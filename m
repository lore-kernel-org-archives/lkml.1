Return-Path: <linux-kernel-owner+w=401wt.eu-S1767666AbXCIXlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767666AbXCIXlr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 18:41:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767672AbXCIXlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 18:41:47 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:44220 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767666AbXCIXlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 18:41:37 -0500
X-AuthUser: davidel@xmailserver.org
Date: Fri, 9 Mar 2007 15:41:36 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [patch 9/9] signalfd/timerfd v1 - timerfd compat code ...
Message-ID: <Pine.LNX.4.64.0703091538420.3761@alien.or.mcafeemobile.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implement the necessary compat code for the timerfd system call.


Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide



Index: linux-2.6.20.ep2/fs/compat.c
===================================================================
--- linux-2.6.20.ep2.orig/fs/compat.c	2007-03-09 12:56:04.000000000 -0800
+++ linux-2.6.20.ep2/fs/compat.c	2007-03-09 15:36:21.000000000 -0800
@@ -2257,3 +2257,23 @@
 	return sys_signalfd(ufd, ksigmask, sizeof(sigset_t));
 }
 
+
+asmlinkage long compat_sys_timerfd(int ufd, int tmrtype,
+				   const struct timespec __user *utmr)
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
+	res = sys_timerfd(ufd, tmrtype, ut);
+err_exit:
+	return res;
+}
+

