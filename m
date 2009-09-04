Return-Path: <linux-kernel-owner+w=401wt.eu-S934225AbZIEACr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934225AbZIEACr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:02:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934349AbZIEACd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:02:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:40464 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934154AbZIEABY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:01:24 -0400
Message-Id: <20090905000125.796929720@goodmis.org>
References: <20090904235527.520961911@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 04 Sep 2009 19:55:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 13/18] tracing: make tracing_reset safe for external use
Content-Disposition: inline; filename=0013-tracing-make-tracing_reset-safe-for-external-use.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Reseting the trace buffer without first disabling the buffer and
waiting for any writers to complete, can corrupt the ring buffer.

This patch makes the external version of tracing_reset safe from
corruption by disabling the ring buffer and calling synchronize_sched.

This version can no longer be called from interrupt context. But all those
callers have been removed.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |   17 +++++++++++++++--
 1 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 7daf372..0418e26 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -641,13 +641,26 @@ void unregister_tracer(struct tracer *type)
 	mutex_unlock(&trace_types_lock);
 }
 
-void tracing_reset(struct trace_array *tr, int cpu)
+static void __tracing_reset(struct trace_array *tr, int cpu)
 {
 	ftrace_disable_cpu();
 	ring_buffer_reset_cpu(tr->buffer, cpu);
 	ftrace_enable_cpu();
 }
 
+void tracing_reset(struct trace_array *tr, int cpu)
+{
+	struct ring_buffer *buffer = tr->buffer;
+
+	ring_buffer_record_disable(buffer);
+
+	/* Make sure all commits have finished */
+	synchronize_sched();
+	__tracing_reset(tr, cpu);
+
+	ring_buffer_record_enable(buffer);
+}
+
 void tracing_reset_online_cpus(struct trace_array *tr)
 {
 	struct ring_buffer *buffer = tr->buffer;
@@ -661,7 +674,7 @@ void tracing_reset_online_cpus(struct trace_array *tr)
 	tr->time_start = ftrace_now(tr->cpu);
 
 	for_each_online_cpu(cpu)
-		tracing_reset(tr, cpu);
+		__tracing_reset(tr, cpu);
 
 	ring_buffer_record_enable(buffer);
 }
-- 
1.6.3.3

-- 
