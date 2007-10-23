Return-Path: <linux-kernel-owner+w=401wt.eu-S1754178AbXJWDaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178AbXJWDaf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 23:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752181AbXJWD3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 23:29:41 -0400
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:50303 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbXJWD3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 23:29:37 -0400
Message-Id: <20071023032916.963188616@goodmis.org>
References: <20071023025900.927578809@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 22 Oct 2007 22:59:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Paul Jackson <pj@sgi.com>, Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH -v2 6/7] wake up balance RT
Content-Disposition: inline; filename=rt-balance-wakeup.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds pushing of overloaded RT tasks from a runqueue that is
having tasks (most likely RT tasks) added to the run queue.

TODO: We don't cover the case of waking of new RT tasks (yet).

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/sched.c    |    2 ++
 kernel/sched_rt.c |   12 ++++++++++++
 2 files changed, 14 insertions(+)

Index: linux-test.git/kernel/sched_rt.c
===================================================================
--- linux-test.git.orig/kernel/sched_rt.c	2007-10-22 22:37:28.000000000 -0400
+++ linux-test.git/kernel/sched_rt.c	2007-10-22 22:38:04.000000000 -0400
@@ -559,9 +559,21 @@ static void schedule_tail_balance_rt(str
 		spin_unlock_irq(&rq->lock);
 	}
 }
+
+static void wakeup_balance_rt(struct rq *rq, struct task_struct *p)
+{
+	if (unlikely(rt_task(p)) &&
+	    (p->prio >= rq->curr->prio)) {
+		/* pull_rt_task needs task to be running */
+		p->state = TASK_RUNNING;
+		push_rt_tasks(rq);
+	}
+}
+
 #else /* CONFIG_SMP */
 # define schedule_tail_balance_rt(rq)	do { } while (0)
 # define schedule_balance_rt(rq)	do { } while (0)
+# define wakeup_balance_rt(rq, p)	do { } while (0)
 #endif /* CONFIG_SMP */
 
 
Index: linux-test.git/kernel/sched.c
===================================================================
--- linux-test.git.orig/kernel/sched.c	2007-10-22 22:37:28.000000000 -0400
+++ linux-test.git/kernel/sched.c	2007-10-22 22:38:04.000000000 -0400
@@ -22,6 +22,7 @@
  *              by Peter Williams
  *  2007-05-06  Interactivity improvements to CFS by Mike Galbraith
  *  2007-07-01  Group scheduling enhancements by Srivatsa Vaddagiri
+ *  2007-10-22  RT overload balancing by Steven Rostedt
  */
 
 #include <linux/mm.h>
@@ -1614,6 +1615,7 @@ out_activate:
 	update_rq_clock(rq);
 	activate_task(rq, p, 1);
 	check_preempt_curr(rq, p);
+	wakeup_balance_rt(rq, p);
 	success = 1;
 
 out_running:

-- 
