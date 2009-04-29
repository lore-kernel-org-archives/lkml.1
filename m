Return-Path: <linux-kernel-owner+w=401wt.eu-S1758403AbZD2FAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758403AbZD2FAi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 01:00:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755236AbZD2E7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 00:59:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:37643 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090AbZD2E7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 00:59:08 -0400
Message-Id: <20090429045907.265491855@goodmis.org>
References: <20090429044814.138790038@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 29 Apr 2009 00:48:18 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 4/5] tracing: have splice only copy full pages
Content-Disposition: inline; filename=0004-tracing-have-splice-only-copy-full-pages.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Splice works with pages, it is much more effecient to use an entire
page than to copy bits over several pages.

Using logdev to trace the internals of the splice mechanism, I was
able to see that splice can be very aggressive. When tracing is
occurring, and the reader caught up to the writer, and the writer
is on the reader page, the reader will copy what is there into the
splice page. Splice may iterate over several pages and if the
writer is still writing to the page, the reader will keep copying
bits to new pages to pass to userspace.

This patch changes it to only pass data to userspace if the page
is full (the writer has left the page). This has a small side effect
that splice can not read a partial page, and must wait for the
page to fill. This should not be an issue. If tracing has stopped,
then a use of "read" will still read all of the page.

[ Impact: better performance for ring buffer splice code ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 0aeb3b9..f5427e0 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3542,7 +3542,7 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 		}
 
 		r = ring_buffer_read_page(ref->buffer, &ref->page,
-					  len, info->cpu, 0);
+					  len, info->cpu, 1);
 		if (r < 0) {
 			ring_buffer_free_read_page(ref->buffer,
 						   ref->page);
-- 
1.6.2.1

-- 
