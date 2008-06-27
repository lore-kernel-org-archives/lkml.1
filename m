Return-Path: <linux-kernel-owner+w=401wt.eu-S1758131AbYF0L71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758131AbYF0L71 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 07:59:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755024AbYF0L54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 07:57:56 -0400
Received: from viefep32-int.chello.at ([62.179.121.50]:38395 "EHLO
	viefep32-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754373AbYF0L5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 07:57:52 -0400
Message-Id: <20080627115211.604904234@chello.nl>
References: <20080627114109.724249622@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 13:41:22 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 13/30] sched: no need to aggregate task_weight
Content-Disposition: inline; filename=sched-agg-no-task_weight.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We only need to know the task_weight of the busiest rq - nothing to do
if there are no tasks there.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c      |   16 +---------------
 kernel/sched_fair.c |    2 +-
 2 files changed, 2 insertions(+), 16 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -432,12 +432,6 @@ struct cfs_rq {
 		 * The sum of all runqueue weights within this span.
 		 */
 		unsigned long rq_weight;
-
-		/*
-		 * Weight contributed by tasks; this is the part we can
-		 * influence by moving tasks around.
-		 */
-		unsigned long task_weight;
 	} aggregate;
 #endif
 #endif
@@ -1483,10 +1477,6 @@ static int task_hot(struct task_struct *
  * rq_weight:
  *    Direct sum of all the cpu's their rq weight, e.g. A would get 3 while
  *    B would get 2.
- *
- * task_weight:
- *    Part of the rq_weight contributed by tasks; all groups except B would
- *    get 1, B gets 2.
  */
 
 static inline struct aggregate_struct *
@@ -1534,16 +1524,12 @@ static void
 aggregate_group_weight(struct task_group *tg, int cpu, struct sched_domain *sd)
 {
 	unsigned long rq_weight = 0;
-	unsigned long task_weight = 0;
 	int i;
 
-	for_each_cpu_mask(i, sd->span) {
+	for_each_cpu_mask(i, sd->span)
 		rq_weight += tg->cfs_rq[i]->load.weight;
-		task_weight += tg->cfs_rq[i]->task_weight;
-	}
 
 	aggregate(tg, cpu)->rq_weight = rq_weight;
-	aggregate(tg, cpu)->task_weight = task_weight;
 }
 
 /*
Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -1418,7 +1418,7 @@ load_balance_fair(struct rq *this_rq, in
 		/*
 		 * empty group
 		 */
-		if (!aggregate(tg, this_cpu)->task_weight)
+		if (!tg->cfs_rq[busiest_cpu]->task_weight)
 			continue;
 
 		rem_load = rem_load_move * aggregate(tg, this_cpu)->rq_weight;

-- 

