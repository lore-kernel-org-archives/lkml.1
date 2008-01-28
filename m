Return-Path: <linux-kernel-owner+w=401wt.eu-S1752038AbYA1UbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038AbYA1UbP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 15:31:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752500AbYA1U3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 15:29:31 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:48431 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757583AbYA1U30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 15:29:26 -0500
Message-Id: <20080128202924.095881796@sgi.com>
References: <20080128202840.974253868@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 28 Jan 2008 12:28:43 -0800
From: Christoph Lameter <clameter@sgi.com>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>
Cc: Nick Piggin <npiggin@suse.de>, kvm-devel@lists.sourceforge.net
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: daniel.blueman@quadrics.com, Hugh Dickins <hugh@veritas.com>
Subject: [patch 3/6] mmu_notifier: invalidate_page callbacks for subsystems with rmap
Content-Disposition: inline; filename=mmu_invalidate_page_rmap_callbacks
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Callbacks to remove individual pages if the subsystem has an
rmap capability. The pagelock is held but no spinlocks are held.
The refcount of the page is elevated so that dropping the refcount
in the subsystem will not directly free the page.

The callbacks occur after the Linux rmaps have been walked.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/rmap.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux-2.6/mm/rmap.c
===================================================================
--- linux-2.6.orig/mm/rmap.c	2008-01-25 14:24:19.000000000 -0800
+++ linux-2.6/mm/rmap.c	2008-01-25 14:24:38.000000000 -0800
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
