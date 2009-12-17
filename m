Return-Path: <linux-kernel-owner+w=401wt.eu-S934652AbZLQTAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934652AbZLQTAp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 14:00:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751075AbZLQTAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 14:00:36 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:59018 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755213AbZLQS7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 13:59:07 -0500
Message-Id: <20091217185430.424905819@chello.nl>
References: <20091217185021.684424629@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 17 Dec 2009 19:50:24 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 3/6] sched: Remove rq_iterator usage from load_balance_fair
Content-Disposition: inline; filename=sched-lb-3.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we only ever iterate the fair class, do away with this
abstraction.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched_fair.c |   80 ++++++++++++++++++----------------------------------
 1 file changed, 29 insertions(+), 51 deletions(-)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -1866,26 +1866,9 @@ static unsigned long
 balance_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		unsigned long max_load_move, struct sched_domain *sd,
 		enum cpu_idle_type idle, int *all_pinned,
-		int *this_best_prio, struct rq_iterator *iterator);
+		int *this_best_prio, struct cfs_rq *busiest_cfs_rq);
 
 
-static unsigned long
-__load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
-		unsigned long max_load_move, struct sched_domain *sd,
-		enum cpu_idle_type idle, int *all_pinned, int *this_best_prio,
-		struct cfs_rq *cfs_rq)
-{
-	struct rq_iterator cfs_rq_iterator;
-
-	cfs_rq_iterator.start = load_balance_start_fair;
-	cfs_rq_iterator.next = load_balance_next_fair;
-	cfs_rq_iterator.arg = cfs_rq;
-
-	return balance_tasks(this_rq, this_cpu, busiest,
-			max_load_move, sd, idle, all_pinned,
-			this_best_prio, &cfs_rq_iterator);
-}
-
 #ifdef CONFIG_FAIR_GROUP_SCHED
 static unsigned long
 load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
@@ -1915,9 +1898,9 @@ load_balance_fair(struct rq *this_rq, in
 		rem_load = (u64)rem_load_move * busiest_weight;
 		rem_load = div_u64(rem_load, busiest_h_load + 1);
 
-		moved_load = __load_balance_fair(this_rq, this_cpu, busiest,
+		moved_load = balance_tasks(this_rq, this_cpu, busiest,
 				rem_load, sd, idle, all_pinned, this_best_prio,
-				tg->cfs_rq[busiest_cpu]);
+				busiest_cfs_rq);
 
 		if (!moved_load)
 			continue;
@@ -1940,7 +1923,7 @@ load_balance_fair(struct rq *this_rq, in
 		  struct sched_domain *sd, enum cpu_idle_type idle,
 		  int *all_pinned, int *this_best_prio)
 {
-	return __load_balance_fair(this_rq, this_cpu, busiest,
+	return balance_tasks(this_rq, this_cpu, busiest,
 			max_load_move, sd, idle, all_pinned,
 			this_best_prio, &busiest->cfs);
 }
@@ -2050,53 +2033,48 @@ static unsigned long
 balance_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
 	      unsigned long max_load_move, struct sched_domain *sd,
 	      enum cpu_idle_type idle, int *all_pinned,
-	      int *this_best_prio, struct rq_iterator *iterator)
+	      int *this_best_prio, struct cfs_rq *busiest_cfs_rq)
 {
 	int loops = 0, pulled = 0, pinned = 0;
-	struct task_struct *p;
 	long rem_load_move = max_load_move;
+	struct task_struct *p, *n;
 
 	if (max_load_move == 0)
 		goto out;
 
 	pinned = 1;
 
-	/*
-	 * Start the load-balancing iterator:
-	 */
-	p = iterator->start(iterator->arg);
-next:
-	if (!p || loops++ > sysctl_sched_nr_migrate)
-		goto out;
+	list_for_each_entry_safe(p, n, &busiest_cfs_rq->tasks, se.group_node) {
+		if (loops++ > sysctl_sched_nr_migrate)
+			break;
 
-	if ((p->se.load.weight >> 1) > rem_load_move ||
-	    !can_migrate_task(p, busiest, this_cpu, sd, idle, &pinned)) {
-		p = iterator->next(iterator->arg);
-		goto next;
-	}
+		if ((p->se.load.weight >> 1) > rem_load_move ||
+		    !can_migrate_task(p, busiest, this_cpu, sd, idle, &pinned))
+			continue;
 
-	pull_task(busiest, p, this_rq, this_cpu);
-	pulled++;
-	rem_load_move -= p->se.load.weight;
+		pull_task(busiest, p, this_rq, this_cpu);
+		pulled++;
+		rem_load_move -= p->se.load.weight;
 
 #ifdef CONFIG_PREEMPT
-	/*
-	 * NEWIDLE balancing is a source of latency, so preemptible kernels
-	 * will stop after the first task is pulled to minimize the critical
-	 * section.
-	 */
-	if (idle == CPU_NEWLY_IDLE)
-		goto out;
+		/*
+		 * NEWIDLE balancing is a source of latency, so preemptible
+		 * kernels will stop after the first task is pulled to minimize
+		 * the critical section.
+		 */
+		if (idle == CPU_NEWLY_IDLE)
+			break;
 #endif
 
-	/*
-	 * We only want to steal up to the prescribed amount of weighted load.
-	 */
-	if (rem_load_move > 0) {
+		/*
+		 * We only want to steal up to the prescribed amount of
+		 * weighted load.
+		 */
+		if (rem_load_move <= 0)
+			break;
+
 		if (p->prio < *this_best_prio)
 			*this_best_prio = p->prio;
-		p = iterator->next(iterator->arg);
-		goto next;
 	}
 out:
 	/*

-- 

