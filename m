Return-Path: <linux-kernel-owner+w=401wt.eu-S2992588AbXDLPt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992588AbXDLPt4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 11:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992586AbXDLPt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 11:49:56 -0400
Received: from styx.suse.cz ([82.119.242.94]:34301 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2992588AbXDLPtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 11:49:55 -0400
Date: Thu, 12 Apr 2007 17:57:51 +0200
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Improve heuristic detecting sequential reads
Message-ID: <20070412155751.GC23348@duck.suse.cz>
References: <20070410155411.GF13445@duck.suse.cz> <20070410192722.9e6efc8b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="IrhDeMKUP4DT/M7F"
Content-Disposition: inline
In-Reply-To: <20070410192722.9e6efc8b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--IrhDeMKUP4DT/M7F
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue 10-04-07 19:27:22, Andrew Morton wrote:
> And shouldn't offset be called prev_offset?  Or should prev_page be called
> page?  Or index?  Or prev_index?  Or Marmaduke?  The naming is all a mess.
> 
> Wanna take a look at all of this, please?
  OK, attached is a patch which changes prev_page to prev_index and offset
to prev_offset. It's still a bit misleading that in mm/filemap.c, variables
with page-numbers are called <something>_index while in mm/readahead.c they
are often called just offset... But let's leave it for next time.

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs

--IrhDeMKUP4DT/M7F
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="readahead-2.6.21-rc6-tidy.diff"

Rename file_ra_state.prev_page to prev_index and file_ra_state.offset to
prev_offset.  Also update of prev_index in do_generic_mapping_read() is now
moved close to the update of prev_offset.

Signed-off-by: Jan Kara <jack@suse.cz>

diff -rupX /home/jack/.kerndiffexclude linux-2.6.21-rc6-1-readahead/include/linux/fs.h linux-2.6.21-rc6-2-readahead-tidy/include/linux/fs.h
--- linux-2.6.21-rc6-1-readahead/include/linux/fs.h	2007-04-10 17:14:42.000000000 +0200
+++ linux-2.6.21-rc6-2-readahead-tidy/include/linux/fs.h	2007-04-12 17:01:08.000000000 +0200
@@ -696,13 +696,13 @@ struct file_ra_state {
 	unsigned long size;
 	unsigned long flags;		/* ra flags RA_FLAG_xxx*/
 	unsigned long cache_hit;	/* cache hit count*/
-	unsigned long prev_page;	/* Cache last read() position */
+	unsigned long prev_index;	/* Cache last read() position */
 	unsigned long ahead_start;	/* Ahead window */
 	unsigned long ahead_size;
 	unsigned long ra_pages;		/* Maximum readahead window */
 	unsigned long mmap_hit;		/* Cache hit stat for mmap accesses */
 	unsigned long mmap_miss;	/* Cache miss stat for mmap accesses */
-	unsigned int offset;		/* Offset where last read() ended in a page */
+	unsigned int prev_offset;	/* Offset where last read() ended in a page */
 };
 #define RA_FLAG_MISS 0x01	/* a cache miss occured against this file */
 #define RA_FLAG_INCACHE 0x02	/* file is already in cache */
diff -rupX /home/jack/.kerndiffexclude linux-2.6.21-rc6-1-readahead/mm/filemap.c linux-2.6.21-rc6-2-readahead-tidy/mm/filemap.c
--- linux-2.6.21-rc6-1-readahead/mm/filemap.c	2007-04-10 17:18:10.000000000 +0200
+++ linux-2.6.21-rc6-2-readahead-tidy/mm/filemap.c	2007-04-12 16:19:25.000000000 +0200
@@ -877,8 +877,8 @@ void do_generic_mapping_read(struct addr
 	cached_page = NULL;
 	index = *ppos >> PAGE_CACHE_SHIFT;
 	next_index = index;
-	prev_index = ra.prev_page;
-	prev_offset = ra.offset;
+	prev_index = ra.prev_index;
+	prev_offset = ra.prev_offset;
 	last_index = (*ppos + desc->count + PAGE_CACHE_SIZE-1) >> PAGE_CACHE_SHIFT;
 	offset = *ppos & ~PAGE_CACHE_MASK;
 
@@ -931,7 +931,6 @@ page_ok:
 		 */
 		if (prev_index != index || offset != prev_offset)
 			mark_page_accessed(page);
-		prev_index = index;
 
 		/*
 		 * Ok, we have the page, and it's up-to-date, so
@@ -947,7 +946,8 @@ page_ok:
 		offset += ret;
 		index += offset >> PAGE_CACHE_SHIFT;
 		offset &= ~PAGE_CACHE_MASK;
-		prev_offset = ra.offset = offset;
+		prev_index = index;
+		prev_offset = ra.prev_offset = offset;
 
 		page_cache_release(page);
 		if (ret == nr && desc->count)
diff -rupX /home/jack/.kerndiffexclude linux-2.6.21-rc6-1-readahead/mm/readahead.c linux-2.6.21-rc6-2-readahead-tidy/mm/readahead.c
--- linux-2.6.21-rc6-1-readahead/mm/readahead.c	2007-04-10 17:14:42.000000000 +0200
+++ linux-2.6.21-rc6-2-readahead-tidy/mm/readahead.c	2007-04-12 17:03:18.000000000 +0200
@@ -37,7 +37,7 @@ void
 file_ra_state_init(struct file_ra_state *ra, struct address_space *mapping)
 {
 	ra->ra_pages = mapping->backing_dev_info->ra_pages;
-	ra->prev_page = -1;
+	ra->prev_index = -1;
 }
 EXPORT_SYMBOL_GPL(file_ra_state_init);
 
@@ -202,19 +202,19 @@ out:
  * size:	Number of pages in that read
  *              Together, these form the "current window".
  *              Together, start and size represent the `readahead window'.
- * prev_page:   The page which the readahead algorithm most-recently inspected.
+ * prev_index:  The page which the readahead algorithm most-recently inspected.
  *              It is mainly used to detect sequential file reading.
  *              If page_cache_readahead sees that it is again being called for
  *              a page which it just looked at, it can return immediately without
  *              making any state changes.
- * offset:      Offset in the prev_page where the last read ended - used for
+ * offset:      Offset in the prev_index where the last read ended - used for
  *              detection of sequential file reading.
  * ahead_start,
  * ahead_size:  Together, these form the "ahead window".
  * ra_pages:	The externally controlled max readahead for this fd.
  *
  * When readahead is in the off state (size == 0), readahead is disabled.
- * In this state, prev_page is used to detect the resumption of sequential I/O.
+ * In this state, prev_index is used to detect the resumption of sequential I/O.
  *
  * The readahead code manages two windows - the "current" and the "ahead"
  * windows.  The intent is that while the application is walking the pages
@@ -417,7 +417,7 @@ static int make_ahead_window(struct addr
 	ra->ahead_size = get_next_ra_size(ra);
 	ra->ahead_start = ra->start + ra->size;
 
-	block = force || (ra->prev_page >= ra->ahead_start);
+	block = force || (ra->prev_index >= ra->ahead_start);
 	ret = blockable_page_cache_readahead(mapping, filp,
 			ra->ahead_start, ra->ahead_size, ra, block);
 
@@ -469,13 +469,13 @@ page_cache_readahead(struct address_spac
 	 * We avoid doing extra work and bogusly perturbing the readahead
 	 * window expansion logic.
 	 */
-	if (offset == ra->prev_page && --req_size)
+	if (offset == ra->prev_index && --req_size)
 		++offset;
 
-	/* Note that prev_page == -1 if it is a first read */
-	sequential = (offset == ra->prev_page + 1);
-	ra->prev_page = offset;
-	ra->offset = 0;
+	/* Note that prev_index == -1 if it is a first read */
+	sequential = (offset == ra->prev_index + 1);
+	ra->prev_index = offset;
+	ra->prev_offset = 0;
 
 	max = get_max_readahead(ra);
 	newsize = min(req_size, max);
@@ -484,7 +484,7 @@ page_cache_readahead(struct address_spac
 	if (newsize == 0 || (ra->flags & RA_FLAG_INCACHE))
 		goto out;
 
-	ra->prev_page += newsize - 1;
+	ra->prev_index += newsize - 1;
 
 	/*
 	 * Special case - first read at start of file. We'll assume it's
@@ -540,18 +540,18 @@ page_cache_readahead(struct address_spac
 	 * we get called back on the first page of the ahead window which
 	 * will allow us to submit more IO.
 	 */
-	if (ra->prev_page >= ra->ahead_start) {
+	if (ra->prev_index >= ra->ahead_start) {
 		ra->start = ra->ahead_start;
 		ra->size = ra->ahead_size;
 		make_ahead_window(mapping, filp, ra, 0);
 recheck:
-		/* prev_page shouldn't overrun the ahead window */
-		ra->prev_page = min(ra->prev_page,
+		/* prev_index shouldn't overrun the ahead window */
+		ra->prev_index = min(ra->prev_index,
 			ra->ahead_start + ra->ahead_size - 1);
 	}
 
 out:
-	return ra->prev_page + 1;
+	return ra->prev_index + 1;
 }
 EXPORT_SYMBOL_GPL(page_cache_readahead);
 

--IrhDeMKUP4DT/M7F--
