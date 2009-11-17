Return-Path: <linux-kernel-owner+w=401wt.eu-S1753968AbZKQOhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbZKQOhY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 09:37:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753380AbZKQOhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 09:37:24 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:33777 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011AbZKQOhW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 09:37:22 -0500
Date: Tue, 17 Nov 2009 20:07:18 +0530
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
Subject: [RFC v4 PATCH 6/7] sched: Rebalance cfs runtimes
Message-ID: <20091117143718.GQ17335@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20091117143306.GK17335@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091117143306.GK17335@in.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sched: CFS runtime borrowing

From: Bharata B Rao <bharata@linux.vnet.ibm.com>

Before throttling a group, try to borrow runtime from groups that have excess.

To start with, a group will get equal runtime on every cpu. If the group doesn't
have tasks on all cpus, it might get throttled on some cpus while it still has
runtime left on other cpus where it doesn't have any tasks to consume that
runtime. Hence there is a chance to borrow runtimes from such cpus/cfs_rqs to
cpus/cfs_rqs where it is required.

CHECK: RT seems to be handling runtime initialization/reclaim during hotplug
from multiple places (migration_call, update_runtime). Need to check if CFS
also needs to do the same.

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
---
 kernel/sched.c      |   26 ++++++++
 kernel/sched_fair.c |  172 +++++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched_rt.c   |   26 +-------
 3 files changed, 202 insertions(+), 22 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index dd56c72..ead02ca 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9328,6 +9328,32 @@ static int update_sched_domains(struct notifier_block *nfb,
 }
 #endif
 
+#ifdef CONFIG_SMP
+static void disable_runtime(struct rq *rq)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&rq->lock, flags);
+#if defined(CONFIG_FAIR_GROUP_SCHED) && defined(CONFIG_CFS_HARD_LIMITS)
+	disable_runtime_cfs(rq);
+#endif
+	disable_runtime_rt(rq);
+	spin_unlock_irqrestore(&rq->lock, flags);
+}
+
+static void enable_runtime(struct rq *rq)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&rq->lock, flags);
+#if defined(CONFIG_FAIR_GROUP_SCHED) && defined(CONFIG_CFS_HARD_LIMITS)
+	enable_runtime_cfs(rq);
+#endif
+	enable_runtime_rt(rq);
+	spin_unlock_irqrestore(&rq->lock, flags);
+}
+#endif
+
 static int update_runtime(struct notifier_block *nfb,
 				unsigned long action, void *hcpu)
 {
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index c57ca54..6b254b8 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -220,6 +220,175 @@ static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq)
 	return cfs_rq->cfs_throttled;
 }
 
+#ifdef CONFIG_SMP
+/*
+ * Ensure this RQ takes back all the runtime it lend to its neighbours.
+ */
+static void disable_runtime_cfs(struct rq *rq)
+{
+	struct root_domain *rd = rq->rd;
+	struct cfs_rq *cfs_rq;
+
+	if (unlikely(!scheduler_running))
+		return;
+
+	for_each_leaf_cfs_rq(rq, cfs_rq) {
+		struct cfs_bandwidth *cfs_b = &cfs_rq->tg->cfs_bandwidth;
+		s64 want;
+		int i;
+
+		spin_lock(&cfs_b->cfs_runtime_lock);
+		spin_lock(&cfs_rq->cfs_runtime_lock);
+
+		/*
+		 * Either we're all are infinity and nobody needs to borrow,
+		 * or we're already disabled and this have nothing to do, or
+		 * we have exactly the right amount of runtime to take out.
+		 */
+		 if (cfs_rq->cfs_runtime == RUNTIME_INF ||
+				cfs_rq->cfs_runtime == cfs_b->cfs_runtime)
+			goto balanced;
+		spin_unlock(&cfs_rq->cfs_runtime_lock);
+
+		/*
+		 * Calculate the difference between what we started out with
+		 * and what we current have, that's the amount of runtime
+		 * we lend and now have to reclaim.
+		 */
+		 want = cfs_b->cfs_runtime - cfs_rq->cfs_runtime;
+
+		/*
+		 * Greedy reclaim, take back as much as possible.
+		 */
+		for_each_cpu(i, rd->span) {
+			struct cfs_rq *iter = sched_cfs_period_cfs_rq(cfs_b, i);
+			s64 diff;
+
+			/*
+			 * Can't reclaim from ourselves or disabled runqueues.
+			 */
+			if (iter == cfs_rq || iter->cfs_runtime == RUNTIME_INF)
+				continue;
+
+			spin_lock(&iter->cfs_runtime_lock);
+			if (want > 0) {
+				diff = min_t(s64, iter->cfs_runtime, want);
+				iter->cfs_runtime -= diff;
+				want -= diff;
+			} else {
+				iter->cfs_runtime -= want;
+				want -= want;
+			}
+
+			spin_unlock(&iter->cfs_runtime_lock);
+			if (!want)
+				break;
+		}
+
+		spin_lock(&cfs_rq->cfs_runtime_lock);
+		/*
+		 * We cannot be left wanting - that would mean some
+		 * runtime leaked out of the system.
+		 */
+		BUG_ON(want);
+balanced:
+		/*
+		 * Disable all the borrow logic by pretending we have infinite
+		 * runtime - in which case borrowing doesn't make sense.
+		 */
+		 cfs_rq->cfs_runtime = RUNTIME_INF;
+		 spin_unlock(&cfs_rq->cfs_runtime_lock);
+		 spin_unlock(&cfs_b->cfs_runtime_lock);
+	}
+}
+
+static void enable_runtime_cfs(struct rq *rq)
+{
+	struct cfs_rq *cfs_rq;
+
+	if (unlikely(!scheduler_running))
+		return;
+
+	/*
+	 * Reset each runqueue's bandwidth settings
+	 */
+	for_each_leaf_cfs_rq(rq, cfs_rq) {
+		struct cfs_bandwidth *cfs_b = &cfs_rq->tg->cfs_bandwidth;
+
+		spin_lock(&cfs_b->cfs_runtime_lock);
+		spin_lock(&cfs_rq->cfs_runtime_lock);
+		cfs_rq->cfs_runtime = cfs_b->cfs_runtime;
+		cfs_rq->cfs_time = 0;
+		cfs_rq->cfs_throttled = 0;
+		spin_unlock(&cfs_rq->cfs_runtime_lock);
+		spin_unlock(&cfs_b->cfs_runtime_lock);
+	}
+}
+
+/*
+ * Ran out of runtime, check if we can borrow some from others
+ * instead of getting throttled right away.
+ */
+static void do_cfs_balance_runtime(struct cfs_rq *cfs_rq)
+{
+	struct cfs_bandwidth *cfs_b = &cfs_rq->tg->cfs_bandwidth;
+	const struct cpumask *span = sched_bw_period_mask();
+	int i, weight;
+	u64 cfs_period;
+
+	weight = cpumask_weight(span);
+	spin_lock(&cfs_b->cfs_runtime_lock);
+	cfs_period = ktime_to_ns(cfs_b->cfs_period);
+
+	for_each_cpu(i, span) {
+		struct cfs_rq *borrow_cfs_rq =
+				sched_cfs_period_cfs_rq(cfs_b, i);
+		s64 diff;
+
+		if (borrow_cfs_rq == cfs_rq)
+			continue;
+
+		cfs_rq_runtime_lock(borrow_cfs_rq);
+		if (borrow_cfs_rq->cfs_runtime == RUNTIME_INF) {
+			cfs_rq_runtime_unlock(borrow_cfs_rq);
+			continue;
+		}
+
+		diff = borrow_cfs_rq->cfs_runtime - borrow_cfs_rq->cfs_time;
+		if (diff > 0) {
+			diff = div_u64((u64)diff, weight);
+			if (cfs_rq->cfs_runtime + diff > cfs_period)
+				diff = cfs_period - cfs_rq->cfs_runtime;
+			borrow_cfs_rq->cfs_runtime -= diff;
+			cfs_rq->cfs_runtime += diff;
+			if (cfs_rq->cfs_runtime == cfs_period) {
+				cfs_rq_runtime_unlock(borrow_cfs_rq);
+				break;
+			}
+		}
+		cfs_rq_runtime_unlock(borrow_cfs_rq);
+	}
+	spin_unlock(&cfs_b->cfs_runtime_lock);
+}
+
+/*
+ * Called with rq->runtime_lock held.
+ */
+static void cfs_balance_runtime(struct cfs_rq *cfs_rq)
+{
+	cfs_rq_runtime_unlock(cfs_rq);
+	do_cfs_balance_runtime(cfs_rq);
+	cfs_rq_runtime_lock(cfs_rq);
+}
+
+#else /* !CONFIG_SMP */
+
+static void cfs_balance_runtime(struct cfs_rq *cfs_rq)
+{
+	return;
+}
+#endif /* CONFIG_SMP */
+
 /*
  * Check if group entity exceeded its runtime. If so, mark the cfs_rq as
  * throttled mark the current task for reschedling.
@@ -239,6 +408,9 @@ static void sched_cfs_runtime_exceeded(struct sched_entity *se,
 	if (cfs_rq_throttled(cfs_rq))
 		return;
 
+	if (cfs_rq->cfs_time > cfs_rq->cfs_runtime)
+		cfs_balance_runtime(cfs_rq);
+
 	if (cfs_rq->cfs_time > cfs_rq->cfs_runtime) {
 		cfs_rq->cfs_throttled = 1;
 		update_stats_throttle_start(cfs_rq, se);
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 97067e1..edcea9b 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -356,7 +356,7 @@ next:
 /*
  * Ensure this RQ takes back all the runtime it lend to its neighbours.
  */
-static void __disable_runtime(struct rq *rq)
+static void disable_runtime_rt(struct rq *rq)
 {
 	struct root_domain *rd = rq->rd;
 	struct rt_rq *rt_rq;
@@ -433,16 +433,7 @@ balanced:
 	}
 }
 
-static void disable_runtime(struct rq *rq)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&rq->lock, flags);
-	__disable_runtime(rq);
-	spin_unlock_irqrestore(&rq->lock, flags);
-}
-
-static void __enable_runtime(struct rq *rq)
+static void enable_runtime_rt(struct rq *rq)
 {
 	struct rt_rq *rt_rq;
 
@@ -465,15 +456,6 @@ static void __enable_runtime(struct rq *rq)
 	}
 }
 
-static void enable_runtime(struct rq *rq)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&rq->lock, flags);
-	__enable_runtime(rq);
-	spin_unlock_irqrestore(&rq->lock, flags);
-}
-
 static int balance_runtime(struct rt_rq *rt_rq)
 {
 	int more = 0;
@@ -1547,7 +1529,7 @@ static void rq_online_rt(struct rq *rq)
 	if (rq->rt.overloaded)
 		rt_set_overload(rq);
 
-	__enable_runtime(rq);
+	enable_runtime_rt(rq);
 
 	cpupri_set(&rq->rd->cpupri, rq->cpu, rq->rt.highest_prio.curr);
 }
@@ -1558,7 +1540,7 @@ static void rq_offline_rt(struct rq *rq)
 	if (rq->rt.overloaded)
 		rt_clear_overload(rq);
 
-	__disable_runtime(rq);
+	disable_runtime_rt(rq);
 
 	cpupri_set(&rq->rd->cpupri, rq->cpu, CPUPRI_INVALID);
 }
