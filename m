Return-Path: <linux-kernel-owner+w=401wt.eu-S1760007AbYFSMiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760007AbYFSMiV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 08:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758547AbYFSMfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 08:35:37 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44132 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758493AbYFSMfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 08:35:36 -0400
Message-Id: <20080619123314.266039200@chello.nl>
References: <20080619122218.971447669@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 19 Jun 2008 14:22:26 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, "Daniel K." <dk@uw.no>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 08/10] sched: rt: move some code around
Content-Disposition: inline; filename=sched-rt-cleanup.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shuffle some code around to get rid of some #ifdef

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched_rt.c |  119 +++++++++++++++++++++++++-----------------------------
 1 file changed, 57 insertions(+), 62 deletions(-)

Index: linux-2.6/kernel/sched_rt.c
===================================================================
--- linux-2.6.orig/kernel/sched_rt.c
+++ linux-2.6/kernel/sched_rt.c
@@ -223,68 +223,6 @@ static inline struct rt_bandwidth *sched
 #endif
 
 #ifdef CONFIG_SMP
-static int do_balance_runtime(struct rt_rq *rt_rq);
-
-static int balance_runtime(struct rt_rq *rt_rq)
-{
-	int more = 0;
-
-	if (rt_rq->rt_time > rt_rq->rt_runtime) {
-		spin_unlock(&rt_rq->rt_runtime_lock);
-		more = do_balance_runtime(rt_rq);
-		spin_lock(&rt_rq->rt_runtime_lock);
-	}
-
-	return more;
-}
-#else
-static inline int balance_runtime(struct rt_rq *rt_rq)
-{
-	return 0;
-}
-#endif
-
-static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun)
-{
-	int i, idle = 1;
-	cpumask_t span;
-
-	if (rt_b->rt_runtime == RUNTIME_INF)
-		return 1;
-
-	span = sched_rt_period_mask();
-	for_each_cpu_mask(i, span) {
-		int enqueue = 0;
-		struct rt_rq *rt_rq = sched_rt_period_rt_rq(rt_b, i);
-		struct rq *rq = rq_of_rt_rq(rt_rq);
-
-		spin_lock(&rq->lock);
-		if (rt_rq->rt_time) {
-			u64 runtime;
-
-			spin_lock(&rt_rq->rt_runtime_lock);
-			if (rt_rq->rt_throttled)
-				balance_runtime(rt_rq);
-			runtime = rt_rq->rt_runtime;
-			rt_rq->rt_time -= min(rt_rq->rt_time, overrun*runtime);
-			if (rt_rq->rt_throttled && rt_rq->rt_time < runtime) {
-				rt_rq->rt_throttled = 0;
-				enqueue = 1;
-			}
-			if (rt_rq->rt_time || rt_rq->rt_nr_running)
-				idle = 0;
-			spin_unlock(&rt_rq->rt_runtime_lock);
-		}
-
-		if (enqueue)
-			sched_rt_rq_enqueue(rt_rq);
-		spin_unlock(&rq->lock);
-	}
-
-	return idle;
-}
-
-#ifdef CONFIG_SMP
 static int do_balance_runtime(struct rt_rq *rt_rq)
 {
 	struct rt_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
@@ -419,8 +357,65 @@ static void enable_runtime(struct rq *rq
 	spin_unlock_irqrestore(&rq->lock, flags);
 }
 
+static int balance_runtime(struct rt_rq *rt_rq)
+{
+	int more = 0;
+
+	if (rt_rq->rt_time > rt_rq->rt_runtime) {
+		spin_unlock(&rt_rq->rt_runtime_lock);
+		more = do_balance_runtime(rt_rq);
+		spin_lock(&rt_rq->rt_runtime_lock);
+	}
+
+	return more;
+}
+#else
+static inline int balance_runtime(struct rt_rq *rt_rq)
+{
+	return 0;
+}
 #endif
 
+static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun)
+{
+	int i, idle = 1;
+	cpumask_t span;
+
+	if (rt_b->rt_runtime == RUNTIME_INF)
+		return 1;
+
+	span = sched_rt_period_mask();
+	for_each_cpu_mask(i, span) {
+		int enqueue = 0;
+		struct rt_rq *rt_rq = sched_rt_period_rt_rq(rt_b, i);
+		struct rq *rq = rq_of_rt_rq(rt_rq);
+
+		spin_lock(&rq->lock);
+		if (rt_rq->rt_time) {
+			u64 runtime;
+
+			spin_lock(&rt_rq->rt_runtime_lock);
+			if (rt_rq->rt_throttled)
+				balance_runtime(rt_rq);
+			runtime = rt_rq->rt_runtime;
+			rt_rq->rt_time -= min(rt_rq->rt_time, overrun*runtime);
+			if (rt_rq->rt_throttled && rt_rq->rt_time < runtime) {
+				rt_rq->rt_throttled = 0;
+				enqueue = 1;
+			}
+			if (rt_rq->rt_time || rt_rq->rt_nr_running)
+				idle = 0;
+			spin_unlock(&rt_rq->rt_runtime_lock);
+		}
+
+		if (enqueue)
+			sched_rt_rq_enqueue(rt_rq);
+		spin_unlock(&rq->lock);
+	}
+
+	return idle;
+}
+
 static inline int rt_se_prio(struct sched_rt_entity *rt_se)
 {
 #ifdef CONFIG_RT_GROUP_SCHED

-- 

