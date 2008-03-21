Return-Path: <linux-kernel-owner+w=401wt.eu-S1758136AbYCUOgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758136AbYCUOgv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 10:36:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754781AbYCUOgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 10:36:41 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:40804 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757353AbYCUOgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 10:36:39 -0400
Date: Fri, 21 Mar 2008 07:36:15 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, mingo@elte.hu, akpm@linux-foundation.org,
       hch@infradead.org, mmlnx@us.ibm.com, dipankar@in.ibm.com,
       dsmith@redhat.com, rostedt@goodmis.org, adrian.bunk@movial.fi,
       a.p.zijlstra@chello.nl, ego@in.ibm.com, niv@us.ibm.com,
       dvhltc@us.ibm.com, rusty@au1.ibm.com, jkenisto@linux.vnet.ibm.com
Subject: [PATCH,RFC] Add call_rcu_sched()
Message-ID: <20080321143615.GA936@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

Rough first cut of patch to provide the call_rcu_sched() needed for
Mathieu's markers implementation.  This is to synchronize_sched()
as call_rcu() is to synchronize_rcu().

Not for inclusion.  Passes light testing, but should be treated with
some caution given that no part of it is more than 24 hours old.
Known/suspected shortcomings:

o	Only lightly tested -- haven't yet tried rcutorture.

o	Need to add call_rcu_sched() testing to rcutorture.

o	If I remember correctly, an rcu_barrier_sched() is required
	(Mathieu?).

o	Interaction of this patch with CPU hotplug should be viewed
	with great suspicion.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 include/linux/rcuclassic.h |    3 
 include/linux/rcupdate.h   |   22 +++
 include/linux/rcupreempt.h |   15 ++
 init/main.c                |    1 
 kernel/rcupdate.c          |   20 ---
 kernel/rcupreempt.c        |  256 +++++++++++++++++++++++++++++++++++++++++++--
 6 files changed, 288 insertions(+), 29 deletions(-)

diff -urpNa -X dontdiff linux-2.6.25-rc6/include/linux/rcuclassic.h linux-2.6.25-rc6-call_rcu_sched/include/linux/rcuclassic.h
--- linux-2.6.25-rc6/include/linux/rcuclassic.h	2008-03-16 17:45:16.000000000 -0700
+++ linux-2.6.25-rc6-call_rcu_sched/include/linux/rcuclassic.h	2008-03-21 04:27:31.000000000 -0700
@@ -153,7 +153,10 @@ extern struct lockdep_map rcu_lock_map;
 
 #define __synchronize_sched() synchronize_rcu()
 
+#define call_rcu_sched(head, func) call_rcu(head, func)
+
 extern void __rcu_init(void);
+#define rcu_init_sched()	do { } while (0)
 extern void rcu_check_callbacks(int cpu, int user);
 extern void rcu_restart_cpu(int cpu);
 
diff -urpNa -X dontdiff linux-2.6.25-rc6/include/linux/rcupdate.h linux-2.6.25-rc6-call_rcu_sched/include/linux/rcupdate.h
--- linux-2.6.25-rc6/include/linux/rcupdate.h	2008-03-16 17:45:16.000000000 -0700
+++ linux-2.6.25-rc6-call_rcu_sched/include/linux/rcupdate.h	2008-03-20 21:10:42.000000000 -0700
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
diff -urpNa -X dontdiff linux-2.6.25-rc6/include/linux/rcupreempt.h linux-2.6.25-rc6-call_rcu_sched/include/linux/rcupreempt.h
--- linux-2.6.25-rc6/include/linux/rcupreempt.h	2008-03-16 17:45:16.000000000 -0700
+++ linux-2.6.25-rc6-call_rcu_sched/include/linux/rcupreempt.h	2008-03-21 04:31:29.000000000 -0700
@@ -46,6 +46,20 @@
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
@@ -57,6 +71,7 @@ extern int rcu_needs_cpu(int cpu);
 extern void __synchronize_sched(void);
 
 extern void __rcu_init(void);
+extern void rcu_init_sched(void);
 extern void rcu_check_callbacks(int cpu, int user);
 extern void rcu_restart_cpu(int cpu);
 extern long rcu_batches_completed(void);
diff -urpNa -X dontdiff linux-2.6.25-rc6/init/main.c linux-2.6.25-rc6-call_rcu_sched/init/main.c
--- linux-2.6.25-rc6/init/main.c	2008-03-16 17:45:17.000000000 -0700
+++ linux-2.6.25-rc6-call_rcu_sched/init/main.c	2008-03-21 04:31:31.000000000 -0700
@@ -736,6 +736,7 @@ static void __init do_basic_setup(void)
 	driver_init();
 	init_irq_proc();
 	do_initcalls();
+	rcu_init_sched();
 }
 
 static int __initdata nosoftlockup;
diff -urpNa -X dontdiff linux-2.6.25-rc6/kernel/rcupdate.c linux-2.6.25-rc6-call_rcu_sched/kernel/rcupdate.c
--- linux-2.6.25-rc6/kernel/rcupdate.c	2008-03-16 17:45:17.000000000 -0700
+++ linux-2.6.25-rc6-call_rcu_sched/kernel/rcupdate.c	2008-03-20 21:10:39.000000000 -0700
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
diff -urpNa -X dontdiff linux-2.6.25-rc6/kernel/rcupreempt.c linux-2.6.25-rc6-call_rcu_sched/kernel/rcupreempt.c
--- linux-2.6.25-rc6/kernel/rcupreempt.c	2008-03-16 17:45:17.000000000 -0700
+++ linux-2.6.25-rc6-call_rcu_sched/kernel/rcupreempt.c	2008-03-21 04:31:26.000000000 -0700
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
@@ -871,6 +894,8 @@ void rcu_offline_cpu(int cpu)
 	struct rcu_head *list = NULL;
 	unsigned long flags;
 	struct rcu_data *rdp = RCU_DATA_CPU(cpu);
+	struct rcu_head *schedlist = NULL;
+	struct rcu_head **schedtail = &schedlist;
 	struct rcu_head **tail = &list;
 
 	/*
@@ -884,6 +909,11 @@ void rcu_offline_cpu(int cpu)
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
 
@@ -924,16 +954,35 @@ void rcu_offline_cpu(int cpu)
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
@@ -993,26 +1042,194 @@ void call_rcu(struct rcu_head *head, voi
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
+		if (rcu_ctrlblk.sched_sleep == rcu_sched_sleeping)
+			rcu_ctrlblk.sched_sleep = rcu_sched_not_sleeping;
+		else
+			wake_gp = 0;
+		spin_unlock_irqrestore(&rcu_ctrlblk.schedlock, flags);
+		if (wake_gp)
+			wake_up(&rcu_ctrlblk.sched_wq);
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
+	int couldsleep;
+	int couldsleepnext = 0;
 	int cpu;
+	unsigned long flags;
+	int needsoftirq;
+	struct rcu_data *rdp;
 
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
+		 * Schedule on each CPU in turn, advancing callbacks
+		 * as we go.  We will have visited each CPU between
+		 * the time we move a callback from the nextsched
+		 * list and the time we move that callback to the
+		 * done list.  Now, a given CPU might come online
+		 * during that interval, but that means that it
+		 * was offline when we started, so we can safely
+		 * ignore it.
+		 */
+
+		for_each_online_cpu(cpu) {
+			
+			/* Initialize and schedule onto current CPU. */
+
+			needsoftirq = 0;
+			sched_setaffinity(0, cpumask_of_cpu(cpu)); /*@@@fail?*/
+			schedule();
+
+			/*
+			 * Get a reference to this CPU's rcu_data
+			 * structure, lock it, and verify that this
+			 * CPU is still online (skip it otherwise).
+			 */
+
+			rdp = RCU_DATA_CPU(cpu);
+			spin_lock_irqsave(&rdp->lock, flags);
+			if (cpu_is_offline(cpu)) {
+				spin_unlock_irqrestore(&rdp->lock, flags);
+				continue;
+			}
+
+			/*
+			 * We are running on the CPU irq-disabled, so it
+			 * cannot go offline until we re-enable irqs.
+			 *
+			 * Advance the callbacks!  We share normal RCU's
+			 * donelist, since callbacks are invoked the
+			 * same way in either case.
+			 */
+
+			if (rdp->waitschedlist != NULL) {
+				*rdp->donetail = rdp->waitschedlist;
+				rdp->donetail = rdp->waitschedtail;
+				needsoftirq = 1;
+			}
+			if (rdp->nextschedlist != NULL) {
+				rdp->waitschedlist = rdp->nextschedlist;
+				rdp->waitschedtail = rdp->nextschedtail;
+				couldsleepnext = couldsleep = 0;
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
+
+			/* If we added callbacks to donelist, process. */
+
+			if (needsoftirq)
+				raise_softirq(RCU_SOFTIRQ);
+		}
+
+		/* If we saw callbacks on the last scan, go deal with them. */
+
+		if (!couldsleep) {
+			continue;
+		}
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
+		__wait_event(rcu_ctrlblk.sched_wq,
+			     rcu_ctrlblk.sched_sleep != rcu_sched_sleeping);
+		couldsleepnext = 0;
+
+	} while (!kthread_should_stop());
+
+	return (0);
 }
-EXPORT_SYMBOL_GPL(__synchronize_sched);
 
 /*
  * Check to see if any future RCU-related work will need to be done
@@ -1107,6 +1324,11 @@ void __init __rcu_init(void)
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
 
@@ -1129,6 +1351,18 @@ void __init __rcu_init(void)
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
