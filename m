Return-Path: <linux-kernel-owner+w=401wt.eu-S1751561AbYGUPik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751561AbYGUPik (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 11:38:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750763AbYGUPib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 11:38:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54573 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736AbYGUPi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 11:38:29 -0400
Date: Mon, 21 Jul 2008 17:38:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] scheduler updates for v2.6.27, phase #2
Message-ID: <20080721153804.GA26072@elte.hu>
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

Please pull the latest sched/for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched/for-linus

this includes the cpu_active_map changes (which cleans up scheduler and 
CPU hotplug interaction) and Peter's hrtick cleanup (which fixes the 
uvesafb regression) and assorted fixlets.

Thanks,

	Ingo

------------------>
David Howells (1):
      sched: fix warning in inc_rt_tasks() to not declare variable 'rq' if it's not needed

Dmitry Adamushko (1):
      sched: rework of "prioritize non-migratable tasks over migratable ones"

Ingo Molnar (3):
      Revert parts of "ftrace: do not trace scheduler functions"
      sched: fix build error, provide partition_sched_domains() unconditionally
      sched: hrtick_enabled() should use cpu_active()

Max Krasnyansky (2):
      cpu hotplug, sched: Introduce cpu_active_map and redo sched domain managment (take 2)
      cpu hotplug: Make cpu_active_map synchronization dependency clear

Mike Travis (1):
      sched: reduce stack size in isolated_cpu_setup()

Peter Zijlstra (1):
      sched, x86: clean up hrtick implementation


 arch/x86/kernel/signal_32.c   |    3 -
 arch/x86/kernel/signal_64.c   |    3 -
 include/asm-x86/thread_info.h |    4 +-
 include/linux/cpumask.h       |    6 +-
 include/linux/cpuset.h        |    7 +
 include/linux/sched.h         |   11 ++-
 init/main.c                   |    7 +
 kernel/Kconfig.hz             |    2 +-
 kernel/Makefile               |    2 +
 kernel/cpu.c                  |   40 +++++-
 kernel/cpuset.c               |    2 +-
 kernel/sched.c                |  313 ++++++++++++++---------------------------
 kernel/sched_fair.c           |    8 +-
 kernel/sched_rt.c             |   77 +++++++----
 14 files changed, 229 insertions(+), 256 deletions(-)

diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index d923736..e1fc7bd 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -667,8 +667,5 @@ do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
 	if (thread_info_flags & _TIF_SIGPENDING)
 		do_signal(regs);
 
-	if (thread_info_flags & _TIF_HRTICK_RESCHED)
-		hrtick_resched();
-
 	clear_thread_flag(TIF_IRET);
 }
diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index e53b267..88023fc 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -502,9 +502,6 @@ void do_notify_resume(struct pt_regs *regs, void *unused,
 	/* deal with pending signal delivery */
 	if (thread_info_flags & _TIF_SIGPENDING)
 		do_signal(regs);
-
-	if (thread_info_flags & _TIF_HRTICK_RESCHED)
-		hrtick_resched();
 }
 
 void signal_fault(struct pt_regs *regs, void __user *frame, char *where)
diff --git a/include/asm-x86/thread_info.h b/include/asm-x86/thread_info.h
index 895339d..d701263 100644
--- a/include/asm-x86/thread_info.h
+++ b/include/asm-x86/thread_info.h
@@ -81,7 +81,6 @@ struct thread_info {
 #define TIF_SYSCALL_AUDIT	7	/* syscall auditing active */
 #define TIF_SECCOMP		8	/* secure computing */
 #define TIF_MCE_NOTIFY		10	/* notify userspace of an MCE */
-#define TIF_HRTICK_RESCHED	11	/* reprogram hrtick timer */
 #define TIF_NOTSC		16	/* TSC is not accessible in userland */
 #define TIF_IA32		17	/* 32bit process */
 #define TIF_FORK		18	/* ret_from_fork */
@@ -108,7 +107,6 @@ struct thread_info {
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
 #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
 #define _TIF_MCE_NOTIFY		(1 << TIF_MCE_NOTIFY)
-#define _TIF_HRTICK_RESCHED	(1 << TIF_HRTICK_RESCHED)
 #define _TIF_NOTSC		(1 << TIF_NOTSC)
 #define _TIF_IA32		(1 << TIF_IA32)
 #define _TIF_FORK		(1 << TIF_FORK)
@@ -132,7 +130,7 @@ struct thread_info {
 
 /* Only used for 64 bit */
 #define _TIF_DO_NOTIFY_MASK						\
-	(_TIF_SIGPENDING|_TIF_SINGLESTEP|_TIF_MCE_NOTIFY|_TIF_HRTICK_RESCHED)
+	(_TIF_SIGPENDING|_TIF_SINGLESTEP|_TIF_MCE_NOTIFY)
 
 /* flags to check in __switch_to() */
 #define _TIF_WORK_CTXSW							\
diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index c24875b..d614d24 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -359,13 +359,14 @@ static inline void __cpus_fold(cpumask_t *dstp, const cpumask_t *origp,
 
 /*
  * The following particular system cpumasks and operations manage
- * possible, present and online cpus.  Each of them is a fixed size
+ * possible, present, active and online cpus.  Each of them is a fixed size
  * bitmap of size NR_CPUS.
  *
  *  #ifdef CONFIG_HOTPLUG_CPU
  *     cpu_possible_map - has bit 'cpu' set iff cpu is populatable
  *     cpu_present_map  - has bit 'cpu' set iff cpu is populated
  *     cpu_online_map   - has bit 'cpu' set iff cpu available to scheduler
+ *     cpu_active_map   - has bit 'cpu' set iff cpu available to migration
  *  #else
  *     cpu_possible_map - has bit 'cpu' set iff cpu is populated
  *     cpu_present_map  - copy of cpu_possible_map
@@ -416,6 +417,7 @@ static inline void __cpus_fold(cpumask_t *dstp, const cpumask_t *origp,
 extern cpumask_t cpu_possible_map;
 extern cpumask_t cpu_online_map;
 extern cpumask_t cpu_present_map;
+extern cpumask_t cpu_active_map;
 
 #if NR_CPUS > 1
 #define num_online_cpus()	cpus_weight(cpu_online_map)
@@ -424,6 +426,7 @@ extern cpumask_t cpu_present_map;
 #define cpu_online(cpu)		cpu_isset((cpu), cpu_online_map)
 #define cpu_possible(cpu)	cpu_isset((cpu), cpu_possible_map)
 #define cpu_present(cpu)	cpu_isset((cpu), cpu_present_map)
+#define cpu_active(cpu)		cpu_isset((cpu), cpu_active_map)
 #else
 #define num_online_cpus()	1
 #define num_possible_cpus()	1
@@ -431,6 +434,7 @@ extern cpumask_t cpu_present_map;
 #define cpu_online(cpu)		((cpu) == 0)
 #define cpu_possible(cpu)	((cpu) == 0)
 #define cpu_present(cpu)	((cpu) == 0)
+#define cpu_active(cpu)		((cpu) == 0)
 #endif
 
 #define cpu_is_offline(cpu)	unlikely(!cpu_online(cpu))
diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index 0385783..e8f450c 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -78,6 +78,8 @@ extern void cpuset_track_online_nodes(void);
 
 extern int current_cpuset_is_being_rebound(void);
 
+extern void rebuild_sched_domains(void);
+
 #else /* !CONFIG_CPUSETS */
 
 static inline int cpuset_init_early(void) { return 0; }
@@ -156,6 +158,11 @@ static inline int current_cpuset_is_being_rebound(void)
 	return 0;
 }
 
+static inline void rebuild_sched_domains(void)
+{
+	partition_sched_domains(0, NULL, NULL);
+}
+
 #endif /* !CONFIG_CPUSETS */
 
 #endif /* _LINUX_CPUSET_H */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 1941d8b..26da921 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -824,7 +824,16 @@ extern void partition_sched_domains(int ndoms_new, cpumask_t *doms_new,
 				    struct sched_domain_attr *dattr_new);
 extern int arch_reinit_sched_domains(void);
 
-#endif	/* CONFIG_SMP */
+#else /* CONFIG_SMP */
+
+struct sched_domain_attr;
+
+static inline void
+partition_sched_domains(int ndoms_new, cpumask_t *doms_new,
+			struct sched_domain_attr *dattr_new)
+{
+}
+#endif	/* !CONFIG_SMP */
 
 struct io_context;			/* See blkdev.h */
 #define NGROUPS_SMALL		32
diff --git a/init/main.c b/init/main.c
index edeace0..dd25259 100644
--- a/init/main.c
+++ b/init/main.c
@@ -415,6 +415,13 @@ static void __init smp_init(void)
 {
 	unsigned int cpu;
 
+	/*
+	 * Set up the current CPU as possible to migrate to.
+	 * The other ones will be done by cpu_up/cpu_down()
+	 */
+	cpu = smp_processor_id();
+	cpu_set(cpu, cpu_active_map);
+
 	/* FIXME: This should be done in userspace --RR */
 	for_each_present_cpu(cpu) {
 		if (num_online_cpus() >= setup_max_cpus)
diff --git a/kernel/Kconfig.hz b/kernel/Kconfig.hz
index 526128a..2a202a8 100644
--- a/kernel/Kconfig.hz
+++ b/kernel/Kconfig.hz
@@ -55,4 +55,4 @@ config HZ
 	default 1000 if HZ_1000
 
 config SCHED_HRTICK
-	def_bool HIGH_RES_TIMERS && X86
+	def_bool HIGH_RES_TIMERS
diff --git a/kernel/Makefile b/kernel/Makefile
index 985ddb7..15ab63f 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -11,6 +11,8 @@ obj-y     = sched.o fork.o exec_domain.o panic.o printk.o profile.o \
 	    hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
 	    notifier.o ksysfs.o pm_qos_params.o sched_clock.o
 
+CFLAGS_REMOVE_sched.o = -mno-spe
+
 ifdef CONFIG_FTRACE
 # Do not trace debug files and internal ftrace files
 CFLAGS_REMOVE_lockdep.o = -pg
diff --git a/kernel/cpu.c b/kernel/cpu.c
index cfb1d43..033603c 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -64,6 +64,8 @@ void __init cpu_hotplug_init(void)
 	cpu_hotplug.refcount = 0;
 }
 
+cpumask_t cpu_active_map;
+
 #ifdef CONFIG_HOTPLUG_CPU
 
 void get_online_cpus(void)
@@ -291,11 +293,30 @@ int __ref cpu_down(unsigned int cpu)
 	int err = 0;
 
 	cpu_maps_update_begin();
-	if (cpu_hotplug_disabled)
+
+	if (cpu_hotplug_disabled) {
 		err = -EBUSY;
-	else
-		err = _cpu_down(cpu, 0);
+		goto out;
+	}
+
+	cpu_clear(cpu, cpu_active_map);
+
+	/*
+	 * Make sure the all cpus did the reschedule and are not
+	 * using stale version of the cpu_active_map.
+	 * This is not strictly necessary becuase stop_machine()
+	 * that we run down the line already provides the required
+	 * synchronization. But it's really a side effect and we do not
+	 * want to depend on the innards of the stop_machine here.
+	 */
+	synchronize_sched();
+
+	err = _cpu_down(cpu, 0);
 
+	if (cpu_online(cpu))
+		cpu_set(cpu, cpu_active_map);
+
+out:
 	cpu_maps_update_done();
 	return err;
 }
@@ -355,11 +376,18 @@ int __cpuinit cpu_up(unsigned int cpu)
 	}
 
 	cpu_maps_update_begin();
-	if (cpu_hotplug_disabled)
+
+	if (cpu_hotplug_disabled) {
 		err = -EBUSY;
-	else
-		err = _cpu_up(cpu, 0);
+		goto out;
+	}
+
+	err = _cpu_up(cpu, 0);
 
+	if (cpu_online(cpu))
+		cpu_set(cpu, cpu_active_map);
+
+out:
 	cpu_maps_update_done();
 	return err;
 }
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 459d601..3c3ef02 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -564,7 +564,7 @@ update_domain_attr(struct sched_domain_attr *dattr, struct cpuset *c)
  *	partition_sched_domains().
  */
 
-static void rebuild_sched_domains(void)
+void rebuild_sched_domains(void)
 {
 	struct kfifo *q;	/* queue of cpusets to be scanned */
 	struct cpuset *cp;	/* scans q */
diff --git a/kernel/sched.c b/kernel/sched.c
index 99e6d85..62b1b8e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -571,8 +571,10 @@ struct rq {
 #endif
 
 #ifdef CONFIG_SCHED_HRTICK
-	unsigned long hrtick_flags;
-	ktime_t hrtick_expire;
+#ifdef CONFIG_SMP
+	int hrtick_csd_pending;
+	struct call_single_data hrtick_csd;
+#endif
 	struct hrtimer hrtick_timer;
 #endif
 
@@ -983,13 +985,6 @@ static struct rq *this_rq_lock(void)
 	return rq;
 }
 
-static void __resched_task(struct task_struct *p, int tif_bit);
-
-static inline void resched_task(struct task_struct *p)
-{
-	__resched_task(p, TIF_NEED_RESCHED);
-}
-
 #ifdef CONFIG_SCHED_HRTICK
 /*
  * Use HR-timers to deliver accurate preemption points.
@@ -1001,25 +996,6 @@ static inline void resched_task(struct task_struct *p)
  * When we get rescheduled we reprogram the hrtick_timer outside of the
  * rq->lock.
  */
-static inline void resched_hrt(struct task_struct *p)
-{
-	__resched_task(p, TIF_HRTICK_RESCHED);
-}
-
-static inline void resched_rq(struct rq *rq)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&rq->lock, flags);
-	resched_task(rq->curr);
-	spin_unlock_irqrestore(&rq->lock, flags);
-}
-
-enum {
-	HRTICK_SET,		/* re-programm hrtick_timer */
-	HRTICK_RESET,		/* not a new slice */
-	HRTICK_BLOCK,		/* stop hrtick operations */
-};
 
 /*
  * Use hrtick when:
@@ -1030,40 +1006,11 @@ static inline int hrtick_enabled(struct rq *rq)
 {
 	if (!sched_feat(HRTICK))
 		return 0;
-	if (unlikely(test_bit(HRTICK_BLOCK, &rq->hrtick_flags)))
+	if (!cpu_active(cpu_of(rq)))
 		return 0;
 	return hrtimer_is_hres_active(&rq->hrtick_timer);
 }
 
-/*
- * Called to set the hrtick timer state.
- *
- * called with rq->lock held and irqs disabled
- */
-static void hrtick_start(struct rq *rq, u64 delay, int reset)
-{
-	assert_spin_locked(&rq->lock);
-
-	/*
-	 * preempt at: now + delay
-	 */
-	rq->hrtick_expire =
-		ktime_add_ns(rq->hrtick_timer.base->get_time(), delay);
-	/*
-	 * indicate we need to program the timer
-	 */
-	__set_bit(HRTICK_SET, &rq->hrtick_flags);
-	if (reset)
-		__set_bit(HRTICK_RESET, &rq->hrtick_flags);
-
-	/*
-	 * New slices are called from the schedule path and don't need a
-	 * forced reschedule.
-	 */
-	if (reset)
-		resched_hrt(rq->curr);
-}
-
 static void hrtick_clear(struct rq *rq)
 {
 	if (hrtimer_active(&rq->hrtick_timer))
@@ -1071,32 +1018,6 @@ static void hrtick_clear(struct rq *rq)
 }
 
 /*
- * Update the timer from the possible pending state.
- */
-static void hrtick_set(struct rq *rq)
-{
-	ktime_t time;
-	int set, reset;
-	unsigned long flags;
-
-	WARN_ON_ONCE(cpu_of(rq) != smp_processor_id());
-
-	spin_lock_irqsave(&rq->lock, flags);
-	set = __test_and_clear_bit(HRTICK_SET, &rq->hrtick_flags);
-	reset = __test_and_clear_bit(HRTICK_RESET, &rq->hrtick_flags);
-	time = rq->hrtick_expire;
-	clear_thread_flag(TIF_HRTICK_RESCHED);
-	spin_unlock_irqrestore(&rq->lock, flags);
-
-	if (set) {
-		hrtimer_start(&rq->hrtick_timer, time, HRTIMER_MODE_ABS);
-		if (reset && !hrtimer_active(&rq->hrtick_timer))
-			resched_rq(rq);
-	} else
-		hrtick_clear(rq);
-}
-
-/*
  * High-resolution timer tick.
  * Runs from hardirq context with interrupts disabled.
  */
@@ -1115,27 +1036,37 @@ static enum hrtimer_restart hrtick(struct hrtimer *timer)
 }
 
 #ifdef CONFIG_SMP
-static void hotplug_hrtick_disable(int cpu)
+/*
+ * called from hardirq (IPI) context
+ */
+static void __hrtick_start(void *arg)
 {
-	struct rq *rq = cpu_rq(cpu);
-	unsigned long flags;
-
-	spin_lock_irqsave(&rq->lock, flags);
-	rq->hrtick_flags = 0;
-	__set_bit(HRTICK_BLOCK, &rq->hrtick_flags);
-	spin_unlock_irqrestore(&rq->lock, flags);
+	struct rq *rq = arg;
 
-	hrtick_clear(rq);
+	spin_lock(&rq->lock);
+	hrtimer_restart(&rq->hrtick_timer);
+	rq->hrtick_csd_pending = 0;
+	spin_unlock(&rq->lock);
 }
 
-static void hotplug_hrtick_enable(int cpu)
+/*
+ * Called to set the hrtick timer state.
+ *
+ * called with rq->lock held and irqs disabled
+ */
+static void hrtick_start(struct rq *rq, u64 delay)
 {
-	struct rq *rq = cpu_rq(cpu);
-	unsigned long flags;
+	struct hrtimer *timer = &rq->hrtick_timer;
+	ktime_t time = ktime_add_ns(timer->base->get_time(), delay);
 
-	spin_lock_irqsave(&rq->lock, flags);
-	__clear_bit(HRTICK_BLOCK, &rq->hrtick_flags);
-	spin_unlock_irqrestore(&rq->lock, flags);
+	timer->expires = time;
+
+	if (rq == this_rq()) {
+		hrtimer_restart(timer);
+	} else if (!rq->hrtick_csd_pending) {
+		__smp_call_function_single(cpu_of(rq), &rq->hrtick_csd);
+		rq->hrtick_csd_pending = 1;
+	}
 }
 
 static int
@@ -1150,16 +1081,7 @@ hotplug_hrtick(struct notifier_block *nfb, unsigned long action, void *hcpu)
 	case CPU_DOWN_PREPARE_FROZEN:
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
-		hotplug_hrtick_disable(cpu);
-		return NOTIFY_OK;
-
-	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
-	case CPU_DOWN_FAILED:
-	case CPU_DOWN_FAILED_FROZEN:
-	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
-		hotplug_hrtick_enable(cpu);
+		hrtick_clear(cpu_rq(cpu));
 		return NOTIFY_OK;
 	}
 
@@ -1170,46 +1092,45 @@ static void init_hrtick(void)
 {
 	hotcpu_notifier(hotplug_hrtick, 0);
 }
-#endif /* CONFIG_SMP */
+#else
+/*
+ * Called to set the hrtick timer state.
+ *
+ * called with rq->lock held and irqs disabled
+ */
+static void hrtick_start(struct rq *rq, u64 delay)
+{
+	hrtimer_start(&rq->hrtick_timer, ns_to_ktime(delay), HRTIMER_MODE_REL);
+}
 
-static void init_rq_hrtick(struct rq *rq)
+static void init_hrtick(void)
 {
-	rq->hrtick_flags = 0;
-	hrtimer_init(&rq->hrtick_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
-	rq->hrtick_timer.function = hrtick;
-	rq->hrtick_timer.cb_mode = HRTIMER_CB_IRQSAFE_NO_SOFTIRQ;
 }
+#endif /* CONFIG_SMP */
 
-void hrtick_resched(void)
+static void init_rq_hrtick(struct rq *rq)
 {
-	struct rq *rq;
-	unsigned long flags;
+#ifdef CONFIG_SMP
+	rq->hrtick_csd_pending = 0;
 
-	if (!test_thread_flag(TIF_HRTICK_RESCHED))
-		return;
+	rq->hrtick_csd.flags = 0;
+	rq->hrtick_csd.func = __hrtick_start;
+	rq->hrtick_csd.info = rq;
+#endif
 
-	local_irq_save(flags);
-	rq = cpu_rq(smp_processor_id());
-	hrtick_set(rq);
-	local_irq_restore(flags);
+	hrtimer_init(&rq->hrtick_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	rq->hrtick_timer.function = hrtick;
+	rq->hrtick_timer.cb_mode = HRTIMER_CB_IRQSAFE_NO_SOFTIRQ;
 }
 #else
 static inline void hrtick_clear(struct rq *rq)
 {
 }
 
-static inline void hrtick_set(struct rq *rq)
-{
-}
-
 static inline void init_rq_hrtick(struct rq *rq)
 {
 }
 
-void hrtick_resched(void)
-{
-}
-
 static inline void init_hrtick(void)
 {
 }
@@ -1228,16 +1149,16 @@ static inline void init_hrtick(void)
 #define tsk_is_polling(t) test_tsk_thread_flag(t, TIF_POLLING_NRFLAG)
 #endif
 
-static void __resched_task(struct task_struct *p, int tif_bit)
+static void resched_task(struct task_struct *p)
 {
 	int cpu;
 
 	assert_spin_locked(&task_rq(p)->lock);
 
-	if (unlikely(test_tsk_thread_flag(p, tif_bit)))
+	if (unlikely(test_tsk_thread_flag(p, TIF_NEED_RESCHED)))
 		return;
 
-	set_tsk_thread_flag(p, tif_bit);
+	set_tsk_thread_flag(p, TIF_NEED_RESCHED);
 
 	cpu = task_cpu(p);
 	if (cpu == smp_processor_id())
@@ -1303,10 +1224,10 @@ void wake_up_idle_cpu(int cpu)
 #endif /* CONFIG_NO_HZ */
 
 #else /* !CONFIG_SMP */
-static void __resched_task(struct task_struct *p, int tif_bit)
+static void resched_task(struct task_struct *p)
 {
 	assert_spin_locked(&task_rq(p)->lock);
-	set_tsk_thread_flag(p, tif_bit);
+	set_tsk_need_resched(p);
 }
 #endif /* CONFIG_SMP */
 
@@ -2881,7 +2802,7 @@ static void sched_migrate_task(struct task_struct *p, int dest_cpu)
 
 	rq = task_rq_lock(p, &flags);
 	if (!cpu_isset(dest_cpu, p->cpus_allowed)
-	    || unlikely(cpu_is_offline(dest_cpu)))
+	    || unlikely(!cpu_active(dest_cpu)))
 		goto out;
 
 	/* force the process onto the specified CPU */
@@ -3849,7 +3770,7 @@ int select_nohz_load_balancer(int stop_tick)
 		/*
 		 * If we are going offline and still the leader, give up!
 		 */
-		if (cpu_is_offline(cpu) &&
+		if (!cpu_active(cpu) &&
 		    atomic_read(&nohz.load_balancer) == cpu) {
 			if (atomic_cmpxchg(&nohz.load_balancer, cpu, -1) != cpu)
 				BUG();
@@ -4395,7 +4316,7 @@ asmlinkage void __sched schedule(void)
 	struct task_struct *prev, *next;
 	unsigned long *switch_count;
 	struct rq *rq;
-	int cpu, hrtick = sched_feat(HRTICK);
+	int cpu;
 
 need_resched:
 	preempt_disable();
@@ -4410,7 +4331,7 @@ need_resched_nonpreemptible:
 
 	schedule_debug(prev);
 
-	if (hrtick)
+	if (sched_feat(HRTICK))
 		hrtick_clear(rq);
 
 	/*
@@ -4457,9 +4378,6 @@ need_resched_nonpreemptible:
 	} else
 		spin_unlock_irq(&rq->lock);
 
-	if (hrtick)
-		hrtick_set(rq);
-
 	if (unlikely(reacquire_kernel_lock(current) < 0))
 		goto need_resched_nonpreemptible;
 
@@ -5876,7 +5794,7 @@ static int __migrate_task(struct task_struct *p, int src_cpu, int dest_cpu)
 	struct rq *rq_dest, *rq_src;
 	int ret = 0, on_rq;
 
-	if (unlikely(cpu_is_offline(dest_cpu)))
+	if (unlikely(!cpu_active(dest_cpu)))
 		return ret;
 
 	rq_src = cpu_rq(src_cpu);
@@ -6768,7 +6686,8 @@ static cpumask_t cpu_isolated_map = CPU_MASK_NONE;
 /* Setup the mask of cpus configured for isolated domains */
 static int __init isolated_cpu_setup(char *str)
 {
-	int ints[NR_CPUS], i;
+	static int __initdata ints[NR_CPUS];
+	int i;
 
 	str = get_options(str, ARRAY_SIZE(ints), ints);
 	cpus_clear(cpu_isolated_map);
@@ -7553,18 +7472,6 @@ void __attribute__((weak)) arch_update_cpu_topology(void)
 }
 
 /*
- * Free current domain masks.
- * Called after all cpus are attached to NULL domain.
- */
-static void free_sched_domains(void)
-{
-	ndoms_cur = 0;
-	if (doms_cur != &fallback_doms)
-		kfree(doms_cur);
-	doms_cur = &fallback_doms;
-}
-
-/*
  * Set up scheduler domains and groups. Callers must hold the hotplug lock.
  * For now this just excludes isolated cpus, but could be used to
  * exclude other special cases in the future.
@@ -7642,7 +7549,7 @@ static int dattrs_equal(struct sched_domain_attr *cur, int idx_cur,
  * ownership of it and will kfree it when done with it. If the caller
  * failed the kmalloc call, then it can pass in doms_new == NULL,
  * and partition_sched_domains() will fallback to the single partition
- * 'fallback_doms'.
+ * 'fallback_doms', it also forces the domains to be rebuilt.
  *
  * Call with hotplug lock held
  */
@@ -7656,12 +7563,8 @@ void partition_sched_domains(int ndoms_new, cpumask_t *doms_new,
 	/* always unregister in case we don't destroy any domains */
 	unregister_sched_domain_sysctl();
 
-	if (doms_new == NULL) {
-		ndoms_new = 1;
-		doms_new = &fallback_doms;
-		cpus_andnot(doms_new[0], cpu_online_map, cpu_isolated_map);
-		dattr_new = NULL;
-	}
+	if (doms_new == NULL)
+		ndoms_new = 0;
 
 	/* Destroy deleted domains */
 	for (i = 0; i < ndoms_cur; i++) {
@@ -7676,6 +7579,14 @@ match1:
 		;
 	}
 
+	if (doms_new == NULL) {
+		ndoms_cur = 0;
+		ndoms_new = 1;
+		doms_new = &fallback_doms;
+		cpus_andnot(doms_new[0], cpu_online_map, cpu_isolated_map);
+		dattr_new = NULL;
+	}
+
 	/* Build new domains */
 	for (i = 0; i < ndoms_new; i++) {
 		for (j = 0; j < ndoms_cur; j++) {
@@ -7706,17 +7617,10 @@ match2:
 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
 int arch_reinit_sched_domains(void)
 {
-	int err;
-
 	get_online_cpus();
-	mutex_lock(&sched_domains_mutex);
-	detach_destroy_domains(&cpu_online_map);
-	free_sched_domains();
-	err = arch_init_sched_domains(&cpu_online_map);
-	mutex_unlock(&sched_domains_mutex);
+	rebuild_sched_domains();
 	put_online_cpus();
-
-	return err;
+	return 0;
 }
 
 static ssize_t sched_power_savings_store(const char *buf, size_t count, int smt)
@@ -7782,59 +7686,49 @@ int sched_create_sysfs_power_savings_entries(struct sysdev_class *cls)
 }
 #endif /* CONFIG_SCHED_MC || CONFIG_SCHED_SMT */
 
+#ifndef CONFIG_CPUSETS
 /*
- * Force a reinitialization of the sched domains hierarchy. The domains
- * and groups cannot be updated in place without racing with the balancing
- * code, so we temporarily attach all running cpus to the NULL domain
- * which will prevent rebalancing while the sched domains are recalculated.
+ * Add online and remove offline CPUs from the scheduler domains.
+ * When cpusets are enabled they take over this function.
  */
 static int update_sched_domains(struct notifier_block *nfb,
 				unsigned long action, void *hcpu)
 {
+	switch (action) {
+	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
+	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
+		partition_sched_domains(0, NULL, NULL);
+		return NOTIFY_OK;
+
+	default:
+		return NOTIFY_DONE;
+	}
+}
+#endif
+
+static int update_runtime(struct notifier_block *nfb,
+				unsigned long action, void *hcpu)
+{
 	int cpu = (int)(long)hcpu;
 
 	switch (action) {
 	case CPU_DOWN_PREPARE:
 	case CPU_DOWN_PREPARE_FROZEN:
 		disable_runtime(cpu_rq(cpu));
-		/* fall-through */
-	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
-		detach_destroy_domains(&cpu_online_map);
-		free_sched_domains();
 		return NOTIFY_OK;
 
-
 	case CPU_DOWN_FAILED:
 	case CPU_DOWN_FAILED_FROZEN:
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
 		enable_runtime(cpu_rq(cpu));
-		/* fall-through */
-	case CPU_UP_CANCELED:
-	case CPU_UP_CANCELED_FROZEN:
-	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
-		/*
-		 * Fall through and re-initialise the domains.
-		 */
-		break;
+		return NOTIFY_OK;
+
 	default:
 		return NOTIFY_DONE;
 	}
-
-#ifndef CONFIG_CPUSETS
-	/*
-	 * Create default domain partitioning if cpusets are disabled.
-	 * Otherwise we let cpusets rebuild the domains based on the
-	 * current setup.
-	 */
-
-	/* The hotplug lock is already held by cpu_up/cpu_down */
-	arch_init_sched_domains(&cpu_online_map);
-#endif
-
-	return NOTIFY_OK;
 }
 
 void __init sched_init_smp(void)
@@ -7854,8 +7748,15 @@ void __init sched_init_smp(void)
 		cpu_set(smp_processor_id(), non_isolated_cpus);
 	mutex_unlock(&sched_domains_mutex);
 	put_online_cpus();
+
+#ifndef CONFIG_CPUSETS
 	/* XXX: Theoretical race here - CPU may be hotplugged now */
 	hotcpu_notifier(update_sched_domains, 0);
+#endif
+
+	/* RT runtime code needs to handle some hotplug events */
+	hotcpu_notifier(update_runtime, 0);
+
 	init_hrtick();
 
 	/* Move init over to a non-isolated CPU */
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index f2aa987..7f70026 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -878,7 +878,6 @@ entity_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr, int queued)
 #ifdef CONFIG_SCHED_HRTICK
 static void hrtick_start_fair(struct rq *rq, struct task_struct *p)
 {
-	int requeue = rq->curr == p;
 	struct sched_entity *se = &p->se;
 	struct cfs_rq *cfs_rq = cfs_rq_of(se);
 
@@ -899,10 +898,10 @@ static void hrtick_start_fair(struct rq *rq, struct task_struct *p)
 		 * Don't schedule slices shorter than 10000ns, that just
 		 * doesn't make sense. Rely on vruntime for fairness.
 		 */
-		if (!requeue)
+		if (rq->curr != p)
 			delta = max(10000LL, delta);
 
-		hrtick_start(rq, delta, requeue);
+		hrtick_start(rq, delta);
 	}
 }
 #else /* !CONFIG_SCHED_HRTICK */
@@ -1004,6 +1003,8 @@ static void yield_task_fair(struct rq *rq)
  * not idle and an idle cpu is available.  The span of cpus to
  * search starts with cpus closest then further out as needed,
  * so we always favor a closer, idle cpu.
+ * Domains may include CPUs that are not usable for migration,
+ * hence we need to mask them out (cpu_active_map)
  *
  * Returns the CPU we should wake onto.
  */
@@ -1031,6 +1032,7 @@ static int wake_idle(int cpu, struct task_struct *p)
 		    || ((sd->flags & SD_WAKE_IDLE_FAR)
 			&& !task_hot(p, task_rq(p)->clock, sd))) {
 			cpus_and(tmp, sd->span, p->cpus_allowed);
+			cpus_and(tmp, tmp, cpu_active_map);
 			for_each_cpu_mask(i, tmp) {
 				if (idle_cpu(i)) {
 					if (i != task_cpu(p)) {
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 47ceac9..24621ce 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -505,7 +505,9 @@ void inc_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 	rt_rq->rt_nr_running++;
 #if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
 	if (rt_se_prio(rt_se) < rt_rq->highest_prio) {
+#ifdef CONFIG_SMP
 		struct rq *rq = rq_of_rt_rq(rt_rq);
+#endif
 
 		rt_rq->highest_prio = rt_se_prio(rt_se);
 #ifdef CONFIG_SMP
@@ -599,11 +601,7 @@ static void __enqueue_rt_entity(struct sched_rt_entity *rt_se)
 	if (group_rq && (rt_rq_throttled(group_rq) || !group_rq->rt_nr_running))
 		return;
 
-	if (rt_se->nr_cpus_allowed == 1)
-		list_add(&rt_se->run_list, queue);
-	else
-		list_add_tail(&rt_se->run_list, queue);
-
+	list_add_tail(&rt_se->run_list, queue);
 	__set_bit(rt_se_prio(rt_se), array->bitmap);
 
 	inc_rt_tasks(rt_se, rt_rq);
@@ -688,32 +686,34 @@ static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int sleep)
  * Put task to the end of the run list without the overhead of dequeue
  * followed by enqueue.
  */
-static
-void requeue_rt_entity(struct rt_rq *rt_rq, struct sched_rt_entity *rt_se)
+static void
+requeue_rt_entity(struct rt_rq *rt_rq, struct sched_rt_entity *rt_se, int head)
 {
-	struct rt_prio_array *array = &rt_rq->active;
-
 	if (on_rt_rq(rt_se)) {
-		list_del_init(&rt_se->run_list);
-		list_add_tail(&rt_se->run_list,
-			      array->queue + rt_se_prio(rt_se));
+		struct rt_prio_array *array = &rt_rq->active;
+		struct list_head *queue = array->queue + rt_se_prio(rt_se);
+
+		if (head)
+			list_move(&rt_se->run_list, queue);
+		else
+			list_move_tail(&rt_se->run_list, queue);
 	}
 }
 
-static void requeue_task_rt(struct rq *rq, struct task_struct *p)
+static void requeue_task_rt(struct rq *rq, struct task_struct *p, int head)
 {
 	struct sched_rt_entity *rt_se = &p->rt;
 	struct rt_rq *rt_rq;
 
 	for_each_sched_rt_entity(rt_se) {
 		rt_rq = rt_rq_of_se(rt_se);
-		requeue_rt_entity(rt_rq, rt_se);
+		requeue_rt_entity(rt_rq, rt_se, head);
 	}
 }
 
 static void yield_task_rt(struct rq *rq)
 {
-	requeue_task_rt(rq, rq->curr);
+	requeue_task_rt(rq, rq->curr, 0);
 }
 
 #ifdef CONFIG_SMP
@@ -753,6 +753,30 @@ static int select_task_rq_rt(struct task_struct *p, int sync)
 	 */
 	return task_cpu(p);
 }
+
+static void check_preempt_equal_prio(struct rq *rq, struct task_struct *p)
+{
+	cpumask_t mask;
+
+	if (rq->curr->rt.nr_cpus_allowed == 1)
+		return;
+
+	if (p->rt.nr_cpus_allowed != 1
+	    && cpupri_find(&rq->rd->cpupri, p, &mask))
+		return;
+
+	if (!cpupri_find(&rq->rd->cpupri, rq->curr, &mask))
+		return;
+
+	/*
+	 * There appears to be other cpus that can accept
+	 * current and none to run 'p', so lets reschedule
+	 * to try and push current away:
+	 */
+	requeue_task_rt(rq, p, 1);
+	resched_task(rq->curr);
+}
+
 #endif /* CONFIG_SMP */
 
 /*
@@ -778,18 +802,8 @@ static void check_preempt_curr_rt(struct rq *rq, struct task_struct *p)
 	 * to move current somewhere else, making room for our non-migratable
 	 * task.
 	 */
-	if((p->prio == rq->curr->prio)
-	   && p->rt.nr_cpus_allowed == 1
-	   && rq->curr->rt.nr_cpus_allowed != 1) {
-		cpumask_t mask;
-
-		if (cpupri_find(&rq->rd->cpupri, rq->curr, &mask))
-			/*
-			 * There appears to be other cpus that can accept
-			 * current, so lets reschedule to try and push it away
-			 */
-			resched_task(rq->curr);
-	}
+	if (p->prio == rq->curr->prio && !need_resched())
+		check_preempt_equal_prio(rq, p);
 #endif
 }
 
@@ -922,6 +936,13 @@ static int find_lowest_rq(struct task_struct *task)
 		return -1; /* No targets found */
 
 	/*
+	 * Only consider CPUs that are usable for migration.
+	 * I guess we might want to change cpupri_find() to ignore those
+	 * in the first place.
+	 */
+	cpus_and(*lowest_mask, *lowest_mask, cpu_active_map);
+
+	/*
 	 * At this point we have built a mask of cpus representing the
 	 * lowest priority tasks in the system.  Now we want to elect
 	 * the best one based on our affinity and topology.
@@ -1415,7 +1436,7 @@ static void task_tick_rt(struct rq *rq, struct task_struct *p, int queued)
 	 * on the queue:
 	 */
 	if (p->rt.run_list.prev != p->rt.run_list.next) {
-		requeue_task_rt(rq, p);
+		requeue_task_rt(rq, p, 0);
 		set_tsk_need_resched(p);
 	}
 }
