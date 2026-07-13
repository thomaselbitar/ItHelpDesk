CREATE DATABASE ITHelpDesk;
GO

USE ITHelpDesk;
GO

CREATE TABLE Roles(
    Id INT IDENTITY PRIMARY KEY,
    RoleName NVARCHAR(50) NOT NULL UNIQUE,
    Description NVARCHAR(255)
);

CREATE TABLE Users(
    Id INT IDENTITY PRIMARY KEY,
    RoleId INT NOT NULL,
    FirstName NVARCHAR(100),
    LastName NVARCHAR(100),
    Email NVARCHAR(255) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(255) NOT NULL,
    Department NVARCHAR(100),
    PhoneNumber NVARCHAR(30),
    ProfileImage NVARCHAR(255),
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedDate DATETIME2 DEFAULT SYSDATETIME(),
    UpdatedDate DATETIME2,
    CONSTRAINT FK_Users_Roles FOREIGN KEY (RoleId) REFERENCES Roles(Id)
);

CREATE TABLE Categories(
    Id INT IDENTITY PRIMARY KEY,
    CategoryName NVARCHAR(100) UNIQUE,
    Description NVARCHAR(255)
);

CREATE TABLE Priorities(
    Id INT IDENTITY PRIMARY KEY,
    PriorityName NVARCHAR(50) UNIQUE,
    DisplayOrder INT
);

CREATE TABLE Statuses(
    Id INT IDENTITY PRIMARY KEY,
    StatusName NVARCHAR(50) UNIQUE,
    DisplayOrder INT
);

CREATE TABLE Tickets(
    Id INT IDENTITY PRIMARY KEY,
    TicketNumber NVARCHAR(30) UNIQUE,
    CreatedByUserId INT NOT NULL,
    AssignedToUserId INT NULL,
    CategoryId INT NOT NULL,
    PriorityId INT NOT NULL,
    StatusId INT NOT NULL,
    Title NVARCHAR(200) NOT NULL,
    Description NVARCHAR(MAX),
    ResolutionNotes NVARCHAR(MAX),
    CreatedDate DATETIME2 DEFAULT SYSDATETIME(),
    UpdatedDate DATETIME2,
    ClosedDate DATETIME2,

    CONSTRAINT FK_Tickets_CreatedBy FOREIGN KEY (CreatedByUserId) REFERENCES Users(Id),
    CONSTRAINT FK_Tickets_AssignedTo FOREIGN KEY (AssignedToUserId) REFERENCES Users(Id),
    CONSTRAINT FK_Tickets_Category FOREIGN KEY (CategoryId) REFERENCES Categories(Id),
    CONSTRAINT FK_Tickets_Priority FOREIGN KEY (PriorityId) REFERENCES Priorities(Id),
    CONSTRAINT FK_Tickets_Status FOREIGN KEY (StatusId) REFERENCES Statuses(Id)
);

CREATE TABLE TicketComments(
    Id INT IDENTITY PRIMARY KEY,
    TicketId INT NOT NULL,
    UserId INT NOT NULL,
    Comment NVARCHAR(MAX),
    CreatedDate DATETIME2 DEFAULT SYSDATETIME(),

    CONSTRAINT FK_TicketComments_Ticket FOREIGN KEY (TicketId) REFERENCES Tickets(Id),
    CONSTRAINT FK_TicketComments_User FOREIGN KEY (UserId) REFERENCES Users(Id)
);

CREATE TABLE TicketAttachments(
    Id INT IDENTITY PRIMARY KEY,
    TicketId INT NOT NULL,
    UploadedByUserId INT NOT NULL,
    FileName NVARCHAR(255),
    FilePath NVARCHAR(500),
    FileType NVARCHAR(100),
    FileSize BIGINT,
    UploadedDate DATETIME2 DEFAULT SYSDATETIME(),

    CONSTRAINT FK_TicketAttachments_Ticket FOREIGN KEY (TicketId) REFERENCES Tickets(Id),
    CONSTRAINT FK_TicketAttachments_User FOREIGN KEY (UploadedByUserId) REFERENCES Users(Id)
);

CREATE TABLE Notifications(
    Id INT IDENTITY PRIMARY KEY,
    UserId INT NOT NULL,
    Title NVARCHAR(200),
    Message NVARCHAR(MAX),
    IsRead BIT DEFAULT 0,
    CreatedDate DATETIME2 DEFAULT SYSDATETIME(),

    CONSTRAINT FK_Notifications_User FOREIGN KEY (UserId) REFERENCES Users(Id)
);

CREATE TABLE ActivityLogs(
    Id INT IDENTITY PRIMARY KEY,
    TicketId INT NOT NULL,
    UserId INT NOT NULL,
    Action NVARCHAR(100),
    Description NVARCHAR(MAX),
    CreatedDate DATETIME2 DEFAULT SYSDATETIME(),

    CONSTRAINT FK_ActivityLogs_Ticket FOREIGN KEY (TicketId) REFERENCES Tickets(Id),
    CONSTRAINT FK_ActivityLogs_User FOREIGN KEY (UserId) REFERENCES Users(Id)
);

CREATE TABLE AssignmentHistory(
    Id INT IDENTITY PRIMARY KEY,
    TicketId INT NOT NULL,
    AssignedByUserId INT NOT NULL,
    AssignedToUserId INT NOT NULL,
    AssignedDate DATETIME2 DEFAULT SYSDATETIME(),

    CONSTRAINT FK_AssignmentHistory_Ticket FOREIGN KEY (TicketId) REFERENCES Tickets(Id),
    CONSTRAINT FK_AssignmentHistory_AssignedBy FOREIGN KEY (AssignedByUserId) REFERENCES Users(Id),
    CONSTRAINT FK_AssignmentHistory_AssignedTo FOREIGN KEY (AssignedToUserId) REFERENCES Users(Id)
);
