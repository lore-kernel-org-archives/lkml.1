Return-Path: <linux-kernel-owner+w=401wt.eu-S1760243AbZBFRxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760243AbZBFRxZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 12:53:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753376AbZBFRxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 12:53:17 -0500
Received: from mail-fx0-f31.google.com ([209.85.220.31]:64631 "EHLO
	mail-fx0-f31.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300AbZBFRxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 12:53:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:from:to:cc:date:subject;
        b=R5slGY3JuDJ/4aRNd73v9gyHThyy40pSdsu5q/LLSi8XlDF9mbvfl4UOrupOn7Lirq
         /spm1+2vIA2vQ+jU3NHFM8zjoi52V3liY398zyTAYDryoKb4t/GqAKIFSTszKJHR6SIU
         +FCKZpltMspFi3HZdECvUgy6wzEtAFPSmYzLQ=
Message-ID: <498c7909.11355e0a.5fc7.4ff2@mx.google.com>
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri, 6 Feb 2009 18:30:44 +0100
Subject: [PATCH] tracing/function-graph-tracer: handle the leaf functions from trace_pipe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When one cat on the trace file, the leaf functions are printed without brackets:

function();

whereas in the trace_pipe file we'll see the following:

function() {
}

This is because the ring_buffer handling is not the same between those two files.
On the trace file, when an entry is printed, the iterator advanced and then we can
check the next entry.

There is no iterator with trace_pipe, the current entry to print has been peeked
and not consumed. So checking the next entry will still return the current one while
we don't consume it.

This patch introduces a new value for the output callbacks to ask the tracing
core to not consume the current entry after printing it.
We need it because we will have to consume the current entry ourself to check the next one.

Now the trace_pipe is able to handle well the leaf functions.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace.c                 |    4 +-
 kernel/trace/trace.h                 |    7 +++--
 kernel/trace/trace_functions_graph.c |   48 +++++++++++++++++++++------------
 3 files changed, 36 insertions(+), 23 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index ef4dbac..e6eb588 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2459,8 +2459,8 @@ waitagain:
 			iter->seq.len = len;
 			break;
 		}
-
-		trace_consume(iter);
+		if (ret != TRACE_TYPE_NO_CONSUME)
+			trace_consume(iter);
 
 		if (iter->seq.len >= cnt)
 			break;
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index f2742fb..519ab31 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -63,13 +63,13 @@ struct ftrace_entry {
 
 /* Function call entry */
 struct ftrace_graph_ent_entry {
-	struct trace_entry			ent;
+	struct trace_entry		ent;
 	struct ftrace_graph_ent		graph_ent;
 };
 
 /* Function return entry */
 struct ftrace_graph_ret_entry {
-	struct trace_entry			ent;
+	struct trace_entry		ent;
 	struct ftrace_graph_ret		ret;
 };
 extern struct tracer boot_tracer;
@@ -309,7 +309,8 @@ extern void __ftrace_bad_type(void);
 enum print_line_t {
 	TRACE_TYPE_PARTIAL_LINE	= 0,	/* Retry after flushing the seq */
 	TRACE_TYPE_HANDLED	= 1,
-	TRACE_TYPE_UNHANDLED	= 2	/* Relay to other output functions */
+	TRACE_TYPE_UNHANDLED	= 2,	/* Relay to other output functions */
+	TRACE_TYPE_NO_CONSUME	= 3	/* Handled but ask to not consume */
 };
 
 
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 222f97d..7f11b7c 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -212,8 +212,8 @@ verif_pid(struct trace_seq *s, pid_t pid, int cpu, pid_t *last_pids_cpu)
 	return ret;
 }
 
-static bool
-trace_branch_is_leaf(struct trace_iterator *iter,
+static struct ftrace_graph_ret_entry *
+get_return_for_leaf(struct trace_iterator *iter,
 		struct ftrace_graph_ent_entry *curr)
 {
 	struct ring_buffer_iter *ring_iter;
@@ -222,24 +222,33 @@ trace_branch_is_leaf(struct trace_iterator *iter,
 
 	ring_iter = iter->buffer_iter[iter->cpu];
 
-	if (!ring_iter)
-		return false;
-
-	event = ring_buffer_iter_peek(ring_iter, NULL);
+	/* First peek to compare current entry and the next one */
+	if (ring_iter)
+		event = ring_buffer_iter_peek(ring_iter, NULL);
+	else {
+	/* We need to consume the current entry to see the next one */
+		ring_buffer_consume(iter->tr->buffer, iter->cpu, NULL);
+		event = ring_buffer_peek(iter->tr->buffer, iter->cpu,
+					NULL);
+	}
 
 	if (!event)
-		return false;
+		return NULL;
 
 	next = ring_buffer_event_data(event);
 
 	if (next->ent.type != TRACE_GRAPH_RET)
-		return false;
+		return NULL;
 
 	if (curr->ent.pid != next->ent.pid ||
 			curr->graph_ent.func != next->ret.func)
-		return false;
+		return NULL;
 
-	return true;
+	/* this is a leaf, now advance the iterator */
+	if (ring_iter)
+		ring_buffer_read(ring_iter, NULL);
+
+	return next;
 }
 
 /* Signal a overhead of time execution to the output */
@@ -376,18 +385,15 @@ static int print_graph_abs_time(u64 t, struct trace_seq *s)
 /* Case of a leaf function on its call entry */
 static enum print_line_t
 print_graph_entry_leaf(struct trace_iterator *iter,
-		struct ftrace_graph_ent_entry *entry, struct trace_seq *s)
+		struct ftrace_graph_ent_entry *entry,
+		struct ftrace_graph_ret_entry *ret_entry, struct trace_seq *s)
 {
-	struct ftrace_graph_ret_entry *ret_entry;
 	struct ftrace_graph_ret *graph_ret;
-	struct ring_buffer_event *event;
 	struct ftrace_graph_ent *call;
 	unsigned long long duration;
 	int ret;
 	int i;
 
-	event = ring_buffer_read(iter->buffer_iter[iter->cpu], NULL);
-	ret_entry = ring_buffer_event_data(event);
 	graph_ret = &ret_entry->ret;
 	call = &entry->graph_ent;
 	duration = graph_ret->rettime - graph_ret->calltime;
@@ -457,7 +463,11 @@ print_graph_entry_nested(struct ftrace_graph_ent_entry *entry,
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
-	return TRACE_TYPE_HANDLED;
+	/*
+	 * we already consumed the current entry to check the next one
+	 * and see if this is a leaf.
+	 */
+	return TRACE_TYPE_NO_CONSUME;
 }
 
 static enum print_line_t
@@ -469,6 +479,7 @@ print_graph_entry(struct ftrace_graph_ent_entry *field, struct trace_seq *s,
 	pid_t *last_entry = iter->private;
 	struct trace_entry *ent = iter->ent;
 	struct ftrace_graph_ent *call = &field->graph_ent;
+	struct ftrace_graph_ret_entry *leaf_ret;
 
 	/* Pid */
 	if (verif_pid(s, ent->pid, cpu, last_entry) == TRACE_TYPE_PARTIAL_LINE)
@@ -504,8 +515,9 @@ print_graph_entry(struct ftrace_graph_ent_entry *field, struct trace_seq *s,
 			return TRACE_TYPE_PARTIAL_LINE;
 	}
 
-	if (trace_branch_is_leaf(iter, field))
-		return print_graph_entry_leaf(iter, field, s);
+	leaf_ret = get_return_for_leaf(iter, field);
+	if (leaf_ret)
+		return print_graph_entry_leaf(iter, field, leaf_ret, s);
 	else
 		return print_graph_entry_nested(field, s, iter->ent->pid, cpu);
 
-- 
1.6.1


