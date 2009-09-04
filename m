Return-Path: <linux-kernel-owner+w=401wt.eu-S934258AbZIEAB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934258AbZIEAB2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:01:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934224AbZIEAB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:01:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:40420 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934029AbZIEABU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:01:20 -0400
Message-Id: <20090905000121.753984070@goodmis.org>
References: <20090904235527.520961911@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 04 Sep 2009 19:55:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 04/18] ring-buffer: fix ring_buffer_read crossing pages
Content-Disposition: inline; filename=0004-ring-buffer-fix-ring_buffer_read-crossing-pages.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

When the ring buffer uses an iterator (static read mode, not on the
fly reading), when it crosses a page boundery, it will skip the first
entry on the next page. The reason is that the last entry of a page
is usually padding if the page is not full. The padding will not be
returned to the user.

The problem arises on ring_buffer_read because it also increments the
iterator. Because both the read and peek use the same rb_iter_peek,
the rb_iter_peak will return the padding but also increment to the next
item. This is because the ring_buffer_peek will not incerment it
itself.

The ring_buffer_read will increment it again and then call rb_iter_peek
again to get the next item. But that will be the second item, not the
first one on the page.

The reason this never showed up before, is because the ftrace utility
always calls ring_buffer_peek first and only uses ring_buffer_read
to increment to the next item. The ring_buffer_peek will always keep
the pointer to a valid item and not padding. This just hid the bug.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index a05541a..9d939e7 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -3286,19 +3286,19 @@ ring_buffer_read(struct ring_buffer_iter *iter, u64 *ts)
 	struct ring_buffer_per_cpu *cpu_buffer = iter->cpu_buffer;
 	unsigned long flags;
 
- again:
 	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
+ again:
 	event = rb_iter_peek(iter, ts);
 	if (!event)
 		goto out;
 
+	if (event->type_len == RINGBUF_TYPE_PADDING)
+		goto again;
+
 	rb_advance_iter(iter);
  out:
 	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
-	if (event && event->type_len == RINGBUF_TYPE_PADDING)
-		goto again;
-
 	return event;
 }
 EXPORT_SYMBOL_GPL(ring_buffer_read);
-- 
1.6.3.3

-- 
