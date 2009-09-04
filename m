Return-Path: <linux-kernel-owner+w=401wt.eu-S934299AbZIEABb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934299AbZIEABb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:01:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934269AbZIEAB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:01:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:33571 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934146AbZIEABX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:01:23 -0400
Message-Id: <20090905000125.020804633@goodmis.org>
References: <20090904235527.520961911@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 04 Sep 2009 19:55:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 11/18] tracing: remove users of tracing_reset
Content-Disposition: inline; filename=0011-tracing-remove-users-of-tracing_reset.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The function tracing_reset is deprecated for outside use of trace.c.

The new function to reset the the buffers is tracing_reset_online_cpus.

The reason for this is that resetting the buffers while the event
trace points are active can corrupt the buffers, because they may
be writing at the time of reset. The tracing_reset_online_cpus disables
writes and waits for current writers to finish.

This patch replaces all users of tracing_reset except for the latency
tracers. Those changes require more work and will be removed in the
following patches.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/kmemtrace.c   |    4 +---
 kernel/trace/trace.c       |    7 ++-----
 kernel/trace/trace_boot.c  |    4 +---
 kernel/trace/trace_power.c |    4 +---
 4 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/kernel/trace/kmemtrace.c b/kernel/trace/kmemtrace.c
index dda53cc..81b1645 100644
--- a/kernel/trace/kmemtrace.c
+++ b/kernel/trace/kmemtrace.c
@@ -183,11 +183,9 @@ static void kmemtrace_stop_probes(void)
 
 static int kmem_trace_init(struct trace_array *tr)
 {
-	int cpu;
 	kmemtrace_array = tr;
 
-	for_each_cpu(cpu, cpu_possible_mask)
-		tracing_reset(tr, cpu);
+	tracing_reset_online_cpus(tr);
 
 	kmemtrace_start_probes();
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 9110329..54517a8 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -550,7 +550,6 @@ __acquires(kernel_lock)
 	if (type->selftest && !tracing_selftest_disabled) {
 		struct tracer *saved_tracer = current_trace;
 		struct trace_array *tr = &global_trace;
-		int i;
 
 		/*
 		 * Run a selftest on this tracer.
@@ -559,8 +558,7 @@ __acquires(kernel_lock)
 		 * internal tracing to verify that everything is in order.
 		 * If we fail, we do not register this tracer.
 		 */
-		for_each_tracing_cpu(i)
-			tracing_reset(tr, i);
+		tracing_reset_online_cpus(tr);
 
 		current_trace = type;
 		/* the test is responsible for initializing and enabling */
@@ -573,8 +571,7 @@ __acquires(kernel_lock)
 			goto out;
 		}
 		/* Only reset on passing, to avoid touching corrupted buffers */
-		for_each_tracing_cpu(i)
-			tracing_reset(tr, i);
+		tracing_reset_online_cpus(tr);
 
 		printk(KERN_CONT "PASSED\n");
 	}
diff --git a/kernel/trace/trace_boot.c b/kernel/trace/trace_boot.c
index a29ef23..8631393 100644
--- a/kernel/trace/trace_boot.c
+++ b/kernel/trace/trace_boot.c
@@ -41,14 +41,12 @@ void disable_boot_trace(void)
 
 static int boot_trace_init(struct trace_array *tr)
 {
-	int cpu;
 	boot_trace = tr;
 
 	if (!tr)
 		return 0;
 
-	for_each_cpu(cpu, cpu_possible_mask)
-		tracing_reset(tr, cpu);
+	tracing_reset_online_cpus(tr);
 
 	tracing_sched_switch_assign_trace(tr);
 	return 0;
diff --git a/kernel/trace/trace_power.c b/kernel/trace/trace_power.c
index 8a30d98..a5d5a4f 100644
--- a/kernel/trace/trace_power.c
+++ b/kernel/trace/trace_power.c
@@ -144,14 +144,12 @@ static void power_trace_reset(struct trace_array *tr)
 
 static int power_trace_init(struct trace_array *tr)
 {
-	int cpu;
 	power_trace = tr;
 
 	trace_power_enabled = 1;
 	tracing_power_register();
 
-	for_each_cpu(cpu, cpu_possible_mask)
-		tracing_reset(tr, cpu);
+	tracing_reset_online_cpus(tr);
 	return 0;
 }
 
-- 
1.6.3.3

-- 
