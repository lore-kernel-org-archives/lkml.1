Return-Path: <linux-kernel-owner+w=401wt.eu-S1755927AbYHKWZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927AbYHKWZR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 18:25:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753438AbYHKWY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 18:24:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56843 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753256AbYHKWYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 18:24:55 -0400
Date: Tue, 12 Aug 2008 00:24:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] scheduler fixes for -rc3
Message-ID: <20080811222440.GA22792@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

Thanks,

	Ingo

------------------>
Dmitry Adamushko (1):
      sched, cpu hotplug: fix set_cpus_allowed() use in hotplug callbacks

Hugh Dickins (1):
      sched: move sched_clock before first use

Ingo Molnar (5):
      sched clock: revert various sched_clock() changes
      sched clock: clean up sched_clock_cpu()
      sched: eliminate scd->prev_raw
      sched clock: simplify __update_sched_clock()
      sched clock: couple local and remote clocks

Mike Galbraith (1):
      sched: fix mysql+oltp regression

OGAWA Hirofumi (1):
      sched: fix SCHED_HRTICK dependency

Peter Zijlstra (2):
      sched: fix warning in hrtick_start_fair()
      sched_clock: delay using sched_clock()

roel kluin (1):
      sched: test runtime rather than period in global_rt_runtime()


 include/linux/sched.h    |   31 +-------
 kernel/Kconfig.hz        |    2 +-
 kernel/cpu.c             |    5 +-
 kernel/sched.c           |    2 +-
 kernel/sched_clock.c     |  178 ++++++++++++++-------------------------------
 kernel/sched_fair.c      |   21 ++++--
 kernel/time/tick-sched.c |    2 -
 7 files changed, 77 insertions(+), 164 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5270d44..5850bfb 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1551,16 +1551,10 @@ static inline int set_cpus_allowed(struct task_struct *p, cpumask_t new_mask)
 
 extern unsigned long long sched_clock(void);
 
-#ifndef CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
-static inline void sched_clock_init(void)
-{
-}
-
-static inline u64 sched_clock_cpu(int cpu)
-{
-	return sched_clock();
-}
+extern void sched_clock_init(void);
+extern u64 sched_clock_cpu(int cpu);
 
+#ifndef CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
 static inline void sched_clock_tick(void)
 {
 }
@@ -1572,28 +1566,11 @@ static inline void sched_clock_idle_sleep_event(void)
 static inline void sched_clock_idle_wakeup_event(u64 delta_ns)
 {
 }
-
-#ifdef CONFIG_NO_HZ
-static inline void sched_clock_tick_stop(int cpu)
-{
-}
-
-static inline void sched_clock_tick_start(int cpu)
-{
-}
-#endif
-
-#else /* CONFIG_HAVE_UNSTABLE_SCHED_CLOCK */
-extern void sched_clock_init(void);
-extern u64 sched_clock_cpu(int cpu);
+#else
 extern void sched_clock_tick(void);
 extern void sched_clock_idle_sleep_event(void);
 extern void sched_clock_idle_wakeup_event(u64 delta_ns);
-#ifdef CONFIG_NO_HZ
-extern void sched_clock_tick_stop(int cpu);
-extern void sched_clock_tick_start(int cpu);
 #endif
-#endif /* CONFIG_HAVE_UNSTABLE_SCHED_CLOCK */
 
 /*
  * For kernel-internal use: high-speed (but slightly incorrect) per-cpu
diff --git a/kernel/Kconfig.hz b/kernel/Kconfig.hz
index 382dd5a..94fabd5 100644
--- a/kernel/Kconfig.hz
+++ b/kernel/Kconfig.hz
@@ -55,4 +55,4 @@ config HZ
 	default 1000 if HZ_1000
 
 config SCHED_HRTICK
-	def_bool HIGH_RES_TIMERS && USE_GENERIC_SMP_HELPERS
+	def_bool HIGH_RES_TIMERS && (!SMP || USE_GENERIC_SMP_HELPERS)
diff --git a/kernel/cpu.c b/kernel/cpu.c
index e202a68..c977c33 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -349,6 +349,8 @@ static int __cpuinit _cpu_up(unsigned int cpu, int tasks_frozen)
 		goto out_notify;
 	BUG_ON(!cpu_online(cpu));
 
+	cpu_set(cpu, cpu_active_map);
+
 	/* Now call notifier in preparation. */
 	raw_notifier_call_chain(&cpu_chain, CPU_ONLINE | mod, hcpu);
 
@@ -383,9 +385,6 @@ int __cpuinit cpu_up(unsigned int cpu)
 
 	err = _cpu_up(cpu, 0);
 
-	if (cpu_online(cpu))
-		cpu_set(cpu, cpu_active_map);
-
 out:
 	cpu_maps_update_done();
 	return err;
diff --git a/kernel/sched.c b/kernel/sched.c
index 04160d2..f014194 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -834,7 +834,7 @@ static inline u64 global_rt_period(void)
 
 static inline u64 global_rt_runtime(void)
 {
-	if (sysctl_sched_rt_period < 0)
+	if (sysctl_sched_rt_runtime < 0)
 		return RUNTIME_INF;
 
 	return (u64)sysctl_sched_rt_runtime * NSEC_PER_USEC;
diff --git a/kernel/sched_clock.c b/kernel/sched_clock.c
index 22ed55d..204991a 100644
--- a/kernel/sched_clock.c
+++ b/kernel/sched_clock.c
@@ -32,13 +32,19 @@
 #include <linux/ktime.h>
 #include <linux/module.h>
 
+/*
+ * Scheduler clock - returns current time in nanosec units.
+ * This is default implementation.
+ * Architectures and sub-architectures can override this.
+ */
+unsigned long long __attribute__((weak)) sched_clock(void)
+{
+	return (unsigned long long)jiffies * (NSEC_PER_SEC / HZ);
+}
 
-#ifdef CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
+static __read_mostly int sched_clock_running;
 
-#define MULTI_SHIFT 15
-/* Max is double, Min is 1/2 */
-#define MAX_MULTI (2LL << MULTI_SHIFT)
-#define MIN_MULTI (1LL << (MULTI_SHIFT-1))
+#ifdef CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
 
 struct sched_clock_data {
 	/*
@@ -49,14 +55,9 @@ struct sched_clock_data {
 	raw_spinlock_t		lock;
 
 	unsigned long		tick_jiffies;
-	u64			prev_raw;
 	u64			tick_raw;
 	u64			tick_gtod;
 	u64			clock;
-	s64			multi;
-#ifdef CONFIG_NO_HZ
-	int			check_max;
-#endif
 };
 
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct sched_clock_data, sched_clock_data);
@@ -71,8 +72,6 @@ static inline struct sched_clock_data *cpu_sdc(int cpu)
 	return &per_cpu(sched_clock_data, cpu);
 }
 
-static __read_mostly int sched_clock_running;
-
 void sched_clock_init(void)
 {
 	u64 ktime_now = ktime_to_ns(ktime_get());
@@ -84,90 +83,39 @@ void sched_clock_init(void)
 
 		scd->lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
 		scd->tick_jiffies = now_jiffies;
-		scd->prev_raw = 0;
 		scd->tick_raw = 0;
 		scd->tick_gtod = ktime_now;
 		scd->clock = ktime_now;
-		scd->multi = 1 << MULTI_SHIFT;
-#ifdef CONFIG_NO_HZ
-		scd->check_max = 1;
-#endif
 	}
 
 	sched_clock_running = 1;
 }
 
-#ifdef CONFIG_NO_HZ
-/*
- * The dynamic ticks makes the delta jiffies inaccurate. This
- * prevents us from checking the maximum time update.
- * Disable the maximum check during stopped ticks.
- */
-void sched_clock_tick_stop(int cpu)
-{
-	struct sched_clock_data *scd = cpu_sdc(cpu);
-
-	scd->check_max = 0;
-}
-
-void sched_clock_tick_start(int cpu)
-{
-	struct sched_clock_data *scd = cpu_sdc(cpu);
-
-	scd->check_max = 1;
-}
-
-static int check_max(struct sched_clock_data *scd)
-{
-	return scd->check_max;
-}
-#else
-static int check_max(struct sched_clock_data *scd)
-{
-	return 1;
-}
-#endif /* CONFIG_NO_HZ */
-
 /*
  * update the percpu scd from the raw @now value
  *
  *  - filter out backward motion
  *  - use jiffies to generate a min,max window to clip the raw values
  */
-static void __update_sched_clock(struct sched_clock_data *scd, u64 now, u64 *time)
+static u64 __update_sched_clock(struct sched_clock_data *scd, u64 now)
 {
 	unsigned long now_jiffies = jiffies;
 	long delta_jiffies = now_jiffies - scd->tick_jiffies;
 	u64 clock = scd->clock;
 	u64 min_clock, max_clock;
-	s64 delta = now - scd->prev_raw;
+	s64 delta = now - scd->tick_raw;
 
 	WARN_ON_ONCE(!irqs_disabled());
-
-	/*
-	 * At schedule tick the clock can be just under the gtod. We don't
-	 * want to push it too prematurely.
-	 */
-	min_clock = scd->tick_gtod + (delta_jiffies * TICK_NSEC);
-	if (min_clock > TICK_NSEC)
-		min_clock -= TICK_NSEC / 2;
+	min_clock = scd->tick_gtod + delta_jiffies * TICK_NSEC;
 
 	if (unlikely(delta < 0)) {
 		clock++;
 		goto out;
 	}
 
-	/*
-	 * The clock must stay within a jiffie of the gtod.
-	 * But since we may be at the start of a jiffy or the end of one
-	 * we add another jiffy buffer.
-	 */
-	max_clock = scd->tick_gtod + (2 + delta_jiffies) * TICK_NSEC;
-
-	delta *= scd->multi;
-	delta >>= MULTI_SHIFT;
+	max_clock = min_clock + TICK_NSEC;
 
-	if (unlikely(clock + delta > max_clock) && check_max(scd)) {
+	if (unlikely(clock + delta > max_clock)) {
 		if (clock < max_clock)
 			clock = max_clock;
 		else
@@ -180,12 +128,10 @@ static void __update_sched_clock(struct sched_clock_data *scd, u64 now, u64 *tim
 	if (unlikely(clock < min_clock))
 		clock = min_clock;
 
-	if (time)
-		*time = clock;
-	else {
-		scd->prev_raw = now;
-		scd->clock = clock;
-	}
+	scd->tick_jiffies = now_jiffies;
+	scd->clock = clock;
+
+	return clock;
 }
 
 static void lock_double_clock(struct sched_clock_data *data1,
@@ -203,7 +149,7 @@ static void lock_double_clock(struct sched_clock_data *data1,
 u64 sched_clock_cpu(int cpu)
 {
 	struct sched_clock_data *scd = cpu_sdc(cpu);
-	u64 now, clock;
+	u64 now, clock, this_clock, remote_clock;
 
 	if (unlikely(!sched_clock_running))
 		return 0ull;
@@ -212,43 +158,44 @@ u64 sched_clock_cpu(int cpu)
 	now = sched_clock();
 
 	if (cpu != raw_smp_processor_id()) {
-		/*
-		 * in order to update a remote cpu's clock based on our
-		 * unstable raw time rebase it against:
-		 *   tick_raw		(offset between raw counters)
-		 *   tick_gotd          (tick offset between cpus)
-		 */
 		struct sched_clock_data *my_scd = this_scd();
 
 		lock_double_clock(scd, my_scd);
 
-		now -= my_scd->tick_raw;
-		now += scd->tick_raw;
+		this_clock = __update_sched_clock(my_scd, now);
+		remote_clock = scd->clock;
 
-		now += my_scd->tick_gtod;
-		now -= scd->tick_gtod;
+		/*
+		 * Use the opportunity that we have both locks
+		 * taken to couple the two clocks: we take the
+		 * larger time as the latest time for both
+		 * runqueues. (this creates monotonic movement)
+		 */
+		if (likely(remote_clock < this_clock)) {
+			clock = this_clock;
+			scd->clock = clock;
+		} else {
+			/*
+			 * Should be rare, but possible:
+			 */
+			clock = remote_clock;
+			my_scd->clock = remote_clock;
+		}
 
 		__raw_spin_unlock(&my_scd->lock);
-
-		__update_sched_clock(scd, now, &clock);
-
-		__raw_spin_unlock(&scd->lock);
-
 	} else {
 		__raw_spin_lock(&scd->lock);
-		__update_sched_clock(scd, now, NULL);
-		clock = scd->clock;
-		__raw_spin_unlock(&scd->lock);
+		clock = __update_sched_clock(scd, now);
 	}
 
+	__raw_spin_unlock(&scd->lock);
+
 	return clock;
 }
 
 void sched_clock_tick(void)
 {
 	struct sched_clock_data *scd = this_scd();
-	unsigned long now_jiffies = jiffies;
-	s64 mult, delta_gtod, delta_raw;
 	u64 now, now_gtod;
 
 	if (unlikely(!sched_clock_running))
@@ -260,29 +207,14 @@ void sched_clock_tick(void)
 	now = sched_clock();
 
 	__raw_spin_lock(&scd->lock);
-	__update_sched_clock(scd, now, NULL);
+	__update_sched_clock(scd, now);
 	/*
 	 * update tick_gtod after __update_sched_clock() because that will
 	 * already observe 1 new jiffy; adding a new tick_gtod to that would
 	 * increase the clock 2 jiffies.
 	 */
-	delta_gtod = now_gtod - scd->tick_gtod;
-	delta_raw = now - scd->tick_raw;
-
-	if ((long)delta_raw > 0) {
-		mult = delta_gtod << MULTI_SHIFT;
-		do_div(mult, delta_raw);
-		scd->multi = mult;
-		if (scd->multi > MAX_MULTI)
-			scd->multi = MAX_MULTI;
-		else if (scd->multi < MIN_MULTI)
-			scd->multi = MIN_MULTI;
-	} else
-		scd->multi = 1 << MULTI_SHIFT;
-
 	scd->tick_raw = now;
 	scd->tick_gtod = now_gtod;
-	scd->tick_jiffies = now_jiffies;
 	__raw_spin_unlock(&scd->lock);
 }
 
@@ -301,7 +233,6 @@ EXPORT_SYMBOL_GPL(sched_clock_idle_sleep_event);
 void sched_clock_idle_wakeup_event(u64 delta_ns)
 {
 	struct sched_clock_data *scd = this_scd();
-	u64 now = sched_clock();
 
 	/*
 	 * Override the previous timestamp and ignore all
@@ -310,27 +241,30 @@ void sched_clock_idle_wakeup_event(u64 delta_ns)
 	 * rq clock:
 	 */
 	__raw_spin_lock(&scd->lock);
-	scd->prev_raw = now;
 	scd->clock += delta_ns;
-	scd->multi = 1 << MULTI_SHIFT;
 	__raw_spin_unlock(&scd->lock);
 
 	touch_softlockup_watchdog();
 }
 EXPORT_SYMBOL_GPL(sched_clock_idle_wakeup_event);
 
-#endif
+#else /* CONFIG_HAVE_UNSTABLE_SCHED_CLOCK */
 
-/*
- * Scheduler clock - returns current time in nanosec units.
- * This is default implementation.
- * Architectures and sub-architectures can override this.
- */
-unsigned long long __attribute__((weak)) sched_clock(void)
+void sched_clock_init(void)
 {
-	return (unsigned long long)jiffies * (NSEC_PER_SEC / HZ);
+	sched_clock_running = 1;
 }
 
+u64 sched_clock_cpu(int cpu)
+{
+	if (unlikely(!sched_clock_running))
+		return 0;
+
+	return sched_clock();
+}
+
+#endif
+
 unsigned long long cpu_clock(int cpu)
 {
 	unsigned long long clock;
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index cf2cd6c..fb8994c 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -899,7 +899,7 @@ static void hrtick_start_fair(struct rq *rq, struct task_struct *p)
 		 * doesn't make sense. Rely on vruntime for fairness.
 		 */
 		if (rq->curr != p)
-			delta = max(10000LL, delta);
+			delta = max_t(s64, 10000LL, delta);
 
 		hrtick_start(rq, delta);
 	}
@@ -1442,18 +1442,23 @@ __load_balance_iterator(struct cfs_rq *cfs_rq, struct list_head *next)
 	struct task_struct *p = NULL;
 	struct sched_entity *se;
 
-	while (next != &cfs_rq->tasks) {
+	if (next == &cfs_rq->tasks)
+		return NULL;
+
+	/* Skip over entities that are not tasks */
+	do {
 		se = list_entry(next, struct sched_entity, group_node);
 		next = next->next;
+	} while (next != &cfs_rq->tasks && !entity_is_task(se));
 
-		/* Skip over entities that are not tasks */
-		if (entity_is_task(se)) {
-			p = task_of(se);
-			break;
-		}
-	}
+	if (next == &cfs_rq->tasks)
+		return NULL;
 
 	cfs_rq->balance_iterator = next;
+
+	if (entity_is_task(se))
+		p = task_of(se);
+
 	return p;
 }
 
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 825b4c0..f5da526 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -289,7 +289,6 @@ void tick_nohz_stop_sched_tick(int inidle)
 			ts->tick_stopped = 1;
 			ts->idle_jiffies = last_jiffies;
 			rcu_enter_nohz();
-			sched_clock_tick_stop(cpu);
 		}
 
 		/*
@@ -392,7 +391,6 @@ void tick_nohz_restart_sched_tick(void)
 	select_nohz_load_balancer(0);
 	now = ktime_get();
 	tick_do_update_jiffies64(now);
-	sched_clock_tick_start(cpu);
 	cpu_clear(cpu, nohz_cpu_mask);
 
 	/*
