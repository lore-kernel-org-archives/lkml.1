Return-Path: <linux-kernel-owner+w=401wt.eu-S1758508AbZLIWlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758508AbZLIWlO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 17:41:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758470AbZLIWlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 17:41:09 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:27544 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758424AbZLIWlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 17:41:06 -0500
X-SpamScore: -10
X-BigFish: VPS-10(zz541I14c3L655Nab9bhzz1202hzz5a6ciz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
Message-ID: <4B202778.4030801@am.sony.com>
Date: Wed, 9 Dec 2009 14:40:56 -0800
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: linux kernel <linux-kernel@vger.kernel.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 2/4] ftrace - add function_duration tracer
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Dec 2009 22:40:57.0200 (UTC) FILETIME=[AC69A700:01CA7920]
X-SEL-encryption-scan: scanned
X-Reverse-DNS: mail8.fw-sd.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add function duration tracer.

Signed-off-by: Tim Bird <tim.bird@am.sony.com>
---
 kernel/trace/Kconfig          |    8
 kernel/trace/Makefile         |    1
 kernel/trace/trace.c          |   32 ++
 kernel/trace/trace_duration.c |  527 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 568 insertions(+)

--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -153,6 +153,14 @@ config FUNCTION_GRAPH_TRACER
          the return value. This is done by setting the current return
          address on the current task structure into a stack of calls.

+config FUNCTION_DURATION_TRACER
+       bool "Kernel Function Duration Tracer"
+       depends on FUNCTION_GRAPH_TRACER
+       default y
+       help
+         Enable the kernel to record function durations, with
+         filtering.  Can also be used in early startup.
+         See Documentation/trace/func-duration.txt

 config IRQSOFF_TRACER
        bool "Interrupts-off Latency Tracer"
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -40,6 +40,7 @@ obj-$(CONFIG_STACK_TRACER) += trace_stac
 obj-$(CONFIG_MMIOTRACE) += trace_mmiotrace.o
 obj-$(CONFIG_BOOT_TRACER) += trace_boot.o
 obj-$(CONFIG_FUNCTION_GRAPH_TRACER) += trace_functions_graph.o
+obj-$(CONFIG_FUNCTION_DURATION_TRACER) += trace_duration.o
 obj-$(CONFIG_TRACE_BRANCH_PROFILING) += trace_branch.o
 obj-$(CONFIG_HW_BRANCH_TRACER) += trace_hw_branches.o
 obj-$(CONFIG_KMEMTRACE) += kmemtrace.o
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -979,6 +979,38 @@ void tracing_record_cmdline(struct task_
        trace_save_cmdline(tsk);
 }

+#ifdef CONFIG_FUNCTION_DURATION_TRACER
+void __duration_return(struct trace_array *tr,
+                               struct ftrace_graph_ret *trace,
+                               unsigned long flags,
+                               int pc)
+{
+       struct ftrace_event_call *call = &event_funcgraph_exit;
+       struct ring_buffer_event *event;
+       struct ring_buffer *buffer = tr->buffer;
+       struct ftrace_graph_ret_entry *entry;
+
+       if (unlikely(local_read(&__get_cpu_var(ftrace_cpu_disabled))))
+               return;
+
+       /* check duration filter */
+       if (tracing_thresh &&
+                       (trace->rettime - trace->calltime) < tracing_thresh) {
+               return;
+       }
+
+       event = trace_buffer_lock_reserve(buffer, TRACE_GRAPH_RET,
+                                         sizeof(*entry), flags, pc);
+       if (!event)
+               return;
+       entry   = ring_buffer_event_data(event);
+       entry->ret = *trace;
+
+       if (!filter_current_check_discard(buffer, call, entry, event))
+               ring_buffer_unlock_commit(buffer, event);
+}
+#endif
+
 void
 tracing_generic_entry_update(struct trace_entry *entry, unsigned long flags,
                             int pc)
--- /dev/null
+++ b/kernel/trace/trace_duration.c
@@ -0,0 +1,527 @@
+/*
+ * Function duration tracer.
+ * Copyright 2009 Sony Corporation
+ * Author: Tim Bird <tim.bird@am.sony.com>
+ *
+ * Much was copied from function graph tracer, which is
+ * Copyright (c) 2008-2009 Frederic Weisbecker <fweisbec@gmail.com>
+ */
+#include <linux/debugfs.h>
+#include <linux/uaccess.h>
+#include <linux/ftrace.h>
+#include <linux/fs.h>
+
+#include "trace.h"
+#include "trace_output.h"
+
+struct fgraph_data {
+       int             depth;
+};
+
+#define DURATION_INDENT        2
+
+/* Flag options */
+#define DURATION_PRINT_OVERRUN         0x1
+#define DURATION_PRINT_CPU             0x2
+#define DURATION_PRINT_PROC            0x4
+#define DURATION_PRINT_ABS_TIME                0X8
+
+static struct tracer_opt trace_opts[] = {
+       /* Display overruns? (for self-debug purpose) */
+       { TRACER_OPT(duration-overrun, DURATION_PRINT_OVERRUN) },
+       /* Display CPU */
+       { TRACER_OPT(duration-cpu, DURATION_PRINT_CPU) },
+       /* Display proc name/pid */
+       { TRACER_OPT(duration-proc, DURATION_PRINT_PROC) },
+       /* Display absolute time of an entry */
+       { TRACER_OPT(duration-abstime, DURATION_PRINT_ABS_TIME) },
+       { } /* Empty entry */
+};
+
+static struct tracer_flags tracer_flags = {
+       /* Don't display overruns and proc by default */
+       .val = DURATION_PRINT_CPU,
+       .opts = trace_opts
+};
+
+extern void __duration_return(struct trace_array *tr,
+                               struct ftrace_graph_ret *trace,
+                               unsigned long flags,
+                               int pc);
+
+static int duration_entry(struct ftrace_graph_ent *trace)
+{
+       /* check some filters, and abort if hit */
+       if (!ftrace_trace_task(current))
+               return 0;
+
+       if (!ftrace_graph_addr(trace->func))
+               return 0;
+
+       return 1;
+}
+
+void duration_return(struct ftrace_graph_ret *trace)
+{
+       struct trace_array *tr = &global_trace;
+       struct trace_array_cpu *data;
+       unsigned long flags;
+       long disabled;
+       int cpu;
+       int pc;
+
+       local_irq_save(flags);
+       cpu = raw_smp_processor_id();
+       data = tr->data[cpu];
+       disabled = atomic_inc_return(&data->disabled);
+       if (likely(disabled == 1)) {
+               pc = preempt_count();
+               __duration_return(tr, trace, flags, pc);
+       }
+       atomic_dec(&data->disabled);
+       local_irq_restore(flags);
+}
+
+static int duration_trace_init(struct trace_array *tr)
+{
+       int ret = register_ftrace_graph(&duration_return,
+                                       &duration_entry);
+       if (ret)
+               return ret;
+       tracing_start_cmdline_record();
+
+       return 0;
+}
+
+static void duration_trace_reset(struct trace_array *tr)
+{
+       tracing_stop_cmdline_record();
+       unregister_ftrace_graph();
+}
+
+static inline int log10_cpu(int nb)
+{
+       if (nb / 100)
+               return 3;
+       if (nb / 10)
+               return 2;
+       return 1;
+}
+
+static enum print_line_t
+print_duration_cpu(struct trace_seq *s, int cpu)
+{
+       int i;
+       int ret;
+       int log10_this = log10_cpu(cpu);
+       int log10_all = log10_cpu(cpumask_weight(cpu_online_mask));
+
+       /*
+        * Start with a space character - to make it stand out
+        * to the right a bit when trace output is pasted into
+        * email:
+        */
+       ret = trace_seq_printf(s, " ");
+
+       /*
+        * Tricky - we space the CPU field according to the max
+        * number of online CPUs. On a 2-cpu system it would take
+        * a maximum of 1 digit - on a 128 cpu system it would
+        * take up to 3 digits:
+        */
+       for (i = 0; i < log10_all - log10_this; i++) {
+               ret = trace_seq_printf(s, " ");
+               if (!ret)
+                       return TRACE_TYPE_PARTIAL_LINE;
+       }
+       ret = trace_seq_printf(s, "%d) ", cpu);
+       if (!ret)
+               return TRACE_TYPE_PARTIAL_LINE;
+
+       return TRACE_TYPE_HANDLED;
+}
+
+#define DURATION_PROCINFO_LENGTH       14
+
+static enum print_line_t
+print_duration_proc(struct trace_seq *s, pid_t pid)
+{
+       char comm[TASK_COMM_LEN];
+       /* sign + log10(MAX_INT) + '\0' */
+       char pid_str[11];
+       int spaces = 0;
+       int ret;
+       int len;
+       int i;
+
+       trace_find_cmdline(pid, comm);
+       comm[7] = '\0';
+       sprintf(pid_str, "%d", pid);
+
+       /* 1 stands for the "-" character */
+       len = strlen(comm) + strlen(pid_str) + 1;
+
+       if (len < DURATION_PROCINFO_LENGTH)
+               spaces = DURATION_PROCINFO_LENGTH - len;
+
+       /* First spaces to align center */
+       for (i = 0; i < spaces / 2; i++) {
+               ret = trace_seq_printf(s, " ");
+               if (!ret)
+                       return TRACE_TYPE_PARTIAL_LINE;
+       }
+
+       ret = trace_seq_printf(s, "%s-%s", comm, pid_str);
+       if (!ret)
+               return TRACE_TYPE_PARTIAL_LINE;
+
+       /* Last spaces to align center */
+       for (i = 0; i < spaces - (spaces / 2); i++) {
+               ret = trace_seq_printf(s, " ");
+               if (!ret)
+                       return TRACE_TYPE_PARTIAL_LINE;
+       }
+       return TRACE_TYPE_HANDLED;
+}
+
+static int print_duration_abs_time(u64 t, struct trace_seq *s)
+{
+       unsigned long usecs_rem;
+
+       usecs_rem = do_div(t, NSEC_PER_SEC);
+       usecs_rem /= 1000;
+
+       return trace_seq_printf(s, "%5lu.%06lu |  ",
+                       (unsigned long)t, usecs_rem);
+}
+
+static int print_duration_calltime(u64 t, struct trace_seq *s)
+{
+       unsigned long usecs_rem;
+
+       usecs_rem = do_div(t, NSEC_PER_SEC);
+
+       return trace_seq_printf(s, "%5lu.%09lu |  ",
+                       (unsigned long)t, usecs_rem);
+}
+
+enum print_line_t
+trace_print_duration_duration(unsigned long long duration, struct trace_seq *s)
+{
+       unsigned long nsecs_rem = do_div(duration, 1000);
+       /* log10(ULONG_MAX) + '\0' */
+       char msecs_str[21];
+       char nsecs_str[5];
+       int ret, len;
+       int i;
+
+       sprintf(msecs_str, "%lu", (unsigned long) duration);
+
+       /* Print msecs */
+       ret = trace_seq_printf(s, "%s", msecs_str);
+       if (!ret)
+               return TRACE_TYPE_PARTIAL_LINE;
+
+       len = strlen(msecs_str);
+
+       /* Print nsecs (we don't want to exceed 7 numbers) */
+       if (len < 7) {
+               snprintf(nsecs_str, 8 - len, "%03lu", nsecs_rem);
+               ret = trace_seq_printf(s, ".%s", nsecs_str);
+               if (!ret)
+                       return TRACE_TYPE_PARTIAL_LINE;
+               len += strlen(nsecs_str);
+       }
+
+       ret = trace_seq_printf(s, " us ");
+       if (!ret)
+               return TRACE_TYPE_PARTIAL_LINE;
+
+       /* Print remaining spaces to fit the row's width */
+       for (i = len; i < 7; i++) {
+               ret = trace_seq_printf(s, " ");
+               if (!ret)
+                       return TRACE_TYPE_PARTIAL_LINE;
+       }
+       return TRACE_TYPE_HANDLED;
+}
+
+static enum print_line_t
+print_duration_duration(unsigned long long duration, struct trace_seq *s)
+{
+       int ret;
+
+       ret = trace_print_duration_duration(duration, s);
+       if (ret != TRACE_TYPE_HANDLED)
+               return ret;
+
+       ret = trace_seq_printf(s, "|  ");
+       if (!ret)
+               return TRACE_TYPE_PARTIAL_LINE;
+
+       return TRACE_TYPE_HANDLED;
+}
+
+static enum print_line_t
+print_duration_prologue(struct trace_iterator *iter, struct trace_seq *s)
+
+{
+       struct trace_entry *ent = iter->ent;
+       int cpu = iter->cpu;
+       int ret;
+
+       /* Absolute time */
+       if (tracer_flags.val & DURATION_PRINT_ABS_TIME) {
+               ret = print_duration_abs_time(iter->ts, s);
+               if (!ret)
+                       return TRACE_TYPE_PARTIAL_LINE;
+       }
+
+       /* Cpu */
+       if (tracer_flags.val & DURATION_PRINT_CPU) {
+               ret = print_duration_cpu(s, cpu);
+               if (ret == TRACE_TYPE_PARTIAL_LINE)
+                       return TRACE_TYPE_PARTIAL_LINE;
+       }
+
+       /* Proc */
+       if (tracer_flags.val & DURATION_PRINT_PROC) {
+               ret = print_duration_proc(s, ent->pid);
+               if (ret == TRACE_TYPE_PARTIAL_LINE)
+                       return TRACE_TYPE_PARTIAL_LINE;
+
+               ret = trace_seq_printf(s, " | ");
+               if (!ret)
+                       return TRACE_TYPE_PARTIAL_LINE;
+       }
+
+       return 0;
+}
+
+static enum print_line_t
+print_duration_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
+                  struct trace_entry *ent, struct trace_iterator *iter)
+{
+       unsigned long long duration = trace->rettime - trace->calltime;
+       struct fgraph_data *data = iter->private;
+       pid_t pid = ent->pid;
+       int cpu = iter->cpu;
+       int ret;
+       int i;
+
+       if (data) {
+               int cpu = iter->cpu;
+               int *depth = &(per_cpu_ptr(data, cpu)->depth);
+
+               /*
+                * Comments display at + 1 to depth. This is the
+                * return from a function, we now want the comments
+                * to display at the same level of the bracket.
+                */
+               *depth = trace->depth - 1;
+       }
+
+       if (print_duration_prologue(iter, s))
+               return TRACE_TYPE_PARTIAL_LINE;
+
+       /* Calltime */
+       ret = print_duration_calltime(trace->calltime, s);
+       if (!ret)
+               return TRACE_TYPE_PARTIAL_LINE;
+
+       /* Duration */
+       ret = print_duration_duration(duration, s);
+       if (ret == TRACE_TYPE_PARTIAL_LINE)
+               return TRACE_TYPE_PARTIAL_LINE;
+
+       /* Function */
+       for (i = 0; i < trace->depth * DURATION_INDENT; i++) {
+               ret = trace_seq_printf(s, " ");
+               if (!ret)
+                       return TRACE_TYPE_PARTIAL_LINE;
+       }
+
+       /* for debug, change 0 to TRACE_ITER_SYM_OFFSET in line below */
+       ret = seq_print_ip_sym(s, trace->func, 0);
+
+       if (!ret)
+               return TRACE_TYPE_PARTIAL_LINE;
+
+       ret = trace_seq_printf(s, "\n");
+       if (!ret)
+               return TRACE_TYPE_PARTIAL_LINE;
+
+       /* Overrun */
+       if (tracer_flags.val & DURATION_PRINT_OVERRUN) {
+               ret = trace_seq_printf(s, " (Overruns: %lu)\n",
+                                       trace->overrun);
+               if (!ret)
+                       return TRACE_TYPE_PARTIAL_LINE;
+       }
+
+       return TRACE_TYPE_HANDLED;
+}
+
+static enum print_line_t
+print_duration_comment(struct trace_seq *s,  struct trace_entry *ent,
+                   struct trace_iterator *iter)
+{
+       unsigned long sym_flags = (trace_flags & TRACE_ITER_SYM_MASK);
+       struct fgraph_data *data = iter->private;
+       struct trace_event *event;
+       int depth = 0;
+       int ret;
+       int i;
+
+       if (data)
+               depth = per_cpu_ptr(data, iter->cpu)->depth;
+
+       if (print_duration_prologue(iter, s))
+               return TRACE_TYPE_PARTIAL_LINE;
+
+       /* No time */
+       ret = trace_seq_printf(s, "            |  ");
+       if (!ret)
+               return TRACE_TYPE_PARTIAL_LINE;
+
+       /* Indentation */
+       if (depth > 0)
+               for (i = 0; i < (depth + 1) * DURATION_INDENT; i++) {
+                       ret = trace_seq_printf(s, " ");
+                       if (!ret)
+                               return TRACE_TYPE_PARTIAL_LINE;
+               }
+
+       /* The comment */
+       ret = trace_seq_printf(s, "/* ");
+       if (!ret)
+               return TRACE_TYPE_PARTIAL_LINE;
+
+       switch (iter->ent->type) {
+       case TRACE_BPRINT:
+               ret = trace_print_bprintk_msg_only(iter);
+               if (ret != TRACE_TYPE_HANDLED)
+                       return ret;
+               break;
+       case TRACE_PRINT:
+               ret = trace_print_printk_msg_only(iter);
+               if (ret != TRACE_TYPE_HANDLED)
+                       return ret;
+               break;
+       default:
+               event = ftrace_find_event(ent->type);
+               if (!event)
+                       return TRACE_TYPE_UNHANDLED;
+
+               ret = event->trace(iter, sym_flags);
+               if (ret != TRACE_TYPE_HANDLED)
+                       return ret;
+       }
+
+       /* Strip ending newline */
+       if (s->buffer[s->len - 1] == '\n') {
+               s->buffer[s->len - 1] = '\0';
+               s->len--;
+       }
+
+       ret = trace_seq_printf(s, " */\n");
+       if (!ret)
+               return TRACE_TYPE_PARTIAL_LINE;
+
+       return TRACE_TYPE_HANDLED;
+}
+
+
+enum print_line_t
+print_duration_function(struct trace_iterator *iter)
+{
+       struct trace_entry *entry = iter->ent;
+       struct trace_seq *s = &iter->seq;
+
+       switch (entry->type) {
+       case TRACE_GRAPH_RET: {
+               /*
+                * Note: No need for trace_assign_type() here.
+                * Case statement already checks the type.)
+                */
+               struct ftrace_graph_ret_entry *ret_entry;
+               ret_entry = (struct ftrace_graph_ret_entry *)entry;
+               return print_duration_return( &ret_entry->ret, s, entry, iter);
+       }
+       default:
+               return print_duration_comment(s, entry, iter);
+       }
+
+       return TRACE_TYPE_HANDLED;
+}
+
+static void print_duration_headers(struct seq_file *s)
+{
+       /* 1st line - settings */
+       seq_printf(s, "# tracing_thresh=%lu\n", tracing_thresh/1000);
+
+       /* fields */
+       seq_printf(s, "# ");
+       if (tracer_flags.val & DURATION_PRINT_ABS_TIME)
+               seq_printf(s, "     TIME       ");
+       if (tracer_flags.val & DURATION_PRINT_CPU)
+               seq_printf(s, "CPU");
+       if (tracer_flags.val & DURATION_PRINT_PROC)
+               seq_printf(s, "  TASK/PID      ");
+       seq_printf(s, "  CALLTIME     ");
+       seq_printf(s, "  DURATION   ");
+       seq_printf(s, "               FUNCTION CALLS\n");
+
+       /* field column lines */
+       seq_printf(s, "# ");
+       if (tracer_flags.val & DURATION_PRINT_ABS_TIME)
+               seq_printf(s, "      |         ");
+       if (tracer_flags.val & DURATION_PRINT_CPU)
+               seq_printf(s, "|  ");
+       if (tracer_flags.val & DURATION_PRINT_PROC)
+               seq_printf(s, "  |    |        ");
+       seq_printf(s, "    |           ");
+       seq_printf(s, "   |   |      ");
+       seq_printf(s, "               |   |   |   |\n");
+}
+
+static void duration_trace_open(struct trace_iterator *iter)
+{
+       /* pid and depth on the last trace processed */
+       struct fgraph_data *data = alloc_percpu(struct fgraph_data);
+       int cpu;
+
+       if (!data)
+               pr_warning("duration tracer: not enough memory\n");
+       else
+               for_each_possible_cpu(cpu) {
+                       int *depth = &(per_cpu_ptr(data, cpu)->depth);
+                       *depth = 0;
+               }
+
+       iter->private = data;
+}
+
+static void duration_trace_close(struct trace_iterator *iter)
+{
+       free_percpu(iter->private);
+}
+
+struct tracer duration_trace __read_mostly = {
+       .name           = "function_duration",
+       .open           = duration_trace_open,
+       .close          = duration_trace_close,
+       .wait_pipe      = poll_wait_pipe,
+       .init           = duration_trace_init,
+       .reset          = duration_trace_reset,
+       .print_line     = print_duration_function,
+       .print_header   = print_duration_headers,
+       .flags          = &tracer_flags,
+};
+
+static __init int init_duration_trace(void)
+{
+       return register_tracer(&duration_trace);
+}
+
+device_initcall(init_duration_trace);


