Return-Path: <linux-kernel-owner+w=401wt.eu-S1755176AbYDUQVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176AbYDUQVQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 12:21:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756956AbYDUQU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 12:20:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42347 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754155AbYDUQU4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 12:20:56 -0400
Date: Mon, 21 Apr 2008 18:20:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gregory Haskins <ghaskins@novell.com>
Cc: suresh.b.siddha@intel.com, rostedt@goodmis.org, chinang.ma@intel.com,
       arjan@linux.intel.com, willy@linux.intel.com,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH v2] sched: push rt tasks only if newly activated tasks
	have been added
Message-ID: <20080421162032.GA12645@elte.hu>
References: <20080421153438.9212.79406.stgit@novell1.haskins.net> <20080421161744.GB10121@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080421161744.GB10121@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


got a build failure:

 In file included from kernel/sched.c:1972:
 kernel/sched_rt.c: In function 'enqueue_task_rt':
 kernel/sched_rt.c:522: error: 'struct rt_rq' has no member named 'pushed'

with this config:

 http://redhat.com/~mingo/misc/config-Mon_Apr_21_18_02_45_CEST_2008.bad

with the patch below against sched-devel/latest.

	Ingo

----------->
Subject: sched: push rt tasks only if newly activated tasks have been added
From: Gregory Haskins <ghaskins@novell.com>
Date: Mon, 21 Apr 2008 11:42:18 -0400

SCHED_RR can context-switch many times without having changed the
run-queue. Therefore trying to push on each context switch can just be
wasted effort since if it failed the first time, it will likely fail any
subsequent times as well.  Instead, set a flag when we have successfully
pushed as many tasks away as possible, and only clear it when the
runqueue adds new tasks (effectively becoming a run-queue "dirty bit").
If new tasks are added we should try again.  If any remote run-queues
downgrade their priority in the meantime, they will try to pull from us
(as they always do).

This attempts to address a performance regression reported by Suresh
Siddha, et. al. in the 2.6.25 series.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
CC: suresh.b.siddha@intel.com
CC: mingo@elte.hu
CC: rostedt@goodmis.org
CC: chinang.ma@intel.com
CC: arjan@linux.intel.com
CC: willy@linux.intel.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c    |    2 ++
 kernel/sched_rt.c |   22 ++++++++++++++++++++--
 2 files changed, 22 insertions(+), 2 deletions(-)

Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -462,6 +462,7 @@ struct rt_rq {
 #ifdef CONFIG_SMP
 	unsigned long rt_nr_migratory;
 	int overloaded;
+	int pushed;
 #endif
 	int rt_throttled;
 	u64 rt_time;
@@ -8073,6 +8074,7 @@ static void init_rt_rq(struct rt_rq *rt_
 #ifdef CONFIG_SMP
 	rt_rq->rt_nr_migratory = 0;
 	rt_rq->overloaded = 0;
+	rt_rq->pushed = 0;
 #endif
 
 	rt_rq->rt_time = 0;
Index: linux/kernel/sched_rt.c
===================================================================
--- linux.orig/kernel/sched_rt.c
+++ linux/kernel/sched_rt.c
@@ -514,6 +514,13 @@ static void enqueue_task_rt(struct rq *r
 	for_each_sched_rt_entity(rt_se)
 		enqueue_rt_entity(rt_se);
 
+	/*
+	 * Clear the "pushed" state since we have changed the run-queue and
+	 * may need to migrate some of these tasks (see push_rt_tasks() for
+	 * details)
+	 */
+	rq->rt.pushed = 0;
+
 	inc_cpu_load(rq, p->se.load.weight);
 }
 
@@ -913,7 +920,7 @@ static int push_rt_task(struct rq *rq)
 	int ret = 0;
 	int paranoid = RT_MAX_TRIES;
 
-	if (!rq->rt.overloaded)
+	if (!rq->rt.overloaded || rq->rt.pushed)
 		return 0;
 
 	next_task = pick_next_highest_task_rt(rq, -1);
@@ -973,6 +980,15 @@ out:
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
@@ -987,6 +1003,8 @@ static void push_rt_tasks(struct rq *rq)
 	/* push_rt_task will return true if it moved an RT */
 	while (push_rt_task(rq))
 		;
+
+	rq->rt.pushed = 1;
 }
 
 static int pull_rt_task(struct rq *this_rq)
@@ -1091,7 +1109,7 @@ static void post_schedule_rt(struct rq *
 	 * the lock was owned by prev, we need to release it
 	 * first via finish_lock_switch and then reaquire it here.
 	 */
-	if (unlikely(rq->rt.overloaded)) {
+	if (unlikely(rq->rt.overloaded && !rq->rt.pushed)) {
 		spin_lock_irq(&rq->lock);
 		push_rt_tasks(rq);
 		spin_unlock_irq(&rq->lock);
