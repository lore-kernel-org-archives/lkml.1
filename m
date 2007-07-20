Return-Path: <linux-kernel-owner+w=401wt.eu-S1756374AbXGTKLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756374AbXGTKLj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 06:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752510AbXGTKLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 06:11:31 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:59100 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751984AbXGTKLa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 06:11:30 -0400
Message-ID: <384926279.42287@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070720101123.936159499@mail.ustc.edu.cn>
References: <20070720100740.106917381@mail.ustc.edu.cn>
User-Agent: quilt/0.45-1
Date: Fri, 20 Jul 2007 18:07:41 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] compacting file_ra_state
Content-Disposition: inline; filename=short-rasize.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use 'unsigned int' instead of 'unsigned long' for the readahead indexes/sizes.

This helps reduce memory consumption on 64bit CPU when
a lot of files are opened.

Note that the (smaller) 32bit index can support up to 16PB file.
Which should be sufficient large at least for now.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 include/linux/fs.h |   10 +++++-----
 mm/filemap.c       |    2 +-
 mm/readahead.c     |    5 +++--
 3 files changed, 9 insertions(+), 8 deletions(-)

--- linux-2.6.22-rc6-mm1.orig/include/linux/fs.h
+++ linux-2.6.22-rc6-mm1/include/linux/fs.h
@@ -771,16 +771,16 @@ struct fown_struct {
  * Track a single file's readahead state
  */
 struct file_ra_state {
-	pgoff_t start;                  /* where readahead started */
-	unsigned long size;             /* # of readahead pages */
-	unsigned long async_size;       /* do asynchronous readahead when
+	unsigned int start;		/* where readahead started */
+	unsigned int size;		/* # of readahead pages */
+	unsigned int async_size;	/* do asynchronous readahead when
 					   there are only # of pages ahead */
 
-	unsigned long ra_pages;		/* Maximum readahead window */
+	unsigned int ra_pages;		/* Maximum readahead window */
 	unsigned long mmap_hit;		/* Cache hit stat for mmap accesses */
 	unsigned long mmap_miss;	/* Cache miss stat for mmap accesses */
-	unsigned long prev_index;	/* Cache last read() position */
 	unsigned int prev_offset;	/* Offset where last read() ended in a page */
+	unsigned int prev_index;	/* Cache last read() position */
 };
 
 /*
--- linux-2.6.22-rc6-mm1.orig/mm/filemap.c
+++ linux-2.6.22-rc6-mm1/mm/filemap.c
@@ -840,7 +840,7 @@ static void shrink_readahead_size_eio(st
 	if (count > 5)
 		return;
 	count++;
-	printk(KERN_WARNING "Reducing readahead size to %luK\n",
+	printk(KERN_WARNING "Reducing readahead size to %dK\n",
 		ra->ra_pages << (PAGE_CACHE_SHIFT - 10));
 }
 
--- linux-2.6.22-rc6-mm1.orig/mm/readahead.c
+++ linux-2.6.22-rc6-mm1/mm/readahead.c
@@ -342,11 +342,12 @@ ondemand_readahead(struct address_space 
 		   bool hit_readahead_marker, pgoff_t offset,
 		   unsigned long req_size)
 {
-	unsigned long max;	/* max readahead pages */
+	int max;	/* max readahead pages */
 	int sequential;
 
 	max = ra->ra_pages;
-	sequential = (offset - ra->prev_index <= 1UL) || (req_size > max);
+	sequential = ((unsigned int)offset - ra->prev_index <= 1UL) ||
+			(req_size > max);
 
 	/*
 	 * It's the expected callback offset, assume sequential access.

--
