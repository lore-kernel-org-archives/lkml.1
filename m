Return-Path: <linux-kernel-owner+w=401wt.eu-S1755259AbZBXFTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259AbZBXFTw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 00:19:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752034AbZBXFTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 00:19:43 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:65514 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbZBXFTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 00:19:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:cc:subject;
        b=t+ZfmtTAVxJwmg/xDawcdLyNeq0OhBB9GWn6igaxTd8dYGosVPoNbgel7sZ8oiJf/g
         sWPal2UiJYngOB/0EEr4aCh9ySAQcj+IGzeBrAoxyuHlxq997140gjgArymBkBW0Hv/1
         vHRkxwzXkRPcsXuq0eJvmMHH22J7CkjmhB0oI=
Message-ID: <49a38369.1c07d00a.7acd.ffff9399@mx.google.com>
Date: Mon, 23 Feb 2009 21:19:37 -0800 (PST)
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/3] ftrace: infrastructure for supporting binary record
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

Impact: save on memory for tracing

Current tracers are typically using a struct(like struct ftrace_entry,
struct ctx_switch_entry, struct special_entr etc...)to record a binary
event. These structs can only record a their own kind of events.
A new kind of tracer need a new struct and a lot of code too handle it.

So we need a generic binary record for events. This infrastructure
is for this purpose.

[fweisbec@gmail.com: ported to latest -tip]

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h       |    3 +
 kernel/trace/Kconfig         |    6 +++
 kernel/trace/Makefile        |    1 +
 kernel/trace/trace.c         |   55 ++++++++++++++++++++++++++
 kernel/trace/trace.h         |   12 ++++++
 kernel/trace/trace_bprintk.c |   87 ++++++++++++++++++++++++++++++++++++++++++
 kernel/trace/trace_output.c  |   76 ++++++++++++++++++++++++++++++++++++
 7 files changed, 240 insertions(+), 0 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 847bb3c..8ac2fac 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -222,6 +222,9 @@ extern int ftrace_make_nop(struct module *mod,
  */
 extern int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr);
 
+#ifdef CONFIG_TRACE_BPRINTK
+extern int trace_vbprintk(unsigned long ip, const char *fmt, va_list args);
+#endif
 
 /* May be defined in arch */
 extern int ftrace_arch_read_dyn_info(char *buf, int size);
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 9e4f17c..fdc6f0a 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -86,6 +86,12 @@ config FUNCTION_GRAPH_TRACER
 	  This is done by setting the current return address on the current
 	  task structure into a stack of calls.
 
+config TRACE_BPRINTK
+	bool "Binary printk for tracing"
+	default y
+	depends on TRACING
+	select BINARY_PRINTF
+
 config IRQSOFF_TRACER
 	bool "Interrupts-off Latency Tracer"
 	default n
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 627090b..28689f9 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -21,6 +21,7 @@ obj-$(CONFIG_RING_BUFFER) += ring_buffer.o
 obj-$(CONFIG_TRACING) += trace.o
 obj-$(CONFIG_TRACING) += trace_output.o
 obj-$(CONFIG_TRACING) += trace_stat.o
+obj-$(CONFIG_TRACE_BPRINTK) += trace_bprintk.o
 obj-$(CONFIG_CONTEXT_SWITCH_TRACER) += trace_sched_switch.o
 obj-$(CONFIG_SYSPROF_TRACER) += trace_sysprof.o
 obj-$(CONFIG_FUNCTION_TRACER) += trace_functions.o
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 7f450b6..be0bb8c 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3085,6 +3085,61 @@ int __ftrace_vprintk(unsigned long ip, const char *fmt, va_list ap)
 }
 EXPORT_SYMBOL_GPL(__ftrace_vprintk);
 
+/**
+ * trace_vbprintk - write binary msg to tracing buffer
+ *
+ * Caller must insure @fmt are valid when msg is in tracing buffer.
+ */
+int trace_vbprintk(unsigned long ip, const char *fmt, va_list args)
+{
+	static DEFINE_SPINLOCK(trace_buf_lock);
+	static u32 trace_buf[TRACE_BUF_SIZE];
+
+	struct ring_buffer_event *event;
+	struct trace_array *tr = &global_trace;
+	struct trace_array_cpu *data;
+	struct bprintk_entry *entry;
+	unsigned long flags;
+	int cpu, len = 0, size, pc;
+
+	if (tracing_disabled || !trace_bprintk_enable)
+		return 0;
+
+	pc = preempt_count();
+	preempt_disable_notrace();
+	cpu = raw_smp_processor_id();
+	data = tr->data[cpu];
+
+	if (unlikely(atomic_read(&data->disabled)))
+		goto out;
+
+	spin_lock_irqsave(&trace_buf_lock, flags);
+	len = vbin_printf(trace_buf, TRACE_BUF_SIZE, fmt, args);
+
+	if (len > TRACE_BUF_SIZE || len < 0)
+		goto out_unlock;
+
+	size = sizeof(*entry) + sizeof(u32) * len;
+	event = trace_buffer_lock_reserve(tr, TRACE_BPRINTK, size, flags, pc);
+	if (!event)
+		goto out_unlock;
+	entry = ring_buffer_event_data(event);
+	entry->ip			= ip;
+	entry->fmt			= fmt;
+
+	memcpy(entry->buf, trace_buf, sizeof(u32) * len);
+	ring_buffer_unlock_commit(tr->buffer, event);
+
+out_unlock:
+	spin_unlock_irqrestore(&trace_buf_lock, flags);
+
+out:
+	preempt_enable_notrace();
+
+	return len;
+}
+EXPORT_SYMBOL_GPL(trace_vbprintk);
+
 static int trace_panic_handler(struct notifier_block *this,
 			       unsigned long event, void *unused)
 {
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index eed732c..45a2a1b 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -20,6 +20,7 @@ enum trace_type {
 	TRACE_WAKE,
 	TRACE_STACK,
 	TRACE_PRINT,
+	TRACE_BPRINTK,
 	TRACE_SPECIAL,
 	TRACE_MMIO_RW,
 	TRACE_MMIO_MAP,
@@ -124,6 +125,16 @@ struct print_entry {
 	char			buf[];
 };
 
+struct bprintk_entry {
+	struct trace_entry ent;
+	unsigned long ip;
+	const char *fmt;
+	u32 buf[];
+};
+#ifdef CONFIG_TRACE_BPRINTK
+extern int trace_bprintk_enable;
+#endif
+
 #define TRACE_OLD_SIZE		88
 
 struct trace_field_cont {
@@ -284,6 +295,7 @@ extern void __ftrace_bad_type(void);
 		IF_ASSIGN(var, ent, struct stack_entry, TRACE_STACK);	\
 		IF_ASSIGN(var, ent, struct userstack_entry, TRACE_USER_STACK);\
 		IF_ASSIGN(var, ent, struct print_entry, TRACE_PRINT);	\
+		IF_ASSIGN(var, ent, struct bprintk_entry, TRACE_BPRINTK);\
 		IF_ASSIGN(var, ent, struct special_entry, 0);		\
 		IF_ASSIGN(var, ent, struct trace_mmiotrace_rw,		\
 			  TRACE_MMIO_RW);				\
diff --git a/kernel/trace/trace_bprintk.c b/kernel/trace/trace_bprintk.c
new file mode 100644
index 0000000..1f8e532
--- /dev/null
+++ b/kernel/trace/trace_bprintk.c
@@ -0,0 +1,87 @@
+/*
+ * trace binary printk
+ *
+ * Copyright (C) 2008 Lai Jiangshan <laijs@cn.fujitsu.com>
+ *
+ */
+#include <linux/kernel.h>
+#include <linux/ftrace.h>
+#include <linux/string.h>
+#include <linux/ctype.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/seq_file.h>
+#include <linux/fs.h>
+#include <linux/marker.h>
+#include <linux/uaccess.h>
+
+#include "trace.h"
+
+/* binary printk basic */
+static DEFINE_MUTEX(btrace_mutex);
+static int btrace_metadata_count;
+
+static inline void lock_btrace(void)
+{
+	mutex_lock(&btrace_mutex);
+}
+
+static inline void unlock_btrace(void)
+{
+	mutex_unlock(&btrace_mutex);
+}
+
+static void get_btrace_metadata(void)
+{
+	lock_btrace();
+	btrace_metadata_count++;
+	unlock_btrace();
+}
+
+static void put_btrace_metadata(void)
+{
+	lock_btrace();
+	btrace_metadata_count--;
+	unlock_btrace();
+}
+
+/* events tracer */
+int trace_bprintk_enable;
+
+static void start_bprintk_trace(struct trace_array *tr)
+{
+	get_btrace_metadata();
+	tracing_reset_online_cpus(tr);
+	trace_bprintk_enable = 1;
+}
+
+static void stop_bprintk_trace(struct trace_array *tr)
+{
+	trace_bprintk_enable = 0;
+	tracing_reset_online_cpus(tr);
+	put_btrace_metadata();
+}
+
+static int init_bprintk_trace(struct trace_array *tr)
+{
+	start_bprintk_trace(tr);
+	return 0;
+}
+
+static struct tracer bprintk_trace __read_mostly =
+{
+	.name	     = "events",
+	.init	     = init_bprintk_trace,
+	.reset	     = stop_bprintk_trace,
+	.start	     = start_bprintk_trace,
+	.stop	     = stop_bprintk_trace,
+};
+
+static __init int init_bprintk(void)
+{
+	return register_tracer(&bprintk_trace);
+}
+
+device_initcall(init_bprintk);
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 9fc8150..7897b5d 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -53,6 +53,26 @@ trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
 	return len;
 }
 
+static int
+trace_seq_bprintf(struct trace_seq *s, const char *fmt, const u32 *binary)
+{
+	int len = (PAGE_SIZE - 1) - s->len;
+	int ret;
+
+	if (!len)
+		return 0;
+
+	ret = bstr_printf(s->buffer + s->len, len, fmt, binary);
+
+	/* If we can't write it all, don't bother writing anything */
+	if (ret >= len)
+		return 0;
+
+	s->len += ret;
+
+	return len;
+}
+
 /**
  * trace_seq_puts - trace sequence printing of simple string
  * @s: trace sequence descriptor
@@ -887,6 +907,61 @@ static struct trace_event trace_print_event = {
 	.raw		= trace_print_raw,
 };
 
+/* TRACE_BPRINTK */
+static enum print_line_t
+trace_bprintk_print(struct trace_iterator *iter, int flags)
+{
+	struct trace_entry *entry = iter->ent;
+	struct trace_seq *s = &iter->seq;
+	struct bprintk_entry *field;
+
+	trace_assign_type(field, entry);
+
+	if (!seq_print_ip_sym(s, field->ip, flags))
+		goto partial;
+
+	if (!trace_seq_puts(s, ": "))
+		goto partial;
+
+	if (!trace_seq_bprintf(s, field->fmt, field->buf))
+		goto partial;
+
+	return TRACE_TYPE_HANDLED;
+
+ partial:
+	return TRACE_TYPE_PARTIAL_LINE;
+}
+
+static enum print_line_t
+trace_bprintk_raw(struct trace_iterator *iter, int flags)
+{
+	struct trace_entry *entry = iter->ent;
+	struct trace_seq *s = &iter->seq;
+	struct bprintk_entry *field;
+
+	trace_assign_type(field, entry);
+
+	if (!trace_seq_printf(s, ": %lx : ", field->ip))
+		goto partial;
+
+	if (!trace_seq_bprintf(s, field->fmt, field->buf))
+		goto partial;
+
+	return TRACE_TYPE_HANDLED;
+
+ partial:
+	return TRACE_TYPE_PARTIAL_LINE;
+}
+
+static struct trace_event trace_bprintk_event = {
+	.type	 	= TRACE_BPRINTK,
+	.trace		= trace_bprintk_print,
+	.latency_trace	= trace_bprintk_print,
+	.raw		= trace_bprintk_raw,
+	.hex		= trace_nop_print,
+	.binary		= trace_nop_print,
+};
+
 static struct trace_event *events[] __initdata = {
 	&trace_fn_event,
 	&trace_ctx_event,
@@ -895,6 +970,7 @@ static struct trace_event *events[] __initdata = {
 	&trace_stack_event,
 	&trace_user_stack_event,
 	&trace_print_event,
+	&trace_bprintk_event,
 	NULL
 };
 
-- 
1.6.1


