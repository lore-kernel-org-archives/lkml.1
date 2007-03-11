Return-Path: <linux-kernel-owner+w=401wt.eu-S932658AbXCKCXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932658AbXCKCXP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 21:23:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932719AbXCKCWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 21:22:47 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:46901 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932658AbXCKCWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 21:22:31 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sat, 10 Mar 2007 18:22:30 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: [patch 5/9] signalfd/timerfd - signalfd compat code ...
Message-ID: <Pine.LNX.4.64.0703101822260.3613@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implement the necessary compat code for the signalfd system call.


Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide



Index: linux-2.6.20.ep2/fs/compat.c
===================================================================
--- linux-2.6.20.ep2.orig/fs/compat.c	2007-03-10 15:57:00.000000000 -0800
+++ linux-2.6.20.ep2/fs/compat.c	2007-03-10 15:58:03.000000000 -0800
@@ -46,6 +46,7 @@
 #include <linux/rwsem.h>
 #include <linux/tsacct_kern.h>
 #include <linux/highmem.h>
+#include <linux/signal.h>
 #include <linux/poll.h>
 #include <linux/mm.h>
 
@@ -2235,3 +2236,24 @@
 	return sys_ni_syscall();
 }
 #endif
+
+asmlinkage long compat_sys_signalfd(int ufd,
+				    const compat_sigset_t __user *sigmask,
+				    compat_size_t sigsetsize)
+{
+	compat_sigset_t ss32;
+	sigset_t tmp;
+	sigset_t __user *ksigmask;
+
+	if (sigsetsize != sizeof(compat_sigset_t))
+		return -EINVAL;
+	if (copy_from_user(&ss32, sigmask, sizeof(ss32)))
+		return -EFAULT;
+	sigset_from_compat(&tmp, &ss32);
+	ksigmask = compat_alloc_user_space(sizeof(sigset_t));
+	if (copy_to_user(ksigmask, &tmp, sizeof(sigset_t)))
+		return -EFAULT;
+
+	return sys_signalfd(ufd, ksigmask, sizeof(sigset_t));
+}
+
