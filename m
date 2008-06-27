Return-Path: <linux-kernel-owner+w=401wt.eu-S1760969AbYF0MIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760969AbYF0MIf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 08:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757236AbYF0L62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 07:58:28 -0400
Received: from viefep20-int.chello.at ([62.179.121.40]:36338 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756895AbYF0L6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 07:58:11 -0400
Message-Id: <20080627115211.948674621@chello.nl>
References: <20080627114109.724249622@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 13:41:29 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 20/30] sched: fix load scaling in group balancing
Content-Disposition: inline; filename=sched-fix-load_balance-h_load.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

doing the load balance will change cfs_rq->load.weight (that's the whole point)
but since that's part of the scale factor, we'll scale back with a different
amount.

Weight getting smaller would result in an inflated moved_load which causes
it to stop balancing too soon.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched_fair.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -1449,6 +1449,8 @@ load_balance_fair(struct rq *this_rq, in
 
 	list_for_each_entry(tg, &task_groups, list) {
 		struct cfs_rq *busiest_cfs_rq = tg->cfs_rq[busiest_cpu];
+		unsigned long busiest_h_load = busiest_cfs_rq->h_load;
+		unsigned long busiest_weight = busiest_cfs_rq->load.weight;
 		long rem_load, moved_load;
 
 		/*
@@ -1457,8 +1459,8 @@ load_balance_fair(struct rq *this_rq, in
 		if (!busiest_cfs_rq->task_weight)
 			continue;
 
-		rem_load = rem_load_move * busiest_cfs_rq->load.weight;
-		rem_load /= busiest_cfs_rq->h_load + 1;
+		rem_load = rem_load_move * busiest_weight;
+		rem_load /= busiest_h_load + 1;
 
 		moved_load = __load_balance_fair(this_rq, this_cpu, busiest,
 				rem_load, sd, idle, all_pinned, this_best_prio,
@@ -1467,8 +1469,8 @@ load_balance_fair(struct rq *this_rq, in
 		if (!moved_load)
 			continue;
 
-		moved_load *= busiest_cfs_rq->h_load;
-		moved_load /= busiest_cfs_rq->load.weight + 1;
+		moved_load *= busiest_h_load;
+		moved_load /= busiest_weight + 1;
 
 		rem_load_move -= moved_load;
 		if (rem_load_move < 0)

-- 

