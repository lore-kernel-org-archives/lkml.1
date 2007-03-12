Return-Path: <linux-kernel-owner+w=401wt.eu-S1752590AbXCLTUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbXCLTUw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 15:20:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752550AbXCLTUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 15:20:00 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:33792 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbXCLTTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 15:19:39 -0400
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 12 Mar 2007 12:19:27 -0700
Subject: [patch 9/9] signalfd/timerfd v4 - timerfd compat code ...
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.5142.1173727173.9>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implement the necessary compat code for the timerfd system call.


Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide



Index: linux-2.6.20.ep2/fs/compat.c
===================================================================
--- linux-2.6.20.ep2.orig/fs/compat.c	2007-03-12 11:28:03.000000000 -0700
+++ linux-2.6.20.ep2/fs/compat.c	2007-03-12 11:47:46.000000000 -0700
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
Index: linux-2.6.20.ep2/include/linux/compat.h
===================================================================
--- linux-2.6.20.ep2.orig/include/linux/compat.h	2007-03-12 11:28:03.000000000 -0700
+++ linux-2.6.20.ep2/include/linux/compat.h	2007-03-12 11:47:46.000000000 -0700
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
Index: linux-2.6.20.ep2/kernel/compat.c
===================================================================
--- linux-2.6.20.ep2.orig/kernel/compat.c	2007-03-12 11:28:03.000000000 -0700
+++ linux-2.6.20.ep2/kernel/compat.c	2007-03-12 11:47:46.000000000 -0700
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

