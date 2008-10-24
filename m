Return-Path: <linux-kernel-owner+w=401wt.eu-S1755804AbYJXKAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804AbYJXKAU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 06:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753338AbYJXJ6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 05:58:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:36227 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156AbYJXJ6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 05:58:49 -0400
Message-Id: <20081024091109.503421146@chello.nl>
References: <20081024090611.936552213@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 24 Oct 2008 11:06:13 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, efault@gmx.de, vatsa@in.ibm.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/8] sched: more accurate min_vruntime accounting
Content-Disposition: inline; filename=sched-min_vruntime-fiddle.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 kernel/sched_fair.c |   49 +++++++++++++++++++++++++------------------------
 1 file changed, 25 insertions(+), 24 deletions(-)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -271,6 +271,27 @@ static inline s64 entity_key(struct cfs_
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
@@ -304,15 +325,8 @@ static void __enqueue_entity(struct cfs_
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
@@ -322,18 +336,9 @@ static void __dequeue_entity(struct cfs_
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
@@ -472,6 +477,7 @@ __update_curr(struct cfs_rq *cfs_rq, str
 	schedstat_add(cfs_rq, exec_clock, delta_exec);
 	delta_exec_weighted = calc_delta_fair(delta_exec, curr);
 	curr->vruntime += delta_exec_weighted;
+	update_min_vruntime(cfs_rq);
 }
 
 static void update_curr(struct cfs_rq *cfs_rq)
@@ -661,13 +667,7 @@ static void check_spread(struct cfs_rq *
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
@@ -744,6 +744,7 @@ dequeue_entity(struct cfs_rq *cfs_rq, st
 	if (se != cfs_rq->curr)
 		__dequeue_entity(cfs_rq, se);
 	account_entity_dequeue(cfs_rq, se);
+	update_min_vruntime(cfs_rq);
 }
 
 /*

-- 

