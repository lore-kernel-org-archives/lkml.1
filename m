Return-Path: <linux-kernel-owner+w=401wt.eu-S1759773AbXKTGzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759773AbXKTGzp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 01:55:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759327AbXKTGxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 01:53:50 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60807 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759287AbXKTGxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 01:53:48 -0500
Date: Tue, 20 Nov 2007 01:53:14 -0500
From: Ulrich Drepper <drepper@redhat.com>
Message-Id: <200711200653.lAK6rE31025888@devserv.devel.redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCHv4 4/6] Allow setting FD_CLOEXEC flag for new sockets
Cc: akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
       torvalds@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a first user of sys_indirect.  Several of the socket-related system
calls which produce a file handle now can be passed an additional parameter
to set the FD_CLOEXEC flag.

 arch/x86/ia32/Makefile        |    1 +
 arch/x86/ia32/sys_ia32.c      |    4 ++++
 include/asm-x86/ia32_unistd.h |    1 +
 include/linux/indirect.h      |   33 +++++++++++++++++++++++++++++++++
 kernel/Makefile               |    2 ++
 kernel/indirect.c             |    4 ++++
 net/socket.c                  |   21 +++++++++++++--------
 7 files changed, 58 insertions(+), 8 deletions(-)

--- arch/x86/ia32/Makefile
+++ arch/x86/ia32/Makefile
@@ -36,6 +36,7 @@ $(obj)/vsyscall-sysenter.so.dbg $(obj)/vsyscall-syscall.so.dbg: \
 $(obj)/vsyscall-%.so.dbg: $(src)/vsyscall.lds $(obj)/vsyscall-%.o FORCE
 	$(call if_changed,syscall)
 
+CFLAGS_sys_ia32.o = -Wno-undef
 AFLAGS_vsyscall-sysenter.o = -m32 -Wa,-32
 AFLAGS_vsyscall-syscall.o = -m32 -Wa,-32
 
--- kernel/Makefile
+++ kernel/Makefile
@@ -67,6 +67,8 @@ ifneq ($(CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER),y)
 CFLAGS_sched.o := $(PROFILING) -fno-omit-frame-pointer
 endif
 
+CFLAGS_indirect.o = -Wno-undef
+
 $(obj)/configs.o: $(obj)/config_data.h
 
 # config_data.h contains the same information as ikconfig.h but gzipped.
diff -u net/socket.c net/socket.c
--- net/socket.c
+++ net/socket.c
@@ -344,11 +344,11 @@
  *	but we take care of internal coherence yet.
  */
 
-static int sock_alloc_fd(struct file **filep)
+static int sock_alloc_fd(struct file **filep, int flags)
 {
 	int fd;
 
-	fd = get_unused_fd();
+	fd = get_unused_fd_flags(flags);
 	if (likely(fd >= 0)) {
 		struct file *file = get_empty_filp();
 
@@ -391,10 +391,10 @@
 	return 0;
 }
 
-int sock_map_fd(struct socket *sock)
+static int sock_map_fd_flags(struct socket *sock, int flags)
 {
 	struct file *newfile;
-	int fd = sock_alloc_fd(&newfile);
+	int fd = sock_alloc_fd(&newfile, flags);
 
 	if (likely(fd >= 0)) {
 		int err = sock_attach_fd(sock, newfile);
@@ -409,6 +409,11 @@
 	return fd;
 }
 
+int sock_map_fd(struct socket *sock)
+{
+	return sock_map_fd_flags(sock, 0);
+}
+
 static struct socket *sock_from_file(struct file *file, int *err)
 {
 	if (file->f_op == &socket_file_ops)
@@ -1208,7 +1213,7 @@
 	if (retval < 0)
 		goto out;
 
-	retval = sock_map_fd(sock);
+	retval = sock_map_fd_flags(sock, INDIRECT_PARAM(file_flags, flags));
 	if (retval < 0)
 		goto out_release;
 
@@ -1249,13 +1254,13 @@
 	if (err < 0)
 		goto out_release_both;
 
-	fd1 = sock_alloc_fd(&newfile1);
+	fd1 = sock_alloc_fd(&newfile1, INDIRECT_PARAM(file_flags, flags));
 	if (unlikely(fd1 < 0)) {
 		err = fd1;
 		goto out_release_both;
 	}
 
-	fd2 = sock_alloc_fd(&newfile2);
+	fd2 = sock_alloc_fd(&newfile2, INDIRECT_PARAM(file_flags, flags));
 	if (unlikely(fd2 < 0)) {
 		err = fd2;
 		put_filp(newfile1);
@@ -1411,7 +1416,7 @@
 	 */
 	__module_get(newsock->ops->owner);
 
-	newfd = sock_alloc_fd(&newfile);
+	newfd = sock_alloc_fd(&newfile, INDIRECT_PARAM(file_flags, flags));
 	if (unlikely(newfd < 0)) {
 		err = newfd;
 		sock_release(newsock);
diff -u arch/x86/ia32/sys_ia32.c arch/x86/ia32/sys_ia32.c
--- arch/x86/ia32/sys_ia32.c
+++ arch/x86/ia32/sys_ia32.c
@@ -902,6 +902,10 @@
 
 	switch (INDIRECT_SYSCALL32(&regs))
 	{
+#define INDSYSCALL(name) __NR_ia32_##name
+#include <linux/indirect.h>
+		break;
+
 	default:
 		return -EINVAL;
 	}
diff -u include/linux/indirect.h include/linux/indirect.h
--- include/linux/indirect.h
+++ include/linux/indirect.h
@@ -1,6 +1,39 @@
+#ifndef INDSYSCALL
 #ifndef _LINUX_INDIRECT_H
 #define _LINUX_INDIRECT_H
 
 #include <asm/indirect.h>
 
+
+union indirect_params {
+  struct {
+    int flags;
+  } file_flags;
+};
+
+#define INDIRECT_PARAM(set, name) current->indirect_params.set.name
+
+#endif
+#else
+
+/* Here comes the list of system calls which can be called through
+   sys_indirect.  When the list if support system calls is needed the
+   file including this header is supposed to define a macro "INDSYSCALL"
+   which adds a prefix fitting to the use.  If the resulting macro is
+   defined we generate a line
+	case MACRO:
+   */
+#if INDSYSCALL(accept)
+  case INDSYSCALL(accept):
+#endif
+#if INDSYSCALL(socket)
+  case INDSYSCALL(socket):
+#endif
+#if INDSYSCALL(socketcall)
+  case INDSYSCALL(socketcall):
+#endif
+#if INDSYSCALL(socketpair)
+  case INDSYSCALL(socketpair):
+#endif
+
 #endif
diff -u kernel/indirect.c kernel/indirect.c
--- kernel/indirect.c
+++ kernel/indirect.c
@@ -19,6 +19,10 @@
 
 	switch (INDIRECT_SYSCALL (&regs))
 	{
+#define INDSYSCALL(name) __NR_##name
+#include <linux/indirect.h>
+		break;
+
 	default:
 		return -EINVAL;
 	}
--- include/asm-x86/ia32_unistd.h
+++ include/asm-x86/ia32_unistd.h
@@ -12,6 +12,7 @@
 #define __NR_ia32_exit		  1
 #define __NR_ia32_read		  3
 #define __NR_ia32_write		  4
+#define __NR_ia32_socketcall	102
 #define __NR_ia32_sigreturn	119
 #define __NR_ia32_rt_sigreturn	173
 
