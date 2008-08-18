Return-Path: <linux-kernel-owner+w=401wt.eu-S1751502AbYHREpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502AbYHREpQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 00:45:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751940AbYHREo6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 00:44:58 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:14036 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199AbYHREo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 00:44:57 -0400
Date: Sun, 17 Aug 2008 21:44:56 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, sfr@canb.auug.org.au
Subject: [PATCH 2/2] documentation: split and build dnotify_test program
Message-Id: <20080817214456.e8c765fa.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Make dnotify_test.c source file and add it to Makefile so that
bitrot can be prevented.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc: Stephen Rothwell <sfr@canb.auug.org.au>
---
 Documentation/filesystems/00-INDEX       |    2 +
 Documentation/filesystems/Makefile       |    2 -
 Documentation/filesystems/dnotify.txt    |   36 -------------------------------
 Documentation/filesystems/dnotify_test.c |   34 +++++++++++++++++++++++++++++
 4 files changed, 38 insertions(+), 36 deletions(-)

--- lin2627-rc3g4-kerndoc.orig/Documentation/filesystems/Makefile
+++ lin2627-rc3g4-kerndoc/Documentation/filesystems/Makefile
@@ -2,7 +2,7 @@
 obj- := dummy.o
 
 # List of programs to build
-hostprogs-y := smount
+hostprogs-y := smount dnotify_test
 
 # Tell kbuild to always build the programs
 always := $(hostprogs-y)
--- lin2627-rc3g4-kerndoc.orig/Documentation/filesystems/dnotify.txt
+++ lin2627-rc3g4-kerndoc/Documentation/filesystems/dnotify.txt
@@ -62,38 +62,4 @@ disabled, fcntl(fd, F_NOTIFY, ...) will 
 
 Example
 -------
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
+See Documentation/filesystems/dnotify_test.c for an example.
--- /dev/null
+++ lin2627-rc3g4-kerndoc/Documentation/filesystems/dnotify_test.c
@@ -0,0 +1,34 @@
+#define _GNU_SOURCE	/* needed to get the defines */
+#include <fcntl.h>	/* in glibc 2.2 this has the needed
+				   values defined */
+#include <signal.h>
+#include <stdio.h>
+#include <unistd.h>
+
+static volatile int event_fd;
+
+static void handler(int sig, siginfo_t *si, void *data)
+{
+	event_fd = si->si_fd;
+}
+
+int main(void)
+{
+	struct sigaction act;
+	int fd;
+
+	act.sa_sigaction = handler;
+	sigemptyset(&act.sa_mask);
+	act.sa_flags = SA_SIGINFO;
+	sigaction(SIGRTMIN + 1, &act, NULL);
+
+	fd = open(".", O_RDONLY);
+	fcntl(fd, F_SETSIG, SIGRTMIN + 1);
+	fcntl(fd, F_NOTIFY, DN_MODIFY|DN_CREATE|DN_MULTISHOT);
+	/* we will now be notified if any of the files
+	   in "." is modified or new files are created */
+	while (1) {
+		pause();
+		printf("Got event on fd=%d\n", event_fd);
+	}
+}
--- lin2627-rc3g4-kerndoc.orig/Documentation/filesystems/00-INDEX
+++ lin2627-rc3g4-kerndoc/Documentation/filesystems/00-INDEX
@@ -34,6 +34,8 @@ dlmfs.txt
 	- info on the userspace interface to the OCFS2 DLM.
 dnotify.txt
 	- info about directory notification in Linux.
+dnotify_test.c
+	- example program for dnotify
 ecryptfs.txt
 	- docs on eCryptfs: stacked cryptographic filesystem for Linux.
 ext2.txt


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
