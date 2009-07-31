Return-Path: <linux-kernel-owner+w=401wt.eu-S1752764AbZGaNPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764AbZGaNPi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 09:15:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752665AbZGaNPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 09:15:38 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:27642 "EHLO
	IE1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647AbZGaNPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 09:15:37 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i203h87h)
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KNNE4R-02-H38-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH] ring-buffer: Change function interface of rb_buffer_peek()
Date: Fri, 31 Jul 2009 14:58:04 +0200
Message-ID: <1249045084-3028-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.3.3
X-OriginalArrivalTime: 31 Jul 2009 13:14:19.0457 (UTC) FILETIME=[D0108310:01CA11E0]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rb_buffer_peek() operates with struct ring_buffer_per_cpu *cpu_buffer
only. Thus, instead of passing variables buffer and cpu it is better
to use cpu_buffer directly. This also reduces the risk of races since
cpu_buffer is not calculated twice.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 kernel/trace/ring_buffer.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 6eb8b97..0133f20 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2346,15 +2346,12 @@ static void rb_advance_iter(struct ring_buffer_iter *iter)
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
@@ -2398,7 +2395,7 @@ rb_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
 	case RINGBUF_TYPE_DATA:
 		if (ts) {
 			*ts = cpu_buffer->read_stamp + event->time_delta;
-			ring_buffer_normalize_time_stamp(buffer,
+			ring_buffer_normalize_time_stamp(cpu_buffer->buffer,
 							 cpu_buffer->cpu, ts);
 		}
 		return event;
@@ -2517,7 +2514,7 @@ ring_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
 	local_irq_save(flags);
 	if (dolock)
 		spin_lock(&cpu_buffer->reader_lock);
-	event = rb_buffer_peek(buffer, cpu, ts);
+	event = rb_buffer_peek(cpu_buffer, ts);
 	if (event && event->type_len == RINGBUF_TYPE_PADDING)
 		rb_advance_reader(cpu_buffer);
 	if (dolock)
@@ -2590,7 +2587,7 @@ ring_buffer_consume(struct ring_buffer *buffer, int cpu, u64 *ts)
 	if (dolock)
 		spin_lock(&cpu_buffer->reader_lock);
 
-	event = rb_buffer_peek(buffer, cpu, ts);
+	event = rb_buffer_peek(cpu_buffer, ts);
 	if (event)
 		rb_advance_reader(cpu_buffer);
 
-- 
1.6.3.3


