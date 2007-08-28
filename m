Return-Path: <linux-kernel-owner+w=401wt.eu-S1756226AbXH1OqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbXH1OqW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 10:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbXH1OqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 10:46:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52355 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779AbXH1OqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 10:46:13 -0400
Date: Tue, 28 Aug 2007 16:46:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [git pull request] scheduler updates
Message-ID: <20070828144604.GA13875@elte.hu>
References: <20070828113259.GA7922@elte.hu> <1188310265.6336.5.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1188310265.6336.5.camel@Homer.simpson.net>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> On Tue, 2007-08-28 at 13:32 +0200, Ingo Molnar wrote:
> > Linus, please pull the latest scheduler git tree from:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git
> > 
> > no big changes - 5 small fixes and 1 small cleanup:
> 
> FWIW, I spent a few hours testing these patches with various loads, 
> and all was peachy here.  No multimedia or interactivity aberrations 
> noted.

great! Btw., there's another refinement Peter and me are working on (see 
the patch below): to place new tasks into the existing 'scheduling flow' 
in a more seemless way. In practice this should mean less firefox spikes 
during a kbuild workload. If you have some time to try it, could you add 
the patch below to your tree too, and see what happens during fork-happy 
workloads? It does not seem to be overly urgent to apply at the moment, 
but it is a nice touch i think.

	Ingo

------------------------>
Subject: sched: place new tasks in the middle of the task pool
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Place new tasks in the middle of the wait_runtime average. This smoothes 
out latency spikes caused by freshly started tasks, without being unfair 
to those tasks. Basically new tasks start right into the 'flow' of 
wait_runtime that exists in the system at that moment.

[ mingo@elte.hu: changed it to use cfs_rq->wait_runtime ]

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c      |    1 
 kernel/sched_fair.c |   59 +++++++++++++++++++++++++++++-----------------------
 2 files changed, 33 insertions(+), 27 deletions(-)

Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -858,7 +858,6 @@ static void dec_nr_running(struct task_s
 
 static void set_load_weight(struct task_struct *p)
 {
-	task_rq(p)->cfs.wait_runtime -= p->se.wait_runtime;
 	p->se.wait_runtime = 0;
 
 	if (task_has_rt_policy(p)) {
Index: linux/kernel/sched_fair.c
===================================================================
--- linux.orig/kernel/sched_fair.c
+++ linux/kernel/sched_fair.c
@@ -86,8 +86,8 @@ unsigned int sysctl_sched_features __rea
 		SCHED_FEAT_SLEEPER_AVG		*0 |
 		SCHED_FEAT_SLEEPER_LOAD_AVG	*1 |
 		SCHED_FEAT_PRECISE_CPU_LOAD	*1 |
-		SCHED_FEAT_START_DEBIT		*1 |
-		SCHED_FEAT_SKIP_INITIAL		*0;
+		SCHED_FEAT_START_DEBIT		*0 |
+		SCHED_FEAT_SKIP_INITIAL		*1;
 
 extern struct sched_class fair_sched_class;
 
@@ -194,6 +194,8 @@ __enqueue_entity(struct cfs_rq *cfs_rq, 
 	update_load_add(&cfs_rq->load, se->load.weight);
 	cfs_rq->nr_running++;
 	se->on_rq = 1;
+
+	cfs_rq->wait_runtime += se->wait_runtime;
 }
 
 static inline void
@@ -205,6 +207,8 @@ __dequeue_entity(struct cfs_rq *cfs_rq, 
 	update_load_sub(&cfs_rq->load, se->load.weight);
 	cfs_rq->nr_running--;
 	se->on_rq = 0;
+
+	cfs_rq->wait_runtime -= se->wait_runtime;
 }
 
 static inline struct rb_node *first_fair(struct cfs_rq *cfs_rq)
@@ -326,9 +330,9 @@ __add_wait_runtime(struct cfs_rq *cfs_rq
 static void
 add_wait_runtime(struct cfs_rq *cfs_rq, struct sched_entity *se, long delta)
 {
-	schedstat_add(cfs_rq, wait_runtime, -se->wait_runtime);
+	cfs_rq->wait_runtime -= se->wait_runtime;
 	__add_wait_runtime(cfs_rq, se, delta);
-	schedstat_add(cfs_rq, wait_runtime, se->wait_runtime);
+	cfs_rq->wait_runtime += se->wait_runtime;
 }
 
 /*
@@ -574,7 +578,6 @@ static void __enqueue_sleeper(struct cfs
 
 	prev_runtime = se->wait_runtime;
 	__add_wait_runtime(cfs_rq, se, delta_fair);
-	schedstat_add(cfs_rq, wait_runtime, se->wait_runtime);
 	delta_fair = se->wait_runtime - prev_runtime;
 
 	/*
@@ -662,7 +665,6 @@ dequeue_entity(struct cfs_rq *cfs_rq, st
 			if (tsk->state & TASK_UNINTERRUPTIBLE)
 				se->block_start = rq_of(cfs_rq)->clock;
 		}
-		cfs_rq->wait_runtime -= se->wait_runtime;
 #endif
 	}
 	__dequeue_entity(cfs_rq, se);
@@ -671,7 +673,7 @@ dequeue_entity(struct cfs_rq *cfs_rq, st
 /*
  * Preempt the current task with a newly woken task if needed:
  */
-static int
+static void
 __check_preempt_curr_fair(struct cfs_rq *cfs_rq, struct sched_entity *se,
 			  struct sched_entity *curr, unsigned long granularity)
 {
@@ -684,9 +686,8 @@ __check_preempt_curr_fair(struct cfs_rq 
 	 */
 	if (__delta > niced_granularity(curr, granularity)) {
 		resched_task(rq_of(cfs_rq)->curr);
-		return 1;
+		curr->prev_sum_exec_runtime = curr->sum_exec_runtime;
 	}
-	return 0;
 }
 
 static inline void
@@ -762,8 +763,7 @@ static void entity_tick(struct cfs_rq *c
 	if (delta_exec > ideal_runtime)
 		gran = 0;
 
-	if (__check_preempt_curr_fair(cfs_rq, next, curr, gran))
-		curr->prev_sum_exec_runtime = curr->sum_exec_runtime;
+	__check_preempt_curr_fair(cfs_rq, next, curr, gran);
 }
 
 /**************************************************
@@ -1087,6 +1087,8 @@ static void task_tick_fair(struct rq *rq
 	}
 }
 
+#define swap(a,b) do { __typeof__(a) tmp = (a); (a) = (b); (b)=tmp; } while (0)
+
 /*
  * Share the fairness runtime between parent and child, thus the
  * total amount of pressure for CPU stays equal - new tasks
@@ -1102,14 +1104,27 @@ static void task_new_fair(struct rq *rq,
 	sched_info_queued(p);
 
 	update_curr(cfs_rq);
-	update_stats_enqueue(cfs_rq, se);
+	if ((long)cfs_rq->wait_runtime < 0)
+		se->wait_runtime = (long)cfs_rq->wait_runtime /
+				(long)cfs_rq->nr_running;
 	/*
-	 * Child runs first: we let it run before the parent
-	 * until it reschedules once. We set up the key so that
-	 * it will preempt the parent:
+	 * The statistical average of wait_runtime is about
+	 * -granularity/2, so initialize the task with that:
 	 */
-	se->fair_key = curr->fair_key -
-		niced_granularity(curr, sched_granularity(cfs_rq)) - 1;
+	if (sysctl_sched_features & SCHED_FEAT_START_DEBIT) {
+		__add_wait_runtime(cfs_rq, se,
+			-niced_granularity(se, sched_granularity(cfs_rq))/2);
+	}
+
+	update_stats_enqueue(cfs_rq, se);
+
+	if (sysctl_sched_child_runs_first && (se->fair_key > curr->fair_key)) {
+		dequeue_entity(cfs_rq, curr, 0);
+		swap(se->wait_runtime, curr->wait_runtime);
+		update_stats_enqueue(cfs_rq, se);
+		enqueue_entity(cfs_rq, curr, 0);
+	}
+
 	/*
 	 * The first wait is dominated by the child-runs-first logic,
 	 * so do not credit it with that waiting time yet:
@@ -1117,16 +1132,8 @@ static void task_new_fair(struct rq *rq,
 	if (sysctl_sched_features & SCHED_FEAT_SKIP_INITIAL)
 		se->wait_start_fair = 0;
 
-	/*
-	 * The statistical average of wait_runtime is about
-	 * -granularity/2, so initialize the task with that:
-	 */
-	if (sysctl_sched_features & SCHED_FEAT_START_DEBIT) {
-		se->wait_runtime = -(sched_granularity(cfs_rq) / 2);
-		schedstat_add(cfs_rq, wait_runtime, se->wait_runtime);
-	}
-
 	__enqueue_entity(cfs_rq, se);
+	__check_preempt_curr_fair(cfs_rq, __pick_next_entity(cfs_rq), curr, 0);
 }
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
