Return-Path: <linux-kernel-owner+w=401wt.eu-S1753635AbZIJENl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635AbZIJENl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 00:13:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751001AbZIJEM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 00:12:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:41345 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbZIJEM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 00:12:58 -0400
Message-Id: <20090910041300.421492176@goodmis.org>
References: <20090910041219.149954890@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 10 Sep 2009 00:12:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 1/6] ring-buffer: consolidate interface of rb_buffer_peek()
Content-Disposition: inline; filename=0001-ring-buffer-consolidate-interface-of-rb_buffer_peek.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@amd.com>

rb_buffer_peek() operates with struct ring_buffer_per_cpu *cpu_buffer
only. Thus, instead of passing variables buffer and cpu it is better
to use cpu_buffer directly. This also reduces the risk of races since
cpu_buffer is not calculated twice.

Signed-off-by: Robert Richter <robert.richter@amd.com>
LKML-Reference: <1249045084-3028-1-git-send-email-robert.richter@amd.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 454e74e..8786c35 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2997,15 +2997,12 @@ static void rb_advance_iter(struct ring_buffer_iter *iter)
 }
 
 static struct ring_buffer_event *
-rb_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
+rb_buffer_peek(struct ring_buffer_per_cpu *cpu_buffer, u64 *ts)
 {
-	struct ring_buffer_per_cpu *cpu_buffer;
 	struct ring_buffer_event *event;
 	struct buffer_page *reader;
 	int nr_loops = 0;
 
-	cpu_buffer = buffer->buffers[cpu];
-
  again:
 	/*
 	 * We repeat when a timestamp is encountered. It is possible
@@ -3049,7 +3046,7 @@ rb_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
 	case RINGBUF_TYPE_DATA:
 		if (ts) {
 			*ts = cpu_buffer->read_stamp + event->time_delta;
-			ring_buffer_normalize_time_stamp(buffer,
+			ring_buffer_normalize_time_stamp(cpu_buffer->buffer,
 							 cpu_buffer->cpu, ts);
 		}
 		return event;
@@ -3168,7 +3165,7 @@ ring_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
 	local_irq_save(flags);
 	if (dolock)
 		spin_lock(&cpu_buffer->reader_lock);
-	event = rb_buffer_peek(buffer, cpu, ts);
+	event = rb_buffer_peek(cpu_buffer, ts);
 	if (event && event->type_len == RINGBUF_TYPE_PADDING)
 		rb_advance_reader(cpu_buffer);
 	if (dolock)
@@ -3237,7 +3234,7 @@ ring_buffer_consume(struct ring_buffer *buffer, int cpu, u64 *ts)
 	if (dolock)
 		spin_lock(&cpu_buffer->reader_lock);
 
-	event = rb_buffer_peek(buffer, cpu, ts);
+	event = rb_buffer_peek(cpu_buffer, ts);
 	if (event)
 		rb_advance_reader(cpu_buffer);
 
-- 
1.6.3.3

-- 
