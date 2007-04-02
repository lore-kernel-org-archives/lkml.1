Return-Path: <linux-kernel-owner+w=401wt.eu-S966038AbXDBWsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966038AbXDBWsY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 18:48:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966032AbXDBWr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 18:47:26 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:50529 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966039AbXDBWqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 18:46:35 -0400
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
Date: Mon, 02 Apr 2007 15:46:31 -0700
Subject: [patch 5/13] signal/timer/event fds v10 - signalfd compat code ...
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.10599.1175553994.5>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implement the necessary compat code for the signalfd system call.


Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide



Index: linux-2.6.21-rc5.fds/fs/compat.c
===================================================================
--- linux-2.6.21-rc5.fds.orig/fs/compat.c	2007-04-02 15:06:12.000000000 -0700
+++ linux-2.6.21-rc5.fds/fs/compat.c	2007-04-02 15:06:36.000000000 -0700
@@ -46,6 +46,7 @@
 #include <linux/rwsem.h>
 #include <linux/tsacct_kern.h>
 #include <linux/highmem.h>
+#include <linux/signal.h>
 #include <linux/poll.h>
 #include <linux/mm.h>
 #include <linux/eventpoll.h>
@@ -2335,3 +2336,28 @@
 #endif /* TIF_RESTORE_SIGMASK */
 
 #endif /* CONFIG_EPOLL */
+
+#ifdef CONFIG_SIGNALFD
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
+#endif /* CONFIG_SIGNALFD */
+

