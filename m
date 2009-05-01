Return-Path: <linux-kernel-owner+w=401wt.eu-S1761915AbZEACZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761915AbZEACZI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 22:25:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757799AbZEACYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 22:24:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:65419 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755066AbZEACYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 22:24:05 -0400
Message-Id: <20090501022403.826182932@goodmis.org>
References: <20090501022210.851418183@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 30 Apr 2009 22:22:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 3/3] ring-buffer: make cpu buffer entries counter atomic
Content-Disposition: inline; filename=0003-ring-buffer-make-cpu-buffer-entries-counter-atomic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The entries counter in cpu buffer is not atomic. Although it only gets
updated by a single CPU, interrupts may come in and update the counter
too. This would cause missing entries to be added.

[ Impact: keep accurate count of cpu buffer entries ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index dc8b2ab..3b9b32b 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -405,7 +405,7 @@ struct ring_buffer_per_cpu {
 	unsigned long			nmi_dropped;
 	unsigned long			commit_overrun;
 	unsigned long			overrun;
-	unsigned long			entries;
+	atomic_t			entries;
 	u64				write_stamp;
 	u64				read_stamp;
 	atomic_t			record_disabled;
@@ -997,7 +997,7 @@ static void rb_update_overflow(struct ring_buffer_per_cpu *cpu_buffer)
 		if (event->type_len > RINGBUF_TYPE_DATA_TYPE_LEN_MAX)
 			continue;
 		cpu_buffer->overrun++;
-		cpu_buffer->entries--;
+		atomic_dec(&cpu_buffer->entries);
 	}
 }
 
@@ -1588,7 +1588,7 @@ EXPORT_SYMBOL_GPL(ring_buffer_lock_reserve);
 static void rb_commit(struct ring_buffer_per_cpu *cpu_buffer,
 		      struct ring_buffer_event *event)
 {
-	cpu_buffer->entries++;
+	atomic_inc(&cpu_buffer->entries);
 
 	/* Only process further if we own the commit */
 	if (!rb_is_commit(cpu_buffer, event))
@@ -1722,7 +1722,7 @@ void ring_buffer_discard_commit(struct ring_buffer *buffer,
 	 * The commit is still visible by the reader, so we
 	 * must increment entries.
 	 */
-	cpu_buffer->entries++;
+	atomic_inc(&cpu_buffer->entries);
  out:
 	/*
 	 * If a write came in and pushed the tail page
@@ -1902,7 +1902,7 @@ unsigned long ring_buffer_entries_cpu(struct ring_buffer *buffer, int cpu)
 		return 0;
 
 	cpu_buffer = buffer->buffers[cpu];
-	ret = cpu_buffer->entries;
+	ret = atomic_read(&cpu_buffer->entries);
 
 	return ret;
 }
@@ -1985,7 +1985,7 @@ unsigned long ring_buffer_entries(struct ring_buffer *buffer)
 	/* if you care about this being correct, lock the buffer */
 	for_each_buffer_cpu(buffer, cpu) {
 		cpu_buffer = buffer->buffers[cpu];
-		entries += cpu_buffer->entries;
+		entries += atomic_read(&cpu_buffer->entries);
 	}
 
 	return entries;
@@ -2225,7 +2225,7 @@ static void rb_advance_reader(struct ring_buffer_per_cpu *cpu_buffer)
 
 	if (event->type_len <= RINGBUF_TYPE_DATA_TYPE_LEN_MAX
 			|| rb_discarded_event(event))
-		cpu_buffer->entries--;
+		atomic_dec(&cpu_buffer->entries);
 
 	rb_update_read_stamp(cpu_buffer, event);
 
@@ -2642,7 +2642,7 @@ rb_reset_cpu(struct ring_buffer_per_cpu *cpu_buffer)
 	cpu_buffer->nmi_dropped = 0;
 	cpu_buffer->commit_overrun = 0;
 	cpu_buffer->overrun = 0;
-	cpu_buffer->entries = 0;
+	atomic_set(&cpu_buffer->entries, 0);
 
 	cpu_buffer->write_stamp = 0;
 	cpu_buffer->read_stamp = 0;
@@ -2813,7 +2813,7 @@ static void rb_remove_entries(struct ring_buffer_per_cpu *cpu_buffer,
 		/* Only count data entries */
 		if (event->type_len > RINGBUF_TYPE_DATA_TYPE_LEN_MAX)
 			continue;
-		cpu_buffer->entries--;
+		atomic_dec(&cpu_buffer->entries);
 	}
 	__raw_spin_unlock(&cpu_buffer->lock);
 }
-- 
1.6.2.1

-- 
