Return-Path: <linux-kernel-owner+w=401wt.eu-S1760719AbYF0MG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760719AbYF0MG5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 08:06:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754660AbYF0L6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 07:58:24 -0400
Received: from viefep31-int.chello.at ([62.179.121.49]:54288 "EHLO
	viefep31-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756797AbYF0L6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 07:58:08 -0400
Message-Id: <20080627115211.506832285@chello.nl>
References: <20080627114109.724249622@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 13:41:20 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 11/30] sched: kill task_group balancing
Content-Disposition: inline; filename=sched-group-balance-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>

The idea was to balance groups until we've reached the global goal, however
Vatsa rightly pointed out that we might never reach that goal this way -
hence take out this logic.

[ the initial rationale for this 'feature' was to promote max concurrency
  within a group - it does not however affect fairness ]

Reported-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched_fair.c |   15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -1427,9 +1427,7 @@ load_balance_fair(struct rq *this_rq, in
 
 	rcu_read_lock();
 	list_for_each_entry(tg, &task_groups, list) {
-		long imbalance;
-		unsigned long this_weight, busiest_weight;
-		long rem_load, max_load, moved_load;
+		long rem_load, moved_load;
 
 		/*
 		 * empty group
@@ -1440,17 +1438,8 @@ load_balance_fair(struct rq *this_rq, in
 		rem_load = rem_load_move * aggregate(tg, this_cpu)->rq_weight;
 		rem_load /= aggregate(tg, this_cpu)->load + 1;
 
-		this_weight = tg->cfs_rq[this_cpu]->task_weight;
-		busiest_weight = tg->cfs_rq[busiest_cpu]->task_weight;
-
-		imbalance = (busiest_weight - this_weight) / 2;
-
-		if (imbalance < 0)
-			imbalance = busiest_weight;
-
-		max_load = max(rem_load, imbalance);
 		moved_load = __load_balance_fair(this_rq, this_cpu, busiest,
-				max_load, sd, idle, all_pinned, this_best_prio,
+				rem_load, sd, idle, all_pinned, this_best_prio,
 				tg->cfs_rq[busiest_cpu]);
 
 		if (!moved_load)

-- 

