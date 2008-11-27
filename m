Return-Path: <linux-kernel-owner+w=401wt.eu-S1754910AbYK0XnE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910AbYK0XnE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 18:43:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbYK0Xmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 18:42:53 -0500
Received: from fk-out-0910.google.com ([209.85.128.184]:19849 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbYK0Xmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 18:42:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=OTLVPWQJBM2KQhl/I74UUgADSgpOPHvlVA62uO/IvLGZe9CY86a0kiAOo2H9R45Dh+
         dPdPxiHOGbTAfS51Q1kpgcyjmEGUDsKPsJ4975ItqoFYiLOLHUpbZ7UVwb44mL09ywCZ
         W09wm0M9y+kDKiSsMreW1aRRoxjyoh4K0qYVI=
Message-ID: <492F3076.7050104@gmail.com>
Date: Fri, 28 Nov 2008 00:42:46 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>, Tim Bird <tim.bird@am.sony.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing/function-graph-tracer: adjustments of the trace informations
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: increase visibility of the output

This patch applies various changes.

_CPU is now a decimal number, followed by a parenthesis.

_Overhead is now on the second column (gives a good visibility)

_Cost is now on the third column, can't exceed 9999.99 us. It is followed
 by a virtual line based on a "|" character.

_Functions calls are now the last column on the right. This way, we haven't
 dynamic column (which flow is harder to follow) on its right.

_CPU and Overhead have their own option flag. They are default-on but you can
 disable them easily:

 echo nofuncgraph-cpu > trace_options
 echo nofuncgraph-overhead > trace_options

TODO:

_ Refactoring of the thread switch output.
_ Give a default-off option to output the thread and its pid on each row.
_ Provide headers
_ ....

Here is an example of the new trace style (a wider one is provided in attachment):

0)           |             mutex_unlock() {
0)      0.639 us |           __mutex_unlock_slowpath();
0)      1.607 us |         }
0)           |             remove_wait_queue() {
0)      0.616 us |           _spin_lock_irqsave();
0)      0.616 us |           _spin_unlock_irqrestore();
0)      2.779 us |         }
0)      0.495 us |         n_tty_set_room();
0) ! 9999.999 us |       }
0)           |           tty_ldisc_deref() {
0)      0.615 us |         _spin_lock_irqsave();
0)      0.616 us |         _spin_unlock_irqrestore();
0)      2.793 us |       }
0)           |           current_fs_time() {
0)      0.488 us |         current_kernel_time();
0)      0.495 us |         timespec_trunc();
0)      2.486 us |       }
0) ! 9999.999 us |     }
0) ! 9999.999 us |   }
0) ! 9999.999 us | }
0)           |     sys_read() {
0)      0.796 us |   fget_light();
0)           |       vfs_read() {
0)           |         rw_verify_area() {
0)           |           security_file_permission() {
0)      0.488 us |         cap_file_permission();
0)      1.720 us |       }
0)      3.  4 us |     }
0)           |         tty_read() {
0)      0.488 us |       tty_paranoia_check();
0)           |           tty_ldisc_ref_wait() {
0)           |             tty_ldisc_try() {
0)      0.615 us |           _spin_lock_irqsave();
0)      0.615 us |           _spin_unlock_irqrestore();
0)      5.436 us |         }
0)      6.427 us |       }

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace_functions_graph.c |  142 ++++++++++++++++++++++------------
 1 files changed, 93 insertions(+), 49 deletions(-)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index b958d60..596a3ee 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -14,20 +14,25 @@
 #include "trace.h"
 
 #define TRACE_GRAPH_INDENT	2
-/* Spaces between function call and time duration */
-#define TRACE_GRAPH_TIMESPACE_ENTRY	"                    "
-/* Spaces between function call and closing braces */
-#define TRACE_GRAPH_TIMESPACE_RET	"                               "
 
+/* Flag options */
 #define TRACE_GRAPH_PRINT_OVERRUN	0x1
+#define TRACE_GRAPH_PRINT_CPU		0x2
+#define TRACE_GRAPH_PRINT_OVERHEAD	0x4
+
 static struct tracer_opt trace_opts[] = {
-	/* Display overruns or not */
-	{ TRACER_OPT(overrun, TRACE_GRAPH_PRINT_OVERRUN) },
+	/* Display overruns ? */
+	{ TRACER_OPT(funcgraph-overrun, TRACE_GRAPH_PRINT_OVERRUN) },
+	/* Display CPU ? */
+	{ TRACER_OPT(funcgraph-cpu, TRACE_GRAPH_PRINT_CPU) },
+	/* Display Overhead ? */
+	{ TRACER_OPT(funcgraph-overhead, TRACE_GRAPH_PRINT_OVERHEAD) },
 	{ } /* Empty entry */
 };
 
 static struct tracer_flags tracer_flags = {
-	.val = 0, /* Don't display overruns by default */
+	/* Don't display overruns by default */
+	.val = TRACE_GRAPH_PRINT_CPU | TRACE_GRAPH_PRINT_OVERHEAD,
 	.opts = trace_opts
 };
 
@@ -56,6 +61,36 @@ static void graph_trace_reset(struct trace_array *tr)
 	unregister_ftrace_graph();
 }
 
+static inline int log10_cpu(int nb)
+{
+	if (nb / 100)
+		return 3;
+	if (nb / 10)
+		return 2;
+	return 1;
+}
+
+static enum print_line_t
+print_graph_cpu(struct trace_seq *s, int cpu)
+{
+	int i;
+	int ret;
+	int log10_this = log10_cpu(cpu);
+	int log10_all = log10_cpu(cpus_weight_nr(cpu_online_map));
+
+
+	for (i = 0; i < log10_all - log10_this; i++) {
+		ret = trace_seq_printf(s, " ");
+		if (!ret)
+			return TRACE_TYPE_PARTIAL_LINE;
+	}
+	ret = trace_seq_printf(s, "%d) ", cpu);
+	if (!ret)
+			return TRACE_TYPE_PARTIAL_LINE;
+	return TRACE_TYPE_HANDLED;
+}
+
+
 /* If the pid changed since the last trace, output this event */
 static int verif_pid(struct trace_seq *s, pid_t pid, int cpu)
 {
@@ -67,8 +102,7 @@ static int verif_pid(struct trace_seq *s, pid_t pid, int cpu)
 	last_pid[cpu] = pid;
 	comm = trace_find_cmdline(pid);
 
-	return trace_seq_printf(s, "\nCPU[%03d] "
-				    " ------------8<---------- thread %s-%d"
+	return trace_seq_printf(s, "\n------------8<---------- thread %s-%d"
 				    " ------------8<----------\n\n",
 				    cpu, comm, pid);
 }
@@ -86,7 +120,7 @@ trace_branch_is_leaf(struct trace_iterator *iter,
 	if (!ring_iter)
 		return false;
 
-	event = ring_buffer_iter_peek(iter->buffer_iter[iter->cpu], NULL);
+	event = ring_buffer_iter_peek(ring_iter, NULL);
 
 	if (!event)
 		return false;
@@ -108,7 +142,7 @@ static inline int
 print_graph_duration(unsigned long long duration, struct trace_seq *s)
 {
 	unsigned long nsecs_rem = do_div(duration, 1000);
-	return trace_seq_printf(s, "+ %llu.%lu us\n", duration, nsecs_rem);
+	return trace_seq_printf(s, "%4llu.%3lu us | ", duration, nsecs_rem);
 }
 
 /* Signal a overhead of time execution to the output */
@@ -136,8 +170,8 @@ print_graph_entry_leaf(struct trace_iterator *iter,
 	struct ring_buffer_event *event;
 	struct ftrace_graph_ent *call;
 	unsigned long long duration;
-	int i;
 	int ret;
+	int i;
 
 	event = ring_buffer_read(iter->buffer_iter[iter->cpu], NULL);
 	ret_entry = ring_buffer_event_data(event);
@@ -145,8 +179,19 @@ print_graph_entry_leaf(struct trace_iterator *iter,
 	call = &entry->graph_ent;
 	duration = graph_ret->rettime - graph_ret->calltime;
 
+	/* Must not exceed 8 characters: 9999.999 us */
+	if (duration > 10000000ULL)
+		duration = 9999999ULL;
+
 	/* Overhead */
-	ret = print_graph_overhead(duration, s);
+	if (tracer_flags.val & TRACE_GRAPH_PRINT_OVERHEAD) {
+		ret = print_graph_overhead(duration, s);
+		if (!ret)
+			return TRACE_TYPE_PARTIAL_LINE;
+	}
+
+	/* Duration */
+	ret = print_graph_duration(duration, s);
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
@@ -161,16 +206,7 @@ print_graph_entry_leaf(struct trace_iterator *iter,
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
-	ret = trace_seq_printf(s, "();");
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
-
-	/* Duration */
-	ret = trace_seq_printf(s, TRACE_GRAPH_TIMESPACE_ENTRY);
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
-
-	ret = print_graph_duration(duration, s);
+	ret = trace_seq_printf(s, "();\n");
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
@@ -186,9 +222,14 @@ print_graph_entry_nested(struct ftrace_graph_ent_entry *entry,
 	struct ftrace_graph_ent *call = &entry->graph_ent;
 
 	/* No overhead */
-	ret = trace_seq_printf(s, "  ");
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
+	if (tracer_flags.val & TRACE_GRAPH_PRINT_OVERHEAD) {
+		ret = trace_seq_printf(s, "  ");
+		if (!ret)
+			return TRACE_TYPE_PARTIAL_LINE;
+	}
+
+	/* No time */
+	ret = trace_seq_printf(s, "        |     ");
 
 	/* Function */
 	for (i = 0; i < call->depth * TRACE_GRAPH_INDENT; i++) {
@@ -201,12 +242,7 @@ print_graph_entry_nested(struct ftrace_graph_ent_entry *entry,
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
-	ret = trace_seq_printf(s, "() {");
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
-
-	/* No duration to print at this state */
-	ret = trace_seq_printf(s, TRACE_GRAPH_TIMESPACE_ENTRY "-\n");
+	ret = trace_seq_printf(s, "() {\n");
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
@@ -220,12 +256,16 @@ print_graph_entry(struct ftrace_graph_ent_entry *field, struct trace_seq *s,
 	int ret;
 	struct trace_entry *ent = iter->ent;
 
+	/* Pid */
 	if (!verif_pid(s, ent->pid, cpu))
 		return TRACE_TYPE_PARTIAL_LINE;
 
-	ret = trace_seq_printf(s, "CPU[%03d] ", cpu);
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
+	/* Cpu */
+	if (tracer_flags.val & TRACE_GRAPH_PRINT_CPU) {
+		ret = print_graph_cpu(s, cpu);
+		if (!ret)
+			return TRACE_TYPE_PARTIAL_LINE;
+	}
 
 	if (trace_branch_is_leaf(iter, field))
 		return print_graph_entry_leaf(iter, field, s);
@@ -242,17 +282,30 @@ print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
 	int ret;
 	unsigned long long duration = trace->rettime - trace->calltime;
 
+	/* Must not exceed 8 characters: xxxx.yyy us */
+	if (duration > 10000000ULL)
+		duration = 9999999ULL;
+
 	/* Pid */
 	if (!verif_pid(s, ent->pid, cpu))
 		return TRACE_TYPE_PARTIAL_LINE;
 
 	/* Cpu */
-	ret = trace_seq_printf(s, "CPU[%03d] ", cpu);
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
+	if (tracer_flags.val & TRACE_GRAPH_PRINT_CPU) {
+		ret = print_graph_cpu(s, cpu);
+		if (!ret)
+			return TRACE_TYPE_PARTIAL_LINE;
+	}
 
 	/* Overhead */
-	ret = print_graph_overhead(duration, s);
+	if (tracer_flags.val & TRACE_GRAPH_PRINT_OVERHEAD) {
+		ret = print_graph_overhead(duration, s);
+		if (!ret)
+			return TRACE_TYPE_PARTIAL_LINE;
+	}
+
+	/* Duration */
+	ret = print_graph_duration(duration, s);
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
@@ -263,16 +316,7 @@ print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
 			return TRACE_TYPE_PARTIAL_LINE;
 	}
 
-	ret = trace_seq_printf(s, "} ");
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
-
-	/* Duration */
-	ret = trace_seq_printf(s, TRACE_GRAPH_TIMESPACE_RET);
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
-
-	ret = print_graph_duration(duration, s);
+	ret = trace_seq_printf(s, "}\n");
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
-- 
1.5.2.5
