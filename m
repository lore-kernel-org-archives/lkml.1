Return-Path: <linux-kernel-owner+w=401wt.eu-S1753421AbZI3M4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbZI3M4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 08:56:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752446AbZI3M4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 08:56:38 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:59696 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752003AbZI3M4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 08:56:37 -0400
Date: Wed, 30 Sep 2009 18:25:03 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pavel Emelyanov <xemul@openvz.org>,
       Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
       Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
       Mike Waychison <mikew@google.com>
Subject: [RFC v2 PATCH 7/8] sched: Rebalance cfs runtimes
Message-ID: <20090930125503.GH19951@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20090930124919.GA19951@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090930124919.GA19951@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sched: CFS runtime borrowing

From: Bharata B Rao <bharata@linux.vnet.ibm.com>

To start with, a group will get equal runtime on every cpu. If the group doesn't
have tasks on all cpus, it might get throttled on some cpus while it still has
runtime left on other cpus where it doesn't have any tasks to consume that
runtime. Hence there is a chance to borrow runtimes from such cpus/cfs_rqs to
cpus/cfs_rqs where it is required.
---
 kernel/sched_fair.c |   98 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 98 insertions(+), 0 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index f4dec63..8b43f4f 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -205,12 +205,107 @@ static inline void update_stats_throttle_end(struct cfs_rq *cfs_rq,
 	schedstat_set(se->throttle_start, 0);
 }
 
+static void double_rq_runtime_lock(struct rq *rq1, struct rq *rq2)
+	__acquires(rq1->runtime_lock)
+	__acquires(rq2->runtime_lock)
+{
+	BUG_ON(!irqs_disabled());
+	if (rq1 == rq2) {
+		spin_lock(&rq1->runtime_lock);
+		__acquire(rq2->runtime_lock);	/* Fake it out ;) */
+	} else {
+		if (rq1 < rq2) {
+			spin_lock(&rq1->runtime_lock);
+			spin_lock_nested(&rq2->runtime_lock,
+					SINGLE_DEPTH_NESTING);
+		} else {
+			spin_lock(&rq2->runtime_lock);
+			spin_lock_nested(&rq1->runtime_lock,
+					SINGLE_DEPTH_NESTING);
+		}
+	}
+	update_rq_clock(rq1);
+	update_rq_clock(rq2);
+}
+
+static void double_rq_runtime_unlock(struct rq *rq1, struct rq *rq2)
+	__releases(rq1->runtime_lock)
+	__releases(rq2->runtime_lock)
+{
+	spin_unlock(&rq1->runtime_lock);
+	if (rq1 != rq2)
+		spin_unlock(&rq2->runtime_lock);
+	else
+		__release(rq2->runtime_lock);
+}
+
 static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq)
 {
 	return cfs_rq->cfs_throttled;
 }
 
 /*
+ * Ran out of runtime, check if we can borrow some from others
+ * instead of getting throttled right away.
+ */
+static void do_cfs_balance_runtime(struct cfs_rq *cfs_rq)
+{
+	struct rq *rq = rq_of(cfs_rq);
+	struct cfs_bandwidth *cfs_b = &cfs_rq->tg->cfs_bandwidth;
+	const struct cpumask *span = sched_bw_period_mask();
+	int i, weight;
+	u64 cfs_period;
+	struct task_group *tg = container_of(cfs_b, struct task_group,
+				cfs_bandwidth);
+
+	weight = cpumask_weight(span);
+	spin_lock(&cfs_b->cfs_runtime_lock);
+	cfs_period = ktime_to_ns(cfs_b->cfs_period);
+
+	for_each_cpu(i, span) {
+		struct cfs_rq *borrow_cfs_rq = tg->cfs_rq[i];
+		struct rq *borrow_rq = rq_of(borrow_cfs_rq);
+		s64 diff;
+
+		if (borrow_cfs_rq == cfs_rq)
+			continue;
+
+		double_rq_runtime_lock(rq, borrow_rq);
+		if (borrow_cfs_rq->cfs_runtime == RUNTIME_INF) {
+			double_rq_runtime_unlock(rq, borrow_rq);
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
+				double_rq_runtime_unlock(rq, borrow_rq);
+				break;
+			}
+		}
+		double_rq_runtime_unlock(rq, borrow_rq);
+	}
+	spin_unlock(&cfs_b->cfs_runtime_lock);
+}
+
+/*
+ * Called with rq->runtime_lock held.
+ */
+static void cfs_balance_runtime(struct cfs_rq *cfs_rq)
+{
+	struct rq *rq = rq_of(cfs_rq);
+
+	rq_runtime_unlock(rq);
+	do_cfs_balance_runtime(cfs_rq);
+	rq_runtime_lock(rq);
+}
+
+/*
  * Check if group entity exceeded its runtime. If so, mark the cfs_rq as
  * throttled mark the current task for reschedling.
  */
@@ -232,6 +327,9 @@ static void sched_cfs_runtime_exceeded(struct sched_entity *se,
 	if (cfs_rq_throttled(cfs_rq))
 		return;
 
+	if (cfs_rq->cfs_time > cfs_rq->cfs_runtime)
+		cfs_balance_runtime(cfs_rq);
+
 	if (cfs_rq->cfs_time > cfs_rq->cfs_runtime) {
 		cfs_rq->cfs_throttled = 1;
 		update_stats_throttle_start(cfs_rq, se);
