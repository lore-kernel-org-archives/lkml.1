Return-Path: <linux-kernel-owner+w=401wt.eu-S1752923AbYKKUrI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923AbYKKUrI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 15:47:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbYKKUq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 15:46:26 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:55215 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbYKKUqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 15:46:24 -0500
Message-Id: <20081111204622.763579486@goodmis.org>
References: <20081111204555.890501283@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 11 Nov 2008 15:45:57 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/3] ring-buffer: add reader lock
Content-Disposition: inline; filename=0002-ring-buffer-add-reader-lock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: serialize reader accesses to individual CPU ring buffers

The code in the ring buffer expects only one reader at a time, but currently
it puts that requirement on the caller. This is not strong enough, and this
patch adds a "reader_lock" that serializes the access to the reader API
of the ring buffer.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ring_buffer.c |  109 +++++++++++++++++++++++++++++++------------
 1 files changed, 78 insertions(+), 31 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 0a4f5c3..e3703b2 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -181,6 +181,7 @@ static inline int test_time_stamp(u64 delta)
 struct ring_buffer_per_cpu {
 	int				cpu;
 	struct ring_buffer		*buffer;
+	spinlock_t			reader_lock;
 	raw_spinlock_t			lock;
 	struct lock_class_key		lock_key;
 	struct list_head		pages;
@@ -348,6 +349,7 @@ rb_allocate_cpu_buffer(struct ring_buffer *buffer, int cpu)
 
 	cpu_buffer->cpu = cpu;
 	cpu_buffer->buffer = buffer;
+	spin_lock_init(&cpu_buffer->reader_lock);
 	cpu_buffer->lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
 	INIT_LIST_HEAD(&cpu_buffer->pages);
 
@@ -1509,6 +1511,9 @@ unsigned long ring_buffer_overruns(struct ring_buffer *buffer)
 void ring_buffer_iter_reset(struct ring_buffer_iter *iter)
 {
 	struct ring_buffer_per_cpu *cpu_buffer = iter->cpu_buffer;
+	unsigned long flags;
+
+	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
 
 	/* Iterator usage is expected to have record disabled */
 	if (list_empty(&cpu_buffer->reader_page->list)) {
@@ -1522,6 +1527,8 @@ void ring_buffer_iter_reset(struct ring_buffer_iter *iter)
 		iter->read_stamp = cpu_buffer->read_stamp;
 	else
 		iter->read_stamp = iter->head_page->time_stamp;
+
+	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 }
 
 /**
@@ -1740,17 +1747,8 @@ static void rb_advance_iter(struct ring_buffer_iter *iter)
 		rb_advance_iter(iter);
 }
 
-/**
- * ring_buffer_peek - peek at the next event to be read
- * @buffer: The ring buffer to read
- * @cpu: The cpu to peak at
- * @ts: The timestamp counter of this event.
- *
- * This will return the event that will be read next, but does
- * not consume the data.
- */
-struct ring_buffer_event *
-ring_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
+static struct ring_buffer_event *
+rb_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct ring_buffer_event *event;
@@ -1812,16 +1810,8 @@ ring_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
 	return NULL;
 }
 
-/**
- * ring_buffer_iter_peek - peek at the next event to be read
- * @iter: The ring buffer iterator
- * @ts: The timestamp counter of this event.
- *
- * This will return the event that will be read next, but does
- * not increment the iterator.
- */
-struct ring_buffer_event *
-ring_buffer_iter_peek(struct ring_buffer_iter *iter, u64 *ts)
+static struct ring_buffer_event *
+rb_iter_peek(struct ring_buffer_iter *iter, u64 *ts)
 {
 	struct ring_buffer *buffer;
 	struct ring_buffer_per_cpu *cpu_buffer;
@@ -1883,6 +1873,51 @@ ring_buffer_iter_peek(struct ring_buffer_iter *iter, u64 *ts)
 }
 
 /**
+ * ring_buffer_peek - peek at the next event to be read
+ * @buffer: The ring buffer to read
+ * @cpu: The cpu to peak at
+ * @ts: The timestamp counter of this event.
+ *
+ * This will return the event that will be read next, but does
+ * not consume the data.
+ */
+struct ring_buffer_event *
+ring_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
+{
+	struct ring_buffer_per_cpu *cpu_buffer = buffer->buffers[cpu];
+	struct ring_buffer_event *event;
+	unsigned long flags;
+
+	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
+	event = rb_buffer_peek(buffer, cpu, ts);
+	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
+
+	return event;
+}
+
+/**
+ * ring_buffer_iter_peek - peek at the next event to be read
+ * @iter: The ring buffer iterator
+ * @ts: The timestamp counter of this event.
+ *
+ * This will return the event that will be read next, but does
+ * not increment the iterator.
+ */
+struct ring_buffer_event *
+ring_buffer_iter_peek(struct ring_buffer_iter *iter, u64 *ts)
+{
+	struct ring_buffer_per_cpu *cpu_buffer = iter->cpu_buffer;
+	struct ring_buffer_event *event;
+	unsigned long flags;
+
+	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
+	event = rb_iter_peek(iter, ts);
+	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
+
+	return event;
+}
+
+/**
  * ring_buffer_consume - return an event and consume it
  * @buffer: The ring buffer to get the next event from
  *
@@ -1893,19 +1928,24 @@ ring_buffer_iter_peek(struct ring_buffer_iter *iter, u64 *ts)
 struct ring_buffer_event *
 ring_buffer_consume(struct ring_buffer *buffer, int cpu, u64 *ts)
 {
-	struct ring_buffer_per_cpu *cpu_buffer;
+	struct ring_buffer_per_cpu *cpu_buffer = buffer->buffers[cpu];
 	struct ring_buffer_event *event;
+	unsigned long flags;
 
 	if (!cpu_isset(cpu, buffer->cpumask))
 		return NULL;
 
-	event = ring_buffer_peek(buffer, cpu, ts);
+	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
+
+	event = rb_buffer_peek(buffer, cpu, ts);
 	if (!event)
-		return NULL;
+		goto out;
 
-	cpu_buffer = buffer->buffers[cpu];
 	rb_advance_reader(cpu_buffer);
 
+ out:
+	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
+
 	return event;
 }
 
@@ -1942,11 +1982,11 @@ ring_buffer_read_start(struct ring_buffer *buffer, int cpu)
 	atomic_inc(&cpu_buffer->record_disabled);
 	synchronize_sched();
 
-	local_irq_save(flags);
+	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
 	__raw_spin_lock(&cpu_buffer->lock);
 	ring_buffer_iter_reset(iter);
 	__raw_spin_unlock(&cpu_buffer->lock);
-	local_irq_restore(flags);
+	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
 	return iter;
 }
@@ -1978,12 +2018,17 @@ struct ring_buffer_event *
 ring_buffer_read(struct ring_buffer_iter *iter, u64 *ts)
 {
 	struct ring_buffer_event *event;
+	struct ring_buffer_per_cpu *cpu_buffer = iter->cpu_buffer;
+	unsigned long flags;
 
-	event = ring_buffer_iter_peek(iter, ts);
+	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
+	event = rb_iter_peek(iter, ts);
 	if (!event)
-		return NULL;
+		goto out;
 
 	rb_advance_iter(iter);
+ out:
+	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
 	return event;
 }
@@ -2032,13 +2077,15 @@ void ring_buffer_reset_cpu(struct ring_buffer *buffer, int cpu)
 	if (!cpu_isset(cpu, buffer->cpumask))
 		return;
 
-	local_irq_save(flags);
+	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
+
 	__raw_spin_lock(&cpu_buffer->lock);
 
 	rb_reset_cpu(cpu_buffer);
 
 	__raw_spin_unlock(&cpu_buffer->lock);
-	local_irq_restore(flags);
+
+	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 }
 
 /**
-- 
1.5.6.5

-- 
