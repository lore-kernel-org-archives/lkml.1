Return-Path: <linux-kernel-owner+w=401wt.eu-S1754421AbYF0L6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421AbYF0L6r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 07:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754706AbYF0L5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 07:57:54 -0400
Received: from viefep20-int.chello.at ([62.179.121.40]:44484 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203AbYF0L5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 07:57:52 -0400
Message-Id: <20080627115211.556117778@chello.nl>
References: <20080627114109.724249622@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 13:41:21 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 12/30] sched: dont micro manage share losses
Content-Disposition: inline; filename=sched-aggregate-no-fixups.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We used to try and contain the loss of 'shares' by playing arithmetic
games. Replace that by noticing that at the top sched_domain we'll
always have the full weight in shares to distribute.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   26 +++-----------------------
 1 file changed, 3 insertions(+), 23 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -1561,6 +1561,9 @@ aggregate_group_shares(struct task_group
 	if ((!shares && aggregate(tg, cpu)->rq_weight) || shares > tg->shares)
 		shares = tg->shares;
 
+	if (!sd->parent || !(sd->parent->flags & SD_LOAD_BALANCE))
+		shares = tg->shares;
+
 	aggregate(tg, cpu)->shares = shares;
 }
 
@@ -1652,20 +1655,8 @@ static void
 __move_group_shares(struct task_group *tg, int cpu, struct sched_domain *sd,
 		    int scpu, int dcpu)
 {
-	unsigned long shares;
-
-	shares = tg->cfs_rq[scpu]->shares + tg->cfs_rq[dcpu]->shares;
-
 	__update_group_shares_cpu(tg, cpu, sd, scpu);
 	__update_group_shares_cpu(tg, cpu, sd, dcpu);
-
-	/*
-	 * ensure we never loose shares due to rounding errors in the
-	 * above redistribution.
-	 */
-	shares -= tg->cfs_rq[scpu]->shares + tg->cfs_rq[dcpu]->shares;
-	if (shares)
-		tg->cfs_rq[dcpu]->shares += shares;
 }
 
 /*
@@ -1685,7 +1676,6 @@ move_group_shares(struct task_group *tg,
 static void
 aggregate_group_set_shares(struct task_group *tg, int cpu, struct sched_domain *sd)
 {
-	unsigned long shares = aggregate(tg, cpu)->shares;
 	int i;
 
 	for_each_cpu_mask(i, sd->span) {
@@ -1698,16 +1688,6 @@ aggregate_group_set_shares(struct task_g
 	}
 
 	aggregate_group_shares(tg, cpu, sd);
-
-	/*
-	 * ensure we never loose shares due to rounding errors in the
-	 * above redistribution.
-	 */
-	shares -= aggregate(tg, cpu)->shares;
-	if (shares) {
-		tg->cfs_rq[cpu]->shares += shares;
-		aggregate(tg, cpu)->shares += shares;
-	}
 }
 
 /*

-- 

