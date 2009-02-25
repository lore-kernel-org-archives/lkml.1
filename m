Return-Path: <linux-kernel-owner+w=401wt.eu-S1760805AbZBYHf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760805AbZBYHf1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 02:35:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757912AbZBYHfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 02:35:17 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61249 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757597AbZBYHfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 02:35:15 -0500
Message-ID: <49A4F401.30503@cn.fujitsu.com>
Date: Wed, 25 Feb 2009 15:32:17 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] sched: fix unfairness when upgrade weight
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When two or more processes upgrade their priority,
unfairness will happen, part of them may get all cpu-usage,
and the others cannot be scheduled to run for a long time.

example:
 # (create 2 processes and set affinity to cpu#0)
 # renice 19 pid1 pid2
 # renice -19 pid1 pid2

step3 upgrade the 2 processes' weight, these 2 processes should
share the cpu#0 as soon as possible after step3, and each of them
should get 50% cpu-usage. But sometimes one of them gets all cpu-usage
for tens of seconds before the other is schedulered to run.

fair-group example:
 # mkdir 1 2 (create 2 fair-groups)
 # (create 2 processes and set affinity to cpu#0)
 # echo pid1 > 1/tasks ; echo pid2 > 2/tasks
 # echo 2 > 1/cpu.shares ; echo 2 > 2/cpu.shares
 # echo $((2**18)) > 1/cpu.shares ; echo $((2**18)) > 2/cpu.shares

The reason why such unfairness happened:

When a sched_entity is running, if its weight is low, its vruntime
increases by a large value every time and if its weight is high,
its vruntime increases by a small value.

So when the two sched_entity's weight is low, they will still
fairness even if difference of their vruntime is large, but if
their weight are upgraded, this large difference of vruntime
will bring unfairness. Because it will cost the process to spend
a lot of time to catch up the huge difference.

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
    (se1 gets all cpu-usage for long time (mybe about tens of seconds))
    (unfairness, difference=20M is too large for new weight)

This patch fixes this bug by tuning the vruntime of weight-upgraded
sched entities, just like waking up a task. the new vruntime will be
    cfs_rq->min_vruntime + sched_vslice();

Reported-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>

---
 kernel/sched.c      |   16 +++++++++-------
 kernel/sched_fair.c |    9 +++++++++
 2 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 410eec4..26e6d33 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5096,12 +5096,8 @@ void set_user_nice(struct task_struct *p, long nice)
 
 	if (on_rq) {
 		enqueue_task(rq, p, 0);
-		/*
-		 * If the task increased its priority or is running and
-		 * lowered its priority, then reschedule its CPU:
-		 */
-		if (delta < 0 || (delta > 0 && task_running(rq, p)))
-			resched_task(rq->curr);
+		p->sched_class->prio_changed(rq, p, old_prio,
+						task_running(rq, p));
 	}
 out_unlock:
 	task_rq_unlock(rq, &flags);
@@ -8929,16 +8925,22 @@ static void __set_se_shares(struct sched_entity *se, unsigned long shares)
 {
 	struct cfs_rq *cfs_rq = se->cfs_rq;
 	int on_rq;
+	unsigned long old_weight;
 
 	on_rq = se->on_rq;
 	if (on_rq)
 		dequeue_entity(cfs_rq, se, 0);
 
+	old_weight = se->load.weight;
 	se->load.weight = shares;
 	se->load.inv_weight = 0;
 
-	if (on_rq)
+	if (on_rq) {
+		if (se->load.weight > old_weight)
+			se->vruntime = cfs_rq->min_vruntime
+						+ sched_vslice(cfs_rq, se);
 		enqueue_entity(cfs_rq, se, 0);
+	}
 }
 
 static void set_se_shares(struct sched_entity *se, unsigned long shares)
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 0566f2a..34d4d11 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1690,6 +1690,15 @@ static void task_new_fair(struct rq *rq, struct task_struct *p)
 static void prio_changed_fair(struct rq *rq, struct task_struct *p,
 			      int oldprio, int running)
 {
+	struct cfs_rq *cfs_rq = task_cfs_rq(p);
+	struct sched_entity *se = &p->se;
+	int on_rq = se->on_rq;
+
+	if (p->prio < oldprio && on_rq) {
+		dequeue_entity(cfs_rq, se, 0);
+		se->vruntime = cfs_rq->min_vruntime + sched_vslice(cfs_rq, se);
+		enqueue_entity(cfs_rq, se, 0);
+	}
 	/*
 	 * Reschedule if we are currently running on this runqueue and
 	 * our priority decreased, or if we are not currently running on
-- 
1.6.0.3


