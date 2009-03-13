Return-Path: <linux-kernel-owner+w=401wt.eu-S1758626AbZCMJtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758626AbZCMJtb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 05:49:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757101AbZCMJtD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 05:49:03 -0400
Received: from mga09.intel.com ([134.134.136.24]:31406 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055AbZCMJtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 05:49:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,356,1233561600"; 
   d="scan'208";a="394218134"
Date: Fri, 13 Mar 2009 10:48:52 +0100
From: Markus Metzger <markus.t.metzger@intel.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com, roland@redhat.com,
       eranian@googlemail.com, oleg@redhat.com, juan.villacis@intel.com,
       ak@linux.jf.intel.com
Subject: [patch 4/5] x86, hw-branch-tracer: keep resources on stop
Message-ID: <20090313104852.A30168@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Distinguish init/reset and start/stop:
init/reset will allocate and release bts tracing resources
stop/start will suspend and resume bts tracing

Return an error on init() if no cpu can be traced.


Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: gits/kernel/trace/trace_hw_branches.c
===================================================================
--- gits.orig/kernel/trace/trace_hw_branches.c	2009-03-09 10:53:20.000000000 +0100
+++ gits/kernel/trace/trace_hw_branches.c	2009-03-09 10:58:41.000000000 +0100
@@ -19,7 +19,7 @@
 #include "trace_output.h"
 
 
-#define SIZEOF_BTS (1 << 13)
+#define BTS_BUFFER_SIZE (1 << 13)
 
 /*
  * The tracer lock protects the below per-cpu tracer array.
@@ -33,53 +33,68 @@
  */
 static DEFINE_SPINLOCK(bts_tracer_lock);
 static DEFINE_PER_CPU(struct bts_tracer *, tracer);
-static DEFINE_PER_CPU(unsigned char[SIZEOF_BTS], buffer);
+static DEFINE_PER_CPU(unsigned char[BTS_BUFFER_SIZE], buffer);
 
 #define this_tracer per_cpu(tracer, smp_processor_id())
 #define this_buffer per_cpu(buffer, smp_processor_id())
 
-static int __read_mostly trace_hw_branches_enabled;
+static int trace_hw_branches_enabled __read_mostly;
+static int trace_hw_branches_suspended __read_mostly;
 static struct trace_array *hw_branch_trace __read_mostly;
 
 
 /*
- * Start tracing on the current cpu.
+ * Initialize the tracer for the current cpu.
  * The argument is ignored.
  *
  * pre: bts_tracer_lock must be locked.
  */
-static void bts_trace_start_cpu(void *arg)
+static void bts_trace_init_cpu(void *arg)
 {
 	if (this_tracer)
 		ds_release_bts(this_tracer);
 
-	this_tracer =
-		ds_request_bts(/* task = */ NULL, this_buffer, SIZEOF_BTS,
-			       /* ovfl = */ NULL, /* th = */ (size_t)-1,
-			       BTS_KERNEL);
+	this_tracer = ds_request_bts(NULL, this_buffer, BTS_BUFFER_SIZE,
+				     NULL, (size_t)-1, BTS_KERNEL);
 	if (IS_ERR(this_tracer)) {
 		this_tracer = NULL;
 		return;
 	}
 }
 
-static void bts_trace_start(struct trace_array *tr)
+static int bts_trace_init(struct trace_array *tr)
 {
+	int cpu, avail;
+
 	spin_lock(&bts_tracer_lock);
 
-	on_each_cpu(bts_trace_start_cpu, NULL, 1);
-	trace_hw_branches_enabled = 1;
+	hw_branch_trace = tr;
+
+	on_each_cpu(bts_trace_init_cpu, NULL, 1);
+
+	/* Check on how many cpus we could enable tracing */
+	avail = 0;
+	for_each_online_cpu(cpu)
+		if (per_cpu(tracer, cpu))
+			avail++;
+
+	trace_hw_branches_enabled = (avail ? 1 : 0);
+	trace_hw_branches_suspended = 0;
 
 	spin_unlock(&bts_tracer_lock);
+
+
+	/* If we could not enable tracing on a single cpu, we fail. */
+	return avail ? 0 : -EOPNOTSUPP;
 }
 
 /*
- * Stop tracing on the current cpu.
+ * Release the tracer for the current cpu.
  * The argument is ignored.
  *
  * pre: bts_tracer_lock must be locked.
  */
-static void bts_trace_stop_cpu(void *arg)
+static void bts_trace_release_cpu(void *arg)
 {
 	if (this_tracer) {
 		ds_release_bts(this_tracer);
@@ -87,12 +102,57 @@ static void bts_trace_stop_cpu(void *arg
 	}
 }
 
-static void bts_trace_stop(struct trace_array *tr)
+static void bts_trace_reset(struct trace_array *tr)
 {
 	spin_lock(&bts_tracer_lock);
 
+	on_each_cpu(bts_trace_release_cpu, NULL, 1);
 	trace_hw_branches_enabled = 0;
-	on_each_cpu(bts_trace_stop_cpu, NULL, 1);
+	trace_hw_branches_suspended = 0;
+
+	spin_unlock(&bts_tracer_lock);
+}
+
+/*
+ * Resume tracing on the current cpu.
+ * The argument is ignored.
+ *
+ * pre: bts_tracer_lock must be locked.
+ */
+static void bts_trace_resume_cpu(void *arg)
+{
+	if (this_tracer)
+		ds_resume_bts(this_tracer);
+}
+
+static void bts_trace_start(struct trace_array *tr)
+{
+	spin_lock(&bts_tracer_lock);
+
+	on_each_cpu(bts_trace_resume_cpu, NULL, 1);
+	trace_hw_branches_suspended = 0;
+
+	spin_unlock(&bts_tracer_lock);
+}
+
+/*
+ * Suspend tracing on the current cpu.
+ * The argument is ignored.
+ *
+ * pre: bts_tracer_lock must be locked.
+ */
+static void bts_trace_suspend_cpu(void *arg)
+{
+	if (this_tracer)
+		ds_suspend_bts(this_tracer);
+}
+
+static void bts_trace_stop(struct trace_array *tr)
+{
+	spin_lock(&bts_tracer_lock);
+
+	on_each_cpu(bts_trace_suspend_cpu, NULL, 1);
+	trace_hw_branches_suspended = 1;
 
 	spin_unlock(&bts_tracer_lock);
 }
@@ -110,10 +170,14 @@ static int __cpuinit bts_hotcpu_handler(
 	switch (action) {
 	case CPU_ONLINE:
 	case CPU_DOWN_FAILED:
-		smp_call_function_single(cpu, bts_trace_start_cpu, NULL, 1);
+		smp_call_function_single(cpu, bts_trace_init_cpu, NULL, 1);
+
+		if (trace_hw_branches_suspended)
+			smp_call_function_single(cpu, bts_trace_suspend_cpu,
+						 NULL, 1);
 		break;
 	case CPU_DOWN_PREPARE:
-		smp_call_function_single(cpu, bts_trace_stop_cpu, NULL, 1);
+		smp_call_function_single(cpu, bts_trace_release_cpu, NULL, 1);
 		break;
 	}
 
@@ -126,20 +190,6 @@ static struct notifier_block bts_hotcpu_
 	.notifier_call = bts_hotcpu_handler
 };
 
-static int bts_trace_init(struct trace_array *tr)
-{
-	hw_branch_trace = tr;
-
-	bts_trace_start(tr);
-
-	return 0;
-}
-
-static void bts_trace_reset(struct trace_array *tr)
-{
-	bts_trace_stop(tr);
-}
-
 static void bts_trace_print_header(struct seq_file *m)
 {
 	seq_puts(m, "# CPU#        TO  <-  FROM\n");
@@ -228,7 +278,7 @@ static void trace_bts_at(const struct bt
  */
 static void trace_bts_cpu(void *arg)
 {
-	struct trace_array *tr = (struct trace_array *) arg;
+	struct trace_array *tr = (struct trace_array *)arg;
 	const struct bts_trace *trace;
 	unsigned char *at;
 
@@ -276,7 +326,8 @@ void trace_hw_branch_oops(void)
 {
 	spin_lock(&bts_tracer_lock);
 
-	trace_bts_cpu(hw_branch_trace);
+	if (trace_hw_branches_enabled)
+		trace_bts_cpu(hw_branch_trace);
 
 	spin_unlock(&bts_tracer_lock);
 }
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

