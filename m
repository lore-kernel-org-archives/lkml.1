Return-Path: <linux-kernel-owner+w=401wt.eu-S1755405AbZBIXbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405AbZBIXbf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 18:31:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751786AbZBIXb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 18:31:26 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:58103 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbZBIXb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 18:31:26 -0500
X-AuthUser: davidel@xmailserver.org
Date: Mon, 9 Feb 2009 15:31:24 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Michael Kerrisk <mtk.manpages@gmail.com>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [patch] timerfd add flags check
Message-ID: <alpine.DEB.1.10.0902091525590.8503@alien.or.mcafeemobile.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Like Michael requested, this patch adds a missing check for valid flags in 
timerfd_settime(), and make it return EINVAL in case some extra bits are 
set.

Michael said:
If this is to be any use to userland apps that want to check flag
support (perhaps it is too late already), then the sooner we get it
into the kernel the better: 2.6.29 would be good; earlier stables as
well would be even better.

Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>


Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


---
 fs/timerfd.c            |   12 ++++++------
 include/linux/timerfd.h |   17 ++++++++++++++---
 2 files changed, 20 insertions(+), 9 deletions(-)

Index: linux-2.6.mod/fs/timerfd.c
===================================================================
--- linux-2.6.mod.orig/fs/timerfd.c	2009-02-08 18:36:45.000000000 -0800
+++ linux-2.6.mod/fs/timerfd.c	2009-02-08 18:53:32.000000000 -0800
@@ -186,10 +186,9 @@ SYSCALL_DEFINE2(timerfd_create, int, clo
 	BUILD_BUG_ON(TFD_CLOEXEC != O_CLOEXEC);
 	BUILD_BUG_ON(TFD_NONBLOCK != O_NONBLOCK);
 
-	if (flags & ~(TFD_CLOEXEC | TFD_NONBLOCK))
-		return -EINVAL;
-	if (clockid != CLOCK_MONOTONIC &&
-	    clockid != CLOCK_REALTIME)
+	if ((flags & ~TFD_CREATE_FLAGS) ||
+	    (clockid != CLOCK_MONOTONIC &&
+	     clockid != CLOCK_REALTIME))
 		return -EINVAL;
 
 	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
@@ -201,7 +200,7 @@ SYSCALL_DEFINE2(timerfd_create, int, clo
 	hrtimer_init(&ctx->tmr, clockid, HRTIMER_MODE_ABS);
 
 	ufd = anon_inode_getfd("[timerfd]", &timerfd_fops, ctx,
-			       flags & (O_CLOEXEC | O_NONBLOCK));
+			       flags & TFD_SHARED_FCNTL_FLAGS);
 	if (ufd < 0)
 		kfree(ctx);
 
@@ -219,7 +218,8 @@ SYSCALL_DEFINE4(timerfd_settime, int, uf
 	if (copy_from_user(&ktmr, utmr, sizeof(ktmr)))
 		return -EFAULT;
 
-	if (!timespec_valid(&ktmr.it_value) ||
+	if ((flags & ~TFD_SETTIME_FLAGS) ||
+	    !timespec_valid(&ktmr.it_value) ||
 	    !timespec_valid(&ktmr.it_interval))
 		return -EINVAL;
 
Index: linux-2.6.mod/include/linux/timerfd.h
===================================================================
--- linux-2.6.mod.orig/include/linux/timerfd.h	2009-02-08 18:36:45.000000000 -0800
+++ linux-2.6.mod/include/linux/timerfd.h	2009-02-08 18:41:22.000000000 -0800
@@ -11,13 +11,24 @@
 /* For O_CLOEXEC and O_NONBLOCK */
 #include <linux/fcntl.h>
 
-/* Flags for timerfd_settime.  */
+/*
+ * CAREFUL: Check include/asm-generic/fcntl.h when defining
+ * new flags, since they might collide with O_* ones. We want
+ * to re-use O_* flags that couldn't possibly have a meaning
+ * from eventfd, in order to leave a free define-space for
+ * shared O_* flags.
+ */
 #define TFD_TIMER_ABSTIME (1 << 0)
-
-/* Flags for timerfd_create.  */
 #define TFD_CLOEXEC O_CLOEXEC
 #define TFD_NONBLOCK O_NONBLOCK
 
+#define TFD_SHARED_FCNTL_FLAGS (TFD_CLOEXEC | TFD_NONBLOCK)
+/* Flags for timerfd_create.  */
+#define TFD_CREATE_FLAGS TFD_SHARED_FCNTL_FLAGS
+/* Flags for timerfd_settime.  */
+#define TFD_SETTIME_FLAGS TFD_TIMER_ABSTIME
+#define TFD_FLAGS_SET (TFD_SHARED_FCNTL_FLAGS | TFD_TIMER_ABSTIME)
+
 
 #endif /* _LINUX_TIMERFD_H */
 
