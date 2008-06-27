Return-Path: <linux-kernel-owner+w=401wt.eu-S1761091AbYF0MIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761091AbYF0MIx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 08:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755249AbYF0L63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 07:58:29 -0400
Received: from viefep26-int.chello.at ([62.179.121.46]:5013 "EHLO
	viefep26-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757095AbYF0L6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 07:58:16 -0400
X-SourceIP: 62.163.52.83
Message-Id: <20080627115212.049923385@chello.nl>
References: <20080627114109.724249622@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 13:41:31 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 22/30] sched: remove prio preference from balance decisions
Content-Disposition: inline; filename=sched-skip_for_load2.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Priority looses much of its meaning in a hierarchical context. So don't
use it in balance decisions.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2884,7 +2884,7 @@ balance_tasks(struct rq *this_rq, int th
 	      enum cpu_idle_type idle, int *all_pinned,
 	      int *this_best_prio, struct rq_iterator *iterator)
 {
-	int loops = 0, pulled = 0, pinned = 0, skip_for_load;
+	int loops = 0, pulled = 0, pinned = 0;
 	struct task_struct *p;
 	long rem_load_move = max_load_move;
 
@@ -2900,14 +2900,8 @@ balance_tasks(struct rq *this_rq, int th
 next:
 	if (!p || loops++ > sysctl_sched_nr_migrate)
 		goto out;
-	/*
-	 * To help distribute high priority tasks across CPUs we don't
-	 * skip a task if it will be the highest priority task (i.e. smallest
-	 * prio value) on its new queue regardless of its load weight
-	 */
-	skip_for_load = (p->se.load.weight >> 1) > rem_load_move +
-							 SCHED_LOAD_SCALE_FUZZ;
-	if ((skip_for_load && p->prio >= *this_best_prio) ||
+
+	if ((p->se.load.weight >> 1) > rem_load_move ||
 	    !can_migrate_task(p, busiest, this_cpu, sd, idle, &pinned)) {
 		p = iterator->next(iterator->arg);
 		goto next;

-- 

