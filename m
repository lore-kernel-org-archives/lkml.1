Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab0BJRZy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 12:25:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36036 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755756Ab0BJRXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 12:23:14 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 26/40] KVM: modify memslots layout in struct kvm
Date: Wed, 10 Feb 2010 19:22:55 +0200
Message-Id: <1265822589-11155-27-git-send-email-avi@redhat.com>
In-Reply-To: <1265822589-11155-1-git-send-email-avi@redhat.com>
References: <1265822589-11155-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

Have a pointer to an allocated region inside struct kvm.

[alex: fix ppc book 3s]

Signed-off-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/ia64/kvm/kvm-ia64.c  |   10 ++++++----
 arch/powerpc/kvm/book3s.c |    2 +-
 arch/x86/kvm/mmu.c        |   11 ++++++-----
 arch/x86/kvm/vmx.c        |    4 ++--
 arch/x86/kvm/x86.c        |    4 ++--
 include/linux/kvm_host.h  |   12 ++++++++----
 virt/kvm/iommu.c          |   18 ++++++++++++------
 virt/kvm/kvm_main.c       |   36 +++++++++++++++++++++++-------------
 8 files changed, 60 insertions(+), 37 deletions(-)

diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index 5fdeec5..1ca1dbf 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -1377,12 +1377,14 @@ static void free_kvm(struct kvm *kvm)
 
 static void kvm_release_vm_pages(struct kvm *kvm)
 {
+	struct kvm_memslots *slots;
 	struct kvm_memory_slot *memslot;
 	int i, j;
 	unsigned long base_gfn;
 
-	for (i = 0; i < kvm->nmemslots; i++) {
-		memslot = &kvm->memslots[i];
+	slots = kvm->memslots;
+	for (i = 0; i < slots->nmemslots; i++) {
+		memslot = &slots->memslots[i];
 		base_gfn = memslot->base_gfn;
 
 		for (j = 0; j < memslot->npages; j++) {
@@ -1802,7 +1804,7 @@ static int kvm_ia64_sync_dirty_log(struct kvm *kvm,
 	if (log->slot >= KVM_MEMORY_SLOTS)
 		goto out;
 
-	memslot = &kvm->memslots[log->slot];
+	memslot = &kvm->memslots->memslots[log->slot];
 	r = -ENOENT;
 	if (!memslot->dirty_bitmap)
 		goto out;
@@ -1840,7 +1842,7 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 	/* If nothing is dirty, don't bother messing with page tables. */
 	if (is_dirty) {
 		kvm_flush_remote_tlbs(kvm);
-		memslot = &kvm->memslots[log->slot];
+		memslot = &kvm->memslots->memslots[log->slot];
 		n = ALIGN(memslot->npages, BITS_PER_LONG) / 8;
 		memset(memslot->dirty_bitmap, 0, n);
 	}
diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index 803505d..bb8873d 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -865,7 +865,7 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 
 	/* If nothing is dirty, don't bother messing with page tables. */
 	if (is_dirty) {
-		memslot = &kvm->memslots[log->slot];
+		memslot = &kvm->memslots->memslots[log->slot];
 
 		ga = memslot->base_gfn << PAGE_SHIFT;
 		ga_end = ga + (memslot->npages << PAGE_SHIFT);
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 4f499d7..81f84d3 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -807,13 +807,14 @@ static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
 {
 	int i, j;
 	int retval = 0;
+	struct kvm_memslots *slots = kvm->memslots;
 
 	/*
 	 * If mmap_sem isn't taken, we can look the memslots with only
 	 * the mmu_lock by skipping over the slots with userspace_addr == 0.
 	 */
-	for (i = 0; i < kvm->nmemslots; i++) {
-		struct kvm_memory_slot *memslot = &kvm->memslots[i];
+	for (i = 0; i < slots->nmemslots; i++) {
+		struct kvm_memory_slot *memslot = &slots->memslots[i];
 		unsigned long start = memslot->userspace_addr;
 		unsigned long end;
 
@@ -3021,8 +3022,8 @@ unsigned int kvm_mmu_calculate_mmu_pages(struct kvm *kvm)
 	unsigned int nr_mmu_pages;
 	unsigned int  nr_pages = 0;
 
-	for (i = 0; i < kvm->nmemslots; i++)
-		nr_pages += kvm->memslots[i].npages;
+	for (i = 0; i < kvm->memslots->nmemslots; i++)
+		nr_pages += kvm->memslots->memslots[i].npages;
 
 	nr_mmu_pages = nr_pages * KVM_PERMILLE_MMU_PAGES / 1000;
 	nr_mmu_pages = max(nr_mmu_pages,
@@ -3295,7 +3296,7 @@ static int count_rmaps(struct kvm_vcpu *vcpu)
 	int i, j, k;
 
 	for (i = 0; i < KVM_MEMORY_SLOTS; ++i) {
-		struct kvm_memory_slot *m = &vcpu->kvm->memslots[i];
+		struct kvm_memory_slot *m = &vcpu->kvm->memslots->memslots[i];
 		struct kvm_rmap_desc *d;
 
 		for (j = 0; j < m->npages; ++j) {
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 74a66f0..1869879 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1503,8 +1503,8 @@ static void enter_pmode(struct kvm_vcpu *vcpu)
 static gva_t rmode_tss_base(struct kvm *kvm)
 {
 	if (!kvm->arch.tss_addr) {
-		gfn_t base_gfn = kvm->memslots[0].base_gfn +
-				 kvm->memslots[0].npages - 3;
+		gfn_t base_gfn = kvm->memslots->memslots[0].base_gfn +
+				 kvm->memslots->memslots[0].npages - 3;
 		return base_gfn << PAGE_SHIFT;
 	}
 	return kvm->arch.tss_addr;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1bdcf26..f8e2712 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2428,7 +2428,7 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 		spin_lock(&kvm->mmu_lock);
 		kvm_mmu_slot_remove_write_access(kvm, log->slot);
 		spin_unlock(&kvm->mmu_lock);
-		memslot = &kvm->memslots[log->slot];
+		memslot = &kvm->memslots->memslots[log->slot];
 		n = ALIGN(memslot->npages, BITS_PER_LONG) / 8;
 		memset(memslot->dirty_bitmap, 0, n);
 	}
@@ -5224,7 +5224,7 @@ int kvm_arch_set_memory_region(struct kvm *kvm,
 				int user_alloc)
 {
 	int npages = mem->memory_size >> PAGE_SHIFT;
-	struct kvm_memory_slot *memslot = &kvm->memslots[mem->slot];
+	struct kvm_memory_slot *memslot = &kvm->memslots->memslots[mem->slot];
 
 	/*To keep backward compatibility with older userspace,
 	 *x86 needs to hanlde !user_alloc case.
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index bd5a616..782bfb1 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -150,14 +150,18 @@ struct kvm_irq_routing_table {};
 
 #endif
 
+struct kvm_memslots {
+	int nmemslots;
+	struct kvm_memory_slot memslots[KVM_MEMORY_SLOTS +
+					KVM_PRIVATE_MEM_SLOTS];
+};
+
 struct kvm {
 	spinlock_t mmu_lock;
 	spinlock_t requests_lock;
 	struct rw_semaphore slots_lock;
 	struct mm_struct *mm; /* userspace tied to this vm */
-	int nmemslots;
-	struct kvm_memory_slot memslots[KVM_MEMORY_SLOTS +
-					KVM_PRIVATE_MEM_SLOTS];
+	struct kvm_memslots *memslots;
 #ifdef CONFIG_KVM_APIC_ARCHITECTURE
 	u32 bsp_vcpu_id;
 	struct kvm_vcpu *bsp_vcpu;
@@ -482,7 +486,7 @@ static inline void kvm_guest_exit(void)
 
 static inline int memslot_id(struct kvm *kvm, struct kvm_memory_slot *slot)
 {
-	return slot - kvm->memslots;
+	return slot - kvm->memslots->memslots;
 }
 
 static inline gpa_t gfn_to_gpa(gfn_t gfn)
diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
index 1514758..bc697a6 100644
--- a/virt/kvm/iommu.c
+++ b/virt/kvm/iommu.c
@@ -76,10 +76,13 @@ unmap_pages:
 static int kvm_iommu_map_memslots(struct kvm *kvm)
 {
 	int i, r = 0;
+	struct kvm_memslots *slots;
 
-	for (i = 0; i < kvm->nmemslots; i++) {
-		r = kvm_iommu_map_pages(kvm, kvm->memslots[i].base_gfn,
-					kvm->memslots[i].npages);
+	slots = kvm->memslots;
+
+	for (i = 0; i < slots->nmemslots; i++) {
+		r = kvm_iommu_map_pages(kvm, slots->memslots[i].base_gfn,
+					slots->memslots[i].npages);
 		if (r)
 			break;
 	}
@@ -210,10 +213,13 @@ static void kvm_iommu_put_pages(struct kvm *kvm,
 static int kvm_iommu_unmap_memslots(struct kvm *kvm)
 {
 	int i;
+	struct kvm_memslots *slots;
+
+	slots = kvm->memslots;
 
-	for (i = 0; i < kvm->nmemslots; i++) {
-		kvm_iommu_put_pages(kvm, kvm->memslots[i].base_gfn,
-				    kvm->memslots[i].npages);
+	for (i = 0; i < slots->nmemslots; i++) {
+		kvm_iommu_put_pages(kvm, slots->memslots[i].base_gfn,
+				    slots->memslots[i].npages);
 	}
 
 	return 0;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index bc23b8e..86dd8f3 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -375,12 +375,16 @@ static struct kvm *kvm_create_vm(void)
 	INIT_HLIST_HEAD(&kvm->irq_ack_notifier_list);
 #endif
 
+	r = -ENOMEM;
+	kvm->memslots = kzalloc(sizeof(struct kvm_memslots), GFP_KERNEL);
+	if (!kvm->memslots)
+		goto out_err;
+
 #ifdef KVM_COALESCED_MMIO_PAGE_OFFSET
 	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
-	if (!page) {
-		r = -ENOMEM;
+	if (!page)
 		goto out_err;
-	}
+
 	kvm->coalesced_mmio_ring =
 			(struct kvm_coalesced_mmio_ring *)page_address(page);
 #endif
@@ -416,6 +420,7 @@ out:
 out_err:
 	hardware_disable_all();
 out_err_nodisable:
+	kfree(kvm->memslots);
 	kfree(kvm);
 	return ERR_PTR(r);
 }
@@ -450,9 +455,12 @@ static void kvm_free_physmem_slot(struct kvm_memory_slot *free,
 void kvm_free_physmem(struct kvm *kvm)
 {
 	int i;
+	struct kvm_memslots *slots = kvm->memslots;
+
+	for (i = 0; i < slots->nmemslots; ++i)
+		kvm_free_physmem_slot(&slots->memslots[i], NULL);
 
-	for (i = 0; i < kvm->nmemslots; ++i)
-		kvm_free_physmem_slot(&kvm->memslots[i], NULL);
+	kfree(kvm->memslots);
 }
 
 static void kvm_destroy_vm(struct kvm *kvm)
@@ -533,7 +541,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	if (mem->guest_phys_addr + mem->memory_size < mem->guest_phys_addr)
 		goto out;
 
-	memslot = &kvm->memslots[mem->slot];
+	memslot = &kvm->memslots->memslots[mem->slot];
 	base_gfn = mem->guest_phys_addr >> PAGE_SHIFT;
 	npages = mem->memory_size >> PAGE_SHIFT;
 
@@ -554,7 +562,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	/* Check for overlaps */
 	r = -EEXIST;
 	for (i = 0; i < KVM_MEMORY_SLOTS; ++i) {
-		struct kvm_memory_slot *s = &kvm->memslots[i];
+		struct kvm_memory_slot *s = &kvm->memslots->memslots[i];
 
 		if (s == memslot || !s->npages)
 			continue;
@@ -656,8 +664,8 @@ skip_lpage:
 		kvm_arch_flush_shadow(kvm);
 
 	spin_lock(&kvm->mmu_lock);
-	if (mem->slot >= kvm->nmemslots)
-		kvm->nmemslots = mem->slot + 1;
+	if (mem->slot >= kvm->memslots->nmemslots)
+		kvm->memslots->nmemslots = mem->slot + 1;
 
 	*memslot = new;
 	spin_unlock(&kvm->mmu_lock);
@@ -727,7 +735,7 @@ int kvm_get_dirty_log(struct kvm *kvm,
 	if (log->slot >= KVM_MEMORY_SLOTS)
 		goto out;
 
-	memslot = &kvm->memslots[log->slot];
+	memslot = &kvm->memslots->memslots[log->slot];
 	r = -ENOENT;
 	if (!memslot->dirty_bitmap)
 		goto out;
@@ -781,9 +789,10 @@ EXPORT_SYMBOL_GPL(kvm_is_error_hva);
 struct kvm_memory_slot *gfn_to_memslot_unaliased(struct kvm *kvm, gfn_t gfn)
 {
 	int i;
+	struct kvm_memslots *slots = kvm->memslots;
 
-	for (i = 0; i < kvm->nmemslots; ++i) {
-		struct kvm_memory_slot *memslot = &kvm->memslots[i];
+	for (i = 0; i < slots->nmemslots; ++i) {
+		struct kvm_memory_slot *memslot = &slots->memslots[i];
 
 		if (gfn >= memslot->base_gfn
 		    && gfn < memslot->base_gfn + memslot->npages)
@@ -802,10 +811,11 @@ struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn)
 int kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn)
 {
 	int i;
+	struct kvm_memslots *slots = kvm->memslots;
 
 	gfn = unalias_gfn(kvm, gfn);
 	for (i = 0; i < KVM_MEMORY_SLOTS; ++i) {
-		struct kvm_memory_slot *memslot = &kvm->memslots[i];
+		struct kvm_memory_slot *memslot = &slots->memslots[i];
 
 		if (gfn >= memslot->base_gfn
 		    && gfn < memslot->base_gfn + memslot->npages)
-- 
1.6.5.3

