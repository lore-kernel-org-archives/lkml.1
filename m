Return-Path: <linux-kernel-owner+w=401wt.eu-S1753496AbYIWNh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496AbYIWNh5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 09:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751452AbYIWNge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 09:36:34 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50025 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbYIWNgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 09:36:31 -0400
Message-Id: <20080923133459.522091580@programming.kicks-ass.net>
References: <20080923133340.929758093@programming.kicks-ass.net>
User-Agent: quilt/0.46-1
Date: Tue, 23 Sep 2008 15:33:42 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/6] sched: fixlet for group load balance
Content-Disposition: inline; filename=sched-group-balance-fix.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should not only correct the increment for the initial group, but should
be consistent and do so for all the groups we encounter.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched_fair.c |   27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -1086,7 +1086,6 @@ static long effective_load(struct task_g
 		long wl, long wg)
 {
 	struct sched_entity *se = tg->se[cpu];
-	long more_w;
 
 	if (!tg->parent)
 		return wl;
@@ -1098,18 +1097,17 @@ static long effective_load(struct task_g
 	if (!wl && sched_feat(ASYM_EFF_LOAD))
 		return wl;
 
-	/*
-	 * Instead of using this increment, also add the difference
-	 * between when the shares were last updated and now.
-	 */
-	more_w = se->my_q->load.weight - se->my_q->rq_weight;
-	wl += more_w;
-	wg += more_w;
-
 	for_each_sched_entity(se) {
-#define D(n) (likely(n) ? (n) : 1)
-
 		long S, rw, s, a, b;
+		long more_w;
+
+		/*
+		 * Instead of using this increment, also add the difference
+		 * between when the shares were last updated and now.
+		 */
+		more_w = se->my_q->load.weight - se->my_q->rq_weight;
+		wl += more_w;
+		wg += more_w;
 
 		S = se->my_q->tg->shares;
 		s = se->my_q->shares;
@@ -1118,7 +1116,11 @@ static long effective_load(struct task_g
 		a = S*(rw + wl);
 		b = S*rw + s*wg;
 
-		wl = s*(a-b)/D(b);
+		wl = s*(a-b);
+
+		if (likely(b))
+			wl /= b;
+
 		/*
 		 * Assume the group is already running and will
 		 * thus already be accounted for in the weight.
@@ -1127,7 +1129,6 @@ static long effective_load(struct task_g
 		 * alter the group weight.
 		 */
 		wg = 0;
-#undef D
 	}
 
 	return wl;

-- 

