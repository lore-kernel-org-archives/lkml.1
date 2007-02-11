Return-Path: <linux-kernel-owner+w=401wt.eu-S1750819AbXBKUP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750819AbXBKUP2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 15:15:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750825AbXBKUP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 15:15:28 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:4292 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbXBKUP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 15:15:27 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sun, 11 Feb 2007 12:15:24 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [patch] add epoll compat code to kernel/compat.c ...
Message-ID: <Pine.LNX.4.64.0702111155180.24568@alien.or.mcafeemobile.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Add epoll compat_ code to kernel/compat.c. IA64 and ARM-OABI are currently 
using their own version of epoll compat_ code and they could probably wire 
to the new common code. Patch over 2.6.20.


Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide



diff -Nru linux-2.6.20/fs/eventpoll.c linux-2.6.20.mod/fs/eventpoll.c
--- linux-2.6.20/fs/eventpoll.c	2007-02-04 10:44:54.000000000 -0800
+++ linux-2.6.20.mod/fs/eventpoll.c	2007-02-11 12:03:50.000000000 -0800
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
+++ linux-2.6.20.mod/include/linux/compat.h	2007-02-11 12:03:50.000000000 -0800
@@ -234,5 +234,22 @@
 		compat_ulong_t maxnode, const compat_ulong_t __user *old_nodes,
 		const compat_ulong_t __user *new_nodes);
 
+/*
+ * epoll (fs/eventpoll.c) compat bits follow ...
+ */
+struct compat_epoll_event {
+	u32 events;
+	u32 data[2];
+};
+
+asmlinkage long compat_sys_epoll_ctl(int epfd, int op, int fd,
+				     struct compat_epoll_event __user *event);
+asmlinkage long compat_sys_epoll_wait(int epfd, struct compat_epoll_event __user *events,
+				      int maxevents, int timeout);
+asmlinkage long compat_sys_epoll_pwait(int epfd, struct compat_epoll_event __user *events,
+				       int maxevents, int timeout,
+				       const compat_sigset_t __user *sigmask,
+				       compat_size_t sigsetsize);
+
 #endif /* CONFIG_COMPAT */
 #endif /* _LINUX_COMPAT_H */
diff -Nru linux-2.6.20/kernel/compat.c linux-2.6.20.mod/kernel/compat.c
--- linux-2.6.20/kernel/compat.c	2007-02-04 10:44:54.000000000 -0800
+++ linux-2.6.20.mod/kernel/compat.c	2007-02-11 12:13:08.000000000 -0800
@@ -23,6 +23,7 @@
 #include <linux/timex.h>
 #include <linux/migrate.h>
 #include <linux/posix-timers.h>
+#include <linux/eventpoll.h>
 
 #include <asm/uaccess.h>
 
@@ -1016,3 +1017,157 @@
 	return sys_migrate_pages(pid, nr_bits + 1, old, new);
 }
 #endif
+
+
+#ifdef CONFIG_EPOLL
+
+/*
+ * epoll (fs/eventpoll.c) compat functions follow ...
+ *
+ *
+ * We need the compat layer over the epoll_event structure, only if the offset
+ * of the __u64 data member is not 4 (size of the events member that precedes the
+ * data one).
+ */
+#define EPOLL_NEED_EVENT_COMPAT() (offsetof(struct epoll_event, data) != 4)
+
+
+asmlinkage long compat_sys_epoll_ctl(int epfd, int op, int fd,
+				     struct compat_epoll_event __user *event)
+{
+	long ret;
+
+	/*
+	 * If compat is not needed, this simply map to a jump to sys_epoll_ctl(),
+	 * with the "else" code being dropped by GCC.
+	 */
+	if (!EPOLL_NEED_EVENT_COMPAT() || op == EPOLL_CTL_DEL)
+		ret = sys_epoll_ctl(epfd, op, fd, (struct epoll_event __user *) event);
+	else {
+		struct compat_epoll_event user;
+		struct epoll_event __user *kernel;
+		union {
+			u64 q;
+			u32 d[2];
+		} mux;
+
+		/*
+		 * The "event" pointer may be NULL in the EPOLL_CTL_DEL case,
+		 * but we handle such case above, so here we know "event" should
+		 * not be NULL.
+		 */
+		if (copy_from_user(&user, event, sizeof(user)))
+			return -EFAULT;
+		kernel = compat_alloc_user_space(sizeof(struct epoll_event));
+		ret = __put_user(user.events, &kernel->events);
+		mux.d[0] = user.data[0];
+		mux.d[1] = user.data[1];
+		if ((ret |= __put_user(mux.q, &kernel->data)) == 0)
+			ret = sys_epoll_ctl(epfd, op, fd, kernel);
+	}
+	
+	return ret;
+}
+
+
+asmlinkage long compat_sys_epoll_wait(int epfd, struct compat_epoll_event __user *events,
+				      int maxevents, int timeout)
+{
+	long ret;
+
+	/*
+	 * The compat_sys_epoll_pwait() function is calling this one. We do need a
+	 * compat function for sys_epoll_pwait() due to the sigset_t size, but not
+	 * every architecture might need a compat layer over sys_epoll_wait().
+	 * With the compile-time test below, a call to compat_sys_epoll_wait() that does
+	 * not need a translation, will map directly to sys_epoll_wait() avoiding the
+	 * double buffer copy for events (that might indeed blow cache and kill
+	 * performance). GCC takes care of removing the unused code (being the condition
+	 * known at compile-time), and issues a simple jump to sys_epoll_wait().
+	 */
+	if (EPOLL_NEED_EVENT_COMPAT()) {
+		struct epoll_event __user *kbuf;
+		struct epoll_event ev;
+		long err, i;
+		union {
+			u64 q;
+			u32 d[2];
+		} mux;
+
+		if (maxevents <= 0 || maxevents > (INT_MAX / sizeof(struct epoll_event)))
+			return -EINVAL;
+		kbuf = compat_alloc_user_space(sizeof(struct epoll_event) * maxevents);
+		ret = sys_epoll_wait(epfd, kbuf, maxevents, timeout);
+		err = 0;
+		for (i = 0; i < ret; i++) {
+			err |= __get_user(ev.events, &kbuf[i].events);
+			err |= __get_user(ev.data, &kbuf[i].data);
+			err |= put_user(ev.events, &events->events);
+			mux.q = ev.data;
+			err |= put_user(mux.d[0], &events->data[0]);
+			err |= put_user(mux.d[1], &events->data[1]);
+			events++;
+		}
+		ret = err ? -EFAULT: ret;	
+	} else
+		ret = sys_epoll_wait(epfd, (struct epoll_event __user *) events,
+				     maxevents, timeout);
+
+	return ret;
+}
+
+
+#ifdef TIF_RESTORE_SIGMASK
+
+asmlinkage long compat_sys_epoll_pwait(int epfd, struct compat_epoll_event __user *events,
+				       int maxevents, int timeout,
+				       const compat_sigset_t __user *sigmask,
+				       compat_size_t sigsetsize)
+{
+	int error;
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
+	/* Compile-time switch ... */
+	if (EPOLL_NEED_EVENT_COMPAT())
+		error = compat_sys_epoll_wait(epfd, events, maxevents, timeout);
+	else
+		error = sys_epoll_wait(epfd, (struct epoll_event __user *) events,
+				       maxevents, timeout);
+
+	/*
+	 * If we changed the signal mask, we need to restore the original one.
+	 * In case we've got a signal while waiting, we do not restore the 
+	 * signal mask yet, and we allow do_signal() to deliver the signal on the way 
+	 * back to userspace, before the signal mask is restored.
+	 */
+	if (sigmask) {
+		if (error == -EINTR) {
+			memcpy(&current->saved_sigmask, &sigsaved, 
+			       sizeof(sigsaved));
+			set_thread_flag(TIF_RESTORE_SIGMASK);
+		} else
+			sigprocmask(SIG_SETMASK, &sigsaved, NULL);
+	}
+
+	return error;	
+}
+
+#endif /* #ifdef TIF_RESTORE_SIGMASK */
+
+#endif /* #ifdef CONFIG_EPOLL */
+
