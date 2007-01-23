Return-Path: <linux-kernel-owner+w=401wt.eu-S965443AbXAWTfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965443AbXAWTfh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 14:35:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965442AbXAWTfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 14:35:07 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:33096 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965441AbXAWTe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 14:34:58 -0500
Message-Id: <200701231927.l0NJRlEH005363@ccure.user-mode-linux.org>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.0.4
To: akpm@osdl.org
cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Subject: [PATCH 6/7] UML - libc-dependent code should call libc directly
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Tue, 23 Jan 2007 14:27:47 -0500
From: Jeff Dike <jdike@addtoit.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We shouldn't be using the os wrappers from os code - we can use libc
directly.  This patch replaces wrapper calls with libc calls.

It turns out that os_sigio_async had only one caller, which was in
startup.c, so that function is moved there and its name changed.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
--
 arch/um/include/os.h        |    1 -
 arch/um/os-Linux/file.c     |   19 -------------------
 arch/um/os-Linux/start_up.c |   39 ++++++++++++++++++++++++++++-----------
 3 files changed, 28 insertions(+), 31 deletions(-)

Index: linux-2.6.18-mm/arch/um/include/os.h
===================================================================
--- linux-2.6.18-mm.orig/arch/um/include/os.h	2007-01-13 17:29:40.000000000 +1100
+++ linux-2.6.18-mm/arch/um/include/os.h	2007-01-14 10:50:06.000000000 +1100
@@ -137,7 +137,6 @@ extern int os_new_tty_pgrp(int fd, int p
 extern int os_get_ifname(int fd, char *namebuf);
 extern int os_set_slip(int fd);
 extern int os_set_owner(int fd, int pid);
-extern int os_sigio_async(int master, int slave);
 extern int os_mode_fd(int fd, int mode);
 
 extern int os_seek_file(int fd, __u64 offset);
Index: linux-2.6.18-mm/arch/um/os-Linux/file.c
===================================================================
--- linux-2.6.18-mm.orig/arch/um/os-Linux/file.c	2007-01-13 17:28:41.000000000 +1100
+++ linux-2.6.18-mm/arch/um/os-Linux/file.c	2007-01-14 10:50:06.000000000 +1100
@@ -162,25 +162,6 @@ int os_set_owner(int fd, int pid)
 	return 0;
 }
 
-/* FIXME? moved wholesale from sigio_user.c to get fcntls out of that file */
-int os_sigio_async(int master, int slave)
-{
-	int flags;
-
-	flags = fcntl(master, F_GETFL);
-	if(flags < 0)
-		return -errno;
-
-	if((fcntl(master, F_SETFL, flags | O_NONBLOCK | O_ASYNC) < 0) ||
-	   (fcntl(master, F_SETOWN, os_getpid()) < 0))
-		return -errno;
-
-	if((fcntl(slave, F_SETFL, flags | O_NONBLOCK) < 0))
-		return -errno;
-
-	return(0);
-}
-
 int os_mode_fd(int fd, int mode)
 {
 	int err;
Index: linux-2.6.18-mm/arch/um/os-Linux/start_up.c
===================================================================
--- linux-2.6.18-mm.orig/arch/um/os-Linux/start_up.c	2007-01-13 18:00:47.000000000 +1100
+++ linux-2.6.18-mm/arch/um/os-Linux/start_up.c	2007-01-14 10:50:14.000000000 +1100
@@ -54,7 +54,7 @@ static int ptrace_child(void *arg)
 		perror("ptrace");
 		os_kill_process(pid, 0);
 	}
-	os_stop_process(pid);
+	kill(pid, SIGSTOP);
 
 	/*This syscall will be intercepted by the parent. Don't call more than
 	 * once, please.*/
@@ -417,7 +417,7 @@ static inline void check_skas3_ptrace_ld
 static inline void check_skas3_proc_mm(void)
 {
 	printf("  - /proc/mm...");
-	if (os_access("/proc/mm", OS_ACC_W_OK) < 0) {
+	if (access("/proc/mm", W_OK) < 0) {
 		proc_mm = 0;
 		printf("not found\n");
 	}
@@ -452,9 +452,9 @@ int can_do_skas(void)
 int __init parse_iomem(char *str, int *add)
 {
 	struct iomem_region *new;
-	struct uml_stat buf;
+	struct stat64 buf;
 	char *file, *driver;
-	int fd, err, size;
+	int fd, size;
 
 	driver = str;
 	file = strchr(str,',');
@@ -464,15 +464,14 @@ int __init parse_iomem(char *str, int *a
 	}
 	*file = '\0';
 	file++;
-	fd = os_open_file(file, of_rdwr(OPENFLAGS()), 0);
+	fd = open(file, O_RDWR, 0);
 	if(fd < 0){
 		os_print_error(fd, "parse_iomem - Couldn't open io file");
 		goto out;
 	}
 
-	err = os_stat_fd(fd, &buf);
-	if(err < 0){
-		os_print_error(err, "parse_iomem - cannot stat_fd file");
+	if(fstat64(fd, &buf) < 0){
+		perror("parse_iomem - cannot stat_fd file");
 		goto out_close;
 	}
 
@@ -482,7 +481,7 @@ int __init parse_iomem(char *str, int *a
 		goto out_close;
 	}
 
-	size = (buf.ust_size + UM_KERN_PAGE_SIZE) & ~(UM_KERN_PAGE_SIZE - 1);
+	size = (buf.st_size + UM_KERN_PAGE_SIZE) & ~(UM_KERN_PAGE_SIZE - 1);
 
 	*new = ((struct iomem_region) { .next		= iomem_regions,
 					.driver		= driver,
@@ -495,7 +494,7 @@ int __init parse_iomem(char *str, int *a
 
 	return 0;
  out_close:
-	os_close_file(fd);
+	close(fd);
  out:
 	return 1;
 }
@@ -528,6 +527,24 @@ static void openpty_cb(void *arg)
 		info->err = -errno;
 }
 
+static int async_pty(int master, int slave)
+{
+	int flags;
+
+	flags = fcntl(master, F_GETFL);
+	if(flags < 0)
+		return -errno;
+
+	if((fcntl(master, F_SETFL, flags | O_NONBLOCK | O_ASYNC) < 0) ||
+	   (fcntl(master, F_SETOWN, os_getpid()) < 0))
+		return -errno;
+
+	if((fcntl(slave, F_SETFL, flags | O_NONBLOCK) < 0))
+		return -errno;
+
+	return(0);
+}
+
 static void __init check_one_sigio(void (*proc)(int, int))
 {
 	struct sigaction old, new;
@@ -553,7 +570,7 @@ static void __init check_one_sigio(void 
 	if (err < 0)
 		panic("check_sigio : __raw failed, errno = %d\n", -err);
 
-	err = os_sigio_async(master, slave);
+	err = async_pty(master, slave);
 	if(err < 0)
 		panic("tty_fds : sigio_async failed, err = %d\n", -err);
 

