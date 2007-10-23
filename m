Return-Path: <linux-kernel-owner+w=401wt.eu-S1753188AbXJWRGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188AbXJWRGK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 13:06:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754478AbXJWRFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 13:05:11 -0400
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:35032
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754447AbXJWRFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 13:05:09 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 02/13] RT: Condense the next-task search into one function
To: linux-rt-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Gregory Haskins <ghaskins@novell.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Darren Hart <dvhltc@us.ibm.com>
Date: Tue, 23 Oct 2007 12:50:34 -0400
Message-ID: <20071023165034.5536.502.stgit@novell1.haskins.net>
In-Reply-To: <20071023164156.5536.95573.stgit@novell1.haskins.net>
References: <20071023164156.5536.95573.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We inadvertently added a redundant function, so clean it up

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/sched.c    |    9 +++++----
 kernel/sched_rt.c |   44 --------------------------------------------
 2 files changed, 5 insertions(+), 48 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 0dabf89..daeb8ed 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1471,9 +1471,10 @@ next_in_queue:
 	 * Return the highest-prio non-running RT task (if task
 	 * may run on this CPU):
 	 */
-	if (!task_running(src_rq, tmp) &&
-				cpu_isset(this_cpu, tmp->cpus_allowed))
-		return tmp;
+	if (!task_running(src_rq, tmp)) {
+		if ((this_cpu == -1) || cpu_isset(this_cpu, tmp->cpus_allowed))
+			return tmp;
+	}
 
 	curr = curr->next;
 	if (curr != head)
@@ -1569,7 +1570,7 @@ static int push_rt_task(struct rq *this_rq)
 
 	assert_spin_locked(&this_rq->lock);
 
-	next_task = rt_next_highest_task(this_rq);
+	next_task = pick_rt_task(this_rq, -1);
 	if (!next_task)
 		return 0;
 
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 8d59e62..369827b 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -96,50 +96,6 @@ static struct task_struct *pick_next_task_rt(struct rq *rq)
 	return next;
 }
 
-#ifdef CONFIG_PREEMPT_RT
-static struct task_struct *rt_next_highest_task(struct rq *rq)
-{
-	struct rt_prio_array *array = &rq->rt.active;
-	struct task_struct *next;
-	struct list_head *queue;
-	int idx;
-
-	if (likely (rq->rt_nr_running < 2))
-		return NULL;
-
-	idx = sched_find_first_bit(array->bitmap);
-	if (idx >= MAX_RT_PRIO) {
-		WARN_ON(1); /* rt_nr_running is bad */
-		return NULL;
-	}
-
-	queue = array->queue + idx;
-	next = list_entry(queue->next, struct task_struct, run_list);
-	if (unlikely(next != current))
-		return next;
-
-	if (queue->next->next != queue) {
-		/* same prio task */
-		next = list_entry(queue->next->next, struct task_struct, run_list);
-		goto out;
-	}
-
-	/* slower, but more flexible */
-	idx = find_next_bit(array->bitmap, MAX_RT_PRIO, idx+1);
-	if (idx >= MAX_RT_PRIO) {
-		WARN_ON(1); /* rt_nr_running was 2 and above! */
-		return NULL;
-	}
-
-	queue = array->queue + idx;
-	next = list_entry(queue->next, struct task_struct, run_list);
-
- out:
-	return next;
-
-}
-#endif /* CONFIG_PREEMPT_RT */
-
 static void put_prev_task_rt(struct rq *rq, struct task_struct *p)
 {
 	update_curr_rt(rq);

