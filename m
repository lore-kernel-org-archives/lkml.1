Return-Path: <linux-kernel-owner+w=401wt.eu-S932979AbYBTQQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932979AbYBTQQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 11:16:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765012AbYBTQJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 11:09:56 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45405 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764940AbYBTQJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 11:09:27 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 11/37] FS-Cache: Release page->private after failed readahead
To: Trond.Myklebust@netapp.com, chuck.lever@oracle.com, casey@schaufler-ca.com
Cc: nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Wed, 20 Feb 2008 16:06:57 +0000
Message-ID: <20080220160657.4715.2133.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080220160557.4715.66608.stgit@warthog.procyon.org.uk>
References: <20080220160557.4715.66608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The attached patch causes read_cache_pages() to release page-private data on a
page for which add_to_page_cache() fails or the filler function fails. This
permits pages with caching references associated with them to be cleaned up.

The invalidatepage() address space op is called (indirectly) to do the honours.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 mm/readahead.c |   39 +++++++++++++++++++++++++++++++++++++--
 1 files changed, 37 insertions(+), 2 deletions(-)


diff --git a/mm/readahead.c b/mm/readahead.c
index c9c50ca..75aa6b6 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -44,6 +44,41 @@ EXPORT_SYMBOL_GPL(file_ra_state_init);
 
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
@@ -65,14 +100,14 @@ int read_cache_pages(struct address_space *mapping, struct list_head *pages,
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

