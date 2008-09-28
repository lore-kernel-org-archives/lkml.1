Return-Path: <linux-kernel-owner+w=401wt.eu-S1754984AbYI1PvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984AbYI1PvZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 11:51:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753416AbYI1Pp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 11:45:56 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50890 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753395AbYI1Ppy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 11:45:54 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 23/25] KVM: switch to get_user_pages_fast
Date: Sun, 28 Sep 2008 18:44:59 +0300
Message-Id: <1222616701-1206-24-git-send-email-avi@redhat.com>
In-Reply-To: <1222616701-1206-1-git-send-email-avi@redhat.com>
References: <1222616701-1206-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

Convert gfn_to_pfn to use get_user_pages_fast, which can do lockless
pagetable lookups on x86. Kernel compilation on 4-way guest is 3.7%
faster on VMX.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/kvm/44x_tlb.c |    2 --
 arch/x86/kvm/mmu.c         |   23 +++++++++--------------
 arch/x86/kvm/paging_tmpl.h |    8 +-------
 arch/x86/kvm/vmx.c         |    4 ----
 arch/x86/kvm/x86.c         |    6 ------
 virt/kvm/kvm_main.c        |   10 +++++-----
 6 files changed, 15 insertions(+), 38 deletions(-)

diff --git a/arch/powerpc/kvm/44x_tlb.c b/arch/powerpc/kvm/44x_tlb.c
index 7b11fd7..2e227a4 100644
--- a/arch/powerpc/kvm/44x_tlb.c
+++ b/arch/powerpc/kvm/44x_tlb.c
@@ -147,9 +147,7 @@ void kvmppc_mmu_map(struct kvm_vcpu *vcpu, u64 gvaddr, gfn_t gfn, u64 asid,
 	stlbe = &vcpu->arch.shadow_tlb[victim];
 
 	/* Get reference to new page. */
-	down_read(&current->mm->mmap_sem);
 	new_page = gfn_to_page(vcpu->kvm, gfn);
-	up_read(&current->mm->mmap_sem);
 	if (is_error_page(new_page)) {
 		printk(KERN_ERR "Couldn't get guest page for gfn %lx!\n", gfn);
 		kvm_release_page_clean(new_page);
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index bce3e25..5779a23 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -405,16 +405,19 @@ static int host_largepage_backed(struct kvm *kvm, gfn_t gfn)
 {
 	struct vm_area_struct *vma;
 	unsigned long addr;
+	int ret = 0;
 
 	addr = gfn_to_hva(kvm, gfn);
 	if (kvm_is_error_hva(addr))
-		return 0;
+		return ret;
 
+	down_read(&current->mm->mmap_sem);
 	vma = find_vma(current->mm, addr);
 	if (vma && is_vm_hugetlb_page(vma))
-		return 1;
+		ret = 1;
+	up_read(&current->mm->mmap_sem);
 
-	return 0;
+	return ret;
 }
 
 static int is_largepage_backed(struct kvm_vcpu *vcpu, gfn_t large_gfn)
@@ -1140,9 +1143,7 @@ struct page *gva_to_page(struct kvm_vcpu *vcpu, gva_t gva)
 	if (gpa == UNMAPPED_GVA)
 		return NULL;
 
-	down_read(&current->mm->mmap_sem);
 	page = gfn_to_page(vcpu->kvm, gpa >> PAGE_SHIFT);
-	up_read(&current->mm->mmap_sem);
 
 	return page;
 }
@@ -1330,16 +1331,14 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn)
 	pfn_t pfn;
 	unsigned long mmu_seq;
 
-	down_read(&current->mm->mmap_sem);
 	if (is_largepage_backed(vcpu, gfn & ~(KVM_PAGES_PER_HPAGE-1))) {
 		gfn &= ~(KVM_PAGES_PER_HPAGE-1);
 		largepage = 1;
 	}
 
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
-	/* implicit mb(), we'll read before PT lock is unlocked */
+	smp_rmb();
 	pfn = gfn_to_pfn(vcpu->kvm, gfn);
-	up_read(&current->mm->mmap_sem);
 
 	/* mmio */
 	if (is_error_pfn(pfn)) {
@@ -1488,15 +1487,13 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa,
 	if (r)
 		return r;
 
-	down_read(&current->mm->mmap_sem);
 	if (is_largepage_backed(vcpu, gfn & ~(KVM_PAGES_PER_HPAGE-1))) {
 		gfn &= ~(KVM_PAGES_PER_HPAGE-1);
 		largepage = 1;
 	}
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
-	/* implicit mb(), we'll read before PT lock is unlocked */
+	smp_rmb();
 	pfn = gfn_to_pfn(vcpu->kvm, gfn);
-	up_read(&current->mm->mmap_sem);
 	if (is_error_pfn(pfn)) {
 		kvm_release_pfn_clean(pfn);
 		return 1;
@@ -1809,15 +1806,13 @@ static void mmu_guess_page_from_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 		return;
 	gfn = (gpte & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT;
 
-	down_read(&current->mm->mmap_sem);
 	if (is_large_pte(gpte) && is_largepage_backed(vcpu, gfn)) {
 		gfn &= ~(KVM_PAGES_PER_HPAGE-1);
 		vcpu->arch.update_pte.largepage = 1;
 	}
 	vcpu->arch.update_pte.mmu_seq = vcpu->kvm->mmu_notifier_seq;
-	/* implicit mb(), we'll read before PT lock is unlocked */
+	smp_rmb();
 	pfn = gfn_to_pfn(vcpu->kvm, gfn);
-	up_read(&current->mm->mmap_sem);
 
 	if (is_error_pfn(pfn)) {
 		kvm_release_pfn_clean(pfn);
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index b671f61..6dd08e0 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -102,14 +102,10 @@ static bool FNAME(cmpxchg_gpte)(struct kvm *kvm,
 	pt_element_t *table;
 	struct page *page;
 
-	down_read(&current->mm->mmap_sem);
 	page = gfn_to_page(kvm, table_gfn);
-	up_read(&current->mm->mmap_sem);
 
 	table = kmap_atomic(page, KM_USER0);
-
 	ret = CMPXCHG(&table[index], orig_pte, new_pte);
-
 	kunmap_atomic(table, KM_USER0);
 
 	kvm_release_page_dirty(page);
@@ -418,7 +414,6 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
 		return 0;
 	}
 
-	down_read(&current->mm->mmap_sem);
 	if (walker.level == PT_DIRECTORY_LEVEL) {
 		gfn_t large_gfn;
 		large_gfn = walker.gfn & ~(KVM_PAGES_PER_HPAGE-1);
@@ -428,9 +423,8 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
 		}
 	}
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
-	/* implicit mb(), we'll read before PT lock is unlocked */
+	smp_rmb();
 	pfn = gfn_to_pfn(vcpu->kvm, walker.gfn);
-	up_read(&current->mm->mmap_sem);
 
 	/* mmio */
 	if (is_error_pfn(pfn)) {
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 046a91b..025bf40 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2010,9 +2010,7 @@ static int alloc_apic_access_page(struct kvm *kvm)
 	if (r)
 		goto out;
 
-	down_read(&current->mm->mmap_sem);
 	kvm->arch.apic_access_page = gfn_to_page(kvm, 0xfee00);
-	up_read(&current->mm->mmap_sem);
 out:
 	up_write(&kvm->slots_lock);
 	return r;
@@ -2034,10 +2032,8 @@ static int alloc_identity_pagetable(struct kvm *kvm)
 	if (r)
 		goto out;
 
-	down_read(&current->mm->mmap_sem);
 	kvm->arch.ept_identity_pagetable = gfn_to_page(kvm,
 			VMX_EPT_IDENTITY_PAGETABLE_ADDR >> PAGE_SHIFT);
-	up_read(&current->mm->mmap_sem);
 out:
 	up_write(&kvm->slots_lock);
 	return r;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 61eddbe..108f072 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -946,10 +946,8 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 		/* ...but clean it before doing the actual write */
 		vcpu->arch.time_offset = data & ~(PAGE_MASK | 1);
 
-		down_read(&current->mm->mmap_sem);
 		vcpu->arch.time_page =
 				gfn_to_page(vcpu->kvm, data >> PAGE_SHIFT);
-		up_read(&current->mm->mmap_sem);
 
 		if (is_error_page(vcpu->arch.time_page)) {
 			kvm_release_page_clean(vcpu->arch.time_page);
@@ -2322,9 +2320,7 @@ static int emulator_cmpxchg_emulated(unsigned long addr,
 
 		val = *(u64 *)new;
 
-		down_read(&current->mm->mmap_sem);
 		page = gfn_to_page(vcpu->kvm, gpa >> PAGE_SHIFT);
-		up_read(&current->mm->mmap_sem);
 
 		kaddr = kmap_atomic(page, KM_USER0);
 		set_64bit((u64 *)(kaddr + offset_in_page(gpa)), val);
@@ -3089,9 +3085,7 @@ static void vapic_enter(struct kvm_vcpu *vcpu)
 	if (!apic || !apic->vapic_addr)
 		return;
 
-	down_read(&current->mm->mmap_sem);
 	page = gfn_to_page(vcpu->kvm, apic->vapic_addr >> PAGE_SHIFT);
-	up_read(&current->mm->mmap_sem);
 
 	vcpu->arch.apic->vapic_page = page;
 }
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2907d05..cd34f73 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -723,9 +723,6 @@ unsigned long gfn_to_hva(struct kvm *kvm, gfn_t gfn)
 }
 EXPORT_SYMBOL_GPL(gfn_to_hva);
 
-/*
- * Requires current->mm->mmap_sem to be held
- */
 pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t gfn)
 {
 	struct page *page[1];
@@ -741,20 +738,23 @@ pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t gfn)
 		return page_to_pfn(bad_page);
 	}
 
-	npages = get_user_pages(current, current->mm, addr, 1, 1, 0, page,
-				NULL);
+	npages = get_user_pages_fast(addr, 1, 1, page);
 
 	if (unlikely(npages != 1)) {
 		struct vm_area_struct *vma;
 
+		down_read(&current->mm->mmap_sem);
 		vma = find_vma(current->mm, addr);
+
 		if (vma == NULL || addr < vma->vm_start ||
 		    !(vma->vm_flags & VM_PFNMAP)) {
+			up_read(&current->mm->mmap_sem);
 			get_page(bad_page);
 			return page_to_pfn(bad_page);
 		}
 
 		pfn = ((addr - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
+		up_read(&current->mm->mmap_sem);
 		BUG_ON(!is_mmio_pfn(pfn));
 	} else
 		pfn = page_to_pfn(page[0]);
-- 
1.6.0.1

