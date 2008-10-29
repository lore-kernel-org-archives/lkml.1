Return-Path: <linux-kernel-owner+w=401wt.eu-S1758951AbYJ2XBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758951AbYJ2XBq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 19:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756261AbYJ2WsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 18:48:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:34709 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756849AbYJ2WsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 18:48:03 -0400
Date: Wed, 29 Oct 2008 18:48:00 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] ring-buffer: add paranoid checks for loops
Message-ID: <alpine.DEB.1.10.0810291439460.13214@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ for 2.6.28 ]

While writing a new tracer, I had a bug where I caused the ring-buffer
to recurse in a bad way. The bug was with the tracer I was writing
and not the ring-buffer itself. But it took a long time to find the
problem.

This patch adds paranoid checks into the ring-buffer infrastructure
that will catch bugs of this nature.

Note: I put the bug back in the tracer and this patch showed the error
      nicely and prevented the lockup.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ring_buffer.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

Index: linux-tip.git/kernel/trace/ring_buffer.c
===================================================================
--- linux-tip.git.orig/kernel/trace/ring_buffer.c	2008-10-29 12:38:54.000000000 -0400
+++ linux-tip.git/kernel/trace/ring_buffer.c	2008-10-29 16:11:00.000000000 -0400
@@ -1022,8 +1022,20 @@ rb_reserve_next_event(struct ring_buffer
 	struct ring_buffer_event *event;
 	u64 ts, delta;
 	int commit = 0;
+	int paranoid = 0;
 
  again:
+	/*
+	 * If we loop here 1,000 times, that means we are either
+	 * in an interrupt storm, or we have something buggy.
+	 * Bail!
+	 */
+	if (unlikely(paranoid > 1000)) {
+		RB_WARN_ON(cpu_buffer, 1);
+		return NULL;
+	}
+	paranoid++;
+
 	ts = ring_buffer_time_stamp(cpu_buffer->cpu);
 
 	/*
@@ -1532,10 +1544,21 @@ rb_get_reader_page(struct ring_buffer_pe
 {
 	struct buffer_page *reader = NULL;
 	unsigned long flags;
+	int paranoid = 0;
 
 	spin_lock_irqsave(&cpu_buffer->lock, flags);
 
  again:
+	/*
+	 * We can call here a couple of times, lets only allow 5.
+	 */
+	if (unlikely(paranoid > 4)) {
+		RB_WARN_ON(cpu_buffer, 1);
+		reader = NULL;
+		goto out;
+	}
+	paranoid++;
+
 	reader = cpu_buffer->reader_page;
 
 	/* If there's more to read, return this page */
@@ -1665,6 +1688,7 @@ ring_buffer_peek(struct ring_buffer *buf
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct ring_buffer_event *event;
 	struct buffer_page *reader;
+	int paranoid = 0;
 
 	if (!cpu_isset(cpu, buffer->cpumask))
 		return NULL;
@@ -1672,6 +1696,16 @@ ring_buffer_peek(struct ring_buffer *buf
 	cpu_buffer = buffer->buffers[cpu];
 
  again:
+	/*
+	 * This could happen a few times, but if more than
+	 * 10 times, then something is probably wrong.
+	 */
+	if (unlikely(paranoid > 10)) {
+		RB_WARN_ON(cpu_buffer, 1);
+		return NULL;
+	}
+	paranoid++;
+
 	reader = rb_get_reader_page(cpu_buffer);
 	if (!reader)
 		return NULL;
@@ -1722,6 +1756,7 @@ ring_buffer_iter_peek(struct ring_buffer
 	struct ring_buffer *buffer;
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct ring_buffer_event *event;
+	int paranoid = 0;
 
 	if (ring_buffer_iter_empty(iter))
 		return NULL;
@@ -1730,6 +1765,16 @@ ring_buffer_iter_peek(struct ring_buffer
 	buffer = cpu_buffer->buffer;
 
  again:
+	/*
+	 * This could happen a few times, but if more than
+	 * 10 times, then something is probably wrong.
+	 */
+	if (unlikely(paranoid > 10)) {
+		RB_WARN_ON(cpu_buffer, 1);
+		return NULL;
+	}
+	paranoid++;
+
 	if (rb_per_cpu_empty(cpu_buffer))
 		return NULL;
 
