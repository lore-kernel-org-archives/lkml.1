Return-Path: <linux-kernel-owner+w=401wt.eu-S1760191AbXIYQW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760191AbXIYQW2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 12:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752873AbXIYQWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 12:22:20 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:34525 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967AbXIYQWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 12:22:19 -0400
Date: Tue, 25 Sep 2007 22:03:02 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/3] Fix size bloat for !CONFIG_FAIR_GROUP_SCHED
Message-ID: <20070925163302.GC3231@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20070925144443.GA17858@elte.hu> <20070925162502.GA3231@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070925162502.GA3231@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Recent fix to check_preempt_wakeup() to check for preemption at higher
levels caused a size bloat for !CONFIG_FAIR_GROUP_SCHED.

Fix the problem.

  42277   10598     320   53195    cfcb kernel/sched.o-before_this_patch
  42216   10598     320   53134    cf8e kernel/sched.o-after_this_patch


Signed-off-by : Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>


---
 kernel/sched_fair.c |   43 +++++++++++++++++++++++++------------------
 1 files changed, 25 insertions(+), 18 deletions(-)

Index: current/kernel/sched_fair.c
===================================================================
--- current.orig/kernel/sched_fair.c
+++ current/kernel/sched_fair.c
@@ -640,15 +640,21 @@ static inline struct cfs_rq *cpu_cfs_rq(
 #define for_each_leaf_cfs_rq(rq, cfs_rq) \
 	list_for_each_entry(cfs_rq, &rq->leaf_cfs_rq_list, leaf_cfs_rq_list)
 
-/* Do the two (enqueued) tasks belong to the same group ? */
-static inline int is_same_group(struct task_struct *curr, struct task_struct *p)
+/* Do the two (enqueued) entities belong to the same group ? */
+static inline int
+is_same_group(struct sched_entity *se, struct sched_entity *pse)
 {
-	if (curr->se.cfs_rq == p->se.cfs_rq)
+	if (se->cfs_rq == pse->cfs_rq)
 		return 1;
 
 	return 0;
 }
 
+static inline struct sched_entity *parent_entity(struct sched_entity *se)
+{
+	return se->parent;
+}
+
 #else	/* CONFIG_FAIR_GROUP_SCHED */
 
 #define for_each_sched_entity(se) \
@@ -681,11 +687,17 @@ static inline struct cfs_rq *cpu_cfs_rq(
 #define for_each_leaf_cfs_rq(rq, cfs_rq) \
 		for (cfs_rq = &rq->cfs; cfs_rq; cfs_rq = NULL)
 
-static inline int is_same_group(struct task_struct *curr, struct task_struct *p)
+static inline int
+is_same_group(struct sched_entity *se, struct sched_entity *pse)
 {
 	return 1;
 }
 
+static inline struct sched_entity *parent_entity(struct sched_entity *se)
+{
+	return NULL;
+}
+
 #endif	/* CONFIG_FAIR_GROUP_SCHED */
 
 /*
@@ -775,8 +787,9 @@ static void yield_task_fair(struct rq *r
 static void check_preempt_wakeup(struct rq *rq, struct task_struct *p)
 {
 	struct task_struct *curr = rq->curr;
-	struct cfs_rq *cfs_rq = task_cfs_rq(curr), *pcfs_rq;
+	struct cfs_rq *cfs_rq = task_cfs_rq(curr);
 	struct sched_entity *se = &curr->se, *pse = &p->se;
+	s64 delta;
 
 	if (unlikely(rt_prio(p->prio))) {
 		update_rq_clock(rq);
@@ -785,21 +798,15 @@ static void check_preempt_wakeup(struct 
 		return;
 	}
 
-	for_each_sched_entity(se) {
-		cfs_rq = cfs_rq_of(se);
-		pcfs_rq = cfs_rq_of(pse);
+	while (!is_same_group(se, pse)) {
+		se = parent_entity(se);
+		pse = parent_entity(pse);
+	}
 
-		if (cfs_rq == pcfs_rq) {
-			s64 delta = se->vruntime - pse->vruntime;
+	delta = se->vruntime - pse->vruntime;
 
-			if (delta > (s64)sysctl_sched_wakeup_granularity)
-				resched_task(curr);
-			break;
-		}
-#ifdef CONFIG_FAIR_GROUP_SCHED
-		pse = pse->parent;
-#endif
-	}
+	if (delta > (s64)sysctl_sched_wakeup_granularity)
+		resched_task(curr);
 }
 
 static struct task_struct *pick_next_task_fair(struct rq *rq)


-- 
Regards,
vatsa
