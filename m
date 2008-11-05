Return-Path: <linux-kernel-owner+w=401wt.eu-S1753752AbYKEVeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752AbYKEVeg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 16:34:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbYKEVeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 16:34:11 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:54528 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbYKEVeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 16:34:09 -0500
Message-Id: <20081105213406.644225861@goodmis.org>
References: <20081105212428.148612398@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 05 Nov 2008 16:24:30 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/3] ftrace: soft tracing stop and start
Content-Disposition: inline; filename=0002-ftrace-soft-tracing-stop-and-start.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: add way to quickly start stop tracing from the kernel

This patch adds a soft stop and start to the trace. This simply
disables function tracing via the ftrace_disabled flag, and
disables the trace buffers to prevent recording. The tracing
code may still be executed, but the trace will not be recorded.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/ftrace.h |    5 +++
 kernel/trace/trace.c   |   81 ++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 84 insertions(+), 2 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 6eb966d..41054a3 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -219,6 +219,9 @@ static inline void __ftrace_enabled_restore(int enabled)
 #ifdef CONFIG_TRACING
 extern int ftrace_dump_on_oops;
 
+extern void tracing_start(void);
+extern void tracing_stop(void);
+
 extern void
 ftrace_special(unsigned long arg1, unsigned long arg2, unsigned long arg3);
 
@@ -249,6 +252,8 @@ ftrace_special(unsigned long arg1, unsigned long arg2, unsigned long arg3) { }
 static inline int
 ftrace_printk(const char *fmt, ...) __attribute__ ((format (printf, 1, 0)));
 
+static inline void tracing_start(void) { }
+static inline void tracing_stop(void) { }
 static inline int
 ftrace_printk(const char *fmt, ...)
 {
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index c4900b8..411ab5c 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -43,6 +43,15 @@
 unsigned long __read_mostly	tracing_max_latency = (cycle_t)ULONG_MAX;
 unsigned long __read_mostly	tracing_thresh;
 
+
+/*
+ * Kill all tracing for good (never come back).
+ * It is initialized to 1 but will turn to zero if the initialization
+ * of the tracer is successful. But that is the only place that sets
+ * this back to zero.
+ */
+int tracing_disabled = 1;
+
 static DEFINE_PER_CPU(local_t, ftrace_cpu_disabled);
 
 static inline void ftrace_disable_cpu(void)
@@ -62,8 +71,6 @@ static cpumask_t __read_mostly		tracing_buffer_mask;
 #define for_each_tracing_cpu(cpu)	\
 	for_each_cpu_mask(cpu, tracing_buffer_mask)
 
-static int tracing_disabled = 1;
-
 /*
  * ftrace_dump_on_oops - variable to dump ftrace buffer on oops
  *
@@ -613,6 +620,76 @@ static void trace_init_cmdlines(void)
 	cmdline_idx = 0;
 }
 
+static int trace_stop_count;
+static DEFINE_SPINLOCK(tracing_start_lock);
+
+/**
+ * tracing_start - quick start of the tracer
+ *
+ * If tracing is enabled but was stopped by tracing_stop,
+ * this will start the tracer back up.
+ */
+void tracing_start(void)
+{
+	struct ring_buffer *buffer;
+	unsigned long flags;
+
+	if (tracing_disabled)
+		return;
+
+	spin_lock_irqsave(&tracing_start_lock, flags);
+	if (--trace_stop_count)
+		goto out;
+
+	if (trace_stop_count < 0) {
+		/* Someone screwed up their debugging */
+		WARN_ON_ONCE(1);
+		trace_stop_count = 0;
+		goto out;
+	}
+
+
+	buffer = global_trace.buffer;
+	if (buffer)
+		ring_buffer_record_enable(buffer);
+
+	buffer = max_tr.buffer;
+	if (buffer)
+		ring_buffer_record_enable(buffer);
+
+	ftrace_start();
+ out:
+	spin_unlock_irqrestore(&tracing_start_lock, flags);
+}
+
+/**
+ * tracing_stop - quick stop of the tracer
+ *
+ * Light weight way to stop tracing. Use in conjunction with
+ * tracing_start.
+ */
+void tracing_stop(void)
+{
+	struct ring_buffer *buffer;
+	unsigned long flags;
+
+	ftrace_stop();
+	spin_lock_irqsave(&tracing_start_lock, flags);
+	if (trace_stop_count++)
+		goto out;
+
+	buffer = global_trace.buffer;
+	if (buffer)
+		ring_buffer_record_disable(buffer);
+
+	buffer = max_tr.buffer;
+	if (buffer)
+		ring_buffer_record_disable(buffer);
+
+ out:
+	spin_unlock_irqrestore(&tracing_start_lock, flags);
+}
+
 void trace_stop_cmdline_recording(void);
 
 static void trace_save_cmdline(struct task_struct *tsk)
-- 
1.5.6.5

-- 
