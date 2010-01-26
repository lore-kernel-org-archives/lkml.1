Return-Path: <linux-kernel-owner+w=401wt.eu-S1754842Ab0AZWR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab0AZWR1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 17:17:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753756Ab0AZWRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 17:17:17 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:63028 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581Ab0AZWRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 17:17:15 -0500
X-Authority-Analysis: v=1.0 c=1 a=B_aHRMq--eUA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=o05VNxUTF6JSB76KbYQA:9 a=0FdooLUpkRs5bUXuu1gA:7 a=DqrTW66T03P0gHVkip1mFGr5A-sA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100126221712.676452282@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 17:09:25 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/5] ring-buffer: Check if ring buffer iterator has stale data
References: <20100126220923.534282809@goodmis.org>
Content-Disposition: inline; filename=0002-ring-buffer-Check-if-ring-buffer-iterator-has-stale-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Usually reads of the ring buffer is performed by a single task.
There are two types of reads from the ring buffer.

One is a consuming read which will consume the entry that was read
and the next read will be the entry that follows.

The other is an iterator that will let the user read the contents of
the ring buffer without modifying it. When an iterator is allocated,
writes to the ring buffer are disabled to protect the iterator.

The problem exists when consuming reads happen while an iterator is
allocated. Specifically, the kind of read that swaps out an entire
page (used by splice) and replaces it with a new read. If the iterator
is on the page that is swapped out, then the next read may read
from this swapped out page and return garbage.

This patch adds a check when reading the iterator to make sure that
the iterator contents are still valid. If a consuming read has taken
place, the iterator is reset.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index edefe3b..503b630 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -464,6 +464,8 @@ struct ring_buffer_iter {
 	struct ring_buffer_per_cpu	*cpu_buffer;
 	unsigned long			head;
 	struct buffer_page		*head_page;
+	struct buffer_page		*cache_reader_page;
+	unsigned long			cache_read;
 	u64				read_stamp;
 };
 
@@ -2716,6 +2718,8 @@ static void rb_iter_reset(struct ring_buffer_iter *iter)
 		iter->read_stamp = cpu_buffer->read_stamp;
 	else
 		iter->read_stamp = iter->head_page->page->time_stamp;
+	iter->cache_reader_page = cpu_buffer->reader_page;
+	iter->cache_read = cpu_buffer->read;
 }
 
 /**
@@ -3066,6 +3070,15 @@ rb_iter_peek(struct ring_buffer_iter *iter, u64 *ts)
 	cpu_buffer = iter->cpu_buffer;
 	buffer = cpu_buffer->buffer;
 
+	/*
+	 * Check if someone performed a consuming read to
+	 * the buffer. A consuming read invalidates the iterator
+	 * and we need to reset the iterator in this case.
+	 */
+	if (unlikely(iter->cache_read != cpu_buffer->read ||
+		     iter->cache_reader_page != cpu_buffer->reader_page))
+		rb_iter_reset(iter);
+
  again:
 	/*
 	 * We repeat when a timestamp is encountered.
-- 
1.6.5


