Return-Path: <linux-kernel-owner+w=401wt.eu-S1754320Ab0AEH77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320Ab0AEH77 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 02:59:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754147Ab0AEH76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 02:59:58 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:40263 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754130Ab0AEH75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 02:59:57 -0500
Date: Tue, 5 Jan 2010 13:29:34 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pavel Emelyanov <xemul@openvz.org>,
       Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
       Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
       Mike Waychison <mikew@google.com>
Subject: [RFC v5 PATCH 2/8] sched: Make rt bandwidth timer and runtime
	related code generic
Message-ID: <20100105075934.GG27899@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20100105075703.GE27899@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100105075703.GE27899@in.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sched: Make rt bandwidth timer and runtime related code generic

From: Bharata B Rao <bharata@linux.vnet.ibm.com>

CFS hard limits requires most of the rt bandwidth timer and runtime related
code. Hence make it generic (move generic parts from sched_rt.c to
sched.c) and make it available for CFS to use.

- Separate out the runtime related fields of rt_rq (rt_throttled, rt_time,
  rt_runtime, rt_runtime_lock) into a new generic structure rq_bandwidth.
- Rename sched_rt_period_mask() to sched_bw_period_mask() and move it to
  sched.c
- Make start_sched_bandwidth() generic so that it can be used by both
  rt and cfs.
- Make disable[enable]_runtime() generic and move them to sched.c so that
  they can be used by cfs also.
- Make rt runtime balancing code generic and move it to sched.c so that
  cfs can make use of it.

No functionality change by this patch.

Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 kernel/sched.c       |  283 ++++++++++++++++++++++++++++++++++++++++++++++----
 kernel/sched_debug.c |    6 +
 kernel/sched_rt.c    |  256 ++++++---------------------------------------
 3 files changed, 298 insertions(+), 247 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 21cf0d5..4a24d62 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -151,7 +151,7 @@ static struct sched_bandwidth def_rt_bandwidth;
 
 static int do_sched_rt_period_timer(struct sched_bandwidth *sched_b, int overrun);
 
-static enum hrtimer_restart sched_rt_period_timer(struct hrtimer *timer)
+static enum hrtimer_restart sched_period_timer(struct hrtimer *timer, int rt)
 {
 	struct sched_bandwidth *sched_b =
 		container_of(timer, struct sched_bandwidth, period_timer);
@@ -166,12 +166,18 @@ static enum hrtimer_restart sched_rt_period_timer(struct hrtimer *timer)
 		if (!overrun)
 			break;
 
-		idle = do_sched_rt_period_timer(sched_b, overrun);
+		if (rt)
+			idle = do_sched_rt_period_timer(sched_b, overrun);
 	}
 
 	return idle ? HRTIMER_NORESTART : HRTIMER_RESTART;
 }
 
+static enum hrtimer_restart sched_rt_period_timer(struct hrtimer *timer)
+{
+	return sched_period_timer(timer, 1);
+}
+
 static void init_sched_bandwidth(struct sched_bandwidth *sched_b, u64 period,
 	u64 runtime, enum hrtimer_restart (*period_timer)(struct hrtimer *))
 {
@@ -190,11 +196,14 @@ static inline int rt_bandwidth_enabled(void)
 	return sysctl_sched_rt_runtime >= 0;
 }
 
-static void start_sched_bandwidth(struct sched_bandwidth *sched_b)
+static void start_sched_bandwidth(struct sched_bandwidth *sched_b, int rt)
 {
 	ktime_t now;
 
-	if (!rt_bandwidth_enabled() || sched_b->runtime == RUNTIME_INF)
+	if (rt && !rt_bandwidth_enabled())
+		return;
+
+	if (sched_b->runtime == RUNTIME_INF)
 		return;
 
 	if (hrtimer_active(&sched_b->period_timer))
@@ -220,10 +229,12 @@ static void start_sched_bandwidth(struct sched_bandwidth *sched_b)
 	raw_spin_unlock(&sched_b->runtime_lock);
 }
 
+#if defined CONFIG_RT_GROUP_SCHED || defined CONFIG_FAIR_GROUP_SCHED
 static void destroy_sched_bandwidth(struct sched_bandwidth *sched_b)
 {
 	hrtimer_cancel(&sched_b->period_timer);
 }
+#endif
 
 /*
  * sched_domains_mutex serializes calls to arch_init_sched_domains,
@@ -383,6 +394,14 @@ static inline struct task_group *task_group(struct task_struct *p)
 
 #endif	/* CONFIG_GROUP_SCHED */
 
+struct rq_bandwidth {
+	int throttled;
+	u64 time;
+	u64 runtime;
+	/* Nests inside the rq lock: */
+	raw_spinlock_t runtime_lock;
+};
+
 /* CFS-related fields in a runqueue */
 struct cfs_rq {
 	struct load_weight load;
@@ -464,11 +483,7 @@ struct rt_rq {
 	int overloaded;
 	struct plist_head pushable_tasks;
 #endif
-	int rt_throttled;
-	u64 rt_time;
-	u64 rt_runtime;
-	/* Nests inside the rq lock: */
-	raw_spinlock_t rt_runtime_lock;
+	struct rq_bandwidth rq_bandwidth;
 
 #ifdef CONFIG_RT_GROUP_SCHED
 	unsigned long rt_nr_boosted;
@@ -1832,6 +1847,234 @@ static inline void __set_task_cpu(struct task_struct *p, unsigned int cpu)
 #endif
 }
 
+
+#if defined(CONFIG_RT_GROUP_SCHED) || defined(CONFIG_FAIR_GROUP_SCHED)
+
+#ifdef CONFIG_SMP
+static inline const struct cpumask *sched_bw_period_mask(void)
+{
+	return cpu_rq(smp_processor_id())->rd->span;
+}
+#else /* !CONFIG_SMP */
+static inline const struct cpumask *sched_bw_period_mask(void)
+{
+	return cpu_online_mask;
+}
+#endif /* CONFIG_SMP */
+
+#else
+static inline const struct cpumask *sched_bw_period_mask(void)
+{
+	return cpu_online_mask;
+}
+
+#endif
+
+static void init_rq_bandwidth(struct rq_bandwidth *rq_b, u64 runtime)
+{
+	rq_b->time = 0;
+	rq_b->throttled = 0;
+	rq_b->runtime = runtime;
+	raw_spin_lock_init(&rq_b->runtime_lock);
+}
+
+#ifdef CONFIG_RT_GROUP_SCHED
+
+static inline
+struct rt_rq *sched_rt_period_rt_rq(struct sched_bandwidth *rt_b, int cpu)
+{
+	return container_of(rt_b, struct task_group, rt_bandwidth)->rt_rq[cpu];
+}
+
+#else
+
+static inline
+struct rt_rq *sched_rt_period_rt_rq(struct sched_bandwidth *rt_b, int cpu)
+{
+	return &cpu_rq(cpu)->rt;
+}
+
+#endif
+
+#ifdef CONFIG_SMP
+
+void __disable_runtime(struct rq *rq, struct sched_bandwidth *sched_b,
+		struct rq_bandwidth *rq_b, int rt)
+{
+	struct root_domain *rd = rq->rd;
+	s64 want;
+	int i;
+
+	raw_spin_lock(&sched_b->runtime_lock);
+	raw_spin_lock(&rq_b->runtime_lock);
+
+	/*
+	 * Either we're all inf and nobody needs to borrow, or we're
+	 * already disabled and thus have nothing to do, or we have
+	 * exactly the right amount of runtime to take out.
+	 */
+	if (rq_b->runtime == RUNTIME_INF || rq_b->runtime == sched_b->runtime)
+		goto balanced;
+
+	raw_spin_unlock(&rq_b->runtime_lock);
+
+	/*
+	 * Calculate the difference between what we started out with
+	 * and what we current have, that's the amount of runtime
+	 * we lend and now have to reclaim.
+	 */
+	want = sched_b->runtime - rq_b->runtime;
+
+	/*
+	 * Greedy reclaim, take back as much as we can.
+	 */
+	for_each_cpu(i, rd->span) {
+		struct rq_bandwidth *iter;
+		s64 diff;
+
+		if (rt)
+			iter = &(sched_rt_period_rt_rq(sched_b, i)->rq_bandwidth);
+		/*
+		 * Can't reclaim from ourselves or disabled runqueues.
+		 */
+		if (iter == rq_b || iter->runtime == RUNTIME_INF)
+			continue;
+
+		raw_spin_lock(&iter->runtime_lock);
+		if (want > 0) {
+			diff = min_t(s64, iter->runtime, want);
+			iter->runtime -= diff;
+			want -= diff;
+		} else {
+			iter->runtime -= want;
+			want -= want;
+		}
+		raw_spin_unlock(&iter->runtime_lock);
+
+		if (!want)
+			break;
+	}
+
+	raw_spin_lock(&rq_b->runtime_lock);
+	/*
+	 * We cannot be left wanting - that would mean some runtime
+	 * leaked out of the system.
+	 */
+	BUG_ON(want);
+
+balanced:
+	/*
+	 * Disable all the borrow logic by pretending we have inf
+	 * runtime - in which case borrowing doesn't make sense.
+	 */
+	rq_b->runtime = RUNTIME_INF;
+	raw_spin_unlock(&rq_b->runtime_lock);
+	raw_spin_unlock(&sched_b->runtime_lock);
+}
+
+void disable_runtime_rt(struct rq *rq);
+static void disable_runtime(struct rq *rq)
+{
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&rq->lock, flags);
+	disable_runtime_rt(rq);
+	raw_spin_unlock_irqrestore(&rq->lock, flags);
+}
+
+void __enable_runtime(struct sched_bandwidth *sched_b,
+		struct rq_bandwidth *rq_b)
+{
+	raw_spin_lock(&sched_b->runtime_lock);
+	raw_spin_lock(&rq_b->runtime_lock);
+	rq_b->runtime = sched_b->runtime;
+	rq_b->time = 0;
+	rq_b->throttled = 0;
+	raw_spin_unlock(&rq_b->runtime_lock);
+	raw_spin_unlock(&sched_b->runtime_lock);
+}
+
+void enable_runtime_rt(struct rq *rq);
+static void enable_runtime(struct rq *rq)
+{
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&rq->lock, flags);
+	enable_runtime_rt(rq);
+	raw_spin_unlock_irqrestore(&rq->lock, flags);
+}
+
+/*
+ * We ran out of runtime, see if we can borrow some from our neighbours.
+ */
+static void do_balance_runtime(struct rq_bandwidth *rq_b,
+		struct sched_bandwidth *sched_b, int rt)
+{
+	struct root_domain *rd = cpu_rq(smp_processor_id())->rd;
+	int i, weight;
+	u64 period;
+
+	weight = cpumask_weight(rd->span);
+
+	raw_spin_lock(&sched_b->runtime_lock);
+	period = ktime_to_ns(sched_b->period);
+	for_each_cpu(i, rd->span) {
+		struct rq_bandwidth *iter;
+		s64 diff;
+
+		if (rt)
+			iter = &(sched_rt_period_rt_rq(sched_b, i)->rq_bandwidth);
+		if (iter == rq_b)
+			continue;
+
+		raw_spin_lock(&iter->runtime_lock);
+		/*
+		 * Either all rqs have inf runtime and there's nothing to steal
+		 * or __disable_runtime() below sets a specific rq to inf to
+		 * indicate its been disabled and disalow stealing.
+		 */
+		if (iter->runtime == RUNTIME_INF)
+			goto next;
+
+		/*
+		 * From runqueues with spare time, take 1/n part of their
+		 * spare time, but no more than our period.
+		 */
+		diff = iter->runtime - iter->time;
+		if (diff > 0) {
+			diff = div_u64((u64)diff, weight);
+			if (rq_b->runtime + diff > period)
+				diff = period - rq_b->runtime;
+			iter->runtime -= diff;
+			rq_b->runtime += diff;
+			if (rq_b->runtime == period) {
+				raw_spin_unlock(&iter->runtime_lock);
+				break;
+			}
+		}
+next:
+		raw_spin_unlock(&iter->runtime_lock);
+	}
+	raw_spin_unlock(&sched_b->runtime_lock);
+}
+
+static void balance_runtime(struct rq_bandwidth *rq_b,
+		struct sched_bandwidth *sched_b, int rt)
+{
+	if (rq_b->time > rq_b->runtime) {
+		raw_spin_unlock(&rq_b->runtime_lock);
+		do_balance_runtime(rq_b, sched_b, rt);
+		raw_spin_lock(&rq_b->runtime_lock);
+	}
+}
+#else /* !CONFIG_SMP */
+static inline void balance_runtime(struct rq_bandwidth *rq_b,
+		struct sched_bandwidth *sched_b, int rt)
+{
+	return;
+}
+#endif /* CONFIG_SMP */
+
 #include "sched_stats.h"
 #include "sched_idletask.c"
 #include "sched_fair.c"
@@ -9381,11 +9624,7 @@ static void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq)
 	rt_rq->overloaded = 0;
 	plist_head_init_raw(&rt_rq->pushable_tasks, &rq->lock);
 #endif
-
-	rt_rq->rt_time = 0;
-	rt_rq->rt_throttled = 0;
-	rt_rq->rt_runtime = 0;
-	raw_spin_lock_init(&rt_rq->rt_runtime_lock);
+	init_rq_bandwidth(&rt_rq->rq_bandwidth, 0);
 
 #ifdef CONFIG_RT_GROUP_SCHED
 	rt_rq->rt_nr_boosted = 0;
@@ -9433,7 +9672,7 @@ static void init_tg_rt_entry(struct task_group *tg, struct rt_rq *rt_rq,
 	init_rt_rq(rt_rq, rq);
 	rt_rq->tg = tg;
 	rt_rq->rt_se = rt_se;
-	rt_rq->rt_runtime = tg->rt_bandwidth.runtime;
+	rt_rq->rq_bandwidth.runtime = tg->rt_bandwidth.runtime;
 	if (add)
 		list_add(&rt_rq->leaf_rt_rq_list, &rq->leaf_rt_rq_list);
 
@@ -9597,7 +9836,7 @@ void __init sched_init(void)
 #endif
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
-		rq->rt.rt_runtime = def_rt_bandwidth.runtime;
+		rq->rt.rq_bandwidth.runtime = def_rt_bandwidth.runtime;
 #ifdef CONFIG_RT_GROUP_SCHED
 		INIT_LIST_HEAD(&rq->leaf_rt_rq_list);
 #ifdef CONFIG_CGROUP_SCHED
@@ -10332,9 +10571,9 @@ static int tg_set_bandwidth(struct task_group *tg,
 	for_each_possible_cpu(i) {
 		struct rt_rq *rt_rq = tg->rt_rq[i];
 
-		raw_spin_lock(&rt_rq->rt_runtime_lock);
-		rt_rq->rt_runtime = rt_runtime;
-		raw_spin_unlock(&rt_rq->rt_runtime_lock);
+		raw_spin_lock(&rt_rq->rq_bandwidth.runtime_lock);
+		rt_rq->rq_bandwidth.runtime = rt_runtime;
+		raw_spin_unlock(&rt_rq->rq_bandwidth.runtime_lock);
 	}
 	raw_spin_unlock_irq(&tg->rt_bandwidth.runtime_lock);
  unlock:
@@ -10445,9 +10684,9 @@ static int sched_rt_global_constraints(void)
 	for_each_possible_cpu(i) {
 		struct rt_rq *rt_rq = &cpu_rq(i)->rt;
 
-		raw_spin_lock(&rt_rq->rt_runtime_lock);
-		rt_rq->rt_runtime = global_rt_runtime();
-		raw_spin_unlock(&rt_rq->rt_runtime_lock);
+		raw_spin_lock(&rt_rq->rq_bandwidth.runtime_lock);
+		rt_rq->rq_bandwidth.runtime = global_rt_runtime();
+		raw_spin_unlock(&rt_rq->rq_bandwidth.runtime_lock);
 	}
 	raw_spin_unlock_irqrestore(&def_rt_bandwidth.runtime_lock, flags);
 
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 67f95aa..1b67698 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -238,9 +238,9 @@ void print_rt_rq(struct seq_file *m, int cpu, struct rt_rq *rt_rq)
 	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", #x, SPLIT_NS(rt_rq->x))
 
 	P(rt_nr_running);
-	P(rt_throttled);
-	PN(rt_time);
-	PN(rt_runtime);
+	P(rq_bandwidth.throttled);
+	PN(rq_bandwidth.time);
+	PN(rq_bandwidth.runtime);
 
 #undef PN
 #undef P
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 1827a10..7531d0f 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -175,7 +175,7 @@ static inline u64 sched_rt_runtime(struct rt_rq *rt_rq)
 	if (!rt_rq->tg)
 		return RUNTIME_INF;
 
-	return rt_rq->rt_runtime;
+	return rt_rq->rq_bandwidth.runtime;
 }
 
 static inline u64 sched_rt_period(struct rt_rq *rt_rq)
@@ -220,7 +220,7 @@ static void sched_rt_rq_dequeue(struct rt_rq *rt_rq)
 
 static inline int rt_rq_throttled(struct rt_rq *rt_rq)
 {
-	return rt_rq->rt_throttled && !rt_rq->rt_nr_boosted;
+	return rt_rq->rq_bandwidth.throttled && !rt_rq->rt_nr_boosted;
 }
 
 static int rt_se_boosted(struct sched_rt_entity *rt_se)
@@ -235,24 +235,6 @@ static int rt_se_boosted(struct sched_rt_entity *rt_se)
 	return p->prio != p->normal_prio;
 }
 
-#ifdef CONFIG_SMP
-static inline const struct cpumask *sched_rt_period_mask(void)
-{
-	return cpu_rq(smp_processor_id())->rd->span;
-}
-#else
-static inline const struct cpumask *sched_rt_period_mask(void)
-{
-	return cpu_online_mask;
-}
-#endif
-
-static inline
-struct rt_rq *sched_rt_period_rt_rq(struct sched_bandwidth *rt_b, int cpu)
-{
-	return container_of(rt_b, struct task_group, rt_bandwidth)->rt_rq[cpu];
-}
-
 static inline struct sched_bandwidth *sched_rt_bandwidth(struct rt_rq *rt_rq)
 {
 	return &rt_rq->tg->rt_bandwidth;
@@ -262,7 +244,7 @@ static inline struct sched_bandwidth *sched_rt_bandwidth(struct rt_rq *rt_rq)
 
 static inline u64 sched_rt_runtime(struct rt_rq *rt_rq)
 {
-	return rt_rq->rt_runtime;
+	return rt_rq->rq_bandwidth.runtime;
 }
 
 static inline u64 sched_rt_period(struct rt_rq *rt_rq)
@@ -293,18 +275,7 @@ static inline void sched_rt_rq_dequeue(struct rt_rq *rt_rq)
 
 static inline int rt_rq_throttled(struct rt_rq *rt_rq)
 {
-	return rt_rq->rt_throttled;
-}
-
-static inline const struct cpumask *sched_rt_period_mask(void)
-{
-	return cpu_online_mask;
-}
-
-static inline
-struct rt_rq *sched_rt_period_rt_rq(struct sched_bandwidth *rt_b, int cpu)
-{
-	return &cpu_rq(cpu)->rt;
+	return rt_rq->rq_bandwidth.throttled;
 }
 
 static inline struct sched_bandwidth *sched_rt_bandwidth(struct rt_rq *rt_rq)
@@ -315,151 +286,24 @@ static inline struct sched_bandwidth *sched_rt_bandwidth(struct rt_rq *rt_rq)
 #endif /* CONFIG_RT_GROUP_SCHED */
 
 #ifdef CONFIG_SMP
-/*
- * We ran out of runtime, see if we can borrow some from our neighbours.
- */
-static int do_balance_runtime(struct rt_rq *rt_rq)
-{
-	struct sched_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
-	struct root_domain *rd = cpu_rq(smp_processor_id())->rd;
-	int i, weight, more = 0;
-	u64 rt_period;
-
-	weight = cpumask_weight(rd->span);
-
-	raw_spin_lock(&rt_b->runtime_lock);
-	rt_period = ktime_to_ns(rt_b->period);
-	for_each_cpu(i, rd->span) {
-		struct rt_rq *iter = sched_rt_period_rt_rq(rt_b, i);
-		s64 diff;
-
-		if (iter == rt_rq)
-			continue;
-
-		raw_spin_lock(&iter->rt_runtime_lock);
-		/*
-		 * Either all rqs have inf runtime and there's nothing to steal
-		 * or __disable_runtime() below sets a specific rq to inf to
-		 * indicate its been disabled and disalow stealing.
-		 */
-		if (iter->rt_runtime == RUNTIME_INF)
-			goto next;
-
-		/*
-		 * From runqueues with spare time, take 1/n part of their
-		 * spare time, but no more than our period.
-		 */
-		diff = iter->rt_runtime - iter->rt_time;
-		if (diff > 0) {
-			diff = div_u64((u64)diff, weight);
-			if (rt_rq->rt_runtime + diff > rt_period)
-				diff = rt_period - rt_rq->rt_runtime;
-			iter->rt_runtime -= diff;
-			rt_rq->rt_runtime += diff;
-			more = 1;
-			if (rt_rq->rt_runtime == rt_period) {
-				raw_spin_unlock(&iter->rt_runtime_lock);
-				break;
-			}
-		}
-next:
-		raw_spin_unlock(&iter->rt_runtime_lock);
-	}
-	raw_spin_unlock(&rt_b->runtime_lock);
-
-	return more;
-}
 
 /*
  * Ensure this RQ takes back all the runtime it lend to its neighbours.
  */
-static void __disable_runtime(struct rq *rq)
+void disable_runtime_rt(struct rq *rq)
 {
-	struct root_domain *rd = rq->rd;
 	struct rt_rq *rt_rq;
 
 	if (unlikely(!scheduler_running))
 		return;
 
 	for_each_leaf_rt_rq(rt_rq, rq) {
-		struct sched_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
-		s64 want;
-		int i;
-
-		raw_spin_lock(&rt_b->runtime_lock);
-		raw_spin_lock(&rt_rq->rt_runtime_lock);
-		/*
-		 * Either we're all inf and nobody needs to borrow, or we're
-		 * already disabled and thus have nothing to do, or we have
-		 * exactly the right amount of runtime to take out.
-		 */
-		if (rt_rq->rt_runtime == RUNTIME_INF ||
-				rt_rq->rt_runtime == rt_b->runtime)
-			goto balanced;
-		raw_spin_unlock(&rt_rq->rt_runtime_lock);
-
-		/*
-		 * Calculate the difference between what we started out with
-		 * and what we current have, that's the amount of runtime
-		 * we lend and now have to reclaim.
-		 */
-		want = rt_b->runtime - rt_rq->rt_runtime;
-
-		/*
-		 * Greedy reclaim, take back as much as we can.
-		 */
-		for_each_cpu(i, rd->span) {
-			struct rt_rq *iter = sched_rt_period_rt_rq(rt_b, i);
-			s64 diff;
-
-			/*
-			 * Can't reclaim from ourselves or disabled runqueues.
-			 */
-			if (iter == rt_rq || iter->rt_runtime == RUNTIME_INF)
-				continue;
-
-			raw_spin_lock(&iter->rt_runtime_lock);
-			if (want > 0) {
-				diff = min_t(s64, iter->rt_runtime, want);
-				iter->rt_runtime -= diff;
-				want -= diff;
-			} else {
-				iter->rt_runtime -= want;
-				want -= want;
-			}
-			raw_spin_unlock(&iter->rt_runtime_lock);
-
-			if (!want)
-				break;
-		}
-
-		raw_spin_lock(&rt_rq->rt_runtime_lock);
-		/*
-		 * We cannot be left wanting - that would mean some runtime
-		 * leaked out of the system.
-		 */
-		BUG_ON(want);
-balanced:
-		/*
-		 * Disable all the borrow logic by pretending we have inf
-		 * runtime - in which case borrowing doesn't make sense.
-		 */
-		rt_rq->rt_runtime = RUNTIME_INF;
-		raw_spin_unlock(&rt_rq->rt_runtime_lock);
-		raw_spin_unlock(&rt_b->runtime_lock);
+		struct sched_bandwidth *sched_b = sched_rt_bandwidth(rt_rq);
+		__disable_runtime(rq, sched_b, &rt_rq->rq_bandwidth, 1);
 	}
 }
 
-static void disable_runtime(struct rq *rq)
-{
-	unsigned long flags;
-
-	raw_spin_lock_irqsave(&rq->lock, flags);
-	__disable_runtime(rq);
-	raw_spin_unlock_irqrestore(&rq->lock, flags);
-}
-
-static void __enable_runtime(struct rq *rq)
+void enable_runtime_rt(struct rq *rq)
 {
 	struct rt_rq *rt_rq;
 
@@ -470,45 +314,12 @@ static void __enable_runtime(struct rq *rq)
 	 * Reset each runqueue's bandwidth settings
 	 */
 	for_each_leaf_rt_rq(rt_rq, rq) {
-		struct sched_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
-
-		raw_spin_lock(&rt_b->runtime_lock);
-		raw_spin_lock(&rt_rq->rt_runtime_lock);
-		rt_rq->rt_runtime = rt_b->runtime;
-		rt_rq->rt_time = 0;
-		rt_rq->rt_throttled = 0;
-		raw_spin_unlock(&rt_rq->rt_runtime_lock);
-		raw_spin_unlock(&rt_b->runtime_lock);
+		struct sched_bandwidth *sched_b = sched_rt_bandwidth(rt_rq);
+		__enable_runtime(sched_b, &rt_rq->rq_bandwidth);
 	}
 }
 
-static void enable_runtime(struct rq *rq)
-{
-	unsigned long flags;
-
-	raw_spin_lock_irqsave(&rq->lock, flags);
-	__enable_runtime(rq);
-	raw_spin_unlock_irqrestore(&rq->lock, flags);
-}
-
-static int balance_runtime(struct rt_rq *rt_rq)
-{
-	int more = 0;
-
-	if (rt_rq->rt_time > rt_rq->rt_runtime) {
-		raw_spin_unlock(&rt_rq->rt_runtime_lock);
-		more = do_balance_runtime(rt_rq);
-		raw_spin_lock(&rt_rq->rt_runtime_lock);
-	}
-
-	return more;
-}
-#else /* !CONFIG_SMP */
-static inline int balance_runtime(struct rt_rq *rt_rq)
-{
-	return 0;
-}
-#endif /* CONFIG_SMP */
+#endif
 
 static int do_sched_rt_period_timer(struct sched_bandwidth *rt_b, int overrun)
 {
@@ -518,28 +329,29 @@ static int do_sched_rt_period_timer(struct sched_bandwidth *rt_b, int overrun)
 	if (!rt_bandwidth_enabled() || rt_b->runtime == RUNTIME_INF)
 		return 1;
 
-	span = sched_rt_period_mask();
+	span = sched_bw_period_mask();
 	for_each_cpu(i, span) {
 		int enqueue = 0;
 		struct rt_rq *rt_rq = sched_rt_period_rt_rq(rt_b, i);
 		struct rq *rq = rq_of_rt_rq(rt_rq);
 
 		raw_spin_lock(&rq->lock);
-		if (rt_rq->rt_time) {
+		if (rt_rq->rq_bandwidth.time) {
 			u64 runtime;
 
-			raw_spin_lock(&rt_rq->rt_runtime_lock);
-			if (rt_rq->rt_throttled)
-				balance_runtime(rt_rq);
-			runtime = rt_rq->rt_runtime;
-			rt_rq->rt_time -= min(rt_rq->rt_time, overrun*runtime);
-			if (rt_rq->rt_throttled && rt_rq->rt_time < runtime) {
-				rt_rq->rt_throttled = 0;
+			raw_spin_lock(&rt_rq->rq_bandwidth.runtime_lock);
+			if (rt_rq->rq_bandwidth.throttled)
+				balance_runtime(&rt_rq->rq_bandwidth,
+					sched_rt_bandwidth(rt_rq), 1);
+			runtime = rt_rq->rq_bandwidth.runtime;
+			rt_rq->rq_bandwidth.time -= min(rt_rq->rq_bandwidth.time, overrun*runtime);
+			if (rt_rq->rq_bandwidth.throttled && rt_rq->rq_bandwidth.time < runtime) {
+				rt_rq->rq_bandwidth.throttled = 0;
 				enqueue = 1;
 			}
-			if (rt_rq->rt_time || rt_rq->rt_nr_running)
+			if (rt_rq->rq_bandwidth.time || rt_rq->rt_nr_running)
 				idle = 0;
-			raw_spin_unlock(&rt_rq->rt_runtime_lock);
+			raw_spin_unlock(&rt_rq->rq_bandwidth.runtime_lock);
 		} else if (rt_rq->rt_nr_running)
 			idle = 0;
 
@@ -567,19 +379,19 @@ static int sched_rt_runtime_exceeded(struct rt_rq *rt_rq)
 {
 	u64 runtime = sched_rt_runtime(rt_rq);
 
-	if (rt_rq->rt_throttled)
+	if (rt_rq->rq_bandwidth.throttled)
 		return rt_rq_throttled(rt_rq);
 
 	if (sched_rt_runtime(rt_rq) >= sched_rt_period(rt_rq))
 		return 0;
 
-	balance_runtime(rt_rq);
+	balance_runtime(&rt_rq->rq_bandwidth, sched_rt_bandwidth(rt_rq), 1);
 	runtime = sched_rt_runtime(rt_rq);
 	if (runtime == RUNTIME_INF)
 		return 0;
 
-	if (rt_rq->rt_time > runtime) {
-		rt_rq->rt_throttled = 1;
+	if (rt_rq->rq_bandwidth.time > runtime) {
+		rt_rq->rq_bandwidth.throttled = 1;
 		if (rt_rq_throttled(rt_rq)) {
 			sched_rt_rq_dequeue(rt_rq);
 			return 1;
@@ -624,11 +436,11 @@ static void update_curr_rt(struct rq *rq)
 		rt_rq = rt_rq_of_se(rt_se);
 
 		if (sched_rt_runtime(rt_rq) != RUNTIME_INF) {
-			raw_spin_lock(&rt_rq->rt_runtime_lock);
-			rt_rq->rt_time += delta_exec;
+			raw_spin_lock(&rt_rq->rq_bandwidth.runtime_lock);
+			rt_rq->rq_bandwidth.time += delta_exec;
 			if (sched_rt_runtime_exceeded(rt_rq))
 				resched_task(curr);
-			raw_spin_unlock(&rt_rq->rt_runtime_lock);
+			raw_spin_unlock(&rt_rq->rq_bandwidth.runtime_lock);
 		}
 	}
 }
@@ -753,7 +565,7 @@ inc_rt_group(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 		rt_rq->rt_nr_boosted++;
 
 	if (rt_rq->tg)
-		start_sched_bandwidth(&rt_rq->tg->rt_bandwidth);
+		start_sched_bandwidth(&rt_rq->tg->rt_bandwidth, 1);
 }
 
 static void
@@ -770,7 +582,7 @@ dec_rt_group(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 static void
 inc_rt_group(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 {
-	start_sched_bandwidth(&def_rt_bandwidth);
+	start_sched_bandwidth(&def_rt_bandwidth, 1);
 }
 
 static inline
@@ -1551,7 +1363,7 @@ static void rq_online_rt(struct rq *rq)
 	if (rq->rt.overloaded)
 		rt_set_overload(rq);
 
-	__enable_runtime(rq);
+	enable_runtime_rt(rq);
 
 	cpupri_set(&rq->rd->cpupri, rq->cpu, rq->rt.highest_prio.curr);
 }
@@ -1562,7 +1374,7 @@ static void rq_offline_rt(struct rq *rq)
 	if (rq->rt.overloaded)
 		rt_clear_overload(rq);
 
-	__disable_runtime(rq);
+	disable_runtime_rt(rq);
 
 	cpupri_set(&rq->rd->cpupri, rq->cpu, CPUPRI_INVALID);
 }
