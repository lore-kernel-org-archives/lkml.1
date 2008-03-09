Return-Path: <linux-kernel-owner+w=401wt.eu-S1756100AbYCIRMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100AbYCIRMg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 13:12:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753226AbYCIRJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 13:09:25 -0400
Received: from viefep25-int.chello.at ([62.179.121.45]:21002 "EHLO
	viefep25-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501AbYCIRJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 13:09:20 -0400
X-SourceIP: 80.56.237.116
Message-Id: <20080309170926.855392000@chello.nl>
References: <20080309170850.256853000@chello.nl>
User-Agent: quilt/0.45-1
Date: Sun, 09 Mar 2008 18:08:55 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Mike Galbraith <efault@gmx.de>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC/PATCH 05/17] sched: rt-group: optimize dequeue_rt_stack
Content-Disposition: inline; filename=sched-rt-group-opt-dequeue.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the group hierarchy can have an arbitrary depth the O(n^2) nature
of RT task dequeues will really hurt. Optimize this by providing space to
store the tree path, so we can walk it the other way.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h |    1 +
 kernel/sched_rt.c     |   28 ++++++++++++----------------
 2 files changed, 13 insertions(+), 16 deletions(-)

Index: linux-2.6-2/kernel/sched_rt.c
===================================================================
--- linux-2.6-2.orig/kernel/sched_rt.c
+++ linux-2.6-2/kernel/sched_rt.c
@@ -479,26 +479,22 @@ static void dequeue_rt_entity(struct sch
 /*
  * Because the prio of an upper entry depends on the lower
  * entries, we must remove entries top - down.
- *
- * XXX: O(1/2 h^2) because we can only walk up, not down the chain.
  */
 static void dequeue_rt_stack(struct task_struct *p)
 {
-	struct sched_rt_entity *rt_se, *top_se;
+	struct sched_rt_entity *rt_se, *back = NULL;
 
-	/*
-	 * dequeue all, top - down.
-	 */
-	do {
-		rt_se = &p->rt;
-		top_se = NULL;
-		for_each_sched_rt_entity(rt_se) {
-			if (on_rt_rq(rt_se))
-				top_se = rt_se;
-		}
-		if (top_se)
-			dequeue_rt_entity(top_se);
-	} while (top_se);
+	rt_se = &p->rt;
+	for_each_sched_rt_entity(rt_se) {
+		if (!on_rt_rq(rt_se))
+			break;
+
+		rt_se->back = back;
+		back = rt_se;
+	}
+
+	for (rt_se = back; rt_se; rt_se = rt_se->back)
+		dequeue_rt_entity(rt_se);
 }
 
 /*
Index: linux-2.6-2/include/linux/sched.h
===================================================================
--- linux-2.6-2.orig/include/linux/sched.h
+++ linux-2.6-2/include/linux/sched.h
@@ -978,6 +978,7 @@ struct sched_rt_entity {
 	unsigned long timeout;
 	int nr_cpus_allowed;
 
+	struct sched_rt_entity *back;
 #ifdef CONFIG_RT_GROUP_SCHED
 	struct sched_rt_entity	*parent;
 	/* rq on which this entity is (to be) queued: */

--

