Return-Path: <linux-kernel-owner+w=401wt.eu-S1755896AbZBJRh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896AbZBJRh1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 12:37:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754455AbZBJRgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 12:36:22 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:50879 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851AbZBJRgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 12:36:19 -0500
Message-Id: <20090210173617.935043008@goodmis.org>
References: <20090210173504.973802731@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 10 Feb 2009 12:35:06 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/7] ring_buffer: fix typing mistake
Content-Disposition: inline; filename=0001-ring_buffer-fix-typing-mistake.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

Impact: Fix bug

I found several very very curious line.
It's so curious that it may be brought by typing mistake.

When (cpu_buffer->reader_page == cpu_buffer->commit_page):

1) We haven't copied it for bpage is changed:
   bpage = cpu_buffer->reader_page->page;
   memcpy(bpage->data, cpu_buffer->reader_page->page->data + read ... )
2) We need update cpu_buffer->reader_page->read, but
   "cpu_buffer->reader_page += read;" is not right.

[
  This bug was a typo. The commit->reader_page is a page pointer
  and not an index into the page. The line should have been
  commit->reader_page->read += read.  The other changes
  by Lai are nice clean ups to the code.  - SDR
]

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ring_buffer.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 53ba3a6..eca2827 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2406,7 +2406,7 @@ void ring_buffer_free_read_page(struct ring_buffer *buffer, void *data)
  * to swap with a page in the ring buffer.
  *
  * for example:
- *	rpage = ring_buffer_alloc_page(buffer);
+ *	rpage = ring_buffer_alloc_read_page(buffer);
  *	if (!rpage)
  *		return error;
  *	ret = ring_buffer_read_page(buffer, &rpage, cpu, 0);
@@ -2461,18 +2461,17 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 	 */
 	if (cpu_buffer->reader_page == cpu_buffer->commit_page) {
 		unsigned int read = cpu_buffer->reader_page->read;
+		unsigned int commit = rb_page_commit(cpu_buffer->reader_page);
 
 		if (full)
 			goto out;
 		/* The writer is still on the reader page, we must copy */
-		bpage = cpu_buffer->reader_page->page;
 		memcpy(bpage->data,
 		       cpu_buffer->reader_page->page->data + read,
-		       local_read(&bpage->commit) - read);
+		       commit - read);
 
 		/* consume what was read */
-		cpu_buffer->reader_page += read;
-
+		cpu_buffer->reader_page->read = commit;
 	} else {
 		/* swap the pages */
 		rb_init_page(bpage);
-- 
1.5.6.5

-- 
