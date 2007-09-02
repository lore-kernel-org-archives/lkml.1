Return-Path: <linux-kernel-owner+w=401wt.eu-S933778AbXIBBDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933778AbXIBBDg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 21:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933003AbXIBBD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 21:03:28 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:31059 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932925AbXIBBD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 21:03:26 -0400
Subject: Re: [ANNOUNCE/RFC] Really Fair Scheduler
From: Daniel Walker <dwalker@mvista.com>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org
In-Reply-To: <Pine.LNX.4.64.0708310139280.1817@scrub.home>
References: <Pine.LNX.4.64.0708310139280.1817@scrub.home>
Content-Type: text/plain
Date: Sat, 01 Sep 2007 17:52:47 -0700
Message-Id: <1188694367.11196.42.camel@dhcp193.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-08-31 at 04:05 +0200, Roman Zippel wrote:
> Hi,
> 
> I'm glad to announce a working prototype of the basic algorithm I
> already suggested last time.
> As I already tried to explain previously CFS has a considerable
> algorithmic and computational complexity. This patch should now make it
> clearer, why I could so easily skip over Ingo's long explanation of all
> the tricks CFS uses to keep the computational overhead low - I simply
> don't need them. The following numbers are based on a 2.6.23-rc3-git1 UP
> kernel, the first 3 runs are without patch, the last 3 runs are with the
> patch:

Out of curiosity I was reviewing your patch .. Since you create
kernel/sched_norm.c as a copy of kernel/sched_fair.c it was hard to see
what had changed .. So I re-diffed your patch to eliminate
kernel/sched_norm.c and just make the changes to kernel/sched_fair.c .. 

The the patch is near the end of this email..  The most notable thing
about the rediff is the line count,

 4 files changed, 323 insertions(+), 729 deletions(-)

That's impressive (assuming my rediff is correct). Although I don't know
for certain how that line reduction is achieved..

I also ran hackbench (in a haphazard way) a few times on it vs. CFS in
my tree, and RFS was faster to some degree (it varied).. 

> (1)	time = sum_{t}^{T}(time_{t})
> (2)	weight_sum = sum_{t}^{T}(weight_{t})

I read your description, but I was distracted by this latex style
notation .. Could you walk through in english what these two equation
are doing ..

The patch below is on top of my tree (2.6.23-rc5-dw1) ,
ftp://source.mvista.com/pub/dwalker/rt/

Daniel

---
 include/linux/sched.h |   21 -
 kernel/sched.c        |  186 ++++-------
 kernel/sched_debug.c  |   26 -
 kernel/sched_fair.c   |  819 +++++++++++++-------------------------------------
 4 files changed, 323 insertions(+), 729 deletions(-)

Index: linux-2.6.22/include/linux/sched.h
===================================================================
--- linux-2.6.22.orig/include/linux/sched.h
+++ linux-2.6.22/include/linux/sched.h
@@ -1046,40 +1046,29 @@ struct load_weight {
  *
  * Current field usage histogram:
  *
- *     4 se->block_start
  *     4 se->run_node
- *     4 se->sleep_start
- *     4 se->sleep_start_fair
  *     6 se->load.weight
- *     7 se->delta_fair
- *    15 se->wait_runtime
  */
 struct sched_entity {
-	long			wait_runtime;
-	unsigned long		delta_fair_run;
-	unsigned long		delta_fair_sleep;
-	unsigned long		delta_exec;
-	s64			fair_key;
+	s64			time_key;
 	struct load_weight	load;		/* for load-balancing */
 	struct rb_node		run_node;
-	unsigned int		on_rq;
+	unsigned int		on_rq, queued;;
+	unsigned int		weight_shift;
 
 	u64			exec_start;
 	u64			sum_exec_runtime;
 	u64			prev_sum_exec_runtime;
-	u64			wait_start_fair;
-	u64			sleep_start_fair;
+	s64			time_norm;
+	s64			req_weight_inv;
 
 #ifdef CONFIG_SCHEDSTATS
-	u64			wait_start;
 	u64			wait_max;
 	s64			sum_wait_runtime;
 
-	u64			sleep_start;
 	u64			sleep_max;
 	s64			sum_sleep_runtime;
 
-	u64			block_start;
 	u64			block_max;
 	u64			exec_max;
 
Index: linux-2.6.22/kernel/sched.c
===================================================================
--- linux-2.6.22.orig/kernel/sched.c
+++ linux-2.6.22/kernel/sched.c
@@ -230,18 +230,24 @@ struct cfs_rq {
 
 	s64 fair_clock;
 	u64 exec_clock;
-	s64 wait_runtime;
 	u64 sleeper_bonus;
 	unsigned long wait_runtime_overruns, wait_runtime_underruns;
 
+	u64 prev_update;
+	s64 time_norm_base, time_norm_inc;
+	u64 run_start, run_end;
+	u64 run_end_next, run_end_curr;
+	s64 time_sum_max, time_sum_off;
+	unsigned long inc_shift, weight_sum;
+
 	struct rb_root tasks_timeline;
-	struct rb_node *rb_leftmost;
 	struct rb_node *rb_load_balance_curr;
-#ifdef CONFIG_FAIR_GROUP_SCHED
 	/* 'curr' points to currently running entity on this cfs_rq.
 	 * It is set to NULL otherwise (i.e when none are currently running).
 	 */
-	struct sched_entity *curr;
+	struct sched_entity *curr, *next;
+	struct sched_entity *rb_leftmost;
+#ifdef CONFIG_FAIR_GROUP_SCHED
 	struct rq *rq;	/* cpu runqueue to which this cfs_rq is attached */
 
 	/* leaf cfs_rqs are those that hold tasks (lowest schedulable entity in
@@ -278,12 +284,16 @@ struct rq {
 	 */
 	unsigned long nr_running;
 	#define CPU_LOAD_IDX_MAX 5
+#ifdef CONFIG_SMP
 	unsigned long cpu_load[CPU_LOAD_IDX_MAX];
+#endif
 	unsigned char idle_at_tick;
 #ifdef CONFIG_NO_HZ
 	unsigned char in_nohz_recently;
 #endif
+#ifdef CONFIG_SMP
 	struct load_stat ls;	/* capture load from *all* tasks on this cpu */
+#endif
 	unsigned long nr_load_updates;
 	u64 nr_switches;
 
@@ -758,13 +768,6 @@ static void resched_cpu(int cpu)
 	resched_task(cpu_curr(cpu));
 	spin_unlock_irqrestore(&rq->lock, flags);
 }
-#else
-static inline void resched_task(struct task_struct *p)
-{
-	assert_spin_locked(&task_rq(p)->lock);
-	set_tsk_need_resched(p);
-}
-#endif
 
 static u64 div64_likely32(u64 divident, unsigned long divisor)
 {
@@ -779,6 +782,13 @@ static u64 div64_likely32(u64 divident, 
 #endif
 }
 
+#else
+static inline void resched_task(struct task_struct *p)
+{
+	assert_spin_locked(&task_rq(p)->lock);
+	set_tsk_need_resched(p);
+}
+#endif
 #if BITS_PER_LONG == 32
 # define WMULT_CONST	(~0UL)
 #else
@@ -856,15 +866,33 @@ static void update_load_sub(struct load_
  * If a task goes up by ~10% and another task goes down by ~10% then
  * the relative distance between them is ~25%.)
  */
+#ifdef SANE_NICE_LEVEL
 static const int prio_to_weight[40] = {
- /* -20 */     88761,     71755,     56483,     46273,     36291,
- /* -15 */     29154,     23254,     18705,     14949,     11916,
- /* -10 */      9548,      7620,      6100,      4904,      3906,
- /*  -5 */      3121,      2501,      1991,      1586,      1277,
- /*   0 */      1024,       820,       655,       526,       423,
- /*   5 */       335,       272,       215,       172,       137,
- /*  10 */       110,        87,        70,        56,        45,
- /*  15 */        36,        29,        23,        18,        15,
+        3567, 3102, 2703, 2351, 2048, 1783, 1551, 1351, 1177, 1024,
+        892, 776, 676, 588, 512, 446, 388, 338, 294, 256,
+        223, 194, 169, 147, 128, 111, 97, 84, 74, 64,
+        56, 49, 42, 37, 32, 28, 24, 21, 18, 16
+};
+
+static const u32 prio_to_wmult[40] = {
+	294, 338, 388, 446, 512, 588, 676, 776, 891, 1024,
+	1176, 1351, 1552, 1783, 2048, 2353, 2702, 3104, 3566, 4096,
+	4705, 5405, 6208, 7132, 8192, 9410, 10809, 12417, 14263, 16384,
+	18820, 21619, 24834, 28526, 32768, 37641, 43238, 49667, 57052, 65536
+};
+
+static const u32 prio_to_wshift[40] = {
+	8, 8, 7, 7, 7, 7, 7, 6, 6, 6,
+	6, 6, 5, 5, 5, 5, 5, 4, 4, 4,
+	4, 4, 3, 3, 3, 3, 3, 2, 2, 2,
+	2, 2, 1, 1, 1, 1, 1, 0, 0, 0
+};
+#else
+static const int prio_to_weight[40] = {
+	95325, 74898, 61681, 49932, 38836, 31775, 24966, 20165, 16132, 12945,
+	10382, 8257, 6637, 5296, 4228, 3393, 2709, 2166, 1736, 1387,
+	1111, 888, 710, 568, 455, 364, 291, 233, 186, 149,
+	119, 95, 76, 61, 49, 39, 31, 25, 20, 16
 };
 
 /*
@@ -875,15 +903,19 @@ static const int prio_to_weight[40] = {
  * into multiplications:
  */
 static const u32 prio_to_wmult[40] = {
- /* -20 */     48388,     59856,     76040,     92818,    118348,
- /* -15 */    147320,    184698,    229616,    287308,    360437,
- /* -10 */    449829,    563644,    704093,    875809,   1099582,
- /*  -5 */   1376151,   1717300,   2157191,   2708050,   3363326,
- /*   0 */   4194304,   5237765,   6557202,   8165337,  10153587,
- /*   5 */  12820798,  15790321,  19976592,  24970740,  31350126,
- /*  10 */  39045157,  49367440,  61356676,  76695844,  95443717,
- /*  15 */ 119304647, 148102320, 186737708, 238609294, 286331153,
+	11, 14, 17, 21, 27, 33, 42, 52, 65, 81,
+	101, 127, 158, 198, 248, 309, 387, 484, 604, 756,
+	944, 1181, 1476, 1845, 2306, 2882, 3603, 4504, 5629, 7037,
+	8796, 10995, 13744, 17180, 21475, 26844, 33554, 41943, 52429, 65536
+};
+
+static const u32 prio_to_wshift[40] = {
+	13, 12, 12, 12, 11, 11, 11, 10, 10, 10,
+	9, 9, 9, 8, 8, 8, 7, 7, 7, 6,
+	6, 6, 5, 5, 5, 5, 4, 4, 4, 3,
+	3, 3, 2, 2, 2, 1, 1, 1, 0, 0
 };
+#endif
 
 static void activate_task(struct rq *rq, struct task_struct *p, int wakeup);
 
@@ -914,6 +946,7 @@ static int balance_tasks(struct rq *this
 
 #define sched_class_highest (&rt_sched_class)
 
+#ifdef CONFIG_SMP
 static void __update_curr_load(struct rq *rq, struct load_stat *ls)
 {
 	if (rq->curr != rq->idle && ls->load.weight) {
@@ -965,6 +998,14 @@ static inline void dec_load(struct rq *r
 	update_curr_load(rq);
 	update_load_sub(&rq->ls.load, p->se.load.weight);
 }
+#else
+static inline void inc_load(struct rq *rq, const struct task_struct *p)
+{
+}
+static inline void dec_load(struct rq *rq, const struct task_struct *p)
+{
+}
+#endif
 
 static void inc_nr_running(struct task_struct *p, struct rq *rq)
 {
@@ -980,9 +1021,6 @@ static void dec_nr_running(struct task_s
 
 static void set_load_weight(struct task_struct *p)
 {
-	task_rq(p)->cfs.wait_runtime -= p->se.wait_runtime;
-	p->se.wait_runtime = 0;
-
 	if (task_has_rt_policy(p)) {
 		p->se.load.weight = prio_to_weight[0] * 2;
 		p->se.load.inv_weight = prio_to_wmult[0] >> 1;
@@ -1000,6 +1038,8 @@ static void set_load_weight(struct task_
 
 	p->se.load.weight = prio_to_weight[p->static_prio - MAX_RT_PRIO];
 	p->se.load.inv_weight = prio_to_wmult[p->static_prio - MAX_RT_PRIO];
+	p->se.weight_shift = prio_to_wshift[p->static_prio - MAX_RT_PRIO];
+	p->se.req_weight_inv = p->se.load.inv_weight * (kclock_t)sysctl_sched_granularity;
 }
 
 static void enqueue_task(struct rq *rq, struct task_struct *p, int wakeup)
@@ -1129,11 +1169,13 @@ inline int task_curr(const struct task_s
 	return cpu_curr(task_cpu(p)) == p;
 }
 
+#ifdef CONFIG_SMP
 /* Used instead of source_load when we know the type == 0 */
 unsigned long weighted_cpuload(const int cpu)
 {
 	return cpu_rq(cpu)->ls.load.weight;
 }
+#endif
 
 /*
  * Pick up the highest-prio task:
@@ -1180,27 +1222,6 @@ static inline void __set_task_cpu(struct
 
 void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 {
-	int old_cpu = task_cpu(p);
-	struct rq *old_rq = cpu_rq(old_cpu), *new_rq = cpu_rq(new_cpu);
-	u64 clock_offset, fair_clock_offset;
-
-	clock_offset = old_rq->clock - new_rq->clock;
-	fair_clock_offset = old_rq->cfs.fair_clock - new_rq->cfs.fair_clock;
-
-	if (p->se.wait_start_fair)
-		p->se.wait_start_fair -= fair_clock_offset;
-	if (p->se.sleep_start_fair)
-		p->se.sleep_start_fair -= fair_clock_offset;
-
-#ifdef CONFIG_SCHEDSTATS
-	if (p->se.wait_start)
-		p->se.wait_start -= clock_offset;
-	if (p->se.sleep_start)
-		p->se.sleep_start -= clock_offset;
-	if (p->se.block_start)
-		p->se.block_start -= clock_offset;
-#endif
-
 	__set_task_cpu(p, new_cpu);
 }
 
@@ -1968,22 +1989,13 @@ int fastcall wake_up_state(struct task_s
  */
 static void __sched_fork(struct task_struct *p)
 {
-	p->se.wait_start_fair		= 0;
 	p->se.exec_start		= 0;
 	p->se.sum_exec_runtime		= 0;
 	p->se.prev_sum_exec_runtime	= 0;
-	p->se.delta_exec		= 0;
-	p->se.delta_fair_run		= 0;
-	p->se.delta_fair_sleep		= 0;
-	p->se.wait_runtime		= 0;
-	p->se.sleep_start_fair		= 0;
 
 #ifdef CONFIG_SCHEDSTATS
-	p->se.wait_start		= 0;
 	p->se.sum_wait_runtime		= 0;
 	p->se.sum_sleep_runtime		= 0;
-	p->se.sleep_start		= 0;
-	p->se.block_start		= 0;
 	p->se.sleep_max			= 0;
 	p->se.block_max			= 0;
 	p->se.exec_max			= 0;
@@ -2426,6 +2438,7 @@ unsigned long nr_active(void)
 	return running + uninterruptible;
 }
 
+#ifdef CONFIG_SMP
 /*
  * Update rq->cpu_load[] statistics. This function is usually called every
  * scheduler tick (TICK_NSEC).
@@ -2482,8 +2495,6 @@ do_avg:
 	}
 }
 
-#ifdef CONFIG_SMP
-
 /*
  * double_rq_lock - safely lock two runqueues
  *
@@ -3814,7 +3825,9 @@ void scheduler_tick(void)
 	if (unlikely(rq->clock < next_tick))
 		rq->clock = next_tick;
 	rq->tick_timestamp = rq->clock;
+#ifdef CONFIG_SMP
 	update_cpu_load(rq);
+#endif
 	if (curr != rq->idle) /* FIXME: needed? */
 		curr->sched_class->task_tick(rq, curr);
 	spin_unlock(&rq->lock);
@@ -5554,32 +5567,6 @@ void __cpuinit init_idle(struct task_str
  */
 cpumask_t nohz_cpu_mask = CPU_MASK_NONE;
 
-/*
- * Increase the granularity value when there are more CPUs,
- * because with more CPUs the 'effective latency' as visible
- * to users decreases. But the relationship is not linear,
- * so pick a second-best guess by going with the log2 of the
- * number of CPUs.
- *
- * This idea comes from the SD scheduler of Con Kolivas:
- */
-static inline void sched_init_granularity(void)
-{
-	unsigned int factor = 1 + ilog2(num_online_cpus());
-	const unsigned long limit = 100000000;
-
-	sysctl_sched_min_granularity *= factor;
-	if (sysctl_sched_min_granularity > limit)
-		sysctl_sched_min_granularity = limit;
-
-	sysctl_sched_latency *= factor;
-	if (sysctl_sched_latency > limit)
-		sysctl_sched_latency = limit;
-
-	sysctl_sched_runtime_limit = sysctl_sched_latency;
-	sysctl_sched_wakeup_granularity = sysctl_sched_min_granularity / 2;
-}
-
 #ifdef CONFIG_SMP
 /*
  * This is how migration works:
@@ -7155,13 +7142,10 @@ void __init sched_init_smp(void)
 	/* Move init over to a non-isolated CPU */
 	if (set_cpus_allowed(current, non_isolated_cpus) < 0)
 		BUG();
-	sched_init_granularity();
 }
 #else
 void __init sched_init_smp(void)
-{
-	sched_init_granularity();
-}
+{ }
 #endif /* CONFIG_SMP */
 
 int in_sched_functions(unsigned long addr)
@@ -7178,6 +7162,9 @@ static inline void init_cfs_rq(struct cf
 {
 	cfs_rq->tasks_timeline = RB_ROOT;
 	cfs_rq->fair_clock = 1;
+	cfs_rq->time_sum_max = 0;
+	cfs_rq->time_norm_inc = MAX_TIMESUM >> 1;
+	cfs_rq->inc_shift = 0;
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	cfs_rq->rq = rq;
 #endif
@@ -7185,7 +7172,6 @@ static inline void init_cfs_rq(struct cf
 
 void __init sched_init(void)
 {
-	u64 now = sched_clock();
 	int highest_cpu = 0;
 	int i, j;
 
@@ -7210,12 +7196,11 @@ void __init sched_init(void)
 		INIT_LIST_HEAD(&rq->leaf_cfs_rq_list);
 		list_add(&rq->cfs.leaf_cfs_rq_list, &rq->leaf_cfs_rq_list);
 #endif
-		rq->ls.load_update_last = now;
-		rq->ls.load_update_start = now;
+#ifdef CONFIG_SMP
+		rq->ls.load_update_last = rq->ls.load_update_start = sched_clock();
 
 		for (j = 0; j < CPU_LOAD_IDX_MAX; j++)
 			rq->cpu_load[j] = 0;
-#ifdef CONFIG_SMP
 		rq->sd = NULL;
 		rq->active_balance = 0;
 		rq->next_balance = jiffies;
@@ -7312,16 +7297,7 @@ void normalize_rt_tasks(void)
 
 	read_lock_irq(&tasklist_lock);
 	do_each_thread(g, p) {
-		p->se.fair_key			= 0;
-		p->se.wait_runtime		= 0;
 		p->se.exec_start		= 0;
-		p->se.wait_start_fair		= 0;
-		p->se.sleep_start_fair		= 0;
-#ifdef CONFIG_SCHEDSTATS
-		p->se.wait_start		= 0;
-		p->se.sleep_start		= 0;
-		p->se.block_start		= 0;
-#endif
 		task_rq(p)->cfs.fair_clock	= 0;
 		task_rq(p)->clock		= 0;
 
Index: linux-2.6.22/kernel/sched_debug.c
===================================================================
--- linux-2.6.22.orig/kernel/sched_debug.c
+++ linux-2.6.22/kernel/sched_debug.c
@@ -38,9 +38,9 @@ print_task(struct seq_file *m, struct rq
 
 	SEQ_printf(m, "%15s %5d %15Ld %13Ld %13Ld %9Ld %5d ",
 		p->comm, p->pid,
-		(long long)p->se.fair_key,
-		(long long)(p->se.fair_key - rq->cfs.fair_clock),
-		(long long)p->se.wait_runtime,
+		(long long)p->se.time_norm >> 16,
+		(long long)((p->se.time_key >> 16) - rq->cfs.fair_clock),
+		((long long)((rq->cfs.fair_clock << 16) - p->se.time_norm) * p->se.load.weight) >> 20,
 		(long long)(p->nvcsw + p->nivcsw),
 		p->prio);
 #ifdef CONFIG_SCHEDSTATS
@@ -73,6 +73,7 @@ static void print_rq(struct seq_file *m,
 
 	read_lock_irq(&tasklist_lock);
 
+	rq->cfs.fair_clock = get_time_avg(&rq->cfs) >> 16;
 	do_each_thread(g, p) {
 		if (!p->se.on_rq || task_cpu(p) != rq_cpu)
 			continue;
@@ -93,10 +94,10 @@ print_cfs_rq_runtime_sum(struct seq_file
 	struct rq *rq = &per_cpu(runqueues, cpu);
 
 	spin_lock_irqsave(&rq->lock, flags);
-	curr = first_fair(cfs_rq);
+	curr = cfs_rq->rb_leftmost ? &cfs_rq->rb_leftmost->run_node : NULL;
 	while (curr) {
 		p = rb_entry(curr, struct task_struct, se.run_node);
-		wait_runtime_rq_sum += p->se.wait_runtime;
+		//wait_runtime_rq_sum += p->se.wait_runtime;
 
 		curr = rb_next(curr);
 	}
@@ -110,12 +111,12 @@ void print_cfs_rq(struct seq_file *m, in
 {
 	SEQ_printf(m, "\ncfs_rq\n");
 
+	cfs_rq->fair_clock = get_time_avg(cfs_rq) >> 16;
 #define P(x) \
 	SEQ_printf(m, "  .%-30s: %Ld\n", #x, (long long)(cfs_rq->x))
 
 	P(fair_clock);
 	P(exec_clock);
-	P(wait_runtime);
 	P(wait_runtime_overruns);
 	P(wait_runtime_underruns);
 	P(sleeper_bonus);
@@ -143,10 +144,12 @@ static void print_cpu(struct seq_file *m
 	SEQ_printf(m, "  .%-30s: %Ld\n", #x, (long long)(rq->x))
 
 	P(nr_running);
+#ifdef CONFIG_SMP
 	SEQ_printf(m, "  .%-30s: %lu\n", "load",
 		   rq->ls.load.weight);
 	P(ls.delta_fair);
 	P(ls.delta_exec);
+#endif
 	P(nr_switches);
 	P(nr_load_updates);
 	P(nr_uninterruptible);
@@ -160,11 +163,13 @@ static void print_cpu(struct seq_file *m
 	P(clock_overflows);
 	P(clock_deep_idle_events);
 	P(clock_max_delta);
+#ifdef CONFIG_SMP
 	P(cpu_load[0]);
 	P(cpu_load[1]);
 	P(cpu_load[2]);
 	P(cpu_load[3]);
 	P(cpu_load[4]);
+#endif
 #ifdef CONFIG_PREEMPT_RT
 	/* Print rt related rq stats */
 	P(rt_nr_running);
@@ -252,16 +257,7 @@ void proc_sched_show_task(struct task_st
 #define P(F) \
 	SEQ_printf(m, "%-25s:%20Ld\n", #F, (long long)p->F)
 
-	P(se.wait_runtime);
-	P(se.wait_start_fair);
-	P(se.exec_start);
-	P(se.sleep_start_fair);
-	P(se.sum_exec_runtime);
-
 #ifdef CONFIG_SCHEDSTATS
-	P(se.wait_start);
-	P(se.sleep_start);
-	P(se.block_start);
 	P(se.sleep_max);
 	P(se.block_max);
 	P(se.exec_max);
Index: linux-2.6.22/kernel/sched_fair.c
===================================================================
--- linux-2.6.22.orig/kernel/sched_fair.c
+++ linux-2.6.22/kernel/sched_fair.c
@@ -16,41 +16,50 @@
  *  Scaled math optimizations by Thomas Gleixner
  *  Copyright (C) 2007, Thomas Gleixner <tglx@linutronix.de>
  *
- *  Adaptive scheduling granularity, math enhancements by Peter Zijlstra
- *  Copyright (C) 2007 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
+ *  Really fair scheduling
+ *  Copyright (C) 2007, Roman Zippel <zippel@linux-m68k.org>
  */
 
+typedef s64 kclock_t;
+
+static inline kclock_t kclock_max(kclock_t x, kclock_t y)
+{
+	return (kclock_t)(x - y) > 0 ? x : y;
+}
+static inline kclock_t kclock_min(kclock_t x, kclock_t y)
+{
+	return (kclock_t)(x - y) < 0 ? x : y;
+}
+
+#define MSHIFT		16
+#define MAX_TIMESUM	((kclock_t)1 << (30 + MSHIFT))
+
 /*
- * Targeted preemption latency for CPU-bound tasks:
- * (default: 20ms, units: nanoseconds)
+ * Preemption granularity:
+ * (default: 2 msec, units: nanoseconds)
  *
- * NOTE: this latency value is not the same as the concept of
- * 'timeslice length' - timeslices in CFS are of variable length.
- * (to see the precise effective timeslice length of your workload,
- *  run vmstat and monitor the context-switches field)
+ * NOTE: this granularity value is not the same as the concept of
+ * 'timeslice length' - timeslices in CFS will typically be somewhat
+ * larger than this value. (to see the precise effective timeslice
+ * length of your workload, run vmstat and monitor the context-switches
+ * field)
  *
  * On SMP systems the value of this is multiplied by the log2 of the
  * number of CPUs. (i.e. factor 2x on 2-way systems, 3x on 4-way
  * systems, 4x on 8-way systems, 5x on 16-way systems, etc.)
- * Targeted preemption latency for CPU-bound tasks:
- */
-unsigned int sysctl_sched_latency __read_mostly = 20000000ULL;
-
-/*
- * Minimal preemption granularity for CPU-bound tasks:
- * (default: 2 msec, units: nanoseconds)
  */
-unsigned int sysctl_sched_min_granularity __read_mostly = 2000000ULL;
+unsigned int sysctl_sched_granularity __read_mostly = 2000000000ULL/HZ;
 
 /*
  * SCHED_BATCH wake-up granularity.
- * (default: 25 msec, units: nanoseconds)
+ * (default: 10 msec, units: nanoseconds)
  *
  * This option delays the preemption effects of decoupled workloads
  * and reduces their over-scheduling. Synchronous workloads will still
  * have immediate wakeup/sleep latencies.
  */
-unsigned int sysctl_sched_batch_wakeup_granularity __read_mostly = 25000000UL;
+unsigned int sysctl_sched_batch_wakeup_granularity __read_mostly =
+							10000000000ULL/HZ;
 
 /*
  * SCHED_OTHER wake-up granularity.
@@ -60,12 +69,12 @@ unsigned int sysctl_sched_batch_wakeup_g
  * and reduces their over-scheduling. Synchronous workloads will still
  * have immediate wakeup/sleep latencies.
  */
-unsigned int sysctl_sched_wakeup_granularity __read_mostly = 1000000UL;
+unsigned int sysctl_sched_wakeup_granularity __read_mostly = 1000000000ULL/HZ;
 
 unsigned int sysctl_sched_stat_granularity __read_mostly;
 
 /*
- * Initialized in sched_init_granularity() [to 5 times the base granularity]:
+ * Initialized in sched_init_granularity():
  */
 unsigned int sysctl_sched_runtime_limit __read_mostly;
 
@@ -83,7 +92,7 @@ enum {
 
 unsigned int sysctl_sched_features __read_mostly =
 		SCHED_FEAT_FAIR_SLEEPERS	*1 |
-		SCHED_FEAT_SLEEPER_AVG		*0 |
+		SCHED_FEAT_SLEEPER_AVG		*1 |
 		SCHED_FEAT_SLEEPER_LOAD_AVG	*1 |
 		SCHED_FEAT_PRECISE_CPU_LOAD	*1 |
 		SCHED_FEAT_START_DEBIT		*1 |
@@ -91,6 +100,17 @@ unsigned int sysctl_sched_features __rea
 
 extern struct sched_class fair_sched_class;
 
+static inline kclock_t get_time_avg(struct cfs_rq *cfs_rq)
+{
+	kclock_t avg;
+
+	avg = cfs_rq->time_norm_base;
+	if (cfs_rq->weight_sum)
+		avg += (kclock_t)((int)(cfs_rq->time_sum_off >> MSHIFT) / cfs_rq->weight_sum) << MSHIFT;
+
+	return avg;
+}
+
 /**************************************************************
  * CFS operations on generic schedulable entities:
  */
@@ -103,21 +123,9 @@ static inline struct rq *rq_of(struct cf
 	return cfs_rq->rq;
 }
 
-/* currently running entity (if any) on this cfs_rq */
-static inline struct sched_entity *cfs_rq_curr(struct cfs_rq *cfs_rq)
-{
-	return cfs_rq->curr;
-}
-
 /* An entity is a task if it doesn't "own" a runqueue */
 #define entity_is_task(se)	(!se->my_q)
 
-static inline void
-set_cfs_rq_curr(struct cfs_rq *cfs_rq, struct sched_entity *se)
-{
-	cfs_rq->curr = se;
-}
-
 #else	/* CONFIG_FAIR_GROUP_SCHED */
 
 static inline struct rq *rq_of(struct cfs_rq *cfs_rq)
@@ -125,21 +133,8 @@ static inline struct rq *rq_of(struct cf
 	return container_of(cfs_rq, struct rq, cfs);
 }
 
-static inline struct sched_entity *cfs_rq_curr(struct cfs_rq *cfs_rq)
-{
-	struct rq *rq = rq_of(cfs_rq);
-
-	if (unlikely(rq->curr->sched_class != &fair_sched_class))
-		return NULL;
-
-	return &rq->curr->se;
-}
-
 #define entity_is_task(se)	1
 
-static inline void
-set_cfs_rq_curr(struct cfs_rq *cfs_rq, struct sched_entity *se) { }
-
 #endif	/* CONFIG_FAIR_GROUP_SCHED */
 
 static inline struct task_struct *task_of(struct sched_entity *se)
@@ -161,9 +156,10 @@ __enqueue_entity(struct cfs_rq *cfs_rq, 
 	struct rb_node **link = &cfs_rq->tasks_timeline.rb_node;
 	struct rb_node *parent = NULL;
 	struct sched_entity *entry;
-	s64 key = se->fair_key;
+	kclock_t key;
 	int leftmost = 1;
 
+	se->time_key = key = se->time_norm + (se->req_weight_inv >> 1);
 	/*
 	 * Find the right place in the rbtree:
 	 */
@@ -174,7 +170,7 @@ __enqueue_entity(struct cfs_rq *cfs_rq, 
 		 * We dont care about collisions. Nodes with
 		 * the same key stay together.
 		 */
-		if (key - entry->fair_key < 0) {
+		if (key - entry->time_key < 0) {
 			link = &parent->rb_left;
 		} else {
 			link = &parent->rb_right;
@@ -186,584 +182,221 @@ __enqueue_entity(struct cfs_rq *cfs_rq, 
 	 * Maintain a cache of leftmost tree entries (it is frequently
 	 * used):
 	 */
-	if (leftmost)
-		cfs_rq->rb_leftmost = &se->run_node;
+	if (leftmost) {
+		cfs_rq->rb_leftmost = se;
+		if (cfs_rq->curr) {
+			cfs_rq->run_end_next = se->time_norm + se->req_weight_inv;
+			cfs_rq->run_end = kclock_min(cfs_rq->run_end_next,
+						     kclock_max(se->time_norm, cfs_rq->run_end_curr));
+		}
+	}
 
 	rb_link_node(&se->run_node, parent, link);
 	rb_insert_color(&se->run_node, &cfs_rq->tasks_timeline);
 	update_load_add(&cfs_rq->load, se->load.weight);
-	cfs_rq->nr_running++;
-	se->on_rq = 1;
+	se->queued = 1;
 }
 
 static inline void
 __dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	if (cfs_rq->rb_leftmost == &se->run_node)
-		cfs_rq->rb_leftmost = rb_next(&se->run_node);
+	if (cfs_rq->rb_leftmost == se) {
+		struct rb_node *next = rb_next(&se->run_node);
+		cfs_rq->rb_leftmost = next ? rb_entry(next, struct sched_entity, run_node) : NULL;
+	}
 	rb_erase(&se->run_node, &cfs_rq->tasks_timeline);
 	update_load_sub(&cfs_rq->load, se->load.weight);
-	cfs_rq->nr_running--;
-	se->on_rq = 0;
+	se->queued = 0;
 }
 
-static inline struct rb_node *first_fair(struct cfs_rq *cfs_rq)
+#ifdef CONFIG_SCHED_DEBUG
+static void verify_queue(struct cfs_rq *cfs_rq, int inc_curr, struct sched_entity *se2)
 {
-	return cfs_rq->rb_leftmost;
-}
+	struct rb_node *node;
+	struct sched_entity *se;
+	kclock_t sum = 0;
 
-static struct sched_entity *__pick_next_entity(struct cfs_rq *cfs_rq)
-{
-	return rb_entry(first_fair(cfs_rq), struct sched_entity, run_node);
+	se = cfs_rq->curr;
+	if (inc_curr && se)
+		sum = (se->time_norm - cfs_rq->time_norm_base) << se->weight_shift;
+	node = rb_first(&cfs_rq->tasks_timeline);
+	WARN_ON(node && cfs_rq->rb_leftmost != rb_entry(node, struct sched_entity, run_node));
+	while (node) {
+		se = rb_entry(node, struct sched_entity, run_node);
+		sum += (se->time_norm - cfs_rq->time_norm_base) << se->weight_shift;
+		node = rb_next(node);
+	}
+	if (sum != cfs_rq->time_sum_off) {
+		kclock_t oldsum = cfs_rq->time_sum_off;
+		cfs_rq->time_sum_off = sum;
+		printk("%ld:%Lx,%Lx,%p,%p,%d\n", cfs_rq->nr_running, sum, oldsum, cfs_rq->curr, se2, inc_curr);
+		WARN_ON(1);
+	}
 }
+#else
+#define verify_queue(q,c,s)	((void)0)
+#endif
 
 /**************************************************************
  * Scheduling class statistics methods:
  */
 
 /*
- * Calculate the preemption granularity needed to schedule every
- * runnable task once per sysctl_sched_latency amount of time.
- * (down to a sensible low limit on granularity)
- *
- * For example, if there are 2 tasks running and latency is 10 msecs,
- * we switch tasks every 5 msecs. If we have 3 tasks running, we have
- * to switch tasks every 3.33 msecs to get a 10 msecs observed latency
- * for each task. We do finer and finer scheduling up to until we
- * reach the minimum granularity value.
- *
- * To achieve this we use the following dynamic-granularity rule:
- *
- *    gran = lat/nr - lat/nr/nr
- *
- * This comes out of the following equations:
- *
- *    kA1 + gran = kB1
- *    kB2 + gran = kA2
- *    kA2 = kA1
- *    kB2 = kB1 - d + d/nr
- *    lat = d * nr
- *
- * Where 'k' is key, 'A' is task A (waiting), 'B' is task B (running),
- * '1' is start of time, '2' is end of time, 'd' is delay between
- * 1 and 2 (during which task B was running), 'nr' is number of tasks
- * running, 'lat' is the the period of each task. ('lat' is the
- * sched_latency that we aim for.)
- */
-static long
-sched_granularity(struct cfs_rq *cfs_rq)
-{
-	unsigned int gran = sysctl_sched_latency;
-	unsigned int nr = cfs_rq->nr_running;
-
-	if (nr > 1) {
-		gran = gran/nr - gran/nr/nr;
-		gran = max(gran, sysctl_sched_min_granularity);
-	}
-
-	return gran;
-}
-
-/*
- * We rescale the rescheduling granularity of tasks according to their
- * nice level, but only linearly, not exponentially:
- */
-static long
-niced_granularity(struct sched_entity *curr, unsigned long granularity)
-{
-	u64 tmp;
-
-	if (likely(curr->load.weight == NICE_0_LOAD))
-		return granularity;
-	/*
-	 * Positive nice levels get the same granularity as nice-0:
-	 */
-	if (likely(curr->load.weight < NICE_0_LOAD)) {
-		tmp = curr->load.weight * (u64)granularity;
-		return (long) (tmp >> NICE_0_SHIFT);
-	}
-	/*
-	 * Negative nice level tasks get linearly finer
-	 * granularity:
-	 */
-	tmp = curr->load.inv_weight * (u64)granularity;
-
-	/*
-	 * It will always fit into 'long':
-	 */
-	return (long) (tmp >> WMULT_SHIFT);
-}
-
-static inline void
-limit_wait_runtime(struct cfs_rq *cfs_rq, struct sched_entity *se)
-{
-	long limit = sysctl_sched_runtime_limit;
-
-	/*
-	 * Niced tasks have the same history dynamic range as
-	 * non-niced tasks:
-	 */
-	if (unlikely(se->wait_runtime > limit)) {
-		se->wait_runtime = limit;
-		schedstat_inc(se, wait_runtime_overruns);
-		schedstat_inc(cfs_rq, wait_runtime_overruns);
-	}
-	if (unlikely(se->wait_runtime < -limit)) {
-		se->wait_runtime = -limit;
-		schedstat_inc(se, wait_runtime_underruns);
-		schedstat_inc(cfs_rq, wait_runtime_underruns);
-	}
-}
-
-static inline void
-__add_wait_runtime(struct cfs_rq *cfs_rq, struct sched_entity *se, long delta)
-{
-	se->wait_runtime += delta;
-	schedstat_add(se, sum_wait_runtime, delta);
-	limit_wait_runtime(cfs_rq, se);
-}
-
-static void
-add_wait_runtime(struct cfs_rq *cfs_rq, struct sched_entity *se, long delta)
-{
-	schedstat_add(cfs_rq, wait_runtime, -se->wait_runtime);
-	__add_wait_runtime(cfs_rq, se, delta);
-	schedstat_add(cfs_rq, wait_runtime, se->wait_runtime);
-}
-
-/*
  * Update the current task's runtime statistics. Skip current tasks that
  * are not in our scheduling class.
  */
-static inline void
-__update_curr(struct cfs_rq *cfs_rq, struct sched_entity *curr)
+static inline void update_curr(struct cfs_rq *cfs_rq)
 {
-	unsigned long delta, delta_exec, delta_fair, delta_mine;
-	struct load_weight *lw = &cfs_rq->load;
-	unsigned long load = lw->weight;
-
-	delta_exec = curr->delta_exec;
-	schedstat_set(curr->exec_max, max((u64)delta_exec, curr->exec_max));
-
-	curr->sum_exec_runtime += delta_exec;
-	cfs_rq->exec_clock += delta_exec;
-
-	if (unlikely(!load))
-		return;
-
-	delta_fair = calc_delta_fair(delta_exec, lw);
-	delta_mine = calc_delta_mine(delta_exec, curr->load.weight, lw);
-
-	if (cfs_rq->sleeper_bonus > sysctl_sched_min_granularity) {
-		delta = min((u64)delta_mine, cfs_rq->sleeper_bonus);
-		delta = min(delta, (unsigned long)(
-			(long)sysctl_sched_runtime_limit - curr->wait_runtime));
-		cfs_rq->sleeper_bonus -= delta;
-		delta_mine -= delta;
-	}
-
-	cfs_rq->fair_clock += delta_fair;
-	/*
-	 * We executed delta_exec amount of time on the CPU,
-	 * but we were only entitled to delta_mine amount of
-	 * time during that period (if nr_running == 1 then
-	 * the two values are equal)
-	 * [Note: delta_mine - delta_exec is negative]:
-	 */
-	add_wait_runtime(cfs_rq, curr, delta_mine - delta_exec);
-}
-
-static void update_curr(struct cfs_rq *cfs_rq)
-{
-	struct sched_entity *curr = cfs_rq_curr(cfs_rq);
+	struct sched_entity *curr = cfs_rq->curr;
+	kclock_t now = rq_of(cfs_rq)->clock;
 	unsigned long delta_exec;
+	kclock_t delta_norm;
 
 	if (unlikely(!curr))
 		return;
 
-	/*
-	 * Get the amount of time the current task was running
-	 * since the last time we changed load (this cannot
-	 * overflow on 32 bits):
-	 */
-	delta_exec = (unsigned long)(rq_of(cfs_rq)->clock - curr->exec_start);
-
-	curr->delta_exec += delta_exec;
-
-	if (unlikely(curr->delta_exec > sysctl_sched_stat_granularity)) {
-		__update_curr(cfs_rq, curr);
-		curr->delta_exec = 0;
-	}
-	curr->exec_start = rq_of(cfs_rq)->clock;
-}
-
-static inline void
-update_stats_wait_start(struct cfs_rq *cfs_rq, struct sched_entity *se)
-{
-	se->wait_start_fair = cfs_rq->fair_clock;
-	schedstat_set(se->wait_start, rq_of(cfs_rq)->clock);
-}
-
-/*
- * We calculate fair deltas here, so protect against the random effects
- * of a multiplication overflow by capping it to the runtime limit:
- */
-#if BITS_PER_LONG == 32
-static inline unsigned long
-calc_weighted(unsigned long delta, unsigned long weight, int shift)
-{
-	u64 tmp = (u64)delta * weight >> shift;
-
-	if (unlikely(tmp > sysctl_sched_runtime_limit*2))
-		return sysctl_sched_runtime_limit*2;
-	return tmp;
-}
-#else
-static inline unsigned long
-calc_weighted(unsigned long delta, unsigned long weight, int shift)
-{
-	return delta * weight >> shift;
-}
-#endif
-
-/*
- * Task is being enqueued - update stats:
- */
-static void update_stats_enqueue(struct cfs_rq *cfs_rq, struct sched_entity *se)
-{
-	s64 key;
-
-	/*
-	 * Are we enqueueing a waiting task? (for current tasks
-	 * a dequeue/enqueue event is a NOP)
-	 */
-	if (se != cfs_rq_curr(cfs_rq))
-		update_stats_wait_start(cfs_rq, se);
-	/*
-	 * Update the key:
-	 */
-	key = cfs_rq->fair_clock;
-
-	/*
-	 * Optimize the common nice 0 case:
-	 */
-	if (likely(se->load.weight == NICE_0_LOAD)) {
-		key -= se->wait_runtime;
-	} else {
-		u64 tmp;
-
-		if (se->wait_runtime < 0) {
-			tmp = -se->wait_runtime;
-			key += (tmp * se->load.inv_weight) >>
-					(WMULT_SHIFT - NICE_0_SHIFT);
-		} else {
-			tmp = se->wait_runtime;
-			key -= (tmp * se->load.inv_weight) >>
-					(WMULT_SHIFT - NICE_0_SHIFT);
-		}
-	}
-
-	se->fair_key = key;
-}
-
-/*
- * Note: must be called with a freshly updated rq->fair_clock.
- */
-static inline void
-__update_stats_wait_end(struct cfs_rq *cfs_rq, struct sched_entity *se)
-{
-	unsigned long delta_fair = se->delta_fair_run;
-
-	schedstat_set(se->wait_max, max(se->wait_max,
-			rq_of(cfs_rq)->clock - se->wait_start));
-
-	if (unlikely(se->load.weight != NICE_0_LOAD))
-		delta_fair = calc_weighted(delta_fair, se->load.weight,
-							NICE_0_SHIFT);
-
-	add_wait_runtime(cfs_rq, se, delta_fair);
-}
-
-static void
-update_stats_wait_end(struct cfs_rq *cfs_rq, struct sched_entity *se)
-{
-	unsigned long delta_fair;
-
-	if (unlikely(!se->wait_start_fair))
-		return;
-
-	delta_fair = (unsigned long)min((u64)(2*sysctl_sched_runtime_limit),
-			(u64)(cfs_rq->fair_clock - se->wait_start_fair));
-
-	se->delta_fair_run += delta_fair;
-	if (unlikely(abs(se->delta_fair_run) >=
-				sysctl_sched_stat_granularity)) {
-		__update_stats_wait_end(cfs_rq, se);
-		se->delta_fair_run = 0;
-	}
-
-	se->wait_start_fair = 0;
-	schedstat_set(se->wait_start, 0);
-}
-
-static inline void
-update_stats_dequeue(struct cfs_rq *cfs_rq, struct sched_entity *se)
-{
-	update_curr(cfs_rq);
-	/*
-	 * Mark the end of the wait period if dequeueing a
-	 * waiting task:
-	 */
-	if (se != cfs_rq_curr(cfs_rq))
-		update_stats_wait_end(cfs_rq, se);
-}
-
-/*
- * We are picking a new current task - update its stats:
- */
-static inline void
-update_stats_curr_start(struct cfs_rq *cfs_rq, struct sched_entity *se)
-{
-	/*
-	 * We are starting a new run period:
-	 */
-	se->exec_start = rq_of(cfs_rq)->clock;
-}
-
-/*
- * We are descheduling a task - update its stats:
- */
-static inline void
-update_stats_curr_end(struct cfs_rq *cfs_rq, struct sched_entity *se)
-{
-	se->exec_start = 0;
-}
-
-/**************************************************
- * Scheduling class queueing methods:
- */
-
-static void __enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
-{
-	unsigned long load = cfs_rq->load.weight, delta_fair;
-	long prev_runtime;
-
-	/*
-	 * Do not boost sleepers if there's too much bonus 'in flight'
-	 * already:
-	 */
-	if (unlikely(cfs_rq->sleeper_bonus > sysctl_sched_runtime_limit))
-		return;
-
-	if (sysctl_sched_features & SCHED_FEAT_SLEEPER_LOAD_AVG)
-		load = rq_of(cfs_rq)->cpu_load[2];
-
-	delta_fair = se->delta_fair_sleep;
-
-	/*
-	 * Fix up delta_fair with the effect of us running
-	 * during the whole sleep period:
-	 */
-	if (sysctl_sched_features & SCHED_FEAT_SLEEPER_AVG)
-		delta_fair = div64_likely32((u64)delta_fair * load,
-						load + se->load.weight);
-
-	if (unlikely(se->load.weight != NICE_0_LOAD))
-		delta_fair = calc_weighted(delta_fair, se->load.weight,
-							NICE_0_SHIFT);
-
-	prev_runtime = se->wait_runtime;
-	__add_wait_runtime(cfs_rq, se, delta_fair);
-	schedstat_add(cfs_rq, wait_runtime, se->wait_runtime);
-	delta_fair = se->wait_runtime - prev_runtime;
-
-	/*
-	 * Track the amount of bonus we've given to sleepers:
-	 */
-	cfs_rq->sleeper_bonus += delta_fair;
-}
-
-static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
-{
-	struct task_struct *tsk = task_of(se);
-	unsigned long delta_fair;
-
-	if ((entity_is_task(se) && tsk->policy == SCHED_BATCH) ||
-			 !(sysctl_sched_features & SCHED_FEAT_FAIR_SLEEPERS))
+	delta_exec = now - cfs_rq->prev_update;
+	if (!delta_exec)
 		return;
+	cfs_rq->prev_update = now;
 
-	delta_fair = (unsigned long)min((u64)(2*sysctl_sched_runtime_limit),
-		(u64)(cfs_rq->fair_clock - se->sleep_start_fair));
-
-	se->delta_fair_sleep += delta_fair;
-	if (unlikely(abs(se->delta_fair_sleep) >=
-				sysctl_sched_stat_granularity)) {
-		__enqueue_sleeper(cfs_rq, se);
-		se->delta_fair_sleep = 0;
-	}
-
-	se->sleep_start_fair = 0;
-
-#ifdef CONFIG_SCHEDSTATS
-	if (se->sleep_start) {
-		u64 delta = rq_of(cfs_rq)->clock - se->sleep_start;
-
-		if ((s64)delta < 0)
-			delta = 0;
-
-		if (unlikely(delta > se->sleep_max))
-			se->sleep_max = delta;
-
-		se->sleep_start = 0;
-		se->sum_sleep_runtime += delta;
-	}
-	if (se->block_start) {
-		u64 delta = rq_of(cfs_rq)->clock - se->block_start;
-
-		if ((s64)delta < 0)
-			delta = 0;
+	curr->sum_exec_runtime += delta_exec;
+	cfs_rq->exec_clock += delta_exec;
 
-		if (unlikely(delta > se->block_max))
-			se->block_max = delta;
+	delta_norm = (kclock_t)delta_exec * curr->load.inv_weight;
+	curr->time_norm += delta_norm;
+	cfs_rq->time_sum_off += delta_norm << curr->weight_shift;
 
-		se->block_start = 0;
-		se->sum_sleep_runtime += delta;
-	}
-#endif
+	verify_queue(cfs_rq, 4, curr);
 }
 
 static void
-enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int wakeup)
+enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	/*
-	 * Update the fair clock.
-	 */
-	update_curr(cfs_rq);
+	kclock_t min_time;
 
-	if (wakeup)
-		enqueue_sleeper(cfs_rq, se);
+	verify_queue(cfs_rq, cfs_rq->curr != se, se);
+	min_time = get_time_avg(cfs_rq) - se->req_weight_inv;
+	if ((kclock_t)(se->time_norm - min_time) < 0)
+		se->time_norm = min_time;
 
-	update_stats_enqueue(cfs_rq, se);
-	__enqueue_entity(cfs_rq, se);
+	cfs_rq->nr_running++;
+	cfs_rq->weight_sum += 1 << se->weight_shift;
+	if (cfs_rq->inc_shift < se->weight_shift) {
+		cfs_rq->time_norm_inc >>= se->weight_shift - cfs_rq->inc_shift;
+		cfs_rq->time_sum_max >>= se->weight_shift - cfs_rq->inc_shift;
+		cfs_rq->inc_shift = se->weight_shift;
+	}
+	cfs_rq->time_sum_max += cfs_rq->time_norm_inc << se->weight_shift;
+	while (cfs_rq->time_sum_max >= MAX_TIMESUM) {
+		cfs_rq->time_norm_inc >>= 1;
+		cfs_rq->time_sum_max >>= 1;
+		cfs_rq->inc_shift++;
+	}
+	cfs_rq->time_sum_off += (se->time_norm - cfs_rq->time_norm_base) << se->weight_shift;
+	if (cfs_rq->time_sum_off >= cfs_rq->time_sum_max) {
+		cfs_rq->time_sum_off -= cfs_rq->time_sum_max;
+		cfs_rq->time_norm_base += cfs_rq->time_norm_inc;
+	}
+
+	if (&rq_of(cfs_rq)->curr->se == se)
+		cfs_rq->curr = se;
+	if (cfs_rq->curr != se)
+		__enqueue_entity(cfs_rq, se);
+	verify_queue(cfs_rq, 2, se);
 }
 
 static void
 dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int sleep)
 {
-	update_stats_dequeue(cfs_rq, se);
-	if (sleep) {
-		se->sleep_start_fair = cfs_rq->fair_clock;
-#ifdef CONFIG_SCHEDSTATS
-		if (entity_is_task(se)) {
-			struct task_struct *tsk = task_of(se);
-
-			if (tsk->state & TASK_INTERRUPTIBLE)
-				se->sleep_start = rq_of(cfs_rq)->clock;
-			if (tsk->state & TASK_UNINTERRUPTIBLE)
-				se->block_start = rq_of(cfs_rq)->clock;
+	verify_queue(cfs_rq, 3, se);
+
+	cfs_rq->weight_sum -= 1 << se->weight_shift;
+	if (cfs_rq->weight_sum) {
+		cfs_rq->time_sum_max -= cfs_rq->time_norm_inc << se->weight_shift;
+		while (cfs_rq->time_sum_max < (MAX_TIMESUM >> 1)) {
+			cfs_rq->time_norm_inc <<= 1;
+			cfs_rq->time_sum_max <<= 1;
+			cfs_rq->inc_shift--;
 		}
-		cfs_rq->wait_runtime -= se->wait_runtime;
-#endif
+
+		cfs_rq->time_sum_off -= (se->time_norm - cfs_rq->time_norm_base) << se->weight_shift;
+		if (cfs_rq->time_sum_off < 0) {
+			cfs_rq->time_sum_off += cfs_rq->time_sum_max;
+			cfs_rq->time_norm_base -= cfs_rq->time_norm_inc;
+		}
+	} else {
+		cfs_rq->time_sum_off -= (se->time_norm - cfs_rq->time_norm_base) << se->weight_shift;
+		BUG_ON(cfs_rq->time_sum_off);
+		cfs_rq->time_norm_inc = MAX_TIMESUM >> 1;
+		cfs_rq->time_sum_max = 0;
+		cfs_rq->inc_shift = 0;
 	}
-	__dequeue_entity(cfs_rq, se);
-}
 
-/*
- * Preempt the current task with a newly woken task if needed:
- */
-static int
-__check_preempt_curr_fair(struct cfs_rq *cfs_rq, struct sched_entity *se,
-			  struct sched_entity *curr, unsigned long granularity)
-{
-	s64 __delta = curr->fair_key - se->fair_key;
 
-	/*
-	 * Take scheduling granularity into account - do not
-	 * preempt the current task unless the best task has
-	 * a larger than sched_granularity fairness advantage:
-	 */
-	if (__delta > niced_granularity(curr, granularity)) {
-		resched_task(rq_of(cfs_rq)->curr);
-		return 1;
-	}
-	return 0;
+	cfs_rq->nr_running--;
+	if (se->queued)
+		__dequeue_entity(cfs_rq, se);
+	if (cfs_rq->curr == se)
+		cfs_rq->curr = NULL;
+	if (cfs_rq->next == se)
+		cfs_rq->next = NULL;
+	verify_queue(cfs_rq, cfs_rq->curr != se, se);
 }
 
 static inline void
 set_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	/*
-	 * Any task has to be enqueued before it get to execute on
-	 * a CPU. So account for the time it spent waiting on the
-	 * runqueue. (note, here we rely on pick_next_task() having
-	 * done a put_prev_task_fair() shortly before this, which
-	 * updated rq->fair_clock - used by update_stats_wait_end())
-	 */
-	update_stats_wait_end(cfs_rq, se);
-	update_stats_curr_start(cfs_rq, se);
-	set_cfs_rq_curr(cfs_rq, se);
+	cfs_rq->prev_update = rq_of(cfs_rq)->clock;
+	cfs_rq->run_start = se->time_norm;
+	cfs_rq->run_end = cfs_rq->run_end_curr = cfs_rq->run_start + se->req_weight_inv;
+	cfs_rq->curr = se;
 }
 
 static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq)
 {
-	struct sched_entity *se = __pick_next_entity(cfs_rq);
+	struct sched_entity *se = cfs_rq->next ? cfs_rq->next : cfs_rq->rb_leftmost;
+	struct sched_entity *next;
 
+	cfs_rq->next = NULL;
+	if (se->queued)
+		__dequeue_entity(cfs_rq, se);
 	set_next_entity(cfs_rq, se);
 
+	next = cfs_rq->rb_leftmost;
+	if (next) {
+		cfs_rq->run_end_next = next->time_norm + next->req_weight_inv;
+		cfs_rq->run_end = kclock_min(cfs_rq->run_end_next,
+					     kclock_max(next->time_norm, cfs_rq->run_end_curr));
+	}
+
 	return se;
 }
 
 static void put_prev_entity(struct cfs_rq *cfs_rq, struct sched_entity *prev)
 {
-	/*
-	 * If still on the runqueue then deactivate_task()
-	 * was not called and update_curr() has to be done:
-	 */
-	if (prev->on_rq)
-		update_curr(cfs_rq);
-
-	update_stats_curr_end(cfs_rq, prev);
-
+	update_curr(cfs_rq);
 	if (prev->on_rq)
-		update_stats_wait_start(cfs_rq, prev);
-	set_cfs_rq_curr(cfs_rq, NULL);
+		__enqueue_entity(cfs_rq, prev);
+	cfs_rq->curr = NULL;
 }
 
 static void entity_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
 {
-	unsigned long gran, ideal_runtime, delta_exec;
-	struct sched_entity *next;
+	update_curr(cfs_rq);
 
-	/*
-	 * Dequeue and enqueue the task to update its
-	 * position within the tree:
-	 */
-	dequeue_entity(cfs_rq, curr, 0);
-	enqueue_entity(cfs_rq, curr, 0);
+	while (cfs_rq->time_sum_off >= cfs_rq->time_sum_max) {
+                cfs_rq->time_sum_off -= cfs_rq->time_sum_max;
+                cfs_rq->time_norm_base += cfs_rq->time_norm_inc;
+        }
 
 	/*
 	 * Reschedule if another task tops the current one.
 	 */
-	next = __pick_next_entity(cfs_rq);
-	if (next == curr)
-		return;
-
-	gran = sched_granularity(cfs_rq);
-	ideal_runtime = niced_granularity(curr,
-		max(sysctl_sched_latency / cfs_rq->nr_running,
-		    (unsigned long)sysctl_sched_min_granularity));
-	/*
-	 * If we executed more than what the latency constraint suggests,
-	 * reduce the rescheduling granularity. This way the total latency
-	 * of how much a task is not scheduled converges to
-	 * sysctl_sched_latency:
-	 */
-	delta_exec = curr->sum_exec_runtime - curr->prev_sum_exec_runtime;
-	if (delta_exec > ideal_runtime)
-		gran = 0;
-
-	if (__check_preempt_curr_fair(cfs_rq, next, curr, gran))
-		curr->prev_sum_exec_runtime = curr->sum_exec_runtime;
+	if (cfs_rq->rb_leftmost && (kclock_t)(curr->time_norm - cfs_rq->run_end) >= 0) {
+		cfs_rq->next = cfs_rq->rb_leftmost;
+		resched_task(rq_of(cfs_rq)->curr);
+	}
 }
 
 /**************************************************
@@ -868,7 +501,7 @@ static void enqueue_task_fair(struct rq 
 		if (se->on_rq)
 			break;
 		cfs_rq = cfs_rq_of(se);
-		enqueue_entity(cfs_rq, se, wakeup);
+		enqueue_entity(cfs_rq, se);
 	}
 }
 
@@ -886,7 +519,7 @@ static void dequeue_task_fair(struct rq 
 		cfs_rq = cfs_rq_of(se);
 		dequeue_entity(cfs_rq, se, sleep);
 		/* Don't dequeue parent if it has other entities besides us */
-		if (cfs_rq->load.weight)
+		if (cfs_rq->weight_sum)
 			break;
 	}
 }
@@ -897,14 +530,16 @@ static void dequeue_task_fair(struct rq 
 static void yield_task_fair(struct rq *rq, struct task_struct *p)
 {
 	struct cfs_rq *cfs_rq = task_cfs_rq(p);
-
+	struct sched_entity *next;
 	__update_rq_clock(rq);
-	/*
-	 * Dequeue and enqueue the task to update its
-	 * position within the tree:
-	 */
-	dequeue_entity(cfs_rq, &p->se, 0);
-	enqueue_entity(cfs_rq, &p->se, 0);
+
+	update_curr(cfs_rq);
+	next = cfs_rq->rb_leftmost;
+	if (next && (kclock_t)(p->se.time_norm - next->time_norm) > 0) {
+		cfs_rq->next = next;
+		return;
+	}
+	cfs_rq->next = &p->se;
 }
 
 /*
@@ -916,12 +551,11 @@ static void check_preempt_curr_fair(stru
 	struct cfs_rq *cfs_rq = task_cfs_rq(curr);
 	unsigned long gran;
 
-	if (unlikely(rt_prio(p->prio))) {
-		update_rq_clock(rq);
-		update_curr(cfs_rq);
+	if (!cfs_rq->curr || unlikely(rt_prio(p->prio))) {
 		resched_task(curr);
 		return;
 	}
+	update_curr(cfs_rq);
 
 	gran = sysctl_sched_wakeup_granularity;
 	/*
@@ -930,8 +564,12 @@ static void check_preempt_curr_fair(stru
 	if (unlikely(p->policy == SCHED_BATCH))
 		gran = sysctl_sched_batch_wakeup_granularity;
 
-	if (is_same_group(curr, p))
-		__check_preempt_curr_fair(cfs_rq, &p->se, &curr->se, gran);
+	if (is_same_group(curr, p) &&
+	    cfs_rq->rb_leftmost == &p->se &&
+	    curr->se.time_norm - p->se.time_norm >= cfs_rq->curr->load.inv_weight * (kclock_t)gran) {
+		cfs_rq->next = &p->se;
+		resched_task(curr);
+	}
 }
 
 static struct task_struct *pick_next_task_fair(struct rq *rq)
@@ -942,6 +580,9 @@ static struct task_struct *pick_next_tas
 	if (unlikely(!cfs_rq->nr_running))
 		return NULL;
 
+	if (cfs_rq->nr_running == 1 && cfs_rq->curr)
+		return task_of(cfs_rq->curr);
+
 	do {
 		se = pick_next_entity(cfs_rq);
 		cfs_rq = group_cfs_rq(se);
@@ -976,10 +617,12 @@ static void put_prev_task_fair(struct rq
  * the current task:
  */
 static inline struct task_struct *
-__load_balance_iterator(struct cfs_rq *cfs_rq, struct rb_node *curr)
+__load_balance_iterator(struct cfs_rq *cfs_rq)
 {
 	struct task_struct *p;
+	struct rb_node *curr;
 
+	curr = cfs_rq->rb_load_balance_curr;
 	if (!curr)
 		return NULL;
 
@@ -993,14 +636,19 @@ static struct task_struct *load_balance_
 {
 	struct cfs_rq *cfs_rq = arg;
 
-	return __load_balance_iterator(cfs_rq, first_fair(cfs_rq));
+	cfs_rq->rb_load_balance_curr = cfs_rq->rb_leftmost ?
+		&cfs_rq->rb_leftmost->run_node : NULL;
+	if (cfs_rq->curr)
+		return rb_entry(&cfs_rq->curr->run_node, struct task_struct, se.run_node);
+
+	return __load_balance_iterator(cfs_rq);
 }
 
 static struct task_struct *load_balance_next_fair(void *arg)
 {
 	struct cfs_rq *cfs_rq = arg;
 
-	return __load_balance_iterator(cfs_rq, cfs_rq->rb_load_balance_curr);
+	return __load_balance_iterator(cfs_rq);
 }
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
@@ -1012,7 +660,7 @@ static int cfs_rq_best_prio(struct cfs_r
 	if (!cfs_rq->nr_running)
 		return MAX_PRIO;
 
-	curr = __pick_next_entity(cfs_rq);
+	curr = cfs_rq->rb_leftmost;
 	p = task_of(curr);
 
 	return p->prio;
@@ -1097,36 +745,21 @@ static void task_tick_fair(struct rq *rq
 static void task_new_fair(struct rq *rq, struct task_struct *p)
 {
 	struct cfs_rq *cfs_rq = task_cfs_rq(p);
-	struct sched_entity *se = &p->se, *curr = cfs_rq_curr(cfs_rq);
+	struct sched_entity *se = &p->se;
+	kclock_t time;
 
 	sched_info_queued(p);
 
-	update_curr(cfs_rq);
-	update_stats_enqueue(cfs_rq, se);
-	/*
-	 * Child runs first: we let it run before the parent
-	 * until it reschedules once. We set up the key so that
-	 * it will preempt the parent:
-	 */
-	se->fair_key = curr->fair_key -
-		niced_granularity(curr, sched_granularity(cfs_rq)) - 1;
-	/*
-	 * The first wait is dominated by the child-runs-first logic,
-	 * so do not credit it with that waiting time yet:
-	 */
-	if (sysctl_sched_features & SCHED_FEAT_SKIP_INITIAL)
-		se->wait_start_fair = 0;
+	time = (rq->curr->se.time_norm - get_time_avg(cfs_rq)) >> 1;
+	cfs_rq->time_sum_off -= (time << rq->curr->se.weight_shift);
+	rq->curr->se.time_norm -= time;
+	se->time_norm = rq->curr->se.time_norm;
 
-	/*
-	 * The statistical average of wait_runtime is about
-	 * -granularity/2, so initialize the task with that:
-	 */
-	if (sysctl_sched_features & SCHED_FEAT_START_DEBIT) {
-		se->wait_runtime = -(sched_granularity(cfs_rq) / 2);
-		schedstat_add(cfs_rq, wait_runtime, se->wait_runtime);
-	}
+	enqueue_entity(cfs_rq, se);
+	p->se.on_rq = 1;
 
-	__enqueue_entity(cfs_rq, se);
+	cfs_rq->next = se;
+	resched_task(rq->curr);
 }
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
@@ -1137,7 +770,7 @@ static void task_new_fair(struct rq *rq,
  */
 static void set_curr_task_fair(struct rq *rq)
 {
-	struct sched_entity *se = &rq->curr->se;
+	struct sched_entity *se = &rq->curr.se;
 
 	for_each_sched_entity(se)
 		set_next_entity(cfs_rq_of(se), se);


