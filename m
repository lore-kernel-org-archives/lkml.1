Return-Path: <linux-kernel-owner+w=401wt.eu-S1752232AbYJaMUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbYJaMUd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 08:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751271AbYJaMUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 08:20:16 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:57062 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbYJaMUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 08:20:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=Gq+pz5D3U5QHhoodDqfSdY0bFBAJ7GKqC9CIYJ4mB86svtpjELPdHgZmpqxeF/0Bd8
         9KX9w2OXg+xd7X5MP3wedDP7cXVdPFQMRSAX2Lx1p1G8lBA+78m6AUpDV0NO61w9CrYV
         xFv8c8lgypYtRbVQ89WyjD++nfBcwOu4gTAiw=
Message-ID: <490AF7F8.7090302@gmail.com>
Date: Fri, 31 Oct 2008 13:20:08 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH][RESEND] tracing/fastboot: Use sched switch tracer from boot
 tracer
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(depends on tracing/ftrace: Remove unused code in sched_switch tracer)
---

Use the sched_switch tracer from the boot tracer.
We also can trace schedule events inside the initcalls.
Sched tracing is disabled after the initcall has finished and then reenabled
before the next one is started.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Arjan van de Ven <arjan@infradead.org>
---
 kernel/trace/trace.c              |    2 ++
 kernel/trace/trace.h              |    1 +
 kernel/trace/trace_boot.c         |    6 ++++++
 kernel/trace/trace_sched_switch.c |    6 +++---
 4 files changed, 12 insertions(+), 3 deletions(-)
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 78d5661..acc21bb 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3192,6 +3192,8 @@ __init static int tracer_alloc_buffers(void)
 
 	register_tracer(&nop_trace);
 #ifdef CONFIG_BOOT_TRACER
+	/* We don't want to launch sched_switch tracer yet */
+	global_trace.ctrl = 0;
 	register_tracer(&boot_tracer);
 	current_trace = &boot_tracer;
 	current_trace->init(&global_trace);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index f1f9957..d45a3cd 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -49,6 +49,7 @@ struct ftrace_entry {
 	unsigned long		parent_ip;
 };
 extern struct tracer boot_tracer;
+extern struct tracer sched_switch_trace; /* Used by the boot tracer */
 
 /*
  * Context switch trace entry - which task (and prio) we switched from/to:
diff --git a/kernel/trace/trace_boot.c b/kernel/trace/trace_boot.c
index d104d5b..6bbc879 100644
--- a/kernel/trace/trace_boot.c
+++ b/kernel/trace/trace_boot.c
@@ -27,10 +27,14 @@ void start_boot_trace(void)
 
 void enable_boot_trace(void)
 {
+	if (pre_initcalls_finished)
+		tracing_start_cmdline_record();
 }
 
 void disable_boot_trace(void)
 {
+	if (pre_initcalls_finished)
+		tracing_stop_cmdline_record();
 }
 
 void reset_boot_trace(struct trace_array *tr)
@@ -45,6 +49,8 @@ static void boot_trace_init(struct trace_array *tr)
 
 	for_each_cpu_mask(cpu, cpu_possible_map)
 		tracing_reset(tr, cpu);
+
+	sched_switch_trace.init(tr);
 }
 
 static void boot_trace_ctrl_update(struct trace_array *tr)
diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
index 96620c7..9d7bdac 100644
--- a/kernel/trace/trace_sched_switch.c
+++ b/kernel/trace/trace_sched_switch.c
@@ -127,6 +127,7 @@ static void tracing_start_sched_switch(void)
 	long ref;
 
 	mutex_lock(&tracepoint_mutex);
+	tracer_enabled = 1;
 	ref = atomic_inc_return(&sched_ref);
 	if (ref == 1)
 		tracing_sched_register();
@@ -138,6 +139,7 @@ static void tracing_stop_sched_switch(void)
 	long ref;
 
 	mutex_lock(&tracepoint_mutex);
+	tracer_enabled = 0;
 	ref = atomic_dec_and_test(&sched_ref);
 	if (ref)
 		tracing_sched_unregister();
@@ -158,12 +160,10 @@ static void start_sched_trace(struct trace_array *tr)
 {
 	sched_switch_reset(tr);
 	tracing_start_cmdline_record();
-	tracer_enabled = 1;
 }
 
 static void stop_sched_trace(struct trace_array *tr)
 {
-	tracer_enabled = 0;
 	tracing_stop_cmdline_record();
 }
 
@@ -190,7 +190,7 @@ static void sched_switch_trace_ctrl_update(struct trace_array *tr)
 		stop_sched_trace(tr);
 }
 
-static struct tracer sched_switch_trace __read_mostly =
+struct tracer sched_switch_trace __read_mostly =
 {
 	.name		= "sched_switch",
 	.init		= sched_switch_trace_init,
