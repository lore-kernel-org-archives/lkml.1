Return-Path: <linux-kernel-owner+w=401wt.eu-S1760739AbYDUQPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760739AbYDUQPb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 12:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754431AbYDUQPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 12:15:23 -0400
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:41374
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754328AbYDUQPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 12:15:21 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH v2] sched: push rt tasks only if newly activated tasks have
	been added
To: suresh.b.siddha@intel.com
Cc: mingo@elte.hu, rostedt@goodmis.org, chinang.ma@intel.com,
       arjan@linux.intel.com, willy@linux.intel.com, ghaskins@novell.com,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Date: Mon, 21 Apr 2008 11:42:18 -0400
Message-ID: <20080421153438.9212.79406.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo, et. al.,
 Steven asked me to comment more thoroughly for posterity, so here is v2.

Changes since v1:

1) Updated header to clarify regression as a perf. regression.
2) Added inline comments to explain nature of change more clearly.
3) Added a further optimization to post_schedule_rt() to avoid retaking the
   expensive rq-lock if we dont need to push.

Regards,
-Greg

----------------------------------------------
sched: push rt tasks only if newly activated tasks have been added

SCHED_RR can context-switch many times without having changed the run-queue.
Therefore trying to push on each context switch can just be wasted effort
since if it failed the first time, it will likely fail any subsequent times
as well.  Instead, set a flag when we have successfully pushed as many tasks
away as possible, and only clear it when the runqueue adds new tasks
(effectively becoming a run-queue "dirty bit").  If new tasks are added we
should try again.  If any remote run-queues downgrade their priority in the
meantime, they will try to pull from us (as they always do).

This attempts to address a performance regression reported by Suresh Siddha,
et. al. in the 2.6.25 series.  It applies to 2.6.25.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
CC: suresh.b.siddha@intel.com
CC: mingo@elte.hu
CC: rostedt@goodmis.org
CC: chinang.ma@intel.com
CC: arjan@linux.intel.com
CC: willy@linux.intel.com
---

 kernel/sched.c    |    2 ++
 kernel/sched_rt.c |   22 ++++++++++++++++++++--
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 8dcdec6..806881b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -331,6 +331,7 @@ struct rt_rq {
 #ifdef CONFIG_SMP
 	unsigned long rt_nr_migratory;
 	int overloaded;
+	int pushed;
 #endif
 	int rt_throttled;
 	u64 rt_time;
@@ -7142,6 +7143,7 @@ static void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq)
 #ifdef CONFIG_SMP
 	rt_rq->rt_nr_migratory = 0;
 	rt_rq->overloaded = 0;
+	rt_rq->pushed = 0;
 #endif
 
 	rt_rq->rt_time = 0;
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 0a6d2e5..5007723 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -393,6 +393,13 @@ static void enqueue_task_rt(struct rq *rq, struct task_struct *p, int wakeup)
 	 */
 	for_each_sched_rt_entity(rt_se)
 		enqueue_rt_entity(rt_se);
+
+	/*
+	 * Clear the "pushed" state since we have changed the run-queue and
+	 * may need to migrate some of these tasks (see push_rt_tasks() for
+	 * details)
+	 */
+	rq->rt.pushed = 0;
 }
 
 static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int sleep)
@@ -789,7 +796,7 @@ static int push_rt_task(struct rq *rq)
 	int ret = 0;
 	int paranoid = RT_MAX_TRIES;
 
-	if (!rq->rt.overloaded)
+	if (!rq->rt.overloaded || rq->rt.pushed)
 		return 0;
 
 	next_task = pick_next_highest_task_rt(rq, -1);
@@ -849,6 +856,15 @@ out:
 }
 
 /*
+ * push_rt_tasks()
+ *
+ * Push as many tasks away as possible.  We only need to try once whenever
+ * one or more new tasks are added to our runqueue.  After an inital attempt,
+ * further changes in remote runqueue state will be accounted for with pull
+ * operations.  Therefore, we mark the run-queue as "pushed" here, and clear it
+ * during enqueue.  This primarily helps SCHED_RR tasks which will tend to
+ * have a higher context-switch to enqueue ratio.
+ *
  * TODO: Currently we just use the second highest prio task on
  *       the queue, and stop when it can't migrate (or there's
  *       no more RT tasks).  There may be a case where a lower
@@ -863,6 +879,8 @@ static void push_rt_tasks(struct rq *rq)
 	/* push_rt_task will return true if it moved an RT */
 	while (push_rt_task(rq))
 		;
+
+	rq->rt.pushed = 1;
 }
 
 static int pull_rt_task(struct rq *this_rq)
@@ -967,7 +985,7 @@ static void post_schedule_rt(struct rq *rq)
 	 * the lock was owned by prev, we need to release it
 	 * first via finish_lock_switch and then reaquire it here.
 	 */
-	if (unlikely(rq->rt.overloaded)) {
+	if (unlikely(rq->rt.overloaded && !rq->rt.pushed)) {
 		spin_lock_irq(&rq->lock);
 		push_rt_tasks(rq);
 		spin_unlock_irq(&rq->lock);

