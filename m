Return-Path: <linux-kernel-owner+w=401wt.eu-S1760555AbZCSUDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760555AbZCSUDe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 16:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753201AbZCSUCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 16:02:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:51806 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbZCSUCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 16:02:04 -0400
Message-Id: <20090319200201.217098940@goodmis.org>
References: <20090319200122.512803803@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 19 Mar 2009 16:01:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 7/7] function-graph: show binary events as comments
Content-Disposition: inline; filename=0007-function-graph-show-binary-events-as-comments.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

With the added TRACE_EVENT macro, the events no longer appear in
the function graph tracer. This was because the function graph
did not know how to display the entries. The graph tracer was
only aware of its own entries and the printk entries.

By using the event call back feature, the graph tracer can now display
the events.

 # echo irq > /debug/tracing/set_event

Which can show:

 0)               |          handle_IRQ_event() {
 0)               |            /* irq_handler_entry: irq=48 handler=eth0 */
 0)               |            e1000_intr() {
 0)   0.926 us    |              __napi_schedule();
 0)   3.888 us    |            }
 0)               |            /* irq_handler_exit: irq=48 return=handled */
 0)   0.655 us    |            runqueue_is_locked();
 0)               |            __wake_up() {
 0)   0.831 us    |              _spin_lock_irqsave();

The irq entry and exit events show up as comments.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_functions_graph.c |   40 +++++++++++++++++++++++----------
 1 files changed, 28 insertions(+), 12 deletions(-)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 66ea23b..e876816 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -712,10 +712,12 @@ print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
 }
 
 static enum print_line_t
-print_graph_comment(struct bprint_entry *trace, struct trace_seq *s,
-		   struct trace_entry *ent, struct trace_iterator *iter)
+print_graph_comment(struct trace_seq *s,  struct trace_entry *ent,
+		    struct trace_iterator *iter)
 {
+	unsigned long sym_flags = (trace_flags & TRACE_ITER_SYM_MASK);
 	struct fgraph_data *data = iter->private;
+	struct trace_event *event;
 	int depth = 0;
 	int ret;
 	int i;
@@ -751,9 +753,26 @@ print_graph_comment(struct bprint_entry *trace, struct trace_seq *s,
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
-	ret = trace_seq_bprintf(s, trace->fmt, trace->buf);
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
+	switch (iter->ent->type) {
+	case TRACE_BPRINT:
+		ret = trace_print_bprintk_msg_only(iter);
+		if (ret != TRACE_TYPE_HANDLED)
+			return ret;
+		break;
+	case TRACE_PRINT:
+		ret = trace_print_printk_msg_only(iter);
+		if (ret != TRACE_TYPE_HANDLED)
+			return ret;
+		break;
+	default:
+		event = ftrace_find_event(ent->type);
+		if (!event)
+			return TRACE_TYPE_UNHANDLED;
+
+		ret = event->trace(iter, sym_flags);
+		if (ret != TRACE_TYPE_HANDLED)
+			return ret;
+	}
 
 	/* Strip ending newline */
 	if (s->buffer[s->len - 1] == '\n') {
@@ -772,8 +791,8 @@ print_graph_comment(struct bprint_entry *trace, struct trace_seq *s,
 enum print_line_t
 print_graph_function(struct trace_iterator *iter)
 {
-	struct trace_seq *s = &iter->seq;
 	struct trace_entry *entry = iter->ent;
+	struct trace_seq *s = &iter->seq;
 
 	switch (entry->type) {
 	case TRACE_GRAPH_ENT: {
@@ -786,14 +805,11 @@ print_graph_function(struct trace_iterator *iter)
 		trace_assign_type(field, entry);
 		return print_graph_return(&field->ret, s, entry, iter);
 	}
-	case TRACE_BPRINT: {
-		struct bprint_entry *field;
-		trace_assign_type(field, entry);
-		return print_graph_comment(field, s, entry, iter);
-	}
 	default:
-		return TRACE_TYPE_UNHANDLED;
+		return print_graph_comment(s, entry, iter);
 	}
+
+	return TRACE_TYPE_HANDLED;
 }
 
 static void print_graph_headers(struct seq_file *s)
-- 
1.6.2

-- 
