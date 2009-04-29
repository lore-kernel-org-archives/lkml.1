Return-Path: <linux-kernel-owner+w=401wt.eu-S1756912AbZD2E7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912AbZD2E7f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 00:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753283AbZD2E7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 00:59:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:33190 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514AbZD2E7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 00:59:07 -0400
Message-Id: <20090429045905.358223447@goodmis.org>
References: <20090429044814.138790038@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 29 Apr 2009 00:48:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/5] tracing: fix ref count in splice pages
Content-Disposition: inline; filename=0002-tracing-fix-ref-count-in-splice-pages.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The pages allocated for the splice binary buffer did not initialize
the ref count correctly. This caused pages not to be freed and causes
a drastic memory leak.

Thanks to logdev I was able to trace the tracer to find where the leak
was.

[ Impact: stop memory leak when using splice ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 5d704a4..9058240 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3531,6 +3531,7 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 		if (!ref)
 			break;
 
+		ref->ref = 1;
 		ref->buffer = info->tr->buffer;
 		ref->page = ring_buffer_alloc_read_page(ref->buffer);
 		if (!ref->page) {
-- 
1.6.2.1

-- 
