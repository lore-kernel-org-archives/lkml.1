Return-Path: <linux-kernel-owner+w=401wt.eu-S1762902AbYD0WST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762902AbYD0WST (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 18:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751936AbYD0WSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 18:18:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45520 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824AbYD0WSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 18:18:10 -0400
Date: Sun, 27 Apr 2008 18:17:35 -0400
From: Ulrich Drepper <drepper@redhat.com>
Message-Id: <200804272217.m3RMHZ0S021481@devserv.devel.redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] eventfd, signalfd, timerfd, epoll_create w/flags
Cc: akpm@linux-foundation.org, davidel@xmailserver.org,
       torvalds@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the absence of sys_indirect we need the following patches as well.  These
are all the event handling functions: epoll_create, signalfd, timerfd, eventd.

There is good news and bad.  The good news is that the timerfd interface
already has a flags parameter.  We just have to put it to use.  It's IMO
not a good idea to use the O_* values for any of the flag parameters so I
introduced new macros for all the functions.

For signalfd and eventfd no flags parameter is available in the syscall.
But for the userlevel interfaces I have added such a parameter back when.
They are just required to be zero so far.  This means the new syscalls
will completely transparently be used once glibc knows about them.
Programs can start using the new flags and get told when the implementation
doesn't support it.

The bad case is epoll_create.  Neither the kernel nor the userlevel interface
has a flags parameter.  So we need a new, additional interface.  We could have
one which differs from epoll_create only in that it returns a file descriptor
with close-on-exec already set.  I don't like that.  Instead, the patch adds
a new interface with a flags parameter.  More flexibility in future.

The changes overall are minimal.  All the basic functionality is already there.
The interface of anon_inode_getfd() had to be changed.  The interface is
exported (as GPL-only).  I changed all the in-tree users so we should be fine. 


The patch applies on top of the socket patch.  The only dependency is the
system call list, though.  Both patches introduce new syscalls.


 arch/x86/ia32/ia32entry.S          |    3 +++
 arch/x86/kernel/syscall_table_32.S |    3 +++
 b/include/asm-x86/unistd_64.h      |    6 ++++++
 b/include/linux/syscalls.h         |    3 +++
 fs/anon_inodes.c                   |    9 +++++----
 fs/compat.c                        |   14 ++++++++++----
 fs/eventfd.c                       |   19 +++++++++++++++++--
 fs/eventpoll.c                     |   19 +++++++++++++++++--
 fs/signalfd.c                      |   19 +++++++++++++++++--
 fs/timerfd.c                       |   13 ++++++++++---
 include/asm-x86/unistd_32.h        |    3 +++
 include/linux/anon_inodes.h        |    2 +-
 include/linux/eventfd.h            |    2 ++
 include/linux/eventpoll.h          |    2 ++
 include/linux/signalfd.h           |    3 +++
 include/linux/timerfd.h            |    4 +++-
 16 files changed, 105 insertions(+), 19 deletions(-)


Signed-off-by: Ulrich Drepper <drepper@redhat.com>

diff -u b/include/asm-x86/unistd_64.h b/include/asm-x86/unistd_64.h
--- b/include/asm-x86/unistd_64.h
+++ b/include/asm-x86/unistd_64.h
@@ -641,6 +641,12 @@
 __SYSCALL(__NR_timerfd_gettime, sys_timerfd_gettime)
 #define __NR_paccept				288
 __SYSCALL(__NR_paccept, sys_paccept)
+#define __NR_signalfd4				289
+__SYSCALL(__NR_signalfd4, sys_signalfd4)
+#define __NR_eventfd2				290
+__SYSCALL(__NR_eventfd2, sys_eventfd2)
+#define __NR_epoll_createp			291
+__SYSCALL(__NR_epoll_createp, sys_epoll_createp)
 
 
 #ifndef __NO_STUBS
diff -u b/include/linux/syscalls.h b/include/linux/syscalls.h
--- b/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -428,6 +428,7 @@
 asmlinkage long sys_select(int n, fd_set __user *inp, fd_set __user *outp,
 			fd_set __user *exp, struct timeval __user *tvp);
 asmlinkage long sys_epoll_create(int size);
+asmlinkage long sys_epoll_createp(int size, int flags);
 asmlinkage long sys_epoll_ctl(int epfd, int op, int fd,
 				struct epoll_event __user *event);
 asmlinkage long sys_epoll_wait(int epfd, struct epoll_event __user *events,
@@ -608,12 +609,14 @@
 				    size_t len);
 asmlinkage long sys_getcpu(unsigned __user *cpu, unsigned __user *node, struct getcpu_cache __user *cache);
 asmlinkage long sys_signalfd(int ufd, sigset_t __user *user_mask, size_t sizemask);
+asmlinkage long sys_signalfd4(int ufd, sigset_t __user *user_mask, size_t sizemask, int flags);
 asmlinkage long sys_timerfd_create(int clockid, int flags);
 asmlinkage long sys_timerfd_settime(int ufd, int flags,
 				    const struct itimerspec __user *utmr,
 				    struct itimerspec __user *otmr);
 asmlinkage long sys_timerfd_gettime(int ufd, struct itimerspec __user *otmr);
 asmlinkage long sys_eventfd(unsigned int count);
+asmlinkage long sys_eventfd2(unsigned int count, int flags);
 asmlinkage long sys_fallocate(int fd, int mode, loff_t offset, loff_t len);
 
 int kernel_execve(const char *filename, char *const argv[], char *const envp[]);
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -731,4 +731,7 @@ ia32_sys_call_table:
 	.quad sys32_fallocate
 	.quad compat_sys_timerfd_settime	/* 325 */
 	.quad compat_sys_timerfd_gettime
+	.quad compat_sys_signalfd4
+	.quad sys_eventfd2
+	.quad sys_epoll_createp
 ia32_syscall_end:
--- a/arch/x86/kernel/syscall_table_32.S
+++ b/arch/x86/kernel/syscall_table_32.S
@@ -326,3 +326,6 @@ ENTRY(sys_call_table)
 	.long sys_fallocate
 	.long sys_timerfd_settime	/* 325 */
 	.long sys_timerfd_gettime
+	.long sys_signalfd4
+	.long sys_eventfd2
+	.long sys_epoll_createp
--- a/fs/anon_inodes.c
+++ b/fs/anon_inodes.c
@@ -61,8 +61,9 @@ static struct dentry_operations anon_inodefs_dentry_operations = {
  * @dpinode: [out]   pointer to the inode
  * @pfile:   [out]   pointer to the file struct
  * @name:    [in]    name of the "class" of the new file
- * @fops     [in]    file operations for the new file
- * @priv     [in]    private data for the new file (will be file's private_data)
+ * @fops:    [in]    file operations for the new file
+ * @priv:    [in]    private data for the new file (will be file's private_data)
+ * @flags:   [in]    flags
  *
  * Creates a new file by hooking it on a single inode. This is useful for files
  * that do not need to have a full-fledged inode in order to operate correctly.
@@ -72,7 +73,7 @@ static struct dentry_operations anon_inodefs_dentry_operations = {
  */
 int anon_inode_getfd(int *pfd, struct inode **pinode, struct file **pfile,
 		     const char *name, const struct file_operations *fops,
-		     void *priv)
+		     void *priv, int flags)
 {
 	struct qstr this;
 	struct dentry *dentry;
@@ -82,7 +83,7 @@ int anon_inode_getfd(int *pfd, struct inode **pinode, struct file **pfile,
 	if (IS_ERR(anon_inode_inode))
 		return -ENODEV;
 
-	error = get_unused_fd();
+	error = get_unused_fd_flags(flags);
 	if (error < 0)
 		return error;
 	fd = error;
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -2130,9 +2130,9 @@ asmlinkage long compat_sys_epoll_pwait(int epfd,
 
 #ifdef CONFIG_SIGNALFD
 
-asmlinkage long compat_sys_signalfd(int ufd,
-				    const compat_sigset_t __user *sigmask,
-				    compat_size_t sigsetsize)
+asmlinkage long compat_sys_signalfd4(int ufd,
+				     const compat_sigset_t __user *sigmask,
+				     compat_size_t sigsetsize, int flags)
 {
 	compat_sigset_t ss32;
 	sigset_t tmp;
@@ -2147,9 +2147,15 @@ asmlinkage long compat_sys_signalfd(int ufd,
 	if (copy_to_user(ksigmask, &tmp, sizeof(sigset_t)))
 		return -EFAULT;
 
-	return sys_signalfd(ufd, ksigmask, sizeof(sigset_t));
+	return sys_signalfd(ufd, ksigmask, sizeof(sigset_t), flags);
 }
 
+asmlinkage long compat_sys_signalfd(int ufd,
+				    const compat_sigset_t __user *sigmask,
+				    compat_size_t sigsetsize)
+{
+	return compat_sys_signalfd4(ufd, sigmask, sigsetsize, 0);
+}
 #endif /* CONFIG_SIGNALFD */
 
 #ifdef CONFIG_TIMERFD
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -198,12 +198,22 @@ struct file *eventfd_fget(int fd)
 	return file;
 }
 
-asmlinkage long sys_eventfd(unsigned int count)
+asmlinkage long sys_eventfd2(unsigned int count, int flags)
 {
 	int error, fd;
 	struct eventfd_ctx *ctx;
 	struct file *file;
 	struct inode *inode;
+	int fflags = 0;
+
+	if (flags) {
+		if ((flags & EFD_CLOEXEC) != 0) {
+			fflags |= O_CLOEXEC;
+			flags &= ~EFD_CLOEXEC;
+		}
+		if (flags)
+			return -EINVAL;
+	}
 
 	ctx = kmalloc(sizeof(*ctx), GFP_KERNEL);
 	if (!ctx)
@@ -217,7 +227,7 @@ asmlinkage long sys_eventfd(unsigned int count)
 	 * anon_inode_getfd() will install the fd.
 	 */
 	error = anon_inode_getfd(&fd, &inode, &file, "[eventfd]",
-				 &eventfd_fops, ctx);
+				 &eventfd_fops, ctx, fflags);
 	if (!error)
 		return fd;
 
@@ -225,3 +235,8 @@ asmlinkage long sys_eventfd(unsigned int count)
 	return error;
 }
 
+asmlinkage long sys_eventfd(unsigned int count)
+{
+	return sys_eventfd2(count, 0);
+}
+
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1067,12 +1067,22 @@ retry:
  * RB tree. With the current implementation, the "size" parameter is ignored
  * (besides sanity checks).
  */
-asmlinkage long sys_epoll_create(int size)
+asmlinkage long sys_epoll_createp(int size, int flags)
 {
 	int error, fd = -1;
 	struct eventpoll *ep;
 	struct inode *inode;
 	struct file *file;
+	int fflags = 0;
+
+	if (flags) {
+		if ((flags & EPOLL_CLOEXEC) != 0) {
+			fflags |= O_CLOEXEC;
+			flags &= ~EPOLL_CLOEXEC;
+		}
+		if (flags)
+			return -EINVAL;
+	}
 
 	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: sys_epoll_create(%d)\n",
 		     current, size));
@@ -1090,7 +1100,7 @@ asmlinkage long sys_epoll_create(int size)
 	 * a file structure, and inode and a free file descriptor.
 	 */
 	error = anon_inode_getfd(&fd, &inode, &file, "[eventpoll]",
-				 &eventpoll_fops, ep);
+				 &eventpoll_fops, ep, fflags);
 	if (error)
 		goto error_free;
 
@@ -1107,6 +1117,11 @@ error_return:
 	return error;
 }
 
+asmlinkage long sys_epoll_create(int size)
+{
+	return sys_epoll_createp(size, 0);
+}
+
 /*
  * The following function implements the controller interface for
  * the eventpoll file that enables the insertion/removal/change of
--- a/fs/signalfd.c
+++ b/fs/signalfd.c
@@ -205,13 +205,24 @@ static const struct file_operations signalfd_fops = {
 	.read		= signalfd_read,
 };
 
-asmlinkage long sys_signalfd(int ufd, sigset_t __user *user_mask, size_t sizemask)
+asmlinkage long sys_signalfd4(int ufd, sigset_t __user *user_mask,
+			      size_t sizemask, int flags)
 {
 	int error;
 	sigset_t sigmask;
 	struct signalfd_ctx *ctx;
 	struct file *file;
 	struct inode *inode;
+	int fflags = 0;
+
+	if (flags) {
+		if ((flags & SFD_CLOEXEC) != 0 && ufd == -1) {
+			fflags |= O_CLOEXEC;
+			flags &= ~SFD_CLOEXEC;
+		}
+		if (flags)
+			return -EINVAL;
+	}
 
 	if (sizemask != sizeof(sigset_t) ||
 	    copy_from_user(&sigmask, user_mask, sizeof(sigmask)))
@@ -231,7 +242,7 @@ asmlinkage long sys_signalfd(int ufd, sigset_t __user *user_mask, size_t sizemas
 		 * anon_inode_getfd() will install the fd.
 		 */
 		error = anon_inode_getfd(&ufd, &inode, &file, "[signalfd]",
-					 &signalfd_fops, ctx);
+					 &signalfd_fops, ctx, fflags);
 		if (error)
 			goto err_fdalloc;
 	} else {
@@ -258,3 +269,7 @@ err_fdalloc:
 	return error;
 }
 
+asmlinkage long sys_signalfd(int ufd, sigset_t __user *user_mask, size_t sizemask)
+{
+	return sys_signalfd4(ufd, user_mask, sizemask, 0);
+}
--- a/fs/timerfd.c
+++ b/fs/timerfd.c
@@ -184,9 +184,16 @@ asmlinkage long sys_timerfd_create(int clockid, int flags)
 	struct timerfd_ctx *ctx;
 	struct file *file;
 	struct inode *inode;
+	int fflags = 0;
 
-	if (flags)
-		return -EINVAL;
+	if (flags) {
+		if ((flags & TFD_CLOEXEC) != 0) {
+			fflags |= O_CLOEXEC;
+			flags &= ~TFD_CLOEXEC;
+		}
+		if (flags)
+			return -EINVAL;
+	}
 	if (clockid != CLOCK_MONOTONIC &&
 	    clockid != CLOCK_REALTIME)
 		return -EINVAL;
@@ -200,7 +207,7 @@ asmlinkage long sys_timerfd_create(int clockid, int flags)
 	hrtimer_init(&ctx->tmr, clockid, HRTIMER_MODE_ABS);
 
 	error = anon_inode_getfd(&ufd, &inode, &file, "[timerfd]",
-				 &timerfd_fops, ctx);
+				 &timerfd_fops, ctx, fflags);
 	if (error) {
 		kfree(ctx);
 		return error;
--- a/include/asm-x86/unistd_32.h
+++ b/include/asm-x86/unistd_32.h
@@ -332,6 +332,9 @@
 #define __NR_fallocate		324
 #define __NR_timerfd_settime	325
 #define __NR_timerfd_gettime	326
+#define __NR_signalfd4		327
+#define __NR_eventfd2		328
+#define __NR_epoll_createp	329
 
 #ifdef __KERNEL__
 
--- a/include/linux/anon_inodes.h
+++ b/include/linux/anon_inodes.h
@@ -10,7 +10,7 @@
 
 int anon_inode_getfd(int *pfd, struct inode **pinode, struct file **pfile,
 		     const char *name, const struct file_operations *fops,
-		     void *priv);
+		     void *priv, int flags);
 
 #endif /* _LINUX_ANON_INODES_H */
 
--- a/include/linux/eventfd.h
+++ b/include/linux/eventfd.h
@@ -8,6 +8,8 @@
 #ifndef _LINUX_EVENTFD_H
 #define _LINUX_EVENTFD_H
 
+/* Flags for eventfd.  */
+#define EFD_CLOEXEC (1 << 0)
 
 #ifdef __KERNEL__
 
--- a/include/linux/eventpoll.h
+++ b/include/linux/eventpoll.h
@@ -16,6 +16,8 @@
 
 #include <linux/types.h>
 
+/* Flags for epoll_createp.  */
+#define EPOLL_CLOEXEC (1 << 0)
 
 /* Valid opcodes to issue to sys_epoll_ctl() */
 #define EPOLL_CTL_ADD 1
--- a/include/linux/signalfd.h
+++ b/include/linux/signalfd.h
@@ -9,6 +9,9 @@
 #define _LINUX_SIGNALFD_H
 
 
+/* Flags for signalfd.  */
+#define SFD_CLOEXEC (1 << 0)
+
 struct signalfd_siginfo {
 	__u32 ssi_signo;
 	__s32 ssi_errno;
--- a/include/linux/timerfd.h
+++ b/include/linux/timerfd.h
@@ -8,9 +8,11 @@
 #ifndef _LINUX_TIMERFD_H
 #define _LINUX_TIMERFD_H
 
-
+/* Flags for timerfd_settime.  */
 #define TFD_TIMER_ABSTIME (1 << 0)
 
+/* Flags for timerfd_create.  */
+#define TFD_CLOEXEC (1 << 0)
 
 
 #endif /* _LINUX_TIMERFD_H */
