Return-Path: <linux-kernel-owner+w=401wt.eu-S1762890AbYAKVv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762890AbYAKVv2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 16:51:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762356AbYAKVu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 16:50:28 -0500
Received: from mail.fieldses.org ([66.93.2.214]:55620 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761289AbYAKVuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 16:50:21 -0500
From: "J. Bruce Fields" <bfields@citi.umich.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "J. Bruce Fields" <bfields@citi.umich.edu>
Subject: [PATCH] Documentation: move dnotify.txt to filesystems/
Date: Fri, 11 Jan 2008 16:50:13 -0500
Message-Id: <1200088216-9211-2-git-send-email-bfields@citi.umich.edu>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1200088216-9211-1-git-send-email-bfields@citi.umich.edu>
References: <1200088216-9211-1-git-send-email-bfields@citi.umich.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm inclined to think dnotify belongs in filesystems/.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
---
 Documentation/00-INDEX                |    2 -
 Documentation/dnotify.txt             |   99 ---------------------------------
 Documentation/filesystems/00-INDEX    |    2 +
 Documentation/filesystems/dnotify.txt |   99 +++++++++++++++++++++++++++++++++
 4 files changed, 101 insertions(+), 101 deletions(-)
 delete mode 100644 Documentation/dnotify.txt
 create mode 100644 Documentation/filesystems/dnotify.txt

diff --git a/Documentation/00-INDEX b/Documentation/00-INDEX
index c3014df..1193939 100644
--- a/Documentation/00-INDEX
+++ b/Documentation/00-INDEX
@@ -126,8 +126,6 @@ devices.txt
 	- plain ASCII listing of all the nodes in /dev/ with major minor #'s.
 digiepca.txt
 	- info on Digi Intl. {PC,PCI,EISA}Xx and Xem series cards.
-dnotify.txt
-	- info about directory notification in Linux.
 dontdiff
 	- file containing a list of files that should never be diff'ed.
 driver-model/
diff --git a/Documentation/dnotify.txt b/Documentation/dnotify.txt
deleted file mode 100644
index 6984fca..0000000
--- a/Documentation/dnotify.txt
+++ /dev/null
@@ -1,99 +0,0 @@
-		Linux Directory Notification
-		============================
-
-	   Stephen Rothwell <sfr@canb.auug.org.au>
-
-The intention of directory notification is to allow user applications
-to be notified when a directory, or any of the files in it, are changed.
-The basic mechanism involves the application registering for notification
-on a directory using a fcntl(2) call and the notifications themselves
-being delivered using signals.
-
-The application decides which "events" it wants to be notified about.
-The currently defined events are:
-
-	DN_ACCESS	A file in the directory was accessed (read)
-	DN_MODIFY	A file in the directory was modified (write,truncate)
-	DN_CREATE	A file was created in the directory
-	DN_DELETE	A file was unlinked from directory
-	DN_RENAME	A file in the directory was renamed
-	DN_ATTRIB	A file in the directory had its attributes
-			changed (chmod,chown)
-
-Usually, the application must reregister after each notification, but
-if DN_MULTISHOT is or'ed with the event mask, then the registration will
-remain until explicitly removed (by registering for no events).
-
-By default, SIGIO will be delivered to the process and no other useful
-information.  However, if the F_SETSIG fcntl(2) call is used to let the
-kernel know which signal to deliver, a siginfo structure will be passed to
-the signal handler and the si_fd member of that structure will contain the
-file descriptor associated with the directory in which the event occurred.
-
-Preferably the application will choose one of the real time signals
-(SIGRTMIN + <n>) so that the notifications may be queued.  This is
-especially important if DN_MULTISHOT is specified.  Note that SIGRTMIN
-is often blocked, so it is better to use (at least) SIGRTMIN + 1.
-
-Implementation expectations (features and bugs :-))
----------------------------
-
-The notification should work for any local access to files even if the
-actual file system is on a remote server.  This implies that remote
-access to files served by local user mode servers should be notified.
-Also, remote accesses to files served by a local kernel NFS server should
-be notified.
-
-In order to make the impact on the file system code as small as possible,
-the problem of hard links to files has been ignored.  So if a file (x)
-exists in two directories (a and b) then a change to the file using the
-name "a/x" should be notified to a program expecting notifications on
-directory "a", but will not be notified to one expecting notifications on
-directory "b".
-
-Also, files that are unlinked, will still cause notifications in the
-last directory that they were linked to.
-
-Configuration
--------------
-
-Dnotify is controlled via the CONFIG_DNOTIFY configuration option.  When
-disabled, fcntl(fd, F_NOTIFY, ...) will return -EINVAL.
-
-Example
--------
-
-	#define _GNU_SOURCE	/* needed to get the defines */
-	#include <fcntl.h>	/* in glibc 2.2 this has the needed
-					   values defined */
-	#include <signal.h>
-	#include <stdio.h>
-	#include <unistd.h>
-	
-	static volatile int event_fd;
-	
-	static void handler(int sig, siginfo_t *si, void *data)
-	{
-		event_fd = si->si_fd;
-	}
-	
-	int main(void)
-	{
-		struct sigaction act;
-		int fd;
-		
-		act.sa_sigaction = handler;
-		sigemptyset(&act.sa_mask);
-		act.sa_flags = SA_SIGINFO;
-		sigaction(SIGRTMIN + 1, &act, NULL);
-		
-		fd = open(".", O_RDONLY);
-		fcntl(fd, F_SETSIG, SIGRTMIN + 1);
-		fcntl(fd, F_NOTIFY, DN_MODIFY|DN_CREATE|DN_MULTISHOT);
-		/* we will now be notified if any of the files
-		   in "." is modified or new files are created */
-		while (1) {
-			pause();
-			printf("Got event on fd=%d\n", event_fd);
-		}
-	}
diff --git a/Documentation/filesystems/00-INDEX b/Documentation/filesystems/00-INDEX
index 1de155e..632fe3f 100644
--- a/Documentation/filesystems/00-INDEX
+++ b/Documentation/filesystems/00-INDEX
@@ -32,6 +32,8 @@ directory-locking
 	- info about the locking scheme used for directory operations.
 dlmfs.txt
 	- info on the userspace interface to the OCFS2 DLM.
+dnotify.txt
+	- info about directory notification in Linux.
 ecryptfs.txt
 	- docs on eCryptfs: stacked cryptographic filesystem for Linux.
 ext2.txt
diff --git a/Documentation/filesystems/dnotify.txt b/Documentation/filesystems/dnotify.txt
new file mode 100644
index 0000000..6984fca
--- /dev/null
+++ b/Documentation/filesystems/dnotify.txt
@@ -0,0 +1,99 @@
+		Linux Directory Notification
+		============================
+
+	   Stephen Rothwell <sfr@canb.auug.org.au>
+
+The intention of directory notification is to allow user applications
+to be notified when a directory, or any of the files in it, are changed.
+The basic mechanism involves the application registering for notification
+on a directory using a fcntl(2) call and the notifications themselves
+being delivered using signals.
+
+The application decides which "events" it wants to be notified about.
+The currently defined events are:
+
+	DN_ACCESS	A file in the directory was accessed (read)
+	DN_MODIFY	A file in the directory was modified (write,truncate)
+	DN_CREATE	A file was created in the directory
+	DN_DELETE	A file was unlinked from directory
+	DN_RENAME	A file in the directory was renamed
+	DN_ATTRIB	A file in the directory had its attributes
+			changed (chmod,chown)
+
+Usually, the application must reregister after each notification, but
+if DN_MULTISHOT is or'ed with the event mask, then the registration will
+remain until explicitly removed (by registering for no events).
+
+By default, SIGIO will be delivered to the process and no other useful
+information.  However, if the F_SETSIG fcntl(2) call is used to let the
+kernel know which signal to deliver, a siginfo structure will be passed to
+the signal handler and the si_fd member of that structure will contain the
+file descriptor associated with the directory in which the event occurred.
+
+Preferably the application will choose one of the real time signals
+(SIGRTMIN + <n>) so that the notifications may be queued.  This is
+especially important if DN_MULTISHOT is specified.  Note that SIGRTMIN
+is often blocked, so it is better to use (at least) SIGRTMIN + 1.
+
+Implementation expectations (features and bugs :-))
+---------------------------
+
+The notification should work for any local access to files even if the
+actual file system is on a remote server.  This implies that remote
+access to files served by local user mode servers should be notified.
+Also, remote accesses to files served by a local kernel NFS server should
+be notified.
+
+In order to make the impact on the file system code as small as possible,
+the problem of hard links to files has been ignored.  So if a file (x)
+exists in two directories (a and b) then a change to the file using the
+name "a/x" should be notified to a program expecting notifications on
+directory "a", but will not be notified to one expecting notifications on
+directory "b".
+
+Also, files that are unlinked, will still cause notifications in the
+last directory that they were linked to.
+
+Configuration
+-------------
+
+Dnotify is controlled via the CONFIG_DNOTIFY configuration option.  When
+disabled, fcntl(fd, F_NOTIFY, ...) will return -EINVAL.
+
+Example
+-------
+
+	#define _GNU_SOURCE	/* needed to get the defines */
+	#include <fcntl.h>	/* in glibc 2.2 this has the needed
+					   values defined */
+	#include <signal.h>
+	#include <stdio.h>
+	#include <unistd.h>
+	
+	static volatile int event_fd;
+	
+	static void handler(int sig, siginfo_t *si, void *data)
+	{
+		event_fd = si->si_fd;
+	}
+	
+	int main(void)
+	{
+		struct sigaction act;
+		int fd;
+		
+		act.sa_sigaction = handler;
+		sigemptyset(&act.sa_mask);
+		act.sa_flags = SA_SIGINFO;
+		sigaction(SIGRTMIN + 1, &act, NULL);
+		
+		fd = open(".", O_RDONLY);
+		fcntl(fd, F_SETSIG, SIGRTMIN + 1);
+		fcntl(fd, F_NOTIFY, DN_MODIFY|DN_CREATE|DN_MULTISHOT);
+		/* we will now be notified if any of the files
+		   in "." is modified or new files are created */
+		while (1) {
+			pause();
+			printf("Got event on fd=%d\n", event_fd);
+		}
+	}
-- 
1.5.4.rc2.60.gb2e62

