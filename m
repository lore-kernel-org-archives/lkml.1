Return-Path: <linux-kernel-owner+w=401wt.eu-S1758609AbZCMLC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758609AbZCMLC0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 07:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758084AbZCMLBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 07:01:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:38998 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756758AbZCMLBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 07:01:32 -0400
Date: Fri, 13 Mar 2009 11:00:58 GMT
From: Markus Metzger <markus.t.metzger@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       markus.t.metzger@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       markus.t.metzger@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090313104852.A30168@sedona.ch.intel.com>
References: <20090313104852.A30168@sedona.ch.intel.com>
Subject: [tip:tracing/hw-branch-tracing] x86, hw-branch-tracer: keep resources on stop
Message-ID: <tip-ba9372a8f306c4e53a5f61dcbcd6c1e4a8c2e9ac@git.kernel.org>
Git-Commit-ID: ba9372a8f306c4e53a5f61dcbcd6c1e4a8c2e9ac
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 13 Mar 2009 11:01:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ba9372a8f306c4e53a5f61dcbcd6c1e4a8c2e9ac
Gitweb:     http://git.kernel.org/tip/ba9372a8f306c4e53a5f61dcbcd6c1e4a8c2e9ac
Author:     Markus Metzger <markus.t.metzger@intel.com>
AuthorDate: Fri, 13 Mar 2009 10:48:52 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 13 Mar 2009 11:57:21 +0100

x86, hw-branch-tracer: keep resources on stop

Distinguish init/reset and start/stop:

init/reset will allocate and release bts tracing resources
stop/start will suspend and resume bts tracing

Return an error on init() if no cpu can be traced.

Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
LKML-Reference: <20090313104852.A30168@sedona.ch.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace_hw_branches.c |  119 +++++++++++++++++++++++++++-----------
 1 files changed, 85 insertions(+), 34 deletions(-)

diff --git a/kernel/trace/trace_hw_branches.c b/kernel/trace/trace_hw_branches.c
index 7bfdf4c..a99a04c 100644
--- a/kernel/trace/trace_hw_branches.c
+++ b/kernel/trace/trace_hw_branches.c
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
@@ -87,12 +102,57 @@ static void bts_trace_stop_cpu(void *arg)
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
@@ -110,10 +170,14 @@ static int __cpuinit bts_hotcpu_handler(struct notifier_block *nfb,
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
 
@@ -126,20 +190,6 @@ static struct notifier_block bts_hotcpu_notifier __cpuinitdata = {
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
@@ -228,7 +278,7 @@ static void trace_bts_at(const struct bts_trace *trace, void *at)
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
