Return-Path: <linux-kernel-owner+w=401wt.eu-S1754346AbZIKPR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346AbZIKPR1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 11:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754248AbZIKPR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 11:17:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:50422 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbZIKPRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 11:17:16 -0400
Message-Id: <20090911151719.109982729@goodmis.org>
References: <20090911151544.006804282@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 11 Sep 2009 11:15:46 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>
Subject: [PATCH 2/2] tracing: add latency format to function_graph tracer
Content-Disposition: inline; filename=0002-tracing-add-latency-format-to-function_graph-tracer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

While debugging something with the function_graph tracer, I found the
need to see the preempt count of the traces. Unfortunately, since
the function graph tracer has its own output formatting, it does not
honor the latency-format option.

This patch makes the function_graph tracer honor the latency-format
option, but still keeps control of the output. But now we have the
same details that the latency-format supplies.

 # tracer: function_graph
 #
 #      _-----=> irqs-off
 #     / _----=> need-resched
 #    | / _---=> hardirq/softirq
 #    || / _--=> preempt-depth
 #    ||| /
 #    ||||
 # CPU||||  DURATION                  FUNCTION CALLS
 # |  ||||   |   |                     |   |   |   |
  3)  d..1  1.333 us    |        idle_cpu();
  3)  d.h1              |        tick_check_idle() {
  3)  d.h1  0.550 us    |          tick_check_oneshot_broadcast();
  3)  d.h1              |          tick_nohz_stop_idle() {
  3)  d.h1              |            ktime_get() {
  3)  d.h1              |              ktime_get_ts() {

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_functions_graph.c |   74 +++++++++++++++++++++++++++++++---
 1 files changed, 68 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index b3749a2..ee791a9 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -364,6 +364,29 @@ print_graph_proc(struct trace_seq *s, pid_t pid)
 }
 
 
+static enum print_line_t
+print_graph_lat_fmt(struct trace_seq *s, struct trace_entry *entry)
+{
+	int hardirq, softirq;
+
+	hardirq = entry->flags & TRACE_FLAG_HARDIRQ;
+	softirq = entry->flags & TRACE_FLAG_SOFTIRQ;
+
+	if (!trace_seq_printf(s, " %c%c%c",
+			      (entry->flags & TRACE_FLAG_IRQS_OFF) ? 'd' :
+				(entry->flags & TRACE_FLAG_IRQS_NOSUPPORT) ?
+				  'X' : '.',
+			      (entry->flags & TRACE_FLAG_NEED_RESCHED) ?
+				'N' : '.',
+			      (hardirq && softirq) ? 'H' :
+				hardirq ? 'h' : softirq ? 's' : '.'))
+		return 0;
+
+	if (entry->preempt_count)
+		return trace_seq_printf(s, "%x", entry->preempt_count);
+	return trace_seq_puts(s, ".");
+}
+
 /* If the pid changed since the last trace, output this event */
 static enum print_line_t
 verif_pid(struct trace_seq *s, pid_t pid, int cpu, struct fgraph_data *data)
@@ -521,6 +544,7 @@ print_graph_irq(struct trace_iterator *iter, unsigned long addr,
 		if (ret == TRACE_TYPE_PARTIAL_LINE)
 			return TRACE_TYPE_PARTIAL_LINE;
 	}
+
 	/* Proc */
 	if (tracer_flags.val & TRACE_GRAPH_PRINT_PROC) {
 		ret = print_graph_proc(s, pid);
@@ -758,6 +782,13 @@ print_graph_prologue(struct trace_iterator *iter, struct trace_seq *s,
 			return TRACE_TYPE_PARTIAL_LINE;
 	}
 
+	/* Latency format */
+	if (trace_flags & TRACE_ITER_LATENCY_FMT) {
+		ret = print_graph_lat_fmt(s, ent);
+		if (ret == TRACE_TYPE_PARTIAL_LINE)
+			return TRACE_TYPE_PARTIAL_LINE;
+	}
+
 	return 0;
 }
 
@@ -952,28 +983,59 @@ print_graph_function(struct trace_iterator *iter)
 	return TRACE_TYPE_HANDLED;
 }
 
+static void print_lat_header(struct seq_file *s)
+{
+	static const char spaces[] = "                "	/* 16 spaces */
+		"    "					/* 4 spaces */
+		"                 ";			/* 17 spaces */
+	int size = 0;
+
+	if (tracer_flags.val & TRACE_GRAPH_PRINT_ABS_TIME)
+		size += 16;
+	if (tracer_flags.val & TRACE_GRAPH_PRINT_CPU)
+		size += 4;
+	if (tracer_flags.val & TRACE_GRAPH_PRINT_PROC)
+		size += 17;
+
+	seq_printf(s, "#%.*s  _-----=> irqs-off        \n", size, spaces);
+	seq_printf(s, "#%.*s / _----=> need-resched    \n", size, spaces);
+	seq_printf(s, "#%.*s| / _---=> hardirq/softirq \n", size, spaces);
+	seq_printf(s, "#%.*s|| / _--=> preempt-depth   \n", size, spaces);
+	seq_printf(s, "#%.*s||| /                      \n", size, spaces);
+	seq_printf(s, "#%.*s||||                       \n", size, spaces);
+}
+
 static void print_graph_headers(struct seq_file *s)
 {
+	int lat = trace_flags & TRACE_ITER_LATENCY_FMT;
+
+	if (lat)
+		print_lat_header(s);
+
 	/* 1st line */
-	seq_printf(s, "# ");
+	seq_printf(s, "#");
 	if (tracer_flags.val & TRACE_GRAPH_PRINT_ABS_TIME)
 		seq_printf(s, "     TIME       ");
 	if (tracer_flags.val & TRACE_GRAPH_PRINT_CPU)
-		seq_printf(s, "CPU");
+		seq_printf(s, " CPU");
 	if (tracer_flags.val & TRACE_GRAPH_PRINT_PROC)
-		seq_printf(s, "  TASK/PID      ");
+		seq_printf(s, "  TASK/PID       ");
+	if (lat)
+		seq_printf(s, "||||");
 	if (tracer_flags.val & TRACE_GRAPH_PRINT_DURATION)
 		seq_printf(s, "  DURATION   ");
 	seq_printf(s, "               FUNCTION CALLS\n");
 
 	/* 2nd line */
-	seq_printf(s, "# ");
+	seq_printf(s, "#");
 	if (tracer_flags.val & TRACE_GRAPH_PRINT_ABS_TIME)
 		seq_printf(s, "      |         ");
 	if (tracer_flags.val & TRACE_GRAPH_PRINT_CPU)
-		seq_printf(s, "|  ");
+		seq_printf(s, " |  ");
 	if (tracer_flags.val & TRACE_GRAPH_PRINT_PROC)
-		seq_printf(s, "  |    |        ");
+		seq_printf(s, "   |    |        ");
+	if (lat)
+		seq_printf(s, "||||");
 	if (tracer_flags.val & TRACE_GRAPH_PRINT_DURATION)
 		seq_printf(s, "   |   |      ");
 	seq_printf(s, "               |   |   |   |\n");
-- 
1.6.3.3

-- 
