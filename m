Return-Path: <linux-kernel-owner+w=401wt.eu-S932953AbXCHBWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932953AbXCHBWr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 20:22:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932945AbXCHBWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 20:22:46 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:42814 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992818AbXCHBWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 20:22:22 -0500
X-AuthUser: davidel@xmailserver.org
Date: Wed, 7 Mar 2007 17:22:21 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [patch 5/5] signalfd v2 - compat code ...
Message-ID: <Pine.LNX.4.64.0703071716040.3672@alien.or.mcafeemobile.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implement the necessary compat code for the signalfd system calls.


Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide



Index: linux-2.6.20.ep2/fs/compat.c
===================================================================
--- linux-2.6.20.ep2.orig/fs/compat.c	2007-03-07 13:28:39.000000000 -0800
+++ linux-2.6.20.ep2/fs/compat.c	2007-03-07 13:42:18.000000000 -0800
@@ -46,6 +46,7 @@
 #include <linux/rwsem.h>
 #include <linux/tsacct_kern.h>
 #include <linux/highmem.h>
+#include <linux/signal.h>
 #include <linux/poll.h>
 #include <linux/mm.h>
 
@@ -2235,3 +2236,41 @@
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
+asmlinkage long compat_sys_signalfd_dequeue(int fd,
+					    struct compat_siginfo __user *info,
+					    long timeo)
+{
+	siginfo_t kinfo;
+	long ret;
+	mm_segment_t old_fs = get_fs();
+
+	set_fs(KERNEL_DS);
+	ret = sys_signalfd_dequeue(fd, (siginfo_t __user *) &kinfo, timeo);
+	set_fs(old_fs);
+	if (!ret)
+		ret = copy_siginfo_to_user32(info, &kinfo);
+
+	return ret;
+}
+
