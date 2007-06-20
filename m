Return-Path: <linux-kernel-owner+w=401wt.eu-S1760356AbXFTSdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760356AbXFTSdc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 14:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759213AbXFTSag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 14:30:36 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54777 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756423AbXFTSaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 14:30:10 -0400
Message-Id: <20070620183009.169763823@sgi.com>
References: <20070620182907.506775016@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 20 Jun 2007 11:29:21 -0700
From: clameter@sgi.com
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Badari Pulavarty <pbadari@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [14/37] Use page_cache_xxx in fs/splice.c
Content-Disposition: inline; filename=vps_fs_splice
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 fs/splice.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

Index: vps/fs/splice.c
===================================================================
--- vps.orig/fs/splice.c	2007-06-09 22:18:02.000000000 -0700
+++ vps/fs/splice.c	2007-06-09 22:22:08.000000000 -0700
@@ -282,9 +282,9 @@ __generic_file_splice_read(struct file *
 		.ops = &page_cache_pipe_buf_ops,
 	};
 
-	index = *ppos >> PAGE_CACHE_SHIFT;
-	loff = *ppos & ~PAGE_CACHE_MASK;
-	nr_pages = (len + loff + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
+	index = page_cache_index(mapping, *ppos);
+	loff = page_cache_offset(mapping, *ppos);
+	nr_pages = page_cache_next(mapping, len + loff);
 
 	if (nr_pages > PIPE_BUFFERS)
 		nr_pages = PIPE_BUFFERS;
@@ -345,7 +345,7 @@ __generic_file_splice_read(struct file *
 	 * Now loop over the map and see if we need to start IO on any
 	 * pages, fill in the partial map, etc.
 	 */
-	index = *ppos >> PAGE_CACHE_SHIFT;
+	index = page_cache_index(mapping, *ppos);
 	nr_pages = spd.nr_pages;
 	spd.nr_pages = 0;
 	for (page_nr = 0; page_nr < nr_pages; page_nr++) {
@@ -357,7 +357,8 @@ __generic_file_splice_read(struct file *
 		/*
 		 * this_len is the max we'll use from this page
 		 */
-		this_len = min_t(unsigned long, len, PAGE_CACHE_SIZE - loff);
+		this_len = min_t(unsigned long, len,
+					page_cache_size(mapping) - loff);
 		page = pages[page_nr];
 
 		if (PageReadahead(page))
@@ -416,7 +417,7 @@ __generic_file_splice_read(struct file *
 			 * i_size must be checked after ->readpage().
 			 */
 			isize = i_size_read(mapping->host);
-			end_index = (isize - 1) >> PAGE_CACHE_SHIFT;
+			end_index = page_cache_index(mapping, isize - 1);
 			if (unlikely(!isize || index > end_index))
 				break;
 
@@ -425,7 +426,8 @@ __generic_file_splice_read(struct file *
 			 * the length and stop
 			 */
 			if (end_index == index) {
-				loff = PAGE_CACHE_SIZE - (isize & ~PAGE_CACHE_MASK);
+				loff = page_cache_size(mapping)
+					- page_cache_offset(mapping, isize);
 				if (total_len + loff > isize)
 					break;
 				/*
@@ -557,6 +559,7 @@ static int pipe_to_file(struct pipe_inod
 	struct page *page;
 	void *fsdata;
 	int ret;
+	int pagesize = page_cache_size(mapping);
 
 	/*
 	 * make sure the data in this buffer is uptodate
@@ -565,11 +568,11 @@ static int pipe_to_file(struct pipe_inod
 	if (unlikely(ret))
 		return ret;
 
-	offset = sd->pos & ~PAGE_CACHE_MASK;
+	offset = page_cache_offset(mapping, sd->pos);
 
 	this_len = sd->len;
-	if (this_len + offset > PAGE_CACHE_SIZE)
-		this_len = PAGE_CACHE_SIZE - offset;
+	if (this_len + offset > pagesize)
+		this_len = pagesize - offset;
 
 	ret = pagecache_write_begin(file, mapping, sd->pos, sd->len,
 				AOP_FLAG_UNINTERRUPTIBLE, &page, &fsdata);

-- 
