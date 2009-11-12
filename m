Return-Path: <linux-kernel-owner+w=401wt.eu-S932197AbZKLFs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932197AbZKLFs7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 00:48:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753716AbZKLFso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 00:48:44 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:62323 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbZKLFsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 00:48:41 -0500
Message-Id: <20091112054845.556037727@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 12 Nov 2009 00:43:55 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>
Subject: [PATCH 1/3][RFC] tracing: Add time stamp normalize to ring buffer clock selection
References: <20091112054354.838746008@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Add-time-stamp-normalize-to-ring-buffer-cloc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The ring buffer allows for selecting the clock to use for tracing
but does not allow for selecting the normalize function for
that clock.

This patch updates both the ring buffer as well as the tracing
files that select clocks for the ring buffer, to also have select
a normalizer for the clock.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ring_buffer.h |    3 ++-
 include/linux/trace_clock.h |    2 ++
 kernel/trace/ring_buffer.c  |    9 ++++++++-
 kernel/trace/trace.c        |   18 ++++++++++++++----
 kernel/trace/trace_clock.c  |   12 ++++++++++++
 5 files changed, 38 insertions(+), 6 deletions(-)

diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index 5fcc31e..dd1aa89 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -170,7 +170,8 @@ u64 ring_buffer_time_stamp(struct ring_buffer *buffer, int cpu);
 void ring_buffer_normalize_time_stamp(struct ring_buffer *buffer,
 				      int cpu, u64 *ts);
 void ring_buffer_set_clock(struct ring_buffer *buffer,
-			   u64 (*clock)(void));
+			   u64 (*clock)(void),
+			   void (*normalize)(int cpu, u64 *ts));
 
 size_t ring_buffer_page_len(void *page);
 
diff --git a/include/linux/trace_clock.h b/include/linux/trace_clock.h
index 7a81303..5ce4f17 100644
--- a/include/linux/trace_clock.h
+++ b/include/linux/trace_clock.h
@@ -16,4 +16,6 @@ extern u64 notrace trace_clock_local(void);
 extern u64 notrace trace_clock(void);
 extern u64 notrace trace_clock_global(void);
 
+extern void trace_normalize_local(int cpu, u64 *ts);
+
 #endif /* _LINUX_TRACE_CLOCK_H */
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 3ffa502..34f9b28 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -455,6 +455,7 @@ struct ring_buffer {
 	struct notifier_block		cpu_notify;
 #endif
 	u64				(*clock)(void);
+	void				(*normalize)(int, u64 *);
 };
 
 struct ring_buffer_iter {
@@ -506,6 +507,10 @@ void ring_buffer_normalize_time_stamp(struct ring_buffer *buffer,
 {
 	/* Just stupid testing the normalize function and deltas */
 	*ts >>= DEBUG_SHIFT;
+
+	/* Any locking must be done by the caller */
+	if (buffer->normalize)
+		buffer->normalize(cpu, *ts);
 }
 EXPORT_SYMBOL_GPL(ring_buffer_normalize_time_stamp);
 
@@ -1176,9 +1181,11 @@ ring_buffer_free(struct ring_buffer *buffer)
 EXPORT_SYMBOL_GPL(ring_buffer_free);
 
 void ring_buffer_set_clock(struct ring_buffer *buffer,
-			   u64 (*clock)(void))
+			   u64 (*clock)(void),
+			   void (*normalize)(int cpu, u64 *ts))
 {
 	buffer->clock = clock;
+	buffer->normalize = normalize;
 }
 
 static void rb_reset_cpu(struct ring_buffer_per_cpu *cpu_buffer);
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 9d3067a..723935b 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -330,10 +330,18 @@ static const char *trace_options[] = {
 
 static struct {
 	u64 (*func)(void);
+	void (*normalize)(int, u64 *);
 	const char *name;
 } trace_clocks[] = {
-	{ trace_clock_local,	"local" },
-	{ trace_clock_global,	"global" },
+	{
+		.func		= trace_clock_local,
+		.normalize	= trace_normalize_local,
+		.name		= "local"
+	},
+	{
+		.func		= trace_clock_global,
+		.name		= "global"
+	},
 };
 
 int trace_clock_id;
@@ -3409,9 +3417,11 @@ static ssize_t tracing_clock_write(struct file *filp, const char __user *ubuf,
 
 	mutex_lock(&trace_types_lock);
 
-	ring_buffer_set_clock(global_trace.buffer, trace_clocks[i].func);
+	ring_buffer_set_clock(global_trace.buffer, trace_clocks[i].func,
+			      trace_clocks[i].normalize);
 	if (max_tr.buffer)
-		ring_buffer_set_clock(max_tr.buffer, trace_clocks[i].func);
+		ring_buffer_set_clock(max_tr.buffer, trace_clocks[i].func,
+			trace_clocks[i].normalize);
 
 	mutex_unlock(&trace_types_lock);
 
diff --git a/kernel/trace/trace_clock.c b/kernel/trace/trace_clock.c
index 878c03f..168bf59 100644
--- a/kernel/trace/trace_clock.c
+++ b/kernel/trace/trace_clock.c
@@ -46,6 +46,18 @@ u64 notrace trace_clock_local(void)
 }
 
 /*
+ * trace_normalize_local(): Normalize trace_clock_local
+ * @cpu: cpu that the trace_clock_local was executed on
+ * @ts: the timestamp result from trace_clock_local
+ *
+ * Normalize the trace_clock_local value.
+ */
+void notrace trace_normalize_local(int cpu, u64 *ts)
+{
+	/* nop */
+}
+
+/*
  * trace_clock(): 'inbetween' trace clock. Not completely serialized,
  * but not completely incorrect when crossing CPUs either.
  *
-- 
1.6.5


