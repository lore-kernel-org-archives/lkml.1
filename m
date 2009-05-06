Return-Path: <linux-kernel-owner+w=401wt.eu-S1753800AbZEFEZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800AbZEFEZZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 00:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752253AbZEFEXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 00:23:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:56410 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbZEFEXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 00:23:34 -0400
Message-Id: <20090506042333.156928467@goodmis.org>
References: <20090506042101.231470089@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 06 May 2009 00:21:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 02/11] ring-buffer: add counters for commit overrun and nmi dropped entries
Content-Disposition: inline; filename=0002-ring-buffer-add-counters-for-commit-overrun-and-nmi.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The WARN_ON in the ring buffer when a commit is preempted and the
buffer is filled by preceding writes can happen in normal operations.
The WARN_ON makes it look like a bug, not to mention, because
it does not stop tracing and calls printk which can also recurse, this
is prone to deadlock (the WARN_ON is not in a position to recurse).

This patch removes the WARN_ON and replaces it with a counter that
can be retrieved by a tracer. This counter is called commit_overrun.

While at it, I added a nmi_dropped counter to count any time an NMI entry
is dropped because the NMI could not take the spinlock.

[ Impact: prevent deadlock by printing normal case warning ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ring_buffer.h |    2 +
 kernel/trace/ring_buffer.c  |   52 ++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 51 insertions(+), 3 deletions(-)

diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index 1c2f809..f134582 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -153,6 +153,8 @@ unsigned long ring_buffer_entries(struct ring_buffer *buffer);
 unsigned long ring_buffer_overruns(struct ring_buffer *buffer);
 unsigned long ring_buffer_entries_cpu(struct ring_buffer *buffer, int cpu);
 unsigned long ring_buffer_overrun_cpu(struct ring_buffer *buffer, int cpu);
+unsigned long ring_buffer_commit_overrun_cpu(struct ring_buffer *buffer, int cpu);
+unsigned long ring_buffer_nmi_dropped_cpu(struct ring_buffer *buffer, int cpu);
 
 u64 ring_buffer_time_stamp(struct ring_buffer *buffer, int cpu);
 void ring_buffer_normalize_time_stamp(struct ring_buffer *buffer,
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 3e86da9..26e1359 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -402,6 +402,8 @@ struct ring_buffer_per_cpu {
 	struct buffer_page		*tail_page;	/* write to tail */
 	struct buffer_page		*commit_page;	/* committed pages */
 	struct buffer_page		*reader_page;
+	unsigned long			nmi_dropped;
+	unsigned long			commit_overrun;
 	unsigned long			overrun;
 	unsigned long			entries;
 	u64				write_stamp;
@@ -1216,8 +1218,10 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 		 * simply fail.
 		 */
 		if (unlikely(in_nmi())) {
-			if (!__raw_spin_trylock(&cpu_buffer->lock))
+			if (!__raw_spin_trylock(&cpu_buffer->lock)) {
+				cpu_buffer->nmi_dropped++;
 				goto out_reset;
+			}
 		} else
 			__raw_spin_lock(&cpu_buffer->lock);
 
@@ -1238,8 +1242,7 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 		 * about it.
 		 */
 		if (unlikely(next_page == commit_page)) {
-			/* This can easily happen on small ring buffers */
-			WARN_ON_ONCE(buffer->pages > 2);
+			cpu_buffer->commit_overrun++;
 			goto out_reset;
 		}
 
@@ -1926,6 +1929,47 @@ unsigned long ring_buffer_overrun_cpu(struct ring_buffer *buffer, int cpu)
 EXPORT_SYMBOL_GPL(ring_buffer_overrun_cpu);
 
 /**
+ * ring_buffer_nmi_dropped_cpu - get the number of nmis that were dropped
+ * @buffer: The ring buffer
+ * @cpu: The per CPU buffer to get the number of overruns from
+ */
+unsigned long ring_buffer_nmi_dropped_cpu(struct ring_buffer *buffer, int cpu)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+	unsigned long ret;
+
+	if (!cpumask_test_cpu(cpu, buffer->cpumask))
+		return 0;
+
+	cpu_buffer = buffer->buffers[cpu];
+	ret = cpu_buffer->nmi_dropped;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ring_buffer_nmi_dropped_cpu);
+
+/**
+ * ring_buffer_commit_overrun_cpu - get the number of overruns caused by commits
+ * @buffer: The ring buffer
+ * @cpu: The per CPU buffer to get the number of overruns from
+ */
+unsigned long
+ring_buffer_commit_overrun_cpu(struct ring_buffer *buffer, int cpu)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+	unsigned long ret;
+
+	if (!cpumask_test_cpu(cpu, buffer->cpumask))
+		return 0;
+
+	cpu_buffer = buffer->buffers[cpu];
+	ret = cpu_buffer->commit_overrun;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ring_buffer_commit_overrun_cpu);
+
+/**
  * ring_buffer_entries - get the number of entries in a buffer
  * @buffer: The ring buffer
  *
@@ -2595,6 +2639,8 @@ rb_reset_cpu(struct ring_buffer_per_cpu *cpu_buffer)
 	local_set(&cpu_buffer->reader_page->page->commit, 0);
 	cpu_buffer->reader_page->read = 0;
 
+	cpu_buffer->nmi_dropped = 0;
+	cpu_buffer->commit_overrun = 0;
 	cpu_buffer->overrun = 0;
 	cpu_buffer->entries = 0;
 
-- 
1.6.2.4

-- 
