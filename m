Return-Path: <linux-kernel-owner+w=401wt.eu-S936416AbXJSSp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936416AbXJSSp7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 14:45:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765935AbXJSSoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 14:44:21 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:57094 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765900AbXJSSoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 14:44:19 -0400
Message-Id: <20071019184336.669654901@goodmis.org>
References: <20071019184254.456160632@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 19 Oct 2007 14:42:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [patch 4/8] RT overloaded runqueues accounting
Content-Disposition: inline; filename=rt-overload.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an RT overload accounting system. When a runqueue has
more than one RT task queued, it is marked as overloaded. That is that it
is a candidate to have RT tasks pulled from it.

Along with the rt_overload counter (number of overloaded runqueues) a
bit mask of overloaded runqueues with RT tasks is set.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/sched_rt.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

Index: linux-test.git/kernel/sched_rt.c
===================================================================
--- linux-test.git.orig/kernel/sched_rt.c	2007-10-19 12:34:46.000000000 -0400
+++ linux-test.git/kernel/sched_rt.c	2007-10-19 12:35:58.000000000 -0400
@@ -25,10 +25,23 @@ static void update_curr_rt(struct rq *rq
 	curr->se.exec_start = rq->clock;
 }
 
+#ifdef CONFIG_SMP
+static __cacheline_aligned_in_smp atomic_t rt_overload;
+static cpumask_t rto_cpumask;
+#endif /* CONFIG_SMP*/
+
 static inline void inc_rt_tasks(struct task_struct *p, struct rq *rq)
 {
 	if (rt_task(p))
 		rq->rt_nr_running++;
+#ifdef CONFIG_SMP
+	if (rq->rt_nr_running == 2) {
+		cpu_set(rq->cpu, rto_cpumask);
+		/* Make sure this cpu is visible on rt_overloads */
+		smp_wmb();
+		atomic_inc(&rt_overload);
+	}
+#endif
 }
 
 static inline void dec_rt_tasks(struct task_struct *p, struct rq *rq)
@@ -37,6 +50,12 @@ static inline void dec_rt_tasks(struct t
 		WARN_ON(!rq->rt_nr_running);
 		rq->rt_nr_running--;
 	}
+#ifdef CONFIG_SMP
+	if (rq->rt_nr_running == 1) {
+		atomic_dec(&rt_overload);
+		cpu_clear(rq->cpu, rto_cpumask);
+	}
+#endif
 }
 
 static void enqueue_task_rt(struct rq *rq, struct task_struct *p, int wakeup)

-- 
