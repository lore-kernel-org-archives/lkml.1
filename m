Return-Path: <linux-kernel-owner+w=401wt.eu-S1755366AbXIYUgD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366AbXIYUgD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 16:36:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751903AbXIYUfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 16:35:54 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:43638 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbXIYUfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 16:35:53 -0400
Subject: [RFC Patch] Trace - Samples
From: "David J. Wilder" <dwilder@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, ananth@in.ibm.com
Content-Type: text/plain
Date: Tue, 25 Sep 2007 13:35:47 -0700
Message-Id: <1190752548.30301.8.camel@lc4eb748232119.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch Moves the trace example into the new samples/ infrastructure

Requires: [patch 3/5] Add samples subdir  (http://lkml.org/lkml/2007/9/25/157)
and create samples/Makefile or apply: 
[patch 4/5] Linux Kernel Markers - Samples (http://lkml.org/lkml/2007/9/25/166) 

Signed-off-by: David Wilder <dwilder@us.ibm.com>
---
 samples/Kbuild             |    2 -
 samples/Kconfig            |    5 ++
 samples/Makefile           |    3 +
 samples/trace/Makefile     |    4 +
 samples/trace/fork_trace.c |  132 ++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 144 insertions(+), 2 deletions(-)

diff --git a/samples/Kbuild b/samples/Kbuild
deleted file mode 100644
index 8af00e9..0000000
--- a/samples/Kbuild
+++ /dev/null
@@ -1,2 +0,0 @@
-# Makefile for Linux samples code
-
diff --git a/samples/Kconfig b/samples/Kconfig
index b46b4cf..e5c6963 100644
--- a/samples/Kconfig
+++ b/samples/Kconfig
@@ -7,5 +7,10 @@ menuconfig SAMPLES
 
 if SAMPLES
 
+config SAMPLE_TRACE
+	tristate "Build trace example -- loadable modules only"
+	depends on TRACE && m
+	help
+	  This builds a trace example module.
 
 endif # SAMPLES
diff --git a/samples/Makefile b/samples/Makefile
new file mode 100644
index 0000000..07a32e6
--- /dev/null
+++ b/samples/Makefile
@@ -0,0 +1,3 @@
+# Makefile for Linux samples code
+
+obj-$(CONFIG_SAMPLES) += trace/
diff --git a/samples/trace/Makefile b/samples/trace/Makefile
new file mode 100644
index 0000000..a2da8af
--- /dev/null
+++ b/samples/trace/Makefile
@@ -0,0 +1,4 @@
+# builds the trace example kernel modules;
+# then to use (as root):  insmod <fork_trace.ko>
+
+obj-$(CONFIG_SAMPLE_TRACE) := fork_trace.o
diff --git a/samples/trace/fork_trace.c b/samples/trace/fork_trace.c
new file mode 100644
index 0000000..71c04c7
--- /dev/null
+++ b/samples/trace/fork_trace.c
@@ -0,0 +1,132 @@
+/*
+ * An example of using trace in a kprobes module
+ *
+ * Copyright (C) 2007 IBM Inc.
+ *
+ * David Wilder <dwilder@us.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * -------
+ * This module creates a trace channel and places a kprobe
+ * on the function do_fork(). The value of current->pid is written to
+ * the trace channel each time the kprobe is hit..
+ *
+ * How to run the example:
+ * $ mount -t debugfs /debug
+ * $ insmod fork_trace.ko
+ *
+ * To view the data produced by the module:
+ * $ cat /debug/trace_example/do_fork/trace0
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/kprobes.h>
+#include <linux/trace.h>
+
+#define USE_GLOBAL_BUFFERS 1
+#define USE_FLIGHT 1
+
+#define PROBE_POINT "do_fork"
+
+static struct kprobe kp;
+static struct trace_info *kprobes_trace;
+
+#ifdef USE_GLOBAL_BUFFERS
+static DEFINE_SPINLOCK(trace_lock);
+#endif
+
+/*
+ * Send formatted trace data to trace channel.
+ * @note Preemption must be disabled to use this.
+ */
+static void trace_printf(struct trace_info *trace, const char *format, ...)
+{
+	va_list ap, aq;
+	char *record;
+	unsigned long flags;
+	int len;
+
+	if (!trace)
+		return;
+
+#ifdef USE_GLOBAL_BUFFERS
+	spin_lock_irqsave(&trace_lock, flags);
+#endif
+	if (trace_running(trace)) {
+		va_start(ap, format);
+		va_copy(aq, ap);
+		len = vsnprintf(NULL, 0, format, aq);
+		va_end(aq);
+		record = relay_reserve(trace->rchan, ++len);
+		if (record)
+			vsnprintf(record, len, format, ap);
+		va_end(ap);
+	}
+#ifdef USE_GLOBAL_BUFFERS
+	spin_unlock_irqrestore(&trace_lock, flags);
+#endif
+}
+
+static int handler_pre(struct kprobe *p, struct pt_regs *regs)
+{
+	rcu_read_lock();
+	trace_printf(kprobes_trace, "%d\n", current->pid);
+	rcu_read_unlock();
+	return 0;
+}
+
+int init_module(void)
+{
+	int ret;
+	u32 flags = 0;
+
+#ifdef USE_GLOBAL_BUFFERS
+	flags |= TRACE_GLOBAL_CHANNEL;
+#endif
+
+#ifdef USE_FLIGHT
+	flags |= TRACE_FLIGHT_CHANNEL;
+#endif
+
+	/* setup the trace */
+	kprobes_trace = trace_setup("trace_example", PROBE_POINT,
+				     1024, 8, flags);
+	if (IS_ERR(kprobes_trace))
+		return PTR_ERR(kprobes_trace);
+
+	trace_start(kprobes_trace);
+
+	/* setup the kprobe */
+	kp.pre_handler = handler_pre;
+	kp.post_handler = NULL;
+	kp.fault_handler = NULL;
+	kp.symbol_name = PROBE_POINT;
+	ret = register_kprobe(&kp);
+	if (ret) {
+		printk(KERN_ERR "fork_trace: register_kprobe failed\n");
+		return ret;
+	}
+	return 0;
+}
+
+void cleanup_module(void)
+{
+	unregister_kprobe(&kp);
+	trace_stop(kprobes_trace);
+	trace_cleanup(kprobes_trace);
+}
+MODULE_LICENSE("GPL");


