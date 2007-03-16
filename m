Return-Path: <linux-kernel-owner+w=401wt.eu-S1753403AbXCPA1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403AbXCPA1e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 20:27:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753473AbXCPA1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 20:27:09 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:47082 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476AbXCPA0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 20:26:34 -0400
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 15 Mar 2007 17:22:15 -0700
Subject: [patch 9/13] signal/timer/event fds v6 - timerfd compat code ...
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.9367.1174004540.9>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implement the necessary compat code for the timerfd system call.


Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide



Index: linux-2.6.21-rc3.quilt/fs/compat.c
===================================================================
--- linux-2.6.21-rc3.quilt.orig/fs/compat.c	2007-03-15 15:53:11.000000000 -0700
+++ linux-2.6.21-rc3.quilt/fs/compat.c	2007-03-15 16:11:52.000000000 -0700
@@ -2257,3 +2257,23 @@
 	return sys_signalfd(ufd, ksigmask, sizeof(sigset_t));
 }
 
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
Index: linux-2.6.21-rc3.quilt/include/linux/compat.h
===================================================================
--- linux-2.6.21-rc3.quilt.orig/include/linux/compat.h	2007-03-15 15:53:11.000000000 -0700
+++ linux-2.6.21-rc3.quilt/include/linux/compat.h	2007-03-15 16:11:52.000000000 -0700
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
Index: linux-2.6.21-rc3.quilt/kernel/compat.c
===================================================================
--- linux-2.6.21-rc3.quilt.orig/kernel/compat.c	2007-03-15 15:53:11.000000000 -0700
+++ linux-2.6.21-rc3.quilt/kernel/compat.c	2007-03-15 16:11:52.000000000 -0700
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

