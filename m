Return-Path: <linux-kernel-owner+w=401wt.eu-S1751401AbXKQG2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751401AbXKQG2o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 01:28:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760933AbXKQGYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 01:24:44 -0500
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:38171 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759006AbXKQGYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 01:24:40 -0500
Message-Id: <20071117062403.217588003@goodmis.org>
References: <20071117062104.177779113@goodmis.org>
User-Agent: quilt/0.46-1
Date: Sat, 17 Nov 2007 01:21:05 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@sgi.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH v3 01/17] Add rt_nr_running accounting
Content-Disposition: inline; filename=count-rt-queued.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds accounting to keep track of the number of RT tasks running
on a runqueue. This information will be used in later patches.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>

---
 kernel/sched.c    |    1 +
 kernel/sched_rt.c |   17 +++++++++++++++++
 2 files changed, 18 insertions(+)

Index: linux-compile.git/kernel/sched.c
===================================================================
--- linux-compile.git.orig/kernel/sched.c	2007-11-16 11:16:38.000000000 -0500
+++ linux-compile.git/kernel/sched.c	2007-11-16 21:48:48.000000000 -0500
@@ -266,6 +266,7 @@ struct rt_rq {
 	struct rt_prio_array active;
 	int rt_load_balance_idx;
 	struct list_head *rt_load_balance_head, *rt_load_balance_curr;
+	unsigned long rt_nr_running;
 };
 
 /*
Index: linux-compile.git/kernel/sched_rt.c
===================================================================
--- linux-compile.git.orig/kernel/sched_rt.c	2007-11-16 11:15:56.000000000 -0500
+++ linux-compile.git/kernel/sched_rt.c	2007-11-16 21:48:48.000000000 -0500
@@ -25,12 +25,27 @@ static void update_curr_rt(struct rq *rq
 	curr->se.exec_start = rq->clock;
 }
 
+static inline void inc_rt_tasks(struct task_struct *p, struct rq *rq)
+{
+	WARN_ON(!rt_task(p));
+	rq->rt.rt_nr_running++;
+}
+
+static inline void dec_rt_tasks(struct task_struct *p, struct rq *rq)
+{
+	WARN_ON(!rt_task(p));
+	WARN_ON(!rq->rt.rt_nr_running);
+	rq->rt.rt_nr_running--;
+}
+
 static void enqueue_task_rt(struct rq *rq, struct task_struct *p, int wakeup)
 {
 	struct rt_prio_array *array = &rq->rt.active;
 
 	list_add_tail(&p->run_list, array->queue + p->prio);
 	__set_bit(p->prio, array->bitmap);
+
+	inc_rt_tasks(p, rq);
 }
 
 /*
@@ -45,6 +60,8 @@ static void dequeue_task_rt(struct rq *r
 	list_del(&p->run_list);
 	if (list_empty(array->queue + p->prio))
 		__clear_bit(p->prio, array->bitmap);
+
+	dec_rt_tasks(p, rq);
 }
 
 /*

-- 
