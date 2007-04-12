Return-Path: <linux-kernel-owner+w=401wt.eu-S1161507AbXDLCvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161507AbXDLCvi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 22:51:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161506AbXDLCvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 22:51:37 -0400
Received: from qb-out-0506.google.com ([72.14.204.234]:58002 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161508AbXDLCvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 22:51:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:date:message-id:in-reply-to:subject;
        b=BfBOLQ00BAuZZyhbkwudcnICJpD9mhbk18Wd1zjlZ9b7YDmsaYM6VlF8a97jxEH5QDWJNx9w1Mf/nDdQTk5grO0u282Dop8Uuzmc8Up1ZI0EW3N74wqI6kNoLGlPBxUI6W7AsBYaDKhOvRBpHwOIF852fd6y8P7G2+sOBgauOFE=
From: Nate Diller <nate.diller@gmail.com>
To: Andrew Morton <akpm@osdl.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
       David Woodhouse <dwmw2@infradead.org>,
       Dave Kleikamp <shaggy@austin.ibm.com>,
       Anton Altaparmakov <aia21@cantab.net>,
       Evgeniy Dushistov <dushistov@mail.ru>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       reiserfs-dev@namesys.com
Date: Wed, 11 Apr 2007 19:49:38 -0700
Message-Id: <20070412024938.27380.66967.patchbomb.py@localhost>
In-Reply-To: <20070412024938.27380.54538.patchbomb.py@localhost>
Subject: [PATCH 2/17] fs: introduce new read_cache_page interface
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Export a single version of read_cache_page, which returns with a locked,
Uptodate page or a synchronous error, and use inline helper functions to
replicate the old behavior.  Also, introduce new helper functions for the
most common file system uses, which include kmapping the page, as well as
needing to keep the page locked.  These changes collectively eliminate a
substantial amount of private fs logic in favor of generic code.

It also simplifies filemap.c significantly, by assuming that callers want
synchronous behavior, which is true for all callers anyway except one.

Signed-off-by: Nate Diller <nate.diller@gmail.com>

---

diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/include/linux/pagemap.h linux-2.6.21-rc6-mm1-test/include/linux/pagemap.h
--- linux-2.6.21-rc6-mm1/include/linux/pagemap.h	2007-04-11 14:22:19.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/include/linux/pagemap.h	2007-04-11 14:29:31.000000000 -0700
@@ -108,21 +108,30 @@ static inline struct page *grab_cache_pa
 
 extern struct page * grab_cache_page_nowait(struct address_space *mapping,
 				unsigned long index);
-extern struct page * read_cache_page_async(struct address_space *mapping,
-				unsigned long index, filler_t *filler,
-				void *data);
-extern struct page * read_cache_page(struct address_space *mapping,
+extern struct page *__read_cache_page(struct address_space *mapping,
 				unsigned long index, filler_t *filler,
 				void *data);
 extern int read_cache_pages(struct address_space *mapping,
 		struct list_head *pages, filler_t *filler, void *data);
 
-static inline struct page *read_mapping_page_async(
-						struct address_space *mapping,
+void fastcall unlock_page(struct page *page);
+static inline struct page *read_cache_page(struct address_space *mapping,
+				unsigned long index, filler_t *filler,
+				void *data)
+{
+	struct page *page;
+
+	page = __read_cache_page(mapping, index, filler, data);
+	if (!IS_ERR(page))
+		unlock_page(page);
+	return page;
+}
+
+static inline struct page *__read_mapping_page(struct address_space *mapping,
 					     unsigned long index, void *data)
 {
 	filler_t *filler = (filler_t *)mapping->a_ops->readpage;
-	return read_cache_page_async(mapping, index, filler, data);
+	return __read_cache_page(mapping, index, filler, data);
 }
 
 static inline struct page *read_mapping_page(struct address_space *mapping,
@@ -132,6 +141,36 @@ static inline struct page *read_mapping_
 	return read_cache_page(mapping, index, filler, data);
 }
 
+static inline struct page *__read_kmap_page(struct address_space *mapping,
+					  unsigned long index)
+{
+	struct page *page = __read_mapping_page(mapping, index, NULL);
+	if (!IS_ERR(page))
+		kmap(page);
+	return page;
+}
+
+static inline struct page *read_kmap_page(struct address_space *mapping,
+					  unsigned long index)
+{
+	struct page *page = read_mapping_page(mapping, index, NULL);
+	if (!IS_ERR(page))
+		kmap(page);
+	return page;
+}
+
+static inline void put_kmapped_page(struct page *page)
+{
+	kunmap(page);
+	page_cache_release(page);
+}
+
+static inline void put_locked_page(struct page *page)
+{
+	unlock_page(page);
+	put_kmapped_page(page);
+}
+
 int add_to_page_cache(struct page *page, struct address_space *mapping,
 				unsigned long index, gfp_t gfp_mask);
 int add_to_page_cache_lru(struct page *page, struct address_space *mapping,
diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/mm/filemap.c linux-2.6.21-rc6-mm1-test/mm/filemap.c
--- linux-2.6.21-rc6-mm1/mm/filemap.c	2007-04-11 14:26:42.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/mm/filemap.c	2007-04-10 21:46:03.000000000 -0700
@@ -1600,115 +1600,53 @@ int generic_file_readonly_mmap(struct fi
 EXPORT_SYMBOL(generic_file_mmap);
 EXPORT_SYMBOL(generic_file_readonly_mmap);
 
-static struct page *__read_cache_page(struct address_space *mapping,
-				unsigned long index,
-				int (*filler)(void *,struct page*),
-				void *data)
-{
-	struct page *page, *cached_page = NULL;
-	int err;
-repeat:
-	page = find_get_page(mapping, index);
-	if (!page) {
-		if (!cached_page) {
-			cached_page = page_cache_alloc_cold(mapping);
-			if (!cached_page)
-				return ERR_PTR(-ENOMEM);
-		}
-		err = add_to_page_cache_lru(cached_page, mapping,
-					index, GFP_KERNEL);
-		if (err == -EEXIST)
-			goto repeat;
-		if (err < 0) {
-			/* Presumably ENOMEM for radix tree node */
-			page_cache_release(cached_page);
-			return ERR_PTR(err);
-		}
-		page = cached_page;
-		cached_page = NULL;
-		err = filler(data, page);
-		if (err < 0) {
-			page_cache_release(page);
-			page = ERR_PTR(err);
-		}
-	}
-	if (cached_page)
-		page_cache_release(cached_page);
-	return page;
-}
-
-/*
- * Same as read_cache_page, but don't wait for page to become unlocked
- * after submitting it to the filler.
+/**
+ * __read_cache_page - read into page cache, fill it if needed
+ * @mapping:	the page's address_space
+ * @index:	the page index
+ * @filler:	function to perform the read
+ * @data:	destination for read data
+ *
+ * Read into the page cache. If a page already exists, and PageUptodate() is
+ * not set, try to fill the page then wait for I/O.
+ *
+ * Returns a locked, uptodate page, or an error.
  */
-struct page *read_cache_page_async(struct address_space *mapping,
+struct page *__read_cache_page(struct address_space *mapping,
 				unsigned long index,
 				int (*filler)(void *,struct page*),
 				void *data)
 {
 	struct page *page;
+	int gfp_mask = mapping_gfp_mask(mapping)|__GFP_COLD;
 	int err;
-
-retry:
-	page = __read_cache_page(mapping, index, filler, data);
-	if (IS_ERR(page))
-		goto out;
+repeat:
+	page = find_or_create_page(mapping, index, gfp_mask);
 	mark_page_accessed(page);
 	if (PageUptodate(page))
-		goto out;
+		return page;
 
-	lock_page(page);
-	if (!page->mapping) {
-		unlock_page(page);
-		page_cache_release(page);
-		goto retry;
-	}
-	if (PageUptodate(page)) {
-		unlock_page(page);
-		goto out;
-	}
 	err = filler(data, page);
 	if (err < 0) {
 		page_cache_release(page);
-		page = ERR_PTR(err);
+		return ERR_PTR(err);
 	}
- out:
-	mark_page_accessed(page);
-	return page;
-}
-EXPORT_SYMBOL(read_cache_page_async);
 
-/**
- * read_cache_page - read into page cache, fill it if needed
- * @mapping:	the page's address_space
- * @index:	the page index
- * @filler:	function to perform the read
- * @data:	destination for read data
- *
- * Read into the page cache. If a page already exists, and PageUptodate() is
- * not set, try to fill the page then wait for it to become unlocked.
- *
- * If the page does not get brought uptodate, return -EIO.
- */
-struct page *read_cache_page(struct address_space *mapping,
-				unsigned long index,
-				int (*filler)(void *,struct page*),
-				void *data)
-{
-	struct page *page;
+	lock_page(page);
+	if (PageUptodate(page))
+		return page;
 
-	page = read_cache_page_async(mapping, index, filler, data);
-	if (IS_ERR(page))
-		goto out;
-	wait_on_page_locked(page);
-	if (!PageUptodate(page)) {
+	if (!page->mapping) {
+		unlock_page(page);
 		page_cache_release(page);
-		page = ERR_PTR(-EIO);
+		goto repeat;
 	}
- out:
-	return page;
+
+	unlock_page(page);
+	page_cache_release(page);
+	return ERR_PTR(-EIO);
 }
-EXPORT_SYMBOL(read_cache_page);
+EXPORT_SYMBOL(__read_cache_page);
 
 /*
  * If the page was newly created, increment its refcount and add it to the
