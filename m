Return-Path: <linux-kernel-owner+w=401wt.eu-S1754853AbZKIJMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853AbZKIJMj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 04:12:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754625AbZKIJMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 04:12:38 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:59054 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754615AbZKIJMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 04:12:37 -0500
Date: Mon, 9 Nov 2009 14:42:36 +0530
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
Subject: [RFC v3 PATCH 6/7] sched: Rebalance cfs runtimes
Message-ID: <20091109091236.GJ23472@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20091109090838.GD23472@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091109090838.GD23472@in.ibm.com>
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
---
 kernel/sched_fair.c |   60 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 60 insertions(+), 0 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 828d7e7..fc09109 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -214,6 +214,63 @@ static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq)
 }
 
 /*
+ * Ran out of runtime, check if we can borrow some from others
+ * instead of getting throttled right away.
+ */
+static void do_cfs_balance_runtime(struct cfs_rq *cfs_rq)
+{
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
+/*
  * Check if group entity exceeded its runtime. If so, mark the cfs_rq as
  * throttled mark the current task for reschedling.
  */
@@ -232,6 +289,9 @@ static void sched_cfs_runtime_exceeded(struct sched_entity *se,
 	if (cfs_rq_throttled(cfs_rq))
 		return;
 
+	if (cfs_rq->cfs_time > cfs_rq->cfs_runtime)
+		cfs_balance_runtime(cfs_rq);
+
 	if (cfs_rq->cfs_time > cfs_rq->cfs_runtime) {
 		cfs_rq->cfs_throttled = 1;
 		update_stats_throttle_start(cfs_rq, se);
