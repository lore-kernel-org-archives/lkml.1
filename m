Return-Path: <linux-kernel-owner+w=401wt.eu-S1757730AbYBDVS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757730AbYBDVS3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 16:18:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755557AbYBDVRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 16:17:14 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:41965 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755403AbYBDVRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 16:17:10 -0500
Message-Id: <20080204211837.523183000@chello.nl>
References: <20080204210258.118479000@chello.nl>
User-Agent: quilt/0.45-1
Date: Mon, 04 Feb 2008 22:03:03 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: tong.n.li@intel.com, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 5/8] sched: rt-group: clean up the ifdeffery
Content-Disposition: inline; filename=sched-rt-group-unclutter.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up some of the excessive ifdeffery introduces in the last patch.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |  150 ++++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 100 insertions(+), 50 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -7563,56 +7563,29 @@ static int load_balance_monitor(void *un
 }
 #endif	/* CONFIG_SMP */
 
-static void free_sched_group(struct task_group *tg)
+#ifdef CONFIG_FAIR_GROUP_SCHED
+static void free_fair_sched_group(struct task_group *tg)
 {
 	int i;
 
 	for_each_possible_cpu(i) {
-#ifdef CONFIG_FAIR_GROUP_SCHED
 		if (tg->cfs_rq)
 			kfree(tg->cfs_rq[i]);
 		if (tg->se)
 			kfree(tg->se[i]);
-#endif
-#ifdef CONFIG_RT_GROUP_SCHED
-		if (tg->rt_rq)
-			kfree(tg->rt_rq[i]);
-		if (tg->rt_se)
-			kfree(tg->rt_se[i]);
-#endif
 	}
 
-#ifdef CONFIG_FAIR_GROUP_SCHED
 	kfree(tg->cfs_rq);
 	kfree(tg->se);
-#endif
-#ifdef CONFIG_RT_GROUP_SCHED
-	kfree(tg->rt_rq);
-	kfree(tg->rt_se);
-#endif
-	kfree(tg);
 }
 
-/* allocate runqueue etc for a new task group */
-struct task_group *sched_create_group(void)
+static int alloc_fair_sched_group(struct task_group *tg)
 {
-	struct task_group *tg;
-#ifdef CONFIG_FAIR_GROUP_SCHED
 	struct cfs_rq *cfs_rq;
 	struct sched_entity *se;
-#endif
-#ifdef CONFIG_RT_GROUP_SCHED
-	struct rt_rq *rt_rq;
-	struct sched_rt_entity *rt_se;
-#endif
 	struct rq *rq;
 	int i;
 
-	tg = kzalloc(sizeof(*tg), GFP_KERNEL);
-	if (!tg)
-		return ERR_PTR(-ENOMEM);
-
-#ifdef CONFIG_FAIR_GROUP_SCHED
 	tg->cfs_rq = kzalloc(sizeof(cfs_rq) * NR_CPUS, GFP_KERNEL);
 	if (!tg->cfs_rq)
 		goto err;
@@ -7621,23 +7594,10 @@ struct task_group *sched_create_group(vo
 		goto err;
 
 	tg->shares = NICE_0_LOAD;
-#endif
-
-#ifdef CONFIG_RT_GROUP_SCHED
-	tg->rt_rq = kzalloc(sizeof(rt_rq) * NR_CPUS, GFP_KERNEL);
-	if (!tg->rt_rq)
-		goto err;
-	tg->rt_se = kzalloc(sizeof(rt_se) * NR_CPUS, GFP_KERNEL);
-	if (!tg->rt_se)
-		goto err;
-
-	tg->rt_runtime = 0;
-#endif
 
 	for_each_possible_cpu(i) {
 		rq = cpu_rq(i);
 
-#ifdef CONFIG_FAIR_GROUP_SCHED
 		cfs_rq = kmalloc_node(sizeof(struct cfs_rq),
 				GFP_KERNEL|__GFP_ZERO, cpu_to_node(i));
 		if (!cfs_rq)
@@ -7649,9 +7609,68 @@ struct task_group *sched_create_group(vo
 			goto err;
 
 		init_tg_cfs_entry(rq, tg, cfs_rq, se, i, 0);
+	}
+
+	lock_task_group_list();
+	for_each_possible_cpu(i) {
+		rq = cpu_rq(i);
+		cfs_rq = tg->cfs_rq[i];
+		list_add_rcu(&cfs_rq->leaf_cfs_rq_list, &rq->leaf_cfs_rq_list);
+	}
+	list_add_rcu(&tg->list, &task_groups);
+	unlock_task_group_list();
+
+	return 1;
+
+ err:
+	return 0;
+}
+#else
+static inline void free_fair_sched_group(struct task_group *tg)
+{
+}
+
+static inline int alloc_fair_sched_group(struct task_group *tg)
+{
+	return 1;
+}
 #endif
 
 #ifdef CONFIG_RT_GROUP_SCHED
+static void free_rt_sched_group(struct task_group *tg)
+{
+	int i;
+
+	for_each_possible_cpu(i) {
+		if (tg->rt_rq)
+			kfree(tg->rt_rq[i]);
+		if (tg->rt_se)
+			kfree(tg->rt_se[i]);
+	}
+
+	kfree(tg->rt_rq);
+	kfree(tg->rt_se);
+}
+
+static int alloc_rt_sched_group(struct task_group *tg)
+{
+	struct rt_rq *rt_rq;
+	struct sched_rt_entity *rt_se;
+	struct rq *rq;
+	int i;
+
+	tg->rt_rq = kzalloc(sizeof(rt_rq) * NR_CPUS, GFP_KERNEL);
+	if (!tg->rt_rq)
+		goto err;
+	tg->rt_se = kzalloc(sizeof(rt_se) * NR_CPUS, GFP_KERNEL);
+	if (!tg->rt_se)
+		goto err;
+
+	tg->rt_runtime = 0;
+
+	for_each_possible_cpu(i) {
+		rq = cpu_rq(i);
+
 		rt_rq = kmalloc_node(sizeof(struct rt_rq),
 				GFP_KERNEL|__GFP_ZERO, cpu_to_node(i));
 		if (!rt_rq)
@@ -7663,24 +7682,55 @@ struct task_group *sched_create_group(vo
 			goto err;
 
 		init_tg_rt_entry(rq, tg, rt_rq, rt_se, i, 0);
-#endif
 	}
 
 	lock_task_group_list();
 	for_each_possible_cpu(i) {
 		rq = cpu_rq(i);
-#ifdef CONFIG_FAIR_GROUP_SCHED
-		cfs_rq = tg->cfs_rq[i];
-		list_add_rcu(&cfs_rq->leaf_cfs_rq_list, &rq->leaf_cfs_rq_list);
-#endif
-#ifdef CONFIG_RT_GROUP_SCHED
 		rt_rq = tg->rt_rq[i];
 		list_add_rcu(&rt_rq->leaf_rt_rq_list, &rq->leaf_rt_rq_list);
-#endif
 	}
 	list_add_rcu(&tg->list, &task_groups);
 	unlock_task_group_list();
 
+	return 1;
+
+ err:
+	return 0;
+}
+#else
+static inline void free_rt_sched_group(struct task_group *tg)
+{
+}
+
+static inline int alloc_rt_sched_group(struct task_group *tg)
+{
+	return 1;
+}
+#endif
+
+static void free_sched_group(struct task_group *tg)
+{
+	free_fair_sched_group(tg);
+	free_rt_sched_group(tg);
+	kfree(tg);
+}
+
+/* allocate runqueue etc for a new task group */
+struct task_group *sched_create_group(void)
+{
+	struct task_group *tg;
+
+	tg = kzalloc(sizeof(*tg), GFP_KERNEL);
+	if (!tg)
+		return ERR_PTR(-ENOMEM);
+
+	if (!alloc_fair_sched_group(tg))
+		goto err;
+
+	if (!alloc_rt_sched_group(tg))
+		goto err;
+
 	return tg;
 
 err:

--

