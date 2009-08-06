Return-Path: <linux-kernel-owner+w=401wt.eu-S1756875AbZHFX0D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875AbZHFX0D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 19:26:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753965AbZHFX0B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 19:26:01 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:41581 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbZHFXZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 19:25:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=gW3imB4to4EdAx5AVyWs75Zw2lc+ysUv0EM1uoIkMI4H3sjLBVK5zlxn6CIX7p4i2s
         vtGUbCmxyKgDR9Ni5kg+3cbfYFoet8JRJHgY/0XsntvAgYODk2643wq3CSAs5u7kv49N
         zYWUKHQhroAP3yAbZpk0fvn5Q4VwXZvmdSyeo=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH] perfcounters: Support for ftrace event records sampling
Date: Fri,  7 Aug 2009 01:25:54 +0200
Message-Id: <1249601154-5597-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch brings the kernel side support for ftrace event record
sampling.

A new counter attribute is added: PERF_SAMPLE_TP_RECORD which requests
ftrace events record sampling.

For now, the events record are always copied from the event profiling
callback and passed down to perfcounter. Perfcounter will just zap
the record copy if the attribute is not set.

Result, after forcing PERF_SAMPLE_TP_RECORD attribute from perf record:

perf record -f -F 1 -a -e workqueue:workqueue_execution
perf report -D

0x21e18 [0x48]: event: 9
.
. ... raw event: size 72 bytes
.  0000:  09 00 00 00 01 00 48 00 d0 c7 00 81 ff ff ff ff  ......H........
.  0010:  0a 00 00 00 0a 00 00 00 21 00 00 00 00 00 00 00  ........!......
.  0020:  2b 00 01 02 0a 00 00 00 0a 00 00 00 65 76 65 6e  +...........eve
.  0030:  74 73 2f 31 00 00 00 00 00 00 00 00 0a 00 00 00  ts/1...........
.  0040:  e0 b1 31 81 ff ff ff ff                          .......
.
0x21e18 [0x48]: PERF_EVENT_SAMPLE (IP, 1): 10: 0xffffffff8100c7d0 period: 33

The ftrace record starts at offset 0020.
Translation:

struct trace_entry {
	type		= 0x2b = 43;
	flags		= 1;
	preempt_count	= 2;
	pid		= 0xa = 10;
	tgid		= 0xa = 10;
}

thread_comm = "events/1"
thread_pid  = 0xa = 10;
func	    = 0xffffffff8131b1e0 = flush_to_ldisc()

What will come next?

- The unconditional copy from the profiling callback brings some costs
  however, and may require to be fixed in the future. For that we need
  to have an instant access to the perf counter attribute. This is a
  matter of a flag to add in the struct ftrace_event.

- Be care of the events recursivity! Don't ever try to record a lock event
  for example, it seems some locking is used in the profiling fast path and
  lead to a tracing recursivity. That will be fixed using raw spinlock or
  recursivity protection.

- Userspace support

- [...]

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 include/linux/ftrace_event.h |    4 +-
 include/linux/perf_counter.h |    9 +++-
 include/trace/ftrace.h       |  130 +++++++++++++++++++++++++++++++-----------
 kernel/perf_counter.c        |   18 ++++++-
 kernel/trace/trace.h         |    4 -
 tools/perf/builtin-record.c  |    1 +
 6 files changed, 125 insertions(+), 41 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index c04e6d9..ac8c6f8 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -89,7 +89,9 @@ enum print_line_t {
 	TRACE_TYPE_NO_CONSUME	= 3	/* Handled but ask to not consume */
 };
 
-
+void tracing_generic_entry_update(struct trace_entry *entry,
+				  unsigned long flags,
+				  int pc);
 struct ring_buffer_event *
 trace_current_buffer_lock_reserve(int type, unsigned long len,
 				  unsigned long flags, int pc);
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index e604e6e..a67dd5c 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -121,8 +121,9 @@ enum perf_counter_sample_format {
 	PERF_SAMPLE_CPU				= 1U << 7,
 	PERF_SAMPLE_PERIOD			= 1U << 8,
 	PERF_SAMPLE_STREAM_ID			= 1U << 9,
+	PERF_SAMPLE_TP_RECORD			= 1U << 10,
 
-	PERF_SAMPLE_MAX = 1U << 10,		/* non-ABI */
+	PERF_SAMPLE_MAX = 1U << 11,		/* non-ABI */
 };
 
 /*
@@ -413,6 +414,11 @@ struct perf_callchain_entry {
 	__u64				ip[PERF_MAX_STACK_DEPTH];
 };
 
+struct perf_tracepoint_record {
+	int				size;
+	char				*record;
+};
+
 struct task_struct;
 
 /**
@@ -681,6 +687,7 @@ struct perf_sample_data {
 	struct pt_regs			*regs;
 	u64				addr;
 	u64				period;
+	void				*private;
 };
 
 extern int perf_counter_overflow(struct perf_counter *counter, int nmi,
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 380b603..80e5f6c 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -355,15 +355,7 @@ static inline int ftrace_get_offsets_##call(				\
 /*
  * Generate the functions needed for tracepoint perf_counter support.
  *
- * static void ftrace_profile_<call>(proto)
- * {
- * 	extern void perf_tpcounter_event(int, u64, u64);
- * 	u64 __addr = 0, __count = 1;
- *
- * 	<assign>   <-- here we expand the TP_perf_assign() macro
- *
- * 	perf_tpcounter_event(event_<call>.id, __addr, __count);
- * }
+ * NOTE: The insertion profile callback (ftrace_profile_<call>) is defined later
  *
  * static int ftrace_profile_enable_<call>(struct ftrace_event_call *event_call)
  * {
@@ -383,28 +375,10 @@ static inline int ftrace_get_offsets_##call(				\
  *
  */
 
-#undef TP_fast_assign
-#define TP_fast_assign(args...)
-
-#undef TP_perf_assign
-#define TP_perf_assign(args...) args
-
-#undef __perf_addr
-#define __perf_addr(a) __addr = (a)
-
-#undef __perf_count
-#define __perf_count(c) __count = (c)
-
 #undef TRACE_EVENT
 #define TRACE_EVENT(call, proto, args, tstruct, assign, print)		\
 									\
-static void ftrace_profile_##call(proto)				\
-{									\
-	extern void perf_tpcounter_event(int, u64, u64);		\
-	u64 __addr = 0, __count = 1;					\
-	{ assign; }							\
-	perf_tpcounter_event(event_##call.id, __addr, __count);		\
-}									\
+static void ftrace_profile_##call(proto);				\
 									\
 static int ftrace_profile_enable_##call(struct ftrace_event_call *event_call) \
 {									\
@@ -424,12 +398,6 @@ static void ftrace_profile_disable_##call(struct ftrace_event_call *event_call)\
 
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
-#undef TP_fast_assign
-#define TP_fast_assign(args...) args
-
-#undef TP_perf_assign
-#define TP_perf_assign(args...)
-
 #endif
 
 /*
@@ -649,5 +617,99 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
+/*
+ * Define the insertion callback to profile events
+ *
+ * The job is very similar to ftrace_raw_event_<call> except that we don't
+ * insert in the ring buffer but in a perf counter.
+ *
+ * static void ftrace_profile_<call>(proto)
+ * {
+ *	struct ftrace_data_offsets_<call> __maybe_unused __data_offsets;
+ *	struct ftrace_event_call *event_call = &event_<call>;
+ *	extern void perf_tpcounter_event(int, u64, u64, void *, int);
+ *	struct ftrace_raw_##call *entry;
+ *	u64 __addr = 0, __count = 1;
+ *	unsigned long irq_flags;
+ *	int __entry_size;
+ *	int __data_size;
+ *	int pc;
+ *
+ *	local_save_flags(irq_flags);
+ *	pc = preempt_count();
+ *
+ *	__data_size = ftrace_get_offsets_<call>(&__data_offsets, args);
+ *	__entry_size = __data_size + sizeof(*entry);
+ *
+ *	do {
+ *		char raw_data[__entry_size]; <- allocate our sample in the stack
+ *		struct trace_entry *ent;
+ *
+ *		entry = (struct ftrace_raw_<call> *)raw_data;
+ *		ent = &entry->ent;
+ *		tracing_generic_entry_update(ent, irq_flags, pc);
+ *		ent->type = event_call->id;
+ *
+ *		<tstruct> <- do some jobs with dynamic arrays
+ *
+ *		<assign>  <- affect our values
+ *
+ *		perf_tpcounter_event(event_call->id, __addr, __count, entry,
+ *			     __entry_size);  <- submit them to perf counter
+ *	} while (0);
+ *
+ * }
+ */
+
+#ifdef CONFIG_EVENT_PROFILE
+
+#undef __perf_addr
+#define __perf_addr(a) __addr = (a)
+
+#undef __perf_count
+#define __perf_count(c) __count = (c)
+
+#undef TRACE_EVENT
+#define TRACE_EVENT(call, proto, args, tstruct, assign, print)		\
+static void ftrace_profile_##call(proto)				\
+{									\
+	struct ftrace_data_offsets_##call __maybe_unused __data_offsets;\
+	struct ftrace_event_call *event_call = &event_##call;		\
+	extern void perf_tpcounter_event(int, u64, u64, void *, int);	\
+	struct ftrace_raw_##call *entry;				\
+	u64 __addr = 0, __count = 1;					\
+	unsigned long irq_flags;					\
+	int __entry_size;						\
+	int __data_size;						\
+	int pc;								\
+									\
+	local_save_flags(irq_flags);					\
+	pc = preempt_count();						\
+									\
+	__data_size = ftrace_get_offsets_##call(&__data_offsets, args); \
+	__entry_size = __data_size + sizeof(*entry);			\
+									\
+	do {								\
+		char raw_data[__entry_size];				\
+		struct trace_entry *ent;				\
+									\
+		entry = (struct ftrace_raw_##call *)raw_data;		\
+		ent = &entry->ent;					\
+		tracing_generic_entry_update(ent, irq_flags, pc);	\
+		ent->type = event_call->id;				\
+									\
+		tstruct							\
+									\
+		{ assign; }						\
+									\
+		perf_tpcounter_event(event_call->id, __addr, __count, entry,\
+			     __entry_size);				\
+	} while (0);							\
+									\
+}
+
+#include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
+#endif /* CONFIG_EVENT_PROFILE */
+
 #undef _TRACE_PROFILE_INIT
 
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 06d210c..93f4312 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -2646,6 +2646,7 @@ static void perf_counter_output(struct perf_counter *counter, int nmi,
 		u64 counter;
 	} group_entry;
 	struct perf_callchain_entry *callchain = NULL;
+	struct perf_tracepoint_record *tp;
 	int callchain_size = 0;
 	u64 time;
 	struct {
@@ -2714,6 +2715,11 @@ static void perf_counter_output(struct perf_counter *counter, int nmi,
 			header.size += sizeof(u64);
 	}
 
+	if (sample_type & PERF_SAMPLE_TP_RECORD) {
+		tp = data->private;
+		header.size += tp->size;
+	}
+
 	ret = perf_output_begin(&handle, counter, header.size, nmi, 1);
 	if (ret)
 		return;
@@ -2777,6 +2783,9 @@ static void perf_counter_output(struct perf_counter *counter, int nmi,
 		}
 	}
 
+	if (sample_type & PERF_SAMPLE_TP_RECORD)
+		perf_output_copy(&handle, tp->record, tp->size);
+
 	perf_output_end(&handle);
 }
 
@@ -3727,11 +3736,18 @@ static const struct pmu perf_ops_task_clock = {
 };
 
 #ifdef CONFIG_EVENT_PROFILE
-void perf_tpcounter_event(int event_id, u64 addr, u64 count)
+void perf_tpcounter_event(int event_id, u64 addr, u64 count, void *record,
+			  int entry_size)
 {
+	struct perf_tracepoint_record tp = {
+		.size = entry_size,
+		.record = record,
+	};
+
 	struct perf_sample_data data = {
 		.regs = get_irq_regs(),
 		.addr = addr,
+		.private = &tp,
 	};
 
 	if (!data.regs)
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 87b004f..44308f3 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -454,10 +454,6 @@ struct trace_entry *tracing_get_trace_entry(struct trace_array *tr,
 struct trace_entry *trace_find_next_entry(struct trace_iterator *iter,
 					  int *ent_cpu, u64 *ent_ts);
 
-void tracing_generic_entry_update(struct trace_entry *entry,
-				  unsigned long flags,
-				  int pc);
-
 void default_wait_pipe(struct trace_iterator *iter);
 void poll_wait_pipe(struct trace_iterator *iter);
 
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 6da0992..90c9808 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -412,6 +412,7 @@ static void create_counter(int counter, int cpu, pid_t pid)
 	if (call_graph)
 		attr->sample_type	|= PERF_SAMPLE_CALLCHAIN;
 
+
 	attr->mmap		= track;
 	attr->comm		= track;
 	attr->inherit		= (cpu < 0) && inherit;
-- 
1.6.2.3

