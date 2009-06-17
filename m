Return-Path: <linux-kernel-owner+w=401wt.eu-S1757741AbZFQXjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757741AbZFQXjw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 19:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756526AbZFQXjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 19:39:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:33657 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755086AbZFQXjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 19:39:44 -0400
Message-Id: <20090617232630.762597258@goodmis.org>
References: <20090617232555.164629684@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 17 Jun 2009 19:26:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 6/7] ring-buffer: do not grab locks in nmi
Content-Disposition: inline; filename=0006-ring-buffer-do-not-grab-locks-in-nmi.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

If ftrace_dump_on_oops is set, and an NMI detects a lockup, then it
will need to read from the ring buffer. But the read side of the
ring buffer still takes locks. This patch adds a check on the read
side that if it is in an NMI, then it will disable the ring buffer
and not take any locks.

Reads can still happen on a disabled ring buffer.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |   59 ++++++++++++++++++++++++++++++++++++++------
 1 files changed, 51 insertions(+), 8 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 969f7cb..589b3ee 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2466,6 +2466,21 @@ rb_iter_peek(struct ring_buffer_iter *iter, u64 *ts)
 }
 EXPORT_SYMBOL_GPL(ring_buffer_iter_peek);
 
+static inline int rb_ok_to_lock(void)
+{
+	/*
+	 * If an NMI die dumps out the content of the ring buffer
+	 * do not grab locks. We also permanently disable the ring
+	 * buffer too. A one time deal is all you get from reading
+	 * the ring buffer from an NMI.
+	 */
+	if (likely(!in_nmi() && !oops_in_progress))
+		return 1;
+
+	tracing_off_permanent();
+	return 0;
+}
+
 /**
  * ring_buffer_peek - peek at the next event to be read
  * @buffer: The ring buffer to read
@@ -2481,14 +2496,20 @@ ring_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
 	struct ring_buffer_per_cpu *cpu_buffer = buffer->buffers[cpu];
 	struct ring_buffer_event *event;
 	unsigned long flags;
+	int dolock;
 
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		return NULL;
 
+	dolock = rb_ok_to_lock();
  again:
-	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
+	local_irq_save(flags);
+	if (dolock)
+		spin_lock(&cpu_buffer->reader_lock);
 	event = rb_buffer_peek(buffer, cpu, ts);
-	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
+	if (dolock)
+		spin_unlock(&cpu_buffer->reader_lock);
+	local_irq_restore(flags);
 
 	if (event && event->type_len == RINGBUF_TYPE_PADDING) {
 		cpu_relax();
@@ -2540,6 +2561,9 @@ ring_buffer_consume(struct ring_buffer *buffer, int cpu, u64 *ts)
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct ring_buffer_event *event = NULL;
 	unsigned long flags;
+	int dolock;
+
+	dolock = rb_ok_to_lock();
 
  again:
 	/* might be called in atomic */
@@ -2549,7 +2573,9 @@ ring_buffer_consume(struct ring_buffer *buffer, int cpu, u64 *ts)
 		goto out;
 
 	cpu_buffer = buffer->buffers[cpu];
-	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
+	local_irq_save(flags);
+	if (dolock)
+		spin_lock(&cpu_buffer->reader_lock);
 
 	event = rb_buffer_peek(buffer, cpu, ts);
 	if (!event)
@@ -2558,7 +2584,9 @@ ring_buffer_consume(struct ring_buffer *buffer, int cpu, u64 *ts)
 	rb_advance_reader(cpu_buffer);
 
  out_unlock:
-	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
+	if (dolock)
+		spin_unlock(&cpu_buffer->reader_lock);
+	local_irq_restore(flags);
 
  out:
 	preempt_enable();
@@ -2757,15 +2785,23 @@ int ring_buffer_empty(struct ring_buffer *buffer)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 	unsigned long flags;
+	int dolock;
 	int cpu;
 	int ret;
 
+	dolock = rb_ok_to_lock();
+
 	/* yes this is racy, but if you don't like the race, lock the buffer */
 	for_each_buffer_cpu(buffer, cpu) {
 		cpu_buffer = buffer->buffers[cpu];
-		spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
+		local_irq_save(flags);
+		if (dolock)
+			spin_lock(&cpu_buffer->reader_lock);
 		ret = rb_per_cpu_empty(cpu_buffer);
-		spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
+		if (dolock)
+			spin_unlock(&cpu_buffer->reader_lock);
+		local_irq_restore(flags);
+
 		if (!ret)
 			return 0;
 	}
@@ -2783,15 +2819,22 @@ int ring_buffer_empty_cpu(struct ring_buffer *buffer, int cpu)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 	unsigned long flags;
+	int dolock;
 	int ret;
 
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		return 1;
 
+	dolock = rb_ok_to_lock();
+
 	cpu_buffer = buffer->buffers[cpu];
-	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
+	local_irq_save(flags);
+	if (dolock)
+		spin_lock(&cpu_buffer->reader_lock);
 	ret = rb_per_cpu_empty(cpu_buffer);
-	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
+	if (dolock)
+		spin_unlock(&cpu_buffer->reader_lock);
+	local_irq_restore(flags);
 
 	return ret;
 }
-- 
1.6.3.1

-- 
