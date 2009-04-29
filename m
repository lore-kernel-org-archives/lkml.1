Return-Path: <linux-kernel-owner+w=401wt.eu-S1757720AbZD2FAL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757720AbZD2FAL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 01:00:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755165AbZD2E7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 00:59:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:37636 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823AbZD2E7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 00:59:07 -0400
Message-Id: <20090429045906.295559520@goodmis.org>
References: <20090429044814.138790038@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 29 Apr 2009 00:48:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 3/5] tracing: only add splice page if entries exist
Content-Disposition: inline; filename=0003-tracing-only-add-splice-page-if-entries-exist.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The splice code allocates a page even when the ring buffer is empty.
It detects the ring buffer being empty when it it fails to copy
anything from the ring buffer into the page.

This patch adds a check to see if there is anything in the ring buffer
before allocating a page.

Thanks to logdev for letting me trace the tracer to find this.

[ Impact: speed up due to removing unnecessary allocation ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 9058240..0aeb3b9 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3508,7 +3508,7 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 		.spd_release	= buffer_spd_release,
 	};
 	struct buffer_ref *ref;
-	int size, i;
+	int entries, size, i;
 	size_t ret;
 
 	if (*ppos & (PAGE_SIZE - 1)) {
@@ -3523,7 +3523,9 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 		len &= PAGE_MASK;
 	}
 
-	for (i = 0; i < PIPE_BUFFERS && len; i++, len -= PAGE_SIZE) {
+	entries = ring_buffer_entries_cpu(info->tr->buffer, info->cpu);
+
+	for (i = 0; i < PIPE_BUFFERS && len && entries; i++, len -= PAGE_SIZE) {
 		struct page *page;
 		int r;
 
@@ -3564,6 +3566,8 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 		spd.partial[i].private = (unsigned long)ref;
 		spd.nr_pages++;
 		*ppos += PAGE_SIZE;
+
+		entries = ring_buffer_entries_cpu(info->tr->buffer, info->cpu);
 	}
 
 	spd.nr_pages = i;
-- 
1.6.2.1

-- 
