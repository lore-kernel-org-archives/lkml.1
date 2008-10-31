Return-Path: <linux-kernel-owner+w=401wt.eu-S1754301AbYJaDQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301AbYJaDQ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 23:16:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753260AbYJaDQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 23:16:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:63875 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbYJaDQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 23:16:48 -0400
Date: Thu, 30 Oct 2008 23:16:45 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -v2] ring-buffer: add paranoid checks for loops
In-Reply-To: <20081030184552.GC17822@elte.hu>
Message-ID: <alpine.DEB.1.10.0810302314460.26352@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0810291439460.13214@gandalf.stny.rr.com> <20081030184552.GC17822@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[
  Changes since v1:

   Updated comments to be more detailed.
]

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
 kernel/trace/ring_buffer.c |   58 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

Index: linux-tip.git/kernel/trace/ring_buffer.c
===================================================================
--- linux-tip.git.orig/kernel/trace/ring_buffer.c	2008-10-30 11:22:43.000000000 -0400
+++ linux-tip.git/kernel/trace/ring_buffer.c	2008-10-30 22:50:53.000000000 -0400
@@ -1022,8 +1022,24 @@ rb_reserve_next_event(struct ring_buffer
 	struct ring_buffer_event *event;
 	u64 ts, delta;
 	int commit = 0;
+	int paranoid = 0;
 
  again:
+	/*
+	 * We allow for interrupts to reenter here and do a trace.
+	 * If one does, it will cause this original code to loop
+	 * back here. Even with heavy interrupts happening, this
+	 * should only happen a few times in a row. If this happens
+	 * 1000 times in a row, there must be either an interrupt
+	 * storm or we have something buggy.
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
@@ -1532,10 +1548,24 @@ rb_get_reader_page(struct ring_buffer_pe
 {
 	struct buffer_page *reader = NULL;
 	unsigned long flags;
+	int paranoid = 0;
 
 	spin_lock_irqsave(&cpu_buffer->lock, flags);
 
  again:
+	/*
+	 * This should normally only loop twice. But because the
+	 * start of the reader inserts an empty page, it causes
+	 * a case where we will loop three times. There should be no
+	 * reason to loop four times (that I know of).
+	 */
+	if (unlikely(paranoid > 2)) {
+		RB_WARN_ON(cpu_buffer, 1);
+		reader = NULL;
+		goto out;
+	}
+	paranoid++;
+
 	reader = cpu_buffer->reader_page;
 
 	/* If there's more to read, return this page */
@@ -1665,6 +1695,7 @@ ring_buffer_peek(struct ring_buffer *buf
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct ring_buffer_event *event;
 	struct buffer_page *reader;
+	int paranoid = 0;
 
 	if (!cpu_isset(cpu, buffer->cpumask))
 		return NULL;
@@ -1672,6 +1703,19 @@ ring_buffer_peek(struct ring_buffer *buf
 	cpu_buffer = buffer->buffers[cpu];
 
  again:
+	/*
+	 * We repeat when a timestamp is encountered. It is possible
+	 * to get multiple timestamps from an interrupt entering just
+	 * as one timestamp is about to be written. The max times
+	 * that this can happen is the number of nested interrupts we
+	 * can have.  10 should be more than enough.
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
@@ -1722,6 +1766,7 @@ ring_buffer_iter_peek(struct ring_buffer
 	struct ring_buffer *buffer;
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct ring_buffer_event *event;
+	int paranoid = 0;
 
 	if (ring_buffer_iter_empty(iter))
 		return NULL;
@@ -1730,6 +1775,19 @@ ring_buffer_iter_peek(struct ring_buffer
 	buffer = cpu_buffer->buffer;
 
  again:
+	/*
+	 * We repeat when a timestamp is encountered. It is possible
+	 * to get multiple timestamps from an interrupt entering just
+	 * as one timestamp is about to be written. The max times
+	 * that this can happen is the number of nested interrupts we
+	 * can have.  10 should be more than enough.
+	 */
+	if (unlikely(paranoid > 10)) {
+		RB_WARN_ON(cpu_buffer, 1);
+		return NULL;
+	}
+	paranoid++;
+
 	if (rb_per_cpu_empty(cpu_buffer))
 		return NULL;
 


