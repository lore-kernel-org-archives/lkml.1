Return-Path: <linux-kernel-owner+w=401wt.eu-S1758024AbZCMClW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758024AbZCMClW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 22:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757758AbZCMCid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 22:38:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:56567 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758533AbZCMCi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 22:38:28 -0400
Message-Id: <20090313023825.732455452@goodmis.org>
References: <20090313023704.971438367@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 12 Mar 2009 22:37:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 04/16] ring-buffer: remove unneeded get_online_cpus
Content-Disposition: inline; filename=0004-ring-buffer-remove-unneeded-get_online_cpus.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: speed up and remove possible races

The get_online_cpus was added to the ring buffer because the original
design would free the ring buffer on a CPU that was being taken
off line. The final design kept the ring buffer around even when the
CPU was taken off line. This is to allow a user to still read the
information on that ring buffer.

Most of the get_online_cpus are no longer needed since the ring buffer will
not disappear from the use cases.

Reported-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ring_buffer.c |   90 +++++++-------------------------------------
 1 files changed, 14 insertions(+), 76 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 035b56c..2c36be9 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1561,15 +1561,11 @@ void ring_buffer_record_disable_cpu(struct ring_buffer *buffer, int cpu)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 
-	get_online_cpus();
-
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
-		goto out;
+		return;
 
 	cpu_buffer = buffer->buffers[cpu];
 	atomic_inc(&cpu_buffer->record_disabled);
- out:
-	put_online_cpus();
 }
 EXPORT_SYMBOL_GPL(ring_buffer_record_disable_cpu);
 
@@ -1585,15 +1581,11 @@ void ring_buffer_record_enable_cpu(struct ring_buffer *buffer, int cpu)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 
-	get_online_cpus();
-
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
-		goto out;
+		return;
 
 	cpu_buffer = buffer->buffers[cpu];
 	atomic_dec(&cpu_buffer->record_disabled);
- out:
-	put_online_cpus();
 }
 EXPORT_SYMBOL_GPL(ring_buffer_record_enable_cpu);
 
@@ -1605,17 +1597,13 @@ EXPORT_SYMBOL_GPL(ring_buffer_record_enable_cpu);
 unsigned long ring_buffer_entries_cpu(struct ring_buffer *buffer, int cpu)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
-	unsigned long ret = 0;
-
-	get_online_cpus();
+	unsigned long ret;
 
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
-		goto out;
+		return 0;
 
 	cpu_buffer = buffer->buffers[cpu];
 	ret = cpu_buffer->entries;
- out:
-	put_online_cpus();
 
 	return ret;
 }
@@ -1629,17 +1617,13 @@ EXPORT_SYMBOL_GPL(ring_buffer_entries_cpu);
 unsigned long ring_buffer_overrun_cpu(struct ring_buffer *buffer, int cpu)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
-	unsigned long ret = 0;
-
-	get_online_cpus();
+	unsigned long ret;
 
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
-		goto out;
+		return 0;
 
 	cpu_buffer = buffer->buffers[cpu];
 	ret = cpu_buffer->overrun;
- out:
-	put_online_cpus();
 
 	return ret;
 }
@@ -1658,16 +1642,12 @@ unsigned long ring_buffer_entries(struct ring_buffer *buffer)
 	unsigned long entries = 0;
 	int cpu;
 
-	get_online_cpus();
-
 	/* if you care about this being correct, lock the buffer */
 	for_each_buffer_cpu(buffer, cpu) {
 		cpu_buffer = buffer->buffers[cpu];
 		entries += cpu_buffer->entries;
 	}
 
-	put_online_cpus();
-
 	return entries;
 }
 EXPORT_SYMBOL_GPL(ring_buffer_entries);
@@ -1685,16 +1665,12 @@ unsigned long ring_buffer_overruns(struct ring_buffer *buffer)
 	unsigned long overruns = 0;
 	int cpu;
 
-	get_online_cpus();
-
 	/* if you care about this being correct, lock the buffer */
 	for_each_buffer_cpu(buffer, cpu) {
 		cpu_buffer = buffer->buffers[cpu];
 		overruns += cpu_buffer->overrun;
 	}
 
-	put_online_cpus();
-
 	return overruns;
 }
 EXPORT_SYMBOL_GPL(ring_buffer_overruns);
@@ -2093,21 +2069,16 @@ struct ring_buffer_event *
 ring_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
 {
 	struct ring_buffer_per_cpu *cpu_buffer = buffer->buffers[cpu];
-	struct ring_buffer_event *event = NULL;
+	struct ring_buffer_event *event;
 	unsigned long flags;
 
-	get_online_cpus();
-
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
-		goto out;
+		return NULL;
 
 	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
 	event = rb_buffer_peek(buffer, cpu, ts);
 	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
- out:
-	put_online_cpus();
-
 	return event;
 }
 
@@ -2189,17 +2160,15 @@ struct ring_buffer_iter *
 ring_buffer_read_start(struct ring_buffer *buffer, int cpu)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
-	struct ring_buffer_iter *iter = NULL;
+	struct ring_buffer_iter *iter;
 	unsigned long flags;
 
-	get_online_cpus();
-
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
-		goto out;
+		return NULL;
 
 	iter = kmalloc(sizeof(*iter), GFP_KERNEL);
 	if (!iter)
-		goto out;
+		return NULL;
 
 	cpu_buffer = buffer->buffers[cpu];
 
@@ -2214,9 +2183,6 @@ ring_buffer_read_start(struct ring_buffer *buffer, int cpu)
 	__raw_spin_unlock(&cpu_buffer->lock);
 	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
- out:
-	put_online_cpus();
-
 	return iter;
 }
 EXPORT_SYMBOL_GPL(ring_buffer_read_start);
@@ -2309,13 +2275,9 @@ void ring_buffer_reset_cpu(struct ring_buffer *buffer, int cpu)
 {
 	struct ring_buffer_per_cpu *cpu_buffer = buffer->buffers[cpu];
 	unsigned long flags;
-	int resched;
-
-	/* Can't use get_online_cpus because this can be in atomic */
-	resched = ftrace_preempt_disable();
 
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
-		goto out;
+		return;
 
 	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
 
@@ -2326,8 +2288,6 @@ void ring_buffer_reset_cpu(struct ring_buffer *buffer, int cpu)
 	__raw_spin_unlock(&cpu_buffer->lock);
 
 	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
- out:
-	ftrace_preempt_enable(resched);
 }
 EXPORT_SYMBOL_GPL(ring_buffer_reset_cpu);
 
@@ -2337,16 +2297,10 @@ EXPORT_SYMBOL_GPL(ring_buffer_reset_cpu);
  */
 void ring_buffer_reset(struct ring_buffer *buffer)
 {
-	int resched;
 	int cpu;
 
-	/* Can't use get_online_cpus because this can be in atomic */
-	resched = ftrace_preempt_disable();
-
 	for_each_buffer_cpu(buffer, cpu)
 		ring_buffer_reset_cpu(buffer, cpu);
-
-	ftrace_preempt_enable(resched);
 }
 EXPORT_SYMBOL_GPL(ring_buffer_reset);
 
@@ -2359,8 +2313,6 @@ int ring_buffer_empty(struct ring_buffer *buffer)
 	struct ring_buffer_per_cpu *cpu_buffer;
 	int cpu;
 
-	get_online_cpus();
-
 	/* yes this is racy, but if you don't like the race, lock the buffer */
 	for_each_buffer_cpu(buffer, cpu) {
 		cpu_buffer = buffer->buffers[cpu];
@@ -2368,8 +2320,6 @@ int ring_buffer_empty(struct ring_buffer *buffer)
 			return 0;
 	}
 
-	put_online_cpus();
-
 	return 1;
 }
 EXPORT_SYMBOL_GPL(ring_buffer_empty);
@@ -2382,18 +2332,14 @@ EXPORT_SYMBOL_GPL(ring_buffer_empty);
 int ring_buffer_empty_cpu(struct ring_buffer *buffer, int cpu)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
-	int ret = 1;
-
-	get_online_cpus();
+	int ret;
 
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
-		goto out;
+		return 1;
 
 	cpu_buffer = buffer->buffers[cpu];
 	ret = rb_per_cpu_empty(cpu_buffer);
 
- out:
-	put_online_cpus();
 
 	return ret;
 }
@@ -2416,8 +2362,6 @@ int ring_buffer_swap_cpu(struct ring_buffer *buffer_a,
 	struct ring_buffer_per_cpu *cpu_buffer_b;
 	int ret = -EINVAL;
 
-	get_online_cpus();
-
 	if (!cpumask_test_cpu(cpu, buffer_a->cpumask) ||
 	    !cpumask_test_cpu(cpu, buffer_b->cpumask))
 		goto out;
@@ -2466,8 +2410,6 @@ int ring_buffer_swap_cpu(struct ring_buffer *buffer_a,
 
 	ret = 0;
 out:
-	put_online_cpus();
-
 	return ret;
 }
 EXPORT_SYMBOL_GPL(ring_buffer_swap_cpu);
@@ -2583,8 +2525,6 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 	u64 save_timestamp;
 	int ret = -1;
 
-	get_online_cpus();
-
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		goto out;
 
@@ -2681,8 +2621,6 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
  out:
-	put_online_cpus();
-
 	return ret;
 }
 
-- 
1.6.1.3

-- 
