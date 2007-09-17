Return-Path: <linux-kernel-owner+w=401wt.eu-S1759852AbXIQJFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759852AbXIQJFc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 05:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755042AbXIQIeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:34:06 -0400
Received: from il.qumranet.com ([82.166.9.18]:45319 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753524AbXIQIc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:28 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Shaohua Li <shaohua.li@intel.com>
Subject: [PATCH 029/104] KVM: Convert vm lock to a mutex
Date: Mon, 17 Sep 2007 10:31:11 +0200
Message-Id: <11900179473778-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shaohua Li <shaohua.li@intel.com>

This allows the kvm mmu to perform sleepy operations, such as memory
allocation.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |    2 +-
 drivers/kvm/kvm_main.c |   69 +++++++++++++++++++++++-------------------------
 drivers/kvm/mmu.c      |    9 +++---
 drivers/kvm/svm.c      |    8 +++---
 drivers/kvm/vmx.c      |    8 +++---
 5 files changed, 46 insertions(+), 50 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 0667183..1072c83 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -393,7 +393,7 @@ struct kvm_memory_slot {
 };
 
 struct kvm {
-	spinlock_t lock; /* protects everything except vcpus */
+	struct mutex lock; /* protects everything except vcpus */
 	int naliases;
 	struct kvm_mem_alias aliases[KVM_ALIAS_SLOTS];
 	int nmemslots;
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 6035e6d..7aeaaba 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -363,7 +363,7 @@ static struct kvm *kvm_create_vm(void)
 		return ERR_PTR(-ENOMEM);
 
 	kvm_io_bus_init(&kvm->pio_bus);
-	spin_lock_init(&kvm->lock);
+	mutex_init(&kvm->lock);
 	INIT_LIST_HEAD(&kvm->active_mmu_pages);
 	kvm_io_bus_init(&kvm->mmio_bus);
 	spin_lock(&kvm_lock);
@@ -489,7 +489,7 @@ static int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3)
 	struct page *page;
 	u64 pdpte[ARRAY_SIZE(vcpu->pdptrs)];
 
-	spin_lock(&vcpu->kvm->lock);
+	mutex_lock(&vcpu->kvm->lock);
 	page = gfn_to_page(vcpu->kvm, pdpt_gfn);
 	if (!page) {
 		ret = 0;
@@ -510,7 +510,7 @@ static int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3)
 
 	memcpy(vcpu->pdptrs, pdpte, sizeof(vcpu->pdptrs));
 out:
-	spin_unlock(&vcpu->kvm->lock);
+	mutex_unlock(&vcpu->kvm->lock);
 
 	return ret;
 }
@@ -570,9 +570,9 @@ void set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
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
@@ -611,9 +611,9 @@ void set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
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
 
@@ -650,7 +650,7 @@ void set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 	}
 
 	vcpu->cr3 = cr3;
-	spin_lock(&vcpu->kvm->lock);
+	mutex_lock(&vcpu->kvm->lock);
 	/*
 	 * Does the new cr3 value map to physical memory? (Note, we
 	 * catch an invalid cr3 even in real-mode, because it would
@@ -664,7 +664,7 @@ void set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 		inject_gp(vcpu);
 	else
 		vcpu->mmu.new_cr3(vcpu);
-	spin_unlock(&vcpu->kvm->lock);
+	mutex_unlock(&vcpu->kvm->lock);
 }
 EXPORT_SYMBOL_GPL(set_cr3);
 
@@ -741,7 +741,7 @@ static int kvm_vm_ioctl_set_memory_region(struct kvm *kvm,
 		mem->flags &= ~KVM_MEM_LOG_DIRTY_PAGES;
 
 raced:
-	spin_lock(&kvm->lock);
+	mutex_lock(&kvm->lock);
 
 	memory_config_version = kvm->memory_config_version;
 	new = old = *memslot;
@@ -770,7 +770,7 @@ raced:
 	 * Do memory allocations outside lock.  memory_config_version will
 	 * detect any races.
 	 */
-	spin_unlock(&kvm->lock);
+	mutex_unlock(&kvm->lock);
 
 	/* Deallocate if slot is being removed */
 	if (!npages)
@@ -809,10 +809,10 @@ raced:
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
@@ -830,13 +830,13 @@ raced:
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
@@ -854,14 +854,14 @@ static int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
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
@@ -880,18 +880,18 @@ static int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
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
 
@@ -921,7 +921,7 @@ static int kvm_vm_ioctl_set_memory_alias(struct kvm *kvm,
 	    < alias->target_phys_addr)
 		goto out;
 
-	spin_lock(&kvm->lock);
+	mutex_lock(&kvm->lock);
 
 	p = &kvm->aliases[alias->slot];
 	p->base_gfn = alias->guest_phys_addr >> PAGE_SHIFT;
@@ -935,7 +935,7 @@ static int kvm_vm_ioctl_set_memory_alias(struct kvm *kvm,
 
 	kvm_mmu_zap_all(kvm);
 
-	spin_unlock(&kvm->lock);
+	mutex_unlock(&kvm->lock);
 
 	return 0;
 
@@ -1900,12 +1900,12 @@ int kvm_setup_pio(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
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
@@ -2298,13 +2298,13 @@ static int kvm_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
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
@@ -2426,14 +2426,14 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, int n)
 	if (r < 0)
 		goto free_vcpu;
 
-	spin_lock(&kvm->lock);
+	mutex_lock(&kvm->lock);
 	if (kvm->vcpus[n]) {
 		r = -EEXIST;
-		spin_unlock(&kvm->lock);
+		mutex_unlock(&kvm->lock);
 		goto mmu_unload;
 	}
 	kvm->vcpus[n] = vcpu;
-	spin_unlock(&kvm->lock);
+	mutex_unlock(&kvm->lock);
 
 	/* Now it's all set up, let userspace reach it */
 	r = create_vcpu_fd(vcpu);
@@ -2442,9 +2442,9 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, int n)
 	return r;
 
 unlink:
-	spin_lock(&kvm->lock);
+	mutex_lock(&kvm->lock);
 	kvm->vcpus[n] = NULL;
-	spin_unlock(&kvm->lock);
+	mutex_unlock(&kvm->lock);
 
 mmu_unload:
 	vcpu_load(vcpu);
@@ -2945,8 +2945,7 @@ static void decache_vcpus_on_cpu(int cpu)
 	int i;
 
 	spin_lock(&kvm_lock);
-	list_for_each_entry(vm, &vm_list, vm_list) {
-		spin_lock(&vm->lock);
+	list_for_each_entry(vm, &vm_list, vm_list)
 		for (i = 0; i < KVM_MAX_VCPUS; ++i) {
 			vcpu = vm->vcpus[i];
 			if (!vcpu)
@@ -2967,8 +2966,6 @@ static void decache_vcpus_on_cpu(int cpu)
 				mutex_unlock(&vcpu->mutex);
 			}
 		}
-		spin_unlock(&vm->lock);
-	}
 	spin_unlock(&kvm_lock);
 }
 
diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index 396c736..e303b41 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -275,10 +275,9 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu)
 	r = __mmu_topup_memory_caches(vcpu, GFP_NOWAIT);
 	kvm_mmu_free_some_pages(vcpu);
 	if (r < 0) {
-		spin_unlock(&vcpu->kvm->lock);
+		mutex_unlock(&vcpu->kvm->lock);
 		r = __mmu_topup_memory_caches(vcpu, GFP_KERNEL);
-		spin_lock(&vcpu->kvm->lock);
-		kvm_mmu_free_some_pages(vcpu);
+		mutex_lock(&vcpu->kvm->lock);
 	}
 	return r;
 }
@@ -1069,7 +1068,7 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 {
 	int r;
 
-	spin_lock(&vcpu->kvm->lock);
+	mutex_lock(&vcpu->kvm->lock);
 	r = mmu_topup_memory_caches(vcpu);
 	if (r)
 		goto out;
@@ -1077,7 +1076,7 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 	kvm_arch_ops->set_cr3(vcpu, vcpu->mmu.root_hpa);
 	kvm_mmu_flush_tlb(vcpu);
 out:
-	spin_unlock(&vcpu->kvm->lock);
+	mutex_unlock(&vcpu->kvm->lock);
 	return r;
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_load);
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index 3997bbd..9a840e0 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -941,21 +941,21 @@ static int pf_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	if (is_external_interrupt(exit_int_info))
 		push_irq(vcpu, exit_int_info & SVM_EVTINJ_VEC_MASK);
 
-	spin_lock(&vcpu->kvm->lock);
+	mutex_lock(&vcpu->kvm->lock);
 
 	fault_address  = svm->vmcb->control.exit_info_2;
 	error_code = svm->vmcb->control.exit_info_1;
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
index 8c87d20..5b77d9b 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -1711,19 +1711,19 @@ static int handle_exception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
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
1.5.3

