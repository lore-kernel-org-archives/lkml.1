Return-Path: <linux-kernel-owner+w=401wt.eu-S1758346AbYF0L7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758346AbYF0L7o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 07:59:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755137AbYF0L55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 07:57:57 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:7165 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753808AbYF0L5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 07:57:52 -0400
Message-Id: <20080627115211.107047525@chello.nl>
References: <20080627114109.724249622@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 13:41:12 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 03/30] sched: fix calc_delta_asym()
Content-Disposition: inline; filename=sched-asyn_gran.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

calc_delta_asym() is supposed to do the same as calc_delta_fair() except
linearly shrink the result for negative nice processes - this causes them
to have a smaller preemption threshold so that they are more easily preempted.

The problem is that for task groups se->load.weight is the per cpu share of
the actual task group weight; take that into account.

Also provide a debug switch to disable the asymmetry (which I still don't
like - but it does greatly benefit some workloads)

This would explain the interactivity issues reported against group scheduling.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched_fair.c     |   28 +++++++++++++++++++++++++++-
 kernel/sched_features.h |    1 +
 2 files changed, 28 insertions(+), 1 deletion(-)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -430,6 +430,29 @@ calc_delta_asym(unsigned long delta, str
 	for_each_sched_entity(se) {
 		struct load_weight *se_lw = &se->load;
 
+#ifdef CONFIG_FAIR_SCHED_GROUP
+		struct cfs_rq *cfs_rq = se->my_q;
+		struct task_group *tg = NULL
+
+		if (cfs_rq)
+			tg = cfs_rq->tg;
+
+		if (tg && tg->shares < NICE_0_LOAD) {
+			/*
+			 * scale shares to what it would have been had
+			 * tg->weight been NICE_0_LOAD:
+			 *
+			 *   weight = 1024 * shares / tg->weight
+			 */
+			lw.weight *= se->load.weight;
+			lw.weight /= tg->shares;
+
+			lw.inv_weight = 0;
+
+			se_lw = &lw;
+		} else
+#endif
+
 		if (se->load.weight < NICE_0_LOAD)
 			se_lw = &lw;
 
@@ -1154,7 +1177,10 @@ static unsigned long wakeup_gran(struct 
 	 * More easily preempt - nice tasks, while not making it harder for
 	 * + nice tasks.
 	 */
-	gran = calc_delta_asym(sysctl_sched_wakeup_granularity, se);
+	if (sched_feat(ASYM_GRAN))
+		gran = calc_delta_asym(sysctl_sched_wakeup_granularity, se);
+	else
+		gran = calc_delta_fair(sysctl_sched_wakeup_granularity, se);
 
 	return gran;
 }
Index: linux-2.6/kernel/sched_features.h
===================================================================
--- linux-2.6.orig/kernel/sched_features.h
+++ linux-2.6/kernel/sched_features.h
@@ -6,3 +6,4 @@ SCHED_FEAT(CACHE_HOT_BUDDY, 1)
 SCHED_FEAT(SYNC_WAKEUPS, 1)
 SCHED_FEAT(HRTICK, 1)
 SCHED_FEAT(DOUBLE_TICK, 0)
+SCHED_FEAT(ASYM_GRAN, 1)

-- 

