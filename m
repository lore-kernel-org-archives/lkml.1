Return-Path: <linux-kernel-owner+w=401wt.eu-S1767169AbXDERpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767169AbXDERpw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 13:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767174AbXDERpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 13:45:52 -0400
Received: from amsfep17-int.chello.nl ([213.46.243.15]:9888 "EHLO
	amsfep18-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1767163AbXDERpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 13:45:45 -0400
Message-Id: <20070405174318.167178980@programming.kicks-ass.net>
References: <20070405174209.498059336@programming.kicks-ass.net>
User-Agent: quilt/0.45-1
Date: Thu, 05 Apr 2007 19:42:12 +0200
From: root@programming.kicks-ass.net
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, a.p.zijlstra@chello.nl,
       nikita@clusterfs.com
Subject: [PATCH 03/12] mm: count dirty pages per BDI
Content-Disposition: inline; filename=bdi_stat_dirty.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Count per BDI dirty pages.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 fs/buffer.c                 |    1 +
 include/linux/backing-dev.h |    1 +
 mm/page-writeback.c         |    2 ++
 mm/truncate.c               |    1 +
 4 files changed, 5 insertions(+)

Index: linux-2.6/fs/buffer.c
===================================================================
--- linux-2.6.orig/fs/buffer.c
+++ linux-2.6/fs/buffer.c
@@ -740,6 +740,7 @@ int __set_page_dirty_buffers(struct page
 	if (page->mapping) {	/* Race with truncate? */
 		if (mapping_cap_account_dirty(mapping)) {
 			__inc_zone_page_state(page, NR_FILE_DIRTY);
+			__inc_bdi_stat(mapping->backing_dev_info, BDI_DIRTY);
 			task_io_account_write(PAGE_CACHE_SIZE);
 		}
 		radix_tree_tag_set(&mapping->page_tree,
Index: linux-2.6/mm/page-writeback.c
===================================================================
--- linux-2.6.orig/mm/page-writeback.c
+++ linux-2.6/mm/page-writeback.c
@@ -828,6 +828,7 @@ int __set_page_dirty_nobuffers(struct pa
 			BUG_ON(mapping2 != mapping);
 			if (mapping_cap_account_dirty(mapping)) {
 				__inc_zone_page_state(page, NR_FILE_DIRTY);
+				__inc_bdi_stat(mapping->backing_dev_info, BDI_DIRTY);
 				task_io_account_write(PAGE_CACHE_SIZE);
 			}
 			radix_tree_tag_set(&mapping->page_tree,
@@ -961,6 +962,7 @@ int clear_page_dirty_for_io(struct page 
 		 */
 		if (TestClearPageDirty(page)) {
 			dec_zone_page_state(page, NR_FILE_DIRTY);
+			dec_bdi_stat(mapping->backing_dev_info, BDI_DIRTY);
 			return 1;
 		}
 		return 0;
Index: linux-2.6/mm/truncate.c
===================================================================
--- linux-2.6.orig/mm/truncate.c
+++ linux-2.6/mm/truncate.c
@@ -71,6 +71,7 @@ void cancel_dirty_page(struct page *page
 		struct address_space *mapping = page->mapping;
 		if (mapping && mapping_cap_account_dirty(mapping)) {
 			dec_zone_page_state(page, NR_FILE_DIRTY);
+			dec_bdi_stat(mapping->backing_dev_info, BDI_DIRTY);
 			if (account_size)
 				task_io_account_cancelled_write(account_size);
 		}
Index: linux-2.6/include/linux/backing-dev.h
===================================================================
--- linux-2.6.orig/include/linux/backing-dev.h
+++ linux-2.6/include/linux/backing-dev.h
@@ -24,6 +24,7 @@ enum bdi_state {
 };
 
 enum bdi_stat_item {
+	BDI_DIRTY,
 	NR_BDI_STAT_ITEMS
 };
 

--

