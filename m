Return-Path: <linux-kernel-owner+w=401wt.eu-S1755755AbXISU10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755AbXISU10 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 16:27:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751024AbXISU1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 16:27:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54079 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbXISU1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 16:27:17 -0400
Date: Wed, 19 Sep 2007 22:26:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chuck Ebbert <cebbert@redhat.com>, Antoine Martin <antoine@nagafix.co.uk>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: CFS: some bad numbers with Java/database threading [FIXED]
Message-ID: <20070919202632.GA30474@elte.hu>
References: <20070914083246.GA20514@elte.hu> <a781481a0709140306k3faf3585haae26853fe81381c@mail.gmail.com> <46EAA7E4.8020700@nagafix.co.uk> <20070914153216.GA27213@elte.hu> <46F00417.7080301@redhat.com> <20070918224656.GA26719@elte.hu> <46F058EE.1080408@redhat.com> <20070919191837.GA19500@elte.hu> <alpine.LFD.0.999.0709191230230.16478@woody.linux-foundation.org> <20070919195633.GA23595@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070919195633.GA23595@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> ok, we can do that.
> 
> the O(1) implementation of yield() was pretty arbitrary: it did not 
> move it last on the same priority level - it only did it within the 
> active array. So expired tasks (such as CPU hogs) would come _after_ a 
> yield()-ing task.
> 
> so the yield() implementation was so much tied to the data structures 
> of the O(1) scheduler that it was impossible to fully emulate it in 
> CFS.
> 
> in CFS we dont have a per-nice-level rbtree, so we cannot move it dead 
> last within the same priority group - but we can move it dead last in 
> the whole tree. (then they'd be put even after nice +19 tasks.) People 
> might complain about _that_.
> 
> another practical problem is that this will break certain desktop apps 
> that do calls to yield() [some firefox plugins do that, some 3D apps 
> do that, etc.] but they dont expect to be moved 'very late' into the 
> queue - they expect the O(1) scheduler's behavior of being delayed "a 
> bit". (That's why i added the yield-granularity tunable.)
> 
> we can make yield super-agressive, that is pretty much the only sane 
> (because well-defined) thing to do (besides turning yield into a NOP), 
> but there will be lots of regression reports about lost interactivity 
> during load. sched_yield() is a mortally broken API. "fix the app" 
> would be the answer, but still there will be lots of complaints.

find below the fix that puts yielding tasks to the rightmost position in 
the rbtree. I have not tested it extensively yet, but it appears to work 
on x86. (i tested yield using interactive tasks and they get hurt now 
under load - but this would be expected.)

	Ingo

---------------------->
Subject: sched: make yield more agressive
From: Ingo Molnar <mingo@elte.hu>

make sys_sched_yield() more agressive, by moving the yielding task
to the last position in the rbtree.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c      |    5 +----
 kernel/sched_fair.c |   39 ++++++++++++++++++++++++++++++++++-----
 2 files changed, 35 insertions(+), 9 deletions(-)

Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -4550,10 +4550,7 @@ asmlinkage long sys_sched_yield(void)
 	struct rq *rq = this_rq_lock();
 
 	schedstat_inc(rq, yld_cnt);
-	if (unlikely(rq->nr_running == 1))
-		schedstat_inc(rq, yld_act_empty);
-	else
-		current->sched_class->yield_task(rq, current);
+	current->sched_class->yield_task(rq, current);
 
 	/*
 	 * Since we are going to call schedule() anyway, there's
Index: linux/kernel/sched_fair.c
===================================================================
--- linux.orig/kernel/sched_fair.c
+++ linux/kernel/sched_fair.c
@@ -902,14 +902,43 @@ static void dequeue_task_fair(struct rq 
 static void yield_task_fair(struct rq *rq, struct task_struct *p)
 {
 	struct cfs_rq *cfs_rq = task_cfs_rq(p);
+	struct rb_node **link = &cfs_rq->tasks_timeline.rb_node;
+	struct sched_entity *rightmost, *se = &p->se;
+	struct rb_node *parent;
 
-	__update_rq_clock(rq);
 	/*
-	 * Dequeue and enqueue the task to update its
-	 * position within the tree:
+	 * Are we the only task in the tree?
 	 */
-	dequeue_entity(cfs_rq, &p->se, 0);
-	enqueue_entity(cfs_rq, &p->se, 0);
+	if (unlikely(cfs_rq->nr_running == 1))
+		return;
+	/*
+	 * Find the rightmost entry in the rbtree:
+	 */
+	do {
+		parent = *link;
+		link = &parent->rb_right;
+	} while (*link);
+
+	rightmost = rb_entry(parent, struct sched_entity, run_node);
+	/*
+	 * Already in the rightmost position?
+	 */
+	if (unlikely(rightmost == se))
+		return;
+
+	/*
+	 * Minimally necessary key value to be last in the tree:
+	 */
+	se->fair_key = rightmost->fair_key + 1;
+
+	if (cfs_rq->rb_leftmost == &se->run_node)
+		cfs_rq->rb_leftmost = rb_next(&se->run_node);
+	/*
+	 * Relink the task to the rightmost position:
+	 */
+	rb_erase(&se->run_node, &cfs_rq->tasks_timeline);
+	rb_link_node(&se->run_node, parent, link);
+	rb_insert_color(&se->run_node, &cfs_rq->tasks_timeline);
 }
 
 /*

