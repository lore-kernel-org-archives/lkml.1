Return-Path: <linux-kernel-owner+w=401wt.eu-S964941AbZLGUWO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964941AbZLGUWO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 15:22:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934892AbZLGUWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 15:22:12 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:65356 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964901AbZLGUWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 15:22:04 -0500
Message-Id: <20091207202209.652641520@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 07 Dec 2009 15:19:07 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 4/4] [PATCH 4/4] tracing: Fix function graph trace_pipe to properly display failed entries
References: <20091207201903.864817226@goodmis.org>
Content-Disposition: inline; filename=0004-tracing-Fix-function-graph-trace_pipe-to-properly-di.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

There is a case where the graph tracer might get confused and omits
displaying of a single record.  This applies mostly with the trace_pipe
since it is unlikely that the trace_seq buffer will overflow with the
trace file.

As the function_graph tracer goes through the trace entries keeping a
pointer to the current record:

current ->  func1 ENTRY
            func2 ENTRY
            func2 RETURN
            func1 RETURN

When an function ENTRY is encountered, it moves the pointer to the
next entry to check if the function is a nested or leaf function.

            func1 ENTRY
current ->  func2 ENTRY
            func2 RETURN
            func1 RETURN

If the rest of the writing of the function fills the trace_seq buffer,
then the trace_pipe read will ignore this entry. The next read will
Now start at the current location, but the first entry (func1) will
be discarded.

This patch keeps a copy of the current entry in the iterator private
storage and will keep track of when the trace_seq buffer fills. When
the trace_seq buffer fills, it will reuse the copy of the entry in the
next iteration.

[
  This patch has been largely modified by Steven Rostedt in order to
  clean it up and simplify it. The original idea and concept was from
  Jirka and for that, this patch will go under his name to give him
  the credit he deserves. But because this was modify by Steven Rostedt
  anything wrong with the patch should be blamed on Steven.
]

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1259067458-27143-1-git-send-email-jolsa@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_functions_graph.c |  165 +++++++++++++++++++++++++++-------
 1 files changed, 131 insertions(+), 34 deletions(-)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 45e6c01..a43d009 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -14,9 +14,20 @@
 #include "trace.h"
 #include "trace_output.h"
 
-struct fgraph_data {
+struct fgraph_cpu_data {
 	pid_t		last_pid;
 	int		depth;
+	int		ignore;
+};
+
+struct fgraph_data {
+	struct fgraph_cpu_data		*cpu_data;
+
+	/* Place to preserve last processed entry. */
+	struct ftrace_graph_ent_entry	ent;
+	struct ftrace_graph_ret_entry	ret;
+	int				failed;
+	int				cpu;
 };
 
 #define TRACE_GRAPH_INDENT	2
@@ -384,7 +395,7 @@ verif_pid(struct trace_seq *s, pid_t pid, int cpu, struct fgraph_data *data)
 	if (!data)
 		return TRACE_TYPE_HANDLED;
 
-	last_pid = &(per_cpu_ptr(data, cpu)->last_pid);
+	last_pid = &(per_cpu_ptr(data->cpu_data, cpu)->last_pid);
 
 	if (*last_pid == pid)
 		return TRACE_TYPE_HANDLED;
@@ -435,26 +446,49 @@ static struct ftrace_graph_ret_entry *
 get_return_for_leaf(struct trace_iterator *iter,
 		struct ftrace_graph_ent_entry *curr)
 {
-	struct ring_buffer_iter *ring_iter;
+	struct fgraph_data *data = iter->private;
+	struct ring_buffer_iter *ring_iter = NULL;
 	struct ring_buffer_event *event;
 	struct ftrace_graph_ret_entry *next;
 
-	ring_iter = iter->buffer_iter[iter->cpu];
+	/*
+	 * If the previous output failed to write to the seq buffer,
+	 * then we just reuse the data from before.
+	 */
+	if (data && data->failed) {
+		curr = &data->ent;
+		next = &data->ret;
+	} else {
 
-	/* First peek to compare current entry and the next one */
-	if (ring_iter)
-		event = ring_buffer_iter_peek(ring_iter, NULL);
-	else {
-	/* We need to consume the current entry to see the next one */
-		ring_buffer_consume(iter->tr->buffer, iter->cpu, NULL);
-		event = ring_buffer_peek(iter->tr->buffer, iter->cpu,
-					NULL);
-	}
+		ring_iter = iter->buffer_iter[iter->cpu];
+
+		/* First peek to compare current entry and the next one */
+		if (ring_iter)
+			event = ring_buffer_iter_peek(ring_iter, NULL);
+		else {
+			/*
+			 * We need to consume the current entry to see
+			 * the next one.
+			 */
+			ring_buffer_consume(iter->tr->buffer, iter->cpu, NULL);
+			event = ring_buffer_peek(iter->tr->buffer, iter->cpu,
+						 NULL);
+		}
 
-	if (!event)
-		return NULL;
+		if (!event)
+			return NULL;
+
+		next = ring_buffer_event_data(event);
 
-	next = ring_buffer_event_data(event);
+		if (data) {
+			/*
+			 * Save current and next entries for later reference
+			 * if the output fails.
+			 */
+			data->ent = *curr;
+			data->ret = *next;
+		}
+	}
 
 	if (next->ent.type != TRACE_GRAPH_RET)
 		return NULL;
@@ -640,7 +674,7 @@ print_graph_entry_leaf(struct trace_iterator *iter,
 
 	if (data) {
 		int cpu = iter->cpu;
-		int *depth = &(per_cpu_ptr(data, cpu)->depth);
+		int *depth = &(per_cpu_ptr(data->cpu_data, cpu)->depth);
 
 		/*
 		 * Comments display at + 1 to depth. Since
@@ -688,7 +722,7 @@ print_graph_entry_nested(struct trace_iterator *iter,
 
 	if (data) {
 		int cpu = iter->cpu;
-		int *depth = &(per_cpu_ptr(data, cpu)->depth);
+		int *depth = &(per_cpu_ptr(data->cpu_data, cpu)->depth);
 
 		*depth = call->depth;
 	}
@@ -782,19 +816,34 @@ static enum print_line_t
 print_graph_entry(struct ftrace_graph_ent_entry *field, struct trace_seq *s,
 			struct trace_iterator *iter)
 {
-	int cpu = iter->cpu;
+	struct fgraph_data *data = iter->private;
 	struct ftrace_graph_ent *call = &field->graph_ent;
 	struct ftrace_graph_ret_entry *leaf_ret;
+	static enum print_line_t ret;
+	int cpu = iter->cpu;
 
 	if (print_graph_prologue(iter, s, TRACE_GRAPH_ENT, call->func))
 		return TRACE_TYPE_PARTIAL_LINE;
 
 	leaf_ret = get_return_for_leaf(iter, field);
 	if (leaf_ret)
-		return print_graph_entry_leaf(iter, field, leaf_ret, s);
+		ret = print_graph_entry_leaf(iter, field, leaf_ret, s);
 	else
-		return print_graph_entry_nested(iter, field, s, cpu);
+		ret = print_graph_entry_nested(iter, field, s, cpu);
 
+	if (data) {
+		/*
+		 * If we failed to write our output, then we need to make
+		 * note of it. Because we already consumed our entry.
+		 */
+		if (s->full) {
+			data->failed = 1;
+			data->cpu = cpu;
+		} else
+			data->failed = 0;
+	}
+
+	return ret;
 }
 
 static enum print_line_t
@@ -810,7 +859,7 @@ print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
 
 	if (data) {
 		int cpu = iter->cpu;
-		int *depth = &(per_cpu_ptr(data, cpu)->depth);
+		int *depth = &(per_cpu_ptr(data->cpu_data, cpu)->depth);
 
 		/*
 		 * Comments display at + 1 to depth. This is the
@@ -873,7 +922,7 @@ print_graph_comment(struct trace_seq *s,  struct trace_entry *ent,
 	int i;
 
 	if (data)
-		depth = per_cpu_ptr(data, iter->cpu)->depth;
+		depth = per_cpu_ptr(data->cpu_data, iter->cpu)->depth;
 
 	if (print_graph_prologue(iter, s, 0, 0))
 		return TRACE_TYPE_PARTIAL_LINE;
@@ -941,8 +990,33 @@ print_graph_comment(struct trace_seq *s,  struct trace_entry *ent,
 enum print_line_t
 print_graph_function(struct trace_iterator *iter)
 {
+	struct ftrace_graph_ent_entry *field;
+	struct fgraph_data *data = iter->private;
 	struct trace_entry *entry = iter->ent;
 	struct trace_seq *s = &iter->seq;
+	int cpu = iter->cpu;
+	int ret;
+
+	if (data && per_cpu_ptr(data->cpu_data, cpu)->ignore) {
+		per_cpu_ptr(data->cpu_data, cpu)->ignore = 0;
+		return TRACE_TYPE_HANDLED;
+	}
+
+	/*
+	 * If the last output failed, there's a possibility we need
+	 * to print out the missing entry which would never go out.
+	 */
+	if (data && data->failed) {
+		field = &data->ent;
+		iter->cpu = data->cpu;
+		ret = print_graph_entry(field, s, iter);
+		if (ret == TRACE_TYPE_HANDLED && iter->cpu != cpu) {
+			per_cpu_ptr(data->cpu_data, iter->cpu)->ignore = 1;
+			ret = TRACE_TYPE_NO_CONSUME;
+		}
+		iter->cpu = cpu;
+		return ret;
+	}
 
 	switch (entry->type) {
 	case TRACE_GRAPH_ENT: {
@@ -952,7 +1026,7 @@ print_graph_function(struct trace_iterator *iter)
 		 * sizeof(struct ftrace_graph_ent_entry) is very small,
 		 * it can be safely saved at the stack.
 		 */
-		struct ftrace_graph_ent_entry *field, saved;
+		struct ftrace_graph_ent_entry saved;
 		trace_assign_type(field, entry);
 		saved = *field;
 		return print_graph_entry(&saved, s, iter);
@@ -1030,31 +1104,54 @@ static void print_graph_headers(struct seq_file *s)
 static void graph_trace_open(struct trace_iterator *iter)
 {
 	/* pid and depth on the last trace processed */
-	struct fgraph_data *data = alloc_percpu(struct fgraph_data);
+	struct fgraph_data *data;
 	int cpu;
 
+	iter->private = NULL;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (!data)
-		pr_warning("function graph tracer: not enough memory\n");
-	else
-		for_each_possible_cpu(cpu) {
-			pid_t *pid = &(per_cpu_ptr(data, cpu)->last_pid);
-			int *depth = &(per_cpu_ptr(data, cpu)->depth);
-			*pid = -1;
-			*depth = 0;
-		}
+		goto out_err;
+
+	data->cpu_data = alloc_percpu(struct fgraph_cpu_data);
+	if (!data->cpu_data)
+		goto out_err_free;
+
+	for_each_possible_cpu(cpu) {
+		pid_t *pid = &(per_cpu_ptr(data->cpu_data, cpu)->last_pid);
+		int *depth = &(per_cpu_ptr(data->cpu_data, cpu)->depth);
+		int *ignore = &(per_cpu_ptr(data->cpu_data, cpu)->ignore);
+		*pid = -1;
+		*depth = 0;
+		*ignore = 0;
+	}
 
 	iter->private = data;
+
+	return;
+
+ out_err_free:
+	kfree(data);
+ out_err:
+	pr_warning("function graph tracer: not enough memory\n");
 }
 
 static void graph_trace_close(struct trace_iterator *iter)
 {
-	free_percpu(iter->private);
+	struct fgraph_data *data = iter->private;
+
+	if (data) {
+		free_percpu(data->cpu_data);
+		kfree(data);
+	}
 }
 
 static struct tracer graph_trace __read_mostly = {
 	.name		= "function_graph",
 	.open		= graph_trace_open,
+	.pipe_open	= graph_trace_open,
 	.close		= graph_trace_close,
+	.pipe_close	= graph_trace_close,
 	.wait_pipe	= poll_wait_pipe,
 	.init		= graph_trace_init,
 	.reset		= graph_trace_reset,
-- 
1.6.5


