Return-Path: <linux-kernel-owner+w=401wt.eu-S1756134AbZANFNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134AbZANFNy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 00:13:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753223AbZANFNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 00:13:44 -0500
Received: from mail.gmx.net ([213.165.64.20]:38001 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753217AbZANFNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 00:13:43 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/qC5AP6DXqV4+DbjCzc8i6sT0D+kIDzEzp8BVXIn
	LOed8H8Vhg74on
Subject: Re: [BUG] How to get real-time priority using idle priority
From: Mike Galbraith <efault@gmx.de>
To: Brian Rogers <brian@xyzw.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <1231815523.5899.7.camel@marge.simson.net>
References: <4969D0D7.2060401@xyzw.org>
	 <1231736941.6003.7.camel@marge.simson.net>
	 <1231765433.5789.35.camel@marge.simson.net> <20090112131406.GB670@elte.hu>
	 <496BE8F6.1040308@xyzw.org>  <1231815523.5899.7.camel@marge.simson.net>
Content-Type: text/plain
Date: Wed, 14 Jan 2009 06:13:34 +0100
Message-Id: <1231910014.610.14.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.43
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-13 at 03:58 +0100, Mike Galbraith wrote:
> On Mon, 2009-01-12 at 17:05 -0800, Brian Rogers wrote:

> > I'll try Mike's "more complete" patch on top of 2.6.29-rc1 and see what 
> > that does.
> 
> Don't bother.  I just tried a SCHED_IDLE make -j8 and had character
> repeats while typing.  Must be another spot.

Hrmph, what an annoying problem.  The below works pretty well, but
_still_ has latency problems in some circumstances.

The more I look at this, the more I think these guys _really_ want to be
a separate class.  The problem is the incredible rate of min_vruntime
advancement creating absurdly huge spreads.

Hm, maybe I could advance min_vruntime at nice 0 when these guys are
running, only advance their vruntime at warp 512, but that seems awfully
hackish.  If they were a separate class, they could use the full nice
spectrum instead of being merely mega-nice.

diff --git a/kernel/sched.c b/kernel/sched.c
index deb5ac8..5221515 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1888,8 +1888,29 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 			schedstat_inc(p, se.nr_forced2_migrations);
 	}
 #endif
-	p->se.vruntime -= old_cfsrq->min_vruntime -
-					 new_cfsrq->min_vruntime;
+	if (old_cpu != new_cpu) {
+		u64 vruntime, min_vruntime;
+		s64 delta = p->se.vruntime - old_cfsrq->min_vruntime;
+
+		/*
+		 * min_vruntimes may be advancing at wildly different
+		 * rates, so we must scale the delta accordingly.
+		 */
+		if (new_cfsrq->load.weight != old_cfsrq->load.weight) {
+			int negative = delta < 0;
+
+			delta = negative ? -delta : delta;
+			delta = calc_delta_mine(delta,
+				new_cfsrq->load.weight, &old_cfsrq->load);
+			delta = negative ? -delta : delta;
+		}
+		vruntime = new_cfsrq->min_vruntime + delta;
+		min_vruntime = new_cfsrq->min_vruntime - sysctl_sched_latency;
+		delta = (s64)(vruntime - min_vruntime);
+		if (delta > 0)
+			min_vruntime = vruntime;
+		p->se.vruntime = min_vruntime;
+	}
 
 	__set_task_cpu(p, new_cpu);
 }
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 8e1352c..b18658f 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -673,7 +673,8 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 
 	if (!initial) {
 		/* sleeps upto a single latency don't count. */
-		if (sched_feat(NEW_FAIR_SLEEPERS)) {
+		if (sched_feat(NEW_FAIR_SLEEPERS) &&
+				task_of(se)->policy != SCHED_IDLE) {
 			unsigned long thresh = sysctl_sched_latency;
 
 			/*
@@ -793,6 +794,10 @@ set_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	}
 #endif
 	se->prev_sum_exec_runtime = se->sum_exec_runtime;
+
+	/* Idle tasks reach parity as soon as they get a chance to run. */
+	if (unlikely(task_of(se)->policy == SCHED_IDLE))
+		se->vruntime = cfs_rq->min_vruntime;
 }
 
 static int
@@ -1340,14 +1345,18 @@ wakeup_preempt_entity(struct sched_entity *curr, struct sched_entity *se)
 
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
@@ -1393,12 +1402,18 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int sync)
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
 


