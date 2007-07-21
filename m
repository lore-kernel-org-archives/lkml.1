Return-Path: <linux-kernel-owner+w=401wt.eu-S932237AbXGUEq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237AbXGUEq6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 00:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761040AbXGUEoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 00:44:17 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:49798 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750993AbXGUEnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 00:43:50 -0400
Message-ID: <384993020.60861@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070721044346.824927556@mail.ustc.edu.cn>
References: <20070721044300.909424569@mail.ustc.edu.cn>
User-Agent: quilt/0.45-1
Date: Sat, 21 Jul 2007 12:43:03 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 3/7] readahead: combine file_ra_state.prev_index/prev_offset into prev_pos
Content-Disposition: inline; filename=merge-start-prev_index.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Combine the file_ra_state members
				unsigned long prev_index
				unsigned int prev_offset
into
				loff_t prev_pos

It is more consistent and better supports huge files.

Thanks to Peter for the nice proposal!

Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 fs/ext3/dir.c      |    2 +-
 fs/ext4/dir.c      |    2 +-
 fs/splice.c        |    2 +-
 include/linux/fs.h |    3 +--
 mm/filemap.c       |   11 ++++++-----
 mm/readahead.c     |   15 ++++++++-------
 6 files changed, 18 insertions(+), 17 deletions(-)

--- linux-2.6.22-rc6-mm1.orig/include/linux/fs.h
+++ linux-2.6.22-rc6-mm1/include/linux/fs.h
@@ -778,8 +778,7 @@ struct file_ra_state {
 
 	unsigned int ra_pages;		/* Maximum readahead window */
 	int mmap_miss;			/* Cache miss stat for mmap accesses */
-	unsigned long prev_index;	/* Cache last read() position */
-	unsigned int prev_offset;	/* Offset where last read() ended in a page */
+	loff_t prev_pos;		/* Cache last read() position */
 };
 
 /*
--- linux-2.6.22-rc6-mm1.orig/mm/filemap.c
+++ linux-2.6.22-rc6-mm1/mm/filemap.c
@@ -881,8 +881,8 @@ void do_generic_mapping_read(struct addr
 
 	index = *ppos >> PAGE_CACHE_SHIFT;
 	next_index = index;
-	prev_index = ra.prev_index;
-	prev_offset = ra.prev_offset;
+	prev_index = ra.prev_pos >> PAGE_CACHE_SHIFT;
+	prev_offset = ra.prev_pos & (PAGE_CACHE_SIZE-1);
 	last_index = (*ppos + desc->count + PAGE_CACHE_SIZE-1) >> PAGE_CACHE_SHIFT;
 	offset = *ppos & ~PAGE_CACHE_MASK;
 
@@ -968,7 +968,6 @@ page_ok:
 		index += offset >> PAGE_CACHE_SHIFT;
 		offset &= ~PAGE_CACHE_MASK;
 		prev_offset = offset;
-		ra.prev_offset = offset;
 
 		page_cache_release(page);
 		if (ret == nr && desc->count)
@@ -1055,7 +1054,9 @@ no_cached_page:
 
 out:
 	*_ra = ra;
-	_ra->prev_index = prev_index;
+	_ra->prev_pos = prev_index;
+	_ra->prev_pos <<= PAGE_CACHE_SHIFT;
+	_ra->prev_pos |= prev_offset;
 
 	*ppos = ((loff_t) index << PAGE_CACHE_SHIFT) + offset;
 	if (filp)
@@ -1435,7 +1436,7 @@ retry_find:
 	 * Found the page and have a reference on it.
 	 */
 	mark_page_accessed(page);
-	ra->prev_index = page->index;
+	ra->prev_pos = page->index << PAGE_CACHE_SHIFT;
 	return page;
 
 outside_data_content:
--- linux-2.6.22-rc6-mm1.orig/mm/readahead.c
+++ linux-2.6.22-rc6-mm1/mm/readahead.c
@@ -45,7 +45,7 @@ void
 file_ra_state_init(struct file_ra_state *ra, struct address_space *mapping)
 {
 	ra->ra_pages = mapping->backing_dev_info->ra_pages;
-	ra->prev_index = -1;
+	ra->prev_pos = -1;
 }
 EXPORT_SYMBOL_GPL(file_ra_state_init);
 
@@ -318,7 +318,7 @@ static unsigned long get_next_ra_size(st
  * indicator. The flag won't be set on already cached pages, to avoid the
  * readahead-for-nothing fuss, saving pointless page cache lookups.
  *
- * prev_index tracks the last visited page in the _previous_ read request.
+ * prev_pos tracks the last visited byte in the _previous_ read request.
  * It should be maintained by the caller, and will be used for detecting
  * small random reads. Note that the readahead algorithm checks loosely
  * for sequential patterns. Hence interleaved reads might be served as
@@ -342,11 +342,9 @@ ondemand_readahead(struct address_space 
 		   bool hit_readahead_marker, pgoff_t offset,
 		   unsigned long req_size)
 {
-	int max;	/* max readahead pages */
-	int sequential;
-
-	max = ra->ra_pages;
-	sequential = (offset - ra->prev_index <= 1UL) || (req_size > max);
+	int	max = ra->ra_pages;	/* max readahead pages */
+	pgoff_t prev_offset;
+	int	sequential;
 
 	/*
 	 * It's the expected callback offset, assume sequential access.
@@ -360,6 +358,9 @@ ondemand_readahead(struct address_space 
 		goto readit;
 	}
 
+	prev_offset = ra->prev_pos >> PAGE_CACHE_SHIFT;
+	sequential = offset - prev_offset <= 1UL || req_size > max;
+
 	/*
 	 * Standalone, small read.
 	 * Read as is, and do not pollute the readahead state.
--- linux-2.6.22-rc6-mm1.orig/fs/ext3/dir.c
+++ linux-2.6.22-rc6-mm1/fs/ext3/dir.c
@@ -143,7 +143,7 @@ static int ext3_readdir(struct file * fi
 					sb->s_bdev->bd_inode->i_mapping,
 					&filp->f_ra, filp,
 					index, 1);
-			filp->f_ra.prev_index = index;
+			filp->f_ra.prev_pos = index << PAGE_CACHE_SHIFT;
 			bh = ext3_bread(NULL, inode, blk, 0, &err);
 		}
 
--- linux-2.6.22-rc6-mm1.orig/fs/ext4/dir.c
+++ linux-2.6.22-rc6-mm1/fs/ext4/dir.c
@@ -142,7 +142,7 @@ static int ext4_readdir(struct file * fi
 					sb->s_bdev->bd_inode->i_mapping,
 					&filp->f_ra, filp,
 					index, 1);
-			filp->f_ra.prev_index = index;
+			filp->f_ra.prev_pos = index << PAGE_CACHE_SHIFT;
 			bh = ext4_bread(NULL, inode, blk, 0, &err);
 		}
 
--- linux-2.6.22-rc6-mm1.orig/fs/splice.c
+++ linux-2.6.22-rc6-mm1/fs/splice.c
@@ -455,7 +455,7 @@ fill_it:
 	 */
 	while (page_nr < nr_pages)
 		page_cache_release(pages[page_nr++]);
-	in->f_ra.prev_index = index;
+	in->f_ra.prev_pos = index << PAGE_CACHE_SHIFT;
 
 	if (spd.nr_pages)
 		return splice_to_pipe(pipe, &spd);

--
