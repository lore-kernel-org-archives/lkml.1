Return-Path: <linux-kernel-owner+w=401wt.eu-S1758772AbYBRKAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758772AbYBRKAz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 05:00:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756064AbYBRJ70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 04:59:26 -0500
Received: from viefep31-int.chello.at ([62.179.121.49]:55338 "EHLO
	viefep31-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592AbYBRJ7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 04:59:23 -0500
Message-Id: <20080218095624.577843000@chello.nl>
References: <20080218095535.629736000@chello.nl>
User-Agent: quilt/0.45-1
Date: Mon, 18 Feb 2008 10:55:37 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       dhaval@linux.vnet.ibm.com, tong.n.li@intel.com
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/7] sched: fair-group scheduling vs latency
Content-Disposition: inline; filename=sched-fair-group-slice.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently FAIR_GROUP sched grows the scheduler latency outside of
sysctl_sched_latency, invert this so it stays within.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched_fair.c |  233 ++++++++++++++++++++++++++--------------------------
 1 file changed, 120 insertions(+), 113 deletions(-)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -87,6 +87,11 @@ const_debug unsigned int sysctl_sched_mi
  * CFS operations on generic schedulable entities:
  */
 
+static inline struct task_struct *task_of(struct sched_entity *se)
+{
+	return container_of(se, struct task_struct, se);
+}
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
 
 /* cpu runqueue to which this cfs_rq is attached */
@@ -98,6 +103,56 @@ static inline struct rq *rq_of(struct cf
 /* An entity is a task if it doesn't "own" a runqueue */
 #define entity_is_task(se)	(!se->my_q)
 
+/* Walk up scheduling entities hierarchy */
+#define for_each_sched_entity(se) \
+		for (; se; se = se->parent)
+
+static inline struct cfs_rq *task_cfs_rq(struct task_struct *p)
+{
+	return p->se.cfs_rq;
+}
+
+/* runqueue on which this entity is (to be) queued */
+static inline struct cfs_rq *cfs_rq_of(struct sched_entity *se)
+{
+	return se->cfs_rq;
+}
+
+/* runqueue "owned" by this group */
+static inline struct cfs_rq *group_cfs_rq(struct sched_entity *grp)
+{
+	return grp->my_q;
+}
+
+/* Given a group's cfs_rq on one cpu, return its corresponding cfs_rq on
+ * another cpu ('this_cpu')
+ */
+static inline struct cfs_rq *cpu_cfs_rq(struct cfs_rq *cfs_rq, int this_cpu)
+{
+	return cfs_rq->tg->cfs_rq[this_cpu];
+}
+
+/* Iterate thr' all leaf cfs_rq's on a runqueue */
+#define for_each_leaf_cfs_rq(rq, cfs_rq) \
+	list_for_each_entry_rcu(cfs_rq, &rq->leaf_cfs_rq_list, leaf_cfs_rq_list)
+
+/* Do the two (enqueued) entities belong to the same group ? */
+static inline int
+is_same_group(struct sched_entity *se, struct sched_entity *pse)
+{
+	if (se->cfs_rq == pse->cfs_rq)
+		return 1;
+
+	return 0;
+}
+
+static inline struct sched_entity *parent_entity(struct sched_entity *se)
+{
+	return se->parent;
+}
+
+#define GROUP_IMBALANCE_PCT	20
+
 #else	/* CONFIG_FAIR_GROUP_SCHED */
 
 static inline struct rq *rq_of(struct cfs_rq *cfs_rq)
@@ -107,13 +162,49 @@ static inline struct rq *rq_of(struct cf
 
 #define entity_is_task(se)	1
 
-#endif	/* CONFIG_FAIR_GROUP_SCHED */
+#define for_each_sched_entity(se) \
+		for (; se; se = NULL)
 
-static inline struct task_struct *task_of(struct sched_entity *se)
+static inline struct cfs_rq *task_cfs_rq(struct task_struct *p)
 {
-	return container_of(se, struct task_struct, se);
+	return &task_rq(p)->cfs;
+}
+
+static inline struct cfs_rq *cfs_rq_of(struct sched_entity *se)
+{
+	struct task_struct *p = task_of(se);
+	struct rq *rq = task_rq(p);
+
+	return &rq->cfs;
+}
+
+/* runqueue "owned" by this group */
+static inline struct cfs_rq *group_cfs_rq(struct sched_entity *grp)
+{
+	return NULL;
+}
+
+static inline struct cfs_rq *cpu_cfs_rq(struct cfs_rq *cfs_rq, int this_cpu)
+{
+	return &cpu_rq(this_cpu)->cfs;
+}
+
+#define for_each_leaf_cfs_rq(rq, cfs_rq) \
+		for (cfs_rq = &rq->cfs; cfs_rq; cfs_rq = NULL)
+
+static inline int
+is_same_group(struct sched_entity *se, struct sched_entity *pse)
+{
+	return 1;
+}
+
+static inline struct sched_entity *parent_entity(struct sched_entity *se)
+{
+	return NULL;
 }
 
+#endif	/* CONFIG_FAIR_GROUP_SCHED */
+
 
 /**************************************************************
  * Scheduling class tree data structure manipulation methods:
@@ -267,31 +358,44 @@ static u64 sched_slice(struct cfs_rq *cf
 {
 	u64 slice = __sched_period(cfs_rq->nr_running);
 
-	slice *= se->load.weight;
-	do_div(slice, cfs_rq->load.weight);
+	for_each_sched_entity(se) {
+		cfs_rq = cfs_rq_of(se);
+
+		slice *= se->load.weight;
+		do_div(slice, cfs_rq->load.weight);
+	}
 
 	return slice;
 }
 
 /*
- * We calculate the vruntime slice.
+ * We calculate the vruntime slice of a to be inserted task
  *
  * vs = s/w = p/rw
  */
-static u64 __sched_vslice(unsigned long rq_weight, unsigned long nr_running)
+static u64 sched_vslice_add(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	u64 vslice = __sched_period(nr_running);
+	unsigned long nr_running = cfs_rq->nr_running;
+	unsigned long weight;
+	u64 vslice;
 
-	vslice *= NICE_0_LOAD;
-	do_div(vslice, rq_weight);
+	if (!se->on_rq)
+		nr_running++;
 
-	return vslice;
-}
+	vslice = __sched_period(nr_running);
 
-static u64 sched_vslice_add(struct cfs_rq *cfs_rq, struct sched_entity *se)
-{
-	return __sched_vslice(cfs_rq->load.weight + se->load.weight,
-			cfs_rq->nr_running + 1);
+	for_each_sched_entity(se) {
+		cfs_rq = cfs_rq_of(se);
+
+		weight = cfs_rq->load.weight;
+		if (!se->on_rq)
+			weight += se->load.weight;
+
+		vslice *= NICE_0_LOAD;
+		do_div(vslice, weight);
+	}
+
+	return vslice;
 }
 
 /*
@@ -668,103 +772,6 @@ entity_tick(struct cfs_rq *cfs_rq, struc
  * CFS operations on tasks:
  */
 
-#ifdef CONFIG_FAIR_GROUP_SCHED
-
-/* Walk up scheduling entities hierarchy */
-#define for_each_sched_entity(se) \
-		for (; se; se = se->parent)
-
-static inline struct cfs_rq *task_cfs_rq(struct task_struct *p)
-{
-	return p->se.cfs_rq;
-}
-
-/* runqueue on which this entity is (to be) queued */
-static inline struct cfs_rq *cfs_rq_of(struct sched_entity *se)
-{
-	return se->cfs_rq;
-}
-
-/* runqueue "owned" by this group */
-static inline struct cfs_rq *group_cfs_rq(struct sched_entity *grp)
-{
-	return grp->my_q;
-}
-
-/* Given a group's cfs_rq on one cpu, return its corresponding cfs_rq on
- * another cpu ('this_cpu')
- */
-static inline struct cfs_rq *cpu_cfs_rq(struct cfs_rq *cfs_rq, int this_cpu)
-{
-	return cfs_rq->tg->cfs_rq[this_cpu];
-}
-
-/* Iterate thr' all leaf cfs_rq's on a runqueue */
-#define for_each_leaf_cfs_rq(rq, cfs_rq) \
-	list_for_each_entry_rcu(cfs_rq, &rq->leaf_cfs_rq_list, leaf_cfs_rq_list)
-
-/* Do the two (enqueued) entities belong to the same group ? */
-static inline int
-is_same_group(struct sched_entity *se, struct sched_entity *pse)
-{
-	if (se->cfs_rq == pse->cfs_rq)
-		return 1;
-
-	return 0;
-}
-
-static inline struct sched_entity *parent_entity(struct sched_entity *se)
-{
-	return se->parent;
-}
-
-#define GROUP_IMBALANCE_PCT	20
-
-#else	/* CONFIG_FAIR_GROUP_SCHED */
-
-#define for_each_sched_entity(se) \
-		for (; se; se = NULL)
-
-static inline struct cfs_rq *task_cfs_rq(struct task_struct *p)
-{
-	return &task_rq(p)->cfs;
-}
-
-static inline struct cfs_rq *cfs_rq_of(struct sched_entity *se)
-{
-	struct task_struct *p = task_of(se);
-	struct rq *rq = task_rq(p);
-
-	return &rq->cfs;
-}
-
-/* runqueue "owned" by this group */
-static inline struct cfs_rq *group_cfs_rq(struct sched_entity *grp)
-{
-	return NULL;
-}
-
-static inline struct cfs_rq *cpu_cfs_rq(struct cfs_rq *cfs_rq, int this_cpu)
-{
-	return &cpu_rq(this_cpu)->cfs;
-}
-
-#define for_each_leaf_cfs_rq(rq, cfs_rq) \
-		for (cfs_rq = &rq->cfs; cfs_rq; cfs_rq = NULL)
-
-static inline int
-is_same_group(struct sched_entity *se, struct sched_entity *pse)
-{
-	return 1;
-}
-
-static inline struct sched_entity *parent_entity(struct sched_entity *se)
-{
-	return NULL;
-}
-
-#endif	/* CONFIG_FAIR_GROUP_SCHED */
-
 #ifdef CONFIG_SCHED_HRTICK
 static void hrtick_start_fair(struct rq *rq, struct task_struct *p)
 {

--

