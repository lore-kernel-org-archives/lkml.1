Return-Path: <linux-kernel-owner+w=401wt.eu-S1758902AbXLaAjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758902AbXLaAjO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 19:39:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756519AbXLaAib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 19:38:31 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:54393 "EHLO
	viefep23-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758465AbXLaAi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 19:38:28 -0500
Message-Id: <20071231001646.997374000@chello.nl>
References: <20071231001137.147986000@chello.nl>
User-Agent: quilt/0.45-1
Date: Mon, 31 Dec 2007 01:11:38 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       dmitry.adamushko@gmail.com,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC/PATCH 1/3] sched: high-res preemption tick
Content-Disposition: inline; filename=sched-hrtick.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use HR-timers (when available) to deliver an accurate preemption tick.

The regular scheduler tick that runs at 1/HZ can be too coarse when nice
level are used. The fairness system will still keep the cpu utilisation 'fair'
by then delaying the task that got an excessive amount of CPU time but try to
minimize this by delivering preemption points spot-on.

The average frequency of this extra interrupt is sched_latency / nr_latency.
Which need not be higher than 1/HZ, its just that the distribution within the
sched_latency period is important.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/kernel/entry_64.S       |    6 -
 arch/x86/kernel/signal_32.c      |    3 
 arch/x86/kernel/signal_64.c      |    3 
 include/asm-x86/thread_info_32.h |    2 
 include/asm-x86/thread_info_64.h |    5 
 include/linux/hrtimer.h          |    9 +
 include/linux/sched.h            |    3 
 kernel/Kconfig.hz                |    2 
 kernel/sched.c                   |  210 ++++++++++++++++++++++++++++++++++++---
 kernel/sched_fair.c              |   69 ++++++++++++
 kernel/sched_idletask.c          |    2 
 kernel/sched_rt.c                |    2 
 12 files changed, 295 insertions(+), 21 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -65,6 +65,7 @@
 #include <linux/reciprocal_div.h>
 #include <linux/unistd.h>
 #include <linux/pagemap.h>
+#include <linux/hrtimer.h>
 
 #include <asm/tlb.h>
 #include <asm/irq_regs.h>
@@ -451,6 +452,12 @@ struct rq {
 	struct list_head migration_queue;
 #endif
 
+#ifdef CONFIG_SCHED_HRTICK
+	unsigned long hrtick_flags;
+	ktime_t hrtick_expire;
+	struct hrtimer hrtick_timer;
+#endif
+
 #ifdef CONFIG_SCHEDSTATS
 	/* latency stats */
 	struct sched_info rq_sched_info;
@@ -572,6 +579,8 @@ enum {
 	SCHED_FEAT_START_DEBIT		= 4,
 	SCHED_FEAT_TREE_AVG		= 8,
 	SCHED_FEAT_APPROX_AVG		= 16,
+	SCHED_FEAT_HRTICK		= 32,
+	SCHED_FEAT_DOUBLE_TICK		= 64,
 };
 
 const_debug unsigned int sysctl_sched_features =
@@ -579,7 +588,9 @@ const_debug unsigned int sysctl_sched_fe
 		SCHED_FEAT_WAKEUP_PREEMPT	* 1 |
 		SCHED_FEAT_START_DEBIT		* 1 |
 		SCHED_FEAT_TREE_AVG		* 0 |
-		SCHED_FEAT_APPROX_AVG		* 0;
+		SCHED_FEAT_APPROX_AVG		* 0 |
+		SCHED_FEAT_HRTICK		* 1 |
+		SCHED_FEAT_DOUBLE_TICK		* 0;
 
 #define sched_feat(x) (sysctl_sched_features & SCHED_FEAT_##x)
 
@@ -796,6 +807,173 @@ void sched_clock_idle_wakeup_event(u64 d
 }
 EXPORT_SYMBOL_GPL(sched_clock_idle_wakeup_event);
 
+static void __resched_task(struct task_struct *p, int tif_bit);
+
+static inline void resched_task(struct task_struct *p)
+{
+	__resched_task(p, TIF_NEED_RESCHED);
+}
+
+#ifdef CONFIG_SCHED_HRTICK
+/*
+ * Use HR-timers to deliver accurate preemption points.
+ *
+ * Its all a bit involved since we cannot program an hrt while holding the
+ * rq->lock. So what we do is store a state in in rq->hrtick_* and ask for a
+ * reschedule event.
+ *
+ * When we get rescheduled we reprogram the hrtick_timer outside of the
+ * rq->lock.
+ */
+static inline void resched_hrt(struct task_struct *p)
+{
+	__resched_task(p, TIF_HRTICK_RESCHED);
+}
+
+static inline void resched_rq(struct rq *rq)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&rq->lock, flags);
+	resched_task(rq->curr);
+	spin_unlock_irqrestore(&rq->lock, flags);
+}
+
+enum {
+	HRTICK_SET,		/* re-programm hrtick_timer */
+	HRTICK_RESET,		/* not a new slice */
+};
+
+/*
+ * Use hrtick when:
+ *  - enabled by features
+ *  - hrtimer is actually high res
+ */
+static inline int hrtick_enabled(struct rq *rq)
+{
+	if (!sched_feat(HRTICK))
+		return 0;
+	return hrtimer_is_hres_active(&rq->hrtick_timer);
+}
+
+/*
+ * Called to set the hrtick timer state.
+ *
+ * called with rq->lock held and irqs disabled
+ */
+static void hrtick_start(struct rq *rq, u64 delay, int reset)
+{
+	assert_spin_locked(&rq->lock);
+
+	/*
+	 * preempt at: now + delay
+	 */
+	rq->hrtick_expire =
+		ktime_add_ns(rq->hrtick_timer.base->get_time(), delay);
+	/*
+	 * indicate we need to program the timer
+	 */
+	__set_bit(HRTICK_SET, &rq->hrtick_flags);
+	if (reset)
+		__set_bit(HRTICK_RESET, &rq->hrtick_flags);
+
+	/*
+	 * New slices are called from the schedule path and don't need a
+	 * forced reschedule.
+	 */
+	if (reset)
+		resched_hrt(rq->curr);
+}
+
+static void hrtick_clear(struct rq *rq)
+{
+	if (hrtimer_active(&rq->hrtick_timer))
+		hrtimer_cancel(&rq->hrtick_timer);
+}
+
+/*
+ * Update the timer from the possible pending state.
+ */
+static void hrtick_set(struct rq *rq)
+{
+	ktime_t time;
+	int set, reset;
+	unsigned long flags;
+
+	WARN_ON_ONCE(cpu_of(rq) != smp_processor_id());
+
+	spin_lock_irqsave(&rq->lock, flags);
+	set = __test_and_clear_bit(HRTICK_SET, &rq->hrtick_flags);
+	reset = __test_and_clear_bit(HRTICK_RESET, &rq->hrtick_flags);
+	time = rq->hrtick_expire;
+	clear_thread_flag(TIF_HRTICK_RESCHED);
+	spin_unlock_irqrestore(&rq->lock, flags);
+
+	if (set) {
+		hrtimer_start(&rq->hrtick_timer, time, HRTIMER_MODE_ABS);
+		if (reset && !hrtimer_active(&rq->hrtick_timer))
+			resched_rq(rq);
+	} else
+		hrtick_clear(rq);
+}
+
+/*
+ * High-resolution timer tick.
+ * Runs from hardirq context with interrupts disabled.
+ */
+static enum hrtimer_restart hrtick(struct hrtimer *timer)
+{
+	struct rq *rq = container_of(timer, struct rq, hrtick_timer);
+
+	WARN_ON_ONCE(cpu_of(rq) != smp_processor_id());
+
+	spin_lock(&rq->lock);
+	__update_rq_clock(rq);
+	rq->curr->sched_class->task_tick(rq, rq->curr, 1);
+	spin_unlock(&rq->lock);
+
+	return HRTIMER_NORESTART;
+}
+
+static inline void init_rq_hrtick(struct rq *rq)
+{
+	rq->hrtick_flags = 0;
+	hrtimer_init(&rq->hrtick_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	rq->hrtick_timer.function = hrtick;
+	rq->hrtick_timer.cb_mode = HRTIMER_CB_IRQSAFE_NO_RESTART;
+}
+
+void hrtick_resched(void)
+{
+	struct rq *rq;
+	unsigned long flags;
+
+	if (!test_thread_flag(TIF_HRTICK_RESCHED))
+		return;
+
+	local_irq_save(flags);
+	rq = cpu_rq(smp_processor_id());
+	hrtick_set(rq);
+	local_irq_restore(flags);
+}
+#else
+static inline void hrtick_clear(struct rq *rq)
+{
+}
+
+static inline void hrtick_set(struct rq *rq)
+{
+}
+
+static inline void init_rq_hrtick(struct rq *rq)
+{
+}
+
+void hrtick_resched(void)
+{
+}
+#endif
+
 /*
  * resched_task - mark a task 'to be rescheduled now'.
  *
@@ -809,16 +987,16 @@ EXPORT_SYMBOL_GPL(sched_clock_idle_wakeu
 #define tsk_is_polling(t) test_tsk_thread_flag(t, TIF_POLLING_NRFLAG)
 #endif
 
-static void resched_task(struct task_struct *p)
+static void __resched_task(struct task_struct *p, int tif_bit)
 {
 	int cpu;
 
 	assert_spin_locked(&task_rq(p)->lock);
 
-	if (unlikely(test_tsk_thread_flag(p, TIF_NEED_RESCHED)))
+	if (unlikely(test_tsk_thread_flag(p, tif_bit)))
 		return;
 
-	set_tsk_thread_flag(p, TIF_NEED_RESCHED);
+	set_tsk_thread_flag(p, tif_bit);
 
 	cpu = task_cpu(p);
 	if (cpu == smp_processor_id())
@@ -841,10 +1019,10 @@ static void resched_cpu(int cpu)
 	spin_unlock_irqrestore(&rq->lock, flags);
 }
 #else
-static inline void resched_task(struct task_struct *p)
+static void __resched_task(struct task_struct *p, int tif_bit)
 {
 	assert_spin_locked(&task_rq(p)->lock);
-	set_tsk_need_resched(p);
+	set_tsk_thread_flag(p, tif_bit);
 }
 #endif
 
@@ -3496,7 +3674,7 @@ void scheduler_tick(void)
 	rq->tick_timestamp = rq->clock;
 	update_cpu_load(rq);
 	if (curr != rq->idle) /* FIXME: needed? */
-		curr->sched_class->task_tick(rq, curr);
+		curr->sched_class->task_tick(rq, curr, 0);
 	spin_unlock(&rq->lock);
 
 #ifdef CONFIG_SMP
@@ -3642,6 +3820,8 @@ need_resched_nonpreemptible:
 
 	schedule_debug(prev);
 
+	hrtick_clear(rq);
+
 	/*
 	 * Do the rq-clock update outside the rq lock:
 	 */
@@ -3679,14 +3859,20 @@ need_resched_nonpreemptible:
 		++*switch_count;
 
 		context_switch(rq, prev, next); /* unlocks the rq */
+		/*
+		 * the context switch might have flipped the stack from under
+		 * us, hence refresh the local variables.
+		 */
+		cpu = smp_processor_id();
+		rq = cpu_rq(cpu);
 	} else
 		spin_unlock_irq(&rq->lock);
 
-	if (unlikely(reacquire_kernel_lock(current) < 0)) {
-		cpu = smp_processor_id();
-		rq = cpu_rq(cpu);
+	hrtick_set(rq);
+
+	if (unlikely(reacquire_kernel_lock(current) < 0))
 		goto need_resched_nonpreemptible;
-	}
+
 	preempt_enable_no_resched();
 	if (unlikely(test_thread_flag(TIF_NEED_RESCHED)))
 		goto need_resched;
@@ -6901,6 +7087,8 @@ void __init sched_init(void)
 		rq->rt.overloaded = 0;
 		rq_attach_root(rq, &def_root_domain);
 #endif
+		init_rq_hrtick(rq);
+
 		atomic_set(&rq->nr_iowait, 0);
 
 		array = &rq->rt.active;
Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -642,13 +642,29 @@ static void put_prev_entity(struct cfs_r
 	cfs_rq->curr = NULL;
 }
 
-static void entity_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
+static void
+entity_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr, int queued)
 {
 	/*
 	 * Update run-time statistics of the 'current'.
 	 */
 	update_curr(cfs_rq);
 
+#ifdef CONFIG_SCHED_HRTICK
+	/*
+	 * queued ticks are scheduled to match the slice, so don't bother
+	 * validating it and just reschedule.
+	 */
+	if (queued)
+		return resched_task(rq_of(cfs_rq)->curr);
+	/*
+	 * don't let the period tick interfere with the hrtick preemption
+	 */
+	if (!sched_feat(DOUBLE_TICK) &&
+			hrtimer_active(&rq_of(cfs_rq)->hrtick_timer))
+		return;
+#endif
+
 	if (cfs_rq->nr_running > 1 || !sched_feat(WAKEUP_PREEMPT))
 		check_preempt_tick(cfs_rq, curr);
 }
@@ -754,6 +770,43 @@ static inline struct sched_entity *paren
 
 #endif	/* CONFIG_FAIR_GROUP_SCHED */
 
+#ifdef CONFIG_SCHED_HRTICK
+static void hrtick_start_fair(struct rq *rq, struct task_struct *p)
+{
+	int requeue = rq->curr == p;
+	struct sched_entity *se = &p->se;
+	struct cfs_rq *cfs_rq = cfs_rq_of(se);
+
+	WARN_ON(task_rq(p) != rq);
+
+	if (hrtick_enabled(rq) && cfs_rq->nr_running > 1) {
+		u64 slice = sched_slice(cfs_rq, se);
+		u64 ran = se->sum_exec_runtime - se->prev_sum_exec_runtime;
+		s64 delta = slice - ran;
+
+		if (delta < 0) {
+			if (rq->curr == p)
+				resched_task(p);
+			return;
+		}
+
+		/*
+		 * Don't schedule slices shorter than 10000ns, that just
+		 * doesn't make sense. Rely on vruntime for fairness.
+		 */
+		if (!requeue)
+			delta = max(10000LL, delta);
+
+		hrtick_start(rq, delta, requeue);
+	}
+}
+#else
+static inline void
+hrtick_start_fair(struct rq *rq, struct task_struct *p)
+{
+}
+#endif
+
 /*
  * The enqueue_task method is called before nr_running is
  * increased. Here we update the fair scheduling stats and
@@ -782,6 +835,8 @@ static void enqueue_task_fair(struct rq 
 	 */
 	if (incload)
 		inc_cpu_load(rq, topse->load.weight);
+
+	hrtick_start_fair(rq, rq->curr);
 }
 
 /*
@@ -814,6 +869,8 @@ static void dequeue_task_fair(struct rq 
 	 */
 	if (decload)
 		dec_cpu_load(rq, topse->load.weight);
+
+	hrtick_start_fair(rq, rq->curr);
 }
 
 /*
@@ -1049,6 +1106,7 @@ static void check_preempt_wakeup(struct 
 
 static struct task_struct *pick_next_task_fair(struct rq *rq)
 {
+	struct task_struct *p;
 	struct cfs_rq *cfs_rq = &rq->cfs;
 	struct sched_entity *se;
 
@@ -1060,7 +1118,10 @@ static struct task_struct *pick_next_tas
 		cfs_rq = group_cfs_rq(se);
 	} while (cfs_rq);
 
-	return task_of(se);
+	p = task_of(se);
+	hrtick_start_fair(rq, p);
+
+	return p;
 }
 
 /*
@@ -1235,14 +1296,14 @@ move_one_task_fair(struct rq *this_rq, i
 /*
  * scheduler tick hitting a task of our scheduling class:
  */
-static void task_tick_fair(struct rq *rq, struct task_struct *curr)
+static void task_tick_fair(struct rq *rq, struct task_struct *curr, int queued)
 {
 	struct cfs_rq *cfs_rq;
 	struct sched_entity *se = &curr->se;
 
 	for_each_sched_entity(se) {
 		cfs_rq = cfs_rq_of(se);
-		entity_tick(cfs_rq, se);
+		entity_tick(cfs_rq, se, queued);
 	}
 }
 
Index: linux-2.6/kernel/Kconfig.hz
===================================================================
--- linux-2.6.orig/kernel/Kconfig.hz
+++ linux-2.6/kernel/Kconfig.hz
@@ -54,3 +54,5 @@ config HZ
 	default 300 if HZ_300
 	default 1000 if HZ_1000
 
+config SCHED_HRTICK
+	def_bool HIGH_RES_TIMERS && X86
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -279,6 +279,7 @@ extern void trap_init(void);
 extern void account_process_tick(struct task_struct *task, int user);
 extern void update_process_times(int user);
 extern void scheduler_tick(void);
+extern void hrtick_resched(void);
 
 extern void sched_show_task(struct task_struct *p);
 
@@ -878,7 +879,7 @@ struct sched_class {
 #endif
 
 	void (*set_curr_task) (struct rq *rq);
-	void (*task_tick) (struct rq *rq, struct task_struct *p);
+	void (*task_tick) (struct rq *rq, struct task_struct *p, int queued);
 	void (*task_new) (struct rq *rq, struct task_struct *p);
 	void (*set_cpus_allowed)(struct task_struct *p, cpumask_t *newmask);
 
Index: linux-2.6/include/linux/hrtimer.h
===================================================================
--- linux-2.6.orig/include/linux/hrtimer.h
+++ linux-2.6/include/linux/hrtimer.h
@@ -216,6 +216,11 @@ static inline ktime_t hrtimer_cb_get_tim
 	return timer->base->get_time();
 }
 
+static inline int hrtimer_is_hres_active(struct hrtimer *timer)
+{
+	return timer->base->cpu_base->hres_active;
+}
+
 /*
  * The resolution of the clocks. The resolution value is returned in
  * the clock_getres() system call to give application programmers an
@@ -247,6 +252,10 @@ static inline ktime_t hrtimer_cb_get_tim
 	return timer->base->softirq_time;
 }
 
+static inline int hrtimer_is_hres_active(struct hrtimer *timer)
+{
+	return 0;
+}
 #endif
 
 extern ktime_t ktime_get(void);
Index: linux-2.6/kernel/sched_idletask.c
===================================================================
--- linux-2.6.orig/kernel/sched_idletask.c
+++ linux-2.6/kernel/sched_idletask.c
@@ -61,7 +61,7 @@ move_one_task_idle(struct rq *this_rq, i
 }
 #endif
 
-static void task_tick_idle(struct rq *rq, struct task_struct *curr)
+static void task_tick_idle(struct rq *rq, struct task_struct *curr, int queued)
 {
 }
 
Index: linux-2.6/kernel/sched_rt.c
===================================================================
--- linux-2.6.orig/kernel/sched_rt.c
+++ linux-2.6/kernel/sched_rt.c
@@ -863,7 +863,7 @@ static void watchdog(struct rq *rq, stru
 	}
 }
 
-static void task_tick_rt(struct rq *rq, struct task_struct *p)
+static void task_tick_rt(struct rq *rq, struct task_struct *p, int queued)
 {
 	update_curr_rt(rq);
 
Index: linux-2.6/arch/x86/kernel/signal_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/signal_32.c
+++ linux-2.6/arch/x86/kernel/signal_32.c
@@ -664,6 +664,9 @@ void do_notify_resume(struct pt_regs *re
 	/* deal with pending signal delivery */
 	if (thread_info_flags & (_TIF_SIGPENDING | _TIF_RESTORE_SIGMASK))
 		do_signal(regs);
+
+	if (thread_info_flags & _TIF_HRTICK_RESCHED)
+		hrtick_resched();
 	
 	clear_thread_flag(TIF_IRET);
 }
Index: linux-2.6/include/asm-x86/thread_info_32.h
===================================================================
--- linux-2.6.orig/include/asm-x86/thread_info_32.h
+++ linux-2.6/include/asm-x86/thread_info_32.h
@@ -132,6 +132,7 @@ static inline struct thread_info *curren
 #define TIF_SYSCALL_AUDIT	6	/* syscall auditing active */
 #define TIF_SECCOMP		7	/* secure computing */
 #define TIF_RESTORE_SIGMASK	8	/* restore signal mask in do_signal() */
+#define TIF_HRTICK_RESCHED	9	/* reprogram hrtick timer */
 #define TIF_MEMDIE		16
 #define TIF_DEBUG		17	/* uses debug registers */
 #define TIF_IO_BITMAP		18	/* uses I/O bitmap */
@@ -151,6 +152,7 @@ static inline struct thread_info *curren
 #define _TIF_SYSCALL_AUDIT	(1<<TIF_SYSCALL_AUDIT)
 #define _TIF_SECCOMP		(1<<TIF_SECCOMP)
 #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
+#define _TIF_HRTICK_RESCHED	(1<<TIF_HRTICK_RESCHED)
 #define _TIF_DEBUG		(1<<TIF_DEBUG)
 #define _TIF_IO_BITMAP		(1<<TIF_IO_BITMAP)
 #define _TIF_FREEZE		(1<<TIF_FREEZE)
Index: linux-2.6/arch/x86/kernel/signal_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/signal_64.c
+++ linux-2.6/arch/x86/kernel/signal_64.c
@@ -476,6 +476,9 @@ do_notify_resume(struct pt_regs *regs, v
 	/* deal with pending signal delivery */
 	if (thread_info_flags & (_TIF_SIGPENDING|_TIF_RESTORE_SIGMASK))
 		do_signal(regs);
+
+	if (thread_info_flags & _TIF_HRTICK_RESCHED)
+		hrtick_resched();
 }
 
 void signal_fault(struct pt_regs *regs, void __user *frame, char *where)
Index: linux-2.6/include/asm-x86/thread_info_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/thread_info_64.h
+++ linux-2.6/include/asm-x86/thread_info_64.h
@@ -112,6 +112,7 @@ static inline struct thread_info *stack_
 #define TIF_SECCOMP		8	/* secure computing */
 #define TIF_RESTORE_SIGMASK	9	/* restore signal mask in do_signal */
 #define TIF_MCE_NOTIFY		10	/* notify userspace of an MCE */
+#define TIF_HRTICK_RESCHED	11	/* reprogram hrtick timer */
 #define TIF_FORCED_TF		16	/* true if TF in eflags artificially */
 #define TIF_IA32		17	/* 32bit process */ 
 #define TIF_FORK		18	/* ret_from_fork */
@@ -134,6 +135,7 @@ static inline struct thread_info *stack_
 #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
 #define _TIF_MCE_NOTIFY		(1<<TIF_MCE_NOTIFY)
 #define _TIF_FORCED_TF		(1<<TIF_FORCED_TF)
+#define _TIF_HRTICK_RESCHED	(1<<TIF_HRTICK_RESCHED)
 #define _TIF_IA32		(1<<TIF_IA32)
 #define _TIF_FORK		(1<<TIF_FORK)
 #define _TIF_ABI_PENDING	(1<<TIF_ABI_PENDING)
@@ -150,6 +152,9 @@ static inline struct thread_info *stack_
 /* work to do on any return to user space */
 #define _TIF_ALLWORK_MASK (0x0000FFFF & ~_TIF_SECCOMP)
 
+#define _TIF_DO_NOTIFY_MASK \
+	(_TIF_SIGPENDING|_TIF_SINGLESTEP|_TIF_MCE_NOTIFY|_TIF_HRTICK_RESCHED)
+
 /* flags to check in __switch_to() */
 #define _TIF_WORK_CTXSW \
     (_TIF_IO_BITMAP|_TIF_DEBUGCTLMSR|_TIF_DS_AREA_MSR|_TIF_BTS_TRACE_TS)
Index: linux-2.6/arch/x86/kernel/entry_64.S
===================================================================
--- linux-2.6.orig/arch/x86/kernel/entry_64.S
+++ linux-2.6/arch/x86/kernel/entry_64.S
@@ -296,7 +296,7 @@ sysret_careful:
 sysret_signal:
 	TRACE_IRQS_ON
 	ENABLE_INTERRUPTS(CLBR_NONE)
-	testl $(_TIF_SIGPENDING|_TIF_SINGLESTEP|_TIF_MCE_NOTIFY),%edx
+	testl $_TIF_DO_NOTIFY_MASK,%edx
 	jz    1f
 
 	/* Really a signal */
@@ -390,7 +390,7 @@ int_very_careful:
 	jmp int_restore_rest
 	
 int_signal:
-	testl $(_TIF_SIGPENDING|_TIF_SINGLESTEP|_TIF_MCE_NOTIFY),%edx
+	testl $_TIF_DO_NOTIFY_MASK,%edx
 	jz 1f
 	movq %rsp,%rdi		# &ptregs -> arg1
 	xorl %esi,%esi		# oldset -> arg2
@@ -620,7 +620,7 @@ retint_careful:
 	jmp retint_check
 	
 retint_signal:
-	testl $(_TIF_SIGPENDING|_TIF_SINGLESTEP|_TIF_MCE_NOTIFY),%edx
+	testl $_TIF_DO_NOTIFY_MASK,%edx
 	jz    retint_swapgs
 	TRACE_IRQS_ON
 	ENABLE_INTERRUPTS(CLBR_NONE)

--

