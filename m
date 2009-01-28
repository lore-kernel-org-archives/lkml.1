Return-Path: <linux-kernel-owner+w=401wt.eu-S1754980AbZA1N5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980AbZA1N5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 08:57:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752149AbZA1N4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 08:56:31 -0500
Received: from casper.infradead.org ([85.118.1.10]:47055 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910AbZA1N4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 08:56:30 -0500
Message-Id: <20090128135253.688841942@chello.nl>
References: <20090128135137.632938951@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 28 Jan 2009 14:51:39 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, efault@gmx.de
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/3] sched: clear buddies more aggressively
Content-Disposition: inline; filename=sched-clear-buddies.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Galbraith <efault@gmx.de>

It was noticed that a task could get re-elected past its run quota due to buddy
affinities. This could increase latency a little. Cure it by more aggresively
clearing buddy state.

We do so in two situations:
 - when we force preempt
 - when we select a buddy to run

Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched_fair.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -768,8 +768,14 @@ check_preempt_tick(struct cfs_rq *cfs_rq
 
 	ideal_runtime = sched_slice(cfs_rq, curr);
 	delta_exec = curr->sum_exec_runtime - curr->prev_sum_exec_runtime;
-	if (delta_exec > ideal_runtime)
+	if (delta_exec > ideal_runtime) {
 		resched_task(rq_of(cfs_rq)->curr);
+		/*
+		 * The current task ran long enough, ensure it doesn't get
+		 * re-elected due to buddy favours.
+		 */
+		clear_buddies(cfs_rq, curr);
+	}
 }
 
 static void
@@ -1492,6 +1498,11 @@ static struct task_struct *pick_next_tas
 
 	do {
 		se = pick_next_entity(cfs_rq);
+		/*
+		 * If se was a buddy, clear it so that it will have to earn
+		 * the favour again.
+		 */
+		clear_buddies(cfs_rq, se);
 		set_next_entity(cfs_rq, se);
 		cfs_rq = group_cfs_rq(se);
 	} while (cfs_rq);

-- 

