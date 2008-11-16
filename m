Return-Path: <linux-kernel-owner+w=401wt.eu-S1751938AbYKPKma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938AbYKPKma (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 05:42:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752065AbYKPKmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 05:42:07 -0500
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:40601 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbYKPKmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 05:42:06 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: rostedt@goodmis.org, mingo@elte.hu, akpm@linux-foundation.org,
       fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ftrace: Add debug_dump trace to dump binary data from kernel to userspace
Date: Sun, 16 Nov 2008 16:08:01 +0530
Message-Id: <1226831883-26362-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.0.4.735.gea4f
In-Reply-To: <1226831883-26362-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1226831883-26362-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1226831883-26362-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1226831883-26362-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The trace add a new interface debug_dump() which can be used
to dump binary data using ftrace framework. Use the dump mode
of iterator by 'echo dump > iter_ctrl' to read the value in
userspace

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

---
 include/linux/debug_dump.h     |   10 ++++
 kernel/trace/Kconfig           |    6 ++
 kernel/trace/Makefile          |    1 +
 kernel/trace/trace_debugdump.c |  103 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 120 insertions(+), 0 deletions(-)

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
index 30eccc8..247cf3f 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -261,4 +261,10 @@ config DEBUG_PRINT
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
index 86e5869..b1c6dec 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -32,5 +32,6 @@ obj-$(CONFIG_BOOT_TRACER) += trace_boot.o
 obj-$(CONFIG_FUNCTION_RET_TRACER) += trace_functions_return.o
 obj-$(CONFIG_TRACE_BRANCH_PROFILING) += trace_branch.o
 obj-$(CONFIG_DEBUG_PRINT) += trace_debugprint.o
+obj-$(CONFIG_DEBUG_DUMP) += trace_debugdump.o
 
 libftrace-y := ftrace.o
diff --git a/kernel/trace/trace_debugdump.c b/kernel/trace/trace_debugdump.c
new file mode 100644
index 0000000..3ebae2a
--- /dev/null
+++ b/kernel/trace/trace_debugdump.c
@@ -0,0 +1,103 @@
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
+static struct trace_array *ctx_trace;
+static int __read_mostly dd_tracer_enabled;
+
+int debug_dump(void *bin_data, int len)
+{
+	int size;
+	unsigned long irq_flags;
+	struct dump_entry *entry;
+	struct ring_buffer_event *event;
+
+	if (!dd_tracer_enabled)
+		return 0;
+
+	size = sizeof(*entry) + len;
+	event = ring_buffer_lock_reserve(ctx_trace->buffer, size, &irq_flags);
+	if (!event)
+		return 0;
+	entry = ring_buffer_event_data(event);
+	tracing_generic_entry_update(&entry->ent, 0, preempt_count());
+	entry->ent.type	= TRACE_BIN_DUMP;
+	entry->len	= len;
+
+	memcpy(&entry->buf, bin_data, len);
+	ring_buffer_unlock_commit(ctx_trace->buffer, event, irq_flags);
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
+static void dd_trace_start(struct trace_array *tr)
+{
+	dd_reset(tr);
+	dd_tracer_enabled = 1;
+}
+
+static void dd_trace_stop(struct trace_array *tr)
+{
+	dd_tracer_enabled = 0;
+	/* Nothing to do! */
+}
+
+static void dd_trace_init(struct trace_array *tr)
+{
+	ctx_trace = tr;
+	/*
+	 * enable the trace during init if
+	 * we have enabled flag already set
+	 */
+	if (tracing_is_enabled())
+		dd_trace_start(tr);
+}
+
+static void dd_trace_reset(struct trace_array *tr)
+{
+	if (dd_tracer_enabled)
+		dd_trace_stop(tr);
+}
+
+struct tracer dd_trace __read_mostly =
+{
+	.name		= "debug_dump",
+	.init		= dd_trace_init,
+	.reset		= dd_trace_reset,
+	.start		= dd_trace_start,
+	.stop		= dd_trace_stop,
+};
+
+__init static int init_dd_trace(void)
+{
+	return register_tracer(&dd_trace);
+}
+device_initcall(init_dd_trace);
-- 
tg: (140170e..) an/ftrace-debug-dump.patch (depends on: an/ftrace-bin-dump.patch)
