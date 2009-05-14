Return-Path: <linux-kernel-owner+w=401wt.eu-S1758089AbZENLXE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758089AbZENLXE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 07:23:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755871AbZENLWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 07:22:37 -0400
Received: from www.tglx.de ([62.245.132.106]:36727 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754916AbZENLWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 07:22:36 -0400
Message-Id: <20090514110712.521114248@linutronix.de>
User-Agent: quilt/0.47-1
Date: Thu, 14 May 2009 11:21:18 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Dimitri Sivanich <sivanich@sgi.com>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 1/2] sched, timers: move calc_load() to scheduler
References: <20090514105915.973318588@linutronix.de>
Content-Disposition: inline; filename=move-calc-load-to-scheduler-v1.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dimitri Sivanich noticed that xtime_lock is held write locked across
calc_load() which iterates over all online CPUs. That can cause long
latencies for xtime_lock readers on large SMP systems. 

The load average calculation is a rough estimate anyway so there is
no real need to protect the readers vs. the update. It's not a problem
when the avenrun array is updated while a reader copies the values.

Instead of iterating over all online CPUs let the scheduler_tick code
update the number of active tasks shortly before the avenrun update
happens. The avenrun update itself is handled by the CPU which calls
do_timer().

[ Impact: reduce xtime_lock write locked section ]

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/sched.h     |    2 -
 kernel/sched.c            |   84 ++++++++++++++++++++++++++++++++++++++++------
 kernel/sched_idletask.c   |    3 +
 kernel/time/timekeeping.c |    2 -
 kernel/timer.c            |   54 +----------------------------
 5 files changed, 80 insertions(+), 65 deletions(-)

Index: linux-2.6-tip/include/linux/sched.h
===================================================================
--- linux-2.6-tip.orig/include/linux/sched.h
+++ linux-2.6-tip/include/linux/sched.h
@@ -137,9 +137,9 @@ DECLARE_PER_CPU(unsigned long, process_c
 extern int nr_processes(void);
 extern unsigned long nr_running(void);
 extern unsigned long nr_uninterruptible(void);
-extern unsigned long nr_active(void);
 extern unsigned long nr_iowait(void);
 extern u64 cpu_nr_migrations(int cpu);
+extern void calc_global_load(void);
 
 extern unsigned long get_parent_ip(unsigned long addr);
 
Index: linux-2.6-tip/kernel/sched.c
===================================================================
--- linux-2.6-tip.orig/kernel/sched.c
+++ linux-2.6-tip/kernel/sched.c
@@ -628,6 +628,10 @@ struct rq {
 	struct list_head migration_queue;
 #endif
 
+	/* calc_load related fields */
+	unsigned long calc_load_update;
+	long calc_load_active;
+
 #ifdef CONFIG_SCHED_HRTICK
 #ifdef CONFIG_SMP
 	int hrtick_csd_pending;
@@ -1726,6 +1730,8 @@ static void cfs_rq_set_shares(struct cfs
 }
 #endif
 
+static void calc_load_account_active(struct rq *this_rq);
+
 #include "sched_stats.h"
 #include "sched_idletask.c"
 #include "sched_fair.c"
@@ -2934,19 +2940,57 @@ unsigned long nr_iowait(void)
 	return sum;
 }
 
-unsigned long nr_active(void)
+/* Variables and functions for calc_load */
+static atomic_long_t calc_load_tasks;
+static unsigned long calc_load_update;
+unsigned long avenrun[3];
+EXPORT_SYMBOL(avenrun);
+
+static unsigned long
+calc_load(unsigned long load, unsigned long exp, unsigned long active)
 {
-	unsigned long i, running = 0, uninterruptible = 0;
+	load *= exp;
+	load += active * (FIXED_1 - exp);
+	return load >> FSHIFT;
+}
 
-	for_each_online_cpu(i) {
-		running += cpu_rq(i)->nr_running;
-		uninterruptible += cpu_rq(i)->nr_uninterruptible;
-	}
+/*
+ * calc_load - update the avenrun load estimates 10 ticks after the
+ * CPUs have updated calc_load_tasks.
+ */
+void calc_global_load(void)
+{
+	unsigned long upd = calc_load_update + 10;
+	long active;
+
+	if (time_before(jiffies, upd))
+		return;
 
-	if (unlikely((long)uninterruptible < 0))
-		uninterruptible = 0;
+	active = atomic_long_read(&calc_load_tasks);
+	active = active > 0 ? active * FIXED_1 : 0;
 
-	return running + uninterruptible;
+	avenrun[0] = calc_load(avenrun[0], EXP_1, active);
+	avenrun[1] = calc_load(avenrun[1], EXP_5, active);
+	avenrun[2] = calc_load(avenrun[2], EXP_15, active);
+
+	calc_load_update += LOAD_FREQ;
+}
+
+/*
+ * Either called from update_cpu_load() or from a cpu going idle
+ */
+static void calc_load_account_active(struct rq *this_rq)
+{
+	long nr_active, delta;
+
+	nr_active = this_rq->nr_running;
+	nr_active += (long) this_rq->nr_uninterruptible;
+
+	if (nr_active != this_rq->calc_load_active) {
+		delta = nr_active - this_rq->calc_load_active;
+		this_rq->calc_load_active = nr_active;
+		atomic_long_add(delta, &calc_load_tasks);
+	}
 }
 
 /*
@@ -2986,6 +3030,11 @@ static void update_cpu_load(struct rq *t
 			new_load += scale-1;
 		this_rq->cpu_load[i] = (old_load*(scale-1) + new_load) >> i;
 	}
+
+	if (time_after_eq(jiffies, this_rq->calc_load_update)) {
+		this_rq->calc_load_update += LOAD_FREQ;
+		calc_load_account_active(this_rq);
+	}
 }
 
 #ifdef CONFIG_SMP
@@ -7192,6 +7241,14 @@ static void migrate_dead_tasks(unsigned 
 
 	}
 }
+
+/*
+ * remove the tasks which were accounted by rq from calc_load_tasks.
+ */
+static void calc_global_load_remove(struct rq *rq)
+{
+	atomic_long_sub(rq->calc_load_active, &calc_load_tasks);
+}
 #endif /* CONFIG_HOTPLUG_CPU */
 
 #if defined(CONFIG_SCHED_DEBUG) && defined(CONFIG_SYSCTL)
@@ -7426,6 +7483,8 @@ migration_call(struct notifier_block *nf
 		/* Update our root-domain */
 		rq = cpu_rq(cpu);
 		spin_lock_irqsave(&rq->lock, flags);
+		rq->calc_load_update = calc_load_update;
+		rq->calc_load_active = 0;
 		if (rq->rd) {
 			BUG_ON(!cpumask_test_cpu(cpu, rq->rd->span));
 
@@ -7465,7 +7524,7 @@ migration_call(struct notifier_block *nf
 		cpuset_unlock();
 		migrate_nr_uninterruptible(rq);
 		BUG_ON(rq->nr_running != 0);
-
+		calc_global_load_remove(rq);
 		/*
 		 * No need to migrate the tasks: it was best-effort if
 		 * they didn't take sched_hotcpu_mutex. Just wake up
@@ -9162,6 +9221,8 @@ void __init sched_init(void)
 		rq = cpu_rq(i);
 		spin_lock_init(&rq->lock);
 		rq->nr_running = 0;
+		rq->calc_load_active = 0;
+		rq->calc_load_update = jiffies + LOAD_FREQ;
 		init_cfs_rq(&rq->cfs, rq);
 		init_rt_rq(&rq->rt, rq);
 #ifdef CONFIG_FAIR_GROUP_SCHED
@@ -9269,6 +9330,9 @@ void __init sched_init(void)
 	 * when this runqueue becomes "idle".
 	 */
 	init_idle(current, smp_processor_id());
+
+	calc_load_update = jiffies + LOAD_FREQ;
+
 	/*
 	 * During early bootup we pretend to be a normal task:
 	 */
Index: linux-2.6-tip/kernel/sched_idletask.c
===================================================================
--- linux-2.6-tip.orig/kernel/sched_idletask.c
+++ linux-2.6-tip/kernel/sched_idletask.c
@@ -22,7 +22,8 @@ static void check_preempt_curr_idle(stru
 static struct task_struct *pick_next_task_idle(struct rq *rq)
 {
 	schedstat_inc(rq, sched_goidle);
-
+	/* adjust the active tasks as we might go into a long sleep */
+	calc_load_account_active(rq);
 	return rq->idle;
 }
 
Index: linux-2.6-tip/kernel/time/timekeeping.c
===================================================================
--- linux-2.6-tip.orig/kernel/time/timekeeping.c
+++ linux-2.6-tip/kernel/time/timekeeping.c
@@ -22,7 +22,7 @@
 
 /*
  * This read-write spinlock protects us from races in SMP while
- * playing with xtime and avenrun.
+ * playing with xtime.
  */
 __cacheline_aligned_in_smp DEFINE_SEQLOCK(xtime_lock);
 
Index: linux-2.6-tip/kernel/timer.c
===================================================================
--- linux-2.6-tip.orig/kernel/timer.c
+++ linux-2.6-tip/kernel/timer.c
@@ -1127,47 +1127,6 @@ void update_process_times(int user_tick)
 }
 
 /*
- * Nr of active tasks - counted in fixed-point numbers
- */
-static unsigned long count_active_tasks(void)
-{
-	return nr_active() * FIXED_1;
-}
-
-/*
- * Hmm.. Changed this, as the GNU make sources (load.c) seems to
- * imply that avenrun[] is the standard name for this kind of thing.
- * Nothing else seems to be standardized: the fractional size etc
- * all seem to differ on different machines.
- *
- * Requires xtime_lock to access.
- */
-unsigned long avenrun[3];
-
-EXPORT_SYMBOL(avenrun);
-
-/*
- * calc_load - given tick count, update the avenrun load estimates.
- * This is called while holding a write_lock on xtime_lock.
- */
-static inline void calc_load(unsigned long ticks)
-{
-	unsigned long active_tasks; /* fixed-point */
-	static int count = LOAD_FREQ;
-
-	count -= ticks;
-	if (unlikely(count < 0)) {
-		active_tasks = count_active_tasks();
-		do {
-			CALC_LOAD(avenrun[0], EXP_1, active_tasks);
-			CALC_LOAD(avenrun[1], EXP_5, active_tasks);
-			CALC_LOAD(avenrun[2], EXP_15, active_tasks);
-			count += LOAD_FREQ;
-		} while (count < 0);
-	}
-}
-
-/*
  * This function runs timers and the timer-tq in bottom half context.
  */
 static void run_timer_softirq(struct softirq_action *h)
@@ -1193,16 +1152,6 @@ void run_local_timers(void)
 }
 
 /*
- * Called by the timer interrupt. xtime_lock must already be taken
- * by the timer IRQ!
- */
-static inline void update_times(unsigned long ticks)
-{
-	update_wall_time();
-	calc_load(ticks);
-}
-
-/*
  * The 64-bit jiffies value is not atomic - you MUST NOT read it
  * without sampling the sequence number in xtime_lock.
  * jiffies is defined in the linker script...
@@ -1211,7 +1160,8 @@ static inline void update_times(unsigned
 void do_timer(unsigned long ticks)
 {
 	jiffies_64 += ticks;
-	update_times(ticks);
+	update_wall_time();
+	calc_global_load();
 }
 
 #ifdef __ARCH_WANT_SYS_ALARM


