Return-Path: <linux-kernel-owner+w=401wt.eu-S1754795AbZGFX1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795AbZGFX1l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 19:27:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753000AbZGFX1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 19:27:34 -0400
Received: from sg2ehsobe003.messaging.microsoft.com ([207.46.51.77]:8613 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752868AbZGFX1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 19:27:33 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzzz2fh6bh62h)
X-Spam-TCS-SCL: 1:0
Message-ID: <4A528851.5040204@am.sony.com>
Date: Mon, 6 Jul 2009 16:27:13 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] ftrace: optimize duration filter event discard
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Jul 2009 23:27:14.0045 (UTC) FILETIME=[4B1992D0:01C9FE91]
X-SEL-encryption-scan: scanned
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a routine to allow optimizing the removal of the last
committed entry in the trace log.  This is useful for
function duration tracing, and can greatly expand the
time coverage of a trace, by reclaiming almost all space
for filtered function events.

Please review the FIXTHIS lines, and let me know if
better concurrency control is needed here.

Signed-off-by: Tim Bird <tim.bird@am.sony.com>
---
 include/linux/ring_buffer.h |    8 +++++++
 kernel/trace/ring_buffer.c  |   45 ++++++++++++++++++++++++++++++++++++++++++++
 kernel/trace/trace.c        |    2 -
 3 files changed, 54 insertions(+), 1 deletion(-)

--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -106,6 +106,14 @@ void ring_buffer_discard_commit(struct r
 				struct ring_buffer_event *event);

 /*
+ * ring_buffer_rewind_tail will remove an event that has already
+ *   been committed.  It remains to be determined if it is safe to
+ *   do this.
+ */
+void ring_buffer_rewind_tail(struct ring_buffer *buffer,
+				struct ring_buffer_event *event);
+
+/*
  * size is in bytes for each per CPU buffer.
  */
 struct ring_buffer *
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1801,6 +1801,51 @@ void ring_buffer_discard_commit(struct r
 EXPORT_SYMBOL_GPL(ring_buffer_discard_commit);

 /**
+ * ring_buffer_rewind_tail - discard an event that was previously committed
+ * @buffer: the ring buffer
+ * @event: committed event to discard
+ *
+ * This is similar to ring_buffer_discard_commit but is intended to be
+ * performed on an event that has already been committed.
+ * This routine will try to free the event from the ring buffer.
+ *
+ * If there is some problem, the event is discarded, but not freed.
+ */
+void ring_buffer_rewind_tail(struct ring_buffer *buffer,
+				struct ring_buffer_event *event)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+	int cpu;
+
+	/* The event is discarded regardless */
+	rb_event_discard(event);
+
+	cpu = smp_processor_id();
+	cpu_buffer = buffer->buffers[cpu];
+
+	/*
+	 * If this is the last event in the buffer,
+	 * this should work...
+	 */
+	if (likely(rb_try_to_discard(cpu_buffer, event))) {
+		/* FIXTHIS - possibility for a race with a reader here? */
+
+		/* reduce the count of entries in the buffer */
+		local_dec(&cpu_buffer->entries);
+
+		/* FIXTHIS - possibility for a race with a writer here? */
+		rb_set_commit_to_write(cpu_buffer);
+
+		/*
+		 * if a write comes in, between the try_to_discard() and
+		 * the set_commit_to_write(), but was not committed yet,
+		 * we just committed it.  This should be rare.
+		 */
+	}
+}
+EXPORT_SYMBOL_GPL(ring_buffer_rewind_tail);
+
+/**
  * ring_buffer_write - write data to the buffer without reserving
  * @buffer: The ring buffer to write to.
  * @length: The length of the data being written (excluding the event header)
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -999,7 +999,7 @@ static void trace_buffer_discard_func_en

 	prev_entry = ring_buffer_event_data(prev_event);
 	if (func == prev_entry->graph_ent.func) {
-		ring_buffer_event_discard(prev_event);
+		ring_buffer_rewind_tail(global_trace.buffer, prev_event);
 	}
 }


