Return-Path: <linux-kernel-owner+w=401wt.eu-S1755275Ab0A2UvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275Ab0A2UvY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 15:51:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755078Ab0A2UvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 15:51:20 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:42682 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550Ab0A2UvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 15:51:14 -0500
Message-Id: <20100129205003.813495196@quilx.com>
References: <20100129204931.789743493@quilx.com>
User-Agent: quilt/0.46-1
Date: Fri, 29 Jan 2010 14:49:41 -0600
From: Christoph Lameter <cl@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Lameter <clameter@sgi.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: akpm@linux-foundation.org
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: linux-kernel@vger.kernel.org
Subject: buffer heads: Support slab defrag
Content-Disposition: inline; filename=defrag_buffer_head
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Defragmentation support for buffer heads. We convert the references to
buffers to struct page references and try to remove the buffers from
those pages. If the pages are dirty then trigger writeout so that the
buffer heads can be removed later.

Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 fs/buffer.c |   99 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 99 insertions(+)

Index: slab-2.6/fs/buffer.c
===================================================================
--- slab-2.6.orig/fs/buffer.c	2010-01-22 15:09:43.000000000 -0600
+++ slab-2.6/fs/buffer.c	2010-01-22 16:17:27.000000000 -0600
@@ -3352,6 +3352,104 @@ int bh_submit_read(struct buffer_head *b
 }
 EXPORT_SYMBOL(bh_submit_read);
 
+/*
+ * Writeback a page to clean the dirty state
+ */
+static void trigger_write(struct page *page)
+{
+	struct address_space *mapping = page_mapping(page);
+	int rc;
+	struct writeback_control wbc = {
+		.sync_mode = WB_SYNC_NONE,
+		.nr_to_write = 1,
+		.range_start = 0,
+		.range_end = LLONG_MAX,
+		.nonblocking = 1,
+		.for_reclaim = 0
+	};
+
+	if (!mapping->a_ops->writepage)
+		/* No write method for the address space */
+		return;
+
+	if (!clear_page_dirty_for_io(page))
+		/* Someone else already triggered a write */
+		return;
+
+	rc = mapping->a_ops->writepage(page, &wbc);
+	if (rc < 0)
+		/* I/O Error writing */
+		return;
+
+	if (rc == AOP_WRITEPAGE_ACTIVATE)
+		unlock_page(page);
+}
+
+/*
+ * Get references on buffers.
+ *
+ * We obtain references on the page that uses the buffer. v[i] will point to
+ * the corresponding page after get_buffers() is through.
+ *
+ * We are safe from the underlying page being removed simply by doing
+ * a get_page_unless_zero. The buffer head removal may race at will.
+ * try_to_free_buffes will later take appropriate locks to remove the
+ * buffers if they are still there.
+ */
+static void *get_buffers(struct kmem_cache *s, int nr, void **v)
+{
+	struct page *page;
+	struct buffer_head *bh;
+	int i, j;
+	int n = 0;
+
+	for (i = 0; i < nr; i++) {
+		bh = v[i];
+		v[i] = NULL;
+
+		page = bh->b_page;
+
+		if (page && PagePrivate(page)) {
+			for (j = 0; j < n; j++)
+				if (page == v[j])
+					continue;
+		}
+
+		if (get_page_unless_zero(page))
+			v[n++] = page;
+	}
+	return NULL;
+}
+
+/*
+ * Despite its name: kick_buffers operates on a list of pointers to
+ * page structs that was set up by get_buffer().
+ */
+static void kick_buffers(struct kmem_cache *s, int nr, void **v,
+							void *private)
+{
+	struct page *page;
+	int i;
+
+	for (i = 0; i < nr; i++) {
+		page = v[i];
+
+		if (!page || PageWriteback(page))
+			continue;
+
+		if (trylock_page(page)) {
+			if (PageDirty(page))
+				trigger_write(page);
+			else {
+				if (PagePrivate(page))
+					try_to_free_buffers(page);
+				unlock_page(page);
+			}
+		}
+		put_page(page);
+	}
+}
+
 static void
 init_buffer_head(void *data)
 {
@@ -3370,6 +3468,7 @@ void __init buffer_init(void)
 				(SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|
 				SLAB_MEM_SPREAD),
 				init_buffer_head);
+	kmem_cache_setup_defrag(bh_cachep, get_buffers, kick_buffers);
 
 	/*
 	 * Limit the bh occupancy to 10% of ZONE_NORMAL

-- 
