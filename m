Return-Path: <linux-kernel-owner+w=401wt.eu-S1030412AbXCSRwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030412AbXCSRwt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 13:52:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030410AbXCSRwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 13:52:49 -0400
Received: from amsfep17-int.chello.nl ([213.46.243.15]:12542 "EHLO
	amsfep14-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030417AbXCSRws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 13:52:48 -0400
Message-Id: <20070319164320.127815453@programming.kicks-ass.net>
References: <20070319155737.653325176@programming.kicks-ass.net>
User-Agent: quilt/0.45-1
Date: Mon, 19 Mar 2007 16:57:40 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, a.p.zijlstra@chello.nl
Subject: [RFC][PATCH 3/6] mm: count writeback pages per BDI
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
@@ -912,10 +912,12 @@ int test_clear_page_writeback(struct pag
 
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
@@ -933,10 +935,12 @@ int test_set_page_writeback(struct page 
 
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
@@ -24,6 +24,7 @@ enum bdi_state {
 
 enum bdi_stat_item {
 	BDI_DIRTY,
+	BDI_WRITEBACK,
 	NR_BDI_STAT_ITEMS
 };
 

--

