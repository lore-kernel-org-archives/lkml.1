Return-Path: <linux-kernel-owner+w=401wt.eu-S1757390AbZCSUCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390AbZCSUCf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 16:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752206AbZCSUCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 16:02:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:51790 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbZCSUCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 16:02:04 -0400
Message-Id: <20090319200200.341942013@goodmis.org>
References: <20090319200122.512803803@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 19 Mar 2009 16:01:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 3/7] function-graph: consolidate prologues for output
Content-Disposition: inline; filename=0003-function-graph-consolidate-prologues-for-output.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: clean up

The prologue of the function graph entry, return and comments all
start out pretty much the same. Each of these duplicate code and
do so slightly differently.

This patch consolidates the printing of the pid, absolute time,
cpu and proc (and for entry, the interrupt).

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_functions_graph.c |   98 ++++++++++------------------------
 1 files changed, 29 insertions(+), 69 deletions(-)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 6004cca..2d4d185 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -554,24 +554,24 @@ print_graph_entry_nested(struct ftrace_graph_ent_entry *entry,
 }
 
 static enum print_line_t
-print_graph_entry(struct ftrace_graph_ent_entry *field, struct trace_seq *s,
-			struct trace_iterator *iter)
+print_graph_prologue(struct trace_iterator *iter, struct trace_seq *s,
+		     int type, unsigned long addr)
 {
-	int ret;
-	int cpu = iter->cpu;
-	pid_t *last_entry = iter->private;
 	struct trace_entry *ent = iter->ent;
-	struct ftrace_graph_ent *call = &field->graph_ent;
-	struct ftrace_graph_ret_entry *leaf_ret;
+	pid_t *last_pid = iter->private;
+	int cpu = iter->cpu;
+	int ret;
 
 	/* Pid */
-	if (verif_pid(s, ent->pid, cpu, last_entry) == TRACE_TYPE_PARTIAL_LINE)
+	if (verif_pid(s, ent->pid, cpu, last_pid) == TRACE_TYPE_PARTIAL_LINE)
 		return TRACE_TYPE_PARTIAL_LINE;
 
-	/* Interrupt */
-	ret = print_graph_irq(iter, call->func, TRACE_GRAPH_ENT, cpu, ent->pid);
-	if (ret == TRACE_TYPE_PARTIAL_LINE)
-		return TRACE_TYPE_PARTIAL_LINE;
+	if (type) {
+		/* Interrupt */
+		ret = print_graph_irq(iter, addr, type, cpu, ent->pid);
+		if (ret == TRACE_TYPE_PARTIAL_LINE)
+			return TRACE_TYPE_PARTIAL_LINE;
+	}
 
 	/* Absolute time */
 	if (tracer_flags.val & TRACE_GRAPH_PRINT_ABS_TIME) {
@@ -598,6 +598,20 @@ print_graph_entry(struct ftrace_graph_ent_entry *field, struct trace_seq *s,
 			return TRACE_TYPE_PARTIAL_LINE;
 	}
 
+	return 0;
+}
+
+static enum print_line_t
+print_graph_entry(struct ftrace_graph_ent_entry *field, struct trace_seq *s,
+			struct trace_iterator *iter)
+{
+	int cpu = iter->cpu;
+	struct ftrace_graph_ent *call = &field->graph_ent;
+	struct ftrace_graph_ret_entry *leaf_ret;
+
+	if (print_graph_prologue(iter, s, TRACE_GRAPH_ENT, call->func))
+		return TRACE_TYPE_PARTIAL_LINE;
+
 	leaf_ret = get_return_for_leaf(iter, field);
 	if (leaf_ret)
 		return print_graph_entry_leaf(iter, field, leaf_ret, s);
@@ -613,38 +627,12 @@ print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
 	int i;
 	int ret;
 	int cpu = iter->cpu;
-	pid_t *last_pid = iter->private, pid = ent->pid;
+	pid_t pid = ent->pid;
 	unsigned long long duration = trace->rettime - trace->calltime;
 
-	/* Pid */
-	if (verif_pid(s, pid, cpu, last_pid) == TRACE_TYPE_PARTIAL_LINE)
+	if (print_graph_prologue(iter, s, 0, 0))
 		return TRACE_TYPE_PARTIAL_LINE;
 
-	/* Absolute time */
-	if (tracer_flags.val & TRACE_GRAPH_PRINT_ABS_TIME) {
-		ret = print_graph_abs_time(iter->ts, s);
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-	}
-
-	/* Cpu */
-	if (tracer_flags.val & TRACE_GRAPH_PRINT_CPU) {
-		ret = print_graph_cpu(s, cpu);
-		if (ret == TRACE_TYPE_PARTIAL_LINE)
-			return TRACE_TYPE_PARTIAL_LINE;
-	}
-
-	/* Proc */
-	if (tracer_flags.val & TRACE_GRAPH_PRINT_PROC) {
-		ret = print_graph_proc(s, ent->pid);
-		if (ret == TRACE_TYPE_PARTIAL_LINE)
-			return TRACE_TYPE_PARTIAL_LINE;
-
-		ret = trace_seq_printf(s, " | ");
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-	}
-
 	/* Overhead */
 	ret = print_graph_overhead(duration, s);
 	if (!ret)
@@ -689,38 +677,10 @@ print_graph_comment(struct bprint_entry *trace, struct trace_seq *s,
 {
 	int i;
 	int ret;
-	int cpu = iter->cpu;
-	pid_t *last_pid = iter->private;
 
-	/* Pid */
-	if (verif_pid(s, ent->pid, cpu, last_pid) == TRACE_TYPE_PARTIAL_LINE)
+	if (print_graph_prologue(iter, s, 0, 0))
 		return TRACE_TYPE_PARTIAL_LINE;
 
-	/* Absolute time */
-	if (tracer_flags.val & TRACE_GRAPH_PRINT_ABS_TIME) {
-		ret = print_graph_abs_time(iter->ts, s);
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-	}
-
-	/* Cpu */
-	if (tracer_flags.val & TRACE_GRAPH_PRINT_CPU) {
-		ret = print_graph_cpu(s, cpu);
-		if (ret == TRACE_TYPE_PARTIAL_LINE)
-			return TRACE_TYPE_PARTIAL_LINE;
-	}
-
-	/* Proc */
-	if (tracer_flags.val & TRACE_GRAPH_PRINT_PROC) {
-		ret = print_graph_proc(s, ent->pid);
-		if (ret == TRACE_TYPE_PARTIAL_LINE)
-			return TRACE_TYPE_PARTIAL_LINE;
-
-		ret = trace_seq_printf(s, " | ");
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-	}
-
 	/* No overhead */
 	ret = print_graph_overhead(-1, s);
 	if (!ret)
-- 
1.6.2

-- 
