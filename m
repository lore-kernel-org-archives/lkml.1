Return-Path: <linux-kernel-owner+w=401wt.eu-S1755155AbXK0FPM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155AbXK0FPM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 00:15:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751062AbXK0FPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 00:15:00 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:41955 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750902AbXK0FO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 00:14:58 -0500
Date: Tue, 27 Nov 2007 10:57:46 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: dmitry.adamushko@gmail.com, a.p.zijlstra@chello.nl,
       dhaval@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, efault@gmx.de,
       skumar@linux.vnet.ibm.com, Balbir Singh <balbir@in.ibm.com>,
       Dipankar <dipankar@in.ibm.com>
Subject: [Patch 5/5] sched: Improve fairness of cpu bandwidth allocation for task groups
Message-ID: <20071127052746.GG20083@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20071119123051.GC28777@linux.vnet.ibm.com> <20071119131201.GB31491@elte.hu> <20071119150312.GA2365@linux.vnet.ibm.com> <20071119152258.GB31426@elte.hu> <20071119160647.GV3359@linux.vnet.ibm.com> <20071119190057.GA12650@elte.hu> <20071126050044.GA5304@linux.vnet.ibm.com> <20071126050905.GF5304@linux.vnet.ibm.com> <20071126202836.GA17012@elte.hu> <20071127050652.GA20083@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071127050652.GA20083@linux.vnet.ibm.com>
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

--------------------------------------------------------------------------------
Col1  | Col2    | Col3  |  Col4
------|---------|-------|-------------------------------------------------------
a     | 277.676 | 57.8% | 54.1%  54.1%  54.1%  54.2%  56.7%  62.2%  62.8% 64.5%
b     | 116.108 | 24.2% | 47.4%  48.1%  48.7%  49.3%
c     |  86.326 | 18.0% | 47.5%  47.9%  48.5%
--------------------------------------------------------------------------------

Explanation of o/p:

Col1 -> Group name
Col2 -> Cumulative execution time (in seconds) received by all tasks of that 
	group in a 60sec window across 8 cpus
Col3 -> CPU bandwidth received by the group in the 60sec window, expressed in 
        percentage. Col3 data is derived as:
		Col3 = 100 * Col2 / (NR_CPUS * 60)
Col4 -> CPU bandwidth received by each individual task of the group.
		Col4 = 100 * cpu_time_recd_by_task / 60

[I can share the test case that produces a similar o/p if reqd]

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

Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>

---
 include/linux/sched.h |    4 
 kernel/sched.c        |  259 ++++++++++++++++++++++++++++++++++++++++++++++++--
 kernel/sched_fair.c   |   88 ++++++++++------
 kernel/sysctl.c       |   18 +++
 4 files changed, 330 insertions(+), 39 deletions(-)

Index: current/include/linux/sched.h
===================================================================
--- current.orig/include/linux/sched.h
+++ current/include/linux/sched.h
@@ -1467,6 +1467,10 @@ extern unsigned int sysctl_sched_child_r
 extern unsigned int sysctl_sched_features;
 extern unsigned int sysctl_sched_migration_cost;
 extern unsigned int sysctl_sched_nr_migrate;
+#if defined(CONFIG_FAIR_GROUP_SCHED) && defined(CONFIG_SMP)
+extern unsigned int sysctl_sched_min_bal_int_shares;
+extern unsigned int sysctl_sched_max_bal_int_shares;
+#endif
 
 int sched_nr_latency_handler(struct ctl_table *table, int write,
 		struct file *file, void __user *buffer, size_t *length,
Index: current/kernel/sched.c
===================================================================
--- current.orig/kernel/sched.c
+++ current/kernel/sched.c
@@ -168,7 +168,43 @@ struct task_group {
 	struct sched_entity **se;
 	/* runqueue "owned" by this group on each cpu */
 	struct cfs_rq **cfs_rq;
+
+	/*
+	 * shares assigned to a task group governs how much of cpu bandwidth
+	 * is allocated to the group. The more shares a group has, the more is
+	 * the cpu bandwidth allocated to it.
+	 *
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
+	 * Note: It's not necessary that each of a task's group schedulable
+	 * 	 entity have the same weight on all CPUs. If the group
+	 * 	 has 2 of its tasks on CPU0 and 1 task on CPU1, then a
+	 * 	 better distribution of weight could be:
+	 *
+	 *	tg_A->se[0]->load.weight = 2/3 * 2000 = 1333
+	 *	tg_A->se[1]->load.weight = 1/2 * 2000 =  667
+	 *
+	 * rebalance_shares() is responsible for distributing the shares of a
+	 * task groups like this among the group's schedulable entities across
+	 * cpus.
+	 *
+	 */
 	unsigned long shares;
+
 	struct rcu_head rcu;
 };
 
@@ -189,6 +225,14 @@ static DEFINE_MUTEX(task_group_mutex);
 /* doms_cur_mutex serializes access to doms_cur[] array */
 static DEFINE_MUTEX(doms_cur_mutex);
 
+#ifdef CONFIG_SMP
+/* kernel thread that runs rebalance_shares() periodically */
+static struct task_struct *lb_monitor_task;
+static int load_balance_monitor(void *unused);
+#endif
+
+static void set_se_shares(struct sched_entity *se, unsigned long shares);
+
 /* Default task group.
  *	Every task in system belong to this group at bootup.
  */
@@ -203,6 +247,8 @@ struct task_group init_task_group = {
 # define INIT_TASK_GROUP_LOAD	NICE_0_LOAD
 #endif
 
+#define MIN_GROUP_SHARES       1
+
 static int init_task_group_load = INIT_TASK_GROUP_LOAD;
 
 /* return group to which a task belongs */
@@ -6740,6 +6786,18 @@ void __init sched_init_smp(void)
 	if (set_cpus_allowed(current, non_isolated_cpus) < 0)
 		BUG();
 	sched_init_granularity();
+
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	lb_monitor_task = kthread_create(load_balance_monitor, NULL,
+					 "load_balance_monitor");
+	if (!IS_ERR(lb_monitor_task)) {
+		lb_monitor_task->flags |= PF_NOFREEZE;
+		wake_up_process(lb_monitor_task);
+	} else {
+		printk(KERN_ERR "Could not create load balance monitor thread"
+			"(error = %ld) \n", PTR_ERR(lb_monitor_task));
+	}
+#endif
 }
 #else
 void __init sched_init_smp(void)
@@ -6995,6 +7053,157 @@ void set_curr_task(int cpu, struct task_
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 
+#ifdef CONFIG_SMP
+/*
+ * distribute shares of all task groups among their schedulable entities,
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
+		/* Nothing to do if this group has no load  */
+		if (!total_load)
+			continue;
+
+		/*
+		 * tg->shares represents the number of cpu shares the task group
+		 * is eligible to hold on a single cpu. On N cpus, it is
+		 * eligible to hold (N * tg->shares) number of cpu shares.
+		 */
+		total_shares = tg->shares * cpus_weight(sdspan);
+
+		/*
+		 * redistribute total_shares across cpus as per the task load
+		 * distribution.
+		 */
+		for_each_cpu_mask(i, sdspan) {
+			unsigned long local_load, local_shares;
+
+			local_load = tg->cfs_rq[i]->load.weight;
+			local_shares = (local_load * total_shares) / total_load;
+			if (!local_shares)
+				local_shares = MIN_GROUP_SHARES;
+			if (local_shares == tg->se[i]->load.weight)
+				continue;
+
+			spin_lock_irq(&cpu_rq(i)->lock);
+			set_se_shares(tg->se[i], local_shares);
+			spin_unlock_irq(&cpu_rq(i)->lock);
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
+/* kernel thread that runs rebalance_shares() periodically */
+static int load_balance_monitor(void *unused)
+{
+	unsigned int timeout = sysctl_sched_min_bal_int_shares;
+	struct sched_param schedparm;
+	int ret;
+
+	/*
+	 * We don't want this thread's execution to be limited by the shares
+	 * assigned to default group (init_task_group). Hence make it run
+	 * as a SCHED_RR RT task at the lowest priority.
+	 */
+	schedparm.sched_priority = 1;
+	ret = sched_setscheduler(current, SCHED_RR, &schedparm);
+	if (ret)
+		printk(KERN_ERR "Couldn't set SCHED_RR policy for load balance"
+				" monitor thread (error = %d) \n", ret);
+
+	while (!kthread_should_stop()) {
+		int i, cpu, balanced = 1;
+
+		/* Prevent cpus going down or coming up */
+		lock_cpu_hotplug();
+		/* lockout changes to doms_cur[] array */
+		lock_doms_cur();
+		/*
+		 * Enter a rcu read-side critical section to safely walk rq->sd
+		 * chain on various cpus and to walk task group list
+		 * (rq->leaf_cfs_rq_list) in rebalance_shares().
+		 */
+		rcu_read_lock();
+
+		for (i = 0; i < ndoms_cur; i++) {
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
+		msleep_interruptible(timeout);
+	}
+
+	return 0;
+}
+#endif	/* CONFIG_SMP */
+
 /* allocate runqueue etc for a new task group */
 struct task_group *sched_create_group(void)
 {
@@ -7151,39 +7360,77 @@ done:
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
+		dec_cpu_load(rq, se->load.weight);
+	}
 
 	se->load.weight = shares;
 	se->load.inv_weight = div64_64((1ULL<<32), shares);
 
-	if (on_rq)
+	if (on_rq) {
 		enqueue_entity(cfs_rq, se, 0);
-
-	spin_unlock_irq(&rq->lock);
+		inc_cpu_load(rq, se->load.weight);
+	}
 }
 
 int sched_group_set_shares(struct task_group *tg, unsigned long shares)
 {
 	int i;
+	struct cfs_rq *cfs_rq;
+	struct rq *rq;
 
 	lock_task_group_list();
 	if (tg->shares == shares)
 		goto done;
 
+	if (shares < MIN_GROUP_SHARES)
+		shares = MIN_GROUP_SHARES;
+
+	/*
+	 * Prevent any load balance activity (rebalance_shares,
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
+	/*
+	 * Now we are free to modify the group's share on each cpu
+	 * w/o tripping rebalance_share or load_balance_fair.
+	 */
 	tg->shares = shares;
-	for_each_possible_cpu(i)
+	for_each_possible_cpu(i) {
+		spin_lock_irq(&cpu_rq(i)->lock);
 		set_se_shares(tg->se[i], shares);
+		spin_unlock_irq(&cpu_rq(i)->lock);
+	}
 
+	/*
+	 * Enable load balance activity on this group, by inserting it back on
+	 * each cpu's rq->leaf_cfs_rq_list.
+	 */
+	for_each_possible_cpu(i) {
+		rq = cpu_rq(i);
+		cfs_rq = tg->cfs_rq[i];
+		list_add_rcu(&cfs_rq->leaf_cfs_rq_list, &rq->leaf_cfs_rq_list);
+	}
 done:
 	unlock_task_group_list();
 	return 0;
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
@@ -961,25 +963,6 @@ static struct task_struct *load_balance_
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
@@ -989,28 +972,45 @@ load_balance_fair(struct rq *this_rq, in
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
+		 * 'group_weight' is contributed by tasks of total weight
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
+		per_task_load = task_load / busy_cfs_rq->nr_running;
+		/*
+		 * balance_tasks will try to forcibly move atleast one task if
+		 * possible (because of SCHED_LOAD_SCALE_FUZZ). Avoid that if
+		 * maxload is less than GROUP_IMBALANCE_FUZZ% the per_task_load.
+		 */
+		 if (100 * maxload < GROUP_IMBALANCE_PCT * per_task_load)
+			continue;
 
-		*this_best_prio = cfs_rq_best_prio(this_cfs_rq);
+		/* Disable priority-based load balance */
+		*this_best_prio = 0;
+		thisload = this_cfs_rq->load.weight;
 #else
 # define maxload rem_load_move
 #endif
@@ -1019,11 +1019,33 @@ load_balance_fair(struct rq *this_rq, in
 		 * load_balance_[start|next]_fair iterators
 		 */
 		cfs_rq_iterator.arg = busy_cfs_rq;
-		rem_load_move -= balance_tasks(this_rq, this_cpu, busiest,
+		load_moved = balance_tasks(this_rq, this_cpu, busiest,
 					       maxload, sd, idle, all_pinned,
 					       this_best_prio,
 					       &cfs_rq_iterator);
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
+		/*
+		 * load_moved holds the task load that was moved. The
+		 * effective (group) weight moved would be:
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
+
 		if (rem_load_move <= 0)
 			break;
 	}
Index: current/kernel/sysctl.c
===================================================================
--- current.orig/kernel/sysctl.c
+++ current/kernel/sysctl.c
@@ -309,6 +309,24 @@ static struct ctl_table kern_table[] = {
 		.mode		= 644,
 		.proc_handler	= &proc_dointvec,
 	},
+#if defined(CONFIG_FAIR_GROUP_SCHED) && defined(CONFIG_SMP)
+	{
+		.ctl_name       = CTL_UNNUMBERED,
+		.procname       = "sched_min_bal_int_shares",
+		.data           = &sysctl_sched_min_bal_int_shares,
+		.maxlen         = sizeof(unsigned int),
+		.mode           = 0644,
+		.proc_handler   = &proc_dointvec,
+	},
+	{
+		.ctl_name       = CTL_UNNUMBERED,
+		.procname       = "sched_max_bal_int_shares",
+		.data           = &sysctl_sched_max_bal_int_shares,
+		.maxlen         = sizeof(unsigned int),
+		.mode           = 0644,
+		.proc_handler   = &proc_dointvec,
+	},
+#endif
 #endif
 	{
 		.ctl_name	= CTL_UNNUMBERED,

-- 
Regards,
vatsa
