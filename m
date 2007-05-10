Return-Path: <linux-kernel-owner+w=401wt.eu-S1761336AbXEJKRK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761336AbXEJKRK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 06:17:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757397AbXEJKOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 06:14:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56113 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758451AbXEJKOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 06:14:03 -0400
Message-Id: <20070510101129.479207249@chello.nl>
References: <20070510100839.621199408@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 10 May 2007 12:08:49 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, a.p.zijlstra@chello.nl,
       nikita@clusterfs.com, trond.myklebust@fys.uio.no,
       yingchao.zhou@gmail.com
Subject: [PATCH 10/15] mm: count writeback pages per BDI
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
--- linux-2.6.orig/mm/page-writeback.c	2007-04-20 15:27:28.000000000 +0200
+++ linux-2.6/mm/page-writeback.c	2007-04-20 15:28:10.000000000 +0200
@@ -979,14 +979,18 @@ int test_clear_page_writeback(struct pag
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
@@ -1002,14 +1006,18 @@ int test_set_page_writeback(struct page 
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
--- linux-2.6.orig/include/linux/backing-dev.h	2007-04-20 15:25:47.000000000 +0200
+++ linux-2.6/include/linux/backing-dev.h	2007-04-20 15:28:17.000000000 +0200
@@ -27,6 +27,7 @@ typedef int (congested_fn)(void *, int);
 
 enum bdi_stat_item {
 	BDI_RECLAIMABLE,
+	BDI_WRITEBACK,
 	NR_BDI_STAT_ITEMS
 };
 

-- 

