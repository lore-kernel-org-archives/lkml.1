Return-Path: <linux-kernel-owner+w=401wt.eu-S1758753AbZCaNWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758753AbZCaNWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 09:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756881AbZCaNWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 09:22:05 -0400
Received: from mga03.intel.com ([143.182.124.21]:4648 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754129AbZCaNWC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 09:22:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,453,1233561600"; 
   d="scan'208";a="126096221"
Date: Tue, 31 Mar 2009 15:21:48 +0200
From: Markus Metzger <markus.t.metzger@intel.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com, roland@redhat.com,
       eranian@googlemail.com, oleg@redhat.com, juan.villacis@intel.com,
       ak@linux.jf.intel.com
Subject: [patch 9/21] x86, hw-branch-tracer: use new debug store interface
Message-ID: <20090331152148.A13092@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the hw-branch-tracer use the new debug store interface introduced in
patch 7.

Remove the unnecessary spinlock.


Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: git-tip/kernel/trace/trace_hw_branches.c
===================================================================
--- git-tip.orig/kernel/trace/trace_hw_branches.c	2009-03-30 13:31:09.000000000 +0200
+++ git-tip/kernel/trace/trace_hw_branches.c	2009-03-30 19:00:53.000000000 +0200
@@ -4,7 +4,6 @@
  * Copyright (C) 2008-2009 Intel Corporation.
  * Markus Metzger <markus.t.metzger@gmail.com>, 2008-2009
  */
-#include <linux/spinlock.h>
 #include <linux/kallsyms.h>
 #include <linux/debugfs.h>
 #include <linux/ftrace.h>
@@ -21,168 +20,108 @@
 
 #define BTS_BUFFER_SIZE (1 << 13)
 
-/*
- * The tracer lock protects the below per-cpu tracer array.
- * It needs to be held to:
- * - start tracing on all cpus
- * - stop tracing on all cpus
- * - start tracing on a single hotplug cpu
- * - stop tracing on a single hotplug cpu
- * - read the trace from all cpus
- * - read the trace from a single cpu
- */
-static DEFINE_SPINLOCK(bts_tracer_lock);
 static DEFINE_PER_CPU(struct bts_tracer *, tracer);
 static DEFINE_PER_CPU(unsigned char[BTS_BUFFER_SIZE], buffer);
 
 #define this_tracer per_cpu(tracer, smp_processor_id())
-#define this_buffer per_cpu(buffer, smp_processor_id())
 
 static int trace_hw_branches_enabled __read_mostly;
 static int trace_hw_branches_suspended __read_mostly;
 static struct trace_array *hw_branch_trace __read_mostly;
 
 
-/*
- * Initialize the tracer for the current cpu.
- * The argument is ignored.
- *
- * pre: bts_tracer_lock must be locked.
- */
-static void bts_trace_init_cpu(void *arg)
+static void bts_trace_init_cpu(int cpu)
 {
-	if (this_tracer)
-		ds_release_bts(this_tracer);
+	per_cpu(tracer, cpu) =
+		ds_request_bts_cpu(cpu, per_cpu(buffer, cpu), BTS_BUFFER_SIZE,
+				   NULL, (size_t)-1, BTS_KERNEL);
 
-	this_tracer = ds_request_bts(NULL, this_buffer, BTS_BUFFER_SIZE,
-				     NULL, (size_t)-1, BTS_KERNEL);
-	if (IS_ERR(this_tracer)) {
-		this_tracer = NULL;
-		return;
-	}
+	if (IS_ERR(per_cpu(tracer, cpu)))
+		per_cpu(tracer, cpu) = NULL;
 }
 
 static int bts_trace_init(struct trace_array *tr)
 {
-	int cpu, avail;
-
-	spin_lock(&bts_tracer_lock);
+	int cpu;
 
 	hw_branch_trace = tr;
+	trace_hw_branches_enabled = 0;
 
-	on_each_cpu(bts_trace_init_cpu, NULL, 1);
+	get_online_cpus();
+	for_each_online_cpu(cpu) {
+		bts_trace_init_cpu(cpu);
 
-	/* Check on how many cpus we could enable tracing */
-	avail = 0;
-	for_each_online_cpu(cpu)
 		if (per_cpu(tracer, cpu))
-			avail++;
-
-	trace_hw_branches_enabled = (avail ? 1 : 0);
+			trace_hw_branches_enabled = 1;
+	}
 	trace_hw_branches_suspended = 0;
-
-	spin_unlock(&bts_tracer_lock);
-
+	put_online_cpus();
 
 	/* If we could not enable tracing on a single cpu, we fail. */
-	return avail ? 0 : -EOPNOTSUPP;
-}
-
-/*
- * Release the tracer for the current cpu.
- * The argument is ignored.
- *
- * pre: bts_tracer_lock must be locked.
- */
-static void bts_trace_release_cpu(void *arg)
-{
-	if (this_tracer) {
-		ds_release_bts(this_tracer);
-		this_tracer = NULL;
-	}
+	return trace_hw_branches_enabled ? 0 : -EOPNOTSUPP;
 }
 
 static void bts_trace_reset(struct trace_array *tr)
 {
-	spin_lock(&bts_tracer_lock);
+	int cpu;
 
-	on_each_cpu(bts_trace_release_cpu, NULL, 1);
+	get_online_cpus();
+	for_each_online_cpu(cpu) {
+		ds_release_bts(per_cpu(tracer, cpu));
+		per_cpu(tracer, cpu) = NULL;
+	}
 	trace_hw_branches_enabled = 0;
 	trace_hw_branches_suspended = 0;
-
-	spin_unlock(&bts_tracer_lock);
-}
-
-/*
- * Resume tracing on the current cpu.
- * The argument is ignored.
- *
- * pre: bts_tracer_lock must be locked.
- */
-static void bts_trace_resume_cpu(void *arg)
-{
-	if (this_tracer)
-		ds_resume_bts(this_tracer);
+	put_online_cpus();
 }
 
 static void bts_trace_start(struct trace_array *tr)
 {
-	spin_lock(&bts_tracer_lock);
+	int cpu;
 
-	on_each_cpu(bts_trace_resume_cpu, NULL, 1);
+	get_online_cpus();
+	for_each_online_cpu(cpu)
+		if (per_cpu(tracer, cpu))
+			ds_resume_bts(per_cpu(tracer, cpu));
 	trace_hw_branches_suspended = 0;
-
-	spin_unlock(&bts_tracer_lock);
-}
-
-/*
- * Suspend tracing on the current cpu.
- * The argument is ignored.
- *
- * pre: bts_tracer_lock must be locked.
- */
-static void bts_trace_suspend_cpu(void *arg)
-{
-	if (this_tracer)
-		ds_suspend_bts(this_tracer);
+	put_online_cpus();
 }
 
 static void bts_trace_stop(struct trace_array *tr)
 {
-	spin_lock(&bts_tracer_lock);
+	int cpu;
 
-	on_each_cpu(bts_trace_suspend_cpu, NULL, 1);
+	get_online_cpus();
+	for_each_online_cpu(cpu)
+		if (per_cpu(tracer, cpu))
+			ds_suspend_bts(per_cpu(tracer, cpu));
 	trace_hw_branches_suspended = 1;
-
-	spin_unlock(&bts_tracer_lock);
+	put_online_cpus();
 }
 
 static int __cpuinit bts_hotcpu_handler(struct notifier_block *nfb,
 				     unsigned long action, void *hcpu)
 {
-	unsigned int cpu = (unsigned long)hcpu;
-
-	spin_lock(&bts_tracer_lock);
-
-	if (!trace_hw_branches_enabled)
-		goto out;
+	int cpu = (long)hcpu;
 
 	switch (action) {
 	case CPU_ONLINE:
 	case CPU_DOWN_FAILED:
-		smp_call_function_single(cpu, bts_trace_init_cpu, NULL, 1);
-
-		if (trace_hw_branches_suspended)
-			smp_call_function_single(cpu, bts_trace_suspend_cpu,
-						 NULL, 1);
+		/* The notification is sent with interrupts enabled. */
+		if (trace_hw_branches_enabled) {
+			bts_trace_init_cpu(cpu);
+
+			if (trace_hw_branches_suspended)
+				ds_suspend_bts(per_cpu(tracer, cpu));
+		}
 		break;
+
 	case CPU_DOWN_PREPARE:
-		smp_call_function_single(cpu, bts_trace_release_cpu, NULL, 1);
-		break;
+		/* The notification is sent with interrupts enabled. */
+		ds_release_bts(per_cpu(tracer, cpu));
+		per_cpu(tracer, cpu) = NULL;
 	}
 
- out:
-	spin_unlock(&bts_tracer_lock);
 	return NOTIFY_DONE;
 }
 
@@ -274,7 +213,7 @@ static void trace_bts_at(const struct bt
 /*
  * Collect the trace on the current cpu and write it into the ftrace buffer.
  *
- * pre: bts_tracer_lock must be locked
+ * pre: tracing must be suspended on the current cpu
  */
 static void trace_bts_cpu(void *arg)
 {
@@ -291,10 +230,9 @@ static void trace_bts_cpu(void *arg)
 	if (unlikely(!this_tracer))
 		return;
 
-	ds_suspend_bts(this_tracer);
 	trace = ds_read_bts(this_tracer);
 	if (!trace)
-		goto out;
+		return;
 
 	for (at = trace->ds.top; (void *)at < trace->ds.end;
 	     at += trace->ds.size)
@@ -303,18 +241,25 @@ static void trace_bts_cpu(void *arg)
 	for (at = trace->ds.begin; (void *)at < trace->ds.top;
 	     at += trace->ds.size)
 		trace_bts_at(trace, at);
-
-out:
-	ds_resume_bts(this_tracer);
 }
 
 static void trace_bts_prepare(struct trace_iterator *iter)
 {
-	spin_lock(&bts_tracer_lock);
+	int cpu;
 
+	get_online_cpus();
+	for_each_online_cpu(cpu)
+		ds_suspend_bts(per_cpu(tracer, cpu));
+	/*
+	 * We need to collect the trace on the respective cpu since ftrace
+	 * implicitly adds the record for the current cpu.
+	 * Once that is more flexible, we could collect the data from any cpu.
+	 */
 	on_each_cpu(trace_bts_cpu, iter->tr, 1);
 
-	spin_unlock(&bts_tracer_lock);
+	for_each_online_cpu(cpu)
+		ds_resume_bts(per_cpu(tracer, cpu));
+	put_online_cpus();
 }
 
 static void trace_bts_close(struct trace_iterator *iter)
@@ -324,12 +269,11 @@ static void trace_bts_close(struct trace
 
 void trace_hw_branch_oops(void)
 {
-	spin_lock(&bts_tracer_lock);
-
-	if (trace_hw_branches_enabled)
+	if (this_tracer) {
+		ds_suspend_bts_noirq(this_tracer);
 		trace_bts_cpu(hw_branch_trace);
-
-	spin_unlock(&bts_tracer_lock);
+		ds_resume_bts_noirq(this_tracer);
+	}
 }
 
 struct tracer bts_tracer __read_mostly =
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

