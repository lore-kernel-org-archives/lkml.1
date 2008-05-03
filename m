Return-Path: <linux-kernel-owner+w=401wt.eu-S1759314AbYECQag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759314AbYECQag (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 12:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764386AbYECQaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 12:30:18 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44885 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763881AbYECQ3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 12:29:52 -0400
Subject: [RFC][PATCH] sched_clock_cpu()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>,
       Guillaume Chazarain <guichaz@gmail.com>,
       Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arch <linux-arch@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Sat, 03 May 2008 18:29:28 +0200
Message-Id: <1209832169.6929.42.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is my current proposal to replace the rq->clock stuff (and possibly
cpu_clock()).

it _DOESN'T_ boot ;-/ and I seem to have caught a flu that makes my
whole body hurt like hell, so I'm not getting anything done.

Brain dump before I crash:

 - architectures that have a 'perfect' hardware clock can set
     CONFIG_HAVE_STABLE_CLOCK

 - the 'jiffie' window might be superfulous when we update tick_gtod
   before the __update_sched_clock() call in sched_clock_tick()

 - cpu_clock() might be implemented as:

     sched_clock_cpu(smp_processor_id())

   if the accuracy proves good enough - how far can TSC drift in a
   single jiffie when considering the filtering and idle hooks?

 - what other architectures besides x86 would need this?

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h |   29 ++++++
 init/main.c           |    1 
 kernel/Makefile       |    2 
 kernel/sched.c        |  163 ++----------------------------------
 kernel/sched_clock.c  |  221 ++++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched_debug.c  |    7 -
 kernel/sched_fair.c   |    2 
 7 files changed, 266 insertions(+), 159 deletions(-)

Index: linux-2.6-2/kernel/sched.c
===================================================================
--- linux-2.6-2.orig/kernel/sched.c
+++ linux-2.6-2/kernel/sched.c
@@ -75,16 +75,6 @@
 #include <asm/irq_regs.h>
 
 /*
- * Scheduler clock - returns current time in nanosec units.
- * This is default implementation.
- * Architectures and sub-architectures can override this.
- */
-unsigned long long __attribute__((weak)) sched_clock(void)
-{
-	return (unsigned long long)jiffies * (NSEC_PER_SEC / HZ);
-}
-
-/*
  * Convert user-nice values [ -20 ... 0 ... 19 ]
  * to static priority [ MAX_RT_PRIO..MAX_PRIO-1 ],
  * and back.
@@ -560,13 +550,7 @@ struct rq {
 	unsigned long next_balance;
 	struct mm_struct *prev_mm;
 
-	u64 clock, prev_clock_raw;
-	s64 clock_max_delta;
-
-	unsigned int clock_warps, clock_overflows, clock_underflows;
-	u64 idle_clock;
-	unsigned int clock_deep_idle_events;
-	u64 tick_timestamp;
+	u64 clock;
 
 	atomic_t nr_iowait;
 
@@ -631,82 +615,6 @@ static inline int cpu_of(struct rq *rq)
 #endif
 }
 
-#ifdef CONFIG_NO_HZ
-static inline bool nohz_on(int cpu)
-{
-	return tick_get_tick_sched(cpu)->nohz_mode != NOHZ_MODE_INACTIVE;
-}
-
-static inline u64 max_skipped_ticks(struct rq *rq)
-{
-	return nohz_on(cpu_of(rq)) ? jiffies - rq->last_tick_seen + 2 : 1;
-}
-
-static inline void update_last_tick_seen(struct rq *rq)
-{
-	rq->last_tick_seen = jiffies;
-}
-#else
-static inline u64 max_skipped_ticks(struct rq *rq)
-{
-	return 1;
-}
-
-static inline void update_last_tick_seen(struct rq *rq)
-{
-}
-#endif
-
-/*
- * Update the per-runqueue clock, as finegrained as the platform can give
- * us, but without assuming monotonicity, etc.:
- */
-static void __update_rq_clock(struct rq *rq)
-{
-	u64 prev_raw = rq->prev_clock_raw;
-	u64 now = sched_clock();
-	s64 delta = now - prev_raw;
-	u64 clock = rq->clock;
-
-#ifdef CONFIG_SCHED_DEBUG
-	WARN_ON_ONCE(cpu_of(rq) != smp_processor_id());
-#endif
-	/*
-	 * Protect against sched_clock() occasionally going backwards:
-	 */
-	if (unlikely(delta < 0)) {
-		clock++;
-		rq->clock_warps++;
-	} else {
-		/*
-		 * Catch too large forward jumps too:
-		 */
-		u64 max_jump = max_skipped_ticks(rq) * TICK_NSEC;
-		u64 max_time = rq->tick_timestamp + max_jump;
-
-		if (unlikely(clock + delta > max_time)) {
-			if (clock < max_time)
-				clock = max_time;
-			else
-				clock++;
-			rq->clock_overflows++;
-		} else {
-			if (unlikely(delta > rq->clock_max_delta))
-				rq->clock_max_delta = delta;
-			clock += delta;
-		}
-	}
-
-	rq->prev_clock_raw = now;
-	rq->clock = clock;
-}
-
-static void update_rq_clock(struct rq *rq)
-{
-	if (likely(smp_processor_id() == cpu_of(rq)))
-		__update_rq_clock(rq);
-}
-
 /*
  * The domain tree (rq->sd) is protected by RCU's quiescent state transition.
  * See detach_destroy_domains: synchronize_sched for details.
@@ -722,6 +630,11 @@ static void update_rq_clock(struct rq *r
 #define task_rq(p)		cpu_rq(task_cpu(p))
 #define cpu_curr(cpu)		(cpu_rq(cpu)->curr)
 
+static inline void update_rq_clock(struct rq *rq)
+{
+	rq->clock = sched_clock_cpu(cpu_of(rq));
+}
+
 /*
  * Tunables that become constants when CONFIG_SCHED_DEBUG is off:
  */
@@ -935,7 +848,6 @@ static unsigned long long __cpu_clock(in
 {
 	unsigned long long now;
 	unsigned long flags;
-	struct rq *rq;
 
 	/*
 	 * Only call sched_clock() if the scheduler has already been
@@ -945,9 +857,7 @@ static unsigned long long __cpu_clock(in
 		return 0;
 
 	local_irq_save(flags);
-	rq = cpu_rq(cpu);
-	update_rq_clock(rq);
-	now = rq->clock;
+	now = sched_clock_cpu(cpu);
 	local_irq_restore(flags);
 
 	return now;
@@ -1117,43 +1027,6 @@ static struct rq *this_rq_lock(void)
 	return rq;
 }
 
-/*
- * We are going deep-idle (irqs are disabled):
- */
-void sched_clock_idle_sleep_event(void)
-{
-	struct rq *rq = cpu_rq(smp_processor_id());
-
-	spin_lock(&rq->lock);
-	__update_rq_clock(rq);
-	spin_unlock(&rq->lock);
-	rq->clock_deep_idle_events++;
-}
-EXPORT_SYMBOL_GPL(sched_clock_idle_sleep_event);
-
-/*
- * We just idled delta nanoseconds (called with irqs disabled):
- */
-void sched_clock_idle_wakeup_event(u64 delta_ns)
-{
-	struct rq *rq = cpu_rq(smp_processor_id());
-	u64 now = sched_clock();
-
-	rq->idle_clock += delta_ns;
-	/*
-	 * Override the previous timestamp and ignore all
-	 * sched_clock() deltas that occured while we idled,
-	 * and use the PM-provided delta_ns to advance the
-	 * rq clock:
-	 */
-	spin_lock(&rq->lock);
-	rq->prev_clock_raw = now;
-	rq->clock += delta_ns;
-	spin_unlock(&rq->lock);
-	touch_softlockup_watchdog();
-}
-EXPORT_SYMBOL_GPL(sched_clock_idle_wakeup_event);
-
 static void __resched_task(struct task_struct *p, int tif_bit);
 
 static inline void resched_task(struct task_struct *p)
@@ -1275,7 +1148,7 @@ static enum hrtimer_restart hrtick(struc
 	WARN_ON_ONCE(cpu_of(rq) != smp_processor_id());
 
 	spin_lock(&rq->lock);
-	__update_rq_clock(rq);
+	update_rq_clock(rq);
 	rq->curr->sched_class->task_tick(rq, rq->curr, 1);
 	spin_unlock(&rq->lock);
 
@@ -4404,19 +4277,11 @@ void scheduler_tick(void)
 	int cpu = smp_processor_id();
 	struct rq *rq = cpu_rq(cpu);
 	struct task_struct *curr = rq->curr;
-	u64 next_tick = rq->tick_timestamp + TICK_NSEC;
+
+	sched_clock_tick();
 
 	spin_lock(&rq->lock);
-	__update_rq_clock(rq);
-	/*
-	 * Let rq->clock advance by at least TICK_NSEC:
-	 */
-	if (unlikely(rq->clock < next_tick)) {
-		rq->clock = next_tick;
-		rq->clock_underflows++;
-	}
-	rq->tick_timestamp = rq->clock;
-	update_last_tick_seen(rq);
+	update_rq_clock(rq);
 	update_cpu_load(rq);
 	curr->sched_class->task_tick(rq, curr, 0);
 	spin_unlock(&rq->lock);
@@ -4570,7 +4435,7 @@ need_resched_nonpreemptible:
 	 * Do the rq-clock update outside the rq lock:
 	 */
 	local_irq_disable();
-	__update_rq_clock(rq);
+	update_rq_clock(rq);
 	spin_lock(&rq->lock);
 	clear_tsk_need_resched(prev);
 
@@ -8149,8 +8014,6 @@ void __init sched_init(void)
 		spin_lock_init(&rq->lock);
 		lockdep_set_class(&rq->lock, &rq->rq_lock_key);
 		rq->nr_running = 0;
-		rq->clock = 1;
-		update_last_tick_seen(rq);
 		init_cfs_rq(&rq->cfs, rq);
 		init_rt_rq(&rq->rt, rq);
 #ifdef CONFIG_FAIR_GROUP_SCHED
@@ -8294,6 +8157,7 @@ EXPORT_SYMBOL(__might_sleep);
 static void normalize_task(struct rq *rq, struct task_struct *p)
 {
 	int on_rq;
+
 	update_rq_clock(rq);
 	on_rq = p->se.on_rq;
 	if (on_rq)
@@ -8325,7 +8189,6 @@ void normalize_rt_tasks(void)
 		p->se.sleep_start		= 0;
 		p->se.block_start		= 0;
 #endif
-		task_rq(p)->clock		= 0;
 
 		if (!rt_task(p)) {
 			/*
Index: linux-2.6-2/kernel/sched_clock.c
===================================================================
--- /dev/null
+++ linux-2.6-2/kernel/sched_clock.c
@@ -0,0 +1,221 @@
+/*
+ * sched_clock for unstable cpu clocks
+ *
+ *  Copyright (C) 2008 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
+ *
+ * Based on code by:
+ *   Ingo Molnar <mingo@redhat.com>
+ *   Guillaume Chazarain <guichaz@gmail.com>
+ *
+ * Create a semi stable clock from a mixture of other events, including:
+ *  - gtod
+ *  - jiffies
+ *  - sched_clock()
+ *  - explicit idle events
+ *
+ * We use gtod as base and the unstable clock deltas. The deltas are filtered,
+ * making it monotonic and keeping it within an expected window.  This window
+ * is set up using jiffies.
+ *
+ * Furthermore, explicit sleep and wakeup hooks allow us to account for time
+ * that is otherwise invisible (TSC gets stopped).
+ *
+ * The clock: sched_clock_cpu() is monotonic per cpu, and should be somewhat
+ * consistent between cpus (never more than 1 jiffies difference).
+ */
+#include <linux/sched.h>
+#include <linux/percpu.h>
+#include <linux/spinlock.h>
+#include <linux/ktime.h>
+#include <linux/module.h>
+
+
+#ifndef CONFIG_HAVE_STABLE_CLOCK
+
+struct sched_clock_data {
+	spinlock_t lock;
+	unsigned long prev_jiffies;
+	u64 prev_raw;
+	u64 tick_raw;
+	u64 tick_gtod;
+	u64 clock;
+};
+
+static DEFINE_PER_CPU_SHARED_ALIGNED(struct sched_clock_data, sched_clock_data);
+
+static inline struct sched_clock_data *this_scd(void)
+{
+	return &__get_cpu_var(sched_clock_data);
+}
+
+static inline struct sched_clock_data *cpu_sdc(int cpu)
+{
+	return &per_cpu(sched_clock_data, cpu);
+}
+
+void sched_clock_init(void)
+{
+	u64 ktime_now = ktime_to_ns(ktime_get());
+	u64 now = 0; // sched_clock();
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		struct sched_clock_data *scd = cpu_sdc(cpu);
+
+		spin_lock_init(&scd->lock);
+		scd->prev_jiffies = jiffies;
+		scd->prev_raw = now;
+		scd->tick_raw = now;
+		scd->tick_gtod = ktime_now;
+		scd->clock = ktime_now;
+	}
+}
+
+/*
+ * update the percpu scd from the raw @now value
+ *
+ *  - filter out backward motion
+ *  - use jiffies to generate a min,max window to clip the raw values
+ */
+static void __update_sched_clock(struct sched_clock_data *scd, u64 now)
+{
+	unsigned long now_jiffies = jiffies;
+	long delta_jiffies = now_jiffies - scd->prev_jiffies;
+	u64 clock = scd->clock;
+	u64 min_clock, max_clock;
+	s64 delta = now - scd->prev_raw;
+
+	min_clock = scd->tick_gtod + delta_jiffies * TICK_NSEC;
+
+	if (unlikely(delta < 0)) {
+		clock++;
+		goto out;
+	}
+
+	max_clock = min_clock + TICK_NSEC;
+
+	if (unlikely(clock + delta > max_clock)) {
+		if (clock < max_clock)
+			clock = max_clock;
+		else
+			clock++;
+	} else {
+		clock += delta;
+	}
+
+ out:
+	if (unlikely(clock < min_clock))
+		clock = min_clock;
+
+	scd->prev_raw = now;
+	scd->prev_jiffies = now_jiffies;
+	scd->clock = clock;
+}
+
+static void lock_double_clock(struct sched_clock_data *data1,
+			      struct sched_clock_data *data2)
+{
+	if (data1 < data2) {
+		spin_lock(&data1->lock);
+		spin_lock_nested(&data2->lock, SINGLE_DEPTH_NESTING);
+	} else {
+		spin_lock(&data2->lock);
+		spin_lock_nested(&data1->lock, SINGLE_DEPTH_NESTING);
+	}
+}
+
+u64 sched_clock_cpu(int cpu)
+{
+	struct sched_clock_data *scd = cpu_sdc(cpu);
+	u64 now = sched_clock();
+	u64 clock;
+
+	if (cpu != smp_processor_id()) {
+		/*
+		 * in order to update a remote cpu's clock based on our
+		 * unstable raw time rebase it against:
+		 *   tick_raw		(offset between raw counters)
+		 *   tick_gotd          (tick offset between cpus)
+		 */
+		struct sched_clock_data *my_scd = this_scd();
+
+		lock_double_clock(scd, my_scd);
+
+		now -= my_scd->tick_raw;
+		now += scd->tick_raw;
+
+		now -= my_scd->tick_gtod;
+		now += scd->tick_gtod;
+
+		spin_unlock(&my_scd->lock);
+	} else
+		spin_lock(&scd->lock);
+
+	__update_sched_clock(scd, now);
+	clock = scd->clock;
+
+	spin_unlock(&scd->lock);
+
+	return clock;
+}
+
+void sched_clock_tick(void)
+{
+	struct sched_clock_data *scd = this_scd();
+	u64 now;
+
+	spin_lock(&scd->lock);
+	now = sched_clock();
+	__update_sched_clock(scd, now);
+	/*
+	 * update tick_gtod after __update_sched_clock() because that will
+	 * already observe 1 new jiffy; adding a new tick_gtod to that would
+	 * increase the clock 2 jiffies.
+	 */
+	scd->tick_raw = now;
+	scd->tick_gtod = ktime_to_ns(ktime_get()); // XXX get from regular tick
+	spin_unlock(&scd->lock);
+}
+
+/*
+ * We are going deep-idle (irqs are disabled):
+ */
+void sched_clock_idle_sleep_event(void)
+{
+	sched_clock_cpu(smp_processor_id());
+}
+EXPORT_SYMBOL_GPL(sched_clock_idle_sleep_event);
+
+/*
+ * We just idled delta nanoseconds (called with irqs disabled):
+ */
+void sched_clock_idle_wakeup_event(u64 delta_ns)
+{
+	struct sched_clock_data *scd = this_scd();
+
+	/*
+	 * Override the previous timestamp and ignore all
+	 * sched_clock() deltas that occured while we idled,
+	 * and use the PM-provided delta_ns to advance the
+	 * rq clock:
+	 */
+	spin_lock(&scd->lock);
+	scd->prev_raw = sched_clock();
+	scd->clock += delta_ns;
+	spin_unlock(&scd->lock);
+
+	touch_softlockup_watchdog();
+}
+EXPORT_SYMBOL_GPL(sched_clock_idle_wakeup_event);
+
+#endif
+
+/*
+ * Scheduler clock - returns current time in nanosec units.
+ * This is default implementation.
+ * Architectures and sub-architectures can override this.
+ */
+unsigned long long __attribute__((weak)) sched_clock(void)
+{
+	return (unsigned long long)jiffies * (NSEC_PER_SEC / HZ);
+}
Index: linux-2.6-2/include/linux/sched.h
===================================================================
--- linux-2.6-2.orig/include/linux/sched.h
+++ linux-2.6-2/include/linux/sched.h
@@ -1551,6 +1551,35 @@ static inline int set_cpus_allowed(struc
 
 extern unsigned long long sched_clock(void);
 
+#ifdef CONFIG_HAVE_STABLE_CLOCK
+static inline void sched_clock_init(void)
+{
+}
+
+static inline u64 sched_clock_cpu(int cpu)
+{
+	return sched_clock();
+}
+
+static inline void sched_clock_tick(void)
+{
+}
+
+static inline void sched_clock_idle_sleep_event(void)
+{
+}
+
+static inline void sched_clock_idle_wakeup_event(u64 delta_ns)
+{
+}
+#else
+extern void sched_clock_init(void);
+extern u64 sched_clock_cpu(int cpu);
+extern void sched_clock_tick(void);
+extern void sched_clock_idle_sleep_event(void);
+extern void sched_clock_idle_wakeup_event(u64 delta_ns);
+#endif
+
 /*
  * For kernel-internal use: high-speed (but slightly incorrect) per-cpu
  * clock constructed from sched_clock():
Index: linux-2.6-2/kernel/Makefile
===================================================================
--- linux-2.6-2.orig/kernel/Makefile
+++ linux-2.6-2/kernel/Makefile
@@ -9,7 +9,7 @@ obj-y     = sched.o fork.o exec_domain.o
 	    rcupdate.o extable.o params.o posix-timers.o \
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
 	    hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
-	    notifier.o ksysfs.o pm_qos_params.o
+	    notifier.o ksysfs.o pm_qos_params.o sched_clock.o
 
 obj-$(CONFIG_SYSCTL_SYSCALL_CHECK) += sysctl_check.o
 obj-$(CONFIG_STACKTRACE) += stacktrace.o
Index: linux-2.6-2/kernel/sched_debug.c
===================================================================
--- linux-2.6-2.orig/kernel/sched_debug.c
+++ linux-2.6-2/kernel/sched_debug.c
@@ -204,13 +204,6 @@ static void print_cpu(struct seq_file *m
 	PN(next_balance);
 	P(curr->pid);
 	PN(clock);
-	PN(idle_clock);
-	PN(prev_clock_raw);
-	P(clock_warps);
-	P(clock_overflows);
-	P(clock_underflows);
-	P(clock_deep_idle_events);
-	PN(clock_max_delta);
 	P(cpu_load[0]);
 	P(cpu_load[1]);
 	P(cpu_load[2]);
Index: linux-2.6-2/kernel/sched_fair.c
===================================================================
--- linux-2.6-2.orig/kernel/sched_fair.c
+++ linux-2.6-2/kernel/sched_fair.c
@@ -957,7 +957,7 @@ static void yield_task_fair(struct rq *r
 		return;
 
 	if (likely(!sysctl_sched_compat_yield) && curr->policy != SCHED_BATCH) {
-		__update_rq_clock(rq);
+		update_rq_clock(rq);
 		/*
 		 * Update run-time statistics of the 'current'.
 		 */
Index: linux-2.6-2/init/main.c
===================================================================
--- linux-2.6-2.orig/init/main.c
+++ linux-2.6-2/init/main.c
@@ -602,6 +602,7 @@ asmlinkage void __init start_kernel(void
 	softirq_init();
 	timekeeping_init();
 	time_init();
+	sched_clock_init();
 	profile_init();
 	if (!irqs_disabled())
 		printk("start_kernel(): bug: interrupts were enabled early\n");


