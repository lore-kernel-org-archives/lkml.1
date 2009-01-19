Return-Path: <linux-kernel-owner+w=401wt.eu-S1758265AbZASJ1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758265AbZASJ1U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 04:27:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754556AbZASJ1D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 04:27:03 -0500
Received: from mga14.intel.com ([143.182.124.37]:21705 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754028AbZASJ1A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 04:27:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,288,1231142400"; 
   d="scan'208";a="101426329"
Date: Mon, 19 Jan 2009 10:26:53 +0100
From: Markus Metzger <markus.t.metzger@intel.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com,
       srostedt@redhat.com
Subject: [patch 1/6] x86, ftrace, hw-branch-tracer: support hotplug cpus
Message-ID: <20090119102653.A18774@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support hotplug cpus.

Reported-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: ftrace/kernel/trace/trace_hw_branches.c
===================================================================
--- ftrace.orig/kernel/trace/trace_hw_branches.c	2009-01-16 15:52:35.000000000 +0100
+++ ftrace/kernel/trace/trace_hw_branches.c	2009-01-16 15:53:40.000000000 +0100
@@ -1,7 +1,8 @@
 /*
  * h/w branch tracer for x86 based on bts
  *
- * Copyright (C) 2008 Markus Metzger <markus.t.metzger@gmail.com>
+ * Copyright (C) 2008-2009 Intel Corporation.
+ * Markus Metzger <markus.t.metzger@gmail.com>, 2008-2009
  *
  */
 
@@ -10,6 +11,9 @@
 #include <linux/debugfs.h>
 #include <linux/ftrace.h>
 #include <linux/kallsyms.h>
+#include <linux/mutex.h>
+#include <linux/cpu.h>
+#include <linux/smp.h>
 
 #include <asm/ds.h>
 
@@ -18,13 +22,31 @@
 
 #define SIZEOF_BTS (1 << 13)
 
+/* The tracer mutex protects the below per-cpu tracer array.
+   It needs to be held to:
+   - start tracing on all cpus
+   - stop tracing on all cpus
+   - start tracing on a single hotplug cpu
+   - stop tracing on a single hotplug cpu
+   - read the trace from all cpus
+   - read the trace from a single cpu
+*/
+static DEFINE_MUTEX(bts_tracer_mutex);
 static DEFINE_PER_CPU(struct bts_tracer *, tracer);
 static DEFINE_PER_CPU(unsigned char[SIZEOF_BTS], buffer);
 
 #define this_tracer per_cpu(tracer, smp_processor_id())
 #define this_buffer per_cpu(buffer, smp_processor_id())
 
+static int __read_mostly trace_hw_branches_enabled;
 
+
+/*
+ * Start tracing on the current cpu.
+ * The argument is ignored.
+ *
+ * pre: bts_tracer_mutex must be locked.
+ */
 static void bts_trace_start_cpu(void *arg)
 {
 	if (this_tracer)
@@ -42,14 +64,20 @@
 
 static void bts_trace_start(struct trace_array *tr)
 {
-	int cpu;
+	mutex_lock(&bts_tracer_mutex);
 
-	tracing_reset_online_cpus(tr);
+	on_each_cpu(bts_trace_start_cpu, NULL, 1);
+	trace_hw_branches_enabled = 1;
 
-	for_each_cpu_mask(cpu, cpu_possible_map)
-		smp_call_function_single(cpu, bts_trace_start_cpu, NULL, 1);
+	mutex_unlock(&bts_tracer_mutex);
 }
 
+/*
+ * Start tracing on the current cpu.
+ * The argument is ignored.
+ *
+ * pre: bts_tracer_mutex must be locked.
+ */
 static void bts_trace_stop_cpu(void *arg)
 {
 	if (this_tracer) {
@@ -60,20 +88,58 @@
 
 static void bts_trace_stop(struct trace_array *tr)
 {
-	int cpu;
+	mutex_lock(&bts_tracer_mutex);
+
+	trace_hw_branches_enabled = 0;
+	on_each_cpu(bts_trace_stop_cpu, NULL, 1);
 
-	for_each_cpu_mask(cpu, cpu_possible_map)
+	mutex_unlock(&bts_tracer_mutex);
+}
+
+static int __cpuinit bts_hotcpu_handler(struct notifier_block *nfb,
+				     unsigned long action, void *hcpu)
+{
+	unsigned int cpu = (unsigned long)hcpu;
+
+	mutex_lock(&bts_tracer_mutex);
+
+	if (!trace_hw_branches_enabled)
+		goto out;
+
+	switch (action) {
+	case CPU_ONLINE:
+	case CPU_DOWN_FAILED:
+		smp_call_function_single(cpu, bts_trace_start_cpu, NULL, 1);
+		break;
+	case CPU_DOWN_PREPARE:
 		smp_call_function_single(cpu, bts_trace_stop_cpu, NULL, 1);
+		break;
+	}
+
+ out:
+	mutex_unlock(&bts_tracer_mutex);
+	return NOTIFY_DONE;
 }
 
+static struct notifier_block bts_hotcpu_notifier __cpuinitdata = {
+	.notifier_call = bts_hotcpu_handler
+};
+
 static int bts_trace_init(struct trace_array *tr)
 {
+	register_hotcpu_notifier(&bts_hotcpu_notifier);
 	tracing_reset_online_cpus(tr);
 	bts_trace_start(tr);
 
 	return 0;
 }
 
+static void bts_trace_reset(struct trace_array *tr)
+{
+	bts_trace_stop(tr);
+	unregister_hotcpu_notifier(&bts_hotcpu_notifier);
+}
+
 static void bts_trace_print_header(struct seq_file *m)
 {
 	seq_puts(m,
@@ -107,18 +173,34 @@
 {
 	struct ring_buffer_event *event;
 	struct hw_branch_entry *entry;
-	unsigned long irq;
+	unsigned long irq1, irq2;
+	int cpu;
 
-	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry), &irq);
-	if (!event)
+	if (unlikely(!tr))
+		return;
+
+	if (unlikely(!trace_hw_branches_enabled))
 		return;
+
+	local_irq_save(irq1);
+	cpu = raw_smp_processor_id();
+	if (atomic_inc_return(&tr->data[cpu]->disabled) != 1)
+		goto out;
+
+	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry), &irq2);
+	if (!event)
+		goto out;
 	entry	= ring_buffer_event_data(event);
 	tracing_generic_entry_update(&entry->ent, 0, from);
 	entry->ent.type = TRACE_HW_BRANCHES;
-	entry->ent.cpu = smp_processor_id();
+	entry->ent.cpu = cpu;
 	entry->from = from;
 	entry->to   = to;
-	ring_buffer_unlock_commit(tr->buffer, event, irq);
+	ring_buffer_unlock_commit(tr->buffer, event, irq2);
+
+ out:
+	atomic_dec(&tr->data[cpu]->disabled);
+	local_irq_restore(irq1);
 }
 
 static void trace_bts_at(struct trace_array *tr,
@@ -142,6 +224,11 @@
 	}
 }
 
+/*
+ * Collect the trace on the current cpu and write it into the ftrace buffer.
+ *
+ * pre: bts_tracer_mutex must be locked
+ */
 static void trace_bts_cpu(void *arg)
 {
 	struct trace_array *tr = (struct trace_array *) arg;
@@ -151,6 +238,9 @@
 	if (!this_tracer)
 		return;
 
+	if (unlikely(atomic_read(&tr->data[raw_smp_processor_id()]->disabled)))
+		return;
+
 	ds_suspend_bts(this_tracer);
 	trace = ds_read_bts(this_tracer);
 	if (!trace)
@@ -170,17 +260,18 @@
 
 static void trace_bts_prepare(struct trace_iterator *iter)
 {
-	int cpu;
+	mutex_lock(&bts_tracer_mutex);
+
+	on_each_cpu(trace_bts_cpu, iter->tr, 1);
 
-	for_each_cpu_mask(cpu, cpu_possible_map)
-		smp_call_function_single(cpu, trace_bts_cpu, iter->tr, 1);
+	mutex_unlock(&bts_tracer_mutex);
 }
 
 struct tracer bts_tracer __read_mostly =
 {
 	.name		= "hw-branch-tracer",
 	.init		= bts_trace_init,
-	.reset		= bts_trace_stop,
+	.reset		= bts_trace_reset,
 	.print_header	= bts_trace_print_header,
 	.print_line	= bts_trace_print_line,
 	.start		= bts_trace_start,
---------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen Germany
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 Ust.-IdNr.
VAT Registration No.: DE129385895
Citibank Frankfurt (BLZ 502 109 00) 600119052

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

