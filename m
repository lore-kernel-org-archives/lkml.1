Return-Path: <linux-kernel-owner+w=401wt.eu-S1757973AbZCYEKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973AbZCYEKV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 00:10:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753369AbZCYEIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 00:08:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:32854 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbZCYEIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 00:08:36 -0400
Message-Id: <20090325040833.213388591@goodmis.org>
References: <20090325035646.662994901@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 24 Mar 2009 23:56:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tim Bird <tim.bird@am.sony.com>, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 5/5][RFC] function-graph: add option to calculate graph time or not
Content-Disposition: inline; filename=0005-function-graph-add-option-to-calculate-graph-time-o.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

graph time is the time that a function is executing another function.
Thus if function A calls B, if graph-time is set, then the time for
A includes B. This is the default behavior. But if graph-time is off,
then the time spent executing B is subtracted from A.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/ftrace.h               |    3 +--
 kernel/trace/ftrace.c                |   21 ++++++++++++++++++++-
 kernel/trace/trace.c                 |    4 +++-
 kernel/trace/trace.h                 |    1 +
 kernel/trace/trace_functions_graph.c |    8 ++++----
 5 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 015a3d2..9e0a8d2 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -365,6 +365,7 @@ struct ftrace_ret_stack {
 	unsigned long ret;
 	unsigned long func;
 	unsigned long long calltime;
+	unsigned long long subtime;
 };
 
 /*
@@ -376,8 +377,6 @@ extern void return_to_handler(void);
 
 extern int
 ftrace_push_return_trace(unsigned long ret, unsigned long func, int *depth);
-extern void
-ftrace_pop_return_trace(struct ftrace_graph_ret *trace, unsigned long *ret);
 
 /*
  * Sometimes we don't want to trace a function with the function
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index ed1fc50..71e5fae 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -604,6 +604,7 @@ static int profile_graph_entry(struct ftrace_graph_ent *trace)
 static void profile_graph_return(struct ftrace_graph_ret *trace)
 {
 	struct ftrace_profile_stat *stat;
+	unsigned long long calltime;
 	struct ftrace_profile *rec;
 	unsigned long flags;
 
@@ -612,9 +613,27 @@ static void profile_graph_return(struct ftrace_graph_ret *trace)
 	if (!stat->hash)
 		goto out;
 
+	calltime = trace->rettime - trace->calltime;
+
+	if (!(trace_flags & TRACE_ITER_GRAPH_TIME)) {
+		int index;
+
+		index = trace->depth;
+
+		/* Append this call time to the parent time to subtract */
+		if (index)
+			current->ret_stack[index - 1].subtime += calltime;
+
+		if (current->ret_stack[index].subtime < calltime)
+			calltime -= current->ret_stack[index].subtime;
+		else
+			calltime = 0;
+	}
+
 	rec = ftrace_find_profiled_func(stat, trace->func);
 	if (rec)
-		rec->time += trace->rettime - trace->calltime;
+		rec->time += calltime;
+
  out:
 	local_irq_restore(flags);
 }
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 821bf49..5d1a16c 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -255,7 +255,8 @@ static DECLARE_WAIT_QUEUE_HEAD(trace_wait);
 
 /* trace_flags holds trace_options default values */
 unsigned long trace_flags = TRACE_ITER_PRINT_PARENT | TRACE_ITER_PRINTK |
-	TRACE_ITER_ANNOTATE | TRACE_ITER_CONTEXT_INFO | TRACE_ITER_SLEEP_TIME;
+	TRACE_ITER_ANNOTATE | TRACE_ITER_CONTEXT_INFO | TRACE_ITER_SLEEP_TIME |
+	TRACE_ITER_GRAPH_TIME;
 
 /**
  * trace_wake_up - wake up tasks waiting for trace input
@@ -317,6 +318,7 @@ static const char *trace_options[] = {
 	"latency-format",
 	"global-clock",
 	"sleep-time",
+	"graph-time",
 	NULL
 };
 
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index c66ca3b..e3429a8 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -685,6 +685,7 @@ enum trace_iterator_flags {
 	TRACE_ITER_LATENCY_FMT		= 0x40000,
 	TRACE_ITER_GLOBAL_CLK		= 0x80000,
 	TRACE_ITER_SLEEP_TIME		= 0x100000,
+	TRACE_ITER_GRAPH_TIME		= 0x200000,
 };
 
 /*
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 85bba0f..10f6ad7 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -78,13 +78,14 @@ ftrace_push_return_trace(unsigned long ret, unsigned long func, int *depth)
 	current->ret_stack[index].ret = ret;
 	current->ret_stack[index].func = func;
 	current->ret_stack[index].calltime = calltime;
+	current->ret_stack[index].subtime = 0;
 	*depth = index;
 
 	return 0;
 }
 
 /* Retrieve a function return address to the trace stack on thread info.*/
-void
+static void
 ftrace_pop_return_trace(struct ftrace_graph_ret *trace, unsigned long *ret)
 {
 	int index;
@@ -104,9 +105,6 @@ ftrace_pop_return_trace(struct ftrace_graph_ret *trace, unsigned long *ret)
 	trace->calltime = current->ret_stack[index].calltime;
 	trace->overrun = atomic_read(&current->trace_overrun);
 	trace->depth = index;
-	barrier();
-	current->curr_ret_stack--;
-
 }
 
 /*
@@ -121,6 +119,8 @@ unsigned long ftrace_return_to_handler(void)
 	ftrace_pop_return_trace(&trace, &ret);
 	trace.rettime = trace_clock_local();
 	ftrace_graph_return(&trace);
+	barrier();
+	current->curr_ret_stack--;
 
 	if (unlikely(!ret)) {
 		ftrace_graph_stop();
-- 
1.6.2

-- 
