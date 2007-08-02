Return-Path: <linux-kernel-owner+w=401wt.eu-S1757049AbXHBPpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757049AbXHBPpK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 11:45:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbXHBPo6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 11:44:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50927 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031AbXHBPo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 11:44:56 -0400
Date: Thu, 2 Aug 2007 17:44:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <npiggin@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: lmbench ctxsw regression with CFS
Message-ID: <20070802154447.GA13725@elte.hu>
References: <20070802021525.GC15595@wotan.suse.de> <alpine.LFD.0.999.0708011922500.3582@woody.linux-foundation.org> <20070802024132.GD15595@wotan.suse.de> <20070802071956.GA23300@elte.hu> <20070802073123.GB16744@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070802073123.GB16744@wotan.suse.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.0.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Nick Piggin <npiggin@suse.de> wrote:

> > > > One thing to check out is whether the lmbench numbers are 
> > > > "correct". Especially on SMP systems, the lmbench numbers are 
> > > > actually *best* when the two processes run on the same CPU, even 
> > > > though that's not really at all the best scheduling - it's just 
> > > > that it artificially improves lmbench numbers because of the 
> > > > close cache affinity for the pipe data structures.
> > > 
> > > Yes, I bound them to a single core.
> > 
> > could you send me the .config you used?
> 
> Sure, attached...
> 
> You don't see a regression? If not, then can you send me the .config 
> you used? [...]

i used your config to get a few numbers and to see what happens. Here's 
the numbers of 10 consecutive "lat_ctx -s 0 2" runs:

                        [ time in micro-seconds, smaller is better ]

        v2.6.22         v2.6.23-git          v2.6.23-git+const-param
        -------         -----------          -----------------------
         1.30              1.60                       1.19
         1.30              1.36                       1.18
         1.14              1.50                       1.01
         1.26              1.27                       1.23
         1.22              1.40                       1.04
         1.13              1.34                       1.09
         1.27              1.39                       1.05
         1.20              1.30                       1.16
         1.20              1.17                       1.16
         1.25              1.33                       1.01
       -------------------------------------------------------------
  avg:   1.22              1.36 (+11.3%)              1.11 (-10.3%)
  min:   1.13              1.17 ( +3.5%)              1.01 (-11.8%)
  max:   1.27              1.60 (+26.0%)              1.23 ( -3.2%)

one reason for the extra overhead is the current tunability of CFS, but 
that is not fundamental, it's caused by the many knobs that CFS has at 
the moment. The const-tuning patch (attached below, results in the 
rightmost column) changes those knobs to constants, allowing the 
compiler to optimize the math better and reduce code size. (the code 
movement in the patch makes up for most of its size, the change that it 
does is simple otherwise.)

so CFS can be faster at micro-context-switching than 2.6.22. But, at 
this point i'd also like to warn against putting _too_ much emphasis on 
lat_ctx numbers in general. lat_ctx prints a 'derived' micro-benchmark 
number. It uses a pair of pipes to context-switch between tasks but only 
prints the delta overhead that context-switching causes. The 'full' 
latency of the pipe operations can be seen via the following pipe-test.c 
code:

   http://redhat.com/~mingo/cfs-scheduler/tools/pipe-test.c

run it to see the full cost:

   neptune:~> ./pipe-test
   4.67 usecs/loop.
   4.41 usecs/loop.
   4.46 usecs/loop.
   4.46 usecs/loop.
   4.44 usecs/loop.
   4.41 usecs/loop.

so the _full_ cost, of even this micro-benchmark, is 4-5 microseconds, 
not 1 microsecond. So even this artificial micro-benchmark sees an 
actual slowdown of only 2.8%.

if you check a macro-benchmark like "hackbench 50":

         [ time in seconds, smaller is better ]

         v2.6.22              v2.6.23-cfs
         -------              -----------
          3.019                  2.842
          2.994                  2.878
          2.977                  2.882
          3.012                  2.864
          2.996                  2.882

then the difference is even starker because with CFS the _quality_ of 
scheduling decisions has increased. So even if we had increased 
micro-costs (which we wont have once the current tuning period is over 
and we cast the CFS parameters into constants), the quality of 
macro-scheduling can offset that, and not only on the desktop!

so that's why our main focus in CFS was on the macro-properties of 
scheduling _first_, and then the micro-properties are adjusted to the 
macro-constraints as a second layer.

	Ingo

----------------------------->
---
 include/linux/sched.h |    2 
 kernel/sched.c        |  143 +++++++++++++++++++++++++-------------------------
 kernel/sched_fair.c   |   27 +++++----
 kernel/sched_rt.c     |   10 ---
 4 files changed, 92 insertions(+), 90 deletions(-)

Index: linux/include/linux/sched.h
===================================================================
--- linux.orig/include/linux/sched.h
+++ linux/include/linux/sched.h
@@ -1396,6 +1396,7 @@ static inline void idle_task_exit(void) 
 
 extern void sched_idle_next(void);
 
+#ifdef CONFIG_SCHED_DEBUG
 extern unsigned int sysctl_sched_granularity;
 extern unsigned int sysctl_sched_wakeup_granularity;
 extern unsigned int sysctl_sched_batch_wakeup_granularity;
@@ -1403,6 +1404,7 @@ extern unsigned int sysctl_sched_stat_gr
 extern unsigned int sysctl_sched_runtime_limit;
 extern unsigned int sysctl_sched_child_runs_first;
 extern unsigned int sysctl_sched_features;
+#endif
 
 #ifdef CONFIG_RT_MUTEXES
 extern int rt_mutex_getprio(struct task_struct *p);
Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -657,7 +657,7 @@ calc_delta_mine(unsigned long delta_exec
 		tmp = (tmp * lw->inv_weight) >> WMULT_SHIFT;
 	}
 
-	return (unsigned long)min(tmp, (u64)sysctl_sched_runtime_limit);
+	return (unsigned long)min(tmp, (u64)ULONG_MAX);
 }
 
 static inline unsigned long
@@ -678,46 +678,6 @@ static void update_load_sub(struct load_
 	lw->inv_weight = 0;
 }
 
-static void __update_curr_load(struct rq *rq, struct load_stat *ls)
-{
-	if (rq->curr != rq->idle && ls->load.weight) {
-		ls->delta_exec += ls->delta_stat;
-		ls->delta_fair += calc_delta_fair(ls->delta_stat, &ls->load);
-		ls->delta_stat = 0;
-	}
-}
-
-/*
- * Update delta_exec, delta_fair fields for rq.
- *
- * delta_fair clock advances at a rate inversely proportional to
- * total load (rq->ls.load.weight) on the runqueue, while
- * delta_exec advances at the same rate as wall-clock (provided
- * cpu is not idle).
- *
- * delta_exec / delta_fair is a measure of the (smoothened) load on this
- * runqueue over any given interval. This (smoothened) load is used
- * during load balance.
- *
- * This function is called /before/ updating rq->ls.load
- * and when switching tasks.
- */
-static void update_curr_load(struct rq *rq, u64 now)
-{
-	struct load_stat *ls = &rq->ls;
-	u64 start;
-
-	start = ls->load_update_start;
-	ls->load_update_start = now;
-	ls->delta_stat += now - start;
-	/*
-	 * Stagger updates to ls->delta_fair. Very frequent updates
-	 * can be expensive.
-	 */
-	if (ls->delta_stat >= sysctl_sched_stat_granularity)
-		__update_curr_load(rq, ls);
-}
-
 /*
  * To aid in avoiding the subversion of "niceness" due to uneven distribution
  * of tasks with abnormal "nice" values across CPUs the contribution that
@@ -781,32 +741,6 @@ static const u32 prio_to_wmult[40] = {
 /*  15 */ 119304647, 148102320, 186737708, 238609294, 286331153,
 };
 
-static inline void
-inc_load(struct rq *rq, const struct task_struct *p, u64 now)
-{
-	update_curr_load(rq, now);
-	update_load_add(&rq->ls.load, p->se.load.weight);
-}
-
-static inline void
-dec_load(struct rq *rq, const struct task_struct *p, u64 now)
-{
-	update_curr_load(rq, now);
-	update_load_sub(&rq->ls.load, p->se.load.weight);
-}
-
-static inline void inc_nr_running(struct task_struct *p, struct rq *rq, u64 now)
-{
-	rq->nr_running++;
-	inc_load(rq, p, now);
-}
-
-static inline void dec_nr_running(struct task_struct *p, struct rq *rq, u64 now)
-{
-	rq->nr_running--;
-	dec_load(rq, p, now);
-}
-
 static void activate_task(struct rq *rq, struct task_struct *p, int wakeup);
 
 /*
@@ -837,6 +771,72 @@ static int balance_tasks(struct rq *this
 
 #define sched_class_highest (&rt_sched_class)
 
+static void __update_curr_load(struct rq *rq, struct load_stat *ls)
+{
+	if (rq->curr != rq->idle && ls->load.weight) {
+		ls->delta_exec += ls->delta_stat;
+		ls->delta_fair += calc_delta_fair(ls->delta_stat, &ls->load);
+		ls->delta_stat = 0;
+	}
+}
+
+/*
+ * Update delta_exec, delta_fair fields for rq.
+ *
+ * delta_fair clock advances at a rate inversely proportional to
+ * total load (rq->ls.load.weight) on the runqueue, while
+ * delta_exec advances at the same rate as wall-clock (provided
+ * cpu is not idle).
+ *
+ * delta_exec / delta_fair is a measure of the (smoothened) load on this
+ * runqueue over any given interval. This (smoothened) load is used
+ * during load balance.
+ *
+ * This function is called /before/ updating rq->ls.load
+ * and when switching tasks.
+ */
+static void update_curr_load(struct rq *rq, u64 now)
+{
+	struct load_stat *ls = &rq->ls;
+	u64 start;
+
+	start = ls->load_update_start;
+	ls->load_update_start = now;
+	ls->delta_stat += now - start;
+	/*
+	 * Stagger updates to ls->delta_fair. Very frequent updates
+	 * can be expensive.
+	 */
+	if (ls->delta_stat >= sysctl_sched_stat_granularity)
+		__update_curr_load(rq, ls);
+}
+
+static inline void
+inc_load(struct rq *rq, const struct task_struct *p, u64 now)
+{
+	update_curr_load(rq, now);
+	update_load_add(&rq->ls.load, p->se.load.weight);
+}
+
+static inline void
+dec_load(struct rq *rq, const struct task_struct *p, u64 now)
+{
+	update_curr_load(rq, now);
+	update_load_sub(&rq->ls.load, p->se.load.weight);
+}
+
+static inline void inc_nr_running(struct task_struct *p, struct rq *rq, u64 now)
+{
+	rq->nr_running++;
+	inc_load(rq, p, now);
+}
+
+static inline void dec_nr_running(struct task_struct *p, struct rq *rq, u64 now)
+{
+	rq->nr_running--;
+	dec_load(rq, p, now);
+}
+
 static void set_load_weight(struct task_struct *p)
 {
 	task_rq(p)->cfs.wait_runtime -= p->se.wait_runtime;
@@ -1661,8 +1661,10 @@ void fastcall wake_up_new_task(struct ta
 
 	p->prio = effective_prio(p);
 
-	if (!sysctl_sched_child_runs_first || (clone_flags & CLONE_VM) ||
-			task_cpu(p) != this_cpu || !current->se.on_rq) {
+	if (!p->sched_class->task_new || !sysctl_sched_child_runs_first ||
+			(clone_flags & CLONE_VM) || task_cpu(p) != this_cpu ||
+			!current->se.on_rq) {
+
 		activate_task(rq, p, 0);
 	} else {
 		/*
@@ -1670,6 +1672,7 @@ void fastcall wake_up_new_task(struct ta
 		 * management (if any):
 		 */
 		p->sched_class->task_new(rq, p);
+		inc_nr_running(p, rq, rq_clock(rq));
 	}
 	check_preempt_curr(rq, p);
 	task_rq_unlock(rq, &flags);
@@ -4864,6 +4867,7 @@ cpumask_t nohz_cpu_mask = CPU_MASK_NONE;
  */
 static inline void sched_init_granularity(void)
 {
+#ifdef CONFIG_SCHED_DEBUG
 	unsigned int factor = 1 + ilog2(num_online_cpus());
 	const unsigned long gran_limit = 100000000;
 
@@ -4873,6 +4877,7 @@ static inline void sched_init_granularit
 
 	sysctl_sched_runtime_limit = sysctl_sched_granularity * 4;
 	sysctl_sched_wakeup_granularity = sysctl_sched_granularity / 2;
+#endif
 }
 
 #ifdef CONFIG_SMP
Index: linux/kernel/sched_fair.c
===================================================================
--- linux.orig/kernel/sched_fair.c
+++ linux/kernel/sched_fair.c
@@ -18,6 +18,15 @@
  */
 
 /*
+ * Tunables that become constants when CONFIG_SCHED_DEBUG is off:
+ */
+#ifdef CONFIG_SCHED_DEBUG
+# define const_debug __read_mostly
+#else
+# define const_debug static const
+#endif
+
+/*
  * Preemption granularity:
  * (default: 2 msec, units: nanoseconds)
  *
@@ -31,7 +40,7 @@
  * number of CPUs. (i.e. factor 2x on 2-way systems, 3x on 4-way
  * systems, 4x on 8-way systems, 5x on 16-way systems, etc.)
  */
-unsigned int sysctl_sched_granularity __read_mostly = 2000000000ULL/HZ;
+const_debug unsigned int sysctl_sched_granularity = 2000000000ULL/HZ;
 
 /*
  * SCHED_BATCH wake-up granularity.
@@ -41,8 +50,8 @@ unsigned int sysctl_sched_granularity __
  * and reduces their over-scheduling. Synchronous workloads will still
  * have immediate wakeup/sleep latencies.
  */
-unsigned int sysctl_sched_batch_wakeup_granularity __read_mostly =
-							10000000000ULL/HZ;
+const_debug unsigned int
+sysctl_sched_batch_wakeup_granularity = 10000000000ULL/HZ;
 
 /*
  * SCHED_OTHER wake-up granularity.
@@ -52,14 +61,11 @@ unsigned int sysctl_sched_batch_wakeup_g
  * and reduces their over-scheduling. Synchronous workloads will still
  * have immediate wakeup/sleep latencies.
  */
-unsigned int sysctl_sched_wakeup_granularity __read_mostly = 1000000000ULL/HZ;
+const_debug unsigned int sysctl_sched_wakeup_granularity = 1000000000ULL/HZ;
 
-unsigned int sysctl_sched_stat_granularity __read_mostly;
+const_debug unsigned int sysctl_sched_stat_granularity;
 
-/*
- * Initialized in sched_init_granularity():
- */
-unsigned int sysctl_sched_runtime_limit __read_mostly;
+const_debug unsigned int sysctl_sched_runtime_limit = 4000000000ULL/HZ;
 
 /*
  * Debugging: various feature bits
@@ -73,7 +79,7 @@ enum {
 	SCHED_FEAT_SKIP_INITIAL		= 32,
 };
 
-unsigned int sysctl_sched_features __read_mostly =
+const_debug unsigned int sysctl_sched_features __read_mostly =
 		SCHED_FEAT_FAIR_SLEEPERS	*1 |
 		SCHED_FEAT_SLEEPER_AVG		*1 |
 		SCHED_FEAT_SLEEPER_LOAD_AVG	*1 |
@@ -1072,7 +1078,6 @@ static void task_new_fair(struct rq *rq,
 		p->se.wait_runtime = -(sysctl_sched_granularity / 2);
 
 	__enqueue_entity(cfs_rq, se);
-	inc_nr_running(p, rq, now);
 }
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
Index: linux/kernel/sched_rt.c
===================================================================
--- linux.orig/kernel/sched_rt.c
+++ linux/kernel/sched_rt.c
@@ -229,15 +229,6 @@ static void task_tick_rt(struct rq *rq, 
 	requeue_task_rt(rq, p);
 }
 
-/*
- * No parent/child timeslice management necessary for RT tasks,
- * just activate them:
- */
-static void task_new_rt(struct rq *rq, struct task_struct *p)
-{
-	activate_task(rq, p, 1);
-}
-
 static struct sched_class rt_sched_class __read_mostly = {
 	.enqueue_task		= enqueue_task_rt,
 	.dequeue_task		= dequeue_task_rt,
@@ -251,5 +242,4 @@ static struct sched_class rt_sched_class
 	.load_balance		= load_balance_rt,
 
 	.task_tick		= task_tick_rt,
-	.task_new		= task_new_rt,
 };
