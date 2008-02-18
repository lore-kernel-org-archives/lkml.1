Return-Path: <linux-kernel-owner+w=401wt.eu-S1752582AbYBRKAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582AbYBRKAB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 05:00:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754694AbYBRJ7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 04:59:24 -0500
Received: from viefep31-int.chello.at ([62.179.121.49]:56682 "EHLO
	viefep31-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875AbYBRJ7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 04:59:21 -0500
Message-Id: <20080218095625.836989000@chello.nl>
References: <20080218095535.629736000@chello.nl>
User-Agent: quilt/0.45-1
Date: Mon, 18 Feb 2008 10:55:42 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       dhaval@linux.vnet.ibm.com, tong.n.li@intel.com
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 7/7] sched: fair: vruntime spread
Content-Disposition: inline; filename=sched-fair-spread.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By its very nature we try to converge vruntime between tasks. This makes it
very hard to interleave the groups that have varying latency requirements,
they end up in a single 'lump'. Avoid this by introducing an artificial
vruntime offset:

A1 |--------------|
A2      |--------------|
A3           |--------------|

New            |--------------|

Because tasks have no stable (dense) enumeration within a group
and we'd want the tasks evenly spaced within the period in a regular
fashion, we use an ascending iterator (nr_iter).

This ensures that in a steady state, each task will have the same offset

However, when a new task gets inserted we cannot re-adjust all offsets,
hence we will approximate by inserting the new task at p(1-1/n).
This is why account_entity_enqueue() sets nr_iter to nr_running-1.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h |    1 
 kernel/sched.c        |    2 +
 kernel/sched_fair.c   |   56 ++++++++++++++++++++++++++++++++++++++++++++++----
 3 files changed, 55 insertions(+), 4 deletions(-)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -923,6 +923,7 @@ struct sched_entity {
 	u64			exec_start;
 	u64			sum_exec_runtime;
 	u64			vruntime;
+	u64			voffset;
 	u64			prev_sum_exec_runtime;
 
 #ifdef CONFIG_SCHEDSTATS
Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -220,9 +220,11 @@ static inline u64 min_vruntime(u64 min_v
 
 static inline s64 entity_key(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	return se->vruntime - cfs_rq->min_vruntime;
+	return se->vruntime + se->voffset - cfs_rq->min_vruntime;
 }
 
+static u64 sched_voffset(struct cfs_rq *cfs_rq, struct sched_entity *se);
+
 /*
  * Enqueue an entity into the rb-tree:
  */
@@ -240,6 +242,8 @@ static void __enqueue_entity(struct cfs_
 	if (se == cfs_rq->curr)
 		return;
 
+	se->voffset = sched_voffset(cfs_rq, se);
+
 	cfs_rq = &rq_of(cfs_rq)->cfs;
 
 	link = &cfs_rq->tasks_timeline.rb_node;
@@ -387,7 +391,7 @@ out:
  *
  * vs = s*rw/w = p
  */
-static u64 sched_vslice_add(struct cfs_rq *cfs_rq, struct sched_entity *se)
+static inline u64 sched_vslice(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
 	unsigned long nr_running = cfs_rq->nr_running;
 
@@ -397,6 +401,46 @@ static u64 sched_vslice_add(struct cfs_r
 	return __sched_period(nr_running);
 }
 
+/*
+ * By its very nature we try to converge vruntime between tasks. This makes it
+ * very hard to interleave the groups that have varying latency requirements,
+ * they end up in a single 'lump'. Avoid this by introducing an artificial
+ * vruntime offset:
+ *
+ * A1 |--------------|
+ * A2      |--------------|
+ * A3           |--------------|
+ *
+ * New            |--------------|
+ *
+ * Because tasks have no stable (dense) enumeration within a group [*]
+ * and we'd want the tasks evenly spaced within the period in a regular
+ * fashion, we use an ascending iterator (nr_iter).
+ *
+ * This ensures that in a steady state, each task will have the same offset
+ *
+ * However, when a new task gets inserted we cannot re-adjust all offsets,
+ * hence we will approximate by inserting the new task at p(1-1/n).
+ * This is why account_entity_enqueue() sets nr_iter to nr_running-1.
+ *
+ * [*] it would be possible to arrange for one, but it seems unnecessarily
+ *     complex, esp. as we still can't re-adjust all tasks on insert.
+ */
+static u64 sched_voffset(struct cfs_rq *cfs_rq, struct sched_entity *se)
+{
+	/*
+	 * approximate p/n with min_granularity
+	 */
+	u64 frac = sysctl_sched_min_granularity;
+
+	frac *= cfs_rq->nr_iter;
+	cfs_rq->nr_iter++;
+	if (cfs_rq->nr_iter >= cfs_rq->nr_running)
+		cfs_rq->nr_iter = 0;
+
+	return frac;
+}
+
 static inline unsigned long
 calc_delta_fair(unsigned long delta, struct sched_entity *se)
 {
@@ -564,6 +608,7 @@ static void
 account_entity_enqueue(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
 	update_load_add(&cfs_rq->load, se->load.weight);
+	cfs_rq->nr_iter = cfs_rq->nr_running;
 	cfs_rq->nr_running++;
 	se->on_rq = 1;
 	list_add(&se->group_node, &cfs_rq->tasks);
@@ -574,6 +619,8 @@ account_entity_dequeue(struct cfs_rq *cf
 {
 	update_load_sub(&cfs_rq->load, se->load.weight);
 	cfs_rq->nr_running--;
+	if (cfs_rq->nr_iter >= cfs_rq->nr_running)
+		cfs_rq->nr_iter = 0;
 	se->on_rq = 0;
 	list_del_init(&se->group_node);
 }
@@ -656,7 +703,7 @@ place_entity(struct cfs_rq *cfs_rq, stru
 	 * stays open at the end.
 	 */
 	if (initial && sched_feat(START_DEBIT))
-		vruntime += sched_vslice_add(cfs_rq, se);
+		vruntime += sched_vslice(cfs_rq, se);
 
 	if (!initial) {
 		/* sleeps upto a single latency don't count. */
@@ -678,6 +725,8 @@ enqueue_entity(struct cfs_rq *cfs_rq, st
 	 */
 	update_curr(cfs_rq);
 
+	account_entity_enqueue(cfs_rq, se);
+
 	if (wakeup) {
 		place_entity(cfs_rq, se, 0);
 		enqueue_sleeper(cfs_rq, se);
@@ -686,7 +735,6 @@ enqueue_entity(struct cfs_rq *cfs_rq, st
 	update_stats_enqueue(cfs_rq, se);
 	check_spread(cfs_rq, se);
 	__enqueue_entity(cfs_rq, se);
-	account_entity_enqueue(cfs_rq, se);
 }
 
 static void
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -425,6 +425,8 @@ struct cfs_rq {
 	struct load_weight load;
 	unsigned long nr_running;
 
+	unsigned long nr_iter;
+
 	u64 exec_clock;
 	u64 min_vruntime;
 

--

