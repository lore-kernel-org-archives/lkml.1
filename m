Return-Path: <linux-kernel-owner+w=401wt.eu-S1756818AbYGIET0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818AbYGIET0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 00:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751375AbYGIES3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 00:18:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:48234 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbYGIES1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 00:18:27 -0400
Message-Id: <20080709041825.507356058@goodmis.org>
References: <20080709041530.668120406@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 09 Jul 2008 00:15:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Cc: Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 3/3] sched_clock: and multiplier for TSC to gtod drift
Content-Disposition: inline; filename=sched-clock-drift-clock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sched_clock code currently tries to keep all CPU clocks of all CPUS
somewhat in sync. At every clock tick it records the gtod clock and
uses that and jiffies and the TSC to calculate a CPU clock that tries to
stay in sync with all the other CPUs.

ftrace depends heavily on this timer and it detects when this timer
"jumps".  One problem is that the TSC and the gtod also drift.
When the TSC is 0.1% faster or slower than the gtod it is very noticeable
in ftrace. To help compensate for this, I've added a multiplier that
tries to keep the CPU clock updating at the same rate as the gtod.

I've tried various ways to get it to be in sync and this ended up being
the most reliable. At every scheduler tick we calculate the new multiplier:

  multi = delta_gtod / delta_TSC

This means we perform a 64 bit divide at the tick (once a HZ). A shift
is used to handle the accuracy.

Other methods that failed due to dynamic HZ are:

(not used)  multi += (gtod - tsc) / delta_gtod
(not used)  multi += (gtod - (last_tsc + delta_tsc)) / delta_gtod

as well as other variants.

This code still allows for a slight drift between TSC and gtod, but
it keeps the damage down to a minimum.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/sched_clock.c |   40 +++++++++++++++++++++++++++++++++++++---
 1 file changed, 37 insertions(+), 3 deletions(-)

Index: linux-tip.git/kernel/sched_clock.c
===================================================================
--- linux-tip.git.orig/kernel/sched_clock.c	2008-07-08 22:14:36.000000000 -0400
+++ linux-tip.git/kernel/sched_clock.c	2008-07-08 22:49:48.000000000 -0400
@@ -3,6 +3,9 @@
  *
  *  Copyright (C) 2008 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
  *
+ *  Updates and enhancements:
+ *    Copyright (C) 2008 Red Hat, Inc. Steven Rostedt <srostedt@redhat.com>
+ *
  * Based on code by:
  *   Ingo Molnar <mingo@redhat.com>
  *   Guillaume Chazarain <guichaz@gmail.com>
@@ -32,6 +35,11 @@
 
 #ifdef CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
 
+#define MULTI_SHIFT 15
+/* Max is double, Min is 1/2 */
+#define MAX_MULTI (2LL << MULTI_SHIFT)
+#define MIN_MULTI (1LL << (MULTI_SHIFT-1))
+
 struct sched_clock_data {
 	/*
 	 * Raw spinlock - this is a special case: this might be called
@@ -45,6 +53,7 @@ struct sched_clock_data {
 	u64			tick_raw;
 	u64			tick_gtod;
 	u64			clock;
+	s64			multi;
 #ifdef CONFIG_NO_HZ
 	int			check_max;
 #endif
@@ -79,6 +88,7 @@ void sched_clock_init(void)
 		scd->tick_raw = 0;
 		scd->tick_gtod = ktime_now;
 		scd->clock = ktime_now;
+		scd->multi = 1 << MULTI_SHIFT;
 #ifdef CONFIG_NO_HZ
 		scd->check_max = 1;
 #endif
@@ -134,8 +144,13 @@ static void __update_sched_clock(struct 
 
 	WARN_ON_ONCE(!irqs_disabled());
 
-	min_clock = scd->tick_gtod +
-		(delta_jiffies ? delta_jiffies - 1 : 0) * TICK_NSEC;
+	/*
+	 * At schedule tick the clock can be just under the gtod. We don't
+	 * want to push it too prematurely.
+	 */
+	min_clock = scd->tick_gtod + (delta_jiffies * TICK_NSEC);
+	if (min_clock > TICK_NSEC)
+		min_clock -= TICK_NSEC / 2;
 
 	if (unlikely(delta < 0)) {
 		clock++;
@@ -149,6 +164,9 @@ static void __update_sched_clock(struct 
 	 */
 	max_clock = scd->tick_gtod + (2 + delta_jiffies) * TICK_NSEC;
 
+	delta *= scd->multi;
+	delta >>= MULTI_SHIFT;
+
 	if (unlikely(clock + delta > max_clock) && check_max(scd)) {
 		if (clock < max_clock)
 			clock = max_clock;
@@ -230,6 +248,7 @@ void sched_clock_tick(void)
 {
 	struct sched_clock_data *scd = this_scd();
 	unsigned long now_jiffies = jiffies;
+	s64 mult, delta_gtod, delta_raw;
 	u64 now, now_gtod;
 
 	if (unlikely(!sched_clock_running))
@@ -247,9 +266,23 @@ void sched_clock_tick(void)
 	 * already observe 1 new jiffy; adding a new tick_gtod to that would
 	 * increase the clock 2 jiffies.
 	 */
-	scd->tick_jiffies = now_jiffies;
+	delta_gtod = now_gtod - scd->tick_gtod;
+	delta_raw = now - scd->tick_raw;
+
+	if ((long)delta_raw > 0) {
+		mult = delta_gtod << MULTI_SHIFT;
+		do_div(mult, delta_raw);
+		scd->multi = mult;
+		if (scd->multi > MAX_MULTI)
+			scd->multi = MAX_MULTI;
+		else if (scd->multi < MIN_MULTI)
+			scd->multi = MIN_MULTI;
+	} else
+		scd->multi = 1 << MULTI_SHIFT;
+
 	scd->tick_raw = now;
 	scd->tick_gtod = now_gtod;
+	scd->tick_jiffies = now_jiffies;
 	__raw_spin_unlock(&scd->lock);
 }
 
@@ -279,6 +312,7 @@ void sched_clock_idle_wakeup_event(u64 d
 	__raw_spin_lock(&scd->lock);
 	scd->prev_raw = now;
 	scd->clock += delta_ns;
+	scd->multi = 1 << MULTI_SHIFT;
 	__raw_spin_unlock(&scd->lock);
 
 	touch_softlockup_watchdog();

-- 
