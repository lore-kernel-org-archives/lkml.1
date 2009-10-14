Return-Path: <linux-kernel-owner+w=401wt.eu-S1754094AbZJNGD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbZJNGD0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 02:03:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753683AbZJNGD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 02:03:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:58672 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753472AbZJNGDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 02:03:23 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de,
       akpm@linux-foundation.org, rostedt@goodmis.org, hpa@zytor.com,
       cebbert@redhat.com
Cc: Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 05/16] percpu: make percpu symbols in tracer unique
Date: Wed, 14 Oct 2009 15:01:54 +0900
Message-Id: <1255500125-3210-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1255500125-3210-1-git-send-email-tj@kernel.org>
References: <1255500125-3210-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 06:02:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates percpu related symbols in kernel tracer such that
percpu symbols are unique and don't clash with local symbols.  This
serves two purposes of decreasing the possibility of global percpu
symbol collision and allowing dropping per_cpu__ prefix from percpu
symbols.

* kernel/trace/trace.c: s/max_data/max_tr_data/
* kernel/trace/trace_hw_branches: s/tracer/hwb_tracer/, s/buffer/hwb_buffer/

Partly based on Rusty Russell's "alloc_percpu: rename percpu vars
which cause name clashes" patch.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
---
 kernel/trace/trace.c             |    4 +-
 kernel/trace/trace_hw_branches.c |   51 +++++++++++++++++++------------------
 2 files changed, 28 insertions(+), 27 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 8439cdc..85a5ed7 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -203,7 +203,7 @@ cycle_t ftrace_now(int cpu)
  */
 static struct trace_array	max_tr;
 
-static DEFINE_PER_CPU(struct trace_array_cpu, max_data);
+static DEFINE_PER_CPU(struct trace_array_cpu, max_tr_data);
 
 /* tracer_enabled is used to toggle activation of a tracer */
 static int			tracer_enabled = 1;
@@ -4426,7 +4426,7 @@ __init static int tracer_alloc_buffers(void)
 	/* Allocate the first page for all buffers */
 	for_each_tracing_cpu(i) {
 		global_trace.data[i] = &per_cpu(global_trace_cpu, i);
-		max_tr.data[i] = &per_cpu(max_data, i);
+		max_tr.data[i] = &per_cpu(max_tr_data, i);
 	}
 
 	trace_init_cmdlines();
diff --git a/kernel/trace/trace_hw_branches.c b/kernel/trace/trace_hw_branches.c
index 23b6385..adaf7a3 100644
--- a/kernel/trace/trace_hw_branches.c
+++ b/kernel/trace/trace_hw_branches.c
@@ -20,10 +20,10 @@
 
 #define BTS_BUFFER_SIZE (1 << 13)
 
-static DEFINE_PER_CPU(struct bts_tracer *, tracer);
-static DEFINE_PER_CPU(unsigned char[BTS_BUFFER_SIZE], buffer);
+static DEFINE_PER_CPU(struct bts_tracer *, hwb_tracer);
+static DEFINE_PER_CPU(unsigned char[BTS_BUFFER_SIZE], hwb_buffer);
 
-#define this_tracer per_cpu(tracer, smp_processor_id())
+#define this_tracer per_cpu(hwb_tracer, smp_processor_id())
 
 static int trace_hw_branches_enabled __read_mostly;
 static int trace_hw_branches_suspended __read_mostly;
@@ -32,12 +32,13 @@ static struct trace_array *hw_branch_trace __read_mostly;
 
 static void bts_trace_init_cpu(int cpu)
 {
-	per_cpu(tracer, cpu) =
-		ds_request_bts_cpu(cpu, per_cpu(buffer, cpu), BTS_BUFFER_SIZE,
-				   NULL, (size_t)-1, BTS_KERNEL);
+	per_cpu(hwb_tracer, cpu) =
+		ds_request_bts_cpu(cpu, per_cpu(hwb_buffer, cpu),
+				   BTS_BUFFER_SIZE, NULL, (size_t)-1,
+				   BTS_KERNEL);
 
-	if (IS_ERR(per_cpu(tracer, cpu)))
-		per_cpu(tracer, cpu) = NULL;
+	if (IS_ERR(per_cpu(hwb_tracer, cpu)))
+		per_cpu(hwb_tracer, cpu) = NULL;
 }
 
 static int bts_trace_init(struct trace_array *tr)
@@ -51,7 +52,7 @@ static int bts_trace_init(struct trace_array *tr)
 	for_each_online_cpu(cpu) {
 		bts_trace_init_cpu(cpu);
 
-		if (likely(per_cpu(tracer, cpu)))
+		if (likely(per_cpu(hwb_tracer, cpu)))
 			trace_hw_branches_enabled = 1;
 	}
 	trace_hw_branches_suspended = 0;
@@ -67,9 +68,9 @@ static void bts_trace_reset(struct trace_array *tr)
 
 	get_online_cpus();
 	for_each_online_cpu(cpu) {
-		if (likely(per_cpu(tracer, cpu))) {
-			ds_release_bts(per_cpu(tracer, cpu));
-			per_cpu(tracer, cpu) = NULL;
+		if (likely(per_cpu(hwb_tracer, cpu))) {
+			ds_release_bts(per_cpu(hwb_tracer, cpu));
+			per_cpu(hwb_tracer, cpu) = NULL;
 		}
 	}
 	trace_hw_branches_enabled = 0;
@@ -83,8 +84,8 @@ static void bts_trace_start(struct trace_array *tr)
 
 	get_online_cpus();
 	for_each_online_cpu(cpu)
-		if (likely(per_cpu(tracer, cpu)))
-			ds_resume_bts(per_cpu(tracer, cpu));
+		if (likely(per_cpu(hwb_tracer, cpu)))
+			ds_resume_bts(per_cpu(hwb_tracer, cpu));
 	trace_hw_branches_suspended = 0;
 	put_online_cpus();
 }
@@ -95,8 +96,8 @@ static void bts_trace_stop(struct trace_array *tr)
 
 	get_online_cpus();
 	for_each_online_cpu(cpu)
-		if (likely(per_cpu(tracer, cpu)))
-			ds_suspend_bts(per_cpu(tracer, cpu));
+		if (likely(per_cpu(hwb_tracer, cpu)))
+			ds_suspend_bts(per_cpu(hwb_tracer, cpu));
 	trace_hw_branches_suspended = 1;
 	put_online_cpus();
 }
@@ -114,16 +115,16 @@ static int __cpuinit bts_hotcpu_handler(struct notifier_block *nfb,
 			bts_trace_init_cpu(cpu);
 
 			if (trace_hw_branches_suspended &&
-			    likely(per_cpu(tracer, cpu)))
-				ds_suspend_bts(per_cpu(tracer, cpu));
+			    likely(per_cpu(hwb_tracer, cpu)))
+				ds_suspend_bts(per_cpu(hwb_tracer, cpu));
 		}
 		break;
 
 	case CPU_DOWN_PREPARE:
 		/* The notification is sent with interrupts enabled. */
-		if (likely(per_cpu(tracer, cpu))) {
-			ds_release_bts(per_cpu(tracer, cpu));
-			per_cpu(tracer, cpu) = NULL;
+		if (likely(per_cpu(hwb_tracer, cpu))) {
+			ds_release_bts(per_cpu(hwb_tracer, cpu));
+			per_cpu(hwb_tracer, cpu) = NULL;
 		}
 	}
 
@@ -256,8 +257,8 @@ static void trace_bts_prepare(struct trace_iterator *iter)
 
 	get_online_cpus();
 	for_each_online_cpu(cpu)
-		if (likely(per_cpu(tracer, cpu)))
-			ds_suspend_bts(per_cpu(tracer, cpu));
+		if (likely(per_cpu(hwb_tracer, cpu)))
+			ds_suspend_bts(per_cpu(hwb_tracer, cpu));
 	/*
 	 * We need to collect the trace on the respective cpu since ftrace
 	 * implicitly adds the record for the current cpu.
@@ -266,8 +267,8 @@ static void trace_bts_prepare(struct trace_iterator *iter)
 	on_each_cpu(trace_bts_cpu, iter->tr, 1);
 
 	for_each_online_cpu(cpu)
-		if (likely(per_cpu(tracer, cpu)))
-			ds_resume_bts(per_cpu(tracer, cpu));
+		if (likely(per_cpu(hwb_tracer, cpu)))
+			ds_resume_bts(per_cpu(hwb_tracer, cpu));
 	put_online_cpus();
 }
 
-- 
1.6.4.2

