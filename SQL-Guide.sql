/* This is a SQL Guide */

/* Note: this is not intended as a direct replacement for formal instruction/study of SQL. */

/* BACKGROUND INFO AND JUSTIFICATION FOR USING SQL */

/* SQL stands for stuctured query langauge. You can load, extract, and transform data with SQL. 
There are several versions of SQL, like MySQL, PostGRE, SQL server, Oracle SQL, SAP SQL, etc. 
For the most part, all versions are pretty similar but there are some differences in syntax. */

/* There are several types of storage systems used with SQL. 

Flat files are a text file or spreadsheet, have little structure, and 
are not scalable. A common example is a CSV file. Another format is an XML file. Data is stored in
trees and is highly structured, making it somewhat scalable (but it really isn't). Then there's 
relational databases, where data is stored in tables and linked by relationships. This type of 
storage system is highly structured and scalable, and as such is used heavily for large database 
systems. */

/* Knowing SQL and how to work with relational databases will be a big differentiator when 
working in the data science industry. In many cases, data handed to a data scientist is not
yet organized into a database and ready for analysis. Knowing how to work with relational 
databases will allow you to organize otherwise messy data and remotely extract, load, and transform 
data that otherwise would be a mess to work with. 

Relational databases allow for remote access, security management, indexing, and have virtually 
no storage limitation (they're highly scalabale!). 

Like most databases, SQL databases have both primary and foreign keys. A foreign key is a variable
in one database that references a primary key in another database. 
Indexing is all about binary search, which is far faster than searching through a non-indexed 
database such as Excel. Keeping the order (sort) is key, and can be unique or multi-column. 
Order matters when performing multi-column indexing. Primary keys are referenced by other tables, 
are automatically and uniquely indexed, can be automatically indexed, may or may not have a 
meaning (student ID or driver license number), and must be unique and not null. Foreign 
keys are NOT automatically indexed, but you may want to add an index of the variable is to 
be edited frequently. As a reminder, foreign keys are variables that reference a primary key 
in another database. 

There are some constraints when working with primary and foreign keys. The primary key cannot 
be a null value and the foreign key must have a parent with a primary key. Other contraints 
include uniqueness, not null, and check conditions (e.g. check if grade>=0.0, else 
ignore data). */

/* Normalization is important. The process includes the following steps: identify entities,
identify the relationships between those entities, build tables based on those relationships, 
use the parent ket of the 'many' as the foreign key if a one-to-many relationship is found, 
create a seperate table to join any many to many relationships, and (usually) create an (E)ER 
diagram to capture all entities and relationships. 

In an example with first name, last name, height, weight, draft pick, team name, and team city,
the entities are players and teams. The relationship between those entities are many-to-many and 
one-to-one. The one-to-one relationships are between the individual plater and the player info
(height, weight, etc.). We need three tables, one table for teams, one table for players, and 
one table for players on teams. We can introduce to primary keys, one for players and one for teams. */

/* SQL STATEMENTS AND DATA TYPES */

/* Some simple SQL statements include create, alter, select, insert into, update, delete, and drop. 
Some basic data types are datetime/date/time, decimal/numeric(size, decimal places), character 
(string with standard size), and variable character (string with variable length), and 
big integer[-32768,32767]/integer[-2147483648,2147483647]/small integer[-9223372036854475808,9223372036854475807],
and binary data types.  */

/* ACCESSING A DATABASE */

/* When connecting to a database, the connection basically looks like this:
You > Connector/Data Provider > Client Application > Connector (Open Database Connectivity) > Database.
The OBDC usually consists of a client (front-end) and a driver (database-specific). It's often provided 
by a vendor but that is not always the case. Any ODBC will always ask the same information, such as the 
server location (IP address or domain name), database name, user name, and password. 

To connect to the database, you need to use your OBDC. Doing this through the command line in Windows 
looks something like this. */

psql -h machine_name -d database_name -U username --it should prompt you for a password

/* WORKING WITH DATA */

/* Below is an example of how to create a table with several different types of variables. In SQL, 
every variable's data type must declared individually. It is not possible to declare several variables 
and then declare the same data type for all the avriables once. */

create table tablename
(
	variable_1 BIGINT NOT NULL,
	variable_2 VARCHAR(100),
	variable_3 time,
	variable_4 SMALLINT,
	variable_5 INTEGER NOT NULL,
	constraint pk_tablename PRIMARY KEY (variable_1),
	constraint fk_tablename_othertablename FOREIGN KEY (variable_5) REFERENCES table_name(variable_5)
);

/* A working example */
create table PayHistory 
(
	PaymentID BIGINT NOT NULL,
	StudentID BIGINT,
	PayeeFirst VARCHAR(50),
	PayeeLast VARCHAR(50),
	BillAmount NUMERIC(10,5),
	PaidAmount NUMERIC(10,5),
	PostDate date,
	PaidDate date,
	constraint pk_PayHistory PRIMARY KEY (PaymentID)
);
	
/* If you declared an incorrect data type, you can drop the table and recreate it the correct way. */
drop table table_name;

/* When creating multiple tables that involve foreign keys, make sure to create the reference table 
and accompanying variable first before creating your new table. An illustration of this is below. 
Note how admission year is declared as an integer variable and not as a date variable. We don't need 
all the funcitonality of date, so declaring the admission year as a integer is more computationally 
efficient. */

/* create table 1 */

create table Instructors
(
	InstructorID BIGINT NOT NULL,
	FirstName VARCHAR(50),
	LastName VARCHAR(50),
	Title VARCHAR(50),
	constraint pk_InstructorID PRIMARY KEY (InstructorID)
);

/* create table 2 */

create table Courses
(
	CourseID BIGINT NOT NULL,
	Title VARCHAR(100),
	BeginTime time,
	EndTime time,
	DOW SMALLINT,
	InstructorID BIGINT NOT NULL,
	constraint pk_Courses PRIMARY KEY (CourseID),
	constraint fk_Courses_Instructors FOREIGN KEY (InstructorID) REFERENCES Instructors(InstructorID)
);

/* create table 3 */

create table Students
(
	StudentID BIGINT NOT NULL,
	FirstName VARCHAR(50),
	LastName VARCHAR(50),
	Gender CHAR(1),
	StudentAge SMALLINT,
	AdmissionYear SMALLINT,
	constraint pk_Students PRIMARY KEY (StudentID)
);

/* create table 4 */

create table Grades
(
	StudentID BIGINT NOT NULL,
	CourseID BIGINT NOT NULL,
	Grade NUMERIC(2,1),
	constraint fk_Grades_Students FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
	constraint fk_Grades_Courses FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

/* The alter command is really useful, naturally. You can rename columns, add or drop columns, 
or add primary or foreign keys. */

/* rename */
alter table tablename RENAME TO newtablename;

/* add/drop column */
alter table tablename ADD COLUMN columnname varchar(50); --can be other types
alter table tablename DROP COLUMN columnname;

/* add primary key */
alter table tablename
add CONSTRAINT pk_tablename
PRIMARY KEY (variable_name);

/* add foreign key */
alter table tablename
add CONSTRAINT fk_table_othertablename
FOREIGN KEY (variable_name)
REFERENCES tablename(variable_name);

/* Some working examples. */

/* Add a foreign key to the PayHistory table */
alter table PayHistory
add CONSTRAINT fk_PayHistory_Students
FOREIGN KEY (StudentID)
REFERENCES Students(StudentID);

/* Add a new column 'Currnecy' with at most 3 characters, to 'PayHistory' */
alter table PayHistory add COLUMN Currency char(3);

/* Add 3 new columns to the 'Grades' table */
alter table Grades
add COLUMN Satisfaction SMALLINT,
add COLUMN Workload SMALLINT,
add COLUMN Difficulty SMALLINT;

/* To review data in a table, you can use the following code. */
select * from table_name;

/* This is how you can insert into a table and copy from table to table. 
Order matters when inserting and copying data and you should insert all 
new data in one commit, not iteratively, for best perfomance. */

/* single entry */
insert into tablename (columns) VALUES(values);
	
/* based on select */
insert into tablename SELECT ...
	
/* based on data from a file */
copy tablename(columns)
from '<filepath>' 
WITH (options);

/* A working example. */
/* based on data from a file */
copy Instructors
from '<C:/Users/vconstantinou/Desktop/instructors.csv>' 
WITH DELIMITER AS ',' csv HEADER;

/* Ordering data is pretty easy. You can do it like this. */
order by variable_1, variable_2;

/* A working example */
insert into Grades
select distinct
	studentID, CourseID, Grade, Satisfaction, Workload, Difficulty
from AllStudents
where StudentID IS NOT NULL AND CourseID IS NOT NULL
order by StudentID, CourseID;

/* So how do we erase the data in a table? We can use the truncate statement. */
truncate table table_name;

/* Erasing data conditionally. */
delete from table_name where conditions;
	
/* Or across table conditions */	
delete from table_name_1 as alias_1
using table_name_2 as alias_2
where join_condition; --such as P.studentID=S.studentID

/* Select statements allow you to grab data. Below is the general structure. */
select table.column_name or alias.column_name or function(column.name) as alias
from table_name as alias
where conditions
group by variable_1 variable_2
having aggregates
order by variable_1 variable_2 --ascending is the default
limit number_of_records_to_retrieve; --10

/* Working examples. */
/* How many students do we have? */
select count(*) as NumOfStudents
from Students;

/* How many female and male students in 2010? */
select gender, count(distinct StudentID)
	from students where AdmissionYear = 2010
	group by gender
	
/* Another example */
select a.admissionyear, count(studentage) as NumAges
from (
		select distinct admissionyear, studentage
		from students
) as a
group by a.admissionyear
order by a.admissionyear desc;

/* or */

select admissionyear, count(distinct(studentage)) as NumAges
from students
group by admissionyear
order by admissionyear desc;