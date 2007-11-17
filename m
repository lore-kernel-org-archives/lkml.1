Return-Path: <linux-kernel-owner+w=401wt.eu-S934133AbXKQG1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934133AbXKQG1d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 01:27:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759139AbXKQGYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 01:24:41 -0500
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:51415 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757555AbXKQGYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 01:24:35 -0500
Message-Id: <20071117062405.470556925@goodmis.org>
References: <20071117062104.177779113@goodmis.org>
User-Agent: quilt/0.46-1
Date: Sat, 17 Nov 2007 01:21:19 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@sgi.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH v3 15/17] RT: Optimize rebalancing
Content-Disposition: inline; filename=0007-optimize-rt-overload-balancing.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gregory Haskins <ghaskins@novell.com>

We have logic to detect whether the system has migratable tasks, but we are
not using it when deciding whether to push tasks away.  So we add support
for considering this new information.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---

 kernel/sched.c    |    2 ++
 kernel/sched_rt.c |   10 ++++++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

Index: linux-compile.git/kernel/sched.c
===================================================================
--- linux-compile.git.orig/kernel/sched.c	2007-11-16 22:23:50.000000000 -0500
+++ linux-compile.git/kernel/sched.c	2007-11-16 22:24:07.000000000 -0500
@@ -273,6 +273,7 @@ struct rt_rq {
 	unsigned long rt_nr_migratory;
 	/* highest queued rt task prio */
 	int highest_prio;
+	int overloaded;
 };
 
 /*
@@ -6672,6 +6673,7 @@ void __init sched_init(void)
 		rq->migration_thread = NULL;
 		INIT_LIST_HEAD(&rq->migration_queue);
 		rq->rt.highest_prio = MAX_RT_PRIO;
+		rq->rt.overloaded = 0;
 #endif
 		atomic_set(&rq->nr_iowait, 0);
 
Index: linux-compile.git/kernel/sched_rt.c
===================================================================
--- linux-compile.git.orig/kernel/sched_rt.c	2007-11-16 22:23:50.000000000 -0500
+++ linux-compile.git/kernel/sched_rt.c	2007-11-16 22:25:30.000000000 -0500
@@ -16,6 +16,7 @@ static inline cpumask_t *rt_overload(voi
 }
 static inline void rt_set_overload(struct rq *rq)
 {
+	rq->rt.overloaded = 1;
 	cpu_set(rq->cpu, rt_overload_mask);
 	/*
 	 * Make sure the mask is visible before we set
@@ -30,6 +31,7 @@ static inline void rt_set_overload(struc
 static inline void rt_clear_overload(struct rq *rq)
 {
 	/* the order here really doesn't matter */
+	rq->rt.overloaded = 0;
 	atomic_dec(&rto_count);
 	cpu_clear(rq->cpu, rt_overload_mask);
 }
@@ -440,6 +442,9 @@ static int push_rt_task(struct rq *rq)
 
 	assert_spin_locked(&rq->lock);
 
+	if (!rq->rt.overloaded)
+		return 0;
+
 	next_task = pick_next_highest_task_rt(rq, -1);
 	if (!next_task)
 		return 0;
@@ -676,7 +681,7 @@ static void schedule_tail_balance_rt(str
 	 * the lock was owned by prev, we need to release it
 	 * first via finish_lock_switch and then reaquire it here.
 	 */
-	if (unlikely(rq->rt.rt_nr_running > 1)) {
+	if (unlikely(rq->rt.overloaded)) {
 		spin_lock_irq(&rq->lock);
 		push_rt_tasks(rq);
 		spin_unlock_irq(&rq->lock);
@@ -688,7 +693,8 @@ static void wakeup_balance_rt(struct rq 
 {
 	if (unlikely(rt_task(p)) &&
 	    !task_running(rq, p) &&
-	    (p->prio >= rq->curr->prio))
+	    (p->prio >= rq->rt.highest_prio) &&
+	    rq->rt.overloaded)
 		push_rt_tasks(rq);
 }
 

-- 
