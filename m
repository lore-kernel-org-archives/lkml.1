Return-Path: <linux-kernel-owner+w=401wt.eu-S1760776AbYAFOuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760776AbYAFOuo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 09:50:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758035AbYAFOk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 09:40:28 -0500
Received: from il.qumranet.com ([82.166.9.18]:46654 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757644AbYAFOjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 09:39:49 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 30/33] KVM: MMU: Switch to mmu spinlock
Date: Sun,  6 Jan 2008 16:39:36 +0200
Message-Id: <1199630379-28638-31-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199630379-28638-1-git-send-email-avi@qumranet.com>
References: <1199630379-28638-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

Convert the synchronization of the shadow handling to a separate mmu_lock
spinlock.

Also guard fetch() by mmap_sem in read-mode to protect against alias
and memslot changes.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/mmu.c         |   48 +++++++++++++++++++++++--------------------
 arch/x86/kvm/paging_tmpl.h |   10 +++++---
 arch/x86/kvm/vmx.c         |    2 -
 include/linux/kvm_host.h   |    3 +-
 virt/kvm/kvm_main.c        |    3 +-
 5 files changed, 35 insertions(+), 31 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index c0b757b..834698d 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -971,16 +971,12 @@ static void nonpaging_new_cr3(struct kvm_vcpu *vcpu)
 {
 }
 
-static int __nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn)
+static int __nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write,
+			   gfn_t gfn, struct page *page)
 {
 	int level = PT32E_ROOT_LEVEL;
 	hpa_t table_addr = vcpu->arch.mmu.root_hpa;
 	int pt_write = 0;
-	struct page *page;
-
-	down_read(&current->mm->mmap_sem);
-	page = gfn_to_page(vcpu->kvm, gfn);
-	up_read(&current->mm->mmap_sem);
 
 	for (; ; level--) {
 		u32 index = PT64_INDEX(v, level);
@@ -1022,9 +1018,17 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn)
 {
 	int r;
 
-	mutex_lock(&vcpu->kvm->lock);
-	r = __nonpaging_map(vcpu, v, write, gfn);
-	mutex_unlock(&vcpu->kvm->lock);
+	struct page *page;
+
+	down_read(&current->mm->mmap_sem);
+	page = gfn_to_page(vcpu->kvm, gfn);
+
+	spin_lock(&vcpu->kvm->mmu_lock);
+	r = __nonpaging_map(vcpu, v, write, gfn, page);
+	spin_unlock(&vcpu->kvm->mmu_lock);
+
+	up_read(&current->mm->mmap_sem);
+
 	return r;
 }
 
@@ -1045,7 +1049,7 @@ static void mmu_free_roots(struct kvm_vcpu *vcpu)
 
 	if (!VALID_PAGE(vcpu->arch.mmu.root_hpa))
 		return;
-	mutex_lock(&vcpu->kvm->lock);
+	spin_lock(&vcpu->kvm->mmu_lock);
 #ifdef CONFIG_X86_64
 	if (vcpu->arch.mmu.shadow_root_level == PT64_ROOT_LEVEL) {
 		hpa_t root = vcpu->arch.mmu.root_hpa;
@@ -1053,7 +1057,7 @@ static void mmu_free_roots(struct kvm_vcpu *vcpu)
 		sp = page_header(root);
 		--sp->root_count;
 		vcpu->arch.mmu.root_hpa = INVALID_PAGE;
-		mutex_unlock(&vcpu->kvm->lock);
+		spin_unlock(&vcpu->kvm->mmu_lock);
 		return;
 	}
 #endif
@@ -1067,7 +1071,7 @@ static void mmu_free_roots(struct kvm_vcpu *vcpu)
 		}
 		vcpu->arch.mmu.pae_root[i] = INVALID_PAGE;
 	}
-	mutex_unlock(&vcpu->kvm->lock);
+	spin_unlock(&vcpu->kvm->mmu_lock);
 	vcpu->arch.mmu.root_hpa = INVALID_PAGE;
 }
 
@@ -1270,9 +1274,9 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 	r = mmu_topup_memory_caches(vcpu);
 	if (r)
 		goto out;
-	mutex_lock(&vcpu->kvm->lock);
+	spin_lock(&vcpu->kvm->mmu_lock);
 	mmu_alloc_roots(vcpu);
-	mutex_unlock(&vcpu->kvm->lock);
+	spin_unlock(&vcpu->kvm->mmu_lock);
 	kvm_x86_ops->set_cr3(vcpu, vcpu->arch.mmu.root_hpa);
 	kvm_mmu_flush_tlb(vcpu);
 out:
@@ -1408,7 +1412,7 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 
 	pgprintk("%s: gpa %llx bytes %d\n", __FUNCTION__, gpa, bytes);
 	mmu_guess_page_from_pte_write(vcpu, gpa, new, bytes);
-	mutex_lock(&vcpu->kvm->lock);
+	spin_lock(&vcpu->kvm->mmu_lock);
 	++vcpu->kvm->stat.mmu_pte_write;
 	kvm_mmu_audit(vcpu, "pre pte write");
 	if (gfn == vcpu->arch.last_pt_write_gfn
@@ -1477,7 +1481,7 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 		}
 	}
 	kvm_mmu_audit(vcpu, "post pte write");
-	mutex_unlock(&vcpu->kvm->lock);
+	spin_unlock(&vcpu->kvm->mmu_lock);
 	if (vcpu->arch.update_pte.page) {
 		kvm_release_page_clean(vcpu->arch.update_pte.page);
 		vcpu->arch.update_pte.page = NULL;
@@ -1493,15 +1497,15 @@ int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva)
 	gpa = vcpu->arch.mmu.gva_to_gpa(vcpu, gva);
 	up_read(&current->mm->mmap_sem);
 
-	mutex_lock(&vcpu->kvm->lock);
+	spin_lock(&vcpu->kvm->mmu_lock);
 	r = kvm_mmu_unprotect_page(vcpu->kvm, gpa >> PAGE_SHIFT);
-	mutex_unlock(&vcpu->kvm->lock);
+	spin_unlock(&vcpu->kvm->mmu_lock);
 	return r;
 }
 
 void __kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu)
 {
-	mutex_lock(&vcpu->kvm->lock);
+	spin_lock(&vcpu->kvm->mmu_lock);
 	while (vcpu->kvm->arch.n_free_mmu_pages < KVM_REFILL_PAGES) {
 		struct kvm_mmu_page *sp;
 
@@ -1510,7 +1514,7 @@ void __kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu)
 		kvm_mmu_zap_page(vcpu->kvm, sp);
 		++vcpu->kvm->stat.mmu_recycled;
 	}
-	mutex_unlock(&vcpu->kvm->lock);
+	spin_unlock(&vcpu->kvm->mmu_lock);
 }
 
 int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t cr2, u32 error_code)
@@ -1642,10 +1646,10 @@ void kvm_mmu_zap_all(struct kvm *kvm)
 {
 	struct kvm_mmu_page *sp, *node;
 
-	mutex_lock(&kvm->lock);
+	spin_lock(&kvm->mmu_lock);
 	list_for_each_entry_safe(sp, node, &kvm->arch.active_mmu_pages, link)
 		kvm_mmu_zap_page(kvm, sp);
-	mutex_unlock(&kvm->lock);
+	spin_unlock(&kvm->mmu_lock);
 
 	kvm_flush_remote_tlbs(kvm);
 }
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 3d7846b..a35b83a 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -387,7 +387,6 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
 	 */
 	r = FNAME(walk_addr)(&walker, vcpu, addr, write_fault, user_fault,
 			     fetch_fault);
-	up_read(&current->mm->mmap_sem);
 
 	/*
 	 * The page is not mapped by the guest.  Let the guest handle it.
@@ -396,12 +395,13 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
 		pgprintk("%s: guest page fault\n", __FUNCTION__);
 		inject_page_fault(vcpu, addr, walker.error_code);
 		vcpu->arch.last_pt_write_count = 0; /* reset fork detector */
+		up_read(&current->mm->mmap_sem);
 		return 0;
 	}
 
 	page = gfn_to_page(vcpu->kvm, walker.gfn);
 
-	mutex_lock(&vcpu->kvm->lock);
+	spin_lock(&vcpu->kvm->mmu_lock);
 	shadow_pte = FNAME(fetch)(vcpu, addr, &walker, user_fault, write_fault,
 				  &write_pt, page);
 	pgprintk("%s: shadow pte %p %llx ptwrite %d\n", __FUNCTION__,
@@ -414,13 +414,15 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
 	 * mmio: emulate if accessible, otherwise its a guest fault.
 	 */
 	if (shadow_pte && is_io_pte(*shadow_pte)) {
-		mutex_unlock(&vcpu->kvm->lock);
+		spin_unlock(&vcpu->kvm->mmu_lock);
+		up_read(&current->mm->mmap_sem);
 		return 1;
 	}
 
 	++vcpu->stat.pf_fixed;
 	kvm_mmu_audit(vcpu, "post page fault (fixed)");
-	mutex_unlock(&vcpu->kvm->lock);
+	spin_unlock(&vcpu->kvm->mmu_lock);
+	up_read(&current->mm->mmap_sem);
 
 	return write_pt;
 }
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 99fec63..4741806 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1476,7 +1476,6 @@ static int alloc_apic_access_page(struct kvm *kvm)
 	struct kvm_userspace_memory_region kvm_userspace_mem;
 	int r = 0;
 
-	mutex_lock(&kvm->lock);
 	down_write(&current->mm->mmap_sem);
 	if (kvm->arch.apic_access_page)
 		goto out;
@@ -1490,7 +1489,6 @@ static int alloc_apic_access_page(struct kvm *kvm)
 	kvm->arch.apic_access_page = gfn_to_page(kvm, 0xfee00);
 out:
 	up_write(&current->mm->mmap_sem);
-	mutex_unlock(&kvm->lock);
 	return r;
 }
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index a020fb2..2714068 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -104,7 +104,8 @@ struct kvm_memory_slot {
 };
 
 struct kvm {
-	struct mutex lock; /* protects everything except vcpus */
+	struct mutex lock; /* protects the vcpus array and APIC accesses */
+	spinlock_t mmu_lock;
 	struct mm_struct *mm; /* userspace tied to this vm */
 	int nmemslots;
 	struct kvm_memory_slot memslots[KVM_MEMORY_SLOTS +
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c462d7e..4295623 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -165,6 +165,7 @@ static struct kvm *kvm_create_vm(void)
 
 	kvm->mm = current->mm;
 	atomic_inc(&kvm->mm->mm_count);
+	spin_lock_init(&kvm->mmu_lock);
 	kvm_io_bus_init(&kvm->pio_bus);
 	mutex_init(&kvm->lock);
 	kvm_io_bus_init(&kvm->mmio_bus);
@@ -552,9 +553,7 @@ int kvm_read_guest_atomic(struct kvm *kvm, gpa_t gpa, void *data,
 	addr = gfn_to_hva(kvm, gfn);
 	if (kvm_is_error_hva(addr))
 		return -EFAULT;
-	pagefault_disable();
 	r = __copy_from_user_inatomic(data, (void __user *)addr + offset, len);
-	pagefault_enable();
 	if (r)
 		return -EFAULT;
 	return 0;
-- 
1.5.3.7

