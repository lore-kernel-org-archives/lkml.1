Return-Path: <linux-kernel-owner+w=401wt.eu-S1758243AbZELEMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758243AbZELEMn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 00:12:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbZELELG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 00:11:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:42535 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbZELEK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 00:10:59 -0400
Message-Id: <20090512041059.600754451@goodmis.org>
References: <20090512040832.681953177@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 12 May 2009 00:08:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4/5] ring-buffer: use internal time stamp function
Content-Disposition: inline; filename=0004-ring-buffer-use-internal-time-stamp-function.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The ring_buffer_time_stamp that is exported adds a little more overhead
than is needed for using it internally. This patch adds an internal
timestamp function that can be inlined (a single line function)
and used internally for the ring buffer.

[ Impact: a little less overhead to the ring buffer ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index f452de2..a9e645a 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -454,13 +454,18 @@ struct ring_buffer_iter {
 /* Up this if you want to test the TIME_EXTENTS and normalization */
 #define DEBUG_SHIFT 0
 
+static inline u64 rb_time_stamp(struct ring_buffer *buffer, int cpu)
+{
+	/* shift to debug/test normalization and TIME_EXTENTS */
+	return buffer->clock() << DEBUG_SHIFT;
+}
+
 u64 ring_buffer_time_stamp(struct ring_buffer *buffer, int cpu)
 {
 	u64 time;
 
 	preempt_disable_notrace();
-	/* shift to debug/test normalization and TIME_EXTENTS */
-	time = buffer->clock() << DEBUG_SHIFT;
+	time = rb_time_stamp(buffer, cpu);
 	preempt_enable_no_resched_notrace();
 
 	return time;
@@ -1247,7 +1252,7 @@ rb_move_tail(struct ring_buffer_per_cpu *cpu_buffer,
 		cpu_buffer->tail_page = next_page;
 
 		/* reread the time stamp */
-		*ts = ring_buffer_time_stamp(buffer, cpu_buffer->cpu);
+		*ts = rb_time_stamp(buffer, cpu_buffer->cpu);
 		cpu_buffer->tail_page->page->time_stamp = *ts;
 	}
 
@@ -1413,7 +1418,7 @@ rb_reserve_next_event(struct ring_buffer_per_cpu *cpu_buffer,
 	if (RB_WARN_ON(cpu_buffer, ++nr_loops > 1000))
 		return NULL;
 
-	ts = ring_buffer_time_stamp(cpu_buffer->buffer, cpu_buffer->cpu);
+	ts = rb_time_stamp(cpu_buffer->buffer, cpu_buffer->cpu);
 
 	/*
 	 * Only the first commit can update the timestamp.
-- 
1.6.2.4

-- 
