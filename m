Return-Path: <linux-kernel-owner+w=401wt.eu-S934398AbYEBMJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934398AbYEBMJ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 08:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761432AbYEBMJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 08:09:49 -0400
Received: from mail.gmx.net ([213.165.64.20]:38626 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757724AbYEBMJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 08:09:48 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/V/Ps5cbXVsD0Grix666teVoDqF0OIiLki4Km85D
	ePTuXpMkbYrUPy
Subject: Re: Horrendous Audio Stutter - current git
From: Mike Galbraith <efault@gmx.de>
To: Parag Warudkar <parag.warudkar@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Frans Pop <elendil@planet.nl>
In-Reply-To: <82e4877d0805020410u78c6f03fr8e8e53d5a19f6846@mail.gmail.com>
References: <82e4877d0805011714m35a47753q58cca706b7af6557@mail.gmail.com>
	 <1209717278.13978.136.camel@twins>
	 <82e4877d0805020410u78c6f03fr8e8e53d5a19f6846@mail.gmail.com>
Content-Type: multipart/mixed; boundary="=-G1ggYH3nO0TZyx8/ewFM"
Date: Fri, 02 May 2008 14:09:45 +0200
Message-Id: <1209730185.18055.21.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-G1ggYH3nO0TZyx8/ewFM
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Fri, 2008-05-02 at 07:10 -0400, Parag Warudkar wrote:

> Mike -  the GROUP_SCHED stuff is set to y in the Ubuntu kernel and I
> have no audio skips - may be a regression introduced after 2.6.24?

Hm.  I've stumbled across a regression that may be related.  Can you
please try the attached with group scheduling enabled in current git?

	-Mike



--=-G1ggYH3nO0TZyx8/ewFM
Content-Disposition: attachment; filename=revert_8f1bc385cfbab474db6c27b5af1e439614f3025c.diff
Content-Type: text/x-patch; name=revert_8f1bc385cfbab474db6c27b5af1e439614f3025c.diff; charset=utf-8
Content-Transfer-Encoding: 7bit

commit 8f1bc385cfbab474db6c27b5af1e439614f3025c
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Sat Apr 19 19:45:00 2008 +0200

    sched: fair: weight calculations
    
    In order to level the hierarchy, we need to calculate load based on the
    root view. That is, each task's load is in the same unit.
    
                 A
                / \
               B   1
              / \
             2   3
    
    To compute 1's load we do:
    
    	   weight(1)
    	--------------
    	 rq_weight(A)
    
    To compute 2's load we do:
    
    	  weight(2)      weight(B)
    	------------ * -----------
    	rq_weight(B)   rw_weight(A)
    
    This yields load fractions in comparable units.
    
    The consequence is that it changes virtual time. We used to have:
    
                    time_{i}
      vtime_{i} = ------------
                   weight_{i}
    
      vtime = \Sum vtime_{i} = time / rq_weight.
    
    But with the new way of load calculation we get that vtime equals time.
    
    Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

Index: linux-2.6.26.git/kernel/sched.c
===================================================================
--- linux-2.6.26.git.orig/kernel/sched.c
+++ linux-2.6.26.git/kernel/sched.c
@@ -1429,9 +1429,6 @@ static void __resched_task(struct task_s
  */
 #define SRR(x, y) (((x) + (1UL << ((y) - 1))) >> (y))
 
-/*
- * delta *= weight / lw
- */
 static unsigned long
 calc_delta_mine(unsigned long delta_exec, unsigned long weight,
 		struct load_weight *lw)
@@ -1454,6 +1451,12 @@ calc_delta_mine(unsigned long delta_exec
 	return (unsigned long)min(tmp, (u64)(unsigned long)LONG_MAX);
 }
 
+static inline unsigned long
+calc_delta_fair(unsigned long delta_exec, struct load_weight *lw)
+{
+	return calc_delta_mine(delta_exec, NICE_0_LOAD, lw);
+}
+
 static inline void update_load_add(struct load_weight *lw, unsigned long inc)
 {
 	lw->weight += inc;
Index: linux-2.6.26.git/kernel/sched_fair.c
===================================================================
--- linux-2.6.26.git.orig/kernel/sched_fair.c
+++ linux-2.6.26.git/kernel/sched_fair.c
@@ -334,34 +334,6 @@ int sched_nr_latency_handler(struct ctl_
 #endif
 
 /*
- * delta *= w / rw
- */
-static inline unsigned long
-calc_delta_weight(unsigned long delta, struct sched_entity *se)
-{
-	for_each_sched_entity(se) {
-		delta = calc_delta_mine(delta,
-				se->load.weight, &cfs_rq_of(se)->load);
-	}
-
-	return delta;
-}
-
-/*
- * delta *= rw / w
- */
-static inline unsigned long
-calc_delta_fair(unsigned long delta, struct sched_entity *se)
-{
-	for_each_sched_entity(se) {
-		delta = calc_delta_mine(delta,
-				cfs_rq_of(se)->load.weight, &se->load);
-	}
-
-	return delta;
-}
-
-/*
  * The idea is to set a period in which each task runs once.
  *
  * When there are too many tasks (sysctl_sched_nr_latency) we have to stretch
@@ -390,54 +362,47 @@ static u64 __sched_period(unsigned long 
  */
 static u64 sched_slice(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	return calc_delta_weight(__sched_period(cfs_rq->nr_running), se);
+	u64 slice = __sched_period(cfs_rq->nr_running);
+
+	for_each_sched_entity(se) {
+		cfs_rq = cfs_rq_of(se);
+
+		slice *= se->load.weight;
+		do_div(slice, cfs_rq->load.weight);
+	}
+
+
+	return slice;
 }
 
 /*
  * We calculate the vruntime slice of a to be inserted task
  *
- * vs = s*rw/w = p
+ * vs = s/w = p/rw
  */
 static u64 sched_vslice_add(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
 	unsigned long nr_running = cfs_rq->nr_running;
+	unsigned long weight;
+	u64 vslice;
 
 	if (!se->on_rq)
 		nr_running++;
 
-	return __sched_period(nr_running);
-}
-
-/*
- * The goal of calc_delta_asym() is to be asymmetrically around NICE_0_LOAD, in
- * that it favours >=0 over <0.
- *
- *   -20         |
- *               |
- *     0 --------+-------
- *             .'
- *    19     .'
- *
- */
-static unsigned long
-calc_delta_asym(unsigned long delta, struct sched_entity *se)
-{
-	struct load_weight lw = {
-		.weight = NICE_0_LOAD,
-		.inv_weight = 1UL << (WMULT_SHIFT-NICE_0_SHIFT)
-	};
+	vslice = __sched_period(nr_running);
 
 	for_each_sched_entity(se) {
-		struct load_weight *se_lw = &se->load;
+		cfs_rq = cfs_rq_of(se);
 
-		if (se->load.weight < NICE_0_LOAD)
-			se_lw = &lw;
+		weight = cfs_rq->load.weight;
+		if (!se->on_rq)
+			weight += se->load.weight;
 
-		delta = calc_delta_mine(delta,
-				cfs_rq_of(se)->load.weight, se_lw);
+		vslice *= NICE_0_LOAD;
+		do_div(vslice, weight);
 	}
 
-	return delta;
+	return vslice;
 }
 
 /*
@@ -454,7 +419,11 @@ __update_curr(struct cfs_rq *cfs_rq, str
 
 	curr->sum_exec_runtime += delta_exec;
 	schedstat_add(cfs_rq, exec_clock, delta_exec);
-	delta_exec_weighted = calc_delta_fair(delta_exec, curr);
+	delta_exec_weighted = delta_exec;
+	if (unlikely(curr->load.weight != NICE_0_LOAD)) {
+		delta_exec_weighted = calc_delta_fair(delta_exec_weighted,
+							&curr->load);
+	}
 	curr->vruntime += delta_exec_weighted;
 }
 
@@ -663,7 +632,8 @@ place_entity(struct cfs_rq *cfs_rq, stru
 		/* sleeps upto a single latency don't count. */
 		if (sched_feat(NEW_FAIR_SLEEPERS)) {
 			if (sched_feat(NORMALIZED_SLEEPER))
-				vruntime -= calc_delta_weight(sysctl_sched_latency, se);
+				vruntime -= calc_delta_fair(sysctl_sched_latency,
+						&cfs_rq->load);
 			else
 				vruntime -= sysctl_sched_latency;
 		}
@@ -1162,10 +1132,11 @@ static unsigned long wakeup_gran(struct 
 	unsigned long gran = sysctl_sched_wakeup_granularity;
 
 	/*
-	 * More easily preempt - nice tasks, while not making it harder for
-	 * + nice tasks.
+	 * More easily preempt - nice tasks, while not making
+	 * it harder for + nice tasks.
 	 */
-	gran = calc_delta_asym(sysctl_sched_wakeup_granularity, se);
+	if (unlikely(se->load.weight > NICE_0_LOAD))
+		gran = calc_delta_fair(gran, &se->load);
 
 	return gran;
 }

--=-G1ggYH3nO0TZyx8/ewFM--

