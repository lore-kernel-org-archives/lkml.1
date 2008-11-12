Return-Path: <linux-kernel-owner+w=401wt.eu-S1752622AbYKLFPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622AbYKLFPp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 00:15:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751296AbYKLFPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 00:15:23 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39197 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbYKLFPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 00:15:20 -0500
Message-Id: <20081112051518.503323629@goodmis.org>
References: <20081112051438.843792214@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 12 Nov 2008 00:14:40 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/2] ftrace: unlikely annotation tracer
Content-Disposition: inline; filename=0002-ftrace-unlikely-annotation-tracer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: new unlikely tracer

This patch adds a way to record the instances of the likely and unlikely
condition annotations.

When "unlikely" is set in /debugfs/tracing/iter_ctrl the unlikely conditions
will be added to any of the ftrace tracers. The change takes effect when
a new tracer is passed into the current_tracer file.

For example:

 bash-3471  [003]   357.014755: [INCORRECT] sched_info_dequeued:sched_stats.h:177
 bash-3471  [003]   357.014756: [correct] update_curr:sched_fair.c:489
 bash-3471  [003]   357.014758: [correct] calc_delta_fair:sched_fair.c:411
 bash-3471  [003]   357.014759: [correct] account_group_exec_runtime:sched_stats.h:356
 bash-3471  [003]   357.014761: [correct] update_curr:sched_fair.c:489
 bash-3471  [003]   357.014763: [INCORRECT] calc_delta_fair:sched_fair.c:411
 bash-3471  [003]   357.014765: [correct] calc_delta_mine:sched.c:1279

Which shows the normal tracer heading, as well as whether the condition was
correct "[correct]" or was mistaken "[INCORRECT]", followed by the function,
file name and line number.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/Kconfig          |   22 ++++++++
 kernel/trace/Makefile         |    6 ++
 kernel/trace/trace.c          |   29 ++++++++++
 kernel/trace/trace.h          |   39 ++++++++++++++
 kernel/trace/trace_unlikely.c |  114 +++++++++++++++++++++++++++++++++++++++++
 5 files changed, 210 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index a604f24..8abcaf8 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -175,6 +175,28 @@ config TRACE_UNLIKELY_PROFILE
 
 	  Say N if unsure.
 
+config TRACING_UNLIKELY
+	bool
+	help
+	  Selected by tracers that will trace the likely and unlikely
+	  conditions. This prevents the tracers themselves from being
+	  profiled. Profiling the tracing infrastructure can only happen
+	  when the likelys and unlikelys are not being traced.
+
+config UNLIKELY_TRACER
+	bool "Trace likely/unlikely instances"
+	depends on TRACE_UNLIKELY_PROFILE
+	select TRACING_UNLIKELY
+	help
+	  This traces the events of likely and unlikely condition
+	  calls in the kernel.  The difference between this and the
+	  "Trace likely/unlikely profiler" is that this is not a
+	  histogram of the callers, but actually places the calling
+	  events into a running trace buffer to see when and where the
+	  events happened, as well as their results.
+
+	  Say N if unsure.
+
 config STACK_TRACER
 	bool "Trace max stack"
 	depends on HAVE_FUNCTION_TRACER
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 98e70ee..c938d03 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -10,6 +10,12 @@ CFLAGS_trace_selftest_dynamic.o = -pg
 obj-y += trace_selftest_dynamic.o
 endif
 
+# If unlikely tracing is enabled, do not trace these files
+ifdef CONFIG_TRACING_UNLIKELY
+KBUILD_CFLAGS += '-Dlikely(x)=likely_notrace(x)'
+KBUILD_CFLAGS += '-Dunlikely(x)=unlikely_notrace(x)'
+endif
+
 obj-$(CONFIG_FUNCTION_TRACER) += libftrace.o
 obj-$(CONFIG_RING_BUFFER) += ring_buffer.o
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index a3f7ae9..83d3863 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -258,6 +258,9 @@ static const char *trace_options[] = {
 	"sched-tree",
 	"ftrace_printk",
 	"ftrace_preempt",
+#ifdef CONFIG_UNLIKELY_TRACER
+	"unlikely",
+#endif
 	NULL
 };
 
@@ -1648,6 +1651,18 @@ print_lat_fmt(struct trace_iterator *iter, unsigned int trace_idx, int cpu)
 			trace_seq_print_cont(s, iter);
 		break;
 	}
+	case TRACE_UNLIKELY: {
+		struct trace_unlikely *field;
+
+		trace_assign_type(field, entry);
+
+		trace_seq_printf(s, "[%s] %s:%s:%d\n",
+				 field->correct ? "correct" : "INCORRECT",
+				 field->func,
+				 field->file,
+				 field->line);
+		break;
+	}
 	default:
 		trace_seq_printf(s, "Unknown type %d\n", entry->type);
 	}
@@ -1787,6 +1802,18 @@ static enum print_line_t print_trace_fmt(struct trace_iterator *iter)
 		return print_return_function(iter);
 		break;
 	}
+	case TRACE_UNLIKELY: {
+		struct trace_unlikely *field;
+
+		trace_assign_type(field, entry);
+
+		trace_seq_printf(s, "[%s] %s:%s:%d\n",
+				 field->correct ? "correct" : "INCORRECT",
+				 field->func,
+				 field->file,
+				 field->line);
+		break;
+	}
 	}
 	return TRACE_TYPE_HANDLED;
 }
@@ -2592,6 +2619,7 @@ static int tracing_set_tracer(char *buf)
 	if (t == current_trace)
 		goto out;
 
+	trace_unlikely_disable();
 	if (current_trace && current_trace->reset)
 		current_trace->reset(tr);
 
@@ -2599,6 +2627,7 @@ static int tracing_set_tracer(char *buf)
 	if (t->init)
 		t->init(tr);
 
+	trace_unlikely_enable(tr);
  out:
 	mutex_unlock(&trace_types_lock);
 
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index e40ce0c..b20eed0 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -21,6 +21,7 @@ enum trace_type {
 	TRACE_SPECIAL,
 	TRACE_MMIO_RW,
 	TRACE_MMIO_MAP,
+	TRACE_UNLIKELY,
 	TRACE_BOOT,
 	TRACE_FN_RET,
 
@@ -127,6 +128,16 @@ struct trace_boot {
 	struct boot_trace	initcall;
 };
 
+#define TRACE_FUNC_SIZE 30
+#define TRACE_FILE_SIZE 20
+struct trace_unlikely {
+	struct trace_entry	ent;
+	unsigned	        line;
+	char			func[TRACE_FUNC_SIZE+1];
+	char			file[TRACE_FILE_SIZE+1];
+	char			correct;
+};
+
 /*
  * trace_flag_type is an enumeration that holds different
  * states when a trace occurs. These are:
@@ -228,6 +239,7 @@ extern void __ftrace_bad_type(void);
 		IF_ASSIGN(var, ent, struct trace_mmiotrace_map,		\
 			  TRACE_MMIO_MAP);				\
 		IF_ASSIGN(var, ent, struct trace_boot, TRACE_BOOT);	\
+		IF_ASSIGN(var, ent, struct trace_unlikely, TRACE_UNLIKELY); \
 		IF_ASSIGN(var, ent, struct ftrace_ret_entry, TRACE_FN_RET); \
 		__ftrace_bad_type();					\
 	} while (0)
@@ -448,6 +460,9 @@ enum trace_iterator_flags {
 	TRACE_ITER_SCHED_TREE		= 0x200,
 	TRACE_ITER_PRINTK		= 0x400,
 	TRACE_ITER_PREEMPTONLY		= 0x800,
+#ifdef CONFIG_UNLIKELY_TRACER
+	TRACE_ITER_UNLIKELY		= 0x1000,
+#endif
 };
 
 /*
@@ -507,4 +522,28 @@ static inline void ftrace_preempt_enable(int resched)
 		preempt_enable_notrace();
 }
 
+#ifdef CONFIG_UNLIKELY_TRACER
+extern int enable_unlikely_tracing(struct trace_array *tr);
+extern void disable_unlikely_tracing(void);
+static inline int trace_unlikely_enable(struct trace_array *tr)
+{
+	if (trace_flags & TRACE_ITER_UNLIKELY)
+		return enable_unlikely_tracing(tr);
+	return 0;
+}
+static inline void trace_unlikely_disable(void)
+{
+	/* due to races, always disable */
+	disable_unlikely_tracing();
+}
+#else
+static inline int trace_unlikely_enable(struct trace_array *tr)
+{
+	return 0;
+}
+static inline void trace_unlikely_disable(void)
+{
+}
+#endif /* CONFIG_UNLIKELY_TRACER */
+
 #endif /* _LINUX_KERNEL_TRACE_H */
diff --git a/kernel/trace/trace_unlikely.c b/kernel/trace/trace_unlikely.c
index 9493269..7290e0e 100644
--- a/kernel/trace/trace_unlikely.c
+++ b/kernel/trace/trace_unlikely.c
@@ -15,8 +15,122 @@
 #include <asm/local.h>
 #include "trace.h"
 
+#ifdef CONFIG_UNLIKELY_TRACER
+
+static int unlikely_tracing_enabled __read_mostly;
+static DEFINE_MUTEX(unlikely_tracing_mutex);
+static struct trace_array *unlikely_tracer;
+
+static void
+probe_likely_condition(struct ftrace_likely_data *f, int val, int expect)
+{
+	struct trace_array *tr = unlikely_tracer;
+	struct ring_buffer_event *event;
+	struct trace_unlikely *entry;
+	unsigned long flags, irq_flags;
+	int cpu, pc;
+	const char *p;
+
+	/*
+	 * I would love to save just the ftrace_likely_data pointer, but
+	 * this code can also be used by modules. Ugly things can happen
+	 * if the module is unloaded, and then we go and read the
+	 * pointer.  This is slower, but much safer.
+	 */
+
+	if (unlikely(!tr))
+		return;
+
+	local_irq_save(flags);
+	cpu = raw_smp_processor_id();
+	if (atomic_inc_return(&tr->data[cpu]->disabled) != 1)
+		goto out;
+
+	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
+					 &irq_flags);
+	if (!event)
+		goto out;
+
+	pc = preempt_count();
+	entry	= ring_buffer_event_data(event);
+	tracing_generic_entry_update(&entry->ent, flags, pc);
+	entry->ent.type		= TRACE_UNLIKELY;
+
+	/* Strip off the path, only save the file */
+	p = f->file + strlen(f->file);
+	while (p >= f->file && *p != '/')
+		p--;
+	p++;
+
+	strncpy(entry->func, f->func, TRACE_FUNC_SIZE);
+	strncpy(entry->file, p, TRACE_FILE_SIZE);
+	entry->func[TRACE_FUNC_SIZE] = 0;
+	entry->file[TRACE_FILE_SIZE] = 0;
+	entry->line = f->line;
+	entry->correct = val == expect;
+
+	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
+
+ out:
+	atomic_dec(&tr->data[cpu]->disabled);
+	local_irq_restore(flags);
+}
+
+static inline
+void trace_likely_condition(struct ftrace_likely_data *f, int val, int expect)
+{
+	if (!unlikely_tracing_enabled)
+		return;
+
+	probe_likely_condition(f, val, expect);
+}
+
+int enable_unlikely_tracing(struct trace_array *tr)
+{
+	int ret = 0;
+
+	mutex_lock(&unlikely_tracing_mutex);
+	unlikely_tracer = tr;
+	/*
+	 * Must be seen before enabling. The reader is a condition
+	 * where we do not need a matching rmb()
+	 */
+	smp_wmb();
+	unlikely_tracing_enabled++;
+	mutex_unlock(&unlikely_tracing_mutex);
+
+	return ret;
+}
+
+void disable_unlikely_tracing(void)
+{
+	mutex_lock(&unlikely_tracing_mutex);
+
+	if (!unlikely_tracing_enabled)
+		goto out_unlock;
+
+	unlikely_tracing_enabled--;
+
+ out_unlock:
+	mutex_unlock(&unlikely_tracing_mutex);
+}
+#else
+static inline
+void trace_likely_condition(struct ftrace_likely_data *f, int val, int expect)
+{
+}
+#endif /* CONFIG_UNLIKELY_TRACER */
+
 void ftrace_likely_update(struct ftrace_likely_data *f, int val, int expect)
 {
+	/*
+	 * I would love to have a trace point here instead, but the
+	 * trace point code is so inundated with unlikely and likely
+	 * conditions that the recursive nightmare that exists is too
+	 * much to try to get working. At least for now.
+	 */
+	trace_likely_condition(f, val, expect);
+
 	/* FIXME: Make this atomic! */
 	if (val == expect)
 		f->correct++;
-- 
1.5.6.5

-- 
