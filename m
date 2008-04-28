Return-Path: <linux-kernel-owner+w=401wt.eu-S1764246AbYD1DUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764246AbYD1DUl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 23:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762264AbYD1DUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 23:20:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45964 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762199AbYD1DUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 23:20:31 -0400
Date: Sun, 27 Apr 2008 23:20:28 -0400
From: Ulrich Drepper <drepper@redhat.com>
Message-Id: <200804280320.m3S3KSFu028466@devserv.devel.redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] dup2 w/flags
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds dup3 which is dup2 with an additional parameter.  The
parameter takes the usual O_* flags, with only O_CLOEXEC handled so far
(it's possible to handle O_NONBLOCK in future, if this is wanted).

I've read some people mentioning that we simply should use a new fcntl()
extension similar to F_DUPFD_CLOEXEC.  I think that's a terrible idea
and in any case not better than sys_indirect.  A new syscall is the
cleanest solution and it's really only a little bit of effort.


 b/arch/x86/ia32/ia32entry.S          |    1 +
 b/arch/x86/kernel/syscall_table_32.S |    1 +
 b/include/asm-x86/unistd_32.h        |    1 +
 b/include/asm-x86/unistd_64.h        |    2 ++
 b/include/linux/syscalls.h           |    1 +
 b/fs/fcntl.c                         |   15 +++++++++++++--
 6 files changed, 19 insertions(+), 2 deletions(-)


Signed-off-by: Ulrich Drepper <drepper@redhat.com>

diff -u b/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
--- b/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -736,2 +736,3 @@
 	.quad sys_epoll_create2
+	.quad sys_dup3			/* 330 */
 ia32_syscall_end:
diff -u b/arch/x86/kernel/syscall_table_32.S b/arch/x86/kernel/syscall_table_32.S
--- b/arch/x86/kernel/syscall_table_32.S
+++ b/arch/x86/kernel/syscall_table_32.S
@@ -331,0 +332 @@
+	.long sys_dup3			/* 330 */
diff -u b/include/asm-x86/unistd_32.h b/include/asm-x86/unistd_32.h
--- b/include/asm-x86/unistd_32.h
+++ b/include/asm-x86/unistd_32.h
@@ -335,6 +335,7 @@
 #define __NR_signalfd4		327
 #define __NR_eventfd2		328
 #define __NR_epoll_create2	329
+#define __NR_dup3		330
 
 #ifdef __KERNEL__
 
diff -u b/include/asm-x86/unistd_64.h b/include/asm-x86/unistd_64.h
--- b/include/asm-x86/unistd_64.h
+++ b/include/asm-x86/unistd_64.h
@@ -647,6 +647,8 @@
 __SYSCALL(__NR_eventfd2, sys_eventfd2)
 #define __NR_epoll_create2			291
 __SYSCALL(__NR_epoll_create2, sys_epoll_create2)
+#define __NR_dup3				292
+__SYSCALL(__NR_dup3, sys_dup3)
 
 
 #ifndef __NO_STUBS
diff -u b/include/linux/syscalls.h b/include/linux/syscalls.h
--- b/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -303,6 +303,7 @@
 #endif
 asmlinkage long sys_dup(unsigned int fildes);
 asmlinkage long sys_dup2(unsigned int oldfd, unsigned int newfd);
+asmlinkage long sys_dup3(unsigned int oldfd, unsigned int newfd, int flags);
 asmlinkage long sys_ioperm(unsigned long from, unsigned long num, int on);
 asmlinkage long sys_ioctl(unsigned int fd, unsigned int cmd,
 				unsigned long arg);
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -125,13 +125,16 @@ static int dupfd(struct file *file, unsigned int start, int cloexec)
 	return fd;
 }
 
-asmlinkage long sys_dup2(unsigned int oldfd, unsigned int newfd)
+asmlinkage long sys_dup3(unsigned int oldfd, unsigned int newfd, int flags)
 {
 	int err = -EBADF;
 	struct file * file, *tofree;
 	struct files_struct * files = current->files;
 	struct fdtable *fdt;
 
+	if ((flags & ~O_CLOEXEC) != 0)
+		return -EINVAL;
+
 	spin_lock(&files->file_lock);
 	if (!(file = fcheck(oldfd)))
 		goto out_unlock;
@@ -163,7 +166,10 @@ asmlinkage long sys_dup2(unsigned int oldfd, unsigned int newfd)
 
 	rcu_assign_pointer(fdt->fd[newfd], file);
 	FD_SET(newfd, fdt->open_fds);
-	FD_CLR(newfd, fdt->close_on_exec);
+	if (flags & O_CLOEXEC)
+		FD_SET(newfd, fdt->close_on_exec);
+	else
+		FD_CLR(newfd, fdt->close_on_exec);
 	spin_unlock(&files->file_lock);
 
 	if (tofree)
@@ -181,6 +187,11 @@ out_fput:
 	goto out;
 }
 
+asmlinkage long sys_dup2(unsigned int oldfd, unsigned int newfd)
+{
+	return sys_dup3(oldfd, newfd, 0);
+}
+
 asmlinkage long sys_dup(unsigned int fildes)
 {
 	int ret = -EBADF;
