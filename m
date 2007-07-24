Return-Path: <linux-kernel-owner+w=401wt.eu-S935010AbXGXCQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935010AbXGXCQi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 22:16:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763502AbXGXCMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 22:12:22 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:40717 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1759351AbXGXCMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 22:12:14 -0400
Message-ID: <385243123.75006@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070724020043.189132028@mail.ustc.edu.cn>
References: <20070724020009.677809022@mail.ustc.edu.cn>
User-Agent: quilt/0.45-1
Date: Tue, 24 Jul 2007 10:00:19 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 10/10] filemap: convert some unsigned long to pgoff_t
Content-Disposition: inline; filename=pgoff_t.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Convert some 'unsigned long' to pgoff_t.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 include/linux/pagemap.h |   23 ++++++++++++-----------
 mm/filemap.c            |   32 ++++++++++++++++----------------
 2 files changed, 28 insertions(+), 27 deletions(-)

--- linux-2.6.22-rc6-mm1.orig/include/linux/pagemap.h
+++ linux-2.6.22-rc6-mm1/include/linux/pagemap.h
@@ -83,11 +83,11 @@ static inline struct page *page_cache_al
 typedef int filler_t(void *, struct page *);
 
 extern struct page * find_get_page(struct address_space *mapping,
-				unsigned long index);
+				pgoff_t index);
 extern struct page * find_lock_page(struct address_space *mapping,
-				unsigned long index);
+				pgoff_t index);
 extern struct page * find_or_create_page(struct address_space *mapping,
-				unsigned long index, gfp_t gfp_mask);
+				pgoff_t index, gfp_t gfp_mask);
 unsigned find_get_pages(struct address_space *mapping, pgoff_t start,
 			unsigned int nr_pages, struct page **pages);
 unsigned find_get_pages_contig(struct address_space *mapping, pgoff_t start,
@@ -100,41 +100,42 @@ struct page *__grab_cache_page(struct ad
 /*
  * Returns locked page at given index in given cache, creating it if needed.
  */
-static inline struct page *grab_cache_page(struct address_space *mapping, unsigned long index)
+static inline struct page *grab_cache_page(struct address_space *mapping,
+								pgoff_t index)
 {
 	return find_or_create_page(mapping, index, mapping_gfp_mask(mapping));
 }
 
 extern struct page * grab_cache_page_nowait(struct address_space *mapping,
-				unsigned long index);
+				pgoff_t index);
 extern struct page * read_cache_page_async(struct address_space *mapping,
-				unsigned long index, filler_t *filler,
+				pgoff_t index, filler_t *filler,
 				void *data);
 extern struct page * read_cache_page(struct address_space *mapping,
-				unsigned long index, filler_t *filler,
+				pgoff_t index, filler_t *filler,
 				void *data);
 extern int read_cache_pages(struct address_space *mapping,
 		struct list_head *pages, filler_t *filler, void *data);
 
 static inline struct page *read_mapping_page_async(
 						struct address_space *mapping,
-					     unsigned long index, void *data)
+						     pgoff_t index, void *data)
 {
 	filler_t *filler = (filler_t *)mapping->a_ops->readpage;
 	return read_cache_page_async(mapping, index, filler, data);
 }
 
 static inline struct page *read_mapping_page(struct address_space *mapping,
-					     unsigned long index, void *data)
+					     pgoff_t index, void *data)
 {
 	filler_t *filler = (filler_t *)mapping->a_ops->readpage;
 	return read_cache_page(mapping, index, filler, data);
 }
 
 int add_to_page_cache(struct page *page, struct address_space *mapping,
-				unsigned long index, gfp_t gfp_mask);
+				pgoff_t index, gfp_t gfp_mask);
 int add_to_page_cache_lru(struct page *page, struct address_space *mapping,
-				unsigned long index, gfp_t gfp_mask);
+				pgoff_t index, gfp_t gfp_mask);
 extern void remove_from_page_cache(struct page *page);
 extern void __remove_from_page_cache(struct page *page);
 
--- linux-2.6.22-rc6-mm1.orig/mm/filemap.c
+++ linux-2.6.22-rc6-mm1/mm/filemap.c
@@ -594,7 +594,7 @@ void fastcall __lock_page_nosync(struct 
  * Is there a pagecache struct page at the given (mapping, offset) tuple?
  * If yes, increment its refcount and return it; if no, return NULL.
  */
-struct page * find_get_page(struct address_space *mapping, unsigned long offset)
+struct page * find_get_page(struct address_space *mapping, pgoff_t offset)
 {
 	struct page *page;
 
@@ -618,7 +618,7 @@ EXPORT_SYMBOL(find_get_page);
  * Returns zero if the page was not present. find_lock_page() may sleep.
  */
 struct page *find_lock_page(struct address_space *mapping,
-				unsigned long offset)
+				pgoff_t offset)
 {
 	struct page *page;
 
@@ -664,7 +664,7 @@ EXPORT_SYMBOL(find_lock_page);
  * memory exhaustion.
  */
 struct page *find_or_create_page(struct address_space *mapping,
-		unsigned long index, gfp_t gfp_mask)
+		pgoff_t index, gfp_t gfp_mask)
 {
 	struct page *page;
 	int err;
@@ -794,7 +794,7 @@ EXPORT_SYMBOL(find_get_pages_tag);
  * and deadlock against the caller's locked page.
  */
 struct page *
-grab_cache_page_nowait(struct address_space *mapping, unsigned long index)
+grab_cache_page_nowait(struct address_space *mapping, pgoff_t index)
 {
 	struct page *page = find_get_page(mapping, index);
 
@@ -870,10 +870,10 @@ void do_generic_mapping_read(struct addr
 			     read_actor_t actor)
 {
 	struct inode *inode = mapping->host;
-	unsigned long index;
-	unsigned long offset;
-	unsigned long last_index;
-	unsigned long prev_index;
+	pgoff_t index;
+	pgoff_t last_index;
+	pgoff_t prev_index;
+	unsigned long offset;      /* offset into pagecache page */
 	unsigned int prev_offset;
 	int error;
 
@@ -885,7 +885,7 @@ void do_generic_mapping_read(struct addr
 
 	for (;;) {
 		struct page *page;
-		unsigned long end_index;
+		pgoff_t end_index;
 		loff_t isize;
 		unsigned long nr, ret;
 
@@ -1255,7 +1255,7 @@ EXPORT_SYMBOL(generic_file_sendfile);
 
 static ssize_t
 do_readahead(struct address_space *mapping, struct file *filp,
-	     unsigned long index, unsigned long nr)
+	     pgoff_t index, unsigned long nr)
 {
 	if (!mapping || !mapping->a_ops || !mapping->a_ops->readpage)
 		return -EINVAL;
@@ -1275,8 +1275,8 @@ asmlinkage ssize_t sys_readahead(int fd,
 	if (file) {
 		if (file->f_mode & FMODE_READ) {
 			struct address_space *mapping = file->f_mapping;
-			unsigned long start = offset >> PAGE_CACHE_SHIFT;
-			unsigned long end = (offset + count - 1) >> PAGE_CACHE_SHIFT;
+			pgoff_t start = offset >> PAGE_CACHE_SHIFT;
+			pgoff_t end = (offset + count - 1) >> PAGE_CACHE_SHIFT;
 			unsigned long len = end - start + 1;
 			ret = do_readahead(mapping, file, start, len);
 		}
@@ -1294,7 +1294,7 @@ asmlinkage ssize_t sys_readahead(int fd,
  * This adds the requested page to the page cache if it isn't already there,
  * and schedules an I/O to read in its contents from disk.
  */
-static int fastcall page_cache_read(struct file * file, unsigned long offset)
+static int fastcall page_cache_read(struct file * file, pgoff_t offset)
 {
 	struct address_space *mapping = file->f_mapping;
 	struct page *page; 
@@ -1540,7 +1540,7 @@ EXPORT_SYMBOL(generic_file_mmap);
 EXPORT_SYMBOL(generic_file_readonly_mmap);
 
 static struct page *__read_cache_page(struct address_space *mapping,
-				unsigned long index,
+				pgoff_t index,
 				int (*filler)(void *,struct page*),
 				void *data)
 {
@@ -1574,7 +1574,7 @@ repeat:
  * after submitting it to the filler.
  */
 struct page *read_cache_page_async(struct address_space *mapping,
-				unsigned long index,
+				pgoff_t index,
 				int (*filler)(void *,struct page*),
 				void *data)
 {
@@ -1623,7 +1623,7 @@ EXPORT_SYMBOL(read_cache_page_async);
  * If the page does not get brought uptodate, return -EIO.
  */
 struct page *read_cache_page(struct address_space *mapping,
-				unsigned long index,
+				pgoff_t index,
 				int (*filler)(void *,struct page*),
 				void *data)
 {

--
