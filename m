Return-Path: <linux-kernel-owner+w=401wt.eu-S1756199AbZIKTdH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199AbZIKTdH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 15:33:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755766AbZIKTdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 15:33:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:38238 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755765AbZIKTcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 15:32:33 -0400
Message-Id: <20090911193236.012261214@goodmis.org>
References: <20090911193153.444303577@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 11 Sep 2009 15:31:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/6] tracing: add lock depth to entries
Content-Disposition: inline; filename=0002-tracing-add-lock-depth-to-entries.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

This patch adds the lock depth of the big kernel lock to the generic
entry header. This way we can see the depth of the lock and help
in removing the BKL.

Example:

 #                  _------=> CPU#
 #                 / _-----=> irqs-off
 #                | / _----=> need-resched
 #                || / _---=> hardirq/softirq
 #                ||| / _--=> preempt-depth
 #                |||| /_--=> lock-depth
 #                |||||/     delay
 #  cmd     pid   |||||| time  |   caller
 #     \   /      ||||||   \   |   /
   <idle>-0       2.N..3 5902255250us+: lock_acquire: read rcu_read_lock
   <idle>-0       2.N..3 5902255253us+: lock_release: rcu_read_lock
   <idle>-0       2dN..3 5902255257us+: lock_acquire: xtime_lock
   <idle>-0       2dN..4 5902255259us : lock_acquire: clocksource_lock
   <idle>-0       2dN..4 5902255261us+: lock_release: clocksource_lock

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h         |    1 +
 kernel/trace/trace.c                 |    9 +++++----
 kernel/trace/trace_events.c          |    5 ++++-
 kernel/trace/trace_functions_graph.c |   16 ++++++++++++----
 kernel/trace/trace_output.c          |   10 +++++++++-
 5 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 06c795b..0608b0f 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -34,6 +34,7 @@ struct trace_entry {
 	unsigned char		flags;
 	unsigned char		preempt_count;
 	int			pid;
+	int			lock_depth;
 };
 
 #define FTRACE_MAX_EVENT						\
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 1a37da2..3b91828 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -886,6 +886,7 @@ tracing_generic_entry_update(struct trace_entry *entry, unsigned long flags,
 
 	entry->preempt_count		= pc & 0xff;
 	entry->pid			= (tsk) ? tsk->pid : 0;
+	entry->lock_depth		= (tsk) ? tsk->lock_depth : 0;
 	entry->flags =
 #ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT
 		(irqs_disabled_flags(flags) ? TRACE_FLAG_IRQS_OFF : 0) |
@@ -1530,10 +1531,10 @@ static void print_lat_help_header(struct seq_file *m)
 	seq_puts(m, "#                | / _----=> need-resched    \n");
 	seq_puts(m, "#                || / _---=> hardirq/softirq \n");
 	seq_puts(m, "#                ||| / _--=> preempt-depth   \n");
-	seq_puts(m, "#                |||| /                      \n");
-	seq_puts(m, "#                |||||     delay             \n");
-	seq_puts(m, "#  cmd     pid   ||||| time  |   caller      \n");
-	seq_puts(m, "#     \\   /      |||||   \\   |   /           \n");
+	seq_puts(m, "#                |||| /_--=> lock-depth       \n");
+	seq_puts(m, "#                |||||/     delay             \n");
+	seq_puts(m, "#  cmd     pid   |||||| time  |   caller      \n");
+	seq_puts(m, "#     \\   /      ||||||   \\   |   /           \n");
 }
 
 static void print_func_help_header(struct seq_file *m)
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 28d9202..975f324 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -86,6 +86,7 @@ int trace_define_common_fields(struct ftrace_event_call *call)
 	__common_field(unsigned char, flags);
 	__common_field(unsigned char, preempt_count);
 	__common_field(int, pid);
+	__common_field(int, lock_depth);
 
 	return ret;
 }
@@ -571,11 +572,13 @@ static int trace_write_header(struct trace_seq *s)
 				"\tfield:%s %s;\toffset:%zu;\tsize:%zu;\n"
 				"\tfield:%s %s;\toffset:%zu;\tsize:%zu;\n"
 				"\tfield:%s %s;\toffset:%zu;\tsize:%zu;\n"
+				"\tfield:%s %s;\toffset:%zu;\tsize:%zu;\n"
 				"\n",
 				FIELD(unsigned short, type),
 				FIELD(unsigned char, flags),
 				FIELD(unsigned char, preempt_count),
-				FIELD(int, pid));
+				FIELD(int, pid),
+				FIELD(int, lock_depth));
 }
 
 static ssize_t
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index ee791a9..48af493 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -368,6 +368,7 @@ static enum print_line_t
 print_graph_lat_fmt(struct trace_seq *s, struct trace_entry *entry)
 {
 	int hardirq, softirq;
+	int ret;
 
 	hardirq = entry->flags & TRACE_FLAG_HARDIRQ;
 	softirq = entry->flags & TRACE_FLAG_SOFTIRQ;
@@ -382,6 +383,13 @@ print_graph_lat_fmt(struct trace_seq *s, struct trace_entry *entry)
 				hardirq ? 'h' : softirq ? 's' : '.'))
 		return 0;
 
+	if (entry->lock_depth < 0)
+		ret = trace_seq_putc(s, '.');
+	else
+		ret = trace_seq_printf(s, "%d", entry->lock_depth);
+	if (!ret)
+		return 0;
+
 	if (entry->preempt_count)
 		return trace_seq_printf(s, "%x", entry->preempt_count);
 	return trace_seq_puts(s, ".");
@@ -1001,8 +1009,8 @@ static void print_lat_header(struct seq_file *s)
 	seq_printf(s, "#%.*s / _----=> need-resched    \n", size, spaces);
 	seq_printf(s, "#%.*s| / _---=> hardirq/softirq \n", size, spaces);
 	seq_printf(s, "#%.*s|| / _--=> preempt-depth   \n", size, spaces);
-	seq_printf(s, "#%.*s||| /                      \n", size, spaces);
-	seq_printf(s, "#%.*s||||                       \n", size, spaces);
+	seq_printf(s, "#%.*s||| / _-=> lock-depth      \n", size, spaces);
+	seq_printf(s, "#%.*s|||| /                     \n", size, spaces);
 }
 
 static void print_graph_headers(struct seq_file *s)
@@ -1021,7 +1029,7 @@ static void print_graph_headers(struct seq_file *s)
 	if (tracer_flags.val & TRACE_GRAPH_PRINT_PROC)
 		seq_printf(s, "  TASK/PID       ");
 	if (lat)
-		seq_printf(s, "||||");
+		seq_printf(s, "|||||");
 	if (tracer_flags.val & TRACE_GRAPH_PRINT_DURATION)
 		seq_printf(s, "  DURATION   ");
 	seq_printf(s, "               FUNCTION CALLS\n");
@@ -1035,7 +1043,7 @@ static void print_graph_headers(struct seq_file *s)
 	if (tracer_flags.val & TRACE_GRAPH_PRINT_PROC)
 		seq_printf(s, "   |    |        ");
 	if (lat)
-		seq_printf(s, "||||");
+		seq_printf(s, "|||||");
 	if (tracer_flags.val & TRACE_GRAPH_PRINT_DURATION)
 		seq_printf(s, "   |   |      ");
 	seq_printf(s, "               |   |   |   |\n");
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index be34a6a..29a370a 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -465,6 +465,7 @@ lat_print_generic(struct trace_seq *s, struct trace_entry *entry, int cpu)
 {
 	int hardirq, softirq;
 	char comm[TASK_COMM_LEN];
+	int ret;
 
 	trace_find_cmdline(entry->pid, comm);
 	hardirq = entry->flags & TRACE_FLAG_HARDIRQ;
@@ -481,9 +482,16 @@ lat_print_generic(struct trace_seq *s, struct trace_entry *entry, int cpu)
 				hardirq ? 'h' : softirq ? 's' : '.'))
 		return 0;
 
+	if (entry->lock_depth < 0)
+		ret = trace_seq_putc(s, '.');
+	else
+		ret = trace_seq_printf(s, "%d", entry->lock_depth);
+	if (!ret)
+		return 0;
+
 	if (entry->preempt_count)
 		return trace_seq_printf(s, "%x", entry->preempt_count);
-	return trace_seq_puts(s, ".");
+	return trace_seq_putc(s, '.');
 }
 
 static unsigned long preempt_mark_thresh = 100;
-- 
1.6.3.3

-- 
