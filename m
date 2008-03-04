Return-Path: <linux-kernel-owner+w=401wt.eu-S1763969AbYCDRIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763969AbYCDRIJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 12:08:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757177AbYCDRHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 12:07:55 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42676 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756249AbYCDRHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 12:07:54 -0500
Date: Tue, 4 Mar 2008 18:07:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] scheduler fixes
Message-ID: <20080304170744.GA18626@elte.hu>
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

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-devel.git for-linus

Thanks,

	Ingo

------------------>
Peter Zijlstra (1):
      sched: revert load_balance_monitor() changes

 include/linux/sched.h |    4 -
 kernel/sched.c        |  283 ++++++-------------------------------------------
 kernel/sched_fair.c   |  115 ++++++--------------
 kernel/sched_rt.c     |    4 -
 kernel/sysctl.c       |   18 ---
 5 files changed, 70 insertions(+), 354 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 2c9621f..9ae4030 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1542,10 +1542,6 @@ extern unsigned int sysctl_sched_child_runs_first;
 extern unsigned int sysctl_sched_features;
 extern unsigned int sysctl_sched_migration_cost;
 extern unsigned int sysctl_sched_nr_migrate;
-#if defined(CONFIG_FAIR_GROUP_SCHED) && defined(CONFIG_SMP)
-extern unsigned int sysctl_sched_min_bal_int_shares;
-extern unsigned int sysctl_sched_max_bal_int_shares;
-#endif
 
 int sched_nr_latency_handler(struct ctl_table *table, int write,
 		struct file *file, void __user *buffer, size_t *length,
diff --git a/kernel/sched.c b/kernel/sched.c
index f06950c..dcd553c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
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
 
@@ -1245,16 +1200,6 @@ static void cpuacct_charge(struct task_struct *tsk, u64 cputime);
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
@@ -1272,14 +1217,26 @@ static int task_hot(struct task_struct *p, u64 now, struct sched_domain *sd);
 
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
@@ -1371,7 +1328,7 @@ static void activate_task(struct rq *rq, struct task_struct *p, int wakeup)
 		rq->nr_uninterruptible--;
 
 	enqueue_task(rq, p, wakeup);
-	inc_nr_running(rq);
+	inc_nr_running(p, rq);
 }
 
 /*
@@ -1383,7 +1340,7 @@ static void deactivate_task(struct rq *rq, struct task_struct *p, int sleep)
 		rq->nr_uninterruptible++;
 
 	dequeue_task(rq, p, sleep);
-	dec_nr_running(rq);
+	dec_nr_running(p, rq);
 }
 
 /**
@@ -2023,7 +1980,7 @@ void wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
 		 * management (if any):
 		 */
 		p->sched_class->task_new(rq, p);
-		inc_nr_running(rq);
+		inc_nr_running(p, rq);
 	}
 	check_preempt_curr(rq, p);
 #ifdef CONFIG_SMP
@@ -4362,8 +4319,10 @@ void set_user_nice(struct task_struct *p, long nice)
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
@@ -4373,6 +4332,7 @@ void set_user_nice(struct task_struct *p, long nice)
 
 	if (on_rq) {
 		enqueue_task(rq, p, 0);
+		inc_load(rq, p);
 		/*
 		 * If the task increased its priority or is running and
 		 * lowered its priority, then reschedule its CPU:
@@ -7087,21 +7047,6 @@ void __init sched_init_smp(void)
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
@@ -7424,157 +7369,6 @@ void set_curr_task(int cpu, struct task_struct *p)
 
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
@@ -7841,29 +7635,25 @@ void sched_move_task(struct task_struct *tsk)
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
@@ -7873,18 +7663,18 @@ int sched_group_set_shares(struct task_group *tg, unsigned long shares)
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
@@ -7898,11 +7688,8 @@ int sched_group_set_shares(struct task_group *tg, unsigned long shares)
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
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index c8e6492..3df4d46 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -727,8 +727,6 @@ static inline struct sched_entity *parent_entity(struct sched_entity *se)
 	return se->parent;
 }
 
-#define GROUP_IMBALANCE_PCT	20
-
 #else	/* CONFIG_FAIR_GROUP_SCHED */
 
 #define for_each_sched_entity(se) \
@@ -819,26 +817,15 @@ hrtick_start_fair(struct rq *rq, struct task_struct *p)
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
@@ -851,28 +838,16 @@ static void enqueue_task_fair(struct rq *rq, struct task_struct *p, int wakeup)
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
@@ -1186,6 +1161,25 @@ static struct task_struct *load_balance_next_fair(void *arg)
 	return __load_balance_iterator(cfs_rq, cfs_rq->rb_load_balance_curr);
 }
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
+static int cfs_rq_best_prio(struct cfs_rq *cfs_rq)
+{
+	struct sched_entity *curr;
+	struct task_struct *p;
+
+	if (!cfs_rq->nr_running || !first_fair(cfs_rq))
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
@@ -1195,45 +1189,28 @@ load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
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
+		struct cfs_rq *this_cfs_rq;
+		long imbalance;
+		unsigned long maxload;
 
-		/*
-		 * 'group_weight' is contributed by tasks of total weight
-		 * 'task_load'. To move 'rem_load_move' worth of weight only,
-		 * we need to move a maximum task load of:
-		 *
-		 * 	maxload = (remload / group_weight) * task_load;
-		 */
-		maxload = (rem_load_move * task_load) / group_weight;
+		this_cfs_rq = cpu_cfs_rq(busy_cfs_rq, this_cpu);
 
-		if (!maxload || !task_load)
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
@@ -1242,33 +1219,11 @@ load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
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
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index f54792b..76e8285 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -393,8 +393,6 @@ static void enqueue_task_rt(struct rq *rq, struct task_struct *p, int wakeup)
 	 */
 	for_each_sched_rt_entity(rt_se)
 		enqueue_rt_entity(rt_se);
-
-	inc_cpu_load(rq, p->se.load.weight);
 }
 
 static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int sleep)
@@ -414,8 +412,6 @@ static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int sleep)
 		if (rt_rq && rt_rq->rt_nr_running)
 			enqueue_rt_entity(rt_se);
 	}
-
-	dec_cpu_load(rq, p->se.load.weight);
 }
 
 /*
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 8b7e954..b2a2d68 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
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
