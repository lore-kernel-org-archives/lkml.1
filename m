Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab0BVM54 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 07:57:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37695 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753265Ab0BVM5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 07:57:24 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: mingo@elte.hu, rostedt@goodmis.org, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 4/4] tracing: raw output for graph tracer
Date: Mon, 22 Feb 2010 13:57:02 +0100
Message-Id: <1266843422-18288-5-git-send-email-jolsa@redhat.com>
In-Reply-To: <1266843422-18288-1-git-send-email-jolsa@redhat.com>
References: <1266843422-18288-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

this patch adds raw trace output for graph tracer.

I have this one around for long time and it was quite handy
for investigating graph tracer issues.

wbr,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 kernel/trace/trace.c                 |    2 +-
 kernel/trace/trace_functions_graph.c |   69 ++++++++++++++++++++++++++++++++++
 2 files changed, 70 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 032c57c..723fa93 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1900,7 +1900,7 @@ static enum print_line_t print_raw_fmt(struct trace_iterator *iter)
 	entry = iter->ent;
 
 	if (trace_flags & TRACE_ITER_CONTEXT_INFO) {
-		if (!trace_seq_printf(s, "%d %d %llu ",
+		if (!trace_seq_printf(s, " %6d %3d %20llu ",
 				      entry->pid, iter->cpu, iter->ts))
 			goto partial;
 	}
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index eca09b3..023e0be 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -1033,6 +1033,66 @@ print_graph_function(struct trace_iterator *iter, int flags)
 	return TRACE_TYPE_HANDLED;
 }
 
+static enum print_line_t
+print_graph_raw(struct trace_iterator *iter, int flags)
+{
+	struct trace_entry *entry = iter->ent;
+	struct trace_seq *s = &iter->seq;
+	int ret = 0;
+	int depth;
+	void *func;
+	char *io;
+
+	switch (entry->type) {
+	case TRACE_GRAPH_ENT: {
+		struct ftrace_graph_ent_entry *field;
+		trace_assign_type(field, entry);
+		depth = field->graph_ent.depth;
+		func = (void *) field->graph_ent.func;
+		io = "-->";
+		break;
+	}
+	case TRACE_GRAPH_RET: {
+		struct ftrace_graph_ret_entry *field;
+		trace_assign_type(field, entry);
+		depth = field->ret.depth;
+		func = (void *) field->ret.func;
+		io = "<--";
+		break;
+	}
+	default:
+		return print_graph_comment(s, entry, iter);
+	}
+
+	ret = trace_seq_printf(s, "%s%6d %6d %6d %4d %7d %20p %4s %ps\n",
+		trace_flags & TRACE_ITER_CONTEXT_INFO ? "" : " ",
+		depth,
+		entry->lock_depth,
+		entry->flags,
+		entry->preempt_count,
+		entry->pid,
+		entry,
+		io,
+		func);
+
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	return TRACE_TYPE_HANDLED;
+}
+
+static void print_graph_raw_header(struct seq_file *s)
+{
+	if (trace_flags & TRACE_ITER_CONTEXT_INFO)
+		seq_printf(s, "#%6s %3s %20s ", "pid", "cpu", "duration");
+	else
+		seq_printf(s, "#");
+
+	seq_printf(s, "%6s %6s %6s %4s %7s %20s %4s %s\n",
+		"depth", "ldepth", "flags", "pc", "pid",
+		"entry", "i/o", "function");
+}
+
 static void print_lat_header(struct seq_file *s)
 {
 	static const char spaces[] = "                "	/* 16 spaces */
@@ -1059,6 +1119,11 @@ void print_graph_headers(struct seq_file *s)
 {
 	int lat = trace_flags & TRACE_ITER_LATENCY_FMT;
 
+	if (trace_flags & TRACE_ITER_RAW) {
+		print_graph_raw_header(s);
+		return;
+	}
+
 	if (lat)
 		print_lat_header(s);
 
@@ -1074,6 +1139,7 @@ void print_graph_headers(struct seq_file *s)
 		seq_printf(s, "|||||");
 	if (tracer_flags.val & TRACE_GRAPH_PRINT_DURATION)
 		seq_printf(s, "  DURATION   ");
+
 	seq_printf(s, "               FUNCTION CALLS\n");
 
 	/* 2nd line */
@@ -1136,14 +1202,17 @@ void graph_trace_close(struct trace_iterator *iter)
 	}
 }
 
+
 static struct trace_event graph_trace_entry_event = {
 	.type		= TRACE_GRAPH_ENT,
 	.trace		= print_graph_function,
+	.raw		= print_graph_raw,
 };
 
 static struct trace_event graph_trace_ret_event = {
 	.type		= TRACE_GRAPH_RET,
 	.trace		= print_graph_function,
+	.raw		= print_graph_raw,
 };
 
 static struct tracer graph_trace __read_mostly = {
-- 
1.6.6

