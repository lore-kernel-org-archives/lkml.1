Return-Path: <linux-kernel-owner+w=401wt.eu-S932850AbZDCP6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932850AbZDCP6e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 11:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933579AbZDCPzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 11:55:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56505 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932733AbZDCPzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 11:55:06 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 05/41] FS-Cache: Release page->private after failed readahead
	[ver #48]
To: linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, nfsv4@linux-nfs.org, linux-fsdevel@vger.kernel.org
Date: Fri, 03 Apr 2009 16:55:02 +0100
Message-ID: <20090403155502.28714.31394.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090403155436.28714.23368.stgit@warthog.procyon.org.uk>
References: <20090403155436.28714.23368.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The attached patch causes read_cache_pages() to release page-private data on a
page for which add_to_page_cache() fails.  If the filler function fails, then
the problematic page is left attached to the pagecache (with appropriate flags
set, one presumes) and the remaining to-be-attached pages are invalidated and
discarded.  This permits pages with caching references associated with them to
be cleaned up.

The invalidatepage() address space op is called (indirectly) to do the honours.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Steve Dickson <steved@redhat.com>
Acked-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Tested-by: Daire Byrne <Daire.Byrne@framestore.com>
---

 include/linux/page-flags.h |    2 +-
 mm/readahead.c             |   39 +++++++++++++++++++++++++++++++++++++--
 2 files changed, 38 insertions(+), 3 deletions(-)


diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 61df177..9d99e74 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -182,7 +182,7 @@ static inline int TestClearPage##uname(struct page *page) { return 0; }
 
 struct page;	/* forward declaration */
 
-TESTPAGEFLAG(Locked, locked)
+TESTPAGEFLAG(Locked, locked) TESTSETFLAG(Locked, locked)
 PAGEFLAG(Error, error)
 PAGEFLAG(Referenced, referenced) TESTCLEARFLAG(Referenced, referenced)
 PAGEFLAG(Dirty, dirty) TESTSCFLAG(Dirty, dirty) __CLEARPAGEFLAG(Dirty, dirty)
diff --git a/mm/readahead.c b/mm/readahead.c
index 9ce303d..6be9275 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -31,6 +31,41 @@ EXPORT_SYMBOL_GPL(file_ra_state_init);
 
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
+		if (!trylock_page(page))
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
@@ -52,14 +87,14 @@ int read_cache_pages(struct address_space *mapping, struct list_head *pages,
 		list_del(&page->lru);
 		if (add_to_page_cache_lru(page, mapping,
 					page->index, GFP_KERNEL)) {
-			page_cache_release(page);
+			read_cache_pages_invalidate_page(mapping, page);
 			continue;
 		}
 		page_cache_release(page);
 
 		ret = filler(data, page);
 		if (unlikely(ret)) {
-			put_pages_list(pages);
+			read_cache_pages_invalidate_pages(mapping, pages);
 			break;
 		}
 		task_io_account_read(PAGE_CACHE_SIZE);

