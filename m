Return-Path: <linux-kernel-owner+w=401wt.eu-S936202AbXHIQIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936202AbXHIQIZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 12:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940092AbXHIQGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 12:06:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51486 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S940138AbXHIQGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 12:06:11 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 01/14] FS-Cache: Release page->private after failed readahead
	[try #2]
To: torvalds@osdl.org, akpm@osdl.org, steved@redhat.com,
       trond.myklebust@fys.uio.no
Cc: linux-fsdevel@vger.kernel.org, linux-cachefs@redhat.com,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org
Date: Thu, 09 Aug 2007 17:04:44 +0100
Message-ID: <20070809160444.17906.30209.stgit@warthog.cambridge.redhat.com>
In-Reply-To: <20070809160438.17906.76348.stgit@warthog.cambridge.redhat.com>
References: <20070809160438.17906.76348.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The attached patch causes read_cache_pages() to release page-private data on a
page for which add_to_page_cache() fails or the filler function fails. This
permits pages with caching references associated with them to be cleaned up.

The invalidatepage() address space op is called (indirectly) to do the honours.

Signed-Off-By: David Howells <dhowells@redhat.com>
---

 mm/readahead.c |   40 ++++++++++++++++++++++++++++++++++++++--
 1 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/mm/readahead.c b/mm/readahead.c
index 39bf45d..12d1378 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -15,6 +15,7 @@
 #include <linux/backing-dev.h>
 #include <linux/task_io_accounting_ops.h>
 #include <linux/pagevec.h>
+#include <linux/buffer_head.h>
 
 void default_unplug_io_fn(struct backing_dev_info *bdi, struct page *page)
 {
@@ -51,6 +52,41 @@ EXPORT_SYMBOL_GPL(file_ra_state_init);
 
 #define list_to_page(head) (list_entry((head)->prev, struct page, lru))
 
+/*
+ * see if a page needs releasing upon read_cache_pages() failure
+ * - the caller of read_cache_pages() may have set PG_private before calling,
+ *   such as the NFS fs marking pages that are cached locally on disk, thus we
+ *   need to give the fs a chance to clean up in the event of an error
+ */
+static void read_cache_pages_invalidate_page(struct address_space *mapping,
+					     struct page *page)
+{
+	if (PagePrivate(page)) {
+		if (TestSetPageLocked(page))
+			BUG();
+		page->mapping = mapping;
+		do_invalidatepage(page, 0);
+		page->mapping = NULL;
+		unlock_page(page);
+	}
+	page_cache_release(page);
+}
+
+/*
+ * release a list of pages, invalidating them first if need be
+ */
+static void read_cache_pages_invalidate_pages(struct address_space *mapping,
+					      struct list_head *pages)
+{
+	struct page *victim;
+
+	while (!list_empty(pages)) {
+		victim = list_to_page(pages);
+		list_del(&victim->lru);
+		read_cache_pages_invalidate_page(mapping, victim);
+	}
+}
+
 /**
  * read_cache_pages - populate an address space with some pages & start reads against them
  * @mapping: the address_space
@@ -74,14 +110,14 @@ int read_cache_pages(struct address_space *mapping, struct list_head *pages,
 		page = list_to_page(pages);
 		list_del(&page->lru);
 		if (add_to_page_cache(page, mapping, page->index, GFP_KERNEL)) {
-			page_cache_release(page);
+			read_cache_pages_invalidate_page(mapping, page);
 			continue;
 		}
 		ret = filler(data, page);
 		if (!pagevec_add(&lru_pvec, page))
 			__pagevec_lru_add(&lru_pvec);
 		if (ret) {
-			put_pages_list(pages);
+			read_cache_pages_invalidate_pages(mapping, pages);
 			break;
 		}
 		task_io_account_read(PAGE_CACHE_SIZE);

