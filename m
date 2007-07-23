Return-Path: <linux-kernel-owner+w=401wt.eu-S1764608AbXGWG7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764608AbXGWG7u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 02:59:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764026AbXGWG5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 02:57:17 -0400
Received: from mga01.intel.com ([192.55.52.88]:55412 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763094AbXGWG4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 02:56:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,569,1175497200"; 
   d="scan'208";a="271462915"
Subject: [RFC 5/8]KVM: rmap readonly pages
From: Shaohua Li <shaohua.li@intel.com>
To: kvm-devel <kvm-devel@lists.sourceforge.net>,
       lkml <linux-kernel@vger.kernel.org>
Cc: Avi Kivity <avi@qumranet.com>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain
Date: Mon, 23 Jul 2007 14:51:41 +0800
Message-Id: <1185173501.2645.69.camel@sli10-conroe.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make shadow page table rmap readonly pages.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 drivers/kvm/mmu.c         |   66 ++++++++++++++++++++++++++--------------------
 drivers/kvm/paging_tmpl.h |    2 -
 2 files changed, 39 insertions(+), 29 deletions(-)

Index: linux/drivers/kvm/mmu.c
===================================================================
--- linux.orig/drivers/kvm/mmu.c	2007-07-20 14:19:16.000000000 +0800
+++ linux/drivers/kvm/mmu.c	2007-07-20 14:25:25.000000000 +0800
@@ -23,6 +23,7 @@
 #include <linux/types.h>
 #include <linux/string.h>
 #include <linux/mm.h>
+#include <linux/pagemap.h>
 #include <linux/highmem.h>
 #include <linux/module.h>
 
@@ -187,12 +188,6 @@ static int is_io_pte(unsigned long pte)
 	return pte & PT_SHADOW_IO_MARK;
 }
 
-static int is_rmap_pte(u64 pte)
-{
-	return (pte & (PT_WRITABLE_MASK | PT_PRESENT_MASK))
-		== (PT_WRITABLE_MASK | PT_PRESENT_MASK);
-}
-
 static void set_shadow_pte(u64 *sptep, u64 spte)
 {
 #ifdef CONFIG_X86_64
@@ -326,12 +321,12 @@ static void rmap_add(struct kvm_vcpu *vc
 	struct kvm_rmap_desc *desc;
 	int i;
 
-	if (!is_rmap_pte(*spte))
-		return;
 	page = pfn_to_page((*spte & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT);
 	if (!page_private(page)) {
 		rmap_printk("rmap_add: %p %llx 0->1\n", spte, *spte);
 		set_page_private(page,(unsigned long)spte);
+		SetPagePrivate(page);
+		page_cache_get(page);
 	} else if (!(page_private(page) & 1)) {
 		rmap_printk("rmap_add: %p %llx 1->many\n", spte, *spte);
 		desc = mmu_alloc_rmap_desc(vcpu);
@@ -367,9 +362,13 @@ static void rmap_desc_remove_entry(struc
 	desc->shadow_ptes[j] = NULL;
 	if (j != 0)
 		return;
-	if (!prev_desc && !desc->more)
+	if (!prev_desc && !desc->more) {
 		set_page_private(page,(unsigned long)desc->shadow_ptes[0]);
-	else
+		if (page_private(page) == 0) {
+			ClearPagePrivate(page);
+			page_cache_release(page);
+		}
+	} else
 		if (prev_desc)
 			prev_desc->more = desc->more;
 		else
@@ -384,8 +383,6 @@ static void rmap_remove(struct kvm_vcpu 
 	struct kvm_rmap_desc *prev_desc;
 	int i;
 
-	if (!is_rmap_pte(*spte))
-		return;
 	page = pfn_to_page((*spte & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT);
 	if (!page_private(page)) {
 		printk(KERN_ERR "rmap_remove: %p %llx 0->BUG\n", spte, *spte);
@@ -398,6 +395,8 @@ static void rmap_remove(struct kvm_vcpu 
 			BUG();
 		}
 		set_page_private(page,0);
+		ClearPagePrivate(page);
+		page_cache_release(page);
 	} else {
 		rmap_printk("rmap_remove:  %p %llx many->many\n", spte, *spte);
 		desc = (struct kvm_rmap_desc *)(page_private(page) & ~1ul);
@@ -417,32 +416,44 @@ static void rmap_remove(struct kvm_vcpu 
 	}
 }
 
+static void rmap_write_protect_one(struct kvm_vcpu *vcpu, u64 *spte,
+	struct page *page)
+{
+		BUG_ON(!spte);
+		BUG_ON((*spte & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT
+		       != page_to_pfn(page));
+		BUG_ON(!(*spte & PT_PRESENT_MASK));
+		rmap_printk("rmap_write_protect: spte %p %llx\n", spte, *spte);
+		set_shadow_pte(spte, *spte & ~PT_WRITABLE_MASK);
+		kvm_flush_remote_tlbs(vcpu->kvm);
+}
+
 static void rmap_write_protect(struct kvm_vcpu *vcpu, u64 gfn)
 {
 	struct kvm *kvm = vcpu->kvm;
 	struct page *page;
 	struct kvm_rmap_desc *desc;
 	u64 *spte;
+	int i;
 
 	page = gfn_to_page(kvm, gfn);
 	BUG_ON(!page);
 
-	while (page_private(page)) {
-		if (!(page_private(page) & 1))
-			spte = (u64 *)page_private(page);
-		else {
-			desc = (struct kvm_rmap_desc *)(page_private(page) & ~1ul);
-			spte = desc->shadow_ptes[0];
+	if (!page_private(page))
+		return;
+
+	if (!(page_private(page) & 1)) {
+		spte = (u64 *)page_private(page);
+		rmap_write_protect_one(vcpu, spte, page);
+		return;
+	}
+	desc = (struct kvm_rmap_desc *)(page_private(page) & ~1ul);
+	while (desc) {
+		for (i = 0; i < RMAP_EXT && desc->shadow_ptes[i]; i++) {
+			spte = desc->shadow_ptes[i];
+			rmap_write_protect_one(vcpu, spte, page);
 		}
-		BUG_ON(!spte);
-		BUG_ON((*spte & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT
-		       != page_to_pfn(page));
-		BUG_ON(!(*spte & PT_PRESENT_MASK));
-		BUG_ON(!(*spte & PT_WRITABLE_MASK));
-		rmap_printk("rmap_write_protect: spte %p %llx\n", spte, *spte);
-		rmap_remove(vcpu, spte);
-		set_shadow_pte(spte, *spte & ~PT_WRITABLE_MASK);
-		kvm_flush_remote_tlbs(vcpu->kvm);
+		desc = desc->more;
 	}
 }
 
@@ -1291,7 +1302,6 @@ void kvm_mmu_slot_remove_write_access(st
 		for (i = 0; i < PT64_ENT_PER_PAGE; ++i)
 			/* avoid RMW */
 			if (pt[i] & PT_WRITABLE_MASK) {
-				rmap_remove(vcpu, &pt[i]);
 				pt[i] &= ~PT_WRITABLE_MASK;
 			}
 	}
Index: linux/drivers/kvm/paging_tmpl.h
===================================================================
--- linux.orig/drivers/kvm/paging_tmpl.h	2007-07-20 14:20:50.000000000 +0800
+++ linux/drivers/kvm/paging_tmpl.h	2007-07-20 14:23:55.000000000 +0800
@@ -212,7 +212,7 @@ static void FNAME(set_pte_common)(struct
 	hpa_t paddr;
 	int dirty = gpte & PT_DIRTY_MASK;
 	u64 spte = *shadow_pte;
-	int was_rmapped = is_rmap_pte(spte);
+	int was_rmapped = spte & PT_PRESENT_MASK;
 
 	pgprintk("%s: spte %llx gpte %llx access %llx write_fault %d"
 		 " user_fault %d gfn %lx\n",
