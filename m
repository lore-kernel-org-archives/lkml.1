Return-Path: <linux-kernel-owner+w=401wt.eu-S935664AbXKQGat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935664AbXKQGat (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 01:30:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762884AbXKQGYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 01:24:50 -0500
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:51464 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759423AbXKQGYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 01:24:41 -0500
Message-Id: <20071117062403.382523660@goodmis.org>
References: <20071117062104.177779113@goodmis.org>
User-Agent: quilt/0.46-1
Date: Sat, 17 Nov 2007 01:21:06 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@sgi.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH v3 02/17] track highest prio queued on runqueue
Content-Disposition: inline; filename=add-rq-highest-prio.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds accounting to each runqueue to keep track of the
highest prio task queued on the run queue. We only care about
RT tasks, so if the run queue does not contain any active RT tasks
its priority will be considered MAX_RT_PRIO.

This information will be used for later patches.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>

---
 kernel/sched.c    |    3 +++
 kernel/sched_rt.c |   18 ++++++++++++++++++
 2 files changed, 21 insertions(+)

Index: linux-compile.git/kernel/sched.c
===================================================================
--- linux-compile.git.orig/kernel/sched.c	2007-11-16 21:55:20.000000000 -0500
+++ linux-compile.git/kernel/sched.c	2007-11-16 21:55:34.000000000 -0500
@@ -267,6 +267,8 @@ struct rt_rq {
 	int rt_load_balance_idx;
 	struct list_head *rt_load_balance_head, *rt_load_balance_curr;
 	unsigned long rt_nr_running;
+	/* highest queued rt task prio */
+	int highest_prio;
 };
 
 /*
@@ -6776,6 +6778,7 @@ void __init sched_init(void)
 		rq->cpu = i;
 		rq->migration_thread = NULL;
 		INIT_LIST_HEAD(&rq->migration_queue);
+		rq->rt.highest_prio = MAX_RT_PRIO;
 #endif
 		atomic_set(&rq->nr_iowait, 0);
 
Index: linux-compile.git/kernel/sched_rt.c
===================================================================
--- linux-compile.git.orig/kernel/sched_rt.c	2007-11-16 21:55:20.000000000 -0500
+++ linux-compile.git/kernel/sched_rt.c	2007-11-16 21:55:34.000000000 -0500
@@ -29,6 +29,10 @@ static inline void inc_rt_tasks(struct t
 {
 	WARN_ON(!rt_task(p));
 	rq->rt.rt_nr_running++;
+#ifdef CONFIG_SMP
+	if (p->prio < rq->rt.highest_prio)
+		rq->rt.highest_prio = p->prio;
+#endif /* CONFIG_SMP */
 }
 
 static inline void dec_rt_tasks(struct task_struct *p, struct rq *rq)
@@ -36,6 +40,20 @@ static inline void dec_rt_tasks(struct t
 	WARN_ON(!rt_task(p));
 	WARN_ON(!rq->rt.rt_nr_running);
 	rq->rt.rt_nr_running--;
+#ifdef CONFIG_SMP
+	if (rq->rt.rt_nr_running) {
+		struct rt_prio_array *array;
+
+		WARN_ON(p->prio < rq->rt.highest_prio);
+		if (p->prio == rq->rt.highest_prio) {
+			/* recalculate */
+			array = &rq->rt.active;
+			rq->rt.highest_prio =
+				sched_find_first_bit(array->bitmap);
+		} /* otherwise leave rq->highest prio alone */
+	} else
+		rq->rt.highest_prio = MAX_RT_PRIO;
+#endif /* CONFIG_SMP */
 }
 
 static void enqueue_task_rt(struct rq *rq, struct task_struct *p, int wakeup)

-- 
