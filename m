Return-Path: <linux-kernel-owner+w=401wt.eu-S933231AbXGWHBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933231AbXGWHBh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 03:01:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932081AbXGWG5U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 02:57:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:55412 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763496AbXGWG5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 02:57:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,569,1175497200"; 
   d="scan'208";a="271462957"
Subject: [RFC 8/8]KVM: cache pages
From: Shaohua Li <shaohua.li@intel.com>
To: kvm-devel <kvm-devel@lists.sourceforge.net>,
       lkml <linux-kernel@vger.kernel.org>
Cc: Avi Kivity <avi@qumranet.com>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain
Date: Mon, 23 Jul 2007 14:51:48 +0800
Message-Id: <1185173508.2645.72.camel@sli10-conroe.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

KVM use gfn_to_page very frequestly, which makes find_get_page a bottleneck,
so cache pages found to speed up.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 drivers/kvm/kvm.h      |    1 +
 drivers/kvm/kvm_main.c |    9 +++++++++
 2 files changed, 10 insertions(+)

Index: linux/drivers/kvm/kvm.h
===================================================================
--- linux.orig/drivers/kvm/kvm.h	2007-07-20 14:29:46.000000000 +0800
+++ linux/drivers/kvm/kvm.h	2007-07-20 14:50:11.000000000 +0800
@@ -431,6 +431,7 @@ struct kvm_mem_alias {
 
 struct kvm_page_info {
 	swp_entry_t entry;
+	struct page *page;
 };
 
 struct kvm_memory_slot {
Index: linux/drivers/kvm/kvm_main.c
===================================================================
--- linux.orig/drivers/kvm/kvm_main.c	2007-07-20 14:45:40.000000000 +0800
+++ linux/drivers/kvm/kvm_main.c	2007-07-20 14:50:11.000000000 +0800
@@ -1031,6 +1031,7 @@ repeat:
 		info->entry.val = 0;
 		if (add_to_page_cache(page, mapping, gfn, GFP_KERNEL))
 			return NULL;
+		info->page = page;
 		ClearPageDirty(page);
 	} else {
 		/* allocate new page */
@@ -1041,6 +1042,7 @@ repeat:
 			page_cache_release(page);
 			return NULL;
 		}
+		info->page = page;
 		SetPageUptodate(page);
 		set_page_private(page, 0);
 	}
@@ -1063,6 +1065,7 @@ static int kvm_move_to_swap(struct page 
 	if (move_to_swap_cache(page, swap) == 0) {
 		slot = __gfn_to_memslot(kvm, gfn);
 		slot->phys_mem[gfn - slot->base_gfn].entry = swap;
+		slot->phys_mem[gfn - slot->base_gfn].page = NULL;
 		return 0;
 	}
 	swap_free(swap);
@@ -1082,6 +1085,12 @@ struct page *gfn_to_page(struct kvm *kvm
 	if (!slot)
 		return NULL;
 
+	page = slot->phys_mem[gfn - slot->base_gfn].page;
+	if (page) {
+		mark_page_accessed(page);
+		return page;
+	}
+
 	page = find_get_page(mapping, gfn);
 	if (page)
 		goto out;
