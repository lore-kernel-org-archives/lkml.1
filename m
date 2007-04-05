Return-Path: <linux-kernel-owner+w=401wt.eu-S1767167AbXDERpB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767167AbXDERpB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 13:45:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767166AbXDERpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 13:45:00 -0400
Received: from amsfep17-int.chello.nl ([213.46.243.15]:24113 "EHLO
	amsfep13-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1767161AbXDERog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 13:44:36 -0400
Message-Id: <20070405174318.465278173@programming.kicks-ass.net>
References: <20070405174209.498059336@programming.kicks-ass.net>
User-Agent: quilt/0.45-1
Date: Thu, 05 Apr 2007 19:42:13 +0200
From: root@programming.kicks-ass.net
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, a.p.zijlstra@chello.nl,
       nikita@clusterfs.com
Subject: [PATCH 04/12] mm: count writeback pages per BDI
Content-Disposition: inline; filename=bdi_stat_writeback.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Count per BDI writeback pages.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/backing-dev.h |    1 +
 mm/page-writeback.c         |    8 ++++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

Index: linux-2.6/mm/page-writeback.c
===================================================================
--- linux-2.6.orig/mm/page-writeback.c
+++ linux-2.6/mm/page-writeback.c
@@ -981,10 +981,12 @@ int test_clear_page_writeback(struct pag
 
 		write_lock_irqsave(&mapping->tree_lock, flags);
 		ret = TestClearPageWriteback(page);
-		if (ret)
+		if (ret) {
 			radix_tree_tag_clear(&mapping->page_tree,
 						page_index(page),
 						PAGECACHE_TAG_WRITEBACK);
+			__dec_bdi_stat(mapping->backing_dev_info, BDI_WRITEBACK);
+		}
 		write_unlock_irqrestore(&mapping->tree_lock, flags);
 	} else {
 		ret = TestClearPageWriteback(page);
@@ -1004,10 +1006,12 @@ int test_set_page_writeback(struct page 
 
 		write_lock_irqsave(&mapping->tree_lock, flags);
 		ret = TestSetPageWriteback(page);
-		if (!ret)
+		if (!ret) {
 			radix_tree_tag_set(&mapping->page_tree,
 						page_index(page),
 						PAGECACHE_TAG_WRITEBACK);
+			__inc_bdi_stat(mapping->backing_dev_info, BDI_WRITEBACK);
+		}
 		if (!PageDirty(page))
 			radix_tree_tag_clear(&mapping->page_tree,
 						page_index(page),
Index: linux-2.6/include/linux/backing-dev.h
===================================================================
--- linux-2.6.orig/include/linux/backing-dev.h
+++ linux-2.6/include/linux/backing-dev.h
@@ -25,6 +25,7 @@ enum bdi_state {
 
 enum bdi_stat_item {
 	BDI_DIRTY,
+	BDI_WRITEBACK,
 	NR_BDI_STAT_ITEMS
 };
 

--

