Return-Path: <linux-kernel-owner+w=401wt.eu-S1760821AbYB2SFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760821AbYB2SFd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 13:05:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757122AbYB2SFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 13:05:23 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43147 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756504AbYB2SFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 13:05:21 -0500
Date: Fri, 29 Feb 2008 19:04:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] scheduler updates
Message-ID: <20080229180449.GA31192@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
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


Linus, please pull the latest scheduler fixes git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git

warning: the rcupreempt patch is a bit larger than what i'd like to do 
for -rc4 but rcupreempt is a new feature, the fix has been in the queue 
for ages (with no changes to it) - and half of the patch's size is 
comments. It has no effect on !RCUPREEMPT || !NOHZ kernels. [this fix 
became more urgent because on larger SMP it's rather easy to trigger a 
boot time hang.]

Thanks,

	Ingo

------------------>
Dmitry Adamushko (1):
      softlockup: fix task state setting

Steven Rostedt (1):
      rcu: add support for dynamic ticks and preempt rcu

 include/linux/hardirq.h    |   10 ++
 include/linux/rcuclassic.h |    3 +
 include/linux/rcupreempt.h |   22 +++++
 kernel/rcupreempt.c        |  224 +++++++++++++++++++++++++++++++++++++++++++-
 kernel/softirq.c           |    1 +
 kernel/softlockup.c        |   13 ++-
 kernel/time/tick-sched.c   |    3 +
 7 files changed, 266 insertions(+), 10 deletions(-)

diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index 2961ec7..4982998 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -109,6 +109,14 @@ static inline void account_system_vtime(struct task_struct *tsk)
 }
 #endif
 
+#if defined(CONFIG_PREEMPT_RCU) && defined(CONFIG_NO_HZ)
+extern void rcu_irq_enter(void);
+extern void rcu_irq_exit(void);
+#else
+# define rcu_irq_enter() do { } while (0)
+# define rcu_irq_exit() do { } while (0)
+#endif /* CONFIG_PREEMPT_RCU */
+
 /*
  * It is safe to do non-atomic ops on ->hardirq_context,
  * because NMI handlers may not preempt and the ops are
@@ -117,6 +125,7 @@ static inline void account_system_vtime(struct task_struct *tsk)
  */
 #define __irq_enter()					\
 	do {						\
+		rcu_irq_enter();			\
 		account_system_vtime(current);		\
 		add_preempt_count(HARDIRQ_OFFSET);	\
 		trace_hardirq_enter();			\
@@ -135,6 +144,7 @@ extern void irq_enter(void);
 		trace_hardirq_exit();			\
 		account_system_vtime(current);		\
 		sub_preempt_count(HARDIRQ_OFFSET);	\
+		rcu_irq_exit();				\
 	} while (0)
 
 /*
diff --git a/include/linux/rcuclassic.h b/include/linux/rcuclassic.h
index 4d66242..b3dccd6 100644
--- a/include/linux/rcuclassic.h
+++ b/include/linux/rcuclassic.h
@@ -160,5 +160,8 @@ extern void rcu_restart_cpu(int cpu);
 extern long rcu_batches_completed(void);
 extern long rcu_batches_completed_bh(void);
 
+#define rcu_enter_nohz()	do { } while (0)
+#define rcu_exit_nohz()		do { } while (0)
+
 #endif /* __KERNEL__ */
 #endif /* __LINUX_RCUCLASSIC_H */
diff --git a/include/linux/rcupreempt.h b/include/linux/rcupreempt.h
index 60c2a03..01152ed 100644
--- a/include/linux/rcupreempt.h
+++ b/include/linux/rcupreempt.h
@@ -82,5 +82,27 @@ extern struct rcupreempt_trace *rcupreempt_trace_cpu(int cpu);
 
 struct softirq_action;
 
+#ifdef CONFIG_NO_HZ
+DECLARE_PER_CPU(long, dynticks_progress_counter);
+
+static inline void rcu_enter_nohz(void)
+{
+	__get_cpu_var(dynticks_progress_counter)++;
+	WARN_ON(__get_cpu_var(dynticks_progress_counter) & 0x1);
+	mb();
+}
+
+static inline void rcu_exit_nohz(void)
+{
+	mb();
+	__get_cpu_var(dynticks_progress_counter)++;
+	WARN_ON(!(__get_cpu_var(dynticks_progress_counter) & 0x1));
+}
+
+#else /* CONFIG_NO_HZ */
+#define rcu_enter_nohz()	do { } while (0)
+#define rcu_exit_nohz()		do { } while (0)
+#endif /* CONFIG_NO_HZ */
+
 #endif /* __KERNEL__ */
 #endif /* __LINUX_RCUPREEMPT_H */
diff --git a/kernel/rcupreempt.c b/kernel/rcupreempt.c
index 987cfb7..c7c5209 100644
--- a/kernel/rcupreempt.c
+++ b/kernel/rcupreempt.c
@@ -23,6 +23,10 @@
  *		to Suparna Bhattacharya for pushing me completely away
  *		from atomic instructions on the read side.
  *
+ *  - Added handling of Dynamic Ticks
+ *      Copyright 2007 - Paul E. Mckenney <paulmck@us.ibm.com>
+ *                     - Steven Rostedt <srostedt@redhat.com>
+ *
  * Papers:  http://www.rdrop.com/users/paulmck/RCU
  *
  * Design Document: http://lwn.net/Articles/253651/
@@ -409,6 +413,212 @@ static void __rcu_advance_callbacks(struct rcu_data *rdp)
 	}
 }
 
+#ifdef CONFIG_NO_HZ
+
+DEFINE_PER_CPU(long, dynticks_progress_counter) = 1;
+static DEFINE_PER_CPU(long, rcu_dyntick_snapshot);
+static DEFINE_PER_CPU(int, rcu_update_flag);
+
+/**
+ * rcu_irq_enter - Called from Hard irq handlers and NMI/SMI.
+ *
+ * If the CPU was idle with dynamic ticks active, this updates the
+ * dynticks_progress_counter to let the RCU handling know that the
+ * CPU is active.
+ */
+void rcu_irq_enter(void)
+{
+	int cpu = smp_processor_id();
+
+	if (per_cpu(rcu_update_flag, cpu))
+		per_cpu(rcu_update_flag, cpu)++;
+
+	/*
+	 * Only update if we are coming from a stopped ticks mode
+	 * (dynticks_progress_counter is even).
+	 */
+	if (!in_interrupt() &&
+	    (per_cpu(dynticks_progress_counter, cpu) & 0x1) == 0) {
+		/*
+		 * The following might seem like we could have a race
+		 * with NMI/SMIs. But this really isn't a problem.
+		 * Here we do a read/modify/write, and the race happens
+		 * when an NMI/SMI comes in after the read and before
+		 * the write. But NMI/SMIs will increment this counter
+		 * twice before returning, so the zero bit will not
+		 * be corrupted by the NMI/SMI which is the most important
+		 * part.
+		 *
+		 * The only thing is that we would bring back the counter
+		 * to a postion that it was in during the NMI/SMI.
+		 * But the zero bit would be set, so the rest of the
+		 * counter would again be ignored.
+		 *
+		 * On return from the IRQ, the counter may have the zero
+		 * bit be 0 and the counter the same as the return from
+		 * the NMI/SMI. If the state machine was so unlucky to
+		 * see that, it still doesn't matter, since all
+		 * RCU read-side critical sections on this CPU would
+		 * have already completed.
+		 */
+		per_cpu(dynticks_progress_counter, cpu)++;
+		/*
+		 * The following memory barrier ensures that any
+		 * rcu_read_lock() primitives in the irq handler
+		 * are seen by other CPUs to follow the above
+		 * increment to dynticks_progress_counter. This is
+		 * required in order for other CPUs to correctly
+		 * determine when it is safe to advance the RCU
+		 * grace-period state machine.
+		 */
+		smp_mb(); /* see above block comment. */
+		/*
+		 * Since we can't determine the dynamic tick mode from
+		 * the dynticks_progress_counter after this routine,
+		 * we use a second flag to acknowledge that we came
+		 * from an idle state with ticks stopped.
+		 */
+		per_cpu(rcu_update_flag, cpu)++;
+		/*
+		 * If we take an NMI/SMI now, they will also increment
+		 * the rcu_update_flag, and will not update the
+		 * dynticks_progress_counter on exit. That is for
+		 * this IRQ to do.
+		 */
+	}
+}
+
+/**
+ * rcu_irq_exit - Called from exiting Hard irq context.
+ *
+ * If the CPU was idle with dynamic ticks active, update the
+ * dynticks_progress_counter to put let the RCU handling be
+ * aware that the CPU is going back to idle with no ticks.
+ */
+void rcu_irq_exit(void)
+{
+	int cpu = smp_processor_id();
+
+	/*
+	 * rcu_update_flag is set if we interrupted the CPU
+	 * when it was idle with ticks stopped.
+	 * Once this occurs, we keep track of interrupt nesting
+	 * because a NMI/SMI could also come in, and we still
+	 * only want the IRQ that started the increment of the
+	 * dynticks_progress_counter to be the one that modifies
+	 * it on exit.
+	 */
+	if (per_cpu(rcu_update_flag, cpu)) {
+		if (--per_cpu(rcu_update_flag, cpu))
+			return;
+
+		/* This must match the interrupt nesting */
+		WARN_ON(in_interrupt());
+
+		/*
+		 * If an NMI/SMI happens now we are still
+		 * protected by the dynticks_progress_counter being odd.
+		 */
+
+		/*
+		 * The following memory barrier ensures that any
+		 * rcu_read_unlock() primitives in the irq handler
+		 * are seen by other CPUs to preceed the following
+		 * increment to dynticks_progress_counter. This
+		 * is required in order for other CPUs to determine
+		 * when it is safe to advance the RCU grace-period
+		 * state machine.
+		 */
+		smp_mb(); /* see above block comment. */
+		per_cpu(dynticks_progress_counter, cpu)++;
+		WARN_ON(per_cpu(dynticks_progress_counter, cpu) & 0x1);
+	}
+}
+
+static void dyntick_save_progress_counter(int cpu)
+{
+	per_cpu(rcu_dyntick_snapshot, cpu) =
+		per_cpu(dynticks_progress_counter, cpu);
+}
+
+static inline int
+rcu_try_flip_waitack_needed(int cpu)
+{
+	long curr;
+	long snap;
+
+	curr = per_cpu(dynticks_progress_counter, cpu);
+	snap = per_cpu(rcu_dyntick_snapshot, cpu);
+	smp_mb(); /* force ordering with cpu entering/leaving dynticks. */
+
+	/*
+	 * If the CPU remained in dynticks mode for the entire time
+	 * and didn't take any interrupts, NMIs, SMIs, or whatever,
+	 * then it cannot be in the middle of an rcu_read_lock(), so
+	 * the next rcu_read_lock() it executes must use the new value
+	 * of the counter.  So we can safely pretend that this CPU
+	 * already acknowledged the counter.
+	 */
+
+	if ((curr == snap) && ((curr & 0x1) == 0))
+		return 0;
+
+	/*
+	 * If the CPU passed through or entered a dynticks idle phase with
+	 * no active irq handlers, then, as above, we can safely pretend
+	 * that this CPU already acknowledged the counter.
+	 */
+
+	if ((curr - snap) > 2 || (snap & 0x1) == 0)
+		return 0;
+
+	/* We need this CPU to explicitly acknowledge the counter flip. */
+
+	return 1;
+}
+
+static inline int
+rcu_try_flip_waitmb_needed(int cpu)
+{
+	long curr;
+	long snap;
+
+	curr = per_cpu(dynticks_progress_counter, cpu);
+	snap = per_cpu(rcu_dyntick_snapshot, cpu);
+	smp_mb(); /* force ordering with cpu entering/leaving dynticks. */
+
+	/*
+	 * If the CPU remained in dynticks mode for the entire time
+	 * and didn't take any interrupts, NMIs, SMIs, or whatever,
+	 * then it cannot have executed an RCU read-side critical section
+	 * during that time, so there is no need for it to execute a
+	 * memory barrier.
+	 */
+
+	if ((curr == snap) && ((curr & 0x1) == 0))
+		return 0;
+
+	/*
+	 * If the CPU either entered or exited an outermost interrupt,
+	 * SMI, NMI, or whatever handler, then we know that it executed
+	 * a memory barrier when doing so.  So we don't need another one.
+	 */
+	if (curr != snap)
+		return 0;
+
+	/* We need the CPU to execute a memory barrier. */
+
+	return 1;
+}
+
+#else /* !CONFIG_NO_HZ */
+
+# define dyntick_save_progress_counter(cpu)	do { } while (0)
+# define rcu_try_flip_waitack_needed(cpu)	(1)
+# define rcu_try_flip_waitmb_needed(cpu)	(1)
+
+#endif /* CONFIG_NO_HZ */
+
 /*
  * Get here when RCU is idle.  Decide whether we need to
  * move out of idle state, and return non-zero if so.
@@ -447,8 +657,10 @@ rcu_try_flip_idle(void)
 
 	/* Now ask each CPU for acknowledgement of the flip. */
 
-	for_each_cpu_mask(cpu, rcu_cpu_online_map)
+	for_each_cpu_mask(cpu, rcu_cpu_online_map) {
 		per_cpu(rcu_flip_flag, cpu) = rcu_flipped;
+		dyntick_save_progress_counter(cpu);
+	}
 
 	return 1;
 }
@@ -464,7 +676,8 @@ rcu_try_flip_waitack(void)
 
 	RCU_TRACE_ME(rcupreempt_trace_try_flip_a1);
 	for_each_cpu_mask(cpu, rcu_cpu_online_map)
-		if (per_cpu(rcu_flip_flag, cpu) != rcu_flip_seen) {
+		if (rcu_try_flip_waitack_needed(cpu) &&
+		    per_cpu(rcu_flip_flag, cpu) != rcu_flip_seen) {
 			RCU_TRACE_ME(rcupreempt_trace_try_flip_ae1);
 			return 0;
 		}
@@ -509,8 +722,10 @@ rcu_try_flip_waitzero(void)
 	smp_mb();  /*  ^^^^^^^^^^^^ */
 
 	/* Call for a memory barrier from each CPU. */
-	for_each_cpu_mask(cpu, rcu_cpu_online_map)
+	for_each_cpu_mask(cpu, rcu_cpu_online_map) {
 		per_cpu(rcu_mb_flag, cpu) = rcu_mb_needed;
+		dyntick_save_progress_counter(cpu);
+	}
 
 	RCU_TRACE_ME(rcupreempt_trace_try_flip_z2);
 	return 1;
@@ -528,7 +743,8 @@ rcu_try_flip_waitmb(void)
 
 	RCU_TRACE_ME(rcupreempt_trace_try_flip_m1);
 	for_each_cpu_mask(cpu, rcu_cpu_online_map)
-		if (per_cpu(rcu_mb_flag, cpu) != rcu_mb_done) {
+		if (rcu_try_flip_waitmb_needed(cpu) &&
+		    per_cpu(rcu_mb_flag, cpu) != rcu_mb_done) {
 			RCU_TRACE_ME(rcupreempt_trace_try_flip_me1);
 			return 0;
 		}
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 5b3aea5..31e9f2a 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -313,6 +313,7 @@ void irq_exit(void)
 	/* Make sure that timer wheel updates are propagated */
 	if (!in_interrupt() && idle_cpu(smp_processor_id()) && !need_resched())
 		tick_nohz_stop_sched_tick();
+	rcu_irq_exit();
 #endif
 	preempt_enable_no_resched();
 }
diff --git a/kernel/softlockup.c b/kernel/softlockup.c
index 7c2da88..01b6522 100644
--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -216,26 +216,27 @@ static int watchdog(void *__bind_cpu)
 	/* initialize timestamp */
 	touch_softlockup_watchdog();
 
+	set_current_state(TASK_INTERRUPTIBLE);
 	/*
 	 * Run briefly once per second to reset the softlockup timestamp.
 	 * If this gets delayed for more than 60 seconds then the
 	 * debug-printout triggers in softlockup_tick().
 	 */
 	while (!kthread_should_stop()) {
-		set_current_state(TASK_INTERRUPTIBLE);
 		touch_softlockup_watchdog();
 		schedule();
 
 		if (kthread_should_stop())
 			break;
 
-		if (this_cpu != check_cpu)
-			continue;
-
-		if (sysctl_hung_task_timeout_secs)
-			check_hung_uninterruptible_tasks(this_cpu);
+		if (this_cpu == check_cpu) {
+			if (sysctl_hung_task_timeout_secs)
+				check_hung_uninterruptible_tasks(this_cpu);
+		}
 
+		set_current_state(TASK_INTERRUPTIBLE);
 	}
+	__set_current_state(TASK_RUNNING);
 
 	return 0;
 }
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index fa9bb73..2968298 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -282,6 +282,7 @@ void tick_nohz_stop_sched_tick(void)
 			ts->idle_tick = ts->sched_timer.expires;
 			ts->tick_stopped = 1;
 			ts->idle_jiffies = last_jiffies;
+			rcu_enter_nohz();
 		}
 
 		/*
@@ -375,6 +376,8 @@ void tick_nohz_restart_sched_tick(void)
 		return;
 	}
 
+	rcu_exit_nohz();
+
 	/* Update jiffies first */
 	select_nohz_load_balancer(0);
 	now = ktime_get();

