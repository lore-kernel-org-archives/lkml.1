Return-Path: <linux-kernel-owner+w=401wt.eu-S1754280AbYCIRRI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280AbYCIRRI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 13:17:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752114AbYCIRQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 13:16:55 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:56723 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751866AbYCIRQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 13:16:55 -0400
Message-Id: <20080309170927.866603000@chello.nl>
References: <20080309170850.256853000@chello.nl>
User-Agent: quilt/0.45-1
Date: Sun, 09 Mar 2008 18:08:59 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Mike Galbraith <efault@gmx.de>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC/PATCH 09/17] sched: fair: remove moved_group()
Content-Disposition: inline; filename=sched-remove-moved_group.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that all tasks are in a single RQ again tasks in different groups are
comparable again, hence we no longer require a notification when a task is
moved between groups.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h |    4 ----
 kernel/sched.c        |    5 -----
 kernel/sched_fair.c   |   14 --------------
 3 files changed, 23 deletions(-)

Index: linux-2.6-2/include/linux/sched.h
===================================================================
--- linux-2.6-2.orig/include/linux/sched.h
+++ linux-2.6-2/include/linux/sched.h
@@ -899,10 +899,6 @@ struct sched_class {
 			     int running);
 	void (*prio_changed) (struct rq *this_rq, struct task_struct *task,
 			     int oldprio, int running);
-
-#ifdef CONFIG_FAIR_GROUP_SCHED
-	void (*moved_group) (struct task_struct *p);
-#endif
 };
 
 struct load_weight {
Index: linux-2.6-2/kernel/sched.c
===================================================================
--- linux-2.6-2.orig/kernel/sched.c
+++ linux-2.6-2/kernel/sched.c
@@ -8134,11 +8134,6 @@ void sched_move_task(struct task_struct 
 
 	set_task_rq(tsk, task_cpu(tsk));
 
-#ifdef CONFIG_FAIR_GROUP_SCHED
-	if (tsk->sched_class->moved_group)
-		tsk->sched_class->moved_group(tsk);
-#endif
-
 	if (on_rq) {
 		if (unlikely(running))
 			tsk->sched_class->set_curr_task(rq);
Index: linux-2.6-2/kernel/sched_fair.c
===================================================================
--- linux-2.6-2.orig/kernel/sched_fair.c
+++ linux-2.6-2/kernel/sched_fair.c
@@ -1487,16 +1487,6 @@ static void set_curr_task_fair(struct rq
 		set_next_entity(cfs_rq_of(se), se);
 }
 
-#ifdef CONFIG_FAIR_GROUP_SCHED
-static void moved_group_fair(struct task_struct *p)
-{
-	struct cfs_rq *cfs_rq = task_cfs_rq(p);
-
-	update_curr(cfs_rq);
-	place_entity(cfs_rq, &p->se, 1);
-}
-#endif
-
 /*
  * All the scheduling class methods:
  */
@@ -1525,10 +1515,6 @@ static const struct sched_class fair_sch
 
 	.prio_changed		= prio_changed_fair,
 	.switched_to		= switched_to_fair,
-
-#ifdef CONFIG_FAIR_GROUP_SCHED
-	.moved_group		= moved_group_fair,
-#endif
 };
 
 #ifdef CONFIG_SCHED_DEBUG

--

