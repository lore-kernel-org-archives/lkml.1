Return-Path: <linux-kernel-owner+w=401wt.eu-S1757552AbZEBTIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552AbZEBTIs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 15:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756788AbZEBTIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 15:08:11 -0400
Received: from www.tglx.de ([62.245.132.106]:33808 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755804AbZEBTII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 15:08:08 -0400
Message-Id: <20090502190545.489264416@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sat, 02 May 2009 19:06:35 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Dimitri Sivanich <sivanich@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [patch 2/3] timer: move calc_load to softirq
References: <20090502190500.513452861@linutronix.de>
Content-Disposition: inline; filename=calc-load-move-to-soft-irq.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xtime_lock is held write locked across calc_load() which iterates over
all online CPUs. That can cause long latencies for xtime_lock readers
on large SMP systems. The load average calculation is an rough
estimate anyway so there is no real need to protect the readers
vs. the update. It's not a problem when the avenrun array is updated
while a reader copies the values.

Move the calculation to the softirq and reduce the xtime_lock write
locked section. This also reduces the interrupts off section.

Inspired by an inital patch from Dimitri Sivanich.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/timekeeping.c |    2 -
 kernel/timer.c            |   59 +++++++++++++++++++++++++++++++++-------------
 2 files changed, 44 insertions(+), 17 deletions(-)

Index: linux-2.6/kernel/time/timekeeping.c
===================================================================
--- linux-2.6.orig/kernel/time/timekeeping.c
+++ linux-2.6/kernel/time/timekeeping.c
@@ -22,7 +22,7 @@
 
 /*
  * This read-write spinlock protects us from races in SMP while
- * playing with xtime and avenrun.
+ * playing with xtime.
  */
 __cacheline_aligned_in_smp DEFINE_SEQLOCK(xtime_lock);
 
Index: linux-2.6/kernel/timer.c
===================================================================
--- linux-2.6.orig/kernel/timer.c
+++ linux-2.6/kernel/timer.c
@@ -1127,12 +1127,14 @@ void update_process_times(int user_tick)
  * imply that avenrun[] is the standard name for this kind of thing.
  * Nothing else seems to be standardized: the fractional size etc
  * all seem to differ on different machines.
- *
- * Requires xtime_lock to access.
  */
 unsigned long avenrun[3];
 EXPORT_SYMBOL(avenrun);
 
+static atomic_t avenrun_ticks;
+static DEFINE_SPINLOCK(avenrun_lock);
+static DEFINE_PER_CPU(int, avenrun_calculate);
+
 static unsigned long
 calc_load(unsigned long load, unsigned long exp, unsigned long active)
 {
@@ -1143,23 +1145,47 @@ calc_load(unsigned long load, unsigned l
 
 /*
  * calc_load - given tick count, update the avenrun load estimates.
- * This is called while holding a write_lock on xtime_lock.
  */
-static void calc_global_load(unsigned long ticks)
+static void calc_global_load(void)
 {
-	unsigned long active_tasks; /* fixed-point */
-	static int count = LOAD_FREQ;
+	unsigned long active_tasks = nr_active() * FIXED_1;
 
-	count -= ticks;
-	if (unlikely(count < 0)) {
-		active_tasks = nr_active() * FIXED_1;
-		do {
-			avenrun[0] = calc_load(avenrun[0], EXP_1, active_tasks);
-			avenrun[1] = calc_load(avenrun[1], EXP_5, active_tasks);
-			avenrun[2] = calc_load(avenrun[2], EXP_15, active_tasks);
-			count += LOAD_FREQ;
-		} while (count < 0);
+	avenrun[0] = calc_load(avenrun[0], EXP_1, active_tasks);
+	avenrun[1] = calc_load(avenrun[1], EXP_5, active_tasks);
+	avenrun[2] = calc_load(avenrun[2], EXP_15, active_tasks);
+}
+
+/*
+ * Check whether do_timer has set avenrun_calculate. The variable is
+ * cpu local so we avoid cache line bouncing of avenrun_lock and
+ * avenrun_ticks. avenrun_lock protects the avenrun calculation.
+ */
+static void check_calc_load(void)
+{
+	int ticks, *calc = &__get_cpu_var(avenrun_calculate);
+
+	if (!*calc)
+		return;
+
+	spin_lock(&avenrun_lock);
+	ticks = atomic_read(&avenrun_ticks);
+	if (ticks >= LOAD_FREQ) {
+		atomic_sub(LOAD_FREQ, &avenrun_ticks);
+		calc_global_load();
 	}
+	spin_unlock(&avenrun_lock);
+	*calc = 0;
+}
+
+/*
+ * Update avenrun_ticks and trigger the load calculation when the
+ * result is >= LOAD_FREQ.
+ */
+static void calc_load_update(unsigned long ticks)
+{
+	ticks = atomic_add_return(ticks, &avenrun_ticks);
+	if (ticks >= LOAD_FREQ)
+		__get_cpu_var(avenrun_calculate) = 1;
 }
 
 /*
@@ -1169,6 +1195,7 @@ static void run_timer_softirq(struct sof
 {
 	struct tvec_base *base = __get_cpu_var(tvec_bases);
 
+	check_calc_load();
 	hrtimer_run_pending();
 
 	if (time_after_eq(jiffies, base->timer_jiffies))
@@ -1192,7 +1219,7 @@ void run_local_timers(void)
 static inline void update_times(unsigned long ticks)
 {
 	update_wall_time();
-	calc_global_load(ticks);
+	calc_load_update(ticks);
 }
 
 /*


