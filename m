Return-Path: <linux-kernel-owner+w=401wt.eu-S1764201AbZAPE5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764201AbZAPE5S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 23:57:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757307AbZAPEyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 23:54:25 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:45871 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756331AbZAPEyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 23:54:20 -0500
Message-Id: <20090116045418.683915469@goodmis.org>
References: <20090116045342.748642160@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 15 Jan 2009 23:53:48 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 6/6] trace: set max latency variable to zero on default
Content-Disposition: inline; filename=0006-trace-set-max-latency-variable-to-zero-on-default.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: trace max latencies on start of latency tracing

This patch sets the max latency to zero whenever one of the
irq variant tracers or the wakeup tracer is set to current tracer.

Most developers expect to see output when starting up a latency
tracer. But since the max_latency is already set to max, and
it takes a latency greater than max_latency to be recorded, there
is no trace. This is not the expected behavior and has even confused
myself.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c              |    2 +-
 kernel/trace/trace_irqsoff.c      |    1 +
 kernel/trace/trace_sched_wakeup.c |    1 +
 3 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 7de6a94..220c264 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -41,7 +41,7 @@
 
 #define TRACE_BUFFER_FLAGS	(RB_FL_OVERWRITE)
 
-unsigned long __read_mostly	tracing_max_latency = (cycle_t)ULONG_MAX;
+unsigned long __read_mostly	tracing_max_latency;
 unsigned long __read_mostly	tracing_thresh;
 
 /*
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index 7c2e326..62a78d9 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -380,6 +380,7 @@ static void stop_irqsoff_tracer(struct trace_array *tr)
 
 static void __irqsoff_tracer_init(struct trace_array *tr)
 {
+	tracing_max_latency = 0;
 	irqsoff_trace = tr;
 	/* make sure that the tracer is visible */
 	smp_wmb();
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index 43586b6..42ae1e7 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -333,6 +333,7 @@ static void stop_wakeup_tracer(struct trace_array *tr)
 
 static int wakeup_tracer_init(struct trace_array *tr)
 {
+	tracing_max_latency = 0;
 	wakeup_trace = tr;
 	start_wakeup_tracer(tr);
 	return 0;
-- 
1.5.6.5

-- 
