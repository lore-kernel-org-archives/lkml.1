Return-Path: <linux-kernel-owner+w=401wt.eu-S1753425AbXCPIvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbXCPIvl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 04:51:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753433AbXCPIvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 04:51:40 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:34637 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S932518AbXCPIvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 04:51:38 -0400
Message-ID: <374035059.44530@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070316085052.388486000@mail.ustc.edu.cn>
References: <20070316084856.687942000@mail.ustc.edu.cn>
User-Agent: quilt/0.45-1
Date: Fri, 16 Mar 2007 16:49:02 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 06/14] readahead: call scheme: cleanup
Content-Disposition: inline; filename=readahead-call-scheme-cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Merge two similar page_cache_readahead_adaptive() calls into one.

No behavior change.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 mm/filemap.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

--- linux-2.6.21-rc3-mm2.orig/mm/filemap.c
+++ linux-2.6.21-rc3-mm2/mm/filemap.c
@@ -934,17 +934,13 @@ void do_generic_mapping_read(struct addr
 find_page:
 		page = find_get_page(mapping, index);
 		if (prefer_adaptive_readahead()) {
-			if (unlikely(page == NULL)) {
-				ra.prev_page = prev_index;
-				page_cache_readahead_adaptive(mapping,
-						&ra, filp, NULL,
-						index, last_index - index);
-				page = find_get_page(mapping, index);
-			} else if (PageReadahead(page)) {
+			if (!page || PageReadahead(page)) {
 				ra.prev_page = prev_index;
 				page_cache_readahead_adaptive(mapping,
 						&ra, filp, page,
 						index, last_index - index);
+				if (!page)
+					page = find_get_page(mapping, index);
 			}
 		}
 		if (unlikely(page == NULL)) {
@@ -1394,13 +1390,11 @@ struct page *filemap_fault(struct vm_are
 retry_find:
 	page = find_lock_page(mapping, fdata->pgoff);
 	if (prefer_adaptive_readahead() && VM_SequentialReadHint(vma)) {
-		if (!page) {
-			page_cache_readahead_adaptive(mapping, ra, file, NULL,
-							fdata->pgoff, 1);
-			page = find_lock_page(mapping, fdata->pgoff);
-		} else if (PageReadahead(page)) {
+		if (!page || PageReadahead(page)) {
 			page_cache_readahead_adaptive(mapping, ra, file, page,
 							fdata->pgoff, 1);
+			if (!page)
+				page = find_lock_page(mapping, fdata->pgoff);
 		}
 	}
 	if (!page) {

--
