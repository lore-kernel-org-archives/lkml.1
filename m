Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434Ab0BIA6I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 19:58:08 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:52316 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329Ab0BIA6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 19:58:03 -0500
Date: Mon, 8 Feb 2010 16:56:25 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH 3/4] docum/fs: split txt and source files
Message-Id: <20100208165625.aaa9688f.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4B70B2E2.0099:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Make dnotify_test.c source file and add it to Makefile so that
bitrot can be prevented.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc: Stephen Rothwell <sfr@canb.auug.org.au>
---
 Documentation/Makefile                   |    2 -
 Documentation/filesystems/00-INDEX       |    2 +
 Documentation/filesystems/Makefile       |    8 ++++
 Documentation/filesystems/dnotify.txt    |   39 ++-------------------
 Documentation/filesystems/dnotify_test.c |   34 ++++++++++++++++++
 5 files changed, 50 insertions(+), 35 deletions(-)

--- /dev/null
+++ lnx-2633-rc7/Documentation/filesystems/Makefile
@@ -0,0 +1,8 @@
+# kbuild trick to avoid linker error. Can be omitted if a module is built.
+obj- := dummy.o
+
+# List of programs to build
+hostprogs-y := dnotify_test
+
+# Tell kbuild to always build the programs
+always := $(hostprogs-y)
--- lnx-2633-rc7.orig/Documentation/filesystems/dnotify.txt
+++ lnx-2633-rc7/Documentation/filesystems/dnotify.txt
@@ -62,38 +62,9 @@ disabled, fcntl(fd, F_NOTIFY, ...) will 
 
 Example
 -------
+See Documentation/filesystems/dnotify_test.c for an example.
 
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
+NOTE
+----
+Beginning with Linux 2.6.13, dnotify has been replaced by inotify.
+See Documentation/filesystems/inotify.txt for more information on it.
--- /dev/null
+++ lnx-2633-rc7/Documentation/filesystems/dnotify_test.c
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
--- lnx-2633-rc7.orig/Documentation/filesystems/00-INDEX
+++ lnx-2633-rc7/Documentation/filesystems/00-INDEX
@@ -32,6 +32,8 @@ dlmfs.txt
 	- info on the userspace interface to the OCFS2 DLM.
 dnotify.txt
 	- info about directory notification in Linux.
+dnotify_test.c
+	- example program for dnotify
 ecryptfs.txt
 	- docs on eCryptfs: stacked cryptographic filesystem for Linux.
 exofs.txt
--- lnx-2633-rc7.orig/Documentation/Makefile
+++ lnx-2633-rc7/Documentation/Makefile
@@ -1,3 +1,3 @@
 obj-m := DocBook/ accounting/ auxdisplay/ connector/ \
-	filesystems/configfs/ ia64/ laptops/ networking/ \
+	filesystems/ filesystems/configfs/ ia64/ laptops/ networking/ \
 	pcmcia/ spi/ timers/ video4linux/ vm/ watchdog/src/
