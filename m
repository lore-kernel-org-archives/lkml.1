Return-Path: <linux-kernel-owner+w=401wt.eu-S1754538AbZELELu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538AbZELELu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 00:11:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751854AbZELELE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 00:11:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:43666 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbZELEK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 00:10:59 -0400
Message-Id: <20090512041059.803404850@goodmis.org>
References: <20090512040832.681953177@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 12 May 2009 00:08:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5/5] ring-buffer: move code around to remove some branches
Content-Disposition: inline; filename=0005-ring-buffer-move-code-around-to-remove-some-branche.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

This is a bit of micro-optimizations. But since the ring buffer is used
in tracing every function call, it is an extreme hot path. Every nanosecond
counts.

This change shows over 5% improvement in the ring-buffer-benchmark.

[ Impact: more efficient code ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index a9e645a..16b24d4 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1400,7 +1400,7 @@ rb_reserve_next_event(struct ring_buffer_per_cpu *cpu_buffer,
 		      unsigned long length)
 {
 	struct ring_buffer_event *event;
-	u64 ts, delta;
+	u64 ts, delta = 0;
 	int commit = 0;
 	int nr_loops = 0;
 
@@ -1431,20 +1431,21 @@ rb_reserve_next_event(struct ring_buffer_per_cpu *cpu_buffer,
 	if (likely(cpu_buffer->tail_page == cpu_buffer->commit_page &&
 		   rb_page_write(cpu_buffer->tail_page) ==
 		   rb_commit_index(cpu_buffer))) {
+		u64 diff;
 
-		delta = ts - cpu_buffer->write_stamp;
+		diff = ts - cpu_buffer->write_stamp;
 
-		/* make sure this delta is calculated here */
+		/* make sure this diff is calculated here */
 		barrier();
 
 		/* Did the write stamp get updated already? */
 		if (unlikely(ts < cpu_buffer->write_stamp))
-			delta = 0;
+			goto get_event;
 
-		else if (unlikely(test_time_stamp(delta))) {
+		delta = diff;
+		if (unlikely(test_time_stamp(delta))) {
 
 			commit = rb_add_time_stamp(cpu_buffer, &ts, &delta);
-
 			if (commit == -EBUSY)
 				return NULL;
 
@@ -1453,12 +1454,11 @@ rb_reserve_next_event(struct ring_buffer_per_cpu *cpu_buffer,
 
 			RB_WARN_ON(cpu_buffer, commit < 0);
 		}
-	} else
-		/* Non commits have zero deltas */
-		delta = 0;
+	}
 
+ get_event:
 	event = __rb_reserve_next(cpu_buffer, 0, length, &ts);
-	if (PTR_ERR(event) == -EAGAIN)
+	if (unlikely(PTR_ERR(event) == -EAGAIN))
 		goto again;
 
 	if (!event) {
-- 
1.6.2.4

-- 
