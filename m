Return-Path: <linux-kernel-owner+w=401wt.eu-S1758190AbZAOMzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758190AbZAOMzU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 07:55:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752911AbZAOMzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 07:55:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52866 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752454AbZAOMy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 07:54:59 -0500
Date: Thu, 15 Jan 2009 13:54:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>, Brian Rogers <brian@xyzw.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG] How to get real-time priority using idle priority
Message-ID: <20090115125451.GB21839@elte.hu>
References: <4969D0D7.2060401@xyzw.org> <1231736941.6003.7.camel@marge.simson.net> <1231765433.5789.35.camel@marge.simson.net> <20090112131406.GB670@elte.hu> <496BE8F6.1040308@xyzw.org> <1232011723.26761.36.camel@marge.simson.net> <1232014456.8870.26.camel@laptop> <1232015423.13856.5.camel@marge.simson.net> <1232019428.5720.8.camel@marge.simson.net> <1232019686.8870.45.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232019686.8870.45.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> > > Aha.  Yeah, I'll re-test with that instead.
> > 
> > Works a treat.
> 
> *cheer* lets get this merged asap, and CC -stable as well.

I've created the delta patch below for sched/urgent - i've been testing 
the previous version already. Mike, do you agree with this splitup?

	Ingo

--------------->
>From 7bad8c0618dc32ecf7632b7d5abfb21645ee6b60 Mon Sep 17 00:00:00 2001
From: Mike Galbraith <efault@gmx.de>
Date: Thu, 15 Jan 2009 10:28:43 +0100
Subject: [PATCH] sched: fix SCHED_IDLE latency/starvation, v2

The below seems to cure all of the problems I've encountered.

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

Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: <stable@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c      |   23 ++++-------------------
 kernel/sched_fair.c |   13 +++++++------
 2 files changed, 11 insertions(+), 25 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index e551bb6..b087c7f 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1323,8 +1323,8 @@ static inline void update_load_sub(struct load_weight *lw, unsigned long dec)
  * slice expiry etc.
  */
 
-#define WEIGHT_IDLEPRIO		2
-#define WMULT_IDLEPRIO		(1 << 31)
+#define WEIGHT_IDLEPRIO		3
+#define WMULT_IDLEPRIO		1431655765
 
 /*
  * Nice levels are multiplicative, with a gentle 10% change for every
@@ -1891,23 +1891,8 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 			schedstat_inc(p, se.nr_forced2_migrations);
 	}
 #endif
-	if (old_cpu != new_cpu) {
-		s64 delta = p->se.vruntime - old_cfsrq->min_vruntime;
-
-		/*
-		 * min_vruntimes may be advancing at wildly different
-		 * rates, so we must scale the delta accordingly.
-		 */
-		if (new_cfsrq->load.weight != old_cfsrq->load.weight) {
-			int negative = delta < 0;
-
-			delta = negative ? -delta : delta;
-			delta = calc_delta_mine(delta,
-				new_cfsrq->load.weight, &old_cfsrq->load);
-			delta = negative ? -delta : delta;
-		}
-		p->se.vruntime = new_cfsrq->min_vruntime + delta;
-	}
+	p->se.vruntime -= old_cfsrq->min_vruntime -
+					 new_cfsrq->min_vruntime;
 
 	__set_task_cpu(p, new_cpu);
 }
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 500ed14..761071d 100644
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
