Return-Path: <linux-kernel-owner+w=401wt.eu-S1755480AbXLFRIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480AbXLFRIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 12:08:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754239AbXLFRHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 12:07:07 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:32911 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168AbXLFRHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 12:07:03 -0500
Date: Thu, 6 Dec 2007 12:06:42 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 4/6] UML - Miscellaneous code cleanups
Message-ID: <20071206170642.GA7435@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Code tidying -
	the pid field of struct irq_fd isn't used, so it is removed
     	os_set_fd_async needed to read flags before changing them, it
doesn't need a pid passed in because it can call getpid itself, and a
block of unused code needed deleting
	os_get_exec_close was unused, so it is removed
	ptrace_child called _exit for historical reasons which are no
longer valid, so just calls exit instead

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/include/irq_user.h  |    1 -
 arch/um/include/os.h        |    3 +--
 arch/um/kernel/irq.c        |    6 ++----
 arch/um/kernel/ksyms.c      |    1 -
 arch/um/kernel/smp.c        |    6 ++----
 arch/um/os-Linux/file.c     |   38 +++++++++++---------------------------
 arch/um/os-Linux/start_up.c |    3 ++-
 7 files changed, 18 insertions(+), 40 deletions(-)

Index: linux-2.6-git/arch/um/include/irq_user.h
===================================================================
--- linux-2.6-git.orig/arch/um/include/irq_user.h	2007-12-06 10:57:50.000000000 -0500
+++ linux-2.6-git/arch/um/include/irq_user.h	2007-12-06 11:00:55.000000000 -0500
@@ -14,7 +14,6 @@ struct irq_fd {
 	int fd;
 	int type;
 	int irq;
-	int pid;
 	int events;
 	int current_events;
 };
Index: linux-2.6-git/arch/um/kernel/irq.c
===================================================================
--- linux-2.6-git.orig/arch/um/kernel/irq.c	2007-12-06 10:57:50.000000000 -0500
+++ linux-2.6-git/arch/um/kernel/irq.c	2007-12-06 11:00:55.000000000 -0500
@@ -107,10 +107,9 @@ int activate_fd(int irq, int fd, int typ
 	struct pollfd *tmp_pfd;
 	struct irq_fd *new_fd, *irq_fd;
 	unsigned long flags;
-	int pid, events, err, n;
+	int events, err, n;
 
-	pid = os_getpid();
-	err = os_set_fd_async(fd, pid);
+	err = os_set_fd_async(fd);
 	if (err < 0)
 		goto out;
 
@@ -127,7 +126,6 @@ int activate_fd(int irq, int fd, int typ
 				     .fd 		= fd,
 				     .type 		= type,
 				     .irq 		= irq,
-				     .pid  		= pid,
 				     .events 		= events,
 				     .current_events 	= 0 } );
 
Index: linux-2.6-git/arch/um/kernel/smp.c
===================================================================
--- linux-2.6-git.orig/arch/um/kernel/smp.c	2007-12-06 10:57:50.000000000 -0500
+++ linux-2.6-git/arch/um/kernel/smp.c	2007-12-06 11:00:55.000000000 -0500
@@ -74,8 +74,7 @@ static int idle_proc(void *cpup)
 	if (err < 0)
 		panic("CPU#%d failed to create IPI pipe, err = %d", cpu, -err);
 
-	os_set_fd_async(cpu_data[cpu].ipi_pipe[0],
-		     current->thread.mode.tt.extern_pid);
+	os_set_fd_async(cpu_data[cpu].ipi_pipe[0]);
 
 	wmb();
 	if (cpu_test_and_set(cpu, cpu_callin_map)) {
@@ -128,8 +127,7 @@ void smp_prepare_cpus(unsigned int maxcp
 	if (err < 0)
 		panic("CPU#0 failed to create IPI pipe, errno = %d", -err);
 
-	os_set_fd_async(cpu_data[me].ipi_pipe[0],
-		     current->thread.mode.tt.extern_pid);
+	os_set_fd_async(cpu_data[me].ipi_pipe[0]);
 
 	for (cpu = 1; cpu < ncpus; cpu++) {
 		printk(KERN_INFO "Booting processor %d...\n", cpu);
Index: linux-2.6-git/arch/um/os-Linux/file.c
===================================================================
--- linux-2.6-git.orig/arch/um/os-Linux/file.c	2007-12-06 10:57:50.000000000 -0500
+++ linux-2.6-git/arch/um/os-Linux/file.c	2007-12-06 11:04:58.000000000 -0500
@@ -328,19 +328,6 @@ int os_file_modtime(const char *file, un
 	return 0;
 }
 
-int os_get_exec_close(int fd, int *close_on_exec)
-{
-	int ret;
-
-	CATCH_EINTR(ret = fcntl(fd, F_GETFD));
-
-	if(ret < 0)
-		return -errno;
-
-	*close_on_exec = (ret & FD_CLOEXEC) ? 1 : 0;
-	return ret;
-}
-
 int os_set_exec_close(int fd)
 {
 	int err;
@@ -380,30 +367,27 @@ int os_pipe(int *fds, int stream, int cl
 	return err;
 }
 
-int os_set_fd_async(int fd, int owner)
+int os_set_fd_async(int fd)
 {
-	int err;
+	int err, flags;
+
+	flags = fcntl(fd, F_GETFL);
+	if (flags < 0)
+		return -errno;
 
-	/* XXX This should do F_GETFL first */
-	if(fcntl(fd, F_SETFL, O_ASYNC | O_NONBLOCK) < 0){
+	flags |= O_ASYNC | O_NONBLOCK;
+	if (fcntl(fd, F_SETFL, flags) < 0) {
 		err = -errno;
 		printk("os_set_fd_async : failed to set O_ASYNC and "
 		       "O_NONBLOCK on fd # %d, errno = %d\n", fd, errno);
 		return err;
 	}
-#ifdef notdef
-	if(fcntl(fd, F_SETFD, 1) < 0){
-		printk("os_set_fd_async : Setting FD_CLOEXEC failed, "
-		       "errno = %d\n", errno);
-	}
-#endif
 
-	if((fcntl(fd, F_SETSIG, SIGIO) < 0) ||
-	   (fcntl(fd, F_SETOWN, owner) < 0)){
+	if ((fcntl(fd, F_SETSIG, SIGIO) < 0) ||
+	    (fcntl(fd, F_SETOWN, os_getpid()) < 0)) {
 		err = -errno;
 		printk("os_set_fd_async : Failed to fcntl F_SETOWN "
-		       "(or F_SETSIG) fd %d to pid %d, errno = %d\n", fd,
-		       owner, errno);
+		       "(or F_SETSIG) fd %d, errno = %d\n", fd, errno);
 		return err;
 	}
 
Index: linux-2.6-git/arch/um/include/os.h
===================================================================
--- linux-2.6-git.orig/arch/um/include/os.h	2007-12-06 10:57:50.000000000 -0500
+++ linux-2.6-git/arch/um/include/os.h	2007-12-06 11:00:55.000000000 -0500
@@ -127,7 +127,6 @@ static inline struct openflags of_cloexe
 extern int os_stat_file(const char *file_name, struct uml_stat *buf);
 extern int os_stat_fd(const int fd, struct uml_stat *buf);
 extern int os_access(const char *file, int mode);
-extern int os_get_exec_close(int fd, int *close_on_exec);
 extern int os_set_exec_close(int fd);
 extern int os_ioctl_generic(int fd, unsigned int cmd, unsigned long arg);
 extern int os_get_ifname(int fd, char *namebuf);
@@ -142,7 +141,7 @@ extern int os_write_file(int fd, const v
 extern int os_file_size(const char *file, unsigned long long *size_out);
 extern int os_file_modtime(const char *file, unsigned long *modtime);
 extern int os_pipe(int *fd, int stream, int close_on_exec);
-extern int os_set_fd_async(int fd, int owner);
+extern int os_set_fd_async(int fd);
 extern int os_clear_fd_async(int fd);
 extern int os_set_fd_block(int fd, int blocking);
 extern int os_accept_connection(int fd);
Index: linux-2.6-git/arch/um/kernel/ksyms.c
===================================================================
--- linux-2.6-git.orig/arch/um/kernel/ksyms.c	2007-12-06 10:57:50.000000000 -0500
+++ linux-2.6-git/arch/um/kernel/ksyms.c	2007-12-06 11:00:55.000000000 -0500
@@ -36,7 +36,6 @@ EXPORT_SYMBOL(uml_strdup);
 EXPORT_SYMBOL(os_stat_fd);
 EXPORT_SYMBOL(os_stat_file);
 EXPORT_SYMBOL(os_access);
-EXPORT_SYMBOL(os_get_exec_close);
 EXPORT_SYMBOL(os_set_exec_close);
 EXPORT_SYMBOL(os_getpid);
 EXPORT_SYMBOL(os_open_file);
Index: linux-2.6-git/arch/um/os-Linux/start_up.c
===================================================================
--- linux-2.6-git.orig/arch/um/os-Linux/start_up.c	2007-12-06 10:57:50.000000000 -0500
+++ linux-2.6-git/arch/um/os-Linux/start_up.c	2007-12-06 11:00:55.000000000 -0500
@@ -60,7 +60,8 @@ static int ptrace_child(void)
 		 * the UML code itself.
 		 */
 		ret = 2;
-	_exit(ret);
+
+	exit(ret);
 }
 
 static void fatal_perror(const char *str)
