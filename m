Return-Path: <linux-kernel-owner+w=401wt.eu-S1753696AbZBHUrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696AbZBHUrO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 15:47:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753368AbZBHUq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 15:46:58 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:56667 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348AbZBHUq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 15:46:57 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sun, 8 Feb 2009 12:46:53 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Michael Kerrisk <mtk.manpages@gmail.com>
cc: "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Why does timerfd() only support CLOCK_REALTIME and
 CLOCK_MONOTONIC?
In-Reply-To: <alpine.DEB.1.10.0902081127510.18839@alien.or.mcafeemobile.com>
Message-ID: <alpine.DEB.1.10.0902081245560.18839@alien.or.mcafeemobile.com>
References: <cfd18e0f0902081025t3fe333ev1616af990e6d19ce@mail.gmail.com> <alpine.DEB.1.10.0902081127510.18839@alien.or.mcafeemobile.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Feb 2009, Davide Libenzi wrote:

> On Mon, 9 Feb 2009, Michael Kerrisk wrote:
> 
> > Hi Davide,
> > 
> > At the moment I'm looking into writing man pages for timer_create(2)
> > and friends.  (Somewhat bizarrely, these pages do not yet exist.)  As
> > I looked into the source code of timer_create(), etc., and did some
> > tests, I saw that timer_create() supports the following clocks:
> > 
> > TIMER_REALTIME
> > TIMER_MONOTONIC
> > TIMER_PROCESS_CPUTIME_ID
> > TIMER_THREAD_CPUTIME_ID
> > clockid obtained from clock_getcpuclockid(3)
> > clockid obtained from pthread_getcpuclockid(3)
> > 
> > On the other hand, timerfd() only permits the first two of these.
> > What's the reason for that limitation of timerfd()?  (It may be worth
> > adding something to the man page on this point.)
> 
> No particular reason I can think of. If Thomas makes invalid_clockid() 
> available, we could allow timerfd() to support all time timers 
> timer_create() supports.
> Do you see any reason why this won't work Thomas?

Patch, not tested, below.



- Davide


---
 fs/timerfd.c                 |   10 ++++------
 include/linux/posix-timers.h |    1 +
 include/linux/timerfd.h      |   13 ++++++++++---
 kernel/posix-timers.c        |    2 +-
 4 files changed, 16 insertions(+), 10 deletions(-)

Index: linux-2.6.mod/fs/timerfd.c
===================================================================
--- linux-2.6.mod.orig/fs/timerfd.c	2009-02-08 12:32:25.000000000 -0800
+++ linux-2.6.mod/fs/timerfd.c	2009-02-08 12:43:57.000000000 -0800
@@ -18,6 +18,7 @@
 #include <linux/spinlock.h>
 #include <linux/time.h>
 #include <linux/hrtimer.h>
+#include <linux/posix-timers.h>
 #include <linux/anon_inodes.h>
 #include <linux/timerfd.h>
 #include <linux/syscalls.h>
@@ -186,12 +187,9 @@ SYSCALL_DEFINE2(timerfd_create, int, clo
 	BUILD_BUG_ON(TFD_CLOEXEC != O_CLOEXEC);
 	BUILD_BUG_ON(TFD_NONBLOCK != O_NONBLOCK);
 
-	if (flags & ~(TFD_CLOEXEC | TFD_NONBLOCK))
+	if ((flags & ~TFD_FLAGS_SET) ||
+	    invalid_clockid(clockid))
 		return -EINVAL;
-	if (clockid != CLOCK_MONOTONIC &&
-	    clockid != CLOCK_REALTIME)
-		return -EINVAL;
-
 	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
 	if (!ctx)
 		return -ENOMEM;
@@ -201,7 +199,7 @@ SYSCALL_DEFINE2(timerfd_create, int, clo
 	hrtimer_init(&ctx->tmr, clockid, HRTIMER_MODE_ABS);
 
 	ufd = anon_inode_getfd("[timerfd]", &timerfd_fops, ctx,
-			       flags & (O_CLOEXEC | O_NONBLOCK));
+			       flags & TFD_SHARED_FCNTL_FLAGS);
 	if (ufd < 0)
 		kfree(ctx);
 
Index: linux-2.6.mod/include/linux/posix-timers.h
===================================================================
--- linux-2.6.mod.orig/include/linux/posix-timers.h	2009-02-08 12:32:25.000000000 -0800
+++ linux-2.6.mod/include/linux/posix-timers.h	2009-02-08 12:33:12.000000000 -0800
@@ -84,6 +84,7 @@ struct k_clock {
 			   struct itimerspec * cur_setting);
 };
 
+int invalid_clockid(const clockid_t which_clock);
 void register_posix_clock(const clockid_t clock_id, struct k_clock *new_clock);
 
 /* error handlers for timer_create, nanosleep and settime */
Index: linux-2.6.mod/kernel/posix-timers.c
===================================================================
--- linux-2.6.mod.orig/kernel/posix-timers.c	2009-02-08 12:32:25.000000000 -0800
+++ linux-2.6.mod/kernel/posix-timers.c	2009-02-08 12:32:57.000000000 -0800
@@ -205,7 +205,7 @@ static int no_timer_create(struct k_itim
 /*
  * Return nonzero if we know a priori this clockid_t value is bogus.
  */
-static inline int invalid_clockid(const clockid_t which_clock)
+int invalid_clockid(const clockid_t which_clock)
 {
 	if (which_clock < 0)	/* CPU clock, posix_cpu_* will check it */
 		return 0;
Index: linux-2.6.mod/include/linux/timerfd.h
===================================================================
--- linux-2.6.mod.orig/include/linux/timerfd.h	2009-02-08 12:34:25.000000000 -0800
+++ linux-2.6.mod/include/linux/timerfd.h	2009-02-08 12:36:09.000000000 -0800
@@ -11,13 +11,20 @@
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
 
+#define TFD_SHARED_FCNTL_FLAGS (O_CLOEXEC | O_NONBLOCK)
+#define TFD_FLAGS_SET (TFD_SHARED_FCNTL_FLAGS | TFD_TIMER_ABSTIME)
+
 
 #endif /* _LINUX_TIMERFD_H */
 
