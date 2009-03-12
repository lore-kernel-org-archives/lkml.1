Return-Path: <linux-kernel-owner+w=401wt.eu-S1755987AbZCLClU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987AbZCLClU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 22:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754924AbZCLCjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 22:39:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:38780 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbZCLCjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 22:39:39 -0400
Message-Id: <20090312023936.696105567@goodmis.org>
References: <20090312023720.144716747@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 11 Mar 2009 22:37:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Wu Fengguang <fengguang.wu@intel.com>, Pierre Ossman <drzeus@drzeus.cx>,
       Pekka Paalanen <pq@iki.fi>, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 4/4] ring-buffer: only allocate buffers for online cpus
Content-Disposition: inline; filename=0004-ring-buffer-only-allocate-buffers-for-online-cpus.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: save on memory

Currently, a ring buffer was allocated for each "possible_cpus". On
some systems, this is the same as NR_CPUS. Thus, if a system defined
NR_CPUS = 64 but it only had 1 CPU, we could have possibly 63 useless
ring buffers taking up space. With a default buffer of 3 megs, this
could be quite drastic.

This patch changes the ring buffer code to only allocate ring buffers
for online CPUs.  If a CPU goes off line, we do not free the buffer.
This is because the user may still have trace data in that buffer
that they would like to look at.

Perhaps in the future we could add code to delete a ring buffer if
the CPU is offline and the ring buffer becomes empty.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ring_buffer.c |  266 +++++++++++++++++++++++++++++++++++--------
 kernel/trace/trace.c       |    6 -
 2 files changed, 216 insertions(+), 56 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 1788584..d07c288 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -16,6 +16,7 @@
 #include <linux/init.h>
 #include <linux/hash.h>
 #include <linux/list.h>
+#include <linux/cpu.h>
 #include <linux/fs.h>
 
 #include "trace.h"
@@ -301,6 +302,10 @@ struct ring_buffer {
 	struct mutex			mutex;
 
 	struct ring_buffer_per_cpu	**buffers;
+
+#ifdef CONFIG_HOTPLUG
+	struct notifier_block		cpu_notify;
+#endif
 };
 
 struct ring_buffer_iter {
@@ -459,6 +464,11 @@ static void rb_free_cpu_buffer(struct ring_buffer_per_cpu *cpu_buffer)
  */
 extern int ring_buffer_page_too_big(void);
 
+#ifdef CONFIG_HOTPLUG
+static int __cpuinit rb_cpu_notify(struct notifier_block *self,
+				   unsigned long action, void *hcpu);
+#endif
+
 /**
  * ring_buffer_alloc - allocate a new ring_buffer
  * @size: the size in bytes per cpu that is needed.
@@ -496,7 +506,8 @@ struct ring_buffer *ring_buffer_alloc(unsigned long size, unsigned flags)
 	if (buffer->pages == 1)
 		buffer->pages++;
 
-	cpumask_copy(buffer->cpumask, cpu_possible_mask);
+	get_online_cpus();
+	cpumask_copy(buffer->cpumask, cpu_online_mask);
 	buffer->cpus = nr_cpu_ids;
 
 	bsize = sizeof(void *) * nr_cpu_ids;
@@ -512,6 +523,13 @@ struct ring_buffer *ring_buffer_alloc(unsigned long size, unsigned flags)
 			goto fail_free_buffers;
 	}
 
+#ifdef CONFIG_HOTPLUG
+	buffer->cpu_notify.notifier_call = rb_cpu_notify;
+	buffer->cpu_notify.priority = 0;
+	register_cpu_notifier(&buffer->cpu_notify);
+#endif
+
+	put_online_cpus();
 	mutex_init(&buffer->mutex);
 
 	return buffer;
@@ -525,6 +543,7 @@ struct ring_buffer *ring_buffer_alloc(unsigned long size, unsigned flags)
 
  fail_free_cpumask:
 	free_cpumask_var(buffer->cpumask);
+	put_online_cpus();
 
  fail_free_buffer:
 	kfree(buffer);
@@ -541,9 +560,17 @@ ring_buffer_free(struct ring_buffer *buffer)
 {
 	int cpu;
 
+	get_online_cpus();
+
+#ifdef CONFIG_HOTPLUG
+	unregister_cpu_notifier(&buffer->cpu_notify);
+#endif
+
 	for_each_buffer_cpu(buffer, cpu)
 		rb_free_cpu_buffer(buffer->buffers[cpu]);
 
+	put_online_cpus();
+
 	free_cpumask_var(buffer->cpumask);
 
 	kfree(buffer);
@@ -649,16 +676,15 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size)
 		return size;
 
 	mutex_lock(&buffer->mutex);
+	get_online_cpus();
 
 	nr_pages = DIV_ROUND_UP(size, BUF_PAGE_SIZE);
 
 	if (size < buffer_size) {
 
 		/* easy case, just free pages */
-		if (RB_WARN_ON(buffer, nr_pages >= buffer->pages)) {
-			mutex_unlock(&buffer->mutex);
-			return -1;
-		}
+		if (RB_WARN_ON(buffer, nr_pages >= buffer->pages))
+			goto out_fail;
 
 		rm_pages = buffer->pages - nr_pages;
 
@@ -677,10 +703,8 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size)
 	 * add these pages to the cpu_buffers. Otherwise we just free
 	 * them all and return -ENOMEM;
 	 */
-	if (RB_WARN_ON(buffer, nr_pages <= buffer->pages)) {
-		mutex_unlock(&buffer->mutex);
-		return -1;
-	}
+	if (RB_WARN_ON(buffer, nr_pages <= buffer->pages))
+		goto out_fail;
 
 	new_pages = nr_pages - buffer->pages;
 
@@ -705,13 +729,12 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size)
 		rb_insert_pages(cpu_buffer, &pages, new_pages);
 	}
 
-	if (RB_WARN_ON(buffer, !list_empty(&pages))) {
-		mutex_unlock(&buffer->mutex);
-		return -1;
-	}
+	if (RB_WARN_ON(buffer, !list_empty(&pages)))
+		goto out_fail;
 
  out:
 	buffer->pages = nr_pages;
+	put_online_cpus();
 	mutex_unlock(&buffer->mutex);
 
 	return size;
@@ -721,8 +744,18 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size)
 		list_del_init(&bpage->list);
 		free_buffer_page(bpage);
 	}
+	put_online_cpus();
 	mutex_unlock(&buffer->mutex);
 	return -ENOMEM;
+
+	/*
+	 * Something went totally wrong, and we are too paranoid
+	 * to even clean up the mess.
+	 */
+ out_fail:
+	put_online_cpus();
+	mutex_unlock(&buffer->mutex);
+	return -1;
 }
 EXPORT_SYMBOL_GPL(ring_buffer_resize);
 
@@ -1528,11 +1561,15 @@ void ring_buffer_record_disable_cpu(struct ring_buffer *buffer, int cpu)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 
+	get_online_cpus();
+
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
-		return;
+		goto out;
 
 	cpu_buffer = buffer->buffers[cpu];
 	atomic_inc(&cpu_buffer->record_disabled);
+ out:
+	put_online_cpus();
 }
 EXPORT_SYMBOL_GPL(ring_buffer_record_disable_cpu);
 
@@ -1548,11 +1585,15 @@ void ring_buffer_record_enable_cpu(struct ring_buffer *buffer, int cpu)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 
+	get_online_cpus();
+
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
-		return;
+		goto out;
 
 	cpu_buffer = buffer->buffers[cpu];
 	atomic_dec(&cpu_buffer->record_disabled);
+ out:
+	put_online_cpus();
 }
 EXPORT_SYMBOL_GPL(ring_buffer_record_enable_cpu);
 
@@ -1564,12 +1605,19 @@ EXPORT_SYMBOL_GPL(ring_buffer_record_enable_cpu);
 unsigned long ring_buffer_entries_cpu(struct ring_buffer *buffer, int cpu)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
+	unsigned long ret = 0;
+
+	get_online_cpus();
 
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
-		return 0;
+		goto out;
 
 	cpu_buffer = buffer->buffers[cpu];
-	return cpu_buffer->entries;
+	ret = cpu_buffer->entries;
+ out:
+	put_online_cpus();
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(ring_buffer_entries_cpu);
 
@@ -1581,12 +1629,19 @@ EXPORT_SYMBOL_GPL(ring_buffer_entries_cpu);
 unsigned long ring_buffer_overrun_cpu(struct ring_buffer *buffer, int cpu)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
+	unsigned long ret = 0;
+
+	get_online_cpus();
 
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
-		return 0;
+		goto out;
 
 	cpu_buffer = buffer->buffers[cpu];
-	return cpu_buffer->overrun;
+	ret = cpu_buffer->overrun;
+ out:
+	put_online_cpus();
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(ring_buffer_overrun_cpu);
 
@@ -1603,12 +1658,16 @@ unsigned long ring_buffer_entries(struct ring_buffer *buffer)
 	unsigned long entries = 0;
 	int cpu;
 
+	get_online_cpus();
+
 	/* if you care about this being correct, lock the buffer */
 	for_each_buffer_cpu(buffer, cpu) {
 		cpu_buffer = buffer->buffers[cpu];
 		entries += cpu_buffer->entries;
 	}
 
+	put_online_cpus();
+
 	return entries;
 }
 EXPORT_SYMBOL_GPL(ring_buffer_entries);
@@ -1626,12 +1685,16 @@ unsigned long ring_buffer_overruns(struct ring_buffer *buffer)
 	unsigned long overruns = 0;
 	int cpu;
 
+	get_online_cpus();
+
 	/* if you care about this being correct, lock the buffer */
 	for_each_buffer_cpu(buffer, cpu) {
 		cpu_buffer = buffer->buffers[cpu];
 		overruns += cpu_buffer->overrun;
 	}
 
+	put_online_cpus();
+
 	return overruns;
 }
 EXPORT_SYMBOL_GPL(ring_buffer_overruns);
@@ -1663,9 +1726,14 @@ static void rb_iter_reset(struct ring_buffer_iter *iter)
  */
 void ring_buffer_iter_reset(struct ring_buffer_iter *iter)
 {
-	struct ring_buffer_per_cpu *cpu_buffer = iter->cpu_buffer;
+	struct ring_buffer_per_cpu *cpu_buffer;
 	unsigned long flags;
 
+	if (!iter)
+		return;
+
+	cpu_buffer = iter->cpu_buffer;
+
 	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
 	rb_iter_reset(iter);
 	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
@@ -1900,9 +1968,6 @@ rb_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
 	struct buffer_page *reader;
 	int nr_loops = 0;
 
-	if (!cpumask_test_cpu(cpu, buffer->cpumask))
-		return NULL;
-
 	cpu_buffer = buffer->buffers[cpu];
 
  again:
@@ -2028,13 +2093,21 @@ struct ring_buffer_event *
 ring_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
 {
 	struct ring_buffer_per_cpu *cpu_buffer = buffer->buffers[cpu];
-	struct ring_buffer_event *event;
+	struct ring_buffer_event *event = NULL;
 	unsigned long flags;
 
+	get_online_cpus();
+
+	if (!cpumask_test_cpu(cpu, buffer->cpumask))
+		goto out;
+
 	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
 	event = rb_buffer_peek(buffer, cpu, ts);
 	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
+ out:
+	put_online_cpus();
+
 	return event;
 }
 
@@ -2071,24 +2144,31 @@ ring_buffer_iter_peek(struct ring_buffer_iter *iter, u64 *ts)
 struct ring_buffer_event *
 ring_buffer_consume(struct ring_buffer *buffer, int cpu, u64 *ts)
 {
-	struct ring_buffer_per_cpu *cpu_buffer = buffer->buffers[cpu];
-	struct ring_buffer_event *event;
+	struct ring_buffer_per_cpu *cpu_buffer;
+	struct ring_buffer_event *event = NULL;
 	unsigned long flags;
 
+	/* might be called in atomic */
+	preempt_disable();
+
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
-		return NULL;
+		goto out;
 
+	cpu_buffer = buffer->buffers[cpu];
 	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
 
 	event = rb_buffer_peek(buffer, cpu, ts);
 	if (!event)
-		goto out;
+		goto out_unlock;
 
 	rb_advance_reader(cpu_buffer);
 
- out:
+ out_unlock:
 	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
+ out:
+	preempt_enable();
+
 	return event;
 }
 EXPORT_SYMBOL_GPL(ring_buffer_consume);
@@ -2109,15 +2189,17 @@ struct ring_buffer_iter *
 ring_buffer_read_start(struct ring_buffer *buffer, int cpu)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
-	struct ring_buffer_iter *iter;
+	struct ring_buffer_iter *iter = NULL;
 	unsigned long flags;
 
+	get_online_cpus();
+
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
-		return NULL;
+		goto out;
 
 	iter = kmalloc(sizeof(*iter), GFP_KERNEL);
 	if (!iter)
-		return NULL;
+		goto out;
 
 	cpu_buffer = buffer->buffers[cpu];
 
@@ -2132,6 +2214,9 @@ ring_buffer_read_start(struct ring_buffer *buffer, int cpu)
 	__raw_spin_unlock(&cpu_buffer->lock);
 	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
+ out:
+	put_online_cpus();
+
 	return iter;
 }
 EXPORT_SYMBOL_GPL(ring_buffer_read_start);
@@ -2224,9 +2309,13 @@ void ring_buffer_reset_cpu(struct ring_buffer *buffer, int cpu)
 {
 	struct ring_buffer_per_cpu *cpu_buffer = buffer->buffers[cpu];
 	unsigned long flags;
+	int resched;
+
+	/* Can't use get_online_cpus because this can be in atomic */
+	resched = ftrace_preempt_disable();
 
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
-		return;
+		goto out;
 
 	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
 
@@ -2237,6 +2326,8 @@ void ring_buffer_reset_cpu(struct ring_buffer *buffer, int cpu)
 	__raw_spin_unlock(&cpu_buffer->lock);
 
 	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
+ out:
+	ftrace_preempt_enable(resched);
 }
 EXPORT_SYMBOL_GPL(ring_buffer_reset_cpu);
 
@@ -2246,10 +2337,16 @@ EXPORT_SYMBOL_GPL(ring_buffer_reset_cpu);
  */
 void ring_buffer_reset(struct ring_buffer *buffer)
 {
+	int resched;
 	int cpu;
 
+	/* Can't use get_online_cpus because this can be in atomic */
+	resched = ftrace_preempt_disable();
+
 	for_each_buffer_cpu(buffer, cpu)
 		ring_buffer_reset_cpu(buffer, cpu);
+
+	ftrace_preempt_enable(resched);
 }
 EXPORT_SYMBOL_GPL(ring_buffer_reset);
 
@@ -2262,12 +2359,17 @@ int ring_buffer_empty(struct ring_buffer *buffer)
 	struct ring_buffer_per_cpu *cpu_buffer;
 	int cpu;
 
+	get_online_cpus();
+
 	/* yes this is racy, but if you don't like the race, lock the buffer */
 	for_each_buffer_cpu(buffer, cpu) {
 		cpu_buffer = buffer->buffers[cpu];
 		if (!rb_per_cpu_empty(cpu_buffer))
 			return 0;
 	}
+
+	put_online_cpus();
+
 	return 1;
 }
 EXPORT_SYMBOL_GPL(ring_buffer_empty);
@@ -2280,12 +2382,20 @@ EXPORT_SYMBOL_GPL(ring_buffer_empty);
 int ring_buffer_empty_cpu(struct ring_buffer *buffer, int cpu)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
+	int ret = 1;
+
+	get_online_cpus();
 
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
-		return 1;
+		goto out;
 
 	cpu_buffer = buffer->buffers[cpu];
-	return rb_per_cpu_empty(cpu_buffer);
+	ret = rb_per_cpu_empty(cpu_buffer);
+
+ out:
+	put_online_cpus();
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(ring_buffer_empty_cpu);
 
@@ -2304,32 +2414,37 @@ int ring_buffer_swap_cpu(struct ring_buffer *buffer_a,
 {
 	struct ring_buffer_per_cpu *cpu_buffer_a;
 	struct ring_buffer_per_cpu *cpu_buffer_b;
+	int ret = -EINVAL;
+
+	get_online_cpus();
 
 	if (!cpumask_test_cpu(cpu, buffer_a->cpumask) ||
 	    !cpumask_test_cpu(cpu, buffer_b->cpumask))
-		return -EINVAL;
+		goto out;
 
 	/* At least make sure the two buffers are somewhat the same */
 	if (buffer_a->pages != buffer_b->pages)
-		return -EINVAL;
+		goto out;
+
+	ret = -EAGAIN;
 
 	if (ring_buffer_flags != RB_BUFFERS_ON)
-		return -EAGAIN;
+		goto out;
 
 	if (atomic_read(&buffer_a->record_disabled))
-		return -EAGAIN;
+		goto out;
 
 	if (atomic_read(&buffer_b->record_disabled))
-		return -EAGAIN;
+		goto out;
 
 	cpu_buffer_a = buffer_a->buffers[cpu];
 	cpu_buffer_b = buffer_b->buffers[cpu];
 
 	if (atomic_read(&cpu_buffer_a->record_disabled))
-		return -EAGAIN;
+		goto out;
 
 	if (atomic_read(&cpu_buffer_b->record_disabled))
-		return -EAGAIN;
+		goto out;
 
 	/*
 	 * We can't do a synchronize_sched here because this
@@ -2349,7 +2464,11 @@ int ring_buffer_swap_cpu(struct ring_buffer *buffer_a,
 	atomic_dec(&cpu_buffer_a->record_disabled);
 	atomic_dec(&cpu_buffer_b->record_disabled);
 
-	return 0;
+	ret = 0;
+out:
+	put_online_cpus();
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(ring_buffer_swap_cpu);
 
@@ -2464,27 +2583,32 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 	u64 save_timestamp;
 	int ret = -1;
 
+	get_online_cpus();
+
+	if (!cpumask_test_cpu(cpu, buffer->cpumask))
+		goto out;
+
 	/*
 	 * If len is not big enough to hold the page header, then
 	 * we can not copy anything.
 	 */
 	if (len <= BUF_PAGE_HDR_SIZE)
-		return -1;
+		goto out;
 
 	len -= BUF_PAGE_HDR_SIZE;
 
 	if (!data_page)
-		return -1;
+		goto out;
 
 	bpage = *data_page;
 	if (!bpage)
-		return -1;
+		goto out;
 
 	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
 
 	reader = rb_get_reader_page(cpu_buffer);
 	if (!reader)
-		goto out;
+		goto out_unlock;
 
 	event = rb_reader_event(cpu_buffer);
 
@@ -2506,7 +2630,7 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 		unsigned int size;
 
 		if (full)
-			goto out;
+			goto out_unlock;
 
 		if (len > (commit - read))
 			len = (commit - read);
@@ -2514,7 +2638,7 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 		size = rb_event_length(event);
 
 		if (len < size)
-			goto out;
+			goto out_unlock;
 
 		/* save the current timestamp, since the user will need it */
 		save_timestamp = cpu_buffer->read_stamp;
@@ -2553,9 +2677,12 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 	}
 	ret = read;
 
- out:
+ out_unlock:
 	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
+ out:
+	put_online_cpus();
+
 	return ret;
 }
 
@@ -2629,3 +2756,42 @@ static __init int rb_init_debugfs(void)
 }
 
 fs_initcall(rb_init_debugfs);
+
+#ifdef CONFIG_HOTPLUG
+static int __cpuinit rb_cpu_notify(struct notifier_block *self,
+				   unsigned long action, void *hcpu)
+{
+	struct ring_buffer *buffer =
+		container_of(self, struct ring_buffer, cpu_notify);
+	long cpu = (long)hcpu;
+
+	switch (action) {
+	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
+		if (cpu_isset(cpu, *buffer->cpumask))
+			return NOTIFY_OK;
+
+		buffer->buffers[cpu] =
+			rb_allocate_cpu_buffer(buffer, cpu);
+		if (!buffer->buffers[cpu]) {
+			WARN(1, "failed to allocate ring buffer on CPU %ld\n",
+			     cpu);
+			return NOTIFY_OK;
+		}
+		smp_wmb();
+		cpu_set(cpu, *buffer->cpumask);
+		break;
+	case CPU_DOWN_PREPARE:
+	case CPU_DOWN_PREPARE_FROZEN:
+		/*
+		 * Do nothing.
+		 *  If we were to free the buffer, then the user would
+		 *  lose any trace that was in the buffer.
+		 */
+		break;
+	default:
+		break;
+	}
+	return NOTIFY_OK;
+}
+#endif
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index e60f4be..14c98f6 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1805,17 +1805,11 @@ __tracing_open(struct inode *inode, struct file *file)
 
 			iter->buffer_iter[cpu] =
 				ring_buffer_read_start(iter->tr->buffer, cpu);
-
-			if (!iter->buffer_iter[cpu])
-				goto fail_buffer;
 		}
 	} else {
 		cpu = iter->cpu_file;
 		iter->buffer_iter[cpu] =
 				ring_buffer_read_start(iter->tr->buffer, cpu);
-
-		if (!iter->buffer_iter[cpu])
-			goto fail;
 	}
 
 	/* TODO stop tracer */
-- 
1.6.1.3

-- 
