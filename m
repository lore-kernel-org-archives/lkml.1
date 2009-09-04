Return-Path: <linux-kernel-owner+w=401wt.eu-S934402AbZIEADG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934402AbZIEADG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:03:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934149AbZIEABX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:01:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33506 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934002AbZIEABT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:01:19 -0400
Message-Id: <20090905000121.298060241@goodmis.org>
References: <20090904235527.520961911@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 04 Sep 2009 19:55:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 03/18] ring-buffer: remove unnecessary cpu_relax
Content-Disposition: inline; filename=0003-ring-buffer-remove-unnecessary-cpu_relax.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The loops in the ring buffer that use cpu_relax are not dependent on
other CPUs. They simply came across some padding in the ring buffer and
are skipping over them. It is a normal loop and does not require a
cpu_relax.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |   16 ++++------------
 1 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 2878bd4..a05541a 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -3132,10 +3132,8 @@ ring_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
 		spin_unlock(&cpu_buffer->reader_lock);
 	local_irq_restore(flags);
 
-	if (event && event->type_len == RINGBUF_TYPE_PADDING) {
-		cpu_relax();
+	if (event && event->type_len == RINGBUF_TYPE_PADDING)
 		goto again;
-	}
 
 	return event;
 }
@@ -3160,10 +3158,8 @@ ring_buffer_iter_peek(struct ring_buffer_iter *iter, u64 *ts)
 	event = rb_iter_peek(iter, ts);
 	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
-	if (event && event->type_len == RINGBUF_TYPE_PADDING) {
-		cpu_relax();
+	if (event && event->type_len == RINGBUF_TYPE_PADDING)
 		goto again;
-	}
 
 	return event;
 }
@@ -3209,10 +3205,8 @@ ring_buffer_consume(struct ring_buffer *buffer, int cpu, u64 *ts)
  out:
 	preempt_enable();
 
-	if (event && event->type_len == RINGBUF_TYPE_PADDING) {
-		cpu_relax();
+	if (event && event->type_len == RINGBUF_TYPE_PADDING)
 		goto again;
-	}
 
 	return event;
 }
@@ -3302,10 +3296,8 @@ ring_buffer_read(struct ring_buffer_iter *iter, u64 *ts)
  out:
 	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
-	if (event && event->type_len == RINGBUF_TYPE_PADDING) {
-		cpu_relax();
+	if (event && event->type_len == RINGBUF_TYPE_PADDING)
 		goto again;
-	}
 
 	return event;
 }
-- 
1.6.3.3

-- 
