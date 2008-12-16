Return-Path: <linux-kernel-owner+w=401wt.eu-S1754968AbYLPK1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968AbYLPK1V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 05:27:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752221AbYLPK1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 05:27:11 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:35266 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185AbYLPK1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 05:27:10 -0500
To: efault@gmx.de
CC: miklos@szeredi.hu, rjw@sisk.pl, a.p.zijlstra@chello.nl, mingo@elte.hu,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org
In-reply-to: <1229397927.5296.48.camel@marge.simson.net> (message from Mike
	Galbraith on Tue, 16 Dec 2008 04:25:27 +0100)
Subject: Re: [Bug #12208] uml is very slow on 2.6.28 host
References: <u7kfEgp36eE.A.qpG.Y4_QJB@chimera>
	 <T1gm2CtAHBF.A.u6G.g4_QJB@chimera>  <E1LCO85-0000rR-Br@pomaz-ex.szeredi.hu> <1229397927.5296.48.camel@marge.simson.net>
Message-Id: <E1LCX8h-0001sh-Uo@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 16 Dec 2008 11:26:55 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Dec 2008, Mike Galbraith wrote:
> On Tue, 2008-12-16 at 01:49 +0100, Miklos Szeredi wrote:
> > On Sat, 13 Dec 2008, Rafael J. Wysocki wrote:
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12208
> > > Subject		: uml is very slow on 2.6.28 host
> > > Submitter	: Miklos Szeredi <miklos@szeredi.hu>
> > > Date		: 2008-12-12 9:35 (2 days old)
> > > References	: http://marc.info/?l=linux-kernel&m=122907463518593&w=4
> > 
> > I did a bisection, and this is the commit which is responsible:
> > 
> >   commit 464b75273f64be7c81fee975bd6ca9593df3427b
> >   Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> >   Date:   Fri Oct 24 11:06:15 2008 +0200
> >   
> >       sched: re-instate vruntime based wakeup preemption
> >   
> >       The advantage is that vruntime based wakeup preemption has a better
> >       conceptual model. Here wakeup_gran = 0 means: preempt when 'fair'.
> >       Therefore wakeup_gran is the granularity of unfairness we allow in order
> >       to make progress.
> >   
> >       Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> >       Acked-by: Mike Galbraith <efault@gmx.de>
> >       Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> If that commit is responsible, then it should also be very slow in pre
> 28 kernels, where the same exists.

Everything prior to 2.6.28 was fine in this respect, so there must be
some subtle difference.

>   Hm, there's another possibility.
> Can you try echo NO_LAST_BUDDY > /sys/kernel/debug/sched_features?

It didn't help, unfortunately.

Applying this patch on top of latest git (which essentially reverts
the above commit) fixes the slowness.

Thanks,
Miklos


---
 kernel/sched_fair.c |   98 +++-------------------------------------------------
 1 file changed, 6 insertions(+), 92 deletions(-)

Index: linux.git/kernel/sched_fair.c
===================================================================
--- linux.git.orig/kernel/sched_fair.c	2008-12-16 01:34:26.000000000 +0100
+++ linux.git/kernel/sched_fair.c	2008-12-16 01:34:54.000000000 +0100
@@ -143,49 +143,6 @@ static inline struct sched_entity *paren
 	return se->parent;
 }
 
-/* return depth at which a sched entity is present in the hierarchy */
-static inline int depth_se(struct sched_entity *se)
-{
-	int depth = 0;
-
-	for_each_sched_entity(se)
-		depth++;
-
-	return depth;
-}
-
-static void
-find_matching_se(struct sched_entity **se, struct sched_entity **pse)
-{
-	int se_depth, pse_depth;
-
-	/*
-	 * preemption test can be made between sibling entities who are in the
-	 * same cfs_rq i.e who have a common parent. Walk up the hierarchy of
-	 * both tasks until we find their ancestors who are siblings of common
-	 * parent.
-	 */
-
-	/* First walk up until both entities are at same depth */
-	se_depth = depth_se(*se);
-	pse_depth = depth_se(*pse);
-
-	while (se_depth > pse_depth) {
-		se_depth--;
-		*se = parent_entity(*se);
-	}
-
-	while (pse_depth > se_depth) {
-		pse_depth--;
-		*pse = parent_entity(*pse);
-	}
-
-	while (!is_same_group(*se, *pse)) {
-		*se = parent_entity(*se);
-		*pse = parent_entity(*pse);
-	}
-}
-
 #else	/* CONFIG_FAIR_GROUP_SCHED */
 
 static inline struct rq *rq_of(struct cfs_rq *cfs_rq)
@@ -236,11 +193,6 @@ static inline struct sched_entity *paren
 	return NULL;
 }
 
-static inline void
-find_matching_se(struct sched_entity **se, struct sched_entity **pse)
-{
-}
-
 #endif	/* CONFIG_FAIR_GROUP_SCHED */
 
 
@@ -1291,8 +1243,8 @@ static unsigned long wakeup_gran(struct
 	 * More easily preempt - nice tasks, while not making it harder for
 	 * + nice tasks.
 	 */
-	if (!sched_feat(ASYM_GRAN) || se->load.weight > NICE_0_LOAD)
-		gran = calc_delta_fair(sysctl_sched_wakeup_granularity, se);
+	if (sched_feat(ASYM_GRAN))
+		gran = calc_delta_mine(gran, NICE_0_LOAD, &se->load);
 
 	return gran;
 }
@@ -1345,6 +1268,7 @@ static void check_preempt_wakeup(struct
 {
 	struct task_struct *curr = rq->curr;
 	struct sched_entity *se = &curr->se, *pse = &p->se;
+	s64 delta_exec;
 
 	if (unlikely(rt_prio(p->prio))) {
 		struct cfs_rq *cfs_rq = task_cfs_rq(curr);
@@ -1398,19 +1322,9 @@ static void check_preempt_wakeup(struct
 		return;
 	}
 
-	find_matching_se(&se, &pse);
-
-	while (se) {
-		BUG_ON(!pse);
-
-		if (wakeup_preempt_entity(se, pse) == 1) {
-			resched_task(curr);
-			break;
-		}
-
-		se = parent_entity(se);
-		pse = parent_entity(pse);
-	}
+	delta_exec = se->sum_exec_runtime - se->prev_sum_exec_runtime;
+	if (delta_exec > wakeup_gran(pse))
+		resched_task(curr);
 }
 
 static struct task_struct *pick_next_task_fair(struct rq *rq)
