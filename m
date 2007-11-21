Return-Path: <linux-kernel-owner+w=401wt.eu-S1765680AbXKUBPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765680AbXKUBPo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 20:15:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756416AbXKUBNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 20:13:48 -0500
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:59819 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762937AbXKUBNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 20:13:46 -0500
Message-Id: <20071121011249.817096909@goodmis.org>
References: <20071121010054.663842380@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 20 Nov 2007 20:01:00 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@sgi.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH v4 06/20] wake up balance RT
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

Index: linux-compile.git/kernel/sched.c
===================================================================
--- linux-compile.git.orig/kernel/sched.c	2007-11-20 19:52:59.000000000 -0500
+++ linux-compile.git/kernel/sched.c	2007-11-20 19:53:00.000000000 -0500
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
 
Index: linux-compile.git/kernel/sched_rt.c
===================================================================
--- linux-compile.git.orig/kernel/sched_rt.c	2007-11-20 19:52:59.000000000 -0500
+++ linux-compile.git/kernel/sched_rt.c	2007-11-20 19:53:00.000000000 -0500
@@ -555,6 +555,15 @@ static void schedule_tail_balance_rt(str
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
@@ -662,6 +671,7 @@ move_one_task_rt(struct rq *this_rq, int
 #else /* CONFIG_SMP */
 # define schedule_tail_balance_rt(rq)	do { } while (0)
 # define schedule_balance_rt(rq, prev)	do { } while (0)
+# define wakeup_balance_rt(rq, p)	do { } while (0)
 #endif /* CONFIG_SMP */
 
 static void task_tick_rt(struct rq *rq, struct task_struct *p)

-- 
