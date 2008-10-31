Return-Path: <linux-kernel-owner+w=401wt.eu-S1751818AbYJaN6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818AbYJaN6q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 09:58:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751365AbYJaN6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 09:58:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:34575 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbYJaN6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 09:58:37 -0400
Date: Fri, 31 Oct 2008 09:58:35 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -v3] ring-buffer: add paranoid checks for loops
In-Reply-To: <20081031093804.GF30317@elte.hu>
Message-ID: <alpine.DEB.1.10.0810310956240.13290@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0810291439460.13214@gandalf.stny.rr.com> <20081030184552.GC17822@elte.hu> <alpine.DEB.1.10.0810302314460.26352@gandalf.stny.rr.com> <20081031093804.GF30317@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[
  Changes from v2:

   Applied Ingo's comments:

     Rephrased one of the comments.

     Renamed the "paranoid" variable into "nr_loops".
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
 kernel/trace/ring_buffer.c |   56 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

Index: linux-tip.git/kernel/trace/ring_buffer.c
===================================================================
--- linux-tip.git.orig/kernel/trace/ring_buffer.c	2008-10-30 11:22:43.000000000 -0400
+++ linux-tip.git/kernel/trace/ring_buffer.c	2008-10-31 09:50:35.000000000 -0400
@@ -1022,8 +1022,23 @@ rb_reserve_next_event(struct ring_buffer
 	struct ring_buffer_event *event;
 	u64 ts, delta;
 	int commit = 0;
+	int nr_loops = 0;
 
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
+	if (unlikely(++nr_loops > 1000)) {
+		RB_WARN_ON(cpu_buffer, 1);
+		return NULL;
+	}
+
 	ts = ring_buffer_time_stamp(cpu_buffer->cpu);
 
 	/*
@@ -1532,10 +1547,23 @@ rb_get_reader_page(struct ring_buffer_pe
 {
 	struct buffer_page *reader = NULL;
 	unsigned long flags;
+	int nr_loops = 0;
 
 	spin_lock_irqsave(&cpu_buffer->lock, flags);
 
  again:
+	/*
+	 * This should normally only loop twice. But because the
+	 * start of the reader inserts an empty page, it causes
+	 * a case where we will loop three times. There should be no
+	 * reason to loop four times (that I know of).
+	 */
+	if (unlikely(++nr_loops > 3)) {
+		RB_WARN_ON(cpu_buffer, 1);
+		reader = NULL;
+		goto out;
+	}
+
 	reader = cpu_buffer->reader_page;
 
 	/* If there's more to read, return this page */
@@ -1665,6 +1693,7 @@ ring_buffer_peek(struct ring_buffer *buf
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct ring_buffer_event *event;
 	struct buffer_page *reader;
+	int nr_loops = 0;
 
 	if (!cpu_isset(cpu, buffer->cpumask))
 		return NULL;
@@ -1672,6 +1701,19 @@ ring_buffer_peek(struct ring_buffer *buf
 	cpu_buffer = buffer->buffers[cpu];
 
  again:
+	/*
+	 * We repeat when a timestamp is encountered. It is possible
+	 * to get multiple timestamps from an interrupt entering just
+	 * as one timestamp is about to be written. The max times
+	 * that this can happen is the number of nested interrupts we
+	 * can have.  Nesting 10 deep of interrupts is clearly
+	 * an anomaly.
+	 */
+	if (unlikely(++nr_loops > 10)) {
+		RB_WARN_ON(cpu_buffer, 1);
+		return NULL;
+	}
+
 	reader = rb_get_reader_page(cpu_buffer);
 	if (!reader)
 		return NULL;
@@ -1722,6 +1764,7 @@ ring_buffer_iter_peek(struct ring_buffer
 	struct ring_buffer *buffer;
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct ring_buffer_event *event;
+	int nr_loops = 0;
 
 	if (ring_buffer_iter_empty(iter))
 		return NULL;
@@ -1730,6 +1773,19 @@ ring_buffer_iter_peek(struct ring_buffer
 	buffer = cpu_buffer->buffer;
 
  again:
+	/*
+	 * We repeat when a timestamp is encountered. It is possible
+	 * to get multiple timestamps from an interrupt entering just
+	 * as one timestamp is about to be written. The max times
+	 * that this can happen is the number of nested interrupts we
+	 * can have. Nesting 10 deep of interrupts is clearly
+	 * an anomaly.
+	 */
+	if (unlikely(++nr_loops > 10)) {
+		RB_WARN_ON(cpu_buffer, 1);
+		return NULL;
+	}
+
 	if (rb_per_cpu_empty(cpu_buffer))
 		return NULL;
 

