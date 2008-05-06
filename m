Return-Path: <linux-kernel-owner+w=401wt.eu-S934205AbYEFXhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934205AbYEFXhi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 19:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934027AbYEFXgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 19:36:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933986AbYEFXgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 19:36:39 -0400
Date: Tue, 6 May 2008 19:36:33 -0400
From: Ulrich Drepper <drepper@redhat.com>
Message-Id: <200805062336.m46NaXvw008006@devserv.devel.redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] flag parameters add-on: remove epoll_create size param
Cc: akpm@linux-foundation.org, davidel@xmailserver.org,
       torvalds@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is to be applied on top of the series which adds the flag
parameters.  It removes the size parameter from the new epoll_create
syscall and renames the syscall itself.  The updated test program
follows.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#include <fcntl.h>
#include <stdio.h>
#include <time.h>
#include <unistd.h>
#include <sys/syscall.h>

#ifndef __NR_epoll_create2
# ifdef __x86_64__
#  define __NR_epoll_create2 291
# elif defined __i386__
#  define __NR_epoll_create2 329
# else
#  error "need __NR_epoll_create2"
# endif
#endif

#define EPOLL_CLOEXEC O_CLOEXEC

int
main (void)
{
  int fd = syscall (__NR_epoll_create2, 0);
  if (fd == -1)
    {
      puts ("epoll_create2(0) failed");
      return 1;
    }
  int coe = fcntl (fd, F_GETFD);
  if (coe == -1)
    {
      puts ("fcntl failed");
      return 1;
    }
  if (coe & FD_CLOEXEC)
    {
      puts ("epoll_create2(0) set close-on-exec flag");
      return 1;
    }
  close (fd);

  fd = syscall (__NR_epoll_create2, EPOLL_CLOEXEC);
  if (fd == -1)
    {
      puts ("epoll_create2(EPOLL_CLOEXEC) failed");
      return 1;
    }
  coe = fcntl (fd, F_GETFD);
  if (coe == -1)
    {
      puts ("fcntl failed");
      return 1;
    }
  if ((coe & FD_CLOEXEC) == 0)
    {
      puts ("epoll_create2(EPOLL_CLOEXEC) set close-on-exec flag");
      return 1;
    }
  close (fd);

  puts ("OK");

  return 0;
}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

 arch/x86/ia32/ia32entry.S          |    2 +-
 arch/x86/kernel/syscall_table_32.S |    2 +-
 fs/eventpoll.c                     |   18 ++++++++++--------
 include/asm-x86/unistd_32.h        |    2 +-
 include/asm-x86/unistd_64.h        |    4 ++--
 include/linux/eventpoll.h          |    2 +-
 include/linux/syscalls.h           |    2 +-
 7 files changed, 17 insertions(+), 15 deletions(-)


Signed-off-by: Ulrich Drepper <drepper@redhat.com>

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 37e4992..8fab3b5 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -733,7 +733,7 @@ ia32_sys_call_table:
 	.quad compat_sys_timerfd_gettime
 	.quad compat_sys_signalfd4
 	.quad sys_eventfd2
-	.quad sys_epoll_create2
+	.quad sys_epoll_create1
 	.quad sys_dup3			/* 330 */
 	.quad sys_pipe2
 	.quad sys_inotify_init1
diff --git a/arch/x86/kernel/syscall_table_32.S b/arch/x86/kernel/syscall_table_32.S
index f59aba5..d44395f 100644
--- a/arch/x86/kernel/syscall_table_32.S
+++ b/arch/x86/kernel/syscall_table_32.S
@@ -328,7 +328,7 @@ ENTRY(sys_call_table)
 	.long sys_timerfd_gettime
 	.long sys_signalfd4
 	.long sys_eventfd2
-	.long sys_epoll_create2
+	.long sys_epoll_create1
 	.long sys_dup3			/* 330 */
 	.long sys_pipe2
 	.long sys_inotify_init1
diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 2fdad42..0c87474 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1046,7 +1046,7 @@ retry:
  * RB tree. With the current implementation, the "size" parameter is ignored
  * (besides sanity checks).
  */
-asmlinkage long sys_epoll_create2(int size, int flags)
+asmlinkage long sys_epoll_create1(int flags)
 {
 	int error, fd = -1;
 	struct eventpoll *ep;
@@ -1058,14 +1058,13 @@ asmlinkage long sys_epoll_create2(int size, int flags)
 		return -EINVAL;
 
 	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: sys_epoll_create(%d)\n",
-		     current, size));
+		     current, flags));
 
 	/*
-	 * Sanity check on the size parameter, and create the internal data
-	 * structure ( "struct eventpoll" ).
+	 * Create the internal data structure ( "struct eventpoll" ).
 	 */
-	error = -EINVAL;
-	if (size <= 0 || (error = ep_alloc(&ep)) < 0) {
+	error = ep_alloc(&ep);
+	if (error < 0) {
 		fd = error;
 		goto error_return;
 	}
@@ -1081,14 +1080,17 @@ asmlinkage long sys_epoll_create2(int size, int flags)
 
 error_return:
 	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: sys_epoll_create(%d) = %d\n",
-		     current, size, fd));
+		     current, flags, fd));
 
 	return fd;
 }
 
 asmlinkage long sys_epoll_create(int size)
 {
-	return sys_epoll_create2(size, 0);
+	if (size < 0)
+		return -EINVAL;
+
+	return sys_epoll_create1(0);
 }
 
 /*
diff --git a/include/asm-x86/unistd_32.h b/include/asm-x86/unistd_32.h
index b3daf50..d739467 100644
--- a/include/asm-x86/unistd_32.h
+++ b/include/asm-x86/unistd_32.h
@@ -334,7 +334,7 @@
 #define __NR_timerfd_gettime	326
 #define __NR_signalfd4		327
 #define __NR_eventfd2		328
-#define __NR_epoll_create2	329
+#define __NR_epoll_create1	329
 #define __NR_dup3		330
 #define __NR_pipe2		331
 #define __NR_inotify_init1	332
diff --git a/include/asm-x86/unistd_64.h b/include/asm-x86/unistd_64.h
index 5ef6778..4b88511 100644
--- a/include/asm-x86/unistd_64.h
+++ b/include/asm-x86/unistd_64.h
@@ -645,8 +645,8 @@ __SYSCALL(__NR_paccept, sys_paccept)
 __SYSCALL(__NR_signalfd4, sys_signalfd4)
 #define __NR_eventfd2				290
 __SYSCALL(__NR_eventfd2, sys_eventfd2)
-#define __NR_epoll_create2			291
-__SYSCALL(__NR_epoll_create2, sys_epoll_create2)
+#define __NR_epoll_create1			291
+__SYSCALL(__NR_epoll_create1, sys_epoll_create1)
 #define __NR_dup3				292
 __SYSCALL(__NR_dup3, sys_dup3)
 #define __NR_pipe2				293
diff --git a/include/linux/eventpoll.h b/include/linux/eventpoll.h
index 1cfaa40..f1e1d3c 100644
--- a/include/linux/eventpoll.h
+++ b/include/linux/eventpoll.h
@@ -18,7 +18,7 @@
 #include <linux/fcntl.h>
 #include <linux/types.h>
 
-/* Flags for epoll_create2.  */
+/* Flags for epoll_create1.  */
 #define EPOLL_CLOEXEC O_CLOEXEC
 
 /* Valid opcodes to issue to sys_epoll_ctl() */
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index aeb2df8..9d86572 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -431,7 +431,7 @@ asmlinkage long sys_poll(struct pollfd __user *ufds, unsigned int nfds,
 asmlinkage long sys_select(int n, fd_set __user *inp, fd_set __user *outp,
 			fd_set __user *exp, struct timeval __user *tvp);
 asmlinkage long sys_epoll_create(int size);
-asmlinkage long sys_epoll_create2(int size, int flags);
+asmlinkage long sys_epoll_create1(int flags);
 asmlinkage long sys_epoll_ctl(int epfd, int op, int fd,
 				struct epoll_event __user *event);
 asmlinkage long sys_epoll_wait(int epfd, struct epoll_event __user *events,
