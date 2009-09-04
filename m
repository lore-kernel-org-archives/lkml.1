Return-Path: <linux-kernel-owner+w=401wt.eu-S934456AbZIEABk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934456AbZIEABk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:01:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934264AbZIEABi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:01:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:33610 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934200AbZIEABZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:01:25 -0400
Message-Id: <20090905000126.181639329@goodmis.org>
References: <20090904235527.520961911@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 04 Sep 2009 19:55:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 14/18] tracing: pass around ring buffer instead of tracer
Content-Disposition: inline; filename=0014-tracing-pass-around-ring-buffer-instead-of-tracer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The latency tracers (irqsoff and wakeup) can swap trace buffers
on the fly. If an event is happening and has reserved data on one of
the buffers, and the latency tracer swaps the global buffer with the
max buffer, the result is that the event may commit the data to the
wrong buffer.

This patch changes the API to the trace recording to be recieve the
buffer that was used to reserve a commit. Then this buffer can be passed
in to the commit.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h         |   15 +++--
 include/trace/ftrace.h               |   15 +++--
 kernel/trace/blktrace.c              |   12 ++-
 kernel/trace/trace.c                 |  117 +++++++++++++++++++--------------
 kernel/trace/trace.h                 |   17 +++--
 kernel/trace/trace_boot.c            |   12 ++-
 kernel/trace/trace_events.c          |    6 +-
 kernel/trace/trace_functions_graph.c |   14 ++--
 kernel/trace/trace_mmiotrace.c       |   10 ++-
 kernel/trace/trace_power.c           |   18 ++++--
 kernel/trace/trace_sched_switch.c    |   18 +++--
 kernel/trace/trace_syscalls.c        |   18 +++--
 12 files changed, 163 insertions(+), 109 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 7554804..23f7179 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -93,13 +93,17 @@ void tracing_generic_entry_update(struct trace_entry *entry,
 				  unsigned long flags,
 				  int pc);
 struct ring_buffer_event *
-trace_current_buffer_lock_reserve(int type, unsigned long len,
+trace_current_buffer_lock_reserve(struct ring_buffer **current_buffer,
+				  int type, unsigned long len,
 				  unsigned long flags, int pc);
-void trace_current_buffer_unlock_commit(struct ring_buffer_event *event,
+void trace_current_buffer_unlock_commit(struct ring_buffer *buffer,
+					struct ring_buffer_event *event,
 					unsigned long flags, int pc);
-void trace_nowake_buffer_unlock_commit(struct ring_buffer_event *event,
+void trace_nowake_buffer_unlock_commit(struct ring_buffer *buffer,
+				       struct ring_buffer_event *event,
 					unsigned long flags, int pc);
-void trace_current_buffer_discard_commit(struct ring_buffer_event *event);
+void trace_current_buffer_discard_commit(struct ring_buffer *buffer,
+					 struct ring_buffer_event *event);
 
 void tracing_record_cmdline(struct task_struct *tsk);
 
@@ -135,7 +139,8 @@ struct ftrace_event_call {
 
 extern void destroy_preds(struct ftrace_event_call *call);
 extern int filter_match_preds(struct ftrace_event_call *call, void *rec);
-extern int filter_current_check_discard(struct ftrace_event_call *call,
+extern int filter_current_check_discard(struct ring_buffer *buffer,
+					struct ftrace_event_call *call,
 					void *rec,
 					struct ring_buffer_event *event);
 
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index bfbc842..308bafd 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -460,13 +460,15 @@ static void ftrace_profile_disable_##call(struct ftrace_event_call *event_call)\
  * {
  *	struct ring_buffer_event *event;
  *	struct ftrace_raw_<call> *entry; <-- defined in stage 1
+ *	struct ring_buffer *buffer;
  *	unsigned long irq_flags;
  *	int pc;
  *
  *	local_save_flags(irq_flags);
  *	pc = preempt_count();
  *
- *	event = trace_current_buffer_lock_reserve(event_<call>.id,
+ *	event = trace_current_buffer_lock_reserve(&buffer,
+ *				  event_<call>.id,
  *				  sizeof(struct ftrace_raw_<call>),
  *				  irq_flags, pc);
  *	if (!event)
@@ -476,7 +478,7 @@ static void ftrace_profile_disable_##call(struct ftrace_event_call *event_call)\
  *	<assign>;  <-- Here we assign the entries by the __field and
  *			__array macros.
  *
- *	trace_current_buffer_unlock_commit(event, irq_flags, pc);
+ *	trace_current_buffer_unlock_commit(buffer, event, irq_flags, pc);
  * }
  *
  * static int ftrace_raw_reg_event_<call>(void)
@@ -568,6 +570,7 @@ static void ftrace_raw_event_##call(proto)				\
 	struct ftrace_event_call *event_call = &event_##call;		\
 	struct ring_buffer_event *event;				\
 	struct ftrace_raw_##call *entry;				\
+	struct ring_buffer *buffer;					\
 	unsigned long irq_flags;					\
 	int __data_size;						\
 	int pc;								\
@@ -577,7 +580,8 @@ static void ftrace_raw_event_##call(proto)				\
 									\
 	__data_size = ftrace_get_offsets_##call(&__data_offsets, args); \
 									\
-	event = trace_current_buffer_lock_reserve(event_##call.id,	\
+	event = trace_current_buffer_lock_reserve(&buffer,		\
+				 event_##call.id,			\
 				 sizeof(*entry) + __data_size,		\
 				 irq_flags, pc);			\
 	if (!event)							\
@@ -589,8 +593,9 @@ static void ftrace_raw_event_##call(proto)				\
 									\
 	{ assign; }							\
 									\
-	if (!filter_current_check_discard(event_call, entry, event))	\
-		trace_nowake_buffer_unlock_commit(event, irq_flags, pc); \
+	if (!filter_current_check_discard(buffer, event_call, entry, event)) \
+		trace_nowake_buffer_unlock_commit(buffer,		\
+						  event, irq_flags, pc); \
 }									\
 									\
 static int ftrace_raw_reg_event_##call(void *ptr)			\
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 1090b0a..243bafc 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -65,13 +65,15 @@ static void trace_note(struct blk_trace *bt, pid_t pid, int action,
 {
 	struct blk_io_trace *t;
 	struct ring_buffer_event *event = NULL;
+	struct ring_buffer *buffer = NULL;
 	int pc = 0;
 	int cpu = smp_processor_id();
 	bool blk_tracer = blk_tracer_enabled;
 
 	if (blk_tracer) {
+		buffer = blk_tr->buffer;
 		pc = preempt_count();
-		event = trace_buffer_lock_reserve(blk_tr, TRACE_BLK,
+		event = trace_buffer_lock_reserve(buffer, TRACE_BLK,
 						  sizeof(*t) + len,
 						  0, pc);
 		if (!event)
@@ -96,7 +98,7 @@ record_it:
 		memcpy((void *) t + sizeof(*t), data, len);
 
 		if (blk_tracer)
-			trace_buffer_unlock_commit(blk_tr, event, 0, pc);
+			trace_buffer_unlock_commit(buffer, event, 0, pc);
 	}
 }
 
@@ -179,6 +181,7 @@ static void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
 {
 	struct task_struct *tsk = current;
 	struct ring_buffer_event *event = NULL;
+	struct ring_buffer *buffer = NULL;
 	struct blk_io_trace *t;
 	unsigned long flags = 0;
 	unsigned long *sequence;
@@ -204,8 +207,9 @@ static void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
 	if (blk_tracer) {
 		tracing_record_cmdline(current);
 
+		buffer = blk_tr->buffer;
 		pc = preempt_count();
-		event = trace_buffer_lock_reserve(blk_tr, TRACE_BLK,
+		event = trace_buffer_lock_reserve(buffer, TRACE_BLK,
 						  sizeof(*t) + pdu_len,
 						  0, pc);
 		if (!event)
@@ -252,7 +256,7 @@ record_it:
 			memcpy((void *) t + sizeof(*t), pdu_data, pdu_len);
 
 		if (blk_tracer) {
-			trace_buffer_unlock_commit(blk_tr, event, 0, pc);
+			trace_buffer_unlock_commit(buffer, event, 0, pc);
 			return;
 		}
 	}
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 0418e26..0c61836 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -169,10 +169,11 @@ static struct trace_array	global_trace;
 
 static DEFINE_PER_CPU(struct trace_array_cpu, global_trace_cpu);
 
-int filter_current_check_discard(struct ftrace_event_call *call, void *rec,
+int filter_current_check_discard(struct ring_buffer *buffer,
+				 struct ftrace_event_call *call, void *rec,
 				 struct ring_buffer_event *event)
 {
-	return filter_check_discard(call, rec, global_trace.buffer, event);
+	return filter_check_discard(call, rec, buffer, event);
 }
 EXPORT_SYMBOL_GPL(filter_current_check_discard);
 
@@ -887,14 +888,15 @@ tracing_generic_entry_update(struct trace_entry *entry, unsigned long flags,
 }
 EXPORT_SYMBOL_GPL(tracing_generic_entry_update);
 
-struct ring_buffer_event *trace_buffer_lock_reserve(struct trace_array *tr,
-						    int type,
-						    unsigned long len,
-						    unsigned long flags, int pc)
+struct ring_buffer_event *
+trace_buffer_lock_reserve(struct ring_buffer *buffer,
+			  int type,
+			  unsigned long len,
+			  unsigned long flags, int pc)
 {
 	struct ring_buffer_event *event;
 
-	event = ring_buffer_lock_reserve(tr->buffer, len);
+	event = ring_buffer_lock_reserve(buffer, len);
 	if (event != NULL) {
 		struct trace_entry *ent = ring_buffer_event_data(event);
 
@@ -905,53 +907,59 @@ struct ring_buffer_event *trace_buffer_lock_reserve(struct trace_array *tr,
 	return event;
 }
 
-static inline void __trace_buffer_unlock_commit(struct trace_array *tr,
-					struct ring_buffer_event *event,
-					unsigned long flags, int pc,
-					int wake)
+static inline void
+__trace_buffer_unlock_commit(struct ring_buffer *buffer,
+			     struct ring_buffer_event *event,
+			     unsigned long flags, int pc,
+			     int wake)
 {
-	ring_buffer_unlock_commit(tr->buffer, event);
+	ring_buffer_unlock_commit(buffer, event);
 
-	ftrace_trace_stack(tr, flags, 6, pc);
-	ftrace_trace_userstack(tr, flags, pc);
+	ftrace_trace_stack(buffer, flags, 6, pc);
+	ftrace_trace_userstack(buffer, flags, pc);
 
 	if (wake)
 		trace_wake_up();
 }
 
-void trace_buffer_unlock_commit(struct trace_array *tr,
-					struct ring_buffer_event *event,
-					unsigned long flags, int pc)
+void trace_buffer_unlock_commit(struct ring_buffer *buffer,
+				struct ring_buffer_event *event,
+				unsigned long flags, int pc)
 {
-	__trace_buffer_unlock_commit(tr, event, flags, pc, 1);
+	__trace_buffer_unlock_commit(buffer, event, flags, pc, 1);
 }
 
 struct ring_buffer_event *
-trace_current_buffer_lock_reserve(int type, unsigned long len,
+trace_current_buffer_lock_reserve(struct ring_buffer **current_rb,
+				  int type, unsigned long len,
 				  unsigned long flags, int pc)
 {
-	return trace_buffer_lock_reserve(&global_trace,
+	*current_rb = global_trace.buffer;
+	return trace_buffer_lock_reserve(*current_rb,
 					 type, len, flags, pc);
 }
 EXPORT_SYMBOL_GPL(trace_current_buffer_lock_reserve);
 
-void trace_current_buffer_unlock_commit(struct ring_buffer_event *event,
+void trace_current_buffer_unlock_commit(struct ring_buffer *buffer,
+					struct ring_buffer_event *event,
 					unsigned long flags, int pc)
 {
-	__trace_buffer_unlock_commit(&global_trace, event, flags, pc, 1);
+	__trace_buffer_unlock_commit(buffer, event, flags, pc, 1);
 }
 EXPORT_SYMBOL_GPL(trace_current_buffer_unlock_commit);
 
-void trace_nowake_buffer_unlock_commit(struct ring_buffer_event *event,
-					unsigned long flags, int pc)
+void trace_nowake_buffer_unlock_commit(struct ring_buffer *buffer,
+				       struct ring_buffer_event *event,
+				       unsigned long flags, int pc)
 {
-	__trace_buffer_unlock_commit(&global_trace, event, flags, pc, 0);
+	__trace_buffer_unlock_commit(buffer, event, flags, pc, 0);
 }
 EXPORT_SYMBOL_GPL(trace_nowake_buffer_unlock_commit);
 
-void trace_current_buffer_discard_commit(struct ring_buffer_event *event)
+void trace_current_buffer_discard_commit(struct ring_buffer *buffer,
+					 struct ring_buffer_event *event)
 {
-	ring_buffer_discard_commit(global_trace.buffer, event);
+	ring_buffer_discard_commit(buffer, event);
 }
 EXPORT_SYMBOL_GPL(trace_current_buffer_discard_commit);
 
@@ -961,6 +969,7 @@ trace_function(struct trace_array *tr,
 	       int pc)
 {
 	struct ftrace_event_call *call = &event_function;
+	struct ring_buffer *buffer = tr->buffer;
 	struct ring_buffer_event *event;
 	struct ftrace_entry *entry;
 
@@ -968,7 +977,7 @@ trace_function(struct trace_array *tr,
 	if (unlikely(local_read(&__get_cpu_var(ftrace_cpu_disabled))))
 		return;
 
-	event = trace_buffer_lock_reserve(tr, TRACE_FN, sizeof(*entry),
+	event = trace_buffer_lock_reserve(buffer, TRACE_FN, sizeof(*entry),
 					  flags, pc);
 	if (!event)
 		return;
@@ -976,8 +985,8 @@ trace_function(struct trace_array *tr,
 	entry->ip			= ip;
 	entry->parent_ip		= parent_ip;
 
-	if (!filter_check_discard(call, entry, tr->buffer, event))
-		ring_buffer_unlock_commit(tr->buffer, event);
+	if (!filter_check_discard(call, entry, buffer, event))
+		ring_buffer_unlock_commit(buffer, event);
 }
 
 void
@@ -990,7 +999,7 @@ ftrace(struct trace_array *tr, struct trace_array_cpu *data,
 }
 
 #ifdef CONFIG_STACKTRACE
-static void __ftrace_trace_stack(struct trace_array *tr,
+static void __ftrace_trace_stack(struct ring_buffer *buffer,
 				 unsigned long flags,
 				 int skip, int pc)
 {
@@ -999,7 +1008,7 @@ static void __ftrace_trace_stack(struct trace_array *tr,
 	struct stack_entry *entry;
 	struct stack_trace trace;
 
-	event = trace_buffer_lock_reserve(tr, TRACE_STACK,
+	event = trace_buffer_lock_reserve(buffer, TRACE_STACK,
 					  sizeof(*entry), flags, pc);
 	if (!event)
 		return;
@@ -1012,26 +1021,27 @@ static void __ftrace_trace_stack(struct trace_array *tr,
 	trace.entries		= entry->caller;
 
 	save_stack_trace(&trace);
-	if (!filter_check_discard(call, entry, tr->buffer, event))
-		ring_buffer_unlock_commit(tr->buffer, event);
+	if (!filter_check_discard(call, entry, buffer, event))
+		ring_buffer_unlock_commit(buffer, event);
 }
 
-void ftrace_trace_stack(struct trace_array *tr, unsigned long flags, int skip,
-			int pc)
+void ftrace_trace_stack(struct ring_buffer *buffer, unsigned long flags,
+			int skip, int pc)
 {
 	if (!(trace_flags & TRACE_ITER_STACKTRACE))
 		return;
 
-	__ftrace_trace_stack(tr, flags, skip, pc);
+	__ftrace_trace_stack(buffer, flags, skip, pc);
 }
 
 void __trace_stack(struct trace_array *tr, unsigned long flags, int skip,
 		   int pc)
 {
-	__ftrace_trace_stack(tr, flags, skip, pc);
+	__ftrace_trace_stack(tr->buffer, flags, skip, pc);
 }
 
-void ftrace_trace_userstack(struct trace_array *tr, unsigned long flags, int pc)
+void
+ftrace_trace_userstack(struct ring_buffer *buffer, unsigned long flags, int pc)
 {
 	struct ftrace_event_call *call = &event_user_stack;
 	struct ring_buffer_event *event;
@@ -1041,7 +1051,7 @@ void ftrace_trace_userstack(struct trace_array *tr, unsigned long flags, int pc)
 	if (!(trace_flags & TRACE_ITER_USERSTACKTRACE))
 		return;
 
-	event = trace_buffer_lock_reserve(tr, TRACE_USER_STACK,
+	event = trace_buffer_lock_reserve(buffer, TRACE_USER_STACK,
 					  sizeof(*entry), flags, pc);
 	if (!event)
 		return;
@@ -1055,8 +1065,8 @@ void ftrace_trace_userstack(struct trace_array *tr, unsigned long flags, int pc)
 	trace.entries		= entry->caller;
 
 	save_stack_trace_user(&trace);
-	if (!filter_check_discard(call, entry, tr->buffer, event))
-		ring_buffer_unlock_commit(tr->buffer, event);
+	if (!filter_check_discard(call, entry, buffer, event))
+		ring_buffer_unlock_commit(buffer, event);
 }
 
 #ifdef UNUSED
@@ -1075,9 +1085,10 @@ ftrace_trace_special(void *__tr,
 {
 	struct ring_buffer_event *event;
 	struct trace_array *tr = __tr;
+	struct ring_buffer *buffer = tr->buffer;
 	struct special_entry *entry;
 
-	event = trace_buffer_lock_reserve(tr, TRACE_SPECIAL,
+	event = trace_buffer_lock_reserve(buffer, TRACE_SPECIAL,
 					  sizeof(*entry), 0, pc);
 	if (!event)
 		return;
@@ -1085,7 +1096,7 @@ ftrace_trace_special(void *__tr,
 	entry->arg1			= arg1;
 	entry->arg2			= arg2;
 	entry->arg3			= arg3;
-	trace_buffer_unlock_commit(tr, event, 0, pc);
+	trace_buffer_unlock_commit(buffer, event, 0, pc);
 }
 
 void
@@ -1131,6 +1142,7 @@ int trace_vbprintk(unsigned long ip, const char *fmt, va_list args)
 
 	struct ftrace_event_call *call = &event_bprint;
 	struct ring_buffer_event *event;
+	struct ring_buffer *buffer;
 	struct trace_array *tr = &global_trace;
 	struct trace_array_cpu *data;
 	struct bprint_entry *entry;
@@ -1163,7 +1175,9 @@ int trace_vbprintk(unsigned long ip, const char *fmt, va_list args)
 		goto out_unlock;
 
 	size = sizeof(*entry) + sizeof(u32) * len;
-	event = trace_buffer_lock_reserve(tr, TRACE_BPRINT, size, flags, pc);
+	buffer = tr->buffer;
+	event = trace_buffer_lock_reserve(buffer, TRACE_BPRINT, size,
+					  flags, pc);
 	if (!event)
 		goto out_unlock;
 	entry = ring_buffer_event_data(event);
@@ -1171,8 +1185,8 @@ int trace_vbprintk(unsigned long ip, const char *fmt, va_list args)
 	entry->fmt			= fmt;
 
 	memcpy(entry->buf, trace_buf, sizeof(u32) * len);
-	if (!filter_check_discard(call, entry, tr->buffer, event))
-		ring_buffer_unlock_commit(tr->buffer, event);
+	if (!filter_check_discard(call, entry, buffer, event))
+		ring_buffer_unlock_commit(buffer, event);
 
 out_unlock:
 	__raw_spin_unlock(&trace_buf_lock);
@@ -1194,6 +1208,7 @@ int trace_vprintk(unsigned long ip, const char *fmt, va_list args)
 
 	struct ftrace_event_call *call = &event_print;
 	struct ring_buffer_event *event;
+	struct ring_buffer *buffer;
 	struct trace_array *tr = &global_trace;
 	struct trace_array_cpu *data;
 	int cpu, len = 0, size, pc;
@@ -1222,7 +1237,9 @@ int trace_vprintk(unsigned long ip, const char *fmt, va_list args)
 	trace_buf[len] = 0;
 
 	size = sizeof(*entry) + len + 1;
-	event = trace_buffer_lock_reserve(tr, TRACE_PRINT, size, irq_flags, pc);
+	buffer = tr->buffer;
+	event = trace_buffer_lock_reserve(buffer, TRACE_PRINT, size,
+					  irq_flags, pc);
 	if (!event)
 		goto out_unlock;
 	entry = ring_buffer_event_data(event);
@@ -1230,8 +1247,8 @@ int trace_vprintk(unsigned long ip, const char *fmt, va_list args)
 
 	memcpy(&entry->buf, trace_buf, len);
 	entry->buf[len] = 0;
-	if (!filter_check_discard(call, entry, tr->buffer, event))
-		ring_buffer_unlock_commit(tr->buffer, event);
+	if (!filter_check_discard(call, entry, buffer, event))
+		ring_buffer_unlock_commit(buffer, event);
 
  out_unlock:
 	__raw_spin_unlock(&trace_buf_lock);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index ca070de..4d30414 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -415,12 +415,13 @@ void init_tracer_sysprof_debugfs(struct dentry *d_tracer);
 
 struct ring_buffer_event;
 
-struct ring_buffer_event *trace_buffer_lock_reserve(struct trace_array *tr,
-						    int type,
-						    unsigned long len,
-						    unsigned long flags,
-						    int pc);
-void trace_buffer_unlock_commit(struct trace_array *tr,
+struct ring_buffer_event *
+trace_buffer_lock_reserve(struct ring_buffer *buffer,
+			  int type,
+			  unsigned long len,
+			  unsigned long flags,
+			  int pc);
+void trace_buffer_unlock_commit(struct ring_buffer *buffer,
 				struct ring_buffer_event *event,
 				unsigned long flags, int pc);
 
@@ -481,10 +482,10 @@ void update_max_tr_single(struct trace_array *tr,
 #endif /* CONFIG_TRACER_MAX_TRACE */
 
 #ifdef CONFIG_STACKTRACE
-void ftrace_trace_stack(struct trace_array *tr, unsigned long flags,
+void ftrace_trace_stack(struct ring_buffer *buffer, unsigned long flags,
 			int skip, int pc);
 
-void ftrace_trace_userstack(struct trace_array *tr, unsigned long flags,
+void ftrace_trace_userstack(struct ring_buffer *buffer, unsigned long flags,
 			    int pc);
 
 void __trace_stack(struct trace_array *tr, unsigned long flags, int skip,
diff --git a/kernel/trace/trace_boot.c b/kernel/trace/trace_boot.c
index 8631393..19bfc75 100644
--- a/kernel/trace/trace_boot.c
+++ b/kernel/trace/trace_boot.c
@@ -130,6 +130,7 @@ struct tracer boot_tracer __read_mostly =
 void trace_boot_call(struct boot_trace_call *bt, initcall_t fn)
 {
 	struct ring_buffer_event *event;
+	struct ring_buffer *buffer;
 	struct trace_boot_call *entry;
 	struct trace_array *tr = boot_trace;
 
@@ -142,13 +143,14 @@ void trace_boot_call(struct boot_trace_call *bt, initcall_t fn)
 	sprint_symbol(bt->func, (unsigned long)fn);
 	preempt_disable();
 
-	event = trace_buffer_lock_reserve(tr, TRACE_BOOT_CALL,
+	buffer = tr->buffer;
+	event = trace_buffer_lock_reserve(buffer, TRACE_BOOT_CALL,
 					  sizeof(*entry), 0, 0);
 	if (!event)
 		goto out;
 	entry	= ring_buffer_event_data(event);
 	entry->boot_call = *bt;
-	trace_buffer_unlock_commit(tr, event, 0, 0);
+	trace_buffer_unlock_commit(buffer, event, 0, 0);
  out:
 	preempt_enable();
 }
@@ -156,6 +158,7 @@ void trace_boot_call(struct boot_trace_call *bt, initcall_t fn)
 void trace_boot_ret(struct boot_trace_ret *bt, initcall_t fn)
 {
 	struct ring_buffer_event *event;
+	struct ring_buffer *buffer;
 	struct trace_boot_ret *entry;
 	struct trace_array *tr = boot_trace;
 
@@ -165,13 +168,14 @@ void trace_boot_ret(struct boot_trace_ret *bt, initcall_t fn)
 	sprint_symbol(bt->func, (unsigned long)fn);
 	preempt_disable();
 
-	event = trace_buffer_lock_reserve(tr, TRACE_BOOT_RET,
+	buffer = tr->buffer;
+	event = trace_buffer_lock_reserve(buffer, TRACE_BOOT_RET,
 					  sizeof(*entry), 0, 0);
 	if (!event)
 		goto out;
 	entry	= ring_buffer_event_data(event);
 	entry->boot_ret = *bt;
-	trace_buffer_unlock_commit(tr, event, 0, 0);
+	trace_buffer_unlock_commit(buffer, event, 0, 0);
  out:
 	preempt_enable();
 }
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index d33bcde..78b1ed2 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1438,6 +1438,7 @@ static void
 function_test_events_call(unsigned long ip, unsigned long parent_ip)
 {
 	struct ring_buffer_event *event;
+	struct ring_buffer *buffer;
 	struct ftrace_entry *entry;
 	unsigned long flags;
 	long disabled;
@@ -1455,7 +1456,8 @@ function_test_events_call(unsigned long ip, unsigned long parent_ip)
 
 	local_save_flags(flags);
 
-	event = trace_current_buffer_lock_reserve(TRACE_FN, sizeof(*entry),
+	event = trace_current_buffer_lock_reserve(&buffer,
+						  TRACE_FN, sizeof(*entry),
 						  flags, pc);
 	if (!event)
 		goto out;
@@ -1463,7 +1465,7 @@ function_test_events_call(unsigned long ip, unsigned long parent_ip)
 	entry->ip			= ip;
 	entry->parent_ip		= parent_ip;
 
-	trace_nowake_buffer_unlock_commit(event, flags, pc);
+	trace_nowake_buffer_unlock_commit(buffer, event, flags, pc);
 
  out:
 	atomic_dec(&per_cpu(test_event_disable, cpu));
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 3f4a251..b3749a2 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -173,19 +173,20 @@ static int __trace_graph_entry(struct trace_array *tr,
 {
 	struct ftrace_event_call *call = &event_funcgraph_entry;
 	struct ring_buffer_event *event;
+	struct ring_buffer *buffer = tr->buffer;
 	struct ftrace_graph_ent_entry *entry;
 
 	if (unlikely(local_read(&__get_cpu_var(ftrace_cpu_disabled))))
 		return 0;
 
-	event = trace_buffer_lock_reserve(tr, TRACE_GRAPH_ENT,
+	event = trace_buffer_lock_reserve(buffer, TRACE_GRAPH_ENT,
 					  sizeof(*entry), flags, pc);
 	if (!event)
 		return 0;
 	entry	= ring_buffer_event_data(event);
 	entry->graph_ent			= *trace;
-	if (!filter_current_check_discard(call, entry, event))
-		ring_buffer_unlock_commit(tr->buffer, event);
+	if (!filter_current_check_discard(buffer, call, entry, event))
+		ring_buffer_unlock_commit(buffer, event);
 
 	return 1;
 }
@@ -236,19 +237,20 @@ static void __trace_graph_return(struct trace_array *tr,
 {
 	struct ftrace_event_call *call = &event_funcgraph_exit;
 	struct ring_buffer_event *event;
+	struct ring_buffer *buffer = tr->buffer;
 	struct ftrace_graph_ret_entry *entry;
 
 	if (unlikely(local_read(&__get_cpu_var(ftrace_cpu_disabled))))
 		return;
 
-	event = trace_buffer_lock_reserve(tr, TRACE_GRAPH_RET,
+	event = trace_buffer_lock_reserve(buffer, TRACE_GRAPH_RET,
 					  sizeof(*entry), flags, pc);
 	if (!event)
 		return;
 	entry	= ring_buffer_event_data(event);
 	entry->ret				= *trace;
-	if (!filter_current_check_discard(call, entry, event))
-		ring_buffer_unlock_commit(tr->buffer, event);
+	if (!filter_current_check_discard(buffer, call, entry, event))
+		ring_buffer_unlock_commit(buffer, event);
 }
 
 void trace_graph_return(struct ftrace_graph_ret *trace)
diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
index d53b45e..c4c9bbd 100644
--- a/kernel/trace/trace_mmiotrace.c
+++ b/kernel/trace/trace_mmiotrace.c
@@ -307,11 +307,12 @@ static void __trace_mmiotrace_rw(struct trace_array *tr,
 				struct trace_array_cpu *data,
 				struct mmiotrace_rw *rw)
 {
+	struct ring_buffer *buffer = tr->buffer;
 	struct ring_buffer_event *event;
 	struct trace_mmiotrace_rw *entry;
 	int pc = preempt_count();
 
-	event = trace_buffer_lock_reserve(tr, TRACE_MMIO_RW,
+	event = trace_buffer_lock_reserve(buffer, TRACE_MMIO_RW,
 					  sizeof(*entry), 0, pc);
 	if (!event) {
 		atomic_inc(&dropped_count);
@@ -319,7 +320,7 @@ static void __trace_mmiotrace_rw(struct trace_array *tr,
 	}
 	entry	= ring_buffer_event_data(event);
 	entry->rw			= *rw;
-	trace_buffer_unlock_commit(tr, event, 0, pc);
+	trace_buffer_unlock_commit(buffer, event, 0, pc);
 }
 
 void mmio_trace_rw(struct mmiotrace_rw *rw)
@@ -333,11 +334,12 @@ static void __trace_mmiotrace_map(struct trace_array *tr,
 				struct trace_array_cpu *data,
 				struct mmiotrace_map *map)
 {
+	struct ring_buffer *buffer = tr->buffer;
 	struct ring_buffer_event *event;
 	struct trace_mmiotrace_map *entry;
 	int pc = preempt_count();
 
-	event = trace_buffer_lock_reserve(tr, TRACE_MMIO_MAP,
+	event = trace_buffer_lock_reserve(buffer, TRACE_MMIO_MAP,
 					  sizeof(*entry), 0, pc);
 	if (!event) {
 		atomic_inc(&dropped_count);
@@ -345,7 +347,7 @@ static void __trace_mmiotrace_map(struct trace_array *tr,
 	}
 	entry	= ring_buffer_event_data(event);
 	entry->map			= *map;
-	trace_buffer_unlock_commit(tr, event, 0, pc);
+	trace_buffer_unlock_commit(buffer, event, 0, pc);
 }
 
 void mmio_trace_mapping(struct mmiotrace_map *map)
diff --git a/kernel/trace/trace_power.c b/kernel/trace/trace_power.c
index a5d5a4f..fe1a00f 100644
--- a/kernel/trace/trace_power.c
+++ b/kernel/trace/trace_power.c
@@ -38,6 +38,7 @@ static void probe_power_end(struct power_trace *it)
 {
 	struct ftrace_event_call *call = &event_power;
 	struct ring_buffer_event *event;
+	struct ring_buffer *buffer;
 	struct trace_power *entry;
 	struct trace_array_cpu *data;
 	struct trace_array *tr = power_trace;
@@ -45,18 +46,20 @@ static void probe_power_end(struct power_trace *it)
 	if (!trace_power_enabled)
 		return;
 
+	buffer = tr->buffer;
+
 	preempt_disable();
 	it->end = ktime_get();
 	data = tr->data[smp_processor_id()];
 
-	event = trace_buffer_lock_reserve(tr, TRACE_POWER,
+	event = trace_buffer_lock_reserve(buffer, TRACE_POWER,
 					  sizeof(*entry), 0, 0);
 	if (!event)
 		goto out;
 	entry	= ring_buffer_event_data(event);
 	entry->state_data = *it;
-	if (!filter_check_discard(call, entry, tr->buffer, event))
-		trace_buffer_unlock_commit(tr, event, 0, 0);
+	if (!filter_check_discard(call, entry, buffer, event))
+		trace_buffer_unlock_commit(buffer, event, 0, 0);
  out:
 	preempt_enable();
 }
@@ -66,6 +69,7 @@ static void probe_power_mark(struct power_trace *it, unsigned int type,
 {
 	struct ftrace_event_call *call = &event_power;
 	struct ring_buffer_event *event;
+	struct ring_buffer *buffer;
 	struct trace_power *entry;
 	struct trace_array_cpu *data;
 	struct trace_array *tr = power_trace;
@@ -73,6 +77,8 @@ static void probe_power_mark(struct power_trace *it, unsigned int type,
 	if (!trace_power_enabled)
 		return;
 
+	buffer = tr->buffer;
+
 	memset(it, 0, sizeof(struct power_trace));
 	it->state = level;
 	it->type = type;
@@ -81,14 +87,14 @@ static void probe_power_mark(struct power_trace *it, unsigned int type,
 	it->end = it->stamp;
 	data = tr->data[smp_processor_id()];
 
-	event = trace_buffer_lock_reserve(tr, TRACE_POWER,
+	event = trace_buffer_lock_reserve(buffer, TRACE_POWER,
 					  sizeof(*entry), 0, 0);
 	if (!event)
 		goto out;
 	entry	= ring_buffer_event_data(event);
 	entry->state_data = *it;
-	if (!filter_check_discard(call, entry, tr->buffer, event))
-		trace_buffer_unlock_commit(tr, event, 0, 0);
+	if (!filter_check_discard(call, entry, buffer, event))
+		trace_buffer_unlock_commit(buffer, event, 0, 0);
  out:
 	preempt_enable();
 }
diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
index e1285d7..5fca0f5 100644
--- a/kernel/trace/trace_sched_switch.c
+++ b/kernel/trace/trace_sched_switch.c
@@ -28,10 +28,11 @@ tracing_sched_switch_trace(struct trace_array *tr,
 			   unsigned long flags, int pc)
 {
 	struct ftrace_event_call *call = &event_context_switch;
+	struct ring_buffer *buffer = tr->buffer;
 	struct ring_buffer_event *event;
 	struct ctx_switch_entry *entry;
 
-	event = trace_buffer_lock_reserve(tr, TRACE_CTX,
+	event = trace_buffer_lock_reserve(buffer, TRACE_CTX,
 					  sizeof(*entry), flags, pc);
 	if (!event)
 		return;
@@ -44,8 +45,8 @@ tracing_sched_switch_trace(struct trace_array *tr,
 	entry->next_state		= next->state;
 	entry->next_cpu	= task_cpu(next);
 
-	if (!filter_check_discard(call, entry, tr->buffer, event))
-		trace_buffer_unlock_commit(tr, event, flags, pc);
+	if (!filter_check_discard(call, entry, buffer, event))
+		trace_buffer_unlock_commit(buffer, event, flags, pc);
 }
 
 static void
@@ -86,8 +87,9 @@ tracing_sched_wakeup_trace(struct trace_array *tr,
 	struct ftrace_event_call *call = &event_wakeup;
 	struct ring_buffer_event *event;
 	struct ctx_switch_entry *entry;
+	struct ring_buffer *buffer = tr->buffer;
 
-	event = trace_buffer_lock_reserve(tr, TRACE_WAKE,
+	event = trace_buffer_lock_reserve(buffer, TRACE_WAKE,
 					  sizeof(*entry), flags, pc);
 	if (!event)
 		return;
@@ -100,10 +102,10 @@ tracing_sched_wakeup_trace(struct trace_array *tr,
 	entry->next_state		= wakee->state;
 	entry->next_cpu			= task_cpu(wakee);
 
-	if (!filter_check_discard(call, entry, tr->buffer, event))
-		ring_buffer_unlock_commit(tr->buffer, event);
-	ftrace_trace_stack(tr, flags, 6, pc);
-	ftrace_trace_userstack(tr, flags, pc);
+	if (!filter_check_discard(call, entry, buffer, event))
+		ring_buffer_unlock_commit(buffer, event);
+	ftrace_trace_stack(tr->buffer, flags, 6, pc);
+	ftrace_trace_userstack(tr->buffer, flags, pc);
 }
 
 static void
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 4f5fae6..8712ce3 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -223,6 +223,7 @@ void ftrace_syscall_enter(struct pt_regs *regs, long id)
 	struct syscall_trace_enter *entry;
 	struct syscall_metadata *sys_data;
 	struct ring_buffer_event *event;
+	struct ring_buffer *buffer;
 	int size;
 	int syscall_nr;
 
@@ -238,8 +239,8 @@ void ftrace_syscall_enter(struct pt_regs *regs, long id)
 
 	size = sizeof(*entry) + sizeof(unsigned long) * sys_data->nb_args;
 
-	event = trace_current_buffer_lock_reserve(sys_data->enter_id, size,
-							0, 0);
+	event = trace_current_buffer_lock_reserve(&buffer, sys_data->enter_id,
+						  size, 0, 0);
 	if (!event)
 		return;
 
@@ -247,8 +248,9 @@ void ftrace_syscall_enter(struct pt_regs *regs, long id)
 	entry->nr = syscall_nr;
 	syscall_get_arguments(current, regs, 0, sys_data->nb_args, entry->args);
 
-	if (!filter_current_check_discard(sys_data->enter_event, entry, event))
-		trace_current_buffer_unlock_commit(event, 0, 0);
+	if (!filter_current_check_discard(buffer, sys_data->enter_event,
+					  entry, event))
+		trace_current_buffer_unlock_commit(buffer, event, 0, 0);
 }
 
 void ftrace_syscall_exit(struct pt_regs *regs, long ret)
@@ -256,6 +258,7 @@ void ftrace_syscall_exit(struct pt_regs *regs, long ret)
 	struct syscall_trace_exit *entry;
 	struct syscall_metadata *sys_data;
 	struct ring_buffer_event *event;
+	struct ring_buffer *buffer;
 	int syscall_nr;
 
 	syscall_nr = syscall_get_nr(current, regs);
@@ -268,7 +271,7 @@ void ftrace_syscall_exit(struct pt_regs *regs, long ret)
 	if (!sys_data)
 		return;
 
-	event = trace_current_buffer_lock_reserve(sys_data->exit_id,
+	event = trace_current_buffer_lock_reserve(&buffer, sys_data->exit_id,
 				sizeof(*entry), 0, 0);
 	if (!event)
 		return;
@@ -277,8 +280,9 @@ void ftrace_syscall_exit(struct pt_regs *regs, long ret)
 	entry->nr = syscall_nr;
 	entry->ret = syscall_get_return_value(current, regs);
 
-	if (!filter_current_check_discard(sys_data->exit_event, entry, event))
-		trace_current_buffer_unlock_commit(event, 0, 0);
+	if (!filter_current_check_discard(buffer, sys_data->exit_event,
+					  entry, event))
+		trace_current_buffer_unlock_commit(buffer, event, 0, 0);
 }
 
 int reg_event_syscall_enter(void *ptr)
-- 
1.6.3.3

-- 
