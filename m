Return-Path: <linux-kernel-owner+w=401wt.eu-S1758569AbZFCORl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758569AbZFCORl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 10:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757426AbZFCOQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 10:16:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:52881 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755618AbZFCOQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 10:16:50 -0400
Message-Id: <20090603141651.463760573@goodmis.org>
References: <20090603141605.001049251@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 03 Jun 2009 10:16:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tim Bird <tim.bird@am.sony.com>
Subject: [PATCH 3/3] ring-buffer: discard timestamps that are at the start of the buffer
Content-Disposition: inline; filename=0003-ring-buffer-discard-timestamps-that-are-at-the-start.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Every buffer page in the ring buffer includes its own time stamp.
When an event is recorded to the ring buffer with a delta time greater
than what can be held in the event header, a time stamp event is created.

If the the create timestamp falls over to the next buffer page, it is
redundant because the buffer page holds a full time stamp. This patch
will try to discard the time stamp when it falls to the start of the
next page.

This change also fixes a issues with disarding events. If most events are
discarded, timestamps will start to creep into the ring buffer. If we
do not discard the timestamps then they can fill up the ring buffer over
time and waste space.

This change will keep time stamps from filling up over another page. If
something is recorded in the buffer page, and the rest is filtered, then
the time stamps can only fill up to the end of the page.

[ Impact: prevent time stamps from filling ring buffer ]

Reported-by: Tim Bird <tim.bird@am.sony.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |   37 +++++++++++++++++++++----------------
 1 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 5092660..7102d7a 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -370,6 +370,9 @@ static inline int test_time_stamp(u64 delta)
 /* Max payload is BUF_PAGE_SIZE - header (8bytes) */
 #define BUF_MAX_DATA_SIZE (BUF_PAGE_SIZE - (sizeof(u32) * 2))
 
+/* Max number of timestamps that can fit on a page */
+#define RB_TIMESTAMPS_PER_PAGE	(BUF_PAGE_SIZE / RB_LEN_TIME_STAMP)
+
 int ring_buffer_print_page_header(struct trace_seq *s)
 {
 	struct buffer_data_page field;
@@ -1409,8 +1412,12 @@ rb_add_time_stamp(struct ring_buffer_per_cpu *cpu_buffer,
 			event->array[0] = *delta >> TS_SHIFT;
 		} else {
 			cpu_buffer->commit_page->page->time_stamp = *ts;
-			event->time_delta = 0;
-			event->array[0] = 0;
+			/* try to discard, since we do not need this */
+			if (!rb_try_to_discard(cpu_buffer, event)) {
+				/* nope, just zero it */
+				event->time_delta = 0;
+				event->array[0] = 0;
+			}
 		}
 		cpu_buffer->write_stamp = *ts;
 		/* let the caller know this was the commit */
@@ -2268,8 +2275,8 @@ static void rb_advance_iter(struct ring_buffer_iter *iter)
 	 * Check if we are at the end of the buffer.
 	 */
 	if (iter->head >= rb_page_size(iter->head_page)) {
-		if (RB_WARN_ON(buffer,
-			       iter->head_page == cpu_buffer->commit_page))
+		/* discarded commits can make the page empty */
+		if (iter->head_page == cpu_buffer->commit_page)
 			return;
 		rb_inc_iter(iter);
 		return;
@@ -2312,12 +2319,10 @@ rb_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
 	/*
 	 * We repeat when a timestamp is encountered. It is possible
 	 * to get multiple timestamps from an interrupt entering just
-	 * as one timestamp is about to be written. The max times
-	 * that this can happen is the number of nested interrupts we
-	 * can have.  Nesting 10 deep of interrupts is clearly
-	 * an anomaly.
+	 * as one timestamp is about to be written, or from discarded
+	 * commits. The most that we can have is the number on a single page.
 	 */
-	if (RB_WARN_ON(cpu_buffer, ++nr_loops > 10))
+	if (RB_WARN_ON(cpu_buffer, ++nr_loops > RB_TIMESTAMPS_PER_PAGE))
 		return NULL;
 
 	reader = rb_get_reader_page(cpu_buffer);
@@ -2383,14 +2388,14 @@ rb_iter_peek(struct ring_buffer_iter *iter, u64 *ts)
 
  again:
 	/*
-	 * We repeat when a timestamp is encountered. It is possible
-	 * to get multiple timestamps from an interrupt entering just
-	 * as one timestamp is about to be written. The max times
-	 * that this can happen is the number of nested interrupts we
-	 * can have. Nesting 10 deep of interrupts is clearly
-	 * an anomaly.
+	 * We repeat when a timestamp is encountered.
+	 * We can get multiple timestamps by nested interrupts or also
+	 * if filtering is on (discarding commits). Since discarding
+	 * commits can be frequent we can get a lot of timestamps.
+	 * But we limit them by not adding timestamps if they begin
+	 * at the start of a page.
 	 */
-	if (RB_WARN_ON(cpu_buffer, ++nr_loops > 10))
+	if (RB_WARN_ON(cpu_buffer, ++nr_loops > RB_TIMESTAMPS_PER_PAGE))
 		return NULL;
 
 	if (rb_per_cpu_empty(cpu_buffer))
-- 
1.6.3.1

-- 
