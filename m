Return-Path: <linux-kernel-owner+w=401wt.eu-S1754456AbZEFEYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456AbZEFEYo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 00:24:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752103AbZEFEXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 00:23:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:56412 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbZEFEXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 00:23:34 -0400
Message-Id: <20090506042333.631773425@goodmis.org>
References: <20090506042101.231470089@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 06 May 2009 00:21:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 04/11] ring-buffer: convert cpu buffer entries to local_t
Content-Disposition: inline; filename=0004-ring-buffer-convert-cpu-buffer-entries-to-local_t.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The entries counter in cpu buffer is not atomic. It can be updated by
other interrupts or from another CPU (readers).

But making entries into "atomic_t" causes an atomic operation that can
hurt performance. Instead we convert it to a local_t that will increment
a counter with a local CPU atomic operation (if the arch supports it).

Instead of fighting with readers and overwrites that decrement the counter,
I added a "read" counter. Every time a reader reads an entry it is
incremented.

We already have a overrun counter and with that, the entries counter and
the read counter, we can calculate the total number of entries in the
buffer with:

  (entries - overrun) - read

As long as the total number of entries in the ring buffer is less than
the word size, this will work. But since the entries counter was previously
a long, this is no different than what we had before.

Thanks to Andrew Morton for pointing out in the first version that
atomic_t does not replace unsigned long. I switched to atomic_long_t
even though it is signed. A negative count is most likely a bug.

[ Impact: keep accurate count of cpu buffer entries ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |   21 ++++++++++++---------
 1 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 26e1359..c792ea8 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -405,7 +405,8 @@ struct ring_buffer_per_cpu {
 	unsigned long			nmi_dropped;
 	unsigned long			commit_overrun;
 	unsigned long			overrun;
-	unsigned long			entries;
+	unsigned long			read;
+	local_t				entries;
 	u64				write_stamp;
 	u64				read_stamp;
 	atomic_t			record_disabled;
@@ -997,7 +998,6 @@ static void rb_update_overflow(struct ring_buffer_per_cpu *cpu_buffer)
 		if (event->type_len > RINGBUF_TYPE_DATA_TYPE_LEN_MAX)
 			continue;
 		cpu_buffer->overrun++;
-		cpu_buffer->entries--;
 	}
 }
 
@@ -1588,7 +1588,7 @@ EXPORT_SYMBOL_GPL(ring_buffer_lock_reserve);
 static void rb_commit(struct ring_buffer_per_cpu *cpu_buffer,
 		      struct ring_buffer_event *event)
 {
-	cpu_buffer->entries++;
+	local_inc(&cpu_buffer->entries);
 
 	/* Only process further if we own the commit */
 	if (!rb_is_commit(cpu_buffer, event))
@@ -1722,7 +1722,7 @@ void ring_buffer_discard_commit(struct ring_buffer *buffer,
 	 * The commit is still visible by the reader, so we
 	 * must increment entries.
 	 */
-	cpu_buffer->entries++;
+	local_inc(&cpu_buffer->entries);
  out:
 	/*
 	 * If a write came in and pushed the tail page
@@ -1902,7 +1902,8 @@ unsigned long ring_buffer_entries_cpu(struct ring_buffer *buffer, int cpu)
 		return 0;
 
 	cpu_buffer = buffer->buffers[cpu];
-	ret = cpu_buffer->entries;
+	ret = (local_read(&cpu_buffer->entries) - cpu_buffer->overrun)
+		- cpu_buffer->read;
 
 	return ret;
 }
@@ -1985,7 +1986,8 @@ unsigned long ring_buffer_entries(struct ring_buffer *buffer)
 	/* if you care about this being correct, lock the buffer */
 	for_each_buffer_cpu(buffer, cpu) {
 		cpu_buffer = buffer->buffers[cpu];
-		entries += cpu_buffer->entries;
+		entries += (local_read(&cpu_buffer->entries) -
+			    cpu_buffer->overrun) - cpu_buffer->read;
 	}
 
 	return entries;
@@ -2225,7 +2227,7 @@ static void rb_advance_reader(struct ring_buffer_per_cpu *cpu_buffer)
 
 	if (event->type_len <= RINGBUF_TYPE_DATA_TYPE_LEN_MAX
 			|| rb_discarded_event(event))
-		cpu_buffer->entries--;
+		cpu_buffer->read++;
 
 	rb_update_read_stamp(cpu_buffer, event);
 
@@ -2642,7 +2644,8 @@ rb_reset_cpu(struct ring_buffer_per_cpu *cpu_buffer)
 	cpu_buffer->nmi_dropped = 0;
 	cpu_buffer->commit_overrun = 0;
 	cpu_buffer->overrun = 0;
-	cpu_buffer->entries = 0;
+	cpu_buffer->read = 0;
+	local_set(&cpu_buffer->entries, 0);
 
 	cpu_buffer->write_stamp = 0;
 	cpu_buffer->read_stamp = 0;
@@ -2813,7 +2816,7 @@ static void rb_remove_entries(struct ring_buffer_per_cpu *cpu_buffer,
 		/* Only count data entries */
 		if (event->type_len > RINGBUF_TYPE_DATA_TYPE_LEN_MAX)
 			continue;
-		cpu_buffer->entries--;
+		cpu_buffer->read++;
 	}
 	__raw_spin_unlock(&cpu_buffer->lock);
 }
-- 
1.6.2.4

-- 
