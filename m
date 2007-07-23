Return-Path: <linux-kernel-owner+w=401wt.eu-S1760810AbXGWG6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760810AbXGWG6e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 02:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763617AbXGWG5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 02:57:12 -0400
Received: from mga01.intel.com ([192.55.52.88]:55412 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759569AbXGWG4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 02:56:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,569,1175497200"; 
   d="scan'208";a="271462876"
Subject: [RFC 3/8]KVM: convert vm lock to a mutex
From: Shaohua Li <shaohua.li@intel.com>
To: kvm-devel <kvm-devel@lists.sourceforge.net>,
       lkml <linux-kernel@vger.kernel.org>
Cc: Avi Kivity <avi@qumranet.com>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain
Date: Mon, 23 Jul 2007 14:51:37 +0800
Message-Id: <1185173497.2645.67.camel@sli10-conroe.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

convert kvm lock to a mutex.

TBD: after this change, a lot of logic in kvm can be simplified, eg, we
don't need release lock and then do operation blocking.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 drivers/kvm/kvm.h      |    2 -
 drivers/kvm/kvm_main.c |   58 ++++++++++++++++++++++++-------------------------
 drivers/kvm/mmu.c      |    8 +++---
 drivers/kvm/svm.c      |    8 +++---
 drivers/kvm/vmx.c      |    8 +++---
 5 files changed, 42 insertions(+), 42 deletions(-)

Index: linux/drivers/kvm/kvm.h
===================================================================
--- linux.orig/drivers/kvm/kvm.h	2007-07-20 14:54:31.000000000 +0800
+++ linux/drivers/kvm/kvm.h	2007-07-20 15:00:17.000000000 +0800
@@ -437,7 +437,7 @@ struct kvm_memory_slot {
 };
 
 struct kvm {
-	spinlock_t lock; /* protects everything except vcpus */
+	struct mutex lock; /* protects everything except vcpus */
 	int naliases;
 	struct kvm_mem_alias aliases[KVM_ALIAS_SLOTS];
 	int nmemslots;
Index: linux/drivers/kvm/kvm_main.c
===================================================================
--- linux.orig/drivers/kvm/kvm_main.c	2007-07-20 14:54:31.000000000 +0800
+++ linux/drivers/kvm/kvm_main.c	2007-07-20 15:00:17.000000000 +0800
@@ -324,7 +324,7 @@ static struct kvm *kvm_create_vm(void)
 		return ERR_PTR(-ENOMEM);
 
 	kvm_io_bus_init(&kvm->pio_bus);
-	spin_lock_init(&kvm->lock);
+	mutex_init(&kvm->lock);
 	INIT_LIST_HEAD(&kvm->active_mmu_pages);
 	spin_lock(&kvm_lock);
 	list_add(&kvm->vm_list, &vm_list);
@@ -471,7 +471,7 @@ static int load_pdptrs(struct kvm_vcpu *
 	int ret;
 	struct page *page;
 
-	spin_lock(&vcpu->kvm->lock);
+	mutex_lock(&vcpu->kvm->lock);
 	page = gfn_to_page(vcpu->kvm, pdpt_gfn);
 	/* FIXME: !page - emulate? 0xff? */
 	pdpt = kmap_atomic(page, KM_USER0);
@@ -490,7 +490,7 @@ static int load_pdptrs(struct kvm_vcpu *
 
 out:
 	kunmap_atomic(pdpt, KM_USER0);
-	spin_unlock(&vcpu->kvm->lock);
+	mutex_unlock(&vcpu->kvm->lock);
 
 	return ret;
 }
@@ -550,9 +550,9 @@ void set_cr0(struct kvm_vcpu *vcpu, unsi
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
@@ -590,9 +590,9 @@ void set_cr4(struct kvm_vcpu *vcpu, unsi
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
 
@@ -620,7 +620,7 @@ void set_cr3(struct kvm_vcpu *vcpu, unsi
 	}
 
 	vcpu->cr3 = cr3;
-	spin_lock(&vcpu->kvm->lock);
+	mutex_lock(&vcpu->kvm->lock);
 	/*
 	 * Does the new cr3 value map to physical memory? (Note, we
 	 * catch an invalid cr3 even in real-mode, because it would
@@ -634,7 +634,7 @@ void set_cr3(struct kvm_vcpu *vcpu, unsi
 		inject_gp(vcpu);
 	else
 		vcpu->mmu.new_cr3(vcpu);
-	spin_unlock(&vcpu->kvm->lock);
+	mutex_unlock(&vcpu->kvm->lock);
 }
 EXPORT_SYMBOL_GPL(set_cr3);
 
@@ -677,9 +677,9 @@ EXPORT_SYMBOL_GPL(fx_init);
 
 static void do_remove_write_access(struct kvm_vcpu *vcpu, int slot)
 {
-	spin_lock(&vcpu->kvm->lock);
+	mutex_lock(&vcpu->kvm->lock);
 	kvm_mmu_slot_remove_write_access(vcpu, slot);
-	spin_unlock(&vcpu->kvm->lock);
+	mutex_unlock(&vcpu->kvm->lock);
 }
 
 /*
@@ -718,7 +718,7 @@ static int kvm_vm_ioctl_set_memory_regio
 		mem->flags &= ~KVM_MEM_LOG_DIRTY_PAGES;
 
 raced:
-	spin_lock(&kvm->lock);
+	mutex_lock(&kvm->lock);
 
 	memory_config_version = kvm->memory_config_version;
 	new = old = *memslot;
@@ -747,7 +747,7 @@ raced:
 	 * Do memory allocations outside lock.  memory_config_version will
 	 * detect any races.
 	 */
-	spin_unlock(&kvm->lock);
+	mutex_unlock(&kvm->lock);
 
 	/* Deallocate if slot is being removed */
 	if (!npages)
@@ -786,10 +786,10 @@ raced:
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
@@ -804,7 +804,7 @@ raced:
 	*memslot = new;
 	++kvm->memory_config_version;
 
-	spin_unlock(&kvm->lock);
+	mutex_unlock(&kvm->lock);
 
 	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
 		struct kvm_vcpu *vcpu;
@@ -822,7 +822,7 @@ raced:
 	return 0;
 
 out_unlock:
-	spin_unlock(&kvm->lock);
+	mutex_unlock(&kvm->lock);
 out_free:
 	kvm_free_physmem_slot(&new, &old);
 out:
@@ -841,14 +841,14 @@ static int kvm_vm_ioctl_get_dirty_log(st
 	int cleared;
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
@@ -888,9 +888,9 @@ static int kvm_vm_ioctl_get_dirty_log(st
 	r = 0;
 
 out:
-	spin_lock(&kvm->lock);
+	mutex_lock(&kvm->lock);
 	--kvm->busy;
-	spin_unlock(&kvm->lock);
+	mutex_unlock(&kvm->lock);
 	return r;
 }
 
@@ -920,7 +920,7 @@ static int kvm_vm_ioctl_set_memory_alias
 	    < alias->target_phys_addr)
 		goto out;
 
-	spin_lock(&kvm->lock);
+	mutex_lock(&kvm->lock);
 
 	p = &kvm->aliases[alias->slot];
 	p->base_gfn = alias->guest_phys_addr >> PAGE_SHIFT;
@@ -932,12 +932,12 @@ static int kvm_vm_ioctl_set_memory_alias
 			break;
 	kvm->naliases = n;
 
-	spin_unlock(&kvm->lock);
+	mutex_unlock(&kvm->lock);
 
 	vcpu_load(&kvm->vcpus[0]);
-	spin_lock(&kvm->lock);
+	mutex_lock(&kvm->lock);
 	kvm_mmu_zap_all(&kvm->vcpus[0]);
-	spin_unlock(&kvm->lock);
+	mutex_unlock(&kvm->lock);
 	vcpu_put(&kvm->vcpus[0]);
 
 	return 0;/vmcs_writel are called with preempt enabled
2. preempt_count check doesn't make sense with preempt disabled
3. vmx_cpu_run doesn't handle error correctly and kvm_mmu_reload might
sleep with mutex cha
@@ -1888,12 +1888,12 @@ int kvm_setup_pio(struct kvm_vcpu *vcpu,
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
@@ -2275,13 +2275,13 @@ static int kvm_vcpu_ioctl_translate(stru
 	gpa_t gpa;
 /vmcs_writel are called with preempt enabled
2. preempt_count check doesn't make sense with preempt disabled
3. vmx_cpu_run doesn't handle error correctly and kvm_mmu_reload might
sleep with mutex cha
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
 /vmcs_writel are called with preempt enabled
2. preempt_count check doesn't make sense with preempt disabled
3. vmx_cpu_run doesn't handle error correctly and kvm_mmu_reload might
sleep with mutex cha
 	return 0;
Index: linux/drivers/kvm/mmu.c
===================================================================
--- linux.orig/drivers/kvm/mmu.c	2007-07-20 14:54:31.000000000 +0800
+++ linux/drivers/kvm/mmu.c	2007-07-20 15:00:17.000000000 +0800
@@ -253,9 +253,9 @@ static int mmu_topup_memory_caches(struc
 
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
@@ -1059,7 +1059,7 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 {
 	int r;
 
-	spin_lock(&vcpu->kvm->lock);
+	mutex_lock(&vcpu->kvm->lock);
 	r = mmu_topup_memory_caches(vcpu);
 	if (r)
 		goto out;
@@ -1067,7 +1067,7 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 	kvm_arch_ops->set_cr3(vcpu, vcpu->mmu.root_hpa);
 	kvm_mmu_flush_tlb(vcpu);
 out:
-	spin_unlock(&vcpu->kvm->lock);
+	mutex_unlock(&vcpu->kvm->lock);
 	return r;
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_load);
Index: linux/drivers/kvm/svm.c
===================================================================
--- linux.orig/drivers/kvm/svm.c	2007-07-20 14:54:31.000000000 +0800
+++ linux/drivers/kvm/svm.c	2007-07-20 15:00:17.000000000 +0800
@@ -908,21 +908,21 @@ static int pf_interception(struct kvm_vc
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
Index: linux/drivers/kvm/vmx.c
===================================================================
--- linux.orig/drivers/kvm/vmx.c	2007-07-20 14:56:45.000000000 +0800
+++ linux/drivers/kvm/vmx.c	2007-07-20 15:00:17.000000000 +0800
@@ -1588,19 +1588,19 @@ static int handle_exception(struct kvm_v
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
