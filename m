Return-Path: <linux-kernel-owner+w=401wt.eu-S1758379AbZCEXch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758379AbZCEXch (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 18:32:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758233AbZCEXb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 18:31:57 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:48494 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758281AbZCEXbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 18:31:55 -0500
Message-Id: <20090305225514.144717530@polymtl.ca>
References: <20090305224728.947235917@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 05 Mar 2009 17:47:39 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>, ltt-dev@lists.casi.polymtl.ca,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Martin Bligh <mbligh@google.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       mrubin@google.com, md@google.com
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [RFC patch 11/41] ltt-relay: cache pages address
Content-Disposition: inline; filename=lttng-optimize-write-to-page-function-cache-page-address.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Thu,  5 Mar 2009 23:14:10 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

page_address is not fast in some systems,
we should cache it.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 include/linux/ltt-relay.h |    4 ++--
 ltt/ltt-relay-alloc.c     |   10 +++++-----
 2 files changed, 7 insertions(+), 7 deletions(-)

Index: linux-2.6-lttng/include/linux/ltt-relay.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/ltt-relay.h	2009-03-05 16:07:47.000000000 -0500
+++ linux-2.6-lttng/include/linux/ltt-relay.h	2009-03-05 16:07:47.000000000 -0500
@@ -34,6 +34,7 @@ struct rchan_buf;
 
 struct buf_page {
 	struct page *page;
+	void *virt;		/* page address of the struct page */
 	size_t offset;		/* page offset in the buffer */
 	struct list_head list;	/* buffer linked list */
 };
@@ -286,8 +287,7 @@ static inline int ltt_relay_write(struct
 
 	page = ltt_relay_cache_page(buf, &buf->wpage, page, offset);
 	pagecpy = min_t(size_t, len, PAGE_SIZE - (offset & ~PAGE_MASK));
-	ltt_relay_do_copy(page_address(page->page)
-		+ (offset & ~PAGE_MASK), src, pagecpy);
+	ltt_relay_do_copy(page->virt + (offset & ~PAGE_MASK), src, pagecpy);
 
 	if (unlikely(len != pagecpy))
 		_ltt_relay_write(buf, offset, src, len, page, pagecpy);
Index: linux-2.6-lttng/ltt/ltt-relay-alloc.c
===================================================================
--- linux-2.6-lttng.orig/ltt/ltt-relay-alloc.c	2009-03-05 16:07:47.000000000 -0500
+++ linux-2.6-lttng/ltt/ltt-relay-alloc.c	2009-03-05 16:07:47.000000000 -0500
@@ -54,6 +54,7 @@ static int relay_alloc_buf(struct rchan_
 			goto depopulate;
 		}
 		list_add_tail(&buf_page->list, &buf->pages);
+		buf_page->virt = page_address(buf_page->page);
 		buf_page->offset = (size_t)i << PAGE_SHIFT;
 		set_page_private(buf_page->page, (unsigned long)buf_page);
 		if (i == 0) {
@@ -529,8 +530,8 @@ void _ltt_relay_write(struct rchan_buf *
 
 		page = ltt_relay_cache_page(buf, &buf->wpage, page, offset);
 		pagecpy = min_t(size_t, len, PAGE_SIZE - (offset & ~PAGE_MASK));
-		ltt_relay_do_copy(page_address(page->page)
-			+ (offset & ~PAGE_MASK), src, pagecpy);
+		ltt_relay_do_copy(page->virt
+				+ (offset & ~PAGE_MASK), src, pagecpy);
 	} while (unlikely(len != pagecpy));
 }
 EXPORT_SYMBOL_GPL(_ltt_relay_write);
@@ -556,8 +557,7 @@ int ltt_relay_read(struct rchan_buf *buf
 	for (;;) {
 		page = ltt_relay_cache_page(buf, &buf->rpage, page, offset);
 		pagecpy = min_t(size_t, len, PAGE_SIZE - (offset & ~PAGE_MASK));
-		memcpy(dest, page_address(page->page) + (offset & ~PAGE_MASK),
-			pagecpy);
+		memcpy(dest, page->virt + (offset & ~PAGE_MASK), pagecpy);
 		len -= pagecpy;
 		if (likely(!len))
 			break;
@@ -610,7 +610,7 @@ void *ltt_relay_offset_address(struct rc
 	if (offset < page->offset || offset >= page->offset + PAGE_SIZE)
 		buf->hpage[odd] = page = buf->wpage;
 	page = ltt_relay_cache_page(buf, &buf->hpage[odd], page, offset);
-	return page_address(page->page) + (offset & ~PAGE_MASK);
+	return page->virt + (offset & ~PAGE_MASK);
 }
 EXPORT_SYMBOL_GPL(ltt_relay_offset_address);
 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
