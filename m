Return-Path: <linux-kernel-owner+w=401wt.eu-S1754534AbYKNKrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534AbYKNKrY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 05:47:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752179AbYKNKqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 05:46:37 -0500
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:51772 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbYKNKqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 05:46:36 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: rostedt@goodmis.org, mingo@elte.hu, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 3/3] ftrace: Add debug_dump trace to dump binary data from kernel to userspace
Date: Fri, 14 Nov 2008 16:16:06 +0530
Message-Id: <1226659566-28168-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.0.4.608.ga9645
In-Reply-To: <1226659566-28168-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1226659566-28168-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1226659566-28168-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The trace add a new interface debug_dump() which can be used
to dump binary data using ftrace framework. Use the bin mode
of iterator by 'echo bin > iter_ctrl' to read the value in
userspace

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 include/linux/debug_dump.h     |   10 +++
 kernel/trace/Kconfig           |    6 ++
 kernel/trace/Makefile          |    1 +
 kernel/trace/trace.c           |    4 +
 kernel/trace/trace.h           |    3 +
 kernel/trace/trace_debugdump.c |  172 ++++++++++++++++++++++++++++++++++++++++
 6 files changed, 196 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/debug_dump.h
 create mode 100644 kernel/trace/trace_debugdump.c

diff --git a/include/linux/debug_dump.h b/include/linux/debug_dump.h
new file mode 100644
index 0000000..2c1836d
--- /dev/null
+++ b/include/linux/debug_dump.h
@@ -0,0 +1,10 @@
+#ifndef _LINUX_DEBUGDUMP_H
+#define _LINUX_DEBUGDUMP_H
+#include <linux/marker.h>
+
+#ifdef CONFIG_DEBUG_DUMP
+extern int debug_dump(void *p, int len);
+#else
+#define debug_dump(p, len)
+#endif
+#endif /*  _LINUX_DEBUGDUMP_H */
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 9b832e0..ddde659 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -202,4 +202,10 @@ config DEBUG_PRINT
 	help
 	  This tracer can be used for printk style debugging.
 
+config DEBUG_DUMP
+	bool "Trace based dump support"
+	depends on DEBUG_KERNEL
+	select TRACING
+	help
+	  This tracer can be used to dump binary data from kernel
 endmenu
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index afbf059..afd1be7 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -25,5 +25,6 @@ obj-$(CONFIG_STACK_TRACER) += trace_stack.o
 obj-$(CONFIG_MMIOTRACE) += trace_mmiotrace.o
 obj-$(CONFIG_BOOT_TRACER) += trace_boot.o
 obj-$(CONFIG_DEBUG_PRINT) += trace_debugprint.o
+obj-$(CONFIG_DEBUG_DUMP) += trace_debugdump.o
 
 libftrace-y := ftrace.o
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index fb32a5c..b62eebe 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -156,6 +156,10 @@ static DECLARE_WAIT_QUEUE_HEAD(trace_wait);
 /* trace_flags holds iter_ctrl options */
 unsigned long trace_flags = TRACE_ITER_PRINT_PARENT;
 
+struct trace_array *trace_get_global_trace(void)
+{
+	return &global_trace;
+}
 /**
  * trace_wake_up - wake up tasks waiting for trace input
  *
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 8465ad0..345bea2 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -22,6 +22,7 @@ enum trace_type {
 	TRACE_MMIO_RW,
 	TRACE_MMIO_MAP,
 	TRACE_BOOT,
+	TRACE_BIN_DUMP,
 
 	__TRACE_LAST_TYPE
 };
@@ -219,6 +220,7 @@ extern void __ftrace_bad_type(void);
 		IF_ASSIGN(var, ent, struct trace_mmiotrace_map,		\
 			  TRACE_MMIO_MAP);				\
 		IF_ASSIGN(var, ent, struct trace_boot, TRACE_BOOT);	\
+		IF_ASSIGN(var, ent, struct dump_entry, TRACE_BIN_DUMP);	\
 		__ftrace_bad_type();					\
 	} while (0)
 
@@ -393,6 +395,7 @@ extern ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf,
 				 size_t cnt);
 extern long ns2usecs(cycle_t nsec);
 extern int trace_vprintk(unsigned long ip, const char *fmt, va_list args);
+extern struct trace_array *trace_get_global_trace(void);
 
 extern unsigned long trace_flags;
 
diff --git a/kernel/trace/trace_debugdump.c b/kernel/trace/trace_debugdump.c
new file mode 100644
index 0000000..8c7c56f
--- /dev/null
+++ b/kernel/trace/trace_debugdump.c
@@ -0,0 +1,172 @@
+/*
+ * Copyright IBM Corporation, 2008
+ * Author Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2.1 of the GNU Lesser General Public License
+ * as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/debugfs.h>
+#include <linux/ftrace.h>
+
+#include "trace.h"
+
+struct dump_entry {
+	struct trace_entry ent;
+	int	len;
+	char	buf[];
+};
+
+static struct trace_array	*ctx_trace;
+static int __read_mostly	tracer_enabled;
+
+int debug_dump(void *bin_data, int len)
+{
+	struct ring_buffer_event *event;
+	struct trace_array *tr;
+	struct trace_array_cpu *data;
+	struct dump_entry *entry;
+	unsigned long flags, irq_flags;
+	int cpu, size, pc;
+
+	if (!tracer_enabled)
+		return 0;
+	tr = trace_get_global_trace();
+	pc = preempt_count();
+	preempt_disable_notrace();
+	cpu = raw_smp_processor_id();
+	data = tr->data[cpu];
+
+	local_irq_save(flags);
+	size = sizeof(*entry) + len;
+	event = ring_buffer_lock_reserve(tr->buffer, size, &irq_flags);
+	if (!event)
+		goto out;
+	entry = ring_buffer_event_data(event);
+	tracing_generic_entry_update(&entry->ent, flags, pc);
+	entry->ent.type	= TRACE_BIN_DUMP;
+	entry->len	= len;
+
+	memcpy(&entry->buf, bin_data, len);
+	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
+
+out:
+	local_irq_restore(flags);
+	preempt_enable_notrace();
+
+	return len;
+}
+EXPORT_SYMBOL_GPL(debug_dump);
+
+static void dd_reset(struct trace_array *tr)
+{
+	int cpu;
+
+	tr->time_start = ftrace_now(tr->cpu);
+
+	for_each_online_cpu(cpu)
+		tracing_reset(tr, cpu);
+}
+
+static void start_dd_trace(struct trace_array *tr)
+{
+	dd_reset(tr);
+	tracer_enabled = 1;
+}
+
+static void stop_dd_trace(struct trace_array *tr)
+{
+	tracer_enabled = 0;
+	/* Nothing to do! */
+}
+
+static void dd_trace_init(struct trace_array *tr)
+{
+	ctx_trace = tr;
+
+	if (tr->ctrl)
+		start_dd_trace(tr);
+}
+
+static void dd_trace_reset(struct trace_array *tr)
+{
+	if (tr->ctrl)
+		stop_dd_trace(tr);
+}
+
+static void dd_trace_ctrl_update(struct trace_array *tr)
+{
+	/* When starting a new trace, reset the buffers */
+	if (tr->ctrl)
+		start_dd_trace(tr);
+	else
+		stop_dd_trace(tr);
+}
+
+#ifdef CONFIG_NOP_TRACER
+int
+trace_selftest_startup_dd(struct tracer *trace, struct trace_array *tr)
+{
+	/* What could possibly go wrong? */
+	return 0;
+}
+#endif
+
+static int
+trace_seq_putmem(struct trace_seq *s, void *mem, size_t len)
+{
+	if (len > ((PAGE_SIZE - 1) - s->len))
+		return 0;
+
+	memcpy(s->buffer + s->len, mem, len);
+	s->len += len;
+
+	return len;
+}
+
+static enum print_line_t debug_dump_entry(struct trace_iterator *iter)
+{
+	struct trace_seq *s = &iter->seq;
+	struct trace_entry *entry;
+
+	entry = iter->ent;
+	switch (entry->type) {
+	case TRACE_BIN_DUMP: {
+		struct dump_entry *field;
+		trace_assign_type(field, entry);
+		trace_seq_putmem(s, field->buf, field->len);
+		break;
+	}
+	default:
+		printk(KERN_INFO "Unsupported type in debug_dump\n");
+		return TRACE_TYPE_UNHANDLED;
+	}
+
+	return TRACE_TYPE_HANDLED;
+}
+
+struct tracer dd_trace __read_mostly =
+{
+	.name		= "debug_dump",
+	.init		= dd_trace_init,
+	.reset		= dd_trace_reset,
+	.ctrl_update	= dd_trace_ctrl_update,
+#ifdef CONFIG_FTRACE_SELFTEST
+	.selftest	= trace_selftest_startup_dd,
+#endif
+	.print_line	= debug_dump_entry,
+};
+
+__init static int init_dd_trace(void)
+{
+	return register_tracer(&dd_trace);
+}
+device_initcall(init_dd_trace);
-- 
1.6.0.4.608.ga9645

