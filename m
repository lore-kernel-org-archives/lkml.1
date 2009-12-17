Return-Path: <linux-kernel-owner+w=401wt.eu-S1753081AbZLQTAD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081AbZLQTAD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 14:00:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965010AbZLQS7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 13:59:25 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:59046 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934792AbZLQS7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 13:59:23 -0500
Message-Id: <20091217185430.582101797@chello.nl>
References: <20091217185021.684424629@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 17 Dec 2009 19:50:26 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 5/6] sched: Remove from fwd decls
Content-Disposition: inline; filename=sched-lb-5.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move code around to get rid of fwd declarations.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched_fair.c |  127 ++++++++++++++++++++++++----------------------------
 1 file changed, 60 insertions(+), 67 deletions(-)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -1814,73 +1814,6 @@ static void put_prev_task_fair(struct rq
  * Fair scheduling class load-balancing methods:
  */
 
-static unsigned long
-balance_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
-		unsigned long max_load_move, struct sched_domain *sd,
-		enum cpu_idle_type idle, int *all_pinned,
-		int *this_best_prio, struct cfs_rq *busiest_cfs_rq);
-
-
-#ifdef CONFIG_FAIR_GROUP_SCHED
-static unsigned long
-load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
-		  unsigned long max_load_move,
-		  struct sched_domain *sd, enum cpu_idle_type idle,
-		  int *all_pinned, int *this_best_prio)
-{
-	long rem_load_move = max_load_move;
-	int busiest_cpu = cpu_of(busiest);
-	struct task_group *tg;
-
-	rcu_read_lock();
-	update_h_load(busiest_cpu);
-
-	list_for_each_entry_rcu(tg, &task_groups, list) {
-		struct cfs_rq *busiest_cfs_rq = tg->cfs_rq[busiest_cpu];
-		unsigned long busiest_h_load = busiest_cfs_rq->h_load;
-		unsigned long busiest_weight = busiest_cfs_rq->load.weight;
-		u64 rem_load, moved_load;
-
-		/*
-		 * empty group
-		 */
-		if (!busiest_cfs_rq->task_weight)
-			continue;
-
-		rem_load = (u64)rem_load_move * busiest_weight;
-		rem_load = div_u64(rem_load, busiest_h_load + 1);
-
-		moved_load = balance_tasks(this_rq, this_cpu, busiest,
-				rem_load, sd, idle, all_pinned, this_best_prio,
-				busiest_cfs_rq);
-
-		if (!moved_load)
-			continue;
-
-		moved_load *= busiest_h_load;
-		moved_load = div_u64(moved_load, busiest_weight + 1);
-
-		rem_load_move -= moved_load;
-		if (rem_load_move < 0)
-			break;
-	}
-	rcu_read_unlock();
-
-	return max_load_move - rem_load_move;
-}
-#else
-static unsigned long
-load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
-		  unsigned long max_load_move,
-		  struct sched_domain *sd, enum cpu_idle_type idle,
-		  int *all_pinned, int *this_best_prio)
-{
-	return balance_tasks(this_rq, this_cpu, busiest,
-			max_load_move, sd, idle, all_pinned,
-			this_best_prio, &busiest->cfs);
-}
-#endif
-
 /*
  * pull_task - move a task from a remote runqueue to the local runqueue.
  * Both runqueues must be locked.
@@ -2042,6 +1975,66 @@ out:
 	return max_load_move - rem_load_move;
 }
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
+static unsigned long
+load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
+		  unsigned long max_load_move,
+		  struct sched_domain *sd, enum cpu_idle_type idle,
+		  int *all_pinned, int *this_best_prio)
+{
+	long rem_load_move = max_load_move;
+	int busiest_cpu = cpu_of(busiest);
+	struct task_group *tg;
+
+	rcu_read_lock();
+	update_h_load(busiest_cpu);
+
+	list_for_each_entry_rcu(tg, &task_groups, list) {
+		struct cfs_rq *busiest_cfs_rq = tg->cfs_rq[busiest_cpu];
+		unsigned long busiest_h_load = busiest_cfs_rq->h_load;
+		unsigned long busiest_weight = busiest_cfs_rq->load.weight;
+		u64 rem_load, moved_load;
+
+		/*
+		 * empty group
+		 */
+		if (!busiest_cfs_rq->task_weight)
+			continue;
+
+		rem_load = (u64)rem_load_move * busiest_weight;
+		rem_load = div_u64(rem_load, busiest_h_load + 1);
+
+		moved_load = balance_tasks(this_rq, this_cpu, busiest,
+				rem_load, sd, idle, all_pinned, this_best_prio,
+				busiest_cfs_rq);
+
+		if (!moved_load)
+			continue;
+
+		moved_load *= busiest_h_load;
+		moved_load = div_u64(moved_load, busiest_weight + 1);
+
+		rem_load_move -= moved_load;
+		if (rem_load_move < 0)
+			break;
+	}
+	rcu_read_unlock();
+
+	return max_load_move - rem_load_move;
+}
+#else
+static unsigned long
+load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
+		  unsigned long max_load_move,
+		  struct sched_domain *sd, enum cpu_idle_type idle,
+		  int *all_pinned, int *this_best_prio)
+{
+	return balance_tasks(this_rq, this_cpu, busiest,
+			max_load_move, sd, idle, all_pinned,
+			this_best_prio, &busiest->cfs);
+}
+#endif
+
 /*
  * move_tasks tries to move up to max_load_move weighted load from busiest to
  * this_rq, as part of a balancing operation within domain "sd".

-- 

