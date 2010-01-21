Return-Path: <linux-kernel-owner+w=401wt.eu-S1754167Ab0AUNxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167Ab0AUNxP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 08:53:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752689Ab0AUNxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 08:53:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:46283 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753412Ab0AUNxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 08:53:08 -0500
Date: Thu, 21 Jan 2010 13:52:39 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Remove rq_iterator usage from load_balance_fair
Message-ID: <tip-ee00e66ffff250fb0d3a789e5565462f71c7c9a7@git.kernel.org>
Git-Commit-ID: ee00e66ffff250fb0d3a789e5565462f71c7c9a7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Jan 2010 13:52:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ee00e66ffff250fb0d3a789e5565462f71c7c9a7
Gitweb:     http://git.kernel.org/tip/ee00e66ffff250fb0d3a789e5565462f71c7c9a7
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 17 Dec 2009 17:25:20 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 21 Jan 2010 13:40:10 +0100

sched: Remove rq_iterator usage from load_balance_fair

Since we only ever iterate the fair class, do away with this abstraction.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |   80 ++++++++++++++++++--------------------------------
 1 files changed, 29 insertions(+), 51 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index faf9a2f..709deb3 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
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
@@ -1915,9 +1898,9 @@ load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		rem_load = (u64)rem_load_move * busiest_weight;
 		rem_load = div_u64(rem_load, busiest_h_load + 1);
 
-		moved_load = __load_balance_fair(this_rq, this_cpu, busiest,
+		moved_load = balance_tasks(this_rq, this_cpu, busiest,
 				rem_load, sd, idle, all_pinned, this_best_prio,
-				tg->cfs_rq[busiest_cpu]);
+				busiest_cfs_rq);
 
 		if (!moved_load)
 			continue;
@@ -1940,7 +1923,7 @@ load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
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
