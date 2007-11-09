Return-Path: <linux-kernel-owner+w=401wt.eu-S1756668AbXKIWHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668AbXKIWHN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 17:07:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751435AbXKIWHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 17:07:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51344 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213AbXKIWG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 17:06:58 -0500
Date: Fri, 9 Nov 2007 23:06:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] scheduler fixes
Message-ID: <20071109220643.GA23005@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull the latest scheduler git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git

There are two cross-subsystem groups of fixes: three commits that 
resolve a KVM build fix on !SMP - acked by Avi to go in via the 
scheduler git tree because it changes a central include file. The other 
one is a powerpc CPU time accounting regression fix from Paul Mackerras.

The remaining 14 commits: one crash fix (only triggerable via the new 
control-groups filesystem), a delay-accounting regression fix, two 
performance regression fixes, a latency fix, two small 
scheduling-behavior regression fixes and seven cleanups.

Build and boot tested on 64-bit and 32-bit x86.

	Ingo

------------------>
Adrian Bunk (1):
      sched: proper prototype for kernel/sched.c:migration_init()

Balbir Singh (1):
      sched: fix delay accounting regression

Eric Dumazet (1):
      sched: cleanup, use NSEC_PER_MSEC and NSEC_PER_SEC

Ingo Molnar (9):
      sched: reintroduce SMP tunings again
      x86: make ipi_handler() always defined
      x86: make nmi_cpu_busy() always defined
      KVM: fix !SMP build error
      sched: turn off PREEMPT_RESTRICT
      sched: remove PREEMPT_RESTRICT
      sched: wakeup preemption fix
      sched: clean up the wakeup preempt check
      sched: clean up the wakeup preempt check, #2

Paul Mackerras (1):
      sched: restore deterministic CPU accounting on powerpc

Peter Zijlstra (4):
      sched: fix vslice
      sched: documentation: place_entity() comments
      sched: reintroduce the sched_min_granularity tunable
      sched: avoid large irq-latencies in smp-balancing

Srivatsa Vaddagiri (1):
      sched: fix copy_namespace() <-> sched_fork() dependency in do_fork

 arch/powerpc/kernel/process.c   |    2 
 arch/powerpc/kernel/time.c      |   25 ----------
 arch/s390/kernel/time.c         |    4 -
 arch/s390/kernel/vtime.c        |    8 ---
 arch/x86/kernel/cpu/mtrr/main.c |    6 --
 arch/x86/kernel/nmi_32.c        |    4 -
 include/linux/sched.h           |   17 ++++++-
 include/linux/smp.h             |    7 ++
 init/main.c                     |    4 -
 kernel/fork.c                   |    6 +-
 kernel/sched.c                  |   59 ++++++++++++++++++------
 kernel/sched_debug.c            |    2 
 kernel/sched_fair.c             |   96 ++++++++++++++++++++++++----------------
 kernel/sched_stats.h            |   11 ++--
 kernel/sysctl.c                 |   23 +++++++--
 kernel/timer.c                  |   21 +++++---
 16 files changed, 172 insertions(+), 123 deletions(-)

Index: linux/arch/powerpc/kernel/process.c
===================================================================
--- linux.orig/arch/powerpc/kernel/process.c
+++ linux/arch/powerpc/kernel/process.c
@@ -350,7 +350,7 @@ struct task_struct *__switch_to(struct t
 	local_irq_save(flags);
 
 	account_system_vtime(current);
-	account_process_vtime(current);
+	account_process_tick(current, 0);
 	calculate_steal_time();
 
 	last = _switch(old_thread, new_thread);
Index: linux/arch/powerpc/kernel/time.c
===================================================================
--- linux.orig/arch/powerpc/kernel/time.c
+++ linux/arch/powerpc/kernel/time.c
@@ -259,7 +259,7 @@ void account_system_vtime(struct task_st
  * user and system time records.
  * Must be called with interrupts disabled.
  */
-void account_process_vtime(struct task_struct *tsk)
+void account_process_tick(struct task_struct *tsk, int user_tick)
 {
 	cputime_t utime, utimescaled;
 
@@ -274,18 +274,6 @@ void account_process_vtime(struct task_s
 	account_user_time_scaled(tsk, utimescaled);
 }
 
-static void account_process_time(struct pt_regs *regs)
-{
-	int cpu = smp_processor_id();
-
-	account_process_vtime(current);
-	run_local_timers();
-	if (rcu_pending(cpu))
-		rcu_check_callbacks(cpu, user_mode(regs));
-	scheduler_tick();
- 	run_posix_cpu_timers(current);
-}
-
 /*
  * Stuff for accounting stolen time.
  */
@@ -375,7 +363,6 @@ static void snapshot_purr(void)
 
 #else /* ! CONFIG_VIRT_CPU_ACCOUNTING */
 #define calc_cputime_factors()
-#define account_process_time(regs)	update_process_times(user_mode(regs))
 #define calculate_steal_time()		do { } while (0)
 #endif
 
@@ -599,16 +586,6 @@ void timer_interrupt(struct pt_regs * re
 		get_lppaca()->int_dword.fields.decr_int = 0;
 #endif
 
-	/*
-	 * We cannot disable the decrementer, so in the period
-	 * between this cpu's being marked offline in cpu_online_map
-	 * and calling stop-self, it is taking timer interrupts.
-	 * Avoid calling into the scheduler rebalancing code if this
-	 * is the case.
-	 */
-	if (!cpu_is_offline(cpu))
-		account_process_time(regs);
-
 	if (evt->event_handler)
 		evt->event_handler(evt);
 	else
Index: linux/arch/s390/kernel/time.c
===================================================================
--- linux.orig/arch/s390/kernel/time.c
+++ linux/arch/s390/kernel/time.c
@@ -145,12 +145,8 @@ void account_ticks(u64 time)
 	do_timer(ticks);
 #endif
 
-#ifdef CONFIG_VIRT_CPU_ACCOUNTING
-	account_tick_vtime(current);
-#else
 	while (ticks--)
 		update_process_times(user_mode(get_irq_regs()));
-#endif
 
 	s390_do_profile();
 }
Index: linux/arch/s390/kernel/vtime.c
===================================================================
--- linux.orig/arch/s390/kernel/vtime.c
+++ linux/arch/s390/kernel/vtime.c
@@ -32,7 +32,7 @@ static DEFINE_PER_CPU(struct vtimer_queu
  * Update process times based on virtual cpu times stored by entry.S
  * to the lowcore fields user_timer, system_timer & steal_clock.
  */
-void account_tick_vtime(struct task_struct *tsk)
+void account_process_tick(struct task_struct *tsk, int user_tick)
 {
 	cputime_t cputime;
 	__u64 timer, clock;
@@ -64,12 +64,6 @@ void account_tick_vtime(struct task_stru
 		S390_lowcore.steal_clock -= cputime << 12;
 		account_steal_time(tsk, cputime);
 	}
-
-	run_local_timers();
-	if (rcu_pending(smp_processor_id()))
-		rcu_check_callbacks(smp_processor_id(), rcu_user_flag);
-	scheduler_tick();
- 	run_posix_cpu_timers(tsk);
 }
 
 /*
Index: linux/arch/x86/kernel/cpu/mtrr/main.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mtrr/main.c
+++ linux/arch/x86/kernel/cpu/mtrr/main.c
@@ -139,13 +139,12 @@ struct set_mtrr_data {
 	mtrr_type	smp_type;
 };
 
-#ifdef CONFIG_SMP
-
 static void ipi_handler(void *info)
 /*  [SUMMARY] Synchronisation handler. Executed by "other" CPUs.
     [RETURNS] Nothing.
 */
 {
+#ifdef CONFIG_SMP
 	struct set_mtrr_data *data = info;
 	unsigned long flags;
 
@@ -168,9 +167,8 @@ static void ipi_handler(void *info)
 
 	atomic_dec(&data->count);
 	local_irq_restore(flags);
-}
-
 #endif
+}
 
 static inline int types_compatible(mtrr_type type1, mtrr_type type2) {
 	return type1 == MTRR_TYPE_UNCACHABLE ||
Index: linux/arch/x86/kernel/nmi_32.c
===================================================================
--- linux.orig/arch/x86/kernel/nmi_32.c
+++ linux/arch/x86/kernel/nmi_32.c
@@ -51,13 +51,13 @@ static int unknown_nmi_panic_callback(st
 
 static int endflag __initdata = 0;
 
-#ifdef CONFIG_SMP
 /* The performance counters used by NMI_LOCAL_APIC don't trigger when
  * the CPU is idle. To make sure the NMI watchdog really ticks on all
  * CPUs during the test make them busy.
  */
 static __init void nmi_cpu_busy(void *data)
 {
+#ifdef CONFIG_SMP
 	local_irq_enable_in_hardirq();
 	/* Intentionally don't use cpu_relax here. This is
 	   to make sure that the performance counter really ticks,
@@ -67,8 +67,8 @@ static __init void nmi_cpu_busy(void *da
 	   care if they get somewhat less cycles. */
 	while (endflag == 0)
 		mb();
-}
 #endif
+}
 
 static int __init check_nmi_watchdog(void)
 {
Index: linux/include/linux/sched.h
===================================================================
--- linux.orig/include/linux/sched.h
+++ linux/include/linux/sched.h
@@ -254,6 +254,7 @@ long io_schedule_timeout(long timeout);
 
 extern void cpu_init (void);
 extern void trap_init(void);
+extern void account_process_tick(struct task_struct *task, int user);
 extern void update_process_times(int user);
 extern void scheduler_tick(void);
 
@@ -862,7 +863,6 @@ struct sched_entity {
 	struct load_weight	load;		/* for load-balancing */
 	struct rb_node		run_node;
 	unsigned int		on_rq;
-	int			peer_preempt;
 
 	u64			exec_start;
 	u64			sum_exec_runtime;
@@ -1460,12 +1460,17 @@ extern void sched_idle_next(void);
 
 #ifdef CONFIG_SCHED_DEBUG
 extern unsigned int sysctl_sched_latency;
-extern unsigned int sysctl_sched_nr_latency;
+extern unsigned int sysctl_sched_min_granularity;
 extern unsigned int sysctl_sched_wakeup_granularity;
 extern unsigned int sysctl_sched_batch_wakeup_granularity;
 extern unsigned int sysctl_sched_child_runs_first;
 extern unsigned int sysctl_sched_features;
 extern unsigned int sysctl_sched_migration_cost;
+extern unsigned int sysctl_sched_nr_migrate;
+
+int sched_nr_latency_handler(struct ctl_table *table, int write,
+		struct file *file, void __user *buffer, size_t *length,
+		loff_t *ppos);
 #endif
 
 extern unsigned int sysctl_sched_compat_yield;
@@ -1983,6 +1988,14 @@ static inline void inc_syscw(struct task
 }
 #endif
 
+#ifdef CONFIG_SMP
+void migration_init(void);
+#else
+static inline void migration_init(void)
+{
+}
+#endif
+
 #endif /* __KERNEL__ */
 
 #endif
Index: linux/include/linux/smp.h
===================================================================
--- linux.orig/include/linux/smp.h
+++ linux/include/linux/smp.h
@@ -84,11 +84,12 @@ void smp_prepare_boot_cpu(void);
  *	These macros fold the SMP functionality into a single CPU system
  */
 #define raw_smp_processor_id()			0
-static inline int up_smp_call_function(void)
+static inline int up_smp_call_function(void (*func)(void *), void *info)
 {
 	return 0;
 }
-#define smp_call_function(func,info,retry,wait)	(up_smp_call_function())
+#define smp_call_function(func, info, retry, wait) \
+			(up_smp_call_function(func, info))
 #define on_each_cpu(func,info,retry,wait)	\
 	({					\
 		local_irq_disable();		\
@@ -107,6 +108,8 @@ static inline void smp_send_reschedule(i
 	local_irq_enable();	\
 	0;			\
 })
+#define smp_call_function_mask(mask, func, info, wait) \
+			(up_smp_call_function(func, info))
 
 #endif /* !SMP */
 
Index: linux/init/main.c
===================================================================
--- linux.orig/init/main.c
+++ linux/init/main.c
@@ -56,6 +56,7 @@
 #include <linux/pid_namespace.h>
 #include <linux/device.h>
 #include <linux/kthread.h>
+#include <linux/sched.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -747,11 +748,8 @@ __setup("nosoftlockup", nosoftlockup_set
 static void __init do_pre_smp_initcalls(void)
 {
 	extern int spawn_ksoftirqd(void);
-#ifdef CONFIG_SMP
-	extern int migration_init(void);
 
 	migration_init();
-#endif
 	spawn_ksoftirqd();
 	if (!nosoftlockup)
 		spawn_softlockup_task();
Index: linux/kernel/fork.c
===================================================================
--- linux.orig/kernel/fork.c
+++ linux/kernel/fork.c
@@ -1123,6 +1123,9 @@ static struct task_struct *copy_process(
 	p->blocked_on = NULL; /* not blocked yet */
 #endif
 
+	/* Perform scheduler related setup. Assign this task to a CPU. */
+	sched_fork(p, clone_flags);
+
 	if ((retval = security_task_alloc(p)))
 		goto bad_fork_cleanup_policy;
 	if ((retval = audit_alloc(p)))
@@ -1212,9 +1215,6 @@ static struct task_struct *copy_process(
 	INIT_LIST_HEAD(&p->ptrace_children);
 	INIT_LIST_HEAD(&p->ptrace_list);
 
-	/* Perform scheduler related setup. Assign this task to a CPU. */
-	sched_fork(p, clone_flags);
-
 	/* Now that the task is set up, run cgroup callbacks if
 	 * necessary. We need to run them before the task is visible
 	 * on the tasklist. */
Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -75,7 +75,7 @@
  */
 unsigned long long __attribute__((weak)) sched_clock(void)
 {
-	return (unsigned long long)jiffies * (1000000000 / HZ);
+	return (unsigned long long)jiffies * (NSEC_PER_SEC / HZ);
 }
 
 /*
@@ -99,8 +99,8 @@ unsigned long long __attribute__((weak))
 /*
  * Some helpers for converting nanosecond timing to jiffy resolution
  */
-#define NS_TO_JIFFIES(TIME)	((unsigned long)(TIME) / (1000000000 / HZ))
-#define JIFFIES_TO_NS(TIME)	((TIME) * (1000000000 / HZ))
+#define NS_TO_JIFFIES(TIME)	((unsigned long)(TIME) / (NSEC_PER_SEC / HZ))
+#define JIFFIES_TO_NS(TIME)	((TIME) * (NSEC_PER_SEC / HZ))
 
 #define NICE_0_LOAD		SCHED_LOAD_SCALE
 #define NICE_0_SHIFT		SCHED_LOAD_SHIFT
@@ -460,7 +460,6 @@ enum {
 	SCHED_FEAT_TREE_AVG             = 4,
 	SCHED_FEAT_APPROX_AVG           = 8,
 	SCHED_FEAT_WAKEUP_PREEMPT	= 16,
-	SCHED_FEAT_PREEMPT_RESTRICT	= 32,
 };
 
 const_debug unsigned int sysctl_sched_features =
@@ -468,12 +467,17 @@ const_debug unsigned int sysctl_sched_fe
 		SCHED_FEAT_START_DEBIT		* 1 |
 		SCHED_FEAT_TREE_AVG		* 0 |
 		SCHED_FEAT_APPROX_AVG		* 0 |
-		SCHED_FEAT_WAKEUP_PREEMPT	* 1 |
-		SCHED_FEAT_PREEMPT_RESTRICT	* 1;
+		SCHED_FEAT_WAKEUP_PREEMPT	* 1;
 
 #define sched_feat(x) (sysctl_sched_features & SCHED_FEAT_##x)
 
 /*
+ * Number of tasks to iterate in a single balance run.
+ * Limited because this is done with IRQs disabled.
+ */
+const_debug unsigned int sysctl_sched_nr_migrate = 32;
+
+/*
  * For kernel-internal use: high-speed (but slightly incorrect) per-cpu
  * clock constructed from sched_clock():
  */
@@ -2237,7 +2241,7 @@ balance_tasks(struct rq *this_rq, int th
 	      enum cpu_idle_type idle, int *all_pinned,
 	      int *this_best_prio, struct rq_iterator *iterator)
 {
-	int pulled = 0, pinned = 0, skip_for_load;
+	int loops = 0, pulled = 0, pinned = 0, skip_for_load;
 	struct task_struct *p;
 	long rem_load_move = max_load_move;
 
@@ -2251,10 +2255,10 @@ balance_tasks(struct rq *this_rq, int th
 	 */
 	p = iterator->start(iterator->arg);
 next:
-	if (!p)
+	if (!p || loops++ > sysctl_sched_nr_migrate)
 		goto out;
 	/*
-	 * To help distribute high priority tasks accross CPUs we don't
+	 * To help distribute high priority tasks across CPUs we don't
 	 * skip a task if it will be the highest priority task (i.e. smallest
 	 * prio value) on its new queue regardless of its load weight
 	 */
@@ -2271,8 +2275,7 @@ next:
 	rem_load_move -= p->se.load.weight;
 
 	/*
-	 * We only want to steal up to the prescribed number of tasks
-	 * and the prescribed amount of weighted load.
+	 * We only want to steal up to the prescribed amount of weighted load.
 	 */
 	if (rem_load_move > 0) {
 		if (p->prio < *this_best_prio)
@@ -4992,6 +4995,32 @@ void __cpuinit init_idle(struct task_str
  */
 cpumask_t nohz_cpu_mask = CPU_MASK_NONE;
 
+/*
+ * Increase the granularity value when there are more CPUs,
+ * because with more CPUs the 'effective latency' as visible
+ * to users decreases. But the relationship is not linear,
+ * so pick a second-best guess by going with the log2 of the
+ * number of CPUs.
+ *
+ * This idea comes from the SD scheduler of Con Kolivas:
+ */
+static inline void sched_init_granularity(void)
+{
+	unsigned int factor = 1 + ilog2(num_online_cpus());
+	const unsigned long limit = 200000000;
+
+	sysctl_sched_min_granularity *= factor;
+	if (sysctl_sched_min_granularity > limit)
+		sysctl_sched_min_granularity = limit;
+
+	sysctl_sched_latency *= factor;
+	if (sysctl_sched_latency > limit)
+		sysctl_sched_latency = limit;
+
+	sysctl_sched_wakeup_granularity *= factor;
+	sysctl_sched_batch_wakeup_granularity *= factor;
+}
+
 #ifdef CONFIG_SMP
 /*
  * This is how migration works:
@@ -5621,7 +5650,7 @@ static struct notifier_block __cpuinitda
 	.priority = 10
 };
 
-int __init migration_init(void)
+void __init migration_init(void)
 {
 	void *cpu = (void *)(long)smp_processor_id();
 	int err;
@@ -5631,8 +5660,6 @@ int __init migration_init(void)
 	BUG_ON(err == NOTIFY_BAD);
 	migration_call(&migration_notifier, CPU_ONLINE, cpu);
 	register_cpu_notifier(&migration_notifier);
-
-	return 0;
 }
 #endif
 
@@ -6688,10 +6715,12 @@ void __init sched_init_smp(void)
 	/* Move init over to a non-isolated CPU */
 	if (set_cpus_allowed(current, non_isolated_cpus) < 0)
 		BUG();
+	sched_init_granularity();
 }
 #else
 void __init sched_init_smp(void)
 {
+	sched_init_granularity();
 }
 #endif /* CONFIG_SMP */
 
@@ -7228,7 +7257,7 @@ static u64 cpu_usage_read(struct cgroup 
 		spin_unlock_irqrestore(&cpu_rq(i)->lock, flags);
 	}
 	/* Convert from ns to ms */
-	do_div(res, 1000000);
+	do_div(res, NSEC_PER_MSEC);
 
 	return res;
 }
Index: linux/kernel/sched_debug.c
===================================================================
--- linux.orig/kernel/sched_debug.c
+++ linux/kernel/sched_debug.c
@@ -211,7 +211,7 @@ static int sched_debug_show(struct seq_f
 #define PN(x) \
 	SEQ_printf(m, "  .%-40s: %Ld.%06ld\n", #x, SPLIT_NS(x))
 	PN(sysctl_sched_latency);
-	PN(sysctl_sched_nr_latency);
+	PN(sysctl_sched_min_granularity);
 	PN(sysctl_sched_wakeup_granularity);
 	PN(sysctl_sched_batch_wakeup_granularity);
 	PN(sysctl_sched_child_runs_first);
Index: linux/kernel/sched_fair.c
===================================================================
--- linux.orig/kernel/sched_fair.c
+++ linux/kernel/sched_fair.c
@@ -22,7 +22,7 @@
 
 /*
  * Targeted preemption latency for CPU-bound tasks:
- * (default: 20ms, units: nanoseconds)
+ * (default: 20ms * ilog(ncpus), units: nanoseconds)
  *
  * NOTE: this latency value is not the same as the concept of
  * 'timeslice length' - timeslices in CFS are of variable length
@@ -32,19 +32,24 @@
  * (to see the precise effective timeslice length of your workload,
  *  run vmstat and monitor the context-switches (cs) field)
  */
-const_debug unsigned int sysctl_sched_latency = 20000000ULL;
+unsigned int sysctl_sched_latency = 20000000ULL;
 
 /*
- * After fork, child runs first. (default) If set to 0 then
- * parent will (try to) run first.
+ * Minimal preemption granularity for CPU-bound tasks:
+ * (default: 1 msec * ilog(ncpus), units: nanoseconds)
  */
-const_debug unsigned int sysctl_sched_child_runs_first = 1;
+unsigned int sysctl_sched_min_granularity = 1000000ULL;
 
 /*
- * Minimal preemption granularity for CPU-bound tasks:
- * (default: 2 msec, units: nanoseconds)
+ * is kept at sysctl_sched_latency / sysctl_sched_min_granularity
+ */
+unsigned int sched_nr_latency = 20;
+
+/*
+ * After fork, child runs first. (default) If set to 0 then
+ * parent will (try to) run first.
  */
-const_debug unsigned int sysctl_sched_nr_latency = 20;
+const_debug unsigned int sysctl_sched_child_runs_first = 1;
 
 /*
  * sys_sched_yield() compat mode
@@ -56,23 +61,23 @@ unsigned int __read_mostly sysctl_sched_
 
 /*
  * SCHED_BATCH wake-up granularity.
- * (default: 10 msec, units: nanoseconds)
+ * (default: 10 msec * ilog(ncpus), units: nanoseconds)
  *
  * This option delays the preemption effects of decoupled workloads
  * and reduces their over-scheduling. Synchronous workloads will still
  * have immediate wakeup/sleep latencies.
  */
-const_debug unsigned int sysctl_sched_batch_wakeup_granularity = 10000000UL;
+unsigned int sysctl_sched_batch_wakeup_granularity = 10000000UL;
 
 /*
  * SCHED_OTHER wake-up granularity.
- * (default: 10 msec, units: nanoseconds)
+ * (default: 10 msec * ilog(ncpus), units: nanoseconds)
  *
  * This option delays the preemption effects of decoupled workloads
  * and reduces their over-scheduling. Synchronous workloads will still
  * have immediate wakeup/sleep latencies.
  */
-const_debug unsigned int sysctl_sched_wakeup_granularity = 10000000UL;
+unsigned int sysctl_sched_wakeup_granularity = 10000000UL;
 
 const_debug unsigned int sysctl_sched_migration_cost = 500000UL;
 
@@ -212,6 +217,22 @@ static inline struct sched_entity *__pic
  * Scheduling class statistics methods:
  */
 
+#ifdef CONFIG_SCHED_DEBUG
+int sched_nr_latency_handler(struct ctl_table *table, int write,
+		struct file *filp, void __user *buffer, size_t *lenp,
+		loff_t *ppos)
+{
+	int ret = proc_dointvec_minmax(table, write, filp, buffer, lenp, ppos);
+
+	if (ret || !write)
+		return ret;
+
+	sched_nr_latency = DIV_ROUND_UP(sysctl_sched_latency,
+					sysctl_sched_min_granularity);
+
+	return 0;
+}
+#endif
 
 /*
  * The idea is to set a period in which each task runs once.
@@ -224,7 +245,7 @@ static inline struct sched_entity *__pic
 static u64 __sched_period(unsigned long nr_running)
 {
 	u64 period = sysctl_sched_latency;
-	unsigned long nr_latency = sysctl_sched_nr_latency;
+	unsigned long nr_latency = sched_nr_latency;
 
 	if (unlikely(nr_running > nr_latency)) {
 		period *= nr_running;
@@ -259,6 +280,7 @@ static u64 __sched_vslice(unsigned long 
 {
 	u64 vslice = __sched_period(nr_running);
 
+	vslice *= NICE_0_LOAD;
 	do_div(vslice, rq_weight);
 
 	return vslice;
@@ -472,19 +494,26 @@ place_entity(struct cfs_rq *cfs_rq, stru
 	} else if (sched_feat(APPROX_AVG) && cfs_rq->nr_running)
 		vruntime += sched_vslice(cfs_rq)/2;
 
+	/*
+	 * The 'current' period is already promised to the current tasks,
+	 * however the extra weight of the new task will slow them down a
+	 * little, place the new task so that it fits in the slot that
+	 * stays open at the end.
+	 */
 	if (initial && sched_feat(START_DEBIT))
 		vruntime += sched_vslice_add(cfs_rq, se);
 
 	if (!initial) {
+		/* sleeps upto a single latency don't count. */
 		if (sched_feat(NEW_FAIR_SLEEPERS) && entity_is_task(se) &&
 				task_of(se)->policy != SCHED_BATCH)
 			vruntime -= sysctl_sched_latency;
 
-		vruntime = max_t(s64, vruntime, se->vruntime);
+		/* ensure we never gain time by being placed backwards. */
+		vruntime = max_vruntime(se->vruntime, vruntime);
 	}
 
 	se->vruntime = vruntime;
-
 }
 
 static void
@@ -517,7 +546,6 @@ dequeue_entity(struct cfs_rq *cfs_rq, st
 
 	update_stats_dequeue(cfs_rq, se);
 	if (sleep) {
-		se->peer_preempt = 0;
 #ifdef CONFIG_SCHEDSTATS
 		if (entity_is_task(se)) {
 			struct task_struct *tsk = task_of(se);
@@ -545,10 +573,8 @@ check_preempt_tick(struct cfs_rq *cfs_rq
 
 	ideal_runtime = sched_slice(cfs_rq, curr);
 	delta_exec = curr->sum_exec_runtime - curr->prev_sum_exec_runtime;
-	if (delta_exec > ideal_runtime ||
-			(sched_feat(PREEMPT_RESTRICT) && curr->peer_preempt))
+	if (delta_exec > ideal_runtime)
 		resched_task(rq_of(cfs_rq)->curr);
-	curr->peer_preempt = 0;
 }
 
 static void
@@ -811,7 +837,7 @@ static void check_preempt_wakeup(struct 
 	struct task_struct *curr = rq->curr;
 	struct cfs_rq *cfs_rq = task_cfs_rq(curr);
 	struct sched_entity *se = &curr->se, *pse = &p->se;
-	s64 delta, gran;
+	unsigned long gran;
 
 	if (unlikely(rt_prio(p->prio))) {
 		update_rq_clock(rq);
@@ -826,24 +852,20 @@ static void check_preempt_wakeup(struct 
 	if (unlikely(p->policy == SCHED_BATCH))
 		return;
 
-	if (sched_feat(WAKEUP_PREEMPT)) {
-		while (!is_same_group(se, pse)) {
-			se = parent_entity(se);
-			pse = parent_entity(pse);
-		}
+	if (!sched_feat(WAKEUP_PREEMPT))
+		return;
 
-		delta = se->vruntime - pse->vruntime;
-		gran = sysctl_sched_wakeup_granularity;
-		if (unlikely(se->load.weight != NICE_0_LOAD))
-			gran = calc_delta_fair(gran, &se->load);
+	while (!is_same_group(se, pse)) {
+		se = parent_entity(se);
+		pse = parent_entity(pse);
+	}
 
-		if (delta > gran) {
-			int now = !sched_feat(PREEMPT_RESTRICT);
+	gran = sysctl_sched_wakeup_granularity;
+	if (unlikely(se->load.weight != NICE_0_LOAD))
+		gran = calc_delta_fair(gran, &se->load);
 
-			if (now || p->prio < curr->prio || !se->peer_preempt++)
-				resched_task(curr);
-		}
-	}
+	if (pse->vruntime + gran < se->vruntime)
+		resched_task(curr);
 }
 
 static struct task_struct *pick_next_task_fair(struct rq *rq)
@@ -1045,8 +1067,9 @@ static void task_new_fair(struct rq *rq,
 	update_curr(cfs_rq);
 	place_entity(cfs_rq, se, 1);
 
+	/* 'curr' will be NULL if the child belongs to a different group */
 	if (sysctl_sched_child_runs_first && this_cpu == task_cpu(p) &&
-			curr->vruntime < se->vruntime) {
+			curr && curr->vruntime < se->vruntime) {
 		/*
 		 * Upon rescheduling, sched_class::put_prev_task() will place
 		 * 'current' within the tree based on its new key value.
@@ -1054,7 +1077,6 @@ static void task_new_fair(struct rq *rq,
 		swap(curr->vruntime, se->vruntime);
 	}
 
-	se->peer_preempt = 0;
 	enqueue_task_fair(rq, p, 0);
 	resched_task(rq->curr);
 }
Index: linux/kernel/sched_stats.h
===================================================================
--- linux.orig/kernel/sched_stats.h
+++ linux/kernel/sched_stats.h
@@ -127,7 +127,7 @@ rq_sched_info_depart(struct rq *rq, unsi
 # define schedstat_set(var, val)	do { } while (0)
 #endif
 
-#ifdef CONFIG_SCHEDSTATS
+#if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
 /*
  * Called when a process is dequeued from the active array and given
  * the cpu.  We should note that with the exception of interactive
@@ -155,7 +155,7 @@ static inline void sched_info_dequeued(s
  */
 static void sched_info_arrive(struct task_struct *t)
 {
-	unsigned long long now = sched_clock(), delta = 0;
+	unsigned long long now = task_rq(t)->clock, delta = 0;
 
 	if (t->sched_info.last_queued)
 		delta = now - t->sched_info.last_queued;
@@ -186,7 +186,7 @@ static inline void sched_info_queued(str
 {
 	if (unlikely(sched_info_on()))
 		if (!t->sched_info.last_queued)
-			t->sched_info.last_queued = sched_clock();
+			t->sched_info.last_queued = task_rq(t)->clock;
 }
 
 /*
@@ -195,7 +195,8 @@ static inline void sched_info_queued(str
  */
 static inline void sched_info_depart(struct task_struct *t)
 {
-	unsigned long long delta = sched_clock() - t->sched_info.last_arrival;
+	unsigned long long delta = task_rq(t)->clock -
+					t->sched_info.last_arrival;
 
 	t->sched_info.cpu_time += delta;
 	rq_sched_info_depart(task_rq(t), delta);
@@ -231,5 +232,5 @@ sched_info_switch(struct task_struct *pr
 #else
 #define sched_info_queued(t)		do { } while (0)
 #define sched_info_switch(t, next)	do { } while (0)
-#endif /* CONFIG_SCHEDSTATS */
+#endif /* CONFIG_SCHEDSTATS || CONFIG_TASK_DELAY_ACCT */
 
Index: linux/kernel/sysctl.c
===================================================================
--- linux.orig/kernel/sysctl.c
+++ linux/kernel/sysctl.c
@@ -226,20 +226,23 @@ static struct ctl_table root_table[] = {
 
 #ifdef CONFIG_SCHED_DEBUG
 static unsigned long min_sched_granularity_ns = 100000;		/* 100 usecs */
-static unsigned long max_sched_granularity_ns = 1000000000;	/* 1 second */
+static unsigned long max_sched_granularity_ns = NSEC_PER_SEC;	/* 1 second */
 static unsigned long min_wakeup_granularity_ns;			/* 0 usecs */
-static unsigned long max_wakeup_granularity_ns = 1000000000;	/* 1 second */
+static unsigned long max_wakeup_granularity_ns = NSEC_PER_SEC;	/* 1 second */
 #endif
 
 static struct ctl_table kern_table[] = {
 #ifdef CONFIG_SCHED_DEBUG
 	{
 		.ctl_name	= CTL_UNNUMBERED,
-		.procname	= "sched_nr_latency",
-		.data		= &sysctl_sched_nr_latency,
+		.procname	= "sched_min_granularity_ns",
+		.data		= &sysctl_sched_min_granularity,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= &sched_nr_latency_handler,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &min_sched_granularity_ns,
+		.extra2		= &max_sched_granularity_ns,
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
@@ -247,7 +250,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_sched_latency,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= &sched_nr_latency_handler,
 		.strategy	= &sysctl_intvec,
 		.extra1		= &min_sched_granularity_ns,
 		.extra2		= &max_sched_granularity_ns,
@@ -298,6 +301,14 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
 	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "sched_nr_migrate",
+		.data		= &sysctl_sched_nr_migrate,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 644,
+		.proc_handler	= &proc_dointvec,
+	},
 #endif
 	{
 		.ctl_name	= CTL_UNNUMBERED,
Index: linux/kernel/timer.c
===================================================================
--- linux.orig/kernel/timer.c
+++ linux/kernel/timer.c
@@ -817,6 +817,19 @@ unsigned long next_timer_interrupt(void)
 
 #endif
 
+#ifndef CONFIG_VIRT_CPU_ACCOUNTING
+void account_process_tick(struct task_struct *p, int user_tick)
+{
+	if (user_tick) {
+		account_user_time(p, jiffies_to_cputime(1));
+		account_user_time_scaled(p, jiffies_to_cputime(1));
+	} else {
+		account_system_time(p, HARDIRQ_OFFSET, jiffies_to_cputime(1));
+		account_system_time_scaled(p, jiffies_to_cputime(1));
+	}
+}
+#endif
+
 /*
  * Called from the timer interrupt handler to charge one tick to the current
  * process.  user_tick is 1 if the tick is user time, 0 for system.
@@ -827,13 +840,7 @@ void update_process_times(int user_tick)
 	int cpu = smp_processor_id();
 
 	/* Note: this timer irq context must be accounted for as well. */
-	if (user_tick) {
-		account_user_time(p, jiffies_to_cputime(1));
-		account_user_time_scaled(p, jiffies_to_cputime(1));
-	} else {
-		account_system_time(p, HARDIRQ_OFFSET, jiffies_to_cputime(1));
-		account_system_time_scaled(p, jiffies_to_cputime(1));
-	}
+	account_process_tick(p, user_tick);
 	run_local_timers();
 	if (rcu_pending(cpu))
 		rcu_check_callbacks(cpu, user_tick);
