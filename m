Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306Ab0BJR0v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 12:26:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23594 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755740Ab0BJRXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 12:23:14 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 31/40] KVM: introduce kvm->srcu and convert kvm_set_memory_region to SRCU update
Date: Wed, 10 Feb 2010 19:23:00 +0200
Message-Id: <1265822589-11155-32-git-send-email-avi@redhat.com>
In-Reply-To: <1265822589-11155-1-git-send-email-avi@redhat.com>
References: <1265822589-11155-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

Use two steps for memslot deletion: mark the slot invalid (which stops
instantiation of new shadow pages for that slot, but allows destruction),
then instantiate the new empty slot.

Also simplifies kvm_handle_hva locking.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/ia64/kvm/kvm-ia64.c |    4 +-
 arch/x86/kvm/mmu.c       |   28 +++++-----
 arch/x86/kvm/vmx.c       |    6 ++-
 include/linux/kvm.h      |    2 +-
 include/linux/kvm_host.h |    7 +--
 virt/kvm/assigned-dev.c  |    8 +-
 virt/kvm/iommu.c         |    4 +-
 virt/kvm/kvm_main.c      |  141 ++++++++++++++++++++++++++++++++++------------
 8 files changed, 136 insertions(+), 64 deletions(-)

diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index 0757c70..b2e4d16 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -1382,7 +1382,7 @@ static void kvm_release_vm_pages(struct kvm *kvm)
 	int i, j;
 	unsigned long base_gfn;
 
-	slots = kvm->memslots;
+	slots = rcu_dereference(kvm->memslots);
 	for (i = 0; i < slots->nmemslots; i++) {
 		memslot = &slots->memslots[i];
 		base_gfn = memslot->base_gfn;
@@ -1837,6 +1837,7 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 	struct kvm_memory_slot *memslot;
 	int is_dirty = 0;
 
+	down_write(&kvm->slots_lock);
 	spin_lock(&kvm->arch.dirty_log_lock);
 
 	r = kvm_ia64_sync_dirty_log(kvm, log);
@@ -1856,6 +1857,7 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 	}
 	r = 0;
 out:
+	up_write(&kvm->slots_lock);
 	spin_unlock(&kvm->arch.dirty_log_lock);
 	return r;
 }
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 81f84d3..f8bf42a 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -29,6 +29,7 @@
 #include <linux/swap.h>
 #include <linux/hugetlb.h>
 #include <linux/compiler.h>
+#include <linux/srcu.h>
 
 #include <asm/page.h>
 #include <asm/cmpxchg.h>
@@ -807,21 +808,15 @@ static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
 {
 	int i, j;
 	int retval = 0;
-	struct kvm_memslots *slots = kvm->memslots;
+	struct kvm_memslots *slots;
+
+	slots = rcu_dereference(kvm->memslots);
 
-	/*
-	 * If mmap_sem isn't taken, we can look the memslots with only
-	 * the mmu_lock by skipping over the slots with userspace_addr == 0.
-	 */
 	for (i = 0; i < slots->nmemslots; i++) {
 		struct kvm_memory_slot *memslot = &slots->memslots[i];
 		unsigned long start = memslot->userspace_addr;
 		unsigned long end;
 
-		/* mmu_lock protects userspace_addr */
-		if (!start)
-			continue;
-
 		end = start + (memslot->npages << PAGE_SHIFT);
 		if (hva >= start && hva < end) {
 			gfn_t gfn_offset = (hva - start) >> PAGE_SHIFT;
@@ -1617,7 +1612,7 @@ static void mmu_unshadow(struct kvm *kvm, gfn_t gfn)
 
 static void page_header_update_slot(struct kvm *kvm, void *pte, gfn_t gfn)
 {
-	int slot = memslot_id(kvm, gfn_to_memslot(kvm, gfn));
+	int slot = memslot_id(kvm, gfn);
 	struct kvm_mmu_page *sp = page_header(__pa(pte));
 
 	__set_bit(slot, sp->slot_bitmap);
@@ -3021,9 +3016,11 @@ unsigned int kvm_mmu_calculate_mmu_pages(struct kvm *kvm)
 	int i;
 	unsigned int nr_mmu_pages;
 	unsigned int  nr_pages = 0;
+	struct kvm_memslots *slots;
 
-	for (i = 0; i < kvm->memslots->nmemslots; i++)
-		nr_pages += kvm->memslots->memslots[i].npages;
+	slots = rcu_dereference(kvm->memslots);
+	for (i = 0; i < slots->nmemslots; i++)
+		nr_pages += slots->memslots[i].npages;
 
 	nr_mmu_pages = nr_pages * KVM_PERMILLE_MMU_PAGES / 1000;
 	nr_mmu_pages = max(nr_mmu_pages,
@@ -3293,10 +3290,12 @@ static void audit_mappings(struct kvm_vcpu *vcpu)
 static int count_rmaps(struct kvm_vcpu *vcpu)
 {
 	int nmaps = 0;
-	int i, j, k;
+	int i, j, k, idx;
 
+	idx = srcu_read_lock(&kvm->srcu);
+	slots = rcu_dereference(kvm->memslots);
 	for (i = 0; i < KVM_MEMORY_SLOTS; ++i) {
-		struct kvm_memory_slot *m = &vcpu->kvm->memslots->memslots[i];
+		struct kvm_memory_slot *m = &slots->memslots[i];
 		struct kvm_rmap_desc *d;
 
 		for (j = 0; j < m->npages; ++j) {
@@ -3319,6 +3318,7 @@ static int count_rmaps(struct kvm_vcpu *vcpu)
 			}
 		}
 	}
+	srcu_read_unlock(&kvm->srcu, idx);
 	return nmaps;
 }
 
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 1869879..f1cae7d 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1503,7 +1503,11 @@ static void enter_pmode(struct kvm_vcpu *vcpu)
 static gva_t rmode_tss_base(struct kvm *kvm)
 {
 	if (!kvm->arch.tss_addr) {
-		gfn_t base_gfn = kvm->memslots->memslots[0].base_gfn +
+		struct kvm_memslots *slots;
+		gfn_t base_gfn;
+
+		slots = rcu_dereference(kvm->memslots);
+		base_gfn = kvm->memslots->memslots[0].base_gfn +
 				 kvm->memslots->memslots[0].npages - 3;
 		return base_gfn << PAGE_SHIFT;
 	}
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index a24de0b..f2feef6 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -103,7 +103,7 @@ struct kvm_userspace_memory_region {
 
 /* for kvm_memory_region::flags */
 #define KVM_MEM_LOG_DIRTY_PAGES  1UL
-
+#define KVM_MEMSLOT_INVALID      (1UL << 1)
 
 /* for KVM_IRQ_LINE */
 struct kvm_irq_level {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9af2403..93bd307 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -162,6 +162,7 @@ struct kvm {
 	struct rw_semaphore slots_lock;
 	struct mm_struct *mm; /* userspace tied to this vm */
 	struct kvm_memslots *memslots;
+	struct srcu_struct srcu;
 #ifdef CONFIG_KVM_APIC_ARCHITECTURE
 	u32 bsp_vcpu_id;
 	struct kvm_vcpu *bsp_vcpu;
@@ -275,6 +276,7 @@ void kvm_set_page_accessed(struct page *page);
 pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t gfn);
 pfn_t gfn_to_pfn_memslot(struct kvm *kvm,
 			 struct kvm_memory_slot *slot, gfn_t gfn);
+int memslot_id(struct kvm *kvm, gfn_t gfn);
 void kvm_release_pfn_dirty(pfn_t);
 void kvm_release_pfn_clean(pfn_t pfn);
 void kvm_set_pfn_dirty(pfn_t pfn);
@@ -490,11 +492,6 @@ static inline void kvm_guest_exit(void)
 	current->flags &= ~PF_VCPU;
 }
 
-static inline int memslot_id(struct kvm *kvm, struct kvm_memory_slot *slot)
-{
-	return slot - kvm->memslots->memslots;
-}
-
 static inline gpa_t gfn_to_gpa(gfn_t gfn)
 {
 	return (gpa_t)gfn << PAGE_SHIFT;
diff --git a/virt/kvm/assigned-dev.c b/virt/kvm/assigned-dev.c
index f73de63..f51e684 100644
--- a/virt/kvm/assigned-dev.c
+++ b/virt/kvm/assigned-dev.c
@@ -504,12 +504,12 @@ out:
 static int kvm_vm_ioctl_assign_device(struct kvm *kvm,
 				      struct kvm_assigned_pci_dev *assigned_dev)
 {
-	int r = 0;
+	int r = 0, idx;
 	struct kvm_assigned_dev_kernel *match;
 	struct pci_dev *dev;
 
 	mutex_lock(&kvm->lock);
-	down_read(&kvm->slots_lock);
+	idx = srcu_read_lock(&kvm->srcu);
 
 	match = kvm_find_assigned_dev(&kvm->arch.assigned_dev_head,
 				      assigned_dev->assigned_dev_id);
@@ -573,7 +573,7 @@ static int kvm_vm_ioctl_assign_device(struct kvm *kvm,
 	}
 
 out:
-	up_read(&kvm->slots_lock);
+	srcu_read_unlock(&kvm->srcu, idx);
 	mutex_unlock(&kvm->lock);
 	return r;
 out_list_del:
@@ -585,7 +585,7 @@ out_put:
 	pci_dev_put(dev);
 out_free:
 	kfree(match);
-	up_read(&kvm->slots_lock);
+	srcu_read_unlock(&kvm->srcu, idx);
 	mutex_unlock(&kvm->lock);
 	return r;
 }
diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
index cf567d8..65a5143 100644
--- a/virt/kvm/iommu.c
+++ b/virt/kvm/iommu.c
@@ -78,7 +78,7 @@ static int kvm_iommu_map_memslots(struct kvm *kvm)
 	int i, r = 0;
 	struct kvm_memslots *slots;
 
-	slots = kvm->memslots;
+	slots = rcu_dereference(kvm->memslots);
 
 	for (i = 0; i < slots->nmemslots; i++) {
 		r = kvm_iommu_map_pages(kvm, &slots->memslots[i]);
@@ -214,7 +214,7 @@ static int kvm_iommu_unmap_memslots(struct kvm *kvm)
 	int i;
 	struct kvm_memslots *slots;
 
-	slots = kvm->memslots;
+	slots = rcu_dereference(kvm->memslots);
 
 	for (i = 0; i < slots->nmemslots; i++) {
 		kvm_iommu_put_pages(kvm, slots->memslots[i].base_gfn,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 87d296d..2bb24a8 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -44,6 +44,7 @@
 #include <linux/bitops.h>
 #include <linux/spinlock.h>
 #include <linux/compat.h>
+#include <linux/srcu.h>
 
 #include <asm/processor.h>
 #include <asm/io.h>
@@ -213,7 +214,7 @@ static void kvm_mmu_notifier_invalidate_page(struct mmu_notifier *mn,
 					     unsigned long address)
 {
 	struct kvm *kvm = mmu_notifier_to_kvm(mn);
-	int need_tlb_flush;
+	int need_tlb_flush, idx;
 
 	/*
 	 * When ->invalidate_page runs, the linux pte has been zapped
@@ -233,10 +234,12 @@ static void kvm_mmu_notifier_invalidate_page(struct mmu_notifier *mn,
 	 * pte after kvm_unmap_hva returned, without noticing the page
 	 * is going to be freed.
 	 */
+	idx = srcu_read_lock(&kvm->srcu);
 	spin_lock(&kvm->mmu_lock);
 	kvm->mmu_notifier_seq++;
 	need_tlb_flush = kvm_unmap_hva(kvm, address);
 	spin_unlock(&kvm->mmu_lock);
+	srcu_read_unlock(&kvm->srcu, idx);
 
 	/* we've to flush the tlb before the pages can be freed */
 	if (need_tlb_flush)
@@ -250,11 +253,14 @@ static void kvm_mmu_notifier_change_pte(struct mmu_notifier *mn,
 					pte_t pte)
 {
 	struct kvm *kvm = mmu_notifier_to_kvm(mn);
+	int idx;
 
+	idx = srcu_read_lock(&kvm->srcu);
 	spin_lock(&kvm->mmu_lock);
 	kvm->mmu_notifier_seq++;
 	kvm_set_spte_hva(kvm, address, pte);
 	spin_unlock(&kvm->mmu_lock);
+	srcu_read_unlock(&kvm->srcu, idx);
 }
 
 static void kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
@@ -263,8 +269,9 @@ static void kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 						    unsigned long end)
 {
 	struct kvm *kvm = mmu_notifier_to_kvm(mn);
-	int need_tlb_flush = 0;
+	int need_tlb_flush = 0, idx;
 
+	idx = srcu_read_lock(&kvm->srcu);
 	spin_lock(&kvm->mmu_lock);
 	/*
 	 * The count increase must become visible at unlock time as no
@@ -275,6 +282,7 @@ static void kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 	for (; start < end; start += PAGE_SIZE)
 		need_tlb_flush |= kvm_unmap_hva(kvm, start);
 	spin_unlock(&kvm->mmu_lock);
+	srcu_read_unlock(&kvm->srcu, idx);
 
 	/* we've to flush the tlb before the pages can be freed */
 	if (need_tlb_flush)
@@ -312,11 +320,13 @@ static int kvm_mmu_notifier_clear_flush_young(struct mmu_notifier *mn,
 					      unsigned long address)
 {
 	struct kvm *kvm = mmu_notifier_to_kvm(mn);
-	int young;
+	int young, idx;
 
+	idx = srcu_read_lock(&kvm->srcu);
 	spin_lock(&kvm->mmu_lock);
 	young = kvm_age_hva(kvm, address);
 	spin_unlock(&kvm->mmu_lock);
+	srcu_read_unlock(&kvm->srcu, idx);
 
 	if (young)
 		kvm_flush_remote_tlbs(kvm);
@@ -379,11 +389,15 @@ static struct kvm *kvm_create_vm(void)
 	kvm->memslots = kzalloc(sizeof(struct kvm_memslots), GFP_KERNEL);
 	if (!kvm->memslots)
 		goto out_err;
+	if (init_srcu_struct(&kvm->srcu))
+		goto out_err;
 
 #ifdef KVM_COALESCED_MMIO_PAGE_OFFSET
 	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
-	if (!page)
+	if (!page) {
+		cleanup_srcu_struct(&kvm->srcu);
 		goto out_err;
+	}
 
 	kvm->coalesced_mmio_ring =
 			(struct kvm_coalesced_mmio_ring *)page_address(page);
@@ -391,6 +405,7 @@ static struct kvm *kvm_create_vm(void)
 
 	r = kvm_init_mmu_notifier(kvm);
 	if (r) {
+		cleanup_srcu_struct(&kvm->srcu);
 #ifdef KVM_COALESCED_MMIO_PAGE_OFFSET
 		put_page(page);
 #endif
@@ -480,6 +495,7 @@ static void kvm_destroy_vm(struct kvm *kvm)
 #else
 	kvm_arch_flush_shadow(kvm);
 #endif
+	cleanup_srcu_struct(&kvm->srcu);
 	kvm_arch_destroy_vm(kvm);
 	hardware_disable_all();
 	mmdrop(mm);
@@ -521,12 +537,13 @@ int __kvm_set_memory_region(struct kvm *kvm,
 			    struct kvm_userspace_memory_region *mem,
 			    int user_alloc)
 {
-	int r;
+	int r, flush_shadow = 0;
 	gfn_t base_gfn;
 	unsigned long npages;
 	unsigned long i;
 	struct kvm_memory_slot *memslot;
 	struct kvm_memory_slot old, new;
+	struct kvm_memslots *slots, *old_memslots;
 
 	r = -EINVAL;
 	/* General sanity checks */
@@ -588,15 +605,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		memset(new.rmap, 0, npages * sizeof(*new.rmap));
 
 		new.user_alloc = user_alloc;
-		/*
-		 * hva_to_rmmap() serialzies with the mmu_lock and to be
-		 * safe it has to ignore memslots with !user_alloc &&
-		 * !userspace_addr.
-		 */
-		if (user_alloc)
-			new.userspace_addr = mem->userspace_addr;
-		else
-			new.userspace_addr = 0;
+		new.userspace_addr = mem->userspace_addr;
 	}
 	if (!npages)
 		goto skip_lpage;
@@ -651,8 +660,9 @@ skip_lpage:
 		if (!new.dirty_bitmap)
 			goto out_free;
 		memset(new.dirty_bitmap, 0, dirty_bytes);
+		/* destroy any largepage mappings for dirty tracking */
 		if (old.npages)
-			kvm_arch_flush_shadow(kvm);
+			flush_shadow = 1;
 	}
 #else  /* not defined CONFIG_S390 */
 	new.user_alloc = user_alloc;
@@ -660,34 +670,72 @@ skip_lpage:
 		new.userspace_addr = mem->userspace_addr;
 #endif /* not defined CONFIG_S390 */
 
-	if (!npages)
+	if (!npages) {
+		r = -ENOMEM;
+		slots = kzalloc(sizeof(struct kvm_memslots), GFP_KERNEL);
+		if (!slots)
+			goto out_free;
+		memcpy(slots, kvm->memslots, sizeof(struct kvm_memslots));
+		if (mem->slot >= slots->nmemslots)
+			slots->nmemslots = mem->slot + 1;
+		slots->memslots[mem->slot].flags |= KVM_MEMSLOT_INVALID;
+
+		old_memslots = kvm->memslots;
+		rcu_assign_pointer(kvm->memslots, slots);
+		synchronize_srcu_expedited(&kvm->srcu);
+		/* From this point no new shadow pages pointing to a deleted
+		 * memslot will be created.
+		 *
+		 * validation of sp->gfn happens in:
+		 * 	- gfn_to_hva (kvm_read_guest, gfn_to_pfn)
+		 * 	- kvm_is_visible_gfn (mmu_check_roots)
+		 */
 		kvm_arch_flush_shadow(kvm);
+		kfree(old_memslots);
+	}
 
 	r = kvm_arch_prepare_memory_region(kvm, &new, old, mem, user_alloc);
 	if (r)
 		goto out_free;
 
-	spin_lock(&kvm->mmu_lock);
-	if (mem->slot >= kvm->memslots->nmemslots)
-		kvm->memslots->nmemslots = mem->slot + 1;
+#ifdef CONFIG_DMAR
+	/* map the pages in iommu page table */
+	if (npages) {
+		r = kvm_iommu_map_pages(kvm, &new);
+		if (r)
+			goto out_free;
+	}
+#endif
 
-	*memslot = new;
-	spin_unlock(&kvm->mmu_lock);
+	r = -ENOMEM;
+	slots = kzalloc(sizeof(struct kvm_memslots), GFP_KERNEL);
+	if (!slots)
+		goto out_free;
+	memcpy(slots, kvm->memslots, sizeof(struct kvm_memslots));
+	if (mem->slot >= slots->nmemslots)
+		slots->nmemslots = mem->slot + 1;
+
+	/* actual memory is freed via old in kvm_free_physmem_slot below */
+	if (!npages) {
+		new.rmap = NULL;
+		new.dirty_bitmap = NULL;
+		for (i = 0; i < KVM_NR_PAGE_SIZES - 1; ++i)
+			new.lpage_info[i] = NULL;
+	}
+
+	slots->memslots[mem->slot] = new;
+	old_memslots = kvm->memslots;
+	rcu_assign_pointer(kvm->memslots, slots);
+	synchronize_srcu_expedited(&kvm->srcu);
 
 	kvm_arch_commit_memory_region(kvm, mem, old, user_alloc);
 
-	kvm_free_physmem_slot(&old, npages ? &new : NULL);
-	/* Slot deletion case: we have to update the current slot */
-	spin_lock(&kvm->mmu_lock);
-	if (!npages)
-		*memslot = old;
-	spin_unlock(&kvm->mmu_lock);
-#ifdef CONFIG_DMAR
-	/* map the pages in iommu page table */
-	r = kvm_iommu_map_pages(kvm, memslot);
-	if (r)
-		goto out;
-#endif
+	kvm_free_physmem_slot(&old, &new);
+	kfree(old_memslots);
+
+	if (flush_shadow)
+		kvm_arch_flush_shadow(kvm);
+
 	return 0;
 
 out_free:
@@ -787,7 +835,7 @@ EXPORT_SYMBOL_GPL(kvm_is_error_hva);
 struct kvm_memory_slot *gfn_to_memslot_unaliased(struct kvm *kvm, gfn_t gfn)
 {
 	int i;
-	struct kvm_memslots *slots = kvm->memslots;
+	struct kvm_memslots *slots = rcu_dereference(kvm->memslots);
 
 	for (i = 0; i < slots->nmemslots; ++i) {
 		struct kvm_memory_slot *memslot = &slots->memslots[i];
@@ -809,12 +857,15 @@ struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn)
 int kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn)
 {
 	int i;
-	struct kvm_memslots *slots = kvm->memslots;
+	struct kvm_memslots *slots = rcu_dereference(kvm->memslots);
 
 	gfn = unalias_gfn(kvm, gfn);
 	for (i = 0; i < KVM_MEMORY_SLOTS; ++i) {
 		struct kvm_memory_slot *memslot = &slots->memslots[i];
 
+		if (memslot->flags & KVM_MEMSLOT_INVALID)
+			continue;
+
 		if (gfn >= memslot->base_gfn
 		    && gfn < memslot->base_gfn + memslot->npages)
 			return 1;
@@ -823,13 +874,31 @@ int kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn)
 }
 EXPORT_SYMBOL_GPL(kvm_is_visible_gfn);
 
+int memslot_id(struct kvm *kvm, gfn_t gfn)
+{
+	int i;
+	struct kvm_memslots *slots = rcu_dereference(kvm->memslots);
+	struct kvm_memory_slot *memslot = NULL;
+
+	gfn = unalias_gfn(kvm, gfn);
+	for (i = 0; i < slots->nmemslots; ++i) {
+		memslot = &slots->memslots[i];
+
+		if (gfn >= memslot->base_gfn
+		    && gfn < memslot->base_gfn + memslot->npages)
+			break;
+	}
+
+	return memslot - slots->memslots;
+}
+
 unsigned long gfn_to_hva(struct kvm *kvm, gfn_t gfn)
 {
 	struct kvm_memory_slot *slot;
 
 	gfn = unalias_gfn(kvm, gfn);
 	slot = gfn_to_memslot_unaliased(kvm, gfn);
-	if (!slot)
+	if (!slot || slot->flags & KVM_MEMSLOT_INVALID)
 		return bad_hva();
 	return (slot->userspace_addr + (gfn - slot->base_gfn) * PAGE_SIZE);
 }
-- 
1.6.5.3

