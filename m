Return-Path: <linux-kernel-owner+w=401wt.eu-S1758071AbZCNBXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758071AbZCNBXI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 21:23:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751659AbZCNBTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:19:50 -0400
Received: from kroah.org ([198.145.64.141]:34792 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752159AbZCNBTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:19:49 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:32 2009
Message-Id: <20090314011032.458313124@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:09:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Michael Kerrisk <mtk.manpages@gmail.com>,
       Davide Libenzi <davidel@xmailserver.org>
Subject: [patch 008/114] timerfd: add flags check
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=timerfd-add-flags-check.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Davide Libenzi <davidel@xmailserver.org>

commit 610d18f4128ebbd88845d0fc60cce67b49af881e upstream.

As requested by Michael, add a missing check for valid flags in
timerfd_settime(), and make it return EINVAL in case some extra bits are
set.

Michael said:
If this is to be any use to userland apps that want to check flag
support (perhaps it is too late already), then the sooner we get it
into the kernel the better: 2.6.29 would be good; earlier stables as
well would be even better.

[akpm@linux-foundation.org: remove unused TFD_FLAGS_SET]
Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/timerfd.c            |   12 ++++++------
 include/linux/timerfd.h |   16 ++++++++++++----
 2 files changed, 18 insertions(+), 10 deletions(-)

--- a/fs/timerfd.c
+++ b/fs/timerfd.c
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
 
--- a/include/linux/timerfd.h
+++ b/include/linux/timerfd.h
@@ -11,13 +11,21 @@
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
 
 #endif /* _LINUX_TIMERFD_H */
-


