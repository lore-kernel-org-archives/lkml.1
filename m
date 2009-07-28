Return-Path: <linux-kernel-owner+w=401wt.eu-S1753887AbZG1MT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbZG1MT6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 08:19:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbZG1MT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 08:19:58 -0400
Received: from mail.valinux.co.jp ([210.128.90.3]:47842 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237AbZG1MT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 08:19:57 -0400
Date: Tue, 28 Jul 2009 21:19:56 +0900 (JST)
Message-Id: <20090728.211956.112608332.ryov@valinux.co.jp>
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com
Subject: [PATCH 6/7] blkio-cgroup-v10: Page tracking hooks
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <20090728.211922.189712796.ryov@valinux.co.jp>
References: <20090728.211820.71102079.ryov@valinux.co.jp>
	<20090728.211850.104046372.ryov@valinux.co.jp>
	<20090728.211922.189712796.ryov@valinux.co.jp>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains several hooks that let the blkio-cgroup framework to know
which blkio-cgroup is the owner of a page before starting I/O against the page.

Signed-off-by: Hirokazu Takahashi <taka@valinux.co.jp>
Signed-off-by: Ryo Tsuruta <ryov@valinux.co.jp>

---
 fs/buffer.c         |    2 ++
 fs/direct-io.c      |    2 ++
 mm/bounce.c         |    2 ++
 mm/filemap.c        |    2 ++
 mm/memory.c         |    5 +++++
 mm/page-writeback.c |    2 ++
 mm/swap_state.c     |    2 ++
 7 files changed, 17 insertions(+)

Index: linux-2.6.31-rc3-mm1/fs/buffer.c
===================================================================
--- linux-2.6.31-rc3-mm1.orig/fs/buffer.c
+++ linux-2.6.31-rc3-mm1/fs/buffer.c
@@ -36,6 +36,7 @@
 #include <linux/buffer_head.h>
 #include <linux/task_io_accounting_ops.h>
 #include <linux/bio.h>
+#include <linux/biotrack.h>
 #include <linux/notifier.h>
 #include <linux/cpu.h>
 #include <linux/bitops.h>
@@ -676,6 +677,7 @@ static void __set_page_dirty(struct page
 	if (page->mapping) {	/* Race with truncate? */
 		WARN_ON_ONCE(warn && !PageUptodate(page));
 		account_page_dirtied(page, mapping);
+		blkio_cgroup_reset_owner_pagedirty(page, current->mm);
 		radix_tree_tag_set(&mapping->page_tree,
 				page_index(page), PAGECACHE_TAG_DIRTY);
 	}
Index: linux-2.6.31-rc3-mm1/fs/direct-io.c
===================================================================
--- linux-2.6.31-rc3-mm1.orig/fs/direct-io.c
+++ linux-2.6.31-rc3-mm1/fs/direct-io.c
@@ -33,6 +33,7 @@
 #include <linux/err.h>
 #include <linux/blkdev.h>
 #include <linux/buffer_head.h>
+#include <linux/biotrack.h>
 #include <linux/rwsem.h>
 #include <linux/uio.h>
 #include <asm/atomic.h>
@@ -797,6 +798,7 @@ static int do_direct_IO(struct dio *dio)
 			ret = PTR_ERR(page);
 			goto out;
 		}
+		blkio_cgroup_reset_owner(page, current->mm);
 
 		while (block_in_page < blocks_per_page) {
 			unsigned offset_in_page = block_in_page << blkbits;
Index: linux-2.6.31-rc3-mm1/mm/bounce.c
===================================================================
--- linux-2.6.31-rc3-mm1.orig/mm/bounce.c
+++ linux-2.6.31-rc3-mm1/mm/bounce.c
@@ -13,6 +13,7 @@
 #include <linux/init.h>
 #include <linux/hash.h>
 #include <linux/highmem.h>
+#include <linux/biotrack.h>
 #include <asm/tlbflush.h>
 
 #include <trace/events/block.h>
@@ -210,6 +211,7 @@ static void __blk_queue_bounce(struct re
 		to->bv_len = from->bv_len;
 		to->bv_offset = from->bv_offset;
 		inc_zone_page_state(to->bv_page, NR_BOUNCE);
+		blkio_cgroup_copy_owner(to->bv_page, page);
 
 		if (rw == WRITE) {
 			char *vto, *vfrom;
Index: linux-2.6.31-rc3-mm1/mm/filemap.c
===================================================================
--- linux-2.6.31-rc3-mm1.orig/mm/filemap.c
+++ linux-2.6.31-rc3-mm1/mm/filemap.c
@@ -33,6 +33,7 @@
 #include <linux/cpuset.h>
 #include <linux/hardirq.h> /* for BUG_ON(!in_atomic()) only */
 #include <linux/memcontrol.h>
+#include <linux/biotrack.h>
 #include <linux/mm_inline.h> /* for page_is_file_cache() */
 #include "internal.h"
 
@@ -466,6 +467,7 @@ int add_to_page_cache_locked(struct page
 					gfp_mask & GFP_RECLAIM_MASK);
 	if (error)
 		goto out;
+	blkio_cgroup_set_owner(page, current->mm);
 
 	error = radix_tree_preload(gfp_mask & ~__GFP_HIGHMEM);
 	if (error == 0) {
Index: linux-2.6.31-rc3-mm1/mm/memory.c
===================================================================
--- linux-2.6.31-rc3-mm1.orig/mm/memory.c
+++ linux-2.6.31-rc3-mm1/mm/memory.c
@@ -51,6 +51,7 @@
 #include <linux/init.h>
 #include <linux/writeback.h>
 #include <linux/memcontrol.h>
+#include <linux/biotrack.h>
 #include <linux/mmu_notifier.h>
 #include <linux/kallsyms.h>
 #include <linux/swapops.h>
@@ -2115,6 +2116,7 @@ gotten:
 		 */
 		ptep_clear_flush_notify(vma, address, page_table);
 		page_add_new_anon_rmap(new_page, vma, address);
+		blkio_cgroup_set_owner(new_page, mm);
 		set_pte_at(mm, address, page_table, entry);
 		update_mmu_cache(vma, address, entry);
 		if (old_page) {
@@ -2580,6 +2582,7 @@ static int do_swap_page(struct mm_struct
 	flush_icache_page(vma, page);
 	set_pte_at(mm, address, page_table, pte);
 	page_add_anon_rmap(page, vma, address);
+	blkio_cgroup_reset_owner(page, mm);
 	/* It's better to call commit-charge after rmap is established */
 	mem_cgroup_commit_charge_swapin(page, ptr);
 
@@ -2644,6 +2647,7 @@ static int do_anonymous_page(struct mm_s
 		goto release;
 	inc_mm_counter(mm, anon_rss);
 	page_add_new_anon_rmap(page, vma, address);
+	blkio_cgroup_set_owner(page, mm);
 	set_pte_at(mm, address, page_table, entry);
 
 	/* No need to invalidate - it was non-present before */
@@ -2791,6 +2795,7 @@ static int __do_fault(struct mm_struct *
 		if (anon) {
 			inc_mm_counter(mm, anon_rss);
 			page_add_new_anon_rmap(page, vma, address);
+			blkio_cgroup_set_owner(page, mm);
 		} else {
 			inc_mm_counter(mm, file_rss);
 			page_add_file_rmap(page);
Index: linux-2.6.31-rc3-mm1/mm/page-writeback.c
===================================================================
--- linux-2.6.31-rc3-mm1.orig/mm/page-writeback.c
+++ linux-2.6.31-rc3-mm1/mm/page-writeback.c
@@ -23,6 +23,7 @@
 #include <linux/init.h>
 #include <linux/backing-dev.h>
 #include <linux/task_io_accounting_ops.h>
+#include <linux/biotrack.h>
 #include <linux/blkdev.h>
 #include <linux/mpage.h>
 #include <linux/rmap.h>
@@ -1130,6 +1131,7 @@ int __set_page_dirty_nobuffers(struct pa
 			BUG_ON(mapping2 != mapping);
 			WARN_ON_ONCE(!PagePrivate(page) && !PageUptodate(page));
 			account_page_dirtied(page, mapping);
+			blkio_cgroup_reset_owner_pagedirty(page, current->mm);
 			radix_tree_tag_set(&mapping->page_tree,
 				page_index(page), PAGECACHE_TAG_DIRTY);
 		}
Index: linux-2.6.31-rc3-mm1/mm/swap_state.c
===================================================================
--- linux-2.6.31-rc3-mm1.orig/mm/swap_state.c
+++ linux-2.6.31-rc3-mm1/mm/swap_state.c
@@ -18,6 +18,7 @@
 #include <linux/pagevec.h>
 #include <linux/migrate.h>
 #include <linux/page_cgroup.h>
+#include <linux/biotrack.h>
 
 #include <asm/pgtable.h>
 
@@ -308,6 +309,7 @@ struct page *read_swap_cache_async(swp_e
 		 */
 		__set_page_locked(new_page);
 		SetPageSwapBacked(new_page);
+		blkio_cgroup_set_owner(new_page, current->mm);
 		err = add_to_swap_cache(new_page, entry, gfp_mask & GFP_KERNEL);
 		if (likely(!err)) {
 			/*
