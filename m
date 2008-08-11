Return-Path: <linux-kernel-owner+w=401wt.eu-S1754740AbYHKPcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740AbYHKPcO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 11:32:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbYHKPb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 11:31:56 -0400
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:17379 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbYHKPbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 11:31:55 -0400
Message-Id: <20080811150657.432780786@quilx.com>
References: <20080811150616.207532384@quilx.com>
User-Agent: quilt/0.46-1
Date: Mon, 11 Aug 2008 08:06:26 -0700
From: Christoph Lameter <cl@linux-foundation.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: akpm@linux-foundation.org, Christoph Lameter <clameter@sgi.com>,
       Christoph Lameter <cl@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
CC: linux-fsdevel@vger.kernel.org
Cc: Mel Gorman <mel@skynet.ie>
Cc: andi@firstfloor.org
Cc: Rik van Riel <riel@redhat.com>
Cc: mpm@selenic.com
Cc: Dave Chinner <david@fromorbit.com>
Subject: [patch 10/19] buffer heads: Support slab defrag
Content-Disposition: inline; filename=0024-Buffer-heads-Support-slab-defrag.patch
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

Index: linux-next/fs/buffer.c
===================================================================
--- linux-next.orig/fs/buffer.c	2008-08-11 07:50:08.322348091 -0700
+++ linux-next/fs/buffer.c	2008-08-11 07:54:49.222357893 -0700
@@ -3316,6 +3316,104 @@ int bh_submit_read(struct buffer_head *b
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
@@ -3334,6 +3432,7 @@ void __init buffer_init(void)
 				(SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|
 				SLAB_MEM_SPREAD),
 				init_buffer_head);
+	kmem_cache_setup_defrag(bh_cachep, get_buffers, kick_buffers);
 
 	/*
 	 * Limit the bh occupancy to 10% of ZONE_NORMAL

-- 
