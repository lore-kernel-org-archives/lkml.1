Return-Path: <linux-kernel-owner+w=401wt.eu-S1760479AbZAOJ3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760479AbZAOJ3J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 04:29:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754453AbZAOJ2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 04:28:50 -0500
Received: from mail.gmx.net ([213.165.64.20]:54978 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754262AbZAOJ2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 04:28:47 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/rzOwF0PnreOcHXs7W1ccowowwW5XAAIjQsnTLbY
	ByfxntyCr+YMB4
Subject: Re: [BUG] How to get real-time priority using idle priority
From: Mike Galbraith <efault@gmx.de>
To: Brian Rogers <brian@xyzw.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <496BE8F6.1040308@xyzw.org>
References: <4969D0D7.2060401@xyzw.org>
	 <1231736941.6003.7.camel@marge.simson.net>
	 <1231765433.5789.35.camel@marge.simson.net> <20090112131406.GB670@elte.hu>
	 <496BE8F6.1040308@xyzw.org>
Content-Type: text/plain
Date: Thu, 15 Jan 2009 10:28:43 +0100
Message-Id: <1232011723.26761.36.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-12 at 17:05 -0800, Brian Rogers wrote:
> Ingo Molnar wrote:
> > i've applied your fix to tip/sched/urgent and merged it into tip/master.
> > Brian, you might want to test tip/master, as per:
> >
> >  http://people.redhat.com/mingo/tip.git/README
> >
> > which now has this fix included. Can you make it break?
> >   
> Yeah, I was able to trigger the same freeze again once on my desktop, 
> but it appears to be harder to trigger now. I couldn't get my program to 
> freeze the system, but one of the times I suspended then resumed BOINC, 
> it happened.

OK, the below seems to cure all of the problems I've encountered, please
take it out for a spin.

The rate of advance thing in set_task_cpu() seems to have been a case of
fixing the symptom instead of the problem.  Perhaps this needs more
thought, but my box says "Red-Herring" ;-)

The real problem (excluding the SCHED_IDLE specific problems), is that
update_min_vruntime() doesn't work quite as intended, and will slam
min_vruntime far right if load balancing etc places a task which is far
right of the currently running task on the runqueue.  If the currently
running, and up to this point the min_vruntime pace setter, is a hog,
any task waking to this runqueue after min_vruntime leaps forward has to
wait for the hog to consume the gap.  In the case of SCHED_IDLE tasks,
that gap can be huge, but even with a nice 19 tasks it can be quite
large and painful.

Removing the if (vruntime == cfs_rq->min_vruntime) test, which will be
true if the currently running task is the pace setter, cured it for me.

If this cures your woes (and Peter acks it), I'll split and submit.

diff --git a/kernel/sched.c b/kernel/sched.c
index deb5ac8..e9f0762 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1320,8 +1320,8 @@ static inline void update_load_sub(struct load_weight *lw, unsigned long dec)
  * slice expiry etc.
  */
 
-#define WEIGHT_IDLEPRIO		2
-#define WMULT_IDLEPRIO		(1 << 31)
+#define WEIGHT_IDLEPRIO		3
+#define WMULT_IDLEPRIO		1431655765
 
 /*
  * Nice levels are multiplicative, with a gentle 10% change for every
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 8e1352c..761071d 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -283,10 +283,7 @@ static void update_min_vruntime(struct cfs_rq *cfs_rq)
 						   struct sched_entity,
 						   run_node);
 
-		if (vruntime == cfs_rq->min_vruntime)
-			vruntime = se->vruntime;
-		else
-			vruntime = min_vruntime(vruntime, se->vruntime);
+		vruntime = min_vruntime(vruntime, se->vruntime);
 	}
 
 	cfs_rq->min_vruntime = max_vruntime(cfs_rq->min_vruntime, vruntime);
@@ -677,9 +674,13 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
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
@@ -1340,14 +1341,18 @@ wakeup_preempt_entity(struct sched_entity *curr, struct sched_entity *se)
 
 static void set_last_buddy(struct sched_entity *se)
 {
-	for_each_sched_entity(se)
-		cfs_rq_of(se)->last = se;
+	for_each_sched_entity(se) {
+		if (likely(task_of(se)->policy != SCHED_IDLE))
+			cfs_rq_of(se)->last = se;
+	}
 }
 
 static void set_next_buddy(struct sched_entity *se)
 {
-	for_each_sched_entity(se)
-		cfs_rq_of(se)->next = se;
+	for_each_sched_entity(se) {
+		if (likely(task_of(se)->policy != SCHED_IDLE))
+			cfs_rq_of(se)->next = se;
+	}
 }
 
 /*
@@ -1393,12 +1398,18 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int sync)
 		return;
 
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
 


