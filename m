Return-Path: <linux-kernel-owner+w=401wt.eu-S1757537AbYBUFiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537AbYBUFiP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 00:38:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751865AbYBUFh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 00:37:58 -0500
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:41380 "EHLO
	e28esmtp04.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751852AbYBUFh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 00:37:57 -0500
Date: Thu, 21 Feb 2008 11:03:21 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peter@programming.kicks-ass.net>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Make yield_task_fair more efficient
Message-ID: <20080221053321.GA26918@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: Ingo Molnar <mingo@elte.hu>,
	Peter Zijlstra <peter@programming.kicks-ass.net>,
	Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
	Dhaval Giani <dhaval@linux.vnet.ibm.com>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__pick_last_entity() walks the entire tree on O(lgn) time to find the
rightmost entry. This patch makes the routine more efficient by
reducing the cost of the lookup

Description
-----------

Cache the rightmost entry in the rb_tree in the same way that we cache
the leftmost entry. __pick_last_entity now uses the cached value.
A cautious reviewer might note that the rb_erase() in dequeue entity
might cause the tree to be rebalanced and thus effect the cached value.
In the case of the rightmost entity, we assign the value to the parent,
which even if the tree is rebalanced will become the rightmost entity.

NOTE: This depends on Peter Zijlstra's patch which checks for !rightmost.
Check out http://lkml.org/lkml/2008/2/18/295. Peter that patch works
for me, could you please push that as well.

I've seen improvements with this patch. Specifically for
the case reported by Yanmin (http://lkml.org/lkml/2008/2/13/128)

Comments?

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 kernel/sched.c      |    7 +++++++
 kernel/sched_fair.c |   30 +++++++++++++++++++-----------
 2 files changed, 26 insertions(+), 11 deletions(-)

diff -puN kernel/sched.c~make-sched-yield-fair-more-efficient kernel/sched.c
--- linux-2.6.25-rc2/kernel/sched.c~make-sched-yield-fair-more-efficient	2008-02-21 08:49:06.000000000 +0530
+++ linux-2.6.25-rc2-balbir/kernel/sched.c	2008-02-21 09:50:13.000000000 +0530
@@ -537,7 +537,13 @@ struct cfs_rq {
 	u64 min_vruntime;
 
 	struct rb_root tasks_timeline;
+
+	/*
+	 * Cached data to help improve performance (avoid walking the
+	 * tree)
+	 */
 	struct rb_node *rb_leftmost;
+	struct rb_node *rb_rightmost;
 
 	struct list_head tasks;
 	struct list_head *balance_iterator;
@@ -7332,6 +7338,7 @@ static void init_cfs_rq(struct cfs_rq *c
 	cfs_rq->tasks_timeline = RB_ROOT;
 	INIT_LIST_HEAD(&cfs_rq->tasks);
 	cfs_rq->rb_leftmost = NULL;
+	cfs_rq->rb_rightmost = NULL;
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	cfs_rq->rq = rq;
 #endif
diff -puN kernel/sched_fair.c~make-sched-yield-fair-more-efficient kernel/sched_fair.c
--- linux-2.6.25-rc2/kernel/sched_fair.c~make-sched-yield-fair-more-efficient	2008-02-21 08:49:06.000000000 +0530
+++ linux-2.6.25-rc2-balbir/kernel/sched_fair.c	2008-02-21 10:26:06.000000000 +0530
@@ -233,6 +233,7 @@ static void __enqueue_entity(struct cfs_
 	struct sched_entity *entry;
 	s64 key;
 	int leftmost = 1;
+	int rightmost = 1;
 
 	if (!entity_is_task(se))
 		return;
@@ -256,6 +257,7 @@ static void __enqueue_entity(struct cfs_
 		 */
 		if (key < entity_key(cfs_rq, entry)) {
 			link = &parent->rb_left;
+			rightmost = 0;
 		} else {
 			link = &parent->rb_right;
 			leftmost = 0;
@@ -268,6 +270,8 @@ static void __enqueue_entity(struct cfs_
 	 */
 	if (leftmost)
 		cfs_rq->rb_leftmost = &se->run_node;
+	if (rightmost)
+		cfs_rq->rb_rightmost = &se->run_node;
 
 	rb_link_node(&se->run_node, parent, link);
 	rb_insert_color(&se->run_node, &cfs_rq->tasks_timeline);
@@ -286,6 +290,12 @@ static void __dequeue_entity(struct cfs_
 	if (cfs_rq->rb_leftmost == &se->run_node)
 		cfs_rq->rb_leftmost = rb_next(&se->run_node);
 
+	/*
+	 * The parent becomes the rightmost node
+	 */
+	if (cfs_rq->rb_rightmost == &se->run_node)
+		cfs_rq->rb_rightmost = rb_parent(&se->run_node);
+
 	rb_erase(&se->run_node, &cfs_rq->tasks_timeline);
 }
 
@@ -294,6 +304,11 @@ static inline struct rb_node *first_fair
 	return cfs_rq->rb_leftmost;
 }
 
+static inline struct rb_node *last_fair(struct cfs_rq *cfs_rq)
+{
+	return cfs_rq->rb_rightmost;
+}
+
 static struct sched_entity *__pick_next_entity(struct cfs_rq *cfs_rq)
 {
 	return rb_entry(first_fair(cfs_rq), struct sched_entity, run_node);
@@ -301,17 +316,10 @@ static struct sched_entity *__pick_next_
 
 static inline struct sched_entity *__pick_last_entity(struct cfs_rq *cfs_rq)
 {
-	struct rb_node **link = &cfs_rq->tasks_timeline.rb_node;
-	struct sched_entity *se = NULL;
-	struct rb_node *parent;
-
-	while (*link) {
-		parent = *link;
-		se = rb_entry(parent, struct sched_entity, run_node);
-		link = &parent->rb_right;
-	}
-
-	return se;
+	struct rb_node *rightmost = last_fair(cfs_rq);
+	if (!rightmost)
+		return NULL;
+	return rb_entry(rightmost, struct sched_entity, run_node);
 }
 
 /**************************************************************
_

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
