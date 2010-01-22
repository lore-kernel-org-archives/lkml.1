Return-Path: <linux-kernel-owner+w=401wt.eu-S1755953Ab0AVRNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953Ab0AVRNt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 12:13:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755942Ab0AVRNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 12:13:47 -0500
Received: from hera.kernel.org ([140.211.167.34]:41414 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755941Ab0AVRNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 12:13:46 -0500
Date: Fri, 22 Jan 2010 17:12:49 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       peterz@infradead.org, mathias.weber.mw1@roche.com, cbe@osadl.org,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       peterz@infradead.org, cbe@osadl.org, mathias.weber.mw1@roche.com,
       tglx@linutronix.de
In-Reply-To: <20100120171629.772169931@linutronix.de>
References: <20100120171629.772169931@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Implement head queueing for sched_rt
Message-ID: <tip-37dad3fce97f01e5149d69de0833d8452c0e862e@git.kernel.org>
Git-Commit-ID: 37dad3fce97f01e5149d69de0833d8452c0e862e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 22 Jan 2010 17:12:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  37dad3fce97f01e5149d69de0833d8452c0e862e
Gitweb:     http://git.kernel.org/tip/37dad3fce97f01e5149d69de0833d8452c0e862e
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 20 Jan 2010 20:59:01 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 22 Jan 2010 18:09:59 +0100

sched: Implement head queueing for sched_rt

The ability of enqueueing a task to the head of a SCHED_FIFO priority
list is required to fix some violations of POSIX scheduling policy.

Implement the functionality in sched_rt.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Tested-by: Carsten Emde <cbe@osadl.org>
Tested-by: Mathias Weber <mathias.weber.mw1@roche.com>
LKML-Reference: <20100120171629.772169931@linutronix.de>
---
 kernel/sched_rt.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 38076da..ca49ceb 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -194,7 +194,7 @@ static inline struct rt_rq *group_rt_rq(struct sched_rt_entity *rt_se)
 	return rt_se->my_q;
 }
 
-static void enqueue_rt_entity(struct sched_rt_entity *rt_se);
+static void enqueue_rt_entity(struct sched_rt_entity *rt_se, bool head);
 static void dequeue_rt_entity(struct sched_rt_entity *rt_se);
 
 static void sched_rt_rq_enqueue(struct rt_rq *rt_rq)
@@ -204,7 +204,7 @@ static void sched_rt_rq_enqueue(struct rt_rq *rt_rq)
 
 	if (rt_rq->rt_nr_running) {
 		if (rt_se && !on_rt_rq(rt_se))
-			enqueue_rt_entity(rt_se);
+			enqueue_rt_entity(rt_se, false);
 		if (rt_rq->highest_prio.curr < curr->prio)
 			resched_task(curr);
 	}
@@ -803,7 +803,7 @@ void dec_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 	dec_rt_group(rt_se, rt_rq);
 }
 
-static void __enqueue_rt_entity(struct sched_rt_entity *rt_se)
+static void __enqueue_rt_entity(struct sched_rt_entity *rt_se, bool head)
 {
 	struct rt_rq *rt_rq = rt_rq_of_se(rt_se);
 	struct rt_prio_array *array = &rt_rq->active;
@@ -819,7 +819,10 @@ static void __enqueue_rt_entity(struct sched_rt_entity *rt_se)
 	if (group_rq && (rt_rq_throttled(group_rq) || !group_rq->rt_nr_running))
 		return;
 
-	list_add_tail(&rt_se->run_list, queue);
+	if (head)
+		list_add(&rt_se->run_list, queue);
+	else
+		list_add_tail(&rt_se->run_list, queue);
 	__set_bit(rt_se_prio(rt_se), array->bitmap);
 
 	inc_rt_tasks(rt_se, rt_rq);
@@ -856,11 +859,11 @@ static void dequeue_rt_stack(struct sched_rt_entity *rt_se)
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
@@ -871,7 +874,7 @@ static void dequeue_rt_entity(struct sched_rt_entity *rt_se)
 		struct rt_rq *rt_rq = group_rt_rq(rt_se);
 
 		if (rt_rq && rt_rq->rt_nr_running)
-			__enqueue_rt_entity(rt_se);
+			__enqueue_rt_entity(rt_se, false);
 	}
 }
 
@@ -886,7 +889,7 @@ enqueue_task_rt(struct rq *rq, struct task_struct *p, int wakeup, bool head)
 	if (wakeup)
 		rt_se->timeout = 0;
 
-	enqueue_rt_entity(rt_se);
+	enqueue_rt_entity(rt_se, head);
 
 	if (!task_current(rq, p) && p->rt.nr_cpus_allowed > 1)
 		enqueue_pushable_task(rq, p);
