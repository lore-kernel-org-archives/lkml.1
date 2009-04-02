Return-Path: <linux-kernel-owner+w=401wt.eu-S934618AbZDBFgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934618AbZDBFgS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 01:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760968AbZDBFf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 01:35:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:43394 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754111AbZDBFfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 01:35:25 -0400
Message-Id: <20090402053522.164795322@goodmis.org>
References: <20090402052721.013878388@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 02 Apr 2009 01:27:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Tom Zanussi <tzanussi@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/4] tracing/filters: add run-time field descriptions to TRACE_EVENT_FORMAT events
Content-Disposition: inline; filename=0001-tracing-filters-add-run-time-field-descriptions-to.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Zanussi <tzanussi@gmail.com>

This patch adds run-time field descriptions to all the event formats
exported using TRACE_EVENT_FORMAT.  It also hooks up all the tracers
that use them (i.e. the tracers in the 'ftrace subsystem') so they can
also have their output filtered by the event-filtering mechanism.

When I was testing this, there were a couple of things that fooled me
into thinking the filters weren't working, when actually they were -
I'll mention them here so others don't make the same mistakes (and file
bug reports. ;-)

One is that some of the tracers trace multiple events e.g. the
sched_switch tracer uses the context_switch and wakeup events, and if
you don't set filters on all of the traced events, the unfiltered output
from the events without filters on them can make it look like the
filtering as a whole isn't working properly, when actually it is doing
what it was asked to do - it just wasn't asked to do the right thing.

The other is that for the really high-volume tracers e.g. the function
tracer, the volume of filtered events can be so high that it pushes the
unfiltered events out of the ring buffer before they can be read so e.g.
cat'ing the trace file repeatedly shows either no output, or once in
awhile some output but that isn't there the next time you read the
trace, which isn't what you normally expect when reading the trace file.
If you read from the trace_pipe file though, you can catch them before
they disappear.

Changes from v1:

As suggested by Frederic Weisbecker:

- get rid of externs in functions
- added unlikely() to filter_check_discard()

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/kmemtrace.c            |    6 ++++
 kernel/trace/trace.c                |   25 +++++++++++++++
 kernel/trace/trace.h                |   20 ++++++++++++
 kernel/trace/trace_branch.c         |    3 ++
 kernel/trace/trace_event_types.h    |    6 ++-
 kernel/trace/trace_events.c         |    7 ++++
 kernel/trace/trace_events_filter.c  |    4 +-
 kernel/trace/trace_events_stage_2.h |    7 ----
 kernel/trace/trace_export.c         |   57 +++++++++++++++++++++++++++++++++--
 kernel/trace/trace_hw_branches.c    |    2 +
 kernel/trace/trace_power.c          |    4 ++
 11 files changed, 127 insertions(+), 14 deletions(-)

diff --git a/kernel/trace/kmemtrace.c b/kernel/trace/kmemtrace.c
index 5011f4d..65aba48 100644
--- a/kernel/trace/kmemtrace.c
+++ b/kernel/trace/kmemtrace.c
@@ -42,6 +42,7 @@ static inline void kmemtrace_alloc(enum kmemtrace_type_id type_id,
 				   gfp_t gfp_flags,
 				   int node)
 {
+	struct ftrace_event_call *call = &event_kmem_alloc;
 	struct trace_array *tr = kmemtrace_array;
 	struct kmemtrace_alloc_entry *entry;
 	struct ring_buffer_event *event;
@@ -62,6 +63,8 @@ static inline void kmemtrace_alloc(enum kmemtrace_type_id type_id,
 	entry->gfp_flags	= gfp_flags;
 	entry->node		= node;
 
+	filter_check_discard(call, entry, event);
+
 	ring_buffer_unlock_commit(tr->buffer, event);
 
 	trace_wake_up();
@@ -71,6 +74,7 @@ static inline void kmemtrace_free(enum kmemtrace_type_id type_id,
 				  unsigned long call_site,
 				  const void *ptr)
 {
+	struct ftrace_event_call *call = &event_kmem_free;
 	struct trace_array *tr = kmemtrace_array;
 	struct kmemtrace_free_entry *entry;
 	struct ring_buffer_event *event;
@@ -86,6 +90,8 @@ static inline void kmemtrace_free(enum kmemtrace_type_id type_id,
 	entry->call_site	= call_site;
 	entry->ptr		= ptr;
 
+	filter_check_discard(call, entry, event);
+
 	ring_buffer_unlock_commit(tr->buffer, event);
 
 	trace_wake_up();
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index a0174a4..9a10af0 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -907,6 +907,7 @@ trace_function(struct trace_array *tr,
 	       unsigned long ip, unsigned long parent_ip, unsigned long flags,
 	       int pc)
 {
+	struct ftrace_event_call *call = &event_function;
 	struct ring_buffer_event *event;
 	struct ftrace_entry *entry;
 
@@ -921,6 +922,9 @@ trace_function(struct trace_array *tr,
 	entry	= ring_buffer_event_data(event);
 	entry->ip			= ip;
 	entry->parent_ip		= parent_ip;
+
+	filter_check_discard(call, entry, event);
+
 	ring_buffer_unlock_commit(tr->buffer, event);
 }
 
@@ -930,6 +934,7 @@ static int __trace_graph_entry(struct trace_array *tr,
 				unsigned long flags,
 				int pc)
 {
+	struct ftrace_event_call *call = &event_funcgraph_entry;
 	struct ring_buffer_event *event;
 	struct ftrace_graph_ent_entry *entry;
 
@@ -942,6 +947,7 @@ static int __trace_graph_entry(struct trace_array *tr,
 		return 0;
 	entry	= ring_buffer_event_data(event);
 	entry->graph_ent			= *trace;
+	filter_check_discard(call, entry, event);
 	ring_buffer_unlock_commit(global_trace.buffer, event);
 
 	return 1;
@@ -952,6 +958,7 @@ static void __trace_graph_return(struct trace_array *tr,
 				unsigned long flags,
 				int pc)
 {
+	struct ftrace_event_call *call = &event_funcgraph_exit;
 	struct ring_buffer_event *event;
 	struct ftrace_graph_ret_entry *entry;
 
@@ -964,6 +971,7 @@ static void __trace_graph_return(struct trace_array *tr,
 		return;
 	entry	= ring_buffer_event_data(event);
 	entry->ret				= *trace;
+	filter_check_discard(call, entry, event);
 	ring_buffer_unlock_commit(global_trace.buffer, event);
 }
 #endif
@@ -982,6 +990,7 @@ static void __ftrace_trace_stack(struct trace_array *tr,
 				 int skip, int pc)
 {
 #ifdef CONFIG_STACKTRACE
+	struct ftrace_event_call *call = &event_kernel_stack;
 	struct ring_buffer_event *event;
 	struct stack_entry *entry;
 	struct stack_trace trace;
@@ -999,6 +1008,7 @@ static void __ftrace_trace_stack(struct trace_array *tr,
 	trace.entries		= entry->caller;
 
 	save_stack_trace(&trace);
+	filter_check_discard(call, entry, event);
 	ring_buffer_unlock_commit(tr->buffer, event);
 #endif
 }
@@ -1024,6 +1034,7 @@ static void ftrace_trace_userstack(struct trace_array *tr,
 				   unsigned long flags, int pc)
 {
 #ifdef CONFIG_STACKTRACE
+	struct ftrace_event_call *call = &event_user_stack;
 	struct ring_buffer_event *event;
 	struct userstack_entry *entry;
 	struct stack_trace trace;
@@ -1045,6 +1056,7 @@ static void ftrace_trace_userstack(struct trace_array *tr,
 	trace.entries		= entry->caller;
 
 	save_stack_trace_user(&trace);
+	filter_check_discard(call, entry, event);
 	ring_buffer_unlock_commit(tr->buffer, event);
 #endif
 }
@@ -1061,6 +1073,7 @@ ftrace_trace_special(void *__tr,
 		     unsigned long arg1, unsigned long arg2, unsigned long arg3,
 		     int pc)
 {
+	struct ftrace_event_call *call = &event_special;
 	struct ring_buffer_event *event;
 	struct trace_array *tr = __tr;
 	struct special_entry *entry;
@@ -1073,6 +1086,7 @@ ftrace_trace_special(void *__tr,
 	entry->arg1			= arg1;
 	entry->arg2			= arg2;
 	entry->arg3			= arg3;
+	filter_check_discard(call, entry, event);
 	trace_buffer_unlock_commit(tr, event, 0, pc);
 }
 
@@ -1089,6 +1103,7 @@ tracing_sched_switch_trace(struct trace_array *tr,
 			   struct task_struct *next,
 			   unsigned long flags, int pc)
 {
+	struct ftrace_event_call *call = &event_context_switch;
 	struct ring_buffer_event *event;
 	struct ctx_switch_entry *entry;
 
@@ -1104,6 +1119,9 @@ tracing_sched_switch_trace(struct trace_array *tr,
 	entry->next_prio		= next->prio;
 	entry->next_state		= next->state;
 	entry->next_cpu	= task_cpu(next);
+
+	filter_check_discard(call, entry, event);
+
 	trace_buffer_unlock_commit(tr, event, flags, pc);
 }
 
@@ -1113,6 +1131,7 @@ tracing_sched_wakeup_trace(struct trace_array *tr,
 			   struct task_struct *curr,
 			   unsigned long flags, int pc)
 {
+	struct ftrace_event_call *call = &event_wakeup;
 	struct ring_buffer_event *event;
 	struct ctx_switch_entry *entry;
 
@@ -1129,6 +1148,8 @@ tracing_sched_wakeup_trace(struct trace_array *tr,
 	entry->next_state		= wakee->state;
 	entry->next_cpu			= task_cpu(wakee);
 
+	filter_check_discard(call, entry, event);
+
 	ring_buffer_unlock_commit(tr->buffer, event);
 	ftrace_trace_stack(tr, flags, 6, pc);
 	ftrace_trace_userstack(tr, flags, pc);
@@ -1230,6 +1251,7 @@ int trace_vbprintk(unsigned long ip, const char *fmt, va_list args)
 		(raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
 	static u32 trace_buf[TRACE_BUF_SIZE];
 
+	struct ftrace_event_call *call = &event_bprint;
 	struct ring_buffer_event *event;
 	struct trace_array *tr = &global_trace;
 	struct trace_array_cpu *data;
@@ -1269,6 +1291,7 @@ int trace_vbprintk(unsigned long ip, const char *fmt, va_list args)
 	entry->fmt			= fmt;
 
 	memcpy(entry->buf, trace_buf, sizeof(u32) * len);
+	filter_check_discard(call, entry, event);
 	ring_buffer_unlock_commit(tr->buffer, event);
 
 out_unlock:
@@ -1288,6 +1311,7 @@ int trace_vprintk(unsigned long ip, const char *fmt, va_list args)
 	static raw_spinlock_t trace_buf_lock = __RAW_SPIN_LOCK_UNLOCKED;
 	static char trace_buf[TRACE_BUF_SIZE];
 
+	struct ftrace_event_call *call = &event_print;
 	struct ring_buffer_event *event;
 	struct trace_array *tr = &global_trace;
 	struct trace_array_cpu *data;
@@ -1323,6 +1347,7 @@ int trace_vprintk(unsigned long ip, const char *fmt, va_list args)
 
 	memcpy(&entry->buf, trace_buf, len);
 	entry->buf[len] = 0;
+	filter_check_discard(call, entry, event);
 	ring_buffer_unlock_commit(tr->buffer, event);
 
  out_unlock:
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index cbc168f..e1615d9 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -858,6 +858,21 @@ extern void filter_free_subsystem_preds(struct event_subsystem *system);
 extern int filter_add_subsystem_pred(struct event_subsystem *system,
 				     struct filter_pred *pred);
 
+static inline void
+filter_check_discard(struct ftrace_event_call *call, void *rec,
+		     struct ring_buffer_event *event)
+{
+	if (unlikely(call->preds) && !filter_match_preds(call, rec))
+		ring_buffer_event_discard(event);
+}
+
+#define __common_field(type, item)					\
+	ret = trace_define_field(event_call, #type, "common_" #item,	\
+				 offsetof(typeof(field.ent), item),	\
+				 sizeof(field.ent.item));		\
+	if (ret)							\
+		return ret;
+
 void event_trace_printk(unsigned long ip, const char *fmt, ...);
 extern struct ftrace_event_call __start_ftrace_events[];
 extern struct ftrace_event_call __stop_ftrace_events[];
@@ -889,4 +904,9 @@ do {									\
 		__trace_printk(ip, fmt, ##args);			\
 } while (0)
 
+#undef TRACE_EVENT_FORMAT
+#define TRACE_EVENT_FORMAT(call, proto, args, fmt, tstruct, tpfmt)	\
+	extern struct ftrace_event_call event_##call;
+#include "trace_event_types.h"
+
 #endif /* _LINUX_KERNEL_TRACE_H */
diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index ad8c22e..25e618a 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -30,6 +30,7 @@ static struct trace_array *branch_tracer;
 static void
 probe_likely_condition(struct ftrace_branch_data *f, int val, int expect)
 {
+	struct ftrace_event_call *call = &event_branch;
 	struct trace_array *tr = branch_tracer;
 	struct ring_buffer_event *event;
 	struct trace_branch *entry;
@@ -73,6 +74,8 @@ probe_likely_condition(struct ftrace_branch_data *f, int val, int expect)
 	entry->line = f->line;
 	entry->correct = val == expect;
 
+	filter_check_discard(call, entry, event);
+
 	ring_buffer_unlock_commit(tr->buffer, event);
 
  out:
diff --git a/kernel/trace/trace_event_types.h b/kernel/trace/trace_event_types.h
index fd78bee..95b147a 100644
--- a/kernel/trace/trace_event_types.h
+++ b/kernel/trace/trace_event_types.h
@@ -122,8 +122,10 @@ TRACE_EVENT_FORMAT(print, TRACE_PRINT, print_entry, ignore,
 TRACE_EVENT_FORMAT(branch, TRACE_BRANCH, trace_branch, ignore,
 	TRACE_STRUCT(
 		TRACE_FIELD(unsigned int, line, line)
-		TRACE_FIELD_SPECIAL(char func[TRACE_FUNC_SIZE+1], func, func)
-		TRACE_FIELD_SPECIAL(char file[TRACE_FUNC_SIZE+1], file, file)
+		TRACE_FIELD_SPECIAL(char func[TRACE_FUNC_SIZE+1], func,
+				    TRACE_FUNC_SIZE+1, func)
+		TRACE_FIELD_SPECIAL(char file[TRACE_FUNC_SIZE+1], file,
+				    TRACE_FUNC_SIZE+1, file)
 		TRACE_FIELD(char, correct, correct)
 	),
 	TP_RAW_FMT("%u:%s:%s (%u)")
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 64ec4d2..be9299a 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -680,6 +680,7 @@ static struct dentry *
 event_subsystem_dir(const char *name, struct dentry *d_events)
 {
 	struct event_subsystem *system;
+	struct dentry *entry;
 
 	/* First see if we did not already create this dir */
 	list_for_each_entry(system, &event_subsystems, list) {
@@ -708,6 +709,12 @@ event_subsystem_dir(const char *name, struct dentry *d_events)
 
 	system->preds = NULL;
 
+	entry = debugfs_create_file("filter", 0644, system->entry, system,
+				    &ftrace_subsystem_filter_fops);
+	if (!entry)
+		pr_warning("Could not create debugfs "
+			   "'%s/filter' entry\n", name);
+
 	return system->entry;
 }
 
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 026be41..470ad94 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -185,7 +185,7 @@ void filter_free_subsystem_preds(struct event_subsystem *system)
 	}
 
 	events_for_each(call) {
-		if (!call->name || !call->regfunc)
+		if (!call->define_fields)
 			continue;
 
 		if (!strcmp(call->system, system->name))
@@ -324,7 +324,7 @@ int filter_add_subsystem_pred(struct event_subsystem *system,
 	events_for_each(call) {
 		int err;
 
-		if (!call->name || !call->regfunc)
+		if (!call->define_fields)
 			continue;
 
 		if (strcmp(call->system, system->name))
diff --git a/kernel/trace/trace_events_stage_2.h b/kernel/trace/trace_events_stage_2.h
index 30743f7..1c94b87 100644
--- a/kernel/trace/trace_events_stage_2.h
+++ b/kernel/trace/trace_events_stage_2.h
@@ -146,13 +146,6 @@ ftrace_format_##call(struct trace_seq *s)				\
 	if (ret)							\
 		return ret;
 
-#define __common_field(type, item)					\
-	ret = trace_define_field(event_call, #type, "common_" #item,	\
-				 offsetof(typeof(field.ent), item),	\
-				 sizeof(field.ent.item));		\
-	if (ret)							\
-		return ret;
-
 #undef TRACE_EVENT
 #define TRACE_EVENT(call, proto, args, tstruct, func, print)		\
 int									\
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index 4d9952d..47989be 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -30,7 +30,7 @@
 
 
 #undef TRACE_FIELD_SPECIAL
-#define TRACE_FIELD_SPECIAL(type_item, item, cmd)			\
+#define TRACE_FIELD_SPECIAL(type_item, item, len, cmd)			\
 	ret = trace_seq_printf(s, "\tfield special:" #type_item ";\t"	\
 			       "offset:%u;\tsize:%u;\n",		\
 			       (unsigned int)offsetof(typeof(field), item), \
@@ -85,18 +85,69 @@ ftrace_format_##call(struct trace_seq *s)				\
 #define TRACE_ENTRY	entry
 
 #undef TRACE_FIELD_SPECIAL
-#define TRACE_FIELD_SPECIAL(type_item, item, cmd) \
+#define TRACE_FIELD_SPECIAL(type_item, item, len, cmd)	\
 	cmd;
 
 #undef TRACE_EVENT_FORMAT
 #define TRACE_EVENT_FORMAT(call, proto, args, fmt, tstruct, tpfmt)	\
+int ftrace_define_fields_##call(void);					\
+static int ftrace_raw_init_event_##call(void);				\
 									\
-static struct ftrace_event_call __used					\
+struct ftrace_event_call __used						\
 __attribute__((__aligned__(4)))						\
 __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.name			= #call,				\
 	.id			= proto,				\
 	.system			= __stringify(TRACE_SYSTEM),		\
+	.raw_init		= ftrace_raw_init_event_##call,		\
 	.show_format		= ftrace_format_##call,			\
+	.define_fields		= ftrace_define_fields_##call,		\
+};									\
+static int ftrace_raw_init_event_##call(void)				\
+{									\
+	INIT_LIST_HEAD(&event_##call.fields);				\
+	return 0;							\
+}									\
+
+#include "trace_event_types.h"
+
+#undef TRACE_FIELD
+#define TRACE_FIELD(type, item, assign)					\
+	ret = trace_define_field(event_call, #type, #item,		\
+				 offsetof(typeof(field), item),		\
+				 sizeof(field.item));			\
+	if (ret)							\
+		return ret;
+
+#undef TRACE_FIELD_SPECIAL
+#define TRACE_FIELD_SPECIAL(type, item, len, cmd)			\
+	ret = trace_define_field(event_call, #type "[" #len "]", #item,	\
+				 offsetof(typeof(field), item),		\
+				 sizeof(field.item));			\
+	if (ret)							\
+		return ret;
+
+#undef TRACE_FIELD_ZERO_CHAR
+#define TRACE_FIELD_ZERO_CHAR(item)
+
+#undef TRACE_EVENT_FORMAT
+#define TRACE_EVENT_FORMAT(call, proto, args, fmt, tstruct, tpfmt)	\
+int									\
+ftrace_define_fields_##call(void)					\
+{									\
+	struct ftrace_event_call *event_call = &event_##call;		\
+	struct args field;						\
+	int ret;							\
+									\
+	__common_field(unsigned char, type);				\
+	__common_field(unsigned char, flags);				\
+	__common_field(unsigned char, preempt_count);			\
+	__common_field(int, pid);					\
+	__common_field(int, tgid);					\
+									\
+	tstruct;							\
+									\
+	return ret;							\
 }
+
 #include "trace_event_types.h"
diff --git a/kernel/trace/trace_hw_branches.c b/kernel/trace/trace_hw_branches.c
index 7bfdf4c..e6b275b 100644
--- a/kernel/trace/trace_hw_branches.c
+++ b/kernel/trace/trace_hw_branches.c
@@ -168,6 +168,7 @@ static enum print_line_t bts_trace_print_line(struct trace_iterator *iter)
 
 void trace_hw_branch(u64 from, u64 to)
 {
+	struct ftrace_event_call *call = &event_hw_branch;
 	struct trace_array *tr = hw_branch_trace;
 	struct ring_buffer_event *event;
 	struct hw_branch_entry *entry;
@@ -194,6 +195,7 @@ void trace_hw_branch(u64 from, u64 to)
 	entry->ent.type = TRACE_HW_BRANCHES;
 	entry->from = from;
 	entry->to   = to;
+	filter_check_discard(call, entry, event);
 	trace_buffer_unlock_commit(tr, event, 0, 0);
 
  out:
diff --git a/kernel/trace/trace_power.c b/kernel/trace/trace_power.c
index bae791e..8ce7d7d 100644
--- a/kernel/trace/trace_power.c
+++ b/kernel/trace/trace_power.c
@@ -36,6 +36,7 @@ static void probe_power_start(struct power_trace *it, unsigned int type,
 
 static void probe_power_end(struct power_trace *it)
 {
+	struct ftrace_event_call *call = &event_power;
 	struct ring_buffer_event *event;
 	struct trace_power *entry;
 	struct trace_array_cpu *data;
@@ -54,6 +55,7 @@ static void probe_power_end(struct power_trace *it)
 		goto out;
 	entry	= ring_buffer_event_data(event);
 	entry->state_data = *it;
+	filter_check_discard(call, entry, event);
 	trace_buffer_unlock_commit(tr, event, 0, 0);
  out:
 	preempt_enable();
@@ -62,6 +64,7 @@ static void probe_power_end(struct power_trace *it)
 static void probe_power_mark(struct power_trace *it, unsigned int type,
 				unsigned int level)
 {
+	struct ftrace_event_call *call = &event_power;
 	struct ring_buffer_event *event;
 	struct trace_power *entry;
 	struct trace_array_cpu *data;
@@ -84,6 +87,7 @@ static void probe_power_mark(struct power_trace *it, unsigned int type,
 		goto out;
 	entry	= ring_buffer_event_data(event);
 	entry->state_data = *it;
+	filter_check_discard(call, entry, event);
 	trace_buffer_unlock_commit(tr, event, 0, 0);
  out:
 	preempt_enable();
-- 
1.6.2.1

-- 
