Return-Path: <linux-kernel-owner+w=401wt.eu-S1757059AbZHGHfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757059AbZHGHfy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 03:35:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756622AbZHGHfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 03:35:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:41007 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755609AbZHGHfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 03:35:52 -0400
Date: Fri, 7 Aug 2009 07:33:55 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
       penberg@cs.helsinki.fi, a.p.zijlstra@chello.nl, lizf@cn.fujitsu.com,
       efault@gmx.de, eduard.munteanu@linux360.ro, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, laijs@cn.fujitsu.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, tzanussi@gmail.com, lizf@cn.fujitsu.com,
       a.p.zijlstra@chello.nl, penberg@cs.helsinki.fi, efault@gmx.de,
       eduard.munteanu@linux360.ro, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, laijs@cn.fujitsu.com, mingo@elte.hu
In-Reply-To: <1249601154-5597-1-git-send-email-fweisbec@gmail.com>
References: <1249601154-5597-1-git-send-email-fweisbec@gmail.com>
Subject: [tip:perfcounters/tracing] perf_counter: Support for ftrace event records sampling
Message-ID: <tip-24cb4fabe71f1d896b504cec82277ad7426a3d6d@git.kernel.org>
Git-Commit-ID: 24cb4fabe71f1d896b504cec82277ad7426a3d6d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 07 Aug 2009 07:33:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  24cb4fabe71f1d896b504cec82277ad7426a3d6d
Gitweb:     http://git.kernel.org/tip/24cb4fabe71f1d896b504cec82277ad7426a3d6d
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Fri, 7 Aug 2009 01:25:54 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 7 Aug 2009 09:30:33 +0200

perf_counter: Support for ftrace event records sampling

This patch implements the kernel side support for ftrace event
record sampling.

A new counter sampling attribute is added:

   PERF_SAMPLE_TP_RECORD

which requests ftrace events record sampling. In this case
if a PERF_TYPE_TRACEPOINT counter is active and a tracepoint
fires, we emit the tracepoint binary record to the
perfcounter event buffer, as a sample.

Result, after setting PERF_SAMPLE_TP_RECORD attribute from perf
record:

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

The raw ftrace binary record starts at offset 0020.

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

 - Userspace support ('perf trace'), 'flight data recorder' mode
   for perf trace, etc.

 - The unconditional copy from the profiling callback brings
   some costs however if someone wants no such sampling to
   occur, and needs to be fixed in the future. For that we need
   to have an instant access to the perf counter attribute.
   This is a matter of a flag to add in the struct ftrace_event.

 - Take care of the events recursivity! Don't ever try to record
   a lock event for example, it seems some locking is used in
   the profiling fast path and lead to a tracing recursivity.
   That will be fixed using raw spinlock or recursivity
   protection.

 - [...]

 - Profit! :-)

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
LKML-Reference: <1249601154-5597-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/ftrace_event.h |    4 +-
 include/linux/perf_counter.h |    9 +++-
 include/trace/ftrace.h       |  130 +++++++++++++++++++++++++++++++-----------
 kernel/perf_counter.c        |   18 ++++++-
 kernel/trace/trace.h         |    4 -
 tools/perf/builtin-record.c  |    1 +
 6 files changed, 125 insertions(+), 41 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 5c093ff..8872ec9 100644
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
index bd15d7a..e175982 100644
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
@@ -402,6 +403,11 @@ struct perf_callchain_entry {
 	__u64				ip[PERF_MAX_STACK_DEPTH];
 };
 
+struct perf_tracepoint_record {
+	int				size;
+	char				*record;
+};
+
 struct task_struct;
 
 /**
@@ -670,6 +676,7 @@ struct perf_sample_data {
 	struct pt_regs			*regs;
 	u64				addr;
 	u64				period;
+	void				*private;
 };
 
 extern int perf_counter_overflow(struct perf_counter *counter, int nmi,
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index fec71f8..bbf9042 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -353,15 +353,7 @@ static inline int ftrace_get_offsets_##call(				\
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
@@ -381,28 +373,10 @@ static inline int ftrace_get_offsets_##call(				\
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
@@ -422,12 +396,6 @@ static void ftrace_profile_disable_##call(struct ftrace_event_call *event_call)\
 
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
-#undef TP_fast_assign
-#define TP_fast_assign(args...) args
-
-#undef TP_perf_assign
-#define TP_perf_assign(args...)
-
 #endif
 
 /*
@@ -647,5 +615,99 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 
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
index 7d281b4..40155bc 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -2631,6 +2631,7 @@ static void perf_counter_output(struct perf_counter *counter, int nmi,
 		u64 counter;
 	} group_entry;
 	struct perf_callchain_entry *callchain = NULL;
+	struct perf_tracepoint_record *tp;
 	int callchain_size = 0;
 	u64 time;
 	struct {
@@ -2699,6 +2700,11 @@ static void perf_counter_output(struct perf_counter *counter, int nmi,
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
@@ -2762,6 +2768,9 @@ static void perf_counter_output(struct perf_counter *counter, int nmi,
 		}
 	}
 
+	if (sample_type & PERF_SAMPLE_TP_RECORD)
+		perf_output_copy(&handle, tp->record, tp->size);
+
 	perf_output_end(&handle);
 }
 
@@ -3673,11 +3682,18 @@ static const struct pmu perf_ops_task_clock = {
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
index 3548ae5..8b9f4f6 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -438,10 +438,6 @@ struct trace_entry *tracing_get_trace_entry(struct trace_array *tr,
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
