Return-Path: <linux-kernel-owner+w=401wt.eu-S1754184AbZFCAWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbZFCAWu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 20:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752166AbZFCAWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 20:22:42 -0400
Received: from sg2ehsobe003.messaging.microsoft.com ([207.46.51.77]:34605 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751742AbZFCAWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 20:22:41 -0400
X-Greylist: delayed 905 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Jun 2009 20:22:41 EDT
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzzz2fh17ch6bh66h)
X-Spam-TCS-SCL: 5:0
Message-ID: <4A25BE9E.5090909@am.sony.com>
Date: Tue, 2 Jun 2009 17:06:54 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] fix bug in ring_buffer_discard_commit
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Jun 2009 00:06:55.0691 (UTC) FILETIME=[34A069B0:01C9E3DF]
X-SEL-encryption-scan: scanned
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Signed-off-by: Tim Bird <tim.bird@am.sony.com
---
 kernel/trace/ring_buffer.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1711,7 +1711,7 @@ void ring_buffer_discard_commit(struct r

 	bpage = cpu_buffer->tail_page;

-	if (bpage == (void *)addr && rb_page_write(bpage) == old_index) {
+	if (bpage->page == (void *)addr && rb_page_write(bpage) == old_index) {
 		/*
 		 * This is on the tail page. It is possible that
 		 * a write could come in and move the tail page

