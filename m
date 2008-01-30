Return-Path: <linux-kernel-owner+w=401wt.eu-S1755568AbYA3C35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbYA3C35 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 21:29:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753408AbYA3C3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 21:29:47 -0500
Received: from relay2.sgi.com ([192.48.171.30]:40837 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753327AbYA3C3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 21:29:46 -0500
Message-Id: <20080130022945.163230715@sgi.com>
References: <20080130022909.677301714@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 29 Jan 2008 18:29:14 -0800
From: Christoph Lameter <clameter@sgi.com>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>
Cc: Nick Piggin <npiggin@suse.de>, kvm-devel@lists.sourceforge.net
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: daniel.blueman@quadrics.com, Hugh Dickins <hugh@veritas.com>
Subject: [patch 5/6] mmu_notifier: Callbacks for xip_filemap.c
Content-Disposition: inline; filename=mmu_xip
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Problem for external rmaps: There is no pagelock held on the page.

Signed-off-by: Robin Holt <holt@sgi.com>

---
 mm/filemap_xip.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-2.6/mm/filemap_xip.c
===================================================================
--- linux-2.6.orig/mm/filemap_xip.c	2008-01-25 19:39:04.000000000 -0800
+++ linux-2.6/mm/filemap_xip.c	2008-01-25 19:39:06.000000000 -0800
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/uio.h>
 #include <linux/rmap.h>
+#include <linux/mmu_notifier.h>
 #include <linux/sched.h>
 #include <asm/tlbflush.h>
 
@@ -183,6 +184,9 @@ __xip_unmap (struct address_space * mapp
 	if (!page)
 		return;
 
+	if (PageExternalRmap(page))
+		mmu_rmap_notifier(invalidate_page, page);
+
 	spin_lock(&mapping->i_mmap_lock);
 	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, pgoff, pgoff) {
 		mm = vma->vm_mm;
@@ -194,6 +198,7 @@ __xip_unmap (struct address_space * mapp
 			/* Nuke the page table entry. */
 			flush_cache_page(vma, address, pte_pfn(*pte));
 			pteval = ptep_clear_flush(vma, address, pte);
+			mmu_notifier(invalidate_page, mm, address);
 			page_remove_rmap(page, vma);
 			dec_mm_counter(mm, file_rss);
 			BUG_ON(pte_dirty(pteval));

-- 
