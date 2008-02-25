Return-Path: <linux-kernel-owner+w=401wt.eu-S1757439AbYBYQeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757439AbYBYQeZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 11:34:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754156AbYBYQeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 11:34:16 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:58778 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203AbYBYQeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 11:34:14 -0500
Subject: Re: [PATCH] sched: revert load_balance_monitor()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: vatsa@linux.vnet.ibm.com
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Galbraith <efault@gmx.de>,
       Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20080225160155.GC21903@linux.vnet.ibm.com>
References: <1203942167.6242.142.camel@lappy>
	 <1203949799.4688.9.camel@homer.simson.net>
	 <20080225143518.GA29275@linux.vnet.ibm.com>
	 <1203953282.6242.180.camel@lappy>
	 <20080225160155.GC21903@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Mon, 25 Feb 2008 17:34:02 +0100
Message-Id: <1203957242.6242.197.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-02-25 at 21:31 +0530, Srivatsa Vaddagiri wrote:
> On Mon, Feb 25, 2008 at 04:28:02PM +0100, Peter Zijlstra wrote:
> > Vatsa, would it make sense to take just that out, or just do a full
> > revert?
> 
> Peter,
> 	6b2d7700266b9402e12824e11e0099ae6a4a6a79 and 
> 58e2d4ca581167c2a079f4ee02be2f0bc52e8729 are related very much. The
> later changes how cpu load is calculated for the former to work
> properly.
> 
> I would suggest we do a full revert for now, until the latency issues are sorted
> out.

Builds a kernel..

---

Subject: sched: revert load_balance_monitor()

The following commits causes a number of serious regressions:

  commit 58e2d4ca581167c2a079f4ee02be2f0bc52e8729
  Author: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
  Date:   Fri Jan 25 21:08:00 2008 +0100
  sched: group scheduling, change how cpu load is calculated

  commit 6b2d7700266b9402e12824e11e0099ae6a4a6a79
  Author: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
  Date:   Fri Jan 25 21:08:00 2008 +0100
  sched: group scheduler, fix fairness of cpu bandwidth allocation for task groups

Namely:
 - very frequent wakeups on SMP, reported by PowerTop users.
 - cacheline trashing on (large) SMP
 - some latencies larger than 500ms

While there is a mergeable patch to fix the latter, the former issues
are IMHO not fixable in a manner suitable for .25 (we're at -rc3 now).
Hence I propose to revert this patch and try again for .26.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
---
 include/linux/sched.h |    4 
 kernel/sched.c        |  283 ++++++--------------------------------------------
 kernel/sched_fair.c   |  119 ++++++---------------
 kernel/sched_rt.c     |    4 
 kernel/sysctl.c       |   18 ---
 5 files changed, 72 insertions(+), 356 deletions(-)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -1541,10 +1541,6 @@ extern unsigned int sysctl_sched_child_r
 extern unsigned int sysctl_sched_features;
 extern unsigned int sysctl_sched_migration_cost;
 extern unsigned int sysctl_sched_nr_migrate;
-#if defined(CONFIG_FAIR_GROUP_SCHED) && defined(CONFIG_SMP)
-extern unsigned int sysctl_sched_min_bal_int_shares;
-extern unsigned int sysctl_sched_max_bal_int_shares;
-#endif
 
 int sched_nr_latency_handler(struct ctl_table *table, int write,
 		struct file *file, void __user *buffer, size_t *length,
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -174,41 +174,6 @@ struct task_group {
 	struct sched_entity **se;
 	/* runqueue "owned" by this group on each cpu */
 	struct cfs_rq **cfs_rq;
-
-	/*
-	 * shares assigned to a task group governs how much of cpu bandwidth
-	 * is allocated to the group. The more shares a group has, the more is
-	 * the cpu bandwidth allocated to it.
-	 *
-	 * For ex, lets say that there are three task groups, A, B and C which
-	 * have been assigned shares 1000, 2000 and 3000 respectively. Then,
-	 * cpu bandwidth allocated by the scheduler to task groups A, B and C
-	 * should be:
-	 *
-	 *	Bw(A) = 1000/(1000+2000+3000) * 100 = 16.66%
-	 *	Bw(B) = 2000/(1000+2000+3000) * 100 = 33.33%
-	 *	Bw(C) = 3000/(1000+2000+3000) * 100 = 50%
-	 *
-	 * The weight assigned to a task group's schedulable entities on every
-	 * cpu (task_group.se[a_cpu]->load.weight) is derived from the task
-	 * group's shares. For ex: lets say that task group A has been
-	 * assigned shares of 1000 and there are two CPUs in a system. Then,
-	 *
-	 *  tg_A->se[0]->load.weight = tg_A->se[1]->load.weight = 1000;
-	 *
-	 * Note: It's not necessary that each of a task's group schedulable
-	 *	 entity have the same weight on all CPUs. If the group
-	 *	 has 2 of its tasks on CPU0 and 1 task on CPU1, then a
-	 *	 better distribution of weight could be:
-	 *
-	 *	tg_A->se[0]->load.weight = 2/3 * 2000 = 1333
-	 *	tg_A->se[1]->load.weight = 1/2 * 2000 =  667
-	 *
-	 * rebalance_shares() is responsible for distributing the shares of a
-	 * task groups like this among the group's schedulable entities across
-	 * cpus.
-	 *
-	 */
 	unsigned long shares;
 #endif
 
@@ -250,22 +215,12 @@ static DEFINE_SPINLOCK(task_group_lock);
 static DEFINE_MUTEX(doms_cur_mutex);
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
-#ifdef CONFIG_SMP
-/* kernel thread that runs rebalance_shares() periodically */
-static struct task_struct *lb_monitor_task;
-static int load_balance_monitor(void *unused);
-#endif
-
-static void set_se_shares(struct sched_entity *se, unsigned long shares);
-
 #ifdef CONFIG_USER_SCHED
 # define INIT_TASK_GROUP_LOAD	(2*NICE_0_LOAD)
 #else
 # define INIT_TASK_GROUP_LOAD	NICE_0_LOAD
 #endif
 
-#define MIN_GROUP_SHARES	2
-
 static int init_task_group_load = INIT_TASK_GROUP_LOAD;
 #endif
 
@@ -1241,16 +1196,6 @@ static void cpuacct_charge(struct task_s
 static inline void cpuacct_charge(struct task_struct *tsk, u64 cputime) {}
 #endif
 
-static inline void inc_cpu_load(struct rq *rq, unsigned long load)
-{
-	update_load_add(&rq->load, load);
-}
-
-static inline void dec_cpu_load(struct rq *rq, unsigned long load)
-{
-	update_load_sub(&rq->load, load);
-}
-
 #ifdef CONFIG_SMP
 static unsigned long source_load(int cpu, int type);
 static unsigned long target_load(int cpu, int type);
@@ -1268,14 +1213,26 @@ static int task_hot(struct task_struct *
 
 #define sched_class_highest (&rt_sched_class)
 
-static void inc_nr_running(struct rq *rq)
+static inline void inc_load(struct rq *rq, const struct task_struct *p)
+{
+	update_load_add(&rq->load, p->se.load.weight);
+}
+
+static inline void dec_load(struct rq *rq, const struct task_struct *p)
+{
+	update_load_sub(&rq->load, p->se.load.weight);
+}
+
+static void inc_nr_running(struct task_struct *p, struct rq *rq)
 {
 	rq->nr_running++;
+	inc_load(rq, p);
 }
 
-static void dec_nr_running(struct rq *rq)
+static void dec_nr_running(struct task_struct *p, struct rq *rq)
 {
 	rq->nr_running--;
+	dec_load(rq, p);
 }
 
 static void set_load_weight(struct task_struct *p)
@@ -1367,7 +1324,7 @@ static void activate_task(struct rq *rq,
 		rq->nr_uninterruptible--;
 
 	enqueue_task(rq, p, wakeup);
-	inc_nr_running(rq);
+	inc_nr_running(p, rq);
 }
 
 /*
@@ -1379,7 +1336,7 @@ static void deactivate_task(struct rq *r
 		rq->nr_uninterruptible++;
 
 	dequeue_task(rq, p, sleep);
-	dec_nr_running(rq);
+	dec_nr_running(p, rq);
 }
 
 /**
@@ -2019,7 +1976,7 @@ void wake_up_new_task(struct task_struct
 		 * management (if any):
 		 */
 		p->sched_class->task_new(rq, p);
-		inc_nr_running(rq);
+		inc_nr_running(p, rq);
 	}
 	check_preempt_curr(rq, p);
 #ifdef CONFIG_SMP
@@ -4358,8 +4315,10 @@ void set_user_nice(struct task_struct *p
 		goto out_unlock;
 	}
 	on_rq = p->se.on_rq;
-	if (on_rq)
+	if (on_rq) {
 		dequeue_task(rq, p, 0);
+		dec_load(rq, p);
+	}
 
 	p->static_prio = NICE_TO_PRIO(nice);
 	set_load_weight(p);
@@ -4369,6 +4328,7 @@ void set_user_nice(struct task_struct *p
 
 	if (on_rq) {
 		enqueue_task(rq, p, 0);
+		inc_load(rq, p);
 		/*
 		 * If the task increased its priority or is running and
 		 * lowered its priority, then reschedule its CPU:
@@ -7083,21 +7043,6 @@ void __init sched_init_smp(void)
 	if (set_cpus_allowed(current, non_isolated_cpus) < 0)
 		BUG();
 	sched_init_granularity();
-
-#ifdef CONFIG_FAIR_GROUP_SCHED
-	if (nr_cpu_ids == 1)
-		return;
-
-	lb_monitor_task = kthread_create(load_balance_monitor, NULL,
-					 "group_balance");
-	if (!IS_ERR(lb_monitor_task)) {
-		lb_monitor_task->flags |= PF_NOFREEZE;
-		wake_up_process(lb_monitor_task);
-	} else {
-		printk(KERN_ERR "Could not create load balance monitor thread"
-			"(error = %ld) \n", PTR_ERR(lb_monitor_task));
-	}
-#endif
 }
 #else
 void __init sched_init_smp(void)
@@ -7418,157 +7363,6 @@ void set_curr_task(int cpu, struct task_
 
 #ifdef CONFIG_GROUP_SCHED
 
-#if defined CONFIG_FAIR_GROUP_SCHED && defined CONFIG_SMP
-/*
- * distribute shares of all task groups among their schedulable entities,
- * to reflect load distribution across cpus.
- */
-static int rebalance_shares(struct sched_domain *sd, int this_cpu)
-{
-	struct cfs_rq *cfs_rq;
-	struct rq *rq = cpu_rq(this_cpu);
-	cpumask_t sdspan = sd->span;
-	int balanced = 1;
-
-	/* Walk thr' all the task groups that we have */
-	for_each_leaf_cfs_rq(rq, cfs_rq) {
-		int i;
-		unsigned long total_load = 0, total_shares;
-		struct task_group *tg = cfs_rq->tg;
-
-		/* Gather total task load of this group across cpus */
-		for_each_cpu_mask(i, sdspan)
-			total_load += tg->cfs_rq[i]->load.weight;
-
-		/* Nothing to do if this group has no load */
-		if (!total_load)
-			continue;
-
-		/*
-		 * tg->shares represents the number of cpu shares the task group
-		 * is eligible to hold on a single cpu. On N cpus, it is
-		 * eligible to hold (N * tg->shares) number of cpu shares.
-		 */
-		total_shares = tg->shares * cpus_weight(sdspan);
-
-		/*
-		 * redistribute total_shares across cpus as per the task load
-		 * distribution.
-		 */
-		for_each_cpu_mask(i, sdspan) {
-			unsigned long local_load, local_shares;
-
-			local_load = tg->cfs_rq[i]->load.weight;
-			local_shares = (local_load * total_shares) / total_load;
-			if (!local_shares)
-				local_shares = MIN_GROUP_SHARES;
-			if (local_shares == tg->se[i]->load.weight)
-				continue;
-
-			spin_lock_irq(&cpu_rq(i)->lock);
-			set_se_shares(tg->se[i], local_shares);
-			spin_unlock_irq(&cpu_rq(i)->lock);
-			balanced = 0;
-		}
-	}
-
-	return balanced;
-}
-
-/*
- * How frequently should we rebalance_shares() across cpus?
- *
- * The more frequently we rebalance shares, the more accurate is the fairness
- * of cpu bandwidth distribution between task groups. However higher frequency
- * also implies increased scheduling overhead.
- *
- * sysctl_sched_min_bal_int_shares represents the minimum interval between
- * consecutive calls to rebalance_shares() in the same sched domain.
- *
- * sysctl_sched_max_bal_int_shares represents the maximum interval between
- * consecutive calls to rebalance_shares() in the same sched domain.
- *
- * These settings allows for the appropriate trade-off between accuracy of
- * fairness and the associated overhead.
- *
- */
-
-/* default: 8ms, units: milliseconds */
-const_debug unsigned int sysctl_sched_min_bal_int_shares = 8;
-
-/* default: 128ms, units: milliseconds */
-const_debug unsigned int sysctl_sched_max_bal_int_shares = 128;
-
-/* kernel thread that runs rebalance_shares() periodically */
-static int load_balance_monitor(void *unused)
-{
-	unsigned int timeout = sysctl_sched_min_bal_int_shares;
-	struct sched_param schedparm;
-	int ret;
-
-	/*
-	 * We don't want this thread's execution to be limited by the shares
-	 * assigned to default group (init_task_group). Hence make it run
-	 * as a SCHED_RR RT task at the lowest priority.
-	 */
-	schedparm.sched_priority = 1;
-	ret = sched_setscheduler(current, SCHED_RR, &schedparm);
-	if (ret)
-		printk(KERN_ERR "Couldn't set SCHED_RR policy for load balance"
-				" monitor thread (error = %d) \n", ret);
-
-	while (!kthread_should_stop()) {
-		int i, cpu, balanced = 1;
-
-		/* Prevent cpus going down or coming up */
-		get_online_cpus();
-		/* lockout changes to doms_cur[] array */
-		lock_doms_cur();
-		/*
-		 * Enter a rcu read-side critical section to safely walk rq->sd
-		 * chain on various cpus and to walk task group list
-		 * (rq->leaf_cfs_rq_list) in rebalance_shares().
-		 */
-		rcu_read_lock();
-
-		for (i = 0; i < ndoms_cur; i++) {
-			cpumask_t cpumap = doms_cur[i];
-			struct sched_domain *sd = NULL, *sd_prev = NULL;
-
-			cpu = first_cpu(cpumap);
-
-			/* Find the highest domain at which to balance shares */
-			for_each_domain(cpu, sd) {
-				if (!(sd->flags & SD_LOAD_BALANCE))
-					continue;
-				sd_prev = sd;
-			}
-
-			sd = sd_prev;
-			/* sd == NULL? No load balance reqd in this domain */
-			if (!sd)
-				continue;
-
-			balanced &= rebalance_shares(sd, cpu);
-		}
-
-		rcu_read_unlock();
-
-		unlock_doms_cur();
-		put_online_cpus();
-
-		if (!balanced)
-			timeout = sysctl_sched_min_bal_int_shares;
-		else if (timeout < sysctl_sched_max_bal_int_shares)
-			timeout *= 2;
-
-		msleep_interruptible(timeout);
-	}
-
-	return 0;
-}
-#endif	/* CONFIG_SMP */
-
 #ifdef CONFIG_FAIR_GROUP_SCHED
 static void free_fair_sched_group(struct task_group *tg)
 {
@@ -7835,29 +7629,25 @@ void sched_move_task(struct task_struct 
 }
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
-/* rq->lock to be locked by caller */
 static void set_se_shares(struct sched_entity *se, unsigned long shares)
 {
 	struct cfs_rq *cfs_rq = se->cfs_rq;
 	struct rq *rq = cfs_rq->rq;
 	int on_rq;
 
-	if (!shares)
-		shares = MIN_GROUP_SHARES;
+	spin_lock_irq(&rq->lock);
 
 	on_rq = se->on_rq;
-	if (on_rq) {
+	if (on_rq)
 		dequeue_entity(cfs_rq, se, 0);
-		dec_cpu_load(rq, se->load.weight);
-	}
 
 	se->load.weight = shares;
 	se->load.inv_weight = div64_64((1ULL<<32), shares);
 
-	if (on_rq) {
+	if (on_rq)
 		enqueue_entity(cfs_rq, se, 0);
-		inc_cpu_load(rq, se->load.weight);
-	}
+
+	spin_unlock_irq(&rq->lock);
 }
 
 static DEFINE_MUTEX(shares_mutex);
@@ -7867,18 +7657,18 @@ int sched_group_set_shares(struct task_g
 	int i;
 	unsigned long flags;
 
+	/*
+	 * A weight of 0 or 1 can cause arithmetics problems.
+	 * (The default weight is 1024 - so there's no practical
+	 *  limitation from this.)
+	 */
+	if (shares < 2)
+		shares = 2;
+
 	mutex_lock(&shares_mutex);
 	if (tg->shares == shares)
 		goto done;
 
-	if (shares < MIN_GROUP_SHARES)
-		shares = MIN_GROUP_SHARES;
-
-	/*
-	 * Prevent any load balance activity (rebalance_shares,
-	 * load_balance_fair) from referring to this group first,
-	 * by taking it off the rq->leaf_cfs_rq_list on each cpu.
-	 */
 	spin_lock_irqsave(&task_group_lock, flags);
 	for_each_possible_cpu(i)
 		unregister_fair_sched_group(tg, i);
@@ -7892,11 +7682,8 @@ int sched_group_set_shares(struct task_g
 	 * w/o tripping rebalance_share or load_balance_fair.
 	 */
 	tg->shares = shares;
-	for_each_possible_cpu(i) {
-		spin_lock_irq(&cpu_rq(i)->lock);
+	for_each_possible_cpu(i)
 		set_se_shares(tg->se[i], shares);
-		spin_unlock_irq(&cpu_rq(i)->lock);
-	}
 
 	/*
 	 * Enable load balance activity on this group, by inserting it back on
Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -732,8 +732,6 @@ static inline struct sched_entity *paren
 	return se->parent;
 }
 
-#define GROUP_IMBALANCE_PCT	20
-
 #else	/* CONFIG_FAIR_GROUP_SCHED */
 
 #define for_each_sched_entity(se) \
@@ -824,26 +822,15 @@ hrtick_start_fair(struct rq *rq, struct 
 static void enqueue_task_fair(struct rq *rq, struct task_struct *p, int wakeup)
 {
 	struct cfs_rq *cfs_rq;
-	struct sched_entity *se = &p->se,
-			    *topse = NULL;	/* Highest schedulable entity */
-	int incload = 1;
+	struct sched_entity *se = &p->se;
 
 	for_each_sched_entity(se) {
-		topse = se;
-		if (se->on_rq) {
-			incload = 0;
+		if (se->on_rq)
 			break;
-		}
 		cfs_rq = cfs_rq_of(se);
 		enqueue_entity(cfs_rq, se, wakeup);
 		wakeup = 1;
 	}
-	/* Increment cpu load if we just enqueued the first task of a group on
-	 * 'rq->cpu'. 'topse' represents the group to which task 'p' belongs
-	 * at the highest grouping level.
-	 */
-	if (incload)
-		inc_cpu_load(rq, topse->load.weight);
 
 	hrtick_start_fair(rq, rq->curr);
 }
@@ -856,28 +843,16 @@ static void enqueue_task_fair(struct rq 
 static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int sleep)
 {
 	struct cfs_rq *cfs_rq;
-	struct sched_entity *se = &p->se,
-			    *topse = NULL; 	/* Highest schedulable entity */
-	int decload = 1;
+	struct sched_entity *se = &p->se;
 
 	for_each_sched_entity(se) {
-		topse = se;
 		cfs_rq = cfs_rq_of(se);
 		dequeue_entity(cfs_rq, se, sleep);
 		/* Don't dequeue parent if it has other entities besides us */
-		if (cfs_rq->load.weight) {
-			if (parent_entity(se))
-				decload = 0;
+		if (cfs_rq->load.weight)
 			break;
-		}
 		sleep = 1;
 	}
-	/* Decrement cpu load if we just dequeued the last task of a group on
-	 * 'rq->cpu'. 'topse' represents the group to which task 'p' belongs
-	 * at the highest grouping level.
-	 */
-	if (decload)
-		dec_cpu_load(rq, topse->load.weight);
 
 	hrtick_start_fair(rq, rq->curr);
 }
@@ -1191,6 +1166,25 @@ static struct task_struct *load_balance_
 	return __load_balance_iterator(cfs_rq, cfs_rq->rb_load_balance_curr);
 }
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
+static int cfs_rq_best_prio(struct cfs_rq *cfs_rq)
+{
+	struct sched_entity *curr;
+	struct task_struct *p;
+
+	if (!cfs_rq->nr_running)
+		return MAX_PRIO;
+
+	curr = cfs_rq->curr;
+	if (!curr)
+		curr = __pick_next_entity(cfs_rq);
+
+	p = task_of(curr);
+
+	return p->prio;
+}
+#endif
+
 static unsigned long
 load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		  unsigned long max_load_move,
@@ -1200,45 +1194,28 @@ load_balance_fair(struct rq *this_rq, in
 	struct cfs_rq *busy_cfs_rq;
 	long rem_load_move = max_load_move;
 	struct rq_iterator cfs_rq_iterator;
-	unsigned long load_moved;
 
 	cfs_rq_iterator.start = load_balance_start_fair;
 	cfs_rq_iterator.next = load_balance_next_fair;
 
 	for_each_leaf_cfs_rq(busiest, busy_cfs_rq) {
 #ifdef CONFIG_FAIR_GROUP_SCHED
-		struct cfs_rq *this_cfs_rq = busy_cfs_rq->tg->cfs_rq[this_cpu];
-		unsigned long maxload, task_load, group_weight;
-		unsigned long thisload, per_task_load;
-		struct sched_entity *se = busy_cfs_rq->tg->se[busiest->cpu];
-
-		task_load = busy_cfs_rq->load.weight;
-		group_weight = se->load.weight;
-
-		/*
-		 * 'group_weight' is contributed by tasks of total weight
-		 * 'task_load'. To move 'rem_load_move' worth of weight only,
-		 * we need to move a maximum task load of:
-		 *
-		 * 	maxload = (remload / group_weight) * task_load;
-		 */
-		maxload = (rem_load_move * task_load) / group_weight;
-
-		if (!maxload || !task_load)
+		struct cfs_rq *this_cfs_rq;
+		long imbalance;
+		unsigned long maxload;
+
+		this_cfs_rq = cpu_cfs_rq(busy_cfs_rq, this_cpu);
+
+		imbalance = busy_cfs_rq->load.weight - this_cfs_rq->load.weight;
+		/* Don't pull if this_cfs_rq has more load than busy_cfs_rq */
+		if (imbalance <= 0)
 			continue;
 
-		per_task_load = task_load / busy_cfs_rq->nr_running;
-		/*
-		 * balance_tasks will try to forcibly move atleast one task if
-		 * possible (because of SCHED_LOAD_SCALE_FUZZ). Avoid that if
-		 * maxload is less than GROUP_IMBALANCE_FUZZ% the per_task_load.
-		 */
-		 if (100 * maxload < GROUP_IMBALANCE_PCT * per_task_load)
-			continue;
+		/* Don't pull more than imbalance/2 */
+		imbalance /= 2;
+		maxload = min(rem_load_move, imbalance);
 
-		/* Disable priority-based load balance */
-		*this_best_prio = 0;
-		thisload = this_cfs_rq->load.weight;
+		*this_best_prio = cfs_rq_best_prio(this_cfs_rq);
 #else
 # define maxload rem_load_move
 #endif
@@ -1247,33 +1224,11 @@ load_balance_fair(struct rq *this_rq, in
 		 * load_balance_[start|next]_fair iterators
 		 */
 		cfs_rq_iterator.arg = busy_cfs_rq;
-		load_moved = balance_tasks(this_rq, this_cpu, busiest,
+		rem_load_move -= balance_tasks(this_rq, this_cpu, busiest,
 					       maxload, sd, idle, all_pinned,
 					       this_best_prio,
 					       &cfs_rq_iterator);
 
-#ifdef CONFIG_FAIR_GROUP_SCHED
-		/*
-		 * load_moved holds the task load that was moved. The
-		 * effective (group) weight moved would be:
-		 * 	load_moved_eff = load_moved/task_load * group_weight;
-		 */
-		load_moved = (group_weight * load_moved) / task_load;
-
-		/* Adjust shares on both cpus to reflect load_moved */
-		group_weight -= load_moved;
-		set_se_shares(se, group_weight);
-
-		se = busy_cfs_rq->tg->se[this_cpu];
-		if (!thisload)
-			group_weight = load_moved;
-		else
-			group_weight = se->load.weight + load_moved;
-		set_se_shares(se, group_weight);
-#endif
-
-		rem_load_move -= load_moved;
-
 		if (rem_load_move <= 0)
 			break;
 	}
Index: linux-2.6/kernel/sysctl.c
===================================================================
--- linux-2.6.orig/kernel/sysctl.c
+++ linux-2.6/kernel/sysctl.c
@@ -311,24 +311,6 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
 	},
-#if defined(CONFIG_FAIR_GROUP_SCHED) && defined(CONFIG_SMP)
-	{
-		.ctl_name       = CTL_UNNUMBERED,
-		.procname       = "sched_min_bal_int_shares",
-		.data           = &sysctl_sched_min_bal_int_shares,
-		.maxlen         = sizeof(unsigned int),
-		.mode           = 0644,
-		.proc_handler   = &proc_dointvec,
-	},
-	{
-		.ctl_name       = CTL_UNNUMBERED,
-		.procname       = "sched_max_bal_int_shares",
-		.data           = &sysctl_sched_max_bal_int_shares,
-		.maxlen         = sizeof(unsigned int),
-		.mode           = 0644,
-		.proc_handler   = &proc_dointvec,
-	},
-#endif
 #endif
 	{
 		.ctl_name	= CTL_UNNUMBERED,
Index: linux-2.6/kernel/sched_rt.c
===================================================================
--- linux-2.6.orig/kernel/sched_rt.c
+++ linux-2.6/kernel/sched_rt.c
@@ -393,8 +393,6 @@ static void enqueue_task_rt(struct rq *r
 	 */
 	for_each_sched_rt_entity(rt_se)
 		enqueue_rt_entity(rt_se);
-
-	inc_cpu_load(rq, p->se.load.weight);
 }
 
 static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int sleep)
@@ -414,8 +412,6 @@ static void dequeue_task_rt(struct rq *r
 		if (rt_rq && rt_rq->rt_nr_running)
 			enqueue_rt_entity(rt_se);
 	}
-
-	dec_cpu_load(rq, p->se.load.weight);
 }
 
 /*


