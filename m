Return-Path: <linux-kernel-owner+w=401wt.eu-S934154AbZIEACd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934154AbZIEACd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934029AbZIEAB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:01:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:33557 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934121AbZIEABW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:01:22 -0400
Message-Id: <20090905000124.262046718@goodmis.org>
References: <20090904235527.520961911@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 04 Sep 2009 19:55:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 09/18] tracing: disable update max tracer while reading trace
Content-Disposition: inline; filename=0009-tracing-disable-update-max-tracer-while-reading-trac.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

When reading the tracer from the trace file, updating the max latency
may corrupt the output. This patch disables the tracing of the max
latency while reading the trace file.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index df2c9f7..e521f1e 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -263,6 +263,9 @@ unsigned long trace_flags = TRACE_ITER_PRINT_PARENT | TRACE_ITER_PRINTK |
 	TRACE_ITER_ANNOTATE | TRACE_ITER_CONTEXT_INFO | TRACE_ITER_SLEEP_TIME |
 	TRACE_ITER_GRAPH_TIME;
 
+static int trace_stop_count;
+static DEFINE_SPINLOCK(tracing_start_lock);
+
 /**
  * trace_wake_up - wake up tasks waiting for trace input
  *
@@ -442,6 +445,9 @@ update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 {
 	struct ring_buffer *buf = tr->buffer;
 
+	if (trace_stop_count)
+		return;
+
 	WARN_ON_ONCE(!irqs_disabled());
 	__raw_spin_lock(&ftrace_max_lock);
 
@@ -469,6 +475,9 @@ update_max_tr_single(struct trace_array *tr, struct task_struct *tsk, int cpu)
 {
 	int ret;
 
+	if (trace_stop_count)
+		return;
+
 	WARN_ON_ONCE(!irqs_disabled());
 	__raw_spin_lock(&ftrace_max_lock);
 
@@ -685,9 +694,6 @@ static void trace_init_cmdlines(void)
 	cmdline_idx = 0;
 }
 
-static int trace_stop_count;
-static DEFINE_SPINLOCK(tracing_start_lock);
-
 /**
  * ftrace_off_permanent - disable all ftrace code permanently
  *
-- 
1.6.3.3

-- 
