Return-Path: <linux-kernel-owner+w=401wt.eu-S936296AbXJSSoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936296AbXJSSoy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 14:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765762AbXJSSoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 14:44:17 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:32796 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758913AbXJSSoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 14:44:15 -0400
Message-Id: <20071019184336.195447315@goodmis.org>
References: <20071019184254.456160632@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 19 Oct 2007 14:42:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [patch 1/8] Add rt_nr_running accounting
Content-Disposition: inline; filename=count-rt-queued.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds accounting to keep track of the number of RT tasks running
on a runqueue. This information will be used in later patches.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

---
 kernel/sched.c    |    2 ++
 kernel/sched_rt.c |   18 ++++++++++++++++++
 2 files changed, 20 insertions(+)

Index: linux-test.git/kernel/sched.c
===================================================================
--- linux-test.git.orig/kernel/sched.c	2007-10-19 12:32:39.000000000 -0400
+++ linux-test.git/kernel/sched.c	2007-10-19 12:33:09.000000000 -0400
@@ -300,6 +300,8 @@ struct rq {
 	 */
 	unsigned long nr_uninterruptible;
 
+	unsigned long rt_nr_running;
+
 	struct task_struct *curr, *idle;
 	unsigned long next_balance;
 	struct mm_struct *prev_mm;
Index: linux-test.git/kernel/sched_rt.c
===================================================================
--- linux-test.git.orig/kernel/sched_rt.c	2007-10-19 12:31:08.000000000 -0400
+++ linux-test.git/kernel/sched_rt.c	2007-10-19 12:33:09.000000000 -0400
@@ -25,12 +25,28 @@ static void update_curr_rt(struct rq *rq
 	curr->se.exec_start = rq->clock;
 }
 
+static inline void inc_rt_tasks(struct task_struct *p, struct rq *rq)
+{
+	if (rt_task(p))
+		rq->rt_nr_running++;
+}
+
+static inline void dec_rt_tasks(struct task_struct *p, struct rq *rq)
+{
+	if (rt_task(p)) {
+		WARN_ON(!rq->rt_nr_running);
+		rq->rt_nr_running--;
+	}
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
@@ -42,6 +58,8 @@ static void dequeue_task_rt(struct rq *r
 
 	update_curr_rt(rq);
 
+	dec_rt_tasks(p, rq);
+
 	list_del(&p->run_list);
 	if (list_empty(array->queue + p->prio))
 		__clear_bit(p->prio, array->bitmap);

-- 
