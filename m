Return-Path: <linux-kernel-owner+w=401wt.eu-S1763349AbXHaCEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763349AbXHaCEy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 22:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758418AbXHaCEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 22:04:44 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:2389 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754392AbXHaCEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 22:04:41 -0400
Date: Fri, 31 Aug 2007 04:05:12 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: linux-kernel@vger.kernel.org
cc: mingo@elte.hu, peterz@infradead.org
Subject: [ANNOUNCE/RFC] Really Fair Scheduler
Message-ID: <Pine.LNX.4.64.0708310139280.1817@scrub.home>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811837-475143151-1188525912=:1817"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811837-475143151-1188525912=:1817
Content-Type: TEXT/PLAIN; charset=US-ASCII

Hi,

I'm glad to announce a working prototype of the basic algorithm I
already suggested last time.
As I already tried to explain previously CFS has a considerable
algorithmic and computational complexity. This patch should now make it
clearer, why I could so easily skip over Ingo's long explanation of all
the tricks CFS uses to keep the computational overhead low - I simply
don't need them. The following numbers are based on a 2.6.23-rc3-git1 UP
kernel, the first 3 runs are without patch, the last 3 runs are with the
patch:

Xeon 1.86GHz:

Context switching - times in microseconds - smaller is better
-------------------------------------------------------------------------
Host                 OS  2p/0K 2p/16K 2p/64K 8p/16K 8p/64K 16p/16K 16p/64K
                         ctxsw  ctxsw  ctxsw ctxsw  ctxsw   ctxsw   ctxsw
--------- ------------- ------ ------ ------ ------ ------ ------- -------
suse      Linux 2.6.23- 0.9500 1.3900 1.1700 1.6500 1.1700 1.68000 1.22000
suse      Linux 2.6.23- 0.9700 1.3600 1.1400 1.6100 1.1500 1.67000 1.18000
suse      Linux 2.6.23- 0.9800 1.4000 1.1500 1.6600 1.1400 1.70000 1.19000
suse      Linux 2.6.23- 0.7500 1.2000 1.0000 1.4800 0.9800 1.52000 1.06000
suse      Linux 2.6.23- 0.7800 1.2200 0.9800 1.4600 1.0100 1.53000 1.05000
suse      Linux 2.6.23- 0.8300 1.2200 1.0000 1.4800 0.9800 1.52000 1.05000

Celeron 2.66GHz:

Context switching - times in microseconds - smaller is better
-------------------------------------------------------------------------
Host                 OS  2p/0K 2p/16K 2p/64K 8p/16K 8p/64K 16p/16K 16p/64K
                         ctxsw  ctxsw  ctxsw ctxsw  ctxsw   ctxsw   ctxsw
--------- ------------- ------ ------ ------ ------ ------ ------- -------
devel6    Linux 2.6.23- 3.1300 3.3800 5.9000 5.8300   18.1 9.33000 18.0
devel6    Linux 2.6.23- 3.1400 3.2800 7.0700 6.0900   17.6 9.18000 17.8
devel6    Linux 2.6.23- 3.1400 3.6000 3.5400 6.1300   17.2 9.02000 17.2
devel6    Linux 2.6.23- 2.7400 3.0300 5.5200 6.4900   16.6 8.70000 17.0
devel6    Linux 2.6.23- 2.7400 3.2700 8.7700 6.8700   17.1 8.79000 17.4
devel6    Linux 2.6.23- 2.7500 3.3100 5.5600 6.1700   16.8 9.07000 17.2


Besides these numbers I can also provide a mathematical foundation for
it, I tried the same for CFS, but IMHO it's not really sanely possible.
This model is far more accurate than CFS is and doesn't add an error
over time, thus there are no more underflow/overflow anymore within the
described limits.
The small example program also demonstrates how it can be easily scaled
down to millisecond resolution to completely get rid of the 64bit math.
This may be interesting for a few archs even if they have a finer clock
resolution as most scheduling decisions are done on a millisecond basis.

The basic idea of this scheduler is somewhat different than CFS. Where
the old scheduler maintains fixed time slices, CFS still maintains a
dynamic per task time slice. This model does away with it completely,
instead it puts the task on a virtual (normalized) time line, where only
the relative distance between any two task is relevant.

So here all the mathematical details necessary to understand what the
scheduler does, so anyone can judge for himself how solid this design
is. First some basics:

(1)	time = sum_{t}^{T}(time_{t})
(2)	weight_sum = sum_{t}^{T}(weight_{t})

Time per task is calculated with:

(3)	time_{t} = time * weight_{t} / weight_sum

This can be also written as: 

(4)	time_{t} / weight_{t} = time / weight_sum

This way we have the normalized time:

(5)	time_norm = time / weight_sum
(6)	time_norm_{t} = time_{t} / weight_{t}

If every task got its share they are all same. Using time_norm one can
calculate the time tasks should get based on their weight:

(7)	sum_{t}^{T}(time_{t}) = sum_{t}^{T}(round(time / weight_sum) * weight_{t})

This is bascially what CFS currently does and it demonstrates the basic
problem it faces. It rounds the normalized time and the rounding error
is also distributed to the time a task gets, so there is a difference
between the time which is distributed to the tasks and the time consumed
by them. On the upside the error is distributed equally to all tasks
relatively to their weight (so it isn't immediately visible via top). On
the downside the error itself is weighted too and so a small error can
be become quite large and the higher the weight the more it contributes
to the error and the more likely it hits one of the limits. Once it hits
a limit, the overflow/underflow time is simply thrown away and is lost
for accounting and the task doesn't get the time it's supposed to get.

An alternative approach is to not use time_norm at all to distribute the
time. Any task can be used to calculate the time any other task needs
relative to it. For this the normalized time per task is maintained
based on (6):

(8)	time_norm_{t} * 2^16 = time_{t} * round(2^16 / weight_{t})

Using the difference between the normalized times of two tasks, one can
calculate the time it needs to equalize the normalized time.
This has the advantage that round(2^16 / weight_{t}) is constant (unless
reniced) and thus also the error due to the rounding. The time one task
gets relative to another is based on these constants. As only the delta
of these times are needed, the absolute value can simply overflow and
the limit of maximum time delta is:

(9)	time_delta_max = KCLOCK_MAX / (2^16 / weight_min)


The global normalized time is still needed and useful (e.g. waking
tasks) and thus this faces the same issue as CFS right now - managing
the rounding error. This means one can't directly use the real
weight_{t} value anymore without producing new errors, so either one
uses this approximate weight:

(10)	weight_app_{t} = 2^16 / round(2^16 / weight_{t})

or even better would be to get rid of this completely.

Based on (5) and (6) one can calculate the global normalized time as:

(11)	time_norm = sum_{t}^{T}(time_{t}) / sum_{t}^{T}(weight_app_{t})
	          = sum_{t}^{T}(time_norm_{t} * weight_app_{t}) / sum_{t}^{T}(weight_app_{t})

This is now a weighted average and provides the possibility to get rid
of weight_app_{t} by simply replacing it:

(12)	time_norm_app = sum_{t}^{T}(time_norm_{t} * weight_{t}) / sum_{t}^{T}(weight_{t})

This produces only a approximate normalized time, but if all
time_norm_{t} are equal (i.e. all tasks got their share), the result is
the same, thus the error is only temporary. If one already approximates
this value this means value other replacements are possible too. In the
previous example program I simply used 1:

(13)	time_norm_app = sum_{t}^{T}(time_norm_{t}) / T

Another approximation is to use a shift:

(14)	time_norm_app = sum_{t}^{T}(time_norm_{t} * 2^weight_shift_{t}) / sum_{t}^{T}(2^weight_shift_{t})

This helps to avoid a possible full 64 bit multiply and makes other
operations elsewhere simpler too and the result should be close enough.
So by maintaining these two sums one can calculate an approximate
normalized time value:

(15)	time_sum_app = sum_{t}^{T}(time_norm_{t} * 2^weight_shift_{t})
(16)	weight_sum_app = sum_{t}^{T}(2^weight_shift_{t})

Using (6) the dividend can also be written as:

(17)	time_sum_app * 2^16 = sum_{t}^{T}(time_{t} * round(2^16 / weight_{t}) * 2^weight_shift_{t})

The multiplier "round(2^16 / weight_{t}) * 2^weight_shift_{t}" is off at
most by 1.42 (or e(.5*l(2))), so this approximate time sum value grows
almost linearly with the real time and thus the maximum of this sum is
reached approximately after:

(18)	time_max = KCLOCK_MAX / 2^16 / 1.42

The problem now is to avoid this overflow, for this the sum is regularly
updated by splitting it:

(19)	time_sum_app = time_sum_base + time_sum_off

Using this (14) can be written as:

(20)	time_norm_app = (time_sum_base + time_sum_off) / weight_sum_app
	              = time_sum_base / weight_sum_app + time_sum_off / weight_sum_app
	              = time_norm_base + time_sum_off / weight_sum_app

time_norm_base is maintained incrementally be defining this increment:

(21)	time_norm_inc = time_sum_max / weight_sum_app

Everytime time_sum_off exceeds time_sum_max, time_sum_off and
time_norm_base are adjusted appropriately. time_sum_max is scaled so
that the required update frequency is reduced to a minimum, but also so
that time_sum_off can be easily scaled down to a 32 bit value when
needed.

This basically describes the static system, but to allow for sleeping
and waking these sums need adjustments to preserve a proper average:

(22)	weight_app_sum += 2^weight_shift_{new}
(23)	time_sum_max += time_norm_inc * 2^weight_shift_{new}
(24)	time_sum_off += (time_norm_{new} - time_norm_base) * 2^weight_shift_{new}

The last one is a little less obvious, it can be derived from (15) and
(19):

(25)	time_sum_base + time_sum_off = sum_{t}^{T}(time_norm_{t} * 2^weight_shift_{t})
	time_sum_off = sum_{t}^{T}(time_norm_{t} * 2^weight_shift_{t}) - time_sum_base
	             = sum_{t}^{T}(time_norm_{t} * 2^weight_shift_{t}) - time_norm_base * weight_sum_app
	             = sum_{t}^{T}(time_norm_{t} * 2^weight_shift_{t}) - sum_{t}^{T}(time_norm_base * 2^weight_shift_{t})
	             = sum_{t}^{T}((time_norm_{t} - time_norm_base) * 2^weight_shift_{t})

As one can see here time_norm_base is only interesting relative to the
normalized task time and so the same limits apply.

The average from (20) can now be used to calculate the normalized time
for the new task in (24). It can be a given a bonus relative to the
other task or it might be still within a certain limit, as it hasn't
slept long enough. The limit (9) still applies here, so a simple
generation counter may still be needed for long sleeps.
The time_sum_off value used to calculate the average can be scaled down
as mentioned above. As it contains far more resolution than needed for
short time scheduling decisions, the lower bits can be thrown away to
get a 32 bit value. The scaling of time_sum_max makes sure that one
knows the location of the most significant bit, so that the 32 bit is
used as much as possible.


Finally a few more notes about the patch. The current task is not kept
in the tree (just this saves a lot of tree updates), so I faced a
similiar problem as FAIR_GROUP_SCHED, that enqueue_task/dequeue_task can
be called for the current task, so maintaining the current task pointer
for the class is interesting. Instead of adding a set_curr_task it would
be IMO simpler to further reduce the number of indirect calls, e.g. the
deactivate_task/put_prev_task sequence can be replaced with a single
call (and I don't need the sleep/wake arguments anymore, so it can be
reused for that).
I disabled the usage of cpu load as its calculation is also rather 64bit
heavy and I suspect it could be easily scaled down, but this way it's
not my immediate concern.

Ingo, from this point now I need your help, you have to explain to me,
what is missing now relative to CFS. I tried to ask questions, but that
wasn't very successful...

bye, Roman

---
 include/linux/sched.h |   21 -
 kernel/sched.c        |  158 +++++----
 kernel/sched_debug.c  |   26 -
 kernel/sched_norm.c   |  812 ++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 910 insertions(+), 107 deletions(-)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -884,39 +884,28 @@ struct load_weight {
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
 
@@ -1584,21 +1606,12 @@ int fastcall wake_up_state(struct task_s
  */
 static void __sched_fork(struct task_struct *p)
 {
-	p->se.wait_start_fair		= 0;
 	p->se.exec_start		= 0;
 	p->se.sum_exec_runtime		= 0;
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
@@ -1970,6 +1983,7 @@ unsigned long nr_active(void)
 	return running + uninterruptible;
 }
 
+#ifdef CONFIG_SMP
 /*
  * Update rq->cpu_load[] statistics. This function is usually called every
  * scheduler tick (TICK_NSEC).
@@ -2026,8 +2040,6 @@ do_avg:
 	}
 }
 
-#ifdef CONFIG_SMP
-
 /*
  * double_rq_lock - safely lock two runqueues
  *
@@ -3349,7 +3361,9 @@ void scheduler_tick(void)
 	if (unlikely(rq->clock < next_tick))
 		rq->clock = next_tick;
 	rq->tick_timestamp = rq->clock;
+#ifdef CONFIG_SMP
 	update_cpu_load(rq);
+#endif
 	if (curr != rq->idle) /* FIXME: needed? */
 		curr->sched_class->task_tick(rq, curr);
 	spin_unlock(&rq->lock);
@@ -6515,6 +6529,9 @@ static inline void init_cfs_rq(struct cf
 {
 	cfs_rq->tasks_timeline = RB_ROOT;
 	cfs_rq->fair_clock = 1;
+	cfs_rq->time_sum_max = 0;
+	cfs_rq->time_norm_inc = MAX_TIMESUM >> 1;
+	cfs_rq->inc_shift = 0;
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	cfs_rq->rq = rq;
 #endif
@@ -6522,7 +6539,6 @@ static inline void init_cfs_rq(struct cf
 
 void __init sched_init(void)
 {
-	u64 now = sched_clock();
 	int highest_cpu = 0;
 	int i, j;
 
@@ -6547,12 +6563,11 @@ void __init sched_init(void)
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
@@ -6642,16 +6657,7 @@ void normalize_rt_tasks(void)
 
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
 
Index: linux-2.6/kernel/sched_norm.c
===================================================================
--- /dev/null
+++ linux-2.6/kernel/sched_norm.c
@@ -0,0 +1,812 @@
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
+ * (default: 2 msec, units: nanoseconds)
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
+unsigned int sysctl_sched_granularity __read_mostly = 2000000000ULL/HZ;
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
+							10000000000ULL/HZ;
+
+/*
+ * SCHED_OTHER wake-up granularity.
+ * (default: 1 msec, units: nanoseconds)
+ *
+ * This option delays the preemption effects of decoupled workloads
+ * and reduces their over-scheduling. Synchronous workloads will still
+ * have immediate wakeup/sleep latencies.
+ */
+unsigned int sysctl_sched_wakeup_granularity __read_mostly = 1000000000ULL/HZ;
+
+unsigned int sysctl_sched_stat_granularity __read_mostly;
+
+/*
+ * Initialized in sched_init_granularity():
+ */
+unsigned int sysctl_sched_runtime_limit __read_mostly;
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
+static inline void
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
+static inline void
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
+	kclock_t sum = 0;
+
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
+static inline void update_curr(struct cfs_rq *cfs_rq)
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
+
+	while (cfs_rq->time_sum_off >= cfs_rq->time_sum_max) {
+                cfs_rq->time_sum_off -= cfs_rq->time_sum_max;
+                cfs_rq->time_norm_base += cfs_rq->time_norm_inc;
+        }
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
+
+	if (!cfs_rq->curr || unlikely(rt_prio(p->prio))) {
+		resched_task(curr);
+		return;
+	}
+	update_curr(cfs_rq);
+
+	gran = sysctl_sched_wakeup_granularity;
+	/*
+	 * Batch tasks prefer throughput over latency:
+	 */
+	if (unlikely(p->policy == SCHED_BATCH))
+		gran = sysctl_sched_batch_wakeup_granularity;
+
+	if (is_same_group(curr, p) &&
+	    cfs_rq->rb_leftmost == &p->se &&
+	    curr->se.time_norm - p->se.time_norm >= cfs_rq->curr->load.inv_weight * (kclock_t)gran) {
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
---1463811837-475143151-1188525912=:1817
Content-Type: TEXT/x-csrc; charset=US-ASCII; name=fs3.c
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0708310405120.1817@scrub.home>
Content-Description: 
Content-Disposition: attachment; filename=fs3.c

I2luY2x1ZGUgPHN0ZGlvLmg+DQojaW5jbHVkZSA8c3RkbGliLmg+DQojaW5j
bHVkZSA8c3RkaW50Lmg+DQoNCiNpZiAxDQoNCnR5cGVkZWYgaW50NjRfdCBr
Y2xvY2tfdDsNCg0KI2RlZmluZSBNU0VDCQkxMDAwMDAwDQoNCiNkZWZpbmUg
VElDS19TTElDRQkoKGtjbG9ja190KTEwKk1TRUMpDQojZGVmaW5lIE1BWF9T
TElDRQkoKGtjbG9ja190KTEwMCpNU0VDKQ0KDQojZGVmaW5lIE1TSElGVAkJ
MTYNCg0KI2RlZmluZSBNU0NBTEUJCTEwMDAwMDANCg0KI2Vsc2UNCg0KdHlw
ZWRlZiBpbnQzMl90IGtjbG9ja190Ow0KDQojZGVmaW5lIFRJQ0tfU0xJQ0UJ
MTANCiNkZWZpbmUgTUFYX1NMSUNFCTEwMA0KDQojZGVmaW5lIE1TSElGVAkJ
MA0KDQojZGVmaW5lIE1TQ0FMRQkJMQ0KDQojZW5kaWYNCg0KI2RlZmluZSBN
QVhfVElNRVNVTQkoKGtjbG9ja190KTEgPDwgKDMwICsgTVNISUZUKSkNCg0K
I2RlZmluZSBNQVhfVEFTS1MJMjANCg0Kc3RydWN0IHRhc2sgew0KCXVuc2ln
bmVkIGludCB3ZWlnaHQsIHdlaWdodF9pbnY7DQoJaW50IGFjdGl2ZSwgcHJp
bywgd2VpZ2h0X3NoaWZ0Ow0KDQoJa2Nsb2NrX3QgdGltZTsNCglrY2xvY2tf
dCB0aW1lX25vcm0sIHRpbWVfa2V5LCByZXFfd2VpZ2h0X2ludjsNCg0KCWtj
bG9ja190IHJlcV9zaXplOw0KfSB0YXNrW01BWF9UQVNLU10gID0gew0KCXsg
LnByaW8gPSAxMCwgfSwNCgl7IC5wcmlvID0gMjAsIH0sDQoJeyAucHJpbyA9
IDMwLCB9LA0KfTsNCg0KI2lmIDENCi8qIDJeMTYqMS4yNV4oaS0zOSkgKi8N
CnVuc2lnbmVkIGludCB3ZWlnaHRfaW52X3RhYmxlWzQwXSA9IHsNCgkxMSwg
MTQsIDE3LCAyMSwgMjcsIDMzLCA0MiwgNTIsIDY1LCA4MSwNCgkxMDEsIDEy
NywgMTU4LCAxOTgsIDI0OCwgMzA5LCAzODcsIDQ4NCwgNjA0LCA3NTYsDQoJ
OTQ0LCAxMTgxLCAxNDc2LCAxODQ1LCAyMzA2LCAyODgyLCAzNjAzLCA0NTA0
LCA1NjI5LCA3MDM3LA0KCTg3OTYsIDEwOTk1LCAxMzc0NCwgMTcxODAsIDIx
NDc1LCAyNjg0NCwgMzM1NTQsIDQxOTQzLCA1MjQyOSwgNjU1MzYNCn07DQoN
Ci8qIDJeMjAvd2VpZ2h0X2ludl90YWJsZVtpXSAqLw0KdW5zaWduZWQgaW50
IHdlaWdodF90YWJsZVs0MF0gPSB7DQoJOTUzMjUsIDc0ODk4LCA2MTY4MSwg
NDk5MzIsIDM4ODM2LCAzMTc3NSwgMjQ5NjYsIDIwMTY1LCAxNjEzMiwgMTI5
NDUsDQoJMTAzODIsIDgyNTcsIDY2MzcsIDUyOTYsIDQyMjgsIDMzOTMsIDI3
MDksIDIxNjYsIDE3MzYsIDEzODcsDQoJMTExMSwgODg4LCA3MTAsIDU2OCwg
NDU1LCAzNjQsIDI5MSwgMjMzLCAxODYsIDE0OSwNCgkxMTksIDk1LCA3Niwg
NjEsIDQ5LCAzOSwgMzEsIDI1LCAyMCwgMTYNCn07DQoNCi8qIGwoMS4yNV4o
MzktaSkpL2woMikgKi8NCnVuc2lnbmVkIGludCB3ZWlnaHRfc2hpZnRfdGFi
bGVbNDBdID0gew0KCTEzLCAxMiwgMTIsIDEyLCAxMSwgMTEsIDExLCAxMCwg
MTAsIDEwLA0KCTksIDksIDksIDgsIDgsIDgsIDcsIDcsIDcsIDYsDQoJNiwg
NiwgNSwgNSwgNSwgNSwgNCwgNCwgNCwgMywNCgkzLCAzLCAyLCAyLCAyLCAx
LCAxLCAxLCAwLCAwDQp9Ow0KI2Vsc2UNCi8qIDJeMTYqZShsKDIpKigoaS0z
OSkvNSkpICovDQp1bnNpZ25lZCBpbnQgd2VpZ2h0X2ludl90YWJsZVs0MF0g
PSB7DQoJMjk0LCAzMzgsIDM4OCwgNDQ2LCA1MTIsIDU4OCwgNjc2LCA3NzYs
IDg5MSwgMTAyNCwNCgkxMTc2LCAxMzUxLCAxNTUyLCAxNzgzLCAyMDQ4LCAy
MzUzLCAyNzAyLCAzMTA0LCAzNTY2LCA0MDk2LA0KCTQ3MDUsIDU0MDUsIDYy
MDgsIDcxMzIsIDgxOTIsIDk0MTAsIDEwODA5LCAxMjQxNywgMTQyNjMsIDE2
Mzg0LA0KCTE4ODIwLCAyMTYxOSwgMjQ4MzQsIDI4NTI2LCAzMjc2OCwgMzc2
NDEsIDQzMjM4LCA0OTY2NywgNTcwNTIsIDY1NTM2DQp9Ow0KDQovKiAyXjIw
L3dlaWdodF9pbnZfdGFibGVbaV0gKi8NCnVuc2lnbmVkIGludCB3ZWlnaHRf
dGFibGVbNDBdID0gew0KCTM1NjcsIDMxMDIsIDI3MDMsIDIzNTEsIDIwNDgs
IDE3ODMsIDE1NTEsIDEzNTEsIDExNzcsIDEwMjQsDQoJODkyLCA3NzYsIDY3
NiwgNTg4LCA1MTIsIDQ0NiwgMzg4LCAzMzgsIDI5NCwgMjU2LA0KCTIyMywg
MTk0LCAxNjksIDE0NywgMTI4LCAxMTEsIDk3LCA4NCwgNzQsIDY0LA0KCTU2
LCA0OSwgNDIsIDM3LCAzMiwgMjgsIDI0LCAyMSwgMTgsIDE2DQp9Ow0KDQov
KiAoMzktaSkvNSAqLw0KdW5zaWduZWQgaW50IHdlaWdodF9zaGlmdF90YWJs
ZVs0MF0gPSB7DQoJOCwgOCwgNywgNywgNywgNywgNywgNiwgNiwgNiwNCgk2
LCA2LCA1LCA1LCA1LCA1LCA1LCA0LCA0LCA0LA0KCTQsIDQsIDMsIDMsIDMs
IDMsIDMsIDIsIDIsIDIsDQoJMiwgMiwgMSwgMSwgMSwgMSwgMSwgMCwgMCwg
MA0KfTsNCiNlbmRpZg0KDQoNCiNkZWZpbmUgVEFTS19OT1JNKHRzaywgdGlt
ZSkJKCh0aW1lKSAqIHRhc2tbdHNrXS53ZWlnaHRfaW52KQ0KDQovKiB5ZXMs
IHRoaXMgY2FuIGJlIGltcHJvdmVkLi4uICovDQojZGVmaW5lIEtDTE9DS19N
SU4oeCwgeSkJKChrY2xvY2tfdCkoKHgpIC0gKHkpKSA8IDAgPyAoeCkgOiAo
eSkpDQojZGVmaW5lIEtDTE9DS19NQVgoeCwgeSkJKChrY2xvY2tfdCkoKHgp
IC0gKHkpKSA+IDAgPyAoeCkgOiAoeSkpDQoNCmtjbG9ja190IHRpbWVfbm9y
bV9iYXNlLCB0aW1lX25vcm1faW5jLCBydW5fc3RhcnQsIHJ1bl9lbmQ7DQpr
Y2xvY2tfdCB0aW1lX3N1bV9tYXgsIHRpbWVfc3VtX29mZjsNCmludCBjdXJy
ZW50LCB3ZWlnaHRfc3VtLCBpbmNfc2hpZnQ7DQoNCg0Kdm9pZCB0YXNrX2Vu
cXVldWUoaW50IHQpOw0Kdm9pZCB0YXNrX2RlcXVldWUoaW50IHQpOw0KDQoN
CmludCB0YXNrX25leHQodm9pZCkNCnsNCglpbnQgaSwgbmV4dDsNCglzdGF0
aWMgaW50IGxhc3QgPSAtMTsNCg0KCW5leHQgPSAtMTsNCgkvKiB0aGlzIHNo
b3VsZCBiZSBhIHNvcnRlZCB0cmVlLi4uICovDQoJZm9yIChpID0gMDsgaSA8
IE1BWF9UQVNLUzsgaSsrKSB7DQoJCWlmIChpID09IGN1cnJlbnQpDQoJCQlj
b250aW51ZTsNCgkJaWYgKCF0YXNrW2ldLmFjdGl2ZSAmJiB0YXNrW2ldLndl
aWdodCkgew0KCQkJaWYgKCEocmFuZCgpICUgMjApKQ0KCQkJCXRhc2tfZW5x
dWV1ZShpKTsNCgkJfQ0KCQlpZiAoIXRhc2tbaV0uYWN0aXZlKQ0KCQkJY29u
dGludWU7DQoJCWlmIChuZXh0IDwgMCB8fCAoa2Nsb2NrX3QpKHRhc2tbaV0u
dGltZV9rZXkgLSB0YXNrW25leHRdLnRpbWVfa2V5KSA8IDApDQoJCQluZXh0
ID0gaTsNCgl9DQoNCglpZiAobmV4dCA8IDApDQoJCXJldHVybiAtMTsNCg0K
CS8qIHVzaW5nIHRhc2tbY3VycmVudF0udGltZV9ub3JtIHRoaXMgY2FuIGJl
IHVzZWQgdG8gY2FsY3VsYXRlDQoJICogdGhlIHJlYWwgZW5kIHRpbWUgdG8g
ZS5nLiBwcm9ncmFtIGEgdGltZXIuDQoJICovDQoJcnVuX2VuZCA9IHRhc2tb
bmV4dF0udGltZV9ub3JtICsgdGFza1tuZXh0XS5yZXFfd2VpZ2h0X2ludjsN
CglpZiAoY3VycmVudCA+PSAwKQ0KCQlydW5fZW5kID0gS0NMT0NLX01JTihy
dW5fZW5kLCBLQ0xPQ0tfTUFYKHRhc2tbbmV4dF0udGltZV9ub3JtLCANCgkJ
CQkJCQkgcnVuX3N0YXJ0ICsgdGFza1tjdXJyZW50XS5yZXFfd2VpZ2h0X2lu
dikpOw0KCWlmIChsYXN0ICE9IG5leHQpIHsNCgkJcHJpbnRmKCJuZXh0OiAl
dSwlZlxuIiwgbmV4dCwgY3VycmVudCA8IDAgPyAwIDoNCgkJCShkb3VibGUp
KHJ1bl9lbmQgLSB0YXNrW2N1cnJlbnRdLnRpbWVfbm9ybSkgKiB0YXNrW2N1
cnJlbnRdLndlaWdodCAvICgxIDw8IDIwKSAvIE1TQ0FMRSk7DQoJCWxhc3Qg
PSBuZXh0Ow0KCX0NCglyZXR1cm4gbmV4dDsNCn0NCg0Kdm9pZCB0YXNrX3Vw
ZGF0ZV9rZXkoaW50IHQpDQp7DQoJdGFza1t0XS50aW1lX2tleSA9IHRhc2tb
dF0udGltZV9ub3JtICsgdGFza1t0XS5yZXFfd2VpZ2h0X2ludiAvIDI7DQp9
DQoNCnZvaWQgdGFza19zd2l0Y2goaW50IG5leHQpDQp7DQoJaWYgKG5leHQg
PCAwKQ0KCQlyZXR1cm47DQoNCgkvKiBldmVyeSB3ZWlnaHRfc3VtKmluYyB0
aW1lcywgdGltZV9ub3JtX2Jhc2UgaXMgdXBkYXRlZCBieSBpbmMgKi8NCgl3
aGlsZSAodGltZV9zdW1fb2ZmID49IHRpbWVfc3VtX21heCkgew0KCQlwcmlu
dGYoIi0tLVxuIik7DQoJCXRpbWVfc3VtX29mZiAtPSB0aW1lX3N1bV9tYXg7
DQoJCXRpbWVfbm9ybV9iYXNlICs9IHRpbWVfbm9ybV9pbmM7DQoJfQ0KDQoJ
aWYgKGN1cnJlbnQgPj0gMCkNCgkJdGFza191cGRhdGVfa2V5KGN1cnJlbnQp
Ow0KCWN1cnJlbnQgPSBuZXh0Ow0KCXJ1bl9zdGFydCA9IHRhc2tbY3VycmVu
dF0udGltZV9ub3JtOw0KCS8qIHRoaXMgc2V0cyBydW5fZW5kIGFuZCBjYW4g
YmUgdXNlZCB0byBwcm9ncmFtIGEgdGltZXIgKi8NCgl0YXNrX25leHQoKTsN
Cn0NCg0Kdm9pZCB0aW1lcl90aWNrKHZvaWQpDQp7DQoJa2Nsb2NrX3QgdGlt
ZV9zdW07DQoJZG91YmxlIHRpbWVfc3VtMjsNCglpbnQgaSwgd2VpZ3RoX3N1
bTsNCg0KCWlmIChjdXJyZW50ID49IDApIHsNCgkJdGFza1tjdXJyZW50XS50
aW1lICs9IFRJQ0tfU0xJQ0U7DQoJCXRhc2tbY3VycmVudF0udGltZV9ub3Jt
ICs9IFRBU0tfTk9STShjdXJyZW50LCBUSUNLX1NMSUNFKTsNCgkJdGltZV9z
dW1fb2ZmICs9IFRBU0tfTk9STShjdXJyZW50LCBUSUNLX1NMSUNFKSA8PCB0
YXNrW2N1cnJlbnRdLndlaWdodF9zaGlmdDsNCgkJLy9wcmludGYoIiVMeCwl
THgsJUx4XG4iLCAobG9uZyBsb25nKXRpbWVfc3VtX29mZiwgKGxvbmcgbG9u
Zyl0aW1lX3N1bV9tYXgsIChsb25nIGxvbmcpdGltZV9ub3JtX2luYyk7DQoJ
fQ0KDQoJcHJpbnRmKCIlZCIsIGN1cnJlbnQpOw0KCXRpbWVfc3VtID0gd2Vp
Z3RoX3N1bSA9IDA7DQoJdGltZV9zdW0yID0gMDsNCglmb3IgKGkgPSAwOyBp
IDwgTUFYX1RBU0tTOyBpKyspIHsNCgkJaWYgKCF0YXNrW2ldLmFjdGl2ZSkg
ew0KCQkJaWYgKHRhc2tbaV0ud2VpZ2h0KQ0KCQkJCXByaW50ZigiXHQlM3Uv
JXU6IC1cdCIsIGksIHRhc2tbaV0ud2VpZ2h0KTsNCgkJCWNvbnRpbnVlOw0K
CQl9DQoJCXdlaWd0aF9zdW0gKz0gdGFza1tpXS53ZWlnaHQ7DQoJCXRpbWVf
c3VtMiArPSAoZG91YmxlKXRhc2tbaV0udGltZV9ub3JtICogdGFza1tpXS53
ZWlnaHQ7DQoJCXRpbWVfc3VtICs9ICh0YXNrW2ldLnRpbWVfbm9ybSAtIHRp
bWVfbm9ybV9iYXNlKSA8PCB0YXNrW2ldLndlaWdodF9zaGlmdDsNCgkJcHJp
bnRmKCJcdCUzdS8lLjNmOiU1Zi8lLTdmKCUtNWYpIiwgaSwgKGRvdWJsZSl0
YXNrW2ldLndlaWdodCAvICgxIDw8IDQpLCAoZG91YmxlKXRhc2tbaV0udGlt
ZSAvIE1TQ0FMRSwNCgkJCShkb3VibGUpdGFza1tpXS50aW1lX25vcm0gLyAo
MSA8PCAxNikgLyBNU0NBTEUsDQoJCQkoZG91YmxlKShrY2xvY2tfdCkodGlt
ZV9ub3JtX2Jhc2UgKyB0aW1lX3N1bV9vZmYgLyB3ZWlnaHRfc3VtIC0gdGFz
a1tpXS50aW1lX25vcm0pICogdGFza1tpXS53ZWlnaHQgLyAoMSA8PCAyMCkg
LyBNU0NBTEUpOw0KCX0NCglpZiAodGltZV9zdW0gIT0gdGltZV9zdW1fb2Zm
KQ0KCQlhYm9ydCgpOw0KCXByaW50ZigiXHR8ICVmKCVmKVxuIiwgKHRpbWVf
bm9ybV9iYXNlICsgKGRvdWJsZSl0aW1lX3N1bV9vZmYgLyB3ZWlnaHRfc3Vt
KSAvICgxIDw8IDE2KSAvIE1TQ0FMRSwNCgkJKCh0aW1lX3N1bTIgLyB3ZWln
dGhfc3VtKSAtICh0aW1lX25vcm1fYmFzZSArIChkb3VibGUpdGltZV9zdW1f
b2ZmIC8gd2VpZ2h0X3N1bSkpIC8gKDEgPDwgMTYpIC8gTVNDQUxFKTsNCn0N
Cg0Kdm9pZCB0YXNrX2VucXVldWUoaW50IHQpDQp7DQoJa2Nsb2NrX3QgbWlu
X3RpbWU7DQoNCglpZiAoIXdlaWdodF9zdW0pDQoJCWdvdG8gZG9uZTsNCg0K
CW1pbl90aW1lID0gdGltZV9ub3JtX2Jhc2UgLSB0YXNrW3RdLnJlcV93ZWln
aHRfaW52Ow0KCW1pbl90aW1lICs9IChrY2xvY2tfdCkoKGludDMyX3QpKHRp
bWVfc3VtX29mZiA+PiBNU0hJRlQpIC8gd2VpZ2h0X3N1bSkgPDwgTVNISUZU
Ow0KDQoJaWYgKChrY2xvY2tfdCkoKHRhc2tbdF0udGltZV9ub3JtKSAtIG1p
bl90aW1lKSA8IDApDQoJCXRhc2tbdF0udGltZV9ub3JtID0gbWluX3RpbWU7
DQpkb25lOg0KCXRhc2tbdF0uYWN0aXZlID0gMTsNCgl0YXNrX3VwZGF0ZV9r
ZXkodCk7DQoNCgl3ZWlnaHRfc3VtICs9IDEgPDwgdGFza1t0XS53ZWlnaHRf
c2hpZnQ7DQoJLyoga2VlcCB0aW1lX3N1bV9tYXggYmVsb3cgTUFYX1RJTUVT
VU0NCgkgKiB3aGljaCBhbGxvd3MgdG8gZWFzaWx5IGNoYW5nZSBpdCB0byBh
IGxvd2VyIHJlc29sdXRpb24gMzJiaXQgdmFsdWUNCgkgKi8NCglpZiAoaW5j
X3NoaWZ0IDwgdGFza1t0XS53ZWlnaHRfc2hpZnQpIHsNCgkJdGltZV9ub3Jt
X2luYyA+Pj0gdGFza1t0XS53ZWlnaHRfc2hpZnQgLSBpbmNfc2hpZnQ7DQoJ
CXRpbWVfc3VtX21heCA+Pj0gdGFza1t0XS53ZWlnaHRfc2hpZnQgLSBpbmNf
c2hpZnQ7DQoJCWluY19zaGlmdCA9IHRhc2tbdF0ud2VpZ2h0X3NoaWZ0Ow0K
CQkvL3ByaW50ZigidysrKCVkKTolTHgsJUx4XG4iLCBpbmNfc2hpZnQsIChs
b25nIGxvbmcpdGltZV9ub3JtX2luYywgKGxvbmcgbG9uZyl0aW1lX3N1bV9t
YXgpOw0KCX0NCgl0aW1lX3N1bV9tYXggKz0gdGltZV9ub3JtX2luYyA8PCB0
YXNrW3RdLndlaWdodF9zaGlmdDsNCgl3aGlsZSAodGltZV9zdW1fbWF4ID49
IE1BWF9USU1FU1VNKSB7DQoJCXRpbWVfbm9ybV9pbmMgPj49IDE7DQoJCXRp
bWVfc3VtX21heCA+Pj0gMTsNCgkJaW5jX3NoaWZ0Kys7DQoJCS8vcHJpbnRm
KCJ3KyglZCk6JUx4LCVMeFxuIiwgaW5jX3NoaWZ0LCAobG9uZyBsb25nKXRp
bWVfbm9ybV9pbmMsIChsb25nIGxvbmcpdGltZV9zdW1fbWF4KTsNCgl9DQoJ
dGltZV9zdW1fb2ZmICs9ICh0YXNrW3RdLnRpbWVfbm9ybSAtIHRpbWVfbm9y
bV9iYXNlKSA8PCB0YXNrW3RdLndlaWdodF9zaGlmdDsNCglpZiAodGltZV9z
dW1fb2ZmID49IHRpbWVfc3VtX21heCkgew0KCQl0aW1lX3N1bV9vZmYgLT0g
dGltZV9zdW1fbWF4Ow0KCQl0aW1lX25vcm1fYmFzZSArPSB0aW1lX25vcm1f
aW5jOw0KCX0NCn0NCg0Kdm9pZCB0YXNrX2RlcXVldWUoaW50IHQpDQp7DQoJ
dGFza1t0XS5hY3RpdmUgPSAwOw0KCXdlaWdodF9zdW0gLT0gMSA8PCB0YXNr
W3RdLndlaWdodF9zaGlmdDsNCglpZiAoIXdlaWdodF9zdW0pDQoJCWN1cnJl
bnQgPSAtMTsNCgl0aW1lX3N1bV9tYXggLT0gdGltZV9ub3JtX2luYyA8PCB0
YXNrW3RdLndlaWdodF9zaGlmdDsNCglpZiAodGltZV9zdW1fbWF4KSB7DQoJ
CXdoaWxlICh0aW1lX3N1bV9tYXggPCAoTUFYX1RJTUVTVU0gPj4gMSkpIHsN
CgkJCXRpbWVfbm9ybV9pbmMgPDw9IDE7DQoJCQl0aW1lX3N1bV9tYXggPDw9
IDE7DQoJCQlpbmNfc2hpZnQtLTsNCgkJCS8vcHJpbnRmKCJ3LSglZCk6JUx4
LCVMeFxuIiwgaW5jX3NoaWZ0LCAobG9uZyBsb25nKXRpbWVfbm9ybV9pbmMs
IChsb25nIGxvbmcpdGltZV9zdW1fbWF4KTsNCgkJfQ0KCX0gZWxzZSB7DQoJ
CXRpbWVfbm9ybV9pbmMgPSBNQVhfVElNRVNVTSA+PiAxOw0KCQlpbmNfc2hp
ZnQgPSAwOw0KCX0NCgl0aW1lX3N1bV9vZmYgLT0gKHRhc2tbdF0udGltZV9u
b3JtIC0gdGltZV9ub3JtX2Jhc2UpIDw8IHRhc2tbdF0ud2VpZ2h0X3NoaWZ0
Ow0KCWlmICh0aW1lX3N1bV9vZmYgPCAwKSB7DQoJCXRpbWVfc3VtX29mZiAr
PSB0aW1lX3N1bV9tYXg7DQoJCXRpbWVfbm9ybV9iYXNlIC09IHRpbWVfbm9y
bV9pbmM7DQoJfQ0KfQ0KDQppbnQgbWFpbih2b2lkKQ0Kew0KCWludCBpLCBu
ZXh0Ow0KDQoJdGltZV9ub3JtX2luYyA9IE1BWF9USU1FU1VNID4+IDE7DQoJ
d2VpZ2h0X3N1bSA9IDA7DQoJZm9yIChpID0gMDsgaSA8IE1BWF9UQVNLUzsg
aSsrKSB7DQoJCWlmICh0YXNrW2ldLnByaW8gPCAxIHx8IHRhc2tbaV0ucHJp
byA+IDQwKQ0KCQkJY29udGludWU7DQoJCXRhc2tbaV0ud2VpZ2h0ID0gd2Vp
Z2h0X3RhYmxlW3Rhc2tbaV0ucHJpbyAtIDFdOw0KCQl0YXNrW2ldLndlaWdo
dF9pbnYgPSB3ZWlnaHRfaW52X3RhYmxlW3Rhc2tbaV0ucHJpbyAtIDFdOw0K
CQl0YXNrW2ldLndlaWdodF9zaGlmdCA9IHdlaWdodF9zaGlmdF90YWJsZVt0
YXNrW2ldLnByaW8gLSAxXTsNCgkJaWYgKHRhc2tbaV0ucmVxX3NpemUpDQoJ
CQl0YXNrW2ldLnJlcV93ZWlnaHRfaW52ID0gdGFza1tpXS5yZXFfc2l6ZSAq
IHRhc2tbaV0ud2VpZ2h0X2ludjsNCgkJZWxzZQ0KCQkJdGFza1tpXS5yZXFf
d2VpZ2h0X2ludiA9IE1BWF9TTElDRSAqIHRhc2tbaV0ud2VpZ2h0X2ludjsN
CgkJdGFza19lbnF1ZXVlKGkpOw0KCX0NCg0KCWN1cnJlbnQgPSAtMTsNCglm
b3IgKDs7IHRpbWVyX3RpY2soKSkgew0KCQluZXh0ID0gdGFza19uZXh0KCk7
DQoNCgkJaWYgKGN1cnJlbnQgPCAwKSB7DQoJCQl0YXNrX3N3aXRjaChuZXh0
KTsNCgkJCWNvbnRpbnVlOw0KCQl9DQoNCiNpZiAxDQoJCWlmICghKHJhbmQo
KSAlIDEwMCkpIHsNCgkJCXRhc2tfZGVxdWV1ZShjdXJyZW50KTsNCgkJCXRh
c2tfc3dpdGNoKG5leHQpOw0KCQkJY29udGludWU7DQoJCX0NCiNlbmRpZg0K
DQoJCWlmICgoa2Nsb2NrX3QpKHRhc2tbY3VycmVudF0udGltZV9ub3JtIC0g
cnVuX2VuZCkgPj0gMCkNCgkJCXRhc2tfc3dpdGNoKG5leHQpOw0KCX0NCn0N
Cg==

---1463811837-475143151-1188525912=:1817--
