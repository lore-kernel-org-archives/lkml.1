Return-Path: <linux-kernel-owner+w=401wt.eu-S1754159AbYKNKq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbYKNKq4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 05:46:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751963AbYKNKqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 05:46:35 -0500
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:48954 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbYKNKqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 05:46:33 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: rostedt@goodmis.org, mingo@elte.hu, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 2/3] ftrace: Add debug_print trace to print data from kernel to userspace
Date: Fri, 14 Nov 2008 16:16:05 +0530
Message-Id: <1226659566-28168-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.0.4.608.ga9645
In-Reply-To: <1226659566-28168-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1226659566-28168-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The trace add a new interface debug_print() which can be used
to dump data from kernel to user space using ftrace framework.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 include/linux/debug_print.h     |   12 ++++
 kernel/trace/Kconfig            |    7 ++
 kernel/trace/Makefile           |    1 +
 kernel/trace/trace_debugprint.c |  134 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 154 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/debug_print.h
 create mode 100644 kernel/trace/trace_debugprint.c

diff --git a/include/linux/debug_print.h b/include/linux/debug_print.h
new file mode 100644
index 0000000..db4397b
--- /dev/null
+++ b/include/linux/debug_print.h
@@ -0,0 +1,12 @@
+#ifndef _LINUX_DEBUGPRINT_H
+#define _LINUX_DEBUGPRINT_H
+#include <linux/marker.h>
+
+#ifdef CONFIG_DEBUG_PRINT
+extern int do_dp_printk(const char *fmt, ...);
+#define dp_printk(fmt, arg...) \
+	do_dp_printk(fmt, ##arg)
+#else
+#define dp_printk(fmt, arg...)
+#endif
+#endif /*  _LINUX_DEBUGPRINT_H */
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index b58f43b..9b832e0 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -195,4 +195,11 @@ config FTRACE_STARTUP_TEST
 	  functioning properly. It will do tests on all the configured
 	  tracers of ftrace.
 
+config DEBUG_PRINT
+	bool "Trace based printk support"
+	depends on DEBUG_KERNEL
+	select TRACING
+	help
+	  This tracer can be used for printk style debugging.
+
 endmenu
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index c8228b1..afbf059 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -24,5 +24,6 @@ obj-$(CONFIG_NOP_TRACER) += trace_nop.o
 obj-$(CONFIG_STACK_TRACER) += trace_stack.o
 obj-$(CONFIG_MMIOTRACE) += trace_mmiotrace.o
 obj-$(CONFIG_BOOT_TRACER) += trace_boot.o
+obj-$(CONFIG_DEBUG_PRINT) += trace_debugprint.o
 
 libftrace-y := ftrace.o
diff --git a/kernel/trace/trace_debugprint.c b/kernel/trace/trace_debugprint.c
new file mode 100644
index 0000000..feb38d8
--- /dev/null
+++ b/kernel/trace/trace_debugprint.c
@@ -0,0 +1,134 @@
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
+static struct trace_array	*ctx_trace;
+static int __read_mostly	tracer_enabled;
+
+int do_dp_printk(const char *fmt, ...)
+{
+	int ret;
+	va_list args;
+
+	if (!tracer_enabled)
+		return 0;
+
+	va_start(args, fmt);
+	ret = trace_vprintk(0, fmt, args);
+	va_end(args);
+	return ret;
+}
+EXPORT_SYMBOL(do_dp_printk);
+
+static void dp_reset(struct trace_array *tr)
+{
+	int cpu;
+
+	tr->time_start = ftrace_now(tr->cpu);
+
+	for_each_online_cpu(cpu)
+		tracing_reset(tr, cpu);
+}
+
+static void start_dp_trace(struct trace_array *tr)
+{
+	dp_reset(tr);
+	tracer_enabled = 1;
+}
+
+static void stop_dp_trace(struct trace_array *tr)
+{
+	tracer_enabled = 0;
+	/* Nothing to do! */
+}
+
+static void dp_trace_init(struct trace_array *tr)
+{
+	ctx_trace = tr;
+
+	if (tr->ctrl)
+		start_dp_trace(tr);
+}
+
+static void dp_trace_reset(struct trace_array *tr)
+{
+	if (tr->ctrl)
+		stop_dp_trace(tr);
+}
+
+static void dp_trace_ctrl_update(struct trace_array *tr)
+{
+	/* When starting a new trace, reset the buffers */
+	if (tr->ctrl)
+		start_dp_trace(tr);
+	else
+		stop_dp_trace(tr);
+}
+
+#ifdef CONFIG_NOP_TRACER
+int
+trace_selftest_startup_dp(struct tracer *trace, struct trace_array *tr)
+{
+	/* What could possibly go wrong? */
+	return 0;
+}
+#endif
+
+static enum print_line_t debug_print_line(struct trace_iterator *iter)
+{
+	struct trace_seq *s = &iter->seq;
+	struct trace_entry *entry;
+
+	entry = iter->ent;
+	switch (entry->type) {
+	case TRACE_PRINT: {
+		struct print_entry *field;
+		trace_assign_type(field, entry);
+
+		trace_seq_printf(s, "%s", field->buf);
+		if (entry->flags & TRACE_FLAG_CONT)
+			trace_seq_print_cont(s, iter);
+		break;
+	}
+	default:
+		printk(KERN_INFO "Unsupported type in debug_print\n");
+		return TRACE_TYPE_UNHANDLED;
+	}
+
+	return TRACE_TYPE_HANDLED;
+}
+
+struct tracer dp_trace __read_mostly =
+{
+	.name		= "debug_print",
+	.init		= dp_trace_init,
+	.reset		= dp_trace_reset,
+	.ctrl_update	= dp_trace_ctrl_update,
+#ifdef CONFIG_FTRACE_SELFTEST
+	.selftest	= trace_selftest_startup_dp,
+#endif
+	.print_line	= debug_print_line,
+};
+
+__init static int init_dp_trace(void)
+{
+	return register_tracer(&dp_trace);
+}
+device_initcall(init_dp_trace);
-- 
1.6.0.4.608.ga9645

