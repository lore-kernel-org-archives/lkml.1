Return-Path: <linux-kernel-owner+w=401wt.eu-S966041AbXDBWti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966041AbXDBWti (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 18:49:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966045AbXDBWrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 18:47:17 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:50556 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966044AbXDBWqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 18:46:43 -0400
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 02 Apr 2007 15:46:31 -0700
Subject: [patch 9/13] signal/timer/event fds v10 - timerfd compat code ...
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.10599.1175553995.9>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implement the necessary compat code for the timerfd system call.


Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide



Index: linux-2.6.21-rc5.fds/fs/compat.c
===================================================================
--- linux-2.6.21-rc5.fds.orig/fs/compat.c	2007-04-02 15:06:36.000000000 -0700
+++ linux-2.6.21-rc5.fds/fs/compat.c	2007-04-02 15:06:41.000000000 -0700
@@ -2361,3 +2361,26 @@
 
 #endif /* CONFIG_SIGNALFD */
 
+#ifdef CONFIG_TIMERFD
+
+asmlinkage long compat_sys_timerfd(int ufd, int clockid, int flags,
+				   const struct compat_itimerspec __user *utmr)
+{
+	long res;
+	struct itimerspec t;
+	struct itimerspec __user *ut;
+
+	res = -EFAULT;
+	if (get_compat_itimerspec(&t, utmr))
+		goto err_exit;
+	ut = compat_alloc_user_space(sizeof(*ut));
+	if (copy_to_user(ut, &t, sizeof(t)) )
+		goto err_exit;
+
+	res = sys_timerfd(ufd, clockid, flags, ut);
+err_exit:
+	return res;
+}
+
+#endif /* CONFIG_TIMERFD */
+
Index: linux-2.6.21-rc5.fds/include/linux/compat.h
===================================================================
--- linux-2.6.21-rc5.fds.orig/include/linux/compat.h	2007-04-02 15:06:12.000000000 -0700
+++ linux-2.6.21-rc5.fds/include/linux/compat.h	2007-04-02 15:06:41.000000000 -0700
@@ -225,6 +225,11 @@
 	return lhs->tv_nsec - rhs->tv_nsec;
 }
 
+extern int get_compat_itimerspec(struct itimerspec *dst,
+				 const struct compat_itimerspec __user *src);
+extern int put_compat_itimerspec(struct compat_itimerspec __user *dst,
+				 const struct itimerspec *src);
+
 asmlinkage long compat_sys_adjtimex(struct compat_timex __user *utp);
 
 extern int compat_printk(const char *fmt, ...);
Index: linux-2.6.21-rc5.fds/kernel/compat.c
===================================================================
--- linux-2.6.21-rc5.fds.orig/kernel/compat.c	2007-04-02 15:06:12.000000000 -0700
+++ linux-2.6.21-rc5.fds/kernel/compat.c	2007-04-02 15:06:41.000000000 -0700
@@ -475,8 +475,8 @@
 	return min_length;
 }
 
-static int get_compat_itimerspec(struct itimerspec *dst, 
-				 struct compat_itimerspec __user *src)
+int get_compat_itimerspec(struct itimerspec *dst,
+			  const struct compat_itimerspec __user *src)
 { 
 	if (get_compat_timespec(&dst->it_interval, &src->it_interval) ||
 	    get_compat_timespec(&dst->it_value, &src->it_value))
@@ -484,8 +484,8 @@
 	return 0;
 } 
 
-static int put_compat_itimerspec(struct compat_itimerspec __user *dst, 
-				 struct itimerspec *src)
+int put_compat_itimerspec(struct compat_itimerspec __user *dst,
+			  const struct itimerspec *src)
 { 
 	if (put_compat_timespec(&src->it_interval, &dst->it_interval) ||
 	    put_compat_timespec(&src->it_value, &dst->it_value))

