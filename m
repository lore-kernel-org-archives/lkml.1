Return-Path: <linux-kernel-owner+w=401wt.eu-S1758134AbYBJHVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134AbYBJHVE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 02:21:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756961AbYBJHUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 02:20:15 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35381 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756815AbYBJHUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 02:20:13 -0500
Date: Sun, 10 Feb 2008 08:20:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Steven Rostedt <rostedt@goodmis.org>
Subject: [02/19] sched: add latency tracer callbacks to the scheduler
Message-ID: <20080210071959.GC4100@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>

add 3 lightweight callbacks to the tracer backend.

zero impact if tracing is turned off.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h |   26 ++++++++++++++++++++++++++
 kernel/sched.c        |    3 +++
 2 files changed, 29 insertions(+)

Index: linux/include/linux/sched.h
===================================================================
--- linux.orig/include/linux/sched.h
+++ linux/include/linux/sched.h
@@ -2027,6 +2027,32 @@ extern int sched_mc_power_savings, sched
 
 extern void normalize_rt_tasks(void);
 
+#ifdef CONFIG_CONTEXT_SWITCH_TRACER
+extern void
+ftrace_ctx_switch(struct task_struct *prev, struct task_struct *next);
+#else
+static inline void
+ftrace_ctx_switch(struct task_struct *prev, struct task_struct *next)
+{
+}
+#endif
+
+#ifdef CONFIG_SCHED_TRACER
+extern void
+ftrace_wake_up_task(struct task_struct *wakee, struct task_struct *curr);
+extern void
+ftrace_wake_up_new_task(struct task_struct *wakee, struct task_struct *curr);
+#else
+static inline void
+ftrace_wake_up_task(struct task_struct *wakee, struct task_struct *curr)
+{
+}
+static inline void
+ftrace_wake_up_new_task(struct task_struct *wakee, struct task_struct *curr)
+{
+}
+#endif
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
 
 extern struct task_group init_task_group;
Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -1867,6 +1867,7 @@ static int try_to_wake_up(struct task_st
 
 out_activate:
 #endif /* CONFIG_SMP */
+	ftrace_wake_up_task(p, rq->curr);
 	schedstat_inc(p, se.nr_wakeups);
 	if (sync)
 		schedstat_inc(p, se.nr_wakeups_sync);
@@ -2007,6 +2008,7 @@ void wake_up_new_task(struct task_struct
 		p->sched_class->task_new(rq, p);
 		inc_nr_running(rq);
 	}
+	ftrace_wake_up_new_task(p, rq->curr);
 	check_preempt_curr(rq, p);
 #ifdef CONFIG_SMP
 	if (p->sched_class->task_wake_up)
@@ -2179,6 +2181,7 @@ context_switch(struct rq *rq, struct tas
 	struct mm_struct *mm, *oldmm;
 
 	prepare_task_switch(rq, prev, next);
+	ftrace_ctx_switch(prev, next);
 	mm = next->mm;
 	oldmm = prev->active_mm;
 	/*
