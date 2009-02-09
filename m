Return-Path: <linux-kernel-owner+w=401wt.eu-S1755012AbZBIPVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012AbZBIPVs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 10:21:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754765AbZBIPVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 10:21:08 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:53032 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754693AbZBIPVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 10:21:06 -0500
Message-Id: <20090209152101.528824783@goodmis.org>
References: <20090209151744.459736868@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 09 Feb 2009 10:17:45 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/2] ring_buffer: fix typing mistake
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
index bd38c5c..e97acae 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2377,7 +2377,7 @@ void ring_buffer_free_read_page(struct ring_buffer *buffer, void *data)
  * to swap with a page in the ring buffer.
  *
  * for example:
- *	rpage = ring_buffer_alloc_page(buffer);
+ *	rpage = ring_buffer_alloc_read_page(buffer);
  *	if (!rpage)
  *		return error;
  *	ret = ring_buffer_read_page(buffer, &rpage, cpu, 0);
@@ -2432,18 +2432,17 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
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
