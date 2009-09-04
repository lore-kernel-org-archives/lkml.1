Return-Path: <linux-kernel-owner+w=401wt.eu-S934425AbZIEABf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934425AbZIEABf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934264AbZIEABd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:01:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:33619 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934183AbZIEAB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:01:26 -0400
Message-Id: <20090905000127.563020279@goodmis.org>
References: <20090904235527.520961911@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 04 Sep 2009 19:55:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 17/18] ring-buffer: check for swapped buffers in start of committing
Content-Disposition: inline; filename=0017-ring-buffer-check-for-swapped-buffers-in-start-of-co.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Because the irqsoff tracer can swap an internal CPU buffer, it is possible
that a swap happens between the start of the write and before the committing
bit is set (the committing bit will disable swapping).

This patch adds a check for this and will fail the write if it detects it.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |   20 +++++++++++++++++---
 1 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index f83a42a..1766c0e 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2073,7 +2073,8 @@ static void rb_end_commit(struct ring_buffer_per_cpu *cpu_buffer)
 }
 
 static struct ring_buffer_event *
-rb_reserve_next_event(struct ring_buffer_per_cpu *cpu_buffer,
+rb_reserve_next_event(struct ring_buffer *buffer,
+		      struct ring_buffer_per_cpu *cpu_buffer,
 		      unsigned long length)
 {
 	struct ring_buffer_event *event;
@@ -2083,6 +2084,19 @@ rb_reserve_next_event(struct ring_buffer_per_cpu *cpu_buffer,
 
 	rb_start_commit(cpu_buffer);
 
+	/*
+	 * Due to the ability to swap a cpu buffer from a buffer
+	 * it is possible it was swapped before we committed.
+	 * (committing stops a swap). We check for it here and
+	 * if it happened, we have to fail the write.
+	 */
+	barrier();
+	if (unlikely(ACCESS_ONCE(cpu_buffer->buffer) != buffer)) {
+		local_dec(&cpu_buffer->committing);
+		local_dec(&cpu_buffer->commits);
+		return NULL;
+	}
+
 	length = rb_calculate_event_length(length);
  again:
 	/*
@@ -2243,7 +2257,7 @@ ring_buffer_lock_reserve(struct ring_buffer *buffer, unsigned long length)
 	if (length > BUF_MAX_DATA_SIZE)
 		goto out;
 
-	event = rb_reserve_next_event(cpu_buffer, length);
+	event = rb_reserve_next_event(buffer, cpu_buffer, length);
 	if (!event)
 		goto out;
 
@@ -2476,7 +2490,7 @@ int ring_buffer_write(struct ring_buffer *buffer,
 	if (length > BUF_MAX_DATA_SIZE)
 		goto out;
 
-	event = rb_reserve_next_event(cpu_buffer, length);
+	event = rb_reserve_next_event(buffer, cpu_buffer, length);
 	if (!event)
 		goto out;
 
-- 
1.6.3.3

-- 
