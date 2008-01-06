Return-Path: <linux-kernel-owner+w=401wt.eu-S1760652AbYAFOtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760652AbYAFOtk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 09:49:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756917AbYAFOkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 09:40:23 -0500
Received: from il.qumranet.com ([82.166.9.18]:46618 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756130AbYAFOjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 09:39:49 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 27/33] KVM: MMU: Concurrent guest walkers
Date: Sun,  6 Jan 2008 16:39:33 +0200
Message-Id: <1199630379-28638-28-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199630379-28638-1-git-send-email-avi@qumranet.com>
References: <1199630379-28638-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

Do not hold kvm->lock mutex across the entire pagefault code,
only acquire it in places where it is necessary, such as mmu
hash list, active list, rmap and parent pte handling.

Allow concurrent guest walkers by switching walk_addr() to use
mmap_sem in read-mode.

And get rid of the lockless __gfn_to_page.

[avi: move kvm_mmu_pte_write() locking inside the function]
[avi: add locking for real mode]
[avi: fix cmpxchg locking]

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/mmu.c         |   41 ++++++++++++++++----
 arch/x86/kvm/paging_tmpl.h |    8 +++-
 arch/x86/kvm/vmx.c         |   25 ++++++++----
 arch/x86/kvm/x86.c         |   92 ++++++++++++++++++++++++++------------------
 virt/kvm/kvm_main.c        |   22 ++--------
 5 files changed, 117 insertions(+), 71 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 8f12ec5..3b91227 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -974,7 +974,7 @@ static void nonpaging_new_cr3(struct kvm_vcpu *vcpu)
 {
 }
 
-static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn)
+static int __nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn)
 {
 	int level = PT32E_ROOT_LEVEL;
 	hpa_t table_addr = vcpu->arch.mmu.root_hpa;
@@ -1015,6 +1015,17 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn)
 	}
 }
 
+static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn)
+{
+	int r;
+
+	mutex_lock(&vcpu->kvm->lock);
+	r = __nonpaging_map(vcpu, v, write, gfn);
+	mutex_unlock(&vcpu->kvm->lock);
+	return r;
+}
+
+
 static void nonpaging_prefetch_page(struct kvm_vcpu *vcpu,
 				    struct kvm_mmu_page *sp)
 {
@@ -1031,6 +1042,7 @@ static void mmu_free_roots(struct kvm_vcpu *vcpu)
 
 	if (!VALID_PAGE(vcpu->arch.mmu.root_hpa))
 		return;
+	mutex_lock(&vcpu->kvm->lock);
 #ifdef CONFIG_X86_64
 	if (vcpu->arch.mmu.shadow_root_level == PT64_ROOT_LEVEL) {
 		hpa_t root = vcpu->arch.mmu.root_hpa;
@@ -1038,6 +1050,7 @@ static void mmu_free_roots(struct kvm_vcpu *vcpu)
 		sp = page_header(root);
 		--sp->root_count;
 		vcpu->arch.mmu.root_hpa = INVALID_PAGE;
+		mutex_unlock(&vcpu->kvm->lock);
 		return;
 	}
 #endif
@@ -1051,6 +1064,7 @@ static void mmu_free_roots(struct kvm_vcpu *vcpu)
 		}
 		vcpu->arch.mmu.pae_root[i] = INVALID_PAGE;
 	}
+	mutex_unlock(&vcpu->kvm->lock);
 	vcpu->arch.mmu.root_hpa = INVALID_PAGE;
 }
 
@@ -1250,15 +1264,15 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 {
 	int r;
 
-	mutex_lock(&vcpu->kvm->lock);
 	r = mmu_topup_memory_caches(vcpu);
 	if (r)
 		goto out;
+	mutex_lock(&vcpu->kvm->lock);
 	mmu_alloc_roots(vcpu);
+	mutex_unlock(&vcpu->kvm->lock);
 	kvm_x86_ops->set_cr3(vcpu, vcpu->arch.mmu.root_hpa);
 	kvm_mmu_flush_tlb(vcpu);
 out:
-	mutex_unlock(&vcpu->kvm->lock);
 	return r;
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_load);
@@ -1353,6 +1367,7 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	int npte;
 
 	pgprintk("%s: gpa %llx bytes %d\n", __FUNCTION__, gpa, bytes);
+	mutex_lock(&vcpu->kvm->lock);
 	++vcpu->kvm->stat.mmu_pte_write;
 	kvm_mmu_audit(vcpu, "pre pte write");
 	if (gfn == vcpu->arch.last_pt_write_gfn
@@ -1421,17 +1436,27 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 		}
 	}
 	kvm_mmu_audit(vcpu, "post pte write");
+	mutex_unlock(&vcpu->kvm->lock);
 }
 
 int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva)
 {
-	gpa_t gpa = vcpu->arch.mmu.gva_to_gpa(vcpu, gva);
+	gpa_t gpa;
+	int r;
 
-	return kvm_mmu_unprotect_page(vcpu->kvm, gpa >> PAGE_SHIFT);
+	down_read(&current->mm->mmap_sem);
+	gpa = vcpu->arch.mmu.gva_to_gpa(vcpu, gva);
+	up_read(&current->mm->mmap_sem);
+
+	mutex_lock(&vcpu->kvm->lock);
+	r = kvm_mmu_unprotect_page(vcpu->kvm, gpa >> PAGE_SHIFT);
+	mutex_unlock(&vcpu->kvm->lock);
+	return r;
 }
 
 void __kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu)
 {
+	mutex_lock(&vcpu->kvm->lock);
 	while (vcpu->kvm->arch.n_free_mmu_pages < KVM_REFILL_PAGES) {
 		struct kvm_mmu_page *sp;
 
@@ -1440,6 +1465,7 @@ void __kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu)
 		kvm_mmu_zap_page(vcpu->kvm, sp);
 		++vcpu->kvm->stat.mmu_recycled;
 	}
+	mutex_unlock(&vcpu->kvm->lock);
 }
 
 int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t cr2, u32 error_code)
@@ -1447,7 +1473,6 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t cr2, u32 error_code)
 	int r;
 	enum emulation_result er;
 
-	mutex_lock(&vcpu->kvm->lock);
 	r = vcpu->arch.mmu.page_fault(vcpu, cr2, error_code);
 	if (r < 0)
 		goto out;
@@ -1462,7 +1487,6 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t cr2, u32 error_code)
 		goto out;
 
 	er = emulate_instruction(vcpu, vcpu->run, cr2, error_code, 0);
-	mutex_unlock(&vcpu->kvm->lock);
 
 	switch (er) {
 	case EMULATE_DONE:
@@ -1477,7 +1501,6 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t cr2, u32 error_code)
 		BUG();
 	}
 out:
-	mutex_unlock(&vcpu->kvm->lock);
 	return r;
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_page_fault);
@@ -1574,8 +1597,10 @@ void kvm_mmu_zap_all(struct kvm *kvm)
 {
 	struct kvm_mmu_page *sp, *node;
 
+	mutex_lock(&kvm->lock);
 	list_for_each_entry_safe(sp, node, &kvm->arch.active_mmu_pages, link)
 		kvm_mmu_zap_page(kvm, sp);
+	mutex_unlock(&kvm->lock);
 
 	kvm_flush_remote_tlbs(kvm);
 }
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 56b88f7..7f83f55 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -368,11 +368,13 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
 	if (r)
 		return r;
 
+	down_read(&current->mm->mmap_sem);
 	/*
 	 * Look up the shadow pte for the faulting address.
 	 */
 	r = FNAME(walk_addr)(&walker, vcpu, addr, write_fault, user_fault,
 			     fetch_fault);
+	up_read(&current->mm->mmap_sem);
 
 	/*
 	 * The page is not mapped by the guest.  Let the guest handle it.
@@ -384,6 +386,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
 		return 0;
 	}
 
+	mutex_lock(&vcpu->kvm->lock);
 	shadow_pte = FNAME(fetch)(vcpu, addr, &walker, user_fault, write_fault,
 				  &write_pt);
 	pgprintk("%s: shadow pte %p %llx ptwrite %d\n", __FUNCTION__,
@@ -395,11 +398,14 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
 	/*
 	 * mmio: emulate if accessible, otherwise its a guest fault.
 	 */
-	if (shadow_pte && is_io_pte(*shadow_pte))
+	if (shadow_pte && is_io_pte(*shadow_pte)) {
+		mutex_unlock(&vcpu->kvm->lock);
 		return 1;
+	}
 
 	++vcpu->stat.pf_fixed;
 	kvm_mmu_audit(vcpu, "post page fault (fixed)");
+	mutex_unlock(&vcpu->kvm->lock);
 
 	return write_pt;
 }
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index fa72f72..99fec63 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1431,27 +1431,34 @@ static int init_rmode_tss(struct kvm *kvm)
 {
 	gfn_t fn = rmode_tss_base(kvm) >> PAGE_SHIFT;
 	u16 data = 0;
+	int ret = 0;
 	int r;
 
+	down_read(&current->mm->mmap_sem);
 	r = kvm_clear_guest_page(kvm, fn, 0, PAGE_SIZE);
 	if (r < 0)
-		return 0;
+		goto out;
 	data = TSS_BASE_SIZE + TSS_REDIRECTION_SIZE;
 	r = kvm_write_guest_page(kvm, fn++, &data, 0x66, sizeof(u16));
 	if (r < 0)
-		return 0;
+		goto out;
 	r = kvm_clear_guest_page(kvm, fn++, 0, PAGE_SIZE);
 	if (r < 0)
-		return 0;
+		goto out;
 	r = kvm_clear_guest_page(kvm, fn, 0, PAGE_SIZE);
 	if (r < 0)
-		return 0;
+		goto out;
 	data = ~0;
-	r = kvm_write_guest_page(kvm, fn, &data, RMODE_TSS_SIZE - 2 * PAGE_SIZE - 1,
-			sizeof(u8));
+	r = kvm_write_guest_page(kvm, fn, &data,
+				 RMODE_TSS_SIZE - 2 * PAGE_SIZE - 1,
+				 sizeof(u8));
 	if (r < 0)
-		return 0;
-	return 1;
+		goto out;
+
+	ret = 1;
+out:
+	up_read(&current->mm->mmap_sem);
+	return ret;
 }
 
 static void seg_setup(int seg)
@@ -1470,6 +1477,7 @@ static int alloc_apic_access_page(struct kvm *kvm)
 	int r = 0;
 
 	mutex_lock(&kvm->lock);
+	down_write(&current->mm->mmap_sem);
 	if (kvm->arch.apic_access_page)
 		goto out;
 	kvm_userspace_mem.slot = APIC_ACCESS_PAGE_PRIVATE_MEMSLOT;
@@ -1481,6 +1489,7 @@ static int alloc_apic_access_page(struct kvm *kvm)
 		goto out;
 	kvm->arch.apic_access_page = gfn_to_page(kvm, 0xfee00);
 out:
+	up_write(&current->mm->mmap_sem);
 	mutex_unlock(&kvm->lock);
 	return r;
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1f48ec8..e3b3141 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -181,7 +181,7 @@ int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3)
 	int ret;
 	u64 pdpte[ARRAY_SIZE(vcpu->arch.pdptrs)];
 
-	mutex_lock(&vcpu->kvm->lock);
+	down_read(&current->mm->mmap_sem);
 	ret = kvm_read_guest_page(vcpu->kvm, pdpt_gfn, pdpte,
 				  offset * sizeof(u64), sizeof(pdpte));
 	if (ret < 0) {
@@ -198,7 +198,7 @@ int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3)
 
 	memcpy(vcpu->arch.pdptrs, pdpte, sizeof(vcpu->arch.pdptrs));
 out:
-	mutex_unlock(&vcpu->kvm->lock);
+	up_read(&current->mm->mmap_sem);
 
 	return ret;
 }
@@ -212,13 +212,13 @@ static bool pdptrs_changed(struct kvm_vcpu *vcpu)
 	if (is_long_mode(vcpu) || !is_pae(vcpu))
 		return false;
 
-	mutex_lock(&vcpu->kvm->lock);
+	down_read(&current->mm->mmap_sem);
 	r = kvm_read_guest(vcpu->kvm, vcpu->arch.cr3 & ~31u, pdpte, sizeof(pdpte));
 	if (r < 0)
 		goto out;
 	changed = memcmp(pdpte, vcpu->arch.pdptrs, sizeof(pdpte)) != 0;
 out:
-	mutex_unlock(&vcpu->kvm->lock);
+	up_read(&current->mm->mmap_sem);
 
 	return changed;
 }
@@ -278,9 +278,7 @@ void set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	kvm_x86_ops->set_cr0(vcpu, cr0);
 	vcpu->arch.cr0 = cr0;
 
-	mutex_lock(&vcpu->kvm->lock);
 	kvm_mmu_reset_context(vcpu);
-	mutex_unlock(&vcpu->kvm->lock);
 	return;
 }
 EXPORT_SYMBOL_GPL(set_cr0);
@@ -320,9 +318,7 @@ void set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 	}
 	kvm_x86_ops->set_cr4(vcpu, cr4);
 	vcpu->arch.cr4 = cr4;
-	mutex_lock(&vcpu->kvm->lock);
 	kvm_mmu_reset_context(vcpu);
-	mutex_unlock(&vcpu->kvm->lock);
 }
 EXPORT_SYMBOL_GPL(set_cr4);
 
@@ -360,7 +356,7 @@ void set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 		 */
 	}
 
-	mutex_lock(&vcpu->kvm->lock);
+	down_read(&current->mm->mmap_sem);
 	/*
 	 * Does the new cr3 value map to physical memory? (Note, we
 	 * catch an invalid cr3 even in real-mode, because it would
@@ -376,7 +372,7 @@ void set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 		vcpu->arch.cr3 = cr3;
 		vcpu->arch.mmu.new_cr3(vcpu);
 	}
-	mutex_unlock(&vcpu->kvm->lock);
+	up_read(&current->mm->mmap_sem);
 }
 EXPORT_SYMBOL_GPL(set_cr3);
 
@@ -1211,12 +1207,12 @@ static int kvm_vm_ioctl_set_nr_mmu_pages(struct kvm *kvm,
 	if (kvm_nr_mmu_pages < KVM_MIN_ALLOC_MMU_PAGES)
 		return -EINVAL;
 
-	mutex_lock(&kvm->lock);
+	down_write(&current->mm->mmap_sem);
 
 	kvm_mmu_change_mmu_pages(kvm, kvm_nr_mmu_pages);
 	kvm->arch.n_requested_mmu_pages = kvm_nr_mmu_pages;
 
-	mutex_unlock(&kvm->lock);
+	up_write(&current->mm->mmap_sem);
 	return 0;
 }
 
@@ -1265,7 +1261,7 @@ static int kvm_vm_ioctl_set_memory_alias(struct kvm *kvm,
 	    < alias->target_phys_addr)
 		goto out;
 
-	mutex_lock(&kvm->lock);
+	down_write(&current->mm->mmap_sem);
 
 	p = &kvm->arch.aliases[alias->slot];
 	p->base_gfn = alias->guest_phys_addr >> PAGE_SHIFT;
@@ -1279,7 +1275,7 @@ static int kvm_vm_ioctl_set_memory_alias(struct kvm *kvm,
 
 	kvm_mmu_zap_all(kvm);
 
-	mutex_unlock(&kvm->lock);
+	up_write(&current->mm->mmap_sem);
 
 	return 0;
 
@@ -1355,7 +1351,7 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 	struct kvm_memory_slot *memslot;
 	int is_dirty = 0;
 
-	mutex_lock(&kvm->lock);
+	down_write(&current->mm->mmap_sem);
 
 	r = kvm_get_dirty_log(kvm, log, &is_dirty);
 	if (r)
@@ -1371,7 +1367,7 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 	}
 	r = 0;
 out:
-	mutex_unlock(&kvm->lock);
+	up_write(&current->mm->mmap_sem);
 	return r;
 }
 
@@ -1565,25 +1561,32 @@ int emulator_read_std(unsigned long addr,
 			     struct kvm_vcpu *vcpu)
 {
 	void *data = val;
+	int r = X86EMUL_CONTINUE;
 
+	down_read(&current->mm->mmap_sem);
 	while (bytes) {
 		gpa_t gpa = vcpu->arch.mmu.gva_to_gpa(vcpu, addr);
 		unsigned offset = addr & (PAGE_SIZE-1);
 		unsigned tocopy = min(bytes, (unsigned)PAGE_SIZE - offset);
 		int ret;
 
-		if (gpa == UNMAPPED_GVA)
-			return X86EMUL_PROPAGATE_FAULT;
+		if (gpa == UNMAPPED_GVA) {
+			r = X86EMUL_PROPAGATE_FAULT;
+			goto out;
+		}
 		ret = kvm_read_guest(vcpu->kvm, gpa, data, tocopy);
-		if (ret < 0)
-			return X86EMUL_UNHANDLEABLE;
+		if (ret < 0) {
+			r = X86EMUL_UNHANDLEABLE;
+			goto out;
+		}
 
 		bytes -= tocopy;
 		data += tocopy;
 		addr += tocopy;
 	}
-
-	return X86EMUL_CONTINUE;
+out:
+	up_read(&current->mm->mmap_sem);
+	return r;
 }
 EXPORT_SYMBOL_GPL(emulator_read_std);
 
@@ -1601,7 +1604,9 @@ static int emulator_read_emulated(unsigned long addr,
 		return X86EMUL_CONTINUE;
 	}
 
+	down_read(&current->mm->mmap_sem);
 	gpa = vcpu->arch.mmu.gva_to_gpa(vcpu, addr);
+	up_read(&current->mm->mmap_sem);
 
 	/* For APIC access vmexit */
 	if ((gpa & PAGE_MASK) == APIC_DEFAULT_PHYS_BASE)
@@ -1617,11 +1622,14 @@ mmio:
 	/*
 	 * Is this MMIO handled locally?
 	 */
+	mutex_lock(&vcpu->kvm->lock);
 	mmio_dev = vcpu_find_mmio_dev(vcpu, gpa);
 	if (mmio_dev) {
 		kvm_iodevice_read(mmio_dev, gpa, bytes, val);
+		mutex_unlock(&vcpu->kvm->lock);
 		return X86EMUL_CONTINUE;
 	}
+	mutex_unlock(&vcpu->kvm->lock);
 
 	vcpu->mmio_needed = 1;
 	vcpu->mmio_phys_addr = gpa;
@@ -1636,10 +1644,14 @@ static int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
 {
 	int ret;
 
+	down_read(&current->mm->mmap_sem);
 	ret = kvm_write_guest(vcpu->kvm, gpa, val, bytes);
-	if (ret < 0)
+	if (ret < 0) {
+		up_read(&current->mm->mmap_sem);
 		return 0;
+	}
 	kvm_mmu_pte_write(vcpu, gpa, val, bytes);
+	up_read(&current->mm->mmap_sem);
 	return 1;
 }
 
@@ -1649,7 +1661,11 @@ static int emulator_write_emulated_onepage(unsigned long addr,
 					   struct kvm_vcpu *vcpu)
 {
 	struct kvm_io_device *mmio_dev;
-	gpa_t                 gpa = vcpu->arch.mmu.gva_to_gpa(vcpu, addr);
+	gpa_t                 gpa;
+
+	down_read(&current->mm->mmap_sem);
+	gpa = vcpu->arch.mmu.gva_to_gpa(vcpu, addr);
+	up_read(&current->mm->mmap_sem);
 
 	if (gpa == UNMAPPED_GVA) {
 		kvm_inject_page_fault(vcpu, addr, 2);
@@ -1667,11 +1683,14 @@ mmio:
 	/*
 	 * Is this MMIO handled locally?
 	 */
+	mutex_lock(&vcpu->kvm->lock);
 	mmio_dev = vcpu_find_mmio_dev(vcpu, gpa);
 	if (mmio_dev) {
 		kvm_iodevice_write(mmio_dev, gpa, bytes, val);
+		mutex_unlock(&vcpu->kvm->lock);
 		return X86EMUL_CONTINUE;
 	}
+	mutex_unlock(&vcpu->kvm->lock);
 
 	vcpu->mmio_needed = 1;
 	vcpu->mmio_phys_addr = gpa;
@@ -1718,11 +1737,14 @@ static int emulator_cmpxchg_emulated(unsigned long addr,
 #ifndef CONFIG_X86_64
 	/* guests cmpxchg8b have to be emulated atomically */
 	if (bytes == 8) {
-		gpa_t gpa = vcpu->arch.mmu.gva_to_gpa(vcpu, addr);
+		gpa_t gpa;
 		struct page *page;
 		char *addr;
 		u64 val;
 
+		down_read(&current->mm->mmap_sem);
+		gpa = vcpu->arch.mmu.gva_to_gpa(vcpu, addr);
+
 		if (gpa == UNMAPPED_GVA ||
 		   (gpa & PAGE_MASK) == APIC_DEFAULT_PHYS_BASE)
 			goto emul_write;
@@ -1736,8 +1758,9 @@ static int emulator_cmpxchg_emulated(unsigned long addr,
 		set_64bit((u64 *)(addr + offset_in_page(gpa)), val);
 		kunmap_atomic(addr, KM_USER0);
 		kvm_release_page_dirty(page);
+	emul_write:
+		up_read(&current->mm->mmap_sem);
 	}
-emul_write:
 #endif
 
 	return emulator_write_emulated(addr, new, bytes, vcpu);
@@ -2118,10 +2141,10 @@ int kvm_emulate_pio_string(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
 		kvm_x86_ops->skip_emulated_instruction(vcpu);
 
 	for (i = 0; i < nr_pages; ++i) {
-		mutex_lock(&vcpu->kvm->lock);
+		down_read(&current->mm->mmap_sem);
 		page = gva_to_page(vcpu, address + i * PAGE_SIZE);
 		vcpu->arch.pio.guest_pages[i] = page;
-		mutex_unlock(&vcpu->kvm->lock);
+		up_read(&current->mm->mmap_sem);
 		if (!page) {
 			kvm_inject_gp(vcpu, 0);
 			free_pio_guest_pages(vcpu);
@@ -2247,7 +2270,6 @@ int kvm_fix_hypercall(struct kvm_vcpu *vcpu)
 	char instruction[3];
 	int ret = 0;
 
-	mutex_lock(&vcpu->kvm->lock);
 
 	/*
 	 * Blow out the MMU to ensure that no other VCPU has an active mapping
@@ -2262,8 +2284,6 @@ int kvm_fix_hypercall(struct kvm_vcpu *vcpu)
 	    != X86EMUL_CONTINUE)
 		ret = -EFAULT;
 
-	mutex_unlock(&vcpu->kvm->lock);
-
 	return ret;
 }
 
@@ -2447,8 +2467,10 @@ static void vapic_enter(struct kvm_vcpu *vcpu)
 	if (!apic || !apic->vapic_addr)
 		return;
 
+	down_read(&current->mm->mmap_sem);
 	page = gfn_to_page(vcpu->kvm, apic->vapic_addr >> PAGE_SHIFT);
 	vcpu->arch.apic->vapic_page = page;
+	up_read(&current->mm->mmap_sem);
 }
 
 static void vapic_exit(struct kvm_vcpu *vcpu)
@@ -2910,13 +2932,13 @@ int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
 	gpa_t gpa;
 
 	vcpu_load(vcpu);
-	mutex_lock(&vcpu->kvm->lock);
+	down_read(&current->mm->mmap_sem);
 	gpa = vcpu->arch.mmu.gva_to_gpa(vcpu, vaddr);
+	up_read(&current->mm->mmap_sem);
 	tr->physical_address = gpa;
 	tr->valid = gpa != UNMAPPED_GVA;
 	tr->writeable = 1;
 	tr->usermode = 0;
-	mutex_unlock(&vcpu->kvm->lock);
 	vcpu_put(vcpu);
 
 	return 0;
@@ -3185,13 +3207,11 @@ int kvm_arch_set_memory_region(struct kvm *kvm,
 	 */
 	if (!user_alloc) {
 		if (npages && !old.rmap) {
-			down_write(&current->mm->mmap_sem);
 			memslot->userspace_addr = do_mmap(NULL, 0,
 						     npages * PAGE_SIZE,
 						     PROT_READ | PROT_WRITE,
 						     MAP_SHARED | MAP_ANONYMOUS,
 						     0);
-			up_write(&current->mm->mmap_sem);
 
 			if (IS_ERR((void *)memslot->userspace_addr))
 				return PTR_ERR((void *)memslot->userspace_addr);
@@ -3199,10 +3219,8 @@ int kvm_arch_set_memory_region(struct kvm *kvm,
 			if (!old.user_alloc && old.rmap) {
 				int ret;
 
-				down_write(&current->mm->mmap_sem);
 				ret = do_munmap(current->mm, old.userspace_addr,
 						old.npages * PAGE_SIZE);
-				up_write(&current->mm->mmap_sem);
 				if (ret < 0)
 					printk(KERN_WARNING
 				       "kvm_vm_ioctl_set_memory_region: "
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a5ee518..396c619 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -227,7 +227,7 @@ static int kvm_vm_release(struct inode *inode, struct file *filp)
  *
  * Discontiguous memory is allowed, mostly for framebuffers.
  *
- * Must be called holding kvm->lock.
+ * Must be called holding mmap_sem for write.
  */
 int __kvm_set_memory_region(struct kvm *kvm,
 			    struct kvm_userspace_memory_region *mem,
@@ -338,9 +338,9 @@ int kvm_set_memory_region(struct kvm *kvm,
 {
 	int r;
 
-	mutex_lock(&kvm->lock);
+	down_write(&current->mm->mmap_sem);
 	r = __kvm_set_memory_region(kvm, mem, user_alloc);
-	mutex_unlock(&kvm->lock);
+	up_write(&current->mm->mmap_sem);
 	return r;
 }
 EXPORT_SYMBOL_GPL(kvm_set_memory_region);
@@ -456,7 +456,7 @@ static unsigned long gfn_to_hva(struct kvm *kvm, gfn_t gfn)
 /*
  * Requires current->mm->mmap_sem to be held
  */
-static struct page *__gfn_to_page(struct kvm *kvm, gfn_t gfn)
+struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
 {
 	struct page *page[1];
 	unsigned long addr;
@@ -481,17 +481,6 @@ static struct page *__gfn_to_page(struct kvm *kvm, gfn_t gfn)
 	return page[0];
 }
 
-struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
-{
-	struct page *page;
-
-	down_read(&current->mm->mmap_sem);
-	page = __gfn_to_page(kvm, gfn);
-	up_read(&current->mm->mmap_sem);
-
-	return page;
-}
-
 EXPORT_SYMBOL_GPL(gfn_to_page);
 
 void kvm_release_page_clean(struct page *page)
@@ -977,8 +966,7 @@ static int kvm_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 
 	if (!kvm_is_visible_gfn(kvm, vmf->pgoff))
 		return VM_FAULT_SIGBUS;
-	/* current->mm->mmap_sem is already held so call lockless version */
-	page = __gfn_to_page(kvm, vmf->pgoff);
+	page = gfn_to_page(kvm, vmf->pgoff);
 	if (is_error_page(page)) {
 		kvm_release_page_clean(page);
 		return VM_FAULT_SIGBUS;
-- 
1.5.3.7

