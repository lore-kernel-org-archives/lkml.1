Return-Path: <linux-kernel-owner+w=401wt.eu-S1754379Ab0ATU77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab0ATU77 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 15:59:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754230Ab0ATU7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 15:59:50 -0500
Received: from www.tglx.de ([62.245.132.106]:43002 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754180Ab0ATU7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 15:59:48 -0500
Message-Id: <20100120171629.772169931@linutronix.de>
User-Agent: quilt/0.47-1
Date: Wed, 20 Jan 2010 20:59:01 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Carsten Emde <cbe@osadl.org>,
       Mathias Weber <mathias.weber.mw1@roche.com>
Subject: [patch 2/3] sched: Implement head queueing for sched_rt
References: <20100120171231.922420383@linutronix.de>
Content-Disposition: inline;
	filename=sched-implement-head-queueing-for-rt.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ability of enqueueing a task to the head of a SCHED_FIFO priority
list is required to fix some violations of POSIX scheduling policy.

Implement the functionality in sched_rt.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched_rt.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

Index: linux-2.6-tip/kernel/sched_rt.c
===================================================================
--- linux-2.6-tip.orig/kernel/sched_rt.c
+++ linux-2.6-tip/kernel/sched_rt.c
@@ -194,7 +194,7 @@ static inline struct rt_rq *group_rt_rq(
 	return rt_se->my_q;
 }
 
-static void enqueue_rt_entity(struct sched_rt_entity *rt_se);
+static void enqueue_rt_entity(struct sched_rt_entity *rt_se, bool head);
 static void dequeue_rt_entity(struct sched_rt_entity *rt_se);
 
 static void sched_rt_rq_enqueue(struct rt_rq *rt_rq)
@@ -204,7 +204,7 @@ static void sched_rt_rq_enqueue(struct r
 
 	if (rt_rq->rt_nr_running) {
 		if (rt_se && !on_rt_rq(rt_se))
-			enqueue_rt_entity(rt_se);
+			enqueue_rt_entity(rt_se, false);
 		if (rt_rq->highest_prio.curr < curr->prio)
 			resched_task(curr);
 	}
@@ -803,7 +803,7 @@ void dec_rt_tasks(struct sched_rt_entity
 	dec_rt_group(rt_se, rt_rq);
 }
 
-static void __enqueue_rt_entity(struct sched_rt_entity *rt_se)
+static void __enqueue_rt_entity(struct sched_rt_entity *rt_se, bool head)
 {
 	struct rt_rq *rt_rq = rt_rq_of_se(rt_se);
 	struct rt_prio_array *array = &rt_rq->active;
@@ -819,7 +819,10 @@ static void __enqueue_rt_entity(struct s
 	if (group_rq && (rt_rq_throttled(group_rq) || !group_rq->rt_nr_running))
 		return;
 
-	list_add_tail(&rt_se->run_list, queue);
+	if (head)
+		list_add(&rt_se->run_list, queue);
+	else
+		list_add_tail(&rt_se->run_list, queue);
 	__set_bit(rt_se_prio(rt_se), array->bitmap);
 
 	inc_rt_tasks(rt_se, rt_rq);
@@ -856,11 +859,11 @@ static void dequeue_rt_stack(struct sche
 	}
 }
 
-static void enqueue_rt_entity(struct sched_rt_entity *rt_se)
+static void enqueue_rt_entity(struct sched_rt_entity *rt_se, bool head)
 {
 	dequeue_rt_stack(rt_se);
 	for_each_sched_rt_entity(rt_se)
-		__enqueue_rt_entity(rt_se);
+		__enqueue_rt_entity(rt_se, head);
 }
 
 static void dequeue_rt_entity(struct sched_rt_entity *rt_se)
@@ -871,7 +874,7 @@ static void dequeue_rt_entity(struct sch
 		struct rt_rq *rt_rq = group_rt_rq(rt_se);
 
 		if (rt_rq && rt_rq->rt_nr_running)
-			__enqueue_rt_entity(rt_se);
+			__enqueue_rt_entity(rt_se, false);
 	}
 }
 
@@ -886,7 +889,7 @@ enqueue_task_rt(struct rq *rq, struct ta
 	if (wakeup)
 		rt_se->timeout = 0;
 
-	enqueue_rt_entity(rt_se);
+	enqueue_rt_entity(rt_se, head);
 
 	if (!task_current(rq, p) && p->rt.nr_cpus_allowed > 1)
 		enqueue_pushable_task(rq, p);


