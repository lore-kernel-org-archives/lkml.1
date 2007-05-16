Return-Path: <linux-kernel-owner+w=401wt.eu-S1761680AbXEPWso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761680AbXEPWso (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 18:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758708AbXEPWse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 18:48:34 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:50150 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1758281AbXEPWsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 18:48:33 -0400
Message-ID: <379355696.29993@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070516224818.963553696@mail.ustc.edu.cn>
References: <20070516224752.500812933@mail.ustc.edu.cn>
User-Agent: quilt/0.45-1
Date: Thu, 17 May 2007 06:47:58 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Steven Pratt <slpratt@austin.ibm.com>
Cc: Ram Pai <linuxram@us.ibm.com>
Subject: [PATCH 6/9] readahead: convert filemap invocations
Content-Disposition: inline; filename=readahead-invocations-filemap.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Convert filemap reads to use on-demand readahead.

The new call scheme is to
- call readahead on non-cached page
- call readahead on look-ahead page
- update prev_index when finished with the read request

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 mm/filemap.c |   51 +++++++++++++++++++++++++++++--------------------
 1 file changed, 31 insertions(+), 20 deletions(-)

--- linux-2.6.22-rc1-mm1.orig/mm/filemap.c
+++ linux-2.6.22-rc1-mm1/mm/filemap.c
@@ -916,15 +916,20 @@ void do_generic_mapping_read(struct addr
 		nr = nr - offset;
 
 		cond_resched();
-		if (index == next_index)
-			next_index = page_cache_readahead(mapping, &ra, filp,
-					index, last_index - index);
-
 find_page:
 		page = find_get_page(mapping, index);
-		if (unlikely(page == NULL)) {
-			handle_ra_miss(mapping, &ra, index);
-			goto no_cached_page;
+		if (!page) {
+			page_cache_readahead_ondemand(mapping,
+					&ra, filp, page,
+					index, last_index - index);
+			page = find_get_page(mapping, index);
+			if (unlikely(page == NULL))
+				goto no_cached_page;
+		}
+		if (PageReadahead(page)) {
+			page_cache_readahead_ondemand(mapping,
+					&ra, filp, page,
+					index, last_index - index);
 		}
 		if (!PageUptodate(page))
 			goto page_not_up_to_date;
@@ -1075,6 +1080,7 @@ no_cached_page:
 
 out:
 	*_ra = ra;
+	_ra->prev_index = prev_index;
 
 	*ppos = ((loff_t) index << PAGE_CACHE_SHIFT) + offset;
 	if (cached_page)
@@ -1378,26 +1384,30 @@ struct page *filemap_fault(struct vm_are
 		goto no_cached_page;
 
 	/*
-	 * The readahead code wants to be told about each and every page
-	 * so it can build and shrink its windows appropriately
-	 *
-	 * For sequential accesses, we use the generic readahead logic.
-	 */
-	if (VM_SequentialReadHint(vma))
-		page_cache_readahead(mapping, ra, file, fdata->pgoff, 1);
-
-	/*
 	 * Do we have something in the page cache already?
 	 */
 retry_find:
 	page = find_lock_page(mapping, fdata->pgoff);
+	/*
+	 * For sequential accesses, we use the generic readahead logic.
+	 */
+	if (VM_SequentialReadHint(vma)) {
+		if (!page) {
+			page_cache_readahead_ondemand(mapping, ra, file, page,
+							   fdata->pgoff, 1);
+			page = find_lock_page(mapping, fdata->pgoff);
+			if (!page)
+				goto no_cached_page;
+		}
+		if (PageReadahead(page)) {
+			page_cache_readahead_ondemand(mapping, ra, file, page,
+							   fdata->pgoff, 1);
+		}
+	}
+
 	if (!page) {
 		unsigned long ra_pages;
 
-		if (VM_SequentialReadHint(vma)) {
-			handle_ra_miss(mapping, ra, fdata->pgoff);
-			goto no_cached_page;
-		}
 		ra->mmap_miss++;
 
 		/*
@@ -1450,6 +1460,7 @@ retry_find:
 	 * Found the page and have a reference on it.
 	 */
 	mark_page_accessed(page);
+	ra->prev_index = page->index;
 	return page;
 
 outside_data_content:

--
