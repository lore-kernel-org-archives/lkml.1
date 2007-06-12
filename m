Return-Path: <linux-kernel-owner+w=401wt.eu-S1754451AbXFLDJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451AbXFLDJT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 23:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbXFLDJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 23:09:09 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:41365 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751015AbXFLDJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 23:09:08 -0400
Message-ID: <381617742.09898@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070612030905.812075843@mail.ustc.edu.cn>
References: <20070612030450.590659600@mail.ustc.edu.cn>
User-Agent: quilt/0.45-1
Date: Tue, 12 Jun 2007 11:00:34 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] readahead: pass real splice size
Content-Disposition: inline; filename=readahead-fix-splice-size.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pass real splice size to page_cache_readahead_ondemand().

The splice code works in chunks of 16 pages internally.
The readahead code should be told of the overall splice size, instead of
the internal chunk size. Otherwize bad things may happen. Imagine some
17-page random splice reads. The code before this patch will result in
two readahead calls: readahead(16); readahead(1); That leads to one
16-page I/O and one 32-page I/O: one extra I/O and 31 readahead miss pages.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 fs/splice.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- linux-2.6.22-rc3-mm1.orig/fs/splice.c
+++ linux-2.6.22-rc3-mm1/fs/splice.c
@@ -267,7 +267,7 @@ __generic_file_splice_read(struct file *
 			   unsigned int flags)
 {
 	struct address_space *mapping = in->f_mapping;
-	unsigned int loff, nr_pages;
+	unsigned int loff, nr_pages, req_pages;
 	struct page *pages[PIPE_BUFFERS];
 	struct partial_page partial[PIPE_BUFFERS];
 	struct page *page;
@@ -284,10 +284,8 @@ __generic_file_splice_read(struct file *
 
 	index = *ppos >> PAGE_CACHE_SHIFT;
 	loff = *ppos & ~PAGE_CACHE_MASK;
-	nr_pages = (len + loff + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
-
-	if (nr_pages > PIPE_BUFFERS)
-		nr_pages = PIPE_BUFFERS;
+	req_pages = (len + loff + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
+	nr_pages = min(req_pages, (unsigned)PIPE_BUFFERS);
 
 	/*
 	 * Now fill in the holes:
@@ -307,7 +305,7 @@ __generic_file_splice_read(struct file *
 	 */
 	if (spd.nr_pages < nr_pages)
 		page_cache_readahead_ondemand(mapping, &in->f_ra, in,
-				NULL, index, nr_pages - spd.nr_pages);
+				NULL, index, req_pages - spd.nr_pages);
 
 	while (spd.nr_pages < nr_pages) {
 		/*
@@ -363,7 +361,7 @@ __generic_file_splice_read(struct file *
 
 		if (PageReadahead(page))
 			page_cache_readahead_ondemand(mapping, &in->f_ra, in,
-					page, index, nr_pages - page_nr);
+					page, index, req_pages - page_nr);
 
 		/*
 		 * If the page isn't uptodate, we may need to start io on it

--
