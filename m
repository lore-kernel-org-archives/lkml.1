Return-Path: <linux-kernel-owner+w=401wt.eu-S932803AbZDAOUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932803AbZDAOUw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 10:20:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763564AbZDAOUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 10:20:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:53225 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445AbZDAOUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 10:20:37 -0400
Message-Id: <20090401142033.869588485@goodmis.org>
References: <20090401141949.714854885@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 01 Apr 2009 10:19:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/2] ring-buffer: do not remove reader page from list on ring buffer free
Content-Disposition: inline; filename=0002-ring-buffer-do-not-remove-reader-page-from-list-on.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: prevent possible memory leak

The reader page of the ring buffer is special. Although it points
into the ring buffer, it is not part of the actual buffer. It is
a page used by the reader to swap with a page in the ring buffer.
Once the swap is made, the new reader page is again outside the
buffer.

Even though the reader page points into the buffer, it is really
pointing to residual data. Note, this data is used by the reader.

              reader page
                  |
                  v
       (prev)   +---+    (next)
     +----------|   |----------+
     |          +---+          |
     v                         v
   +---+        +---+        +---+
-->|   |------->|   |------->|   |--->
<--|   |<-------|   |<-------|   |<---
   +---+        +---+        +---+

     ^            ^            ^
      \           |            /
       ------- Buffer---------

If we perform a list_del_init() on the reader page we will actually remove
the last page the reader swapped with and not the reader page itself.
This will cause that page to not be freed, and thus is a memory leak.

Luckily, the only user of the ring buffer so far is ftrace. And ftrace
will not free its ring buffer after it allocates it. There is no current
possible memory leak. But once there are other users, or if ftrace
dynamically creates and frees its ring buffer, then this would be a
memory leak.

This patch fixes the leak for future cases.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ring_buffer.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index edce2ff..960cbf4 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -563,7 +563,6 @@ static void rb_free_cpu_buffer(struct ring_buffer_per_cpu *cpu_buffer)
 	struct list_head *head = &cpu_buffer->pages;
 	struct buffer_page *bpage, *tmp;
 
-	list_del_init(&cpu_buffer->reader_page->list);
 	free_buffer_page(cpu_buffer->reader_page);
 
 	list_for_each_entry_safe(bpage, tmp, head, list) {
-- 
1.6.2.1

-- 
