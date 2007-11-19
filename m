Return-Path: <linux-kernel-owner+w=401wt.eu-S1753357AbXKSMSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbXKSMSS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 07:18:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752364AbXKSMSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 07:18:09 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:45585 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301AbXKSMSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 07:18:07 -0500
Date: Mon, 19 Nov 2007 18:00:51 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: dmitry.adamushko@gmail.com, a.p.zijlstra@chello.nl,
       dhaval@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, efault@gmx.de,
       skumar@linux.vnet.ibm.com, Balbir Singh <balbir@in.ibm.com>
Subject: [PATCH 2/2] sched: Improve fairness of cpu allocation for task groups
Message-ID: <20071119123051.GC28777@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20071119122713.GA28777@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071119122713.GA28777@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The current load balancing scheme isn't good for group fairness.

For ex: on a 8-cpu system, I created 3 groups as under:

	a = 8 tasks (cpu.shares = 1024) 
	b = 4 tasks (cpu.shares = 1024) 
	c = 3 tasks (cpu.shares = 1024) 

a, b and c are task groups that have equal weight. We would expect each
of the groups to receive 33.33% of cpu bandwidth under a fair scheduler.

This is what I get with the latest scheduler git tree:

Before this patch:
--------------------------------------------------------------------------------
Col1  | Col2    | Col3  |  Col4
------|---------|-------|-------------------------------------------------------
a     | 277.676 | 57.8% | 54.1%  54.1%  54.1%  54.2%  56.7%  62.2%  62.8% 64.5%
b     | 116.108 | 24.2% | 47.4%  48.1%  48.7%  49.3%
c     |  86.326 | 18.0% | 47.5%  47.9%  48.5%
--------------------------------------------------------------------------------

Explanation of o/p:

Col1 -> Group name
Col2 -> Cumulative execution time (in seconds) receive by all tasks of that 
	group in a 60sec window across 8 cpus
Col3 -> CPU bandwidth received by the group in the 60sec window, expressed in 
        percentage. Col3 data is derived as:
		Col3 = 100 * Col2 / (NR_CPUS * 60)
Col4 -> CPU bandwidth received by each individual task of the group.
		Col4 = 100 * cpu_time_recd_by_task / 60

[I can share the test scripts that produce such an o/p if reqd]

The deviation from desired group fairness is as below:

	a = +24.47%
	b = -9.13%
	c = -15.33%

which is quite high.

After the patch below is applied, here are the results:

--------------------------------------------------------------------------------
Col1  | Col2    | Col3  |  Col4
------|---------|-------|-------------------------------------------------------
a     | 163.112 | 34.0% | 33.2%  33.4%  33.5%  33.5%  33.7%  34.4%  34.8% 35.3%
b     | 156.220 | 32.5% | 63.3%  64.5%  66.1%  66.5%
c     | 160.653 | 33.5% | 85.8%  90.6%  91.4%
--------------------------------------------------------------------------------

Deviation from desired group fairness is as below:

	a = +0.67%
	b = -0.83%
 	c = +0.17%

which is far better IMO. Most of other runs have yielded a deviation within
+-2% at the most, which is good.

Why do we see bad (group) fairness with current scheuler?
=========================================================

Currently cpu's weight is just the summation of individual task weights.
This can yield incorrect results. For ex: consider three groups as below
on a 2-cpu system:

	CPU0	CPU1
---------------------------
	A (10)  B(5)
		C(5)
---------------------------

Group A has 10 tasks, all on CPU0, Group B and C have 5 tasks each all
of which are on CPU1. Each task has the same weight (NICE_0_LOAD =
1024).

The current scheme would yield a cpu weight of 10240 (10*1024) for each cpu and
the load balancer will think both CPUs are perfectly balanced and won't
move around any tasks. This, however, would yield this bandwidth:

	A = 50%
	B = 25%
	C = 25%

which is not the desired result.

What's changing in the patch?
=============================

	- How cpu weights are calculated when CONFIF_FAIR_GROUP_SCHED is
	  defined (see below)
	- API Change 
		- Minimum shares that can be allocated to a group is 
		  set to 100 (MIN_GROUP_SHARES macro introduced)
		- Two tunables introduced in sysfs (under SCHED_DEBUG) to 
		  control the frequency at which the load balance monitor
		  thread runs. 

The basic change made in this patch is how cpu weight (rq->load.weight) is 
calculated. Its now calculated as the summation of group weights on a cpu,
rather than summation of task weights. Weight exerted by a group on a
cpu is dependent on the shares allocated to it and also the number of
tasks the group has on that cpu compared to the total number of
(runnable) tasks the group has in the system.

Let,
	W(K,i)  = Weight of group K on cpu i
	T(K,i)  = Task load present in group K's cfs_rq on cpu i
	T(K)    = Total task load of group K across various cpus
	S(K) 	= Shares allocated to group K
	NRCPUS	= Number of online cpus in the scheduler domain to
	 	  which group K is assigned.

Then,
	W(K,i) = S(K) * NRCPUS * T(K,i) / T(K)

A load balance monitor thread is created at bootup, which periodically
runs and adjusts group's weight on each cpu. To avoid its overhead, two
min/max tunables are introduced (under SCHED_DEBUG) to control the rate at which
it runs.


Impact to sched.o size
======================

CONFIG_FAIR_GROUP_SCHED not defined ->

  		text    data     bss     dec     hex filename
	       36829    2766      48   39643    9adb sched.o-before
	       36912    2766      48   39726    9b2e sched.o-after
	                              ---------
					+83
				      --------

CONFIG_FAIR_GROUP_SCHED defined ->

  		text    data     bss     dec     hex filename
	       39019    3346     336   42701    a6cd sched.o-before
	       40223    3482     340   44045    ac0d sched.o-after
				       ------
				       +1344
				       ------

Signed-off-by : Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>

---
 include/linux/sched.h |    4 
 kernel/sched.c        |  292 +++++++++++++++++++++++++++++++++++++++++++++-----
 kernel/sched_fair.c   |   95 ++++++++++------
 kernel/sched_rt.c     |    2 
 kernel/sysctl.c       |   16 ++
 5 files changed, 348 insertions(+), 61 deletions(-)

Index: current/include/linux/sched.h
===================================================================
--- current.orig/include/linux/sched.h
+++ current/include/linux/sched.h
@@ -1467,6 +1467,10 @@ extern unsigned int sysctl_sched_child_r
 extern unsigned int sysctl_sched_features;
 extern unsigned int sysctl_sched_migration_cost;
 extern unsigned int sysctl_sched_nr_migrate;
+#ifdef CONFIG_FAIR_GROUP_SCHED
+extern unsigned int sysctl_sched_min_bal_int_shares;
+extern unsigned int sysctl_sched_max_bal_int_shares;
+#endif
 
 int sched_nr_latency_handler(struct ctl_table *table, int write,
 		struct file *file, void __user *buffer, size_t *length,
Index: current/kernel/sched.c
===================================================================
--- current.orig/kernel/sched.c
+++ current/kernel/sched.c
@@ -168,9 +168,46 @@ struct task_group {
 	struct sched_entity **se;
 	/* runqueue "owned" by this group on each cpu */
 	struct cfs_rq **cfs_rq;
+
+	/* shares assigned to a task group governs how much of cpu bandwidth
+	 * is allocated to the group. The more shares a group has, the more is
+	 * the cpu bandwidth allocated to it.
+ 	 *
+	 * For ex, lets say that there are three task groups, A, B and C which
+	 * have been assigned shares 1000, 2000 and 3000 respectively. Then,
+	 * cpu bandwidth allocated by the scheduler to task groups A, B and C
+	 * should be:
+	 *
+	 *	Bw(A) = 1000/(1000+2000+3000) * 100 = 16.66%
+	 *	Bw(B) = 2000/(1000+2000+3000) * 100 = 33.33%
+	 * 	Bw(C) = 3000/(1000+2000+3000) * 100 = 50%
+	 *
+	 * The weight assigned to a task group's schedulable entities on every
+	 * cpu (task_group.se[a_cpu]->load.weight) is derived from the task
+	 * group's shares. For ex: lets say that task group A has been
+	 * assigned shares of 1000 and there are two CPUs in a system. Then,
+	 *
+	 *  tg_A->se[0]->load.weight = tg_A->se[1]->load.weight = 1000;
+	 *
+ 	 * Note: It's not necessary that each of a task's group schedulable
+ 	 * 	 entity have the same weight on all CPUs. If the group
+ 	 * 	 has 2 of its tasks on CPU0 and 1 task on CPU1, then a
+ 	 * 	 better distribution of weight could be:
+ 	 *
+ 	 *	tg_A->se[0]->load.weight = 2/3 * 2000 = 1333
+ 	 *	tg_A->se[1]->load.weight = 1/2 * 2000 =  667
+ 	 *
+ 	 * rebalance_shares() is responsible for distributing the shares of a
+ 	 * task groups like this among the group's schedulable entities across
+ 	 * cpus.
+ 	 *
+	 */
 	unsigned long shares;
-	/* spinlock to serialize modification to shares */
-	spinlock_t lock;
+
+ 	/* lock to serialize modification to shares */
+ 	struct mutex lock;
+
+ 	unsigned long last_total_load;
 	struct rcu_head rcu;
 };
 
@@ -182,6 +219,14 @@ static DEFINE_PER_CPU(struct cfs_rq, ini
 static struct sched_entity *init_sched_entity_p[NR_CPUS];
 static struct cfs_rq *init_cfs_rq_p[NR_CPUS];
 
+static DEFINE_MUTEX(doms_cur_mutex); /* serialize access to doms_curr[] array */
+
+/* kernel thread that runs rebalance_shares() periodically */
+static struct task_struct *lb_monitor_task;
+
+static void set_se_shares(struct sched_entity *se, unsigned long shares);
+static int load_balance_monitor(void *unused);
+
 /* Default task group.
  *	Every task in system belong to this group at bootup.
  */
@@ -196,6 +241,8 @@ struct task_group init_task_group = {
 # define INIT_TASK_GROUP_LOAD	NICE_0_LOAD
 #endif
 
+#define MIN_GROUP_SHARES       100
+
 static int init_task_group_load = INIT_TASK_GROUP_LOAD;
 
 /* return group to which a task belongs */
@@ -222,9 +269,21 @@ static inline void set_task_cfs_rq(struc
 	p->se.parent = task_group(p)->se[cpu];
 }
 
+static inline void lock_doms_cur(void)
+{
+	mutex_lock(&doms_cur_mutex);
+}
+
+static inline void unlock_doms_cur(void)
+{
+	mutex_unlock(&doms_cur_mutex);
+}
+
 #else
 
 static inline void set_task_cfs_rq(struct task_struct *p, unsigned int cpu) { }
+static inline void lock_doms_cur(void) { }
+static inline void unlock_doms_cur(void) { }
 
 #endif	/* CONFIG_FAIR_GROUP_SCHED */
 
@@ -854,6 +913,16 @@ iter_move_one_task(struct rq *this_rq, i
 		   struct rq_iterator *iterator);
 #endif
 
+static inline void inc_load(struct rq *rq, unsigned long load)
+{
+	update_load_add(&rq->load, load);
+}
+
+static inline void dec_load(struct rq *rq, unsigned long load)
+{
+	update_load_sub(&rq->load, load);
+}
+
 #include "sched_stats.h"
 #include "sched_idletask.c"
 #include "sched_fair.c"
@@ -864,26 +933,14 @@ iter_move_one_task(struct rq *this_rq, i
 
 #define sched_class_highest (&rt_sched_class)
 
-static inline void inc_load(struct rq *rq, const struct task_struct *p)
-{
-	update_load_add(&rq->load, p->se.load.weight);
-}
-
-static inline void dec_load(struct rq *rq, const struct task_struct *p)
-{
-	update_load_sub(&rq->load, p->se.load.weight);
-}
-
 static void inc_nr_running(struct task_struct *p, struct rq *rq)
 {
 	rq->nr_running++;
-	inc_load(rq, p);
 }
 
 static void dec_nr_running(struct task_struct *p, struct rq *rq)
 {
 	rq->nr_running--;
-	dec_load(rq, p);
 }
 
 static void set_load_weight(struct task_struct *p)
@@ -4055,10 +4112,8 @@ void set_user_nice(struct task_struct *p
 		goto out_unlock;
 	}
 	on_rq = p->se.on_rq;
-	if (on_rq) {
+	if (on_rq)
 		dequeue_task(rq, p, 0);
-		dec_load(rq, p);
-	}
 
 	p->static_prio = NICE_TO_PRIO(nice);
 	set_load_weight(p);
@@ -4068,7 +4123,6 @@ void set_user_nice(struct task_struct *p
 
 	if (on_rq) {
 		enqueue_task(rq, p, 0);
-		inc_load(rq, p);
 		/*
 		 * If the task increased its priority or is running and
 		 * lowered its priority, then reschedule its CPU:
@@ -6509,6 +6563,8 @@ void partition_sched_domains(int ndoms_n
 {
 	int i, j;
 
+	lock_doms_cur();
+
 	/* always unregister in case we don't destroy any domains */
 	unregister_sched_domain_sysctl();
 
@@ -6549,6 +6605,8 @@ match2:
 	ndoms_cur = ndoms_new;
 
 	register_sched_domain_sysctl();
+
+	unlock_doms_cur();
 }
 
 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
@@ -6683,6 +6741,17 @@ void __init sched_init_smp(void)
 	if (set_cpus_allowed(current, non_isolated_cpus) < 0)
 		BUG();
 	sched_init_granularity();
+
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	lb_monitor_task = kthread_create(load_balance_monitor, NULL,
+					 "load_balance_monitor");
+	if (!IS_ERR(lb_monitor_task))
+		wake_up_process(lb_monitor_task);
+	else {
+		printk("Could not create load balance monitor thread"
+			"(error = %ld) \n", PTR_ERR(lb_monitor_task));
+	}
+#endif
 }
 #else
 void __init sched_init_smp(void)
@@ -6747,7 +6816,7 @@ void __init sched_init(void)
 			se->parent = NULL;
 		}
 		init_task_group.shares = init_task_group_load;
-		spin_lock_init(&init_task_group.lock);
+		mutex_init(&init_task_group.lock);
 #endif
 
 		for (j = 0; j < CPU_LOAD_IDX_MAX; j++)
@@ -6939,6 +7008,136 @@ void set_curr_task(int cpu, struct task_
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 
+/* distribute shares of all task groups among their schedulable entities,
+ * to reflect load distrbution across cpus.
+ */
+static int rebalance_shares(struct sched_domain *sd, int this_cpu)
+{
+	struct cfs_rq *cfs_rq;
+	struct rq *rq = cpu_rq(this_cpu);
+	cpumask_t sdspan = sd->span;
+	int balanced = 1;
+
+	/* Walk thr' all the task groups that we have */
+	for_each_leaf_cfs_rq(rq, cfs_rq) {
+		int i;
+		unsigned long total_load = 0, total_shares;
+		struct task_group *tg = cfs_rq->tg;
+
+		/* Gather total task load of this group across cpus */
+		for_each_cpu_mask(i, sdspan)
+			total_load += tg->cfs_rq[i]->load.weight;
+
+		/* Nothing to do if this group has no load or if it's load
+		 * hasn't changed since the last time we checked.
+		 */
+		if (!total_load || total_load == tg->last_total_load)
+			continue;
+
+		tg->last_total_load = total_load;
+
+		/* tg->shares represents the number of cpu shares the task group
+		 * is eligible to hold on a single cpu. On N cpus, it is
+		 * eligible to hold (N * tg->shares) number of cpu shares.
+		 */
+		total_shares = tg->shares * cpus_weight(sdspan);
+
+		/* redistribute total_shares across cpus as per the task load
+		 * distribution.
+		 */
+		for_each_cpu_mask(i, sdspan) {
+			unsigned long local_load, local_shares, irqflags;
+
+			local_load = tg->cfs_rq[i]->load.weight;
+			local_shares = (local_load * total_shares) / total_load;
+			if (!local_shares)
+				local_shares = MIN_GROUP_SHARES;
+			if (local_shares == tg->se[i]->load.weight)
+				continue;
+
+			spin_lock_irqsave(&cpu_rq(i)->lock, irqflags);
+			set_se_shares(tg->se[i], local_shares);
+			spin_unlock_irqrestore(&cpu_rq(i)->lock, irqflags);
+			balanced = 0;
+		}
+	}
+
+	return balanced;
+}
+
+/*
+ * How frequently should we rebalance_shares() across cpus?
+ *
+ * The more frequently we rebalance shares, the more accurate is the fairness
+ * of cpu bandwidth distribution between task groups. However higher frequency
+ * also implies increased scheduling overhead.
+ *
+ * sysctl_sched_min_bal_int_shares represents the minimum interval between
+ * consecutive calls to rebalance_shares() in the same sched domain.
+ *
+ * sysctl_sched_max_bal_int_shares represents the maximum interval between
+ * consecutive calls to rebalance_shares() in the same sched domain.
+ *
+ * These settings allows for the appropriate tradeoff between accuracy of
+ * fairness and the associated overhead.
+ *
+ */
+
+/* default: 8ms, units: milliseconds */
+const_debug unsigned int sysctl_sched_min_bal_int_shares = 8;
+
+/* default: 128ms, units: milliseconds */
+const_debug unsigned int sysctl_sched_max_bal_int_shares = 128;
+
+static int load_balance_monitor(void *unused)
+{
+	unsigned int timeout = sysctl_sched_min_bal_int_shares;
+
+	while(!kthread_should_stop()) {
+		int i, cpu, balanced = 1;
+
+		lock_cpu_hotplug(); /* Prevent cpus going down or coming up */
+		lock_doms_cur();  /* lockout changes to doms_cur[] array */
+
+		rcu_read_lock();  /* to walk rq->sd chain on various cpus */
+
+		for (i=0; i < ndoms_cur; i++) {
+			cpumask_t cpumap = doms_cur[i];
+			struct sched_domain *sd = NULL, *sd_prev = NULL;
+
+			cpu = first_cpu(cpumap);
+
+			/* Find the highest domain at which to balance shares */
+			for_each_domain(cpu, sd) {
+				if (!(sd->flags & SD_LOAD_BALANCE))
+					continue;
+				sd_prev = sd;
+			}
+
+			sd = sd_prev;
+			/* sd == NULL? No load balance reqd in this domain */
+			if (!sd)
+				continue;
+
+			balanced &= rebalance_shares(sd, cpu);
+		}
+
+		rcu_read_unlock();
+
+		unlock_doms_cur();
+		unlock_cpu_hotplug();
+
+		if (!balanced)
+			timeout = sysctl_sched_min_bal_int_shares;
+		else if (timeout < sysctl_sched_max_bal_int_shares)
+			timeout *= 2;
+
+		msleep(timeout);
+	}
+
+	return 0;
+}
+
 /* allocate runqueue etc for a new task group */
 struct task_group *sched_create_group(void)
 {
@@ -6994,7 +7193,7 @@ struct task_group *sched_create_group(vo
 	}
 
 	tg->shares = NICE_0_LOAD;
-	spin_lock_init(&tg->lock);
+	mutex_init(&tg->lock);
 
 	return tg;
 
@@ -7092,41 +7291,78 @@ done:
 	task_rq_unlock(rq, &flags);
 }
 
+/* rq->lock to be locked by caller */
 static void set_se_shares(struct sched_entity *se, unsigned long shares)
 {
 	struct cfs_rq *cfs_rq = se->cfs_rq;
 	struct rq *rq = cfs_rq->rq;
 	int on_rq;
 
-	spin_lock_irq(&rq->lock);
+	if (!shares)
+		shares = MIN_GROUP_SHARES;
 
 	on_rq = se->on_rq;
-	if (on_rq)
+	if (on_rq) {
 		dequeue_entity(cfs_rq, se, 0);
+		dec_load(rq, se->load.weight);
+	}
 
 	se->load.weight = shares;
 	se->load.inv_weight = div64_64((1ULL<<32), shares);
 
-	if (on_rq)
+	if (on_rq) {
 		enqueue_entity(cfs_rq, se, 0);
-
-	spin_unlock_irq(&rq->lock);
+		inc_load(rq, se->load.weight);
+	}
 }
 
 int sched_group_set_shares(struct task_group *tg, unsigned long shares)
 {
 	int i;
+	struct cfs_rq *cfs_rq;
+	struct rq *rq;
+
+	mutex_lock(&tg->lock);
 
-	spin_lock(&tg->lock);
 	if (tg->shares == shares)
 		goto done;
 
+	if (shares < MIN_GROUP_SHARES)
+		shares = MIN_GROUP_SHARES;
+
+	/* Prevent any load balance activity (rebalance_shares,
+	 * load_balance_fair) from referring to this group first,
+	 * by taking it off the rq->leaf_cfs_rq_list on each cpu.
+	 */
+	for_each_possible_cpu(i) {
+		cfs_rq = tg->cfs_rq[i];
+		list_del_rcu(&cfs_rq->leaf_cfs_rq_list);
+	}
+
+	/* wait for any ongoing reference to this group to finish */
+	synchronize_sched();
+
+	/* Now we are free to modify the group's share on each cpu
+	 * w/o tripping rebalance_share or load_balance_fair.
+	 */
 	tg->shares = shares;
-	for_each_possible_cpu(i)
+	for_each_possible_cpu(i) {
+		spin_lock_irq(&cpu_rq(i)->lock);
 		set_se_shares(tg->se[i], shares);
+		spin_unlock_irq(&cpu_rq(i)->lock);
+	}
+
+	/* Enable load balance activity on this group, by inserting it back on
+	 * each cpu's rq->lead_cfs_rq_list.
+	 */
+	for_each_possible_cpu(i) {
+		rq = cpu_rq(i);
+		cfs_rq = tg->cfs_rq[i];
+		list_add_rcu(&cfs_rq->leaf_cfs_rq_list, &rq->leaf_cfs_rq_list);
+	}
 
 done:
-	spin_unlock(&tg->lock);
+	mutex_unlock(&tg->lock);
 	return 0;
 }
 
Index: current/kernel/sched_fair.c
===================================================================
--- current.orig/kernel/sched_fair.c
+++ current/kernel/sched_fair.c
@@ -702,6 +702,8 @@ static inline struct sched_entity *paren
 	return se->parent;
 }
 
+#define GROUP_IMBALANCE_PCT	20
+
 #else	/* CONFIG_FAIR_GROUP_SCHED */
 
 #define for_each_sched_entity(se) \
@@ -756,6 +758,7 @@ static void enqueue_task_fair(struct rq 
 {
 	struct cfs_rq *cfs_rq;
 	struct sched_entity *se = &p->se;
+	unsigned long old_load = rq->cfs.load.weight, new_load, delta_load;
 
 	for_each_sched_entity(se) {
 		if (se->on_rq)
@@ -764,6 +767,10 @@ static void enqueue_task_fair(struct rq 
 		enqueue_entity(cfs_rq, se, wakeup);
 		wakeup = 1;
 	}
+
+	new_load = rq->cfs.load.weight;
+	delta_load = new_load - old_load;
+	inc_load(rq, delta_load);
 }
 
 /*
@@ -775,6 +782,7 @@ static void dequeue_task_fair(struct rq 
 {
 	struct cfs_rq *cfs_rq;
 	struct sched_entity *se = &p->se;
+	unsigned long old_load = rq->cfs.load.weight, new_load, delta_load;
 
 	for_each_sched_entity(se) {
 		cfs_rq = cfs_rq_of(se);
@@ -784,6 +792,10 @@ static void dequeue_task_fair(struct rq 
 			break;
 		sleep = 1;
 	}
+
+	new_load = rq->cfs.load.weight;
+	delta_load = old_load - new_load;
+	dec_load(rq, delta_load);
 }
 
 /*
@@ -938,25 +950,6 @@ static struct task_struct *load_balance_
 	return __load_balance_iterator(cfs_rq, cfs_rq->rb_load_balance_curr);
 }
 
-#ifdef CONFIG_FAIR_GROUP_SCHED
-static int cfs_rq_best_prio(struct cfs_rq *cfs_rq)
-{
-	struct sched_entity *curr;
-	struct task_struct *p;
-
-	if (!cfs_rq->nr_running)
-		return MAX_PRIO;
-
-	curr = cfs_rq->curr;
-	if (!curr)
-		curr = __pick_next_entity(cfs_rq);
-
-	p = task_of(curr);
-
-	return p->prio;
-}
-#endif
-
 static unsigned long
 load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		  unsigned long max_load_move,
@@ -966,28 +959,44 @@ load_balance_fair(struct rq *this_rq, in
 	struct cfs_rq *busy_cfs_rq;
 	long rem_load_move = max_load_move;
 	struct rq_iterator cfs_rq_iterator;
+	unsigned long load_moved;
 
 	cfs_rq_iterator.start = load_balance_start_fair;
 	cfs_rq_iterator.next = load_balance_next_fair;
 
 	for_each_leaf_cfs_rq(busiest, busy_cfs_rq) {
 #ifdef CONFIG_FAIR_GROUP_SCHED
-		struct cfs_rq *this_cfs_rq;
-		long imbalance;
-		unsigned long maxload;
-
-		this_cfs_rq = cpu_cfs_rq(busy_cfs_rq, this_cpu);
-
-		imbalance = busy_cfs_rq->load.weight - this_cfs_rq->load.weight;
-		/* Don't pull if this_cfs_rq has more load than busy_cfs_rq */
-		if (imbalance <= 0)
+		struct cfs_rq *this_cfs_rq = busy_cfs_rq->tg->cfs_rq[this_cpu];
+		unsigned long maxload, task_load, group_weight;
+		unsigned long thisload, per_task_load;
+		struct sched_entity *se = busy_cfs_rq->tg->se[busiest->cpu];
+
+		task_load = busy_cfs_rq->load.weight;
+		group_weight = se->load.weight;
+
+		/*
+ 		 * 'group_weight' is contributed by tasks of total weight
+		 * 'task_load'. To move 'rem_load_move' worth of weight only,
+		 * we need to move a maximum task load of:
+		 *
+		 * 	maxload = (remload / group_weight) * task_load;
+		 */
+		maxload = (rem_load_move * task_load) / group_weight;
+
+		if (!maxload || !task_load)
 			continue;
 
-		/* Don't pull more than imbalance/2 */
-		imbalance /= 2;
-		maxload = min(rem_load_move, imbalance);
+		per_task_load = task_load/busy_cfs_rq->nr_running;
 
-		*this_best_prio = cfs_rq_best_prio(this_cfs_rq);
+		/* balance_tasks will try to forcibly move atleast one task if
+		 * possible (because of SCHED_LOAD_SCALE_FUZZ). Avoid that if
+		 * maxload is less than GROUP_IMBALANCE_FUZZ% the per_task_load.
+		 */
+		 if (100 * maxload < GROUP_IMBALANCE_PCT * per_task_load)
+			continue;
+
+		*this_best_prio = 0;
+		thisload = this_cfs_rq->load.weight;
 #else
 # define maxload rem_load_move
 #endif
@@ -996,11 +1005,31 @@ load_balance_fair(struct rq *this_rq, in
 		 * load_balance_[start|next]_fair iterators
 		 */
 		cfs_rq_iterator.arg = busy_cfs_rq;
-		rem_load_move -= balance_tasks(this_rq, this_cpu, busiest,
+		load_moved = balance_tasks(this_rq, this_cpu, busiest,
 					       maxload, sd, idle, all_pinned,
 					       this_best_prio,
 					       &cfs_rq_iterator);
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
+		/* load_moved holds the task load that was moved. The
+		 * effective weight moved would be:
+		 * 	load_moved_eff = load_moved/task_load * group_weight;
+		 */
+		load_moved = (group_weight * load_moved) / task_load;
+
+		/* Adjust shares on both cpus to reflect load_moved */
+		group_weight -= load_moved;
+		set_se_shares(se, group_weight);
+
+		se = busy_cfs_rq->tg->se[this_cpu];
+		if (!thisload)
+			group_weight = load_moved;
+		else
+			group_weight = se->load.weight + load_moved;
+		set_se_shares(se, group_weight);
+#endif
+
+		rem_load_move -= load_moved;
 		if (rem_load_move <= 0)
 			break;
 	}
Index: current/kernel/sched_rt.c
===================================================================
--- current.orig/kernel/sched_rt.c
+++ current/kernel/sched_rt.c
@@ -31,6 +31,7 @@ static void enqueue_task_rt(struct rq *r
 
 	list_add_tail(&p->run_list, array->queue + p->prio);
 	__set_bit(p->prio, array->bitmap);
+	inc_load(rq, p->se.load.weight);
 }
 
 /*
@@ -45,6 +46,7 @@ static void dequeue_task_rt(struct rq *r
 	list_del(&p->run_list);
 	if (list_empty(array->queue + p->prio))
 		__clear_bit(p->prio, array->bitmap);
+	dec_load(rq, p->se.load.weight);
 }
 
 /*
Index: current/kernel/sysctl.c
===================================================================
--- current.orig/kernel/sysctl.c
+++ current/kernel/sysctl.c
@@ -309,6 +309,22 @@ static struct ctl_table kern_table[] = {
 		.mode		= 644,
 		.proc_handler	= &proc_dointvec,
 	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "sched_min_bal_int_shares",
+		.data		= &sysctl_sched_min_bal_int_shares,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "sched_max_bal_int_shares",
+		.data		= &sysctl_sched_max_bal_int_shares,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
 #endif
 	{
 		.ctl_name	= CTL_UNNUMBERED,





-- 
Regards,
vatsa
