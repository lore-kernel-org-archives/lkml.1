Return-Path: <linux-kernel-owner+w=401wt.eu-S1762678AbYF0Ubf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762678AbYF0Ubf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 16:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761463AbYF0UaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 16:30:07 -0400
Received: from lsg.lsg.lab.novell.com ([151.155.230.1]:8166 "EHLO
	lsg.lsg.lab.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609AbYF0UaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 16:30:01 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 3/3] sched: add avg-overlap support to RT tasks
To: mingo@elte.hu, peterz@infradead.org
Cc: npiggin@suse.de, ghaskins@novell.com, rostedt@goodmis.org,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Date: Fri, 27 Jun 2008 14:30:00 -0600
Message-ID: <20080627203000.3829.47406.stgit@lsg.lsg.lab.novell.com>
In-Reply-To: <20080627202444.3829.21595.stgit@lsg.lsg.lab.novell.com>
References: <20080627202444.3829.21595.stgit@lsg.lsg.lab.novell.com>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have the notion of tracking process-coupling (a.k.a. buddy-wake) via
the p->se.last_wake / p->se.avg_overlap facilities, but it is only used
for cfs to cfs interactions.  There is no reason why an rt to cfs
interaction cannot share in establishing a relationhip in a similar
manner.

Because PREEMPT_RT runs many kernel threads as FIFO priority, we often
times have heavy interaction between RT threads waking CFS applications.
This patch offers a substantial boost (50-60%+) in perfomance under those
circumstances.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/sched.c      |   14 ++++++++++++++
 kernel/sched_fair.c |   21 ++-------------------
 2 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 0b9f90e..af9a68b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1544,6 +1544,12 @@ static void set_load_weight(struct task_struct *p)
 	p->se.load.inv_weight = prio_to_wmult[p->static_prio - MAX_RT_PRIO];
 }
 
+static void update_avg(u64 *avg, u64 sample)
+{
+	s64 diff = sample - *avg;
+	*avg += diff >> 3;
+}
+
 static void enqueue_task(struct rq *rq, struct task_struct *p, int wakeup)
 {
 	sched_info_queued(p);
@@ -1553,6 +1559,12 @@ static void enqueue_task(struct rq *rq, struct task_struct *p, int wakeup)
 
 static void dequeue_task(struct rq *rq, struct task_struct *p, int sleep)
 {
+	if (sleep && p->se.last_wakeup) {
+		update_avg(&p->se.avg_overlap,
+			   p->se.sum_exec_runtime - p->se.last_wakeup);
+		p->se.last_wakeup = 0;
+	}
+
 	p->sched_class->dequeue_task(rq, p, sleep);
 	p->se.on_rq = 0;
 }
@@ -2157,6 +2169,8 @@ out_running:
 		p->sched_class->task_wake_up(rq, p);
 #endif
 out:
+	current->se.last_wakeup = current->se.sum_exec_runtime;
+
 	task_rq_unlock(rq, &flags);
 
 	return success;
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 8e77d67..3c06027 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -639,21 +639,6 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int wakeup)
 		__enqueue_entity(cfs_rq, se);
 }
 
-static void update_avg(u64 *avg, u64 sample)
-{
-	s64 diff = sample - *avg;
-	*avg += diff >> 3;
-}
-
-static void update_avg_stats(struct cfs_rq *cfs_rq, struct sched_entity *se)
-{
-	if (!se->last_wakeup)
-		return;
-
-	update_avg(&se->avg_overlap, se->sum_exec_runtime - se->last_wakeup);
-	se->last_wakeup = 0;
-}
-
 static void
 dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int sleep)
 {
@@ -664,7 +649,6 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int sleep)
 
 	update_stats_dequeue(cfs_rq, se);
 	if (sleep) {
-		update_avg_stats(cfs_rq, se);
 #ifdef CONFIG_SCHEDSTATS
 		if (entity_is_task(se)) {
 			struct task_struct *tsk = task_of(se);
@@ -1016,9 +1000,9 @@ wake_affine(struct rq *rq, struct sched_domain *this_sd, struct rq *this_rq,
 	 * a reasonable amount of time then attract this newly
 	 * woken task:
 	 */
-	if (sync && balanced && curr->sched_class == &fair_sched_class) {
+	if (sync && balanced) {
 		if (curr->se.avg_overlap < sysctl_sched_migration_cost &&
-				p->se.avg_overlap < sysctl_sched_migration_cost)
+		    p->se.avg_overlap < sysctl_sched_migration_cost)
 			return 1;
 	}
 
@@ -1177,7 +1161,6 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p)
 		return;
 	}
 
-	se->last_wakeup = se->sum_exec_runtime;
 	if (unlikely(se == pse))
 		return;
 

