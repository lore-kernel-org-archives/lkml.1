Return-Path: <linux-kernel-owner+w=401wt.eu-S1764043AbXKUBSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764043AbXKUBSb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 20:18:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757360AbXKUBN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 20:13:57 -0500
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:61521 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765395AbXKUBNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 20:13:50 -0500
Message-Id: <20071121011251.260288347@goodmis.org>
References: <20071121010054.663842380@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 20 Nov 2007 20:01:09 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@sgi.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH v4 15/20] RT: Optimize rebalancing
Content-Disposition: inline; filename=sched-wake-balance-fixes.patch
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
--- linux-compile.git.orig/kernel/sched.c	2007-11-20 19:53:09.000000000 -0500
+++ linux-compile.git/kernel/sched.c	2007-11-20 19:53:10.000000000 -0500
@@ -273,6 +273,7 @@ struct rt_rq {
 	unsigned long rt_nr_migratory;
 	/* highest queued rt task prio */
 	int highest_prio;
+	int overloaded;
 };
 
 /*
@@ -6685,6 +6686,7 @@ void __init sched_init(void)
 		rq->migration_thread = NULL;
 		INIT_LIST_HEAD(&rq->migration_queue);
 		rq->rt.highest_prio = MAX_RT_PRIO;
+		rq->rt.overloaded = 0;
 #endif
 		atomic_set(&rq->nr_iowait, 0);
 
Index: linux-compile.git/kernel/sched_rt.c
===================================================================
--- linux-compile.git.orig/kernel/sched_rt.c	2007-11-20 19:53:09.000000000 -0500
+++ linux-compile.git/kernel/sched_rt.c	2007-11-20 19:53:10.000000000 -0500
@@ -16,6 +16,7 @@ static inline cpumask_t *rt_overload(voi
 }
 static inline void rt_set_overload(struct rq *rq)
 {
+	rq->rt.overloaded = 1;
 	cpu_set(rq->cpu, rt_overload_mask);
 	/*
 	 * Make sure the mask is visible before we set
@@ -32,6 +33,7 @@ static inline void rt_clear_overload(str
 	/* the order here really doesn't matter */
 	atomic_dec(&rto_count);
 	cpu_clear(rq->cpu, rt_overload_mask);
+	rq->rt.overloaded = 0;
 }
 
 static void update_rt_migration(struct rq *rq)
@@ -445,6 +447,9 @@ static int push_rt_task(struct rq *rq)
 
 	assert_spin_locked(&rq->lock);
 
+	if (!rq->rt.overloaded)
+		return 0;
+
 	next_task = pick_next_highest_task_rt(rq, -1);
 	if (!next_task)
 		return 0;
@@ -672,7 +677,7 @@ static void schedule_tail_balance_rt(str
 	 * the lock was owned by prev, we need to release it
 	 * first via finish_lock_switch and then reaquire it here.
 	 */
-	if (unlikely(rq->rt.rt_nr_running > 1)) {
+	if (unlikely(rq->rt.overloaded)) {
 		spin_lock_irq(&rq->lock);
 		push_rt_tasks(rq);
 		spin_unlock_irq(&rq->lock);
@@ -684,7 +689,8 @@ static void wakeup_balance_rt(struct rq 
 {
 	if (unlikely(rt_task(p)) &&
 	    !task_running(rq, p) &&
-	    (p->prio >= rq->curr->prio))
+	    (p->prio >= rq->rt.highest_prio) &&
+	    rq->rt.overloaded)
 		push_rt_tasks(rq);
 }
 

-- 
