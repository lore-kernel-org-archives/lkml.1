Return-Path: <linux-kernel-owner+w=401wt.eu-S1755451AbYJXKB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451AbYJXKB2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 06:01:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753571AbYJXJ6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 05:58:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44855 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448AbYJXJ6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 05:58:52 -0400
Message-Id: <20081024091109.750408932@chello.nl>
References: <20081024090611.936552213@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 24 Oct 2008 11:06:16 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, efault@gmx.de, vatsa@in.ibm.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 5/8] sched: virtual time buddy preemption
Content-Disposition: inline; filename=sched-buddy-vruntime.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we moved wakeup preemption back to virtual time, it makes sense to move
the buddy stuff back as well. The purpose of the buddy scheduling is to allow
a quickly scheduling pair of tasks to run away from the group as far as a
regular busy task would be allowed under wakeup preemption.

This has the advantage that the pair can ping-pong for a while, enjoying
cache-hotness. Without buddy scheduling other tasks would interleave destroying
the cache.

Also, it saves a word in cfs_rq.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c      |    1 -
 kernel/sched_fair.c |   12 +++++-------
 2 files changed, 5 insertions(+), 8 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -385,7 +385,6 @@ struct cfs_rq {
 
 	u64 exec_clock;
 	u64 min_vruntime;
-	u64 pair_start;
 
 	struct rb_root tasks_timeline;
 	struct rb_node *rb_leftmost;
Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -790,16 +790,14 @@ set_next_entity(struct cfs_rq *cfs_rq, s
 	se->prev_sum_exec_runtime = se->sum_exec_runtime;
 }
 
+static int
+wakeup_preempt_entity(struct sched_entity *curr, struct sched_entity *se);
+
 static struct sched_entity *
 pick_next(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	struct rq *rq = rq_of(cfs_rq);
-	u64 pair_slice = rq->clock - cfs_rq->pair_start;
-
-	if (!cfs_rq->next || pair_slice > sysctl_sched_min_granularity) {
-		cfs_rq->pair_start = rq->clock;
+	if (!cfs_rq->next || wakeup_preempt_entity(cfs_rq->next, se) == 1)
 		return se;
-	}
 
 	return cfs_rq->next;
 }

-- 

