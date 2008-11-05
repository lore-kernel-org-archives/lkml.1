Return-Path: <linux-kernel-owner+w=401wt.eu-S1756088AbYKERse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088AbYKERse (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 12:48:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752478AbYKERsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 12:48:25 -0500
Received: from casper.infradead.org ([85.118.1.10]:40160 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbYKERsY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 12:48:24 -0500
Date: Wed, 5 Nov 2008 09:49:02 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: [PATCH] ftrace: add an fsync tracer
Message-ID: <20081105094902.27ec4b39@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 63c1b869d94eb31a98015af09fb24e22151f2f00 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Tue, 4 Nov 2008 21:08:11 -0800
Subject: [PATCH] ftrace: add an fsync tracer

fsync() (and its cousin, fdatasync()) are important chokepoints in the
kernel as they imply very expensive operations, both in terms of filesystem
operations (ext3 writes back its entire journal) as well as the block layer
(fsync() implies sending a cache flushing barrier to the SATA/SCSI disk).

This tracer makes a log of which application calls fsync() on which file,
so that developers and others interested in finding these choke points
can locate them and fix them in the apps that call this function.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 fs/sync.c                  |    4 +
 include/trace/fs.h         |   11 +++
 kernel/trace/Kconfig       |    9 +++
 kernel/trace/Makefile      |    1 +
 kernel/trace/trace.h       |    1 +
 kernel/trace/trace_fsync.c |  165 ++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 191 insertions(+), 0 deletions(-)
 create mode 100644 include/trace/fs.h
 create mode 100644 kernel/trace/trace_fsync.c

diff --git a/fs/sync.c b/fs/sync.c
index 2967562..dd5641b 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -14,6 +14,8 @@
 #include <linux/quotaops.h>
 #include <linux/buffer_head.h>
 
+#include <trace/fs.h>
+
 #define VALID_FLAGS (SYNC_FILE_RANGE_WAIT_BEFORE|SYNC_FILE_RANGE_WRITE| \
 			SYNC_FILE_RANGE_WAIT_AFTER)
 
@@ -81,6 +83,8 @@ long do_fsync(struct file *file, int datasync)
 	int err;
 	struct address_space *mapping = file->f_mapping;
 
+	trace_do_fsync(file, datasync);
+
 	if (!file->f_op || !file->f_op->fsync) {
 		/* Why?  We can still call filemap_fdatawrite */
 		ret = -EINVAL;
diff --git a/include/trace/fs.h b/include/trace/fs.h
new file mode 100644
index 0000000..9d964f1
--- /dev/null
+++ b/include/trace/fs.h
@@ -0,0 +1,11 @@
+#ifndef _TRACE_FS_H
+#define _TRACE_FS_H
+
+#include <linux/fs.h>
+#include <linux/tracepoint.h>
+
+DEFINE_TRACE(do_fsync,
+	TPPROTO(struct file *file, int datasync),
+		TPARGS(file, datasync));
+
+#endif
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 33dbefd..42d60c5 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -119,6 +119,15 @@ config CONTEXT_SWITCH_TRACER
 	  This tracer gets called from the context switch and records
 	  all switching of tasks.
 
+config FSYNC_TRACER
+	bool "Trace fsync() calls"
+	depends on DEBUG_KERNEL
+	select TRACING
+	select MARKERS
+	help
+	  This tracer records fsync() and fdatasync() calls. These calls
+	  are key reasons for IO related system latency.
+
 config BOOT_TRACER
 	bool "Trace boot initcalls"
 	depends on DEBUG_KERNEL
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index c8228b1..292f39d 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -15,6 +15,7 @@ obj-$(CONFIG_RING_BUFFER) += ring_buffer.o
 
 obj-$(CONFIG_TRACING) += trace.o
 obj-$(CONFIG_CONTEXT_SWITCH_TRACER) += trace_sched_switch.o
+obj-$(CONFIG_FSYNC_TRACER) += trace_fsync.o
 obj-$(CONFIG_SYSPROF_TRACER) += trace_sysprof.o
 obj-$(CONFIG_FUNCTION_TRACER) += trace_functions.o
 obj-$(CONFIG_IRQSOFF_TRACER) += trace_irqsoff.o
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 8465ad0..dd0fef4 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -22,6 +22,7 @@ enum trace_type {
 	TRACE_MMIO_RW,
 	TRACE_MMIO_MAP,
 	TRACE_BOOT,
+	TRACE_FSYNC,
 
 	__TRACE_LAST_TYPE
 };
diff --git a/kernel/trace/trace_fsync.c b/kernel/trace/trace_fsync.c
new file mode 100644
index 0000000..9cfb9d0
--- /dev/null
+++ b/kernel/trace/trace_fsync.c
@@ -0,0 +1,165 @@
+/*
+ * trace fsync calls
+ * Copyright (C) 2008 Intel Corporation
+ *
+ * Based extensively on trace_sched_switch.c
+ * Copyright (C) 2007 Steven Rostedt <srostedt@redhat.com>
+ *
+ */
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/debugfs.h>
+#include <linux/kallsyms.h>
+#include <linux/uaccess.h>
+#include <linux/ftrace.h>
+#include <trace/fs.h>
+
+#include "trace.h"
+
+static struct trace_array	*ctx_trace;
+static int __read_mostly	tracer_enabled;
+static atomic_t			fsync_ref;
+
+static void
+probe_do_fsync(struct file *file, int datasync)
+{
+	char *buffer;
+	char *err;
+
+	if (!atomic_read(&fsync_ref))
+		return;
+
+	if (!tracer_enabled)
+		return;
+
+	buffer = kmalloc(4096, GFP_KERNEL);
+	if (!buffer)
+		return;
+
+	memset(buffer, 0, 4096);
+	err = d_path(&file->f_path, buffer, 4096);
+
+	if (IS_ERR(err))
+		goto out;
+
+	ftrace_printk("Process %s is calling fsync on %s\n",
+			current->comm, err);
+
+out:
+	kfree(buffer);
+}
+
+static void fsync_reset(struct trace_array *tr)
+{
+	int cpu;
+
+	tr->time_start = ftrace_now(tr->cpu);
+
+	for_each_online_cpu(cpu)
+		tracing_reset(tr, cpu);
+}
+
+static int tracing_fsync_register(void)
+{
+	int ret;
+
+	ret = register_trace_do_fsync(probe_do_fsync);
+	if (ret) {
+		pr_info("wakeup trace: Couldn't activate tracepoint"
+			" probe to do_fsync\n");
+		return ret;
+	}
+
+	return ret;
+}
+
+static void tracing_fsync_unregister(void)
+{
+	unregister_trace_do_fsync(probe_do_fsync);
+}
+
+static void tracing_start_fsync(void)
+{
+	long ref;
+
+	ref = atomic_inc_return(&fsync_ref);
+	if (ref == 1)
+		tracing_fsync_register();
+}
+
+static void tracing_stop_fsync(void)
+{
+	long ref;
+
+	ref = atomic_dec_and_test(&fsync_ref);
+	if (ref)
+		tracing_fsync_unregister();
+}
+
+void tracing_start_cmdline_record(void)
+{
+	tracing_start_fsync();
+}
+
+void tracing_stop_cmdline_record(void)
+{
+	tracing_stop_fsync();
+}
+
+static void start_fsync_trace(struct trace_array *tr)
+{
+	fsync_reset(tr);
+	tracing_start_cmdline_record();
+	tracer_enabled = 1;
+}
+
+static void stop_fsync_trace(struct trace_array *tr)
+{
+	tracer_enabled = 0;
+	tracing_stop_cmdline_record();
+}
+
+static void fsync_trace_init(struct trace_array *tr)
+{
+	ctx_trace = tr;
+
+	if (tr->ctrl)
+		start_fsync_trace(tr);
+}
+
+static void fsync_trace_reset(struct trace_array *tr)
+{
+	if (tr->ctrl)
+		stop_fsync_trace(tr);
+}
+
+static void fsync_trace_ctrl_update(struct trace_array *tr)
+{
+	/* When starting a new trace, reset the buffers */
+	if (tr->ctrl)
+		start_fsync_trace(tr);
+	else
+		stop_fsync_trace(tr);
+}
+
+static struct tracer fsync_trace __read_mostly =
+{
+	.name		= "fsync",
+	.init		= fsync_trace_init,
+	.reset		= fsync_trace_reset,
+	.ctrl_update	= fsync_trace_ctrl_update,
+};
+
+__init static int init_fsync_trace(void)
+{
+	int ret = 0;
+
+	if (atomic_read(&fsync_ref))
+		ret = tracing_fsync_register();
+	if (ret) {
+		pr_info("error registering fsync trace\n");
+		return ret;
+	}
+	return register_tracer(&fsync_trace);
+}
+device_initcall(init_fsync_trace);
-- 
1.6.0.3



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
