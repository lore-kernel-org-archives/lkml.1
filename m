Return-Path: <linux-kernel-owner+w=401wt.eu-S1762662AbXEPWuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762662AbXEPWuu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 18:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759906AbXEPWsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 18:48:39 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:50151 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1758506AbXEPWsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 18:48:33 -0400
Message-ID: <379355696.93198@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070516224819.131727893@mail.ustc.edu.cn>
References: <20070516224752.500812933@mail.ustc.edu.cn>
User-Agent: quilt/0.45-1
Date: Thu, 17 May 2007 06:47:59 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Steven Pratt <slpratt@austin.ibm.com>
Cc: Ram Pai <linuxram@us.ibm.com>
Subject: [PATCH 7/9] readahead: convert splice invocations
Content-Disposition: inline; filename=readahead-invocations-splice.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Convert splice reads to use on-demand readahead.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 fs/splice.c |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

--- linux-2.6.22-rc1-mm1.orig/fs/splice.c
+++ linux-2.6.22-rc1-mm1/fs/splice.c
@@ -289,12 +289,6 @@ __generic_file_splice_read(struct file *
 		nr_pages = PIPE_BUFFERS;
 
 	/*
-	 * Don't try to 2nd guess the read-ahead logic, call into
-	 * page_cache_readahead() like the page cache reads would do.
-	 */
-	page_cache_readahead(mapping, &in->f_ra, in, index, nr_pages);
-
-	/*
 	 * Now fill in the holes:
 	 */
 	error = 0;
@@ -317,11 +311,8 @@ __generic_file_splice_read(struct file *
 		 */
 		page = find_get_page(mapping, index);
 		if (!page) {
-			/*
-			 * Make sure the read-ahead engine is notified
-			 * about this failure.
-			 */
-			handle_ra_miss(mapping, &in->f_ra, index);
+			page_cache_readahead_ondemand(mapping, &in->f_ra, in,
+					NULL, index, nr_pages - spd.nr_pages);
 
 			/*
 			 * page didn't exist, allocate one.
@@ -368,6 +359,10 @@ __generic_file_splice_read(struct file *
 		this_len = min_t(unsigned long, len, PAGE_CACHE_SIZE - loff);
 		page = pages[page_nr];
 
+		if (PageReadahead(page))
+			page_cache_readahead_ondemand(mapping, &in->f_ra, in,
+					page, index, nr_pages - page_nr);
+
 		/*
 		 * If the page isn't uptodate, we may need to start io on it
 		 */
@@ -456,6 +451,7 @@ fill_it:
 	 */
 	while (page_nr < nr_pages)
 		page_cache_release(pages[page_nr++]);
+	in->f_ra.prev_index = index;
 
 	if (spd.nr_pages)
 		return splice_to_pipe(pipe, &spd);

--
