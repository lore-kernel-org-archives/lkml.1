Return-Path: <linux-kernel-owner+w=401wt.eu-S933279AbXCNWZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933279AbXCNWZG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 18:25:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933282AbXCNWYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 18:24:30 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:42391 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269AbXCNWYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 18:24:25 -0400
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
Date: Wed, 14 Mar 2007 15:19:21 -0700
Subject: [patch 5/13] signalfd/timerfd/asyncfd v5 - signalfd compat code ...
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.13805.1173910765.5>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implement the necessary compat code for the signalfd system call.


Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide



Index: linux-2.6.20.ep2/fs/compat.c
===================================================================
--- linux-2.6.20.ep2.orig/fs/compat.c	2007-03-11 14:28:28.000000000 -0700
+++ linux-2.6.20.ep2/fs/compat.c	2007-03-11 14:28:48.000000000 -0700
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

