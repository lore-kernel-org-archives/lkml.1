Return-Path: <linux-kernel-owner+w=401wt.eu-S1753430AbZJXBFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430AbZJXBFv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 21:05:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753188AbZJXBFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 21:05:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:49433 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753369AbZJXBFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 21:05:05 -0400
Date: Sat, 24 Oct 2009 01:04:17 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:branch?] sched: Strengthen buddies and mitigate buddy induced latencies
Message-ID: <tip-f685ceacab07d3f6c236f04803e2f2f0dbcc5afb@git.kernel.org>
Git-Commit-ID: f685ceacab07d3f6c236f04803e2f2f0dbcc5afb
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f685ceacab07d3f6c236f04803e2f2f0dbcc5afb
Gitweb:     http://git.kernel.org/tip/f685ceacab07d3f6c236f04803e2f2f0dbcc5afb
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Fri, 23 Oct 2009 23:09:22 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 23 Oct 2009 23:48:28 +0200

sched: Strengthen buddies and mitigate buddy induced latencies

This patch restores the effectiveness of LAST_BUDDY in preventing
pgsql+oltp from collapsing due to wakeup preemption. It also
switches LAST_BUDDY to exclusively do what it does best, namely
mitigate the effects of aggressive wakeup preemption, which
improves vmark throughput markedly, and restores mysql+oltp
scalability.

Since buddies are about scalability, enable them beginning at the
point where we begin expanding sched_latency, namely
sched_nr_latency. Previously, buddies were cleared aggressively,
which seriously reduced their effectiveness. Not clearing
aggressively however, produces a small drop in mysql+oltp
throughput immediately after peak, indicating that LAST_BUDDY is
actually doing some harm. This is right at the point where X on the
desktop in competition with another load wants low latency service.
Ergo, do not enable until we need to scale.

To mitigate latency induced by buddies, or by a task just missing
wakeup preemption, check latency at tick time.

Last hunk prevents buddies from stymieing BALANCE_NEWIDLE via
CACHE_HOT_BUDDY.

Supporting performance tests:

 tip   = v2.6.32-rc5-1497-ga525b32
 tipx  = NO_GENTLE_FAIR_SLEEPERS NEXT_BUDDY granularity knobs = 31 knobs + 31 buddies
 tip+x = NO_GENTLE_FAIR_SLEEPERS granularity knobs = 31 knobs

(Three run averages except where noted.)

 vmark:
 ------
 tip           108466 messages per second
 tip+          125307 messages per second
 tip+x         125335 messages per second
 tipx          117781 messages per second
 2.6.31.3      122729 messages per second

 mysql+oltp:
 -----------
 clients          1        2        4        8       16       32       64        128    256
 ..........................................................................................
 tip        9949.89 18690.20 34801.24 34460.04 32682.88 30765.97 28305.27 25059.64 19548.08
 tip+      10013.90 18526.84 34900.38 34420.14 33069.83 32083.40 30578.30 28010.71 25605.47
 tipx       9698.71 18002.70 34477.56 33420.01 32634.30 31657.27 29932.67 26827.52 21487.18
 2.6.31.3   8243.11 18784.20 34404.83 33148.38 31900.32 31161.90 29663.81 25995.94 18058.86

 pgsql+oltp:
 -----------
 clients          1        2        4        8       16       32       64      128      256
 ..........................................................................................
 tip       13686.37 26609.25 51934.28 51347.81 49479.51 45312.65 36691.91 26851.57 24145.35
 tip+ (1x) 13907.85 27135.87 52951.98 52514.04 51742.52 50705.43 49947.97 48374.19 46227.94
 tip+x     13906.78 27065.81 52951.19 52542.59 52176.11 51815.94 50838.90 49439.46 46891.00
 tipx      13742.46 26769.81 52351.99 51891.73 51320.79 50938.98 50248.65 48908.70 46553.84
 2.6.31.3  13815.35 26906.46 52683.34 52061.31 51937.10 51376.80 50474.28 49394.47 47003.25

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c      |    2 +-
 kernel/sched_fair.c |   73 ++++++++++++++++++++++++++++++++------------------
 2 files changed, 48 insertions(+), 27 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 789001d..cae6700 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2008,7 +2008,7 @@ task_hot(struct task_struct *p, u64 now, struct sched_domain *sd)
 	/*
 	 * Buddy candidates are cache hot:
 	 */
-	if (sched_feat(CACHE_HOT_BUDDY) &&
+	if (sched_feat(CACHE_HOT_BUDDY) && this_rq()->nr_running &&
 			(&p->se == cfs_rq_of(&p->se)->next ||
 			 &p->se == cfs_rq_of(&p->se)->last))
 		return 1;
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index c32c3e6..37087a7 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -822,6 +822,26 @@ check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
 		 * re-elected due to buddy favours.
 		 */
 		clear_buddies(cfs_rq, curr);
+		return;
+	}
+
+	/*
+	 * Ensure that a task that missed wakeup preemption by a
+	 * narrow margin doesn't have to wait for a full slice.
+	 * This also mitigates buddy induced latencies under load.
+	 */
+	if (!sched_feat(WAKEUP_PREEMPT))
+		return;
+
+	if (delta_exec < sysctl_sched_min_granularity)
+		return;
+
+	if (cfs_rq->nr_running > 1) {
+		struct sched_entity *se = __pick_next_entity(cfs_rq);
+		s64 delta = curr->vruntime - se->vruntime;
+
+		if (delta > ideal_runtime)
+			resched_task(rq_of(cfs_rq)->curr);
 	}
 }
 
@@ -861,21 +881,18 @@ wakeup_preempt_entity(struct sched_entity *curr, struct sched_entity *se);
 static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq)
 {
 	struct sched_entity *se = __pick_next_entity(cfs_rq);
-	struct sched_entity *buddy;
+	struct sched_entity *left = se;
 
-	if (cfs_rq->next) {
-		buddy = cfs_rq->next;
-		cfs_rq->next = NULL;
-		if (wakeup_preempt_entity(buddy, se) < 1)
-			return buddy;
-	}
+	if (cfs_rq->next && wakeup_preempt_entity(cfs_rq->next, left) < 1)
+		se = cfs_rq->next;
 
-	if (cfs_rq->last) {
-		buddy = cfs_rq->last;
-		cfs_rq->last = NULL;
-		if (wakeup_preempt_entity(buddy, se) < 1)
-			return buddy;
-	}
+	/*
+	 * Prefer last buddy, try to return the CPU to a preempted task.
+	 */
+	if (cfs_rq->last && wakeup_preempt_entity(cfs_rq->last, left) < 1)
+		se = cfs_rq->last;
+
+	clear_buddies(cfs_rq, se);
 
 	return se;
 }
@@ -1577,6 +1594,7 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 	struct sched_entity *se = &curr->se, *pse = &p->se;
 	struct cfs_rq *cfs_rq = task_cfs_rq(curr);
 	int sync = wake_flags & WF_SYNC;
+	int scale = cfs_rq->nr_running >= sched_nr_latency;
 
 	update_curr(cfs_rq);
 
@@ -1591,18 +1609,7 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 	if (unlikely(se == pse))
 		return;
 
-	/*
-	 * Only set the backward buddy when the current task is still on the
-	 * rq. This can happen when a wakeup gets interleaved with schedule on
-	 * the ->pre_schedule() or idle_balance() point, either of which can
-	 * drop the rq lock.
-	 *
-	 * Also, during early boot the idle thread is in the fair class, for
-	 * obvious reasons its a bad idea to schedule back to the idle thread.
-	 */
-	if (sched_feat(LAST_BUDDY) && likely(se->on_rq && curr != rq->idle))
-		set_last_buddy(se);
-	if (sched_feat(NEXT_BUDDY) && !(wake_flags & WF_FORK))
+	if (sched_feat(NEXT_BUDDY) && scale && !(wake_flags & WF_FORK))
 		set_next_buddy(pse);
 
 	/*
@@ -1648,8 +1655,22 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 
 	BUG_ON(!pse);
 
-	if (wakeup_preempt_entity(se, pse) == 1)
+	if (wakeup_preempt_entity(se, pse) == 1) {
 		resched_task(curr);
+		/*
+		 * Only set the backward buddy when the current task is still
+		 * on the rq. This can happen when a wakeup gets interleaved
+		 * with schedule on the ->pre_schedule() or idle_balance()
+		 * point, either of which can * drop the rq lock.
+		 *
+		 * Also, during early boot the idle thread is in the fair class,
+		 * for obvious reasons its a bad idea to schedule back to it.
+		 */
+		if (unlikely(!se->on_rq || curr == rq->idle))
+			return;
+		if (sched_feat(LAST_BUDDY) && scale && entity_is_task(se))
+			set_last_buddy(se);
+	}
 }
 
 static struct task_struct *pick_next_task_fair(struct rq *rq)
