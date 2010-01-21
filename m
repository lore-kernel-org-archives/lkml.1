Return-Path: <linux-kernel-owner+w=401wt.eu-S1754444Ab0AUNyC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444Ab0AUNyC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 08:54:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754226Ab0AUNxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 08:53:53 -0500
Received: from hera.kernel.org ([140.211.167.34]:46321 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754218Ab0AUNxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 08:53:51 -0500
Date: Thu, 21 Jan 2010 13:53:10 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Remove from fwd decls
Message-ID: <tip-230059de77a4e0f6afba98073e73bc9fd471506e@git.kernel.org>
Git-Commit-ID: 230059de77a4e0f6afba98073e73bc9fd471506e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Jan 2010 13:53:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  230059de77a4e0f6afba98073e73bc9fd471506e
Gitweb:     http://git.kernel.org/tip/230059de77a4e0f6afba98073e73bc9fd471506e
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 17 Dec 2009 17:47:12 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 21 Jan 2010 13:40:12 +0100

sched: Remove from fwd decls

Move code around to get rid of fwd declarations.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |  127 ++++++++++++++++++++++++---------------------------
 1 files changed, 60 insertions(+), 67 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index e48e459..93fccba 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1814,73 +1814,6 @@ static void put_prev_task_fair(struct rq *rq, struct task_struct *prev)
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
