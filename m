Return-Path: <linux-kernel-owner+w=401wt.eu-S1753529AbXFLDJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529AbXFLDJd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 23:09:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753330AbXFLDJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 23:09:14 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:41364 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751724AbXFLDJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 23:09:10 -0400
Message-ID: <381617742.09696@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070612030905.685830707@mail.ustc.edu.cn>
References: <20070612030450.590659600@mail.ustc.edu.cn>
User-Agent: quilt/0.45-1
Date: Tue, 12 Jun 2007 11:00:33 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] readahead: move synchronous readahead call out of splice loop
Content-Disposition: inline; filename=readahead-splice-move-out-of-loop.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Move synchronous page_cache_readahead_ondemand() call out of splice loop.

This avoids one pointless page allocation/insertion in case of non-zero
ra_pages, or many pointless readahead calls in case of zero ra_pages.

Note that if a user sets ra_pages to less than PIPE_BUFFERS=16 pages, he will
not get expected readahead behavior anyway.  The splice code works in batches
of 16 pages, which can be taken as another form of synchronous readahead.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 fs/splice.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- linux-2.6.22-rc3-mm1.orig/fs/splice.c
+++ linux-2.6.22-rc3-mm1/fs/splice.c
@@ -299,12 +299,16 @@ __generic_file_splice_read(struct file *
 	 * Lookup the (hopefully) full range of pages we need.
 	 */
 	spd.nr_pages = find_get_pages_contig(mapping, index, nr_pages, pages);
+	index += spd.nr_pages;
 
 	/*
 	 * If find_get_pages_contig() returned fewer pages than we needed,
-	 * allocate the rest.
+	 * readahead/allocate the rest.
 	 */
-	index += spd.nr_pages;
+	if (spd.nr_pages < nr_pages)
+		page_cache_readahead_ondemand(mapping, &in->f_ra, in,
+				NULL, index, nr_pages - spd.nr_pages);
+
 	while (spd.nr_pages < nr_pages) {
 		/*
 		 * Page could be there, find_get_pages_contig() breaks on
@@ -312,9 +316,6 @@ __generic_file_splice_read(struct file *
 		 */
 		page = find_get_page(mapping, index);
 		if (!page) {
-			page_cache_readahead_ondemand(mapping, &in->f_ra, in,
-					NULL, index, nr_pages - spd.nr_pages);
-
 			/*
 			 * page didn't exist, allocate one.
 			 */

--
