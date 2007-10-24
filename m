Return-Path: <linux-kernel-owner+w=401wt.eu-S1759608AbXJXOJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759608AbXJXOJY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 10:09:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759016AbXJXOHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 10:07:48 -0400
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:49109
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757410AbXJXOHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 10:07:45 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 6/9] RT: Maintain the highest RQ priority
To: linux-rt-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Gregory Haskins <ghaskins@novell.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Darren Hart <dvhltc@us.ibm.com>
Date: Wed, 24 Oct 2007 09:53:04 -0400
Message-ID: <20071024135304.7960.70606.stgit@novell1.haskins.net>
In-Reply-To: <20071024134431.7960.41984.stgit@novell1.haskins.net>
References: <20071024134431.7960.41984.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an implementation of Steve's idea where we should update the RQ
concept of priority to show the highest-task, even if that task is not (yet)
running.  This prevents us from pushing multiple tasks to the RQ before it
gets a chance to reschedule.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/sched.c |   43 ++++++++++++++++++++++++++++++++++---------
 1 files changed, 34 insertions(+), 9 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index ce5292f..9e5cc2c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -304,7 +304,7 @@ struct rq {
 #ifdef CONFIG_PREEMPT_RT
 	unsigned long rt_nr_running;
 	unsigned long rt_nr_uninterruptible;
-	int curr_prio;
+	int highest_prio;
 #endif
 
 	unsigned long switch_timestamp;
@@ -368,11 +368,29 @@ static DEFINE_MUTEX(sched_hotcpu_mutex);
 #if defined(CONFIG_PREEMPT_RT) && defined(CONFIG_SMP)
 static inline void set_rq_prio(struct rq *rq, int prio)
 {
-	rq->curr_prio = prio;
+	rq->highest_prio = prio;
+}
+
+/*
+ * We dont care what the exact normal priority is.  We only care about
+ * RT-priority, vs non-RT (normal or idle).  So flatten the priority if its a
+ * non-RT variety. This will reduce cache-thrashing on the rq->highest_prio.
+ */
+static inline void update_rq_prio(struct rq *rq)
+{
+	struct rt_prio_array *array = &rq->rt.active;
+	int                   prio  = sched_find_first_bit(array->bitmap);
+
+	if ((prio != MAX_PRIO) && (prio > MAX_RT_PRIO))
+		prio = MAX_RT_PRIO;
+
+	if (rq->highest_prio != prio)
+		set_rq_prio(rq, prio);
 }
 
 #else
 #define set_rq_prio(rq, prio) do { } while(0)
+#define update_rq_prio(rq)    do { } while(0)
 #endif
 
 static inline void check_preempt_curr(struct rq *rq, struct task_struct *p)
@@ -1023,12 +1041,14 @@ static void enqueue_task(struct rq *rq, struct task_struct *p, int wakeup)
 	sched_info_queued(p);
 	p->sched_class->enqueue_task(rq, p, wakeup);
 	p->se.on_rq = 1;
+	update_rq_prio(rq);
 }
 
 static void dequeue_task(struct rq *rq, struct task_struct *p, int sleep)
 {
 	p->sched_class->dequeue_task(rq, p, sleep);
 	p->se.on_rq = 0;
+	update_rq_prio(rq);
 }
 
 /*
@@ -1527,14 +1547,14 @@ static struct rq *find_lock_lowest_rq(struct task_struct *task,
 				continue;
 
 			/* We look for lowest RT prio or non-rt CPU */
-			if (rq->curr_prio >= MAX_RT_PRIO) {
+			if (rq->highest_prio >= MAX_RT_PRIO) {
 				lowest_rq = rq;
 				break;
 			}
 
 			/* no locking for now */
-			if (rq->curr_prio > task->prio &&
-			    (!lowest_rq || rq->curr_prio < lowest_rq->curr_prio)) {
+			if (rq->highest_prio > task->prio &&
+			    (!lowest_rq || rq->highest_prio < lowest_rq->highest_prio)) {
 				lowest_rq = rq;
 			}
 		}
@@ -1560,7 +1580,7 @@ static struct rq *find_lock_lowest_rq(struct task_struct *task,
 		}
 
 		/* If this rq is still suitable use it. */
-		if (lowest_rq->curr_prio > task->prio)
+		if (lowest_rq->highest_prio > task->prio)
 			break;
 
 		/* try again */
@@ -2336,10 +2356,8 @@ static inline void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	 */
 	prev_state = prev->state;
 	_finish_arch_switch(prev);
-
-	set_rq_prio(rq, current->prio);
-
 	finish_lock_switch(rq, prev);
+
 #if defined(CONFIG_PREEMPT_RT) && defined(CONFIG_SMP)
 	/*
 	 * If we pushed an RT task off the runqueue,
@@ -4654,6 +4672,9 @@ void rt_mutex_setprio(struct task_struct *p, int prio)
 	prev_resched = _need_resched();
 
 	if (on_rq) {
+		/*
+		 * Note: RQ priority gets updated in the enqueue/dequeue logic
+		 */
 		enqueue_task(rq, p, 0);
 		/*
 		 * Reschedule if we are currently running on this runqueue and
@@ -4720,6 +4741,10 @@ void set_user_nice(struct task_struct *p, long nice)
 		 */
 		if (delta < 0 || (delta > 0 && task_running(rq, p)))
 			resched_task(rq->curr);
+
+		/*
+		 * Note: RQ priority gets updated in the enqueue/dequeue logic
+		 */
 	}
 out_unlock:
 	task_rq_unlock(rq, &flags);

