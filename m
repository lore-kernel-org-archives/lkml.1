Return-Path: <linux-kernel-owner+w=401wt.eu-S1756912AbXJ3Ram@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912AbXJ3Ram (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 13:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753697AbXJ3R3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 13:29:39 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:43047 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050AbXJ3R3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 13:29:38 -0400
Date: Tue, 30 Oct 2007 13:28:49 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       WANG Cong <xiyou.wangcong@gmail.com>
Subject: [PATCH 2/4] UML - Code tidying under arch/um/os-Linux
Message-ID: <20071030172849.GA8362@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: WANG Cong <xiyou.wangcong@gmail.com>

This patch contains varied fixes and improvements for some files under
arch/um/os-Linux/, such as a typo fix in a perror message, a missing
argument fix for a printf, some constifying for pointers and so on.

[ jdike - made sigprocmask failure return -errno instead of -1 ]

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/include/os.h        |   12 ++++++------
 arch/um/os-Linux/file.c     |   14 +++++++-------
 arch/um/os-Linux/main.c     |   12 ++++++++----
 arch/um/os-Linux/mem.c      |    5 ++++-
 arch/um/os-Linux/signal.c   |    3 ++-
 arch/um/os-Linux/start_up.c |    2 +-
 6 files changed, 28 insertions(+), 20 deletions(-)

Index: linux-2.6.22/arch/um/include/os.h
===================================================================
--- linux-2.6.22.orig/arch/um/include/os.h	2007-10-29 12:51:14.000000000 -0400
+++ linux-2.6.22/arch/um/include/os.h	2007-10-29 12:56:18.000000000 -0400
@@ -137,24 +137,24 @@ extern int os_set_owner(int fd, int pid)
 extern int os_mode_fd(int fd, int mode);
 
 extern int os_seek_file(int fd, unsigned long long offset);
-extern int os_open_file(char *file, struct openflags flags, int mode);
+extern int os_open_file(const char *file, struct openflags flags, int mode);
 extern int os_read_file(int fd, void *buf, int len);
 extern int os_write_file(int fd, const void *buf, int count);
-extern int os_file_size(char *file, unsigned long long *size_out);
-extern int os_file_modtime(char *file, unsigned long *modtime);
+extern int os_file_size(const char *file, unsigned long long *size_out);
+extern int os_file_modtime(const char *file, unsigned long *modtime);
 extern int os_pipe(int *fd, int stream, int close_on_exec);
 extern int os_set_fd_async(int fd, int owner);
 extern int os_clear_fd_async(int fd);
 extern int os_set_fd_block(int fd, int blocking);
 extern int os_accept_connection(int fd);
-extern int os_create_unix_socket(char *file, int len, int close_on_exec);
+extern int os_create_unix_socket(const char *file, int len, int close_on_exec);
 extern int os_shutdown_socket(int fd, int r, int w);
 extern void os_close_file(int fd);
 extern int os_rcv_fd(int fd, int *helper_pid_out);
 extern int create_unix_socket(char *file, int len, int close_on_exec);
-extern int os_connect_socket(char *name);
+extern int os_connect_socket(const char *name);
 extern int os_file_type(char *file);
-extern int os_file_mode(char *file, struct openflags *mode_out);
+extern int os_file_mode(const char *file, struct openflags *mode_out);
 extern int os_lock_file(int fd, int excl);
 extern void os_flush_stdout(void);
 extern int os_stat_filesystem(char *path, long *bsize_out,
Index: linux-2.6.22/arch/um/os-Linux/file.c
===================================================================
--- linux-2.6.22.orig/arch/um/os-Linux/file.c	2007-10-29 12:51:14.000000000 -0400
+++ linux-2.6.22/arch/um/os-Linux/file.c	2007-10-29 12:56:18.000000000 -0400
@@ -19,7 +19,7 @@
 #include "user.h"
 #include "kern_util.h"
 
-static void copy_stat(struct uml_stat *dst, struct stat64 *src)
+static void copy_stat(struct uml_stat *dst, const struct stat64 *src)
 {
 	*dst = ((struct uml_stat) {
 		.ust_dev     = src->st_dev,     /* device */
@@ -168,7 +168,7 @@ int os_file_type(char *file)
 	else return OS_TYPE_FILE;
 }
 
-int os_file_mode(char *file, struct openflags *mode_out)
+int os_file_mode(const char *file, struct openflags *mode_out)
 {
 	int err;
 
@@ -189,7 +189,7 @@ int os_file_mode(char *file, struct open
 	return err;
 }
 
-int os_open_file(char *file, struct openflags flags, int mode)
+int os_open_file(const char *file, struct openflags flags, int mode)
 {
 	int fd, err, f = 0;
 
@@ -216,7 +216,7 @@ int os_open_file(char *file, struct open
 	return fd;
 }
 
-int os_connect_socket(char *name)
+int os_connect_socket(const char *name)
 {
 	struct sockaddr_un sock;
 	int fd, err;
@@ -277,7 +277,7 @@ int os_write_file(int fd, const void *bu
 	return n;
 }
 
-int os_file_size(char *file, unsigned long long *size_out)
+int os_file_size(const char *file, unsigned long long *size_out)
 {
 	struct uml_stat buf;
 	int err;
@@ -314,7 +314,7 @@ int os_file_size(char *file, unsigned lo
 	return 0;
 }
 
-int os_file_modtime(char *file, unsigned long *modtime)
+int os_file_modtime(const char *file, unsigned long *modtime)
 {
 	struct uml_stat buf;
 	int err;
@@ -515,7 +515,7 @@ int os_rcv_fd(int fd, int *helper_pid_ou
 	return new;
 }
 
-int os_create_unix_socket(char *file, int len, int close_on_exec)
+int os_create_unix_socket(const char *file, int len, int close_on_exec)
 {
 	struct sockaddr_un addr;
 	int sock, err;
Index: linux-2.6.22/arch/um/os-Linux/main.c
===================================================================
--- linux-2.6.22.orig/arch/um/os-Linux/main.c	2007-10-29 12:51:31.000000000 -0400
+++ linux-2.6.22/arch/um/os-Linux/main.c	2007-10-29 12:56:18.000000000 -0400
@@ -73,7 +73,7 @@ static void install_fatal_handler(int si
 	action.sa_handler = last_ditch_exit;
 	if (sigaction(sig, &action, NULL) < 0) {
 		printf("failed to install handler for signal %d - errno = %d\n",
-		       errno);
+		       sig, errno);
 		exit(1);
 	}
 }
@@ -92,7 +92,8 @@ static void setup_env_path(void)
 	 * just use the default + /usr/lib/uml
 	 */
 	if (!old_path || (path_len = strlen(old_path)) == 0) {
-		putenv("PATH=:/bin:/usr/bin/" UML_LIB_PATH);
+		if (putenv("PATH=:/bin:/usr/bin/" UML_LIB_PATH))
+			perror("couldn't putenv");
 		return;
 	}
 
@@ -100,11 +101,14 @@ static void setup_env_path(void)
 	path_len += strlen("PATH=" UML_LIB_PATH) + 1;
 	new_path = malloc(path_len);
 	if (!new_path) {
-		perror("coudn't malloc to set a new PATH");
+		perror("couldn't malloc to set a new PATH");
 		return;
 	}
 	snprintf(new_path, path_len, "PATH=%s" UML_LIB_PATH, old_path);
-	putenv(new_path);
+	if (putenv(new_path)) {
+		perror("couldn't putenv to set a new PATH");
+		free(new_path);
+	}
 }
 
 extern int uml_exitcode;
Index: linux-2.6.22/arch/um/os-Linux/mem.c
===================================================================
--- linux-2.6.22.orig/arch/um/os-Linux/mem.c	2007-10-29 12:51:14.000000000 -0400
+++ linux-2.6.22/arch/um/os-Linux/mem.c	2007-10-29 12:56:18.000000000 -0400
@@ -172,13 +172,15 @@ int __init make_tempfile(const char *tem
 
 	which_tmpdir();
 	tempname = malloc(MAXPATHLEN);
+	if (!tempname)
+		goto out;
 
 	find_tempdir();
 	if (template[0] != '/')
 		strcpy(tempname, tempdir);
 	else
 		tempname[0] = '\0';
-	strcat(tempname, template);
+	strncat(tempname, template, MAXPATHLEN-1-strlen(tempname));
 	fd = mkstemp(tempname);
 	if(fd < 0){
 		fprintf(stderr, "open - cannot create %s: %s\n", tempname,
@@ -268,6 +270,7 @@ void __init check_tmpexec(void)
 	if(addr == MAP_FAILED){
 		err = errno;
 		perror("failed");
+		close(fd);
 		if(err == EPERM)
 			printf("%s must be not mounted noexec\n",tempdir);
 		exit(1);
Index: linux-2.6.22/arch/um/os-Linux/signal.c
===================================================================
--- linux-2.6.22.orig/arch/um/os-Linux/signal.c	2007-10-29 12:51:14.000000000 -0400
+++ linux-2.6.22/arch/um/os-Linux/signal.c	2007-10-29 12:57:14.000000000 -0400
@@ -183,7 +183,8 @@ int change_sig(int signal, int on)
 
 	sigemptyset(&sigset);
 	sigaddset(&sigset, signal);
-	sigprocmask(on ? SIG_UNBLOCK : SIG_BLOCK, &sigset, &old);
+	if (sigprocmask(on ? SIG_UNBLOCK : SIG_BLOCK, &sigset, &old) < 0)
+		return -errno;
 	return !sigismember(&old, signal);
 }
 
Index: linux-2.6.22/arch/um/os-Linux/start_up.c
===================================================================
--- linux-2.6.22.orig/arch/um/os-Linux/start_up.c	2007-10-29 12:51:14.000000000 -0400
+++ linux-2.6.22/arch/um/os-Linux/start_up.c	2007-10-29 12:56:18.000000000 -0400
@@ -63,7 +63,7 @@ static int ptrace_child(void)
 	_exit(ret);
 }
 
-static void fatal_perror(char *str)
+static void fatal_perror(const char *str)
 {
 	perror(str);
 	exit(1);
