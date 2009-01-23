Return-Path: <linux-kernel-owner+w=401wt.eu-S1758677AbZAWBFJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758677AbZAWBFJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 20:05:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754671AbZAWBE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 20:04:56 -0500
Received: from mu-out-0910.google.com ([209.85.134.188]:44739 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754397AbZAWBEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 20:04:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:cc:subject;
        b=eomTHcpp/vrAJtTUtJW0Ln8wTLGIkm3LFnrT5Sj9mI2G9oYxNoo5K4GigXGwoHE1BK
         wh5dMZel9FxlOUG5ytK2gg8EHbwYUq47JzgOaaplhfLy6vm92PIcC6fqUKjw4pnU+L/G
         J76nQnXjMbj/2go1xPdLt+q3SltijfB6igZ4s=
Message-ID: <497917b5.09cc660a.5f4c.ffffc568@mx.google.com>
Date: Thu, 22 Jan 2009 17:04:53 -0800 (PST)
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/2 v2] tracing/function-graph-tracer: various fixes and features
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch brings various bugfixes:

_ Drop the first irrelevant task switch on the very beginning of a trace.
_ Drop the OVERHEAD word from the headers, the DURATION word is sufficient and will not
  overlap other columns.
_ Make the headers fit well their respective columns whatever the selected options.

Ie, default options:

# tracer: function_graph
#
# CPU  DURATION                  FUNCTION CALLS
# |     |   |                     |   |   |   |

 1)   0.646 us    |                    }
 1)               |                    mem_cgroup_del_lru_list() {
 1)   0.624 us    |                      lookup_page_cgroup();
 1)   1.970 us    |                    }

echo funcgraph-proc > trace_options

# tracer: function_graph
#
# CPU  TASK/PID        DURATION                  FUNCTION CALLS
# |    |    |           |   |                     |   |   |   |

 0)   bash-2937    |   0.895 us    |                }
 0)   bash-2937    |   0.888 us    |                __rcu_read_unlock();
 0)   bash-2937    |   0.864 us    |                conv_uni_to_pc();
 0)   bash-2937    |   1.015 us    |                __rcu_read_lock();

echo nofuncgraph-cpu > trace_options
echo nofuncgraph-proc > trace_options

# tracer: function_graph
#
#   DURATION                  FUNCTION CALLS
#    |   |                     |   |   |   |

  3.752 us    |                  native_pud_val();
  0.616 us    |                  native_pud_val();
  0.624 us    |                  native_pmd_val();


About features, one can now disable the duration (this will hide the overhead too
for convenient reasons and because on  doesn't need overhead if it hasn't the duration

echo nofuncgraph-duration > trace_options

# tracer: function_graph
#
#                FUNCTION CALLS
#                |   |   |   |

          cap_vm_enough_memory() {
            __vm_enough_memory() {
              vm_acct_memory();
            }
          }
        }

And at last, an option to print the absolute time:

//Restart from default options
echo funcgraph-abstime > trace_options

# tracer: function_graph
#
#      TIME       CPU  DURATION                  FUNCTION CALLS
#       |         |     |   |                     |   |   |   |

  261.339774 |   1) + 42.823 us   |    }
  261.339775 |   1)   1.045 us    |    _spin_lock_irq();
  261.339777 |   1)   0.940 us    |    _spin_lock_irqsave();
  261.339778 |   1)   0.752 us    |    _spin_unlock_irqrestore();
  261.339780 |   1)   0.857 us    |    _spin_unlock_irq();
  261.339782 |   1)               |    flush_to_ldisc() {
  261.339783 |   1)               |      tty_ldisc_ref() {
  261.339783 |   1)               |        tty_ldisc_try() {
  261.339784 |   1)   1.075 us    |          _spin_lock_irqsave();
  261.339786 |   1)   0.842 us    |          _spin_unlock_irqrestore();
  261.339788 |   1)   4.211 us    |        }
  261.339788 |   1)   5.662 us    |      }

The format is seconds.usecs
I guess no one needs the nanosec precision here, the main goal is to find when happened
the events on a cpu when the trace switches from one cpu to another.

ie:

  274.874760 |   1)   0.676 us    |      _spin_unlock();
  274.874762 |   1)   0.609 us    |      native_load_sp0();
  274.874763 |   1)   0.602 us    |      native_load_tls();
  274.878739 |   0)   0.722 us    |                  }
  274.878740 |   0)   0.714 us    |                  native_pmd_val();
  274.878741 |   0)   0.730 us    |                  native_pmd_val();

Here there is a 4000 usecs difference when we switch the cpu.

Changes in V2:
_ Completely fix the first pointless task switch.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace_functions_graph.c |  298 ++++++++++++++++++++++------------
 1 files changed, 195 insertions(+), 103 deletions(-)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 3c54598..66fc7b8 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -1,7 +1,7 @@
 /*
  *
  * Function graph tracer.
- * Copyright (c) 2008 Frederic Weisbecker <fweisbec@gmail.com>
+ * Copyright (c) 2008-2009 Frederic Weisbecker <fweisbec@gmail.com>
  * Mostly borrowed from function tracer which
  * is Copyright (c) Steven Rostedt <srostedt@redhat.com>
  *
@@ -21,9 +21,11 @@
 #define TRACE_GRAPH_PRINT_CPU		0x2
 #define TRACE_GRAPH_PRINT_OVERHEAD	0x4
 #define TRACE_GRAPH_PRINT_PROC		0x8
+#define TRACE_GRAPH_PRINT_DURATION	0x10
+#define TRACE_GRAPH_PRINT_ABS_TIME	0X20
 
 static struct tracer_opt trace_opts[] = {
-	/* Display overruns ? */
+	/* Display overruns? (for self-debug purpose) */
 	{ TRACER_OPT(funcgraph-overrun, TRACE_GRAPH_PRINT_OVERRUN) },
 	/* Display CPU ? */
 	{ TRACER_OPT(funcgraph-cpu, TRACE_GRAPH_PRINT_CPU) },
@@ -31,17 +33,22 @@ static struct tracer_opt trace_opts[] = {
 	{ TRACER_OPT(funcgraph-overhead, TRACE_GRAPH_PRINT_OVERHEAD) },
 	/* Display proc name/pid */
 	{ TRACER_OPT(funcgraph-proc, TRACE_GRAPH_PRINT_PROC) },
+	/* Display duration of execution */
+	{ TRACER_OPT(funcgraph-duration, TRACE_GRAPH_PRINT_DURATION) },
+	/* Display absolute time of an entry */
+	{ TRACER_OPT(funcgraph-abstime, TRACE_GRAPH_PRINT_ABS_TIME) },
 	{ } /* Empty entry */
 };
 
 static struct tracer_flags tracer_flags = {
 	/* Don't display overruns and proc by default */
-	.val = TRACE_GRAPH_PRINT_CPU | TRACE_GRAPH_PRINT_OVERHEAD,
+	.val = TRACE_GRAPH_PRINT_CPU | TRACE_GRAPH_PRINT_OVERHEAD |
+	       TRACE_GRAPH_PRINT_DURATION,
 	.opts = trace_opts
 };
 
 /* pid on the last trace processed */
-static pid_t last_pid[NR_CPUS] = { [0 ... NR_CPUS-1] = -1 };
+
 
 static int graph_trace_init(struct trace_array *tr)
 {
@@ -154,17 +161,25 @@ print_graph_proc(struct trace_seq *s, pid_t pid)
 
 /* If the pid changed since the last trace, output this event */
 static enum print_line_t
-verif_pid(struct trace_seq *s, pid_t pid, int cpu)
+verif_pid(struct trace_seq *s, pid_t pid, int cpu, pid_t *last_pids_cpu)
 {
 	pid_t prev_pid;
+	pid_t *last_pid;
 	int ret;
 
-	if (last_pid[cpu] != -1 && last_pid[cpu] == pid)
+	if (!last_pids_cpu)
+		return TRACE_TYPE_HANDLED;
+
+	last_pid = per_cpu_ptr(last_pids_cpu, cpu);
+
+	if (*last_pid == pid)
 		return TRACE_TYPE_HANDLED;
 
-	prev_pid = last_pid[cpu];
-	last_pid[cpu] = pid;
+	prev_pid = *last_pid;
+	*last_pid = pid;
 
+	if (prev_pid == -1)
+		return TRACE_TYPE_HANDLED;
 /*
  * Context-switch trace line:
 
@@ -232,9 +247,34 @@ trace_branch_is_leaf(struct trace_iterator *iter,
 	return true;
 }
 
+/* Signal a overhead of time execution to the output */
+static int
+print_graph_overhead(unsigned long long duration, struct trace_seq *s)
+{
+	/* If duration disappear, we don't need anything */
+	if (!(tracer_flags.val & TRACE_GRAPH_PRINT_DURATION))
+		return 1;
+
+	/* Non nested entry or return */
+	if (duration == -1)
+		return trace_seq_printf(s, "  ");
+
+	if (tracer_flags.val & TRACE_GRAPH_PRINT_OVERHEAD) {
+		/* Duration exceeded 100 msecs */
+		if (duration > 100000ULL)
+			return trace_seq_printf(s, "! ");
+
+		/* Duration exceeded 10 msecs */
+		if (duration > 10000ULL)
+			return trace_seq_printf(s, "+ ");
+	}
+
+	return trace_seq_printf(s, "  ");
+}
+
 static enum print_line_t
 print_graph_irq(struct trace_seq *s, unsigned long addr,
-				enum trace_type type, int cpu, pid_t pid)
+		enum trace_type type, int cpu, pid_t pid)
 {
 	int ret;
 
@@ -242,35 +282,40 @@ print_graph_irq(struct trace_seq *s, unsigned long addr,
 		addr >= (unsigned long)__irqentry_text_end)
 		return TRACE_TYPE_UNHANDLED;
 
-	if (type == TRACE_GRAPH_ENT) {
-		ret = trace_seq_printf(s, "==========> |  ");
-	} else {
-		/* Cpu */
-		if (tracer_flags.val & TRACE_GRAPH_PRINT_CPU) {
-			ret = print_graph_cpu(s, cpu);
-			if (ret == TRACE_TYPE_PARTIAL_LINE)
-				return TRACE_TYPE_PARTIAL_LINE;
-		}
-		/* Proc */
-		if (tracer_flags.val & TRACE_GRAPH_PRINT_PROC) {
-			ret = print_graph_proc(s, pid);
-			if (ret == TRACE_TYPE_PARTIAL_LINE)
-				return TRACE_TYPE_PARTIAL_LINE;
+	/* Cpu */
+	if (tracer_flags.val & TRACE_GRAPH_PRINT_CPU) {
+		ret = print_graph_cpu(s, cpu);
+		if (ret == TRACE_TYPE_PARTIAL_LINE)
+			return TRACE_TYPE_PARTIAL_LINE;
+	}
+	/* Proc */
+	if (tracer_flags.val & TRACE_GRAPH_PRINT_PROC) {
+		ret = print_graph_proc(s, pid);
+		if (ret == TRACE_TYPE_PARTIAL_LINE)
+			return TRACE_TYPE_PARTIAL_LINE;
+		ret = trace_seq_printf(s, " | ");
+		if (!ret)
+			return TRACE_TYPE_PARTIAL_LINE;
+	}
 
-			ret = trace_seq_printf(s, " | ");
-			if (!ret)
-				return TRACE_TYPE_PARTIAL_LINE;
-		}
+	/* No overhead */
+	ret = print_graph_overhead(-1, s);
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
 
-		/* No overhead */
-		if (tracer_flags.val & TRACE_GRAPH_PRINT_OVERHEAD) {
-			ret = trace_seq_printf(s, "  ");
-			if (!ret)
-				return TRACE_TYPE_PARTIAL_LINE;
-		}
+	if (type == TRACE_GRAPH_ENT)
+		ret = trace_seq_printf(s, "==========>");
+	else
+		ret = trace_seq_printf(s, "<==========");
+
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	/* Don't close the duration column if haven't one */
+	if (tracer_flags.val & TRACE_GRAPH_PRINT_DURATION)
+		trace_seq_printf(s, " |");
+	ret = trace_seq_printf(s, "\n");
 
-		ret = trace_seq_printf(s, "<========== |\n");
-	}
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 	return TRACE_TYPE_HANDLED;
@@ -289,7 +334,7 @@ print_graph_duration(unsigned long long duration, struct trace_seq *s)
 	sprintf(msecs_str, "%lu", (unsigned long) duration);
 
 	/* Print msecs */
-	ret = trace_seq_printf(s, msecs_str);
+	ret = trace_seq_printf(s, "%s", msecs_str);
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
@@ -322,19 +367,15 @@ print_graph_duration(unsigned long long duration, struct trace_seq *s)
 
 }
 
-/* Signal a overhead of time execution to the output */
-static int
-print_graph_overhead(unsigned long long duration, struct trace_seq *s)
+static int print_graph_abs_time(u64 t, struct trace_seq *s)
 {
-	/* Duration exceeded 100 msecs */
-	if (duration > 100000ULL)
-		return trace_seq_printf(s, "! ");
+	unsigned long usecs_rem;
 
-	/* Duration exceeded 10 msecs */
-	if (duration > 10000ULL)
-		return trace_seq_printf(s, "+ ");
+	usecs_rem = do_div(t, 1000000000);
+	usecs_rem /= 1000;
 
-	return trace_seq_printf(s, "  ");
+	return trace_seq_printf(s, "%5lu.%06lu |  ",
+			(unsigned long)t, usecs_rem);
 }
 
 /* Case of a leaf function on its call entry */
@@ -357,16 +398,16 @@ print_graph_entry_leaf(struct trace_iterator *iter,
 	duration = graph_ret->rettime - graph_ret->calltime;
 
 	/* Overhead */
-	if (tracer_flags.val & TRACE_GRAPH_PRINT_OVERHEAD) {
-		ret = print_graph_overhead(duration, s);
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-	}
+	ret = print_graph_overhead(duration, s);
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
 
 	/* Duration */
-	ret = print_graph_duration(duration, s);
-	if (ret == TRACE_TYPE_PARTIAL_LINE)
-		return TRACE_TYPE_PARTIAL_LINE;
+	if (tracer_flags.val & TRACE_GRAPH_PRINT_DURATION) {
+		ret = print_graph_duration(duration, s);
+		if (ret == TRACE_TYPE_PARTIAL_LINE)
+			return TRACE_TYPE_PARTIAL_LINE;
+	}
 
 	/* Function */
 	for (i = 0; i < call->depth * TRACE_GRAPH_INDENT; i++) {
@@ -395,25 +436,17 @@ print_graph_entry_nested(struct ftrace_graph_ent_entry *entry,
 	struct ftrace_graph_ent *call = &entry->graph_ent;
 
 	/* No overhead */
-	if (tracer_flags.val & TRACE_GRAPH_PRINT_OVERHEAD) {
-		ret = trace_seq_printf(s, "  ");
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-	}
+	ret = print_graph_overhead(-1, s);
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
 
-	/* Interrupt */
-	ret = print_graph_irq(s, call->func, TRACE_GRAPH_ENT, cpu, pid);
-	if (ret == TRACE_TYPE_UNHANDLED) {
-		/* No time */
+	/* No time */
+	if (tracer_flags.val & TRACE_GRAPH_PRINT_DURATION) {
 		ret = trace_seq_printf(s, "            |  ");
 		if (!ret)
 			return TRACE_TYPE_PARTIAL_LINE;
-	} else {
-		if (ret == TRACE_TYPE_PARTIAL_LINE)
-			return TRACE_TYPE_PARTIAL_LINE;
 	}
 
-
 	/* Function */
 	for (i = 0; i < call->depth * TRACE_GRAPH_INDENT; i++) {
 		ret = trace_seq_printf(s, " ");
@@ -434,15 +467,30 @@ print_graph_entry_nested(struct ftrace_graph_ent_entry *entry,
 
 static enum print_line_t
 print_graph_entry(struct ftrace_graph_ent_entry *field, struct trace_seq *s,
-			struct trace_iterator *iter, int cpu)
+			struct trace_iterator *iter)
 {
 	int ret;
+	int cpu = iter->cpu;
+	pid_t *last_entry = iter->private;
 	struct trace_entry *ent = iter->ent;
+	struct ftrace_graph_ent *call = &field->graph_ent;
 
 	/* Pid */
-	if (verif_pid(s, ent->pid, cpu) == TRACE_TYPE_PARTIAL_LINE)
+	if (verif_pid(s, ent->pid, cpu, last_entry) == TRACE_TYPE_PARTIAL_LINE)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	/* Interrupt */
+	ret = print_graph_irq(s, call->func, TRACE_GRAPH_ENT, cpu, ent->pid);
+	if (ret == TRACE_TYPE_PARTIAL_LINE)
 		return TRACE_TYPE_PARTIAL_LINE;
 
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
@@ -470,16 +518,25 @@ print_graph_entry(struct ftrace_graph_ent_entry *field, struct trace_seq *s,
 
 static enum print_line_t
 print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
-		   struct trace_entry *ent, int cpu)
+		   struct trace_entry *ent, struct trace_iterator *iter)
 {
 	int i;
 	int ret;
+	int cpu = iter->cpu;
+	pid_t *last_pid = iter->private;
 	unsigned long long duration = trace->rettime - trace->calltime;
 
 	/* Pid */
-	if (verif_pid(s, ent->pid, cpu) == TRACE_TYPE_PARTIAL_LINE)
+	if (verif_pid(s, ent->pid, cpu, last_pid) == TRACE_TYPE_PARTIAL_LINE)
 		return TRACE_TYPE_PARTIAL_LINE;
 
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
@@ -499,16 +556,16 @@ print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
 	}
 
 	/* Overhead */
-	if (tracer_flags.val & TRACE_GRAPH_PRINT_OVERHEAD) {
-		ret = print_graph_overhead(duration, s);
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-	}
+	ret = print_graph_overhead(duration, s);
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
 
 	/* Duration */
-	ret = print_graph_duration(duration, s);
-	if (ret == TRACE_TYPE_PARTIAL_LINE)
-		return TRACE_TYPE_PARTIAL_LINE;
+	if (tracer_flags.val & TRACE_GRAPH_PRINT_DURATION) {
+		ret = print_graph_duration(duration, s);
+		if (ret == TRACE_TYPE_PARTIAL_LINE)
+			return TRACE_TYPE_PARTIAL_LINE;
+	}
 
 	/* Closing brace */
 	for (i = 0; i < trace->depth * TRACE_GRAPH_INDENT; i++) {
@@ -542,14 +599,23 @@ print_graph_comment(struct print_entry *trace, struct trace_seq *s,
 {
 	int i;
 	int ret;
+	int cpu = iter->cpu;
+	pid_t *last_pid = iter->private;
+
+	/* Absolute time */
+	if (tracer_flags.val & TRACE_GRAPH_PRINT_ABS_TIME) {
+		ret = print_graph_abs_time(iter->ts, s);
+		if (!ret)
+			return TRACE_TYPE_PARTIAL_LINE;
+	}
 
 	/* Pid */
-	if (verif_pid(s, ent->pid, iter->cpu) == TRACE_TYPE_PARTIAL_LINE)
+	if (verif_pid(s, ent->pid, cpu, last_pid) == TRACE_TYPE_PARTIAL_LINE)
 		return TRACE_TYPE_PARTIAL_LINE;
 
 	/* Cpu */
 	if (tracer_flags.val & TRACE_GRAPH_PRINT_CPU) {
-		ret = print_graph_cpu(s, iter->cpu);
+		ret = print_graph_cpu(s, cpu);
 		if (ret == TRACE_TYPE_PARTIAL_LINE)
 			return TRACE_TYPE_PARTIAL_LINE;
 	}
@@ -566,17 +632,17 @@ print_graph_comment(struct print_entry *trace, struct trace_seq *s,
 	}
 
 	/* No overhead */
-	if (tracer_flags.val & TRACE_GRAPH_PRINT_OVERHEAD) {
-		ret = trace_seq_printf(s, "  ");
+	ret = print_graph_overhead(-1, s);
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	/* No time */
+	if (tracer_flags.val & TRACE_GRAPH_PRINT_DURATION) {
+		ret = trace_seq_printf(s, "            |  ");
 		if (!ret)
 			return TRACE_TYPE_PARTIAL_LINE;
 	}
 
-	/* No time */
-	ret = trace_seq_printf(s, "            |  ");
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
-
 	/* Indentation */
 	if (trace->depth > 0)
 		for (i = 0; i < (trace->depth + 1) * TRACE_GRAPH_INDENT; i++) {
@@ -614,13 +680,12 @@ print_graph_function(struct trace_iterator *iter)
 	case TRACE_GRAPH_ENT: {
 		struct ftrace_graph_ent_entry *field;
 		trace_assign_type(field, entry);
-		return print_graph_entry(field, s, iter,
-					 iter->cpu);
+		return print_graph_entry(field, s, iter);
 	}
 	case TRACE_GRAPH_RET: {
 		struct ftrace_graph_ret_entry *field;
 		trace_assign_type(field, entry);
-		return print_graph_return(&field->ret, s, entry, iter->cpu);
+		return print_graph_return(&field->ret, s, entry, iter);
 	}
 	case TRACE_PRINT: {
 		struct print_entry *field;
@@ -636,28 +701,55 @@ static void print_graph_headers(struct seq_file *s)
 {
 	/* 1st line */
 	seq_printf(s, "# ");
+	if (tracer_flags.val & TRACE_GRAPH_PRINT_ABS_TIME)
+		seq_printf(s, "     TIME       ");
 	if (tracer_flags.val & TRACE_GRAPH_PRINT_CPU)
-		seq_printf(s, "CPU ");
+		seq_printf(s, "CPU");
 	if (tracer_flags.val & TRACE_GRAPH_PRINT_PROC)
-		seq_printf(s, "TASK/PID     ");
-	if (tracer_flags.val & TRACE_GRAPH_PRINT_OVERHEAD)
-		seq_printf(s, "OVERHEAD/");
-	seq_printf(s, "DURATION            FUNCTION CALLS\n");
+		seq_printf(s, "  TASK/PID      ");
+	if (tracer_flags.val & TRACE_GRAPH_PRINT_DURATION)
+		seq_printf(s, "  DURATION   ");
+	seq_printf(s, "               FUNCTION CALLS\n");
 
 	/* 2nd line */
 	seq_printf(s, "# ");
+	if (tracer_flags.val & TRACE_GRAPH_PRINT_ABS_TIME)
+		seq_printf(s, "      |         ");
 	if (tracer_flags.val & TRACE_GRAPH_PRINT_CPU)
-		seq_printf(s, "|   ");
+		seq_printf(s, "|  ");
 	if (tracer_flags.val & TRACE_GRAPH_PRINT_PROC)
-		seq_printf(s, "|      |     ");
-	if (tracer_flags.val & TRACE_GRAPH_PRINT_OVERHEAD) {
-		seq_printf(s, "|        ");
-		seq_printf(s, "|                   |   |   |   |\n");
-	} else
-		seq_printf(s, "    |               |   |   |   |\n");
+		seq_printf(s, "  |    |        ");
+	if (tracer_flags.val & TRACE_GRAPH_PRINT_DURATION)
+		seq_printf(s, "   |   |      ");
+	seq_printf(s, "               |   |   |   |\n");
 }
+
+static void graph_trace_open(struct trace_iterator *iter)
+{
+	/* pid on the last trace processed */
+	pid_t *last_pid = alloc_percpu(pid_t);
+	int cpu;
+
+	if (!last_pid)
+		pr_warning("function graph tracer: not enough memory\n");
+	else
+		for_each_possible_cpu(cpu) {
+			pid_t *pid = per_cpu_ptr(last_pid, cpu);
+			*pid = -1;
+		}
+
+	iter->private = last_pid;
+}
+
+static void graph_trace_close(struct trace_iterator *iter)
+{
+	percpu_free(iter->private);
+}
+
 static struct tracer graph_trace __read_mostly = {
 	.name	     	= "function_graph",
+	.open		= graph_trace_open,
+	.close		= graph_trace_close,
 	.init	     	= graph_trace_init,
 	.reset	     	= graph_trace_reset,
 	.print_line	= print_graph_function,
-- 
1.6.0.4


