Return-Path: <linux-kernel-owner+w=401wt.eu-S1754274AbZLIJzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274AbZLIJzP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 04:55:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754369AbZLIJzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 04:55:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:45162 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754318AbZLIJzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 04:55:05 -0500
Date: Wed, 9 Dec 2009 09:54:51 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Clean up check_preempt_wakeup()
Message-ID: <tip-3a7e73a2e26fffdbc46ba95fc0425418984f5140@git.kernel.org>
Git-Commit-ID: 3a7e73a2e26fffdbc46ba95fc0425418984f5140
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3a7e73a2e26fffdbc46ba95fc0425418984f5140
Gitweb:     http://git.kernel.org/tip/3a7e73a2e26fffdbc46ba95fc0425418984f5140
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Sat, 28 Nov 2009 18:51:02 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 9 Dec 2009 10:03:07 +0100

sched: Clean up check_preempt_wakeup()

Streamline the wakeup preemption code a bit, unifying the preempt path
so that they all do the same.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |   73 +++++++++++++++++++++++----------------------------
 1 files changed, 33 insertions(+), 40 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 4dec185..76b5792 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1651,10 +1651,8 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 	int sync = wake_flags & WF_SYNC;
 	int scale = cfs_rq->nr_running >= sched_nr_latency;
 
-	if (unlikely(rt_prio(p->prio))) {
-		resched_task(curr);
-		return;
-	}
+	if (unlikely(rt_prio(p->prio)))
+		goto preempt;
 
 	if (unlikely(p->sched_class != &fair_sched_class))
 		return;
@@ -1680,52 +1678,47 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 		return;
 
 	/* Idle tasks are by definition preempted by everybody. */
-	if (unlikely(curr->policy == SCHED_IDLE)) {
-		resched_task(curr);
-		return;
-	}
+	if (unlikely(curr->policy == SCHED_IDLE))
+		goto preempt;
 
-	if ((sched_feat(WAKEUP_SYNC) && sync) ||
-	    (sched_feat(WAKEUP_OVERLAP) &&
-	     (se->avg_overlap < sysctl_sched_migration_cost &&
-	      pse->avg_overlap < sysctl_sched_migration_cost))) {
-		resched_task(curr);
-		return;
-	}
+	if (sched_feat(WAKEUP_SYNC) && sync)
+		goto preempt;
 
-	if (sched_feat(WAKEUP_RUNNING)) {
-		if (pse->avg_running < se->avg_running) {
-			set_next_buddy(pse);
-			resched_task(curr);
-			return;
-		}
-	}
+	if (sched_feat(WAKEUP_OVERLAP) &&
+			se->avg_overlap < sysctl_sched_migration_cost &&
+			pse->avg_overlap < sysctl_sched_migration_cost)
+		goto preempt;
+
+	if (sched_feat(WAKEUP_RUNNING) && pse->avg_running < se->avg_running)
+		goto preempt;
 
 	if (!sched_feat(WAKEUP_PREEMPT))
 		return;
 
+	update_curr(cfs_rq);
 	find_matching_se(&se, &pse);
-
 	BUG_ON(!pse);
+	if (wakeup_preempt_entity(se, pse) == 1)
+		goto preempt;
 
-	update_curr(cfs_rq);
+	return;
 
-	if (wakeup_preempt_entity(se, pse) == 1) {
-		resched_task(curr);
-		/*
-		 * Only set the backward buddy when the current task is still
-		 * on the rq. This can happen when a wakeup gets interleaved
-		 * with schedule on the ->pre_schedule() or idle_balance()
-		 * point, either of which can * drop the rq lock.
-		 *
-		 * Also, during early boot the idle thread is in the fair class,
-		 * for obvious reasons its a bad idea to schedule back to it.
-		 */
-		if (unlikely(!se->on_rq || curr == rq->idle))
-			return;
-		if (sched_feat(LAST_BUDDY) && scale && entity_is_task(se))
-			set_last_buddy(se);
-	}
+preempt:
+	resched_task(curr);
+	/*
+	 * Only set the backward buddy when the current task is still
+	 * on the rq. This can happen when a wakeup gets interleaved
+	 * with schedule on the ->pre_schedule() or idle_balance()
+	 * point, either of which can * drop the rq lock.
+	 *
+	 * Also, during early boot the idle thread is in the fair class,
+	 * for obvious reasons its a bad idea to schedule back to it.
+	 */
+	if (unlikely(!se->on_rq || curr == rq->idle))
+		return;
+
+	if (sched_feat(LAST_BUDDY) && scale && entity_is_task(se))
+		set_last_buddy(se);
 }
 
 static struct task_struct *pick_next_task_fair(struct rq *rq)
