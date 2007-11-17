Return-Path: <linux-kernel-owner+w=401wt.eu-S932363AbXKQG0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932363AbXKQG0p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 01:26:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758267AbXKQGYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 01:24:38 -0500
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:51406 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756665AbXKQGYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 01:24:35 -0500
Message-Id: <20071117062404.021808553@goodmis.org>
References: <20071117062104.177779113@goodmis.org>
User-Agent: quilt/0.46-1
Date: Sat, 17 Nov 2007 01:21:10 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@sgi.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH v3 06/17] wake up balance RT
Content-Disposition: inline; filename=rt-balance-wakeup.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds pushing of overloaded RT tasks from a runqueue that is
having tasks (most likely RT tasks) added to the run queue.

TODO: We don't cover the case of waking of new RT tasks (yet).

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/sched.c    |    3 +++
 kernel/sched_rt.c |   10 ++++++++++
 2 files changed, 13 insertions(+)

Index: linux-compile.git/kernel/sched_rt.c
===================================================================
--- linux-compile.git.orig/kernel/sched_rt.c	2007-11-16 22:12:13.000000000 -0500
+++ linux-compile.git/kernel/sched_rt.c	2007-11-16 22:12:17.000000000 -0500
@@ -562,6 +562,15 @@ static void schedule_tail_balance_rt(str
 	}
 }
 
+
+static void wakeup_balance_rt(struct rq *rq, struct task_struct *p)
+{
+	if (unlikely(rt_task(p)) &&
+	    !task_running(rq, p) &&
+	    (p->prio >= rq->curr->prio))
+		push_rt_tasks(rq);
+}
+
 /*
  * Load-balancing iterator. Note: while the runqueue stays locked
  * during the whole iteration, the current task might be
@@ -669,6 +678,7 @@ move_one_task_rt(struct rq *this_rq, int
 #else /* CONFIG_SMP */
 # define schedule_tail_balance_rt(rq)	do { } while (0)
 # define schedule_balance_rt(rq, prev)	do { } while (0)
+# define wakeup_balance_rt(rq, p)	do { } while (0)
 #endif /* CONFIG_SMP */
 
 static void task_tick_rt(struct rq *rq, struct task_struct *p)
Index: linux-compile.git/kernel/sched.c
===================================================================
--- linux-compile.git.orig/kernel/sched.c	2007-11-16 22:12:13.000000000 -0500
+++ linux-compile.git/kernel/sched.c	2007-11-16 22:12:17.000000000 -0500
@@ -22,6 +22,8 @@
  *              by Peter Williams
  *  2007-05-06  Interactivity improvements to CFS by Mike Galbraith
  *  2007-07-01  Group scheduling enhancements by Srivatsa Vaddagiri
+ *  2007-10-22  RT overload balancing by Steven Rostedt
+ *                 (with thanks to Gregory Haskins)
  */
 
 #include <linux/mm.h>
@@ -1635,6 +1637,7 @@ out_activate:
 
 out_running:
 	p->state = TASK_RUNNING;
+	wakeup_balance_rt(rq, p);
 out:
 	task_rq_unlock(rq, &flags);
 

-- 
