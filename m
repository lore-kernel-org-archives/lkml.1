Return-Path: <linux-kernel-owner+w=401wt.eu-S1756176AbYGYWDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176AbYGYWDp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 18:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751925AbYGYWDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 18:03:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:35828 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbYGYWDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 18:03:36 -0400
Message-Id: <20080725220334.781928198@goodmis.org>
References: <20080725220040.911370182@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 25 Jul 2008 18:00:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>
Cc: Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/2] ftrace: single CPU tracers use CPU clock
Content-Disposition: inline; filename=ftrace-local-cpu-clock-use.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current ftrace clock uses the sched_clock.c code. This code tries
to handle cases where the TSC is out of sync between different CPUs.
Unfortunately, even with insync TSCs, due to drifts between the CPU clock
and the GTOD clock, we might get some inaccuracy in a single CPU trace.

Some tracers (irqsoff, preemptoff, preempirqsoff) only care about a trace
on a single CPU. This patch changes the ftrace_now (the clock reader) from
a function call to a function variable. On initialization of a tracer,
the tracer will be allowed to choose which type of clock to use.

Now the irqsoff, preemptoff and preemptirqs off tracers can have accurate traces
with the local CPU clock without affecting the tracers that want the
modified clock that tries to keep the different CPU clock reads in sync.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>

---
 kernel/trace/trace.c         |   15 ++++++++++++++-
 kernel/trace/trace.h         |    3 ++-
 kernel/trace/trace_irqsoff.c |    3 +++
 3 files changed, 19 insertions(+), 2 deletions(-)

Index: linux-tip.git/kernel/trace/trace.c
===================================================================
--- linux-tip.git.orig/kernel/trace/trace.c	2008-07-25 17:55:49.000000000 -0400
+++ linux-tip.git/kernel/trace/trace.c	2008-07-25 17:55:50.000000000 -0400
@@ -58,11 +58,18 @@ ns2usecs(cycle_t nsec)
 	return nsec;
 }
 
-cycle_t ftrace_now(int cpu)
+static cycle_t trace_local_now(int cpu)
+{
+	return sched_clock();
+}
+
+static cycle_t trace_global_now(int cpu)
 {
 	return cpu_clock(cpu);
 }
 
+cycle_t (*ftrace_now)(int cpu) = trace_global_now;
+
 /*
  * The global_trace is the descriptor that holds the tracing
  * buffers for the live tracing. For each CPU, it contains
@@ -2378,6 +2385,12 @@ tracing_set_trace_write(struct file *fil
 		current_trace->reset(tr);
 
 	current_trace = t;
+
+	if (t->local_now)
+		ftrace_now = trace_local_now;
+	else
+		ftrace_now = trace_global_now;
+
 	if (t->init)
 		t->init(tr);
 
Index: linux-tip.git/kernel/trace/trace.h
===================================================================
--- linux-tip.git.orig/kernel/trace/trace.h	2008-07-25 17:55:49.000000000 -0400
+++ linux-tip.git/kernel/trace/trace.h	2008-07-25 17:55:50.000000000 -0400
@@ -155,6 +155,7 @@ struct tracer {
 	int			(*print_line)(struct trace_iterator *iter);
 	struct tracer		*next;
 	int			print_max;
+	int			local_now;
 };
 
 struct trace_seq {
@@ -237,7 +238,7 @@ void update_max_tr(struct trace_array *t
 void update_max_tr_single(struct trace_array *tr,
 			  struct task_struct *tsk, int cpu);
 
-extern cycle_t ftrace_now(int cpu);
+extern cycle_t (*ftrace_now)(int cpu);
 
 #ifdef CONFIG_FTRACE
 void tracing_start_function_trace(void);
Index: linux-tip.git/kernel/trace/trace_irqsoff.c
===================================================================
--- linux-tip.git.orig/kernel/trace/trace_irqsoff.c	2008-07-25 17:55:49.000000000 -0400
+++ linux-tip.git/kernel/trace/trace_irqsoff.c	2008-07-25 17:55:50.000000000 -0400
@@ -413,6 +413,7 @@ static struct tracer irqsoff_tracer __re
 	.close		= irqsoff_tracer_close,
 	.ctrl_update	= irqsoff_tracer_ctrl_update,
 	.print_max	= 1,
+	.local_now	= 1,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    = trace_selftest_startup_irqsoff,
 #endif
@@ -439,6 +440,7 @@ static struct tracer preemptoff_tracer _
 	.close		= irqsoff_tracer_close,
 	.ctrl_update	= irqsoff_tracer_ctrl_update,
 	.print_max	= 1,
+	.local_now	= 1,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    = trace_selftest_startup_preemptoff,
 #endif
@@ -467,6 +469,7 @@ static struct tracer preemptirqsoff_trac
 	.close		= irqsoff_tracer_close,
 	.ctrl_update	= irqsoff_tracer_ctrl_update,
 	.print_max	= 1,
+	.local_now	= 1,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    = trace_selftest_startup_preemptirqsoff,
 #endif

-- 
