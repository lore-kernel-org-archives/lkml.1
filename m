Return-Path: <linux-kernel-owner+w=401wt.eu-S1750855AbXBSK0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750855AbXBSK0y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 05:26:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750843AbXBSK0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 05:26:54 -0500
Received: from il.qumranet.com ([82.166.9.18]:35459 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840AbXBSK0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 05:26:53 -0500
Subject: [PATCH 6/13] KVM: Use page_private()/set_page_private() apis
From: Avi Kivity <avi@qumranet.com>
Date: Mon, 19 Feb 2007 10:26:52 -0000
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, mingo@elte.hu
References: <45D979D3.2020907@qumranet.com>
In-Reply-To: <45D979D3.2020907@qumranet.com>
Content-Type: text/plain; charset=UTF-8
Message-Id: <20070219102652.053E325016B@il.qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Rechberger <markus.rechberger@amd.com>

Besides using an established api, this allows using kvm in older kernels.

Signed-off-by: Markus Rechberger <markus.rechberger@amd.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>

Index: linux-2.6/drivers/kvm/mmu.c
===================================================================
--- linux-2.6.orig/drivers/kvm/mmu.c
+++ linux-2.6/drivers/kvm/mmu.c
@@ -298,18 +298,18 @@ static void rmap_add(struct kvm_vcpu *vc
 	if (!is_rmap_pte(*spte))
 		return;
 	page = pfn_to_page((*spte & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT);
-	if (!page->private) {
+	if (!page_private(page)) {
 		rmap_printk("rmap_add: %p %llx 0->1\n", spte, *spte);
-		page->private = (unsigned long)spte;
-	} else if (!(page->private & 1)) {
+		set_page_private(page,(unsigned long)spte);
+	} else if (!(page_private(page) & 1)) {
 		rmap_printk("rmap_add: %p %llx 1->many\n", spte, *spte);
 		desc = mmu_alloc_rmap_desc(vcpu);
-		desc->shadow_ptes[0] = (u64 *)page->private;
+		desc->shadow_ptes[0] = (u64 *)page_private(page);
 		desc->shadow_ptes[1] = spte;
-		page->private = (unsigned long)desc | 1;
+		set_page_private(page,(unsigned long)desc | 1);
 	} else {
 		rmap_printk("rmap_add: %p %llx many->many\n", spte, *spte);
-		desc = (struct kvm_rmap_desc *)(page->private & ~1ul);
+		desc = (struct kvm_rmap_desc *)(page_private(page) & ~1ul);
 		while (desc->shadow_ptes[RMAP_EXT-1] && desc->more)
 			desc = desc->more;
 		if (desc->shadow_ptes[RMAP_EXT-1]) {
@@ -337,12 +337,12 @@ static void rmap_desc_remove_entry(struc
 	if (j != 0)
 		return;
 	if (!prev_desc && !desc->more)
-		page->private = (unsigned long)desc->shadow_ptes[0];
+		set_page_private(page,(unsigned long)desc->shadow_ptes[0]);
 	else
 		if (prev_desc)
 			prev_desc->more = desc->more;
 		else
-			page->private = (unsigned long)desc->more | 1;
+			set_page_private(page,(unsigned long)desc->more | 1);
 	mmu_free_rmap_desc(vcpu, desc);
 }
 
@@ -356,20 +356,20 @@ static void rmap_remove(struct kvm_vcpu 
 	if (!is_rmap_pte(*spte))
 		return;
 	page = pfn_to_page((*spte & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT);
-	if (!page->private) {
+	if (!page_private(page)) {
 		printk(KERN_ERR "rmap_remove: %p %llx 0->BUG\n", spte, *spte);
 		BUG();
-	} else if (!(page->private & 1)) {
+	} else if (!(page_private(page) & 1)) {
 		rmap_printk("rmap_remove:  %p %llx 1->0\n", spte, *spte);
-		if ((u64 *)page->private != spte) {
+		if ((u64 *)page_private(page) != spte) {
 			printk(KERN_ERR "rmap_remove:  %p %llx 1->BUG\n",
 			       spte, *spte);
 			BUG();
 		}
-		page->private = 0;
+		set_page_private(page,0);
 	} else {
 		rmap_printk("rmap_remove:  %p %llx many->many\n", spte, *spte);
-		desc = (struct kvm_rmap_desc *)(page->private & ~1ul);
+		desc = (struct kvm_rmap_desc *)(page_private(page) & ~1ul);
 		prev_desc = NULL;
 		while (desc) {
 			for (i = 0; i < RMAP_EXT && desc->shadow_ptes[i]; ++i)
@@ -398,11 +398,11 @@ static void rmap_write_protect(struct kv
 	BUG_ON(!slot);
 	page = gfn_to_page(slot, gfn);
 
-	while (page->private) {
-		if (!(page->private & 1))
-			spte = (u64 *)page->private;
+	while (page_private(page)) {
+		if (!(page_private(page) & 1))
+			spte = (u64 *)page_private(page);
 		else {
-			desc = (struct kvm_rmap_desc *)(page->private & ~1ul);
+			desc = (struct kvm_rmap_desc *)(page_private(page) & ~1ul);
 			spte = desc->shadow_ptes[0];
 		}
 		BUG_ON(!spte);
@@ -1218,7 +1218,7 @@ static int alloc_mmu_pages(struct kvm_vc
 		INIT_LIST_HEAD(&page_header->link);
 		if ((page = alloc_page(GFP_KERNEL)) == NULL)
 			goto error_1;
-		page->private = (unsigned long)page_header;
+		set_page_private(page, (unsigned long)page_header);
 		page_header->page_hpa = (hpa_t)page_to_pfn(page) << PAGE_SHIFT;
 		memset(__va(page_header->page_hpa), 0, PAGE_SIZE);
 		list_add(&page_header->link, &vcpu->free_pages);
Index: linux-2.6/drivers/kvm/kvm_main.c
===================================================================
--- linux-2.6.orig/drivers/kvm/kvm_main.c
+++ linux-2.6/drivers/kvm/kvm_main.c
@@ -670,7 +670,7 @@ raced:
 						     | __GFP_ZERO);
 			if (!new.phys_mem[i])
 				goto out_free;
- 			new.phys_mem[i]->private = 0;
+			set_page_private(new.phys_mem[i],0);
 		}
 	}
 
Index: linux-2.6/drivers/kvm/kvm.h
===================================================================
--- linux-2.6.orig/drivers/kvm/kvm.h
+++ linux-2.6/drivers/kvm/kvm.h
@@ -523,7 +523,7 @@ static inline struct kvm_mmu_page *page_
 {
 	struct page *page = pfn_to_page(shadow_page >> PAGE_SHIFT);
 
-	return (struct kvm_mmu_page *)page->private;
+	return (struct kvm_mmu_page *)page_private(page);
 }
 
 static inline u16 read_fs(void)
