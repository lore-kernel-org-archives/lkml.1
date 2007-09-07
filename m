Return-Path: <linux-kernel-owner+w=401wt.eu-S1758539AbXIGPfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758539AbXIGPfm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 11:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932477AbXIGPfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 11:35:32 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:1609 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757552AbXIGPf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 11:35:29 -0400
Date: Fri, 7 Sep 2007 17:35:43 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Ingo Molnar <mingo@elte.hu>
cc: Daniel Walker <dwalker@mvista.com>, linux-kernel@vger.kernel.org,
       peterz@infradead.org, Mike Galbraith <efault@gmx.de>
Subject: Re: [ANNOUNCE/RFC] Really Fair Scheduler
In-Reply-To: <20070902072029.GA24427@elte.hu>
Message-ID: <Pine.LNX.4.64.0709071634450.1817@scrub.home>
References: <Pine.LNX.4.64.0708310139280.1817@scrub.home>
 <1188694367.11196.42.camel@dhcp193.mvista.com> <20070902072029.GA24427@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, 2 Sep 2007, Ingo Molnar wrote:

Below is a patch updated against the latest git tree, no major changes. 
For a split version I'm still waiting for some more explanation about the 
CFS tuning parameter.
I added another check for the debug version so that any inbalances (as 
e.g. Mike seen it) should be reported. I left some of the proc parameter 
visible even in the non-debug version, so one can play with it without 
getting the debug overhead.

> And if you look at the resulting code size/complexity, it actually 
> increases with Roman's patch (UP, nodebug, x86):
> 
>      text    data     bss     dec     hex filename
>     13420     228    1204   14852    3a04 sched.o.rc5
>     13554     228    1228   15010    3aa2 sched.o.rc5-roman

You'll be happy to know, that with the patch even the SMP code size 
decreases.
BTW if I made the impression that overall code size must decrease, than I 
apologize, overall code size is of course only an indication, IMO more 
important is where that code is, i.e. that regularly executed code is as 
compact as possible.
64bit math simply adds a level of bloatness, which is hard to avoid, but 
with the fixed math it's actually possible to further reduce the code size 
by getting rid of the 64bit math, so that anyone prefering a really 
compact scheduler can have that.

> > I also ran hackbench (in a haphazard way) a few times on it vs. CFS in 
> > my tree, and RFS was faster to some degree (it varied)..
> 
> here are some actual numbers for "hackbench 50" on -rc5, 10 consecutive 
> runs fresh after bootup, Core2Duo, UP:
> 
>            -rc5(cfs)           -rc5+rfs
>           -------------------------------
>           Time: 3.905         Time: 4.259
>           Time: 3.962         Time: 4.190
>           Time: 3.981         Time: 4.241
>           Time: 3.986         Time: 3.937
>           Time: 3.984         Time: 4.120
>           Time: 4.001         Time: 4.013
>           Time: 3.980         Time: 4.248
>           Time: 3.983         Time: 3.961
>           Time: 3.989         Time: 4.345
>           Time: 3.981         Time: 4.294
>           -------------------------------
>            Avg: 3.975          Avg: 4.160 (+4.6%)
>          Fluct: 0.138        Fluct: 1.671
> 
> so unmodified CFS is 4.6% faster on this box than with Roman's patch and 
> it's also more consistent/stable (10 times lower fluctuations).

hackbench apparently works best if one doesn't wake up the consumer too 
early, so in the patch I don't preempt a just woken process, which 
produces far better numbers.

bye, Roman


---
 include/linux/sched.h |   26 -
 kernel/sched.c        |  173 +++++-----
 kernel/sched_debug.c  |   26 -
 kernel/sched_norm.c   |  841 ++++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sysctl.c       |   30 -
 5 files changed, 948 insertions(+), 148 deletions(-)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -884,40 +884,28 @@ struct load_weight {
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
+	unsigned int		on_rq, queued;
+	unsigned int		weight_shift;
 
 	u64			exec_start;
 	u64			sum_exec_runtime;
-	u64			prev_sum_exec_runtime;
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
 
@@ -1400,12 +1388,10 @@ static inline void idle_task_exit(void) 
 
 extern void sched_idle_next(void);
 
-extern unsigned int sysctl_sched_latency;
-extern unsigned int sysctl_sched_min_granularity;
+extern unsigned int sysctl_sched_granularity;
 extern unsigned int sysctl_sched_wakeup_granularity;
 extern unsigned int sysctl_sched_batch_wakeup_granularity;
 extern unsigned int sysctl_sched_stat_granularity;
-extern unsigned int sysctl_sched_runtime_limit;
 extern unsigned int sysctl_sched_child_runs_first;
 extern unsigned int sysctl_sched_features;
 
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -183,18 +183,24 @@ struct cfs_rq {
 
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
@@ -231,12 +237,16 @@ struct rq {
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
 
@@ -636,13 +646,6 @@ static void resched_cpu(int cpu)
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
@@ -657,6 +660,13 @@ static u64 div64_likely32(u64 divident, 
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
@@ -734,15 +744,33 @@ static void update_load_sub(struct load_
  * If a task goes up by ~10% and another task goes down by ~10% then
  * the relative distance between them is ~25%.)
  */
+#ifdef SANE_NICE_LEVEL
+static const int prio_to_weight[40] = {
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
 static const int prio_to_weight[40] = {
- /* -20 */     88761,     71755,     56483,     46273,     36291,
- /* -15 */     29154,     23254,     18705,     14949,     11916,
- /* -10 */      9548,      7620,      6100,      4904,      3906,
- /*  -5 */      3121,      2501,      1991,      1586,      1277,
- /*   0 */      1024,       820,       655,       526,       423,
- /*   5 */       335,       272,       215,       172,       137,
- /*  10 */       110,        87,        70,        56,        45,
- /*  15 */        36,        29,        23,        18,        15,
+	95325, 74898, 61681, 49932, 38836, 31775, 24966, 20165, 16132, 12945,
+	10382, 8257, 6637, 5296, 4228, 3393, 2709, 2166, 1736, 1387,
+	1111, 888, 710, 568, 455, 364, 291, 233, 186, 149,
+	119, 95, 76, 61, 49, 39, 31, 25, 20, 16
 };
 
 /*
@@ -753,16 +781,20 @@ static const int prio_to_weight[40] = {
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
 };
 
+static const u32 prio_to_wshift[40] = {
+	13, 12, 12, 12, 11, 11, 11, 10, 10, 10,
+	9, 9, 9, 8, 8, 8, 7, 7, 7, 6,
+	6, 6, 5, 5, 5, 5, 4, 4, 4, 3,
+	3, 3, 2, 2, 2, 1, 1, 1, 0, 0
+};
+#endif
+
 static void activate_task(struct rq *rq, struct task_struct *p, int wakeup);
 
 /*
@@ -784,7 +816,8 @@ static int balance_tasks(struct rq *this
 
 #include "sched_stats.h"
 #include "sched_rt.c"
-#include "sched_fair.c"
+//#include "sched_fair.c"
+#include "sched_norm.c"
 #include "sched_idletask.c"
 #ifdef CONFIG_SCHED_DEBUG
 # include "sched_debug.c"
@@ -792,6 +825,7 @@ static int balance_tasks(struct rq *this
 
 #define sched_class_highest (&rt_sched_class)
 
+#ifdef CONFIG_SMP
 static void __update_curr_load(struct rq *rq, struct load_stat *ls)
 {
 	if (rq->curr != rq->idle && ls->load.weight) {
@@ -843,6 +877,14 @@ static inline void dec_load(struct rq *r
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
@@ -858,9 +900,6 @@ static void dec_nr_running(struct task_s
 
 static void set_load_weight(struct task_struct *p)
 {
-	task_rq(p)->cfs.wait_runtime -= p->se.wait_runtime;
-	p->se.wait_runtime = 0;
-
 	if (task_has_rt_policy(p)) {
 		p->se.load.weight = prio_to_weight[0] * 2;
 		p->se.load.inv_weight = prio_to_wmult[0] >> 1;
@@ -878,6 +917,8 @@ static void set_load_weight(struct task_
 
 	p->se.load.weight = prio_to_weight[p->static_prio - MAX_RT_PRIO];
 	p->se.load.inv_weight = prio_to_wmult[p->static_prio - MAX_RT_PRIO];
+	p->se.weight_shift = prio_to_wshift[p->static_prio - MAX_RT_PRIO];
+	p->se.req_weight_inv = p->se.load.inv_weight * (kclock_t)sysctl_sched_granularity;
 }
 
 static void enqueue_task(struct rq *rq, struct task_struct *p, int wakeup)
@@ -986,11 +1027,13 @@ inline int task_curr(const struct task_s
 	return cpu_curr(task_cpu(p)) == p;
 }
 
+#ifdef CONFIG_SMP
 /* Used instead of source_load when we know the type == 0 */
 unsigned long weighted_cpuload(const int cpu)
 {
 	return cpu_rq(cpu)->ls.load.weight;
 }
+#endif
 
 static inline void __set_task_cpu(struct task_struct *p, unsigned int cpu)
 {
@@ -1004,27 +1047,6 @@ static inline void __set_task_cpu(struct
 
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
 
@@ -1584,22 +1606,12 @@ int fastcall wake_up_state(struct task_s
  */
 static void __sched_fork(struct task_struct *p)
 {
-	p->se.wait_start_fair		= 0;
 	p->se.exec_start		= 0;
 	p->se.sum_exec_runtime		= 0;
-	p->se.prev_sum_exec_runtime	= 0;
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
@@ -1971,6 +1983,7 @@ unsigned long nr_active(void)
 	return running + uninterruptible;
 }
 
+#ifdef CONFIG_SMP
 /*
  * Update rq->cpu_load[] statistics. This function is usually called every
  * scheduler tick (TICK_NSEC).
@@ -2027,8 +2040,6 @@ do_avg:
 	}
 }
 
-#ifdef CONFIG_SMP
-
 /*
  * double_rq_lock - safely lock two runqueues
  *
@@ -3350,7 +3361,9 @@ void scheduler_tick(void)
 	if (unlikely(rq->clock < next_tick))
 		rq->clock = next_tick;
 	rq->tick_timestamp = rq->clock;
+#ifdef CONFIG_SMP
 	update_cpu_load(rq);
+#endif
 	if (curr != rq->idle) /* FIXME: needed? */
 		curr->sched_class->task_tick(rq, curr);
 	spin_unlock(&rq->lock);
@@ -4914,16 +4927,12 @@ static inline void sched_init_granularit
 	unsigned int factor = 1 + ilog2(num_online_cpus());
 	const unsigned long limit = 100000000;
 
-	sysctl_sched_min_granularity *= factor;
-	if (sysctl_sched_min_granularity > limit)
-		sysctl_sched_min_granularity = limit;
-
-	sysctl_sched_latency *= factor;
-	if (sysctl_sched_latency > limit)
-		sysctl_sched_latency = limit;
+	sysctl_sched_granularity *= factor;
+	if (sysctl_sched_granularity > limit)
+		sysctl_sched_granularity = limit;
 
-	sysctl_sched_runtime_limit = sysctl_sched_latency;
-	sysctl_sched_wakeup_granularity = sysctl_sched_min_granularity / 2;
+	sysctl_sched_wakeup_granularity = sysctl_sched_granularity / 2;
+	sysctl_sched_batch_wakeup_granularity = sysctl_sched_granularity;
 }
 
 #ifdef CONFIG_SMP
@@ -6516,6 +6525,9 @@ static inline void init_cfs_rq(struct cf
 {
 	cfs_rq->tasks_timeline = RB_ROOT;
 	cfs_rq->fair_clock = 1;
+	cfs_rq->time_sum_max = 0;
+	cfs_rq->time_norm_inc = MAX_TIMESUM >> 1;
+	cfs_rq->inc_shift = 0;
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	cfs_rq->rq = rq;
 #endif
@@ -6523,7 +6535,6 @@ static inline void init_cfs_rq(struct cf
 
 void __init sched_init(void)
 {
-	u64 now = sched_clock();
 	int highest_cpu = 0;
 	int i, j;
 
@@ -6548,12 +6559,11 @@ void __init sched_init(void)
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
@@ -6643,16 +6653,7 @@ void normalize_rt_tasks(void)
 
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
 
Index: linux-2.6/kernel/sched_debug.c
===================================================================
--- linux-2.6.orig/kernel/sched_debug.c
+++ linux-2.6/kernel/sched_debug.c
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
 #undef P
 
 	print_cfs_stats(m, cpu);
@@ -241,16 +246,7 @@ void proc_sched_show_task(struct task_st
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
Index: linux-2.6/kernel/sched_norm.c
===================================================================
--- /dev/null
+++ linux-2.6/kernel/sched_norm.c
@@ -0,0 +1,841 @@
+/*
+ * Completely Fair Scheduling (CFS) Class (SCHED_NORMAL/SCHED_BATCH)
+ *
+ *  Copyright (C) 2007 Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
+ *
+ *  Interactivity improvements by Mike Galbraith
+ *  (C) 2007 Mike Galbraith <efault@gmx.de>
+ *
+ *  Various enhancements by Dmitry Adamushko.
+ *  (C) 2007 Dmitry Adamushko <dmitry.adamushko@gmail.com>
+ *
+ *  Group scheduling enhancements by Srivatsa Vaddagiri
+ *  Copyright IBM Corporation, 2007
+ *  Author: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
+ *
+ *  Scaled math optimizations by Thomas Gleixner
+ *  Copyright (C) 2007, Thomas Gleixner <tglx@linutronix.de>
+ *
+ *  Really fair scheduling
+ *  Copyright (C) 2007, Roman Zippel <zippel@linux-m68k.org>
+ */
+
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
+/*
+ * Preemption granularity:
+ * (default: 10 msec, units: nanoseconds)
+ *
+ * NOTE: this granularity value is not the same as the concept of
+ * 'timeslice length' - timeslices in CFS will typically be somewhat
+ * larger than this value. (to see the precise effective timeslice
+ * length of your workload, run vmstat and monitor the context-switches
+ * field)
+ *
+ * On SMP systems the value of this is multiplied by the log2 of the
+ * number of CPUs. (i.e. factor 2x on 2-way systems, 3x on 4-way
+ * systems, 4x on 8-way systems, 5x on 16-way systems, etc.)
+ */
+unsigned int sysctl_sched_granularity __read_mostly = 10000000ULL;
+
+/*
+ * SCHED_BATCH wake-up granularity.
+ * (default: 10 msec, units: nanoseconds)
+ *
+ * This option delays the preemption effects of decoupled workloads
+ * and reduces their over-scheduling. Synchronous workloads will still
+ * have immediate wakeup/sleep latencies.
+ */
+unsigned int sysctl_sched_batch_wakeup_granularity __read_mostly =
+							10000000ULL;
+
+/*
+ * SCHED_OTHER wake-up granularity.
+ * (default: 2 msec, units: nanoseconds)
+ *
+ * This option delays the preemption effects of decoupled workloads
+ * and reduces their over-scheduling. Synchronous workloads will still
+ * have immediate wakeup/sleep latencies.
+ */
+unsigned int sysctl_sched_wakeup_granularity __read_mostly = 2000000ULL;
+
+unsigned int sysctl_sched_stat_granularity __read_mostly;
+
+/*
+ * Debugging: various feature bits
+ */
+enum {
+	SCHED_FEAT_FAIR_SLEEPERS	= 1,
+	SCHED_FEAT_SLEEPER_AVG		= 2,
+	SCHED_FEAT_SLEEPER_LOAD_AVG	= 4,
+	SCHED_FEAT_PRECISE_CPU_LOAD	= 8,
+	SCHED_FEAT_START_DEBIT		= 16,
+	SCHED_FEAT_SKIP_INITIAL		= 32,
+};
+
+unsigned int sysctl_sched_features __read_mostly =
+		SCHED_FEAT_FAIR_SLEEPERS	*1 |
+		SCHED_FEAT_SLEEPER_AVG		*1 |
+		SCHED_FEAT_SLEEPER_LOAD_AVG	*1 |
+		SCHED_FEAT_PRECISE_CPU_LOAD	*1 |
+		SCHED_FEAT_START_DEBIT		*1 |
+		SCHED_FEAT_SKIP_INITIAL		*0;
+
+extern struct sched_class fair_sched_class;
+
+static kclock_t get_time_avg(struct cfs_rq *cfs_rq)
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
+static void normalize_time_sum_off(struct cfs_rq *cfs_rq)
+{
+	if (unlikely(cfs_rq->time_sum_off >= cfs_rq->time_sum_max)) {
+		cfs_rq->time_sum_off -= cfs_rq->time_sum_max;
+		cfs_rq->time_norm_base += cfs_rq->time_norm_inc;
+	} else if (unlikely(cfs_rq->time_sum_off < 0)) {
+		cfs_rq->time_sum_off += cfs_rq->time_sum_max;
+		cfs_rq->time_norm_base -= cfs_rq->time_norm_inc;
+	}
+}
+
+/**************************************************************
+ * CFS operations on generic schedulable entities:
+ */
+
+#ifdef CONFIG_FAIR_GROUP_SCHED
+
+/* cpu runqueue to which this cfs_rq is attached */
+static inline struct rq *rq_of(struct cfs_rq *cfs_rq)
+{
+	return cfs_rq->rq;
+}
+
+/* An entity is a task if it doesn't "own" a runqueue */
+#define entity_is_task(se)	(!se->my_q)
+
+#else	/* CONFIG_FAIR_GROUP_SCHED */
+
+static inline struct rq *rq_of(struct cfs_rq *cfs_rq)
+{
+	return container_of(cfs_rq, struct rq, cfs);
+}
+
+#define entity_is_task(se)	1
+
+#endif	/* CONFIG_FAIR_GROUP_SCHED */
+
+static inline struct task_struct *task_of(struct sched_entity *se)
+{
+	return container_of(se, struct task_struct, se);
+}
+
+
+/**************************************************************
+ * Scheduling class tree data structure manipulation methods:
+ */
+
+/*
+ * Enqueue an entity into the rb-tree:
+ */
+static void
+__enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
+{
+	struct rb_node **link = &cfs_rq->tasks_timeline.rb_node;
+	struct rb_node *parent = NULL;
+	struct sched_entity *entry;
+	kclock_t key;
+	int leftmost = 1;
+
+	se->time_key = key = se->time_norm + (se->req_weight_inv >> 1);
+	/*
+	 * Find the right place in the rbtree:
+	 */
+	while (*link) {
+		parent = *link;
+		entry = rb_entry(parent, struct sched_entity, run_node);
+		/*
+		 * We dont care about collisions. Nodes with
+		 * the same key stay together.
+		 */
+		if (key - entry->time_key < 0) {
+			link = &parent->rb_left;
+		} else {
+			link = &parent->rb_right;
+			leftmost = 0;
+		}
+	}
+
+	/*
+	 * Maintain a cache of leftmost tree entries (it is frequently
+	 * used):
+	 */
+	if (leftmost) {
+		cfs_rq->rb_leftmost = se;
+		if (cfs_rq->curr) {
+			cfs_rq->run_end_next = se->time_norm + se->req_weight_inv;
+			cfs_rq->run_end = kclock_min(cfs_rq->run_end_next,
+						     kclock_max(se->time_norm, cfs_rq->run_end_curr));
+		}
+	}
+
+	rb_link_node(&se->run_node, parent, link);
+	rb_insert_color(&se->run_node, &cfs_rq->tasks_timeline);
+	update_load_add(&cfs_rq->load, se->load.weight);
+	se->queued = 1;
+}
+
+static void
+__dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
+{
+	if (cfs_rq->rb_leftmost == se) {
+		struct rb_node *next = rb_next(&se->run_node);
+		cfs_rq->rb_leftmost = next ? rb_entry(next, struct sched_entity, run_node) : NULL;
+	}
+	rb_erase(&se->run_node, &cfs_rq->tasks_timeline);
+	update_load_sub(&cfs_rq->load, se->load.weight);
+	se->queued = 0;
+}
+
+#ifdef CONFIG_SCHED_DEBUG
+static void verify_queue(struct cfs_rq *cfs_rq, int inc_curr, struct sched_entity *se2)
+{
+	struct rb_node *node;
+	struct sched_entity *se;
+	kclock_t avg, sum = 0;
+	static int busy = 0, cnt = 10;
+
+#define RANGE_CHECK(se, se2) ({							\
+	if (cnt > 0 && abs(avg - se->time_norm) > (se->req_weight_inv << 2)) {	\
+		cnt--;								\
+		printk("%ld,%p(%u): %Lx,%Lx,%p(%u),%d\n",			\
+			cfs_rq->nr_running, se, task_of(se)->pid,		\
+			se->time_norm, avg, se2, task_of(se2)->pid, inc_curr);	\
+		WARN_ON(1);							\
+	} })
+
+	if (busy)
+		return;
+	busy = 1;
+
+	avg = get_time_avg(cfs_rq);
+	se = cfs_rq->curr;
+	if (inc_curr && se) {
+		sum = (se->time_norm - cfs_rq->time_norm_base) << se->weight_shift;
+		RANGE_CHECK(se, se2);
+	}
+	node = rb_first(&cfs_rq->tasks_timeline);
+	WARN_ON(node && cfs_rq->rb_leftmost != rb_entry(node, struct sched_entity, run_node));
+	while (node) {
+		se = rb_entry(node, struct sched_entity, run_node);
+		sum += (se->time_norm - cfs_rq->time_norm_base) << se->weight_shift;
+		RANGE_CHECK(se, se2);
+		node = rb_next(node);
+	}
+	if (sum != cfs_rq->time_sum_off) {
+		kclock_t oldsum = cfs_rq->time_sum_off;
+		cfs_rq->time_sum_off = sum;
+		printk("%ld:%Lx,%Lx,%p,%p,%d\n", cfs_rq->nr_running, sum, oldsum, cfs_rq->curr, se2, inc_curr);
+		WARN_ON(1);
+	}
+	busy = 0;
+}
+#else
+#define verify_queue(q,c,s)	((void)0)
+#endif
+
+/**************************************************************
+ * Scheduling class statistics methods:
+ */
+
+/*
+ * Update the current task's runtime statistics. Skip current tasks that
+ * are not in our scheduling class.
+ */
+static void update_curr(struct cfs_rq *cfs_rq)
+{
+	struct sched_entity *curr = cfs_rq->curr;
+	kclock_t now = rq_of(cfs_rq)->clock;
+	unsigned long delta_exec;
+	kclock_t delta_norm;
+
+	if (unlikely(!curr))
+		return;
+
+	delta_exec = now - cfs_rq->prev_update;
+	if (!delta_exec)
+		return;
+	cfs_rq->prev_update = now;
+
+	curr->sum_exec_runtime += delta_exec;
+	cfs_rq->exec_clock += delta_exec;
+
+	delta_norm = (kclock_t)delta_exec * curr->load.inv_weight;
+	curr->time_norm += delta_norm;
+	cfs_rq->time_sum_off += delta_norm << curr->weight_shift;
+
+	verify_queue(cfs_rq, 4, curr);
+}
+
+static void
+enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
+{
+	kclock_t min_time;
+
+	verify_queue(cfs_rq, cfs_rq->curr != se, se);
+	min_time = get_time_avg(cfs_rq) - se->req_weight_inv;
+	if ((kclock_t)(se->time_norm - min_time) < 0)
+		se->time_norm = min_time;
+
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
+	normalize_time_sum_off(cfs_rq);
+
+	if (&rq_of(cfs_rq)->curr->se == se)
+		cfs_rq->curr = se;
+	if (cfs_rq->curr != se)
+		__enqueue_entity(cfs_rq, se);
+	verify_queue(cfs_rq, 2, se);
+}
+
+static void
+dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int sleep)
+{
+	verify_queue(cfs_rq, 3, se);
+
+	cfs_rq->weight_sum -= 1 << se->weight_shift;
+	if (cfs_rq->weight_sum) {
+		cfs_rq->time_sum_max -= cfs_rq->time_norm_inc << se->weight_shift;
+		while (cfs_rq->time_sum_max < (MAX_TIMESUM >> 1)) {
+			cfs_rq->time_norm_inc <<= 1;
+			cfs_rq->time_sum_max <<= 1;
+			cfs_rq->inc_shift--;
+		}
+
+		cfs_rq->time_sum_off -= (se->time_norm - cfs_rq->time_norm_base) << se->weight_shift;
+		normalize_time_sum_off(cfs_rq);
+	} else {
+		cfs_rq->time_sum_off -= (se->time_norm - cfs_rq->time_norm_base) << se->weight_shift;
+		BUG_ON(cfs_rq->time_sum_off);
+		cfs_rq->time_norm_inc = MAX_TIMESUM >> 1;
+		cfs_rq->time_sum_max = 0;
+		cfs_rq->inc_shift = 0;
+	}
+
+
+	cfs_rq->nr_running--;
+	if (se->queued)
+		__dequeue_entity(cfs_rq, se);
+	if (cfs_rq->curr == se)
+		cfs_rq->curr = NULL;
+	if (cfs_rq->next == se)
+		cfs_rq->next = NULL;
+	verify_queue(cfs_rq, cfs_rq->curr != se, se);
+}
+
+static inline void
+set_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
+{
+	cfs_rq->prev_update = rq_of(cfs_rq)->clock;
+	cfs_rq->run_start = se->time_norm;
+	cfs_rq->run_end = cfs_rq->run_end_curr = cfs_rq->run_start + se->req_weight_inv;
+	cfs_rq->curr = se;
+}
+
+static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq)
+{
+	struct sched_entity *se = cfs_rq->next ? cfs_rq->next : cfs_rq->rb_leftmost;
+	struct sched_entity *next;
+
+	cfs_rq->next = NULL;
+	if (se->queued)
+		__dequeue_entity(cfs_rq, se);
+	set_next_entity(cfs_rq, se);
+
+	next = cfs_rq->rb_leftmost;
+	if (next) {
+		cfs_rq->run_end_next = next->time_norm + next->req_weight_inv;
+		cfs_rq->run_end = kclock_min(cfs_rq->run_end_next,
+					     kclock_max(next->time_norm, cfs_rq->run_end_curr));
+	}
+
+	return se;
+}
+
+static void put_prev_entity(struct cfs_rq *cfs_rq, struct sched_entity *prev)
+{
+	update_curr(cfs_rq);
+	if (prev->on_rq)
+		__enqueue_entity(cfs_rq, prev);
+	cfs_rq->curr = NULL;
+}
+
+static void entity_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
+{
+	update_curr(cfs_rq);
+	normalize_time_sum_off(cfs_rq);
+
+#ifdef CONFIG_SCHED_DEBUG
+{
+	static int cnt = 10;
+	kclock_t avg = get_time_avg(cfs_rq);
+	int inc_curr = 5;
+	RANGE_CHECK(curr, curr);
+}
+#endif
+
+	/*
+	 * Reschedule if another task tops the current one.
+	 */
+	if (cfs_rq->rb_leftmost && (kclock_t)(curr->time_norm - cfs_rq->run_end) >= 0) {
+		cfs_rq->next = cfs_rq->rb_leftmost;
+		resched_task(rq_of(cfs_rq)->curr);
+	}
+}
+
+/**************************************************
+ * CFS operations on tasks:
+ */
+
+#ifdef CONFIG_FAIR_GROUP_SCHED
+
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
+	/* A later patch will take group into account */
+	return &cpu_rq(this_cpu)->cfs;
+}
+
+/* Iterate thr' all leaf cfs_rq's on a runqueue */
+#define for_each_leaf_cfs_rq(rq, cfs_rq) \
+	list_for_each_entry(cfs_rq, &rq->leaf_cfs_rq_list, leaf_cfs_rq_list)
+
+/* Do the two (enqueued) tasks belong to the same group ? */
+static inline int is_same_group(struct task_struct *curr, struct task_struct *p)
+{
+	if (curr->se.cfs_rq == p->se.cfs_rq)
+		return 1;
+
+	return 0;
+}
+
+#else	/* CONFIG_FAIR_GROUP_SCHED */
+
+#define for_each_sched_entity(se) \
+		for (; se; se = NULL)
+
+static inline struct cfs_rq *task_cfs_rq(struct task_struct *p)
+{
+	return &task_rq(p)->cfs;
+}
+
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
+static inline int is_same_group(struct task_struct *curr, struct task_struct *p)
+{
+	return 1;
+}
+
+#endif	/* CONFIG_FAIR_GROUP_SCHED */
+
+/*
+ * The enqueue_task method is called before nr_running is
+ * increased. Here we update the fair scheduling stats and
+ * then put the task into the rbtree:
+ */
+static void enqueue_task_fair(struct rq *rq, struct task_struct *p, int wakeup)
+{
+	struct cfs_rq *cfs_rq;
+	struct sched_entity *se = &p->se;
+
+	for_each_sched_entity(se) {
+		if (se->on_rq)
+			break;
+		cfs_rq = cfs_rq_of(se);
+		enqueue_entity(cfs_rq, se);
+	}
+}
+
+/*
+ * The dequeue_task method is called before nr_running is
+ * decreased. We remove the task from the rbtree and
+ * update the fair scheduling stats:
+ */
+static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int sleep)
+{
+	struct cfs_rq *cfs_rq;
+	struct sched_entity *se = &p->se;
+
+	for_each_sched_entity(se) {
+		cfs_rq = cfs_rq_of(se);
+		dequeue_entity(cfs_rq, se, sleep);
+		/* Don't dequeue parent if it has other entities besides us */
+		if (cfs_rq->weight_sum)
+			break;
+	}
+}
+
+/*
+ * sched_yield() support is very simple - we dequeue and enqueue
+ */
+static void yield_task_fair(struct rq *rq, struct task_struct *p)
+{
+	struct cfs_rq *cfs_rq = task_cfs_rq(p);
+	struct sched_entity *next;
+	__update_rq_clock(rq);
+
+	update_curr(cfs_rq);
+	next = cfs_rq->rb_leftmost;
+	if (next && (kclock_t)(p->se.time_norm - next->time_norm) > 0) {
+		cfs_rq->next = next;
+		return;
+	}
+	cfs_rq->next = &p->se;
+}
+
+/*
+ * Preempt the current task with a newly woken task if needed:
+ */
+static void check_preempt_curr_fair(struct rq *rq, struct task_struct *p)
+{
+	struct task_struct *curr = rq->curr;
+	struct cfs_rq *cfs_rq = task_cfs_rq(curr);
+	unsigned long gran;
+	kclock_t gran_norm;
+
+	if (!cfs_rq->curr || unlikely(rt_prio(p->prio))) {
+		resched_task(curr);
+		return;
+	}
+	update_curr(cfs_rq);
+
+	if (!is_same_group(curr, p) || cfs_rq->rb_leftmost != &p->se)
+		return;
+
+	gran = sysctl_sched_wakeup_granularity;
+	/*
+	 * Batch tasks prefer throughput over latency:
+	 */
+	if (unlikely(p->policy == SCHED_BATCH))
+		gran = sysctl_sched_batch_wakeup_granularity;
+	gran_norm = cfs_rq->curr->load.inv_weight * (kclock_t)gran;
+
+	if (curr->se.time_norm - cfs_rq->run_start >= gran_norm &&
+	    curr->se.time_norm - p->se.time_norm >= gran_norm) {
+		cfs_rq->next = &p->se;
+		resched_task(curr);
+	}
+}
+
+static struct task_struct *pick_next_task_fair(struct rq *rq)
+{
+	struct cfs_rq *cfs_rq = &rq->cfs;
+	struct sched_entity *se;
+
+	if (unlikely(!cfs_rq->nr_running))
+		return NULL;
+
+	if (cfs_rq->nr_running == 1 && cfs_rq->curr)
+		return task_of(cfs_rq->curr);
+
+	do {
+		se = pick_next_entity(cfs_rq);
+		cfs_rq = group_cfs_rq(se);
+	} while (cfs_rq);
+
+	return task_of(se);
+}
+
+/*
+ * Account for a descheduled task:
+ */
+static void put_prev_task_fair(struct rq *rq, struct task_struct *prev)
+{
+	struct sched_entity *se = &prev->se;
+	struct cfs_rq *cfs_rq;
+
+	for_each_sched_entity(se) {
+		cfs_rq = cfs_rq_of(se);
+		put_prev_entity(cfs_rq, se);
+	}
+}
+
+/**************************************************
+ * Fair scheduling class load-balancing methods:
+ */
+
+/*
+ * Load-balancing iterator. Note: while the runqueue stays locked
+ * during the whole iteration, the current task might be
+ * dequeued so the iterator has to be dequeue-safe. Here we
+ * achieve that by always pre-iterating before returning
+ * the current task:
+ */
+static inline struct task_struct *
+__load_balance_iterator(struct cfs_rq *cfs_rq)
+{
+	struct task_struct *p;
+	struct rb_node *curr;
+
+	curr = cfs_rq->rb_load_balance_curr;
+	if (!curr)
+		return NULL;
+
+	p = rb_entry(curr, struct task_struct, se.run_node);
+	cfs_rq->rb_load_balance_curr = rb_next(curr);
+
+	return p;
+}
+
+static struct task_struct *load_balance_start_fair(void *arg)
+{
+	struct cfs_rq *cfs_rq = arg;
+
+	cfs_rq->rb_load_balance_curr = cfs_rq->rb_leftmost ?
+		&cfs_rq->rb_leftmost->run_node : NULL;
+	if (cfs_rq->curr)
+		return rb_entry(&cfs_rq->curr->run_node, struct task_struct, se.run_node);
+
+	return __load_balance_iterator(cfs_rq);
+}
+
+static struct task_struct *load_balance_next_fair(void *arg)
+{
+	struct cfs_rq *cfs_rq = arg;
+
+	return __load_balance_iterator(cfs_rq);
+}
+
+#ifdef CONFIG_FAIR_GROUP_SCHED
+static int cfs_rq_best_prio(struct cfs_rq *cfs_rq)
+{
+	struct sched_entity *curr;
+	struct task_struct *p;
+
+	if (!cfs_rq->nr_running)
+		return MAX_PRIO;
+
+	curr = cfs_rq->rb_leftmost;
+	p = task_of(curr);
+
+	return p->prio;
+}
+#endif
+
+static unsigned long
+load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
+		  unsigned long max_nr_move, unsigned long max_load_move,
+		  struct sched_domain *sd, enum cpu_idle_type idle,
+		  int *all_pinned, int *this_best_prio)
+{
+	struct cfs_rq *busy_cfs_rq;
+	unsigned long load_moved, total_nr_moved = 0, nr_moved;
+	long rem_load_move = max_load_move;
+	struct rq_iterator cfs_rq_iterator;
+
+	cfs_rq_iterator.start = load_balance_start_fair;
+	cfs_rq_iterator.next = load_balance_next_fair;
+
+	for_each_leaf_cfs_rq(busiest, busy_cfs_rq) {
+#ifdef CONFIG_FAIR_GROUP_SCHED
+		struct cfs_rq *this_cfs_rq;
+		long imbalance;
+		unsigned long maxload;
+
+		this_cfs_rq = cpu_cfs_rq(busy_cfs_rq, this_cpu);
+
+		imbalance = busy_cfs_rq->load.weight - this_cfs_rq->load.weight;
+		/* Don't pull if this_cfs_rq has more load than busy_cfs_rq */
+		if (imbalance <= 0)
+			continue;
+
+		/* Don't pull more than imbalance/2 */
+		imbalance /= 2;
+		maxload = min(rem_load_move, imbalance);
+
+		*this_best_prio = cfs_rq_best_prio(this_cfs_rq);
+#else
+# define maxload rem_load_move
+#endif
+		/* pass busy_cfs_rq argument into
+		 * load_balance_[start|next]_fair iterators
+		 */
+		cfs_rq_iterator.arg = busy_cfs_rq;
+		nr_moved = balance_tasks(this_rq, this_cpu, busiest,
+				max_nr_move, maxload, sd, idle, all_pinned,
+				&load_moved, this_best_prio, &cfs_rq_iterator);
+
+		total_nr_moved += nr_moved;
+		max_nr_move -= nr_moved;
+		rem_load_move -= load_moved;
+
+		if (max_nr_move <= 0 || rem_load_move <= 0)
+			break;
+	}
+
+	return max_load_move - rem_load_move;
+}
+
+/*
+ * scheduler tick hitting a task of our scheduling class:
+ */
+static void task_tick_fair(struct rq *rq, struct task_struct *curr)
+{
+	struct cfs_rq *cfs_rq;
+	struct sched_entity *se = &curr->se;
+
+	for_each_sched_entity(se) {
+		cfs_rq = cfs_rq_of(se);
+		entity_tick(cfs_rq, se);
+	}
+}
+
+/*
+ * Share the fairness runtime between parent and child, thus the
+ * total amount of pressure for CPU stays equal - new tasks
+ * get a chance to run but frequent forkers are not allowed to
+ * monopolize the CPU. Note: the parent runqueue is locked,
+ * the child is not running yet.
+ */
+static void task_new_fair(struct rq *rq, struct task_struct *p)
+{
+	struct cfs_rq *cfs_rq = task_cfs_rq(p);
+	struct sched_entity *se = &p->se;
+	kclock_t time;
+
+	sched_info_queued(p);
+
+	time = (rq->curr->se.time_norm - get_time_avg(cfs_rq)) >> 1;
+	cfs_rq->time_sum_off -= (time << rq->curr->se.weight_shift);
+	normalize_time_sum_off(cfs_rq);
+	rq->curr->se.time_norm -= time;
+	se->time_norm = rq->curr->se.time_norm;
+
+	enqueue_entity(cfs_rq, se);
+	p->se.on_rq = 1;
+
+	cfs_rq->next = se;
+	resched_task(rq->curr);
+}
+
+#ifdef CONFIG_FAIR_GROUP_SCHED
+/* Account for a task changing its policy or group.
+ *
+ * This routine is mostly called to set cfs_rq->curr field when a task
+ * migrates between groups/classes.
+ */
+static void set_curr_task_fair(struct rq *rq)
+{
+	struct sched_entity *se = &rq->curr.se;
+
+	for_each_sched_entity(se)
+		set_next_entity(cfs_rq_of(se), se);
+}
+#else
+static void set_curr_task_fair(struct rq *rq)
+{
+}
+#endif
+
+/*
+ * All the scheduling class methods:
+ */
+struct sched_class fair_sched_class __read_mostly = {
+	.enqueue_task		= enqueue_task_fair,
+	.dequeue_task		= dequeue_task_fair,
+	.yield_task		= yield_task_fair,
+
+	.check_preempt_curr	= check_preempt_curr_fair,
+
+	.pick_next_task		= pick_next_task_fair,
+	.put_prev_task		= put_prev_task_fair,
+
+	.load_balance		= load_balance_fair,
+
+	.set_curr_task          = set_curr_task_fair,
+	.task_tick		= task_tick_fair,
+	.task_new		= task_new_fair,
+};
+
+#ifdef CONFIG_SCHED_DEBUG
+static void print_cfs_stats(struct seq_file *m, int cpu)
+{
+	struct cfs_rq *cfs_rq;
+
+	for_each_leaf_cfs_rq(cpu_rq(cpu), cfs_rq)
+		print_cfs_rq(m, cpu, cfs_rq);
+}
+#endif
Index: linux-2.6/kernel/sysctl.c
===================================================================
--- linux-2.6.orig/kernel/sysctl.c
+++ linux-2.6/kernel/sysctl.c
@@ -211,30 +211,16 @@ static ctl_table root_table[] = {
 	{ .ctl_name = 0 }
 };
 
-#ifdef CONFIG_SCHED_DEBUG
 static unsigned long min_sched_granularity_ns = 100000;		/* 100 usecs */
 static unsigned long max_sched_granularity_ns = 1000000000;	/* 1 second */
 static unsigned long min_wakeup_granularity_ns;			/* 0 usecs */
 static unsigned long max_wakeup_granularity_ns = 1000000000;	/* 1 second */
-#endif
 
 static ctl_table kern_table[] = {
-#ifdef CONFIG_SCHED_DEBUG
-	{
-		.ctl_name	= CTL_UNNUMBERED,
-		.procname	= "sched_min_granularity_ns",
-		.data		= &sysctl_sched_min_granularity,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
-		.extra1		= &min_sched_granularity_ns,
-		.extra2		= &max_sched_granularity_ns,
-	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
-		.procname	= "sched_latency_ns",
-		.data		= &sysctl_sched_latency,
+		.procname	= "sched_granularity_ns",
+		.data		= &sysctl_sched_granularity,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_minmax,
@@ -264,6 +250,7 @@ static ctl_table kern_table[] = {
 		.extra1		= &min_wakeup_granularity_ns,
 		.extra2		= &max_wakeup_granularity_ns,
 	},
+#ifdef CONFIG_SCHED_DEBUG
 	{
 		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "sched_stat_granularity_ns",
@@ -277,17 +264,6 @@ static ctl_table kern_table[] = {
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
-		.procname	= "sched_runtime_limit_ns",
-		.data		= &sysctl_sched_runtime_limit,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
-		.extra1		= &min_sched_granularity_ns,
-		.extra2		= &max_sched_granularity_ns,
-	},
-	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "sched_child_runs_first",
 		.data		= &sysctl_sched_child_runs_first,
 		.maxlen		= sizeof(unsigned int),
