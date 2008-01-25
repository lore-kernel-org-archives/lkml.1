Return-Path: <linux-kernel-owner+w=401wt.eu-S1756641AbYAYF6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641AbYAYF6q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 00:58:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755712AbYAYF6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 00:58:08 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:44089 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753357AbYAYF6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 00:58:04 -0500
Message-Id: <20080125055801.674007010@sgi.com>
References: <20080125055606.102986685@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 24 Jan 2008 21:56:09 -0800
From: Christoph Lameter <clameter@sgi.com>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>
Cc: Nick Piggin <npiggin@suse.de>, kvm-devel@lists.sourceforge.net
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: daniel.blueman@quadrics.com, Hugh Dickins <hugh@veritas.com>
Subject: [patch 3/4] mmu_notifier: invalidate_page callbacks for subsystems with rmap
Content-Disposition: inline; filename=mmu_invalidate_page_rmap_callbacks
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Callbacks to remove individual pages if the subsystem has an
rmap capability. The pagelock is held but no spinlocks are held.
The refcount of the page is elevated so that dropping the refcount
in the subsystem will not directly free the page.

The callbacks occur after the Linux rmaps have been walked.

Robin: We do not hold the page lock in __xip_unmap().
I guess we do not need to increase the refcount there since the
page is static and cannot go away?

Signed-off-by: Christoph Lameter <clameter@sgi.com>

Index: linux-2.6/mm/filemap_xip.c
===================================================================
--- linux-2.6.orig/mm/filemap_xip.c	2008-01-24 19:47:28.000000000 -0800
+++ linux-2.6/mm/filemap_xip.c	2008-01-24 20:30:31.000000000 -0800
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
Index: linux-2.6/mm/rmap.c
===================================================================
--- linux-2.6.orig/mm/rmap.c	2008-01-24 19:47:28.000000000 -0800
+++ linux-2.6/mm/rmap.c	2008-01-24 20:30:31.000000000 -0800
@@ -49,6 +49,7 @@
 #include <linux/rcupdate.h>
 #include <linux/module.h>
 #include <linux/kallsyms.h>
+#include <linux/mmu_notifier.h>
 
 #include <asm/tlbflush.h>
 
@@ -473,6 +474,8 @@ int page_mkclean(struct page *page)
 		struct address_space *mapping = page_mapping(page);
 		if (mapping) {
 			ret = page_mkclean_file(mapping, page);
+			if (unlikely(PageExternalRmap(page)))
+				mmu_rmap_notifier(invalidate_page, page);
 			if (page_test_dirty(page)) {
 				page_clear_dirty(page);
 				ret = 1;
@@ -971,6 +974,9 @@ int try_to_unmap(struct page *page, int 
 	else
 		ret = try_to_unmap_file(page, migration);
 
+	if (unlikely(PageExternalRmap(page)))
+		mmu_rmap_notifier(invalidate_page, page);
+
 	if (!page_mapped(page))
 		ret = SWAP_SUCCESS;
 	return ret;

-- 
