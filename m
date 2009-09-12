Return-Path: <linux-kernel-owner+w=401wt.eu-S1752291AbZILHwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291AbZILHwk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 03:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751930AbZILHwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 03:52:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:33424 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519AbZILHwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 03:52:38 -0400
Date: Sat, 12 Sep 2009 07:52:16 GMT
From: tip-bot for Robert Richter <robert.richter@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       robert.richter@amd.com, rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       robert.richter@amd.com, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <1249045084-3028-1-git-send-email-robert.richter@amd.com>
References: <1249045084-3028-1-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] ring-buffer: consolidate interface of rb_buffer_peek()
Message-ID: <tip-d8eeb2d3b26d25c44c10f28430e2157a2d20bd1d@git.kernel.org>
Git-Commit-ID: d8eeb2d3b26d25c44c10f28430e2157a2d20bd1d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 12 Sep 2009 07:52:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d8eeb2d3b26d25c44c10f28430e2157a2d20bd1d
Gitweb:     http://git.kernel.org/tip/d8eeb2d3b26d25c44c10f28430e2157a2d20bd1d
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Fri, 31 Jul 2009 14:58:04 +0200
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 9 Sep 2009 23:54:02 -0400

ring-buffer: consolidate interface of rb_buffer_peek()

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
 
