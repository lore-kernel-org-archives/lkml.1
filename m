Return-Path: <linux-kernel-owner+w=401wt.eu-S1753695AbZCSUEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695AbZCSUEQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 16:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751884AbZCSUCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 16:02:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:51829 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbZCSUCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 16:02:04 -0400
Message-Id: <20090319200200.786900451@goodmis.org>
References: <20090319200122.512803803@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 19 Mar 2009 16:01:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 5/7] function-graph: calculate function depth within function graph tracer
Content-Disposition: inline; filename=0005-function-graph-calculate-function-depth-within-func.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Currently, the function graph tracer depends on the trace_printk
to record the depth. All the information is already there in the trace
to calculate function depth, with the exception of having the printk
be the first item. But as soon as a entry or exit is reached, then
we know the depth.

This patch changes the iter->private data from recording a per cpu
last_pid, to a structure that holds both the last_pid and the current
depth. This data is used to determine the function depth for the
printks.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_functions_graph.c |   91 +++++++++++++++++++++++++--------
 1 files changed, 69 insertions(+), 22 deletions(-)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 2d4d185..66ea23b 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -14,6 +14,11 @@
 #include "trace.h"
 #include "trace_output.h"
 
+struct fgraph_data {
+	pid_t		last_pid;
+	int		depth;
+};
+
 #define TRACE_GRAPH_INDENT	2
 
 /* Flag options */
@@ -231,16 +236,16 @@ print_graph_proc(struct trace_seq *s, pid_t pid)
 
 /* If the pid changed since the last trace, output this event */
 static enum print_line_t
-verif_pid(struct trace_seq *s, pid_t pid, int cpu, pid_t *last_pids_cpu)
+verif_pid(struct trace_seq *s, pid_t pid, int cpu, struct fgraph_data *data)
 {
 	pid_t prev_pid;
 	pid_t *last_pid;
 	int ret;
 
-	if (!last_pids_cpu)
+	if (!data)
 		return TRACE_TYPE_HANDLED;
 
-	last_pid = per_cpu_ptr(last_pids_cpu, cpu);
+	last_pid = &(per_cpu_ptr(data, cpu)->last_pid);
 
 	if (*last_pid == pid)
 		return TRACE_TYPE_HANDLED;
@@ -471,6 +476,7 @@ print_graph_entry_leaf(struct trace_iterator *iter,
 		struct ftrace_graph_ent_entry *entry,
 		struct ftrace_graph_ret_entry *ret_entry, struct trace_seq *s)
 {
+	struct fgraph_data *data = iter->private;
 	struct ftrace_graph_ret *graph_ret;
 	struct ftrace_graph_ent *call;
 	unsigned long long duration;
@@ -481,6 +487,18 @@ print_graph_entry_leaf(struct trace_iterator *iter,
 	call = &entry->graph_ent;
 	duration = graph_ret->rettime - graph_ret->calltime;
 
+	if (data) {
+		int cpu = iter->cpu;
+		int *depth = &(per_cpu_ptr(data, cpu)->depth);
+
+		/*
+		 * Comments display at + 1 to depth. Since
+		 * this is a leaf function, keep the comments
+		 * equal to this depth.
+		 */
+		*depth = call->depth - 1;
+	}
+
 	/* Overhead */
 	ret = print_graph_overhead(duration, s);
 	if (!ret)
@@ -512,12 +530,21 @@ print_graph_entry_leaf(struct trace_iterator *iter,
 }
 
 static enum print_line_t
-print_graph_entry_nested(struct ftrace_graph_ent_entry *entry,
-			struct trace_seq *s, pid_t pid, int cpu)
+print_graph_entry_nested(struct trace_iterator *iter,
+			 struct ftrace_graph_ent_entry *entry,
+			 struct trace_seq *s, int cpu)
 {
-	int i;
-	int ret;
 	struct ftrace_graph_ent *call = &entry->graph_ent;
+	struct fgraph_data *data = iter->private;
+	int ret;
+	int i;
+
+	if (data) {
+		int cpu = iter->cpu;
+		int *depth = &(per_cpu_ptr(data, cpu)->depth);
+
+		*depth = call->depth;
+	}
 
 	/* No overhead */
 	ret = print_graph_overhead(-1, s);
@@ -557,13 +584,13 @@ static enum print_line_t
 print_graph_prologue(struct trace_iterator *iter, struct trace_seq *s,
 		     int type, unsigned long addr)
 {
+	struct fgraph_data *data = iter->private;
 	struct trace_entry *ent = iter->ent;
-	pid_t *last_pid = iter->private;
 	int cpu = iter->cpu;
 	int ret;
 
 	/* Pid */
-	if (verif_pid(s, ent->pid, cpu, last_pid) == TRACE_TYPE_PARTIAL_LINE)
+	if (verif_pid(s, ent->pid, cpu, data) == TRACE_TYPE_PARTIAL_LINE)
 		return TRACE_TYPE_PARTIAL_LINE;
 
 	if (type) {
@@ -616,7 +643,7 @@ print_graph_entry(struct ftrace_graph_ent_entry *field, struct trace_seq *s,
 	if (leaf_ret)
 		return print_graph_entry_leaf(iter, field, leaf_ret, s);
 	else
-		return print_graph_entry_nested(field, s, iter->ent->pid, cpu);
+		return print_graph_entry_nested(iter, field, s, cpu);
 
 }
 
@@ -624,11 +651,24 @@ static enum print_line_t
 print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
 		   struct trace_entry *ent, struct trace_iterator *iter)
 {
-	int i;
-	int ret;
-	int cpu = iter->cpu;
-	pid_t pid = ent->pid;
 	unsigned long long duration = trace->rettime - trace->calltime;
+	struct fgraph_data *data = iter->private;
+	pid_t pid = ent->pid;
+	int cpu = iter->cpu;
+	int ret;
+	int i;
+
+	if (data) {
+		int cpu = iter->cpu;
+		int *depth = &(per_cpu_ptr(data, cpu)->depth);
+
+		/*
+		 * Comments display at + 1 to depth. This is the
+		 * return from a function, we now want the comments
+		 * to display at the same level of the bracket.
+		 */
+		*depth = trace->depth - 1;
+	}
 
 	if (print_graph_prologue(iter, s, 0, 0))
 		return TRACE_TYPE_PARTIAL_LINE;
@@ -675,8 +715,13 @@ static enum print_line_t
 print_graph_comment(struct bprint_entry *trace, struct trace_seq *s,
 		   struct trace_entry *ent, struct trace_iterator *iter)
 {
-	int i;
+	struct fgraph_data *data = iter->private;
+	int depth = 0;
 	int ret;
+	int i;
+
+	if (data)
+		depth = per_cpu_ptr(data, iter->cpu)->depth;
 
 	if (print_graph_prologue(iter, s, 0, 0))
 		return TRACE_TYPE_PARTIAL_LINE;
@@ -694,8 +739,8 @@ print_graph_comment(struct bprint_entry *trace, struct trace_seq *s,
 	}
 
 	/* Indentation */
-	if (trace->depth > 0)
-		for (i = 0; i < (trace->depth + 1) * TRACE_GRAPH_INDENT; i++) {
+	if (depth > 0)
+		for (i = 0; i < (depth + 1) * TRACE_GRAPH_INDENT; i++) {
 			ret = trace_seq_printf(s, " ");
 			if (!ret)
 				return TRACE_TYPE_PARTIAL_LINE;
@@ -780,19 +825,21 @@ static void print_graph_headers(struct seq_file *s)
 
 static void graph_trace_open(struct trace_iterator *iter)
 {
-	/* pid on the last trace processed */
-	pid_t *last_pid = alloc_percpu(pid_t);
+	/* pid and depth on the last trace processed */
+	struct fgraph_data *data = alloc_percpu(struct fgraph_data);
 	int cpu;
 
-	if (!last_pid)
+	if (!data)
 		pr_warning("function graph tracer: not enough memory\n");
 	else
 		for_each_possible_cpu(cpu) {
-			pid_t *pid = per_cpu_ptr(last_pid, cpu);
+			pid_t *pid = &(per_cpu_ptr(data, cpu)->last_pid);
+			int *depth = &(per_cpu_ptr(data, cpu)->depth);
 			*pid = -1;
+			*depth = 0;
 		}
 
-	iter->private = last_pid;
+	iter->private = data;
 }
 
 static void graph_trace_close(struct trace_iterator *iter)
-- 
1.6.2

-- 
