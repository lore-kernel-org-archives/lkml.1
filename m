Return-Path: <linux-kernel-owner+w=401wt.eu-S1756119AbYDFVhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119AbYDFVhj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 17:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753662AbYDFVh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 17:37:29 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:44047 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996AbYDFVh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 17:37:27 -0400
Date: Sun, 6 Apr 2008 14:37:19 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, mingo@elte.hu, akpm@linux-foundation.org,
       hch@infradead.org, mmlnx@us.ibm.com, dipankar@in.ibm.com,
       dsmith@redhat.com, rostedt@goodmis.org, adrian.bunk@movial.fi,
       a.p.zijlstra@chello.nl, ego@in.ibm.com, niv@us.ibm.com,
       dvhltc@us.ibm.com, rusty@au1.ibm.com, jkenisto@linux.vnet.ibm.com,
       oleg@tv-sign.ru
Subject: Re: [PATCH,RFC] Add call_rcu_sched()
Message-ID: <20080406213719.GA10533@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080321143615.GA936@linux.vnet.ibm.com> <20080321224026.GA10169@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080321224026.GA10169@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

Third cut of patch to provide the call_rcu_sched().  This is again to
synchronize_sched() as call_rcu() is to synchronize_rcu().

Should be fine for experimental use, but not ready for inclusion.

Passes multi-hour rcutorture sessions with concurrent CPU hotplugging.

Fixes since the first version include a bug that could result in
indefinite blocking (spotted by Gautham Shenoy), better resiliency
against CPU-hotplug operations, and other minor fixes.

Fixes since the second version include reworking grace-period detection
to avoid deadlocks that could happen when running concurrently with
CPU hotplug, adding Mathieu's fix to avoid the softlockup messages,
as well as Mathieu's fix to allow use earlier in boot.

Known/suspected shortcomings:

o	Only moderately tested on x86-64 and POWER -- a few hours of
	rcutorture with concurrent CPU hotplugging.  In particular, I
	still do not trust the sleep/wakeup logic between call_rcu_sched()
	and rcu_sched_grace_period().

o	Need to add call_rcu_sched() testing to rcutorture.

o	Still needs rcu_barrier_sched() -- intending to incorporate
	the version Mathieu provided.

This patch also fixes a long-standing bug in the earlier preemptable-RCU
implementation of synchronize_rcu() that could result in loss of
concurrent external changes to a task's CPU affinity mask.  I still cannot
remember who reported this...

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---

 include/linux/rcuclassic.h |    3 
 include/linux/rcupdate.h   |   22 ++
 include/linux/rcupreempt.h |   42 ++++
 init/main.c                |    1 
 kernel/rcupdate.c          |   20 --
 kernel/rcupreempt.c        |  401 ++++++++++++++++++++++++++++++++++++++++-----
 6 files changed, 427 insertions(+), 62 deletions(-)

diff -urpNa -X dontdiff linux-2.6.25-rc6/include/linux/rcuclassic.h linux-2.6.25-rc6-C1-call_rcu_sched/include/linux/rcuclassic.h
--- linux-2.6.25-rc6/include/linux/rcuclassic.h	2008-03-16 17:45:16.000000000 -0700
+++ linux-2.6.25-rc6-C1-call_rcu_sched/include/linux/rcuclassic.h	2008-03-21 04:27:31.000000000 -0700
@@ -153,7 +153,10 @@ extern struct lockdep_map rcu_lock_map;
 
 #define __synchronize_sched() synchronize_rcu()
 
+#define call_rcu_sched(head, func) call_rcu(head, func)
+
 extern void __rcu_init(void);
+#define rcu_init_sched()	do { } while (0)
 extern void rcu_check_callbacks(int cpu, int user);
 extern void rcu_restart_cpu(int cpu);
 
diff -urpNa -X dontdiff linux-2.6.25-rc6/include/linux/rcupdate.h linux-2.6.25-rc6-C1-call_rcu_sched/include/linux/rcupdate.h
--- linux-2.6.25-rc6/include/linux/rcupdate.h	2008-03-16 17:45:16.000000000 -0700
+++ linux-2.6.25-rc6-C1-call_rcu_sched/include/linux/rcupdate.h	2008-03-20 21:10:42.000000000 -0700
@@ -42,6 +42,7 @@
 #include <linux/cpumask.h>
 #include <linux/seqlock.h>
 #include <linux/lockdep.h>
+#include <linux/completion.h>
 
 /**
  * struct rcu_head - callback structure for use with RCU
@@ -182,6 +183,27 @@ struct rcu_head {
 		(p) = (v); \
 	})
 
+/* Infrastructure to implement the synchronize_() primitives. */
+
+struct rcu_synchronize {
+	struct rcu_head head;
+	struct completion completion;
+};
+
+extern void wakeme_after_rcu(struct rcu_head  *head);
+
+#define synchronize_rcu_xxx(name, func) \
+void name(void) \
+{ \
+	struct rcu_synchronize rcu; \
+	\
+	init_completion(&rcu.completion); \
+	/* Will wake me after RCU finished. */ \
+	func(&rcu.head, wakeme_after_rcu); \
+	/* Wait for it. */ \
+	wait_for_completion(&rcu.completion); \
+}
+
 /**
  * synchronize_sched - block until all CPUs have exited any non-preemptive
  * kernel code sequences.
diff -urpNa -X dontdiff linux-2.6.25-rc6/include/linux/rcupreempt.h linux-2.6.25-rc6-C1-call_rcu_sched/include/linux/rcupreempt.h
--- linux-2.6.25-rc6/include/linux/rcupreempt.h	2008-03-16 17:45:16.000000000 -0700
+++ linux-2.6.25-rc6-C1-call_rcu_sched/include/linux/rcupreempt.h	2008-04-04 18:17:54.000000000 -0700
@@ -42,10 +42,39 @@
 #include <linux/cpumask.h>
 #include <linux/seqlock.h>
 
-#define rcu_qsctr_inc(cpu)
+struct rcu_dyntick_sched {
+	int dynticks;
+	int dynticks_snap;
+	int sched_qs;
+	int sched_qs_snap;
+	int sched_dynticks_snap;
+};
+
+DECLARE_PER_CPU(struct rcu_dyntick_sched, rcu_dyntick_sched);
+
+static inline void rcu_qsctr_inc(int cpu)
+{
+	struct rcu_dyntick_sched *rdssp = &per_cpu(rcu_dyntick_sched, cpu);
+
+	rdssp->sched_qs++;
+}
 #define rcu_bh_qsctr_inc(cpu)
 #define call_rcu_bh(head, rcu) call_rcu(head, rcu)
 
+/**
+ * call_rcu_sched - Queue RCU callback for invocation after sched grace period.
+ * @head: structure to be used for queueing the RCU updates.
+ * @func: actual update function to be invoked after the grace period
+ *
+ * The update function will be invoked some time after a full
+ * synchronize_sched()-style grace period elapses, in other words after
+ * all currently executing preempt-disabled sections of code (including
+ * hardirq handlers, NMI handlers, and local_irq_save() blocks) have
+ * completed.
+ */
+extern void call_rcu_sched(struct rcu_head *head,
+			   void (*func)(struct rcu_head *head));
+
 extern void __rcu_read_lock(void)	__acquires(RCU);
 extern void __rcu_read_unlock(void)	__releases(RCU);
 extern int rcu_pending(int cpu);
@@ -57,6 +86,7 @@ extern int rcu_needs_cpu(int cpu);
 extern void __synchronize_sched(void);
 
 extern void __rcu_init(void);
+extern void rcu_init_sched(void);
 extern void rcu_check_callbacks(int cpu, int user);
 extern void rcu_restart_cpu(int cpu);
 extern long rcu_batches_completed(void);
@@ -83,20 +113,20 @@ extern struct rcupreempt_trace *rcupreem
 struct softirq_action;
 
 #ifdef CONFIG_NO_HZ
-DECLARE_PER_CPU(long, dynticks_progress_counter);
+DECLARE_PER_CPU(struct rcu_dyntick_sched, rcu_dyntick_sched);
 
 static inline void rcu_enter_nohz(void)
 {
-	__get_cpu_var(dynticks_progress_counter)++;
-	WARN_ON(__get_cpu_var(dynticks_progress_counter) & 0x1);
+	__get_cpu_var(rcu_dyntick_sched).dynticks++;
+	WARN_ON(__get_cpu_var(rcu_dyntick_sched).dynticks & 0x1);
 	mb();
 }
 
 static inline void rcu_exit_nohz(void)
 {
 	mb();
-	__get_cpu_var(dynticks_progress_counter)++;
-	WARN_ON(!(__get_cpu_var(dynticks_progress_counter) & 0x1));
+	__get_cpu_var(rcu_dyntick_sched).dynticks++;
+	WARN_ON(!(__get_cpu_var(rcu_dyntick_sched).dynticks & 0x1));
 }
 
 #else /* CONFIG_NO_HZ */
diff -urpNa -X dontdiff linux-2.6.25-rc6/init/main.c linux-2.6.25-rc6-C1-call_rcu_sched/init/main.c
--- linux-2.6.25-rc6/init/main.c	2008-03-16 17:45:17.000000000 -0700
+++ linux-2.6.25-rc6-C1-call_rcu_sched/init/main.c	2008-03-25 08:31:17.000000000 -0700
@@ -730,6 +730,7 @@ static void __init do_initcalls(void)
  */
 static void __init do_basic_setup(void)
 {
+	rcu_init_sched(); /* needed by module_init stage. */
 	/* drivers will send hotplug events */
 	init_workqueues();
 	usermodehelper_init();
diff -urpNa -X dontdiff linux-2.6.25-rc6/kernel/rcupdate.c linux-2.6.25-rc6-C1-call_rcu_sched/kernel/rcupdate.c
--- linux-2.6.25-rc6/kernel/rcupdate.c	2008-03-16 17:45:17.000000000 -0700
+++ linux-2.6.25-rc6-C1-call_rcu_sched/kernel/rcupdate.c	2008-03-20 21:10:39.000000000 -0700
@@ -39,18 +39,12 @@
 #include <linux/sched.h>
 #include <asm/atomic.h>
 #include <linux/bitops.h>
-#include <linux/completion.h>
 #include <linux/percpu.h>
 #include <linux/notifier.h>
 #include <linux/cpu.h>
 #include <linux/mutex.h>
 #include <linux/module.h>
 
-struct rcu_synchronize {
-	struct rcu_head head;
-	struct completion completion;
-};
-
 static DEFINE_PER_CPU(struct rcu_head, rcu_barrier_head) = {NULL};
 static atomic_t rcu_barrier_cpu_count;
 static DEFINE_MUTEX(rcu_barrier_mutex);
@@ -60,7 +54,7 @@ static struct completion rcu_barrier_com
  * Awaken the corresponding synchronize_rcu() instance now that a
  * grace period has elapsed.
  */
-static void wakeme_after_rcu(struct rcu_head  *head)
+void wakeme_after_rcu(struct rcu_head  *head)
 {
 	struct rcu_synchronize *rcu;
 
@@ -77,17 +71,7 @@ static void wakeme_after_rcu(struct rcu_
  * sections are delimited by rcu_read_lock() and rcu_read_unlock(),
  * and may be nested.
  */
-void synchronize_rcu(void)
-{
-	struct rcu_synchronize rcu;
-
-	init_completion(&rcu.completion);
-	/* Will wake me after RCU finished */
-	call_rcu(&rcu.head, wakeme_after_rcu);
-
-	/* Wait for it */
-	wait_for_completion(&rcu.completion);
-}
+synchronize_rcu_xxx(synchronize_rcu, call_rcu)
 EXPORT_SYMBOL_GPL(synchronize_rcu);
 
 static void rcu_barrier_callback(struct rcu_head *notused)
diff -urpNa -X dontdiff linux-2.6.25-rc6/kernel/rcupreempt.c linux-2.6.25-rc6-C1-call_rcu_sched/kernel/rcupreempt.c
--- linux-2.6.25-rc6/kernel/rcupreempt.c	2008-03-16 17:45:17.000000000 -0700
+++ linux-2.6.25-rc6-C1-call_rcu_sched/kernel/rcupreempt.c	2008-04-04 18:16:34.000000000 -0700
@@ -46,6 +46,7 @@
 #include <asm/atomic.h>
 #include <linux/bitops.h>
 #include <linux/module.h>
+#include <linux/kthread.h>
 #include <linux/completion.h>
 #include <linux/moduleparam.h>
 #include <linux/percpu.h>
@@ -87,9 +88,14 @@ struct rcu_data {
 	struct rcu_head **nexttail;
 	struct rcu_head *waitlist[GP_STAGES];
 	struct rcu_head **waittail[GP_STAGES];
-	struct rcu_head *donelist;
+	struct rcu_head *donelist;	/* from waitlist & waitschedlist */
 	struct rcu_head **donetail;
 	long rcu_flipctr[2];
+	struct rcu_head *nextschedlist;
+	struct rcu_head **nextschedtail;
+	struct rcu_head *waitschedlist;
+	struct rcu_head **waitschedtail;
+	int rcu_sched_sleeping;
 #ifdef CONFIG_RCU_TRACE
 	struct rcupreempt_trace trace;
 #endif /* #ifdef CONFIG_RCU_TRACE */
@@ -131,11 +137,24 @@ enum rcu_try_flip_states {
 	rcu_try_flip_waitmb_state,
 };
 
+/*
+ * States for rcu_ctrlblk.rcu_sched_sleep.
+ */
+
+enum rcu_sched_sleep_states {
+	rcu_sched_not_sleeping,	/* Not sleeping, callbacks need GP.  */
+	rcu_sched_sleep_prep,	/* Thinking of sleeping, rechecking. */
+	rcu_sched_sleeping,	/* Sleeping, awaken if GP needed. */
+};
+
 struct rcu_ctrlblk {
 	spinlock_t	fliplock;	/* Protect state-machine transitions. */
 	long		completed;	/* Number of last completed batch. */
 	enum rcu_try_flip_states rcu_try_flip_state; /* The current state of
 							the rcu state machine */
+	spinlock_t	schedlock;	/* Protect rcu_sched sleep state. */
+	enum rcu_sched_sleep_states sched_sleep; /* rcu_sched state. */
+	wait_queue_head_t sched_wq;	/* Place for rcu_sched to sleep. */
 };
 
 static DEFINE_PER_CPU(struct rcu_data, rcu_data);
@@ -143,8 +162,12 @@ static struct rcu_ctrlblk rcu_ctrlblk = 
 	.fliplock = __SPIN_LOCK_UNLOCKED(rcu_ctrlblk.fliplock),
 	.completed = 0,
 	.rcu_try_flip_state = rcu_try_flip_idle_state,
+	.schedlock = __SPIN_LOCK_UNLOCKED(rcu_ctrlblk.schedlock),
+	.sched_sleep = rcu_sched_not_sleeping,
+	.sched_wq = __WAIT_QUEUE_HEAD_INITIALIZER(rcu_ctrlblk.sched_wq),
 };
 
+static struct task_struct *rcu_sched_grace_period_task;
 
 #ifdef CONFIG_RCU_TRACE
 static char *rcu_try_flip_state_names[] =
@@ -413,32 +436,34 @@ static void __rcu_advance_callbacks(stru
 	}
 }
 
-#ifdef CONFIG_NO_HZ
+DEFINE_PER_CPU_SHARED_ALIGNED(struct rcu_dyntick_sched, rcu_dyntick_sched) = {
+	.dynticks = 1,
+};
 
-DEFINE_PER_CPU(long, dynticks_progress_counter) = 1;
-static DEFINE_PER_CPU(long, rcu_dyntick_snapshot);
+#ifdef CONFIG_NO_HZ
 static DEFINE_PER_CPU(int, rcu_update_flag);
 
 /**
  * rcu_irq_enter - Called from Hard irq handlers and NMI/SMI.
  *
  * If the CPU was idle with dynamic ticks active, this updates the
- * dynticks_progress_counter to let the RCU handling know that the
+ * rcu_dyntick_sched.dynticks to let the RCU handling know that the
  * CPU is active.
  */
 void rcu_irq_enter(void)
 {
 	int cpu = smp_processor_id();
+	struct rcu_dyntick_sched *rdssp = &per_cpu(rcu_dyntick_sched, cpu);
 
 	if (per_cpu(rcu_update_flag, cpu))
 		per_cpu(rcu_update_flag, cpu)++;
 
 	/*
 	 * Only update if we are coming from a stopped ticks mode
-	 * (dynticks_progress_counter is even).
+	 * (rcu_dyntick_sched.dynticks is even).
 	 */
 	if (!in_interrupt() &&
-	    (per_cpu(dynticks_progress_counter, cpu) & 0x1) == 0) {
+	    (rdssp->dynticks & 0x1) == 0) {
 		/*
 		 * The following might seem like we could have a race
 		 * with NMI/SMIs. But this really isn't a problem.
@@ -461,12 +486,12 @@ void rcu_irq_enter(void)
 		 * RCU read-side critical sections on this CPU would
 		 * have already completed.
 		 */
-		per_cpu(dynticks_progress_counter, cpu)++;
+		rdssp->dynticks++;
 		/*
 		 * The following memory barrier ensures that any
 		 * rcu_read_lock() primitives in the irq handler
 		 * are seen by other CPUs to follow the above
-		 * increment to dynticks_progress_counter. This is
+		 * increment to rcu_dyntick_sched.dynticks. This is
 		 * required in order for other CPUs to correctly
 		 * determine when it is safe to advance the RCU
 		 * grace-period state machine.
@@ -474,7 +499,7 @@ void rcu_irq_enter(void)
 		smp_mb(); /* see above block comment. */
 		/*
 		 * Since we can't determine the dynamic tick mode from
-		 * the dynticks_progress_counter after this routine,
+		 * the rcu_dyntick_sched.dynticks after this routine,
 		 * we use a second flag to acknowledge that we came
 		 * from an idle state with ticks stopped.
 		 */
@@ -482,7 +507,7 @@ void rcu_irq_enter(void)
 		/*
 		 * If we take an NMI/SMI now, they will also increment
 		 * the rcu_update_flag, and will not update the
-		 * dynticks_progress_counter on exit. That is for
+		 * rcu_dyntick_sched.dynticks on exit. That is for
 		 * this IRQ to do.
 		 */
 	}
@@ -492,12 +517,13 @@ void rcu_irq_enter(void)
  * rcu_irq_exit - Called from exiting Hard irq context.
  *
  * If the CPU was idle with dynamic ticks active, update the
- * dynticks_progress_counter to put let the RCU handling be
+ * rcu_dyntick_sched.dynticks to put let the RCU handling be
  * aware that the CPU is going back to idle with no ticks.
  */
 void rcu_irq_exit(void)
 {
 	int cpu = smp_processor_id();
+	struct rcu_dyntick_sched *rdssp = &per_cpu(rcu_dyntick_sched, cpu);
 
 	/*
 	 * rcu_update_flag is set if we interrupted the CPU
@@ -505,7 +531,7 @@ void rcu_irq_exit(void)
 	 * Once this occurs, we keep track of interrupt nesting
 	 * because a NMI/SMI could also come in, and we still
 	 * only want the IRQ that started the increment of the
-	 * dynticks_progress_counter to be the one that modifies
+	 * rcu_dyntick_sched.dynticks to be the one that modifies
 	 * it on exit.
 	 */
 	if (per_cpu(rcu_update_flag, cpu)) {
@@ -517,28 +543,29 @@ void rcu_irq_exit(void)
 
 		/*
 		 * If an NMI/SMI happens now we are still
-		 * protected by the dynticks_progress_counter being odd.
+		 * protected by the rcu_dyntick_sched.dynticks being odd.
 		 */
 
 		/*
 		 * The following memory barrier ensures that any
 		 * rcu_read_unlock() primitives in the irq handler
 		 * are seen by other CPUs to preceed the following
-		 * increment to dynticks_progress_counter. This
+		 * increment to rcu_dyntick_sched.dynticks. This
 		 * is required in order for other CPUs to determine
 		 * when it is safe to advance the RCU grace-period
 		 * state machine.
 		 */
 		smp_mb(); /* see above block comment. */
-		per_cpu(dynticks_progress_counter, cpu)++;
-		WARN_ON(per_cpu(dynticks_progress_counter, cpu) & 0x1);
+		rdssp->dynticks++;
+		WARN_ON(rdssp->dynticks & 0x1);
 	}
 }
 
 static void dyntick_save_progress_counter(int cpu)
 {
-	per_cpu(rcu_dyntick_snapshot, cpu) =
-		per_cpu(dynticks_progress_counter, cpu);
+	struct rcu_dyntick_sched *rdssp = &per_cpu(rcu_dyntick_sched, cpu);
+
+	rdssp->dynticks_snap = rdssp->dynticks;
 }
 
 static inline int
@@ -546,9 +573,10 @@ rcu_try_flip_waitack_needed(int cpu)
 {
 	long curr;
 	long snap;
+	struct rcu_dyntick_sched *rdssp = &per_cpu(rcu_dyntick_sched, cpu);
 
-	curr = per_cpu(dynticks_progress_counter, cpu);
-	snap = per_cpu(rcu_dyntick_snapshot, cpu);
+	curr = rdssp->dynticks;
+	snap = rdssp->dynticks_snap;
 	smp_mb(); /* force ordering with cpu entering/leaving dynticks. */
 
 	/*
@@ -582,9 +610,10 @@ rcu_try_flip_waitmb_needed(int cpu)
 {
 	long curr;
 	long snap;
+	struct rcu_dyntick_sched *rdssp = &per_cpu(rcu_dyntick_sched, cpu);
 
-	curr = per_cpu(dynticks_progress_counter, cpu);
-	snap = per_cpu(rcu_dyntick_snapshot, cpu);
+	curr = rdssp->dynticks;
+	snap = rdssp->dynticks_snap;
 	smp_mb(); /* force ordering with cpu entering/leaving dynticks. */
 
 	/*
@@ -611,14 +640,88 @@ rcu_try_flip_waitmb_needed(int cpu)
 	return 1;
 }
 
+static void dyntick_save_progress_counter_sched(int cpu)
+{
+	struct rcu_dyntick_sched *rdssp = &per_cpu(rcu_dyntick_sched, cpu);
+
+	rdssp->sched_dynticks_snap = rdssp->dynticks;
+}
+
+static inline int
+rcu_qsctr_inc_needed_dyntick(int cpu)
+{
+	long curr;
+	long snap;
+	struct rcu_dyntick_sched *rdssp = &per_cpu(rcu_dyntick_sched, cpu);
+
+	curr = rdssp->dynticks;
+	snap = rdssp->sched_dynticks_snap;
+	smp_mb(); /* force ordering with cpu entering/leaving dynticks. */
+
+	/*
+	 * If the CPU remained in dynticks mode for the entire time
+	 * and didn't take any interrupts, NMIs, SMIs, or whatever,
+	 * then it cannot be in the middle of an rcu_read_lock(), so
+	 * the next rcu_read_lock() it executes must use the new value
+	 * of the counter.  Therefore, this CPU has been in a quiescent
+	 * state the entire time, and we don't need to wait for it.
+	 */
+
+	if ((curr == snap) && ((curr & 0x1) == 0))
+		return 0;
+
+	/*
+	 * If the CPU passed through or entered a dynticks idle phase with
+	 * no active irq handlers, then, as above, this CPU has already
+	 * passed through a quiescent state.
+	 */
+
+	if ((curr - snap) > 2 || (snap & 0x1) == 0)
+		return 0;
+
+	/* We need this CPU to go through a quiescent state. */
+
+	return 1;
+}
+
 #else /* !CONFIG_NO_HZ */
 
-# define dyntick_save_progress_counter(cpu)	do { } while (0)
-# define rcu_try_flip_waitack_needed(cpu)	(1)
-# define rcu_try_flip_waitmb_needed(cpu)	(1)
+# define dyntick_save_progress_counter(cpu)		do { } while (0)
+# define rcu_try_flip_waitack_needed(cpu)		(1)
+# define rcu_try_flip_waitmb_needed(cpu)		(1)
+
+# define dyntick_save_progress_counter_sched(cpu)	do { } while (0)
+# define rcu_qsctr_inc_needed_dyntick(cpu)		(1)
 
 #endif /* CONFIG_NO_HZ */
 
+static void save_qsctr_sched(int cpu)
+{
+	struct rcu_dyntick_sched *rdssp = &per_cpu(rcu_dyntick_sched, cpu);
+
+	rdssp->sched_qs_snap = rdssp->sched_qs;
+}
+
+static inline int
+rcu_qsctr_inc_needed(int cpu)
+{
+	struct rcu_dyntick_sched *rdssp = &per_cpu(rcu_dyntick_sched, cpu);
+
+	/*
+	 * If there has been a quiescent state, no more need to wait
+	 * on this CPU.
+	 */
+
+	if (rdssp->sched_qs != rdssp->sched_qs_snap) {
+		smp_mb(); /* force ordering with cpu entering schedule(). */
+		return 0;
+	}
+
+	/* We need this CPU to go through a quiescent state. */
+
+	return 1;
+}
+
 /*
  * Get here when RCU is idle.  Decide whether we need to
  * move out of idle state, and return non-zero if so.
@@ -821,6 +924,13 @@ void rcu_check_callbacks(int cpu, int us
 	unsigned long flags;
 	struct rcu_data *rdp = RCU_DATA_CPU(cpu);
 
+	if (user ||
+	    (idle_cpu(cpu) && !in_softirq() &&
+	     hardirq_count() <= (1 << HARDIRQ_SHIFT))) {
+		smp_mb();	/* Guard against aggressive schedule(). */
+	     	rcu_qsctr_inc(cpu);
+	}
+
 	rcu_check_mb(cpu);
 	if (rcu_ctrlblk.completed == rdp->completed)
 		rcu_try_flip();
@@ -871,6 +981,8 @@ void rcu_offline_cpu(int cpu)
 	struct rcu_head *list = NULL;
 	unsigned long flags;
 	struct rcu_data *rdp = RCU_DATA_CPU(cpu);
+	struct rcu_head *schedlist = NULL;
+	struct rcu_head **schedtail = &schedlist;
 	struct rcu_head **tail = &list;
 
 	/*
@@ -884,6 +996,11 @@ void rcu_offline_cpu(int cpu)
 		rcu_offline_cpu_enqueue(rdp->waitlist[i], rdp->waittail[i],
 						list, tail);
 	rcu_offline_cpu_enqueue(rdp->nextlist, rdp->nexttail, list, tail);
+	rcu_offline_cpu_enqueue(rdp->waitschedlist, rdp->waitschedtail,
+				schedlist, schedtail);
+	rcu_offline_cpu_enqueue(rdp->nextschedlist, rdp->nextschedtail,
+				schedlist, schedtail);
+	rdp->rcu_sched_sleeping = 0;
 	spin_unlock_irqrestore(&rdp->lock, flags);
 	rdp->waitlistcount = 0;
 
@@ -924,16 +1041,35 @@ void rcu_offline_cpu(int cpu)
 	*rdp->nexttail = list;
 	if (list)
 		rdp->nexttail = tail;
+	*rdp->nextschedtail = schedlist;
+	if (schedlist)
+		rdp->nextschedtail = schedtail;
 	spin_unlock_irqrestore(&rdp->lock, flags);
 }
 
 void __devinit rcu_online_cpu(int cpu)
 {
 	unsigned long flags;
+	struct rcu_data *rdp;
 
 	spin_lock_irqsave(&rcu_ctrlblk.fliplock, flags);
 	cpu_set(cpu, rcu_cpu_online_map);
 	spin_unlock_irqrestore(&rcu_ctrlblk.fliplock, flags);
+
+	/*
+	 * The rcu_sched grace-period processing might have bypassed
+	 * this CPU, given that it was not in the rcu_cpu_online_map
+	 * when the grace-period scan started.  This means that the
+	 * grace-period task might sleep.  So make sure that if this
+	 * should happen, the first callback posted to this CPU will
+	 * wake up the grace-period task if need be.
+	 */
+
+	local_irq_save(flags);
+	rdp = RCU_DATA_ME();
+	spin_lock(&rdp->lock);
+	rdp->rcu_sched_sleeping = 1;
+	spin_unlock_irqrestore(&rdp->lock, flags);
 }
 
 #else /* #ifdef CONFIG_HOTPLUG_CPU */
@@ -993,26 +1129,194 @@ void call_rcu(struct rcu_head *head, voi
 }
 EXPORT_SYMBOL_GPL(call_rcu);
 
+void call_rcu_sched(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
+{
+	unsigned long flags;
+	struct rcu_data *rdp;
+	int wake_gp = 0;
+
+	head->func = func;
+	head->next = NULL;
+	local_irq_save(flags);
+	rdp = RCU_DATA_ME();
+	spin_lock(&rdp->lock);
+	*rdp->nextschedtail = head;
+	rdp->nextschedtail = &head->next;
+	if (rdp->rcu_sched_sleeping) {
+
+		/* Grace-period processing might be sleeping... */
+
+		rdp->rcu_sched_sleeping = 0;
+		wake_gp = 1;
+	}
+	spin_unlock(&rdp->lock);
+	local_irq_restore(flags);
+	if (wake_gp) {
+
+		/* Wake up grace-period processing, unless someone beat us. */
+
+		spin_lock_irqsave(&rcu_ctrlblk.schedlock, flags);
+		if (rcu_ctrlblk.sched_sleep != rcu_sched_sleeping)
+			wake_gp = 0;
+		rcu_ctrlblk.sched_sleep = rcu_sched_not_sleeping;
+		spin_unlock_irqrestore(&rcu_ctrlblk.schedlock, flags);
+		if (wake_gp)
+			wake_up_interruptible(&rcu_ctrlblk.sched_wq);
+	}
+}
+EXPORT_SYMBOL_GPL(call_rcu_sched);
+
 /*
  * Wait until all currently running preempt_disable() code segments
  * (including hardware-irq-disable segments) complete.  Note that
  * in -rt this does -not- necessarily result in all currently executing
  * interrupt -handlers- having completed.
  */
-void __synchronize_sched(void)
+synchronize_rcu_xxx(__synchronize_sched, call_rcu_sched)
+EXPORT_SYMBOL_GPL(__synchronize_sched);
+
+/*
+ * kthread function that manages call_rcu_sched grace periods.
+ */
+static int
+rcu_sched_grace_period(void *arg)
 {
-	cpumask_t oldmask;
+	int couldsleep;		/* might sleep after current pass. */
+	int couldsleepnext = 0; /* might sleep after next pass. */
 	int cpu;
+	unsigned long flags;
+	struct rcu_data *rdp;
+	int ret;
 
-	if (sched_getaffinity(0, &oldmask) < 0)
-		oldmask = cpu_possible_map;
-	for_each_online_cpu(cpu) {
-		sched_setaffinity(0, cpumask_of_cpu(cpu));
-		schedule();
-	}
-	sched_setaffinity(0, oldmask);
+	/*
+	 * Each pass through the following loop handles one
+	 * rcu_sched grace period cycle.
+	 */
+
+	do {
+		
+		/* Save each CPU's current state. */
+
+		for_each_online_cpu(cpu) {
+			dyntick_save_progress_counter_sched(cpu);
+			save_qsctr_sched(cpu);
+		}
+
+		/*
+		 * Sleep for about an RCU grace-period's worth to
+		 * allow better batching and to consume less CPU.
+		 */
+
+		schedule_timeout_interruptible(HZ / 20);
+
+		/*
+		 * If there was nothing to do last time, prepare to
+		 * sleep at the end of the current grace period cycle.
+		 */
+
+		couldsleep = couldsleepnext;
+		couldsleepnext = 1;
+		if (couldsleep) {
+			spin_lock_irqsave(&rcu_ctrlblk.schedlock, flags);
+			rcu_ctrlblk.sched_sleep = rcu_sched_sleep_prep;
+			spin_unlock_irqrestore(&rcu_ctrlblk.schedlock, flags);
+		}
+
+		/*
+		 * Wait on each CPU in turn to have either visited
+		 * a quiescent state or been in dynticks-idle mode.
+		 */
+
+		for_each_online_cpu(cpu) {
+			while (rcu_qsctr_inc_needed(cpu) &&
+			       rcu_qsctr_inc_needed_dyntick(cpu)) {
+				/* resched_cpu(cpu); */
+				schedule_timeout_interruptible(1);
+			}
+		}
+
+		/*
+		 * Advance callbacks for each CPU.
+		 */
+
+		for_each_online_cpu(cpu) {
+
+			rdp = RCU_DATA_CPU(cpu);
+			spin_lock_irqsave(&rdp->lock, flags);
+
+			/*
+			 * We are running on this CPU irq-disabled, so no
+			 * CPU can go offline until we re-enable irqs.
+			 *
+			 * Advance the callbacks!  We share normal RCU's
+			 * donelist, since callbacks are invoked the
+			 * same way in either case.
+			 */
+
+			if (rdp->waitschedlist != NULL) {
+				*rdp->donetail = rdp->waitschedlist;
+				rdp->donetail = rdp->waitschedtail;
+
+				/*
+				 * Next rcu_check_callbacks() will
+				 * do the required raise_softirq().
+				 */
+			}
+			if (rdp->nextschedlist != NULL) {
+				rdp->waitschedlist = rdp->nextschedlist;
+				rdp->waitschedtail = rdp->nextschedtail;
+				couldsleep = 0;
+				couldsleepnext = 0;
+			} else {
+				rdp->waitschedlist = NULL;
+				rdp->waitschedtail = &rdp->waitschedlist;
+			}
+			rdp->nextschedlist = NULL;
+			rdp->nextschedtail = &rdp->nextschedlist;
+
+			/* Mark sleep intention. */
+
+			rdp->rcu_sched_sleeping = couldsleep;
+
+			spin_unlock_irqrestore(&rdp->lock, flags);
+		}
+
+		/* If we saw callbacks on the last scan, go deal with them. */
+
+		if (!couldsleep)
+			continue;
+
+		/* Attempt to block... */
+
+		spin_lock_irqsave(&rcu_ctrlblk.schedlock, flags);
+		if (rcu_ctrlblk.sched_sleep != rcu_sched_sleep_prep) {
+
+			/*
+			 * Someone posted a callback after we scanned.
+			 * Go take care of it.
+			 */
+
+			spin_unlock_irqrestore(&rcu_ctrlblk.schedlock, flags);
+			couldsleepnext = 0;
+			continue;
+		}
+
+		/* Block until the next person posts a callback. */
+
+		rcu_ctrlblk.sched_sleep = rcu_sched_sleeping;
+		spin_unlock_irqrestore(&rcu_ctrlblk.schedlock, flags);
+		ret = 0;
+		__wait_event_interruptible(rcu_ctrlblk.sched_wq,
+			rcu_ctrlblk.sched_sleep != rcu_sched_sleeping,
+			ret);
+		if (ret)
+			flush_signals(current);
+		couldsleepnext = 0;
+
+	} while (!kthread_should_stop());
+
+	return (0);
 }
-EXPORT_SYMBOL_GPL(__synchronize_sched);
 
 /*
  * Check to see if any future RCU-related work will need to be done
@@ -1029,7 +1333,9 @@ int rcu_needs_cpu(int cpu)
 
 	return (rdp->donelist != NULL ||
 		!!rdp->waitlistcount ||
-		rdp->nextlist != NULL);
+		rdp->nextlist != NULL ||
+		rdp->nextschedlist != NULL ||
+		rdp->waitschedlist != NULL);
 }
 
 int rcu_pending(int cpu)
@@ -1040,7 +1346,9 @@ int rcu_pending(int cpu)
 
 	if (rdp->donelist != NULL ||
 	    !!rdp->waitlistcount ||
-	    rdp->nextlist != NULL)
+	    rdp->nextlist != NULL ||
+	    rdp->nextschedlist != NULL ||
+	    rdp->waitschedlist != NULL)
 		return 1;
 
 	/* The RCU core needs an acknowledgement from this CPU. */
@@ -1107,6 +1415,11 @@ void __init __rcu_init(void)
 		rdp->donetail = &rdp->donelist;
 		rdp->rcu_flipctr[0] = 0;
 		rdp->rcu_flipctr[1] = 0;
+		rdp->nextschedlist = NULL;
+		rdp->nextschedtail = &rdp->nextschedlist;
+		rdp->waitschedlist = NULL;
+		rdp->waitschedtail = &rdp->waitschedlist;
+		rdp->rcu_sched_sleeping = 0;
 	}
 	register_cpu_notifier(&rcu_nb);
 
@@ -1129,6 +1442,18 @@ void __init __rcu_init(void)
 }
 
 /*
+ * Late-boot-time RCU initialization that must wait until after scheduler
+ * has been initialized.
+ */
+void __init rcu_init_sched(void)
+{
+	rcu_sched_grace_period_task = kthread_run(rcu_sched_grace_period,
+						  NULL,
+						  "rcu_sched_grace_period");
+	WARN_ON(IS_ERR(rcu_sched_grace_period_task));
+}
+
+/*
  * Deprecated, use synchronize_rcu() or synchronize_sched() instead.
  */
 void synchronize_kernel(void)
