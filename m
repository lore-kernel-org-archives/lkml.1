Return-Path: <linux-kernel-owner+w=401wt.eu-S1762790AbXJMXOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762790AbXJMXOm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 19:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754713AbXJMXOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 19:14:33 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44253 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876AbXJMXOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 19:14:32 -0400
Subject: Re: [PATCH] sched: high-res preemption tick
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mike Galbraith <efault@gmx.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1192267072.5897.5.camel@lappy>
References: <1192222309.5897.3.camel@lappy>
	 <1192259938.7369.4.camel@Homer.simpson.net>
	 <1192265717.27435.44.camel@twins>  <1192267072.5897.5.camel@lappy>
Content-Type: text/plain
Date: Sun, 14 Oct 2007 01:13:48 +0200
Message-Id: <1192317228.5625.8.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2007-10-13 at 11:17 +0200, Peter Zijlstra wrote:

> > Ah, but HRTICK is not compatible with PREEMPT_RESTRICT, it will be
> > similar to !WAKEUP_PREEMPT.
> 
> (I do plan to fix that eventually, just need to do it)

I guess something like this ought to do, but its a tad late so I'm quite
sure :-)

---
 kernel/sched_fair.c |   44 +++++++++++++++++++++++++++++++++++++-------
 1 file changed, 37 insertions(+), 7 deletions(-)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -737,6 +737,24 @@ static inline struct sched_entity *paren
 
 #endif	/* CONFIG_FAIR_GROUP_SCHED */
 
+/*
+ * does pse (newly woken task) preempt se (current task)
+ */
+static int wakeup_preempt(struct sched_entity *se, struct sched_entity *pse)
+{
+	s64 delta, gran;
+
+	delta = se->vruntime - pse->vruntime;
+	gran = sysctl_sched_wakeup_granularity;
+	if (unlikely(se->load.weight != NICE_0_LOAD))
+		gran = calc_delta_fair(gran, &se->load);
+
+	if (delta > gran)
+		return 1;
+
+	return 0;
+}
+
 #ifdef CONFIG_SCHED_HRTICK
 static void hrtick_start_fair(struct rq *rq, struct task_struct *p)
 {
@@ -764,6 +782,24 @@ static void hrtick_start_fair(struct rq 
 		if (!requeue)
 			delta = max(10000LL, delta);
 
+		/*
+		 * if we delayed wakeup preemption, shorten the slice to at most
+		 * 1 jiffy (does this call for yet another sysctl_sched_?)
+		 */
+		if (sched_feat(PREEMPT_RESTRICT) && first_fair(cfs_rq)) {
+			struct sched_entity *next = __pick_next_entity(cfs_rq);
+
+			if (wakeup_preempt(se, next)) {
+				u64 wakeup = NSEC_PER_SEC / HZ;
+				s64 delta2 = wakeup - ran;
+
+				if (delta2 < 0)
+					resched_task(rq->curr);
+				else
+					delta = min(delta, delta2);
+			}
+		}
+
 		hrtick_start(rq, delta, requeue);
 	}
 }
@@ -866,7 +902,6 @@ static void check_preempt_wakeup(struct 
 	struct task_struct *curr = rq->curr;
 	struct cfs_rq *cfs_rq = task_cfs_rq(curr);
 	struct sched_entity *se = &curr->se, *pse = &p->se;
-	s64 delta, gran;
 
 	if (unlikely(rt_prio(p->prio))) {
 		update_rq_clock(rq);
@@ -887,12 +922,7 @@ static void check_preempt_wakeup(struct 
 			pse = parent_entity(pse);
 		}
 
-		delta = se->vruntime - pse->vruntime;
-		gran = sysctl_sched_wakeup_granularity;
-		if (unlikely(se->load.weight != NICE_0_LOAD))
-			gran = calc_delta_fair(gran, &se->load);
-
-		if (delta > gran) {
+		if (wakeup_preempt(se, pse)) {
 			int now = !sched_feat(PREEMPT_RESTRICT);
 
 			if (now || p->prio < curr->prio || !se->peer_preempt++)


