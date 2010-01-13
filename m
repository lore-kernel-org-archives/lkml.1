Return-Path: <linux-kernel-owner+w=401wt.eu-S1756248Ab0AMSJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248Ab0AMSJw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 13:09:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755667Ab0AMSJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 13:09:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754888Ab0AMSJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 13:09:51 -0500
Date: Wed, 13 Jan 2010 19:09:22 +0100 (CET)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: Steven Rostedt <rostedt@goodmis.org>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Clark Williams <williams@redhat.com>
Subject: Re: [PATCH 14/26] trace: Convert various locks to raw_spinlock
In-Reply-To: <1263397315.28171.3827.camel@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.00.1001131907560.5665@localhost.localdomain>
References: <1263245216-14754-7-git-send-email-jkacur@redhat.com>  <1263245216-14754-8-git-send-email-jkacur@redhat.com>  <1263245216-14754-9-git-send-email-jkacur@redhat.com>  <1263245216-14754-10-git-send-email-jkacur@redhat.com> 
 <1263245216-14754-11-git-send-email-jkacur@redhat.com>  <1263245216-14754-12-git-send-email-jkacur@redhat.com>  <1263245216-14754-13-git-send-email-jkacur@redhat.com>  <1263245216-14754-14-git-send-email-jkacur@redhat.com>  <1263245216-14754-15-git-send-email-jkacur@redhat.com>
  <20100112033931.GF5243@nowhere> <20100113152824.GA15301@goodmis.org>  <alpine.LFD.2.00.1001131632350.5665@localhost.localdomain> <1263397315.28171.3827.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 13 Jan 2010, Steven Rostedt wrote:

> On Wed, 2010-01-13 at 16:36 +0100, John Kacur wrote:
> > 
> > On Wed, 13 Jan 2010, Steven Rostedt wrote:
> 
> > > 
> > Thanks for the review Steve and Frederic - I'll spin a new patch that 
> > doesn't convert tracing_start_lock.
> > 
> > However, let's give it some good testing in preempt-rt, because we may 
> > have forgotten over time, why we converted these locks.
> 
> Well, I think we just never unconverted them :-)  I think we took the
> paranoid approach and converted all locks in the trace directory to raw.
> In fact, I think I even had a script to do it.
> 
> -- Steve

Okay, here is the new version of the patch.
Frederic and Steve, can I have Acked-bys before I push to git?

Thanks

>From ee03cc607493e58f34bf93afa2b8a23da5510927 Mon Sep 17 00:00:00 2001
From: John Kacur <jkacur@redhat.com>
Date: Sun, 10 Jan 2010 03:09:48 +0100
Subject: [PATCH] trace: Convert reader_lock and max_trace_lock to raw_spinlocks

Convert reader_lock and max_trace_lock to raw_spinlock.
These locks cannot sleep in preempt-rt because they are called with
interrupts disabled. This should have zero-impact on mainline.

See also: 87654a70523a8c5baadcbbc07d80cbae8f912837

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 kernel/trace/ring_buffer.c   |   53 +++++++++++++++++++++--------------------
 kernel/trace/trace_irqsoff.c |   10 +++++--
 2 files changed, 34 insertions(+), 29 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 2326b04..56b073c 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -422,7 +422,8 @@ int ring_buffer_print_page_header(struct trace_seq *s)
 struct ring_buffer_per_cpu {
 	int				cpu;
 	struct ring_buffer		*buffer;
-	spinlock_t			reader_lock;	/* serialize readers */
+	/* Can be called with interrupts disabled via ftrace_dump */
+	raw_spinlock_t			reader_lock;	/* serialize readers */
 	arch_spinlock_t			lock;
 	struct lock_class_key		lock_key;
 	struct list_head		*pages;
@@ -996,7 +997,7 @@ rb_allocate_cpu_buffer(struct ring_buffer *buffer, int cpu)
 
 	cpu_buffer->cpu = cpu;
 	cpu_buffer->buffer = buffer;
-	spin_lock_init(&cpu_buffer->reader_lock);
+	raw_spin_lock_init(&cpu_buffer->reader_lock);
 	lockdep_set_class(&cpu_buffer->reader_lock, buffer->reader_lock_key);
 	cpu_buffer->lock = (arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
 
@@ -1193,7 +1194,7 @@ rb_remove_pages(struct ring_buffer_per_cpu *cpu_buffer, unsigned nr_pages)
 	struct list_head *p;
 	unsigned i;
 
-	spin_lock_irq(&cpu_buffer->reader_lock);
+	raw_spin_lock_irq(&cpu_buffer->reader_lock);
 	rb_head_page_deactivate(cpu_buffer);
 
 	for (i = 0; i < nr_pages; i++) {
@@ -1210,7 +1211,7 @@ rb_remove_pages(struct ring_buffer_per_cpu *cpu_buffer, unsigned nr_pages)
 	rb_reset_cpu(cpu_buffer);
 	rb_check_pages(cpu_buffer);
 
-	spin_unlock_irq(&cpu_buffer->reader_lock);
+	raw_spin_unlock_irq(&cpu_buffer->reader_lock);
 }
 
 static void
@@ -1221,7 +1222,7 @@ rb_insert_pages(struct ring_buffer_per_cpu *cpu_buffer,
 	struct list_head *p;
 	unsigned i;
 
-	spin_lock_irq(&cpu_buffer->reader_lock);
+	raw_spin_lock_irq(&cpu_buffer->reader_lock);
 	rb_head_page_deactivate(cpu_buffer);
 
 	for (i = 0; i < nr_pages; i++) {
@@ -1235,7 +1236,7 @@ rb_insert_pages(struct ring_buffer_per_cpu *cpu_buffer,
 	rb_reset_cpu(cpu_buffer);
 	rb_check_pages(cpu_buffer);
 
-	spin_unlock_irq(&cpu_buffer->reader_lock);
+	raw_spin_unlock_irq(&cpu_buffer->reader_lock);
 }
 
 /**
@@ -2735,9 +2736,9 @@ void ring_buffer_iter_reset(struct ring_buffer_iter *iter)
 
 	cpu_buffer = iter->cpu_buffer;
 
-	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
+	raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
 	rb_iter_reset(iter);
-	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
+	raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 }
 EXPORT_SYMBOL_GPL(ring_buffer_iter_reset);
 
@@ -3157,12 +3158,12 @@ ring_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
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
@@ -3187,9 +3188,9 @@ ring_buffer_iter_peek(struct ring_buffer_iter *iter, u64 *ts)
 	unsigned long flags;
 
  again:
-	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
+	raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
 	event = rb_iter_peek(iter, ts);
-	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
+	raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
 	if (event && event->type_len == RINGBUF_TYPE_PADDING)
 		goto again;
@@ -3225,14 +3226,14 @@ ring_buffer_consume(struct ring_buffer *buffer, int cpu, u64 *ts)
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
@@ -3278,11 +3279,11 @@ ring_buffer_read_start(struct ring_buffer *buffer, int cpu)
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
@@ -3319,7 +3320,7 @@ ring_buffer_read(struct ring_buffer_iter *iter, u64 *ts)
 	struct ring_buffer_per_cpu *cpu_buffer = iter->cpu_buffer;
 	unsigned long flags;
 
-	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
+	raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
  again:
 	event = rb_iter_peek(iter, ts);
 	if (!event)
@@ -3330,7 +3331,7 @@ ring_buffer_read(struct ring_buffer_iter *iter, u64 *ts)
 
 	rb_advance_iter(iter);
  out:
-	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
+	raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
 	return event;
 }
@@ -3396,7 +3397,7 @@ void ring_buffer_reset_cpu(struct ring_buffer *buffer, int cpu)
 
 	atomic_inc(&cpu_buffer->record_disabled);
 
-	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
+	raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
 
 	if (RB_WARN_ON(cpu_buffer, local_read(&cpu_buffer->committing)))
 		goto out;
@@ -3408,7 +3409,7 @@ void ring_buffer_reset_cpu(struct ring_buffer *buffer, int cpu)
 	arch_spin_unlock(&cpu_buffer->lock);
 
  out:
-	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
+	raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
 	atomic_dec(&cpu_buffer->record_disabled);
 }
@@ -3446,10 +3447,10 @@ int ring_buffer_empty(struct ring_buffer *buffer)
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
@@ -3480,10 +3481,10 @@ int ring_buffer_empty_cpu(struct ring_buffer *buffer, int cpu)
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
@@ -3678,7 +3679,7 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 	if (!bpage)
 		goto out;
 
-	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
+	raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
 
 	reader = rb_get_reader_page(cpu_buffer);
 	if (!reader)
@@ -3753,7 +3754,7 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 	ret = read;
 
  out_unlock:
-	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
+	raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
  out:
 	return ret;
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index 2974bc7..7125f71 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -23,7 +23,11 @@ static int				tracer_enabled __read_mostly;
 
 static DEFINE_PER_CPU(int, tracing_cpu);
 
-static DEFINE_SPINLOCK(max_trace_lock);
+/*
+ * This lock is always taken with interrupts disabled,
+ * and therefore cannot sleep in preempt-rt.
+ */
+static DEFINE_RAW_SPINLOCK(max_trace_lock);
 
 enum {
 	TRACER_IRQS_OFF		= (1 << 1),
@@ -144,7 +148,7 @@ check_critical_timing(struct trace_array *tr,
 	if (!report_latency(delta))
 		goto out;
 
-	spin_lock_irqsave(&max_trace_lock, flags);
+	raw_spin_lock_irqsave(&max_trace_lock, flags);
 
 	/* check if we are still the max latency */
 	if (!report_latency(delta))
@@ -167,7 +171,7 @@ check_critical_timing(struct trace_array *tr,
 	max_sequence++;
 
 out_unlock:
-	spin_unlock_irqrestore(&max_trace_lock, flags);
+	raw_spin_unlock_irqrestore(&max_trace_lock, flags);
 
 out:
 	data->critical_sequence = max_sequence;
-- 
1.6.5.2

