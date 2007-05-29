Return-Path: <linux-kernel-owner+w=401wt.eu-S1753750AbXE2Vrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750AbXE2Vrx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 17:47:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbXE2Vro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 17:47:44 -0400
Received: from www.osadl.org ([213.239.205.134]:54212 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751336AbXE2Vro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 17:47:44 -0400
Subject: [PATCH] NOHZ: prevent multiplication overflow - stop timer for
	huge timeouts
From: Thomas Gleixner <tglx@linutronix.de>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <465C222A.8060003@googlemail.com>
References: <465C188F.9000900@googlemail.com>
	 <465C222A.8060003@googlemail.com>
Content-Type: text/plain
Date: Tue, 29 May 2007 23:47:39 +0200
Message-Id: <1180475259.20546.26.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

get_next_timer_interrupt() returns a delta of (LONG_MAX > 1) in case
there is no timer pending. On 64 bit machines this results in a
multiplication overflow in tick_nohz_stop_sched_tick(). 

Reported by: Dave Miller <davem@davemloft.net>

Make the return value a constant and limit the return value to a 32 bit
value.

When the max timeout value is returned, we can safely stop the tick
timer device. The max jiffies delta results in a 12 days timeout for
HZ=1000.

In the long term the get_next_timer_interrupt() code needs to be
reworked to return ktime instead of jiffies, but we have to wait until
the last users of the original NO_IDLE_HZ code are converted.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 include/linux/timer.h    |    6 ++++++
 kernel/time/tick-sched.c |   16 +++++++++++++++-
 kernel/timer.c           |   10 +++++++++-
 3 files changed, 30 insertions(+), 2 deletions(-)

Index: linux-2.6.21/include/linux/timer.h
===================================================================
--- linux-2.6.21.orig/include/linux/timer.h	2007-05-29 17:58:04.000000000 +0200
+++ linux-2.6.21/include/linux/timer.h	2007-05-29 17:58:06.000000000 +0200
@@ -68,6 +68,12 @@
 extern int mod_timer(struct timer_list *timer, unsigned long expires);
 
 /*
+ * The jiffies value which is added to now, when there is no timer
+ * in the timer wheel:
+ */
+#define NEXT_TIMER_MAX_DELTA	((1UL << 30) - 1)
+
+/*
  * Return when the next timer-wheel timeout occurs (in absolute jiffies),
  * locks the timer base:
  */
Index: linux-2.6.21/kernel/time/tick-sched.c
===================================================================
--- linux-2.6.21.orig/kernel/time/tick-sched.c	2007-05-29 17:58:04.000000000 +0200
+++ linux-2.6.21/kernel/time/tick-sched.c	2007-05-29 17:58:06.000000000 +0200
@@ -233,6 +233,21 @@
 		if (cpu == tick_do_timer_cpu)
 			tick_do_timer_cpu = -1;
 
+		ts->idle_sleeps++;
+
+		/*
+		 * delta_jiffies >= NEXT_TIMER_MAX_DELTA signals that
+		 * there is no timer pending or at least extremly far
+		 * into the future (12 days for HZ=1000). In this case
+		 * we simply stop the tick timer:
+		 */
+		if (unlikely(delta_jiffies >= NEXT_TIMER_MAX_DELTA)) {
+			ts->idle_expires.tv64 = KTIME_MAX;
+			if (ts->nohz_mode == NOHZ_MODE_HIGHRES)
+				hrtimer_cancel(&ts->sched_timer);
+			goto out;
+		}
+
 		/*
 		 * calculate the expiry time for the next timer wheel
 		 * timer
@@ -240,7 +255,6 @@
 		expires = ktime_add_ns(last_update, tick_period.tv64 *
 				       delta_jiffies);
 		ts->idle_expires = expires;
-		ts->idle_sleeps++;
 
 		if (ts->nohz_mode == NOHZ_MODE_HIGHRES) {
 			hrtimer_start(&ts->sched_timer, expires,
Index: linux-2.6.21/kernel/timer.c
===================================================================
--- linux-2.6.21.orig/kernel/timer.c	2007-05-29 17:58:05.000000000 +0200
+++ linux-2.6.21/kernel/timer.c	2007-05-29 17:58:06.000000000 +0200
@@ -625,7 +625,7 @@
 static unsigned long __next_timer_interrupt(tvec_base_t *base)
 {
 	unsigned long timer_jiffies = base->timer_jiffies;
-	unsigned long expires = timer_jiffies + (LONG_MAX >> 1);
+	unsigned long expires = timer_jiffies + NEXT_TIMER_MAX_DELTA;
 	int index, slot, array, found = 0;
 	struct timer_list *nte;
 	tvec_t *varray[4];
@@ -708,6 +708,14 @@
 
 	tsdelta = ktime_to_timespec(hr_delta);
 	delta = timespec_to_jiffies(&tsdelta);
+
+	/*
+	 * Limit the delta to the max value, which is checked in
+	 * tick_nohz_stop_sched_tick():
+	 */
+	if (delta > NEXT_TIMER_MAX_DELTA)
+		delta = NEXT_TIMER_MAX_DELTA;
+
 	/*
 	 * Take rounding errors in to account and make sure, that it
 	 * expires in the next tick. Otherwise we go into an endless


