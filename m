Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab0CJHv7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 02:51:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57280 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751758Ab0CJHvQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 02:51:16 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCHv2 1/4] tracing: adding ftrace events for graph tracer
Date: Wed, 10 Mar 2010 08:51:07 +0100
Message-Id: <1268207470-2880-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1268207470-2880-1-git-send-email-jolsa@redhat.com>
References: <1268207470-2880-1-git-send-email-jolsa@redhat.com>
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
 kernel/trace/trace.h                 |    7 -------
 kernel/trace/trace_functions_graph.c |   30 ++++++++++++++++++++++++++++--
 2 files changed, 28 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index fd05bca..9992c29 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -490,7 +490,6 @@ extern int trace_clock_id;
 
 /* Standard output formatting function used for function return traces */
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
-extern enum print_line_t print_graph_function(struct trace_iterator *iter);
 extern enum print_line_t
 trace_print_graph_duration(unsigned long long duration, struct trace_seq *s);
 
@@ -521,12 +520,6 @@ static inline int ftrace_graph_addr(unsigned long addr)
 	return 1;
 }
 #endif /* CONFIG_DYNAMIC_FTRACE */
-#else /* CONFIG_FUNCTION_GRAPH_TRACER */
-static inline enum print_line_t
-print_graph_function(struct trace_iterator *iter)
-{
-	return TRACE_TYPE_UNHANDLED;
-}
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
 
 extern struct list_head ftrace_pids;
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 3fc2a57..b0e6384 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -39,7 +39,7 @@ struct fgraph_data {
 #define TRACE_GRAPH_PRINT_OVERHEAD	0x4
 #define TRACE_GRAPH_PRINT_PROC		0x8
 #define TRACE_GRAPH_PRINT_DURATION	0x10
-#define TRACE_GRAPH_PRINT_ABS_TIME	0X20
+#define TRACE_GRAPH_PRINT_ABS_TIME	0x20
 
 static struct tracer_opt trace_opts[] = {
 	/* Display overruns? (for self-debug purpose) */
@@ -1017,7 +1017,7 @@ print_graph_comment(struct trace_seq *s,  struct trace_entry *ent,
 }
 
 
-enum print_line_t
+static enum print_line_t
 print_graph_function(struct trace_iterator *iter)
 {
 	struct ftrace_graph_ent_entry *field;
@@ -1073,6 +1073,12 @@ print_graph_function(struct trace_iterator *iter)
 	return TRACE_TYPE_HANDLED;
 }
 
+static enum print_line_t
+print_graph_function_event(struct trace_iterator *iter, int flags)
+{
+	return print_graph_function(iter);
+}
+
 static void print_lat_header(struct seq_file *s)
 {
 	static const char spaces[] = "                "	/* 16 spaces */
@@ -1176,6 +1182,16 @@ static void graph_trace_close(struct trace_iterator *iter)
 	}
 }
 
+static struct trace_event graph_trace_entry_event = {
+	.type		= TRACE_GRAPH_ENT,
+	.trace		= print_graph_function_event,
+};
+
+static struct trace_event graph_trace_ret_event = {
+	.type		= TRACE_GRAPH_RET,
+	.trace		= print_graph_function_event,
+};
+
 static struct tracer graph_trace __read_mostly = {
 	.name		= "function_graph",
 	.open		= graph_trace_open,
@@ -1197,6 +1213,16 @@ static __init int init_graph_trace(void)
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

