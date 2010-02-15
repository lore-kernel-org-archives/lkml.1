Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab0BONrK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 08:47:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54542 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660Ab0BONrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 08:47:04 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: mingo@elte.hu, rostedt@goodmis.org, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH/RFC] tracing: function graph output for irqsoff tracer
Date: Mon, 15 Feb 2010 14:46:48 +0100
Message-Id: <1266241608-9270-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

when I was using irqsoff tracer, I thought it could be any use
to see the disabled IRQs flow output same way as function graph output.

It turned out not to be much work.. and could be probably
enabled for preempt tracer as well.

The graph output is enabled by setting new 'irqsoff-graph' trace option
of irqsoff tracer.

It looks like this:

[root@dell-pe1950-05 tracing]# echo irqsoff-graph > ./trace_options 
[root@dell-pe1950-05 tracing]# cat ./trace
# tracer: irqsoff
#
#      _-----=> irqs-off        
#     / _----=> need-resched    
#    | / _---=> hardirq/softirq 
#    || / _--=> preempt-depth   
#    ||| / _-=> lock-depth      
#    |||| /                     
# CPU|||||  DURATION                  FUNCTION CALLS
# |  |||||   |   |                     |   |   |   |
hald-add-1048    3d...0    0us : _raw_spin_lock_irqsave <-scsi_dispatch_cmd
 3)  d...0              |      ata_scsi_queuecmd() {
 3)  d...0  0.318 us    |        _raw_spin_lock();
 3)  d...0              |        ata_scsi_find_dev() {
 3)  d...0              |          __ata_scsi_find_dev() {
 3)  d...0  0.273 us    |            ata_find_dev();
 3)  d...0  0.798 us    |          }
 3)  d...0  1.419 us    |        }
 3)  d...0              |        __ata_scsi_queuecmd() {
 3)  d...0              |          ata_qc_new_init() {
 3)  d...0              |            ata_qc_reinit() {
 3)  d...0  0.258 us    |              ata_tf_init();
 3)  d...0  0.784 us    |            }
 3)  d...0  1.441 us    |          }
 3)  d...0  0.348 us    |          atapi_xlat();
 3)  d...0              |          ata_qc_issue() {
...

SNIP

...
 3)  d...0+ 31.244 us   |                }
 3)  d...0+ 32.393 us   |              }
 3)  d...0+ 99.146 us   |            }
 3)  d...0! 100.455 us  |          }
 3)  d...0! 103.669 us  |        }
 3)  d...0  0.267 us    |        _raw_spin_lock();
 3)  d...0! 107.264 us  |      }
 3)  d...0              |      spin_unlock_irqrestore() {
 3)  d...0              |        _raw_spin_unlock_irqrestore() {
hald-add-1048    3d...0  109us : _raw_spin_unlock_irqrestore <-return_to_handler
hald-add-1048    3d...0  109us : trace_hardirqs_on <-return_to_handler
hald-add-1048    3d...0  109us : <stack trace>
 => trace_hardirqs_on
 => _raw_spin_unlock_irqrestore
 => return_to_handler
 => scsi_dispatch_cmd
 => return_to_handler
 => __generic_unplug_device
 => scsi_request_fn
 => return_to_handler
[root@dell-pe1950-05 tracing]#

wbr,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 kernel/trace/trace.h                 |   10 ++
 kernel/trace/trace_functions_graph.c |   25 ++---
 kernel/trace/trace_irqsoff.c         |  178 ++++++++++++++++++++++++++++++++--
 3 files changed, 190 insertions(+), 23 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index ce077fb..423e7db 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -491,8 +491,18 @@ extern int trace_clock_id;
 /* Standard output formatting function used for function return traces */
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 extern enum print_line_t print_graph_function(struct trace_iterator *iter);
+extern void print_graph_headers(struct seq_file *s);
 extern enum print_line_t
 trace_print_graph_duration(unsigned long long duration, struct trace_seq *s);
+void graph_trace_open(struct trace_iterator *iter);
+void graph_trace_close(struct trace_iterator *iter);
+int __trace_graph_entry(struct trace_array *tr, struct ftrace_graph_ent *trace,
+			unsigned long flags, int pc);
+void __trace_graph_return(struct trace_array *tr,
+			  struct ftrace_graph_ret *trace,
+			  unsigned long flags, int pc);
+
+
 
 #ifdef CONFIG_DYNAMIC_FTRACE
 /* TODO: make this variable */
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 616b135..dc8f97b 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -177,7 +177,7 @@ unsigned long ftrace_return_to_handler(unsigned long frame_pointer)
 	return ret;
 }
 
-static int __trace_graph_entry(struct trace_array *tr,
+int __trace_graph_entry(struct trace_array *tr,
 				struct ftrace_graph_ent *trace,
 				unsigned long flags,
 				int pc)
@@ -236,7 +236,7 @@ int trace_graph_entry(struct ftrace_graph_ent *trace)
 	return ret;
 }
 
-static void __trace_graph_return(struct trace_array *tr,
+void __trace_graph_return(struct trace_array *tr,
 				struct ftrace_graph_ret *trace,
 				unsigned long flags,
 				int pc)
@@ -911,9 +911,7 @@ static enum print_line_t
 print_graph_comment(struct trace_seq *s,  struct trace_entry *ent,
 		    struct trace_iterator *iter)
 {
-	unsigned long sym_flags = (trace_flags & TRACE_ITER_SYM_MASK);
 	struct fgraph_data *data = iter->private;
-	struct trace_event *event;
 	int depth = 0;
 	int ret;
 	int i;
@@ -960,14 +958,6 @@ print_graph_comment(struct trace_seq *s,  struct trace_entry *ent,
 		if (ret != TRACE_TYPE_HANDLED)
 			return ret;
 		break;
-	default:
-		event = ftrace_find_event(ent->type);
-		if (!event)
-			return TRACE_TYPE_UNHANDLED;
-
-		ret = event->trace(iter, sym_flags);
-		if (ret != TRACE_TYPE_HANDLED)
-			return ret;
 	}
 
 	/* Strip ending newline */
@@ -1033,8 +1023,11 @@ print_graph_function(struct trace_iterator *iter)
 		trace_assign_type(field, entry);
 		return print_graph_return(&field->ret, s, entry, iter);
 	}
-	default:
+	case TRACE_BPRINT:
+	case TRACE_PRINT:
 		return print_graph_comment(s, entry, iter);
+	default:
+		return TRACE_TYPE_UNHANDLED;
 	}
 
 	return TRACE_TYPE_HANDLED;
@@ -1062,7 +1055,7 @@ static void print_lat_header(struct seq_file *s)
 	seq_printf(s, "#%.*s|||| /                     \n", size, spaces);
 }
 
-static void print_graph_headers(struct seq_file *s)
+void print_graph_headers(struct seq_file *s)
 {
 	int lat = trace_flags & TRACE_ITER_LATENCY_FMT;
 
@@ -1098,7 +1091,7 @@ static void print_graph_headers(struct seq_file *s)
 	seq_printf(s, "               |   |   |   |\n");
 }
 
-static void graph_trace_open(struct trace_iterator *iter)
+void graph_trace_open(struct trace_iterator *iter)
 {
 	/* pid and depth on the last trace processed */
 	struct fgraph_data *data;
@@ -1133,7 +1126,7 @@ static void graph_trace_open(struct trace_iterator *iter)
 	pr_warning("function graph tracer: not enough memory\n");
 }
 
-static void graph_trace_close(struct trace_iterator *iter)
+void graph_trace_close(struct trace_iterator *iter)
 {
 	struct fgraph_data *data = iter->private;
 
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index 2974bc7..f9e9a6b 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -34,6 +34,9 @@ static int trace_type __read_mostly;
 
 static int save_lat_flag;
 
+static void stop_irqsoff_tracer(struct trace_array *tr, int graph);
+static int start_irqsoff_tracer(struct trace_array *tr, int graph);
+
 #ifdef CONFIG_PREEMPT_TRACER
 static inline int
 preempt_trace(void)
@@ -55,6 +58,23 @@ irq_trace(void)
 # define irq_trace() (0)
 #endif
 
+#define TRACE_IRQSOFF_GRAPH	1
+
+static struct tracer_opt trace_opts[] = {
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+	/* display latency trace as call graph */
+	{ TRACER_OPT(irqsoff-graph, TRACE_IRQSOFF_GRAPH) },
+#endif
+	{ } /* Empty entry */
+};
+
+static struct tracer_flags tracer_flags = {
+	.val = 0,
+	.opts = trace_opts,
+};
+
+#define is_graph() (tracer_flags.val & TRACE_IRQSOFF_GRAPH)
+
 /*
  * Sequence count - we record it when starting a measurement and
  * skip the latency if the sequence has changed - some other section
@@ -108,6 +128,123 @@ static struct ftrace_ops trace_ops __read_mostly =
 };
 #endif /* CONFIG_FUNCTION_TRACER */
 
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+static int irqsoff_set_flag(u32 old_flags, u32 bit, int set)
+{
+	int cpu;
+
+	if (!(bit & TRACE_IRQSOFF_GRAPH))
+		return -EINVAL;
+
+	if (!(is_graph() ^ set))
+		return 0;
+
+	stop_irqsoff_tracer(irqsoff_trace, !set);
+
+	for_each_possible_cpu(cpu)
+		per_cpu(tracing_cpu, cpu) = 0;
+
+	tracing_max_latency = 0;
+	tracing_reset_online_cpus(irqsoff_trace);
+
+	return start_irqsoff_tracer(irqsoff_trace, set);
+}
+
+static int irqsoff_graph_entry(struct ftrace_graph_ent *trace)
+{
+	struct trace_array *tr = irqsoff_trace;
+	struct trace_array_cpu *data;
+	unsigned long flags;
+	long disabled;
+	int ret;
+	int cpu;
+	int pc;
+
+	cpu = raw_smp_processor_id();
+	if (likely(!per_cpu(tracing_cpu, cpu)))
+		return 0;
+
+	local_save_flags(flags);
+	/* slight chance to get a false positive on tracing_cpu */
+	if (!irqs_disabled_flags(flags))
+		return 0;
+
+	data = tr->data[cpu];
+	disabled = atomic_inc_return(&data->disabled);
+
+	if (likely(disabled == 1)) {
+		pc = preempt_count();
+		ret = __trace_graph_entry(tr, trace, flags, pc);
+	} else
+		ret = 0;
+
+	atomic_dec(&data->disabled);
+	return ret;
+}
+
+static void irqsoff_graph_return(struct ftrace_graph_ret *trace)
+{
+	struct trace_array *tr = irqsoff_trace;
+	struct trace_array_cpu *data;
+	unsigned long flags;
+	long disabled;
+	int cpu;
+	int pc;
+
+	cpu = raw_smp_processor_id();
+	if (likely(!per_cpu(tracing_cpu, cpu)))
+		return;
+
+	local_save_flags(flags);
+	/* slight chance to get a false positive on tracing_cpu */
+	if (!irqs_disabled_flags(flags))
+		return;
+
+	data = tr->data[cpu];
+	disabled = atomic_inc_return(&data->disabled);
+
+	if (likely(disabled == 1)) {
+		pc = preempt_count();
+		__trace_graph_return(tr, trace, flags, pc);
+	}
+
+	atomic_dec(&data->disabled);
+}
+
+static void irqsoff_trace_open(struct trace_iterator *iter)
+{
+	if (is_graph())
+		graph_trace_open(iter);
+
+}
+
+static void irqsoff_trace_close(struct trace_iterator *iter)
+{
+	if (iter->private)
+		graph_trace_close(iter);
+}
+
+
+static enum print_line_t irqsoff_graph_function(struct trace_iterator *iter)
+{
+	if (is_graph())
+		return print_graph_function(iter);
+
+	return TRACE_TYPE_UNHANDLED;
+}
+
+static void irqsoff_graph_headers(struct seq_file *s)
+{
+	if (is_graph())
+		return print_graph_headers(s);
+}
+#else
+static int irqsoff_set_flag(u32 old_flags, u32 bit, int set)
+{
+	return -EINVAL;
+}
+#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
+
 /*
  * Should this new latency be reported/recorded?
  */
@@ -347,19 +484,36 @@ void trace_preempt_off(unsigned long a0, unsigned long a1)
 }
 #endif /* CONFIG_PREEMPT_TRACER */
 
-static void start_irqsoff_tracer(struct trace_array *tr)
+static int start_irqsoff_tracer(struct trace_array *tr, int graph)
 {
-	register_ftrace_function(&trace_ops);
-	if (tracing_is_enabled())
+	int ret = 0;
+
+	if (!graph)
+		ret = register_ftrace_function(&trace_ops);
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+	else
+		ret = register_ftrace_graph(&irqsoff_graph_return,
+					    &irqsoff_graph_entry);
+#endif
+
+	if (!ret && tracing_is_enabled())
 		tracer_enabled = 1;
 	else
 		tracer_enabled = 0;
+
+	return ret;
 }
 
-static void stop_irqsoff_tracer(struct trace_array *tr)
+static void stop_irqsoff_tracer(struct trace_array *tr, int graph)
 {
 	tracer_enabled = 0;
-	unregister_ftrace_function(&trace_ops);
+
+	if (!graph)
+		unregister_ftrace_function(&trace_ops);
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+	else
+		unregister_ftrace_graph();
+#endif
 }
 
 static void __irqsoff_tracer_init(struct trace_array *tr)
@@ -372,12 +526,14 @@ static void __irqsoff_tracer_init(struct trace_array *tr)
 	/* make sure that the tracer is visible */
 	smp_wmb();
 	tracing_reset_online_cpus(tr);
-	start_irqsoff_tracer(tr);
+
+	if (start_irqsoff_tracer(tr, is_graph()))
+		printk(KERN_ERR "failed to start irqsoff tracer\n");
 }
 
 static void irqsoff_tracer_reset(struct trace_array *tr)
 {
-	stop_irqsoff_tracer(tr);
+	stop_irqsoff_tracer(tr, is_graph());
 
 	if (!save_lat_flag)
 		trace_flags &= ~TRACE_ITER_LATENCY_FMT;
@@ -408,10 +564,18 @@ static struct tracer irqsoff_tracer __read_mostly =
 	.reset		= irqsoff_tracer_reset,
 	.start		= irqsoff_tracer_start,
 	.stop		= irqsoff_tracer_stop,
+	.flags		= &tracer_flags,
 	.print_max	= 1,
+	.set_flag	= irqsoff_set_flag,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    = trace_selftest_startup_irqsoff,
 #endif
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+	.open           = irqsoff_trace_open,
+	.close          = irqsoff_trace_close,
+	.print_line	= irqsoff_graph_function,
+	.print_header	= irqsoff_graph_headers,
+#endif
 };
 # define register_irqsoff(trace) register_tracer(&trace)
 #else
