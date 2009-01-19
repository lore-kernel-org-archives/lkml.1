Return-Path: <linux-kernel-owner+w=401wt.eu-S1758684AbZASJbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758684AbZASJbU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 04:31:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755405AbZASJbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 04:31:09 -0500
Received: from mga09.intel.com ([134.134.136.24]:50481 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755071AbZASJbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 04:31:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,288,1231142400"; 
   d="scan'208";a="482778147"
Date: Mon, 19 Jan 2009 10:31:01 +0100
From: Markus Metzger <markus.t.metzger@intel.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com,
       srostedt@redhat.com
Subject: [patch 3/6] x86, ftrace, hw-branch-tracer: dump trace on oops
Message-ID: <20090119103101.A18811@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dump the branch trace on an oops (based on ftrace_dump_on_oops).

Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: ftrace/arch/x86/kernel/dumpstack.c
===================================================================
--- ftrace.orig/arch/x86/kernel/dumpstack.c	2009-01-16 15:52:35.000000000 +0100
+++ ftrace/arch/x86/kernel/dumpstack.c	2009-01-16 16:19:36.000000000 +0100
@@ -14,6 +14,7 @@
 #include <linux/bug.h>
 #include <linux/nmi.h>
 #include <linux/sysfs.h>
+#include <linux/ftrace.h>
 
 #include <asm/stacktrace.h>
 
@@ -195,6 +196,11 @@
 	int cpu;
 	unsigned long flags;
 
+	/* notify the hw-branch tracer so it may disable tracing and
+	   add the last trace to the trace buffer -
+	   the earlier this happens, the more useful the trace. */
+	trace_hw_branch_oops();
+
 	oops_enter();
 
 	/* racy, but better than risking deadlock. */
Index: ftrace/kernel/trace/trace.h
===================================================================
--- ftrace.orig/kernel/trace/trace.h	2009-01-16 15:52:35.000000000 +0100
+++ ftrace/kernel/trace/trace.h	2009-01-16 16:19:36.000000000 +0100
@@ -415,7 +415,6 @@
 
 void trace_graph_return(struct ftrace_graph_ret *trace);
 int trace_graph_entry(struct ftrace_graph_ent *trace);
-void trace_hw_branch(struct trace_array *tr, u64 from, u64 to);
 
 void tracing_start_cmdline_record(void);
 void tracing_stop_cmdline_record(void);
Index: ftrace/kernel/trace/trace_hw_branches.c
===================================================================
--- ftrace.orig/kernel/trace/trace_hw_branches.c	2009-01-16 16:19:35.000000000 +0100
+++ ftrace/kernel/trace/trace_hw_branches.c	2009-01-16 16:20:04.000000000 +0100
@@ -39,6 +39,7 @@
 #define this_buffer per_cpu(buffer, smp_processor_id())
 
 static int __read_mostly trace_hw_branches_enabled;
+static struct trace_array *hw_branch_trace __read_mostly;
 
 
 /*
@@ -127,6 +128,8 @@
 
 static int bts_trace_init(struct trace_array *tr)
 {
+	hw_branch_trace = tr;
+
 	register_hotcpu_notifier(&bts_hotcpu_notifier);
 	tracing_reset_online_cpus(tr);
 	bts_trace_start(tr);
@@ -166,8 +169,9 @@
 	return TRACE_TYPE_UNHANDLED;
 }
 
-void trace_hw_branch(struct trace_array *tr, u64 from, u64 to)
+void trace_hw_branch(u64 from, u64 to)
 {
+	struct trace_array *tr = hw_branch_trace;
 	struct ring_buffer_event *event;
 	struct hw_branch_entry *entry;
 	unsigned long irq1, irq2;
@@ -200,8 +204,7 @@
 	local_irq_restore(irq1);
 }
 
-static void trace_bts_at(struct trace_array *tr,
-			 const struct bts_trace *trace, void *at)
+static void trace_bts_at(const struct bts_trace *trace, void *at)
 {
 	struct bts_struct bts;
 	int err = 0;
@@ -216,7 +219,7 @@
 
 	switch (bts.qualifier) {
 	case BTS_BRANCH:
-		trace_hw_branch(tr, bts.variant.lbr.from, bts.variant.lbr.to);
+		trace_hw_branch(bts.variant.lbr.from, bts.variant.lbr.to);
 		break;
 	}
 }
@@ -232,12 +235,15 @@
 	const struct bts_trace *trace;
 	unsigned char *at;
 
-	if (!this_tracer)
+	if (unlikely(!tr))
 		return;
 
 	if (unlikely(atomic_read(&tr->data[raw_smp_processor_id()]->disabled)))
 		return;
 
+	if (unlikely(!this_tracer))
+		return;
+
 	ds_suspend_bts(this_tracer);
 	trace = ds_read_bts(this_tracer);
 	if (!trace)
@@ -245,11 +251,11 @@
 
 	for (at = trace->ds.top; (void *)at < trace->ds.end;
 	     at += trace->ds.size)
-		trace_bts_at(tr, trace, at);
+		trace_bts_at(trace, at);
 
 	for (at = trace->ds.begin; (void *)at < trace->ds.top;
 	     at += trace->ds.size)
-		trace_bts_at(tr, trace, at);
+		trace_bts_at(trace, at);
 
 out:
 	ds_resume_bts(this_tracer);
@@ -264,6 +270,15 @@
 	mutex_unlock(&bts_tracer_mutex);
 }
 
+void trace_hw_branch_oops(void)
+{
+	mutex_lock(&bts_tracer_mutex);
+
+	trace_bts_cpu(hw_branch_trace);
+
+	mutex_unlock(&bts_tracer_mutex);
+}
+
 struct tracer bts_tracer __read_mostly =
 {
 	.name		= "hw-branch-tracer",
Index: ftrace/include/linux/ftrace.h
===================================================================
--- ftrace.orig/include/linux/ftrace.h	2009-01-16 15:52:35.000000000 +0100
+++ ftrace/include/linux/ftrace.h	2009-01-16 16:19:36.000000000 +0100
@@ -492,4 +492,17 @@
 
 #endif /* CONFIG_TRACING */
 
+
+#ifdef CONFIG_HW_BRANCH_TRACER
+
+void trace_hw_branch(u64 from, u64 to);
+void trace_hw_branch_oops(void);
+
+#else /* CONFIG_HW_BRANCH_TRACER */
+
+static inline void trace_hw_branch(u64 from, u64 to) {}
+static inline void trace_hw_branch_oops(void) {}
+
+#endif /* CONFIG_HW_BRANCH_TRACER */
+
 #endif /* _LINUX_FTRACE_H */
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

