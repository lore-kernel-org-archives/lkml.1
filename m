Return-Path: <linux-kernel-owner+w=401wt.eu-S1756804AbYBKUup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804AbYBKUup (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 15:50:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751625AbYBKUug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 15:50:36 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49413 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527AbYBKUub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 15:50:31 -0500
Date: Mon, 11 Feb 2008 21:49:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Alessandro Suardi <alessandro.suardi@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: 2.6.24-git2: Oracle 11g VKTM process enters R state on startup
	and is unkillable [still broken in 2.6.25-rc1]
Message-ID: <20080211204921.GA24806@elte.hu>
References: <5a4c581d0802110820l1fcbb1ffib874f268b4ab7eae@mail.gmail.com> <200802112009.31018.rjw@sisk.pl> <alpine.LFD.1.00.0802111131310.2920@woody.linux-foundation.org> <200802112056.17839.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802112056.17839.rjw@sisk.pl>
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> Well, I've already bisected that down to commit 
> 6f505b16425a51270058e4a93441fe64de3dd435 "sched: rt group scheduling" 
> and provided a simple test case.  Moreover, there are patches from 
> Peter that fix the problem, but they are lost somewhere in the way 
> from him to you (please see http://lkml.org/lkml/2008/2/5/535 and 
> http://lkml.org/lkml/2008/2/6/320).

no, they were not lost, they just didnt pass QA here (they crashed on a 
particularly hard to debug 8-way box i have) and Peter worked on that 
queue of fixes up until today to get it really correct. Could you check:

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git

combo patch below as well - whichever you prefer. The shortlog can be 
found below as well - but i dont yet consider this pullable, i'd like it 
to see pass a full night of randconfig tests on my test-systems.

this all was complicated by the fact that people found interactivity of 
the group scheduler to be not up to their expectations (the observed 
latencies would go up linearly with the number of UIDs in the system). 
And your positive test results depended on the presence of those (at 
that time, still half-baken) changes. That issue turned out to be due to 
a .24-era design bug in the group scheduler and it took Peter a longer 
time to straighten it out. (he flattened the rbtree to maintain perfect 
weights and to get latencies back within the target.)

So what fixed your thing was simply not pullable into -rc1, as -rc1 was 
being cooled down at around last Friday already. Sorry about that! The 
short-term emergency fix would be to turn off the group scheduler 
altogether. (or, if we are lucky, tomorrow i can send the pull request 
for the changes below.)

	Ingo

------------------>
Peter Zijlstra (15):
      hrtimer: more hrtimer_init_sleeper() fallout.
      sched: fair-group: separate tg->shares from task_group_lock
      sched: fix incorrect irq lock usage in normalize_rt_tasks()
      sched: rt-group: deal with PI
      sched: rt-group: interface
      sched: rt-group: make rt groups scheduling configurable
      sched: rt-group: clean up the ifdeffery
      sched: rt-group: refure unrunnable tasks
      sched: rt-group: synchonised bandwidth period
      sched: rt-group: smp balancing
      sched: cleanup old and rarely used 'debug' features.
      sched: fair-group scheduling vs latency
      sched: fair-group: de-couple load-balancing from the rb-trees
      sched: fair-group: single RQ approach
      sched: remove sysctl_sched_batch_wakeup_granularity

Steven Rostedt (1):
      rcu: add support for dynamic ticks and preempt rcu

 Documentation/sched-rt-group.txt |   59 +++
 include/linux/cgroup_subsys.h    |    2 +-
 include/linux/hardirq.h          |   10 +
 include/linux/init_task.h        |    3 +
 include/linux/rcuclassic.h       |    3 +
 include/linux/rcupreempt.h       |   22 ++
 include/linux/sched.h            |   27 +-
 init/Kconfig                     |   23 +-
 kernel/rcupreempt.c              |  224 +++++++++++-
 kernel/rtmutex.c                 |    5 +-
 kernel/sched.c                   |  766 +++++++++++++++++++++++++++++---------
 kernel/sched_debug.c             |    1 -
 kernel/sched_fair.c              |  381 ++++++++++---------
 kernel/sched_rt.c                |  262 ++++++++++---
 kernel/softirq.c                 |    1 +
 kernel/sysctl.c                  |   43 +--
 kernel/time/tick-sched.c         |    8 +-
 kernel/user.c                    |   78 ++++-
 18 files changed, 1444 insertions(+), 474 deletions(-)
 create mode 100644 Documentation/sched-rt-group.txt

diff --git a/Documentation/sched-rt-group.txt b/Documentation/sched-rt-group.txt
new file mode 100644
index 0000000..1c6332f
--- /dev/null
+++ b/Documentation/sched-rt-group.txt
@@ -0,0 +1,59 @@
+
+
+Real-Time group scheduling.
+
+The problem space:
+
+In order to schedule multiple groups of realtime tasks each group must
+be assigned a fixed portion of the CPU time available. Without a minimum
+guarantee a realtime group can obviously fall short. A fuzzy upper limit
+is of no use since it cannot be relied upon. Which leaves us with just
+the single fixed portion.
+
+CPU time is divided by means of specifying how much time can be spent
+running in a given period. Say a frame fixed realtime renderer must
+deliver 25 frames a second, which yields a period of 0.04s. Now say
+it will also have to play some music and respond to input, leaving it
+with around 80% for the graphics. We can then give this group a runtime
+of 0.8 * 0.04s = 0.032s.
+
+This way the graphics group will have a 0.04s period with a 0.032s runtime
+limit.
+
+Now if the audio thread needs to refill the DMA buffer every 0.005s, but
+needs only about 3% CPU time to do so, it can do with a 0.03 * 0.005s
+= 0.00015s.
+
+
+The Interface:
+
+system wide:
+
+/proc/sys/kernel/sched_rt_period_ms
+/proc/sys/kernel/sched_rt_runtime_us
+
+CONFIG_FAIR_USER_SCHED
+
+/sys/kernel/uids/<uid>/cpu_rt_runtime_us
+
+or
+
+CONFIG_FAIR_CGROUP_SCHED
+
+/cgroup/<cgroup>/cpu.rt_runtime_us
+
+[ time is specified in us because the interface is s32; this gives an
+  operating range of ~35m to 1us ]
+
+The period takes values in [ 1, INT_MAX ], runtime in [ -1, INT_MAX - 1 ].
+
+A runtime of -1 specifies runtime == period, ie. no limit.
+
+New groups get the period from /proc/sys/kernel/sched_rt_period_us and
+a runtime of 0.
+
+Settings are constrained to:
+
+   \Sum_{i} runtime_{i} / global_period <= global_runtime / global_period
+
+in order to keep the configuration schedulable.
diff --git a/include/linux/cgroup_subsys.h b/include/linux/cgroup_subsys.h
index 228235c..ac6aad9 100644
--- a/include/linux/cgroup_subsys.h
+++ b/include/linux/cgroup_subsys.h
@@ -25,7 +25,7 @@ SUBSYS(ns)
 
 /* */
 
-#ifdef CONFIG_FAIR_CGROUP_SCHED
+#ifdef CONFIG_CGROUP_SCHED
 SUBSYS(cpu_cgroup)
 #endif
 
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
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 1f74e1d..37a6f5b 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -151,6 +151,9 @@ extern struct group_info init_groups;
 	.cpus_allowed	= CPU_MASK_ALL,					\
 	.mm		= NULL,						\
 	.active_mm	= &init_mm,					\
+	.se		= {						\
+		.group_node 	= LIST_HEAD_INIT(tsk.se.group_node),	\
+	},								\
 	.rt		= {						\
 		.run_list	= LIST_HEAD_INIT(tsk.rt.run_list),	\
 		.time_slice	= HZ, 					\
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
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 00e1441..3052436 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -590,7 +590,7 @@ struct user_struct {
 	struct hlist_node uidhash_node;
 	uid_t uid;
 
-#ifdef CONFIG_FAIR_USER_SCHED
+#ifdef CONFIG_USER_SCHED
 	struct task_group *tg;
 #ifdef CONFIG_SYSFS
 	struct kobject kobj;
@@ -917,6 +917,7 @@ struct load_weight {
 struct sched_entity {
 	struct load_weight	load;		/* for load-balancing */
 	struct rb_node		run_node;
+	struct list_head	group_node;
 	unsigned int		on_rq;
 
 	u64			exec_start;
@@ -973,7 +974,7 @@ struct sched_rt_entity {
 	unsigned long timeout;
 	int nr_cpus_allowed;
 
-#ifdef CONFIG_FAIR_GROUP_SCHED
+#ifdef CONFIG_RT_GROUP_SCHED
 	struct sched_rt_entity	*parent;
 	/* rq on which this entity is (to be) queued: */
 	struct rt_rq		*rt_rq;
@@ -1536,13 +1537,10 @@ extern void sched_idle_next(void);
 extern unsigned int sysctl_sched_latency;
 extern unsigned int sysctl_sched_min_granularity;
 extern unsigned int sysctl_sched_wakeup_granularity;
-extern unsigned int sysctl_sched_batch_wakeup_granularity;
 extern unsigned int sysctl_sched_child_runs_first;
 extern unsigned int sysctl_sched_features;
 extern unsigned int sysctl_sched_migration_cost;
 extern unsigned int sysctl_sched_nr_migrate;
-extern unsigned int sysctl_sched_rt_period;
-extern unsigned int sysctl_sched_rt_ratio;
 #if defined(CONFIG_FAIR_GROUP_SCHED) && defined(CONFIG_SMP)
 extern unsigned int sysctl_sched_min_bal_int_shares;
 extern unsigned int sysctl_sched_max_bal_int_shares;
@@ -1552,6 +1550,12 @@ int sched_nr_latency_handler(struct ctl_table *table, int write,
 		struct file *file, void __user *buffer, size_t *length,
 		loff_t *ppos);
 #endif
+extern unsigned int sysctl_sched_rt_period;
+extern int sysctl_sched_rt_runtime;
+
+int sched_rt_handler(struct ctl_table *table, int write,
+		struct file *filp, void __user *buffer, size_t *lenp,
+		loff_t *ppos);
 
 extern unsigned int sysctl_sched_compat_yield;
 
@@ -2027,16 +2031,25 @@ extern int sched_mc_power_savings, sched_smt_power_savings;
 
 extern void normalize_rt_tasks(void);
 
-#ifdef CONFIG_FAIR_GROUP_SCHED
+#ifdef CONFIG_GROUP_SCHED
 
 extern struct task_group init_task_group;
 
 extern struct task_group *sched_create_group(void);
 extern void sched_destroy_group(struct task_group *tg);
 extern void sched_move_task(struct task_struct *tsk);
+#ifdef CONFIG_FAIR_GROUP_SCHED
 extern int sched_group_set_shares(struct task_group *tg, unsigned long shares);
 extern unsigned long sched_group_shares(struct task_group *tg);
-
+#endif
+#ifdef CONFIG_RT_GROUP_SCHED
+extern int sched_group_set_rt_runtime(struct task_group *tg,
+				      long rt_runtime_us);
+extern long sched_group_rt_runtime(struct task_group *tg);
+extern int sched_group_set_rt_period(struct task_group *tg,
+				      long rt_period_us);
+extern long sched_group_rt_period(struct task_group *tg);
+#endif
 #endif
 
 #ifdef CONFIG_TASK_XACCT
diff --git a/init/Kconfig b/init/Kconfig
index 824d48c..dcef8b5 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -311,25 +311,36 @@ config CPUSETS
 
 	  Say N if unsure.
 
-config FAIR_GROUP_SCHED
-	bool "Fair group CPU scheduler"
+config GROUP_SCHED
+	bool "Group CPU scheduler"
 	default y
 	help
 	  This feature lets CPU scheduler recognize task groups and control CPU
 	  bandwidth allocation to such task groups.
 
+config FAIR_GROUP_SCHED
+	bool "Group scheduling for SCHED_OTHER"
+	depends on GROUP_SCHED
+	default y
+
+config RT_GROUP_SCHED
+	bool "Group scheduling for SCHED_RR/FIFO"
+	depends on EXPERIMENTAL
+	depends on GROUP_SCHED
+	default n
+
 choice
-	depends on FAIR_GROUP_SCHED
+	depends on GROUP_SCHED
 	prompt "Basis for grouping tasks"
-	default FAIR_USER_SCHED
+	default USER_SCHED
 
-config FAIR_USER_SCHED
+config USER_SCHED
 	bool "user id"
 	help
 	  This option will choose userid as the basis for grouping
 	  tasks, thus providing equal CPU bandwidth to each user.
 
-config FAIR_CGROUP_SCHED
+config CGROUP_SCHED
 	bool "Control groups"
  	depends on CGROUPS
  	help
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
diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index 0deef71..6522ae5 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -630,9 +630,12 @@ rt_mutex_slowlock(struct rt_mutex *lock, int state,
 	set_current_state(state);
 
 	/* Setup the timer, when timeout != NULL */
-	if (unlikely(timeout))
+	if (unlikely(timeout)) {
 		hrtimer_start(&timeout->timer, timeout->timer.expires,
 			      HRTIMER_MODE_ABS);
+		if (!hrtimer_active(&timeout->timer))
+			timeout->task = NULL;
+	}
 
 	for (;;) {
 		/* Try to acquire the lock: */
diff --git a/kernel/sched.c b/kernel/sched.c
index 3eedd52..76dc41d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -114,6 +114,11 @@ unsigned long long __attribute__((weak)) sched_clock(void)
  */
 #define DEF_TIMESLICE		(100 * HZ / 1000)
 
+/*
+ * single value that denotes runtime == period, ie unlimited time.
+ */
+#define RUNTIME_INF	((u64)~0ULL)
+
 #ifdef CONFIG_SMP
 /*
  * Divide a load by a sched group cpu_power : (load / sg->__cpu_power)
@@ -155,7 +160,85 @@ struct rt_prio_array {
 	struct list_head queue[MAX_RT_PRIO];
 };
 
-#ifdef CONFIG_FAIR_GROUP_SCHED
+static inline ktime_t ns_to_ktime(u64 ns)
+{
+	static const ktime_t ktime_zero = { .tv64 = 0 };
+	return ktime_add_ns(ktime_zero, ns);
+}
+
+struct rt_bandwidth {
+	ktime_t rt_period;
+	u64 rt_runtime;
+	spinlock_t rt_runtime_lock;
+	struct hrtimer rt_period_timer;
+};
+
+static struct rt_bandwidth def_rt_bandwidth;
+
+static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun);
+
+static enum hrtimer_restart sched_rt_period_timer(struct hrtimer *timer)
+{
+	struct rt_bandwidth *rt_b =
+		container_of(timer, struct rt_bandwidth, rt_period_timer);
+	ktime_t now;
+	int overrun;
+	int idle = 0;
+
+	for (;;) {
+		now = hrtimer_cb_get_time(timer);
+		overrun = hrtimer_forward(timer, now, rt_b->rt_period);
+
+		if (!overrun)
+			break;
+
+		idle = do_sched_rt_period_timer(rt_b, overrun);
+	}
+
+	return idle ? HRTIMER_NORESTART : HRTIMER_RESTART;
+}
+
+static
+void init_rt_bandwidth(struct rt_bandwidth *rt_b, u64 period, u64 runtime)
+{
+	rt_b->rt_period = ns_to_ktime(period);
+	rt_b->rt_runtime = runtime;
+
+	spin_lock_init(&rt_b->rt_runtime_lock);
+
+	hrtimer_init(&rt_b->rt_period_timer,
+			CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	rt_b->rt_period_timer.function = sched_rt_period_timer;
+	rt_b->rt_period_timer.cb_mode = HRTIMER_CB_IRQSAFE_NO_SOFTIRQ;
+}
+
+static void start_rt_bandwidth(struct rt_bandwidth *rt_b)
+{
+	ktime_t now;
+
+	if (rt_b->rt_runtime == RUNTIME_INF)
+		return;
+
+	for (;;) {
+		if (hrtimer_active(&rt_b->rt_period_timer))
+			break;
+
+		now = hrtimer_cb_get_time(&rt_b->rt_period_timer);
+		hrtimer_forward(&rt_b->rt_period_timer, now, rt_b->rt_period);
+		hrtimer_start(&rt_b->rt_period_timer,
+			      rt_b->rt_period_timer.expires,
+			      HRTIMER_MODE_ABS);
+	}
+}
+
+#ifdef CONFIG_RT_GROUP_SCHED
+static void destroy_rt_bandwidth(struct rt_bandwidth *rt_b)
+{
+	hrtimer_cancel(&rt_b->rt_period_timer);
+}
+#endif
+
+#ifdef CONFIG_GROUP_SCHED
 
 #include <linux/cgroup.h>
 
@@ -165,19 +248,16 @@ static LIST_HEAD(task_groups);
 
 /* task group related information */
 struct task_group {
-#ifdef CONFIG_FAIR_CGROUP_SCHED
+#ifdef CONFIG_CGROUP_SCHED
 	struct cgroup_subsys_state css;
 #endif
+
+#ifdef CONFIG_FAIR_GROUP_SCHED
 	/* schedulable entities of this group on each cpu */
 	struct sched_entity **se;
 	/* runqueue "owned" by this group on each cpu */
 	struct cfs_rq **cfs_rq;
 
-	struct sched_rt_entity **rt_se;
-	struct rt_rq **rt_rq;
-
-	unsigned int rt_ratio;
-
 	/*
 	 * shares assigned to a task group governs how much of cpu bandwidth
 	 * is allocated to the group. The more shares a group has, the more is
@@ -213,33 +293,46 @@ struct task_group {
 	 *
 	 */
 	unsigned long shares;
+#endif
+
+#ifdef CONFIG_RT_GROUP_SCHED
+	struct sched_rt_entity **rt_se;
+	struct rt_rq **rt_rq;
+
+	struct rt_bandwidth rt_bandwidth;
+#endif
 
 	struct rcu_head rcu;
 	struct list_head list;
 };
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
 /* Default task group's sched entity on each cpu */
 static DEFINE_PER_CPU(struct sched_entity, init_sched_entity);
 /* Default task group's cfs_rq on each cpu */
 static DEFINE_PER_CPU(struct cfs_rq, init_cfs_rq) ____cacheline_aligned_in_smp;
 
-static DEFINE_PER_CPU(struct sched_rt_entity, init_sched_rt_entity);
-static DEFINE_PER_CPU(struct rt_rq, init_rt_rq) ____cacheline_aligned_in_smp;
-
 static struct sched_entity *init_sched_entity_p[NR_CPUS];
 static struct cfs_rq *init_cfs_rq_p[NR_CPUS];
+#endif
+
+#ifdef CONFIG_RT_GROUP_SCHED
+static DEFINE_PER_CPU(struct sched_rt_entity, init_sched_rt_entity);
+static DEFINE_PER_CPU(struct rt_rq, init_rt_rq) ____cacheline_aligned_in_smp;
 
 static struct sched_rt_entity *init_sched_rt_entity_p[NR_CPUS];
 static struct rt_rq *init_rt_rq_p[NR_CPUS];
+#endif
 
-/* task_group_mutex serializes add/remove of task groups and also changes to
+/* task_group_lock serializes add/remove of task groups and also changes to
  * a task group's cpu shares.
  */
-static DEFINE_MUTEX(task_group_mutex);
+static DEFINE_SPINLOCK(task_group_lock);
 
 /* doms_cur_mutex serializes access to doms_cur[] array */
 static DEFINE_MUTEX(doms_cur_mutex);
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
 #ifdef CONFIG_SMP
 /* kernel thread that runs rebalance_shares() periodically */
 static struct task_struct *lb_monitor_task;
@@ -248,35 +341,40 @@ static int load_balance_monitor(void *unused);
 
 static void set_se_shares(struct sched_entity *se, unsigned long shares);
 
+#ifdef CONFIG_USER_SCHED
+# define INIT_TASK_GROUP_LOAD	(2*NICE_0_LOAD)
+#else
+# define INIT_TASK_GROUP_LOAD	NICE_0_LOAD
+#endif
+
+#define MIN_GROUP_SHARES	2
+
+static int init_task_group_load = INIT_TASK_GROUP_LOAD;
+#endif
+
 /* Default task group.
  *	Every task in system belong to this group at bootup.
  */
 struct task_group init_task_group = {
+#ifdef CONFIG_FAIR_GROUP_SCHED
 	.se	= init_sched_entity_p,
 	.cfs_rq = init_cfs_rq_p,
+#endif
 
+#ifdef CONFIG_RT_GROUP_SCHED
 	.rt_se	= init_sched_rt_entity_p,
 	.rt_rq	= init_rt_rq_p,
-};
-
-#ifdef CONFIG_FAIR_USER_SCHED
-# define INIT_TASK_GROUP_LOAD	(2*NICE_0_LOAD)
-#else
-# define INIT_TASK_GROUP_LOAD	NICE_0_LOAD
 #endif
-
-#define MIN_GROUP_SHARES	2
-
-static int init_task_group_load = INIT_TASK_GROUP_LOAD;
+};
 
 /* return group to which a task belongs */
 static inline struct task_group *task_group(struct task_struct *p)
 {
 	struct task_group *tg;
 
-#ifdef CONFIG_FAIR_USER_SCHED
+#ifdef CONFIG_USER_SCHED
 	tg = p->user->tg;
-#elif defined(CONFIG_FAIR_CGROUP_SCHED)
+#elif defined(CONFIG_CGROUP_SCHED)
 	tg = container_of(task_subsys_state(p, cpu_cgroup_subsys_id),
 				struct task_group, css);
 #else
@@ -288,21 +386,15 @@ static inline struct task_group *task_group(struct task_struct *p)
 /* Change a task's cfs_rq and parent entity if it moves across CPUs/groups */
 static inline void set_task_rq(struct task_struct *p, unsigned int cpu)
 {
+#ifdef CONFIG_FAIR_GROUP_SCHED
 	p->se.cfs_rq = task_group(p)->cfs_rq[cpu];
 	p->se.parent = task_group(p)->se[cpu];
+#endif
 
+#ifdef CONFIG_RT_GROUP_SCHED
 	p->rt.rt_rq  = task_group(p)->rt_rq[cpu];
 	p->rt.parent = task_group(p)->rt_se[cpu];
-}
-
-static inline void lock_task_group_list(void)
-{
-	mutex_lock(&task_group_mutex);
-}
-
-static inline void unlock_task_group_list(void)
-{
-	mutex_unlock(&task_group_mutex);
+#endif
 }
 
 static inline void lock_doms_cur(void)
@@ -318,12 +410,10 @@ static inline void unlock_doms_cur(void)
 #else
 
 static inline void set_task_rq(struct task_struct *p, unsigned int cpu) { }
-static inline void lock_task_group_list(void) { }
-static inline void unlock_task_group_list(void) { }
 static inline void lock_doms_cur(void) { }
 static inline void unlock_doms_cur(void) { }
 
-#endif	/* CONFIG_FAIR_GROUP_SCHED */
+#endif	/* CONFIG_GROUP_SCHED */
 
 /* CFS-related fields in a runqueue */
 struct cfs_rq {
@@ -335,8 +425,12 @@ struct cfs_rq {
 
 	struct rb_root tasks_timeline;
 	struct rb_node *rb_leftmost;
-	struct rb_node *rb_load_balance_curr;
-	/* 'curr' points to currently running entity on this cfs_rq.
+
+	struct list_head tasks;
+	struct list_head *balance_iterator;
+
+	/*
+	 * 'curr' points to currently running entity on this cfs_rq.
 	 * It is set to NULL otherwise (i.e when none are currently running).
 	 */
 	struct sched_entity *curr;
@@ -363,7 +457,7 @@ struct cfs_rq {
 struct rt_rq {
 	struct rt_prio_array active;
 	unsigned long rt_nr_running;
-#if defined CONFIG_SMP || defined CONFIG_FAIR_GROUP_SCHED
+#if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
 	int highest_prio; /* highest queued rt task prio */
 #endif
 #ifdef CONFIG_SMP
@@ -372,8 +466,12 @@ struct rt_rq {
 #endif
 	int rt_throttled;
 	u64 rt_time;
+	u64 rt_runtime;
+	spinlock_t rt_runtime_lock;
+
+#ifdef CONFIG_RT_GROUP_SCHED
+	unsigned long rt_nr_boosted;
 
-#ifdef CONFIG_FAIR_GROUP_SCHED
 	struct rq *rq;
 	struct list_head leaf_rt_rq_list;
 	struct task_group *tg;
@@ -441,12 +539,12 @@ struct rq {
 
 	struct cfs_rq cfs;
 	struct rt_rq rt;
-	u64 rt_period_expire;
-	int rt_throttled;
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	/* list of leaf cfs_rq on this cpu: */
 	struct list_head leaf_cfs_rq_list;
+#endif
+#ifdef CONFIG_RT_GROUP_SCHED
 	struct list_head leaf_rt_rq_list;
 #endif
 
@@ -595,23 +693,6 @@ static void update_rq_clock(struct rq *rq)
 #define task_rq(p)		cpu_rq(task_cpu(p))
 #define cpu_curr(cpu)		(cpu_rq(cpu)->curr)
 
-unsigned long rt_needs_cpu(int cpu)
-{
-	struct rq *rq = cpu_rq(cpu);
-	u64 delta;
-
-	if (!rq->rt_throttled)
-		return 0;
-
-	if (rq->clock > rq->rt_period_expire)
-		return 1;
-
-	delta = rq->rt_period_expire - rq->clock;
-	do_div(delta, NSEC_PER_SEC / HZ);
-
-	return (unsigned long)delta;
-}
-
 /*
  * Tunables that become constants when CONFIG_SCHED_DEBUG is off:
  */
@@ -628,18 +709,14 @@ enum {
 	SCHED_FEAT_NEW_FAIR_SLEEPERS	= 1,
 	SCHED_FEAT_WAKEUP_PREEMPT	= 2,
 	SCHED_FEAT_START_DEBIT		= 4,
-	SCHED_FEAT_TREE_AVG		= 8,
-	SCHED_FEAT_APPROX_AVG		= 16,
-	SCHED_FEAT_HRTICK		= 32,
-	SCHED_FEAT_DOUBLE_TICK		= 64,
+	SCHED_FEAT_HRTICK		= 8,
+	SCHED_FEAT_DOUBLE_TICK		= 16,
 };
 
 const_debug unsigned int sysctl_sched_features =
 		SCHED_FEAT_NEW_FAIR_SLEEPERS	* 1 |
 		SCHED_FEAT_WAKEUP_PREEMPT	* 1 |
 		SCHED_FEAT_START_DEBIT		* 1 |
-		SCHED_FEAT_TREE_AVG		* 0 |
-		SCHED_FEAT_APPROX_AVG		* 0 |
 		SCHED_FEAT_HRTICK		* 1 |
 		SCHED_FEAT_DOUBLE_TICK		* 0;
 
@@ -652,19 +729,29 @@ const_debug unsigned int sysctl_sched_features =
 const_debug unsigned int sysctl_sched_nr_migrate = 32;
 
 /*
- * period over which we measure -rt task cpu usage in ms.
+ * period over which we measure -rt task cpu usage in us.
  * default: 1s
  */
-const_debug unsigned int sysctl_sched_rt_period = 1000;
-
-#define SCHED_RT_FRAC_SHIFT	16
-#define SCHED_RT_FRAC		(1UL << SCHED_RT_FRAC_SHIFT)
+unsigned int sysctl_sched_rt_period = 1000000;
 
 /*
- * ratio of time -rt tasks may consume.
- * default: 95%
+ * part of the period that we allow rt tasks to run in us.
+ * default: 0.95s
  */
-const_debug unsigned int sysctl_sched_rt_ratio = 62259;
+int sysctl_sched_rt_runtime = 950000;
+
+static inline u64 global_rt_period(void)
+{
+	return (u64)sysctl_sched_rt_period * NSEC_PER_USEC;
+}
+
+static inline u64 global_rt_runtime(void)
+{
+	if (sysctl_sched_rt_period < 0)
+		return RUNTIME_INF;
+
+	return (u64)sysctl_sched_rt_runtime * NSEC_PER_USEC;
+}
 
 /*
  * For kernel-internal use: high-speed (but slightly incorrect) per-cpu
@@ -1105,6 +1192,9 @@ static void __resched_task(struct task_struct *p, int tif_bit)
  */
 #define SRR(x, y) (((x) + (1UL << ((y) - 1))) >> (y))
 
+/*
+ * delta *= weight / lw
+ */
 static unsigned long
 calc_delta_mine(unsigned long delta_exec, unsigned long weight,
 		struct load_weight *lw)
@@ -1127,12 +1217,6 @@ calc_delta_mine(unsigned long delta_exec, unsigned long weight,
 	return (unsigned long)min(tmp, (u64)(unsigned long)LONG_MAX);
 }
 
-static inline unsigned long
-calc_delta_fair(unsigned long delta_exec, struct load_weight *lw)
-{
-	return calc_delta_mine(delta_exec, NICE_0_LOAD, lw);
-}
-
 static inline void update_load_add(struct load_weight *lw, unsigned long inc)
 {
 	lw->weight += inc;
@@ -1930,6 +2014,7 @@ static void __sched_fork(struct task_struct *p)
 
 	INIT_LIST_HEAD(&p->rt.run_list);
 	p->se.on_rq = 0;
+	INIT_LIST_HEAD(&p->se.group_node);
 
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 	INIT_HLIST_HEAD(&p->preempt_notifiers);
@@ -3742,7 +3827,6 @@ void scheduler_tick(void)
 	rq->tick_timestamp = rq->clock;
 	update_cpu_load(rq);
 	curr->sched_class->task_tick(rq, curr, 0);
-	update_sched_rt_period(rq);
 	spin_unlock(&rq->lock);
 
 #ifdef CONFIG_SMP
@@ -4571,6 +4655,15 @@ recheck:
 			return -EPERM;
 	}
 
+#ifdef CONFIG_RT_GROUP_SCHED
+	/*
+	 * Do not allow realtime tasks into groups that have no runtime
+	 * assigned.
+	 */
+	if (rt_policy(policy) && task_group(p)->rt_bandwidth.rt_runtime == 0)
+		return -EPERM;
+#endif
+
 	retval = security_task_setscheduler(p, policy, param);
 	if (retval)
 		return retval;
@@ -5276,7 +5369,6 @@ static inline void sched_init_granularity(void)
 		sysctl_sched_latency = limit;
 
 	sysctl_sched_wakeup_granularity *= factor;
-	sysctl_sched_batch_wakeup_granularity *= factor;
 }
 
 #ifdef CONFIG_SMP
@@ -7093,6 +7185,8 @@ int in_sched_functions(unsigned long addr)
 static void init_cfs_rq(struct cfs_rq *cfs_rq, struct rq *rq)
 {
 	cfs_rq->tasks_timeline = RB_ROOT;
+	INIT_LIST_HEAD(&cfs_rq->tasks);
+	cfs_rq->rb_leftmost = NULL;
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	cfs_rq->rq = rq;
 #endif
@@ -7112,7 +7206,7 @@ static void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq)
 	/* delimiter for bitsearch: */
 	__set_bit(MAX_RT_PRIO, array->bitmap);
 
-#if defined CONFIG_SMP || defined CONFIG_FAIR_GROUP_SCHED
+#if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
 	rt_rq->highest_prio = MAX_RT_PRIO;
 #endif
 #ifdef CONFIG_SMP
@@ -7122,8 +7216,11 @@ static void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq)
 
 	rt_rq->rt_time = 0;
 	rt_rq->rt_throttled = 0;
+	rt_rq->rt_runtime = 0;
+	spin_lock_init(&rt_rq->rt_runtime_lock);
 
-#ifdef CONFIG_FAIR_GROUP_SCHED
+#ifdef CONFIG_RT_GROUP_SCHED
+	rt_rq->rt_nr_boosted = 0;
 	rt_rq->rq = rq;
 #endif
 }
@@ -7146,7 +7243,9 @@ static void init_tg_cfs_entry(struct rq *rq, struct task_group *tg,
 	se->load.inv_weight = div64_64(1ULL<<32, se->load.weight);
 	se->parent = NULL;
 }
+#endif
 
+#ifdef CONFIG_RT_GROUP_SCHED
 static void init_tg_rt_entry(struct rq *rq, struct task_group *tg,
 		struct rt_rq *rt_rq, struct sched_rt_entity *rt_se,
 		int cpu, int add)
@@ -7155,6 +7254,7 @@ static void init_tg_rt_entry(struct rq *rq, struct task_group *tg,
 	init_rt_rq(rt_rq, rq);
 	rt_rq->tg = tg;
 	rt_rq->rt_se = rt_se;
+	rt_rq->rt_runtime = tg->rt_bandwidth.rt_runtime;
 	if (add)
 		list_add(&rt_rq->leaf_rt_rq_list, &rq->leaf_rt_rq_list);
 
@@ -7175,10 +7275,20 @@ void __init sched_init(void)
 	init_defrootdomain();
 #endif
 
-#ifdef CONFIG_FAIR_GROUP_SCHED
+	init_rt_bandwidth(&def_rt_bandwidth,
+			global_rt_period(), global_rt_runtime());
+
+#ifdef CONFIG_RT_GROUP_SCHED
+	init_rt_bandwidth(&init_task_group.rt_bandwidth,
+			global_rt_period(), global_rt_runtime());
+#endif
+
+#ifdef CONFIG_GROUP_SCHED
 	list_add(&init_task_group.list, &task_groups);
 #endif
 
+	INIT_LIST_HEAD(&init_task.se.group_node);
+
 	for_each_possible_cpu(i) {
 		struct rq *rq;
 
@@ -7196,14 +7306,15 @@ void __init sched_init(void)
 				&per_cpu(init_cfs_rq, i),
 				&per_cpu(init_sched_entity, i), i, 1);
 
-		init_task_group.rt_ratio = sysctl_sched_rt_ratio; /* XXX */
+#endif
+#ifdef CONFIG_RT_GROUP_SCHED
 		INIT_LIST_HEAD(&rq->leaf_rt_rq_list);
 		init_tg_rt_entry(rq, &init_task_group,
 				&per_cpu(init_rt_rq, i),
 				&per_cpu(init_sched_rt_entity, i), i, 1);
+#else
+		rq->rt.rt_runtime = def_rt_bandwidth.rt_runtime;
 #endif
-		rq->rt_period_expire = 0;
-		rq->rt_throttled = 0;
 
 		for (j = 0; j < CPU_LOAD_IDX_MAX; j++)
 			rq->cpu_load[j] = 0;
@@ -7303,7 +7414,7 @@ void normalize_rt_tasks(void)
 	unsigned long flags;
 	struct rq *rq;
 
-	read_lock_irq(&tasklist_lock);
+	read_lock_irqsave(&tasklist_lock, flags);
 	do_each_thread(g, p) {
 		/*
 		 * Only normalize user tasks:
@@ -7329,16 +7440,16 @@ void normalize_rt_tasks(void)
 			continue;
 		}
 
-		spin_lock_irqsave(&p->pi_lock, flags);
+		spin_lock(&p->pi_lock);
 		rq = __task_rq_lock(p);
 
 		normalize_task(rq, p);
 
 		__task_rq_unlock(rq);
-		spin_unlock_irqrestore(&p->pi_lock, flags);
+		spin_unlock(&p->pi_lock);
 	} while_each_thread(g, p);
 
-	read_unlock_irq(&tasklist_lock);
+	read_unlock_irqrestore(&tasklist_lock, flags);
 }
 
 #endif /* CONFIG_MAGIC_SYSRQ */
@@ -7387,9 +7498,7 @@ void set_curr_task(int cpu, struct task_struct *p)
 
 #endif
 
-#ifdef CONFIG_FAIR_GROUP_SCHED
-
-#ifdef CONFIG_SMP
+#if defined CONFIG_FAIR_GROUP_SCHED && defined CONFIG_SMP
 /*
  * distribute shares of all task groups among their schedulable entities,
  * to reflect load distribution across cpus.
@@ -7540,7 +7649,8 @@ static int load_balance_monitor(void *unused)
 }
 #endif	/* CONFIG_SMP */
 
-static void free_sched_group(struct task_group *tg)
+#ifdef CONFIG_FAIR_GROUP_SCHED
+static void free_fair_sched_group(struct task_group *tg)
 {
 	int i;
 
@@ -7549,49 +7659,27 @@ static void free_sched_group(struct task_group *tg)
 			kfree(tg->cfs_rq[i]);
 		if (tg->se)
 			kfree(tg->se[i]);
-		if (tg->rt_rq)
-			kfree(tg->rt_rq[i]);
-		if (tg->rt_se)
-			kfree(tg->rt_se[i]);
 	}
 
 	kfree(tg->cfs_rq);
 	kfree(tg->se);
-	kfree(tg->rt_rq);
-	kfree(tg->rt_se);
-	kfree(tg);
 }
 
-/* allocate runqueue etc for a new task group */
-struct task_group *sched_create_group(void)
+static int alloc_fair_sched_group(struct task_group *tg)
 {
-	struct task_group *tg;
 	struct cfs_rq *cfs_rq;
 	struct sched_entity *se;
-	struct rt_rq *rt_rq;
-	struct sched_rt_entity *rt_se;
 	struct rq *rq;
 	int i;
 
-	tg = kzalloc(sizeof(*tg), GFP_KERNEL);
-	if (!tg)
-		return ERR_PTR(-ENOMEM);
-
 	tg->cfs_rq = kzalloc(sizeof(cfs_rq) * NR_CPUS, GFP_KERNEL);
 	if (!tg->cfs_rq)
 		goto err;
 	tg->se = kzalloc(sizeof(se) * NR_CPUS, GFP_KERNEL);
 	if (!tg->se)
 		goto err;
-	tg->rt_rq = kzalloc(sizeof(rt_rq) * NR_CPUS, GFP_KERNEL);
-	if (!tg->rt_rq)
-		goto err;
-	tg->rt_se = kzalloc(sizeof(rt_se) * NR_CPUS, GFP_KERNEL);
-	if (!tg->rt_se)
-		goto err;
 
 	tg->shares = NICE_0_LOAD;
-	tg->rt_ratio = 0; /* XXX */
 
 	for_each_possible_cpu(i) {
 		rq = cpu_rq(i);
@@ -7606,6 +7694,82 @@ struct task_group *sched_create_group(void)
 		if (!se)
 			goto err;
 
+		init_tg_cfs_entry(rq, tg, cfs_rq, se, i, 0);
+	}
+
+	return 1;
+
+ err:
+	return 0;
+}
+
+static inline void register_fair_sched_group(struct task_group *tg, int cpu)
+{
+	list_add_rcu(&tg->cfs_rq[cpu]->leaf_cfs_rq_list,
+			&cpu_rq(cpu)->leaf_cfs_rq_list);
+}
+
+static inline void unregister_fair_sched_group(struct task_group *tg, int cpu)
+{
+	list_del_rcu(&tg->cfs_rq[cpu]->leaf_cfs_rq_list);
+}
+#else
+static inline void free_fair_sched_group(struct task_group *tg)
+{
+}
+
+static inline int alloc_fair_sched_group(struct task_group *tg)
+{
+	return 1;
+}
+
+static inline void register_fair_sched_group(struct task_group *tg, int cpu)
+{
+}
+
+static inline void unregister_fair_sched_group(struct task_group *tg, int cpu)
+{
+}
+#endif
+
+#ifdef CONFIG_RT_GROUP_SCHED
+static void free_rt_sched_group(struct task_group *tg)
+{
+	int i;
+
+	destroy_rt_bandwidth(&tg->rt_bandwidth);
+
+	for_each_possible_cpu(i) {
+		if (tg->rt_rq)
+			kfree(tg->rt_rq[i]);
+		if (tg->rt_se)
+			kfree(tg->rt_se[i]);
+	}
+
+	kfree(tg->rt_rq);
+	kfree(tg->rt_se);
+}
+
+static int alloc_rt_sched_group(struct task_group *tg)
+{
+	struct rt_rq *rt_rq;
+	struct sched_rt_entity *rt_se;
+	struct rq *rq;
+	int i;
+
+	tg->rt_rq = kzalloc(sizeof(rt_rq) * NR_CPUS, GFP_KERNEL);
+	if (!tg->rt_rq)
+		goto err;
+	tg->rt_se = kzalloc(sizeof(rt_se) * NR_CPUS, GFP_KERNEL);
+	if (!tg->rt_se)
+		goto err;
+
+	init_rt_bandwidth(&tg->rt_bandwidth,
+			ktime_to_ns(def_rt_bandwidth.rt_period), 0);
+
+	for_each_possible_cpu(i) {
+		rq = cpu_rq(i);
+
 		rt_rq = kmalloc_node(sizeof(struct rt_rq),
 				GFP_KERNEL|__GFP_ZERO, cpu_to_node(i));
 		if (!rt_rq)
@@ -7616,20 +7780,76 @@ struct task_group *sched_create_group(void)
 		if (!rt_se)
 			goto err;
 
-		init_tg_cfs_entry(rq, tg, cfs_rq, se, i, 0);
 		init_tg_rt_entry(rq, tg, rt_rq, rt_se, i, 0);
 	}
 
-	lock_task_group_list();
+	return 1;
+
+ err:
+	return 0;
+}
+
+static inline void register_rt_sched_group(struct task_group *tg, int cpu)
+{
+	list_add_rcu(&tg->rt_rq[cpu]->leaf_rt_rq_list,
+			&cpu_rq(cpu)->leaf_rt_rq_list);
+}
+
+static inline void unregister_rt_sched_group(struct task_group *tg, int cpu)
+{
+	list_del_rcu(&tg->rt_rq[cpu]->leaf_rt_rq_list);
+}
+#else
+static inline void free_rt_sched_group(struct task_group *tg)
+{
+}
+
+static inline int alloc_rt_sched_group(struct task_group *tg)
+{
+	return 1;
+}
+
+static inline void register_rt_sched_group(struct task_group *tg, int cpu)
+{
+}
+
+static inline void unregister_rt_sched_group(struct task_group *tg, int cpu)
+{
+}
+#endif
+
+#ifdef CONFIG_GROUP_SCHED
+static void free_sched_group(struct task_group *tg)
+{
+	free_fair_sched_group(tg);
+	free_rt_sched_group(tg);
+	kfree(tg);
+}
+
+/* allocate runqueue etc for a new task group */
+struct task_group *sched_create_group(void)
+{
+	struct task_group *tg;
+	unsigned long flags;
+	int i;
+
+	tg = kzalloc(sizeof(*tg), GFP_KERNEL);
+	if (!tg)
+		return ERR_PTR(-ENOMEM);
+
+	if (!alloc_fair_sched_group(tg))
+		goto err;
+
+	if (!alloc_rt_sched_group(tg))
+		goto err;
+
+	spin_lock_irqsave(&task_group_lock, flags);
 	for_each_possible_cpu(i) {
-		rq = cpu_rq(i);
-		cfs_rq = tg->cfs_rq[i];
-		list_add_rcu(&cfs_rq->leaf_cfs_rq_list, &rq->leaf_cfs_rq_list);
-		rt_rq = tg->rt_rq[i];
-		list_add_rcu(&rt_rq->leaf_rt_rq_list, &rq->leaf_rt_rq_list);
+		register_fair_sched_group(tg, i);
+		register_rt_sched_group(tg, i);
 	}
 	list_add_rcu(&tg->list, &task_groups);
-	unlock_task_group_list();
+	spin_unlock_irqrestore(&task_group_lock, flags);
 
 	return tg;
 
@@ -7648,21 +7868,16 @@ static void free_sched_group_rcu(struct rcu_head *rhp)
 /* Destroy runqueue etc associated with a task group */
 void sched_destroy_group(struct task_group *tg)
 {
-	struct cfs_rq *cfs_rq = NULL;
-	struct rt_rq *rt_rq = NULL;
+	unsigned long flags;
 	int i;
 
-	lock_task_group_list();
+	spin_lock_irqsave(&task_group_lock, flags);
 	for_each_possible_cpu(i) {
-		cfs_rq = tg->cfs_rq[i];
-		list_del_rcu(&cfs_rq->leaf_cfs_rq_list);
-		rt_rq = tg->rt_rq[i];
-		list_del_rcu(&rt_rq->leaf_rt_rq_list);
+		unregister_fair_sched_group(tg, i);
+		unregister_rt_sched_group(tg, i);
 	}
 	list_del_rcu(&tg->list);
-	unlock_task_group_list();
-
-	BUG_ON(!cfs_rq);
+	spin_unlock_irqrestore(&task_group_lock, flags);
 
 	/* wait for possible concurrent references to cfs_rqs complete */
 	call_rcu(&tg->rcu, free_sched_group_rcu);
@@ -7702,7 +7917,9 @@ void sched_move_task(struct task_struct *tsk)
 
 	task_rq_unlock(rq, &flags);
 }
+#endif
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
 /* rq->lock to be locked by caller */
 static void set_se_shares(struct sched_entity *se, unsigned long shares)
 {
@@ -7728,13 +7945,14 @@ static void set_se_shares(struct sched_entity *se, unsigned long shares)
 	}
 }
 
+static DEFINE_MUTEX(shares_mutex);
+
 int sched_group_set_shares(struct task_group *tg, unsigned long shares)
 {
 	int i;
-	struct cfs_rq *cfs_rq;
-	struct rq *rq;
+	unsigned long flags;
 
-	lock_task_group_list();
+	mutex_lock(&shares_mutex);
 	if (tg->shares == shares)
 		goto done;
 
@@ -7746,10 +7964,10 @@ int sched_group_set_shares(struct task_group *tg, unsigned long shares)
 	 * load_balance_fair) from referring to this group first,
 	 * by taking it off the rq->leaf_cfs_rq_list on each cpu.
 	 */
-	for_each_possible_cpu(i) {
-		cfs_rq = tg->cfs_rq[i];
-		list_del_rcu(&cfs_rq->leaf_cfs_rq_list);
-	}
+	spin_lock_irqsave(&task_group_lock, flags);
+	for_each_possible_cpu(i)
+		unregister_fair_sched_group(tg, i);
+	spin_unlock_irqrestore(&task_group_lock, flags);
 
 	/* wait for any ongoing reference to this group to finish */
 	synchronize_sched();
@@ -7769,13 +7987,12 @@ int sched_group_set_shares(struct task_group *tg, unsigned long shares)
 	 * Enable load balance activity on this group, by inserting it back on
 	 * each cpu's rq->leaf_cfs_rq_list.
 	 */
-	for_each_possible_cpu(i) {
-		rq = cpu_rq(i);
-		cfs_rq = tg->cfs_rq[i];
-		list_add_rcu(&cfs_rq->leaf_cfs_rq_list, &rq->leaf_cfs_rq_list);
-	}
+	spin_lock_irqsave(&task_group_lock, flags);
+	for_each_possible_cpu(i)
+		register_fair_sched_group(tg, i);
+	spin_unlock_irqrestore(&task_group_lock, flags);
 done:
-	unlock_task_group_list();
+	mutex_unlock(&shares_mutex);
 	return 0;
 }
 
@@ -7783,35 +8000,178 @@ unsigned long sched_group_shares(struct task_group *tg)
 {
 	return tg->shares;
 }
+#endif
 
+#ifdef CONFIG_RT_GROUP_SCHED
 /*
- * Ensure the total rt_ratio <= sysctl_sched_rt_ratio
+ * Ensure that the real time constraints are schedulable.
  */
-int sched_group_set_rt_ratio(struct task_group *tg, unsigned long rt_ratio)
+static DEFINE_MUTEX(rt_constraints_mutex);
+
+static unsigned long to_ratio(u64 period, u64 runtime)
+{
+	if (runtime == RUNTIME_INF)
+		return 1ULL << 16;
+
+	runtime *= (1ULL << 16);
+	div64_64(runtime, period);
+	return runtime;
+}
+
+static int __rt_schedulable(struct task_group *tg, u64 period, u64 runtime)
 {
 	struct task_group *tgi;
 	unsigned long total = 0;
+	unsigned long global_ratio =
+		to_ratio(global_rt_period(), global_rt_runtime());
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(tgi, &task_groups, list)
-		total += tgi->rt_ratio;
+	list_for_each_entry_rcu(tgi, &task_groups, list) {
+		if (tgi == tg)
+			continue;
+
+		total += to_ratio(ktime_to_ns(tgi->rt_bandwidth.rt_period),
+				tgi->rt_bandwidth.rt_runtime);
+	}
 	rcu_read_unlock();
 
-	if (total + rt_ratio - tg->rt_ratio > sysctl_sched_rt_ratio)
-		return -EINVAL;
+	return total + to_ratio(period, runtime) < global_ratio;
+}
 
-	tg->rt_ratio = rt_ratio;
-	return 0;
+static int tg_set_bandwidth(struct task_group *tg,
+		u64 rt_period, u64 rt_runtime)
+{
+	int i, err = 0;
+
+	mutex_lock(&rt_constraints_mutex);
+	if (!__rt_schedulable(tg, rt_period, rt_runtime)) {
+		err = -EINVAL;
+		goto unlock;
+	}
+
+	spin_lock_irq(&tg->rt_bandwidth.rt_runtime_lock);
+	tg->rt_bandwidth.rt_period = ns_to_ktime(rt_period);
+	tg->rt_bandwidth.rt_runtime = rt_runtime;
+
+	for_each_possible_cpu(i) {
+		struct rt_rq *rt_rq = tg->rt_rq[i];
+
+		spin_lock(&rt_rq->rt_runtime_lock);
+		rt_rq->rt_runtime = rt_runtime;
+		spin_unlock(&rt_rq->rt_runtime_lock);
+	}
+	spin_unlock_irq(&tg->rt_bandwidth.rt_runtime_lock);
+ unlock:
+	mutex_unlock(&rt_constraints_mutex);
+
+	return err;
+}
+
+int sched_group_set_rt_runtime(struct task_group *tg, long rt_runtime_us)
+{
+	u64 rt_runtime, rt_period;
+
+	rt_period = ktime_to_ns(tg->rt_bandwidth.rt_period);
+	rt_runtime = (u64)rt_runtime_us * NSEC_PER_USEC;
+	if (rt_runtime_us < 0)
+		rt_runtime = RUNTIME_INF;
+
+	return tg_set_bandwidth(tg, rt_period, rt_runtime);
+}
+
+long sched_group_rt_runtime(struct task_group *tg)
+{
+	u64 rt_runtime_us;
+
+	if (tg->rt_bandwidth.rt_runtime == RUNTIME_INF)
+		return -1;
+
+	rt_runtime_us = tg->rt_bandwidth.rt_runtime;
+	do_div(rt_runtime_us, NSEC_PER_USEC);
+	return rt_runtime_us;
+}
+
+int sched_group_set_rt_period(struct task_group *tg, long rt_period_us)
+{
+	u64 rt_runtime, rt_period;
+
+	rt_period = (u64)rt_period_us * NSEC_PER_USEC;
+	rt_runtime = tg->rt_bandwidth.rt_runtime;
+
+	return tg_set_bandwidth(tg, rt_period, rt_runtime);
+}
+
+long sched_group_rt_period(struct task_group *tg)
+{
+	u64 rt_period_us;
+
+	rt_period_us = ktime_to_ns(tg->rt_bandwidth.rt_period);
+	do_div(rt_period_us, NSEC_PER_USEC);
+	return rt_period_us;
 }
 
-unsigned long sched_group_rt_ratio(struct task_group *tg)
+static int sched_rt_global_constraints(void)
+{
+	int ret = 0;
+
+	mutex_lock(&rt_constraints_mutex);
+	if (!__rt_schedulable(NULL, 1, 0))
+		ret = -EINVAL;
+	mutex_unlock(&rt_constraints_mutex);
+
+	return ret;
+}
+#else
+static int sched_rt_global_constraints(void)
 {
-	return tg->rt_ratio;
+	unsigned long flags;
+	int i;
+
+	spin_lock_irqsave(&def_rt_bandwidth.rt_runtime_lock, flags);
+	for_each_possible_cpu(i) {
+		struct rt_rq *rt_rq = &cpu_rq(i)->rt;
+
+		spin_lock(&rt_rq->rt_runtime_lock);
+		rt_rq->rt_runtime = global_rt_runtime();
+		spin_unlock(&rt_rq->rt_runtime_lock);
+	}
+	spin_unlock_irqrestore(&def_rt_bandwidth.rt_runtime_lock, flags);
+
+	return 0;
 }
+#endif
+
+int sched_rt_handler(struct ctl_table *table, int write,
+		struct file *filp, void __user *buffer, size_t *lenp,
+		loff_t *ppos)
+{
+	int ret;
+	int old_period, old_runtime;
+	static DEFINE_MUTEX(mutex);
+
+	mutex_lock(&mutex);
+	old_period = sysctl_sched_rt_period;
+	old_runtime = sysctl_sched_rt_runtime;
+
+	ret = proc_dointvec(table, write, filp, buffer, lenp, ppos);
+
+	if (!ret && write) {
+		ret = sched_rt_global_constraints();
+		if (ret) {
+			sysctl_sched_rt_period = old_period;
+			sysctl_sched_rt_runtime = old_runtime;
+		} else {
+			def_rt_bandwidth.rt_runtime = global_rt_runtime();
+			def_rt_bandwidth.rt_period =
+				ns_to_ktime(global_rt_period());
+		}
+	}
+	mutex_unlock(&mutex);
 
-#endif	/* CONFIG_FAIR_GROUP_SCHED */
+	return ret;
+}
 
-#ifdef CONFIG_FAIR_CGROUP_SCHED
+#ifdef CONFIG_CGROUP_SCHED
 
 /* return corresponding task_group object of a cgroup */
 static inline struct task_group *cgroup_tg(struct cgroup *cgrp)
@@ -7857,9 +8217,15 @@ static int
 cpu_cgroup_can_attach(struct cgroup_subsys *ss, struct cgroup *cgrp,
 		      struct task_struct *tsk)
 {
+#ifdef CONFIG_RT_GROUP_SCHED
+	/* Don't accept realtime tasks when there is no way for them to run */
+	if (rt_task(tsk) && cgroup_tg(cgrp)->rt_bandwidth.rt_runtime == 0)
+		return -EINVAL;
+#else
 	/* We don't support RT-tasks being in separate groups */
 	if (tsk->sched_class != &fair_sched_class)
 		return -EINVAL;
+#endif
 
 	return 0;
 }
@@ -7871,6 +8237,7 @@ cpu_cgroup_attach(struct cgroup_subsys *ss, struct cgroup *cgrp,
 	sched_move_task(tsk);
 }
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
 static int cpu_shares_write_uint(struct cgroup *cgrp, struct cftype *cftype,
 				u64 shareval)
 {
@@ -7883,31 +8250,86 @@ static u64 cpu_shares_read_uint(struct cgroup *cgrp, struct cftype *cft)
 
 	return (u64) tg->shares;
 }
+#endif
 
-static int cpu_rt_ratio_write_uint(struct cgroup *cgrp, struct cftype *cftype,
-		u64 rt_ratio_val)
+#ifdef CONFIG_RT_GROUP_SCHED
+static ssize_t cpu_rt_runtime_write(struct cgroup *cgrp, struct cftype *cft,
+				struct file *file,
+				const char __user *userbuf,
+				size_t nbytes, loff_t *unused_ppos)
 {
-	return sched_group_set_rt_ratio(cgroup_tg(cgrp), rt_ratio_val);
+	char buffer[64];
+	int retval = 0;
+	s64 val;
+	char *end;
+
+	if (!nbytes)
+		return -EINVAL;
+	if (nbytes >= sizeof(buffer))
+		return -E2BIG;
+	if (copy_from_user(buffer, userbuf, nbytes))
+		return -EFAULT;
+
+	buffer[nbytes] = 0;     /* nul-terminate */
+
+	/* strip newline if necessary */
+	if (nbytes && (buffer[nbytes-1] == '\n'))
+		buffer[nbytes-1] = 0;
+	val = simple_strtoll(buffer, &end, 0);
+	if (*end)
+		return -EINVAL;
+
+	/* Pass to subsystem */
+	retval = sched_group_set_rt_runtime(cgroup_tg(cgrp), val);
+	if (!retval)
+		retval = nbytes;
+	return retval;
 }
 
-static u64 cpu_rt_ratio_read_uint(struct cgroup *cgrp, struct cftype *cft)
+static ssize_t cpu_rt_runtime_read(struct cgroup *cgrp, struct cftype *cft,
+				   struct file *file,
+				   char __user *buf, size_t nbytes,
+				   loff_t *ppos)
 {
-	struct task_group *tg = cgroup_tg(cgrp);
+	char tmp[64];
+	long val = sched_group_rt_runtime(cgroup_tg(cgrp));
+	int len = sprintf(tmp, "%ld\n", val);
 
-	return (u64) tg->rt_ratio;
+	return simple_read_from_buffer(buf, nbytes, ppos, tmp, len);
 }
 
+static int cpu_rt_period_write_uint(struct cgroup *cgrp, struct cftype *cftype,
+		u64 rt_period_us)
+{
+	return sched_group_set_rt_period(cgroup_tg(cgrp), rt_period_us);
+}
+
+static u64 cpu_rt_period_read_uint(struct cgroup *cgrp, struct cftype *cft)
+{
+	return sched_group_rt_period(cgroup_tg(cgrp));
+}
+#endif
+
 static struct cftype cpu_files[] = {
+#ifdef CONFIG_FAIR_GROUP_SCHED
 	{
 		.name = "shares",
 		.read_uint = cpu_shares_read_uint,
 		.write_uint = cpu_shares_write_uint,
 	},
+#endif
+#ifdef CONFIG_RT_GROUP_SCHED
+	{
+		.name = "rt_runtime_us",
+		.read = cpu_rt_runtime_read,
+		.write = cpu_rt_runtime_write,
+	},
 	{
-		.name = "rt_ratio",
-		.read_uint = cpu_rt_ratio_read_uint,
-		.write_uint = cpu_rt_ratio_write_uint,
+		.name = "rt_period_us",
+		.read_uint = cpu_rt_period_read_uint,
+		.write_uint = cpu_rt_period_write_uint,
 	},
+#endif
 };
 
 static int cpu_cgroup_populate(struct cgroup_subsys *ss, struct cgroup *cont)
@@ -7926,7 +8348,7 @@ struct cgroup_subsys cpu_cgroup_subsys = {
 	.early_init	= 1,
 };
 
-#endif	/* CONFIG_FAIR_CGROUP_SCHED */
+#endif	/* CONFIG_CGROUP_SCHED */
 
 #ifdef CONFIG_CGROUP_CPUACCT
 
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 4b5e24c..8b2c1fd 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -214,7 +214,6 @@ static int sched_debug_show(struct seq_file *m, void *v)
 	PN(sysctl_sched_latency);
 	PN(sysctl_sched_min_granularity);
 	PN(sysctl_sched_wakeup_granularity);
-	PN(sysctl_sched_batch_wakeup_granularity);
 	PN(sysctl_sched_child_runs_first);
 	P(sysctl_sched_features);
 #undef PN
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 6c091d6..2b0eb52 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -62,16 +62,6 @@ const_debug unsigned int sysctl_sched_child_runs_first = 1;
 unsigned int __read_mostly sysctl_sched_compat_yield;
 
 /*
- * SCHED_BATCH wake-up granularity.
- * (default: 10 msec * (1 + ilog(ncpus)), units: nanoseconds)
- *
- * This option delays the preemption effects of decoupled workloads
- * and reduces their over-scheduling. Synchronous workloads will still
- * have immediate wakeup/sleep latencies.
- */
-unsigned int sysctl_sched_batch_wakeup_granularity = 10000000UL;
-
-/*
  * SCHED_OTHER wake-up granularity.
  * (default: 10 msec * (1 + ilog(ncpus)), units: nanoseconds)
  *
@@ -87,6 +77,11 @@ const_debug unsigned int sysctl_sched_migration_cost = 500000UL;
  * CFS operations on generic schedulable entities:
  */
 
+static inline struct task_struct *task_of(struct sched_entity *se)
+{
+	return container_of(se, struct task_struct, se);
+}
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
 
 /* cpu runqueue to which this cfs_rq is attached */
@@ -98,6 +93,56 @@ static inline struct rq *rq_of(struct cfs_rq *cfs_rq)
 /* An entity is a task if it doesn't "own" a runqueue */
 #define entity_is_task(se)	(!se->my_q)
 
+/* Walk up scheduling entities hierarchy */
+#define for_each_sched_entity(se) \
+		for (; se; se = se->parent)
+
+static inline struct cfs_rq *task_cfs_rq(struct task_struct *p)
+{
+	return p->se.cfs_rq;
+}
+
+/* runqueue on which this entity is (to be) queued */
+static inline struct cfs_rq *cfs_rq_of(struct sched_entity *se)
+{
+	return se->cfs_rq;
+}
+
+/* runqueue "owned" by this group */
+static inline struct cfs_rq *group_cfs_rq(struct sched_entity *grp)
+{
+	return grp->my_q;
+}
+
+/* Given a group's cfs_rq on one cpu, return its corresponding cfs_rq on
+ * another cpu ('this_cpu')
+ */
+static inline struct cfs_rq *cpu_cfs_rq(struct cfs_rq *cfs_rq, int this_cpu)
+{
+	return cfs_rq->tg->cfs_rq[this_cpu];
+}
+
+/* Iterate thr' all leaf cfs_rq's on a runqueue */
+#define for_each_leaf_cfs_rq(rq, cfs_rq) \
+	list_for_each_entry_rcu(cfs_rq, &rq->leaf_cfs_rq_list, leaf_cfs_rq_list)
+
+/* Do the two (enqueued) entities belong to the same group ? */
+static inline int
+is_same_group(struct sched_entity *se, struct sched_entity *pse)
+{
+	if (se->cfs_rq == pse->cfs_rq)
+		return 1;
+
+	return 0;
+}
+
+static inline struct sched_entity *parent_entity(struct sched_entity *se)
+{
+	return se->parent;
+}
+
+#define GROUP_IMBALANCE_PCT	20
+
 #else	/* CONFIG_FAIR_GROUP_SCHED */
 
 static inline struct rq *rq_of(struct cfs_rq *cfs_rq)
@@ -107,13 +152,49 @@ static inline struct rq *rq_of(struct cfs_rq *cfs_rq)
 
 #define entity_is_task(se)	1
 
-#endif	/* CONFIG_FAIR_GROUP_SCHED */
+#define for_each_sched_entity(se) \
+		for (; se; se = NULL)
 
-static inline struct task_struct *task_of(struct sched_entity *se)
+static inline struct cfs_rq *task_cfs_rq(struct task_struct *p)
 {
-	return container_of(se, struct task_struct, se);
+	return &task_rq(p)->cfs;
 }
 
+static inline struct cfs_rq *cfs_rq_of(struct sched_entity *se)
+{
+	struct task_struct *p = task_of(se);
+	struct rq *rq = task_rq(p);
+
+	return &rq->cfs;
+}
+
+/* runqueue "owned" by this group */
+static inline struct cfs_rq *group_cfs_rq(struct sched_entity *grp)
+{
+	return NULL;
+}
+
+static inline struct cfs_rq *cpu_cfs_rq(struct cfs_rq *cfs_rq, int this_cpu)
+{
+	return &cpu_rq(this_cpu)->cfs;
+}
+
+#define for_each_leaf_cfs_rq(rq, cfs_rq) \
+		for (cfs_rq = &rq->cfs; cfs_rq; cfs_rq = NULL)
+
+static inline int
+is_same_group(struct sched_entity *se, struct sched_entity *pse)
+{
+	return 1;
+}
+
+static inline struct sched_entity *parent_entity(struct sched_entity *se)
+{
+	return NULL;
+}
+
+#endif	/* CONFIG_FAIR_GROUP_SCHED */
+
 
 /**************************************************************
  * Scheduling class tree data structure manipulation methods:
@@ -147,12 +228,22 @@ static inline s64 entity_key(struct cfs_rq *cfs_rq, struct sched_entity *se)
  */
 static void __enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	struct rb_node **link = &cfs_rq->tasks_timeline.rb_node;
+	struct rb_node **link;
 	struct rb_node *parent = NULL;
 	struct sched_entity *entry;
-	s64 key = entity_key(cfs_rq, se);
+	s64 key;
 	int leftmost = 1;
 
+	if (!entity_is_task(se))
+		return;
+
+	if (se == cfs_rq->curr)
+		return;
+
+	cfs_rq = &rq_of(cfs_rq)->cfs;
+
+	link = &cfs_rq->tasks_timeline.rb_node;
+	key = entity_key(cfs_rq, se);
 	/*
 	 * Find the right place in the rbtree:
 	 */
@@ -184,6 +275,14 @@ static void __enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 
 static void __dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
+	if (!entity_is_task(se))
+		return;
+
+	if (se == cfs_rq->curr)
+		return;
+
+	cfs_rq = &rq_of(cfs_rq)->cfs;
+
 	if (cfs_rq->rb_leftmost == &se->run_node)
 		cfs_rq->rb_leftmost = rb_next(&se->run_node);
 
@@ -267,36 +366,59 @@ static u64 sched_slice(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
 	u64 slice = __sched_period(cfs_rq->nr_running);
 
-	slice *= se->load.weight;
-	do_div(slice, cfs_rq->load.weight);
+	/*
+	 * curious 'hack' to make it boot - when the tick is started we hit
+	 * this with the init_task, which is not actually enqueued.
+	 */
+	if (unlikely(rq_of(cfs_rq)->load.weight <= se->load.weight))
+		goto out;
+
+	for_each_sched_entity(se) {
+		cfs_rq = cfs_rq_of(se);
+
+		slice *= se->load.weight;
+		do_div(slice, cfs_rq->load.weight);
+	}
 
+out:
 	return slice;
 }
 
 /*
- * We calculate the vruntime slice.
+ * We calculate the vruntime slice of a to be inserted task
  *
- * vs = s/w = p/rw
+ * vs = s*rw/w = p
  */
-static u64 __sched_vslice(unsigned long rq_weight, unsigned long nr_running)
+static u64 sched_vslice_add(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	u64 vslice = __sched_period(nr_running);
+	unsigned long nr_running = cfs_rq->nr_running;
 
-	vslice *= NICE_0_LOAD;
-	do_div(vslice, rq_weight);
+	if (!se->on_rq)
+		nr_running++;
 
-	return vslice;
+	return __sched_period(nr_running);
 }
 
-static u64 sched_vslice(struct cfs_rq *cfs_rq)
+static inline unsigned long
+calc_delta_fair(unsigned long delta, struct sched_entity *se)
 {
-	return __sched_vslice(cfs_rq->load.weight, cfs_rq->nr_running);
+	for_each_sched_entity(se) {
+		delta = calc_delta_mine(delta,
+				cfs_rq_of(se)->load.weight, &se->load);
+	}
+
+	return delta;
 }
 
-static u64 sched_vslice_add(struct cfs_rq *cfs_rq, struct sched_entity *se)
+static inline unsigned long
+calc_delta_asym(unsigned long delta, struct sched_entity *se)
 {
-	return __sched_vslice(cfs_rq->load.weight + se->load.weight,
-			cfs_rq->nr_running + 1);
+	unsigned long fair = calc_delta_fair(delta, se);
+
+	if (fair > delta)
+		fair = delta;
+
+	return fair;
 }
 
 /*
@@ -314,13 +436,14 @@ __update_curr(struct cfs_rq *cfs_rq, struct sched_entity *curr,
 
 	curr->sum_exec_runtime += delta_exec;
 	schedstat_add(cfs_rq, exec_clock, delta_exec);
-	delta_exec_weighted = delta_exec;
-	if (unlikely(curr->load.weight != NICE_0_LOAD)) {
-		delta_exec_weighted = calc_delta_fair(delta_exec_weighted,
-							&curr->load);
-	}
+	delta_exec_weighted = calc_delta_fair(delta_exec, curr);
 	curr->vruntime += delta_exec_weighted;
 
+	if (!entity_is_task(curr))
+		return;
+
+	cfs_rq = &rq_of(cfs_rq)->cfs;
+
 	/*
 	 * maintain cfs_rq->min_vruntime to be a monotonic increasing
 	 * value tracking the leftmost vruntime in the tree.
@@ -424,6 +547,7 @@ account_entity_enqueue(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	update_load_add(&cfs_rq->load, se->load.weight);
 	cfs_rq->nr_running++;
 	se->on_rq = 1;
+	list_add(&se->group_node, &cfs_rq->tasks);
 }
 
 static void
@@ -432,6 +556,7 @@ account_entity_dequeue(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	update_load_sub(&cfs_rq->load, se->load.weight);
 	cfs_rq->nr_running--;
 	se->on_rq = 0;
+	list_del_init(&se->group_node);
 }
 
 static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
@@ -498,16 +623,12 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 {
 	u64 vruntime;
 
-	vruntime = cfs_rq->min_vruntime;
+	if (!entity_is_task(se))
+		return;
 
-	if (sched_feat(TREE_AVG)) {
-		struct sched_entity *last = __pick_last_entity(cfs_rq);
-		if (last) {
-			vruntime += last->vruntime;
-			vruntime >>= 1;
-		}
-	} else if (sched_feat(APPROX_AVG) && cfs_rq->nr_running)
-		vruntime += sched_vslice(cfs_rq)/2;
+	cfs_rq = &rq_of(cfs_rq)->cfs;
+
+	vruntime = cfs_rq->min_vruntime;
 
 	/*
 	 * The 'current' period is already promised to the current tasks,
@@ -521,7 +642,7 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 	if (!initial) {
 		/* sleeps upto a single latency don't count. */
 		if (sched_feat(NEW_FAIR_SLEEPERS))
-			vruntime -= sysctl_sched_latency;
+			vruntime -= calc_delta_asym(sysctl_sched_latency, se);
 
 		/* ensure we never gain time by being placed backwards. */
 		vruntime = max_vruntime(se->vruntime, vruntime);
@@ -545,8 +666,7 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int wakeup)
 
 	update_stats_enqueue(cfs_rq, se);
 	check_spread(cfs_rq, se);
-	if (se != cfs_rq->curr)
-		__enqueue_entity(cfs_rq, se);
+	__enqueue_entity(cfs_rq, se);
 	account_entity_enqueue(cfs_rq, se);
 }
 
@@ -572,8 +692,7 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int sleep)
 #endif
 	}
 
-	if (se != cfs_rq->curr)
-		__dequeue_entity(cfs_rq, se);
+	__dequeue_entity(cfs_rq, se);
 	account_entity_dequeue(cfs_rq, se);
 }
 
@@ -602,6 +721,8 @@ set_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 		 * runqueue.
 		 */
 		update_stats_wait_end(cfs_rq, se);
+		if (WARN_ON_ONCE(cfs_rq->curr))
+			cfs_rq->curr = NULL;
 		__dequeue_entity(cfs_rq, se);
 	}
 
@@ -621,18 +742,6 @@ set_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	se->prev_sum_exec_runtime = se->sum_exec_runtime;
 }
 
-static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq)
-{
-	struct sched_entity *se = NULL;
-
-	if (first_fair(cfs_rq)) {
-		se = __pick_next_entity(cfs_rq);
-		set_next_entity(cfs_rq, se);
-	}
-
-	return se;
-}
-
 static void put_prev_entity(struct cfs_rq *cfs_rq, struct sched_entity *prev)
 {
 	/*
@@ -643,12 +752,12 @@ static void put_prev_entity(struct cfs_rq *cfs_rq, struct sched_entity *prev)
 		update_curr(cfs_rq);
 
 	check_spread(cfs_rq, prev);
+	cfs_rq->curr = NULL;
 	if (prev->on_rq) {
 		update_stats_wait_start(cfs_rq, prev);
 		/* Put 'current' back into the tree. */
 		__enqueue_entity(cfs_rq, prev);
 	}
-	cfs_rq->curr = NULL;
 }
 
 static void
@@ -659,6 +768,9 @@ entity_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr, int queued)
 	 */
 	update_curr(cfs_rq);
 
+	if (!entity_is_task(curr))
+		return;
+
 #ifdef CONFIG_SCHED_HRTICK
 	/*
 	 * queued ticks are scheduled to match the slice, so don't bother
@@ -674,7 +786,8 @@ entity_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr, int queued)
 		return;
 #endif
 
-	if (cfs_rq->nr_running > 1 || !sched_feat(WAKEUP_PREEMPT))
+	if (rq_of(cfs_rq)->load.weight != curr->load.weight ||
+			!sched_feat(WAKEUP_PREEMPT))
 		check_preempt_tick(cfs_rq, curr);
 }
 
@@ -682,103 +795,6 @@ entity_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr, int queued)
  * CFS operations on tasks:
  */
 
-#ifdef CONFIG_FAIR_GROUP_SCHED
-
-/* Walk up scheduling entities hierarchy */
-#define for_each_sched_entity(se) \
-		for (; se; se = se->parent)
-
-static inline struct cfs_rq *task_cfs_rq(struct task_struct *p)
-{
-	return p->se.cfs_rq;
-}
-
-/* runqueue on which this entity is (to be) queued */
-static inline struct cfs_rq *cfs_rq_of(struct sched_entity *se)
-{
-	return se->cfs_rq;
-}
-
-/* runqueue "owned" by this group */
-static inline struct cfs_rq *group_cfs_rq(struct sched_entity *grp)
-{
-	return grp->my_q;
-}
-
-/* Given a group's cfs_rq on one cpu, return its corresponding cfs_rq on
- * another cpu ('this_cpu')
- */
-static inline struct cfs_rq *cpu_cfs_rq(struct cfs_rq *cfs_rq, int this_cpu)
-{
-	return cfs_rq->tg->cfs_rq[this_cpu];
-}
-
-/* Iterate thr' all leaf cfs_rq's on a runqueue */
-#define for_each_leaf_cfs_rq(rq, cfs_rq) \
-	list_for_each_entry_rcu(cfs_rq, &rq->leaf_cfs_rq_list, leaf_cfs_rq_list)
-
-/* Do the two (enqueued) entities belong to the same group ? */
-static inline int
-is_same_group(struct sched_entity *se, struct sched_entity *pse)
-{
-	if (se->cfs_rq == pse->cfs_rq)
-		return 1;
-
-	return 0;
-}
-
-static inline struct sched_entity *parent_entity(struct sched_entity *se)
-{
-	return se->parent;
-}
-
-#define GROUP_IMBALANCE_PCT	20
-
-#else	/* CONFIG_FAIR_GROUP_SCHED */
-
-#define for_each_sched_entity(se) \
-		for (; se; se = NULL)
-
-static inline struct cfs_rq *task_cfs_rq(struct task_struct *p)
-{
-	return &task_rq(p)->cfs;
-}
-
-static inline struct cfs_rq *cfs_rq_of(struct sched_entity *se)
-{
-	struct task_struct *p = task_of(se);
-	struct rq *rq = task_rq(p);
-
-	return &rq->cfs;
-}
-
-/* runqueue "owned" by this group */
-static inline struct cfs_rq *group_cfs_rq(struct sched_entity *grp)
-{
-	return NULL;
-}
-
-static inline struct cfs_rq *cpu_cfs_rq(struct cfs_rq *cfs_rq, int this_cpu)
-{
-	return &cpu_rq(this_cpu)->cfs;
-}
-
-#define for_each_leaf_cfs_rq(rq, cfs_rq) \
-		for (cfs_rq = &rq->cfs; cfs_rq; cfs_rq = NULL)
-
-static inline int
-is_same_group(struct sched_entity *se, struct sched_entity *pse)
-{
-	return 1;
-}
-
-static inline struct sched_entity *parent_entity(struct sched_entity *se)
-{
-	return NULL;
-}
-
-#endif	/* CONFIG_FAIR_GROUP_SCHED */
-
 #ifdef CONFIG_SCHED_HRTICK
 static void hrtick_start_fair(struct rq *rq, struct task_struct *p)
 {
@@ -896,7 +912,7 @@ static void yield_task_fair(struct rq *rq)
 	/*
 	 * Are we the only task in the tree?
 	 */
-	if (unlikely(cfs_rq->nr_running == 1))
+	if (unlikely(rq->load.weight == curr->se.load.weight))
 		return;
 
 	if (likely(!sysctl_sched_compat_yield) && curr->policy != SCHED_BATCH) {
@@ -911,7 +927,7 @@ static void yield_task_fair(struct rq *rq)
 	/*
 	 * Find the rightmost entry in the rbtree:
 	 */
-	rightmost = __pick_last_entity(cfs_rq);
+	rightmost = __pick_last_entity(&rq->cfs);
 	/*
 	 * Already in the rightmost position?
 	 */
@@ -1073,7 +1089,6 @@ out_set_cpu:
 }
 #endif /* CONFIG_SMP */
 
-
 /*
  * Preempt the current task with a newly woken task if needed:
  */
@@ -1100,19 +1115,11 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p)
 	if (!sched_feat(WAKEUP_PREEMPT))
 		return;
 
-	while (!is_same_group(se, pse)) {
-		se = parent_entity(se);
-		pse = parent_entity(pse);
-	}
-
-	gran = sysctl_sched_wakeup_granularity;
 	/*
-	 * More easily preempt - nice tasks, while not making
-	 * it harder for + nice tasks.
+	 * More easily preempt - nice tasks, while not making it harder for
+	 * + nice tasks.
 	 */
-	if (unlikely(se->load.weight > NICE_0_LOAD))
-		gran = calc_delta_fair(gran, &se->load);
-
+	gran = calc_delta_asym(sysctl_sched_wakeup_granularity, se);
 	if (pse->vruntime + gran < se->vruntime)
 		resched_task(curr);
 }
@@ -1121,17 +1128,18 @@ static struct task_struct *pick_next_task_fair(struct rq *rq)
 {
 	struct task_struct *p;
 	struct cfs_rq *cfs_rq = &rq->cfs;
-	struct sched_entity *se;
+	struct sched_entity *se, *next;
 
-	if (unlikely(!cfs_rq->nr_running))
+	if (!first_fair(cfs_rq))
 		return NULL;
 
-	do {
-		se = pick_next_entity(cfs_rq);
-		cfs_rq = group_cfs_rq(se);
-	} while (cfs_rq);
+	next = se = __pick_next_entity(cfs_rq);
+	for_each_sched_entity(se) {
+		cfs_rq = cfs_rq_of(se);
+		set_next_entity(cfs_rq, se);
+	}
 
-	p = task_of(se);
+	p = task_of(next);
 	hrtick_start_fair(rq, p);
 
 	return p;
@@ -1163,16 +1171,17 @@ static void put_prev_task_fair(struct rq *rq, struct task_struct *prev)
  * achieve that by always pre-iterating before returning
  * the current task:
  */
+
 static struct task_struct *
-__load_balance_iterator(struct cfs_rq *cfs_rq, struct rb_node *curr)
+__load_balance_iterator(struct cfs_rq *cfs_rq, struct list_head *next)
 {
 	struct task_struct *p;
 
-	if (!curr)
+	if (next == &cfs_rq->tasks)
 		return NULL;
 
-	p = rb_entry(curr, struct task_struct, se.run_node);
-	cfs_rq->rb_load_balance_curr = rb_next(curr);
+	p = list_entry(next, struct task_struct, se.group_node);
+	cfs_rq->balance_iterator = next->next;
 
 	return p;
 }
@@ -1181,14 +1190,14 @@ static struct task_struct *load_balance_start_fair(void *arg)
 {
 	struct cfs_rq *cfs_rq = arg;
 
-	return __load_balance_iterator(cfs_rq, first_fair(cfs_rq));
+	return __load_balance_iterator(cfs_rq, cfs_rq->tasks.next);
 }
 
 static struct task_struct *load_balance_next_fair(void *arg)
 {
 	struct cfs_rq *cfs_rq = arg;
 
-	return __load_balance_iterator(cfs_rq, cfs_rq->rb_load_balance_curr);
+	return __load_balance_iterator(cfs_rq, cfs_rq->balance_iterator);
 }
 
 static unsigned long
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 274b40d..4868310 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -55,14 +55,19 @@ static inline int on_rt_rq(struct sched_rt_entity *rt_se)
 	return !list_empty(&rt_se->run_list);
 }
 
-#ifdef CONFIG_FAIR_GROUP_SCHED
+#ifdef CONFIG_RT_GROUP_SCHED
 
-static inline unsigned int sched_rt_ratio(struct rt_rq *rt_rq)
+static inline u64 sched_rt_runtime(struct rt_rq *rt_rq)
 {
 	if (!rt_rq->tg)
-		return SCHED_RT_FRAC;
+		return RUNTIME_INF;
 
-	return rt_rq->tg->rt_ratio;
+	return rt_rq->rt_runtime;
+}
+
+static inline u64 sched_rt_period(struct rt_rq *rt_rq)
+{
+	return ktime_to_ns(rt_rq->tg->rt_bandwidth.rt_period);
 }
 
 #define for_each_leaf_rt_rq(rt_rq, rq) \
@@ -89,7 +94,7 @@ static inline struct rt_rq *group_rt_rq(struct sched_rt_entity *rt_se)
 static void enqueue_rt_entity(struct sched_rt_entity *rt_se);
 static void dequeue_rt_entity(struct sched_rt_entity *rt_se);
 
-static void sched_rt_ratio_enqueue(struct rt_rq *rt_rq)
+static void sched_rt_rq_enqueue(struct rt_rq *rt_rq)
 {
 	struct sched_rt_entity *rt_se = rt_rq->rt_se;
 
@@ -102,7 +107,7 @@ static void sched_rt_ratio_enqueue(struct rt_rq *rt_rq)
 	}
 }
 
-static void sched_rt_ratio_dequeue(struct rt_rq *rt_rq)
+static void sched_rt_rq_dequeue(struct rt_rq *rt_rq)
 {
 	struct sched_rt_entity *rt_se = rt_rq->rt_se;
 
@@ -110,11 +115,56 @@ static void sched_rt_ratio_dequeue(struct rt_rq *rt_rq)
 		dequeue_rt_entity(rt_se);
 }
 
+static inline int rt_rq_throttled(struct rt_rq *rt_rq)
+{
+	return rt_rq->rt_throttled && !rt_rq->rt_nr_boosted;
+}
+
+static int rt_se_boosted(struct sched_rt_entity *rt_se)
+{
+	struct rt_rq *rt_rq = group_rt_rq(rt_se);
+	struct task_struct *p;
+
+	if (rt_rq)
+		return !!rt_rq->rt_nr_boosted;
+
+	p = rt_task_of(rt_se);
+	return p->prio != p->normal_prio;
+}
+
+#ifdef CONFIG_SMP
+static inline cpumask_t sched_rt_period_mask(void)
+{
+	return cpu_rq(smp_processor_id())->rd->span;
+}
 #else
+static inline cpumask_t sched_rt_period_mask(void)
+{
+	return cpu_online_map;
+}
+#endif
 
-static inline unsigned int sched_rt_ratio(struct rt_rq *rt_rq)
+static inline
+struct rt_rq *sched_rt_period_rt_rq(struct rt_bandwidth *rt_b, int cpu)
+{
+	return container_of(rt_b, struct task_group, rt_bandwidth)->rt_rq[cpu];
+}
+
+static inline struct rt_bandwidth *sched_rt_bandwidth(struct rt_rq *rt_rq)
 {
-	return sysctl_sched_rt_ratio;
+	return &rt_rq->tg->rt_bandwidth;
+}
+
+#else
+
+static inline u64 sched_rt_runtime(struct rt_rq *rt_rq)
+{
+	return rt_rq->rt_runtime;
+}
+
+static inline u64 sched_rt_period(struct rt_rq *rt_rq)
+{
+	return ktime_to_ns(def_rt_bandwidth.rt_period);
 }
 
 #define for_each_leaf_rt_rq(rt_rq, rq) \
@@ -141,19 +191,119 @@ static inline struct rt_rq *group_rt_rq(struct sched_rt_entity *rt_se)
 	return NULL;
 }
 
-static inline void sched_rt_ratio_enqueue(struct rt_rq *rt_rq)
+static inline void sched_rt_rq_enqueue(struct rt_rq *rt_rq)
+{
+}
+
+static inline void sched_rt_rq_dequeue(struct rt_rq *rt_rq)
+{
+}
+
+static inline int rt_rq_throttled(struct rt_rq *rt_rq)
+{
+	return rt_rq->rt_throttled;
+}
+
+static inline cpumask_t sched_rt_period_mask(void)
 {
+	return cpu_online_map;
 }
 
-static inline void sched_rt_ratio_dequeue(struct rt_rq *rt_rq)
+static inline
+struct rt_rq *sched_rt_period_rt_rq(struct rt_bandwidth *rt_b, int cpu)
 {
+	return &cpu_rq(cpu)->rt;
+}
+
+static inline struct rt_bandwidth *sched_rt_bandwidth(struct rt_rq *rt_rq)
+{
+	return &def_rt_bandwidth;
+}
+
+#endif
+
+static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun)
+{
+	int i, idle = 1;
+	cpumask_t span;
+
+	if (rt_b->rt_runtime == RUNTIME_INF)
+		return 1;
+
+	span = sched_rt_period_mask();
+	for_each_cpu_mask(i, span) {
+		int enqueue = 0;
+		struct rt_rq *rt_rq = sched_rt_period_rt_rq(rt_b, i);
+		struct rq *rq = rq_of_rt_rq(rt_rq);
+
+		spin_lock(&rq->lock);
+		if (rt_rq->rt_time) {
+			u64 runtime;
+
+			spin_lock(&rt_rq->rt_runtime_lock);
+			runtime = rt_rq->rt_runtime;
+			rt_rq->rt_time -= min(rt_rq->rt_time, overrun*runtime);
+			if (rt_rq->rt_throttled && rt_rq->rt_time < runtime) {
+				rt_rq->rt_throttled = 0;
+				enqueue = 1;
+			}
+			if (rt_rq->rt_time || rt_rq->rt_nr_running)
+				idle = 0;
+			spin_unlock(&rt_rq->rt_runtime_lock);
+		}
+
+		if (enqueue)
+			sched_rt_rq_enqueue(rt_rq);
+		spin_unlock(&rq->lock);
+	}
+
+	return idle;
 }
 
+#ifdef CONFIG_SMP
+static int balance_runtime(struct rt_rq *rt_rq)
+{
+	struct rt_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
+	struct root_domain *rd = cpu_rq(smp_processor_id())->rd;
+	int i, weight, more = 0;
+	u64 rt_period;
+
+	weight = cpus_weight(rd->span);
+
+	spin_lock(&rt_b->rt_runtime_lock);
+	rt_period = ktime_to_ns(rt_b->rt_period);
+	for_each_cpu_mask(i, rd->span) {
+		struct rt_rq *iter = sched_rt_period_rt_rq(rt_b, i);
+		s64 diff;
+
+		if (iter == rt_rq)
+			continue;
+
+		spin_lock(&iter->rt_runtime_lock);
+		diff = iter->rt_runtime - iter->rt_time;
+		if (diff > 0) {
+			do_div(diff, weight);
+			if (rt_rq->rt_runtime + diff > rt_period)
+				diff = rt_period - rt_rq->rt_runtime;
+			iter->rt_runtime -= diff;
+			rt_rq->rt_runtime += diff;
+			more = 1;
+			if (rt_rq->rt_runtime == rt_period) {
+				spin_unlock(&iter->rt_runtime_lock);
+				break;
+			}
+		}
+		spin_unlock(&iter->rt_runtime_lock);
+	}
+	spin_unlock(&rt_b->rt_runtime_lock);
+
+	return more;
+}
 #endif
 
 static inline int rt_se_prio(struct sched_rt_entity *rt_se)
 {
-#ifdef CONFIG_FAIR_GROUP_SCHED
+#ifdef CONFIG_RT_GROUP_SCHED
 	struct rt_rq *rt_rq = group_rt_rq(rt_se);
 
 	if (rt_rq)
@@ -163,55 +313,41 @@ static inline int rt_se_prio(struct sched_rt_entity *rt_se)
 	return rt_task_of(rt_se)->prio;
 }
 
-static int sched_rt_ratio_exceeded(struct rt_rq *rt_rq)
+static int sched_rt_runtime_exceeded(struct rt_rq *rt_rq)
 {
-	unsigned int rt_ratio = sched_rt_ratio(rt_rq);
-	u64 period, ratio;
+	u64 runtime = sched_rt_runtime(rt_rq);
 
-	if (rt_ratio == SCHED_RT_FRAC)
+	if (runtime == RUNTIME_INF)
 		return 0;
 
 	if (rt_rq->rt_throttled)
-		return 1;
+		return rt_rq_throttled(rt_rq);
 
-	period = (u64)sysctl_sched_rt_period * NSEC_PER_MSEC;
-	ratio = (period * rt_ratio) >> SCHED_RT_FRAC_SHIFT;
+	if (sched_rt_runtime(rt_rq) >= sched_rt_period(rt_rq))
+		return 0;
 
-	if (rt_rq->rt_time > ratio) {
-		struct rq *rq = rq_of_rt_rq(rt_rq);
+#ifdef CONFIG_SMP
+	if (rt_rq->rt_time > runtime) {
+		int more;
 
-		rq->rt_throttled = 1;
-		rt_rq->rt_throttled = 1;
+		spin_unlock(&rt_rq->rt_runtime_lock);
+		more = balance_runtime(rt_rq);
+		spin_lock(&rt_rq->rt_runtime_lock);
 
-		sched_rt_ratio_dequeue(rt_rq);
-		return 1;
+		if (more)
+			runtime = sched_rt_runtime(rt_rq);
 	}
+#endif
 
-	return 0;
-}
-
-static void update_sched_rt_period(struct rq *rq)
-{
-	struct rt_rq *rt_rq;
-	u64 period;
-
-	while (rq->clock > rq->rt_period_expire) {
-		period = (u64)sysctl_sched_rt_period * NSEC_PER_MSEC;
-		rq->rt_period_expire += period;
-
-		for_each_leaf_rt_rq(rt_rq, rq) {
-			unsigned long rt_ratio = sched_rt_ratio(rt_rq);
-			u64 ratio = (period * rt_ratio) >> SCHED_RT_FRAC_SHIFT;
-
-			rt_rq->rt_time -= min(rt_rq->rt_time, ratio);
-			if (rt_rq->rt_throttled) {
-				rt_rq->rt_throttled = 0;
-				sched_rt_ratio_enqueue(rt_rq);
-			}
+	if (rt_rq->rt_time > runtime) {
+		rt_rq->rt_throttled = 1;
+		if (rt_rq_throttled(rt_rq)) {
+			sched_rt_rq_dequeue(rt_rq);
+			return 1;
 		}
-
-		rq->rt_throttled = 0;
 	}
+
+	return 0;
 }
 
 /*
@@ -238,14 +374,11 @@ static void update_curr_rt(struct rq *rq)
 	curr->se.exec_start = rq->clock;
 	cpuacct_charge(curr, delta_exec);
 
+	spin_lock(&rt_rq->rt_runtime_lock);
 	rt_rq->rt_time += delta_exec;
-	/*
-	 * might make it a tad more accurate:
-	 *
-	 * update_sched_rt_period(rq);
-	 */
-	if (sched_rt_ratio_exceeded(rt_rq))
+	if (sched_rt_runtime_exceeded(rt_rq))
 		resched_task(curr);
+	spin_unlock(&rt_rq->rt_runtime_lock);
 }
 
 static inline
@@ -253,7 +386,7 @@ void inc_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 {
 	WARN_ON(!rt_prio(rt_se_prio(rt_se)));
 	rt_rq->rt_nr_running++;
-#if defined CONFIG_SMP || defined CONFIG_FAIR_GROUP_SCHED
+#if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
 	if (rt_se_prio(rt_se) < rt_rq->highest_prio)
 		rt_rq->highest_prio = rt_se_prio(rt_se);
 #endif
@@ -265,6 +398,15 @@ void inc_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 
 	update_rt_migration(rq_of_rt_rq(rt_rq));
 #endif
+#ifdef CONFIG_RT_GROUP_SCHED
+	if (rt_se_boosted(rt_se))
+		rt_rq->rt_nr_boosted++;
+
+	if (rt_rq->tg)
+		start_rt_bandwidth(&rt_rq->tg->rt_bandwidth);
+#else
+	start_rt_bandwidth(&def_rt_bandwidth);
+#endif
 }
 
 static inline
@@ -273,7 +415,7 @@ void dec_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 	WARN_ON(!rt_prio(rt_se_prio(rt_se)));
 	WARN_ON(!rt_rq->rt_nr_running);
 	rt_rq->rt_nr_running--;
-#if defined CONFIG_SMP || defined CONFIG_FAIR_GROUP_SCHED
+#if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
 	if (rt_rq->rt_nr_running) {
 		struct rt_prio_array *array;
 
@@ -295,6 +437,12 @@ void dec_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 
 	update_rt_migration(rq_of_rt_rq(rt_rq));
 #endif /* CONFIG_SMP */
+#ifdef CONFIG_RT_GROUP_SCHED
+	if (rt_se_boosted(rt_se))
+		rt_rq->rt_nr_boosted--;
+
+	WARN_ON(!rt_rq->rt_nr_running && rt_rq->rt_nr_boosted);
+#endif
 }
 
 static void enqueue_rt_entity(struct sched_rt_entity *rt_se)
@@ -303,7 +451,7 @@ static void enqueue_rt_entity(struct sched_rt_entity *rt_se)
 	struct rt_prio_array *array = &rt_rq->active;
 	struct rt_rq *group_rq = group_rt_rq(rt_se);
 
-	if (group_rq && group_rq->rt_throttled)
+	if (group_rq && rt_rq_throttled(group_rq))
 		return;
 
 	list_add_tail(&rt_se->run_list, array->queue + rt_se_prio(rt_se));
@@ -496,7 +644,7 @@ static struct task_struct *pick_next_task_rt(struct rq *rq)
 	if (unlikely(!rt_rq->rt_nr_running))
 		return NULL;
 
-	if (sched_rt_ratio_exceeded(rt_rq))
+	if (rt_rq_throttled(rt_rq))
 		return NULL;
 
 	do {
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
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index d41ef6b..d1fa7af 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -270,17 +270,6 @@ static struct ctl_table kern_table[] = {
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
-		.procname	= "sched_batch_wakeup_granularity_ns",
-		.data		= &sysctl_sched_batch_wakeup_granularity,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
-		.extra1		= &min_wakeup_granularity_ns,
-		.extra2		= &max_wakeup_granularity_ns,
-	},
-	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "sched_child_runs_first",
 		.data		= &sysctl_sched_child_runs_first,
 		.maxlen		= sizeof(unsigned int),
@@ -311,22 +300,6 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
 	},
-	{
-		.ctl_name	= CTL_UNNUMBERED,
-		.procname	= "sched_rt_period_ms",
-		.data		= &sysctl_sched_rt_period,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
-	},
-	{
-		.ctl_name	= CTL_UNNUMBERED,
-		.procname	= "sched_rt_ratio",
-		.data		= &sysctl_sched_rt_ratio,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
-	},
 #if defined(CONFIG_FAIR_GROUP_SCHED) && defined(CONFIG_SMP)
 	{
 		.ctl_name       = CTL_UNNUMBERED,
@@ -348,6 +321,22 @@ static struct ctl_table kern_table[] = {
 #endif
 	{
 		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "sched_rt_period_us",
+		.data		= &sysctl_sched_rt_period,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &sched_rt_handler,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "sched_rt_runtime_us",
+		.data		= &sysctl_sched_rt_runtime,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &sched_rt_handler,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "sched_compat_yield",
 		.data		= &sysctl_sched_compat_yield,
 		.maxlen		= sizeof(unsigned int),
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index fa9bb73..769deb9 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -192,7 +192,6 @@ u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
 void tick_nohz_stop_sched_tick(void)
 {
 	unsigned long seq, last_jiffies, next_jiffies, delta_jiffies, flags;
-	unsigned long rt_jiffies;
 	struct tick_sched *ts;
 	ktime_t last_update, expires, now;
 	struct clock_event_device *dev = __get_cpu_var(tick_cpu_device).evtdev;
@@ -245,10 +244,6 @@ void tick_nohz_stop_sched_tick(void)
 	next_jiffies = get_next_timer_interrupt(last_jiffies);
 	delta_jiffies = next_jiffies - last_jiffies;
 
-	rt_jiffies = rt_needs_cpu(cpu);
-	if (rt_jiffies && rt_jiffies < delta_jiffies)
-		delta_jiffies = rt_jiffies;
-
 	if (rcu_needs_cpu(cpu))
 		delta_jiffies = 1;
 	/*
@@ -282,6 +277,7 @@ void tick_nohz_stop_sched_tick(void)
 			ts->idle_tick = ts->sched_timer.expires;
 			ts->tick_stopped = 1;
 			ts->idle_jiffies = last_jiffies;
+			rcu_enter_nohz();
 		}
 
 		/*
@@ -375,6 +371,8 @@ void tick_nohz_restart_sched_tick(void)
 		return;
 	}
 
+	rcu_exit_nohz();
+
 	/* Update jiffies first */
 	select_nohz_load_balancer(0);
 	now = ktime_get();
diff --git a/kernel/user.c b/kernel/user.c
index 7d7900c..5925c68 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -57,7 +57,7 @@ struct user_struct root_user = {
 	.uid_keyring	= &root_user_keyring,
 	.session_keyring = &root_session_keyring,
 #endif
-#ifdef CONFIG_FAIR_USER_SCHED
+#ifdef CONFIG_USER_SCHED
 	.tg		= &init_task_group,
 #endif
 };
@@ -90,7 +90,7 @@ static struct user_struct *uid_hash_find(uid_t uid, struct hlist_head *hashent)
 	return NULL;
 }
 
-#ifdef CONFIG_FAIR_USER_SCHED
+#ifdef CONFIG_USER_SCHED
 
 static void sched_destroy_user(struct user_struct *up)
 {
@@ -113,15 +113,15 @@ static void sched_switch_user(struct task_struct *p)
 	sched_move_task(p);
 }
 
-#else	/* CONFIG_FAIR_USER_SCHED */
+#else	/* CONFIG_USER_SCHED */
 
 static void sched_destroy_user(struct user_struct *up) { }
 static int sched_create_user(struct user_struct *up) { return 0; }
 static void sched_switch_user(struct task_struct *p) { }
 
-#endif	/* CONFIG_FAIR_USER_SCHED */
+#endif	/* CONFIG_USER_SCHED */
 
-#if defined(CONFIG_FAIR_USER_SCHED) && defined(CONFIG_SYSFS)
+#if defined(CONFIG_USER_SCHED) && defined(CONFIG_SYSFS)
 
 static struct kset *uids_kset; /* represents the /sys/kernel/uids/ directory */
 static DEFINE_MUTEX(uids_mutex);
@@ -137,6 +137,7 @@ static inline void uids_mutex_unlock(void)
 }
 
 /* uid directory attributes */
+#ifdef CONFIG_FAIR_GROUP_SCHED
 static ssize_t cpu_shares_show(struct kobject *kobj,
 			       struct kobj_attribute *attr,
 			       char *buf)
@@ -163,10 +164,73 @@ static ssize_t cpu_shares_store(struct kobject *kobj,
 
 static struct kobj_attribute cpu_share_attr =
 	__ATTR(cpu_share, 0644, cpu_shares_show, cpu_shares_store);
+#endif
+
+#ifdef CONFIG_RT_GROUP_SCHED
+static ssize_t cpu_rt_runtime_show(struct kobject *kobj,
+				   struct kobj_attribute *attr,
+				   char *buf)
+{
+	struct user_struct *up = container_of(kobj, struct user_struct, kobj);
+
+	return sprintf(buf, "%lu\n", sched_group_rt_runtime(up->tg));
+}
+
+static ssize_t cpu_rt_runtime_store(struct kobject *kobj,
+				    struct kobj_attribute *attr,
+				    const char *buf, size_t size)
+{
+	struct user_struct *up = container_of(kobj, struct user_struct, kobj);
+	unsigned long rt_runtime;
+	int rc;
+
+	sscanf(buf, "%lu", &rt_runtime);
+
+	rc = sched_group_set_rt_runtime(up->tg, rt_runtime);
+
+	return (rc ? rc : size);
+}
+
+static struct kobj_attribute cpu_rt_runtime_attr =
+	__ATTR(cpu_rt_runtime, 0644, cpu_rt_runtime_show, cpu_rt_runtime_store);
+
+static ssize_t cpu_rt_period_show(struct kobject *kobj,
+				   struct kobj_attribute *attr,
+				   char *buf)
+{
+	struct user_struct *up = container_of(kobj, struct user_struct, kobj);
+
+	return sprintf(buf, "%lu\n", sched_group_rt_period(up->tg));
+}
+
+static ssize_t cpu_rt_period_store(struct kobject *kobj,
+				    struct kobj_attribute *attr,
+				    const char *buf, size_t size)
+{
+	struct user_struct *up = container_of(kobj, struct user_struct, kobj);
+	unsigned long rt_period;
+	int rc;
+
+	sscanf(buf, "%lu", &rt_period);
+
+	rc = sched_group_set_rt_period(up->tg, rt_period);
+
+	return (rc ? rc : size);
+}
+
+static struct kobj_attribute cpu_rt_period_attr =
+	__ATTR(cpu_rt_period, 0644, cpu_rt_period_show, cpu_rt_period_store);
+#endif
 
 /* default attributes per uid directory */
 static struct attribute *uids_attributes[] = {
+#ifdef CONFIG_FAIR_GROUP_SCHED
 	&cpu_share_attr.attr,
+#endif
+#ifdef CONFIG_RT_GROUP_SCHED
+	&cpu_rt_runtime_attr.attr,
+	&cpu_rt_period_attr.attr,
+#endif
 	NULL
 };
 
@@ -269,7 +333,7 @@ static inline void free_user(struct user_struct *up, unsigned long flags)
 	schedule_work(&up->work);
 }
 
-#else	/* CONFIG_FAIR_USER_SCHED && CONFIG_SYSFS */
+#else	/* CONFIG_USER_SCHED && CONFIG_SYSFS */
 
 int uids_sysfs_init(void) { return 0; }
 static inline int uids_user_create(struct user_struct *up) { return 0; }
@@ -373,7 +437,7 @@ struct user_struct * alloc_uid(struct user_namespace *ns, uid_t uid)
 		spin_lock_irq(&uidhash_lock);
 		up = uid_hash_find(uid, hashent);
 		if (up) {
-			/* This case is not possible when CONFIG_FAIR_USER_SCHED
+			/* This case is not possible when CONFIG_USER_SCHED
 			 * is defined, since we serialize alloc_uid() using
 			 * uids_mutex. Hence no need to call
 			 * sched_destroy_user() or remove_user_sysfs_dir().
