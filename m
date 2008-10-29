Return-Path: <linux-kernel-owner+w=401wt.eu-S1754590AbYJ2WlB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbYJ2WlB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 18:41:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752112AbYJ2Wky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 18:40:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:37895 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbYJ2Wkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 18:40:53 -0400
Date: Wed, 29 Oct 2008 18:40:50 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Arjan van de Ven <arjan@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Mike Snitzer <snitzer@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Daniel Walker <dwalker@mvista.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 2/2 v3][RFC] ftrace: unlikely annotation tracer
In-Reply-To: <alpine.DEB.1.10.0810291833540.6145@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.1.10.0810291840050.6145@gandalf.stny.rr.com>
References: <170fa0d20810271529g3c64ae89me29ed8b65a9c3b5e@mail.gmail.com> <alpine.DEB.1.10.0810271918390.19731@gandalf.stny.rr.com> <20081028001340.GB9797@mit.edu> <alpine.DEB.1.10.0810272316270.802@gandalf.stny.rr.com> <20081028143720.GD8869@mit.edu>
 <20081028074816.04193e04@infradead.org> <alpine.DEB.1.10.0810281050440.29482@gandalf.stny.rr.com> <alpine.DEB.1.10.0810291233580.13214@gandalf.stny.rr.com> <alpine.DEB.1.10.0810291833540.6145@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[
  Changes since v2:

   Changed to a "func:file:line-num" format.
]

This patch adds a way to record the instances of the likely and unlikely
condition annotations.

When "unlikely" is set in /debugfs/tracing/iter_ctrl the unlikely conditions
will be added to any of the ftrace tracers.

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
 kernel/Makefile               |    5 +
 kernel/trace/Kconfig          |   22 ++++++
 kernel/trace/Makefile         |    5 +
 kernel/trace/ring_buffer.c    |   11 +++
 kernel/trace/trace.c          |   39 +++++++++++
 kernel/trace/trace.h          |   43 +++++++++++++
 kernel/trace/trace_unlikely.c |  137 ++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 262 insertions(+)

Index: linux-tip.git/kernel/trace/Kconfig
===================================================================
--- linux-tip.git.orig/kernel/trace/Kconfig	2008-10-29 17:01:11.000000000 -0400
+++ linux-tip.git/kernel/trace/Kconfig	2008-10-29 17:46:37.000000000 -0400
@@ -154,6 +154,28 @@ config TRACE_UNLIKELY_PROFILE
 
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
+	  This is traces the events of likely and unlikely condition
+	  calls in the kernel.  The difference between this and the
+	  "Trace likely/unlikely profiler" is that this is not a
+	  histogram of the callers, but actually places the calling
+	  events into a running buffer to see when and where the
+	  events happened, as well as their results.
+
+	  Say N if unsure.
+
 config STACK_TRACER
 	bool "Trace max stack"
 	depends on HAVE_FUNCTION_TRACER
Index: linux-tip.git/kernel/Makefile
===================================================================
--- linux-tip.git.orig/kernel/Makefile	2008-10-29 17:01:11.000000000 -0400
+++ linux-tip.git/kernel/Makefile	2008-10-29 17:46:37.000000000 -0400
@@ -24,6 +24,11 @@ CFLAGS_REMOVE_sched_clock.o = -pg
 CFLAGS_REMOVE_sched.o = -mno-spe -pg
 endif
 
+ifdef CONFIG_TRACING_UNLIKELY
+# Do not profile tracepoint if we are tracing the unlikely conditions
+CFLAGS_tracepoint.o += '-Dunlikely(x)=unlikely_notrace(x)'
+endif
+
 obj-$(CONFIG_FREEZER) += freezer.o
 obj-$(CONFIG_PROFILING) += profile.o
 obj-$(CONFIG_SYSCTL_SYSCALL_CHECK) += sysctl_check.o
Index: linux-tip.git/kernel/trace/Makefile
===================================================================
--- linux-tip.git.orig/kernel/trace/Makefile	2008-10-29 17:01:11.000000000 -0400
+++ linux-tip.git/kernel/trace/Makefile	2008-10-29 17:46:37.000000000 -0400
@@ -10,6 +10,11 @@ CFLAGS_trace_selftest_dynamic.o = -pg
 obj-y += trace_selftest_dynamic.o
 endif
 
+ifdef CONFIG_TRACING_UNLIKELY
+KBUILD_CFLAGS += '-Dlikely(x)=likely_notrace(x)'
+KBUILD_CFLAGS += '-Dunlikely(x)=unlikely_notrace(x)'
+endif
+
 obj-$(CONFIG_FUNCTION_TRACER) += libftrace.o
 obj-$(CONFIG_RING_BUFFER) += ring_buffer.o
 
Index: linux-tip.git/kernel/trace/trace_unlikely.c
===================================================================
--- linux-tip.git.orig/kernel/trace/trace_unlikely.c	2008-10-29 17:25:31.000000000 -0400
+++ linux-tip.git/kernel/trace/trace_unlikely.c	2008-10-29 18:03:30.000000000 -0400
@@ -15,8 +15,145 @@
 #include <asm/local.h>
 #include "trace.h"
 
+#ifdef CONFIG_UNLIKELY_TRACER
+
+static int unlikely_tracing_enabled __read_mostly;
+static DEFINE_MUTEX(unlikely_tracing_mutex);
+static DEFINE_PER_CPU(atomic_t, unlikely_trace_disabled);
+static struct trace_array *unlikely_tracer;
+
+void trace_unlikely_stop(void)
+{
+	/* preemption should be disabled */
+	int cpu = smp_processor_id();
+
+	atomic_inc(&per_cpu(unlikely_trace_disabled, cpu));
+}
+
+void trace_unlikely_start(void)
+{
+	/* preemption should be disabled */
+	int cpu = smp_processor_id();
+
+	atomic_dec(&per_cpu(unlikely_trace_disabled, cpu));
+}
+
+static void
+probe_likely_condition(struct ftrace_likely_data *f, int val, int expect)
+{
+	struct trace_array *tr = unlikely_tracer;
+	struct ring_buffer_event *event;
+	struct trace_unlikely *entry;
+	unsigned long flags, irq_flags;
+	int cpu, resched, pc;
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
+	pc = preempt_count();
+	/* Can be called within schedule */
+	resched = need_resched();
+	preempt_disable_notrace();
+	cpu = raw_smp_processor_id();
+	if (atomic_inc_return(&per_cpu(unlikely_trace_disabled, cpu)) != 1)
+		goto out;
+
+	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
+					 &irq_flags);
+	if (!event)
+		goto out;
+
+	local_save_flags(flags);
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
+	atomic_dec(&per_cpu(unlikely_trace_disabled, cpu));
+	if (resched)
+		preempt_enable_no_resched_notrace();
+	else
+		preempt_enable_notrace();
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
Index: linux-tip.git/kernel/trace/trace.c
===================================================================
--- linux-tip.git.orig/kernel/trace/trace.c	2008-10-29 17:01:11.000000000 -0400
+++ linux-tip.git/kernel/trace/trace.c	2008-10-29 18:04:04.000000000 -0400
@@ -235,6 +235,9 @@ static const char *trace_options[] = {
 	"stacktrace",
 	"sched-tree",
 	"ftrace_printk",
+#ifdef CONFIG_UNLIKELY_TRACER
+	"unlikely",
+#endif
 	NULL
 };
 
@@ -1457,6 +1460,18 @@ print_lat_fmt(struct trace_iterator *ite
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
@@ -1593,6 +1608,18 @@ static enum print_line_t print_trace_fmt
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
 	}
 	return TRACE_TYPE_HANDLED;
 }
@@ -1675,6 +1702,10 @@ static enum print_line_t print_raw_fmt(s
 			trace_seq_print_cont(s, iter);
 		break;
 	}
+	case TRACE_UNLIKELY: {
+		/* IGNORE */
+		break;
+	};
 	}
 	return TRACE_TYPE_HANDLED;
 }
@@ -2362,8 +2393,14 @@ tracing_ctrl_write(struct file *filp, co
 
 		tr->ctrl = val;
 
+		if (!val)
+			trace_unlikely_disable();
+
 		if (current_trace && current_trace->ctrl_update)
 			current_trace->ctrl_update(tr);
+
+		if (val)
+			trace_unlikely_enable(tr);
 	}
 	mutex_unlock(&trace_types_lock);
 
@@ -2425,6 +2462,7 @@ tracing_set_trace_write(struct file *fil
 	if (t == current_trace)
 		goto out;
 
+	trace_unlikely_disable();
 	if (current_trace && current_trace->reset)
 		current_trace->reset(tr);
 
@@ -2432,6 +2470,7 @@ tracing_set_trace_write(struct file *fil
 	if (t->init)
 		t->init(tr);
 
+	trace_unlikely_enable(tr);
  out:
 	mutex_unlock(&trace_types_lock);
 
Index: linux-tip.git/kernel/trace/trace.h
===================================================================
--- linux-tip.git.orig/kernel/trace/trace.h	2008-10-29 17:01:11.000000000 -0400
+++ linux-tip.git/kernel/trace/trace.h	2008-10-29 17:46:37.000000000 -0400
@@ -21,6 +21,7 @@ enum trace_type {
 	TRACE_SPECIAL,
 	TRACE_MMIO_RW,
 	TRACE_MMIO_MAP,
+	TRACE_UNLIKELY,
 	TRACE_BOOT,
 
 	__TRACE_LAST_TYPE
@@ -117,6 +118,16 @@ struct trace_boot {
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
@@ -217,6 +228,7 @@ extern void __ftrace_bad_type(void);
 		IF_ASSIGN(var, ent, struct trace_mmiotrace_map,		\
 			  TRACE_MMIO_MAP);				\
 		IF_ASSIGN(var, ent, struct trace_boot, TRACE_BOOT);	\
+		IF_ASSIGN(var, ent, struct trace_unlikely, TRACE_UNLIKELY); \
 		__ftrace_bad_type();					\
 	} while (0)
 
@@ -413,8 +425,39 @@ enum trace_iterator_flags {
 	TRACE_ITER_STACKTRACE		= 0x100,
 	TRACE_ITER_SCHED_TREE		= 0x200,
 	TRACE_ITER_PRINTK		= 0x400,
+#ifdef CONFIG_UNLIKELY_TRACER
+	TRACE_ITER_UNLIKELY		= 0x800,
+#endif
 };
 
 extern struct tracer nop_trace;
 
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
+extern void trace_unlikely_stop(void);
+extern void trace_unlikely_start(void);
+#else
+static inline int trace_unlikely_enable(struct trace_array *tr)
+{
+	return 0;
+}
+static inline void trace_unlikely_disable(void)
+{
+}
+static inline void trace_unlikely_stop(void) { }
+static inline void trace_unlikely_start(void) { }
+#endif /* CONFIG_UNLIKELY_TRACER */
+
 #endif /* _LINUX_KERNEL_TRACE_H */
Index: linux-tip.git/kernel/trace/ring_buffer.c
===================================================================
--- linux-tip.git.orig/kernel/trace/ring_buffer.c	2008-10-29 17:01:11.000000000 -0400
+++ linux-tip.git/kernel/trace/ring_buffer.c	2008-10-29 17:46:37.000000000 -0400
@@ -16,6 +16,8 @@
 #include <linux/list.h>
 #include <linux/fs.h>
 
+#include "trace.h"
+
 /* Up this if you want to test the TIME_EXTENTS and normalization */
 #define DEBUG_SHIFT 0
 
@@ -1151,7 +1153,14 @@ ring_buffer_lock_reserve(struct ring_buf
 	if (length > BUF_PAGE_SIZE)
 		goto out;
 
+	/*
+	 * Ugly, but the unlikely tracing will enter back into
+	 * the ring buffer code. Namely through the timestamp, causing
+	 * a triggering of the "again" loop, that will be infinite.
+	 */
+	trace_unlikely_stop();
 	event = rb_reserve_next_event(cpu_buffer, RINGBUF_TYPE_DATA, length);
+	trace_unlikely_start();
 	if (!event)
 		goto out;
 
@@ -1263,8 +1272,10 @@ int ring_buffer_write(struct ring_buffer
 		goto out;
 
 	event_length = rb_calculate_event_length(length);
+	trace_unlikely_stop();
 	event = rb_reserve_next_event(cpu_buffer,
 				      RINGBUF_TYPE_DATA, event_length);
+	trace_unlikely_start();
 	if (!event)
 		goto out;
 


