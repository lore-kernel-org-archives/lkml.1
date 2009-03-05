Return-Path: <linux-kernel-owner+w=401wt.eu-S1757453AbZCED3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453AbZCED3p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 22:29:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754037AbZCED1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 22:27:22 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:40213 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388AbZCED1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 22:27:16 -0500
Message-Id: <20090305032713.851501507@goodmis.org>
References: <20090305032532.802709985@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 04 Mar 2009 22:25:39 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Theodore Tso <tytso@mit.edu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 7/7] tracing: have latency tracers set the latency format
Content-Disposition: inline; filename=0007-tracing-have-latency-tracers-set-the-latency-format.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The latency tracers (irqsoff, preemptoff, preemptirqsoff, and wakeup)
are pretty useless with the default output format. This patch makes them
automatically enable the latency format when they are selected. They
also record the state of the latency option, and if it was not enabled
when selected, they disable it on reset.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_irqsoff.c      |    8 ++++++++
 kernel/trace/trace_sched_wakeup.c |    8 ++++++++
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index 9e5ebd8..b923d13 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -32,6 +32,8 @@ enum {
 
 static int trace_type __read_mostly;
 
+static int save_lat_flag;
+
 #ifdef CONFIG_PREEMPT_TRACER
 static inline int
 preempt_trace(void)
@@ -370,6 +372,9 @@ static void stop_irqsoff_tracer(struct trace_array *tr)
 
 static void __irqsoff_tracer_init(struct trace_array *tr)
 {
+	save_lat_flag = trace_flags & TRACE_ITER_LATENCY_FMT;
+	trace_flags |= TRACE_ITER_LATENCY_FMT;
+
 	tracing_max_latency = 0;
 	irqsoff_trace = tr;
 	/* make sure that the tracer is visible */
@@ -380,6 +385,9 @@ static void __irqsoff_tracer_init(struct trace_array *tr)
 static void irqsoff_tracer_reset(struct trace_array *tr)
 {
 	stop_irqsoff_tracer(tr);
+
+	if (!save_lat_flag)
+		trace_flags &= ~TRACE_ITER_LATENCY_FMT;
 }
 
 static void irqsoff_tracer_start(struct trace_array *tr)
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index db55f7a..3c5ad6b 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -32,6 +32,8 @@ static raw_spinlock_t wakeup_lock =
 
 static void __wakeup_reset(struct trace_array *tr);
 
+static int save_lat_flag;
+
 #ifdef CONFIG_FUNCTION_TRACER
 /*
  * irqsoff uses its own tracer function to keep the overhead down:
@@ -324,6 +326,9 @@ static void stop_wakeup_tracer(struct trace_array *tr)
 
 static int __wakeup_tracer_init(struct trace_array *tr)
 {
+	save_lat_flag = trace_flags & TRACE_ITER_LATENCY_FMT;
+	trace_flags |= TRACE_ITER_LATENCY_FMT;
+
 	tracing_max_latency = 0;
 	wakeup_trace = tr;
 	start_wakeup_tracer(tr);
@@ -347,6 +352,9 @@ static void wakeup_tracer_reset(struct trace_array *tr)
 	stop_wakeup_tracer(tr);
 	/* make sure we put back any tasks we are tracing */
 	wakeup_reset(tr);
+
+	if (!save_lat_flag)
+		trace_flags &= ~TRACE_ITER_LATENCY_FMT;
 }
 
 static void wakeup_tracer_start(struct trace_array *tr)
-- 
1.6.1.3

-- 
