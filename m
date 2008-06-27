Return-Path: <linux-kernel-owner+w=401wt.eu-S1759124AbYF0MIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759124AbYF0MIO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 08:08:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755171AbYF0L61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 07:58:27 -0400
Received: from viefep11-int.chello.at ([62.179.121.31]:52969 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756899AbYF0L6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 07:58:11 -0400
Message-Id: <20080627115212.299243385@chello.nl>
References: <20080627114109.724249622@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 13:41:36 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 27/30] sched: fix mult overflow
Content-Disposition: inline; filename=sched-fix-mult-overflow.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>

It was observed these mults can overflow.

Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched_fair.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -1518,7 +1518,7 @@ load_balance_fair(struct rq *this_rq, in
 		struct cfs_rq *busiest_cfs_rq = tg->cfs_rq[busiest_cpu];
 		unsigned long busiest_h_load = busiest_cfs_rq->h_load;
 		unsigned long busiest_weight = busiest_cfs_rq->load.weight;
-		long rem_load, moved_load;
+		u64 rem_load, moved_load;
 
 		/*
 		 * empty group
@@ -1526,8 +1526,8 @@ load_balance_fair(struct rq *this_rq, in
 		if (!busiest_cfs_rq->task_weight)
 			continue;
 
-		rem_load = rem_load_move * busiest_weight;
-		rem_load /= busiest_h_load + 1;
+		rem_load = (u64)rem_load_move * busiest_weight;
+		rem_load = div_u64(rem_load, busiest_h_load + 1);
 
 		moved_load = __load_balance_fair(this_rq, this_cpu, busiest,
 				rem_load, sd, idle, all_pinned, this_best_prio,
@@ -1537,7 +1537,7 @@ load_balance_fair(struct rq *this_rq, in
 			continue;
 
 		moved_load *= busiest_h_load;
-		moved_load /= busiest_weight + 1;
+		moved_load = div_u64(moved_load, busiest_weight + 1);
 
 		rem_load_move -= moved_load;
 		if (rem_load_move < 0)

-- 

