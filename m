Return-Path: <linux-kernel-owner+w=401wt.eu-S1763556AbZFOPqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763556AbZFOPqA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 11:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761857AbZFOPoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 11:44:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:40189 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754336AbZFOPoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 11:44:10 -0400
Message-Id: <20090615154411.844037130@goodmis.org>
References: <20090615154226.058101204@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 15 Jun 2009 11:42:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 7/7] ring-buffer: prevent adding write in discarded area
Content-Disposition: inline; filename=0007-ring-buffer-prevent-adding-write-in-discarded-area.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

This a very tight race where an interrupt could come in and not
have enough data to put into the end of a buffer page, and that
it would fail to write and need to go to the next page.

But if this happened when another writer was about to reserver
their data, and that writer has smaller data to reserve, then
it could succeed even though the interrupt moved the tail page.

To pervent that, if we fail to store data, and by subtracting the
amount we reserved we still have room for smaller data, we need
to fill that space with "discarded" data.

[ Impact: prevent race were buffer data may be lost ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |   68 ++++++++++++++++++++++++++++++++++++--------
 1 files changed, 56 insertions(+), 12 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 9c31c9f..dbc0f93 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -205,6 +205,7 @@ EXPORT_SYMBOL_GPL(tracing_is_on);
 #define RB_EVNT_HDR_SIZE (offsetof(struct ring_buffer_event, array))
 #define RB_ALIGNMENT		4U
 #define RB_MAX_SMALL_DATA	(RB_ALIGNMENT * RINGBUF_TYPE_DATA_TYPE_LEN_MAX)
+#define RB_EVNT_MIN_SIZE	8U	/* two 32bit words */
 
 /* define RINGBUF_TYPE_DATA for 'case RINGBUF_TYPE_DATA:' */
 #define RINGBUF_TYPE_DATA 0 ... RINGBUF_TYPE_DATA_TYPE_LEN_MAX
@@ -1170,6 +1171,59 @@ static unsigned rb_calculate_event_length(unsigned length)
 	return length;
 }
 
+static inline void
+rb_reset_tail(struct ring_buffer_per_cpu *cpu_buffer,
+	      struct buffer_page *tail_page,
+	      unsigned long tail, unsigned long length)
+{
+	struct ring_buffer_event *event;
+
+	/*
+	 * Only the event that crossed the page boundary
+	 * must fill the old tail_page with padding.
+	 */
+	if (tail >= BUF_PAGE_SIZE) {
+		local_sub(length, &tail_page->write);
+		return;
+	}
+
+	event = __rb_page_index(tail_page, tail);
+
+	/*
+	 * If this event is bigger than the minimum size, then
+	 * we need to be careful that we don't subtract the
+	 * write counter enough to allow another writer to slip
+	 * in on this page.
+	 * We put in a discarded commit instead, to make sure
+	 * that this space is not used again.
+	 *
+	 * If we are less than the minimum size, we don't need to
+	 * worry about it.
+	 */
+	if (tail > (BUF_PAGE_SIZE - RB_EVNT_MIN_SIZE)) {
+		/* No room for any events */
+
+		/* Mark the rest of the page with padding */
+		rb_event_set_padding(event);
+
+		/* Set the write back to the previous setting */
+		local_sub(length, &tail_page->write);
+		return;
+	}
+
+	/* Put in a discarded event */
+	event->array[0] = (BUF_PAGE_SIZE - tail) - RB_EVNT_HDR_SIZE;
+	event->type_len = RINGBUF_TYPE_PADDING;
+	/* time delta must be non zero */
+	event->time_delta = 1;
+	/* Account for this as an entry */
+	local_inc(&tail_page->entries);
+	local_inc(&cpu_buffer->entries);
+
+	/* Set write to end of buffer */
+	length = (tail + length) - BUF_PAGE_SIZE;
+	local_sub(length, &tail_page->write);
+}
 
 static struct ring_buffer_event *
 rb_move_tail(struct ring_buffer_per_cpu *cpu_buffer,
@@ -1264,17 +1318,7 @@ rb_move_tail(struct ring_buffer_per_cpu *cpu_buffer,
 		cpu_buffer->tail_page->page->time_stamp = *ts;
 	}
 
-	/*
-	 * The actual tail page has moved forward.
-	 */
-	if (tail < BUF_PAGE_SIZE) {
-		/* Mark the rest of the page with padding */
-		event = __rb_page_index(tail_page, tail);
-		rb_event_set_padding(event);
-	}
-
-	/* Set the write back to the previous setting */
-	local_sub(length, &tail_page->write);
+	rb_reset_tail(cpu_buffer, tail_page, tail, length);
 
 	/*
 	 * If this was a commit entry that failed,
@@ -1293,7 +1337,7 @@ rb_move_tail(struct ring_buffer_per_cpu *cpu_buffer,
 
  out_reset:
 	/* reset write */
-	local_sub(length, &tail_page->write);
+	rb_reset_tail(cpu_buffer, tail_page, tail, length);
 
 	if (likely(lock_taken))
 		__raw_spin_unlock(&cpu_buffer->lock);
-- 
1.6.3.1

-- 
