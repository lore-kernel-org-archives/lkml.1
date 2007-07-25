Return-Path: <linux-kernel-owner+w=401wt.eu-S1760930AbXGYMn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760930AbXGYMn6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 08:43:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760703AbXGYMnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 08:43:01 -0400
Received: from il.qumranet.com ([82.166.9.18]:39209 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757095AbXGYMm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 08:42:58 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       shaohua.li@intel.com, rusty@rustcorp.com.au, Andi Kleen <ak@suse.de>,
       Avi Kivity <avi@qumranet.com>
Subject: [PATCH 3/3] KVM: Convert vm lock to a mutex
Date: Wed, 25 Jul 2007 15:43:07 +0300
Message-Id: <11853673872091-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <11853673872732-git-send-email-avi@qumranet.com>
References: <11853673872732-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shaohua Li <shaohua.li@intel.com>

This allows the kvm mmu to perform sleepy operations, such as memory
allocation.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |    2 +-
 drivers/kvm/kvm_main.c |   54 ++++++++++++++++++++++++------------------------
 drivers/kvm/mmu.c      |    8 +++---
 drivers/kvm/svm.c      |    8 +++---
 drivers/kvm/vmx.c      |    8 +++---
 5 files changed, 40 insertions(+), 40 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 50ddd3c..ca167c4 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -420,7 +420,7 @@ struct kvm_memory_slot {
 };
 
 struct kvm {
-	spinlock_t lock; /* protects everything except vcpus */
+	struct mutex lock; /* protects everything except vcpus */
 	int naliases;
 	struct kvm_mem_alias aliases[KVM_ALIAS_SLOTS];
 	int nmemslots;
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 4f45247..6e76345 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -310,7 +310,7 @@ static struct kvm *kvm_create_vm(void)
 		return ERR_PTR(-ENOMEM);
 
 	kvm_io_bus_init(&kvm->pio_bus);
-	spin_lock_init(&kvm->lock);
+	mutex_init(&kvm->lock);
 	INIT_LIST_HEAD(&kvm->active_mmu_pages);
 	kvm_io_bus_init(&kvm->mmio_bus);
 	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
@@ -457,7 +457,7 @@ static int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3)
 	int ret;
 	struct page *page;
 
-	spin_lock(&vcpu->kvm->lock);
+	mutex_lock(&vcpu->kvm->lock);
 	page = gfn_to_page(vcpu->kvm, pdpt_gfn);
 	/* FIXME: !page - emulate? 0xff? */
 	pdpt = kmap_atomic(page, KM_USER0);
@@ -476,7 +476,7 @@ static int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3)
 
 out:
 	kunmap_atomic(pdpt, KM_USER0);
-	spin_unlock(&vcpu->kvm->lock);
+	mutex_unlock(&vcpu->kvm->lock);
 
 	return ret;
 }
@@ -536,9 +536,9 @@ void set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	kvm_arch_ops->set_cr0(vcpu, cr0);
 	vcpu->cr0 = cr0;
 
-	spin_lock(&vcpu->kvm->lock);
+	mutex_lock(&vcpu->kvm->lock);
 	kvm_mmu_reset_context(vcpu);
-	spin_unlock(&vcpu->kvm->lock);
+	mutex_unlock(&vcpu->kvm->lock);
 	return;
 }
 EXPORT_SYMBOL_GPL(set_cr0);
@@ -577,9 +577,9 @@ void set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 		return;
 	}
 	kvm_arch_ops->set_cr4(vcpu, cr4);
-	spin_lock(&vcpu->kvm->lock);
+	mutex_lock(&vcpu->kvm->lock);
 	kvm_mmu_reset_context(vcpu);
-	spin_unlock(&vcpu->kvm->lock);
+	mutex_unlock(&vcpu->kvm->lock);
 }
 EXPORT_SYMBOL_GPL(set_cr4);
 
@@ -616,7 +616,7 @@ void set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 	}
 
 	vcpu->cr3 = cr3;
-	spin_lock(&vcpu->kvm->lock);
+	mutex_lock(&vcpu->kvm->lock);
 	/*
 	 * Does the new cr3 value map to physical memory? (Note, we
 	 * catch an invalid cr3 even in real-mode, because it would
@@ -630,7 +630,7 @@ void set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 		inject_gp(vcpu);
 	else
 		vcpu->mmu.new_cr3(vcpu);
-	spin_unlock(&vcpu->kvm->lock);
+	mutex_unlock(&vcpu->kvm->lock);
 }
 EXPORT_SYMBOL_GPL(set_cr3);
 
@@ -707,7 +707,7 @@ static int kvm_vm_ioctl_set_memory_region(struct kvm *kvm,
 		mem->flags &= ~KVM_MEM_LOG_DIRTY_PAGES;
 
 raced:
-	spin_lock(&kvm->lock);
+	mutex_lock(&kvm->lock);
 
 	memory_config_version = kvm->memory_config_version;
 	new = old = *memslot;
@@ -736,7 +736,7 @@ raced:
 	 * Do memory allocations outside lock.  memory_config_version will
 	 * detect any races.
 	 */
-	spin_unlock(&kvm->lock);
+	mutex_unlock(&kvm->lock);
 
 	/* Deallocate if slot is being removed */
 	if (!npages)
@@ -775,10 +775,10 @@ raced:
 		memset(new.dirty_bitmap, 0, dirty_bytes);
 	}
 
-	spin_lock(&kvm->lock);
+	mutex_lock(&kvm->lock);
 
 	if (memory_config_version != kvm->memory_config_version) {
-		spin_unlock(&kvm->lock);
+		mutex_unlock(&kvm->lock);
 		kvm_free_physmem_slot(&new, &old);
 		goto raced;
 	}
@@ -796,13 +796,13 @@ raced:
 	kvm_mmu_slot_remove_write_access(kvm, mem->slot);
 	kvm_flush_remote_tlbs(kvm);
 
-	spin_unlock(&kvm->lock);
+	mutex_unlock(&kvm->lock);
 
 	kvm_free_physmem_slot(&old, &new);
 	return 0;
 
 out_unlock:
-	spin_unlock(&kvm->lock);
+	mutex_unlock(&kvm->lock);
 out_free:
 	kvm_free_physmem_slot(&new, &old);
 out:
@@ -820,14 +820,14 @@ static int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 	int n;
 	unsigned long any = 0;
 
-	spin_lock(&kvm->lock);
+	mutex_lock(&kvm->lock);
 
 	/*
 	 * Prevent changes to guest memory configuration even while the lock
 	 * is not taken.
 	 */
 	++kvm->busy;
-	spin_unlock(&kvm->lock);
+	mutex_unlock(&kvm->lock);
 	r = -EINVAL;
 	if (log->slot >= KVM_MEMORY_SLOTS)
 		goto out;
@@ -846,18 +846,18 @@ static int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 	if (copy_to_user(log->dirty_bitmap, memslot->dirty_bitmap, n))
 		goto out;
 
-	spin_lock(&kvm->lock);
+	mutex_lock(&kvm->lock);
 	kvm_mmu_slot_remove_write_access(kvm, log->slot);
 	kvm_flush_remote_tlbs(kvm);
 	memset(memslot->dirty_bitmap, 0, n);
-	spin_unlock(&kvm->lock);
+	mutex_unlock(&kvm->lock);
 
 	r = 0;
 
 out:
-	spin_lock(&kvm->lock);
+	mutex_lock(&kvm->lock);
 	--kvm->busy;
-	spin_unlock(&kvm->lock);
+	mutex_unlock(&kvm->lock);
 	return r;
 }
 
@@ -887,7 +887,7 @@ static int kvm_vm_ioctl_set_memory_alias(struct kvm *kvm,
 	    < alias->target_phys_addr)
 		goto out;
 
-	spin_lock(&kvm->lock);
+	mutex_lock(&kvm->lock);
 
 	p = &kvm->aliases[alias->slot];
 	p->base_gfn = alias->guest_phys_addr >> PAGE_SHIFT;
@@ -901,7 +901,7 @@ static int kvm_vm_ioctl_set_memory_alias(struct kvm *kvm,
 
 	kvm_mmu_zap_all(kvm);
 
-	spin_unlock(&kvm->lock);
+	mutex_unlock(&kvm->lock);
 
 	return 0;
 
@@ -1884,12 +1884,12 @@ int kvm_setup_pio(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
 	vcpu->pio.cur_count = now;
 
 	for (i = 0; i < nr_pages; ++i) {
-		spin_lock(&vcpu->kvm->lock);
+		mutex_lock(&vcpu->kvm->lock);
 		page = gva_to_page(vcpu, address + i * PAGE_SIZE);
 		if (page)
 			get_page(page);
 		vcpu->pio.guest_pages[i] = page;
-		spin_unlock(&vcpu->kvm->lock);
+		mutex_unlock(&vcpu->kvm->lock);
 		if (!page) {
 			inject_gp(vcpu);
 			free_pio_guest_pages(vcpu);
@@ -2282,13 +2282,13 @@ static int kvm_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
 	gpa_t gpa;
 
 	vcpu_load(vcpu);
-	spin_lock(&vcpu->kvm->lock);
+	mutex_lock(&vcpu->kvm->lock);
 	gpa = vcpu->mmu.gva_to_gpa(vcpu, vaddr);
 	tr->physical_address = gpa;
 	tr->valid = gpa != UNMAPPED_GVA;
 	tr->writeable = 1;
 	tr->usermode = 0;
-	spin_unlock(&vcpu->kvm->lock);
+	mutex_unlock(&vcpu->kvm->lock);
 	vcpu_put(vcpu);
 
 	return 0;
diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index fdb967a..bfe16d5 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -274,9 +274,9 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu)
 
 	r = __mmu_topup_memory_caches(vcpu, GFP_NOWAIT);
 	if (r < 0) {
-		spin_unlock(&vcpu->kvm->lock);
+		mutex_unlock(&vcpu->kvm->lock);
 		r = __mmu_topup_memory_caches(vcpu, GFP_KERNEL);
-		spin_lock(&vcpu->kvm->lock);
+		mutex_lock(&vcpu->kvm->lock);
 	}
 	return r;
 }
@@ -1067,7 +1067,7 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 {
 	int r;
 
-	spin_lock(&vcpu->kvm->lock);
+	mutex_lock(&vcpu->kvm->lock);
 	r = mmu_topup_memory_caches(vcpu);
 	if (r)
 		goto out;
@@ -1075,7 +1075,7 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 	kvm_arch_ops->set_cr3(vcpu, vcpu->mmu.root_hpa);
 	kvm_mmu_flush_tlb(vcpu);
 out:
-	spin_unlock(&vcpu->kvm->lock);
+	mutex_unlock(&vcpu->kvm->lock);
 	return r;
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_load);
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index e3a4722..ac7d8b0 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -905,21 +905,21 @@ static int pf_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	if (is_external_interrupt(exit_int_info))
 		push_irq(vcpu, exit_int_info & SVM_EVTINJ_VEC_MASK);
 
-	spin_lock(&vcpu->kvm->lock);
+	mutex_lock(&vcpu->kvm->lock);
 
 	fault_address  = vcpu->svm->vmcb->control.exit_info_2;
 	error_code = vcpu->svm->vmcb->control.exit_info_1;
 	r = kvm_mmu_page_fault(vcpu, fault_address, error_code);
 	if (r < 0) {
-		spin_unlock(&vcpu->kvm->lock);
+		mutex_unlock(&vcpu->kvm->lock);
 		return r;
 	}
 	if (!r) {
-		spin_unlock(&vcpu->kvm->lock);
+		mutex_unlock(&vcpu->kvm->lock);
 		return 1;
 	}
 	er = emulate_instruction(vcpu, kvm_run, fault_address, error_code);
-	spin_unlock(&vcpu->kvm->lock);
+	mutex_unlock(&vcpu->kvm->lock);
 
 	switch (er) {
 	case EMULATE_DONE:
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 90f28f0..ece992f 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -1596,19 +1596,19 @@ static int handle_exception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	if (is_page_fault(intr_info)) {
 		cr2 = vmcs_readl(EXIT_QUALIFICATION);
 
-		spin_lock(&vcpu->kvm->lock);
+		mutex_lock(&vcpu->kvm->lock);
 		r = kvm_mmu_page_fault(vcpu, cr2, error_code);
 		if (r < 0) {
-			spin_unlock(&vcpu->kvm->lock);
+			mutex_unlock(&vcpu->kvm->lock);
 			return r;
 		}
 		if (!r) {
-			spin_unlock(&vcpu->kvm->lock);
+			mutex_unlock(&vcpu->kvm->lock);
 			return 1;
 		}
 
 		er = emulate_instruction(vcpu, kvm_run, cr2, error_code);
-		spin_unlock(&vcpu->kvm->lock);
+		mutex_unlock(&vcpu->kvm->lock);
 
 		switch (er) {
 		case EMULATE_DONE:
-- 
1.5.2.4

