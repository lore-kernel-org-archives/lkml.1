Return-Path: <linux-kernel-owner+w=401wt.eu-S1760270AbXJaVQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760270AbXJaVQt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 17:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759622AbXJaVOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 17:14:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44879 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759611AbXJaVOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 17:14:33 -0400
Message-Id: <20071031211248.440554000@chello.nl>
References: <20071031211030.310581000@chello.nl>
User-Agent: quilt/0.45-1
Date: Wed, 31 Oct 2007 22:10:31 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: [PATCH 1/6] sched: move the group scheduling primitives around
Content-Disposition: inline; filename=sched-move-group.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The next patch will make sched_slice group aware, reorder the group scheduling
primitives so that they don't need fwd declarations.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
---
 kernel/sched_fair.c |  190 +++++++++++++++++++++++++---------------------------
 1 file changed, 92 insertions(+), 98 deletions(-)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -80,6 +80,11 @@ const_debug unsigned int sysctl_sched_mi
  * CFS operations on generic schedulable entities:
  */
 
+static inline struct task_struct *task_of(struct sched_entity *se)
+{
+	return container_of(se, struct task_struct, se);
+}
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
 
 /* cpu runqueue to which this cfs_rq is attached */
@@ -91,6 +96,54 @@ static inline struct rq *rq_of(struct cf
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
+	list_for_each_entry(cfs_rq, &rq->leaf_cfs_rq_list, leaf_cfs_rq_list)
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
 #else	/* CONFIG_FAIR_GROUP_SCHED */
 
 static inline struct rq *rq_of(struct cfs_rq *cfs_rq)
@@ -100,13 +153,49 @@ static inline struct rq *rq_of(struct cf
 
 #define entity_is_task(se)	1
 
-#endif	/* CONFIG_FAIR_GROUP_SCHED */
+#define for_each_sched_entity(se) \
+		for (; se; se = NULL)
 
-static inline struct task_struct *task_of(struct sched_entity *se)
+static inline struct cfs_rq *task_cfs_rq(struct task_struct *p)
 {
-	return container_of(se, struct task_struct, se);
+	return &task_rq(p)->cfs;
 }
 
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
+}
+
+#endif	/* CONFIG_FAIR_GROUP_SCHED */
+
 
 /**************************************************************
  * Scheduling class tree data structure manipulation methods:
@@ -626,101 +715,6 @@ static void entity_tick(struct cfs_rq *c
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
-	list_for_each_entry(cfs_rq, &rq->leaf_cfs_rq_list, leaf_cfs_rq_list)
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
 /*
  * The enqueue_task method is called before nr_running is
  * increased. Here we update the fair scheduling stats and

--

