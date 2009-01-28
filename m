Return-Path: <linux-kernel-owner+w=401wt.eu-S1755283AbZA1N5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbZA1N5m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 08:57:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752268AbZA1N4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 08:56:31 -0500
Received: from casper.infradead.org ([85.118.1.10]:47056 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbZA1N4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 08:56:30 -0500
Message-Id: <20090128135253.777811766@chello.nl>
References: <20090128135137.632938951@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 28 Jan 2009 14:51:40 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, efault@gmx.de
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 3/3] sched: fix buddie group latency
Content-Disposition: inline; filename=sched-group-buddies.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Similar to the previous patch, by not clearing buddies we can select entities
past their run quota, which can increase latency. This means we have to clear
group buddies as well.

Do not use the group clear for pick_next_task(), otherwise that'll get O(n^2).

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched_fair.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -719,7 +719,7 @@ enqueue_entity(struct cfs_rq *cfs_rq, st
 		__enqueue_entity(cfs_rq, se);
 }
 
-static void clear_buddies(struct cfs_rq *cfs_rq, struct sched_entity *se)
+static void __clear_buddies(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
 	if (cfs_rq->last == se)
 		cfs_rq->last = NULL;
@@ -728,6 +728,12 @@ static void clear_buddies(struct cfs_rq 
 		cfs_rq->next = NULL;
 }
 
+static void clear_buddies(struct cfs_rq *cfs_rq, struct sched_entity *se)
+{
+	for_each_sched_entity(se)
+		__clear_buddies(cfs_rq_of(se), se);
+}
+
 static void
 dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int sleep)
 {
@@ -1502,7 +1508,7 @@ static struct task_struct *pick_next_tas
 		 * If se was a buddy, clear it so that it will have to earn
 		 * the favour again.
 		 */
-		clear_buddies(cfs_rq, se);
+		__clear_buddies(cfs_rq, se);
 		set_next_entity(cfs_rq, se);
 		cfs_rq = group_cfs_rq(se);
 	} while (cfs_rq);

-- 

