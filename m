Return-Path: <linux-kernel-owner+w=401wt.eu-S1755199AbXFMBlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199AbXFMBlI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 21:41:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751854AbXFMBk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 21:40:57 -0400
Received: from ozlabs.org ([203.10.76.45]:39956 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751663AbXFMBk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 21:40:56 -0400
Subject: Re: [PATCH 5/9] readahead: on-demand readahead logic
From: Rusty Russell <rusty@rustcorp.com.au>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, Jens Axboe <jens.axboe@oracle.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, Steven Pratt <slpratt@austin.ibm.com>,
       Ram Pai <linuxram@us.ibm.com>
In-Reply-To: <20070612103518.GA9624@mail.ustc.edu.cn>
References: <20070516224752.500812933@mail.ustc.edu.cn>
	 <20070516224818.841068730@mail.ustc.edu.cn>
	 <1181622986.6237.65.camel@localhost.localdomain>
	 <20070612103518.GA9624@mail.ustc.edu.cn>
Content-Type: text/plain
Date: Wed, 13 Jun 2007 11:40:33 +1000
Message-Id: <1181698833.6237.113.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-12 at 18:35 +0800, Fengguang Wu wrote:
> > This seems a little like two functions crammed into one.  Do you think
> > page_cache_readahead_ondemand() should be split into
> > "page_cache_readahead()" which doesn't take a page*, and
> > "page_cache_check_readahead_page()" which is an inline which does the
> > PageReadahead(page) check as well?
> 
> page_cache_check_readahead_page(..., page) is a good idea.
> But which part of the code should we put to page_cache_readahead()
> that does not take a page param?

OK, here's my attempt.  I also made them return void, since none of the
callers seem to mind.  I didn't change the internals much: I think
they're pretty clear and I didn't want to clash if you decided to rename
the "ra" fields.  It compiles and boots.

Thoughts?

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 3c8ae0c37063 fs/ext3/dir.c
--- a/fs/ext3/dir.c	Tue Jun 12 17:17:25 2007 +1000
+++ b/fs/ext3/dir.c	Wed Jun 13 11:17:42 2007 +1000
@@ -139,10 +139,10 @@ static int ext3_readdir(struct file * fi
 			pgoff_t index = map_bh.b_blocknr >>
 					(PAGE_CACHE_SHIFT - inode->i_blkbits);
 			if (!ra_has_index(&filp->f_ra, index))
-				page_cache_readahead_ondemand(
+				page_cache_sync_readahead(
 					sb->s_bdev->bd_inode->i_mapping,
 					&filp->f_ra, filp,
-					NULL, index, 1);
+					index, 1);
 			filp->f_ra.prev_index = index;
 			bh = ext3_bread(NULL, inode, blk, 0, &err);
 		}
diff -r 3c8ae0c37063 fs/ext4/dir.c
--- a/fs/ext4/dir.c	Tue Jun 12 17:17:25 2007 +1000
+++ b/fs/ext4/dir.c	Wed Jun 13 11:19:56 2007 +1000
@@ -138,10 +138,10 @@ static int ext4_readdir(struct file * fi
 			pgoff_t index = map_bh.b_blocknr >>
 					(PAGE_CACHE_SHIFT - inode->i_blkbits);
 			if (!ra_has_index(&filp->f_ra, index))
-				page_cache_readahead_ondemand(
+				page_cache_sync_readahead(
 					sb->s_bdev->bd_inode->i_mapping,
 					&filp->f_ra, filp,
-					NULL, index, 1);
+					index, 1);
 			filp->f_ra.prev_index = index;
 			bh = ext4_bread(NULL, inode, blk, 0, &err);
 		}
diff -r 3c8ae0c37063 fs/splice.c
--- a/fs/splice.c	Tue Jun 12 17:17:25 2007 +1000
+++ b/fs/splice.c	Wed Jun 13 11:18:38 2007 +1000
@@ -312,8 +312,8 @@ __generic_file_splice_read(struct file *
 		 */
 		page = find_get_page(mapping, index);
 		if (!page) {
-			page_cache_readahead_ondemand(mapping, &in->f_ra, in,
-					NULL, index, nr_pages - spd.nr_pages);
+			page_cache_sync_readahead(mapping, &in->f_ra, in,
+					index, nr_pages - spd.nr_pages);
 
 			/*
 			 * page didn't exist, allocate one.
@@ -360,8 +360,7 @@ __generic_file_splice_read(struct file *
 		this_len = min_t(unsigned long, len, PAGE_CACHE_SIZE - loff);
 		page = pages[page_nr];
 
-		if (PageReadahead(page))
-			page_cache_readahead_ondemand(mapping, &in->f_ra, in,
+		page_cache_check_readahead_page(mapping, &in->f_ra, in,
 					page, index, nr_pages - page_nr);
 
 		/*
diff -r 3c8ae0c37063 include/linux/mm.h
--- a/include/linux/mm.h	Tue Jun 12 17:17:25 2007 +1000
+++ b/include/linux/mm.h	Wed Jun 13 11:25:10 2007 +1000
@@ -1146,12 +1146,34 @@ int do_page_cache_readahead(struct addre
 			pgoff_t offset, unsigned long nr_to_read);
 int force_page_cache_readahead(struct address_space *mapping, struct file *filp,
 			pgoff_t offset, unsigned long nr_to_read);
-unsigned long page_cache_readahead_ondemand(struct address_space *mapping,
-			  struct file_ra_state *ra,
-			  struct file *filp,
-			  struct page *page,
-			  pgoff_t offset,
-			  unsigned long size);
+
+void page_cache_sync_readahead(struct address_space *mapping,
+			       struct file_ra_state *ra,
+			       struct file *filp,
+			       pgoff_t offset,
+			       unsigned long size);
+
+void page_cache_async_readahead(struct address_space *mapping,
+				struct file_ra_state *ra,
+				struct file *filp,
+				struct page *pg,
+				pgoff_t offset,
+				unsigned long size);
+
+/* If page has PG_readahead flag set, call async readahead logic. */
+static inline void
+page_cache_check_readahead_page(struct address_space *mapping,
+				struct file_ra_state *ra,
+				struct file *filp,
+				struct page *pg,
+				pgoff_t offset,
+				unsigned long size)
+{
+	if (!PageReadahead(pg))
+		return;
+	page_cache_async_readahead(mapping, ra, filp, pg, offset, size);
+}
+
 unsigned long max_sane_readahead(unsigned long nr);
 
 /* Do stack extension */
diff -r 3c8ae0c37063 mm/filemap.c
--- a/mm/filemap.c	Tue Jun 12 17:17:25 2007 +1000
+++ b/mm/filemap.c	Wed Jun 13 11:22:04 2007 +1000
@@ -913,18 +913,16 @@ find_page:
 find_page:
 		page = find_get_page(mapping, index);
 		if (!page) {
-			page_cache_readahead_ondemand(mapping,
-					&ra, filp, page,
+			page_cache_sync_readahead(mapping,
+					&ra, filp,
 					index, last_index - index);
 			page = find_get_page(mapping, index);
 			if (unlikely(page == NULL))
 				goto no_cached_page;
 		}
-		if (PageReadahead(page)) {
-			page_cache_readahead_ondemand(mapping,
+		page_cache_check_readahead_page(mapping,
 					&ra, filp, page,
 					index, last_index - index);
-		}
 		if (!PageUptodate(page))
 			goto page_not_up_to_date;
 page_ok:
@@ -1382,16 +1380,14 @@ retry_find:
 	 */
 	if (VM_SequentialReadHint(vma)) {
 		if (!page) {
-			page_cache_readahead_ondemand(mapping, ra, file, page,
+			page_cache_sync_readahead(mapping, ra, file,
 							   fdata->pgoff, 1);
 			page = find_lock_page(mapping, fdata->pgoff);
 			if (!page)
 				goto no_cached_page;
 		}
-		if (PageReadahead(page)) {
-			page_cache_readahead_ondemand(mapping, ra, file, page,
+		page_cache_check_readahead_page(mapping, ra, file, page,
 							   fdata->pgoff, 1);
-		}
 	}
 
 	if (!page) {
diff -r 3c8ae0c37063 mm/readahead.c
--- a/mm/readahead.c	Tue Jun 12 17:17:25 2007 +1000
+++ b/mm/readahead.c	Wed Jun 13 11:09:39 2007 +1000
@@ -351,7 +351,7 @@ static unsigned long
 static unsigned long
 ondemand_readahead(struct address_space *mapping,
 		   struct file_ra_state *ra, struct file *filp,
-		   struct page *page, pgoff_t offset,
+		   bool hit_lookahead_marker, pgoff_t offset,
 		   unsigned long req_size)
 {
 	unsigned long max;	/* max readahead pages */
@@ -379,7 +379,7 @@ ondemand_readahead(struct address_space 
 	 * Standalone, small read.
 	 * Read as is, and do not pollute the readahead state.
 	 */
-	if (!page && !sequential) {
+	if (!hit_lookahead_marker && !sequential) {
 		return __do_page_cache_readahead(mapping, filp,
 						offset, req_size, 0);
 	}
@@ -400,7 +400,7 @@ ondemand_readahead(struct address_space 
 	 * E.g. interleaved reads.
 	 * Not knowing its readahead pos/size, bet on the minimal possible one.
 	 */
-	if (page) {
+	if (hit_lookahead_marker) {
 		ra_index++;
 		ra_size = min(4 * ra_size, max);
 	}
@@ -413,50 +413,71 @@ fill_ra:
 }
 
 /**
- * page_cache_readahead_ondemand - generic file readahead
+ * page_cache_sync_readahead - generic file readahead
  * @mapping: address_space which holds the pagecache and I/O vectors
  * @ra: file_ra_state which holds the readahead state
  * @filp: passed on to ->readpage() and ->readpages()
- * @page: the page at @offset, or NULL if non-present
  * @offset: start offset into @mapping, in PAGE_CACHE_SIZE units
  * @req_size: hint: total size of the read which the caller is performing in
  *            PAGE_CACHE_SIZE units
  *
- * page_cache_readahead_ondemand() is the entry point of readahead logic.
- * This function should be called when it is time to perform readahead:
- * 1) @page == NULL
- *    A cache miss happened, time for synchronous readahead.
- * 2) @page != NULL && PageReadahead(@page)
- *    A look-ahead hit occured, time for asynchronous readahead.
- */
-unsigned long
-page_cache_readahead_ondemand(struct address_space *mapping,
-				struct file_ra_state *ra, struct file *filp,
-				struct page *page, pgoff_t offset,
-				unsigned long req_size)
+ * page_cache_sync_readahead() should be called when a cache miss happened:
+ * it will submit the read.  The readahead logic may decide to piggyback more
+ * pages onto the read request if access patterns suggest it will improve
+ * performance.
+ */
+void page_cache_sync_readahead(struct address_space *mapping,
+			       struct file_ra_state *ra, struct file *filp,
+			       pgoff_t offset, unsigned long req_size)
 {
 	/* no read-ahead */
 	if (!ra->ra_pages)
-		return 0;
-
-	if (page) {
-		/*
-		 * It can be PG_reclaim.
-		 */
-		if (PageWriteback(page))
-			return 0;
-
-		ClearPageReadahead(page);
-
-		/*
-		 * Defer asynchronous read-ahead on IO congestion.
-		 */
-		if (bdi_read_congested(mapping->backing_dev_info))
-			return 0;
-	}
+		return;
 
 	/* do read-ahead */
-	return ondemand_readahead(mapping, ra, filp, page,
-					offset, req_size);
-}
-EXPORT_SYMBOL_GPL(page_cache_readahead_ondemand);
+	ondemand_readahead(mapping, ra, filp, false, offset, req_size);
+}
+EXPORT_SYMBOL_GPL(page_cache_sync_readahead);
+
+/**
+ * page_cache_async_readahead - file readahead for marked pages
+ * @mapping: address_space which holds the pagecache and I/O vectors
+ * @ra: file_ra_state which holds the readahead state
+ * @filp: passed on to ->readpage() and ->readpages()
+ * @page: the page at @offset which has the PageReadahead flag set
+ * @offset: start offset into @mapping, in PAGE_CACHE_SIZE units
+ * @req_size: hint: total size of the read which the caller is performing in
+ *            PAGE_CACHE_SIZE units
+ *
+ * page_cache_async_ondemand() should be called when a page is used which
+ * has the PageReadahead flag: this is a marker to suggest that the application
+ * has used up enough of the readahead window that we should start pulling in
+ * more pages. */
+void
+page_cache_async_readahead(struct address_space *mapping,
+			   struct file_ra_state *ra, struct file *filp,
+			   struct page *page, pgoff_t offset,
+			   unsigned long req_size)
+{
+	/* no read-ahead */
+	if (!ra->ra_pages)
+		return;
+
+	/*
+	 * Same bit is used for PG_readahead and PG_reclaim.
+	 */
+	if (PageWriteback(page))
+		return;
+
+	ClearPageReadahead(page);
+
+	/*
+	 * Defer asynchronous read-ahead on IO congestion.
+	 */
+	if (bdi_read_congested(mapping->backing_dev_info))
+		return;
+
+	/* do read-ahead */
+	ondemand_readahead(mapping, ra, filp, true, offset, req_size);
+}
+EXPORT_SYMBOL_GPL(page_cache_async_readahead);


