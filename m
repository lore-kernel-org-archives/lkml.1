Return-Path: <linux-kernel-owner+w=401wt.eu-S1762044AbXH1TOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762044AbXH1TOU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 15:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761253AbXH1TIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 15:08:11 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58792 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756674AbXH1THh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 15:07:37 -0400
Message-Id: <20070828190730.925053748@sgi.com>
References: <20070828190551.415127746@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 28 Aug 2007 12:06:05 -0700
From: clameter@sgi.com
To: torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Badari Pulavarty <pbadari@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>
Cc: swin wang <wangswin@gmail.com>, totty.lu@gmail.com,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: joern@lazybastard.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [14/36] Use page_cache_xxx in fs/splice.c
Content-Disposition: inline; filename=0014-Use-page_cache_xxx-in-fs-splice.c.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use page_cache_xxx in fs/splice.c

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 fs/splice.c |   27 ++++++++++++++-------------
 1 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index c010a72..7910f32 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -279,9 +279,9 @@ __generic_file_splice_read(struct file *in, loff_t *ppos,
 		.ops = &page_cache_pipe_buf_ops,
 	};
 
-	index = *ppos >> PAGE_CACHE_SHIFT;
-	loff = *ppos & ~PAGE_CACHE_MASK;
-	req_pages = (len + loff + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
+	index = page_cache_index(mapping, *ppos);
+	loff = page_cache_offset(mapping, *ppos);
+	req_pages = page_cache_next(mapping, len + loff);
 	nr_pages = min(req_pages, (unsigned)PIPE_BUFFERS);
 
 	/*
@@ -336,7 +336,7 @@ __generic_file_splice_read(struct file *in, loff_t *ppos,
 	 * Now loop over the map and see if we need to start IO on any
 	 * pages, fill in the partial map, etc.
 	 */
-	index = *ppos >> PAGE_CACHE_SHIFT;
+	index = page_cache_index(mapping, *ppos);
 	nr_pages = spd.nr_pages;
 	spd.nr_pages = 0;
 	for (page_nr = 0; page_nr < nr_pages; page_nr++) {
@@ -348,7 +348,8 @@ __generic_file_splice_read(struct file *in, loff_t *ppos,
 		/*
 		 * this_len is the max we'll use from this page
 		 */
-		this_len = min_t(unsigned long, len, PAGE_CACHE_SIZE - loff);
+		this_len = min_t(unsigned long, len,
+					page_cache_size(mapping) - loff);
 		page = pages[page_nr];
 
 		if (PageReadahead(page))
@@ -408,7 +409,7 @@ fill_it:
 		 * i_size must be checked after PageUptodate.
 		 */
 		isize = i_size_read(mapping->host);
-		end_index = (isize - 1) >> PAGE_CACHE_SHIFT;
+		end_index = page_cache_index(mapping, isize - 1);
 		if (unlikely(!isize || index > end_index))
 			break;
 
@@ -422,7 +423,7 @@ fill_it:
 			/*
 			 * max good bytes in this page
 			 */
-			plen = ((isize - 1) & ~PAGE_CACHE_MASK) + 1;
+			plen = page_cache_offset(mapping, isize - 1) + 1;
 			if (plen <= loff)
 				break;
 
@@ -573,12 +574,12 @@ static int pipe_to_file(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
 	if (unlikely(ret))
 		return ret;
 
-	index = sd->pos >> PAGE_CACHE_SHIFT;
-	offset = sd->pos & ~PAGE_CACHE_MASK;
+	index = page_cache_index(mapping, sd->pos);
+	offset = page_cache_offset(mapping, sd->pos);
 
 	this_len = sd->len;
-	if (this_len + offset > PAGE_CACHE_SIZE)
-		this_len = PAGE_CACHE_SIZE - offset;
+	if (this_len + offset > page_cache_size(mapping))
+		this_len = page_cache_size(mapping) - offset;
 
 find_page:
 	page = find_lock_page(mapping, index);
@@ -839,7 +840,7 @@ generic_file_splice_write_nolock(struct pipe_inode_info *pipe, struct file *out,
 		unsigned long nr_pages;
 
 		*ppos += ret;
-		nr_pages = (ret + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
+		nr_pages = page_cache_next(mapping, ret);
 
 		/*
 		 * If file or inode is SYNC and we actually wrote some data,
@@ -896,7 +897,7 @@ generic_file_splice_write(struct pipe_inode_info *pipe, struct file *out,
 		unsigned long nr_pages;
 
 		*ppos += ret;
-		nr_pages = (ret + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
+		nr_pages = page_cache_next(mapping, ret);
 
 		/*
 		 * If file or inode is SYNC and we actually wrote some data,
-- 
1.5.2.4

-- 
