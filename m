Return-Path: <linux-kernel-owner+w=401wt.eu-S932710AbXCGBiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932710AbXCGBiA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 20:38:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932767AbXCGBiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 20:38:00 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:42322 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932710AbXCGBhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 20:37:51 -0500
X-AuthUser: davidel@xmailserver.org
Date: Tue, 6 Mar 2007 17:37:50 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [patch 4/4] signalfd v1 - compat code ...
Message-ID: <Pine.LNX.4.64.0703061711460.3661@alien.or.mcafeemobile.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The new signalfd system call requires compat code for the sigset_t. This 
patch implements it in fs/compat.c



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>



- Davide


fs/compat.c |   20 ++++++++++++++++++++
1 file changed, 20 insertions(+)



Index: linux-2.6.20.ep2/fs/compat.c
===================================================================
--- linux-2.6.20.ep2.orig/fs/compat.c	2007-03-06 17:22:33.000000000 -0800
+++ linux-2.6.20.ep2/fs/compat.c	2007-03-06 17:23:37.000000000 -0800
@@ -2235,3 +2235,23 @@
 	return sys_ni_syscall();
 }
 #endif
+
+asmlinkage long compat_sys_signalfd(int ufd, const compat_sigset_t __user *sigmask,
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
