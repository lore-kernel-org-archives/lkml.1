Return-Path: <linux-kernel-owner+w=401wt.eu-S1756139AbZIKTd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139AbZIKTd2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 15:33:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756124AbZIKTdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 15:33:03 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:45547 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756044AbZIKTce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 15:32:34 -0400
Message-Id: <20090911193236.321478246@goodmis.org>
References: <20090911193153.444303577@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 11 Sep 2009 15:31:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 3/6] tracing: consolidate code between trace_output.c and trace_function_graph.c
Content-Disposition: inline; filename=0003-tracing-consolidate-code-between-trace_output.c-and-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Both trace_output.c and trace_function_graph.c do basically the same
thing to handle the printing of the latency-format. This patch moves
the code into one function that both can use.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_functions_graph.c |   26 ++------------------------
 kernel/trace/trace_output.c          |   30 ++++++++++++++++++++++++------
 kernel/trace/trace_output.h          |    2 ++
 3 files changed, 28 insertions(+), 30 deletions(-)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 48af493..61f1667 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -367,32 +367,10 @@ print_graph_proc(struct trace_seq *s, pid_t pid)
 static enum print_line_t
 print_graph_lat_fmt(struct trace_seq *s, struct trace_entry *entry)
 {
-	int hardirq, softirq;
-	int ret;
-
-	hardirq = entry->flags & TRACE_FLAG_HARDIRQ;
-	softirq = entry->flags & TRACE_FLAG_SOFTIRQ;
-
-	if (!trace_seq_printf(s, " %c%c%c",
-			      (entry->flags & TRACE_FLAG_IRQS_OFF) ? 'd' :
-				(entry->flags & TRACE_FLAG_IRQS_NOSUPPORT) ?
-				  'X' : '.',
-			      (entry->flags & TRACE_FLAG_NEED_RESCHED) ?
-				'N' : '.',
-			      (hardirq && softirq) ? 'H' :
-				hardirq ? 'h' : softirq ? 's' : '.'))
-		return 0;
-
-	if (entry->lock_depth < 0)
-		ret = trace_seq_putc(s, '.');
-	else
-		ret = trace_seq_printf(s, "%d", entry->lock_depth);
-	if (!ret)
+	if (!trace_seq_putc(s, ' '))
 		return 0;
 
-	if (entry->preempt_count)
-		return trace_seq_printf(s, "%x", entry->preempt_count);
-	return trace_seq_puts(s, ".");
+	return trace_print_lat_fmt(s, entry);
 }
 
 /* If the pid changed since the last trace, output this event */
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 29a370a..f572f44 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -460,19 +460,23 @@ seq_print_ip_sym(struct trace_seq *s, unsigned long ip, unsigned long sym_flags)
 	return ret;
 }
 
-static int
-lat_print_generic(struct trace_seq *s, struct trace_entry *entry, int cpu)
+/**
+ * trace_print_lat_fmt - print the irq, preempt and lockdep fields
+ * @s: trace seq struct to write to
+ * @entry: The trace entry field from the ring buffer
+ *
+ * Prints the generic fields of irqs off, in hard or softirq, preempt
+ * count and lock depth.
+ */
+int trace_print_lat_fmt(struct trace_seq *s, struct trace_entry *entry)
 {
 	int hardirq, softirq;
-	char comm[TASK_COMM_LEN];
 	int ret;
 
-	trace_find_cmdline(entry->pid, comm);
 	hardirq = entry->flags & TRACE_FLAG_HARDIRQ;
 	softirq = entry->flags & TRACE_FLAG_SOFTIRQ;
 
-	if (!trace_seq_printf(s, "%8.8s-%-5d %3d%c%c%c",
-			      comm, entry->pid, cpu,
+	if (!trace_seq_printf(s, "%c%c%c",
 			      (entry->flags & TRACE_FLAG_IRQS_OFF) ? 'd' :
 				(entry->flags & TRACE_FLAG_IRQS_NOSUPPORT) ?
 				  'X' : '.',
@@ -494,6 +498,20 @@ lat_print_generic(struct trace_seq *s, struct trace_entry *entry, int cpu)
 	return trace_seq_putc(s, '.');
 }
 
+static int
+lat_print_generic(struct trace_seq *s, struct trace_entry *entry, int cpu)
+{
+	char comm[TASK_COMM_LEN];
+
+	trace_find_cmdline(entry->pid, comm);
+
+	if (!trace_seq_printf(s, "%8.8s-%-5d %3d",
+			      comm, entry->pid, cpu))
+		return 0;
+
+	return trace_print_lat_fmt(s, entry);
+}
+
 static unsigned long preempt_mark_thresh = 100;
 
 static int
diff --git a/kernel/trace/trace_output.h b/kernel/trace/trace_output.h
index d38bec4..9d91c72 100644
--- a/kernel/trace/trace_output.h
+++ b/kernel/trace/trace_output.h
@@ -26,6 +26,8 @@ extern struct trace_event *ftrace_find_event(int type);
 
 extern enum print_line_t trace_nop_print(struct trace_iterator *iter,
 					 int flags);
+extern int
+trace_print_lat_fmt(struct trace_seq *s, struct trace_entry *entry);
 
 /* used by module unregistering */
 extern int __unregister_ftrace_event(struct trace_event *event);
-- 
1.6.3.3

-- 
