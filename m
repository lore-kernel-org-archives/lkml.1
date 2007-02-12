Return-Path: <linux-kernel-owner+w=401wt.eu-S1751010AbXBLAYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751010AbXBLAYf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 19:24:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751014AbXBLAYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 19:24:34 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:4330 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbXBLAYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 19:24:33 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sun, 11 Feb 2007 16:24:30 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [patch] (2nd try)  add epoll compat code to kernel/compat.c ...
Message-ID: <Pine.LNX.4.64.0702111615340.24568@alien.or.mcafeemobile.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Add epoll compat_ code to kernel/compat.c. IA64 and ARM-OABI are currently 
using their own version of epoll compat_ code and they could probably wire 
to the new common code.
Unfortunately, sys_epoll_pwait needs two compat versions, one for sigset_t 
only, and one for sigset_t+epoll_event.
Architectures that do not require epoll_event translation [1] whould wire 
compat_sys_epoll_pwait, while the ones that do require it, should wire 
compat_sys_epoll_pwait2.
Architectures that do not require epoll_event translation, should *not* 
wire neither compat_sys_epoll_ctl nor compat_sys_epoll_wait.
Patch over 2.6.20.


[1] An architecture needs epoll_event translation is alignof(u64) in 32 
    bits mode is 4, *and* alignof(u64) in 64 bits mode is 8.


Signed-off-by: Davide Libenzi <davidel@xmailserver.org>



- Davide



diff -Nru linux-2.6.20/fs/eventpoll.c linux-2.6.20.mod/fs/eventpoll.c
--- linux-2.6.20/fs/eventpoll.c	2007-02-04 10:44:54.000000000 -0800
+++ linux-2.6.20.mod/fs/eventpoll.c	2007-02-11 15:26:07.000000000 -0800
@@ -544,8 +544,7 @@
  * file descriptors inside the interest set.  It represents
  * the kernel part of the user space epoll_ctl(2).
  */
-asmlinkage long
-sys_epoll_ctl(int epfd, int op, int fd, struct epoll_event __user *event)
+asmlinkage long sys_epoll_ctl(int epfd, int op, int fd, struct epoll_event __user *event)
 {
 	int error;
 	struct file *file, *tfile;
@@ -707,8 +706,8 @@
  * part of the user space epoll_pwait(2).
  */
 asmlinkage long sys_epoll_pwait(int epfd, struct epoll_event __user *events,
-		int maxevents, int timeout, const sigset_t __user *sigmask,
-		size_t sigsetsize)
+				int maxevents, int timeout, const sigset_t __user *sigmask,
+				size_t sigsetsize)
 {
 	int error;
 	sigset_t ksigmask, sigsaved;
diff -Nru linux-2.6.20/include/linux/compat.h linux-2.6.20.mod/include/linux/compat.h
--- linux-2.6.20/include/linux/compat.h	2007-02-09 16:14:20.000000000 -0800
+++ linux-2.6.20.mod/include/linux/compat.h	2007-02-11 16:11:37.000000000 -0800
@@ -234,5 +234,35 @@
 		compat_ulong_t maxnode, const compat_ulong_t __user *old_nodes,
 		const compat_ulong_t __user *new_nodes);
 
+/*
+ * epoll (fs/eventpoll.c) compat bits follow ...
+ */
+struct epoll_event;
+
+struct compat_epoll_event {
+	u32 events;
+	u32 data[2];
+};
+
+asmlinkage long compat_sys_epoll_ctl(int epfd, int op, int fd,
+				     struct compat_epoll_event __user *event);
+asmlinkage long compat_sys_epoll_wait(int epfd, struct compat_epoll_event __user *events,
+				      int maxevents, int timeout);
+/*
+ * Architectures that does not need "struct epoll_event" translation
+ * should wire compat_sys_epoll_pwait. The ones that needs "struct epoll_event"
+ * translation, should wire compat_sys_epoll_pwait2. An architecture needs
+ * "struct epoll_event" translation is alignof(u64) in 32 bits mode is 4, and
+ * alignof(u64) in 64 bits mode is 8.
+ */
+asmlinkage long compat_sys_epoll_pwait(int epfd, struct epoll_event __user *events,
+				       int maxevents, int timeout,
+				       const compat_sigset_t __user *sigmask,
+				       compat_size_t sigsetsize);
+asmlinkage long compat_sys_epoll_pwait2(int epfd, struct compat_epoll_event __user *events,
+					int maxevents, int timeout,
+					const compat_sigset_t __user *sigmask,
+					compat_size_t sigsetsize);
+
 #endif /* CONFIG_COMPAT */
 #endif /* _LINUX_COMPAT_H */
diff -Nru linux-2.6.20/kernel/compat.c linux-2.6.20.mod/kernel/compat.c
--- linux-2.6.20/kernel/compat.c	2007-02-04 10:44:54.000000000 -0800
+++ linux-2.6.20.mod/kernel/compat.c	2007-02-11 16:11:01.000000000 -0800
@@ -23,6 +23,7 @@
 #include <linux/timex.h>
 #include <linux/migrate.h>
 #include <linux/posix-timers.h>
+#include <linux/eventpoll.h>
 
 #include <asm/uaccess.h>
 
@@ -1016,3 +1017,141 @@
 	return sys_migrate_pages(pid, nr_bits + 1, old, new);
 }
 #endif
+
+
+#ifdef CONFIG_EPOLL
+
+/*
+ * epoll (fs/eventpoll.c) compat functions follow ...
+ */
+
+asmlinkage long compat_sys_epoll_ctl(int epfd, int op, int fd,
+				     struct compat_epoll_event __user *event)
+{
+	long err = 0;
+	struct compat_epoll_event user;
+	struct epoll_event __user *kernel = NULL;
+	union {
+		u64 q;
+		u32 d[2];
+	} mux;
+
+	if (event) {
+		if (copy_from_user(&user, event, sizeof(user)))
+			return -EFAULT;
+		kernel = compat_alloc_user_space(sizeof(struct epoll_event));
+		err |= __put_user(user.events, &kernel->events);
+		mux.d[0] = user.data[0];
+		mux.d[1] = user.data[1];
+		err |= __put_user(mux.q, &kernel->data);
+	}
+	
+	return err ? err: sys_epoll_ctl(epfd, op, fd, kernel);
+}
+
+
+asmlinkage long compat_sys_epoll_wait(int epfd, struct compat_epoll_event __user *events,
+				      int maxevents, int timeout)
+{
+	long i, ret, err = 0;
+	struct epoll_event __user *kbuf;
+	struct epoll_event ev;
+	union {
+		u64 q;
+		u32 d[2];
+	} mux;
+
+	if (maxevents <= 0 || maxevents > (INT_MAX / sizeof(struct epoll_event)))
+		return -EINVAL;
+	kbuf = compat_alloc_user_space(sizeof(struct epoll_event) * maxevents);
+	ret = sys_epoll_wait(epfd, kbuf, maxevents, timeout);
+	for (i = 0; i < ret; i++) {
+		err |= __get_user(ev.events, &kbuf[i].events);
+		err |= __get_user(ev.data, &kbuf[i].data);
+		err |= put_user(ev.events, &events->events);
+		mux.q = ev.data;
+		err |= put_user(mux.d[0], &events->data[0]);
+		err |= put_user(mux.d[1], &events->data[1]);
+		events++;
+	}
+
+	return err ? -EFAULT: ret;	
+}
+
+
+#ifdef TIF_RESTORE_SIGMASK
+
+static long __sys_epoll_pwait(int epfd, void __user *events, int maxevents,
+			      int timeout, const compat_sigset_t __user *sigmask,
+			      compat_size_t sigsetsize,
+			      long (asmlinkage *proc)(int, void __user *, int, int))
+{
+	long err;
+	compat_sigset_t ss32;
+	sigset_t ksigmask, sigsaved;
+
+	/*
+	 * If the caller wants a certain signal mask to be set during the wait,
+	 * we apply it here.
+	 */
+	if (sigmask) {
+		if (sigsetsize != sizeof(compat_sigset_t))
+			return -EINVAL;
+		if (copy_from_user(&ss32, sigmask, sizeof(ss32)))
+			return -EFAULT;
+		sigset_from_compat(&ksigmask, &ss32);
+		sigdelsetmask(&ksigmask, sigmask(SIGKILL) | sigmask(SIGSTOP));
+		sigprocmask(SIG_SETMASK, &ksigmask, &sigsaved);		
+	}
+
+	err = (*proc)(epfd, events, maxevents, timeout);
+
+	/*
+	 * If we changed the signal mask, we need to restore the original one.
+	 * In case we've got a signal while waiting, we do not restore the 
+	 * signal mask yet, and we allow do_signal() to deliver the signal on the way 
+	 * back to userspace, before the signal mask is restored.
+	 */
+	if (sigmask) {
+		if (err == -EINTR) {
+			memcpy(&current->saved_sigmask, &sigsaved, 
+			       sizeof(sigsaved));
+			set_thread_flag(TIF_RESTORE_SIGMASK);
+		} else
+			sigprocmask(SIG_SETMASK, &sigsaved, NULL);
+	}
+
+	return err;	
+}
+
+
+/*
+ * Architectures that does not need "struct epoll_event" translation
+ * should wire compat_sys_epoll_pwait. The ones that needs "struct epoll_event"
+ * translation, should wire compat_sys_epoll_pwait2. An architecture needs
+ * "struct epoll_event" translation is alignof(u64) in 32 bits mode is 4, and
+ * alignof(u64) in 64 bits mode is 8.
+ */
+asmlinkage long compat_sys_epoll_pwait(int epfd, struct epoll_event __user *events,
+				       int maxevents, int timeout,
+				       const compat_sigset_t __user *sigmask,
+				       compat_size_t sigsetsize)
+{
+	return __sys_epoll_pwait(epfd, events, maxevents, timeout, sigmask, sigsetsize,
+				 (long (asmlinkage *)(int, void __user *, int, int)) sys_epoll_wait);
+}
+
+
+asmlinkage long compat_sys_epoll_pwait2(int epfd, struct compat_epoll_event __user *events,
+				       int maxevents, int timeout,
+				       const compat_sigset_t __user *sigmask,
+				       compat_size_t sigsetsize)
+{
+	return __sys_epoll_pwait(epfd, events, maxevents, timeout, sigmask, sigsetsize,
+				 (long (asmlinkage *)(int, void __user *, int, int)) compat_sys_epoll_wait);
+}
+
+#endif /* #ifdef TIF_RESTORE_SIGMASK */
+
+#endif /* #ifdef CONFIG_EPOLL */
+

