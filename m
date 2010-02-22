Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab0BVM5e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 07:57:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43124 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753307Ab0BVM5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 07:57:30 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: mingo@elte.hu, rostedt@goodmis.org, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 1/4] tracing: adding ftrace events for graph tracer
Date: Mon, 22 Feb 2010 13:56:59 +0100
Message-Id: <1266843422-18288-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1266843422-18288-1-git-send-email-jolsa@redhat.com>
References: <1266843422-18288-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

this patch adds ftrace events for graph tracer, so the graph output
could be shared within other tracers.

wbr,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 kernel/trace/trace.h                 |    3 ++-
 kernel/trace/trace_functions_graph.c |   25 ++++++++++++++++++++++---
 2 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index b477fce..1feda87 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -490,7 +490,8 @@ extern int trace_clock_id;
 
 /* Standard output formatting function used for function return traces */
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
-extern enum print_line_t print_graph_function(struct trace_iterator *iter);
+extern enum print_line_t print_graph_function(struct trace_iterator *iter,
+					      int flags);
 extern enum print_line_t
 trace_print_graph_duration(unsigned long long duration, struct trace_seq *s);
 
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 616b135..41cec17 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -38,7 +38,7 @@ struct fgraph_data {
 #define TRACE_GRAPH_PRINT_OVERHEAD	0x4
 #define TRACE_GRAPH_PRINT_PROC		0x8
 #define TRACE_GRAPH_PRINT_DURATION	0x10
-#define TRACE_GRAPH_PRINT_ABS_TIME	0X20
+#define TRACE_GRAPH_PRINT_ABS_TIME	0x20
 
 static struct tracer_opt trace_opts[] = {
 	/* Display overruns? (for self-debug purpose) */
@@ -985,7 +985,7 @@ print_graph_comment(struct trace_seq *s,  struct trace_entry *ent,
 
 
 enum print_line_t
-print_graph_function(struct trace_iterator *iter)
+print_graph_function(struct trace_iterator *iter, int flags)
 {
 	struct ftrace_graph_ent_entry *field;
 	struct fgraph_data *data = iter->private;
@@ -1143,6 +1143,16 @@ static void graph_trace_close(struct trace_iterator *iter)
 	}
 }
 
+static struct trace_event graph_trace_entry_event = {
+	.type		= TRACE_GRAPH_ENT,
+	.trace		= print_graph_function,
+};
+
+static struct trace_event graph_trace_ret_event = {
+	.type		= TRACE_GRAPH_RET,
+	.trace		= print_graph_function,
+};
+
 static struct tracer graph_trace __read_mostly = {
 	.name		= "function_graph",
 	.open		= graph_trace_open,
@@ -1152,7 +1162,6 @@ static struct tracer graph_trace __read_mostly = {
 	.wait_pipe	= poll_wait_pipe,
 	.init		= graph_trace_init,
 	.reset		= graph_trace_reset,
-	.print_line	= print_graph_function,
 	.print_header	= print_graph_headers,
 	.flags		= &tracer_flags,
 #ifdef CONFIG_FTRACE_SELFTEST
@@ -1164,6 +1173,16 @@ static __init int init_graph_trace(void)
 {
 	max_bytes_for_cpu = snprintf(NULL, 0, "%d", nr_cpu_ids - 1);
 
+	if (!register_ftrace_event(&graph_trace_entry_event)) {
+		pr_warning("Warning: could not register graph trace events\n");
+		return 1;
+	}
+
+	if (!register_ftrace_event(&graph_trace_ret_event)) {
+		pr_warning("Warning: could not register graph trace events\n");
+		return 1;
+	}
+
 	return register_tracer(&graph_trace);
 }
 
-- 
1.6.6

