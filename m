Return-Path: <linux-kernel-owner+w=401wt.eu-S1755165AbYK0Aqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165AbYK0Aqt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 19:46:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbYK0Aqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 19:46:40 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:16731 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599AbYK0Aqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 19:46:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=TACPMzjs7i6tlSFImRI9SMRQCh7ZzTBPXUOzt8QOwM9868PcPJFoS6DVslJvVIQ38P
         fhCsTuwANXPPr55d+rvRnZw1uXCLrnfLXlSpo6XEM/ExFdOjclG/C0yY+sQuJ0LgSdeU
         3oyuv64gY020Xw7OVCnX5lxznaHv3+1wiiOd4=
Message-ID: <492DEDE9.9010109@gmail.com>
Date: Thu, 27 Nov 2008 01:46:33 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>, Tim Bird <tim.bird@am.sony.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing/function-branch-tracer: enhancements for the trace
 output
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: enhancement

This patch applies some ideas of Ingo Molnar and Steven Rostedt.

* Output leaf functions in one line with parenthesis, semicolon and duration
  output.

* Add a second column (after cpu) for an overhead sign.
  if duration > 100 us, "!"
  if duration > 10 us, "+"
  else " "

* Print output in us with remaining nanosec: u.n

* Print duration on the right end, following the indentation of the functions.
  Use also visual clues: "-" on entry call (no duration to output) and "+" on
  return (duration output).

The name of the tracer has been fixed as well: function-branch becomes
function_branch.

Here is an example of the new output:

CPU[000]           dequeue_entity() {                    -
CPU[000]             update_curr() {                    -
CPU[000]               update_min_vruntime();                    + 0.512 us
CPU[000]             }                                + 1.504 us
CPU[000]             clear_buddies();                    + 0.481 us
CPU[000]             update_min_vruntime();                    + 0.504 us
CPU[000]           }                                + 4.557 us
CPU[000]           hrtick_update() {                    -
CPU[000]             hrtick_start_fair();                    + 0.489 us
CPU[000]           }                                + 1.443 us
CPU[000] +       }                                + 14.655 us
CPU[000] +     }                                + 15.678 us
CPU[000] +   }                                + 16.686 us
CPU[000]     msecs_to_jiffies();                    + 0.481 us
CPU[000]     put_prev_task_fair();                    + 0.504 us
CPU[000]     pick_next_task_fair();                    + 0.482 us
CPU[000]     pick_next_task_rt();                    + 0.504 us
CPU[000]     pick_next_task_fair();                    + 0.481 us
CPU[000]     pick_next_task_idle();                    + 0.489 us
CPU[000]     _spin_trylock();                    + 0.655 us
CPU[000]     _spin_unlock();                    + 0.609 us

CPU[000]  ------------8<---------- thread bash-2794 ------------8<----------

CPU[000]               finish_task_switch() {                    -
CPU[000]                 _spin_unlock_irq();                    + 0.722 us
CPU[000]               }                                + 2.369 us
CPU[000] !           }                                + 501972.605 us
CPU[000] !         }                                + 501973.763 us
CPU[000]           copy_from_read_buf() {                    -
CPU[000]             _spin_lock_irqsave();                    + 0.670 us
CPU[000]             _spin_unlock_irqrestore();                    + 0.699 us
CPU[000]             copy_to_user() {                    -
CPU[000]               might_fault() {                    -
CPU[000]                 __might_sleep();                    + 0.503 us
CPU[000]               }                                + 1.632 us
CPU[000]               __copy_to_user_ll();                    + 0.542 us
CPU[000]             }                                + 3.858 us
CPU[000]             tty_audit_add_data() {                    -
CPU[000]               _spin_lock_irq();                    + 0.609 us
CPU[000]               _spin_unlock_irq();                    + 0.624 us
CPU[000]             }                                + 3.196 us
CPU[000]             _spin_lock_irqsave();                    + 0.624 us
CPU[000]             _spin_unlock_irqrestore();                    + 0.625 us
CPU[000] +         }                                + 13.611 us
CPU[000]           copy_from_read_buf() {                    -
CPU[000]             _spin_lock_irqsave();                    + 0.624 us
CPU[000]             _spin_unlock_irqrestore();                    + 0.616 us
CPU[000]           }                                + 2.820 us
CPU[000]

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace_functions_graph.c |  168 ++++++++++++++++++++++++++++++++--
 1 files changed, 159 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index d31d695..b958d60 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -14,6 +14,10 @@
 #include "trace.h"
 
 #define TRACE_GRAPH_INDENT	2
+/* Spaces between function call and time duration */
+#define TRACE_GRAPH_TIMESPACE_ENTRY	"                    "
+/* Spaces between function call and closing braces */
+#define TRACE_GRAPH_TIMESPACE_RET	"                               "
 
 #define TRACE_GRAPH_PRINT_OVERRUN	0x1
 static struct tracer_opt trace_opts[] = {
@@ -63,26 +67,130 @@ static int verif_pid(struct trace_seq *s, pid_t pid, int cpu)
 	last_pid[cpu] = pid;
 	comm = trace_find_cmdline(pid);
 
-	return trace_seq_printf(s, "\nCPU[%03d]"
+	return trace_seq_printf(s, "\nCPU[%03d] "
 				    " ------------8<---------- thread %s-%d"
 				    " ------------8<----------\n\n",
 				    cpu, comm, pid);
 }
 
+static bool
+trace_branch_is_leaf(struct trace_iterator *iter,
+		struct ftrace_graph_ent_entry *curr)
+{
+	struct ring_buffer_iter *ring_iter;
+	struct ring_buffer_event *event;
+	struct ftrace_graph_ret_entry *next;
+
+	ring_iter = iter->buffer_iter[iter->cpu];
+
+	if (!ring_iter)
+		return false;
+
+	event = ring_buffer_iter_peek(iter->buffer_iter[iter->cpu], NULL);
+
+	if (!event)
+		return false;
+
+	next = ring_buffer_event_data(event);
+
+	if (next->ent.type != TRACE_GRAPH_RET)
+		return false;
+
+	if (curr->ent.pid != next->ent.pid ||
+			curr->graph_ent.func != next->ret.func)
+		return false;
+
+	return true;
+}
+
+
+static inline int
+print_graph_duration(unsigned long long duration, struct trace_seq *s)
+{
+	unsigned long nsecs_rem = do_div(duration, 1000);
+	return trace_seq_printf(s, "+ %llu.%lu us\n", duration, nsecs_rem);
+}
+
+/* Signal a overhead of time execution to the output */
+static int
+print_graph_overhead(unsigned long long duration, struct trace_seq *s)
+{
+	/* Duration exceeded 100 msecs */
+	if (duration > 100000ULL)
+		return trace_seq_printf(s, "! ");
+
+	/* Duration exceeded 10 msecs */
+	if (duration > 10000ULL)
+		return trace_seq_printf(s, "+ ");
+
+	return trace_seq_printf(s, "  ");
+}
+
+/* Case of a leaf function on its call entry */
 static enum print_line_t
-print_graph_entry(struct ftrace_graph_ent *call, struct trace_seq *s,
-		  struct trace_entry *ent, int cpu)
+print_graph_entry_leaf(struct trace_iterator *iter,
+		struct ftrace_graph_ent_entry *entry, struct trace_seq *s)
 {
+	struct ftrace_graph_ret_entry *ret_entry;
+	struct ftrace_graph_ret *graph_ret;
+	struct ring_buffer_event *event;
+	struct ftrace_graph_ent *call;
+	unsigned long long duration;
 	int i;
 	int ret;
 
-	if (!verif_pid(s, ent->pid, cpu))
+	event = ring_buffer_read(iter->buffer_iter[iter->cpu], NULL);
+	ret_entry = ring_buffer_event_data(event);
+	graph_ret = &ret_entry->ret;
+	call = &entry->graph_ent;
+	duration = graph_ret->rettime - graph_ret->calltime;
+
+	/* Overhead */
+	ret = print_graph_overhead(duration, s);
+	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
-	ret = trace_seq_printf(s, "CPU[%03d] ", cpu);
+	/* Function */
+	for (i = 0; i < call->depth * TRACE_GRAPH_INDENT; i++) {
+		ret = trace_seq_printf(s, " ");
+		if (!ret)
+			return TRACE_TYPE_PARTIAL_LINE;
+	}
+
+	ret = seq_print_ip_sym(s, call->func, 0);
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	ret = trace_seq_printf(s, "();");
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
+	/* Duration */
+	ret = trace_seq_printf(s, TRACE_GRAPH_TIMESPACE_ENTRY);
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	ret = print_graph_duration(duration, s);
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	return TRACE_TYPE_HANDLED;
+}
+
+static enum print_line_t
+print_graph_entry_nested(struct ftrace_graph_ent_entry *entry,
+			struct trace_seq *s)
+{
+	int i;
+	int ret;
+	struct ftrace_graph_ent *call = &entry->graph_ent;
+
+	/* No overhead */
+	ret = trace_seq_printf(s, "  ");
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	/* Function */
 	for (i = 0; i < call->depth * TRACE_GRAPH_INDENT; i++) {
 		ret = trace_seq_printf(s, " ");
 		if (!ret)
@@ -93,26 +201,62 @@ print_graph_entry(struct ftrace_graph_ent *call, struct trace_seq *s,
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
-	ret = trace_seq_printf(s, "() {\n");
+	ret = trace_seq_printf(s, "() {");
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
+
+	/* No duration to print at this state */
+	ret = trace_seq_printf(s, TRACE_GRAPH_TIMESPACE_ENTRY "-\n");
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
 	return TRACE_TYPE_HANDLED;
 }
 
 static enum print_line_t
+print_graph_entry(struct ftrace_graph_ent_entry *field, struct trace_seq *s,
+			struct trace_iterator *iter, int cpu)
+{
+	int ret;
+	struct trace_entry *ent = iter->ent;
+
+	if (!verif_pid(s, ent->pid, cpu))
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	ret = trace_seq_printf(s, "CPU[%03d] ", cpu);
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	if (trace_branch_is_leaf(iter, field))
+		return print_graph_entry_leaf(iter, field, s);
+	else
+		return print_graph_entry_nested(field, s);
+
+}
+
+static enum print_line_t
 print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
 		   struct trace_entry *ent, int cpu)
 {
 	int i;
 	int ret;
+	unsigned long long duration = trace->rettime - trace->calltime;
 
+	/* Pid */
 	if (!verif_pid(s, ent->pid, cpu))
 		return TRACE_TYPE_PARTIAL_LINE;
 
+	/* Cpu */
 	ret = trace_seq_printf(s, "CPU[%03d] ", cpu);
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
+	/* Overhead */
+	ret = print_graph_overhead(duration, s);
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	/* Closing brace */
 	for (i = 0; i < trace->depth * TRACE_GRAPH_INDENT; i++) {
 		ret = trace_seq_printf(s, " ");
 		if (!ret)
@@ -123,10 +267,16 @@ print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
-	ret = trace_seq_printf(s, "%llu\n", trace->rettime - trace->calltime);
+	/* Duration */
+	ret = trace_seq_printf(s, TRACE_GRAPH_TIMESPACE_RET);
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	ret = print_graph_duration(duration, s);
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
+	/* Overrun */
 	if (tracer_flags.val & TRACE_GRAPH_PRINT_OVERRUN) {
 		ret = trace_seq_printf(s, " (Overruns: %lu)\n",
 					trace->overrun);
@@ -146,7 +296,7 @@ print_graph_function(struct trace_iterator *iter)
 	case TRACE_GRAPH_ENT: {
 		struct ftrace_graph_ent_entry *field;
 		trace_assign_type(field, entry);
-		return print_graph_entry(&field->graph_ent, s, entry,
+		return print_graph_entry(field, s, iter,
 					 iter->cpu);
 	}
 	case TRACE_GRAPH_RET: {
@@ -160,7 +310,7 @@ print_graph_function(struct trace_iterator *iter)
 }
 
 static struct tracer graph_trace __read_mostly = {
-	.name	     = "function-graph",
+	.name	     = "function_graph",
 	.init	     = graph_trace_init,
 	.reset	     = graph_trace_reset,
 	.print_line = print_graph_function,
-- 
1.5.2.5
