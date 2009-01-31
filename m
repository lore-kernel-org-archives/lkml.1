Return-Path: <linux-kernel-owner+w=401wt.eu-S1754958AbZAaJIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958AbZAaJIq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 04:08:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751771AbZAaJI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 04:08:29 -0500
Received: from mail.gmx.net ([213.165.64.20]:32834 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751850AbZAaJIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 04:08:25 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/J18ALs/PJ46xSNhmFY+9Z1QE9RjpdxuCPZo47pi
	eyM3i2Jbgc83WL
Subject: Re: scheduler nice 19 versus 'idle' behavior / static low-priority
	scheduling
From: Mike Galbraith <efault@gmx.de>
To: Brian Rogers <brian@xyzw.org>
Cc: Nathanael Hoyle <nhoyle@hoyletech.com>,
       Jan Engelhardt <jengelh@medozas.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       stable <stable@kernel.org>
In-Reply-To: <1233380284.5636.5.camel@marge.simson.net>
References: <1233294584.28741.2.camel@localhost>
	 <alpine.LSU.2.00.0901300710200.999@fbirervta.pbzchgretzou.qr>
	 <1233297635.17301.11.camel@localhost>
	 <alpine.LSU.2.00.0901300818580.28427@fbirervta.pbzchgretzou.qr>
	 <1233302349.17301.27.camel@localhost>
	 <1233302861.6061.14.camel@marge.simson.net>  <49837B32.3010206@xyzw.org>
	 <1233380284.5636.5.camel@marge.simson.net>
Content-Type: text/plain
Date: Sat, 31 Jan 2009 10:08:13 +0100
Message-Id: <1233392893.5863.25.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-01-31 at 06:38 +0100, Mike Galbraith wrote:
> On Fri, 2009-01-30 at 14:12 -0800, Brian Rogers wrote:
> > Mike Galbraith wrote:
> > > On Fri, 2009-01-30 at 02:59 -0500, Nathanael Hoyle wrote:
> > >   
> > >> I am running foldingathome under it at the moment, and it seems to be
> > >> improving the situation somewhat, but I still need/want to test with
> > >> Mike's referenced patches.
> > >>     
> > > You will most definitely encounter evilness running SCHED_IDLE tasks in
> > > a kernel without the SCHED_IDLE fixes.
> > >   
> > Speaking of SCHED_IDLE fixes, is 
> > 6bc912b71b6f33b041cfde93ca3f019cbaa852bc going to be put into the next 
> > stable 2.6.28 release? Without it on 2.6.28.2, I can still produce 
> > minutes-long freezes with BOINC or other idle processes.
> > 
> > With the above commit on top of 2.6.28.2 and also 
> > cce7ade803699463ecc62a065ca522004f7ccb3d, the problem is solved, though 
> > I assume cce7ad isn't actually required to fix that, and I can test that 
> > if desired.
> 
> I think they both should go to stable, but dunno if they're headed that
> direction or not.
> 
> One way to find out, CCs added.

For those who may want to run SCHED_IDLE tasks in .27, I've integrated
and lightly tested the fixes required to do so.  One additional commit
was needed to get SCHED_IDLE vs nice 19 working right, namely f9c0b09.
Without that, SCHED_IDLE tasks received more CPU than nice 19 tasks.

Since .27 is in long-term maintenance, I'd integrate into stable, but
that's not my decision.  Anyone who applies the below to their stable
kernel gets to keep all the pieces should something break ;-)

commit f9c0b0950d5fd8c8c5af39bc061f27ea8fddcac3
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Fri Oct 17 19:27:04 2008 +0200

    sched: revert back to per-rq vruntime
    
    Vatsa rightly points out that having the runqueue weight in the vruntime
    calculations can cause unfairness in the face of task joins/leaves.
    
    Suppose: dv = dt * rw / w
    
    Then take 10 tasks t_n, each of similar weight. If the first will run 1
    then its vruntime will increase by 10. Now, if the next 8 tasks leave after
    having run their 1, then the last task will get a vruntime increase of 2
    after having run 1.
    
    Which will leave us with 2 tasks of equal weight and equal runtime, of which
    one will not be scheduled for 8/2=4 units of time.
    
    Ergo, we cannot do that and must use: dv = dt / w.
    
    This means we cannot have a global vruntime based on effective priority, but
    must instead go back to the vruntime per rq model we started out with.
    
    This patch was lightly tested by doing starting while loops on each nice level
    and observing their execution time, and a simple group scenario of 1:2:3 pinned
    to a single cpu.
    
    Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

---
 kernel/sched_fair.c |   32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

Index: linux-2.6.27/kernel/sched_fair.c
===================================================================
--- linux-2.6.27.orig/kernel/sched_fair.c
+++ linux-2.6.27/kernel/sched_fair.c
@@ -334,7 +334,7 @@ int sched_nr_latency_handler(struct ctl_
 #endif
 
 /*
- * delta *= w / rw
+ * delta *= P[w / rw]
  */
 static inline unsigned long
 calc_delta_weight(unsigned long delta, struct sched_entity *se)
@@ -348,15 +348,13 @@ calc_delta_weight(unsigned long delta, s
 }
 
 /*
- * delta *= rw / w
+ * delta /= w
  */
 static inline unsigned long
 calc_delta_fair(unsigned long delta, struct sched_entity *se)
 {
-	for_each_sched_entity(se) {
-		delta = calc_delta_mine(delta,
-				cfs_rq_of(se)->load.weight, &se->load);
-	}
+	if (unlikely(se->load.weight != NICE_0_LOAD))
+		delta = calc_delta_mine(delta, NICE_0_LOAD, &se->load);
 
 	return delta;
 }
@@ -386,26 +384,26 @@ static u64 __sched_period(unsigned long
  * We calculate the wall-time slice from the period by taking a part
  * proportional to the weight.
  *
- * s = p*w/rw
+ * s = p*P[w/rw]
  */
 static u64 sched_slice(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	return calc_delta_weight(__sched_period(cfs_rq->nr_running), se);
+	unsigned long nr_running = cfs_rq->nr_running;
+
+	if (unlikely(!se->on_rq))
+		nr_running++;
+
+	return calc_delta_weight(__sched_period(nr_running), se);
 }
 
 /*
  * We calculate the vruntime slice of a to be inserted task
  *
- * vs = s*rw/w = p
+ * vs = s/w
  */
-static u64 sched_vslice_add(struct cfs_rq *cfs_rq, struct sched_entity *se)
+static u64 sched_vslice(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	unsigned long nr_running = cfs_rq->nr_running;
-
-	if (!se->on_rq)
-		nr_running++;
-
-	return __sched_period(nr_running);
+	return calc_delta_fair(sched_slice(cfs_rq, se), se);
 }
 
 /*
@@ -683,7 +681,7 @@ place_entity(struct cfs_rq *cfs_rq, stru
 	 * stays open at the end.
 	 */
 	if (initial && sched_feat(START_DEBIT))
-		vruntime += sched_vslice_add(cfs_rq, se);
+		vruntime += sched_vslice(cfs_rq, se);
 
 	if (!initial) {
 		/* sleeps upto a single latency don't count. */
commit 1af5f730fc1bf7c62ec9fb2d307206e18bf40a69
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Fri Oct 24 11:06:13 2008 +0200

    sched: more accurate min_vruntime accounting
    
    Mike noticed the current min_vruntime tracking can go wrong and skip the
    current task. If the only remaining task in the tree is a nice 19 task
    with huge vruntime, new tasks will be inserted too far to the right too,
    causing some interactibity issues.
    
    min_vruntime can only change due to the leftmost entry disappearing
    (dequeue_entity()), or by the leftmost entry being incremented past the
    next entry, which elects a new leftmost (__update_curr())
    
    Due to the current entry not being part of the actual tree, we have to
    compare the leftmost tree entry with the current entry, and take the
    leftmost of these two.
    
    So create a update_min_vruntime() function that takes computes the
    leftmost vruntime in the system (either tree of current) and increases
    the cfs_rq->min_vruntime if the computed value is larger than the
    previously found min_vruntime. And call this from the two sites we've
    identified that can change min_vruntime.
    
    Reported-by: Mike Galbraith <efault@gmx.de>
    Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Acked-by: Mike Galbraith <efault@gmx.de>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

---
 kernel/sched_fair.c |   49 +++++++++++++++++++++++++------------------------
 1 file changed, 25 insertions(+), 24 deletions(-)

Index: linux-2.6.27/kernel/sched_fair.c
===================================================================
--- linux-2.6.27.orig/kernel/sched_fair.c
+++ linux-2.6.27/kernel/sched_fair.c
@@ -221,6 +221,27 @@ static inline s64 entity_key(struct cfs_
 	return se->vruntime - cfs_rq->min_vruntime;
 }
 
+static void update_min_vruntime(struct cfs_rq *cfs_rq)
+{
+	u64 vruntime = cfs_rq->min_vruntime;
+
+	if (cfs_rq->curr)
+		vruntime = cfs_rq->curr->vruntime;
+
+	if (cfs_rq->rb_leftmost) {
+		struct sched_entity *se = rb_entry(cfs_rq->rb_leftmost,
+						   struct sched_entity,
+						   run_node);
+
+		if (vruntime == cfs_rq->min_vruntime)
+			vruntime = se->vruntime;
+		else
+			vruntime = min_vruntime(vruntime, se->vruntime);
+	}
+
+	cfs_rq->min_vruntime = max_vruntime(cfs_rq->min_vruntime, vruntime);
+}
+
 /*
  * Enqueue an entity into the rb-tree:
  */
@@ -254,15 +275,8 @@ static void __enqueue_entity(struct cfs_
 	 * Maintain a cache of leftmost tree entries (it is frequently
 	 * used):
 	 */
-	if (leftmost) {
+	if (leftmost)
 		cfs_rq->rb_leftmost = &se->run_node;
-		/*
-		 * maintain cfs_rq->min_vruntime to be a monotonic increasing
-		 * value tracking the leftmost vruntime in the tree.
-		 */
-		cfs_rq->min_vruntime =
-			max_vruntime(cfs_rq->min_vruntime, se->vruntime);
-	}
 
 	rb_link_node(&se->run_node, parent, link);
 	rb_insert_color(&se->run_node, &cfs_rq->tasks_timeline);
@@ -272,18 +286,9 @@ static void __dequeue_entity(struct cfs_
 {
 	if (cfs_rq->rb_leftmost == &se->run_node) {
 		struct rb_node *next_node;
-		struct sched_entity *next;
 
 		next_node = rb_next(&se->run_node);
 		cfs_rq->rb_leftmost = next_node;
-
-		if (next_node) {
-			next = rb_entry(next_node,
-					struct sched_entity, run_node);
-			cfs_rq->min_vruntime =
-				max_vruntime(cfs_rq->min_vruntime,
-					     next->vruntime);
-		}
 	}
 
 	if (cfs_rq->next == se)
@@ -480,6 +485,7 @@ __update_curr(struct cfs_rq *cfs_rq, str
 	schedstat_add(cfs_rq, exec_clock, delta_exec);
 	delta_exec_weighted = calc_delta_fair(delta_exec, curr);
 	curr->vruntime += delta_exec_weighted;
+	update_min_vruntime(cfs_rq);
 }
 
 static void update_curr(struct cfs_rq *cfs_rq)
@@ -666,13 +672,7 @@ static void check_spread(struct cfs_rq *
 static void
 place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 {
-	u64 vruntime;
-
-	if (first_fair(cfs_rq)) {
-		vruntime = min_vruntime(cfs_rq->min_vruntime,
-				__pick_next_entity(cfs_rq)->vruntime);
-	} else
-		vruntime = cfs_rq->min_vruntime;
+	u64 vruntime = cfs_rq->min_vruntime;
 
 	/*
 	 * The 'current' period is already promised to the current tasks,
@@ -749,6 +749,7 @@ dequeue_entity(struct cfs_rq *cfs_rq, st
 	if (se != cfs_rq->curr)
 		__dequeue_entity(cfs_rq, se);
 	account_entity_dequeue(cfs_rq, se);
+	update_min_vruntime(cfs_rq);
 }
 
 /*
commit e17036dac189dd034c092a91df56aa740db7146d
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Thu Jan 15 14:53:39 2009 +0100

    sched: fix update_min_vruntime
    
    Impact: fix SCHED_IDLE latency problems
    
    OK, so we have 1 running task A (which is obviously curr and the tree is
    equally obviously empty).
    
    'A' nicely chugs along, doing its thing, carrying min_vruntime along as it
    goes.
    
    Then some whacko speed freak SCHED_IDLE task gets inserted due to SMP
    balancing, which is very likely far right, in that case
    
    update_curr
      update_min_vruntime
        cfs_rq->rb_leftmost := true (the crazy task sitting in a tree)
          vruntime = se->vruntime
    
    and voila, min_vruntime is waaay right of where it ought to be.
    
    OK, so why did I write it like that to begin with...
    
    Aah, yes.
    
    Say we've just dequeued current
    
    schedule
      deactivate_task(prev)
        dequeue_entity
          update_min_vruntime
    
    Then we'll set
    
      vruntime = cfs_rq->min_vruntime;
    
    we find !cfs_rq->curr, but do find someone in the tree. Then we _must_
    do vruntime = se->vruntime, because
    
     vruntime = min_vruntime(vruntime := cfs_rq->min_vruntime, se->vruntime)
    
    will not advance vruntime, and cause lags the other way around (which we
    fixed with that initial patch: 1af5f730fc1bf7c62ec9fb2d307206e18bf40a69
    (sched: more accurate min_vruntime accounting).
    
    Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Tested-by: Mike Galbraith <efault@gmx.de>
    Acked-by: Mike Galbraith <efault@gmx.de>
    Cc: <stable@kernel.org>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

---
 kernel/sched_fair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.27/kernel/sched_fair.c
===================================================================
--- linux-2.6.27.orig/kernel/sched_fair.c
+++ linux-2.6.27/kernel/sched_fair.c
@@ -233,7 +233,7 @@ static void update_min_vruntime(struct c
 						   struct sched_entity,
 						   run_node);
 
-		if (vruntime == cfs_rq->min_vruntime)
+		if (!cfs_rq->curr)
 			vruntime = se->vruntime;
 		else
 			vruntime = min_vruntime(vruntime, se->vruntime);
commit 6bc912b71b6f33b041cfde93ca3f019cbaa852bc
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Thu Jan 15 14:53:38 2009 +0100

    sched: SCHED_OTHER vs SCHED_IDLE isolation
    
    Stronger SCHED_IDLE isolation:
    
     - no SCHED_IDLE buddies
     - never let SCHED_IDLE preempt on wakeup
     - always preempt SCHED_IDLE on wakeup
     - limit SLEEPER fairness for SCHED_IDLE.
    
    Signed-off-by: Mike Galbraith <efault@gmx.de>
    Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

---
 kernel/sched_fair.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

Index: linux-2.6.27/kernel/sched_fair.c
===================================================================
--- linux-2.6.27.orig/kernel/sched_fair.c
+++ linux-2.6.27/kernel/sched_fair.c
@@ -689,9 +689,13 @@ place_entity(struct cfs_rq *cfs_rq, stru
 			unsigned long thresh = sysctl_sched_latency;
 
 			/*
-			 * convert the sleeper threshold into virtual time
+			 * Convert the sleeper threshold into virtual time.
+			 * SCHED_IDLE is a special sub-class.  We care about
+			 * fairness only relative to other SCHED_IDLE tasks,
+			 * all of which have the same weight.
 			 */
-			if (sched_feat(NORMALIZED_SLEEPER))
+			if (sched_feat(NORMALIZED_SLEEPER) &&
+					task_of(se)->policy != SCHED_IDLE)
 				thresh = calc_delta_fair(thresh, se);
 
 			vruntime -= thresh;
@@ -1347,15 +1351,22 @@ static void check_preempt_wakeup(struct
 	if (unlikely(se == pse))
 		return;
 
-	cfs_rq_of(pse)->next = pse;
+	if (likely(task_of(se)->policy != SCHED_IDLE))
+		cfs_rq_of(pse)->next = pse;
 
 	/*
-	 * Batch tasks do not preempt (their preemption is driven by
+	 * Batch and idle tasks do not preempt (their preemption is driven by
 	 * the tick):
 	 */
-	if (unlikely(p->policy == SCHED_BATCH))
+	if (unlikely(p->policy != SCHED_NORMAL))
 		return;
 
+	/* Idle tasks are by definition preempted by everybody. */
+	if (unlikely(curr->policy == SCHED_IDLE)) {
+		resched_task(curr);
+		return;
+	}
+
 	if (!sched_feat(WAKEUP_PREEMPT))
 		return;
 


