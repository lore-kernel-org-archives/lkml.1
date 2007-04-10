Return-Path: <linux-kernel-owner+w=401wt.eu-S1030888AbXDJPqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030888AbXDJPqW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 11:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030890AbXDJPqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 11:46:22 -0400
Received: from styx.suse.cz ([82.119.242.94]:58297 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030888AbXDJPqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 11:46:21 -0400
Date: Tue, 10 Apr 2007 17:54:11 +0200
From: Jan Kara <jack@suse.cz>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, npiggin@suse.de
Subject: [PATCH] Improve heuristic detecting sequential reads
Message-ID: <20070410155411.GF13445@duck.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0F1p//8PRICkK4MW"
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

  Hello!

  In thread http://lkml.org/lkml/2007/3/9/403, we discussed a problem
with the current heuristic for detecting sequential IO in
do_generic_mapping_read() - for small files a page is marked as accessed
only once which can cause a performance problems.
  Attached is a patch that improves the heuristic by introducing a
ra.offset variable so now we can reliably detect sequetial reads.
The patch replaces Nick's patch from http://lkml.org/lkml/2007/3/15/177
(Nick has acked to replace the patch). Could you please put the patch
into -mm?

							Bye
								Honza

-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs

--0F1p//8PRICkK4MW
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="readahead-2.6.21-rc6.diff"

Introduce ra.offset and store in it an offset where the previous read ended. This way
we can detect whether reads are really sequential (and thus we should not mark the page
as accessed repeatedly) or whether they are random and just happen to be in the same page
(and the page should really be marked accessed again).

Signed-off-by: Jan Kara <jack@suse.cz>

diff -rupX /home/jack/.kerndiffexclude linux-2.6.21-rc6/include/linux/fs.h linux-2.6.21-rc6-1-readahead/include/linux/fs.h
--- linux-2.6.21-rc6/include/linux/fs.h	2007-04-10 17:09:58.000000000 +0200
+++ linux-2.6.21-rc6-1-readahead/include/linux/fs.h	2007-04-10 17:14:42.000000000 +0200
@@ -702,6 +702,7 @@ struct file_ra_state {
 	unsigned long ra_pages;		/* Maximum readahead window */
 	unsigned long mmap_hit;		/* Cache hit stat for mmap accesses */
 	unsigned long mmap_miss;	/* Cache miss stat for mmap accesses */
+	unsigned int offset;		/* Offset where last read() ended in a page */
 };
 #define RA_FLAG_MISS 0x01	/* a cache miss occured against this file */
 #define RA_FLAG_INCACHE 0x02	/* file is already in cache */
diff -rupX /home/jack/.kerndiffexclude linux-2.6.21-rc6/mm/filemap.c linux-2.6.21-rc6-1-readahead/mm/filemap.c
--- linux-2.6.21-rc6/mm/filemap.c	2007-04-10 17:10:00.000000000 +0200
+++ linux-2.6.21-rc6-1-readahead/mm/filemap.c	2007-04-10 17:18:10.000000000 +0200
@@ -868,6 +868,7 @@ void do_generic_mapping_read(struct addr
 	unsigned long last_index;
 	unsigned long next_index;
 	unsigned long prev_index;
+	unsigned int prev_offset;
 	loff_t isize;
 	struct page *cached_page;
 	int error;
@@ -877,6 +878,7 @@ void do_generic_mapping_read(struct addr
 	index = *ppos >> PAGE_CACHE_SHIFT;
 	next_index = index;
 	prev_index = ra.prev_page;
+	prev_offset = ra.offset;
 	last_index = (*ppos + desc->count + PAGE_CACHE_SIZE-1) >> PAGE_CACHE_SHIFT;
 	offset = *ppos & ~PAGE_CACHE_MASK;
 
@@ -924,10 +926,10 @@ page_ok:
 			flush_dcache_page(page);
 
 		/*
-		 * When (part of) the same page is read multiple times
-		 * in succession, only mark it as accessed the first time.
+		 * When a sequential read accesses a page several times,
+		 * only mark it as accessed the first time.
 		 */
-		if (prev_index != index)
+		if (prev_index != index || offset != prev_offset)
 			mark_page_accessed(page);
 		prev_index = index;
 
@@ -945,6 +947,7 @@ page_ok:
 		offset += ret;
 		index += offset >> PAGE_CACHE_SHIFT;
 		offset &= ~PAGE_CACHE_MASK;
+		prev_offset = ra.offset = offset;
 
 		page_cache_release(page);
 		if (ret == nr && desc->count)
diff -rupX /home/jack/.kerndiffexclude linux-2.6.21-rc6/mm/readahead.c linux-2.6.21-rc6-1-readahead/mm/readahead.c
--- linux-2.6.21-rc6/mm/readahead.c	2007-04-10 17:10:00.000000000 +0200
+++ linux-2.6.21-rc6-1-readahead/mm/readahead.c	2007-04-10 17:14:42.000000000 +0200
@@ -207,6 +207,8 @@ out:
  *              If page_cache_readahead sees that it is again being called for
  *              a page which it just looked at, it can return immediately without
  *              making any state changes.
+ * offset:      Offset in the prev_page where the last read ended - used for
+ *              detection of sequential file reading.
  * ahead_start,
  * ahead_size:  Together, these form the "ahead window".
  * ra_pages:	The externally controlled max readahead for this fd.
@@ -473,6 +475,7 @@ page_cache_readahead(struct address_spac
 	/* Note that prev_page == -1 if it is a first read */
 	sequential = (offset == ra->prev_page + 1);
 	ra->prev_page = offset;
+	ra->offset = 0;
 
 	max = get_max_readahead(ra);
 	newsize = min(req_size, max);

--0F1p//8PRICkK4MW--
