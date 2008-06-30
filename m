Return-Path: <linux-kernel-owner+w=401wt.eu-S1758161AbYF3G3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161AbYF3G3q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 02:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755758AbYF3G3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 02:29:21 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63941 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753362AbYF3G3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 02:29:18 -0400
Message-ID: <48687CDB.5070702@cn.fujitsu.com>
Date: Mon, 30 Jun 2008 14:27:39 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] sched: fix unfairness when upgrade weight
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When two or more process upgrade their priority,
unfairness will happen, several of them may get all cpu-usage,
and the other cannot be scheduled to run for a long time.

example:
# (create 2 processes and set affinity to cpu#0)
# renice 19 pid1 pid2
# renice -19 pid1 pid2

step3 upgrade the 2 processes' weight, these 2 processes should
share the cpu#0 as soon as possible after step3, and any of them
should get 50% cpu-usage. But sometimes one of them gets all cpu-usage
for tens of seconds before they share the cpu#0.

fair-group example:
# mkdir 1 2 (create 2 fair-groups)
# (create 2 processes and set affinity to cpu#0)
# echo pid1 > 1/tasks ; echo pid2 > 2/tasks
# echo 2 > 1/cpu.shares ; echo 2 > 2/cpu.shares
# echo $((2**18)) > 1/cpu.shares ; echo $((2**18)) > 2/cpu.shares

The reason why such unfairness happened:

When a sched_entity is running, if its weight is low, its vruntime
increases by a large value every time and if its weight
is high, its vruntime increases by a small value.

So when the two sched_entity's weight is low, they will still 
fairness even if difference of their vruntime is large, but if
their weight are upgraded, this large difference of vruntime
will bring unfairness.

example:
se1's vruntime         se2's vruntime
    1000M               (R) 1020M
	(assume vruntime is increases by about 50M every time)
(R) 1050M                   1020M 
    1050M               (R) 1070M
(R) 1100M                   1070M
    1100M               (R) 1120M 
	(fairness, even if difference of their vruntime is large)
	(upgrade their weight, vruntime is increases by about 10K)
(R) 1100M+10K               1120M
(R) 1100M+20K               1120M
(R) 1100M+30K               1120M
(R) 1100M+40K               1120M
(R) 1100M+50K               1120M
	(se1 gets all cpu-usage for long time (mybe about tens
of seconds))
	(unfairness, difference=20M is too large for new weight)

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/sched.c b/kernel/sched.c
index 3aaa5c8..9c4b8cd 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4598,6 +4598,9 @@ void set_user_nice(struct task_struct *p, long nice)
 	delta = p->prio - old_prio;
 
 	if (on_rq) {
+		if (delta < 0 && p->sched_class == &fair_sched_class)
+			upgrade_weight(task_cfs_rq(p), &p->se);
+
 		enqueue_task(rq, p, 0);
 		inc_load(rq, p);
 		/*
@@ -8282,6 +8285,7 @@ static void set_se_shares(struct sched_entity *se, unsigned long shares)
 	struct cfs_rq *cfs_rq = se->cfs_rq;
 	struct rq *rq = cfs_rq->rq;
 	int on_rq;
+	unsigned long old_weight = se->load.weight;
 
 	spin_lock_irq(&rq->lock);
 
@@ -8292,8 +8296,12 @@ static void set_se_shares(struct sched_entity *se, unsigned long shares)
 	se->load.weight = shares;
 	se->load.inv_weight = 0;
 
-	if (on_rq)
+	if (on_rq) {
+		if (old_weight < shares)
+			upgrade_weight(cfs_rq, se);
+
 		enqueue_entity(cfs_rq, se, 0);
+	}
 
 	spin_unlock_irq(&rq->lock);
 }
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 08ae848..f3b2af4 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -587,6 +587,33 @@ static void check_spread(struct cfs_rq *cfs_rq, struct sched_entity *se)
 #endif
 }
 
+static void upgrade_weight(struct cfs_rq *cfs_rq, struct sched_entity *se)
+{
+	unsigned long delta_exec_per_tick = TICK_NSEC;
+	u64 vruntime = cfs_rq->min_vruntime;
+
+	/*
+	 * The new vruntime should be:
+	 *	pre_vruntime + calc_delta_fair(pre_delta_exec, &se->load)
+	 * but we do not have any field to memorize this 2 value. So we assume
+	 * that this sched_entity has just been enqueued and the last
+	 * delta_exec is slice in one tick.
+	 */
+
+	if (cfs_rq->curr) {
+		vruntime = min_vruntime(vruntime,
+				cfs_rq->curr->vruntime);
+	}
+
+	if (first_fair(cfs_rq)) {
+		vruntime = min_vruntime(vruntime,
+				__pick_next_entity(cfs_rq)->vruntime);
+	}
+
+	vruntime += calc_delta_fair(delta_exec_per_tick, &se->load);
+	se->vruntime = min_vruntime(vruntime, se->vruntime);
+}
+
 static void
 place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 {


