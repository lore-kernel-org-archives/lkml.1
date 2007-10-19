Return-Path: <linux-kernel-owner+w=401wt.eu-S935397AbXJSSoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935397AbXJSSoc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 14:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760406AbXJSSoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 14:44:16 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:57008 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758773AbXJSSoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 14:44:15 -0400
Message-Id: <20071019184337.146601417@goodmis.org>
References: <20071019184254.456160632@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 19 Oct 2007 14:43:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [patch 7/8] wake up balance RT
Content-Disposition: inline; filename=rt-balance-wakeup.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds pushing of overloaded RT tasks from a runqueue that is
having tasks (most likely RT tasks) added to the run queue.

TODO: We don't cover the case of waking of new RT tasks (yet).

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/sched.c    |    1 +
 kernel/sched_rt.c |   12 ++++++++++++
 2 files changed, 13 insertions(+)

Index: linux-test.git/kernel/sched_rt.c
===================================================================
--- linux-test.git.orig/kernel/sched_rt.c	2007-10-19 12:36:05.000000000 -0400
+++ linux-test.git/kernel/sched_rt.c	2007-10-19 12:36:07.000000000 -0400
@@ -512,9 +512,21 @@ static void schedule_tail_balance_rt(str
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
 # define schedule_balance_rt(rq)	do { } while (0)
 # define schedule_tail_balance_rt(rq)	do { } while (0)
+# define wakeup_balance_rt(rq, p)	do { } while (0)
 #endif /* CONFIG_SMP */
 
 static void put_prev_task_rt(struct rq *rq, struct task_struct *p)
Index: linux-test.git/kernel/sched.c
===================================================================
--- linux-test.git.orig/kernel/sched.c	2007-10-19 12:36:05.000000000 -0400
+++ linux-test.git/kernel/sched.c	2007-10-19 12:36:07.000000000 -0400
@@ -1609,6 +1609,7 @@ out_activate:
 	update_rq_clock(rq);
 	activate_task(rq, p, 1);
 	check_preempt_curr(rq, p);
+	wakeup_balance_rt(rq, p);
 	success = 1;
 
 out_running:

-- 
