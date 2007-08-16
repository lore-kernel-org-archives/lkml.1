Return-Path: <linux-kernel-owner+w=401wt.eu-S1763557AbXHPI2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763557AbXHPI2g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 04:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756066AbXHPI2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 04:28:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60079 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755777AbXHPI2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 04:28:14 -0400
Message-Id: <20070816074629.019919000@chello.nl>
References: <20070816074525.065850000@chello.nl>
User-Agent: quilt/0.45-1
Date: Thu, 16 Aug 2007 09:45:43 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, a.p.zijlstra@chello.nl,
       nikita@clusterfs.com, trond.myklebust@fys.uio.no,
       yingchao.zhou@gmail.com, richard@rsk.demon.co.uk,
       torvalds@linux-foundation.org
Subject: [PATCH 18/23] mm: count writeback pages per BDI
Content-Disposition: inline; filename=bdi_stat_writeback.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Count per BDI writeback pages.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/backing-dev.h |    1 +
 mm/page-writeback.c         |   12 ++++++++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

Index: linux-2.6/mm/page-writeback.c
===================================================================
--- linux-2.6.orig/mm/page-writeback.c
+++ linux-2.6/mm/page-writeback.c
@@ -981,14 +981,18 @@ int test_clear_page_writeback(struct pag
 	int ret;
 
 	if (mapping) {
+		struct backing_dev_info *bdi = mapping->backing_dev_info;
 		unsigned long flags;
 
 		write_lock_irqsave(&mapping->tree_lock, flags);
 		ret = TestClearPageWriteback(page);
-		if (ret)
+		if (ret) {
 			radix_tree_tag_clear(&mapping->page_tree,
 						page_index(page),
 						PAGECACHE_TAG_WRITEBACK);
+			if (bdi_cap_writeback_dirty(bdi))
+				__dec_bdi_stat(bdi, BDI_WRITEBACK);
+		}
 		write_unlock_irqrestore(&mapping->tree_lock, flags);
 	} else {
 		ret = TestClearPageWriteback(page);
@@ -1004,14 +1008,18 @@ int test_set_page_writeback(struct page 
 	int ret;
 
 	if (mapping) {
+		struct backing_dev_info *bdi = mapping->backing_dev_info;
 		unsigned long flags;
 
 		write_lock_irqsave(&mapping->tree_lock, flags);
 		ret = TestSetPageWriteback(page);
-		if (!ret)
+		if (!ret) {
 			radix_tree_tag_set(&mapping->page_tree,
 						page_index(page),
 						PAGECACHE_TAG_WRITEBACK);
+			if (bdi_cap_writeback_dirty(bdi))
+				__inc_bdi_stat(bdi, BDI_WRITEBACK);
+		}
 		if (!PageDirty(page))
 			radix_tree_tag_clear(&mapping->page_tree,
 						page_index(page),
Index: linux-2.6/include/linux/backing-dev.h
===================================================================
--- linux-2.6.orig/include/linux/backing-dev.h
+++ linux-2.6/include/linux/backing-dev.h
@@ -28,6 +28,7 @@ typedef int (congested_fn)(void *, int);
 
 enum bdi_stat_item {
 	BDI_RECLAIMABLE,
+	BDI_WRITEBACK,
 	NR_BDI_STAT_ITEMS
 };
 

--

