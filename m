Return-Path: <linux-kernel-owner+w=401wt.eu-S1756068AbYBYORU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068AbYBYORU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 09:17:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754174AbYBYORL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 09:17:11 -0500
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:48353 "EHLO
	e28esmtp07.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754206AbYBYORJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 09:17:09 -0500
Date: Mon, 25 Feb 2008 19:47:03 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Sudhir Kumar <skumar@linux.vnet.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>, vgoyal@redhat.com,
       serue@us.ibm.com, menage@google.com
Subject: [RFC, PATCH 1/2] sched: allow the CFS group scheduler to have
	multiple levels
Message-ID: <20080225141703.GB29213@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20080225141504.GA27746@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080225141504.GA27746@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the group scheduler multi hierarchy aware.

Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>

---
 include/linux/sched.h |    2 +-
 kernel/sched.c        |   41 ++++++++++++++++++++++++-----------------
 2 files changed, 25 insertions(+), 18 deletions(-)

Index: linux-2.6.25-rc2/include/linux/sched.h
===================================================================
--- linux-2.6.25-rc2.orig/include/linux/sched.h
+++ linux-2.6.25-rc2/include/linux/sched.h
@@ -2031,7 +2031,7 @@ extern void normalize_rt_tasks(void);
 
 extern struct task_group init_task_group;
 
-extern struct task_group *sched_create_group(void);
+extern struct task_group *sched_create_group(struct task_group *parent);
 extern void sched_destroy_group(struct task_group *tg);
 extern void sched_move_task(struct task_struct *tsk);
 #ifdef CONFIG_FAIR_GROUP_SCHED
Index: linux-2.6.25-rc2/kernel/sched.c
===================================================================
--- linux-2.6.25-rc2.orig/kernel/sched.c
+++ linux-2.6.25-rc2/kernel/sched.c
@@ -7155,10 +7155,11 @@ static void init_rt_rq(struct rt_rq *rt_
 }
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
-static void init_tg_cfs_entry(struct rq *rq, struct task_group *tg,
-		struct cfs_rq *cfs_rq, struct sched_entity *se,
-		int cpu, int add)
+static void init_tg_cfs_entry(struct task_group *tg, struct cfs_rq *cfs_rq,
+				struct sched_entity *se, int cpu, int add,
+				struct sched_entity *parent)
 {
+	struct rq *rq = cpu_rq(cpu);
 	tg->cfs_rq[cpu] = cfs_rq;
 	init_cfs_rq(cfs_rq, rq);
 	cfs_rq->tg = tg;
@@ -7170,7 +7171,11 @@ static void init_tg_cfs_entry(struct rq 
 	if (!se)
 		return;
 
-	se->cfs_rq = &rq->cfs;
+	if (parent == NULL)
+		se->cfs_rq = &rq->cfs;
+	else
+		se->cfs_rq = parent->my_q;
+
 	se->my_q = cfs_rq;
 	se->load.weight = tg->shares;
 	se->load.inv_weight = div64_64(1ULL<<32, se->load.weight);
@@ -7244,7 +7249,8 @@ void __init sched_init(void)
 		 * We achieve this by letting init_task_group's tasks sit
 		 * directly in rq->cfs (i.e init_task_group->se[] = NULL).
 		 */
-		init_tg_cfs_entry(rq, &init_task_group, &rq->cfs, NULL, i, 1);
+		init_tg_cfs_entry(&init_task_group, &rq->cfs,
+							NULL, i, 1, NULL);
 		init_tg_rt_entry(rq, &init_task_group, &rq->rt, NULL, i, 1);
 #elif defined CONFIG_USER_SCHED
 		/*
@@ -7260,7 +7266,7 @@ void __init sched_init(void)
 		 */
 		init_tg_cfs_entry(rq, &init_task_group,
 				&per_cpu(init_cfs_rq, i),
-				&per_cpu(init_sched_entity, i), i, 1);
+				&per_cpu(init_sched_entity, i), i, 1, NULL);
 
 #endif
 #endif /* CONFIG_FAIR_GROUP_SCHED */
@@ -7630,7 +7636,8 @@ static void free_fair_sched_group(struct
 	kfree(tg->se);
 }
 
-static int alloc_fair_sched_group(struct task_group *tg)
+static int alloc_fair_sched_group(struct task_group *tg,
+					struct task_group *parent)
 {
 	struct cfs_rq *cfs_rq;
 	struct sched_entity *se;
@@ -7658,8 +7665,11 @@ static int alloc_fair_sched_group(struct
 				GFP_KERNEL|__GFP_ZERO, cpu_to_node(i));
 		if (!se)
 			goto err;
-
-		init_tg_cfs_entry(rq, tg, cfs_rq, se, i, 0);
+		if (!parent) {
+			init_tg_cfs_entry(tg, cfs_rq, se, i, 0,	parent->se[i]);
+		} else {
+			init_tg_cfs_entry(tg, cfs_rq, se, i, 0, NULL);
+		}
 	}
 
 	return 1;
@@ -7788,7 +7798,7 @@ static void free_sched_group(struct task
 }
 
 /* allocate runqueue etc for a new task group */
-struct task_group *sched_create_group(void)
+struct task_group *sched_create_group(struct task_group *parent)
 {
 	struct task_group *tg;
 	unsigned long flags;
@@ -7798,7 +7808,7 @@ struct task_group *sched_create_group(vo
 	if (!tg)
 		return ERR_PTR(-ENOMEM);
 
-	if (!alloc_fair_sched_group(tg))
+	if (!alloc_fair_sched_group(tg, parent))
 		goto err;
 
 	if (!alloc_rt_sched_group(tg))
@@ -8049,7 +8059,7 @@ static inline struct task_group *cgroup_
 static struct cgroup_subsys_state *
 cpu_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cgrp)
 {
-	struct task_group *tg;
+	struct task_group *tg, *parent;
 
 	if (!cgrp->parent) {
 		/* This is early initialization for the top cgroup */
@@ -8057,11 +8067,8 @@ cpu_cgroup_create(struct cgroup_subsys *
 		return &init_task_group.css;
 	}
 
-	/* we support only 1-level deep hierarchical scheduler atm */
-	if (cgrp->parent->parent)
-		return ERR_PTR(-EINVAL);
-
-	tg = sched_create_group();
+	parent = cgroup_tg(cgrp->parent);
+	tg = sched_create_group(parent);
 	if (IS_ERR(tg))
 		return ERR_PTR(-ENOMEM);
 
-- 
regards,
Dhaval
