Return-Path: <linux-kernel-owner+w=401wt.eu-S1756170AbZIUNNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170AbZIUNNl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 09:13:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756137AbZIUNNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 09:13:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36564 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756057AbZIUNNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 09:13:39 -0400
Date: Mon, 21 Sep 2009 15:13:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [GIT PULL] core kernel fixes
Message-ID: <20090921131319.GA5647@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

RCU fixes.

 Thanks,

	Ingo

------------------>
Josh Triplett (1):
      rcutorture: Occasionally delay readers enough to make RCU force_quiescent_state

Paul E. McKenney (10):
      rcu: Need to update rnp->gpnum if preemptable RCU is to be reliable
      rcu: Initialize multi-level RCU grace periods holding locks
      rcu: Kconfig help needs to say that TREE_PREEMPT_RCU scales down
      rcu: Add debug checks to TREE_PREEMPT_RCU for premature grace periods
      rcu: Simplify rcu_read_unlock_special() quiescent-state accounting
      rcu: Fix synchronize_rcu() for TREE_PREEMPT_RCU
      rcu: Add WARN_ON_ONCE() consistency checks covering state transitions
      rcu: Apply results of code inspection of kernel/rcutree_plugin.h
      rcu: Fix thinko, actually initialize full tree
      rcu: Fix whitespace inconsistencies


 include/linux/rculist_nulls.h |    2 +-
 include/linux/rcupdate.h      |   29 +++--------
 include/linux/rcutree.h       |    6 +-
 include/linux/sched.h         |    1 -
 init/Kconfig                  |    3 +-
 kernel/rcupdate.c             |   48 +++++++++++++++++-
 kernel/rcutorture.c           |   43 +++++++++-------
 kernel/rcutree.c              |  105 ++++++++++++++-------------------------
 kernel/rcutree.h              |    2 +-
 kernel/rcutree_plugin.h       |  110 +++++++++++++++++++++++++++--------------
 kernel/rcutree_trace.c        |    2 +-
 11 files changed, 195 insertions(+), 156 deletions(-)

diff --git a/include/linux/rculist_nulls.h b/include/linux/rculist_nulls.h
index f9ddd03..589a409 100644
--- a/include/linux/rculist_nulls.h
+++ b/include/linux/rculist_nulls.h
@@ -102,7 +102,7 @@ static inline void hlist_nulls_add_head_rcu(struct hlist_nulls_node *n,
  */
 #define hlist_nulls_for_each_entry_rcu(tpos, pos, head, member) \
 	for (pos = rcu_dereference((head)->first);			 \
-		(!is_a_nulls(pos)) && 			\
+		(!is_a_nulls(pos)) &&			\
 		({ tpos = hlist_nulls_entry(pos, typeof(*tpos), member); 1; }); \
 		pos = rcu_dereference(pos->next))
 
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 95e0615..6fe0363 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -1,5 +1,5 @@
 /*
- * Read-Copy Update mechanism for mutual exclusion 
+ * Read-Copy Update mechanism for mutual exclusion
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -18,7 +18,7 @@
  * Copyright IBM Corporation, 2001
  *
  * Author: Dipankar Sarma <dipankar@in.ibm.com>
- * 
+ *
  * Based on the original work by Paul McKenney <paulmck@us.ibm.com>
  * and inputs from Rusty Russell, Andrea Arcangeli and Andi Kleen.
  * Papers:
@@ -26,7 +26,7 @@
  * http://lse.sourceforge.net/locking/rclock_OLS.2001.05.01c.sc.pdf (OLS2001)
  *
  * For detailed explanation of Read-Copy Update mechanism see -
- * 		http://lse.sourceforge.net/locking/rcupdate.html
+ *		http://lse.sourceforge.net/locking/rcupdate.html
  *
  */
 
@@ -52,8 +52,13 @@ struct rcu_head {
 };
 
 /* Exported common interfaces */
+#ifdef CONFIG_TREE_PREEMPT_RCU
 extern void synchronize_rcu(void);
+#else /* #ifdef CONFIG_TREE_PREEMPT_RCU */
+#define synchronize_rcu synchronize_sched
+#endif /* #else #ifdef CONFIG_TREE_PREEMPT_RCU */
 extern void synchronize_rcu_bh(void);
+extern void synchronize_sched(void);
 extern void rcu_barrier(void);
 extern void rcu_barrier_bh(void);
 extern void rcu_barrier_sched(void);
@@ -262,24 +267,6 @@ struct rcu_synchronize {
 extern void wakeme_after_rcu(struct rcu_head  *head);
 
 /**
- * synchronize_sched - block until all CPUs have exited any non-preemptive
- * kernel code sequences.
- *
- * This means that all preempt_disable code sequences, including NMI and
- * hardware-interrupt handlers, in progress on entry will have completed
- * before this primitive returns.  However, this does not guarantee that
- * softirq handlers will have completed, since in some kernels, these
- * handlers can run in process context, and can block.
- *
- * This primitive provides the guarantees made by the (now removed)
- * synchronize_kernel() API.  In contrast, synchronize_rcu() only
- * guarantees that rcu_read_lock() sections will have completed.
- * In "classic RCU", these two guarantees happen to be one and
- * the same, but can differ in realtime RCU implementations.
- */
-#define synchronize_sched() __synchronize_sched()
-
-/**
  * call_rcu - Queue an RCU callback for invocation after a grace period.
  * @head: structure to be used for queueing the RCU updates.
  * @func: actual update function to be invoked after the grace period
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index a893077..3768277 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -24,7 +24,7 @@
  * and inputs from Rusty Russell, Andrea Arcangeli and Andi Kleen.
  *
  * For detailed explanation of Read-Copy Update mechanism see -
- * 	Documentation/RCU
+ *	Documentation/RCU
  */
 
 #ifndef __LINUX_RCUTREE_H
@@ -53,6 +53,8 @@ static inline void __rcu_read_unlock(void)
 	preempt_enable();
 }
 
+#define __synchronize_sched() synchronize_rcu()
+
 static inline void exit_rcu(void)
 {
 }
@@ -68,8 +70,6 @@ static inline void __rcu_read_unlock_bh(void)
 	local_bh_enable();
 }
 
-#define __synchronize_sched() synchronize_rcu()
-
 extern void call_rcu_sched(struct rcu_head *head,
 			   void (*func)(struct rcu_head *rcu));
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index f3d74bd..c62a9f8 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1740,7 +1740,6 @@ extern cputime_t task_gtime(struct task_struct *p);
 
 #define RCU_READ_UNLOCK_BLOCKED (1 << 0) /* blocked while in RCU read-side. */
 #define RCU_READ_UNLOCK_NEED_QS (1 << 1) /* RCU core needs CPU response. */
-#define RCU_READ_UNLOCK_GOT_QS  (1 << 2) /* CPU has responded to RCU core. */
 
 static inline void rcu_copy_process(struct task_struct *p)
 {
diff --git a/init/Kconfig b/init/Kconfig
index 8e8b76d..4c2c936 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -331,7 +331,8 @@ config TREE_PREEMPT_RCU
 	  This option selects the RCU implementation that is
 	  designed for very large SMP systems with hundreds or
 	  thousands of CPUs, but for which real-time response
-	  is also required.
+	  is also required.  It also scales down nicely to
+	  smaller systems.
 
 endchoice
 
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index bd5d5c8..37ac454 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -19,7 +19,7 @@
  *
  * Authors: Dipankar Sarma <dipankar@in.ibm.com>
  *	    Manfred Spraul <manfred@colorfullife.com>
- * 
+ *
  * Based on the original work by Paul McKenney <paulmck@us.ibm.com>
  * and inputs from Rusty Russell, Andrea Arcangeli and Andi Kleen.
  * Papers:
@@ -27,7 +27,7 @@
  * http://lse.sourceforge.net/locking/rclock_OLS.2001.05.01c.sc.pdf (OLS2001)
  *
  * For detailed explanation of Read-Copy Update mechanism see -
- * 		http://lse.sourceforge.net/locking/rcupdate.html
+ *		http://lse.sourceforge.net/locking/rcupdate.html
  *
  */
 #include <linux/types.h>
@@ -74,6 +74,8 @@ void wakeme_after_rcu(struct rcu_head  *head)
 	complete(&rcu->completion);
 }
 
+#ifdef CONFIG_TREE_PREEMPT_RCU
+
 /**
  * synchronize_rcu - wait until a grace period has elapsed.
  *
@@ -87,7 +89,7 @@ void synchronize_rcu(void)
 {
 	struct rcu_synchronize rcu;
 
-	if (rcu_blocking_is_gp())
+	if (!rcu_scheduler_active)
 		return;
 
 	init_completion(&rcu.completion);
@@ -98,6 +100,46 @@ void synchronize_rcu(void)
 }
 EXPORT_SYMBOL_GPL(synchronize_rcu);
 
+#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
+
+/**
+ * synchronize_sched - wait until an rcu-sched grace period has elapsed.
+ *
+ * Control will return to the caller some time after a full rcu-sched
+ * grace period has elapsed, in other words after all currently executing
+ * rcu-sched read-side critical sections have completed.   These read-side
+ * critical sections are delimited by rcu_read_lock_sched() and
+ * rcu_read_unlock_sched(), and may be nested.  Note that preempt_disable(),
+ * local_irq_disable(), and so on may be used in place of
+ * rcu_read_lock_sched().
+ *
+ * This means that all preempt_disable code sequences, including NMI and
+ * hardware-interrupt handlers, in progress on entry will have completed
+ * before this primitive returns.  However, this does not guarantee that
+ * softirq handlers will have completed, since in some kernels, these
+ * handlers can run in process context, and can block.
+ *
+ * This primitive provides the guarantees made by the (now removed)
+ * synchronize_kernel() API.  In contrast, synchronize_rcu() only
+ * guarantees that rcu_read_lock() sections will have completed.
+ * In "classic RCU", these two guarantees happen to be one and
+ * the same, but can differ in realtime RCU implementations.
+ */
+void synchronize_sched(void)
+{
+	struct rcu_synchronize rcu;
+
+	if (rcu_blocking_is_gp())
+		return;
+
+	init_completion(&rcu.completion);
+	/* Will wake me after RCU finished. */
+	call_rcu_sched(&rcu.head, wakeme_after_rcu);
+	/* Wait for it. */
+	wait_for_completion(&rcu.completion);
+}
+EXPORT_SYMBOL_GPL(synchronize_sched);
+
 /**
  * synchronize_rcu_bh - wait until an rcu_bh grace period has elapsed.
  *
diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index b33db53..233768f 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -18,7 +18,7 @@
  * Copyright (C) IBM Corporation, 2005, 2006
  *
  * Authors: Paul E. McKenney <paulmck@us.ibm.com>
- *          Josh Triplett <josh@freedesktop.org>
+ *	  Josh Triplett <josh@freedesktop.org>
  *
  * See also:  Documentation/RCU/torture.txt
  */
@@ -50,7 +50,7 @@
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Paul E. McKenney <paulmck@us.ibm.com> and "
-              "Josh Triplett <josh@freedesktop.org>");
+	      "Josh Triplett <josh@freedesktop.org>");
 
 static int nreaders = -1;	/* # reader threads, defaults to 2*ncpus */
 static int nfakewriters = 4;	/* # fake writer threads */
@@ -110,8 +110,8 @@ struct rcu_torture {
 };
 
 static LIST_HEAD(rcu_torture_freelist);
-static struct rcu_torture *rcu_torture_current = NULL;
-static long rcu_torture_current_version = 0;
+static struct rcu_torture *rcu_torture_current;
+static long rcu_torture_current_version;
 static struct rcu_torture rcu_tortures[10 * RCU_TORTURE_PIPE_LEN];
 static DEFINE_SPINLOCK(rcu_torture_lock);
 static DEFINE_PER_CPU(long [RCU_TORTURE_PIPE_LEN + 1], rcu_torture_count) =
@@ -124,11 +124,11 @@ static atomic_t n_rcu_torture_alloc_fail;
 static atomic_t n_rcu_torture_free;
 static atomic_t n_rcu_torture_mberror;
 static atomic_t n_rcu_torture_error;
-static long n_rcu_torture_timers = 0;
+static long n_rcu_torture_timers;
 static struct list_head rcu_torture_removed;
 static cpumask_var_t shuffle_tmp_mask;
 
-static int stutter_pause_test = 0;
+static int stutter_pause_test;
 
 #if defined(MODULE) || defined(CONFIG_RCU_TORTURE_TEST_RUNNABLE)
 #define RCUTORTURE_RUNNABLE_INIT 1
@@ -267,7 +267,8 @@ struct rcu_torture_ops {
 	int irq_capable;
 	char *name;
 };
-static struct rcu_torture_ops *cur_ops = NULL;
+
+static struct rcu_torture_ops *cur_ops;
 
 /*
  * Definitions for rcu torture testing.
@@ -281,14 +282,17 @@ static int rcu_torture_read_lock(void) __acquires(RCU)
 
 static void rcu_read_delay(struct rcu_random_state *rrsp)
 {
-	long delay;
-	const long longdelay = 200;
+	const unsigned long shortdelay_us = 200;
+	const unsigned long longdelay_ms = 50;
 
-	/* We want there to be long-running readers, but not all the time. */
+	/* We want a short delay sometimes to make a reader delay the grace
+	 * period, and we want a long delay occasionally to trigger
+	 * force_quiescent_state. */
 
-	delay = rcu_random(rrsp) % (nrealreaders * 2 * longdelay);
-	if (!delay)
-		udelay(longdelay);
+	if (!(rcu_random(rrsp) % (nrealreaders * 2000 * longdelay_ms)))
+		mdelay(longdelay_ms);
+	if (!(rcu_random(rrsp) % (nrealreaders * 2 * shortdelay_us)))
+		udelay(shortdelay_us);
 }
 
 static void rcu_torture_read_unlock(int idx) __releases(RCU)
@@ -339,8 +343,8 @@ static struct rcu_torture_ops rcu_ops = {
 	.sync		= synchronize_rcu,
 	.cb_barrier	= rcu_barrier,
 	.stats		= NULL,
-	.irq_capable 	= 1,
-	.name 		= "rcu"
+	.irq_capable	= 1,
+	.name		= "rcu"
 };
 
 static void rcu_sync_torture_deferred_free(struct rcu_torture *p)
@@ -638,7 +642,8 @@ rcu_torture_writer(void *arg)
 
 	do {
 		schedule_timeout_uninterruptible(1);
-		if ((rp = rcu_torture_alloc()) == NULL)
+		rp = rcu_torture_alloc();
+		if (rp == NULL)
 			continue;
 		rp->rtort_pipe_count = 0;
 		udelay(rcu_random(&rand) & 0x3ff);
@@ -1110,7 +1115,7 @@ rcu_torture_init(void)
 		printk(KERN_ALERT "rcutorture: invalid torture type: \"%s\"\n",
 		       torture_type);
 		mutex_unlock(&fullstop_mutex);
-		return (-EINVAL);
+		return -EINVAL;
 	}
 	if (cur_ops->init)
 		cur_ops->init(); /* no "goto unwind" prior to this point!!! */
@@ -1161,7 +1166,7 @@ rcu_torture_init(void)
 		goto unwind;
 	}
 	fakewriter_tasks = kzalloc(nfakewriters * sizeof(fakewriter_tasks[0]),
-	                           GFP_KERNEL);
+				   GFP_KERNEL);
 	if (fakewriter_tasks == NULL) {
 		VERBOSE_PRINTK_ERRSTRING("out of memory");
 		firsterr = -ENOMEM;
@@ -1170,7 +1175,7 @@ rcu_torture_init(void)
 	for (i = 0; i < nfakewriters; i++) {
 		VERBOSE_PRINTK_STRING("Creating rcu_torture_fakewriter task");
 		fakewriter_tasks[i] = kthread_run(rcu_torture_fakewriter, NULL,
-		                                  "rcu_torture_fakewriter");
+						  "rcu_torture_fakewriter");
 		if (IS_ERR(fakewriter_tasks[i])) {
 			firsterr = PTR_ERR(fakewriter_tasks[i]);
 			VERBOSE_PRINTK_ERRSTRING("Failed to create fakewriter");
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 6b11b07..52b06f6 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -25,7 +25,7 @@
  * and inputs from Rusty Russell, Andrea Arcangeli and Andi Kleen.
  *
  * For detailed explanation of Read-Copy Update mechanism see -
- * 	Documentation/RCU
+ *	Documentation/RCU
  */
 #include <linux/types.h>
 #include <linux/kernel.h>
@@ -107,27 +107,23 @@ static void __cpuinit rcu_init_percpu_data(int cpu, struct rcu_state *rsp,
  */
 void rcu_sched_qs(int cpu)
 {
-	unsigned long flags;
 	struct rcu_data *rdp;
 
-	local_irq_save(flags);
 	rdp = &per_cpu(rcu_sched_data, cpu);
-	rdp->passed_quiesc = 1;
 	rdp->passed_quiesc_completed = rdp->completed;
-	rcu_preempt_qs(cpu);
-	local_irq_restore(flags);
+	barrier();
+	rdp->passed_quiesc = 1;
+	rcu_preempt_note_context_switch(cpu);
 }
 
 void rcu_bh_qs(int cpu)
 {
-	unsigned long flags;
 	struct rcu_data *rdp;
 
-	local_irq_save(flags);
 	rdp = &per_cpu(rcu_bh_data, cpu);
-	rdp->passed_quiesc = 1;
 	rdp->passed_quiesc_completed = rdp->completed;
-	local_irq_restore(flags);
+	barrier();
+	rdp->passed_quiesc = 1;
 }
 
 #ifdef CONFIG_NO_HZ
@@ -605,8 +601,6 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 {
 	struct rcu_data *rdp = rsp->rda[smp_processor_id()];
 	struct rcu_node *rnp = rcu_get_root(rsp);
-	struct rcu_node *rnp_cur;
-	struct rcu_node *rnp_end;
 
 	if (!cpu_needs_another_gp(rsp, rdp)) {
 		spin_unlock_irqrestore(&rnp->lock, flags);
@@ -615,6 +609,7 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 
 	/* Advance to a new grace period and initialize state. */
 	rsp->gpnum++;
+	WARN_ON_ONCE(rsp->signaled == RCU_GP_INIT);
 	rsp->signaled = RCU_GP_INIT; /* Hold off force_quiescent_state. */
 	rsp->jiffies_force_qs = jiffies + RCU_JIFFIES_TILL_FORCE_QS;
 	record_gp_stall_check_time(rsp);
@@ -631,7 +626,9 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 
 	/* Special-case the common single-level case. */
 	if (NUM_RCU_NODES == 1) {
+		rcu_preempt_check_blocked_tasks(rnp);
 		rnp->qsmask = rnp->qsmaskinit;
+		rnp->gpnum = rsp->gpnum;
 		rsp->signaled = RCU_SIGNAL_INIT; /* force_quiescent_state OK. */
 		spin_unlock_irqrestore(&rnp->lock, flags);
 		return;
@@ -644,42 +641,28 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 	spin_lock(&rsp->onofflock);  /* irqs already disabled. */
 
 	/*
-	 * Set the quiescent-state-needed bits in all the non-leaf RCU
-	 * nodes for all currently online CPUs.  This operation relies
-	 * on the layout of the hierarchy within the rsp->node[] array.
-	 * Note that other CPUs will access only the leaves of the
-	 * hierarchy, which still indicate that no grace period is in
-	 * progress.  In addition, we have excluded CPU-hotplug operations.
-	 *
-	 * We therefore do not need to hold any locks.  Any required
-	 * memory barriers will be supplied by the locks guarding the
-	 * leaf rcu_nodes in the hierarchy.
-	 */
-
-	rnp_end = rsp->level[NUM_RCU_LVLS - 1];
-	for (rnp_cur = &rsp->node[0]; rnp_cur < rnp_end; rnp_cur++)
-		rnp_cur->qsmask = rnp_cur->qsmaskinit;
-
-	/*
-	 * Now set up the leaf nodes.  Here we must be careful.  First,
-	 * we need to hold the lock in order to exclude other CPUs, which
-	 * might be contending for the leaf nodes' locks.  Second, as
-	 * soon as we initialize a given leaf node, its CPUs might run
-	 * up the rest of the hierarchy.  We must therefore acquire locks
-	 * for each node that we touch during this stage.  (But we still
-	 * are excluding CPU-hotplug operations.)
+	 * Set the quiescent-state-needed bits in all the rcu_node
+	 * structures for all currently online CPUs in breadth-first
+	 * order, starting from the root rcu_node structure.  This
+	 * operation relies on the layout of the hierarchy within the
+	 * rsp->node[] array.  Note that other CPUs will access only
+	 * the leaves of the hierarchy, which still indicate that no
+	 * grace period is in progress, at least until the corresponding
+	 * leaf node has been initialized.  In addition, we have excluded
+	 * CPU-hotplug operations.
 	 *
 	 * Note that the grace period cannot complete until we finish
 	 * the initialization process, as there will be at least one
 	 * qsmask bit set in the root node until that time, namely the
-	 * one corresponding to this CPU.
+	 * one corresponding to this CPU, due to the fact that we have
+	 * irqs disabled.
 	 */
-	rnp_end = &rsp->node[NUM_RCU_NODES];
-	rnp_cur = rsp->level[NUM_RCU_LVLS - 1];
-	for (; rnp_cur < rnp_end; rnp_cur++) {
-		spin_lock(&rnp_cur->lock);	/* irqs already disabled. */
-		rnp_cur->qsmask = rnp_cur->qsmaskinit;
-		spin_unlock(&rnp_cur->lock);	/* irqs already disabled. */
+	for (rnp = &rsp->node[0]; rnp < &rsp->node[NUM_RCU_NODES]; rnp++) {
+		spin_lock(&rnp->lock);	/* irqs already disabled. */
+		rcu_preempt_check_blocked_tasks(rnp);
+		rnp->qsmask = rnp->qsmaskinit;
+		rnp->gpnum = rsp->gpnum;
+		spin_unlock(&rnp->lock);	/* irqs already disabled. */
 	}
 
 	rsp->signaled = RCU_SIGNAL_INIT; /* force_quiescent_state now OK. */
@@ -722,6 +705,7 @@ rcu_process_gp_end(struct rcu_state *rsp, struct rcu_data *rdp)
 static void cpu_quiet_msk_finish(struct rcu_state *rsp, unsigned long flags)
 	__releases(rnp->lock)
 {
+	WARN_ON_ONCE(rsp->completed == rsp->gpnum);
 	rsp->completed = rsp->gpnum;
 	rcu_process_gp_end(rsp, rsp->rda[smp_processor_id()]);
 	rcu_start_gp(rsp, flags);  /* releases root node's rnp->lock. */
@@ -739,6 +723,8 @@ cpu_quiet_msk(unsigned long mask, struct rcu_state *rsp, struct rcu_node *rnp,
 	      unsigned long flags)
 	__releases(rnp->lock)
 {
+	struct rcu_node *rnp_c;
+
 	/* Walk up the rcu_node hierarchy. */
 	for (;;) {
 		if (!(rnp->qsmask & mask)) {
@@ -762,8 +748,10 @@ cpu_quiet_msk(unsigned long mask, struct rcu_state *rsp, struct rcu_node *rnp,
 			break;
 		}
 		spin_unlock_irqrestore(&rnp->lock, flags);
+		rnp_c = rnp;
 		rnp = rnp->parent;
 		spin_lock_irqsave(&rnp->lock, flags);
+		WARN_ON_ONCE(rnp_c->qsmask);
 	}
 
 	/*
@@ -776,10 +764,10 @@ cpu_quiet_msk(unsigned long mask, struct rcu_state *rsp, struct rcu_node *rnp,
 
 /*
  * Record a quiescent state for the specified CPU, which must either be
- * the current CPU or an offline CPU.  The lastcomp argument is used to
- * make sure we are still in the grace period of interest.  We don't want
- * to end the current grace period based on quiescent states detected in
- * an earlier grace period!
+ * the current CPU.  The lastcomp argument is used to make sure we are
+ * still in the grace period of interest.  We don't want to end the current
+ * grace period based on quiescent states detected in an earlier grace
+ * period!
  */
 static void
 cpu_quiet(int cpu, struct rcu_state *rsp, struct rcu_data *rdp, long lastcomp)
@@ -814,7 +802,6 @@ cpu_quiet(int cpu, struct rcu_state *rsp, struct rcu_data *rdp, long lastcomp)
 		 * This GP can't end until cpu checks in, so all of our
 		 * callbacks can be processed during the next GP.
 		 */
-		rdp = rsp->rda[smp_processor_id()];
 		rdp->nxttail[RCU_NEXT_READY_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
 
 		cpu_quiet_msk(mask, rsp, rnp, flags); /* releases rnp->lock */
@@ -872,7 +859,7 @@ static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
 	spin_lock_irqsave(&rsp->onofflock, flags);
 
 	/* Remove the outgoing CPU from the masks in the rcu_node hierarchy. */
-	rnp = rdp->mynode;
+	rnp = rdp->mynode;	/* this is the outgoing CPU's rnp. */
 	mask = rdp->grpmask;	/* rnp->grplo is constant. */
 	do {
 		spin_lock(&rnp->lock);		/* irqs already disabled. */
@@ -881,7 +868,7 @@ static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
 			spin_unlock(&rnp->lock); /* irqs remain disabled. */
 			break;
 		}
-		rcu_preempt_offline_tasks(rsp, rnp);
+		rcu_preempt_offline_tasks(rsp, rnp, rdp);
 		mask = rnp->grpmask;
 		spin_unlock(&rnp->lock);	/* irqs remain disabled. */
 		rnp = rnp->parent;
@@ -890,9 +877,6 @@ static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
 
 	spin_unlock(&rsp->onofflock);		/* irqs remain disabled. */
 
-	/* Being offline is a quiescent state, so go record it. */
-	cpu_quiet(cpu, rsp, rdp, lastcomp);
-
 	/*
 	 * Move callbacks from the outgoing CPU to the running CPU.
 	 * Note that the outgoing CPU is now quiscent, so it is now
@@ -1457,20 +1441,7 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptable)
 		rnp = rnp->parent;
 	} while (rnp != NULL && !(rnp->qsmaskinit & mask));
 
-	spin_unlock(&rsp->onofflock);		/* irqs remain disabled. */
-
-	/*
-	 * A new grace period might start here.  If so, we will be part of
-	 * it, and its gpnum will be greater than ours, so we will
-	 * participate.  It is also possible for the gpnum to have been
-	 * incremented before this function was called, and the bitmasks
-	 * to not be filled out until now, in which case we will also
-	 * participate due to our gpnum being behind.
-	 */
-
-	/* Since it is coming online, the CPU is in a quiescent state. */
-	cpu_quiet(cpu, rsp, rdp, lastcomp);
-	local_irq_restore(flags);
+	spin_unlock_irqrestore(&rsp->onofflock, flags);
 }
 
 static void __cpuinit rcu_online_cpu(int cpu)
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index bf8a6f9..8e8287a 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -142,7 +142,7 @@ struct rcu_data {
 	 */
 	struct rcu_head *nxtlist;
 	struct rcu_head **nxttail[RCU_NEXT_SIZE];
-	long		qlen; 	 	/* # of queued callbacks */
+	long		qlen;		/* # of queued callbacks */
 	long		blimit;		/* Upper limit on a processed batch */
 
 #ifdef CONFIG_NO_HZ
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 4778936..1cee04f 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -64,22 +64,31 @@ EXPORT_SYMBOL_GPL(rcu_batches_completed);
  * not in a quiescent state.  There might be any number of tasks blocked
  * while in an RCU read-side critical section.
  */
-static void rcu_preempt_qs_record(int cpu)
+static void rcu_preempt_qs(int cpu)
 {
 	struct rcu_data *rdp = &per_cpu(rcu_preempt_data, cpu);
-	rdp->passed_quiesc = 1;
 	rdp->passed_quiesc_completed = rdp->completed;
+	barrier();
+	rdp->passed_quiesc = 1;
 }
 
 /*
- * We have entered the scheduler or are between softirqs in ksoftirqd.
- * If we are in an RCU read-side critical section, we need to reflect
- * that in the state of the rcu_node structure corresponding to this CPU.
- * Caller must disable hardirqs.
+ * We have entered the scheduler, and the current task might soon be
+ * context-switched away from.  If this task is in an RCU read-side
+ * critical section, we will no longer be able to rely on the CPU to
+ * record that fact, so we enqueue the task on the appropriate entry
+ * of the blocked_tasks[] array.  The task will dequeue itself when
+ * it exits the outermost enclosing RCU read-side critical section.
+ * Therefore, the current grace period cannot be permitted to complete
+ * until the blocked_tasks[] entry indexed by the low-order bit of
+ * rnp->gpnum empties.
+ *
+ * Caller must disable preemption.
  */
-static void rcu_preempt_qs(int cpu)
+static void rcu_preempt_note_context_switch(int cpu)
 {
 	struct task_struct *t = current;
+	unsigned long flags;
 	int phase;
 	struct rcu_data *rdp;
 	struct rcu_node *rnp;
@@ -90,7 +99,7 @@ static void rcu_preempt_qs(int cpu)
 		/* Possibly blocking in an RCU read-side critical section. */
 		rdp = rcu_preempt_state.rda[cpu];
 		rnp = rdp->mynode;
-		spin_lock(&rnp->lock);
+		spin_lock_irqsave(&rnp->lock, flags);
 		t->rcu_read_unlock_special |= RCU_READ_UNLOCK_BLOCKED;
 		t->rcu_blocked_node = rnp;
 
@@ -103,11 +112,15 @@ static void rcu_preempt_qs(int cpu)
 		 * state for the current grace period), then as long
 		 * as that task remains queued, the current grace period
 		 * cannot end.
+		 *
+		 * But first, note that the current CPU must still be
+		 * on line!
 		 */
-		phase = !(rnp->qsmask & rdp->grpmask) ^ (rnp->gpnum & 0x1);
+		WARN_ON_ONCE((rdp->grpmask & rnp->qsmaskinit) == 0);
+		WARN_ON_ONCE(!list_empty(&t->rcu_node_entry));
+		phase = (rnp->gpnum + !(rnp->qsmask & rdp->grpmask)) & 0x1;
 		list_add(&t->rcu_node_entry, &rnp->blocked_tasks[phase]);
-		smp_mb();  /* Ensure later ctxt swtch seen after above. */
-		spin_unlock(&rnp->lock);
+		spin_unlock_irqrestore(&rnp->lock, flags);
 	}
 
 	/*
@@ -119,9 +132,10 @@ static void rcu_preempt_qs(int cpu)
 	 * grace period, then the fact that the task has been enqueued
 	 * means that we continue to block the current grace period.
 	 */
-	rcu_preempt_qs_record(cpu);
-	t->rcu_read_unlock_special &= ~(RCU_READ_UNLOCK_NEED_QS |
-					RCU_READ_UNLOCK_GOT_QS);
+	rcu_preempt_qs(cpu);
+	local_irq_save(flags);
+	t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_NEED_QS;
+	local_irq_restore(flags);
 }
 
 /*
@@ -157,7 +171,7 @@ static void rcu_read_unlock_special(struct task_struct *t)
 	special = t->rcu_read_unlock_special;
 	if (special & RCU_READ_UNLOCK_NEED_QS) {
 		t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_NEED_QS;
-		t->rcu_read_unlock_special |= RCU_READ_UNLOCK_GOT_QS;
+		rcu_preempt_qs(smp_processor_id());
 	}
 
 	/* Hardware IRQ handlers cannot block. */
@@ -177,10 +191,10 @@ static void rcu_read_unlock_special(struct task_struct *t)
 		 */
 		for (;;) {
 			rnp = t->rcu_blocked_node;
-			spin_lock(&rnp->lock);
+			spin_lock(&rnp->lock);  /* irqs already disabled. */
 			if (rnp == t->rcu_blocked_node)
 				break;
-			spin_unlock(&rnp->lock);
+			spin_unlock(&rnp->lock);  /* irqs remain disabled. */
 		}
 		empty = list_empty(&rnp->blocked_tasks[rnp->gpnum & 0x1]);
 		list_del_init(&t->rcu_node_entry);
@@ -194,9 +208,8 @@ static void rcu_read_unlock_special(struct task_struct *t)
 		 */
 		if (!empty && rnp->qsmask == 0 &&
 		    list_empty(&rnp->blocked_tasks[rnp->gpnum & 0x1])) {
-			t->rcu_read_unlock_special &=
-				~(RCU_READ_UNLOCK_NEED_QS |
-				  RCU_READ_UNLOCK_GOT_QS);
+			struct rcu_node *rnp_p;
+
 			if (rnp->parent == NULL) {
 				/* Only one rcu_node in the tree. */
 				cpu_quiet_msk_finish(&rcu_preempt_state, flags);
@@ -205,9 +218,10 @@ static void rcu_read_unlock_special(struct task_struct *t)
 			/* Report up the rest of the hierarchy. */
 			mask = rnp->grpmask;
 			spin_unlock_irqrestore(&rnp->lock, flags);
-			rnp = rnp->parent;
-			spin_lock_irqsave(&rnp->lock, flags);
-			cpu_quiet_msk(mask, &rcu_preempt_state, rnp, flags);
+			rnp_p = rnp->parent;
+			spin_lock_irqsave(&rnp_p->lock, flags);
+			WARN_ON_ONCE(rnp->qsmask);
+			cpu_quiet_msk(mask, &rcu_preempt_state, rnp_p, flags);
 			return;
 		}
 		spin_unlock(&rnp->lock);
@@ -259,6 +273,19 @@ static void rcu_print_task_stall(struct rcu_node *rnp)
 #endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
 
 /*
+ * Check that the list of blocked tasks for the newly completed grace
+ * period is in fact empty.  It is a serious bug to complete a grace
+ * period that still has RCU readers blocked!  This function must be
+ * invoked -before- updating this rnp's ->gpnum, and the rnp's ->lock
+ * must be held by the caller.
+ */
+static void rcu_preempt_check_blocked_tasks(struct rcu_node *rnp)
+{
+	WARN_ON_ONCE(!list_empty(&rnp->blocked_tasks[rnp->gpnum & 0x1]));
+	WARN_ON_ONCE(rnp->qsmask);
+}
+
+/*
  * Check for preempted RCU readers for the specified rcu_node structure.
  * If the caller needs a reliable answer, it must hold the rcu_node's
  * >lock.
@@ -280,7 +307,8 @@ static int rcu_preempted_readers(struct rcu_node *rnp)
  * The caller must hold rnp->lock with irqs disabled.
  */
 static void rcu_preempt_offline_tasks(struct rcu_state *rsp,
-				      struct rcu_node *rnp)
+				      struct rcu_node *rnp,
+				      struct rcu_data *rdp)
 {
 	int i;
 	struct list_head *lp;
@@ -292,6 +320,9 @@ static void rcu_preempt_offline_tasks(struct rcu_state *rsp,
 		WARN_ONCE(1, "Last CPU thought to be offlined?");
 		return;  /* Shouldn't happen: at least one CPU online. */
 	}
+	WARN_ON_ONCE(rnp != rdp->mynode &&
+		     (!list_empty(&rnp->blocked_tasks[0]) ||
+		      !list_empty(&rnp->blocked_tasks[1])));
 
 	/*
 	 * Move tasks up to root rcu_node.  Rely on the fact that the
@@ -335,20 +366,12 @@ static void rcu_preempt_check_callbacks(int cpu)
 	struct task_struct *t = current;
 
 	if (t->rcu_read_lock_nesting == 0) {
-		t->rcu_read_unlock_special &=
-			~(RCU_READ_UNLOCK_NEED_QS | RCU_READ_UNLOCK_GOT_QS);
-		rcu_preempt_qs_record(cpu);
+		t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_NEED_QS;
+		rcu_preempt_qs(cpu);
 		return;
 	}
-	if (per_cpu(rcu_preempt_data, cpu).qs_pending) {
-		if (t->rcu_read_unlock_special & RCU_READ_UNLOCK_GOT_QS) {
-			rcu_preempt_qs_record(cpu);
-			t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_GOT_QS;
-		} else if (!(t->rcu_read_unlock_special &
-			     RCU_READ_UNLOCK_NEED_QS)) {
-			t->rcu_read_unlock_special |= RCU_READ_UNLOCK_NEED_QS;
-		}
-	}
+	if (per_cpu(rcu_preempt_data, cpu).qs_pending)
+		t->rcu_read_unlock_special |= RCU_READ_UNLOCK_NEED_QS;
 }
 
 /*
@@ -434,7 +457,7 @@ EXPORT_SYMBOL_GPL(rcu_batches_completed);
  * Because preemptable RCU does not exist, we never have to check for
  * CPUs being in quiescent states.
  */
-static void rcu_preempt_qs(int cpu)
+static void rcu_preempt_note_context_switch(int cpu)
 {
 }
 
@@ -451,6 +474,16 @@ static void rcu_print_task_stall(struct rcu_node *rnp)
 #endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
 
 /*
+ * Because there is no preemptable RCU, there can be no readers blocked,
+ * so there is no need to check for blocked tasks.  So check only for
+ * bogus qsmask values.
+ */
+static void rcu_preempt_check_blocked_tasks(struct rcu_node *rnp)
+{
+	WARN_ON_ONCE(rnp->qsmask);
+}
+
+/*
  * Because preemptable RCU does not exist, there are never any preempted
  * RCU readers.
  */
@@ -466,7 +499,8 @@ static int rcu_preempted_readers(struct rcu_node *rnp)
  * tasks that were blocked within RCU read-side critical sections.
  */
 static void rcu_preempt_offline_tasks(struct rcu_state *rsp,
-				      struct rcu_node *rnp)
+				      struct rcu_node *rnp,
+				      struct rcu_data *rdp)
 {
 }
 
diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index 0ea1bff..c89f5e9 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -20,7 +20,7 @@
  * Papers:  http://www.rdrop.com/users/paulmck/RCU
  *
  * For detailed explanation of Read-Copy Update mechanism see -
- * 		Documentation/RCU
+ *		Documentation/RCU
  *
  */
 #include <linux/types.h>
