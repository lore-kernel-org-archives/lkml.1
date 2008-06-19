Return-Path: <linux-kernel-owner+w=401wt.eu-S1758801AbYFSMfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758801AbYFSMfv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 08:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756686AbYFSMf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 08:35:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:33531 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755069AbYFSMf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 08:35:27 -0400
Message-Id: <20080619123314.178592128@chello.nl>
References: <20080619122218.971447669@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 19 Jun 2008 14:22:25 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, "Daniel K." <dk@uw.no>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 07/10] sched: rt: fix SMP bandwidth balancing for throttled groups
Content-Disposition: inline; filename=sched-rt-bw-balance-fix.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We didn't balance the runtime when throttled, this can cause large wakeup
latencies. Suppose a task is migrated to another cpu right before the group
quota runs out - its likely that the previuos cpu had a large amount of the
group runtime, whereas the new cpu would be almost depleted (due to it being 
handed the other cpu).

Now we exceed the runtime and get throttled - the period rollover tick will
subtract the cpu quota from the runtime and check if we're below quota. However
with this cpu having a very small portion of the runtime it will not refresh
as fast as it should.

Therefore, also rebalance the runtime when we're throttled.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched_rt.c |   41 +++++++++++++++++++++++++++++------------
 1 file changed, 29 insertions(+), 12 deletions(-)

Index: linux-2.6/kernel/sched_rt.c
===================================================================
--- linux-2.6.orig/kernel/sched_rt.c
+++ linux-2.6/kernel/sched_rt.c
@@ -222,6 +222,28 @@ static inline struct rt_bandwidth *sched
 
 #endif
 
+#ifdef CONFIG_SMP
+static int do_balance_runtime(struct rt_rq *rt_rq);
+
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
+#endif
+
 static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun)
 {
 	int i, idle = 1;
@@ -241,6 +263,8 @@ static int do_sched_rt_period_timer(stru
 			u64 runtime;
 
 			spin_lock(&rt_rq->rt_runtime_lock);
+			if (rt_rq->rt_throttled)
+				balance_runtime(rt_rq);
 			runtime = rt_rq->rt_runtime;
 			rt_rq->rt_time -= min(rt_rq->rt_time, overrun*runtime);
 			if (rt_rq->rt_throttled && rt_rq->rt_time < runtime) {
@@ -261,7 +285,7 @@ static int do_sched_rt_period_timer(stru
 }
 
 #ifdef CONFIG_SMP
-static int balance_runtime(struct rt_rq *rt_rq)
+static int do_balance_runtime(struct rt_rq *rt_rq)
 {
 	struct rt_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
 	struct root_domain *rd = cpu_rq(smp_processor_id())->rd;
@@ -422,17 +446,10 @@ static int sched_rt_runtime_exceeded(str
 	if (sched_rt_runtime(rt_rq) >= sched_rt_period(rt_rq))
 		return 0;
 
-#ifdef CONFIG_SMP
-	if (rt_rq->rt_time > runtime) {
-		spin_unlock(&rt_rq->rt_runtime_lock);
-		balance_runtime(rt_rq);
-		spin_lock(&rt_rq->rt_runtime_lock);
-
-		runtime = sched_rt_runtime(rt_rq);
-		if (runtime == RUNTIME_INF)
-			return 0;
-	}
-#endif
+	balance_runtime(rt_rq);
+	runtime = sched_rt_runtime(rt_rq);
+	if (runtime == RUNTIME_INF)
+		return 0;
 
 	if (rt_rq->rt_time > runtime) {
 		rt_rq->rt_throttled = 1;

-- 

