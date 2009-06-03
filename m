Return-Path: <linux-kernel-owner+w=401wt.eu-S1757286AbZFCORR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757286AbZFCORR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 10:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754802AbZFCOQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 10:16:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:40943 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754312AbZFCOQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 10:16:49 -0400
Message-Id: <20090603141651.041050697@goodmis.org>
References: <20090603141605.001049251@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 03 Jun 2009 10:16:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tim Bird <tim.bird@am.sony.com>
Subject: [PATCH 1/3] ring-buffer: fix bug in ring_buffer_discard_commit
Content-Disposition: inline; filename=0001-ring-buffer-fix-bug-in-ring_buffer_discard_commit.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tim Bird <tim.bird@am.sony.com>

There's a bug in ring_buffer_discard_commit.  The wrong
pointer is being compared in order to check if the event
can be freed from the buffer rather than discarded
(i.e. marked as PAD).

I noticed this when I was working on duration filtering.
The bug is not deadly - it just results in lots of wasted
space in the buffer.  All filtered events are left in
the buffer and marked as discarded, rather than being
removed from the buffer to make space for other events.

Unfortunately, when I fixed this bug, I got errors doing a
filtered function trace.  Multiple TIME_EXTEND
events pile up in the buffer, and trigger the
following loop overage warning in rb_iter_peek():

again:
	...
	if (RB_WARN_ON(cpu_buffer, ++nr_loops > 10))
		return NULL;

I'm not sure what the best way is to fix this. I don't
know if I should extend the loop threshhold, or if I should
make the test more complex (ignore TIME_EXTEND
events), or just get rid of this loop check completely.

Note that if I implement a workaround for this, then I
see another problem from rb_advance_iter().  I haven't
tracked that one down yet.

In general, it seems like the case of removing filtered
events has not been working properly, and so some assumptions
about buffer invariant conditions need to be revisited.

Here's the patch for the simple fix:

Compare correct pointer for checking if an event can be
freed rather than left as discarded in the buffer.

Signed-off-by: Tim Bird <tim.bird@am.sony.com>
LKML-Reference: <4A25BE9E.5090909@am.sony.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 16b24d4..9453023 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1708,7 +1708,7 @@ void ring_buffer_discard_commit(struct ring_buffer *buffer,
 
 	bpage = cpu_buffer->tail_page;
 
-	if (bpage == (void *)addr && rb_page_write(bpage) == old_index) {
+	if (bpage->page == (void *)addr && rb_page_write(bpage) == old_index) {
 		/*
 		 * This is on the tail page. It is possible that
 		 * a write could come in and move the tail page
-- 
1.6.3.1

-- 
