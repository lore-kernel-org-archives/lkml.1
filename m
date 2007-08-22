Return-Path: <linux-kernel-owner+w=401wt.eu-S1764868AbXHVTDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764868AbXHVTDh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 15:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764431AbXHVTDB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 15:03:01 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:40932 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763673AbXHVTC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 15:02:57 -0400
Date: Wed, 22 Aug 2007 12:02:54 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-rt-users@vger.kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
       dipankar@in.ibm.com, josht@linux.vnet.ibm.com, tytso@us.ibm.com,
       dvhltc@us.ibm.com, tglx@linutronix.de
Subject: [PATCH RFC] Priority boosting for preemptible RCU
Message-ID: <20070822190254.GA1135@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This patch is a forward-port of RCU priority boosting (described in
http://lwn.net/Articles/220677/).  It applies to 2.6.22 on top of
the patches sent in the http://lkml.org/lkml/2007/8/7/276 series and
the hotplug patch (http://lkml.org/lkml/2007/8/17/262).  Passes several
hours of rcutorture on x86_64 and POWER, so OK for experimentation but
not ready for inclusion.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 include/linux/init_task.h  |   12 +
 include/linux/rcupdate.h   |   13 +
 include/linux/rcupreempt.h |   20 +
 include/linux/sched.h      |   16 +
 init/main.c                |    1 
 kernel/Kconfig.preempt     |   32 ++
 kernel/fork.c              |    6 
 kernel/rcupreempt.c        |  530 +++++++++++++++++++++++++++++++++++++++++++++
 kernel/rtmutex.c           |    7 
 kernel/sched.c             |    5 
 10 files changed, 639 insertions(+), 3 deletions(-)

diff -urpNa -X dontdiff linux-2.6.22-e-hotplugcpu/include/linux/init_task.h linux-2.6.22-f-boost/include/linux/init_task.h
--- linux-2.6.22-e-hotplugcpu/include/linux/init_task.h	2007-07-08 16:32:17.000000000 -0700
+++ linux-2.6.22-f-boost/include/linux/init_task.h	2007-08-20 17:38:18.000000000 -0700
@@ -87,6 +87,17 @@ extern struct nsproxy init_nsproxy;
 	.signalfd_list	= LIST_HEAD_INIT(sighand.signalfd_list),	\
 }
 
+#ifdef CONFIG_PREEMPT_RCU_BOOST
+#define INIT_RCU_BOOST_PRIO .rcu_prio	= MAX_PRIO,
+#define INIT_PREEMPT_RCU_BOOST(tsk)					\
+	.rcub_rbdp	= NULL,						\
+	.rcub_state	= RCU_BOOST_IDLE,				\
+	.rcub_entry	= LIST_HEAD_INIT(tsk.rcub_entry),
+#else /* #ifdef CONFIG_PREEMPT_RCU_BOOST */
+#define INIT_RCU_BOOST_PRIO
+#define INIT_PREEMPT_RCU_BOOST(tsk)
+#endif /* #else #ifdef CONFIG_PREEMPT_RCU_BOOST */
+
 extern struct group_info init_groups;
 
 #define INIT_STRUCT_PID {						\
@@ -169,6 +180,7 @@ extern struct group_info init_groups;
 	},								\
 	INIT_TRACE_IRQFLAGS						\
 	INIT_LOCKDEP							\
+	INIT_PREEMPT_RCU_BOOST(tsk)					\
 }
 
 
diff -urpNa -X dontdiff linux-2.6.22-e-hotplugcpu/include/linux/rcupdate.h linux-2.6.22-f-boost/include/linux/rcupdate.h
--- linux-2.6.22-e-hotplugcpu/include/linux/rcupdate.h	2007-08-07 13:24:28.000000000 -0700
+++ linux-2.6.22-f-boost/include/linux/rcupdate.h	2007-08-20 17:48:31.000000000 -0700
@@ -252,5 +252,18 @@ static inline void rcu_qsctr_inc(int cpu
 	per_cpu(rcu_data_passed_quiesc, cpu) = 1;
 }
 
+#ifdef CONFIG_PREEMPT_RCU_BOOST
+extern void init_rcu_boost_late(void);
+extern void __rcu_preempt_boost(void);
+#define rcu_preempt_boost() \
+	do { \
+		if (unlikely(current->rcu_read_lock_nesting > 0)) \
+			__rcu_preempt_boost(); \
+	} while (0)
+#else /* #ifdef CONFIG_PREEMPT_RCU_BOOST */
+#define init_rcu_boost_late()
+#define rcu_preempt_boost()
+#endif /* #else #ifdef CONFIG_PREEMPT_RCU_BOOST */
+
 #endif /* __KERNEL__ */
 #endif /* __LINUX_RCUPDATE_H */
diff -urpNa -X dontdiff linux-2.6.22-e-hotplugcpu/include/linux/rcupreempt.h linux-2.6.22-f-boost/include/linux/rcupreempt.h
--- linux-2.6.22-e-hotplugcpu/include/linux/rcupreempt.h	2007-08-07 18:15:10.000000000 -0700
+++ linux-2.6.22-f-boost/include/linux/rcupreempt.h	2007-08-20 17:41:14.000000000 -0700
@@ -42,6 +42,26 @@
 #include <linux/cpumask.h>
 #include <linux/seqlock.h>
 
+#ifdef CONFIG_PREEMPT_RCU_BOOST
+/*
+ * Task state with respect to being RCU-boosted.  This state is changed
+ * by the task itself in response to the following three events:
+ * 1. Preemption (or block on lock) while in RCU read-side critical section.
+ * 2. Outermost rcu_read_unlock() for blocked RCU read-side critical section.
+ *
+ * The RCU-boost task also updates the state when boosting priority.
+ */
+enum rcu_boost_state {
+	RCU_BOOST_IDLE = 0,	   /* Not yet blocked if in RCU read-side. */
+	RCU_BOOST_BLOCKED = 1,	   /* Blocked from RCU read-side. */
+	RCU_BOOSTED = 2,	   /* Boosting complete. */
+	RCU_BOOST_INVALID = 3,	   /* For bogus state sightings. */
+};
+
+#define N_RCU_BOOST_STATE (RCU_BOOST_INVALID + 1)
+
+#endif /* #ifdef CONFIG_PREEMPT_RCU_BOOST */
+
 #define call_rcu_bh(head, rcu) call_rcu(head, rcu)
 #define rcu_bh_qsctr_inc(cpu)
 #define __rcu_read_lock_bh()	{ rcu_read_lock(); local_bh_disable(); }
diff -urpNa -X dontdiff linux-2.6.22-e-hotplugcpu/include/linux/sched.h linux-2.6.22-f-boost/include/linux/sched.h
--- linux-2.6.22-e-hotplugcpu/include/linux/sched.h	2007-07-21 09:12:49.000000000 -0700
+++ linux-2.6.22-f-boost/include/linux/sched.h	2007-08-20 17:38:19.000000000 -0700
@@ -546,6 +546,14 @@ struct signal_struct {
 #define is_rt_policy(p)		((p) != SCHED_NORMAL && (p) != SCHED_BATCH)
 #define has_rt_policy(p)	unlikely(is_rt_policy((p)->policy))
 
+#ifdef CONFIG_PREEMPT_RCU_BOOST
+#define set_rcu_prio(p, prio)  ((p)->rcu_prio = (prio))
+#define get_rcu_prio(p) ((p)->rcu_prio)
+#else /* #ifdef CONFIG_PREEMPT_RCU_BOOST */
+#define set_rcu_prio(p, prio)  do { } while (0)
+#define get_rcu_prio(p) MAX_PRIO
+#endif /* #else #ifdef CONFIG_PREEMPT_RCU_BOOST */
+
 /*
  * Some day this will be a full-fledged user tracking system..
  */
@@ -834,6 +842,9 @@ struct task_struct {
 #endif
 	int load_weight;	/* for niceness load balancing purposes */
 	int prio, static_prio, normal_prio;
+#ifdef CONFIG_PREEMPT_RCU_BOOST
+	int rcu_prio;
+#endif /* #ifdef CONFIG_PREEMPT_RCU_BOOST */
 	struct list_head run_list;
 	struct prio_array *array;
 
@@ -858,6 +869,11 @@ struct task_struct {
 #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
 	struct sched_info sched_info;
 #endif
+#ifdef CONFIG_PREEMPT_RCU_BOOST
+	struct rcu_boost_dat *rcub_rbdp;
+	enum rcu_boost_state rcub_state;
+	struct list_head rcub_entry;
+#endif /* #ifdef CONFIG_PREEMPT_RCU_BOOST */
 
 	struct list_head tasks;
 	/*
diff -urpNa -X dontdiff linux-2.6.22-e-hotplugcpu/init/main.c linux-2.6.22-f-boost/init/main.c
--- linux-2.6.22-e-hotplugcpu/init/main.c	2007-07-08 16:32:17.000000000 -0700
+++ linux-2.6.22-f-boost/init/main.c	2007-08-20 17:49:27.000000000 -0700
@@ -722,6 +722,7 @@ static void __init do_basic_setup(void)
 	driver_init();
 	init_irq_proc();
 	do_initcalls();
+	init_rcu_boost_late();
 }
 
 static void __init do_pre_smp_initcalls(void)
diff -urpNa -X dontdiff linux-2.6.22-e-hotplugcpu/kernel/fork.c linux-2.6.22-f-boost/kernel/fork.c
--- linux-2.6.22-e-hotplugcpu/kernel/fork.c	2007-07-21 09:23:20.000000000 -0700
+++ linux-2.6.22-f-boost/kernel/fork.c	2007-08-20 17:52:47.000000000 -0700
@@ -1036,6 +1036,12 @@ static struct task_struct *copy_process(
 	p->rcu_read_lock_nesting = 0;
 	p->rcu_flipctr_idx = 0;
 #endif /* #ifdef CONFIG_PREEMPT_RCU */
+#ifdef CONFIG_PREEMPT_RCU_BOOST
+	p->rcu_prio = MAX_PRIO;
+	p->rcub_rbdp = NULL;
+	p->rcub_state = RCU_BOOST_IDLE;
+	INIT_LIST_HEAD(&p->rcub_entry);
+#endif /* #ifdef CONFIG_PREEMPT_RCU_BOOST */
 	p->vfork_done = NULL;
 	spin_lock_init(&p->alloc_lock);
 
diff -urpNa -X dontdiff linux-2.6.22-e-hotplugcpu/kernel/Kconfig.preempt linux-2.6.22-f-boost/kernel/Kconfig.preempt
--- linux-2.6.22-e-hotplugcpu/kernel/Kconfig.preempt	2007-07-21 10:11:00.000000000 -0700
+++ linux-2.6.22-f-boost/kernel/Kconfig.preempt	2007-08-20 17:38:19.000000000 -0700
@@ -101,3 +101,35 @@ config RCU_TRACE
 
 	  Say Y here if you want to enable RCU tracing
 	  Say N if you are unsure.
+
+config PREEMPT_RCU_BOOST
+	bool "Enable priority boosting of RCU read-side critical sections"
+	depends on PREEMPT_RCU
+	default n
+	help
+	  This option permits priority boosting of RCU read-side critical
+	  sections that have been preempted in order to prevent indefinite
+	  delay of grace periods in face of runaway non-realtime processes.
+
+	  Say N if you are unsure.
+
+config PREEMPT_RCU_BOOST_STATS
+	bool "Enable RCU priority-boosting statistic printing"
+	depends on PREEMPT_RCU_BOOST
+	default n
+	help
+	  This option enables debug printk()s of RCU boost statistics,
+	  which are normally only used to debug RCU priority boost
+	  implementations.
+
+	  Say N if you are unsure.
+
+config PREEMPT_RCU_BOOST_STATS_INTERVAL
+	int "RCU priority-boosting statistic printing interval (seconds)"
+	depends on PREEMPT_RCU_BOOST_STATS
+	default 100
+	range 10 86400
+	help
+	  This option controls the timing of debug printk()s of RCU boost
+	  statistics, which are normally only used to debug RCU priority
+	  boost implementations.
diff -urpNa -X dontdiff linux-2.6.22-e-hotplugcpu/kernel/rcupreempt.c linux-2.6.22-f-boost/kernel/rcupreempt.c
--- linux-2.6.22-e-hotplugcpu/kernel/rcupreempt.c	2007-08-11 04:02:10.000000000 -0700
+++ linux-2.6.22-f-boost/kernel/rcupreempt.c	2007-08-21 12:56:34.000000000 -0700
@@ -51,6 +51,7 @@
 #include <linux/byteorder/swabb.h>
 #include <linux/cpumask.h>
 #include <linux/rcupreempt_trace.h>
+#include <linux/kthread.h>
 
 /*
  * PREEMPT_RCU data structures.
@@ -82,6 +83,525 @@ static struct rcu_ctrlblk rcu_ctrlblk = 
 };
 static DEFINE_PER_CPU(int [2], rcu_flipctr) = { 0, 0 };
 
+#ifndef CONFIG_PREEMPT_RCU_BOOST
+static inline void init_rcu_boost_early(void) { }
+static inline void rcu_read_unlock_unboost(void) { }
+#else /* #ifndef CONFIG_PREEMPT_RCU_BOOST */
+
+/* Defines possible event indices for ->rbs_stats[] (first index). */
+
+#define RCU_BOOST_DAT_BLOCK	0
+#define RCU_BOOST_DAT_BOOST	1
+#define RCU_BOOST_DAT_UNLOCK	2
+#define N_RCU_BOOST_DAT_EVENTS	3
+
+/* RCU-boost per-CPU array element. */
+
+struct rcu_boost_dat {
+	spinlock_t rbs_mutex;
+	struct list_head rbs_toboost;
+	struct list_head rbs_boosted;
+	unsigned long rbs_blocked;
+	unsigned long rbs_boost_attempt;
+	unsigned long rbs_boost;
+	unsigned long rbs_unlock;
+	unsigned long rbs_unboosted;
+#ifdef CONFIG_PREEMPT_RCU_BOOST_STATS
+	unsigned long rbs_stats[N_RCU_BOOST_DAT_EVENTS][N_RCU_BOOST_STATE];
+#endif /* #ifdef CONFIG_PREEMPT_RCU_BOOST_STATS */
+};
+#define RCU_BOOST_ELEMENTS 4
+
+int rcu_boost_idx = -1; /* invalid value in case someone uses RCU early. */
+DEFINE_PER_CPU(struct rcu_boost_dat, rcu_boost_dat[RCU_BOOST_ELEMENTS]);
+static struct task_struct *rcu_boost_task = NULL;
+
+#ifdef CONFIG_PREEMPT_RCU_BOOST_STATS
+
+/*
+ * Function to increment indicated ->rbs_stats[] element.
+ */
+static inline void rcu_boost_dat_stat(struct rcu_boost_dat *rbdp,
+				      int event,
+				      enum rcu_boost_state oldstate)
+{
+	if (oldstate >= RCU_BOOST_IDLE &&
+	    oldstate <= RCU_BOOSTED) {
+		rbdp->rbs_stats[event][oldstate]++;
+	} else {
+		rbdp->rbs_stats[event][RCU_BOOST_INVALID]++;
+	}
+}
+
+#define rcu_boost_dat_stat_block(rbdp, oldstate) \
+	rcu_boost_dat_stat(rbdp, RCU_BOOST_DAT_BLOCK, oldstate)
+#define rcu_boost_dat_stat_boost(rbdp, oldstate) \
+	rcu_boost_dat_stat(rbdp, RCU_BOOST_DAT_BOOST, oldstate)
+#define rcu_boost_dat_stat_unlock(rbdp, oldstate) \
+	rcu_boost_dat_stat(rbdp, RCU_BOOST_DAT_UNLOCK, oldstate)
+
+/*
+ * Prefix for kprint() strings for periodic statistics messages.
+ */
+static char *rcu_boost_state_event[] = {
+	"block:  ",
+	"boost:  ",
+	"unlock: ",
+};
+
+/*
+ * Indicators for numbers in kprint() strings.  "!" indicates a state-event
+ * pair that should not happen, while "?" indicates a state that should
+ * not happen.
+ */
+static char *rcu_boost_state_error[] = {
+	/*ibBe*/
+	 "   ?",  /* block */
+	 "!  ?",  /* boost */
+	 "?  ?",  /* unlock */
+};
+
+/*
+ * Print out RCU booster task statistics at the specified interval.
+ */
+static void rcu_boost_dat_stat_print(void)
+{
+	/* Three decimal digits per byte plus spacing per number and line. */
+	char buf[N_RCU_BOOST_STATE * (sizeof(long) * 3 + 2) + 2];
+	int cpu;
+	int event;
+	int i;
+	static time_t lastprint = 0;
+	struct rcu_boost_dat *rbdp;
+	int state;
+	struct rcu_boost_dat sum;
+
+	/* Wait a graceful interval between printk spamming. */
+
+	if (xtime.tv_sec - lastprint <
+	    CONFIG_PREEMPT_RCU_BOOST_STATS_INTERVAL)
+		return;
+
+	/* Sum up the state/event-independent counters. */
+
+	sum.rbs_blocked = 0;
+	sum.rbs_boost_attempt = 0;
+	sum.rbs_boost = 0;
+	sum.rbs_unlock = 0;
+	sum.rbs_unboosted = 0;
+	for_each_possible_cpu(cpu)
+		for (i = 0; i < RCU_BOOST_ELEMENTS; i++) {
+			rbdp = per_cpu(rcu_boost_dat, cpu);
+			sum.rbs_blocked += rbdp[i].rbs_blocked;
+			sum.rbs_boost_attempt += rbdp[i].rbs_boost_attempt;
+			sum.rbs_boost += rbdp[i].rbs_boost;
+			sum.rbs_unlock += rbdp[i].rbs_unlock;
+			sum.rbs_unboosted += rbdp[i].rbs_unboosted;
+		}
+
+	/* Sum up the state/event-dependent counters. */
+
+	for (event = 0; event < N_RCU_BOOST_DAT_EVENTS; event++)
+		for (state = 0; state < N_RCU_BOOST_STATE; state++) {
+			sum.rbs_stats[event][state] = 0;
+			for_each_possible_cpu(cpu) {
+				for (i = 0; i < RCU_BOOST_ELEMENTS; i++) {
+					sum.rbs_stats[event][state]
+					    += per_cpu(rcu_boost_dat,
+						       cpu)[i].rbs_stats[event][state];
+				}
+			}
+		}
+
+	/* Print them out! */
+
+	printk(KERN_ALERT
+	       "rcu_boost_dat: idx=%d "
+	       "b=%lu ul=%lu ub=%lu boost: a=%lu b=%lu\n",
+	       rcu_boost_idx,
+	       sum.rbs_blocked, sum.rbs_unlock, sum.rbs_unboosted,
+	       sum.rbs_boost_attempt, sum.rbs_boost);
+	for (event = 0; event < N_RCU_BOOST_DAT_EVENTS; event++) {
+		i = 0;
+		for (state = 0; state < N_RCU_BOOST_STATE; state++) {
+			i += sprintf(&buf[i], " %ld%c",
+				     sum.rbs_stats[event][state],
+				     rcu_boost_state_error[event][state]);
+		}
+		printk(KERN_ALERT "rcu_boost_dat %s %s\n",
+		       rcu_boost_state_event[event], buf);
+	}
+
+	/* Go away and don't come back for awhile. */
+
+	lastprint = xtime.tv_sec;
+}
+
+#else /* #ifdef CONFIG_PREEMPT_RCU_BOOST_STATS */
+
+#define rcu_boost_dat_stat_block(rbdp, oldstate)
+#define rcu_boost_dat_stat_boost(rbdp, oldstate)
+#define rcu_boost_dat_stat_unlock(rbdp, oldstate)
+#define rcu_boost_dat_stat_print()
+
+#endif /* #else #ifdef CONFIG_PREEMPT_RCU_BOOST_STATS */
+
+/*
+ * Initialize RCU-boost state.  This happens early in the boot process,
+ * when the scheduler does not yet exist.  So don't try to use it.
+ */
+static void init_rcu_boost_early(void)
+{
+	struct rcu_boost_dat *rbdp;
+	int cpu;
+	int i;
+
+	for_each_possible_cpu(cpu) {
+		rbdp = per_cpu(rcu_boost_dat, cpu);
+		for (i = 0; i < RCU_BOOST_ELEMENTS; i++) {
+			rbdp[i].rbs_mutex = SPIN_LOCK_UNLOCKED;
+			INIT_LIST_HEAD(&rbdp[i].rbs_toboost);
+			INIT_LIST_HEAD(&rbdp[i].rbs_boosted);
+			rbdp[i].rbs_blocked = 0;
+			rbdp[i].rbs_boost_attempt = 0;
+			rbdp[i].rbs_boost = 0;
+			rbdp[i].rbs_unlock = 0;
+			rbdp[i].rbs_unboosted = 0;
+#ifdef CONFIG_PREEMPT_RCU_BOOST_STATS
+			{
+				int j, k;
+
+				for (j = 0; j < N_RCU_BOOST_DAT_EVENTS; j++)
+					for (k = 0; k < N_RCU_BOOST_STATE; k++)
+						rbdp[i].rbs_stats[j][k] = 0;
+			}
+#endif /* #ifdef CONFIG_PREEMPT_RCU_BOOST_STATS */
+		}
+		smp_wmb();  /* Make sure readers see above initialization. */
+		rcu_boost_idx = 0;  /* Allow readers to access data. */
+	}
+}
+
+/*
+ * Return the list on which the calling task should add itself, or
+ * NULL if too early during initialization.
+ */
+static inline struct rcu_boost_dat *rcu_rbd_new(void)
+{
+	int cpu = raw_smp_processor_id();  /* locks used, so preemption OK. */
+	int idx = rcu_boost_idx;
+
+	smp_read_barrier_depends(); barrier(); /* rmb() on Alpha for idx. */
+	if (unlikely(idx < 0))
+		return (NULL);
+	return &per_cpu(rcu_boost_dat, cpu)[idx];
+}
+
+/*
+ * Return the list from which to boost target tasks.
+ * May only be invoked by the booster task, so guaranteed to
+ * already be initialized.  Use rcu_boost_dat element least recently
+ * the destination for task blocking in RCU read-side critical sections.
+ */
+static inline struct rcu_boost_dat *rcu_rbd_boosting(int cpu)
+{
+	int idx = (rcu_boost_idx + 1) & (RCU_BOOST_ELEMENTS - 1);
+
+	return &per_cpu(rcu_boost_dat, cpu)[idx];
+}
+
+#define PREEMPT_RCU_BOOSTER_PRIO 49  /* Match curr_irq_prio manually. */
+			             /*  Administrators can always adjust */
+				     /*  via the /proc interface. */
+
+/*
+ * Boost the specified task from an RCU viewpoint.
+ * Boost the target task to a priority just a bit less-favored than
+ * that of the RCU-boost task, but boost to a realtime priority even
+ * if the RCU-boost task is running at a non-realtime priority.
+ * We check the priority of the RCU-boost task each time we boost
+ * in case the sysadm manually changes the priority.
+ */
+static void rcu_boost_prio(struct task_struct *taskp)
+{
+	unsigned long oldirq;
+	int rcuprio;
+
+	spin_lock_irqsave(&current->pi_lock, oldirq);
+	rcuprio = rt_mutex_getprio(current) + 1;
+	if (rcuprio >= MAX_USER_RT_PRIO)
+		rcuprio = MAX_USER_RT_PRIO - 1;
+	spin_unlock_irqrestore(&current->pi_lock, oldirq);
+	spin_lock_irqsave(&taskp->pi_lock, oldirq);
+	if (taskp->rcu_prio != rcuprio) {
+		taskp->rcu_prio = rcuprio;
+		if (taskp->rcu_prio != taskp->prio)
+			rt_mutex_setprio(taskp, taskp->rcu_prio);
+	}
+	spin_unlock_irqrestore(&taskp->pi_lock, oldirq);
+}
+
+/*
+ * Unboost the specified task from an RCU viewpoint.
+ */
+static void rcu_unboost_prio(struct task_struct *taskp)
+{
+	int nprio;
+	unsigned long oldirq;
+
+	spin_lock_irqsave(&taskp->pi_lock, oldirq);
+	taskp->rcu_prio = MAX_PRIO;
+	nprio = rt_mutex_getprio(taskp);
+	if (nprio > taskp->prio)
+		rt_mutex_setprio(taskp, nprio);
+	spin_unlock_irqrestore(&taskp->pi_lock, oldirq);
+}
+
+/*
+ * Boost all of the RCU-reader tasks on the specified list.
+ */
+static void rcu_boost_one_reader_list(struct rcu_boost_dat *rbdp)
+{
+	LIST_HEAD(list);
+	unsigned long oldirq;
+	struct task_struct *taskp;
+
+	/*
+	 * Splice both lists onto a local list.  We will still
+	 * need to hold the lock when manipulating the local list
+	 * because tasks can remove themselves at any time.
+	 * The reason for splicing the rbs_boosted list is that
+	 * our priority may have changed, so reboosting may be
+	 * required.
+	 */
+
+	spin_lock_irqsave(&rbdp->rbs_mutex, oldirq);
+	list_splice_init(&rbdp->rbs_toboost, &list);
+	list_splice_init(&rbdp->rbs_boosted, &list);
+	while (!list_empty(&list)) {
+
+		/*
+		 * Pause for a bit before boosting each task.
+		 * @@@FIXME: reduce/eliminate pausing in case of OOM.
+		 */
+
+		spin_unlock_irqrestore(&rbdp->rbs_mutex, oldirq);
+		schedule_timeout_uninterruptible(1);
+		spin_lock_irqsave(&rbdp->rbs_mutex, oldirq);
+
+		/*
+		 * All tasks might have removed themselves while
+		 * we were waiting.  Recheck list emptiness.
+		 */
+
+		if (list_empty(&list))
+			break;
+
+		/* Remove first task in local list, count the attempt. */
+
+		taskp = list_entry(list.next, typeof(*taskp), rcub_entry);
+		list_del_init(&taskp->rcub_entry);
+		rbdp->rbs_boost_attempt++;
+
+		/* Ignore tasks in unexpected states. */
+
+		if (taskp->rcub_state == RCU_BOOST_IDLE) {
+			list_add_tail(&taskp->rcub_entry, &rbdp->rbs_toboost);
+			rcu_boost_dat_stat_boost(rbdp, taskp->rcub_state);
+			continue;
+		}
+
+		/* Boost the task's priority. */
+
+		rcu_boost_prio(taskp);
+		rbdp->rbs_boost++;
+		rcu_boost_dat_stat_boost(rbdp, taskp->rcub_state);
+		taskp->rcub_state = RCU_BOOSTED;
+		list_add_tail(&taskp->rcub_entry, &rbdp->rbs_boosted);
+	}
+	spin_unlock_irqrestore(&rbdp->rbs_mutex, oldirq);
+}
+
+/*
+ * Priority-boost tasks stuck in RCU read-side critical sections as
+ * needed (presumably rarely).
+ */
+static int rcu_booster(void *arg)
+{
+	int cpu;
+	struct sched_param sp;
+
+	sp.sched_priority = PREEMPT_RCU_BOOSTER_PRIO;
+	sched_setscheduler(current, SCHED_RR, &sp);
+	current->flags |= PF_NOFREEZE;
+
+	do {
+
+		/* Advance the lists of tasks. */
+
+		rcu_boost_idx = (rcu_boost_idx + 1) % RCU_BOOST_ELEMENTS;
+		for_each_possible_cpu(cpu) {
+
+			/*
+			 * Boost all sufficiently aged readers.
+			 * Readers must first be preempted or block
+			 * on a mutex in an RCU read-side critical section,
+			 * then remain in that critical section for
+			 * RCU_BOOST_ELEMENTS-1 time intervals.
+			 * So most of the time we should end up doing
+			 * nothing.
+			 */
+
+			rcu_boost_one_reader_list(rcu_rbd_boosting(cpu));
+
+			/*
+			 * Large SMP systems may need to sleep sometimes
+			 * in this loop.  Or have multiple RCU-boost tasks.
+			 */
+		}
+
+		/*
+		 * Sleep to allow any unstalled RCU read-side critical
+		 * sections to age out of the list.  @@@ FIXME: reduce,
+		 * adjust, or eliminate in case of OOM.
+		 */
+
+		schedule_timeout_uninterruptible(HZ / 100);
+
+		/* Print stats if enough time has passed. */
+
+		rcu_boost_dat_stat_print();
+
+	} while (!kthread_should_stop());
+
+	return 0;
+}
+
+/*
+ * Perform the portions of RCU-boost initialization that require the
+ * scheduler to be up and running.
+ */
+void init_rcu_boost_late(void)
+{
+
+	/* Spawn RCU-boost task. */
+
+	printk(KERN_INFO "Starting RCU priority booster\n");
+	rcu_boost_task = kthread_run(rcu_booster, NULL, "RCU Prio Booster");
+	if (IS_ERR(rcu_boost_task)) {
+		printk(KERN_ALERT
+		       "Unable to create RCU Priority Booster, errno %ld\n",
+		       -PTR_ERR(rcu_boost_task));
+
+		/*
+		 * Continue running, but tasks permanently blocked
+		 * in RCU read-side critical sections will be able
+		 * to stall grace-period processing, potentially
+		 * OOMing the machine.
+		 */
+
+		rcu_boost_task = NULL;
+	}
+}
+
+/*
+ * Update task's RCU-boost state to reflect blocking in RCU read-side
+ * critical section, so that the RCU-boost task can find it in case it
+ * later needs its priority boosted.
+ */
+void __rcu_preempt_boost(void)
+{
+	struct rcu_boost_dat *rbdp;
+	unsigned long oldirq;
+
+	/* Identify list to place task on for possible later boosting. */
+
+	local_irq_save(oldirq);
+	rbdp = rcu_rbd_new();
+	if (rbdp == NULL) {
+		local_irq_restore(oldirq);
+		printk(KERN_ALERT
+		       "Preempted RCU read-side critical section too early.\n");
+		return;
+	}
+	spin_lock(&rbdp->rbs_mutex);
+	rbdp->rbs_blocked++;
+
+	/*
+	 * Update state.  We hold the lock and aren't yet on the list,
+	 * so the booster cannot mess with us yet.
+	 */
+
+	rcu_boost_dat_stat_block(rbdp, current->rcub_state);
+	if (current->rcub_state != RCU_BOOST_IDLE) {
+
+		/*
+		 * We have been here before, so just update stats.
+		 * It may seem strange to do all this work just to
+		 * accumulate statistics, but this is such a
+		 * low-probability code path that we shouldn't care.
+		 * If it becomes a problem, it can be fixed.
+		 */
+
+		spin_unlock_irqrestore(&rbdp->rbs_mutex, oldirq);
+		return;
+	}
+	current->rcub_state = RCU_BOOST_BLOCKED;
+
+	/* Now add ourselves to the list so that the booster can find us. */
+
+	list_add_tail(&current->rcub_entry, &rbdp->rbs_toboost);
+	current->rcub_rbdp = rbdp;
+	spin_unlock_irqrestore(&rbdp->rbs_mutex, oldirq);
+}
+
+/*
+ * Do the list-removal and priority-unboosting "heavy lifting" when
+ * required.
+ */
+static void __rcu_read_unlock_unboost(void)
+{
+	unsigned long oldirq;
+	struct rcu_boost_dat *rbdp;
+
+	/* Identify the list structure and acquire the corresponding lock. */
+
+	rbdp = current->rcub_rbdp;
+	spin_lock_irqsave(&rbdp->rbs_mutex, oldirq);
+
+	/* Remove task from the list it was on. */
+
+	list_del_init(&current->rcub_entry);
+	rbdp->rbs_unlock++;
+	current->rcub_rbdp = NULL;
+
+	/* Record stats, unboost if needed, and update state. */
+
+	rcu_boost_dat_stat_unlock(rbdp, current->rcub_state);
+	if (current->rcub_state == RCU_BOOSTED) {
+		rcu_unboost_prio(current);
+		rbdp->rbs_unboosted++;
+	}
+	current->rcub_state = RCU_BOOST_IDLE;
+	spin_unlock_irqrestore(&rbdp->rbs_mutex, oldirq);
+}
+
+/*
+ * Do any state changes and unboosting needed for rcu_read_unlock().
+ * Pass any complex work on to __rcu_read_unlock_unboost().
+ * The vast majority of the time, no work will be needed, as preemption
+ * and blocking within RCU read-side critical sections is comparatively
+ * rare.
+ */
+static inline void rcu_read_unlock_unboost(void)
+{
+
+	if (unlikely(current->rcub_state != RCU_BOOST_IDLE))
+		__rcu_read_unlock_unboost();
+}
+
+#endif /* #else #ifndef CONFIG_PREEMPT_RCU_BOOST */
+
 /*
  * States for rcu_try_flip() and friends.
  */
@@ -302,6 +822,9 @@ void __rcu_read_unlock(void)
 		 */
 
 		ORDERED_WRT_IRQ(__get_cpu_var(rcu_flipctr)[idx])--;
+
+		rcu_read_unlock_unboost();
+
 		local_irq_restore(oldirq);
 	}
 }
@@ -578,6 +1101,7 @@ void rcu_advance_callbacks_rt(int cpu, i
 		if (rcu_ctrlblk.completed == rdp->completed) {
 			return;
 		}
+		rcu_read_unlock_unboost();
 	}
 	spin_lock_irqsave(&rdp->lock, oldirq);
 	RCU_TRACE_RDP(rcupreempt_trace_check_callbacks, rdp);
@@ -756,6 +1280,11 @@ int rcu_pending_rt(int cpu)
 	return 0;
 }
 
+/*
+ * Initialize RCU.  This is called very early in boot, so is restricted
+ * to very simple operations.  Don't even think about messing with anything
+ * that involves the scheduler, as it doesn't exist yet.
+ */
 void __init rcu_init_rt(void)
 {
 	int cpu;
@@ -777,6 +1306,7 @@ void __init rcu_init_rt(void)
 		rdp->donelist = NULL;
 		rdp->donetail = &rdp->donelist;
 	}
+	init_rcu_boost_early();
 /*&&&&*/printk("experimental non-atomic RCU implementation: init done\n");
 }
 
diff -urpNa -X dontdiff linux-2.6.22-e-hotplugcpu/kernel/rtmutex.c linux-2.6.22-f-boost/kernel/rtmutex.c
--- linux-2.6.22-e-hotplugcpu/kernel/rtmutex.c	2007-07-08 16:32:17.000000000 -0700
+++ linux-2.6.22-f-boost/kernel/rtmutex.c	2007-08-20 17:38:19.000000000 -0700
@@ -111,11 +111,12 @@ static inline void mark_rt_mutex_waiters
  */
 int rt_mutex_getprio(struct task_struct *task)
 {
+	int prio = min(task->normal_prio, get_rcu_prio(task));
+
 	if (likely(!task_has_pi_waiters(task)))
-		return task->normal_prio;
+		return prio;
 
-	return min(task_top_pi_waiter(task)->pi_list_entry.prio,
-		   task->normal_prio);
+	return min(task_top_pi_waiter(task)->pi_list_entry.prio, prio);
 }
 
 /*
diff -urpNa -X dontdiff linux-2.6.22-e-hotplugcpu/kernel/sched.c linux-2.6.22-f-boost/kernel/sched.c
--- linux-2.6.22-e-hotplugcpu/kernel/sched.c	2007-07-08 16:32:17.000000000 -0700
+++ linux-2.6.22-f-boost/kernel/sched.c	2007-08-20 17:58:24.000000000 -0700
@@ -1702,6 +1702,7 @@ void fastcall sched_fork(struct task_str
 	 * Make sure we do not leak PI boosting priority to the child:
 	 */
 	p->prio = current->normal_prio;
+	set_rcu_prio(p, MAX_PRIO);
 
 	INIT_LIST_HEAD(&p->run_list);
 	p->array = NULL;
@@ -1784,6 +1785,7 @@ void fastcall wake_up_new_task(struct ta
 			else {
 				p->prio = current->prio;
 				p->normal_prio = current->normal_prio;
+				set_rcu_prio(p, MAX_PRIO);
 				list_add_tail(&p->run_list, &current->run_list);
 				p->array = current->array;
 				p->array->nr_active++;
@@ -3590,6 +3592,8 @@ asmlinkage void __sched schedule(void)
 	}
 	profile_hit(SCHED_PROFILING, __builtin_return_address(0));
 
+	rcu_preempt_boost();
+
 need_resched:
 	preempt_disable();
 	prev = current;
@@ -5060,6 +5064,7 @@ void __cpuinit init_idle(struct task_str
 	idle->sleep_avg = 0;
 	idle->array = NULL;
 	idle->prio = idle->normal_prio = MAX_PRIO;
+	set_rcu_prio(idle, MAX_PRIO);
 	idle->state = TASK_RUNNING;
 	idle->cpus_allowed = cpumask_of_cpu(cpu);
 	set_task_cpu(idle, cpu);
