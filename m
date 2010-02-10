Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988Ab0BJRY2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 12:24:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25405 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755789Ab0BJRXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 12:23:15 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 35/40] KVM: switch vcpu context to use SRCU
Date: Wed, 10 Feb 2010 19:23:04 +0200
Message-Id: <1265822589-11155-36-git-send-email-avi@redhat.com>
In-Reply-To: <1265822589-11155-1-git-send-email-avi@redhat.com>
References: <1265822589-11155-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/ia64/kvm/kvm-ia64.c |   15 ++++++---------
 arch/s390/kvm/kvm-s390.h |   10 +++++++---
 arch/x86/kvm/mmu.c       |    7 +++----
 arch/x86/kvm/vmx.c       |    6 +++---
 arch/x86/kvm/x86.c       |   43 ++++++++++++++++++++++++-------------------
 include/linux/kvm_host.h |    2 ++
 6 files changed, 45 insertions(+), 38 deletions(-)

diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index d0ad538..d5e3846 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -636,12 +636,9 @@ static void kvm_vcpu_post_transition(struct kvm_vcpu *vcpu)
 static int __vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	union context *host_ctx, *guest_ctx;
-	int r;
+	int r, idx;
 
-	/*
-	 * down_read() may sleep and return with interrupts enabled
-	 */
-	down_read(&vcpu->kvm->slots_lock);
+	idx = srcu_read_lock(&vcpu->kvm->srcu);
 
 again:
 	if (signal_pending(current)) {
@@ -663,7 +660,7 @@ again:
 	if (r < 0)
 		goto vcpu_run_fail;
 
-	up_read(&vcpu->kvm->slots_lock);
+	srcu_read_unlock(&vcpu->kvm->srcu, idx);
 	kvm_guest_enter();
 
 	/*
@@ -687,7 +684,7 @@ again:
 	kvm_guest_exit();
 	preempt_enable();
 
-	down_read(&vcpu->kvm->slots_lock);
+	idx = srcu_read_lock(&vcpu->kvm->srcu);
 
 	r = kvm_handle_exit(kvm_run, vcpu);
 
@@ -697,10 +694,10 @@ again:
 	}
 
 out:
-	up_read(&vcpu->kvm->slots_lock);
+	srcu_read_unlock(&vcpu->kvm->srcu, idx);
 	if (r > 0) {
 		kvm_resched(vcpu);
-		down_read(&vcpu->kvm->slots_lock);
+		idx = srcu_read_lock(&vcpu->kvm->srcu);
 		goto again;
 	}
 
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 06cce82..60f09ab 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -67,10 +67,14 @@ static inline long kvm_s390_vcpu_get_memsize(struct kvm_vcpu *vcpu)
 
 static inline void kvm_s390_vcpu_set_mem(struct kvm_vcpu *vcpu)
 {
+	int idx;
 	struct kvm_memory_slot *mem;
+	struct kvm_memslots *memslots;
 
-	down_read(&vcpu->kvm->slots_lock);
-	mem = &vcpu->kvm->memslots[0];
+	idx = srcu_read_lock(&vcpu->kvm->srcu);
+	memslots = rcu_dereference(vcpu->kvm->memslots);
+
+	mem = &memslots->memslots[0];
 
 	vcpu->arch.sie_block->gmsor = mem->userspace_addr;
 	vcpu->arch.sie_block->gmslm =
@@ -78,7 +82,7 @@ static inline void kvm_s390_vcpu_set_mem(struct kvm_vcpu *vcpu)
 		(mem->npages << PAGE_SHIFT) +
 		VIRTIODESCSPACE - 1ul;
 
-	up_read(&vcpu->kvm->slots_lock);
+	srcu_read_unlock(&vcpu->kvm->srcu, idx);
 }
 
 /* implemented in priv.c */
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index f8bf42a..25aabd0 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2933,10 +2933,9 @@ static int mmu_shrink(int nr_to_scan, gfp_t gfp_mask)
 	spin_lock(&kvm_lock);
 
 	list_for_each_entry(kvm, &vm_list, vm_list) {
-		int npages;
+		int npages, idx;
 
-		if (!down_read_trylock(&kvm->slots_lock))
-			continue;
+		idx = srcu_read_lock(&kvm->srcu);
 		spin_lock(&kvm->mmu_lock);
 		npages = kvm->arch.n_alloc_mmu_pages -
 			 kvm->arch.n_free_mmu_pages;
@@ -2949,7 +2948,7 @@ static int mmu_shrink(int nr_to_scan, gfp_t gfp_mask)
 		nr_to_scan--;
 
 		spin_unlock(&kvm->mmu_lock);
-		up_read(&kvm->slots_lock);
+		srcu_read_unlock(&kvm->srcu, idx);
 	}
 	if (kvm_freed)
 		list_move_tail(&kvm_freed->vm_list, &vm_list);
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index f1cae7d..22ab713 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2478,10 +2478,10 @@ static int vmx_vcpu_reset(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	u64 msr;
-	int ret;
+	int ret, idx;
 
 	vcpu->arch.regs_avail = ~((1 << VCPU_REGS_RIP) | (1 << VCPU_REGS_RSP));
-	down_read(&vcpu->kvm->slots_lock);
+	idx = srcu_read_lock(&vcpu->kvm->srcu);
 	if (!init_rmode(vmx->vcpu.kvm)) {
 		ret = -ENOMEM;
 		goto out;
@@ -2589,7 +2589,7 @@ static int vmx_vcpu_reset(struct kvm_vcpu *vcpu)
 	vmx->emulation_required = 0;
 
 out:
-	up_read(&vcpu->kvm->slots_lock);
+	srcu_read_unlock(&vcpu->kvm->srcu, idx);
 	return ret;
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b9adeae..0cb795c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1307,15 +1307,15 @@ static int __msr_io(struct kvm_vcpu *vcpu, struct kvm_msrs *msrs,
 		    int (*do_msr)(struct kvm_vcpu *vcpu,
 				  unsigned index, u64 *data))
 {
-	int i;
+	int i, idx;
 
 	vcpu_load(vcpu);
 
-	down_read(&vcpu->kvm->slots_lock);
+	idx = srcu_read_lock(&vcpu->kvm->srcu);
 	for (i = 0; i < msrs->nmsrs; ++i)
 		if (do_msr(vcpu, entries[i].index, &entries[i].data))
 			break;
-	up_read(&vcpu->kvm->slots_lock);
+	srcu_read_unlock(&vcpu->kvm->srcu, idx);
 
 	vcpu_put(vcpu);
 
@@ -3901,14 +3901,15 @@ static void vapic_enter(struct kvm_vcpu *vcpu)
 static void vapic_exit(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
+	int idx;
 
 	if (!apic || !apic->vapic_addr)
 		return;
 
-	down_read(&vcpu->kvm->slots_lock);
+	idx = srcu_read_lock(&vcpu->kvm->srcu);
 	kvm_release_page_dirty(apic->vapic_page);
 	mark_page_dirty(vcpu->kvm, apic->vapic_addr >> PAGE_SHIFT);
-	up_read(&vcpu->kvm->slots_lock);
+	srcu_read_unlock(&vcpu->kvm->srcu, idx);
 }
 
 static void update_cr8_intercept(struct kvm_vcpu *vcpu)
@@ -4037,7 +4038,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		kvm_lapic_sync_to_vapic(vcpu);
 	}
 
-	up_read(&vcpu->kvm->slots_lock);
+	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
 
 	kvm_guest_enter();
 
@@ -4079,7 +4080,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 	preempt_enable();
 
-	down_read(&vcpu->kvm->slots_lock);
+	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
 
 	/*
 	 * Profile KVM exit RIPs:
@@ -4101,6 +4102,7 @@ out:
 static int __vcpu_run(struct kvm_vcpu *vcpu)
 {
 	int r;
+	struct kvm *kvm = vcpu->kvm;
 
 	if (unlikely(vcpu->arch.mp_state == KVM_MP_STATE_SIPI_RECEIVED)) {
 		pr_debug("vcpu %d received sipi with vector # %x\n",
@@ -4112,7 +4114,7 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
 		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 	}
 
-	down_read(&vcpu->kvm->slots_lock);
+	vcpu->srcu_idx = srcu_read_lock(&kvm->srcu);
 	vapic_enter(vcpu);
 
 	r = 1;
@@ -4120,9 +4122,9 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
 		if (vcpu->arch.mp_state == KVM_MP_STATE_RUNNABLE)
 			r = vcpu_enter_guest(vcpu);
 		else {
-			up_read(&vcpu->kvm->slots_lock);
+			srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
 			kvm_vcpu_block(vcpu);
-			down_read(&vcpu->kvm->slots_lock);
+			vcpu->srcu_idx = srcu_read_lock(&kvm->srcu);
 			if (test_and_clear_bit(KVM_REQ_UNHALT, &vcpu->requests))
 			{
 				switch(vcpu->arch.mp_state) {
@@ -4157,13 +4159,13 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
 			++vcpu->stat.signal_exits;
 		}
 		if (need_resched()) {
-			up_read(&vcpu->kvm->slots_lock);
+			srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
 			kvm_resched(vcpu);
-			down_read(&vcpu->kvm->slots_lock);
+			vcpu->srcu_idx = srcu_read_lock(&kvm->srcu);
 		}
 	}
 
-	up_read(&vcpu->kvm->slots_lock);
+	srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
 	post_kvm_run_save(vcpu);
 
 	vapic_exit(vcpu);
@@ -4202,10 +4204,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		vcpu->mmio_read_completed = 1;
 		vcpu->mmio_needed = 0;
 
-		down_read(&vcpu->kvm->slots_lock);
+		vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
 		r = emulate_instruction(vcpu, vcpu->arch.mmio_fault_cr2, 0,
 					EMULTYPE_NO_DECODE);
-		up_read(&vcpu->kvm->slots_lock);
+		srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
 		if (r == EMULATE_DO_MMIO) {
 			/*
 			 * Read-modify-write.  Back to userspace.
@@ -4968,11 +4970,12 @@ int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
 {
 	unsigned long vaddr = tr->linear_address;
 	gpa_t gpa;
+	int idx;
 
 	vcpu_load(vcpu);
-	down_read(&vcpu->kvm->slots_lock);
+	idx = srcu_read_lock(&vcpu->kvm->srcu);
 	gpa = vcpu->arch.mmu.gva_to_gpa(vcpu, vaddr);
-	up_read(&vcpu->kvm->slots_lock);
+	srcu_read_unlock(&vcpu->kvm->srcu, idx);
 	tr->physical_address = gpa;
 	tr->valid = gpa != UNMAPPED_GVA;
 	tr->writeable = 1;
@@ -5224,11 +5227,13 @@ fail:
 
 void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu)
 {
+	int idx;
+
 	kfree(vcpu->arch.mce_banks);
 	kvm_free_lapic(vcpu);
-	down_read(&vcpu->kvm->slots_lock);
+	idx = srcu_read_lock(&vcpu->kvm->srcu);
 	kvm_mmu_destroy(vcpu);
-	up_read(&vcpu->kvm->slots_lock);
+	srcu_read_unlock(&vcpu->kvm->srcu, idx);
 	free_page((unsigned long)vcpu->arch.pio_data);
 }
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 5e9cb90..0bb9aa2 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -83,6 +83,8 @@ struct kvm_vcpu {
 	struct kvm_run *run;
 	unsigned long requests;
 	unsigned long guest_debug;
+	int srcu_idx;
+
 	int fpu_active;
 	int guest_fpu_loaded;
 	wait_queue_head_t wq;
-- 
1.6.5.3

