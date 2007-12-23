Return-Path: <linux-kernel-owner+w=401wt.eu-S1758328AbXLWO6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758328AbXLWO6h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 09:58:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755986AbXLWOwB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 09:52:01 -0500
Received: from il.qumranet.com ([82.166.9.18]:35919 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753050AbXLWOvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 09:51:44 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Izik Eidus <izike@qumranet.com>
Subject: [PATCH 20/50] KVM: Remove the usage of page->private field by rmap
Date: Sun, 23 Dec 2007 16:51:05 +0200
Message-Id: <1198421495-31481-21-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198421495-31481-1-git-send-email-avi@qumranet.com>
References: <1198421495-31481-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Izik Eidus <izike@qumranet.com>

When kvm uses user-allocated pages in the future for the guest, we won't
be able to use page->private for rmap, since page->rmap is reserved for
the filesystem.  So we move the rmap base pointers to the memory slot.

A side effect of this is that we need to store the gfn of each gpte in
the shadow pages, since the memory slot is addressed by gfn, instead of
hfn like struct page.

Signed-off-by: Izik Eidus <izik@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h         |    6 ++-
 drivers/kvm/kvm_main.c    |   11 +++-
 drivers/kvm/mmu.c         |  122 ++++++++++++++++++++++++++-------------------
 drivers/kvm/paging_tmpl.h |    3 +-
 4 files changed, 86 insertions(+), 56 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 08ffc82..80cfb99 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -126,6 +126,8 @@ struct kvm_mmu_page {
 	union kvm_mmu_page_role role;
 
 	u64 *spt;
+	/* hold the gfn of each spte inside spt */
+	gfn_t *gfns;
 	unsigned long slot_bitmap; /* One bit set per slot which has memory
 				    * in this shadow page.
 				    */
@@ -159,7 +161,7 @@ struct kvm_mmu {
 	u64 *pae_root;
 };
 
-#define KVM_NR_MEM_OBJS 20
+#define KVM_NR_MEM_OBJS 40
 
 struct kvm_mmu_memory_cache {
 	int nobjs;
@@ -402,6 +404,7 @@ struct kvm_memory_slot {
 	unsigned long npages;
 	unsigned long flags;
 	struct page **phys_mem;
+	unsigned long *rmap;
 	unsigned long *dirty_bitmap;
 };
 
@@ -554,6 +557,7 @@ struct page *gva_to_page(struct kvm_vcpu *vcpu, gva_t gva);
 
 extern hpa_t bad_page_address;
 
+gfn_t unalias_gfn(struct kvm *kvm, gfn_t gfn);
 struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn);
 struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn);
 void mark_page_dirty(struct kvm *kvm, gfn_t gfn);
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index f7566b9..ac563fc 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -309,6 +309,8 @@ static void kvm_free_physmem_slot(struct kvm_memory_slot *free,
 					__free_page(free->phys_mem[i]);
 			vfree(free->phys_mem);
 		}
+	if (!dont || free->rmap != dont->rmap)
+		vfree(free->rmap);
 
 	if (!dont || free->dirty_bitmap != dont->dirty_bitmap)
 		vfree(free->dirty_bitmap);
@@ -719,13 +721,18 @@ static int kvm_vm_ioctl_set_memory_region(struct kvm *kvm,
 		if (!new.phys_mem)
 			goto out_unlock;
 
+		new.rmap = vmalloc(npages * sizeof(struct page*));
+
+		if (!new.rmap)
+			goto out_unlock;
+
 		memset(new.phys_mem, 0, npages * sizeof(struct page *));
+		memset(new.rmap, 0, npages * sizeof(*new.rmap));
 		for (i = 0; i < npages; ++i) {
 			new.phys_mem[i] = alloc_page(GFP_HIGHUSER
 						     | __GFP_ZERO);
 			if (!new.phys_mem[i])
 				goto out_unlock;
-			set_page_private(new.phys_mem[i],0);
 		}
 	}
 
@@ -909,7 +916,7 @@ static int kvm_vm_ioctl_set_irqchip(struct kvm *kvm, struct kvm_irqchip *chip)
 	return r;
 }
 
-static gfn_t unalias_gfn(struct kvm *kvm, gfn_t gfn)
+gfn_t unalias_gfn(struct kvm *kvm, gfn_t gfn)
 {
 	int i;
 	struct kvm_mem_alias *alias;
diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index d347e89..72757db 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -276,7 +276,7 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu)
 				   rmap_desc_cache, 1);
 	if (r)
 		goto out;
-	r = mmu_topup_memory_cache_page(&vcpu->mmu_page_cache, 4);
+	r = mmu_topup_memory_cache_page(&vcpu->mmu_page_cache, 8);
 	if (r)
 		goto out;
 	r = mmu_topup_memory_cache(&vcpu->mmu_page_header_cache,
@@ -327,35 +327,52 @@ static void mmu_free_rmap_desc(struct kvm_rmap_desc *rd)
 }
 
 /*
+ * Take gfn and return the reverse mapping to it.
+ * Note: gfn must be unaliased before this function get called
+ */
+
+static unsigned long *gfn_to_rmap(struct kvm *kvm, gfn_t gfn)
+{
+	struct kvm_memory_slot *slot;
+
+	slot = gfn_to_memslot(kvm, gfn);
+	return &slot->rmap[gfn - slot->base_gfn];
+}
+
+/*
  * Reverse mapping data structures:
  *
- * If page->private bit zero is zero, then page->private points to the
- * shadow page table entry that points to page_address(page).
+ * If rmapp bit zero is zero, then rmapp point to the shadw page table entry
+ * that points to page_address(page).
  *
- * If page->private bit zero is one, (then page->private & ~1) points
- * to a struct kvm_rmap_desc containing more mappings.
+ * If rmapp bit zero is one, (then rmap & ~1) points to a struct kvm_rmap_desc
+ * containing more mappings.
  */
-static void rmap_add(struct kvm_vcpu *vcpu, u64 *spte)
+static void rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
 {
-	struct page *page;
+	struct kvm_mmu_page *page;
 	struct kvm_rmap_desc *desc;
+	unsigned long *rmapp;
 	int i;
 
 	if (!is_rmap_pte(*spte))
 		return;
-	page = pfn_to_page((*spte & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT);
-	if (!page_private(page)) {
+	gfn = unalias_gfn(vcpu->kvm, gfn);
+	page = page_header(__pa(spte));
+	page->gfns[spte - page->spt] = gfn;
+	rmapp = gfn_to_rmap(vcpu->kvm, gfn);
+	if (!*rmapp) {
 		rmap_printk("rmap_add: %p %llx 0->1\n", spte, *spte);
-		set_page_private(page,(unsigned long)spte);
-	} else if (!(page_private(page) & 1)) {
+		*rmapp = (unsigned long)spte;
+	} else if (!(*rmapp & 1)) {
 		rmap_printk("rmap_add: %p %llx 1->many\n", spte, *spte);
 		desc = mmu_alloc_rmap_desc(vcpu);
-		desc->shadow_ptes[0] = (u64 *)page_private(page);
+		desc->shadow_ptes[0] = (u64 *)*rmapp;
 		desc->shadow_ptes[1] = spte;
-		set_page_private(page,(unsigned long)desc | 1);
+		*rmapp = (unsigned long)desc | 1;
 	} else {
 		rmap_printk("rmap_add: %p %llx many->many\n", spte, *spte);
-		desc = (struct kvm_rmap_desc *)(page_private(page) & ~1ul);
+		desc = (struct kvm_rmap_desc *)(*rmapp & ~1ul);
 		while (desc->shadow_ptes[RMAP_EXT-1] && desc->more)
 			desc = desc->more;
 		if (desc->shadow_ptes[RMAP_EXT-1]) {
@@ -368,7 +385,7 @@ static void rmap_add(struct kvm_vcpu *vcpu, u64 *spte)
 	}
 }
 
-static void rmap_desc_remove_entry(struct page *page,
+static void rmap_desc_remove_entry(unsigned long *rmapp,
 				   struct kvm_rmap_desc *desc,
 				   int i,
 				   struct kvm_rmap_desc *prev_desc)
@@ -382,44 +399,46 @@ static void rmap_desc_remove_entry(struct page *page,
 	if (j != 0)
 		return;
 	if (!prev_desc && !desc->more)
-		set_page_private(page,(unsigned long)desc->shadow_ptes[0]);
+		*rmapp = (unsigned long)desc->shadow_ptes[0];
 	else
 		if (prev_desc)
 			prev_desc->more = desc->more;
 		else
-			set_page_private(page,(unsigned long)desc->more | 1);
+			*rmapp = (unsigned long)desc->more | 1;
 	mmu_free_rmap_desc(desc);
 }
 
-static void rmap_remove(u64 *spte)
+static void rmap_remove(struct kvm *kvm, u64 *spte)
 {
-	struct page *page;
 	struct kvm_rmap_desc *desc;
 	struct kvm_rmap_desc *prev_desc;
+	struct kvm_mmu_page *page;
+	unsigned long *rmapp;
 	int i;
 
 	if (!is_rmap_pte(*spte))
 		return;
-	page = pfn_to_page((*spte & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT);
-	if (!page_private(page)) {
+	page = page_header(__pa(spte));
+	rmapp = gfn_to_rmap(kvm, page->gfns[spte - page->spt]);
+	if (!*rmapp) {
 		printk(KERN_ERR "rmap_remove: %p %llx 0->BUG\n", spte, *spte);
 		BUG();
-	} else if (!(page_private(page) & 1)) {
+	} else if (!(*rmapp & 1)) {
 		rmap_printk("rmap_remove:  %p %llx 1->0\n", spte, *spte);
-		if ((u64 *)page_private(page) != spte) {
+		if ((u64 *)*rmapp != spte) {
 			printk(KERN_ERR "rmap_remove:  %p %llx 1->BUG\n",
 			       spte, *spte);
 			BUG();
 		}
-		set_page_private(page,0);
+		*rmapp = 0;
 	} else {
 		rmap_printk("rmap_remove:  %p %llx many->many\n", spte, *spte);
-		desc = (struct kvm_rmap_desc *)(page_private(page) & ~1ul);
+		desc = (struct kvm_rmap_desc *)(*rmapp & ~1ul);
 		prev_desc = NULL;
 		while (desc) {
 			for (i = 0; i < RMAP_EXT && desc->shadow_ptes[i]; ++i)
 				if (desc->shadow_ptes[i] == spte) {
-					rmap_desc_remove_entry(page,
+					rmap_desc_remove_entry(rmapp,
 							       desc, i,
 							       prev_desc);
 					return;
@@ -433,28 +452,25 @@ static void rmap_remove(u64 *spte)
 
 static void rmap_write_protect(struct kvm_vcpu *vcpu, u64 gfn)
 {
-	struct kvm *kvm = vcpu->kvm;
-	struct page *page;
 	struct kvm_rmap_desc *desc;
+	unsigned long *rmapp;
 	u64 *spte;
 
-	page = gfn_to_page(kvm, gfn);
-	BUG_ON(!page);
+	gfn = unalias_gfn(vcpu->kvm, gfn);
+	rmapp = gfn_to_rmap(vcpu->kvm, gfn);
 
-	while (page_private(page)) {
-		if (!(page_private(page) & 1))
-			spte = (u64 *)page_private(page);
+	while (*rmapp) {
+		if (!(*rmapp & 1))
+			spte = (u64 *)*rmapp;
 		else {
-			desc = (struct kvm_rmap_desc *)(page_private(page) & ~1ul);
+			desc = (struct kvm_rmap_desc *)(*rmapp & ~1ul);
 			spte = desc->shadow_ptes[0];
 		}
 		BUG_ON(!spte);
-		BUG_ON((*spte & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT
-		       != page_to_pfn(page));
 		BUG_ON(!(*spte & PT_PRESENT_MASK));
 		BUG_ON(!(*spte & PT_WRITABLE_MASK));
 		rmap_printk("rmap_write_protect: spte %p %llx\n", spte, *spte);
-		rmap_remove(spte);
+		rmap_remove(vcpu->kvm, spte);
 		set_shadow_pte(spte, *spte & ~PT_WRITABLE_MASK);
 		kvm_flush_remote_tlbs(vcpu->kvm);
 	}
@@ -482,6 +498,7 @@ static void kvm_mmu_free_page(struct kvm *kvm,
 	ASSERT(is_empty_shadow_page(page_head->spt));
 	list_del(&page_head->link);
 	__free_page(virt_to_page(page_head->spt));
+	__free_page(virt_to_page(page_head->gfns));
 	kfree(page_head);
 	++kvm->n_free_mmu_pages;
 }
@@ -502,6 +519,7 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu,
 	page = mmu_memory_cache_alloc(&vcpu->mmu_page_header_cache,
 				      sizeof *page);
 	page->spt = mmu_memory_cache_alloc(&vcpu->mmu_page_cache, PAGE_SIZE);
+	page->gfns = mmu_memory_cache_alloc(&vcpu->mmu_page_cache, PAGE_SIZE);
 	set_page_private(virt_to_page(page->spt), (unsigned long)page);
 	list_add(&page->link, &vcpu->kvm->active_mmu_pages);
 	ASSERT(is_empty_shadow_page(page->spt));
@@ -667,7 +685,7 @@ static void kvm_mmu_page_unlink_children(struct kvm *kvm,
 	if (page->role.level == PT_PAGE_TABLE_LEVEL) {
 		for (i = 0; i < PT64_ENT_PER_PAGE; ++i) {
 			if (is_shadow_present_pte(pt[i]))
-				rmap_remove(&pt[i]);
+				rmap_remove(kvm, &pt[i]);
 			pt[i] = shadow_trap_nonpresent_pte;
 		}
 		kvm_flush_remote_tlbs(kvm);
@@ -832,7 +850,7 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, hpa_t p)
 			page_header_update_slot(vcpu->kvm, table, v);
 			table[index] = p | PT_PRESENT_MASK | PT_WRITABLE_MASK |
 								PT_USER_MASK;
-			rmap_add(vcpu, &table[index]);
+			rmap_add(vcpu, &table[index], v >> PAGE_SHIFT);
 			return 0;
 		}
 
@@ -1123,7 +1141,7 @@ static void mmu_pte_write_zap_pte(struct kvm_vcpu *vcpu,
 	pte = *spte;
 	if (is_shadow_present_pte(pte)) {
 		if (page->role.level == PT_PAGE_TABLE_LEVEL)
-			rmap_remove(spte);
+			rmap_remove(vcpu->kvm, spte);
 		else {
 			child = page_header(pte & PT64_BASE_ADDR_MASK);
 			mmu_page_remove_parent_pte(child, spte);
@@ -1340,7 +1358,7 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)
 		for (i = 0; i < PT64_ENT_PER_PAGE; ++i)
 			/* avoid RMW */
 			if (pt[i] & PT_WRITABLE_MASK) {
-				rmap_remove(&pt[i]);
+				rmap_remove(kvm, &pt[i]);
 				pt[i] &= ~PT_WRITABLE_MASK;
 			}
 	}
@@ -1470,15 +1488,15 @@ static int count_rmaps(struct kvm_vcpu *vcpu)
 		struct kvm_rmap_desc *d;
 
 		for (j = 0; j < m->npages; ++j) {
-			struct page *page = m->phys_mem[j];
+			unsigned long *rmapp = &m->rmap[j];
 
-			if (!page->private)
+			if (!*rmapp)
 				continue;
-			if (!(page->private & 1)) {
+			if (!(*rmapp & 1)) {
 				++nmaps;
 				continue;
 			}
-			d = (struct kvm_rmap_desc *)(page->private & ~1ul);
+			d = (struct kvm_rmap_desc *)(*rmapp & ~1ul);
 			while (d) {
 				for (k = 0; k < RMAP_EXT; ++k)
 					if (d->shadow_ptes[k])
@@ -1530,18 +1548,18 @@ static void audit_rmap(struct kvm_vcpu *vcpu)
 static void audit_write_protection(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu_page *page;
+	struct kvm_memory_slot *slot;
+	unsigned long *rmapp;
+	gfn_t gfn;
 
 	list_for_each_entry(page, &vcpu->kvm->active_mmu_pages, link) {
-		hfn_t hfn;
-		struct page *pg;
-
 		if (page->role.metaphysical)
 			continue;
 
-		hfn = gpa_to_hpa(vcpu, (gpa_t)page->gfn << PAGE_SHIFT)
-			>> PAGE_SHIFT;
-		pg = pfn_to_page(hfn);
-		if (pg->private)
+		slot = gfn_to_memslot(vcpu->kvm, page->gfn);
+		gfn = unalias_gfn(vcpu->kvm, page->gfn);
+		rmapp = &slot->rmap[gfn - slot->base_gfn];
+		if (*rmapp)
 			printk(KERN_ERR "%s: (%s) shadow page has writable"
 			       " mappings: gfn %lx role %x\n",
 			       __FUNCTION__, audit_msg, page->gfn,
diff --git a/drivers/kvm/paging_tmpl.h b/drivers/kvm/paging_tmpl.h
index be0f852..fbe595f 100644
--- a/drivers/kvm/paging_tmpl.h
+++ b/drivers/kvm/paging_tmpl.h
@@ -295,7 +295,8 @@ unshadowed:
 	set_shadow_pte(shadow_pte, spte);
 	page_header_update_slot(vcpu->kvm, shadow_pte, gaddr);
 	if (!was_rmapped)
-		rmap_add(vcpu, shadow_pte);
+		rmap_add(vcpu, shadow_pte, (gaddr & PT64_BASE_ADDR_MASK)
+			 >> PAGE_SHIFT);
 	if (!ptwrite || !*ptwrite)
 		vcpu->last_pte_updated = shadow_pte;
 }
-- 
1.5.3.7

