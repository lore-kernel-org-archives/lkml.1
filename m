Return-Path: <linux-kernel-owner+w=401wt.eu-S1755414AbYKKGOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414AbYKKGOj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 01:14:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751670AbYKKGOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 01:14:31 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:56821 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbYKKGOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 01:14:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=vXlx+YvQcz8Se/eUkfQdZhmbCb43c9/jxYs5h902kdDXVnMjwIIXMDexBrFqrUt4Rd
         jKBGe9+6oNN2JdHupmkLM0nQoEmZqtRwxoGZ9Ridu+4QuqWmfowfLgLiP7kHVSufxJ2N
         S4Qzq6TK9x+wpRZxdaxyh3f7i/Q0nISZaG4DQ=
Message-ID: <491922C1.7030606@gmail.com>
Date: Tue, 11 Nov 2008 07:14:25 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [RFC v3][PATCH 2/2] Add a tracer to catch execution time of kernel
 functions
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This tracer uses the low level function return ftrace plugin to measure
the execution time of the kernel functions.

The first field is the caller of the function, the second is the measured function, and the last
one is the execution time in nanoseconds.

In this V3:
_ HAVE_FTRACE_RETURN have been added. Each arch that support ftrace return
  should enable it.
_ ftrace_return_stub becomes ftrace_stub.
_ CONFIG_FTRACE_RETURN depends now on CONFIG_FUNCTION_TRACER
_ Return traces printing can be used for other tracers on trace.c
_ Adapt to the new tracing API (no more ctrl_update callback)
_ Correct the check of "disabled" during insertion.
_ Minor changes...

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index fc4febc..c5d30c0 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -9,6 +9,9 @@ config NOP_TRACER
 config HAVE_FUNCTION_TRACER
 	bool
 
+config HAVE_FTRACE_RETURN
+	bool
+
 config HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	bool
 	help
@@ -54,6 +57,17 @@ config FUNCTION_TRACER
 	  (the bootup default), then the overhead of the instructions is very
 	  small and not measurable even in micro-benchmarks.
 
+config FTRACE_RETURN
+	bool "Kernel Function return Tracer"
+	depends on !DYNAMIC_FTRACE
+	depends on HAVE_FTRACE_RETURN
+	depends on FUNCTION_TRACER
+	help
+	  Enable the kernel to trace a function at its return.
+	  It's first purpose is to trace the duration of functions.
+	  This is done by setting the current return address on the thread
+	  info structure of the current task.
+
 config IRQSOFF_TRACER
 	bool "Interrupts-off Latency Tracer"
 	default n
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index c8228b1..5cfacd5 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -24,5 +24,6 @@ obj-$(CONFIG_NOP_TRACER) += trace_nop.o
 obj-$(CONFIG_STACK_TRACER) += trace_stack.o
 obj-$(CONFIG_MMIOTRACE) += trace_mmiotrace.o
 obj-$(CONFIG_BOOT_TRACER) += trace_boot.o
+obj-$(CONFIG_FTRACE_RETURN) += trace_functions_return.o
 
 libftrace-y := ftrace.o
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 4d2e751..211668c 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1484,3 +1484,19 @@ ftrace_enable_sysctl(struct ctl_table *table, int write,
 	return ret;
 }
 
+#ifdef CONFIG_FTRACE_RETURN
+trace_function_return_t ftrace_function_return =
+			(trace_function_return_t)ftrace_stub;
+void register_ftrace_return(trace_function_return_t func)
+{
+	ftrace_function_return = func;
+}
+
+void unregister_ftrace_return(void)
+{
+	ftrace_function_return = (trace_function_return_t)ftrace_stub;
+}
+#endif
+
+
+
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index f147f19..f775d24 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -244,13 +244,6 @@ unsigned long nsecs_to_usecs(unsigned long nsecs)
 	return nsecs / 1000;
 }
 
-/*
- * TRACE_ITER_SYM_MASK masks the options in trace_flags that
- * control the output of kernel symbols.
- */
-#define TRACE_ITER_SYM_MASK \
-	(TRACE_ITER_PRINT_PARENT|TRACE_ITER_SYM_OFFSET|TRACE_ITER_SYM_ADDR)
-
 /* These must match the bit postions in trace_iterator_flags */
 static const char *trace_options[] = {
 	"print-parent",
@@ -810,6 +803,35 @@ trace_function(struct trace_array *tr, struct trace_array_cpu *data,
 	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
 }
 
+#ifdef CONFIG_FTRACE_RETURN
+static void __trace_function_return(struct trace_array *tr,
+				struct trace_array_cpu *data,
+				struct ftrace_retfunc *trace,
+				unsigned long flags,
+				int pc)
+{
+	struct ring_buffer_event *event;
+	struct ftrace_ret_entry *entry;
+	unsigned long irq_flags;
+
+	if (unlikely(local_read(&__get_cpu_var(ftrace_cpu_disabled))))
+		return;
+
+	event = ring_buffer_lock_reserve(global_trace.buffer, sizeof(*entry),
+					 &irq_flags);
+	if (!event)
+		return;
+	entry	= ring_buffer_event_data(event);
+	tracing_generic_entry_update(&entry->ent, flags, pc);
+	entry->ent.type			= TRACE_FN_RET;
+	entry->ip			= trace->func;
+	entry->parent_ip	= trace->ret;
+	entry->rettime		= trace->rettime;
+	entry->calltime		= trace->calltime;
+	ring_buffer_unlock_commit(global_trace.buffer, event, irq_flags);
+}
+#endif
+
 void
 ftrace(struct trace_array *tr, struct trace_array_cpu *data,
        unsigned long ip, unsigned long parent_ip, unsigned long flags,
@@ -1036,6 +1058,29 @@ function_trace_call(unsigned long ip, unsigned long parent_ip)
 	raw_local_irq_restore(flags);
 }
 
+#ifdef CONFIG_FTRACE_RETURN
+void trace_function_return(struct ftrace_retfunc *trace)
+{
+	struct trace_array *tr = &global_trace;
+	struct trace_array_cpu *data;
+	unsigned long flags;
+	long disabled;
+	int cpu;
+	int pc;
+
+	raw_local_irq_save(flags);
+	cpu = raw_smp_processor_id();
+	data = tr->data[cpu];
+	disabled = atomic_inc_return(&data->disabled);
+	if (likely(disabled == 1)) {
+		pc = preempt_count();
+		__trace_function_return(tr, data, trace, flags, pc);
+	}
+	atomic_dec(&data->disabled);
+	raw_local_irq_restore(flags);
+}
+#endif /* CONFIG_FTRACE_RETURN */
+
 static struct ftrace_ops trace_ops __read_mostly =
 {
 	.func = function_trace_call,
@@ -1283,7 +1328,7 @@ seq_print_sym_offset(struct trace_seq *s, const char *fmt,
 # define IP_FMT "%016lx"
 #endif
 
-static int
+int
 seq_print_ip_sym(struct trace_seq *s, unsigned long ip, unsigned long sym_flags)
 {
 	int ret;
@@ -1736,6 +1781,10 @@ static enum print_line_t print_trace_fmt(struct trace_iterator *iter)
 			trace_seq_print_cont(s, iter);
 		break;
 	}
+	case TRACE_FN_RET: {
+		return print_return_function(iter);
+		break;
+	}
 	}
 	return TRACE_TYPE_HANDLED;
 }
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 9781450..ab66a34 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -22,6 +22,7 @@ enum trace_type {
 	TRACE_MMIO_RW,
 	TRACE_MMIO_MAP,
 	TRACE_BOOT,
+	TRACE_FN_RET,
 
 	__TRACE_LAST_TYPE
 };
@@ -48,6 +49,15 @@ struct ftrace_entry {
 	unsigned long		ip;
 	unsigned long		parent_ip;
 };
+
+/* Function return entry */
+struct ftrace_ret_entry {
+	struct trace_entry	ent;
+	unsigned long		ip;
+	unsigned long		parent_ip;
+	unsigned long long	calltime;
+	unsigned long long	rettime;
+};
 extern struct tracer boot_tracer;
 
 /*
@@ -218,6 +228,7 @@ extern void __ftrace_bad_type(void);
 		IF_ASSIGN(var, ent, struct trace_mmiotrace_map,		\
 			  TRACE_MMIO_MAP);				\
 		IF_ASSIGN(var, ent, struct trace_boot, TRACE_BOOT);	\
+		IF_ASSIGN(var, ent, struct ftrace_ret_entry, TRACE_FN_RET); \
 		__ftrace_bad_type();					\
 	} while (0)
 
@@ -321,6 +332,8 @@ void trace_function(struct trace_array *tr,
 		    unsigned long ip,
 		    unsigned long parent_ip,
 		    unsigned long flags, int pc);
+void
+trace_function_return(struct ftrace_retfunc *trace);
 
 void tracing_start_cmdline_record(void);
 void tracing_stop_cmdline_record(void);
@@ -393,6 +406,10 @@ extern void *head_page(struct trace_array_cpu *data);
 extern int trace_seq_printf(struct trace_seq *s, const char *fmt, ...);
 extern void trace_seq_print_cont(struct trace_seq *s,
 				 struct trace_iterator *iter);
+
+extern int
+seq_print_ip_sym(struct trace_seq *s, unsigned long ip,
+		unsigned long sym_flags);
 extern ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf,
 				 size_t cnt);
 extern long ns2usecs(cycle_t nsec);
@@ -400,6 +417,17 @@ extern int trace_vprintk(unsigned long ip, const char *fmt, va_list args);
 
 extern unsigned long trace_flags;
 
+/* Standard output formatting function used for function return traces */
+#ifdef CONFIG_FTRACE_RETURN
+extern enum print_line_t print_return_function(struct trace_iterator *iter);
+#else
+static inline enum print_line_t
+print_return_function(struct trace_iterator *iter)
+{
+	return TRACE_TYPE_UNHANDLED;
+}
+#endif
+
 /*
  * trace_iterator_flags is an enumeration that defines bit
  * positions into trace_flags that controls the output.
@@ -422,6 +450,13 @@ enum trace_iterator_flags {
 	TRACE_ITER_PREEMPTONLY		= 0x800,
 };
 
+/*
+ * TRACE_ITER_SYM_MASK masks the options in trace_flags that
+ * control the output of kernel symbols.
+ */
+#define TRACE_ITER_SYM_MASK \
+	(TRACE_ITER_PRINT_PARENT|TRACE_ITER_SYM_OFFSET|TRACE_ITER_SYM_ADDR)
+
 extern struct tracer nop_trace;
 
 /**
diff --git a/kernel/trace/trace_functions_return.c b/kernel/trace/trace_functions_return.c
new file mode 100644
index 0000000..7680b21
--- /dev/null
+++ b/kernel/trace/trace_functions_return.c
@@ -0,0 +1,82 @@
+/*
+ *
+ * Function return tracer.
+ * Copyright (c) 2008 Frederic Weisbecker <fweisbec@gmail.com>
+ * Mostly borrowed from function tracer which
+ * is Copyright (c) Steven Rostedt <srostedt@redhat.com>
+ *
+ */
+#include <linux/debugfs.h>
+#include <linux/uaccess.h>
+#include <linux/ftrace.h>
+#include <linux/fs.h>
+
+#include "trace.h"
+
+
+static void start_return_trace(struct trace_array *tr)
+{
+	register_ftrace_return(&trace_function_return);
+}
+
+static void stop_return_trace(struct trace_array *tr)
+{
+	unregister_ftrace_return();
+}
+
+static void return_trace_init(struct trace_array *tr)
+{
+	int cpu;
+	for_each_online_cpu(cpu)
+		tracing_reset(tr, cpu);
+
+	start_return_trace(tr);
+}
+
+static void return_trace_reset(struct trace_array *tr)
+{
+		stop_return_trace(tr);
+}
+
+
+enum print_line_t
+print_return_function(struct trace_iterator *iter)
+{
+	struct trace_seq *s = &iter->seq;
+	struct trace_entry *entry = iter->ent;
+	struct ftrace_ret_entry *field;
+	int ret;
+
+	if (entry->type == TRACE_FN_RET) {
+		trace_assign_type(field, entry);
+		ret = trace_seq_printf(s, "%pF -> ", (void *)field->parent_ip);
+		if (!ret)
+			return TRACE_TYPE_PARTIAL_LINE;
+		ret = seq_print_ip_sym(s, field->ip,
+					trace_flags & TRACE_ITER_SYM_MASK);
+		if (!ret)
+			return TRACE_TYPE_PARTIAL_LINE;
+		ret = trace_seq_printf(s, " (%llu ns)\n",
+					field->rettime - field->calltime);
+		if (!ret)
+			return TRACE_TYPE_PARTIAL_LINE;
+		else
+			return TRACE_TYPE_HANDLED;
+	}
+	return TRACE_TYPE_UNHANDLED;
+}
+
+static struct tracer return_trace __read_mostly =
+{
+	.name	     = "return",
+	.init	     = return_trace_init,
+	.reset	     = return_trace_reset,
+	.print_line = print_return_function
+};
+
+static __init int init_return_trace(void)
+{
+	return register_tracer(&return_trace);
+}
+
+device_initcall(init_return_trace);
