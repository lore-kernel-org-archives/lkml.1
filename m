Return-Path: <linux-kernel-owner+w=401wt.eu-S1752140AbXDQHXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140AbXDQHXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 03:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752072AbXDQHXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 03:23:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44707 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022AbXDQHW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 03:22:58 -0400
Message-Id: <20070417071703.452105009@chello.nl>
References: <20070417071046.318415445@chello.nl>
User-Agent: quilt/0.46-1
Date: Tue, 17 Apr 2007 09:10:53 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, a.p.zijlstra@chello.nl,
       nikita@clusterfs.com, trond.myklebust@fys.uio.no,
       yingchao.zhou@gmail.com
Subject: [PATCH 07/12] mm: count dirty pages per BDI
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

Index: linux-2.6-mm/fs/buffer.c
===================================================================
--- linux-2.6-mm.orig/fs/buffer.c
+++ linux-2.6-mm/fs/buffer.c
@@ -740,6 +740,7 @@ int __set_page_dirty_buffers(struct page
 	if (page->mapping) {	/* Race with truncate? */
 		if (mapping_cap_account_dirty(mapping)) {
 			__inc_zone_page_state(page, NR_FILE_DIRTY);
+			__inc_bdi_stat(mapping->backing_dev_info, BDI_DIRTY);
 			task_io_account_write(PAGE_CACHE_SIZE);
 		}
 		radix_tree_tag_set(&mapping->page_tree,
Index: linux-2.6-mm/mm/page-writeback.c
===================================================================
--- linux-2.6-mm.orig/mm/page-writeback.c
+++ linux-2.6-mm/mm/page-writeback.c
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
Index: linux-2.6-mm/mm/truncate.c
===================================================================
--- linux-2.6-mm.orig/mm/truncate.c
+++ linux-2.6-mm/mm/truncate.c
@@ -71,6 +71,7 @@ void cancel_dirty_page(struct page *page
 		struct address_space *mapping = page->mapping;
 		if (mapping && mapping_cap_account_dirty(mapping)) {
 			dec_zone_page_state(page, NR_FILE_DIRTY);
+			dec_bdi_stat(mapping->backing_dev_info, BDI_DIRTY);
 			if (account_size)
 				task_io_account_cancelled_write(account_size);
 		}
Index: linux-2.6-mm/include/linux/backing-dev.h
===================================================================
--- linux-2.6-mm.orig/include/linux/backing-dev.h
+++ linux-2.6-mm/include/linux/backing-dev.h
@@ -26,6 +26,7 @@ enum bdi_state {
 typedef int (congested_fn)(void *, int);
 
 enum bdi_stat_item {
+	BDI_DIRTY,
 	NR_BDI_STAT_ITEMS
 };
 

-- 

