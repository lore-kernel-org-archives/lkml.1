Return-Path: <linux-kernel-owner+w=401wt.eu-S1751879AbZHIQIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879AbZHIQIu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 12:08:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751424AbZHIQIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 12:08:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59381 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751402AbZHIQIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 12:08:48 -0400
Date: Sun, 9 Aug 2009 18:08:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] tracing fixes
Message-ID: <20090809160831.GA27832@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest tracing-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing-fixes-for-linus

Note, these two commits:

 f413cdb: perf_counter: Fix/complete ftrace event records sampling
 3a65930: perf_counter, ftrace: Fix perf_counter integration

are not regression fixes as perfcounters are new in .31, but 
fixes/enhancements to perfcounters+tracepoints integration. I kept 
them at the end of the tree and can zap them if they are a problem.

 Thanks,

	Ingo

------------------>
Eric Dumazet (1):
      ring-buffer: Fix memleak in ring_buffer_free()

Frederic Weisbecker (1):
      perf_counter: Fix/complete ftrace event records sampling

Peter Zijlstra (1):
      perf_counter, ftrace: Fix perf_counter integration

Robert Richter (1):
      ring-buffer: Fix advance of reader in rb_buffer_peek()

Steven Rostedt (4):
      ring-buffer: fix check of try_to_discard result
      ring-buffer: do not disable ring buffer on oops_in_progress
      tracing: do not use functions starting with .L in recordmcount.pl
      tracing: Fix recordmcount.pl to handle sections with only weak functions

Tom Zanussi (2):
      tracing/filters: Don't use pred on alloc failure
      tracing/filters: Always free pred on filter_add_subsystem_pred() failure


 include/linux/ftrace_event.h       |    4 +-
 include/linux/perf_counter.h       |    9 ++-
 include/trace/ftrace.h             |  172 ++++++++++++++++++++++++++++++-----
 kernel/perf_counter.c              |   22 ++++-
 kernel/trace/ring_buffer.c         |   15 ++--
 kernel/trace/trace.c               |    1 +
 kernel/trace/trace.h               |    4 -
 kernel/trace/trace_events_filter.c |   20 +++-
 scripts/recordmcount.pl            |    9 ++-
 tools/perf/builtin-record.c        |    1 +
 10 files changed, 207 insertions(+), 50 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index d7cd193..a81170d 100644
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
index 1867553..7fb16d9 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -144,6 +144,9 @@
 #undef TP_fast_assign
 #define TP_fast_assign(args...) args
 
+#undef TP_perf_assign
+#define TP_perf_assign(args...)
+
 #undef TRACE_EVENT
 #define TRACE_EVENT(call, proto, args, tstruct, func, print)		\
 static int								\
@@ -345,6 +348,56 @@ static inline int ftrace_get_offsets_##call(				\
 
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
+#ifdef CONFIG_EVENT_PROFILE
+
+/*
+ * Generate the functions needed for tracepoint perf_counter support.
+ *
+ * NOTE: The insertion profile callback (ftrace_profile_<call>) is defined later
+ *
+ * static int ftrace_profile_enable_<call>(struct ftrace_event_call *event_call)
+ * {
+ * 	int ret = 0;
+ *
+ * 	if (!atomic_inc_return(&event_call->profile_count))
+ * 		ret = register_trace_<call>(ftrace_profile_<call>);
+ *
+ * 	return ret;
+ * }
+ *
+ * static void ftrace_profile_disable_<call>(struct ftrace_event_call *event_call)
+ * {
+ * 	if (atomic_add_negative(-1, &event->call->profile_count))
+ * 		unregister_trace_<call>(ftrace_profile_<call>);
+ * }
+ *
+ */
+
+#undef TRACE_EVENT
+#define TRACE_EVENT(call, proto, args, tstruct, assign, print)		\
+									\
+static void ftrace_profile_##call(proto);				\
+									\
+static int ftrace_profile_enable_##call(struct ftrace_event_call *event_call) \
+{									\
+	int ret = 0;							\
+									\
+	if (!atomic_inc_return(&event_call->profile_count))		\
+		ret = register_trace_##call(ftrace_profile_##call);	\
+									\
+	return ret;							\
+}									\
+									\
+static void ftrace_profile_disable_##call(struct ftrace_event_call *event_call)\
+{									\
+	if (atomic_add_negative(-1, &event_call->profile_count))	\
+		unregister_trace_##call(ftrace_profile_##call);		\
+}
+
+#include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
+
+#endif
+
 /*
  * Stage 4 of the trace events.
  *
@@ -447,28 +500,6 @@ static inline int ftrace_get_offsets_##call(				\
 #define TP_FMT(fmt, args...)	fmt "\n", ##args
 
 #ifdef CONFIG_EVENT_PROFILE
-#define _TRACE_PROFILE(call, proto, args)				\
-static void ftrace_profile_##call(proto)				\
-{									\
-	extern void perf_tpcounter_event(int);				\
-	perf_tpcounter_event(event_##call.id);				\
-}									\
-									\
-static int ftrace_profile_enable_##call(struct ftrace_event_call *event_call) \
-{									\
-	int ret = 0;							\
-									\
-	if (!atomic_inc_return(&event_call->profile_count))		\
-		ret = register_trace_##call(ftrace_profile_##call);	\
-									\
-	return ret;							\
-}									\
-									\
-static void ftrace_profile_disable_##call(struct ftrace_event_call *event_call)\
-{									\
-	if (atomic_add_negative(-1, &event_call->profile_count))	\
-		unregister_trace_##call(ftrace_profile_##call);		\
-}
 
 #define _TRACE_PROFILE_INIT(call)					\
 	.profile_count = ATOMIC_INIT(-1),				\
@@ -476,7 +507,6 @@ static void ftrace_profile_disable_##call(struct ftrace_event_call *event_call)\
 	.profile_disable = ftrace_profile_disable_##call,
 
 #else
-#define _TRACE_PROFILE(call, proto, args)
 #define _TRACE_PROFILE_INIT(call)
 #endif
 
@@ -502,7 +532,6 @@ static void ftrace_profile_disable_##call(struct ftrace_event_call *event_call)\
 
 #undef TRACE_EVENT
 #define TRACE_EVENT(call, proto, args, tstruct, assign, print)		\
-_TRACE_PROFILE(call, PARAMS(proto), PARAMS(args))			\
 									\
 static struct ftrace_event_call event_##call;				\
 									\
@@ -586,6 +615,99 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
-#undef _TRACE_PROFILE
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
+	__entry_size = ALIGN(__data_size + sizeof(*entry), sizeof(u64));\
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
index 673c1aa..8681021 100644
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
 
@@ -3703,17 +3712,24 @@ static const struct pmu perf_ops_task_clock = {
 };
 
 #ifdef CONFIG_EVENT_PROFILE
-void perf_tpcounter_event(int event_id)
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
-		.addr = 0,
+		.addr = addr,
+		.private = &tp,
 	};
 
 	if (!data.regs)
 		data.regs = task_pt_regs(current);
 
-	do_perf_swcounter_event(PERF_TYPE_TRACEPOINT, event_id, 1, 1, &data);
+	do_perf_swcounter_event(PERF_TYPE_TRACEPOINT, event_id, count, 1, &data);
 }
 EXPORT_SYMBOL_GPL(perf_tpcounter_event);
 
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index bf27bb7..a330513 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -735,6 +735,7 @@ ring_buffer_free(struct ring_buffer *buffer)
 
 	put_online_cpus();
 
+	kfree(buffer->buffers);
 	free_cpumask_var(buffer->cpumask);
 
 	kfree(buffer);
@@ -1785,7 +1786,7 @@ void ring_buffer_discard_commit(struct ring_buffer *buffer,
 	 */
 	RB_WARN_ON(buffer, !local_read(&cpu_buffer->committing));
 
-	if (!rb_try_to_discard(cpu_buffer, event))
+	if (rb_try_to_discard(cpu_buffer, event))
 		goto out;
 
 	/*
@@ -2383,7 +2384,6 @@ rb_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
 		 * the box. Return the padding, and we will release
 		 * the current locks, and try again.
 		 */
-		rb_advance_reader(cpu_buffer);
 		return event;
 
 	case RINGBUF_TYPE_TIME_EXTEND:
@@ -2486,7 +2486,7 @@ static inline int rb_ok_to_lock(void)
 	 * buffer too. A one time deal is all you get from reading
 	 * the ring buffer from an NMI.
 	 */
-	if (likely(!in_nmi() && !oops_in_progress))
+	if (likely(!in_nmi()))
 		return 1;
 
 	tracing_off_permanent();
@@ -2519,6 +2519,8 @@ ring_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
 	if (dolock)
 		spin_lock(&cpu_buffer->reader_lock);
 	event = rb_buffer_peek(buffer, cpu, ts);
+	if (event && event->type_len == RINGBUF_TYPE_PADDING)
+		rb_advance_reader(cpu_buffer);
 	if (dolock)
 		spin_unlock(&cpu_buffer->reader_lock);
 	local_irq_restore(flags);
@@ -2590,12 +2592,9 @@ ring_buffer_consume(struct ring_buffer *buffer, int cpu, u64 *ts)
 		spin_lock(&cpu_buffer->reader_lock);
 
 	event = rb_buffer_peek(buffer, cpu, ts);
-	if (!event)
-		goto out_unlock;
-
-	rb_advance_reader(cpu_buffer);
+	if (event)
+		rb_advance_reader(cpu_buffer);
 
- out_unlock:
 	if (dolock)
 		spin_unlock(&cpu_buffer->reader_lock);
 	local_irq_restore(flags);
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 8930e39..c22b40f 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -848,6 +848,7 @@ tracing_generic_entry_update(struct trace_entry *entry, unsigned long flags,
 		((pc & SOFTIRQ_MASK) ? TRACE_FLAG_SOFTIRQ : 0) |
 		(need_resched() ? TRACE_FLAG_NEED_RESCHED : 0);
 }
+EXPORT_SYMBOL_GPL(tracing_generic_entry_update);
 
 struct ring_buffer_event *trace_buffer_lock_reserve(struct trace_array *tr,
 						    int type,
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
 
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 936c621..f32dc9d 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -624,9 +624,6 @@ static int filter_add_subsystem_pred(struct filter_parse_state *ps,
 		return -ENOSPC;
 	}
 
-	filter->preds[filter->n_preds] = pred;
-	filter->n_preds++;
-
 	list_for_each_entry(call, &ftrace_events, list) {
 
 		if (!call->define_fields)
@@ -643,6 +640,9 @@ static int filter_add_subsystem_pred(struct filter_parse_state *ps,
 		}
 		replace_filter_string(call->filter, filter_string);
 	}
+
+	filter->preds[filter->n_preds] = pred;
+	filter->n_preds++;
 out:
 	return err;
 }
@@ -1029,12 +1029,17 @@ static int replace_preds(struct event_subsystem *system,
 
 		if (elt->op == OP_AND || elt->op == OP_OR) {
 			pred = create_logical_pred(elt->op);
+			if (!pred)
+				return -ENOMEM;
 			if (call) {
 				err = filter_add_pred(ps, call, pred);
 				filter_free_pred(pred);
-			} else
+			} else {
 				err = filter_add_subsystem_pred(ps, system,
 							pred, filter_string);
+				if (err)
+					filter_free_pred(pred);
+			}
 			if (err)
 				return err;
 
@@ -1048,12 +1053,17 @@ static int replace_preds(struct event_subsystem *system,
 		}
 
 		pred = create_pred(elt->op, operand1, operand2);
+		if (!pred)
+			return -ENOMEM;
 		if (call) {
 			err = filter_add_pred(ps, call, pred);
 			filter_free_pred(pred);
-		} else
+		} else {
 			err = filter_add_subsystem_pred(ps, system, pred,
 							filter_string);
+			if (err)
+				filter_free_pred(pred);
+		}
 		if (err)
 			return err;
 
diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index d29baa2..911ba7f 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -393,7 +393,7 @@ while (<IN>) {
 	    $read_function = 0;
 	}
 	# print out any recorded offsets
-	update_funcs() if ($text_found);
+	update_funcs() if (defined($ref_func));
 
 	# reset all markers and arrays
 	$text_found = 0;
@@ -414,7 +414,10 @@ while (<IN>) {
 	    $offset = hex $1;
 	} else {
 	    # if we already have a function, and this is weak, skip it
-	    if (!defined($ref_func) && !defined($weak{$text})) {
+	    if (!defined($ref_func) && !defined($weak{$text}) &&
+		 # PPC64 can have symbols that start with .L and
+		 # gcc considers these special. Don't use them!
+		 $text !~ /^\.L/) {
 		$ref_func = $text;
 		$offset = hex $1;
 	    }
@@ -441,7 +444,7 @@ while (<IN>) {
 }
 
 # dump out anymore offsets that may have been found
-update_funcs() if ($text_found);
+update_funcs() if (defined($ref_func));
 
 # If we did not find any mcount callers, we are done (do nothing).
 if (!$opened) {
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
