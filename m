Return-Path: <linux-kernel-owner+w=401wt.eu-S1759677AbXLWPGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759677AbXLWPGU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 10:06:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756001AbXLWOwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 09:52:30 -0500
Received: from il.qumranet.com ([82.166.9.18]:35914 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755155AbXLWOvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 09:51:48 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Izik Eidus <avi@qumranet.com>
Subject: [PATCH 48/50] KVM: MMU: Partial swapping of guest memory
Date: Sun, 23 Dec 2007 16:51:33 +0200
Message-Id: <1198421495-31481-49-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198421495-31481-1-git-send-email-avi@qumranet.com>
References: <1198421495-31481-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Izik Eidus <avi@qumranet.com>

This allows guest memory to be swapped.  Pages which are currently mapped
via shadow page tables are pinned into memory, but all other pages can
be freely swapped.

The patch makes gfn_to_page() elevate the page's reference count, and
introduces kvm_release_page() that pairs with it.

Signed-off-by: Izik Eidus <izike@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h         |    2 +
 drivers/kvm/kvm_main.c    |   83 +++++++++++++++++++++++++--------------------
 drivers/kvm/mmu.c         |   14 +++++++-
 drivers/kvm/paging_tmpl.h |   26 ++++++++++++--
 4 files changed, 84 insertions(+), 41 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 0c17c76..df0711c 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -409,6 +409,7 @@ struct kvm_memory_slot {
 	unsigned long *rmap;
 	unsigned long *dirty_bitmap;
 	int user_alloc; /* user allocated memory */
+	unsigned long userspace_addr;
 };
 
 struct kvm {
@@ -570,6 +571,7 @@ extern struct page *bad_page;
 int is_error_page(struct page *page);
 gfn_t unalias_gfn(struct kvm *kvm, gfn_t gfn);
 struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn);
+void kvm_release_page(struct page *page);
 int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
 			int len);
 int kvm_read_guest(struct kvm *kvm, gpa_t gpa, void *data, unsigned long len);
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index ebfb967..1c64047 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -300,19 +300,6 @@ static struct kvm *kvm_create_vm(void)
 	return kvm;
 }
 
-static void kvm_free_userspace_physmem(struct kvm_memory_slot *free)
-{
-	int i;
-
-	for (i = 0; i < free->npages; ++i) {
-		if (free->phys_mem[i]) {
-			if (!PageReserved(free->phys_mem[i]))
-				SetPageDirty(free->phys_mem[i]);
-			page_cache_release(free->phys_mem[i]);
-		}
-	}
-}
-
 static void kvm_free_kernel_physmem(struct kvm_memory_slot *free)
 {
 	int i;
@@ -330,9 +317,7 @@ static void kvm_free_physmem_slot(struct kvm_memory_slot *free,
 {
 	if (!dont || free->phys_mem != dont->phys_mem)
 		if (free->phys_mem) {
-			if (free->user_alloc)
-				kvm_free_userspace_physmem(free);
-			else
+			if (!free->user_alloc)
 				kvm_free_kernel_physmem(free);
 			vfree(free->phys_mem);
 		}
@@ -361,7 +346,7 @@ static void free_pio_guest_pages(struct kvm_vcpu *vcpu)
 
 	for (i = 0; i < ARRAY_SIZE(vcpu->pio.guest_pages); ++i)
 		if (vcpu->pio.guest_pages[i]) {
-			__free_page(vcpu->pio.guest_pages[i]);
+			kvm_release_page(vcpu->pio.guest_pages[i]);
 			vcpu->pio.guest_pages[i] = NULL;
 		}
 }
@@ -752,19 +737,8 @@ static int kvm_vm_ioctl_set_memory_region(struct kvm *kvm,
 		memset(new.phys_mem, 0, npages * sizeof(struct page *));
 		memset(new.rmap, 0, npages * sizeof(*new.rmap));
 		if (user_alloc) {
-			unsigned long pages_num;
-
 			new.user_alloc = 1;
-			down_read(&current->mm->mmap_sem);
-
-			pages_num = get_user_pages(current, current->mm,
-						   mem->userspace_addr,
-						   npages, 1, 0, new.phys_mem,
-						   NULL);
-
-			up_read(&current->mm->mmap_sem);
-			if (pages_num != npages)
-				goto out_unlock;
+			new.userspace_addr = mem->userspace_addr;
 		} else {
 			for (i = 0; i < npages; ++i) {
 				new.phys_mem[i] = alloc_page(GFP_HIGHUSER
@@ -1039,12 +1013,39 @@ struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
 
 	gfn = unalias_gfn(kvm, gfn);
 	slot = __gfn_to_memslot(kvm, gfn);
-	if (!slot)
+	if (!slot) {
+		get_page(bad_page);
 		return bad_page;
+	}
+	if (slot->user_alloc) {
+		struct page *page[1];
+		int npages;
+
+		down_read(&current->mm->mmap_sem);
+		npages = get_user_pages(current, current->mm,
+					slot->userspace_addr
+					+ (gfn - slot->base_gfn) * PAGE_SIZE, 1,
+					1, 0, page, NULL);
+		up_read(&current->mm->mmap_sem);
+		if (npages != 1) {
+			get_page(bad_page);
+			return bad_page;
+		}
+		return page[0];
+	}
+	get_page(slot->phys_mem[gfn - slot->base_gfn]);
 	return slot->phys_mem[gfn - slot->base_gfn];
 }
 EXPORT_SYMBOL_GPL(gfn_to_page);
 
+void kvm_release_page(struct page *page)
+{
+	if (!PageReserved(page))
+		SetPageDirty(page);
+	put_page(page);
+}
+EXPORT_SYMBOL_GPL(kvm_release_page);
+
 static int next_segment(unsigned long len, int offset)
 {
 	if (len > PAGE_SIZE - offset)
@@ -1060,13 +1061,16 @@ int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
 	struct page *page;
 
 	page = gfn_to_page(kvm, gfn);
-	if (is_error_page(page))
+	if (is_error_page(page)) {
+		kvm_release_page(page);
 		return -EFAULT;
+	}
 	page_virt = kmap_atomic(page, KM_USER0);
 
 	memcpy(data, page_virt + offset, len);
 
 	kunmap_atomic(page_virt, KM_USER0);
+	kvm_release_page(page);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(kvm_read_guest_page);
@@ -1098,14 +1102,17 @@ int kvm_write_guest_page(struct kvm *kvm, gfn_t gfn, const void *data,
 	struct page *page;
 
 	page = gfn_to_page(kvm, gfn);
-	if (is_error_page(page))
+	if (is_error_page(page)) {
+		kvm_release_page(page);
 		return -EFAULT;
+	}
 	page_virt = kmap_atomic(page, KM_USER0);
 
 	memcpy(page_virt + offset, data, len);
 
 	kunmap_atomic(page_virt, KM_USER0);
 	mark_page_dirty(kvm, gfn);
+	kvm_release_page(page);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(kvm_write_guest_page);
@@ -1136,13 +1143,16 @@ int kvm_clear_guest_page(struct kvm *kvm, gfn_t gfn, int offset, int len)
 	struct page *page;
 
 	page = gfn_to_page(kvm, gfn);
-	if (is_error_page(page))
+	if (is_error_page(page)) {
+		kvm_release_page(page);
 		return -EFAULT;
+	}
 	page_virt = kmap_atomic(page, KM_USER0);
 
 	memset(page_virt + offset, 0, len);
 
 	kunmap_atomic(page_virt, KM_USER0);
+	kvm_release_page(page);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(kvm_clear_guest_page);
@@ -2070,8 +2080,6 @@ int kvm_emulate_pio_string(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
 	for (i = 0; i < nr_pages; ++i) {
 		mutex_lock(&vcpu->kvm->lock);
 		page = gva_to_page(vcpu, address + i * PAGE_SIZE);
-		if (page)
-			get_page(page);
 		vcpu->pio.guest_pages[i] = page;
 		mutex_unlock(&vcpu->kvm->lock);
 		if (!page) {
@@ -3074,9 +3082,10 @@ static struct page *kvm_vm_nopage(struct vm_area_struct *vma,
 
 	pgoff = ((address - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
 	page = gfn_to_page(kvm, pgoff);
-	if (is_error_page(page))
+	if (is_error_page(page)) {
+		kvm_release_page(page);
 		return NOPAGE_SIGBUS;
-	get_page(page);
+	}
 	if (type != NULL)
 		*type = VM_FAULT_MINOR;
 
diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index 2ad14fb..5d7af4b 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -425,6 +425,8 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
 	if (!is_rmap_pte(*spte))
 		return;
 	page = page_header(__pa(spte));
+	kvm_release_page(pfn_to_page((*spte & PT64_BASE_ADDR_MASK) >>
+			 PAGE_SHIFT));
 	rmapp = gfn_to_rmap(kvm, page->gfns[spte - page->spt]);
 	if (!*rmapp) {
 		printk(KERN_ERR "rmap_remove: %p %llx 0->BUG\n", spte, *spte);
@@ -911,6 +913,8 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, hpa_t p)
 								PT_USER_MASK;
 			if (!was_rmapped)
 				rmap_add(vcpu, &table[index], v >> PAGE_SHIFT);
+			else
+				kvm_release_page(pfn_to_page(p >> PAGE_SHIFT));
 			return 0;
 		}
 
@@ -925,6 +929,7 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, hpa_t p)
 						     1, 3, &table[index]);
 			if (!new_table) {
 				pgprintk("nonpaging_map: ENOMEM\n");
+				kvm_release_page(pfn_to_page(p >> PAGE_SHIFT));
 				return -ENOMEM;
 			}
 
@@ -1039,8 +1044,11 @@ static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
 
 	paddr = gpa_to_hpa(vcpu->kvm, addr & PT64_BASE_ADDR_MASK);
 
-	if (is_error_hpa(paddr))
+	if (is_error_hpa(paddr)) {
+		kvm_release_page(pfn_to_page((paddr & PT64_BASE_ADDR_MASK)
+				 >> PAGE_SHIFT));
 		return 1;
+	}
 
 	return nonpaging_map(vcpu, addr & PAGE_MASK, paddr);
 }
@@ -1507,6 +1515,7 @@ static void audit_mappings_page(struct kvm_vcpu *vcpu, u64 page_pte,
 		} else {
 			gpa_t gpa = vcpu->mmu.gva_to_gpa(vcpu, va);
 			hpa_t hpa = gpa_to_hpa(vcpu, gpa);
+			struct page *page;
 
 			if (is_shadow_present_pte(ent)
 			    && (ent & PT64_BASE_ADDR_MASK) != hpa)
@@ -1519,6 +1528,9 @@ static void audit_mappings_page(struct kvm_vcpu *vcpu, u64 page_pte,
 				 && !is_error_hpa(hpa))
 				printk(KERN_ERR "audit: (%s) notrap shadow,"
 				       " valid guest gva %lx\n", audit_msg, va);
+			page = pfn_to_page((gpa & PT64_BASE_ADDR_MASK)
+					   >> PAGE_SHIFT);
+			kvm_release_page(page);
 
 		}
 	}
diff --git a/drivers/kvm/paging_tmpl.h b/drivers/kvm/paging_tmpl.h
index 572e5b6..0f0266a 100644
--- a/drivers/kvm/paging_tmpl.h
+++ b/drivers/kvm/paging_tmpl.h
@@ -72,7 +72,7 @@ static int FNAME(walk_addr)(struct guest_walker *walker,
 			    struct kvm_vcpu *vcpu, gva_t addr,
 			    int write_fault, int user_fault, int fetch_fault)
 {
-	struct page *page;
+	struct page *page = NULL;
 	pt_element_t *table;
 	pt_element_t pte;
 	gfn_t table_gfn;
@@ -149,6 +149,7 @@ static int FNAME(walk_addr)(struct guest_walker *walker,
 
 		walker->inherited_ar &= pte;
 		--walker->level;
+		kvm_release_page(page);
 	}
 
 	if (write_fault && !is_dirty_pte(pte)) {
@@ -162,6 +163,7 @@ static int FNAME(walk_addr)(struct guest_walker *walker,
 		kvm_mmu_pte_write(vcpu, pte_gpa, (u8 *)&pte, sizeof(pte));
 	}
 
+	kvm_release_page(page);
 	walker->pte = pte;
 	pgprintk("%s: pte %llx\n", __FUNCTION__, (u64)pte);
 	return 1;
@@ -180,6 +182,8 @@ err:
 		walker->error_code |= PFERR_USER_MASK;
 	if (fetch_fault)
 		walker->error_code |= PFERR_FETCH_MASK;
+	if (page)
+		kvm_release_page(page);
 	return 0;
 }
 
@@ -223,6 +227,8 @@ static void FNAME(set_pte_common)(struct kvm_vcpu *vcpu,
 	if (is_error_hpa(paddr)) {
 		set_shadow_pte(shadow_pte,
 			       shadow_trap_nonpresent_pte | PT_SHADOW_IO_MARK);
+		kvm_release_page(pfn_to_page((paddr & PT64_BASE_ADDR_MASK)
+					     >> PAGE_SHIFT));
 		return;
 	}
 
@@ -260,9 +266,20 @@ unshadowed:
 	pgprintk("%s: setting spte %llx\n", __FUNCTION__, spte);
 	set_shadow_pte(shadow_pte, spte);
 	page_header_update_slot(vcpu->kvm, shadow_pte, gaddr);
-	if (!was_rmapped)
+	if (!was_rmapped) {
 		rmap_add(vcpu, shadow_pte, (gaddr & PT64_BASE_ADDR_MASK)
 			 >> PAGE_SHIFT);
+		if (!is_rmap_pte(*shadow_pte)) {
+			struct page *page;
+
+			page = pfn_to_page((paddr & PT64_BASE_ADDR_MASK)
+					   >> PAGE_SHIFT);
+			kvm_release_page(page);
+		}
+	}
+	else
+		kvm_release_page(pfn_to_page((paddr & PT64_BASE_ADDR_MASK)
+				 >> PAGE_SHIFT));
 	if (!ptwrite || !*ptwrite)
 		vcpu->last_pte_updated = shadow_pte;
 }
@@ -486,19 +503,22 @@ static void FNAME(prefetch_page)(struct kvm_vcpu *vcpu,
 {
 	int i;
 	pt_element_t *gpt;
+	struct page *page;
 
 	if (sp->role.metaphysical || PTTYPE == 32) {
 		nonpaging_prefetch_page(vcpu, sp);
 		return;
 	}
 
-	gpt = kmap_atomic(gfn_to_page(vcpu->kvm, sp->gfn), KM_USER0);
+	page = gfn_to_page(vcpu->kvm, sp->gfn);
+	gpt = kmap_atomic(page, KM_USER0);
 	for (i = 0; i < PT64_ENT_PER_PAGE; ++i)
 		if (is_present_pte(gpt[i]))
 			sp->spt[i] = shadow_trap_nonpresent_pte;
 		else
 			sp->spt[i] = shadow_notrap_nonpresent_pte;
 	kunmap_atomic(gpt, KM_USER0);
+	kvm_release_page(page);
 }
 
 #undef pt_element_t
-- 
1.5.3.7

