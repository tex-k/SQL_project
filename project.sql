/*База данных содержит информацию о студентах, преподавателях, кафедрах и читаемых курсах.
Она позволяет просматривать наличие зачётов студентов, а также атоматически выставляет
зачёт студенту по предмету, если у него сданы все формы, составляющие этот предмет.*/

DROP DATABASE IF EXISTS project;
CREATE DATABASE project;

USE project;

/*Таблица содержит список кафедр*/
DROP TABLE IF EXISTS departments;
CREATE TABLE departments(
	id SERIAL,
	name VARCHAR(30),
	PRIMARY KEY (id)
);

/*Таблица содержит список студентов*/
DROP TABLE IF EXISTS students;
CREATE TABLE students(
	id SERIAL,
	first_name VARCHAR(20),
	last_name VARCHAR(20),
	department_id BIGINT UNSIGNED NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (department_id) REFERENCES departments(id),
	INDEX (last_name)
);

/*Таблица содержит список преподавателей*/
DROP TABLE IF EXISTS teachers;
CREATE TABLE teachers(
	id SERIAL,
	first_name VARCHAR(30),
	last_name VARCHAR(30),
	department_id BIGINT UNSIGNED NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (department_id) REFERENCES departments(id),
	INDEX (last_name)
);

/*Таблица содержит список курсов*/
DROP TABLE IF EXISTS lessons;
CREATE TABLE lessons(
	id SERIAL,
	name VARCHAR(30),
	PRIMARY KEY (id)
);

/*Таблица содержит связи между студентами и курсами*/
DROP TABLE IF EXISTS students_lessons;
CREATE TABLE students_lessons(
	id SERIAL,
	student_id BIGINT UNSIGNED NOT NULL,
	lesson_id BIGINT UNSIGNED NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (student_id) REFERENCES students(id),
	FOREIGN KEY (lesson_id) REFERENCES lessons(id)
);

/*Таблица содержит формы преподавания, составляющие курс*/
DROP TABLE IF EXISTS forms_of_lessons;
CREATE TABLE forms_of_lessons(
	id SERIAL,
	name VARCHAR(20),
	PRIMARY KEY (id)
);

/*Таблица содержит связи между преподавателями и курсами*/
DROP TABLE IF EXISTS teachers_lessons;
CREATE TABLE teachers_lessons(
	id SERIAL,
	teacher_id BIGINT UNSIGNED NOT NULL,
	lesson_id BIGINT UNSIGNED NOT NULL,
	form_id BIGINT UNSIGNED NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (teacher_id) REFERENCES teachers(id),
	FOREIGN KEY (lesson_id) REFERENCES lessons(id)
	#FOREIGN KEY (form_id) REFERENCES forms_of_lessons(id)
);

/*Таблица содержит связи между курсами и формами преподавания*/
DROP TABLE IF EXISTS lessons_forms_of_lessons;
CREATE TABLE lessons_forms_of_lessons(
	id SERIAL,
	lesson_id BIGINT UNSIGNED NOT NULL,
	form_id BIGINT UNSIGNED NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (lesson_id) REFERENCES lessons(id),
	FOREIGN KEY (form_id) REFERENCES forms_of_lessons(id)
);

/*Таблица содержит сведения о зачётах студентов по отдельным формам преподавания для каждого курса*/
DROP TABLE IF EXISTS credits;
CREATE TABLE credits(
	id SERIAL,
	student_id BIGINT UNSIGNED,
	lesson_id BIGINT UNSIGNED,
	form_id BIGINT UNSIGNED,
	credit BOOLEAN DEFAULT FALSE,
	PRIMARY KEY (id),
	FOREIGN KEY (student_id) REFERENCES students(id),
	FOREIGN KEY (lesson_id) REFERENCES lessons(id),
	FOREIGN KEY (form_id) REFERENCES forms_of_lessons(id)
);

/*Таблица содержит сведения об итоговых зачётах студентов по каждому предмету*/
DROP TABLE IF EXISTS final_credit;
CREATE TABLE final_credit(
	id SERIAL,
	student_id BIGINT UNSIGNED,
	lesson_id BIGINT UNSIGNED,
	credit BOOLEAN DEFAULT FALSE,
	PRIMARY KEY (id),
	FOREIGN KEY (student_id) REFERENCES students(id),
	FOREIGN KEY (lesson_id) REFERENCES lessons(id)
);

INSERT INTO departments (name)
VALUES
("Теоретической физики"),
("Физики космоса"),
("Физики твёрдого тела"),
("Общей физики"),
("Радиофизики"),
("Математики");

INSERT INTO students (first_name, last_name, department_id) 
VALUES 
("Юрий", "Внуков", 5),
("Павел", "Иванов", 5),
("Степан", "Малахов", 1),
("Евгений", "Кучеренко", 5),
("Александр", "Голощапов", 5),
("Александра", "Карташева", 1),
("Дмитрий", "Власенко", 1),
("Антон", "Слотин", 2),
("Давид", "Давтян", 1),
("Татьяна", "Землянухина", 3);

INSERT INTO teachers (first_name, last_name, department_id)
VALUES
("Григорий Моисеевич", "Верешков", 1),
("Лусеген Арменакович", "Бугаев", 3),
("Александр Соломонович", "Богатин", 4),
("Леонид Рубенович", "Кечек", 5),
("Ирина Александровна", "Потапова", 2),
("Валерий Владимирович", "Алексеев", 6),
("Галина Викторовна", "Костецкая", 6);

INSERT INTO lessons (name)
VALUES
("Квантовая теория поля"),
("Электричество и магнетизм"),
("Математический анализ"),
("Дифференциальные уравнения"),
("Основы радиоэлектроники"),
("Теория рассеяния"),
("Физика космоса"),
("Квантовая механика");

INSERT INTO students_lessons (student_id, lesson_id)
VALUES
(1, 5),
(1, 2),
(1, 3),
(2, 5),
(2, 2),
(2, 3),
(4, 5),
(4, 2),
(4, 3),
(5, 5),
(5, 2),
(5, 3),
(3, 6),
(3, 8),
(3, 4),
(6, 6),
(6, 8),
(6, 4),
(7, 1),
(7, 8),
(7, 4),
(9, 6),
(9, 8),
(9, 4),
(8, 8),
(8, 7),
(8, 3),
(10, 3),
(10, 8),
(10, 6);

INSERT INTO teachers_lessons (teacher_id, lesson_id, form_id)
VALUES
(1, 1, 4),
(1, 8, 2),
(2, 6, 1),
(2, 8, 1),
(3, 2, 1),
(3, 2, 2),
(3, 2, 3),
(4, 5, 1),
(4, 5, 2),
(4, 5, 3),
(5, 7, 1),
(6, 3, 2),
(6, 4, 1),
(7, 4, 2),
(7, 3, 1);

INSERT INTO forms_of_lessons (name)
VALUES
("лекция"),
("семинар"),
("практикум"),
("электив");

INSERT INTO lessons_forms_of_lessons (lesson_id, form_id)
VALUES
(1, 4),
(2, 1),
(2, 2),
(2, 3),
(3, 1),
(3, 2),
(4, 1),
(4, 2),
(5, 1),
(5, 2),
(5, 3),
(6, 1),
(7, 1),
(8, 1),
(8, 2);

/*В эту таблицу вставляются данные из предыдущих таблиц. Поле зачёт по умолчанию 0*/
INSERT INTO credits (student_id, lesson_id, form_id)
SELECT students_lessons.student_id, students_lessons.lesson_id, lessons_forms_of_lessons.form_id
FROM students_lessons
JOIN lessons_forms_of_lessons ON lessons_forms_of_lessons.lesson_id = students_lessons.lesson_id;

/*В эту таблицу вставляются данные из предыдущих таблиц. Поле зачёт по умолчанию 0*/
INSERT INTO final_credit (student_id, lesson_id)
SELECT students_lessons.student_id, students_lessons.lesson_id
FROM students_lessons
JOIN lessons_forms_of_lessons ON lessons_forms_of_lessons.lesson_id = students_lessons.lesson_id
GROUP BY students_lessons.student_id, students_lessons.lesson_id;

/*Триггер реагирует на проставление зачёта студенту по одной из форм преподавания предмета
и пересчитывает наличие или отсутствие итогового зачёта по предмету путём сложения зачётов
каждой формы и целочисленного деления на количество форм для этого предмета.*/
DROP TRIGGER IF EXISTS make_credit;
DELIMITER //
CREATE TRIGGER make_credit AFTER UPDATE ON credits
FOR EACH ROW
BEGIN
	SET @cnt = (
		SELECT COUNT(*) FROM credits WHERE credits.student_id = NEW.student_id AND credits.lesson_id = NEW.lesson_id
	);
	SET @n = (
		SELECT ROUND(SUM(credits.credit)) FROM credits WHERE credits.student_id = NEW.student_id AND credits.lesson_id = NEW.lesson_id
	) DIV @cnt;
	UPDATE final_credit SET credit = @n WHERE final_credit.student_id = NEW.student_id AND final_credit.lesson_id = NEW.lesson_id;
	SET @cnt = NULL;
	SET @n = NULL;
END//
DELIMITER ;

/*Представление собирает информацию о зачётах студентов по отдельным формам преподавания для каждого предмета*/
CREATE VIEW preliminary_results AS SELECT CONCAT(students.last_name, " ", students.first_name) AS "Студенты",
lessons.name AS "Курс",
forms_of_lessons.name AS "Форма",
credits.credit AS "Зачёт"
FROM credits
JOIN students ON students.id = credits.student_id
JOIN lessons ON lessons.id = credits.lesson_id
JOIN forms_of_lessons ON forms_of_lessons.id = credits.form_id
ORDER BY students.last_name, lessons.name;

/*Представление собирает информацию об итоговых зачётах студентов по каждому предмету*/
CREATE VIEW results AS SELECT CONCAT(students.last_name, " ", students.first_name) AS "Студенты",
lessons.name AS "Курс",
final_credit.credit AS "Зачёт"
FROM final_credit
JOIN students ON students.id = final_credit.student_id
JOIN lessons ON lessons.id = final_credit.lesson_id
ORDER BY students.last_name, lessons.name;

/*Несколько характерных выборок*/

SELECT lessons.name AS "Курс", forms_of_lessons.name AS "Форма"
FROM lessons_forms_of_lessons
JOIN lessons ON lessons.id = lessons_forms_of_lessons.lesson_id
JOIN forms_of_lessons ON forms_of_lessons.id = lessons_forms_of_lessons.form_id
ORDER BY lessons.name;

SELECT CONCAT(students.last_name, " ", students.first_name) AS "Студенты", lessons.name AS "Курсы"
FROM students_lessons
JOIN students ON students.id = students_lessons.student_id
JOIN lessons ON lessons.id = students_lessons.lesson_id
ORDER BY students.last_name;

SELECT teachers_lessons.id, 
CONCAT(teachers.last_name, " ", teachers.first_name) AS "Преподаватель", 
lessons.name AS "Курс", forms_of_lessons.name AS "Форма"
FROM teachers_lessons
JOIN teachers ON teachers.id = teachers_lessons.teacher_id
JOIN lessons ON lessons.id = teachers_lessons.lesson_id
JOIN forms_of_lessons ON forms_of_lessons.id = teachers_lessons.form_id
ORDER BY teachers_lessons.id;

/*Зачёты студентов до изменений*/
SELECT * FROM preliminary_results;
SELECT * FROM results;

UPDATE credits SET credit = TRUE WHERE student_id = 7 AND lesson_id = 4 AND form_id = 2;
UPDATE credits SET credit = TRUE WHERE student_id = 1 AND lesson_id = 5 AND form_id = 1;
UPDATE credits SET credit = TRUE WHERE student_id = 1 AND lesson_id = 5 AND form_id = 2;
UPDATE credits SET credit = TRUE WHERE student_id = 1 AND lesson_id = 5 AND form_id = 3;
UPDATE credits SET credit = TRUE WHERE student_id = 1 AND lesson_id = 2 AND form_id = 1;
UPDATE credits SET credit = TRUE WHERE student_id = 1 AND lesson_id = 2 AND form_id = 2;

/*Зачёты студентов после изменений*/
SELECT * FROM preliminary_results;
SELECT * FROM results;


