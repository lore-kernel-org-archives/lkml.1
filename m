Return-Path: <linux-kernel-owner+w=401wt.eu-S1758640AbYF0L77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758640AbYF0L77 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 07:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755274AbYF0L56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 07:57:58 -0400
Received: from viefep32-int.chello.at ([62.179.121.50]:48084 "EHLO
	viefep32-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754421AbYF0L5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 07:57:53 -0400
Message-Id: <20080627115211.705143382@chello.nl>
References: <20080627114109.724249622@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 13:41:24 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 15/30] sched: fix newidle smp group balancing
Content-Disposition: inline; filename=sched-fix-newidle.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Re-compute the shares on newidle - so we can make a decision based on
recent data.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -1579,6 +1579,13 @@ static void update_shares(struct sched_d
 	walk_tg_tree(tg_nop, tg_shares_up, 0, sd);
 }
 
+static void update_shares_locked(struct rq *rq, struct sched_domain *sd)
+{
+	spin_unlock(&rq->lock);
+	update_shares(sd);
+	spin_lock(&rq->lock);
+}
+
 static void update_h_load(int cpu)
 {
 	walk_tg_tree(tg_load_down, tg_nop, cpu, NULL);
@@ -1595,6 +1602,10 @@ static inline void update_shares(struct 
 {
 }
 
+static inline void update_shares_locked(struct rq *rq, struct sched_domain *sd)
+{
+}
+
 #endif
 
 #endif
@@ -3543,6 +3554,7 @@ load_balance_newidle(int this_cpu, struc
 
 	schedstat_inc(sd, lb_count[CPU_NEWLY_IDLE]);
 redo:
+	update_shares_locked(this_rq, sd);
 	group = find_busiest_group(sd, this_cpu, &imbalance, CPU_NEWLY_IDLE,
 				   &sd_idle, cpus, NULL);
 	if (!group) {
@@ -3586,6 +3598,7 @@ redo:
 	} else
 		sd->nr_balance_failed = 0;
 
+	update_shares_locked(this_rq, sd);
 	return ld_moved;
 
 out_balanced:

-- 

