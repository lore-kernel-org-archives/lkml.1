Return-Path: <linux-kernel-owner+w=401wt.eu-S1752700Ab0AKV1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700Ab0AKV1o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 16:27:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752403Ab0AKV1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 16:27:34 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:35385 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299Ab0AKV12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 16:27:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=wx4T3sxpUpG6XoB7JMWL6ceJpXpQdlnbcnAC6trc93tMAzByekgBEPJwNnym6V6bDQ
         EJNIYE8vqQwqBNnE0UYs5YiNsC+0O+Vmfn2ekJ8xNh53Q63ZqdhVJFvGUEdjEXPp2M7P
         I3wj8fPiizWgpGCMdQ8e7hXK6Ugr+ifV7YR7s=
From: John Kacur <jkacur@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Cc: Clark Williams <williams@redhat.com>, John Kacur <jkacur@redhat.com>
Subject: [PATCH 14/26] trace: Convert various locks to raw_spinlock
Date: Mon, 11 Jan 2010 22:26:44 +0100
Message-Id: <1263245216-14754-15-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1263245216-14754-14-git-send-email-jkacur@redhat.com>
References: <1263245216-14754-1-git-send-email-jkacur@redhat.com>
 <1263245216-14754-2-git-send-email-jkacur@redhat.com>
 <1263245216-14754-3-git-send-email-jkacur@redhat.com>
 <1263245216-14754-4-git-send-email-jkacur@redhat.com>
 <1263245216-14754-5-git-send-email-jkacur@redhat.com>
 <1263245216-14754-6-git-send-email-jkacur@redhat.com>
 <1263245216-14754-7-git-send-email-jkacur@redhat.com>
 <1263245216-14754-8-git-send-email-jkacur@redhat.com>
 <1263245216-14754-9-git-send-email-jkacur@redhat.com>
 <1263245216-14754-10-git-send-email-jkacur@redhat.com>
 <1263245216-14754-11-git-send-email-jkacur@redhat.com>
 <1263245216-14754-12-git-send-email-jkacur@redhat.com>
 <1263245216-14754-13-git-send-email-jkacur@redhat.com>
 <1263245216-14754-14-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert locks that cannot sleep in preempt-rt to raw_spinlocks.

See also: 87654a70523a8c5baadcbbc07d80cbae8f912837

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 kernel/trace/ring_buffer.c   |   52 +++++++++++++++++++++---------------------
 kernel/trace/trace.c         |   10 ++++----
 kernel/trace/trace_irqsoff.c |    6 ++--
 3 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 2326b04..ffaddc5 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -422,7 +422,7 @@ int ring_buffer_print_page_header(struct trace_seq *s)
 struct ring_buffer_per_cpu {
 	int				cpu;
 	struct ring_buffer		*buffer;
-	spinlock_t			reader_lock;	/* serialize readers */
+	raw_spinlock_t			reader_lock;	/* serialize readers */
 	arch_spinlock_t			lock;
 	struct lock_class_key		lock_key;
 	struct list_head		*pages;
@@ -996,7 +996,7 @@ rb_allocate_cpu_buffer(struct ring_buffer *buffer, int cpu)
 
 	cpu_buffer->cpu = cpu;
 	cpu_buffer->buffer = buffer;
-	spin_lock_init(&cpu_buffer->reader_lock);
+	raw_spin_lock_init(&cpu_buffer->reader_lock);
 	lockdep_set_class(&cpu_buffer->reader_lock, buffer->reader_lock_key);
 	cpu_buffer->lock = (arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
 
@@ -1193,7 +1193,7 @@ rb_remove_pages(struct ring_buffer_per_cpu *cpu_buffer, unsigned nr_pages)
 	struct list_head *p;
 	unsigned i;
 
-	spin_lock_irq(&cpu_buffer->reader_lock);
+	raw_spin_lock_irq(&cpu_buffer->reader_lock);
 	rb_head_page_deactivate(cpu_buffer);
 
 	for (i = 0; i < nr_pages; i++) {
@@ -1210,7 +1210,7 @@ rb_remove_pages(struct ring_buffer_per_cpu *cpu_buffer, unsigned nr_pages)
 	rb_reset_cpu(cpu_buffer);
 	rb_check_pages(cpu_buffer);
 
-	spin_unlock_irq(&cpu_buffer->reader_lock);
+	raw_spin_unlock_irq(&cpu_buffer->reader_lock);
 }
 
 static void
@@ -1221,7 +1221,7 @@ rb_insert_pages(struct ring_buffer_per_cpu *cpu_buffer,
 	struct list_head *p;
 	unsigned i;
 
-	spin_lock_irq(&cpu_buffer->reader_lock);
+	raw_spin_lock_irq(&cpu_buffer->reader_lock);
 	rb_head_page_deactivate(cpu_buffer);
 
 	for (i = 0; i < nr_pages; i++) {
@@ -1235,7 +1235,7 @@ rb_insert_pages(struct ring_buffer_per_cpu *cpu_buffer,
 	rb_reset_cpu(cpu_buffer);
 	rb_check_pages(cpu_buffer);
 
-	spin_unlock_irq(&cpu_buffer->reader_lock);
+	raw_spin_unlock_irq(&cpu_buffer->reader_lock);
 }
 
 /**
@@ -2735,9 +2735,9 @@ void ring_buffer_iter_reset(struct ring_buffer_iter *iter)
 
 	cpu_buffer = iter->cpu_buffer;
 
-	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
+	raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
 	rb_iter_reset(iter);
-	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
+	raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 }
 EXPORT_SYMBOL_GPL(ring_buffer_iter_reset);
 
@@ -3157,12 +3157,12 @@ ring_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
  again:
 	local_irq_save(flags);
 	if (dolock)
-		spin_lock(&cpu_buffer->reader_lock);
+		raw_spin_lock(&cpu_buffer->reader_lock);
 	event = rb_buffer_peek(cpu_buffer, ts);
 	if (event && event->type_len == RINGBUF_TYPE_PADDING)
 		rb_advance_reader(cpu_buffer);
 	if (dolock)
-		spin_unlock(&cpu_buffer->reader_lock);
+		raw_spin_unlock(&cpu_buffer->reader_lock);
 	local_irq_restore(flags);
 
 	if (event && event->type_len == RINGBUF_TYPE_PADDING)
@@ -3187,9 +3187,9 @@ ring_buffer_iter_peek(struct ring_buffer_iter *iter, u64 *ts)
 	unsigned long flags;
 
  again:
-	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
+	raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
 	event = rb_iter_peek(iter, ts);
-	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
+	raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
 	if (event && event->type_len == RINGBUF_TYPE_PADDING)
 		goto again;
@@ -3225,14 +3225,14 @@ ring_buffer_consume(struct ring_buffer *buffer, int cpu, u64 *ts)
 	cpu_buffer = buffer->buffers[cpu];
 	local_irq_save(flags);
 	if (dolock)
-		spin_lock(&cpu_buffer->reader_lock);
+		raw_spin_lock(&cpu_buffer->reader_lock);
 
 	event = rb_buffer_peek(cpu_buffer, ts);
 	if (event)
 		rb_advance_reader(cpu_buffer);
 
 	if (dolock)
-		spin_unlock(&cpu_buffer->reader_lock);
+		raw_spin_unlock(&cpu_buffer->reader_lock);
 	local_irq_restore(flags);
 
  out:
@@ -3278,11 +3278,11 @@ ring_buffer_read_start(struct ring_buffer *buffer, int cpu)
 	atomic_inc(&cpu_buffer->record_disabled);
 	synchronize_sched();
 
-	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
+	raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
 	arch_spin_lock(&cpu_buffer->lock);
 	rb_iter_reset(iter);
 	arch_spin_unlock(&cpu_buffer->lock);
-	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
+	raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
 	return iter;
 }
@@ -3319,7 +3319,7 @@ ring_buffer_read(struct ring_buffer_iter *iter, u64 *ts)
 	struct ring_buffer_per_cpu *cpu_buffer = iter->cpu_buffer;
 	unsigned long flags;
 
-	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
+	raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
  again:
 	event = rb_iter_peek(iter, ts);
 	if (!event)
@@ -3330,7 +3330,7 @@ ring_buffer_read(struct ring_buffer_iter *iter, u64 *ts)
 
 	rb_advance_iter(iter);
  out:
-	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
+	raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
 	return event;
 }
@@ -3396,7 +3396,7 @@ void ring_buffer_reset_cpu(struct ring_buffer *buffer, int cpu)
 
 	atomic_inc(&cpu_buffer->record_disabled);
 
-	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
+	raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
 
 	if (RB_WARN_ON(cpu_buffer, local_read(&cpu_buffer->committing)))
 		goto out;
@@ -3408,7 +3408,7 @@ void ring_buffer_reset_cpu(struct ring_buffer *buffer, int cpu)
 	arch_spin_unlock(&cpu_buffer->lock);
 
  out:
-	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
+	raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
 	atomic_dec(&cpu_buffer->record_disabled);
 }
@@ -3446,10 +3446,10 @@ int ring_buffer_empty(struct ring_buffer *buffer)
 		cpu_buffer = buffer->buffers[cpu];
 		local_irq_save(flags);
 		if (dolock)
-			spin_lock(&cpu_buffer->reader_lock);
+			raw_spin_lock(&cpu_buffer->reader_lock);
 		ret = rb_per_cpu_empty(cpu_buffer);
 		if (dolock)
-			spin_unlock(&cpu_buffer->reader_lock);
+			raw_spin_unlock(&cpu_buffer->reader_lock);
 		local_irq_restore(flags);
 
 		if (!ret)
@@ -3480,10 +3480,10 @@ int ring_buffer_empty_cpu(struct ring_buffer *buffer, int cpu)
 	cpu_buffer = buffer->buffers[cpu];
 	local_irq_save(flags);
 	if (dolock)
-		spin_lock(&cpu_buffer->reader_lock);
+		raw_spin_lock(&cpu_buffer->reader_lock);
 	ret = rb_per_cpu_empty(cpu_buffer);
 	if (dolock)
-		spin_unlock(&cpu_buffer->reader_lock);
+		raw_spin_unlock(&cpu_buffer->reader_lock);
 	local_irq_restore(flags);
 
 	return ret;
@@ -3678,7 +3678,7 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 	if (!bpage)
 		goto out;
 
-	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
+	raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
 
 	reader = rb_get_reader_page(cpu_buffer);
 	if (!reader)
@@ -3753,7 +3753,7 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 	ret = read;
 
  out_unlock:
-	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
+	raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
  out:
 	return ret;
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 0df1b0f..0c6bbcb 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -258,7 +258,7 @@ unsigned long trace_flags = TRACE_ITER_PRINT_PARENT | TRACE_ITER_PRINTK |
 	TRACE_ITER_GRAPH_TIME;
 
 static int trace_stop_count;
-static DEFINE_SPINLOCK(tracing_start_lock);
+static DEFINE_RAW_SPINLOCK(tracing_start_lock);
 
 /**
  * trace_wake_up - wake up tasks waiting for trace input
@@ -847,7 +847,7 @@ void tracing_start(void)
 	if (tracing_disabled)
 		return;
 
-	spin_lock_irqsave(&tracing_start_lock, flags);
+	raw_spin_lock_irqsave(&tracing_start_lock, flags);
 	if (--trace_stop_count) {
 		if (trace_stop_count < 0) {
 			/* Someone screwed up their debugging */
@@ -868,7 +868,7 @@ void tracing_start(void)
 
 	ftrace_start();
  out:
-	spin_unlock_irqrestore(&tracing_start_lock, flags);
+	raw_spin_unlock_irqrestore(&tracing_start_lock, flags);
 }
 
 /**
@@ -883,7 +883,7 @@ void tracing_stop(void)
 	unsigned long flags;
 
 	ftrace_stop();
-	spin_lock_irqsave(&tracing_start_lock, flags);
+	raw_spin_lock_irqsave(&tracing_start_lock, flags);
 	if (trace_stop_count++)
 		goto out;
 
@@ -896,7 +896,7 @@ void tracing_stop(void)
 		ring_buffer_record_disable(buffer);
 
  out:
-	spin_unlock_irqrestore(&tracing_start_lock, flags);
+	raw_spin_unlock_irqrestore(&tracing_start_lock, flags);
 }
 
 void trace_stop_cmdline_recording(void);
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index 2974bc7..60ba58e 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -23,7 +23,7 @@ static int				tracer_enabled __read_mostly;
 
 static DEFINE_PER_CPU(int, tracing_cpu);
 
-static DEFINE_SPINLOCK(max_trace_lock);
+static DEFINE_RAW_SPINLOCK(max_trace_lock);
 
 enum {
 	TRACER_IRQS_OFF		= (1 << 1),
@@ -144,7 +144,7 @@ check_critical_timing(struct trace_array *tr,
 	if (!report_latency(delta))
 		goto out;
 
-	spin_lock_irqsave(&max_trace_lock, flags);
+	raw_spin_lock_irqsave(&max_trace_lock, flags);
 
 	/* check if we are still the max latency */
 	if (!report_latency(delta))
@@ -167,7 +167,7 @@ check_critical_timing(struct trace_array *tr,
 	max_sequence++;
 
 out_unlock:
-	spin_unlock_irqrestore(&max_trace_lock, flags);
+	raw_spin_unlock_irqrestore(&max_trace_lock, flags);
 
 out:
 	data->critical_sequence = max_sequence;
-- 
1.6.5.2

