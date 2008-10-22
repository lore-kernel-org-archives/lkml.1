Return-Path: <linux-kernel-owner+w=401wt.eu-S1755884AbYJVRJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884AbYJVRJ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 13:09:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751285AbYJVRJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 13:09:50 -0400
Received: from gv-out-0910.google.com ([216.239.58.191]:17000 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbYJVRJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:09:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=ZaNwgXxhF+qOOdY84xqhXgiyG/BYCJBdlQZ5VX744OK40rjVDusAMe3PYgvQf0LbTL
         i/4JFrQm/fc7Ysoo6lR7Hf5fFSDEaNThH3GbWYLCV9mt7dnB0bLNVIH1kmEahdLxacJk
         69+VfC482KCFTuqdwU3wuS3+1KsoyrBkNTsww=
Message-ID: <48FF5E54.7000101@gmail.com>
Date: Wed, 22 Oct 2008 19:09:40 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH][RESEND] tracing/ftrace: Introduce the big kernel lock tracer
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce the Big Kernel Lock tracer.
This new tracer lets one to observe the latencies caused
by the lock_kernel() function.
It captures the time when the task request the spinlock,
the time when the spinlock is hold and the time it is released.
This way we can measure the latency for a task that wait for this
spinlock and the latency caused by the time this lock is hold.

I will surely add some improvements like:

_ Adding a stack trace to know which function locked or unlocked the kernel.
_ Adding a script to get some statistics about this: which functions hold it
often, which hold it for a long time and some other things....

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/bkl.h      |   29 ++++++++
 kernel/trace/Kconfig     |   11 +++
 kernel/trace/Makefile    |    1 +
 kernel/trace/trace.h     |   18 +++++
 kernel/trace/trace_bkl.c |  170 ++++++++++++++++++++++++++++++++++++++++++++++
 lib/kernel_lock.c        |   22 ++++++-
 6 files changed, 249 insertions(+), 2 deletions(-)

diff --git a/include/trace/bkl.h b/include/trace/bkl.h
new file mode 100644
index 0000000..bed2f1b
--- /dev/null
+++ b/include/trace/bkl.h
@@ -0,0 +1,29 @@
+#ifndef _TRACE_BKL_H
+#define _TRACE_BKL_H
+
+
+/* Entry which log the time when the task tried first to acquire the bkl
+ * and the time when it acquired it.
+ * That will let us know the latency to acquire the kernel lock.
+ */
+struct bkl_trace_acquire {
+	unsigned long long acquire_req_time;
+	unsigned long long acquire_time;
+};
+
+/* This will log the time when the task released the bkl.
+ * So we will know the whole duration of its kernel lock.
+ */
+struct bkl_trace_release {
+	unsigned long long release_time;
+};
+
+#ifdef CONFIG_BKL_TRACER
+extern void trace_bkl_acquire(struct bkl_trace_acquire *trace);
+extern void trace_bkl_release(struct bkl_trace_release *trace);
+#else
+static void trace_bkl_acquire(struct bkl_trace_acquire *trace) { }
+static void trace_bkl_release(struct bkl_trace_release *trace) { }
+#endif
+
+#endif
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 396aea1..fde7700 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -144,6 +144,17 @@ config STACK_TRACER
 	 This tracer records the max stack of the kernel, and displays
 	 it in debugfs/tracing/stack_trace

+config BKL_TRACER
+	bool "Trace Big Kernel Lock latencies"
+	depends on HAVE_FTRACE
+	depends on DEBUG_KERNEL
+	select FTRACE
+	select STACKTRACE
+	help
+	  This tracer records the latencies issued by the Big Kernel Lock.
+	  It traces the time when a task request the bkl, the time when it
+	  acquires it and the time when it releases it.
+
 config DYNAMIC_FTRACE
 	bool "enable/disable ftrace tracepoints dynamically"
 	depends on FTRACE
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index a85dfba..2ba8904 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -24,5 +24,6 @@ obj-$(CONFIG_NOP_TRACER) += trace_nop.o
 obj-$(CONFIG_STACK_TRACER) += trace_stack.o
 obj-$(CONFIG_MMIOTRACE) += trace_mmiotrace.o
 obj-$(CONFIG_BOOT_TRACER) += trace_boot.o
+obj-$(CONFIG_BKL_TRACER) += trace_bkl.o

 libftrace-y := ftrace.o
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 707620c..b1df671 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -8,6 +8,7 @@
 #include <linux/ring_buffer.h>
 #include <linux/mmiotrace.h>
 #include <linux/ftrace.h>
+#include <trace/bkl.h>

 enum trace_type {
 	__TRACE_FIRST_TYPE = 0,
@@ -22,6 +23,8 @@ enum trace_type {
 	TRACE_MMIO_RW,
 	TRACE_MMIO_MAP,
 	TRACE_BOOT,
+	TRACE_BKL_ACQ,
+	TRACE_BKL_REL,

 	__TRACE_LAST_TYPE
 };
@@ -119,6 +122,17 @@ struct trace_boot {
 	struct boot_trace	initcall;
 };

+/* Trace bkl entries */
+struct trace_bkl_acq {
+	struct trace_entry		ent;
+	struct bkl_trace_acquire	bkl_acq;
+};
+
+struct trace_bkl_rel {
+	struct trace_entry		ent;
+	struct bkl_trace_release	bkl_rel;
+};
+
 /*
 * trace_flag_type is an enumeration that holds different
 * states when a trace occurs. These are:
@@ -219,6 +233,10 @@ extern void __ftrace_bad_type(void);
 		IF_ASSIGN(var, ent, struct trace_mmiotrace_map,		\
 			  TRACE_MMIO_MAP);				\
 		IF_ASSIGN(var, ent, struct trace_boot, TRACE_BOOT);     \
+		IF_ASSIGN(var, ent, struct trace_bkl_acq,               \
+			  TRACE_BKL_ACQ);				\
+		IF_ASSIGN(var, ent, struct trace_bkl_rel,		\
+			  TRACE_BKL_REL);				\
 		__ftrace_bad_type();					\
 	} while (0)

diff --git a/kernel/trace/trace_bkl.c b/kernel/trace/trace_bkl.c
new file mode 100644
index 0000000..169ee01
--- /dev/null
+++ b/kernel/trace/trace_bkl.c
@@ -0,0 +1,170 @@
+/*
+ * Ring buffer based Big Kernel Lock tracer
+ * for purpose of measuring the latencies issued
+ * by the BKL.
+ *
+ * Copyright (C) 2008 Frederic Weisbecker <fweisbec@gmail.com>
+ */
+
+#include <trace/bkl.h>
+#include "trace.h"
+#include <linux/ftrace.h>
+
+
+static struct trace_array *bkl_trace;
+static bool bkl_tracer_enabled;
+
+
+static void bkl_trace_init(struct trace_array *tr)
+{
+	int cpu;
+	bkl_trace = tr;
+
+	for_each_cpu_mask(cpu, cpu_possible_map)
+		tracing_reset(tr, cpu);
+
+	if (tr->ctrl)
+		bkl_tracer_enabled = 1;
+}
+
+static void reset_bkl_trace(struct trace_array *tr)
+{
+	bkl_tracer_enabled = 0;
+}
+
+static void bkl_trace_ctrl_update(struct trace_array *tr)
+{
+	if (tr->ctrl)
+		bkl_tracer_enabled = 1;
+	else
+		bkl_tracer_enabled = 0;
+}
+
+static enum print_line_t bkl_acq_print_line(struct trace_iterator *iter)
+{
+	int ret;
+	struct trace_entry *entry = iter->ent;
+	struct trace_bkl_acq *field = (struct trace_bkl_acq *) entry;
+	struct bkl_trace_acquire *bta = &field->bkl_acq;
+	struct trace_seq *s = &iter->seq;
+	unsigned long sec, nsec_rem;
+	unsigned long long wait_for_spin;
+
+	wait_for_spin = bta->acquire_time - bta->acquire_req_time;
+	nsec_rem = do_div(bta->acquire_req_time, 1000000000);
+	sec = (unsigned long) bta->acquire_req_time;
+	ret = trace_seq_printf(s, "Kernel lock requested at %5lu.%09lu ",
+				  sec, nsec_rem);
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	nsec_rem = do_div(bta->acquire_time, 1000000000);
+	sec = (unsigned long) bta->acquire_time;
+	ret = trace_seq_printf(s, "acquired at %5lu.%09lu "
+				  "(waited %llu nsecs)\n",
+				  sec, nsec_rem,
+				  wait_for_spin);
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+	return TRACE_TYPE_HANDLED;
+}
+
+static enum print_line_t bkl_rel_print_line(struct trace_iterator *iter)
+{
+	int ret;
+	struct trace_entry *entry = iter->ent;
+	struct trace_bkl_rel *field = (struct trace_bkl_rel *) entry;
+	struct bkl_trace_release *btr = &field->bkl_rel;
+	struct trace_seq *s = &iter->seq;
+	unsigned long sec, nsec_rem;
+
+	nsec_rem = do_div(btr->release_time, 1000000000);
+	sec = (unsigned long) btr->release_time;
+	ret = trace_seq_printf(s, "Kernel lock released at  %5lu.%09lu\n",
+				  sec, nsec_rem);
+	return TRACE_TYPE_HANDLED;
+}
+
+static enum print_line_t bkl_trace_print_line(struct trace_iterator *iter)
+{
+	struct trace_entry *entry = iter->ent;
+
+	if (entry->type == TRACE_BKL_ACQ)
+		return bkl_acq_print_line(iter);
+	if (entry->type == TRACE_BKL_REL)
+		return bkl_rel_print_line(iter);
+
+	return TRACE_TYPE_UNHANDLED;
+}
+
+static struct tracer bkl_tracer __read_mostly =
+{
+	.name		= "bkl",
+	.init		= bkl_trace_init,
+	.reset		= reset_bkl_trace,
+	.ctrl_update	= bkl_trace_ctrl_update,
+	.print_line	= bkl_trace_print_line,
+};
+
+__init static int init_bkl_tracer(void)
+{
+	return register_tracer(&bkl_tracer);
+}
+device_initcall(init_bkl_tracer);
+
+/*
+ * These functions don't need us to disable
+ * the preemption since it has been done by lock_kernel()
+ */
+
+void trace_bkl_acquire(struct bkl_trace_acquire *trace)
+{
+	struct ring_buffer_event *event;
+	struct trace_bkl_acq *entry;
+	struct trace_array_cpu *data;
+	unsigned long irq_flags;
+	struct trace_array *tr = bkl_trace;
+
+	if (!bkl_tracer_enabled)
+		return;
+
+	data = tr->data[smp_processor_id()];
+
+	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
+					 &irq_flags);
+	if (!event)
+		return;
+	entry = ring_buffer_event_data(event);
+	tracing_generic_entry_update(&entry->ent, 0, 0);
+	entry->ent.type = TRACE_BKL_ACQ;
+	entry->bkl_acq = *trace;
+	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
+
+	trace_wake_up();
+}
+
+void trace_bkl_release(struct bkl_trace_release *trace)
+{
+	struct ring_buffer_event *event;
+	struct trace_bkl_rel *entry;
+	struct trace_array_cpu *data;
+	unsigned long irq_flags;
+	struct trace_array *tr = bkl_trace;
+
+	if (!bkl_tracer_enabled)
+		return;
+
+	data = tr->data[smp_processor_id()];
+
+	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
+					 &irq_flags);
+	if (!event)
+		return;
+	entry   = ring_buffer_event_data(event);
+	tracing_generic_entry_update(&entry->ent, 0, 0);
+	entry->ent.type = TRACE_BKL_REL;
+	entry->bkl_rel = *trace;
+	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
+
+	trace_wake_up();
+}
diff --git a/lib/kernel_lock.c b/lib/kernel_lock.c
index 01a3c22..9987834 100644
--- a/lib/kernel_lock.c
+++ b/lib/kernel_lock.c
@@ -9,6 +9,7 @@
 #include <linux/module.h>
 #include <linux/kallsyms.h>
 #include <linux/semaphore.h>
+#include <trace/bkl.h>

 /*
 * The 'big kernel lock'
@@ -116,16 +117,33 @@ static inline void __unlock_kernel(void)
 void __lockfunc lock_kernel(void)
 {
 	int depth = current->lock_depth+1;
-	if (likely(!depth))
+	if (likely(!depth)) {
+#ifdef CONFIG_BKL_TRACER
+		struct bkl_trace_acquire trace;
+		preempt_disable();
+		trace.acquire_req_time = cpu_clock(raw_smp_processor_id());
+		preempt_enable();
 		__lock_kernel();
+		trace.acquire_time = cpu_clock(raw_smp_processor_id());
+		trace_bkl_acquire(&trace);
+#else
+		__lock_kernel();
+#endif
+	}
 	current->lock_depth = depth;
 }

 void __lockfunc unlock_kernel(void)
 {
 	BUG_ON(current->lock_depth < 0);
-	if (likely(--current->lock_depth < 0))
+	if (likely(--current->lock_depth < 0)) {
+#ifdef CONFIG_BKL_TRACER
+		struct bkl_trace_release trace;
+		trace.release_time = cpu_clock(raw_smp_processor_id());
+		trace_bkl_release(&trace);
+#endif
 		__unlock_kernel();
+	}
 }

 EXPORT_SYMBOL(lock_kernel);
