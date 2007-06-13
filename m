Return-Path: <linux-kernel-owner+w=401wt.eu-S1756206AbXFMFvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206AbXFMFvp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 01:51:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbXFMFvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 01:51:37 -0400
Received: from ozlabs.org ([203.10.76.45]:45778 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624AbXFMFvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 01:51:36 -0400
Subject: Re: [PATCH 5/9] readahead: on-demand readahead logic
From: Rusty Russell <rusty@rustcorp.com.au>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, Jens Axboe <jens.axboe@oracle.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, Steven Pratt <slpratt@austin.ibm.com>,
       Ram Pai <linuxram@us.ibm.com>
In-Reply-To: <20070613040044.GB6494@mail.ustc.edu.cn>
References: <20070516224752.500812933@mail.ustc.edu.cn>
	 <20070516224818.841068730@mail.ustc.edu.cn>
	 <1181622986.6237.65.camel@localhost.localdomain>
	 <20070612103518.GA9624@mail.ustc.edu.cn>
	 <1181698833.6237.113.camel@localhost.localdomain>
	 <20070613040044.GB6494@mail.ustc.edu.cn>
Content-Type: text/plain
Date: Wed, 13 Jun 2007 15:51:14 +1000
Message-Id: <1181713875.6237.134.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-13 at 12:00 +0800, Fengguang Wu wrote:
> On Wed, Jun 13, 2007 at 11:40:33AM +1000, Rusty Russell wrote:
> > +/* If page has PG_readahead flag set, call async readahead logic. */
> > +static inline void
> > +page_cache_check_readahead_page(struct address_space *mapping,
> > +				struct file_ra_state *ra,
> > +				struct file *filp,
> > +				struct page *pg,
> > +				pgoff_t offset,
> > +				unsigned long size)
> > +{
> > +	if (!PageReadahead(pg))
> > +		return;
> > +	page_cache_async_readahead(mapping, ra, filp, pg, offset, size);
> > +}
> 
> This function might not be necessary?
> I guess the explicit code is clear enough.

Hi Fengguang,

	Yes, I think you're right.

> >  static unsigned long
> >  ondemand_readahead(struct address_space *mapping,
> >  		   struct file_ra_state *ra, struct file *filp,
> > -		   struct page *page, pgoff_t offset,
> > +		   bool hit_lookahead_marker, pgoff_t offset,
> 
> Or use names like async/is_async for hit_lookahead_marker?

I wasn't sure.  The argument says "we've hit a marker, so do readahead
even if doesn't look sequential.".  Now, you and I know that only
happens if it's an async readahead, but that's not really relevant to
this function.

> Seems that you have accepted the 'lookahead' term ;)

Yes, but I shouldn't, because marker is still called PG_readahead 8)  I
changed this to "hit_readahead_marker" instead.

> > +/**
> > + * page_cache_async_readahead - file readahead for marked pages
> > + * @mapping: address_space which holds the pagecache and I/O vectors
> > + * @ra: file_ra_state which holds the readahead state
> > + * @filp: passed on to ->readpage() and ->readpages()
> > + * @page: the page at @offset which has the PageReadahead flag set
> 
>                                                ^PG_readahead

Oh, yes.

> > + * @offset: start offset into @mapping, in PAGE_CACHE_SIZE units
> > + * @req_size: hint: total size of the read which the caller is performing in
> > + *            PAGE_CACHE_SIZE units
> 
>                  ^in pagecache pages?
> //Christoph is changing the fixed PAGE_CACHE_SIZE to variable ones.

This came from your patch, but it sounds like a good change.  Also the
PAGE_CACHE_SIZE units above.

> I like this new comment!

Heh, maybe that means I finally understand the code 8).

OK, here is revised patch with your changes:

====
Split ondemand readahead interface into two functions.  I think this
makes it a little clearer for non-readahead experts (like Rusty).

Internally they both call ondemand_readahead(), but the page argument
is changed to an obvious boolean flag.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r e96f11f61577 fs/ext3/dir.c
--- a/fs/ext3/dir.c	Sun Jun 10 18:25:28 2007 +1000
+++ b/fs/ext3/dir.c	Wed Jun 13 15:16:49 2007 +1000
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
diff -r e96f11f61577 fs/ext4/dir.c
--- a/fs/ext4/dir.c	Sun Jun 10 18:25:28 2007 +1000
+++ b/fs/ext4/dir.c	Wed Jun 13 15:16:49 2007 +1000
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
diff -r e96f11f61577 fs/splice.c
--- a/fs/splice.c	Sun Jun 10 18:25:28 2007 +1000
+++ b/fs/splice.c	Wed Jun 13 15:16:49 2007 +1000
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
@@ -361,7 +361,7 @@ __generic_file_splice_read(struct file *
 		page = pages[page_nr];
 
 		if (PageReadahead(page))
-			page_cache_readahead_ondemand(mapping, &in->f_ra, in,
+			page_cache_async_readahead(mapping, &in->f_ra, in,
 					page, index, nr_pages - page_nr);
 
 		/*
diff -r e96f11f61577 include/linux/mm.h
--- a/include/linux/mm.h	Sun Jun 10 18:25:28 2007 +1000
+++ b/include/linux/mm.h	Wed Jun 13 15:16:49 2007 +1000
@@ -1146,12 +1146,20 @@ int do_page_cache_readahead(struct addre
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
 unsigned long max_sane_readahead(unsigned long nr);
 
 /* Do stack extension */
diff -r e96f11f61577 mm/filemap.c
--- a/mm/filemap.c	Sun Jun 10 18:25:28 2007 +1000
+++ b/mm/filemap.c	Wed Jun 13 15:16:49 2007 +1000
@@ -913,15 +913,15 @@ find_page:
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
 		if (PageReadahead(page)) {
-			page_cache_readahead_ondemand(mapping,
+			page_cache_async_readahead(mapping,
 					&ra, filp, page,
 					index, last_index - index);
 		}
@@ -1382,14 +1382,14 @@ retry_find:
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
 		if (PageReadahead(page)) {
-			page_cache_readahead_ondemand(mapping, ra, file, page,
+			page_cache_async_readahead(mapping, ra, file, page,
 							   fdata->pgoff, 1);
 		}
 	}
diff -r e96f11f61577 mm/readahead.c
--- a/mm/readahead.c	Sun Jun 10 18:25:28 2007 +1000
+++ b/mm/readahead.c	Wed Jun 13 15:16:49 2007 +1000
@@ -351,7 +351,7 @@ static unsigned long
 static unsigned long
 ondemand_readahead(struct address_space *mapping,
 		   struct file_ra_state *ra, struct file *filp,
-		   struct page *page, pgoff_t offset,
+		   bool hit_readahead_marker, pgoff_t offset,
 		   unsigned long req_size)
 {
 	unsigned long max;	/* max readahead pages */
@@ -379,7 +379,7 @@ ondemand_readahead(struct address_space 
 	 * Standalone, small read.
 	 * Read as is, and do not pollute the readahead state.
 	 */
-	if (!page && !sequential) {
+	if (!hit_readahead_marker && !sequential) {
 		return __do_page_cache_readahead(mapping, filp,
 						offset, req_size, 0);
 	}
@@ -400,7 +400,7 @@ ondemand_readahead(struct address_space 
 	 * E.g. interleaved reads.
 	 * Not knowing its readahead pos/size, bet on the minimal possible one.
 	 */
-	if (page) {
+	if (hit_readahead_marker) {
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
- * @offset: start offset into @mapping, in PAGE_CACHE_SIZE units
+ * @offset: start offset into @mapping, in pagecache page-sized units
  * @req_size: hint: total size of the read which the caller is performing in
- *            PAGE_CACHE_SIZE units
- *
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
+ *            pagecache pages
+ *
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
+ * @page: the page at @offset which has the PG_readahead flag set
+ * @offset: start offset into @mapping, in pagecache page-sized units
+ * @req_size: hint: total size of the read which the caller is performing in
+ *            pagecache pages
+ *
+ * page_cache_async_ondemand() should be called when a page is used which
+ * has the PG_readahead flag: this is a marker to suggest that the application
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


