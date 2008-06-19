Return-Path: <linux-kernel-owner+w=401wt.eu-S1759699AbYFSMhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759699AbYFSMhl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 08:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758460AbYFSMfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 08:35:36 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44117 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758286AbYFSMfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 08:35:33 -0400
Message-Id: <20080619123314.049253081@chello.nl>
References: <20080619122218.971447669@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 19 Jun 2008 14:22:23 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, "Daniel K." <dk@uw.no>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 05/10] sched: rt-bandwidth: fix cpu-hotplug interaction
Content-Disposition: inline; filename=sched-rt_bandwidth-vs-hotplug.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Restore the bandwidth to offlining cpus so we don't leak/gain bandwidth.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c    |   15 +++++--
 kernel/sched_rt.c |  108 +++++++++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 114 insertions(+), 9 deletions(-)

Index: linux-2.6/kernel/sched_rt.c
===================================================================
--- linux-2.6.orig/kernel/sched_rt.c
+++ linux-2.6/kernel/sched_rt.c
@@ -280,6 +280,9 @@ static int balance_runtime(struct rt_rq 
 			continue;
 
 		spin_lock(&iter->rt_runtime_lock);
+		if (iter->rt_runtime == RUNTIME_INF)
+			goto next;
+
 		diff = iter->rt_runtime - iter->rt_time;
 		if (diff > 0) {
 			do_div(diff, weight);
@@ -293,12 +296,104 @@ static int balance_runtime(struct rt_rq 
 				break;
 			}
 		}
+next:
 		spin_unlock(&iter->rt_runtime_lock);
 	}
 	spin_unlock(&rt_b->rt_runtime_lock);
 
 	return more;
 }
+
+static void __disable_runtime(struct rq *rq)
+{
+	struct root_domain *rd = rq->rd;
+	struct rt_rq *rt_rq;
+
+	if (unlikely(!scheduler_running))
+		return;
+
+	for_each_leaf_rt_rq(rt_rq, rq) {
+		struct rt_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
+		s64 want;
+		int i;
+
+		spin_lock(&rt_b->rt_runtime_lock);
+		spin_lock(&rt_rq->rt_runtime_lock);
+		if (rt_rq->rt_runtime == RUNTIME_INF ||
+				rt_rq->rt_runtime == rt_b->rt_runtime)
+			goto balanced;
+		spin_unlock(&rt_rq->rt_runtime_lock);
+
+		want = rt_b->rt_runtime - rt_rq->rt_runtime;
+
+		for_each_cpu_mask(i, rd->span) {
+			struct rt_rq *iter = sched_rt_period_rt_rq(rt_b, i);
+			s64 diff;
+
+			if (iter == rt_rq)
+				continue;
+
+			spin_lock(&iter->rt_runtime_lock);
+			if (want > 0) {
+				diff = min_t(s64, iter->rt_runtime, want);
+				iter->rt_runtime -= diff;
+				want -= diff;
+			} else {
+				iter->rt_runtime -= want;
+				want -= want;
+			}
+			spin_unlock(&iter->rt_runtime_lock);
+
+			if (!want)
+				break;
+		}
+
+		spin_lock(&rt_rq->rt_runtime_lock);
+		BUG_ON(want);
+balanced:
+		rt_rq->rt_runtime = RUNTIME_INF;
+		spin_unlock(&rt_rq->rt_runtime_lock);
+		spin_unlock(&rt_b->rt_runtime_lock);
+	}
+}
+
+static void disable_runtime(struct rq *rq)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&rq->lock, flags);
+	__disable_runtime(rq);
+	spin_unlock_irqrestore(&rq->lock, flags);
+}
+
+static void __enable_runtime(struct rq *rq)
+{
+	struct rt_rq *rt_rq;
+
+	if (unlikely(!scheduler_running))
+		return;
+
+	for_each_leaf_rt_rq(rt_rq, rq) {
+		struct rt_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
+
+		spin_lock(&rt_b->rt_runtime_lock);
+		spin_lock(&rt_rq->rt_runtime_lock);
+		rt_rq->rt_runtime = rt_b->rt_runtime;
+		rt_rq->rt_time = 0;
+		spin_unlock(&rt_rq->rt_runtime_lock);
+		spin_unlock(&rt_b->rt_runtime_lock);
+	}
+}
+
+static void enable_runtime(struct rq *rq)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&rq->lock, flags);
+	__enable_runtime(rq);
+	spin_unlock_irqrestore(&rq->lock, flags);
+}
+
 #endif
 
 static inline int rt_se_prio(struct sched_rt_entity *rt_se)
@@ -328,14 +423,13 @@ static int sched_rt_runtime_exceeded(str
 
 #ifdef CONFIG_SMP
 	if (rt_rq->rt_time > runtime) {
-		int more;
-
 		spin_unlock(&rt_rq->rt_runtime_lock);
-		more = balance_runtime(rt_rq);
+		balance_runtime(rt_rq);
 		spin_lock(&rt_rq->rt_runtime_lock);
 
-		if (more)
-			runtime = sched_rt_runtime(rt_rq);
+		runtime = sched_rt_runtime(rt_rq);
+		if (runtime == RUNTIME_INF)
+			return 0;
 	}
 #endif
 
@@ -1166,6 +1260,8 @@ static void join_domain_rt(struct rq *rq
 {
 	if (rq->rt.overloaded)
 		rt_set_overload(rq);
+
+	__enable_runtime(rq);
 }
 
 /* Assumes rq->lock is held */
@@ -1173,6 +1269,8 @@ static void leave_domain_rt(struct rq *r
 {
 	if (rq->rt.overloaded)
 		rt_clear_overload(rq);
+
+	__disable_runtime(rq);
 }
 
 /*
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -7461,20 +7461,27 @@ int sched_create_sysfs_power_savings_ent
 static int update_sched_domains(struct notifier_block *nfb,
 				unsigned long action, void *hcpu)
 {
+	int cpu = (int)(long)hcpu;
+
 	switch (action) {
-	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
 	case CPU_DOWN_PREPARE:
 	case CPU_DOWN_PREPARE_FROZEN:
+		disable_runtime(cpu_rq(cpu));
+		/* fall-through */
+	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
 		detach_destroy_domains(&cpu_online_map);
 		return NOTIFY_OK;
 
-	case CPU_UP_CANCELED:
-	case CPU_UP_CANCELED_FROZEN:
+
 	case CPU_DOWN_FAILED:
 	case CPU_DOWN_FAILED_FROZEN:
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
+		enable_runtime(cpu_rq(cpu));
+		/* fall-through */
+	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
 		/*

-- 

