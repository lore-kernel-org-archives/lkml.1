Return-Path: <linux-kernel-owner+w=401wt.eu-S1754049AbYBDVRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbYBDVRY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 16:17:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755399AbYBDVRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 16:17:09 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:46902 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555AbYBDVRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 16:17:07 -0500
Message-Id: <20080204211837.889013000@chello.nl>
References: <20080204210258.118479000@chello.nl>
User-Agent: quilt/0.45-1
Date: Mon, 04 Feb 2008 22:03:06 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: tong.n.li@intel.com, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 8/8] sched: rt-group: smp balancing
Content-Disposition: inline; filename=sched-rt-group-smp.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the rt group scheduling does a per cpu runtime limit, however
the rt load balancer makes no guarantees about an equal spread of real-
time tasks, just that at any one time, the highest priority tasks run.

Solve this by making the runtime limit a global property by borrowing
excessive runtime from the other cpus once the local limit runs out.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c    |   38 ++++++++++++++++++++++-
 kernel/sched_rt.c |   88 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 121 insertions(+), 5 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -169,6 +169,7 @@ static inline ktime_t ns_to_ktime(u64 ns
 struct rt_bandwidth {
 	ktime_t rt_period;
 	u64 rt_runtime;
+	spinlock_t rt_runtime_lock;
 	struct hrtimer rt_period_timer;
 };
 
@@ -203,6 +204,8 @@ void init_rt_bandwidth(struct rt_bandwid
 	rt_b->rt_period = ns_to_ktime(period);
 	rt_b->rt_runtime = runtime;
 
+	spin_lock_init(&rt_b->rt_runtime_lock);
+
 	hrtimer_init(&rt_b->rt_period_timer,
 			CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	rt_b->rt_period_timer.function = sched_rt_period_timer;
@@ -471,6 +474,8 @@ struct rt_rq {
 #endif
 	int rt_throttled;
 	u64 rt_time;
+	u64 rt_runtime;
+	spinlock_t rt_runtime_lock;
 
 #ifdef CONFIG_RT_GROUP_SCHED
 	unsigned long rt_nr_boosted;
@@ -7216,6 +7221,8 @@ static void init_rt_rq(struct rt_rq *rt_
 
 	rt_rq->rt_time = 0;
 	rt_rq->rt_throttled = 0;
+	rt_rq->rt_runtime = 0;
+	spin_lock_init(&rt_rq->rt_runtime_lock);
 
 #ifdef CONFIG_RT_GROUP_SCHED
 	rt_rq->rt_nr_boosted = 0;
@@ -7252,6 +7259,7 @@ static void init_tg_rt_entry(struct rq *
 	init_rt_rq(rt_rq, rq);
 	rt_rq->tg = tg;
 	rt_rq->rt_se = rt_se;
+	rt_rq->rt_runtime = tg->rt_bandwidth.rt_runtime;
 	if (add)
 		list_add(&rt_rq->leaf_rt_rq_list, &rq->leaf_rt_rq_list);
 
@@ -7307,6 +7315,8 @@ void __init sched_init(void)
 		init_tg_rt_entry(rq, &init_task_group,
 				&per_cpu(init_rt_rq, i),
 				&per_cpu(init_sched_rt_entity, i), i, 1);
+#else
+		rq->rt.rt_runtime = def_rt_bandwidth.rt_runtime;
 #endif
 
 		for (j = 0; j < CPU_LOAD_IDX_MAX; j++)
@@ -8007,15 +8017,26 @@ static int __rt_schedulable(struct task_
 static int tg_set_bandwidth(struct task_group *tg,
 		u64 rt_period, u64 rt_runtime)
 {
-	int err = 0;
+	int i, err = 0;
 
 	mutex_lock(&rt_constraints_mutex);
 	if (!__rt_schedulable(tg, rt_period, rt_runtime)) {
 		err = -EINVAL;
 		goto unlock;
 	}
+
+	spin_lock_irq(&tg->rt_bandwidth.rt_runtime_lock);
 	tg->rt_bandwidth.rt_period = ns_to_ktime(rt_period);
 	tg->rt_bandwidth.rt_runtime = rt_runtime;
+
+	for_each_possible_cpu(i) {
+		struct rt_rq *rt_rq = tg->rt_rq[i];
+
+		spin_lock(&rt_rq->rt_runtime_lock);
+		rt_rq->rt_runtime = rt_runtime;
+		spin_unlock(&rt_rq->rt_runtime_lock);
+	}
+	spin_unlock_irq(&tg->rt_bandwidth.rt_runtime_lock);
  unlock:
 	mutex_unlock(&rt_constraints_mutex);
 
@@ -8079,6 +8100,19 @@ static int sched_rt_global_constraints(v
 #else
 static int sched_rt_global_constraints(void)
 {
+	unsigned long flags;
+	int i;
+
+	spin_lock_irqsave(&def_rt_bandwidth.rt_runtime_lock, flags);
+	for_each_possible_cpu(i) {
+		struct rt_rq *rt_rq = &cpu_rq(i)->rt;
+
+		spin_lock(&rt_rq->rt_runtime_lock);
+		rt_rq->rt_runtime = global_rt_runtime();
+		spin_unlock(&rt_rq->rt_runtime_lock);
+	}
+	spin_unlock_irqrestore(&def_rt_bandwidth.rt_runtime_lock, flags);
+
 	return 0;
 }
 #endif
@@ -8195,7 +8229,7 @@ static u64 cpu_shares_read_uint(struct c
 #endif
 
 #ifdef CONFIG_RT_GROUP_SCHED
-static int cpu_rt_runtime_write(struct cgroup *cgrp, struct cftype *cft,
+static ssize_t cpu_rt_runtime_write(struct cgroup *cgrp, struct cftype *cft,
 				struct file *file,
 				const char __user *userbuf,
 				size_t nbytes, loff_t *unused_ppos)
Index: linux-2.6/kernel/sched_rt.c
===================================================================
--- linux-2.6.orig/kernel/sched_rt.c
+++ linux-2.6/kernel/sched_rt.c
@@ -62,7 +62,12 @@ static inline u64 sched_rt_runtime(struc
 	if (!rt_rq->tg)
 		return RUNTIME_INF;
 
-	return rt_rq->tg->rt_bandwidth.rt_runtime;
+	return rt_rq->rt_runtime;
+}
+
+static inline u64 sched_rt_period(struct rt_rq *rt_rq)
+{
+	return ktime_to_ns(rt_rq->tg->rt_bandwidth.rt_period);
 }
 
 #define for_each_leaf_rt_rq(rt_rq, rq) \
@@ -145,11 +150,21 @@ struct rt_rq *sched_rt_period_rt_rq(stru
 	return container_of(rt_b, struct task_group, rt_bandwidth)->rt_rq[cpu];
 }
 
+static inline struct rt_bandwidth *sched_rt_bandwidth(struct rt_rq *rt_rq)
+{
+	return &rt_rq->tg->rt_bandwidth;
+}
+
 #else
 
 static inline u64 sched_rt_runtime(struct rt_rq *rt_rq)
 {
-	return def_rt_bandwidth.rt_runtime;
+	return rt_rq->rt_runtime;
+}
+
+static inline u64 sched_rt_period(struct rt_rq *rt_rq)
+{
+	return ktime_to_ns(def_rt_bandwidth.rt_period);
 }
 
 #define for_each_leaf_rt_rq(rt_rq, rq) \
@@ -200,6 +215,11 @@ struct rt_rq *sched_rt_period_rt_rq(stru
 	return &cpu_rq(cpu)->rt;
 }
 
+static inline struct rt_bandwidth *sched_rt_bandwidth(struct rt_rq *rt_rq)
+{
+	return &def_rt_bandwidth;
+}
+
 #endif
 
 static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun)
@@ -218,8 +238,10 @@ static int do_sched_rt_period_timer(stru
 
 		spin_lock(&rq->lock);
 		if (rt_rq->rt_time) {
-			u64 runtime = rt_b->rt_runtime;
+			u64 runtime;
 
+			spin_lock(&rt_rq->rt_runtime_lock);
+			runtime = rt_rq->rt_runtime;
 			rt_rq->rt_time -= min(rt_rq->rt_time, overrun*runtime);
 			if (rt_rq->rt_throttled && rt_rq->rt_time < runtime) {
 				rt_rq->rt_throttled = 0;
@@ -227,6 +249,7 @@ static int do_sched_rt_period_timer(stru
 			}
 			if (rt_rq->rt_time || rt_rq->rt_nr_running)
 				idle = 0;
+			spin_unlock(&rt_rq->rt_runtime_lock);
 		}
 
 		if (enqueue)
@@ -237,6 +260,47 @@ static int do_sched_rt_period_timer(stru
 	return idle;
 }
 
+#ifdef CONFIG_SMP
+static int balance_runtime(struct rt_rq *rt_rq)
+{
+	struct rt_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
+	struct root_domain *rd = cpu_rq(smp_processor_id())->rd;
+	int i, weight, more = 0;
+	u64 rt_period;
+
+	weight = cpus_weight(rd->span);
+
+	spin_lock(&rt_b->rt_runtime_lock);
+	rt_period = ktime_to_ns(rt_b->rt_period);
+	for_each_cpu_mask(i, rd->span) {
+		struct rt_rq *iter = sched_rt_period_rt_rq(rt_b, i);
+		s64 diff;
+
+		if (iter == rt_rq)
+			continue;
+
+		spin_lock(&iter->rt_runtime_lock);
+		diff = iter->rt_runtime - iter->rt_time;
+		if (diff > 0) {
+			diff /= weight;
+			if (rt_rq->rt_runtime + diff > rt_period)
+				diff = rt_period - rt_rq->rt_runtime;
+			iter->rt_runtime -= diff;
+			rt_rq->rt_runtime += diff;
+			more = 1;
+			if (rt_rq->rt_runtime == rt_period) {
+				spin_unlock(&iter->rt_runtime_lock);
+				break;
+			}
+		}
+		spin_unlock(&iter->rt_runtime_lock);
+	}
+	spin_unlock(&rt_b->rt_runtime_lock);
+
+	return more;
+}
+#endif
+
 static inline int rt_se_prio(struct sched_rt_entity *rt_se)
 {
 #ifdef CONFIG_RT_GROUP_SCHED
@@ -259,6 +323,22 @@ static int sched_rt_runtime_exceeded(str
 	if (rt_rq->rt_throttled)
 		return rt_rq_throttled(rt_rq);
 
+	if (sched_rt_runtime(rt_rq) >= sched_rt_period(rt_rq))
+		return 0;
+
+#ifdef CONFIG_SMP
+	if (rt_rq->rt_time > runtime) {
+		int more;
+
+		spin_unlock(&rt_rq->rt_runtime_lock);
+		more = balance_runtime(rt_rq);
+		spin_lock(&rt_rq->rt_runtime_lock);
+
+		if (more)
+			runtime = sched_rt_runtime(rt_rq);
+	}
+#endif
+
 	if (rt_rq->rt_time > runtime) {
 		rt_rq->rt_throttled = 1;
 		if (rt_rq_throttled(rt_rq)) {
@@ -294,9 +374,11 @@ static void update_curr_rt(struct rq *rq
 	curr->se.exec_start = rq->clock;
 	cpuacct_charge(curr, delta_exec);
 
+	spin_lock(&rt_rq->rt_runtime_lock);
 	rt_rq->rt_time += delta_exec;
 	if (sched_rt_runtime_exceeded(rt_rq))
 		resched_task(curr);
+	spin_unlock(&rt_rq->rt_runtime_lock);
 }
 
 static inline

--

