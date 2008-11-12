Return-Path: <linux-kernel-owner+w=401wt.eu-S1755984AbYKLW4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984AbYKLW4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 17:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754170AbYKLWzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 17:55:09 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39178 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071AbYKLWzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 17:55:08 -0500
Message-Id: <20081112225501.291179692@goodmis.org>
References: <20081112225235.056515739@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 12 Nov 2008 17:52:38 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       David Miller <davem@davemloft.net>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 3/3] ftrace: CPU buffer start annotation clean ups
Content-Disposition: inline; filename=0003-ftrace-CPU-buffer-start-annotation-clean-ups.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: better handling of CPU buffer start annotation

Because of the confusion with the per CPU buffers wrapping where
one CPU might be more active at the end of the trace than the other
CPUs causing that one CPU to have a shorter history. Kernel
developers were confused by the "missing" data of that one CPU
at the beginning of the trace output. An annotation was added to
the trace output to show that the buffer had started:

# tracer: function
#
#           TASK-PID    CPU#    TIMESTAMP  FUNCTION
#              | |       |          |         |
##### CPU 3 buffer started ####
          <idle>-0     [003]   158.192959: smp_apic_timer_interrupt
[...]
          <idle>-0     [003]   161.556520: default_idle
##### CPU 1 buffer started ####
          <idle>-0     [001]   161.592494: hrtimer_force_reprogram
[etc]

But this annotation gets a bit messy when tracers do not fill the
buffers. This patch does a couple of things:

 One) it adds a flag to trace_options to disable these annotations

 Two) it does not annotate if the tracer did not overflow its buffer.

This makes the output much cleaner.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c |   16 +++++++++++++++-
 kernel/trace/trace.h |    1 +
 2 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 32cef26..40c9cc1 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -205,7 +205,8 @@ static DEFINE_MUTEX(trace_types_lock);
 static DECLARE_WAIT_QUEUE_HEAD(trace_wait);
 
 /* trace_flags holds trace_options default values */
-unsigned long trace_flags = TRACE_ITER_PRINT_PARENT | TRACE_ITER_PRINTK;
+unsigned long trace_flags = TRACE_ITER_PRINT_PARENT | TRACE_ITER_PRINTK |
+	TRACE_ITER_ANNOTATE;
 
 /**
  * trace_wake_up - wake up tasks waiting for trace input
@@ -261,6 +262,7 @@ static const char *trace_options[] = {
 #ifdef CONFIG_BRANCH_TRACER
 	"branch",
 #endif
+	"annotate",
 	NULL
 };
 
@@ -1113,6 +1115,7 @@ void tracing_stop_function_trace(void)
 
 enum trace_file_type {
 	TRACE_FILE_LAT_FMT	= 1,
+	TRACE_FILE_ANNOTATE	= 2,
 };
 
 static void trace_iterator_increment(struct trace_iterator *iter, int cpu)
@@ -1532,6 +1535,12 @@ static void test_cpu_buff_start(struct trace_iterator *iter)
 {
 	struct trace_seq *s = &iter->seq;
 
+	if (!(trace_flags & TRACE_ITER_ANNOTATE))
+		return;
+
+	if (!(iter->iter_flags & TRACE_FILE_ANNOTATE))
+		return;
+
 	if (cpu_isset(iter->cpu, iter->started))
 		return;
 
@@ -2132,6 +2141,11 @@ __tracing_open(struct inode *inode, struct file *file, int *ret)
 	iter->trace = current_trace;
 	iter->pos = -1;
 
+	/* Annotate start of buffers if we had overruns */
+	if (ring_buffer_overruns(iter->tr->buffer))
+		iter->iter_flags |= TRACE_FILE_ANNOTATE;
+
+
 	for_each_tracing_cpu(cpu) {
 
 		iter->buffer_iter[cpu] =
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 9e015f5..790ea8c 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -473,6 +473,7 @@ enum trace_iterator_flags {
 #ifdef CONFIG_BRANCH_TRACER
 	TRACE_ITER_BRANCH		= 0x1000,
 #endif
+	TRACE_ITER_ANNOTATE		= 0x2000,
 };
 
 /*
-- 
1.5.6.5

-- 
