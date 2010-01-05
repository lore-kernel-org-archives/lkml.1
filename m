Return-Path: <linux-kernel-owner+w=401wt.eu-S1754290Ab0AEH6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290Ab0AEH6t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 02:58:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754247Ab0AEH6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 02:58:48 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:43228 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754246Ab0AEH6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 02:58:47 -0500
Date: Tue, 5 Jan 2010 13:28:24 +0530
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
Subject: [RFC v5 PATCH 1/8] sched: Rename struct rt_bandwidth to
	sched_bandwidth
Message-ID: <20100105075824.GF27899@in.ibm.com>
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

sched: Rename struct rt_bandwidth to sched_bandwidth

From: Dhaval Giani <dhaval@linux.vnet.ibm.com>

Rename struct rt_bandwidth to sched_bandwidth and rename some of the
routines to generic names (s/rt_/sched_) so that they can be used
by CFS hard limits code in the subsequent patches.

No functionality change by this patch.

Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 kernel/sched.c    |  127 ++++++++++++++++++++++++++---------------------------
 kernel/sched_rt.c |   46 ++++++++++---------
 2 files changed, 86 insertions(+), 87 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index c535cc4..21cf0d5 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -139,50 +139,50 @@ struct rt_prio_array {
 	struct list_head queue[MAX_RT_PRIO];
 };
 
-struct rt_bandwidth {
+struct sched_bandwidth {
 	/* nests inside the rq lock: */
-	raw_spinlock_t		rt_runtime_lock;
-	ktime_t			rt_period;
-	u64			rt_runtime;
-	struct hrtimer		rt_period_timer;
+	raw_spinlock_t		runtime_lock;
+	ktime_t			period;
+	u64			runtime;
+	struct hrtimer		period_timer;
 };
 
-static struct rt_bandwidth def_rt_bandwidth;
+static struct sched_bandwidth def_rt_bandwidth;
 
-static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun);
+static int do_sched_rt_period_timer(struct sched_bandwidth *sched_b, int overrun);
 
 static enum hrtimer_restart sched_rt_period_timer(struct hrtimer *timer)
 {
-	struct rt_bandwidth *rt_b =
-		container_of(timer, struct rt_bandwidth, rt_period_timer);
+	struct sched_bandwidth *sched_b =
+		container_of(timer, struct sched_bandwidth, period_timer);
 	ktime_t now;
 	int overrun;
 	int idle = 0;
 
 	for (;;) {
 		now = hrtimer_cb_get_time(timer);
-		overrun = hrtimer_forward(timer, now, rt_b->rt_period);
+		overrun = hrtimer_forward(timer, now, sched_b->period);
 
 		if (!overrun)
 			break;
 
-		idle = do_sched_rt_period_timer(rt_b, overrun);
+		idle = do_sched_rt_period_timer(sched_b, overrun);
 	}
 
 	return idle ? HRTIMER_NORESTART : HRTIMER_RESTART;
 }
 
-static
-void init_rt_bandwidth(struct rt_bandwidth *rt_b, u64 period, u64 runtime)
+static void init_sched_bandwidth(struct sched_bandwidth *sched_b, u64 period,
+	u64 runtime, enum hrtimer_restart (*period_timer)(struct hrtimer *))
 {
-	rt_b->rt_period = ns_to_ktime(period);
-	rt_b->rt_runtime = runtime;
+	sched_b->period = ns_to_ktime(period);
+	sched_b->runtime = runtime;
 
-	raw_spin_lock_init(&rt_b->rt_runtime_lock);
+	raw_spin_lock_init(&sched_b->runtime_lock);
 
-	hrtimer_init(&rt_b->rt_period_timer,
+	hrtimer_init(&sched_b->period_timer,
 			CLOCK_MONOTONIC, HRTIMER_MODE_REL);
-	rt_b->rt_period_timer.function = sched_rt_period_timer;
+	sched_b->period_timer.function = *period_timer;
 }
 
 static inline int rt_bandwidth_enabled(void)
@@ -190,42 +190,40 @@ static inline int rt_bandwidth_enabled(void)
 	return sysctl_sched_rt_runtime >= 0;
 }
 
-static void start_rt_bandwidth(struct rt_bandwidth *rt_b)
+static void start_sched_bandwidth(struct sched_bandwidth *sched_b)
 {
 	ktime_t now;
 
-	if (!rt_bandwidth_enabled() || rt_b->rt_runtime == RUNTIME_INF)
+	if (!rt_bandwidth_enabled() || sched_b->runtime == RUNTIME_INF)
 		return;
 
-	if (hrtimer_active(&rt_b->rt_period_timer))
+	if (hrtimer_active(&sched_b->period_timer))
 		return;
 
-	raw_spin_lock(&rt_b->rt_runtime_lock);
+	raw_spin_lock(&sched_b->runtime_lock);
 	for (;;) {
 		unsigned long delta;
 		ktime_t soft, hard;
 
-		if (hrtimer_active(&rt_b->rt_period_timer))
+		if (hrtimer_active(&sched_b->period_timer))
 			break;
 
-		now = hrtimer_cb_get_time(&rt_b->rt_period_timer);
-		hrtimer_forward(&rt_b->rt_period_timer, now, rt_b->rt_period);
+		now = hrtimer_cb_get_time(&sched_b->period_timer);
+		hrtimer_forward(&sched_b->period_timer, now, sched_b->period);
 
-		soft = hrtimer_get_softexpires(&rt_b->rt_period_timer);
-		hard = hrtimer_get_expires(&rt_b->rt_period_timer);
+		soft = hrtimer_get_softexpires(&sched_b->period_timer);
+		hard = hrtimer_get_expires(&sched_b->period_timer);
 		delta = ktime_to_ns(ktime_sub(hard, soft));
-		__hrtimer_start_range_ns(&rt_b->rt_period_timer, soft, delta,
+		__hrtimer_start_range_ns(&sched_b->period_timer, soft, delta,
 				HRTIMER_MODE_ABS_PINNED, 0);
 	}
-	raw_spin_unlock(&rt_b->rt_runtime_lock);
+	raw_spin_unlock(&sched_b->runtime_lock);
 }
 
-#ifdef CONFIG_RT_GROUP_SCHED
-static void destroy_rt_bandwidth(struct rt_bandwidth *rt_b)
+static void destroy_sched_bandwidth(struct sched_bandwidth *sched_b)
 {
-	hrtimer_cancel(&rt_b->rt_period_timer);
+	hrtimer_cancel(&sched_b->period_timer);
 }
-#endif
 
 /*
  * sched_domains_mutex serializes calls to arch_init_sched_domains,
@@ -263,7 +261,7 @@ struct task_group {
 	struct sched_rt_entity **rt_se;
 	struct rt_rq **rt_rq;
 
-	struct rt_bandwidth rt_bandwidth;
+	struct sched_bandwidth rt_bandwidth;
 #endif
 
 	struct rcu_head rcu;
@@ -6344,7 +6342,7 @@ recheck:
 		 * assigned.
 		 */
 		if (rt_bandwidth_enabled() && rt_policy(policy) &&
-				task_group(p)->rt_bandwidth.rt_runtime == 0)
+				task_group(p)->rt_bandwidth.runtime == 0)
 			return -EPERM;
 #endif
 
@@ -9435,7 +9433,7 @@ static void init_tg_rt_entry(struct task_group *tg, struct rt_rq *rt_rq,
 	init_rt_rq(rt_rq, rq);
 	rt_rq->tg = tg;
 	rt_rq->rt_se = rt_se;
-	rt_rq->rt_runtime = tg->rt_bandwidth.rt_runtime;
+	rt_rq->rt_runtime = tg->rt_bandwidth.runtime;
 	if (add)
 		list_add(&rt_rq->leaf_rt_rq_list, &rq->leaf_rt_rq_list);
 
@@ -9516,15 +9514,15 @@ void __init sched_init(void)
 	init_defrootdomain();
 #endif
 
-	init_rt_bandwidth(&def_rt_bandwidth,
-			global_rt_period(), global_rt_runtime());
+	init_sched_bandwidth(&def_rt_bandwidth, global_rt_period(),
+			global_rt_runtime(), &sched_rt_period_timer);
 
 #ifdef CONFIG_RT_GROUP_SCHED
-	init_rt_bandwidth(&init_task_group.rt_bandwidth,
-			global_rt_period(), global_rt_runtime());
+	init_sched_bandwidth(&init_task_group.rt_bandwidth, global_rt_period(),
+			global_rt_runtime(), &sched_rt_period_timer);
 #ifdef CONFIG_USER_SCHED
-	init_rt_bandwidth(&root_task_group.rt_bandwidth,
-			global_rt_period(), RUNTIME_INF);
+	init_sched_bandwidth(&root_task_group.rt_bandwidth, global_rt_period(),
+			RUNTIME_INF, &sched_rt_period_timer);
 #endif /* CONFIG_USER_SCHED */
 #endif /* CONFIG_RT_GROUP_SCHED */
 
@@ -9599,7 +9597,7 @@ void __init sched_init(void)
 #endif
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
-		rq->rt.rt_runtime = def_rt_bandwidth.rt_runtime;
+		rq->rt.rt_runtime = def_rt_bandwidth.runtime;
 #ifdef CONFIG_RT_GROUP_SCHED
 		INIT_LIST_HEAD(&rq->leaf_rt_rq_list);
 #ifdef CONFIG_CGROUP_SCHED
@@ -9920,7 +9918,7 @@ static void free_rt_sched_group(struct task_group *tg)
 {
 	int i;
 
-	destroy_rt_bandwidth(&tg->rt_bandwidth);
+	destroy_sched_bandwidth(&tg->rt_bandwidth);
 
 	for_each_possible_cpu(i) {
 		if (tg->rt_rq)
@@ -9948,8 +9946,9 @@ int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
 	if (!tg->rt_se)
 		goto err;
 
-	init_rt_bandwidth(&tg->rt_bandwidth,
-			ktime_to_ns(def_rt_bandwidth.rt_period), 0);
+	init_sched_bandwidth(&tg->rt_bandwidth,
+			ktime_to_ns(def_rt_bandwidth.period), 0,
+			&sched_rt_period_timer);
 
 	for_each_possible_cpu(i) {
 		rq = cpu_rq(i);
@@ -10248,8 +10247,8 @@ static int tg_schedulable(struct task_group *tg, void *data)
 	unsigned long total, sum = 0;
 	u64 period, runtime;
 
-	period = ktime_to_ns(tg->rt_bandwidth.rt_period);
-	runtime = tg->rt_bandwidth.rt_runtime;
+	period = ktime_to_ns(tg->rt_bandwidth.period);
+	runtime = tg->rt_bandwidth.runtime;
 
 	if (tg == d->tg) {
 		period = d->rt_period;
@@ -10287,8 +10286,8 @@ static int tg_schedulable(struct task_group *tg, void *data)
 	 * The sum of our children's runtime should not exceed our own.
 	 */
 	list_for_each_entry_rcu(child, &tg->children, siblings) {
-		period = ktime_to_ns(child->rt_bandwidth.rt_period);
-		runtime = child->rt_bandwidth.rt_runtime;
+		period = ktime_to_ns(child->rt_bandwidth.period);
+		runtime = child->rt_bandwidth.runtime;
 
 		if (child == d->tg) {
 			period = d->rt_period;
@@ -10326,9 +10325,9 @@ static int tg_set_bandwidth(struct task_group *tg,
 	if (err)
 		goto unlock;
 
-	raw_spin_lock_irq(&tg->rt_bandwidth.rt_runtime_lock);
-	tg->rt_bandwidth.rt_period = ns_to_ktime(rt_period);
-	tg->rt_bandwidth.rt_runtime = rt_runtime;
+	raw_spin_lock_irq(&tg->rt_bandwidth.runtime_lock);
+	tg->rt_bandwidth.period = ns_to_ktime(rt_period);
+	tg->rt_bandwidth.runtime = rt_runtime;
 
 	for_each_possible_cpu(i) {
 		struct rt_rq *rt_rq = tg->rt_rq[i];
@@ -10337,7 +10336,7 @@ static int tg_set_bandwidth(struct task_group *tg,
 		rt_rq->rt_runtime = rt_runtime;
 		raw_spin_unlock(&rt_rq->rt_runtime_lock);
 	}
-	raw_spin_unlock_irq(&tg->rt_bandwidth.rt_runtime_lock);
+	raw_spin_unlock_irq(&tg->rt_bandwidth.runtime_lock);
  unlock:
 	read_unlock(&tasklist_lock);
 	mutex_unlock(&rt_constraints_mutex);
@@ -10349,7 +10348,7 @@ int sched_group_set_rt_runtime(struct task_group *tg, long rt_runtime_us)
 {
 	u64 rt_runtime, rt_period;
 
-	rt_period = ktime_to_ns(tg->rt_bandwidth.rt_period);
+	rt_period = ktime_to_ns(tg->rt_bandwidth.period);
 	rt_runtime = (u64)rt_runtime_us * NSEC_PER_USEC;
 	if (rt_runtime_us < 0)
 		rt_runtime = RUNTIME_INF;
@@ -10361,10 +10360,10 @@ long sched_group_rt_runtime(struct task_group *tg)
 {
 	u64 rt_runtime_us;
 
-	if (tg->rt_bandwidth.rt_runtime == RUNTIME_INF)
+	if (tg->rt_bandwidth.runtime == RUNTIME_INF)
 		return -1;
 
-	rt_runtime_us = tg->rt_bandwidth.rt_runtime;
+	rt_runtime_us = tg->rt_bandwidth.runtime;
 	do_div(rt_runtime_us, NSEC_PER_USEC);
 	return rt_runtime_us;
 }
@@ -10374,7 +10373,7 @@ int sched_group_set_rt_period(struct task_group *tg, long rt_period_us)
 	u64 rt_runtime, rt_period;
 
 	rt_period = (u64)rt_period_us * NSEC_PER_USEC;
-	rt_runtime = tg->rt_bandwidth.rt_runtime;
+	rt_runtime = tg->rt_bandwidth.runtime;
 
 	if (rt_period == 0)
 		return -EINVAL;
@@ -10386,7 +10385,7 @@ long sched_group_rt_period(struct task_group *tg)
 {
 	u64 rt_period_us;
 
-	rt_period_us = ktime_to_ns(tg->rt_bandwidth.rt_period);
+	rt_period_us = ktime_to_ns(tg->rt_bandwidth.period);
 	do_div(rt_period_us, NSEC_PER_USEC);
 	return rt_period_us;
 }
@@ -10420,7 +10419,7 @@ static int sched_rt_global_constraints(void)
 int sched_rt_can_attach(struct task_group *tg, struct task_struct *tsk)
 {
 	/* Don't accept realtime tasks when there is no way for them to run */
-	if (rt_task(tsk) && tg->rt_bandwidth.rt_runtime == 0)
+	if (rt_task(tsk) && tg->rt_bandwidth.runtime == 0)
 		return 0;
 
 	return 1;
@@ -10442,7 +10441,7 @@ static int sched_rt_global_constraints(void)
 	if (sysctl_sched_rt_runtime == 0)
 		return -EBUSY;
 
-	raw_spin_lock_irqsave(&def_rt_bandwidth.rt_runtime_lock, flags);
+	raw_spin_lock_irqsave(&def_rt_bandwidth.runtime_lock, flags);
 	for_each_possible_cpu(i) {
 		struct rt_rq *rt_rq = &cpu_rq(i)->rt;
 
@@ -10450,7 +10449,7 @@ static int sched_rt_global_constraints(void)
 		rt_rq->rt_runtime = global_rt_runtime();
 		raw_spin_unlock(&rt_rq->rt_runtime_lock);
 	}
-	raw_spin_unlock_irqrestore(&def_rt_bandwidth.rt_runtime_lock, flags);
+	raw_spin_unlock_irqrestore(&def_rt_bandwidth.runtime_lock, flags);
 
 	return 0;
 }
@@ -10476,8 +10475,8 @@ int sched_rt_handler(struct ctl_table *table, int write,
 			sysctl_sched_rt_period = old_period;
 			sysctl_sched_rt_runtime = old_runtime;
 		} else {
-			def_rt_bandwidth.rt_runtime = global_rt_runtime();
-			def_rt_bandwidth.rt_period =
+			def_rt_bandwidth.runtime = global_rt_runtime();
+			def_rt_bandwidth.period =
 				ns_to_ktime(global_rt_period());
 		}
 	}
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index f48328a..1827a10 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -180,7 +180,7 @@ static inline u64 sched_rt_runtime(struct rt_rq *rt_rq)
 
 static inline u64 sched_rt_period(struct rt_rq *rt_rq)
 {
-	return ktime_to_ns(rt_rq->tg->rt_bandwidth.rt_period);
+	return ktime_to_ns(rt_rq->tg->rt_bandwidth.period);
 }
 
 #define for_each_leaf_rt_rq(rt_rq, rq) \
@@ -248,12 +248,12 @@ static inline const struct cpumask *sched_rt_period_mask(void)
 #endif
 
 static inline
-struct rt_rq *sched_rt_period_rt_rq(struct rt_bandwidth *rt_b, int cpu)
+struct rt_rq *sched_rt_period_rt_rq(struct sched_bandwidth *rt_b, int cpu)
 {
 	return container_of(rt_b, struct task_group, rt_bandwidth)->rt_rq[cpu];
 }
 
-static inline struct rt_bandwidth *sched_rt_bandwidth(struct rt_rq *rt_rq)
+static inline struct sched_bandwidth *sched_rt_bandwidth(struct rt_rq *rt_rq)
 {
 	return &rt_rq->tg->rt_bandwidth;
 }
@@ -267,7 +267,7 @@ static inline u64 sched_rt_runtime(struct rt_rq *rt_rq)
 
 static inline u64 sched_rt_period(struct rt_rq *rt_rq)
 {
-	return ktime_to_ns(def_rt_bandwidth.rt_period);
+	return ktime_to_ns(def_rt_bandwidth.period);
 }
 
 #define for_each_leaf_rt_rq(rt_rq, rq) \
@@ -302,12 +302,12 @@ static inline const struct cpumask *sched_rt_period_mask(void)
 }
 
 static inline
-struct rt_rq *sched_rt_period_rt_rq(struct rt_bandwidth *rt_b, int cpu)
+struct rt_rq *sched_rt_period_rt_rq(struct sched_bandwidth *rt_b, int cpu)
 {
 	return &cpu_rq(cpu)->rt;
 }
 
-static inline struct rt_bandwidth *sched_rt_bandwidth(struct rt_rq *rt_rq)
+static inline struct sched_bandwidth *sched_rt_bandwidth(struct rt_rq *rt_rq)
 {
 	return &def_rt_bandwidth;
 }
@@ -320,15 +320,15 @@ static inline struct rt_bandwidth *sched_rt_bandwidth(struct rt_rq *rt_rq)
  */
 static int do_balance_runtime(struct rt_rq *rt_rq)
 {
-	struct rt_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
+	struct sched_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
 	struct root_domain *rd = cpu_rq(smp_processor_id())->rd;
 	int i, weight, more = 0;
 	u64 rt_period;
 
 	weight = cpumask_weight(rd->span);
 
-	raw_spin_lock(&rt_b->rt_runtime_lock);
-	rt_period = ktime_to_ns(rt_b->rt_period);
+	raw_spin_lock(&rt_b->runtime_lock);
+	rt_period = ktime_to_ns(rt_b->period);
 	for_each_cpu(i, rd->span) {
 		struct rt_rq *iter = sched_rt_period_rt_rq(rt_b, i);
 		s64 diff;
@@ -365,7 +365,7 @@ static int do_balance_runtime(struct rt_rq *rt_rq)
 next:
 		raw_spin_unlock(&iter->rt_runtime_lock);
 	}
-	raw_spin_unlock(&rt_b->rt_runtime_lock);
+	raw_spin_unlock(&rt_b->runtime_lock);
 
 	return more;
 }
@@ -382,11 +382,11 @@ static void __disable_runtime(struct rq *rq)
 		return;
 
 	for_each_leaf_rt_rq(rt_rq, rq) {
-		struct rt_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
+		struct sched_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
 		s64 want;
 		int i;
 
-		raw_spin_lock(&rt_b->rt_runtime_lock);
+		raw_spin_lock(&rt_b->runtime_lock);
 		raw_spin_lock(&rt_rq->rt_runtime_lock);
 		/*
 		 * Either we're all inf and nobody needs to borrow, or we're
@@ -394,7 +394,7 @@ static void __disable_runtime(struct rq *rq)
 		 * exactly the right amount of runtime to take out.
 		 */
 		if (rt_rq->rt_runtime == RUNTIME_INF ||
-				rt_rq->rt_runtime == rt_b->rt_runtime)
+				rt_rq->rt_runtime == rt_b->runtime)
 			goto balanced;
 		raw_spin_unlock(&rt_rq->rt_runtime_lock);
 
@@ -403,7 +403,7 @@ static void __disable_runtime(struct rq *rq)
 		 * and what we current have, that's the amount of runtime
 		 * we lend and now have to reclaim.
 		 */
-		want = rt_b->rt_runtime - rt_rq->rt_runtime;
+		want = rt_b->runtime - rt_rq->rt_runtime;
 
 		/*
 		 * Greedy reclaim, take back as much as we can.
@@ -446,7 +446,7 @@ balanced:
 		 */
 		rt_rq->rt_runtime = RUNTIME_INF;
 		raw_spin_unlock(&rt_rq->rt_runtime_lock);
-		raw_spin_unlock(&rt_b->rt_runtime_lock);
+		raw_spin_unlock(&rt_b->runtime_lock);
 	}
 }
 
@@ -470,15 +470,15 @@ static void __enable_runtime(struct rq *rq)
 	 * Reset each runqueue's bandwidth settings
 	 */
 	for_each_leaf_rt_rq(rt_rq, rq) {
-		struct rt_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
+		struct sched_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
 
-		raw_spin_lock(&rt_b->rt_runtime_lock);
+		raw_spin_lock(&rt_b->runtime_lock);
 		raw_spin_lock(&rt_rq->rt_runtime_lock);
-		rt_rq->rt_runtime = rt_b->rt_runtime;
+		rt_rq->rt_runtime = rt_b->runtime;
 		rt_rq->rt_time = 0;
 		rt_rq->rt_throttled = 0;
 		raw_spin_unlock(&rt_rq->rt_runtime_lock);
-		raw_spin_unlock(&rt_b->rt_runtime_lock);
+		raw_spin_unlock(&rt_b->runtime_lock);
 	}
 }
 
@@ -510,12 +510,12 @@ static inline int balance_runtime(struct rt_rq *rt_rq)
 }
 #endif /* CONFIG_SMP */
 
-static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun)
+static int do_sched_rt_period_timer(struct sched_bandwidth *rt_b, int overrun)
 {
 	int i, idle = 1;
 	const struct cpumask *span;
 
-	if (!rt_bandwidth_enabled() || rt_b->rt_runtime == RUNTIME_INF)
+	if (!rt_bandwidth_enabled() || rt_b->runtime == RUNTIME_INF)
 		return 1;
 
 	span = sched_rt_period_mask();
@@ -753,7 +753,7 @@ inc_rt_group(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 		rt_rq->rt_nr_boosted++;
 
 	if (rt_rq->tg)
-		start_rt_bandwidth(&rt_rq->tg->rt_bandwidth);
+		start_sched_bandwidth(&rt_rq->tg->rt_bandwidth);
 }
 
 static void
@@ -770,7 +770,7 @@ dec_rt_group(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 static void
 inc_rt_group(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 {
-	start_rt_bandwidth(&def_rt_bandwidth);
+	start_sched_bandwidth(&def_rt_bandwidth);
 }
 
 static inline
