Return-Path: <linux-kernel-owner+w=401wt.eu-S1756860AbYGGSVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860AbYGGSVT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 14:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755212AbYGGSVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 14:21:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:63949 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754409AbYGGSVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 14:21:07 -0400
Message-Id: <20080707182104.030313295@goodmis.org>
References: <20080707181649.942597764@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 07 Jul 2008 14:16:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/3] sched_clock: record from last tick
Content-Disposition: inline; filename=sched-clock-tick-jiffies.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sched_clock code tries to keep within the gtod time by one tick (jiffy).
The current code mistakenly keeps track of the delta jiffies between
updates of the clock, where the the delta is used to compare with the
number of jiffies that have past since an update of the gtod. The gtod is
updated at each schedule tick not each sched_clock update. After one
jiffy passes the clock is updated fine. But the delta is taken from the
last update so if the next update happens before the next tick the delta
jiffies used will be incorrect.

This patch changes the code to check the delta of jiffies between ticks
and not updates to match the comparison of the updates with the gtod.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/sched_clock.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

Index: linux-tip.git/kernel/sched_clock.c
===================================================================
--- linux-tip.git.orig/kernel/sched_clock.c	2008-07-06 01:24:43.000000000 -0400
+++ linux-tip.git/kernel/sched_clock.c	2008-07-06 22:35:35.000000000 -0400
@@ -40,7 +40,7 @@ struct sched_clock_data {
 	 */
 	raw_spinlock_t		lock;
 
-	unsigned long		prev_jiffies;
+	unsigned long		tick_jiffies;
 	u64			prev_raw;
 	u64			tick_raw;
 	u64			tick_gtod;
@@ -71,7 +71,7 @@ void sched_clock_init(void)
 		struct sched_clock_data *scd = cpu_sdc(cpu);
 
 		scd->lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
-		scd->prev_jiffies = now_jiffies;
+		scd->tick_jiffies = now_jiffies;
 		scd->prev_raw = 0;
 		scd->tick_raw = 0;
 		scd->tick_gtod = ktime_now;
@@ -90,7 +90,7 @@ void sched_clock_init(void)
 static void __update_sched_clock(struct sched_clock_data *scd, u64 now)
 {
 	unsigned long now_jiffies = jiffies;
-	long delta_jiffies = now_jiffies - scd->prev_jiffies;
+	long delta_jiffies = now_jiffies - scd->tick_jiffies;
 	u64 clock = scd->clock;
 	u64 min_clock, max_clock;
 	s64 delta = now - scd->prev_raw;
@@ -119,7 +119,6 @@ static void __update_sched_clock(struct 
 		clock = min_clock;
 
 	scd->prev_raw = now;
-	scd->prev_jiffies = now_jiffies;
 	scd->clock = clock;
 }
 
@@ -179,6 +178,7 @@ u64 sched_clock_cpu(int cpu)
 void sched_clock_tick(void)
 {
 	struct sched_clock_data *scd = this_scd();
+	unsigned long now_jiffies = jiffies;
 	u64 now, now_gtod;
 
 	if (unlikely(!sched_clock_running))
@@ -196,6 +196,7 @@ void sched_clock_tick(void)
 	 * already observe 1 new jiffy; adding a new tick_gtod to that would
 	 * increase the clock 2 jiffies.
 	 */
+	scd->tick_jiffies = now_jiffies;
 	scd->tick_raw = now;
 	scd->tick_gtod = now_gtod;
 	__raw_spin_unlock(&scd->lock);

-- 
