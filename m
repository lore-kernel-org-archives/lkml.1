Return-Path: <linux-kernel-owner+w=401wt.eu-S1751679AbYKLF4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679AbYKLF4v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 00:56:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751273AbYKLF4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 00:56:07 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:56014 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbYKLF4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 00:56:03 -0500
Message-Id: <20081112055600.657041406@goodmis.org>
References: <20081112055454.798779203@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 12 Nov 2008 00:54:56 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/2] tracing/fastboot: Use the ring-buffer timestamp for initcall entries
Content-Disposition: inline; filename=0002-tracing-fastboot-Use-the-ring-buffer-timestamp-for.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: Split the boot tracer entries in two parts: call and return

Now that we are using the sched tracer from the boot tracer, we want to use the
same timestamp than the ring-buffer to have consistent time captures between sched
events and initcall events.
So we get rid of the old time capture by the boot tracer and split the initcall events
in two parts: call and return. This way we have the ring buffer timestamp of both.

There is an example of a trace in attachment.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/trace/boot.h      |   31 ++++++++---
 init/main.c               |   32 ++++++------
 kernel/trace/trace.h      |   15 ++++--
 kernel/trace/trace_boot.c |  123 ++++++++++++++++++++++++++++++++++-----------
 4 files changed, 143 insertions(+), 58 deletions(-)

diff --git a/include/trace/boot.h b/include/trace/boot.h
index 4cbe64e..9eac38b 100644
--- a/include/trace/boot.h
+++ b/include/trace/boot.h
@@ -2,22 +2,30 @@
 #define _LINUX_TRACE_BOOT_H
 
 /*
- * Structure which defines the trace of an initcall.
+ * Structure which defines the trace of an initcall
+ * while it is called.
  * You don't have to fill the func field since it is
  * only used internally by the tracer.
  */
-struct boot_trace {
+struct boot_trace_call {
 	pid_t			caller;
 	char			func[KSYM_NAME_LEN];
-	int			result;
-	unsigned long long	duration;		/* usecs */
-	ktime_t			calltime;
-	ktime_t			rettime;
+};
+
+/*
+ * Structure which defines the trace of an initcall
+ * while it returns.
+ */
+struct boot_trace_ret {
+	char			func[KSYM_NAME_LEN];
+	int				result;
+	unsigned long long 	duration;
 };
 
 #ifdef CONFIG_BOOT_TRACER
-/* Append the trace on the ring-buffer */
-extern void trace_boot(struct boot_trace *it, initcall_t fn);
+/* Append the traces on the ring-buffer */
+extern void trace_boot_call(struct boot_trace_call *bt, initcall_t fn);
+extern void trace_boot_ret(struct boot_trace_ret *bt, initcall_t fn);
 
 /* Tells the tracer that smp_pre_initcall is finished.
  * So we can start the tracing
@@ -34,7 +42,12 @@ extern void enable_boot_trace(void);
  */
 extern void disable_boot_trace(void);
 #else
-static inline void trace_boot(struct boot_trace *it, initcall_t fn) { }
+static inline
+void trace_boot_call(struct boot_trace_call *bt, initcall_t fn) { }
+
+static inline
+void trace_boot_ret(struct boot_trace_ret *bt, initcall_t fn) { }
+
 static inline void start_boot_trace(void) { }
 static inline void enable_boot_trace(void) { }
 static inline void disable_boot_trace(void) { }
diff --git a/init/main.c b/init/main.c
index 2a04290..fc7c379 100644
--- a/init/main.c
+++ b/init/main.c
@@ -712,33 +712,35 @@ core_param(initcall_debug, initcall_debug, bool, 0644);
 int do_one_initcall(initcall_t fn)
 {
 	int count = preempt_count();
-	ktime_t delta;
+	ktime_t calltime, delta, rettime;
 	char msgbuf[64];
-	struct boot_trace it;
+	struct boot_trace_call call;
+	struct boot_trace_ret ret;
 
 	if (initcall_debug) {
-		it.caller = task_pid_nr(current);
-		printk("calling  %pF @ %i\n", fn, it.caller);
-		it.calltime = ktime_get();
+		call.caller = task_pid_nr(current);
+		printk("calling  %pF @ %i\n", fn, call.caller);
+		calltime = ktime_get();
+		trace_boot_call(&call, fn);
 		enable_boot_trace();
 	}
 
-	it.result = fn();
+	ret.result = fn();
 
 	if (initcall_debug) {
-		it.rettime = ktime_get();
-		delta = ktime_sub(it.rettime, it.calltime);
-		it.duration = (unsigned long long) delta.tv64 >> 10;
-		printk("initcall %pF returned %d after %Ld usecs\n", fn,
-			it.result, it.duration);
-		trace_boot(&it, fn);
 		disable_boot_trace();
+		rettime = ktime_get();
+		delta = ktime_sub(rettime, calltime);
+		ret.duration = (unsigned long long) delta.tv64 >> 10;
+		trace_boot_ret(&ret, fn);
+		printk("initcall %pF returned %d after %Ld usecs\n", fn,
+			ret.result, ret.duration);
 	}
 
 	msgbuf[0] = 0;
 
-	if (it.result && it.result != -ENODEV && initcall_debug)
-		sprintf(msgbuf, "error code %d ", it.result);
+	if (ret.result && ret.result != -ENODEV && initcall_debug)
+		sprintf(msgbuf, "error code %d ", ret.result);
 
 	if (preempt_count() != count) {
 		strlcat(msgbuf, "preemption imbalance ", sizeof(msgbuf));
@@ -752,7 +754,7 @@ int do_one_initcall(initcall_t fn)
 		printk("initcall %pF returned with %s\n", fn, msgbuf);
 	}
 
-	return it.result;
+	return ret.result;
 }
 
 
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 9878c27..97927a8 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -23,7 +23,8 @@ enum trace_type {
 	TRACE_MMIO_RW,
 	TRACE_MMIO_MAP,
 	TRACE_UNLIKELY,
-	TRACE_BOOT,
+	TRACE_BOOT_CALL,
+	TRACE_BOOT_RET,
 	TRACE_FN_RET,
 
 	__TRACE_LAST_TYPE
@@ -124,9 +125,14 @@ struct trace_mmiotrace_map {
 	struct mmiotrace_map	map;
 };
 
-struct trace_boot {
+struct trace_boot_call {
 	struct trace_entry	ent;
-	struct boot_trace	initcall;
+	struct boot_trace_call boot_call;
+};
+
+struct trace_boot_ret {
+	struct trace_entry	ent;
+	struct boot_trace_ret boot_ret;
 };
 
 #define TRACE_FUNC_SIZE 30
@@ -239,7 +245,8 @@ extern void __ftrace_bad_type(void);
 			  TRACE_MMIO_RW);				\
 		IF_ASSIGN(var, ent, struct trace_mmiotrace_map,		\
 			  TRACE_MMIO_MAP);				\
-		IF_ASSIGN(var, ent, struct trace_boot, TRACE_BOOT);	\
+		IF_ASSIGN(var, ent, struct trace_boot_call, TRACE_BOOT_CALL);\
+		IF_ASSIGN(var, ent, struct trace_boot_ret, TRACE_BOOT_RET);\
 		IF_ASSIGN(var, ent, struct trace_unlikely, TRACE_UNLIKELY); \
 		IF_ASSIGN(var, ent, struct ftrace_ret_entry, TRACE_FN_RET); \
 		__ftrace_bad_type();					\
diff --git a/kernel/trace/trace_boot.c b/kernel/trace/trace_boot.c
index 8f71915..cb333b7 100644
--- a/kernel/trace/trace_boot.c
+++ b/kernel/trace/trace_boot.c
@@ -58,35 +58,71 @@ static void boot_trace_init(struct trace_array *tr)
 	tracing_sched_switch_assign_trace(tr);
 }
 
-static enum print_line_t initcall_print_line(struct trace_iterator *iter)
+static enum print_line_t
+initcall_call_print_line(struct trace_iterator *iter)
 {
+	struct trace_entry *entry = iter->ent;
+	struct trace_seq *s = &iter->seq;
+	struct trace_boot_call *field;
+	struct boot_trace_call *call;
+	u64 ts;
+	unsigned long nsec_rem;
 	int ret;
+
+	trace_assign_type(field, entry);
+	call = &field->boot_call;
+	ts = iter->ts;
+	nsec_rem = do_div(ts, 1000000000);
+
+	ret = trace_seq_printf(s, "[%5ld.%09ld] calling  %s @ %i\n",
+			(unsigned long)ts, nsec_rem, call->func, call->caller);
+
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+	else
+		return TRACE_TYPE_HANDLED;
+}
+
+static enum print_line_t
+initcall_ret_print_line(struct trace_iterator *iter)
+{
 	struct trace_entry *entry = iter->ent;
-	struct trace_boot *field = (struct trace_boot *)entry;
-	struct boot_trace *it = &field->initcall;
 	struct trace_seq *s = &iter->seq;
-	struct timespec calltime = ktime_to_timespec(it->calltime);
-	struct timespec rettime = ktime_to_timespec(it->rettime);
-
-	if (entry->type == TRACE_BOOT) {
-		ret = trace_seq_printf(s, "[%5ld.%09ld] calling  %s @ %i\n",
-					  calltime.tv_sec,
-					  calltime.tv_nsec,
-					  it->func, it->caller);
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-
-		ret = trace_seq_printf(s, "[%5ld.%09ld] initcall %s "
-					  "returned %d after %lld msecs\n",
-					  rettime.tv_sec,
-					  rettime.tv_nsec,
-					  it->func, it->result, it->duration);
-
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
+	struct trace_boot_ret *field;
+	struct boot_trace_ret *init_ret;
+	u64 ts;
+	unsigned long nsec_rem;
+	int ret;
+
+	trace_assign_type(field, entry);
+	init_ret = &field->boot_ret;
+	ts = iter->ts;
+	nsec_rem = do_div(ts, 1000000000);
+
+	ret = trace_seq_printf(s, "[%5ld.%09ld] initcall %s "
+			"returned %d after %llu msecs\n",
+			(unsigned long) ts,
+			nsec_rem,
+			init_ret->func, init_ret->result, init_ret->duration);
+
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+	else
 		return TRACE_TYPE_HANDLED;
+}
+
+static enum print_line_t initcall_print_line(struct trace_iterator *iter)
+{
+	struct trace_entry *entry = iter->ent;
+
+	switch (entry->type) {
+	case TRACE_BOOT_CALL:
+		return initcall_call_print_line(iter);
+	case TRACE_BOOT_RET:
+		return initcall_ret_print_line(iter);
+	default:
+		return TRACE_TYPE_UNHANDLED;
 	}
-	return TRACE_TYPE_UNHANDLED;
 }
 
 struct tracer boot_tracer __read_mostly =
@@ -97,11 +133,10 @@ struct tracer boot_tracer __read_mostly =
 	.print_line	= initcall_print_line,
 };
 
-void trace_boot(struct boot_trace *it, initcall_t fn)
+void trace_boot_call(struct boot_trace_call *bt, initcall_t fn)
 {
 	struct ring_buffer_event *event;
-	struct trace_boot *entry;
-	struct trace_array_cpu *data;
+	struct trace_boot_call *entry;
 	unsigned long irq_flags;
 	struct trace_array *tr = boot_trace;
 
@@ -111,9 +146,37 @@ void trace_boot(struct boot_trace *it, initcall_t fn)
 	/* Get its name now since this function could
 	 * disappear because it is in the .init section.
 	 */
-	sprint_symbol(it->func, (unsigned long)fn);
+	sprint_symbol(bt->func, (unsigned long)fn);
+	preempt_disable();
+
+	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
+					 &irq_flags);
+	if (!event)
+		goto out;
+	entry	= ring_buffer_event_data(event);
+	tracing_generic_entry_update(&entry->ent, 0, 0);
+	entry->ent.type = TRACE_BOOT_CALL;
+	entry->boot_call = *bt;
+	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
+
+	trace_wake_up();
+
+ out:
+	preempt_enable();
+}
+
+void trace_boot_ret(struct boot_trace_ret *bt, initcall_t fn)
+{
+	struct ring_buffer_event *event;
+	struct trace_boot_ret *entry;
+	unsigned long irq_flags;
+	struct trace_array *tr = boot_trace;
+
+	if (!pre_initcalls_finished)
+		return;
+
+	sprint_symbol(bt->func, (unsigned long)fn);
 	preempt_disable();
-	data = tr->data[smp_processor_id()];
 
 	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
 					 &irq_flags);
@@ -121,8 +184,8 @@ void trace_boot(struct boot_trace *it, initcall_t fn)
 		goto out;
 	entry	= ring_buffer_event_data(event);
 	tracing_generic_entry_update(&entry->ent, 0, 0);
-	entry->ent.type = TRACE_BOOT;
-	entry->initcall = *it;
+	entry->ent.type = TRACE_BOOT_RET;
+	entry->boot_ret = *bt;
 	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
 
 	trace_wake_up();
-- 
1.5.6.5

-- 
