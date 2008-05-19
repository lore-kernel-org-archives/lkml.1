Return-Path: <linux-kernel-owner+w=401wt.eu-S1756210AbYESF4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210AbYESF4S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 01:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752870AbYESF4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 01:56:04 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39337 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669AbYESFz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 01:55:59 -0400
Subject: Re: [Bug #10638] sysbench+mysql(oltp, readonly) 30% regression
	with 2.6.26-rc1
From: Peter Zijlstra <peterz@infradead.org>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1211160283.3177.134.camel@ymzhang>
References: <oKKSi1w1qaF.A.mEG.JrBMIB@albercik>
	 <7wuznNhcUqC.A.IMB.TtBMIB@albercik>
	 <1211131278.6463.7.camel@lappy.programming.kicks-ass.net>
	 <1211135856.6463.22.camel@lappy.programming.kicks-ass.net>
	 <1211160283.3177.134.camel@ymzhang>
Content-Type: text/plain
Date: Mon, 19 May 2008 07:55:40 +0200
Message-Id: <1211176540.8292.3.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-05-19 at 09:24 +0800, Zhang, Yanmin wrote:
> On Sun, 2008-05-18 at 20:37 +0200, Peter Zijlstra wrote:
> > On Sun, 2008-05-18 at 19:21 +0200, Peter Zijlstra wrote:
> > > On Sun, 2008-05-18 at 13:13 +0200, Rafael J. Wysocki wrote:
> > > > This message has been generated automatically as a part of a report
> > > > of recent regressions.
> > > > 
> > > > The following bug entry is on the current list of known regressions
> > > > from 2.6.25.  Please verify if it still should be listed.
> > > > 
> > > > 
> > > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10638
> > > > Subject		: sysbench+mysql(oltp, readonly) 30% regression with 2.6.26-rc1
> > > > Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
> > > > Date		: 2008-05-07 4:55 (12 days old)
> > > > References	: http://marc.info/?l=linux-kernel&m=121013681527052&w=2
> > > > Handled-By	: Ingo Molnar <mingo@elte.hu>
> > > > Patch		: http://marc.info/?l=linux-kernel&m=121015292616802&w=2
> > > > 
> > > > 
> > > 
> > > Could people test this:
> > > 
> > > git://git.kernel.org/home/peterz/git/linux-2.6-sched.git/ v2.6.26-rc2-group-load-balance
> > 
> > Seems I got my own url wrong - the right one is:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-sched.git v2.6.26-rc2-group-load-balance
> I used below command to clone your tree:
> RSYNC_PROXY=proxy.sc.intel.com:911 git clone rsync://rsync.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-sched.git linux-2.6-sched
> 
> Got below errors:
> @ERROR: Unknown module 'home'
> rsync: connection unexpectedly closed (0 bytes received so far) [receiver]
> rsync error: error in rsync protocol data stream (code 12) at io.c(359)
> fatal: failed to unpack tree object HEAD
> 
> 
> Would you like to create a patch against 2.6.26-rc3?

Index: linux-2.6/kernel/sched_clock.c
===================================================================
--- linux-2.6.orig/kernel/sched_clock.c
+++ linux-2.6/kernel/sched_clock.c
@@ -59,22 +59,26 @@ static inline struct sched_clock_data *c
 	return &per_cpu(sched_clock_data, cpu);
 }
 
+static __read_mostly int sched_clock_running;
+
 void sched_clock_init(void)
 {
 	u64 ktime_now = ktime_to_ns(ktime_get());
-	u64 now = 0;
+	unsigned long now_jiffies = jiffies;
 	int cpu;
 
 	for_each_possible_cpu(cpu) {
 		struct sched_clock_data *scd = cpu_sdc(cpu);
 
 		scd->lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
-		scd->prev_jiffies = jiffies;
-		scd->prev_raw = now;
-		scd->tick_raw = now;
+		scd->prev_jiffies = now_jiffies;
+		scd->prev_raw = 0;
+		scd->tick_raw = 0;
 		scd->tick_gtod = ktime_now;
 		scd->clock = ktime_now;
 	}
+
+	sched_clock_running = 1;
 }
 
 /*
@@ -136,6 +140,9 @@ u64 sched_clock_cpu(int cpu)
 	struct sched_clock_data *scd = cpu_sdc(cpu);
 	u64 now, clock;
 
+	if (unlikely(!sched_clock_running))
+		return 0ull;
+
 	WARN_ON_ONCE(!irqs_disabled());
 	now = sched_clock();
 
@@ -174,6 +181,9 @@ void sched_clock_tick(void)
 	struct sched_clock_data *scd = this_scd();
 	u64 now, now_gtod;
 
+	if (unlikely(!sched_clock_running))
+		return;
+
 	WARN_ON_ONCE(!irqs_disabled());
 
 	now = sched_clock();
@@ -234,3 +244,15 @@ unsigned long long __attribute__((weak))
 {
 	return (unsigned long long)jiffies * (NSEC_PER_SEC / HZ);
 }
+
+unsigned long long cpu_clock(int cpu)
+{
+	unsigned long long clock;
+	unsigned long flags;
+
+	raw_local_irq_save(flags);
+	clock = sched_clock_cpu(cpu);
+	raw_local_irq_restore(flags);
+
+	return clock;
+}
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -766,7 +766,6 @@ struct sched_domain {
 	struct sched_domain *child;	/* bottom domain must be null terminated */
 	struct sched_group *groups;	/* the balancing groups of the domain */
 	cpumask_t span;			/* span of all CPUs in this domain */
-	int first_cpu;			/* cache of the first cpu in this domain */
 	unsigned long min_interval;	/* Minimum balance interval ms */
 	unsigned long max_interval;	/* Maximum balance interval ms */
 	unsigned int busy_factor;	/* less balancing by factor if busy */
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -370,6 +370,7 @@ struct cfs_rq {
 
 	u64 exec_clock;
 	u64 min_vruntime;
+	u64 pair_start;
 
 	struct rb_root tasks_timeline;
 	struct rb_node *rb_leftmost;
@@ -400,40 +401,23 @@ struct cfs_rq {
 	struct task_group *tg;	/* group that "owns" this runqueue */
 
 #ifdef CONFIG_SMP
-	unsigned long task_weight;
-	unsigned long shares;
 	/*
-	 * We need space to build a sched_domain wide view of the full task
-	 * group tree, in order to avoid depending on dynamic memory allocation
-	 * during the load balancing we place this in the per cpu task group
-	 * hierarchy. This limits the load balancing to one instance per cpu,
-	 * but more should not be needed anyway.
+	 * the part of load.weight contributed by tasks
 	 */
-	struct aggregate_struct {
-		/*
-		 *   load = weight(cpus) * f(tg)
-		 *
-		 * Where f(tg) is the recursive weight fraction assigned to
-		 * this group.
-		 */
-		unsigned long load;
-
-		/*
-		 * part of the group weight distributed to this span.
-		 */
-		unsigned long shares;
+	unsigned long task_weight;
 
-		/*
-		 * The sum of all runqueue weights within this span.
-		 */
-		unsigned long rq_weight;
+	/*
+	 *   h_load = weight * f(tg)
+	 *
+	 * Where f(tg) is the recursive weight fraction assigned to
+	 * this group.
+	 */
+	unsigned long h_load;
 
-		/*
-		 * Weight contributed by tasks; this is the part we can
-		 * influence by moving tasks around.
-		 */
-		unsigned long task_weight;
-	} aggregate;
+	/*
+	 * this cpu's part of tg->shares
+	 */
+	unsigned long shares;
 #endif
 #endif
 };
@@ -561,6 +545,8 @@ struct rq {
 	/* cpu of this runqueue: */
 	int cpu;
 
+	unsigned long avg_load_per_task;
+
 	struct task_struct *migration_thread;
 	struct list_head migration_queue;
 #endif
@@ -788,8 +774,6 @@ const_debug unsigned int sysctl_sched_nr
  */
 unsigned int sysctl_sched_rt_period = 1000000;
 
-static __read_mostly int scheduler_running;
-
 /*
  * part of the period that we allow rt tasks to run in us.
  * default: 0.95s
@@ -809,82 +793,6 @@ static inline u64 global_rt_runtime(void
 	return (u64)sysctl_sched_rt_runtime * NSEC_PER_USEC;
 }
 
-unsigned long long time_sync_thresh = 100000;
-
-static DEFINE_PER_CPU(unsigned long long, time_offset);
-static DEFINE_PER_CPU(unsigned long long, prev_cpu_time);
-
-/*
- * Global lock which we take every now and then to synchronize
- * the CPUs time. This method is not warp-safe, but it's good
- * enough to synchronize slowly diverging time sources and thus
- * it's good enough for tracing:
- */
-static DEFINE_SPINLOCK(time_sync_lock);
-static unsigned long long prev_global_time;
-
-static unsigned long long __sync_cpu_clock(unsigned long long time, int cpu)
-{
-	/*
-	 * We want this inlined, to not get tracer function calls
-	 * in this critical section:
-	 */
-	spin_acquire(&time_sync_lock.dep_map, 0, 0, _THIS_IP_);
-	__raw_spin_lock(&time_sync_lock.raw_lock);
-
-	if (time < prev_global_time) {
-		per_cpu(time_offset, cpu) += prev_global_time - time;
-		time = prev_global_time;
-	} else {
-		prev_global_time = time;
-	}
-
-	__raw_spin_unlock(&time_sync_lock.raw_lock);
-	spin_release(&time_sync_lock.dep_map, 1, _THIS_IP_);
-
-	return time;
-}
-
-static unsigned long long __cpu_clock(int cpu)
-{
-	unsigned long long now;
-
-	/*
-	 * Only call sched_clock() if the scheduler has already been
-	 * initialized (some code might call cpu_clock() very early):
-	 */
-	if (unlikely(!scheduler_running))
-		return 0;
-
-	now = sched_clock_cpu(cpu);
-
-	return now;
-}
-
-/*
- * For kernel-internal use: high-speed (but slightly incorrect) per-cpu
- * clock constructed from sched_clock():
- */
-unsigned long long cpu_clock(int cpu)
-{
-	unsigned long long prev_cpu_time, time, delta_time;
-	unsigned long flags;
-
-	local_irq_save(flags);
-	prev_cpu_time = per_cpu(prev_cpu_time, cpu);
-	time = __cpu_clock(cpu) + per_cpu(time_offset, cpu);
-	delta_time = time-prev_cpu_time;
-
-	if (unlikely(delta_time > time_sync_thresh)) {
-		time = __sync_cpu_clock(time, cpu);
-		per_cpu(prev_cpu_time, cpu) = time;
-	}
-	local_irq_restore(flags);
-
-	return time;
-}
-EXPORT_SYMBOL_GPL(cpu_clock);
-
 #ifndef prepare_arch_switch
 # define prepare_arch_switch(next)	do { } while (0)
 #endif
@@ -1503,63 +1411,35 @@ static inline void dec_cpu_load(struct r
 #ifdef CONFIG_SMP
 static unsigned long source_load(int cpu, int type);
 static unsigned long target_load(int cpu, int type);
-static unsigned long cpu_avg_load_per_task(int cpu);
 static int task_hot(struct task_struct *p, u64 now, struct sched_domain *sd);
 
-#ifdef CONFIG_FAIR_GROUP_SCHED
+static unsigned long cpu_avg_load_per_task(int cpu)
+{
+	struct rq *rq = cpu_rq(cpu);
 
-/*
- * Group load balancing.
- *
- * We calculate a few balance domain wide aggregate numbers; load and weight.
- * Given the pictures below, and assuming each item has equal weight:
- *
- *         root          1 - thread
- *         / | \         A - group
- *        A  1  B
- *       /|\   / \
- *      C 2 D 3   4
- *      |   |
- *      5   6
- *
- * load:
- *    A and B get 1/3-rd of the total load. C and D get 1/3-rd of A's 1/3-rd,
- *    which equals 1/9-th of the total load.
- *
- * shares:
- *    The weight of this group on the selected cpus.
- *
- * rq_weight:
- *    Direct sum of all the cpu's their rq weight, e.g. A would get 3 while
- *    B would get 2.
- *
- * task_weight:
- *    Part of the rq_weight contributed by tasks; all groups except B would
- *    get 1, B gets 2.
- */
+	if (rq->nr_running)
+		rq->avg_load_per_task = rq->load.weight / rq->nr_running;
 
-static inline struct aggregate_struct *
-aggregate(struct task_group *tg, struct sched_domain *sd)
-{
-	return &tg->cfs_rq[sd->first_cpu]->aggregate;
+	return rq->avg_load_per_task;
 }
 
-typedef void (*aggregate_func)(struct task_group *, struct sched_domain *);
+#ifdef CONFIG_FAIR_GROUP_SCHED
+
+typedef void (*tg_visitor)(struct task_group *, int, struct sched_domain *);
 
 /*
  * Iterate the full tree, calling @down when first entering a node and @up when
  * leaving it for the final time.
  */
-static
-void aggregate_walk_tree(aggregate_func down, aggregate_func up,
-			 struct sched_domain *sd)
+static void
+walk_tg_tree(tg_visitor down, tg_visitor up, int cpu, struct sched_domain *sd)
 {
 	struct task_group *parent, *child;
 
 	rcu_read_lock();
 	parent = &root_task_group;
 down:
-	(*down)(parent, sd);
+	(*down)(parent, cpu, sd);
 	list_for_each_entry_rcu(child, &parent->children, siblings) {
 		parent = child;
 		goto down;
@@ -1567,7 +1447,7 @@ down:
 up:
 		continue;
 	}
-	(*up)(parent, sd);
+	(*up)(parent, cpu, sd);
 
 	child = parent;
 	parent = parent->parent;
@@ -1576,90 +1456,23 @@ up:
 	rcu_read_unlock();
 }
 
-/*
- * Calculate the aggregate runqueue weight.
- */
-static
-void aggregate_group_weight(struct task_group *tg, struct sched_domain *sd)
-{
-	unsigned long rq_weight = 0;
-	unsigned long task_weight = 0;
-	int i;
-
-	for_each_cpu_mask(i, sd->span) {
-		rq_weight += tg->cfs_rq[i]->load.weight;
-		task_weight += tg->cfs_rq[i]->task_weight;
-	}
-
-	aggregate(tg, sd)->rq_weight = rq_weight;
-	aggregate(tg, sd)->task_weight = task_weight;
-}
-
-/*
- * Compute the weight of this group on the given cpus.
- */
-static
-void aggregate_group_shares(struct task_group *tg, struct sched_domain *sd)
-{
-	unsigned long shares = 0;
-	int i;
-
-	for_each_cpu_mask(i, sd->span)
-		shares += tg->cfs_rq[i]->shares;
-
-	if ((!shares && aggregate(tg, sd)->rq_weight) || shares > tg->shares)
-		shares = tg->shares;
-
-	aggregate(tg, sd)->shares = shares;
-}
-
-/*
- * Compute the load fraction assigned to this group, relies on the aggregate
- * weight and this group's parent's load, i.e. top-down.
- */
-static
-void aggregate_group_load(struct task_group *tg, struct sched_domain *sd)
-{
-	unsigned long load;
-
-	if (!tg->parent) {
-		int i;
-
-		load = 0;
-		for_each_cpu_mask(i, sd->span)
-			load += cpu_rq(i)->load.weight;
-
-	} else {
-		load = aggregate(tg->parent, sd)->load;
-
-		/*
-		 * shares is our weight in the parent's rq so
-		 * shares/parent->rq_weight gives our fraction of the load
-		 */
-		load *= aggregate(tg, sd)->shares;
-		load /= aggregate(tg->parent, sd)->rq_weight + 1;
-	}
-
-	aggregate(tg, sd)->load = load;
-}
-
 static void __set_se_shares(struct sched_entity *se, unsigned long shares);
 
 /*
  * Calculate and set the cpu's group shares.
  */
 static void
-__update_group_shares_cpu(struct task_group *tg, struct sched_domain *sd,
-			  int tcpu)
+__update_group_shares_cpu(struct task_group *tg, int cpu,
+			  unsigned long sd_shares, unsigned long sd_rq_weight)
 {
 	int boost = 0;
 	unsigned long shares;
 	unsigned long rq_weight;
 
-	if (!tg->se[tcpu])
+	if (!tg->se[cpu])
 		return;
 
-	rq_weight = tg->cfs_rq[tcpu]->load.weight;
+	rq_weight = tg->cfs_rq[cpu]->load.weight;
 
 	/*
 	 * If there are currently no tasks on the cpu pretend there is one of
@@ -1671,137 +1484,104 @@ __update_group_shares_cpu(struct task_gr
 		rq_weight = NICE_0_LOAD;
 	}
 
+	if (unlikely(rq_weight > sd_rq_weight))
+		rq_weight = sd_rq_weight;
+
 	/*
 	 *           \Sum shares * rq_weight
 	 * shares =  -----------------------
 	 *               \Sum rq_weight
 	 *
 	 */
-	shares = aggregate(tg, sd)->shares * rq_weight;
-	shares /= aggregate(tg, sd)->rq_weight + 1;
+	shares = (sd_shares * rq_weight) / (sd_rq_weight + 1);
 
 	/*
 	 * record the actual number of shares, not the boosted amount.
 	 */
-	tg->cfs_rq[tcpu]->shares = boost ? 0 : shares;
+	tg->cfs_rq[cpu]->shares = boost ? 0 : shares;
 
 	if (shares < MIN_SHARES)
 		shares = MIN_SHARES;
 	else if (shares > MAX_SHARES)
 		shares = MAX_SHARES;
 
-	__set_se_shares(tg->se[tcpu], shares);
+	__set_se_shares(tg->se[cpu], shares);
 }
 
 /*
- * Re-adjust the weights on the cpu the task came from and on the cpu the
- * task went to.
+ * Re-compute the task group their per cpu shares over the given domain.
+ * This needs to be done in a bottom-up fashion because the rq weight of a
+ * parent group depends on the shares of its child groups.
  */
 static void
-__move_group_shares(struct task_group *tg, struct sched_domain *sd,
-		    int scpu, int dcpu)
+tg_shares_up(struct task_group *tg, int cpu, struct sched_domain *sd)
 {
-	unsigned long shares;
-
-	shares = tg->cfs_rq[scpu]->shares + tg->cfs_rq[dcpu]->shares;
-
-	__update_group_shares_cpu(tg, sd, scpu);
-	__update_group_shares_cpu(tg, sd, dcpu);
-
-	/*
-	 * ensure we never loose shares due to rounding errors in the
-	 * above redistribution.
-	 */
-	shares -= tg->cfs_rq[scpu]->shares + tg->cfs_rq[dcpu]->shares;
-	if (shares)
-		tg->cfs_rq[dcpu]->shares += shares;
-}
+	unsigned long rq_weight = 0;
+	unsigned long shares = 0;
+	int i;
 
-/*
- * Because changing a group's shares changes the weight of the super-group
- * we need to walk up the tree and change all shares until we hit the root.
- */
-static void
-move_group_shares(struct task_group *tg, struct sched_domain *sd,
-		  int scpu, int dcpu)
-{
-	while (tg) {
-		__move_group_shares(tg, sd, scpu, dcpu);
-		tg = tg->parent;
+	for_each_cpu_mask(i, sd->span) {
+		rq_weight += tg->cfs_rq[i]->load.weight;
+		shares += tg->cfs_rq[i]->shares;
 	}
-}
 
-static
-void aggregate_group_set_shares(struct task_group *tg, struct sched_domain *sd)
-{
-	unsigned long shares = aggregate(tg, sd)->shares;
-	int i;
+	if ((!shares && rq_weight) || shares > tg->shares)
+		shares = tg->shares;
+
+	if (!sd->parent || !(sd->parent->flags & SD_LOAD_BALANCE))
+		shares = tg->shares;
 
 	for_each_cpu_mask(i, sd->span) {
 		struct rq *rq = cpu_rq(i);
 		unsigned long flags;
 
 		spin_lock_irqsave(&rq->lock, flags);
-		__update_group_shares_cpu(tg, sd, i);
+		__update_group_shares_cpu(tg, i, shares, rq_weight);
 		spin_unlock_irqrestore(&rq->lock, flags);
 	}
-
-	aggregate_group_shares(tg, sd);
-
-	/*
-	 * ensure we never loose shares due to rounding errors in the
-	 * above redistribution.
-	 */
-	shares -= aggregate(tg, sd)->shares;
-	if (shares) {
-		tg->cfs_rq[sd->first_cpu]->shares += shares;
-		aggregate(tg, sd)->shares += shares;
-	}
 }
 
 /*
- * Calculate the accumulative weight and recursive load of each task group
- * while walking down the tree.
+ * Compute the cpu's hierarchical load factor for each task group.
+ * This needs to be done in a top-down fashion because the load of a child
+ * group is a fraction of its parents load.
  */
-static
-void aggregate_get_down(struct task_group *tg, struct sched_domain *sd)
+static void
+tg_load_down(struct task_group *tg, int cpu, struct sched_domain *sd)
 {
-	aggregate_group_weight(tg, sd);
-	aggregate_group_shares(tg, sd);
-	aggregate_group_load(tg, sd);
+	unsigned long load;
+
+	if (!tg->parent) {
+		load = cpu_rq(cpu)->load.weight;
+	} else {
+		load = tg->parent->cfs_rq[cpu]->h_load;
+		load *= tg->cfs_rq[cpu]->shares;
+		load /= tg->parent->cfs_rq[cpu]->load.weight + 1;
+	}
+
+	tg->cfs_rq[cpu]->h_load = load;
 }
 
-/*
- * Rebalance the cpu shares while walking back up the tree.
- */
-static
-void aggregate_get_up(struct task_group *tg, struct sched_domain *sd)
+static void
+tg_nop(struct task_group *tg, int cpu, struct sched_domain *sd)
 {
-	aggregate_group_set_shares(tg, sd);
 }
 
-static DEFINE_PER_CPU(spinlock_t, aggregate_lock);
-
-static void __init init_aggregate(void)
+static void update_shares(struct sched_domain *sd)
 {
-	int i;
-
-	for_each_possible_cpu(i)
-		spin_lock_init(&per_cpu(aggregate_lock, i));
+	walk_tg_tree(tg_nop, tg_shares_up, 0, sd);
 }
 
-static int get_aggregate(struct sched_domain *sd)
+static void update_shares_locked(struct rq *rq, struct sched_domain *sd)
 {
-	if (!spin_trylock(&per_cpu(aggregate_lock, sd->first_cpu)))
-		return 0;
-
-	aggregate_walk_tree(aggregate_get_down, aggregate_get_up, sd);
-	return 1;
+	spin_unlock(&rq->lock);
+	update_shares(sd);
+	spin_lock(&rq->lock);
 }
 
-static void put_aggregate(struct sched_domain *sd)
+static void update_h_load(int cpu)
 {
-	spin_unlock(&per_cpu(aggregate_lock, sd->first_cpu));
+	walk_tg_tree(tg_load_down, tg_nop, cpu, NULL);
 }
 
 static void cfs_rq_set_shares(struct cfs_rq *cfs_rq, unsigned long shares)
@@ -1811,18 +1591,14 @@ static void cfs_rq_set_shares(struct cfs
 
 #else
 
-static inline void init_aggregate(void)
+static inline void update_shares(struct sched_domain *sd)
 {
 }
 
-static inline int get_aggregate(struct sched_domain *sd)
+static inline void update_shares_locked(struct rq *rq, struct sched_domain *sd)
 {
-	return 0;
 }
 
-static inline void put_aggregate(struct sched_domain *sd)
-{
-}
 #endif
 
 #else /* CONFIG_SMP */
@@ -2234,18 +2010,6 @@ static unsigned long target_load(int cpu
 }
 
 /*
- * Return the average load per task on the cpu's run queue
- */
-static unsigned long cpu_avg_load_per_task(int cpu)
-{
-	struct rq *rq = cpu_rq(cpu);
-	unsigned long total = weighted_cpuload(cpu);
-	unsigned long n = rq->nr_running;
-
-	return n ? total / n : SCHED_LOAD_SCALE;
-}
-
-/*
  * find_idlest_group finds and returns the least busy CPU group within the
  * domain.
  */
@@ -2351,6 +2115,9 @@ static int sched_balance_self(int cpu, i
 			sd = tmp;
 	}
 
+	if (sd)
+		update_shares(sd);
+
 	while (sd) {
 		cpumask_t span, tmpmask;
 		struct sched_group *group;
@@ -3271,6 +3038,7 @@ find_busiest_group(struct sched_domain *
 	max_load = this_load = total_load = total_pwr = 0;
 	busiest_load_per_task = busiest_nr_running = 0;
 	this_load_per_task = this_nr_running = 0;
+
 	if (idle == CPU_NOT_IDLE)
 		load_idx = sd->busy_idx;
 	else if (idle == CPU_NEWLY_IDLE)
@@ -3285,6 +3053,8 @@ find_busiest_group(struct sched_domain *
 		int __group_imb = 0;
 		unsigned int balance_cpu = -1, first_idle_cpu = 0;
 		unsigned long sum_nr_running, sum_weighted_load;
+		unsigned long sum_avg_load_per_task;
+		unsigned long avg_load_per_task;
 
 		local_group = cpu_isset(this_cpu, group->cpumask);
 
@@ -3293,6 +3063,8 @@ find_busiest_group(struct sched_domain *
 
 		/* Tally up the load of all CPUs in the group */
 		sum_weighted_load = sum_nr_running = avg_load = 0;
+		sum_avg_load_per_task = avg_load_per_task = 0;
+
 		max_cpu_load = 0;
 		min_cpu_load = ~0UL;
 
@@ -3326,6 +3098,8 @@ find_busiest_group(struct sched_domain *
 			avg_load += load;
 			sum_nr_running += rq->nr_running;
 			sum_weighted_load += weighted_cpuload(i);
+
+			sum_avg_load_per_task += cpu_avg_load_per_task(i);
 		}
 
 		/*
@@ -3347,7 +3121,20 @@ find_busiest_group(struct sched_domain *
 		avg_load = sg_div_cpu_power(group,
 				avg_load * SCHED_LOAD_SCALE);
 
-		if ((max_cpu_load - min_cpu_load) > SCHED_LOAD_SCALE)
+
+		/*
+		 * Consider the group unbalanced when the imbalance is larger
+		 * than the average weight of two tasks.
+		 *
+		 * APZ: with cgroup the avg task weight can vary wildly and
+		 *      might not be a suitable number - should we keep a
+		 *      normalized nr_running number somewhere that negates
+		 *      the hierarchy?
+		 */
+		avg_load_per_task = sg_div_cpu_power(group,
+				sum_avg_load_per_task * SCHED_LOAD_SCALE);
+
+		if ((max_cpu_load - min_cpu_load) > 2*avg_load_per_task)
 			__group_imb = 1;
 
 		group_capacity = group->__cpu_power / SCHED_LOAD_SCALE;
@@ -3488,9 +3275,9 @@ small_imbalance:
 			if (busiest_load_per_task > this_load_per_task)
 				imbn = 1;
 		} else
-			this_load_per_task = SCHED_LOAD_SCALE;
+			this_load_per_task = cpu_avg_load_per_task(this_cpu);
 
-		if (max_load - this_load + SCHED_LOAD_SCALE_FUZZ >=
+		if (max_load - this_load + 2*busiest_load_per_task >=
 					busiest_load_per_task * imbn) {
 			*imbalance = busiest_load_per_task;
 			return busiest;
@@ -3600,12 +3387,9 @@ static int load_balance(int this_cpu, st
 	unsigned long imbalance;
 	struct rq *busiest;
 	unsigned long flags;
-	int unlock_aggregate;
 
 	cpus_setall(*cpus);
 
-	unlock_aggregate = get_aggregate(sd);
-
 	/*
 	 * When power savings policy is enabled for the parent domain, idle
 	 * sibling can pick up load irrespective of busy siblings. In this case,
@@ -3619,6 +3403,7 @@ static int load_balance(int this_cpu, st
 	schedstat_inc(sd, lb_count[idle]);
 
 redo:
+	update_shares(sd);
 	group = find_busiest_group(sd, this_cpu, &imbalance, idle, &sd_idle,
 				   cpus, balance);
 
@@ -3742,8 +3527,8 @@ out_one_pinned:
 	else
 		ld_moved = 0;
 out:
-	if (unlock_aggregate)
-		put_aggregate(sd);
+	if (ld_moved)
+		update_shares(sd);
 	return ld_moved;
 }
 
@@ -3779,6 +3564,7 @@ load_balance_newidle(int this_cpu, struc
 
 	schedstat_inc(sd, lb_count[CPU_NEWLY_IDLE]);
 redo:
+	update_shares_locked(this_rq, sd);
 	group = find_busiest_group(sd, this_cpu, &imbalance, CPU_NEWLY_IDLE,
 				   &sd_idle, cpus, NULL);
 	if (!group) {
@@ -3822,6 +3608,7 @@ redo:
 	} else
 		sd->nr_balance_failed = 0;
 
+	update_shares_locked(this_rq, sd);
 	return ld_moved;
 
 out_balanced:
@@ -7316,7 +7103,6 @@ static int __build_sched_domains(const c
 			SD_INIT(sd, ALLNODES);
 			set_domain_attribute(sd, attr);
 			sd->span = *cpu_map;
-			sd->first_cpu = first_cpu(sd->span);
 			cpu_to_allnodes_group(i, cpu_map, &sd->groups, tmpmask);
 			p = sd;
 			sd_allnodes = 1;
@@ -7327,7 +7113,6 @@ static int __build_sched_domains(const c
 		SD_INIT(sd, NODE);
 		set_domain_attribute(sd, attr);
 		sched_domain_node_span(cpu_to_node(i), &sd->span);
-		sd->first_cpu = first_cpu(sd->span);
 		sd->parent = p;
 		if (p)
 			p->child = sd;
@@ -7339,7 +7124,6 @@ static int __build_sched_domains(const c
 		SD_INIT(sd, CPU);
 		set_domain_attribute(sd, attr);
 		sd->span = *nodemask;
-		sd->first_cpu = first_cpu(sd->span);
 		sd->parent = p;
 		if (p)
 			p->child = sd;
@@ -7351,7 +7135,6 @@ static int __build_sched_domains(const c
 		SD_INIT(sd, MC);
 		set_domain_attribute(sd, attr);
 		sd->span = cpu_coregroup_map(i);
-		sd->first_cpu = first_cpu(sd->span);
 		cpus_and(sd->span, sd->span, *cpu_map);
 		sd->parent = p;
 		p->child = sd;
@@ -7364,7 +7147,6 @@ static int __build_sched_domains(const c
 		SD_INIT(sd, SIBLING);
 		set_domain_attribute(sd, attr);
 		sd->span = per_cpu(cpu_sibling_map, i);
-		sd->first_cpu = first_cpu(sd->span);
 		cpus_and(sd->span, sd->span, *cpu_map);
 		sd->parent = p;
 		p->child = sd;
@@ -8034,7 +7816,6 @@ void __init sched_init(void)
 	}
 
 #ifdef CONFIG_SMP
-	init_aggregate();
 	init_defrootdomain();
 #endif
 
@@ -8178,8 +7959,6 @@ void __init sched_init(void)
 	 * During early bootup we pretend to be a normal task:
 	 */
 	current->sched_class = &fair_sched_class;
-
-	scheduler_running = 1;
 }
 
 #ifdef CONFIG_DEBUG_SPINLOCK_SLEEP
Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -63,13 +63,13 @@ unsigned int __read_mostly sysctl_sched_
 
 /*
  * SCHED_OTHER wake-up granularity.
- * (default: 10 msec * (1 + ilog(ncpus)), units: nanoseconds)
+ * (default: 5 msec * (1 + ilog(ncpus)), units: nanoseconds)
  *
  * This option delays the preemption effects of decoupled workloads
  * and reduces their over-scheduling. Synchronous workloads will still
  * have immediate wakeup/sleep latencies.
  */
-unsigned int sysctl_sched_wakeup_granularity = 10000000UL;
+unsigned int sysctl_sched_wakeup_granularity = 5000000UL;
 
 const_debug unsigned int sysctl_sched_migration_cost = 500000UL;
 
@@ -430,6 +430,29 @@ calc_delta_asym(unsigned long delta, str
 	for_each_sched_entity(se) {
 		struct load_weight *se_lw = &se->load;
 
+#ifdef CONFIG_FAIR_SCHED_GROUP
+		struct cfs_rq *cfs_rq = se->my_q;
+		struct task_group *tg = NULL
+
+		if (cfs_rq)
+			tg = cfs_rq->tg;
+
+		if (tg && tg->shares < NICE_0_LOAD) {
+			/*
+			 * scale shares to what it would have been had
+			 * tg->weight been NICE_0_LOAD:
+			 *
+			 *   weight = 1024 * shares / tg->weight
+			 */
+			lw.weight *= se->load.weight;
+			lw.weight /= tg->shares;
+
+			lw.inv_weight = 0;
+
+			se_lw = &lw;
+		} else
+#endif
+
 		if (se->load.weight < NICE_0_LOAD)
 			se_lw = &lw;
 
@@ -787,17 +810,16 @@ set_next_entity(struct cfs_rq *cfs_rq, s
 	se->prev_sum_exec_runtime = se->sum_exec_runtime;
 }
 
-static int
-wakeup_preempt_entity(struct sched_entity *curr, struct sched_entity *se);
-
 static struct sched_entity *
 pick_next(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	if (!cfs_rq->next)
-		return se;
+	struct rq *rq = rq_of(cfs_rq);
+	u64 pair_slice = rq->clock - cfs_rq->pair_start;
 
-	if (wakeup_preempt_entity(cfs_rq->next, se) != 0)
+	if (!cfs_rq->next || pair_slice > sched_slice(cfs_rq, cfs_rq->next)) {
+		cfs_rq->pair_start = rq->clock;
 		return se;
+	}
 
 	return cfs_rq->next;
 }
@@ -1048,6 +1070,26 @@ static inline int wake_idle(int cpu, str
 
 static const struct sched_class fair_sched_class;
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
+static unsigned long task_h_load(struct task_struct *p)
+{
+	unsigned long h_load = p->se.load.weight;
+	struct cfs_rq *cfs_rq = cfs_rq_of(&p->se);
+
+	update_h_load(task_cpu(p));
+
+	h_load *= cfs_rq->h_load;
+	h_load /= cfs_rq->load.weight + 1;
+
+	return h_load;
+}
+#else
+static unsigned long task_h_load(struct task_struct *p)
+{
+	return p->se.load.weight;
+}
+#endif
+
 static int
 wake_affine(struct rq *rq, struct sched_domain *this_sd, struct rq *this_rq,
 	    struct task_struct *p, int prev_cpu, int this_cpu, int sync,
@@ -1081,10 +1123,10 @@ wake_affine(struct rq *rq, struct sched_
 	 * of the current CPU:
 	 */
 	if (sync)
-		tl -= current->se.load.weight;
+		tl -= task_h_load(current);
 
 	if ((tl <= load && tl + target_load(prev_cpu, idx) <= tl_per_task) ||
-			100*(tl + p->se.load.weight) <= imbalance*load) {
+			100*(tl + task_h_load(p)) <= imbalance*load) {
 		/*
 		 * This domain has SD_WAKE_AFFINE and
 		 * p is cache cold in this domain, and
@@ -1172,7 +1214,10 @@ static unsigned long wakeup_gran(struct 
 	 * More easily preempt - nice tasks, while not making it harder for
 	 * + nice tasks.
 	 */
-	gran = calc_delta_asym(sysctl_sched_wakeup_granularity, se);
+	if (sched_feat(ASYM_GRAN))
+		gran = calc_delta_asym(sysctl_sched_wakeup_granularity, se);
+	else
+		gran = calc_delta_fair(sysctl_sched_wakeup_granularity, se);
 
 	return gran;
 }
@@ -1395,40 +1440,30 @@ load_balance_fair(struct rq *this_rq, in
 	struct task_group *tg;
 
 	rcu_read_lock();
+	update_h_load(busiest_cpu);
+
 	list_for_each_entry(tg, &task_groups, list) {
-		long imbalance;
-		unsigned long this_weight, busiest_weight;
-		long rem_load, max_load, moved_load;
+		struct cfs_rq *busiest_cfs_rq = tg->cfs_rq[busiest_cpu];
+		long rem_load, moved_load;
 
 		/*
 		 * empty group
 		 */
-		if (!aggregate(tg, sd)->task_weight)
+		if (!busiest_cfs_rq->task_weight)
 			continue;
 
-		rem_load = rem_load_move * aggregate(tg, sd)->rq_weight;
-		rem_load /= aggregate(tg, sd)->load + 1;
-
-		this_weight = tg->cfs_rq[this_cpu]->task_weight;
-		busiest_weight = tg->cfs_rq[busiest_cpu]->task_weight;
+		rem_load = rem_load_move * busiest_cfs_rq->load.weight;
+		rem_load /= busiest_cfs_rq->h_load + 1;
 
-		imbalance = (busiest_weight - this_weight) / 2;
-
-		if (imbalance < 0)
-			imbalance = busiest_weight;
-
-		max_load = max(rem_load, imbalance);
 		moved_load = __load_balance_fair(this_rq, this_cpu, busiest,
-				max_load, sd, idle, all_pinned, this_best_prio,
+				rem_load, sd, idle, all_pinned, this_best_prio,
 				tg->cfs_rq[busiest_cpu]);
 
 		if (!moved_load)
 			continue;
 
-		move_group_shares(tg, sd, busiest_cpu, this_cpu);
-
-		moved_load *= aggregate(tg, sd)->load;
-		moved_load /= aggregate(tg, sd)->rq_weight + 1;
+		moved_load *= busiest_cfs_rq->h_load;
+		moved_load /= busiest_cfs_rq->load.weight + 1;
 
 		rem_load_move -= moved_load;
 		if (rem_load_move < 0)
Index: linux-2.6/kernel/sched_features.h
===================================================================
--- linux-2.6.orig/kernel/sched_features.h
+++ linux-2.6/kernel/sched_features.h
@@ -8,3 +8,4 @@ SCHED_FEAT(HRTICK, 1)
 SCHED_FEAT(DOUBLE_TICK, 0)
 SCHED_FEAT(NORMALIZED_SLEEPER, 1)
 SCHED_FEAT(DEADLINE, 1)
+SCHED_FEAT(ASYM_GRAN, 1)


