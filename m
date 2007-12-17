Return-Path: <linux-kernel-owner+w=401wt.eu-S937406AbXLQUUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937406AbXLQUUu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 15:20:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753590AbXLQUUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 15:20:34 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:36715 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756153AbXLQUUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 15:20:32 -0500
X-AuthUser: davidel@xmailserver.org
Date: Mon, 17 Dec 2007 12:20:30 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Michael Kerrisk <mtk-manpages@gmx.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 1/2] timerfd - make hrtimer_forward() to return a u64
Message-ID: <Pine.LNX.4.64.0712171213550.10687@alien.or.mcafeemobile.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes hrtimer_forward() to return a u64 instead of unsigned long.
Since timerfd returns the number of timer ticks in a u64 variable, and
hrtimer_forward() is used to calculate the timer ticks, the patch allow full
64 bit usage even on 32 bit platforms. The core of the hrtimer_forward() ticks
calculation, ktime_divns(), was already having the result in u64 and it was
chopping it to unsigned long.
Andrew, this goes on top of the ones you already have in -mm.



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


---
 fs/timerfd.c            |    6 +++---
 include/linux/hrtimer.h |   10 +++++-----
 kernel/hrtimer.c        |    9 ++++-----
 kernel/posix-timers.c   |    9 +++++----
 4 files changed, 17 insertions(+), 17 deletions(-)

Index: linux-2.6.mod/include/linux/hrtimer.h
===================================================================
--- linux-2.6.mod.orig/include/linux/hrtimer.h	2007-12-13 16:37:36.000000000 -0800
+++ linux-2.6.mod/include/linux/hrtimer.h	2007-12-14 16:05:23.000000000 -0800
@@ -295,12 +295,12 @@
 }
 
 /* Forward a hrtimer so it expires after now: */
-extern unsigned long
+extern u64
 hrtimer_forward(struct hrtimer *timer, ktime_t now, ktime_t interval);
 
 /* Forward a hrtimer so it expires after the hrtimer's current now */
-static inline unsigned long hrtimer_forward_now(struct hrtimer *timer,
-						ktime_t interval)
+static inline u64 hrtimer_forward_now(struct hrtimer *timer,
+				      ktime_t interval)
 {
 	return hrtimer_forward(timer, timer->base->get_time(), interval);
 }
@@ -322,9 +322,9 @@
 extern void __init hrtimers_init(void);
 
 #if BITS_PER_LONG < 64
-extern unsigned long ktime_divns(const ktime_t kt, s64 div);
+extern u64 ktime_divns(const ktime_t kt, s64 div);
 #else /* BITS_PER_LONG < 64 */
-# define ktime_divns(kt, div)		(unsigned long)((kt).tv64 / (div))
+# define ktime_divns(kt, div)		(u64)((kt).tv64 / (div))
 #endif
 
 /* Show pending timers: */
Index: linux-2.6.mod/kernel/hrtimer.c
===================================================================
--- linux-2.6.mod.orig/kernel/hrtimer.c	2007-12-13 16:37:53.000000000 -0800
+++ linux-2.6.mod/kernel/hrtimer.c	2007-12-13 16:41:42.000000000 -0800
@@ -306,7 +306,7 @@
 /*
  * Divide a ktime value by a nanosecond value
  */
-unsigned long ktime_divns(const ktime_t kt, s64 div)
+u64 ktime_divns(const ktime_t kt, s64 div)
 {
 	u64 dclc, inc, dns;
 	int sft = 0;
@@ -321,7 +321,7 @@
 	dclc >>= sft;
 	do_div(dclc, (unsigned long) div);
 
-	return (unsigned long) dclc;
+	return dclc;
 }
 #endif /* BITS_PER_LONG >= 64 */
 
@@ -655,10 +655,9 @@
  * Forward the timer expiry so it will expire in the future.
  * Returns the number of overruns.
  */
-unsigned long
-hrtimer_forward(struct hrtimer *timer, ktime_t now, ktime_t interval)
+u64 hrtimer_forward(struct hrtimer *timer, ktime_t now, ktime_t interval)
 {
-	unsigned long orun = 1;
+	u64 orun = 1;
 	ktime_t delta;
 
 	delta = ktime_sub(now, timer->expires);
Index: linux-2.6.mod/kernel/posix-timers.c
===================================================================
--- linux-2.6.mod.orig/kernel/posix-timers.c	2007-12-13 16:38:15.000000000 -0800
+++ linux-2.6.mod/kernel/posix-timers.c	2007-12-13 16:45:20.000000000 -0800
@@ -256,8 +256,9 @@
 	if (timr->it.real.interval.tv64 == 0)
 		return;
 
-	timr->it_overrun += hrtimer_forward(timer, timer->base->get_time(),
-					    timr->it.real.interval);
+	timr->it_overrun += (unsigned int) hrtimer_forward(timer,
+						timer->base->get_time(),
+						timr->it.real.interval);
 
 	timr->it_overrun_last = timr->it_overrun;
 	timr->it_overrun = -1;
@@ -386,7 +387,7 @@
 					now = ktime_add(now, kj);
 			}
 #endif
-			timr->it_overrun +=
+			timr->it_overrun += (unsigned int)
 				hrtimer_forward(timer, now,
 						timr->it.real.interval);
 			ret = HRTIMER_RESTART;
@@ -662,7 +663,7 @@
 	 */
 	if (iv.tv64 && (timr->it_requeue_pending & REQUEUE_PENDING ||
 	    (timr->it_sigev_notify & ~SIGEV_THREAD_ID) == SIGEV_NONE))
-		timr->it_overrun += hrtimer_forward(timer, now, iv);
+		timr->it_overrun += (unsigned int) hrtimer_forward(timer, now, iv);
 
 	remaining = ktime_sub(timer->expires, now);
 	/* Return 0 only, when the timer is expired and not pending */
Index: linux-2.6.mod/fs/timerfd.c
===================================================================
--- linux-2.6.mod.orig/fs/timerfd.c	2007-12-13 16:49:46.000000000 -0800
+++ linux-2.6.mod/fs/timerfd.c	2007-12-14 16:04:36.000000000 -0800
@@ -134,8 +134,8 @@
 			 * callback to avoid DoS attacks specifying a very
 			 * short timer period.
 			 */
-			ticks += (u64) hrtimer_forward_now(&ctx->tmr,
-							   ctx->tintv) - 1;
+			ticks += hrtimer_forward_now(&ctx->tmr,
+						     ctx->tintv) - 1;
 			hrtimer_restart(&ctx->tmr);
 		}
 		ctx->expired = 0;
@@ -270,7 +270,7 @@
 	spin_lock_irq(&ctx->wqh.lock);
 	if (ctx->expired && ctx->tintv.tv64) {
 		ctx->expired = 0;
-		ctx->ticks += (u64)
+		ctx->ticks +=
 			hrtimer_forward_now(&ctx->tmr, ctx->tintv) - 1;
 		hrtimer_restart(&ctx->tmr);
 	}
