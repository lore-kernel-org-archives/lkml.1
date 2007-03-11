Return-Path: <linux-kernel-owner+w=401wt.eu-S932739AbXCKCX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932739AbXCKCX4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 21:23:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932719AbXCKCXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 21:23:15 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:46920 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932722AbXCKCXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 21:23:04 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sat, 10 Mar 2007 18:23:02 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [patch 9/9] signalfd/timerfd - timerfd compat code ...
Message-ID: <Pine.LNX.4.64.0703101822570.3613@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implement the necessary compat code for the timerfd system call.


Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide



Index: linux-2.6.20.ep2/fs/compat.c
===================================================================
--- linux-2.6.20.ep2.orig/fs/compat.c	2007-03-10 15:58:03.000000000 -0800
+++ linux-2.6.20.ep2/fs/compat.c	2007-03-10 15:58:12.000000000 -0800
@@ -2257,3 +2257,23 @@
 	return sys_signalfd(ufd, ksigmask, sizeof(sigset_t));
 }
 
+
+asmlinkage long compat_sys_timerfd(int ufd, int clockid, int tmrtype,
+				   const struct compat_timespec __user *utmr)
+{
+	long res;
+	struct timespec t;
+	struct timespec __user *ut;
+
+	res = -EFAULT;
+	if (get_compat_timespec(&t, utmr))
+		goto err_exit;
+	ut = compat_alloc_user_space(sizeof(*ut));
+	if (copy_to_user(ut, &t, sizeof(t)) )
+		goto err_exit;
+
+	res = sys_timerfd(ufd, clockid, tmrtype, ut);
+err_exit:
+	return res;
+}
+
