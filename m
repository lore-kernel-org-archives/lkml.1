Return-Path: <linux-kernel-owner+w=401wt.eu-S1754184Ab0AZWRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab0AZWRR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 17:17:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753756Ab0AZWRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 17:17:15 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:63023 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121Ab0AZWRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 17:17:15 -0500
X-Authority-Analysis: v=1.0 c=1 a=SdZH3j3oqqkA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=GxKzfC2Yg13wzWQHhGEA:9 a=zBJOgn3y8FNlGzR3S2AA:7 a=_KQlAJUauENhotuZQGtvhysqHiEA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100126221712.930071285@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 17:09:26 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/5] ring-buffer: Check for end of page in iterator
References: <20100126220923.534282809@goodmis.org>
Content-Disposition: inline; filename=0003-ring-buffer-Check-for-end-of-page-in-iterator.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

If the iterator comes to an empty page for some reason, or if
the page is emptied by a consuming read. The iterator code currently
does not check if the iterator is pass the contents, and may
return a false entry.

This patch adds a check to the ring buffer iterator to test if the
current page has been completely read and sets the iterator to the
next page if necessary.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 503b630..8c1b2d2 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -3064,9 +3064,6 @@ rb_iter_peek(struct ring_buffer_iter *iter, u64 *ts)
 	struct ring_buffer_event *event;
 	int nr_loops = 0;
 
-	if (ring_buffer_iter_empty(iter))
-		return NULL;
-
 	cpu_buffer = iter->cpu_buffer;
 	buffer = cpu_buffer->buffer;
 
@@ -3080,6 +3077,9 @@ rb_iter_peek(struct ring_buffer_iter *iter, u64 *ts)
 		rb_iter_reset(iter);
 
  again:
+	if (ring_buffer_iter_empty(iter))
+		return NULL;
+
 	/*
 	 * We repeat when a timestamp is encountered.
 	 * We can get multiple timestamps by nested interrupts or also
@@ -3094,6 +3094,11 @@ rb_iter_peek(struct ring_buffer_iter *iter, u64 *ts)
 	if (rb_per_cpu_empty(cpu_buffer))
 		return NULL;
 
+	if (iter->head >= local_read(&iter->head_page->page->commit)) {
+		rb_inc_iter(iter);
+		goto again;
+	}
+
 	event = rb_iter_head_event(iter);
 
 	switch (event->type_len) {
-- 
1.6.5


