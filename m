Return-Path: <linux-kernel-owner+w=401wt.eu-S1755757AbXLKRCE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757AbXLKRCE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 12:02:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbXLKRBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 12:01:52 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:32956 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713AbXLKRBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 12:01:50 -0500
Date: Tue, 11 Dec 2007 12:01:24 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH 1/2] UML - Stop gdb from deleting breakpoints when running UML
Message-ID: <20071211170124.GA6584@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ This should go into 2.6.24.  It applies ahead of my other -mm
patches and it conflicts with
uml-kill-processes-instead-of-panicing-kernel.patch.  So, I'm also
sending an updated version of that patch which merges cleanly with
this one already applied. ]

From: Stanislaw Gruszka <stf_xl@wp.pl>

Sometimes when UML is debugged gdb miss breakpoints.

When process traced by gdb do fork, debugger remove breakpoints from
child address space. There is possibility to trace more than one fork,
but this not work with UML, I guess (only guess) there is a deadlock -
gdb waits for UML and UML waits for gdb.

When clone() is called with SIGCHLD and CLONE_VM flags, gdb see this
as PTRACE_EVENT_FORK not as PTRACE_EVENT_CLONE and remove breakpoints
from child and at the same time from traced process, because either
have the same address space.

Maybe it is possible to do fix in gdb, but I'm not sure if there is
easy way to find out if traced and child processes share memory. So I
do fix for UML, it simply do not call clone() with both SIGCHLD and
CLONE_VM flags together.  Additionally __WALL flag is used for
waitpid() to assure not miss clone and normal process events.

[ jdike - checkpatch fixes ]

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/drivers/net_user.c               |    2 -
 arch/um/drivers/slip_user.c              |   12 +--------
 arch/um/drivers/slirp_user.c             |   15 ++----------
 arch/um/drivers/ubd_user.c               |    3 --
 arch/um/include/os.h                     |    2 -
 arch/um/os-Linux/aio.c                   |    4 +--
 arch/um/os-Linux/drivers/ethertap_user.c |   10 +-------
 arch/um/os-Linux/drivers/tuntap_user.c   |    2 -
 arch/um/os-Linux/helper.c                |   38 ++++++++++++++++++++++---------
 arch/um/os-Linux/process.c               |    4 +--
 arch/um/os-Linux/skas/process.c          |   12 +++++----
 arch/um/os-Linux/util.c                  |    2 -
 12 files changed, 50 insertions(+), 56 deletions(-)

Index: linux-2.6-git/arch/um/drivers/net_user.c
===================================================================
--- linux-2.6-git.orig/arch/um/drivers/net_user.c	2007-12-11 11:48:08.000000000 -0500
+++ linux-2.6-git/arch/um/drivers/net_user.c	2007-12-11 11:49:03.000000000 -0500
@@ -201,7 +201,7 @@ static int change_tramp(char **argv, cha
 	close(fds[1]);
 
 	if (pid > 0)
-		CATCH_EINTR(err = waitpid(pid, NULL, 0));
+		helper_wait(pid, 0, "change_tramp");
 	return pid;
 }
 
Index: linux-2.6-git/arch/um/drivers/slip_user.c
===================================================================
--- linux-2.6-git.orig/arch/um/drivers/slip_user.c	2007-12-11 11:48:08.000000000 -0500
+++ linux-2.6-git/arch/um/drivers/slip_user.c	2007-12-11 11:49:03.000000000 -0500
@@ -77,7 +77,7 @@ static int slip_tramp(char **argv, int f
 {
 	struct slip_pre_exec_data pe_data;
 	char *output;
-	int status, pid, fds[2], err, output_len;
+	int pid, fds[2], err, output_len;
 
 	err = os_pipe(fds, 1, 0);
 	if (err < 0) {
@@ -109,15 +109,7 @@ static int slip_tramp(char **argv, int f
 	read_output(fds[0], output, output_len);
 	printk("%s", output);
 
-	CATCH_EINTR(err = waitpid(pid, &status, 0));
-	if (err < 0)
-		err = errno;
-	else if (!WIFEXITED(status) || (WEXITSTATUS(status) != 0)) {
-		printk(UM_KERN_ERR "'%s' didn't exit with status 0\n", argv[0]);
-		err = -EINVAL;
-	}
-	else err = 0;
-
+	err = helper_wait(pid, 0, argv[0]);
 	close(fds[0]);
 
 out_free:
Index: linux-2.6-git/arch/um/drivers/slirp_user.c
===================================================================
--- linux-2.6-git.orig/arch/um/drivers/slirp_user.c	2007-12-11 11:48:08.000000000 -0500
+++ linux-2.6-git/arch/um/drivers/slirp_user.c	2007-12-11 11:49:03.000000000 -0500
@@ -79,7 +79,7 @@ out:
 static void slirp_close(int fd, void *data)
 {
 	struct slirp_data *pri = data;
-	int status,err;
+	int err;
 
 	close(fd);
 	close(pri->slave);
@@ -98,18 +98,9 @@ static void slirp_close(int fd, void *da
 		       "(%d)\n", pri->pid, errno);
 	}
 #endif
-
-	CATCH_EINTR(err = waitpid(pri->pid, &status, WNOHANG));
-	if (err < 0) {
-		printk(UM_KERN_ERR "slirp_close: waitpid returned %d\n", errno);
+	err = helper_wait(pri->pid, 1, "slirp_close");
+	if (err < 0)
 		return;
-	}
-
-	if (err == 0) {
-		printk(UM_KERN_ERR "slirp_close: process %d has not exited\n",
-		       pri->pid);
-		return;
-	}
 
 	pri->pid = -1;
 }
Index: linux-2.6-git/arch/um/drivers/ubd_user.c
===================================================================
--- linux-2.6-git.orig/arch/um/drivers/ubd_user.c	2007-12-11 11:48:08.000000000 -0500
+++ linux-2.6-git/arch/um/drivers/ubd_user.c	2007-12-11 11:49:03.000000000 -0500
@@ -49,8 +49,7 @@ int start_io_thread(unsigned long sp, in
 		goto out_close;
 	}
 
-	pid = clone(io_thread, (void *) sp, CLONE_FILES | CLONE_VM | SIGCHLD,
-		    NULL);
+	pid = clone(io_thread, (void *) sp, CLONE_FILES | CLONE_VM, NULL);
 	if(pid < 0){
 		err = -errno;
 		printk("start_io_thread - clone failed : errno = %d\n", errno);
Index: linux-2.6-git/arch/um/os-Linux/aio.c
===================================================================
--- linux-2.6-git.orig/arch/um/os-Linux/aio.c	2007-12-11 11:48:08.000000000 -0500
+++ linux-2.6-git/arch/um/os-Linux/aio.c	2007-12-11 11:49:03.000000000 -0500
@@ -218,7 +218,7 @@ static int init_aio_24(void)
 		goto out_close_pipe;
 
 	err = run_helper_thread(not_aio_thread, NULL,
-				CLONE_FILES | CLONE_VM | SIGCHLD, &aio_stack);
+				CLONE_FILES | CLONE_VM, &aio_stack);
 	if (err < 0)
 		goto out_close_pipe;
 
@@ -254,7 +254,7 @@ static int init_aio_26(void)
 	}
 
 	err = run_helper_thread(aio_thread, NULL,
-				CLONE_FILES | CLONE_VM | SIGCHLD, &aio_stack);
+				CLONE_FILES | CLONE_VM, &aio_stack);
 	if (err < 0)
 		return err;
 
Index: linux-2.6-git/arch/um/os-Linux/drivers/ethertap_user.c
===================================================================
--- linux-2.6-git.orig/arch/um/os-Linux/drivers/ethertap_user.c	2007-12-11 11:48:08.000000000 -0500
+++ linux-2.6-git/arch/um/os-Linux/drivers/ethertap_user.c	2007-12-11 11:49:03.000000000 -0500
@@ -94,7 +94,7 @@ static int etap_tramp(char *dev, char *g
 		      int control_remote, int data_me, int data_remote)
 {
 	struct etap_pre_exec_data pe_data;
-	int pid, status, err, n;
+	int pid, err, n;
 	char version_buf[sizeof("nnnnn\0")];
 	char data_fd_buf[sizeof("nnnnnn\0")];
 	char gate_buf[sizeof("nnn.nnn.nnn.nnn\0")];
@@ -131,13 +131,7 @@ static int etap_tramp(char *dev, char *g
 	}
 	if (c != 1) {
 		printk(UM_KERN_ERR "etap_tramp : uml_net failed\n");
-		err = -EINVAL;
-		CATCH_EINTR(n = waitpid(pid, &status, 0));
-		if (n < 0)
-			err = -errno;
-		else if (!WIFEXITED(status) || (WEXITSTATUS(status) != 1))
-			printk(UM_KERN_ERR "uml_net didn't exit with "
-			       "status 1\n");
+		err = helper_wait(pid, 0, "uml_net");
 	}
 	return err;
 }
Index: linux-2.6-git/arch/um/os-Linux/drivers/tuntap_user.c
===================================================================
--- linux-2.6-git.orig/arch/um/os-Linux/drivers/tuntap_user.c	2007-12-11 11:48:08.000000000 -0500
+++ linux-2.6-git/arch/um/os-Linux/drivers/tuntap_user.c	2007-12-11 11:49:03.000000000 -0500
@@ -107,7 +107,7 @@ static int tuntap_open_tramp(char *gate,
 		       "errno = %d\n", errno);
 		return err;
 	}
-	CATCH_EINTR(waitpid(pid, NULL, 0));
+	helper_wait(pid, 0, "tuntap_open_tramp");
 
 	cmsg = CMSG_FIRSTHDR(&msg);
 	if (cmsg == NULL) {
Index: linux-2.6-git/arch/um/os-Linux/helper.c
===================================================================
--- linux-2.6-git.orig/arch/um/os-Linux/helper.c	2007-12-11 11:48:08.000000000 -0500
+++ linux-2.6-git/arch/um/os-Linux/helper.c	2007-12-11 11:50:31.000000000 -0500
@@ -76,7 +76,7 @@ int run_helper(void (*pre_exec)(void *),
 	data.fd = fds[1];
 	data.buf = __cant_sleep() ? kmalloc(PATH_MAX, UM_GFP_ATOMIC) :
 					kmalloc(PATH_MAX, UM_GFP_KERNEL);
-	pid = clone(helper_child, (void *) sp, CLONE_VM | SIGCHLD, &data);
+	pid = clone(helper_child, (void *) sp, CLONE_VM, &data);
 	if (pid < 0) {
 		ret = -errno;
 		printk("run_helper : clone failed, errno = %d\n", errno);
@@ -101,7 +101,7 @@ int run_helper(void (*pre_exec)(void *),
 			ret = n;
 			kill(pid, SIGKILL);
 		}
-		CATCH_EINTR(waitpid(pid, NULL, 0));
+		CATCH_EINTR(waitpid(pid, NULL, __WCLONE));
 	}
 
 out_free2:
@@ -126,7 +126,7 @@ int run_helper_thread(int (*proc)(void *
 		return -ENOMEM;
 
 	sp = stack + UM_KERN_PAGE_SIZE - sizeof(void *);
-	pid = clone(proc, (void *) sp, flags | SIGCHLD, arg);
+	pid = clone(proc, (void *) sp, flags, arg);
 	if (pid < 0) {
 		err = -errno;
 		printk("run_helper_thread : clone failed, errno = %d\n",
@@ -134,7 +134,7 @@ int run_helper_thread(int (*proc)(void *
 		return err;
 	}
 	if (stack_out == NULL) {
-		CATCH_EINTR(pid = waitpid(pid, &status, 0));
+		CATCH_EINTR(pid = waitpid(pid, &status, __WCLONE));
 		if (pid < 0) {
 			err = -errno;
 			printk("run_helper_thread - wait failed, errno = %d\n",
@@ -150,14 +150,30 @@ int run_helper_thread(int (*proc)(void *
 	return pid;
 }
 
-int helper_wait(int pid)
+int helper_wait(int pid, int nohang, char *pname)
 {
-	int ret;
+	int ret, status;
+	int wflags = __WCLONE;
 
-	CATCH_EINTR(ret = waitpid(pid, NULL, WNOHANG));
+	if (nohang)
+		wflags |= WNOHANG;
+
+	if (!pname)
+		pname = "helper_wait";
+
+	CATCH_EINTR(ret = waitpid(pid, &status, wflags));
 	if (ret < 0) {
-		ret = -errno;
-		printk("helper_wait : waitpid failed, errno = %d\n", errno);
-	}
-	return ret;
+		printk(UM_KERN_ERR "%s : waitpid process %d failed, "
+		       "errno = %d\n", pname, pid, errno);
+		return -errno;
+	} else if (nohang && ret == 0) {
+		printk(UM_KERN_ERR "%s : process %d has not exited\n",
+		       pname, pid);
+		return -ECHILD;
+	} else if (!WIFEXITED(status) || WEXITSTATUS(status) != 0) {
+		printk(UM_KERN_ERR "%s : process %d didn't exit with "
+		       "status 0\n", pname, pid);
+		return -ECHILD;
+	} else
+		return 0;
 }
Index: linux-2.6-git/arch/um/os-Linux/process.c
===================================================================
--- linux-2.6-git.orig/arch/um/os-Linux/process.c	2007-12-11 11:48:08.000000000 -0500
+++ linux-2.6-git/arch/um/os-Linux/process.c	2007-12-11 11:49:03.000000000 -0500
@@ -101,7 +101,7 @@ void os_kill_process(int pid, int reap_c
 {
 	kill(pid, SIGKILL);
 	if (reap_child)
-		CATCH_EINTR(waitpid(pid, NULL, 0));
+		CATCH_EINTR(waitpid(pid, NULL, __WALL));
 }
 
 /* This is here uniquely to have access to the userspace errno, i.e. the one
@@ -130,7 +130,7 @@ void os_kill_ptraced_process(int pid, in
 	ptrace(PTRACE_KILL, pid);
 	ptrace(PTRACE_CONT, pid);
 	if (reap_child)
-		CATCH_EINTR(waitpid(pid, NULL, 0));
+		CATCH_EINTR(waitpid(pid, NULL, __WALL));
 }
 
 /* Don't use the glibc version, which caches the result in TLS. It misses some
Index: linux-2.6-git/arch/um/os-Linux/util.c
===================================================================
--- linux-2.6-git.orig/arch/um/os-Linux/util.c	2007-12-11 11:48:08.000000000 -0500
+++ linux-2.6-git/arch/um/os-Linux/util.c	2007-12-11 11:49:03.000000000 -0500
@@ -141,7 +141,7 @@ void os_dump_core(void)
 	 * nothing reasonable to do if that fails.
 	 */
 
-	while ((pid = waitpid(-1, NULL, WNOHANG)) > 0)
+	while ((pid = waitpid(-1, NULL, WNOHANG | __WALL)) > 0)
 		os_kill_ptraced_process(pid, 0);
 
 	abort();
Index: linux-2.6-git/arch/um/include/os.h
===================================================================
--- linux-2.6-git.orig/arch/um/include/os.h	2007-12-11 11:48:08.000000000 -0500
+++ linux-2.6-git/arch/um/include/os.h	2007-12-11 11:49:03.000000000 -0500
@@ -214,7 +214,7 @@ extern int execvp_noalloc(char *buf, con
 extern int run_helper(void (*pre_exec)(void *), void *pre_data, char **argv);
 extern int run_helper_thread(int (*proc)(void *), void *arg,
 			     unsigned int flags, unsigned long *stack_out);
-extern int helper_wait(int pid);
+extern int helper_wait(int pid, int nohang, char *pname);
 
 
 /* tls.c */
Index: linux-2.6-git/arch/um/os-Linux/skas/process.c
===================================================================
--- linux-2.6-git.orig/arch/um/os-Linux/skas/process.c	2007-12-11 11:48:08.000000000 -0500
+++ linux-2.6-git/arch/um/os-Linux/skas/process.c	2007-12-11 11:49:03.000000000 -0500
@@ -64,7 +64,7 @@ void wait_stub_done(int pid)
 	int n, status, err;
 
 	while (1) {
-		CATCH_EINTR(n = waitpid(pid, &status, WUNTRACED));
+		CATCH_EINTR(n = waitpid(pid, &status, WUNTRACED | __WALL));
 		if ((n < 0) || !WIFSTOPPED(status))
 			goto bad_wait;
 
@@ -153,7 +153,7 @@ static void handle_trap(int pid, struct 
 			panic("handle_trap - continuing to end of syscall "
 			      "failed, errno = %d\n", errno);
 
-		CATCH_EINTR(err = waitpid(pid, &status, WUNTRACED));
+		CATCH_EINTR(err = waitpid(pid, &status, WUNTRACED | __WALL));
 		if ((err < 0) || !WIFSTOPPED(status) ||
 		   (WSTOPSIG(status) != SIGTRAP + 0x80)) {
                         err = ptrace_dump_regs(pid);
@@ -255,16 +255,18 @@ int start_userspace(unsigned long stub_s
 		panic("start_userspace : mmap failed, errno = %d", errno);
 	sp = (unsigned long) stack + UM_KERN_PAGE_SIZE - sizeof(void *);
 
-	flags = CLONE_FILES | SIGCHLD;
+	flags = CLONE_FILES;
 	if (proc_mm)
 		flags |= CLONE_VM;
+	else
+		flags |= SIGCHLD;
 
 	pid = clone(userspace_tramp, (void *) sp, flags, (void *) stub_stack);
 	if (pid < 0)
 		panic("start_userspace : clone failed, errno = %d", errno);
 
 	do {
-		CATCH_EINTR(n = waitpid(pid, &status, WUNTRACED));
+		CATCH_EINTR(n = waitpid(pid, &status, WUNTRACED | __WALL));
 		if (n < 0)
 			panic("start_userspace : wait failed, errno = %d",
 			      errno);
@@ -314,7 +316,7 @@ void userspace(struct uml_pt_regs *regs)
 			      "pid=%d, ptrace operation = %d, errno = %d\n",
 			      pid, op, errno);
 
-		CATCH_EINTR(err = waitpid(pid, &status, WUNTRACED));
+		CATCH_EINTR(err = waitpid(pid, &status, WUNTRACED | __WALL));
 		if (err < 0)
 			panic("userspace - waitpid failed, errno = %d\n",
 			      errno);
