Return-Path: <linux-kernel-owner+w=401wt.eu-S1754156AbZBRFwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbZBRFwp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 00:52:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751397AbZBRFwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 00:52:35 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:55738 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbZBRFwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 00:52:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:from:to:cc:date:subject;
        b=GsHIMBqjgMySxPHtsQCVMNmV5HfiZYuHjsfqNOY6iwHrIoec5KwDkl2cLLYKr6zEu0
         tYePYRCVP2+ctCYhWD/zFAivL/x0XZTHI/k2fV8s4dE/SHbdTs5Ht7U6zsm5lWiOAEjw
         ERhgSkGcHgDUHoHsWpmnHsxF1KduPwmpcFfp8=
Message-ID: <499ba220.0508d00a.2110.ffffac34@mx.google.com>
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, linux-kernel@vger.kernel.org
Date: Wed, 18 Feb 2009 04:25:25 +0100
Subject: [PATCH 1/2] tracing/function-graph-tracer: fix traces weirdness while absolute time printing
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: trace output cleanup/reordering

When an interrupt occurs and and the abstime option is selected

echo funcgraph-abstime > /debug/tracing/trace_options

then we observe broken traces:

30581.025422 |   0)   Xorg-4291    |   0.503 us    |      idle_cpu();
30581.025424 |   0)   Xorg-4291    |   2.576 us    |    }
30581.025424 |   0)   Xorg-4291    | + 75.771 us   |  }
 0)   Xorg-4291    |   <========== |
30581.025425 |   0)   Xorg-4291    |               |  schedule() {
30581.025426 |   0)   Xorg-4291    |               |    __schedule() {
30581.025426 |   0)   Xorg-4291    |   0.705 us    |      _spin_lock_irq();

With this patch, the interrupts output better adapts on absolute time printing:

  414.856543 |   1)   Xorg-4279    |   8.816 us    |                        }
  414.856544 |   1)   Xorg-4279    |   0.525 us    |                        rcu_irq_exit();
  414.856545 |   1)   Xorg-4279    |   0.526 us    |                        idle_cpu();
  414.856546 |   1)   Xorg-4279    | + 12.157 us   |                      }
  414.856549 |   1)   Xorg-4279    | ! 104.114 us  |                    }
  414.856549 |   1)   Xorg-4279    |   <========== |
  414.856549 |   1)   Xorg-4279    | ! 107.944 us  |                  }
  414.856550 |   1)   Xorg-4279    | ! 137.010 us  |                }
  414.856551 |   1)   Xorg-4279    |   0.624 us    |                _read_unlock();
  414.856552 |   1)   Xorg-4279    | ! 140.930 us  |              }
  414.856552 |   1)   Xorg-4279    | ! 166.159 us  |            }

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace_functions_graph.c |   50 +++++++++++++++++++--------------
 1 files changed, 29 insertions(+), 21 deletions(-)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 0ff5cb6..5c19937 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -276,16 +276,35 @@ print_graph_overhead(unsigned long long duration, struct trace_seq *s)
 	return trace_seq_printf(s, "  ");
 }
 
+static int print_graph_abs_time(u64 t, struct trace_seq *s)
+{
+	unsigned long usecs_rem;
+
+	usecs_rem = do_div(t, NSEC_PER_SEC);
+	usecs_rem /= 1000;
+
+	return trace_seq_printf(s, "%5lu.%06lu |  ",
+			(unsigned long)t, usecs_rem);
+}
+
 static enum print_line_t
-print_graph_irq(struct trace_seq *s, unsigned long addr,
+print_graph_irq(struct trace_iterator *iter, unsigned long addr,
 		enum trace_type type, int cpu, pid_t pid)
 {
 	int ret;
+	struct trace_seq *s = &iter->seq;
 
 	if (addr < (unsigned long)__irqentry_text_start ||
 		addr >= (unsigned long)__irqentry_text_end)
 		return TRACE_TYPE_UNHANDLED;
 
+	/* Absolute time */
+	if (tracer_flags.val & TRACE_GRAPH_PRINT_ABS_TIME) {
+		ret = print_graph_abs_time(iter->ts, s);
+		if (!ret)
+			return TRACE_TYPE_PARTIAL_LINE;
+	}
+
 	/* Cpu */
 	if (tracer_flags.val & TRACE_GRAPH_PRINT_CPU) {
 		ret = print_graph_cpu(s, cpu);
@@ -371,17 +390,6 @@ print_graph_duration(unsigned long long duration, struct trace_seq *s)
 
 }
 
-static int print_graph_abs_time(u64 t, struct trace_seq *s)
-{
-	unsigned long usecs_rem;
-
-	usecs_rem = do_div(t, 1000000000);
-	usecs_rem /= 1000;
-
-	return trace_seq_printf(s, "%5lu.%06lu |  ",
-			(unsigned long)t, usecs_rem);
-}
-
 /* Case of a leaf function on its call entry */
 static enum print_line_t
 print_graph_entry_leaf(struct trace_iterator *iter,
@@ -486,7 +494,7 @@ print_graph_entry(struct ftrace_graph_ent_entry *field, struct trace_seq *s,
 		return TRACE_TYPE_PARTIAL_LINE;
 
 	/* Interrupt */
-	ret = print_graph_irq(s, call->func, TRACE_GRAPH_ENT, cpu, ent->pid);
+	ret = print_graph_irq(iter, call->func, TRACE_GRAPH_ENT, cpu, ent->pid);
 	if (ret == TRACE_TYPE_PARTIAL_LINE)
 		return TRACE_TYPE_PARTIAL_LINE;
 
@@ -530,11 +538,11 @@ print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
 	int i;
 	int ret;
 	int cpu = iter->cpu;
-	pid_t *last_pid = iter->private;
+	pid_t *last_pid = iter->private, pid = ent->pid;
 	unsigned long long duration = trace->rettime - trace->calltime;
 
 	/* Pid */
-	if (verif_pid(s, ent->pid, cpu, last_pid) == TRACE_TYPE_PARTIAL_LINE)
+	if (verif_pid(s, pid, cpu, last_pid) == TRACE_TYPE_PARTIAL_LINE)
 		return TRACE_TYPE_PARTIAL_LINE;
 
 	/* Absolute time */
@@ -553,7 +561,7 @@ print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
 
 	/* Proc */
 	if (tracer_flags.val & TRACE_GRAPH_PRINT_PROC) {
-		ret = print_graph_proc(s, ent->pid);
+		ret = print_graph_proc(s, pid);
 		if (ret == TRACE_TYPE_PARTIAL_LINE)
 			return TRACE_TYPE_PARTIAL_LINE;
 
@@ -593,7 +601,7 @@ print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
 			return TRACE_TYPE_PARTIAL_LINE;
 	}
 
-	ret = print_graph_irq(s, trace->func, TRACE_GRAPH_RET, cpu, ent->pid);
+	ret = print_graph_irq(iter, trace->func, TRACE_GRAPH_RET, cpu, pid);
 	if (ret == TRACE_TYPE_PARTIAL_LINE)
 		return TRACE_TYPE_PARTIAL_LINE;
 
@@ -609,6 +617,10 @@ print_graph_comment(struct print_entry *trace, struct trace_seq *s,
 	int cpu = iter->cpu;
 	pid_t *last_pid = iter->private;
 
+	/* Pid */
+	if (verif_pid(s, ent->pid, cpu, last_pid) == TRACE_TYPE_PARTIAL_LINE)
+		return TRACE_TYPE_PARTIAL_LINE;
+
 	/* Absolute time */
 	if (tracer_flags.val & TRACE_GRAPH_PRINT_ABS_TIME) {
 		ret = print_graph_abs_time(iter->ts, s);
@@ -616,10 +628,6 @@ print_graph_comment(struct print_entry *trace, struct trace_seq *s,
 			return TRACE_TYPE_PARTIAL_LINE;
 	}
 
-	/* Pid */
-	if (verif_pid(s, ent->pid, cpu, last_pid) == TRACE_TYPE_PARTIAL_LINE)
-		return TRACE_TYPE_PARTIAL_LINE;
-
 	/* Cpu */
 	if (tracer_flags.val & TRACE_GRAPH_PRINT_CPU) {
 		ret = print_graph_cpu(s, cpu);
-- 
1.6.1


