Return-Path: <linux-kernel-owner+w=401wt.eu-S1753499AbYKPKjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499AbYKPKjw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 05:39:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751736AbYKPKjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 05:39:40 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:36633 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbYKPKjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 05:39:39 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: rostedt@goodmis.org, mingo@elte.hu, akpm@linux-foundation.org,
       fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ftrace: Add debug_print trace to print data from kernel to userspace
Date: Sun, 16 Nov 2008 16:08:02 +0530
Message-Id: <1226831883-26362-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.0.4.735.gea4f
In-Reply-To: <1226831883-26362-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1226831883-26362-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1226831883-26362-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1226831883-26362-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1226831883-26362-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The trace add a new interface dp_printk() which can be used
to dump data from kernel to user space using ftrace framework.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

---
 include/linux/debug_print.h     |   12 +++++
 kernel/trace/Kconfig            |    7 +++
 kernel/trace/Makefile           |    1 +
 kernel/trace/trace_debugprint.c |   90 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 110 insertions(+), 0 deletions(-)

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
index 9c89526..30eccc8 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -254,4 +254,11 @@ config FTRACE_STARTUP_TEST
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
index 1a8c925..86e5869 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -31,5 +31,6 @@ obj-$(CONFIG_MMIOTRACE) += trace_mmiotrace.o
 obj-$(CONFIG_BOOT_TRACER) += trace_boot.o
 obj-$(CONFIG_FUNCTION_RET_TRACER) += trace_functions_return.o
 obj-$(CONFIG_TRACE_BRANCH_PROFILING) += trace_branch.o
+obj-$(CONFIG_DEBUG_PRINT) += trace_debugprint.o
 
 libftrace-y := ftrace.o
diff --git a/kernel/trace/trace_debugprint.c b/kernel/trace/trace_debugprint.c
new file mode 100644
index 0000000..2c3ac3d
--- /dev/null
+++ b/kernel/trace/trace_debugprint.c
@@ -0,0 +1,90 @@
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
+static int __read_mostly dp_tracer_enabled;
+
+int do_dp_printk(const char *fmt, ...)
+{
+	int ret;
+	va_list args;
+
+	if (!dp_tracer_enabled)
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
+static void dp_trace_start(struct trace_array *tr)
+{
+	dp_reset(tr);
+	dp_tracer_enabled = 1;
+}
+
+static void dp_trace_stop(struct trace_array *tr)
+{
+	dp_tracer_enabled = 0;
+	/* Nothing to do! */
+}
+
+static void dp_trace_init(struct trace_array *tr)
+{
+	/*
+	 * enable the trace during init if
+	 * we have enabled flag already set
+	 */
+	if (tracing_is_enabled())
+		dp_trace_start(tr);
+}
+
+static void dp_trace_reset(struct trace_array *tr)
+{
+	if (dp_tracer_enabled)
+		dp_trace_stop(tr);
+}
+
+struct tracer dp_trace __read_mostly =
+{
+	.name		= "debug_print",
+	.init		= dp_trace_init,
+	.reset		= dp_trace_reset,
+	.start		= dp_trace_start,
+	.stop		= dp_trace_stop,
+};
+
+__init static int init_dp_trace(void)
+{
+	return register_tracer(&dp_trace);
+}
+device_initcall(init_dp_trace);
-- 
tg: (bfb3409..) an/ftrace-dp-printk.patch (depends on: an/ftrace-dump-iterator.patch)
