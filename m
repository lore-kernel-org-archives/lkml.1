Return-Path: <linux-kernel-owner+w=401wt.eu-S1756010AbYCIRR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010AbYCIRR4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 13:17:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753975AbYCIRRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 13:17:04 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:57123 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753854AbYCIRRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 13:17:01 -0400
Message-Id: <20080309170929.145446000@chello.nl>
References: <20080309170850.256853000@chello.nl>
User-Agent: quilt/0.45-1
Date: Sun, 09 Mar 2008 18:09:04 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Mike Galbraith <efault@gmx.de>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC/PATCH 14/17] sched: fair: avg_vruntime
Content-Disposition: inline; filename=sched-avg-vruntime.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to implement EEVDF we need to be able to test egibility. 
This requires knowing the current virtual time. We use a property of
fair schedulers to determine this in an numerically stable way, namely
the sum of all lags is 0. Therefore the average of all virtual times
is the position of lag=0.

We can't just take the average of vruntime - as it will use the full range
of its u64 and will wrap around. Instead we'll use the average of
(vruntime - min_vruntime)

\Sum_{i}^{n} 1/n (v_{i} - v) = 1/n (\Sum_{i}^{n} v_{i}) - vn

By factoring out the 1/n (never storing that) we avoid rounding, which
would bring an accumulating error.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c       |    5 +++
 kernel/sched_debug.c |    5 +++
 kernel/sched_fair.c  |   76 ++++++++++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 83 insertions(+), 3 deletions(-)

Index: linux-2.6-2/kernel/sched.c
===================================================================
--- linux-2.6-2.orig/kernel/sched.c
+++ linux-2.6-2/kernel/sched.c
@@ -387,6 +387,11 @@ struct cfs_root_rq {
 	struct rb_root tasks_timeline;
 	struct rb_node *rb_leftmost;
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	s64 avg_vruntime;
+	unsigned long nr_queued;
+#endif
+
 #ifdef CONFIG_SCHEDSTATS
 	unsigned long nr_spread_over;
 	u64 exec_clock;
Index: linux-2.6-2/kernel/sched_fair.c
===================================================================
--- linux-2.6-2.orig/kernel/sched_fair.c
+++ linux-2.6-2/kernel/sched_fair.c
@@ -273,6 +273,67 @@ static void __dequeue_timeline(struct cf
 	rb_erase(&se->run_node, &cfs_r_rq->tasks_timeline);
 }
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
+static inline
+void avg_vruntime_add(struct cfs_root_rq *cfs_r_rq, struct sched_entity *se)
+{
+	s64 key = entity_key(cfs_r_rq, se);
+	cfs_r_rq->avg_vruntime += key;
+	cfs_r_rq->nr_queued++;
+}
+
+static inline
+void avg_vruntime_sub(struct cfs_root_rq *cfs_r_rq, struct sched_entity *se)
+{
+	s64 key = entity_key(cfs_r_rq, se);
+	cfs_r_rq->avg_vruntime -= key;
+	cfs_r_rq->nr_queued--;
+}
+
+static inline
+void avg_vruntime_update(struct cfs_root_rq *cfs_r_rq, s64 delta)
+{
+	cfs_r_rq->avg_vruntime -= cfs_r_rq->nr_queued * delta;
+}
+
+static inline
+s64 avg_vruntime(struct cfs_root_rq *cfs_r_rq)
+{
+	s64 avg = cfs_r_rq->avg_vruntime;
+	int sign = 0;
+
+	if (avg < 0) {
+		sign = 1;
+		avg = -avg;
+	}
+
+	if (cfs_r_rq->nr_queued)
+		do_div(avg, cfs_r_rq->nr_queued);
+
+	if (sign)
+		avg = -avg;
+
+	return avg;
+}
+
+#else /* CONFIG_FAIR_GROUP_SCHED */
+
+static inline
+void avg_vruntime_add(struct cfs_root_rq *cfs_rq, struct sched_entity *se)
+{
+}
+
+static inline
+void avg_vruntime_sub(struct cfs_root_rq *cfs_rq, struct sched_entity *se)
+{
+}
+
+static inline
+void avg_vruntime_update(struct cfs_root_rq *cfs_rq, s64 delta)
+{
+}
+#endif /* CONFIG_FAIR_GROUP_SCHED */
+
 /*
  * Enqueue an entity into the rb-tree:
  */
@@ -286,6 +347,7 @@ static void __enqueue_entity(struct cfs_
 		return;
 
 	__enqueue_timeline(&rq_of(cfs_rq)->cfs_root, se);
+	avg_vruntime_add(&rq_of(cfs_rq)->cfs_root, se);
 }
 
 static void __dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
@@ -297,6 +359,7 @@ static void __dequeue_entity(struct cfs_
 		return;
 
 	__dequeue_timeline(&rq_of(cfs_rq)->cfs_root, se);
+	avg_vruntime_sub(&rq_of(cfs_rq)->cfs_root, se);
 }
 
 static inline struct rb_node *first_fair(struct cfs_root_rq *cfs_r_rq)
@@ -464,6 +527,7 @@ static inline
 void __update_root(struct cfs_root_rq *cfs_r_rq, struct sched_entity *curr)
 {
 	u64 vruntime;
+	s64 delta;
 
 	/*
 	 * maintain cfs_r_rq->min_vruntime to be a monotonic increasing
@@ -475,8 +539,14 @@ void __update_root(struct cfs_root_rq *c
 	} else
 		vruntime = curr->vruntime;
 
-	cfs_r_rq->min_vruntime =
-		max_vruntime(cfs_r_rq->min_vruntime, vruntime);
+	/*
+	 * open coded max_vruntime() to allow updating avg_vruntime
+	 */
+	delta = (s64)(vruntime - cfs_r_rq->min_vruntime);
+	if (delta > 0) {
+		avg_vruntime_update(cfs_r_rq, delta);
+		cfs_r_rq->min_vruntime = vruntime;
+	}
 }
 
 /*
@@ -939,7 +1009,7 @@ static void yield_task_fair(struct rq *r
 	/*
 	 * Are we the only task in the tree?
 	 */
-	if (unlikely(rq->load.weight == curr->se.load.weight))
+	if (unlikely(!rq->cfs_root.nr_queued))
 		return;
 
 	if (likely(!sysctl_sched_compat_yield) && curr->policy != SCHED_BATCH) {
Index: linux-2.6-2/kernel/sched_debug.c
===================================================================
--- linux-2.6-2.orig/kernel/sched_debug.c
+++ linux-2.6-2/kernel/sched_debug.c
@@ -136,6 +136,11 @@ void print_cfs_root(struct seq_file *m, 
 	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "spread0",
 			SPLIT_NS(spread0));
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "avg_vruntime",
+			SPLIT_NS(avg_vruntime(cfs_r_rq)));
+#endif
+
 #ifdef CONFIG_SCHEDSTATS
 	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "exec_clock",
 			SPLIT_NS(cfs_r_rq->exec_clock));

--

