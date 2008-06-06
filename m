Return-Path: <linux-kernel-owner+w=401wt.eu-S932073AbYFFTq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073AbYFFTq2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 15:46:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755312AbYFFTqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 15:46:19 -0400
Received: from il.qumranet.com ([212.179.150.194]:42329 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752692AbYFFTqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 15:46:16 -0400
From: Avi Kivity <avi@qumranet.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] KVM updates for Linux 2.6.26-rc5
Date: Fri,  6 Jun 2008 22:46:13 +0300
Message-Id: <1212781573-27158-1-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the repo and branch at

  git://git.kernel.org/pub/scm/linux/kernel/git/avi/kvm.git kvm-updates-2.6.26

to receive the KVM updates for 2.6.26-rc.  These include updates for the
three new KVM archs, timer and interrupt injection fixes, a fix for
hypercall breakage on AMD, and better coexistence with VMWare Server.

Shortlog, diffstat, and diff follow.

Avi Kivity (4):
      KVM: x86 emulator: fix hypercall return value on AMD
      KVM: MMU: reschedule during shadow teardown
      KVM: MMU: Fix printk() format string
      KVM: MMU: Fix is_empty_shadow_page() check

Carsten Otte (3):
      KVM: s390: fix interrupt delivery
      KVM: s390: Send program check on access error
      KVM: s390: Fix race condition in kvm_s390_handle_wait

Christian Borntraeger (3):
      KVM: s390: use yield instead of schedule to implement diag 0x44
      KVM: s390: fix locking order problem in enable_sie
      KVM: s390: handle machine checks when guest is running

Eli Collins (1):
      KVM: VMX: Clear CR4.VMXE in hardware_disable

Hollis Blanchard (5):
      KVM: ppc: Remove duplicate function
      KVM: ppc: add lwzx/stwz emulation
      KVM: ppc: Remove unmatched kunmap() call
      KVM: ppc: Use a read lock around MMU operations, and release it on error
      KVM: ppc: Report bad GFNs

Jes Sorensen (1):
      KVM: ia64: fix zero extending for mmio ld1/2/4 emulation in KVM

Marcelo Tosatti (2):
      KVM: migrate PIT timer
      KVM: IOAPIC: only set remote_irr if interrupt was injected

 arch/ia64/kvm/mmio.c           |    3 +-
 arch/powerpc/kvm/44x_tlb.c     |    9 +++----
 arch/powerpc/kvm/booke_guest.c |   33 ------------------------------
 arch/powerpc/kvm/emulate.c     |   12 ++++++++++
 arch/s390/kvm/diag.c           |    2 +-
 arch/s390/kvm/interrupt.c      |    7 ++++-
 arch/s390/kvm/kvm-s390.c       |   13 ++++++++++-
 arch/s390/mm/pgtable.c         |   44 ++++++++++++++++++++++++---------------
 arch/x86/kvm/i8254.c           |   14 +++++++++++-
 arch/x86/kvm/irq.c             |    6 +++++
 arch/x86/kvm/irq.h             |    2 +
 arch/x86/kvm/mmu.c             |    3 +-
 arch/x86/kvm/paging_tmpl.h     |    2 +-
 arch/x86/kvm/svm.c             |    2 +-
 arch/x86/kvm/vmx.c             |    3 +-
 arch/x86/kvm/x86.c             |    2 +-
 arch/x86/kvm/x86_emulate.c     |    3 +-
 drivers/s390/s390mach.c        |    1 +
 include/asm-powerpc/kvm_ppc.h  |    1 +
 include/linux/kvm_host.h       |    2 +-
 virt/kvm/ioapic.c              |   21 ++++++++++---------
 21 files changed, 106 insertions(+), 79 deletions(-)

diff --git a/arch/ia64/kvm/mmio.c b/arch/ia64/kvm/mmio.c
index 351bf70..7f1a858 100644
--- a/arch/ia64/kvm/mmio.c
+++ b/arch/ia64/kvm/mmio.c
@@ -159,7 +159,8 @@ static void mmio_access(struct kvm_vcpu *vcpu, u64 src_pa, u64 *dest,
 
 	if (p->u.ioreq.state == STATE_IORESP_READY) {
 		if (dir == IOREQ_READ)
-			*dest = p->u.ioreq.data;
+			/* it's necessary to ensure zero extending */
+			*dest = p->u.ioreq.data & (~0UL >> (64-(s*8)));
 	} else
 		panic_vm(vcpu);
 out:
diff --git a/arch/powerpc/kvm/44x_tlb.c b/arch/powerpc/kvm/44x_tlb.c
index f5d7a5e..75dff7c 100644
--- a/arch/powerpc/kvm/44x_tlb.c
+++ b/arch/powerpc/kvm/44x_tlb.c
@@ -116,8 +116,6 @@ static void kvmppc_44x_shadow_release(struct kvm_vcpu *vcpu,
 	struct tlbe *stlbe = &vcpu->arch.shadow_tlb[index];
 	struct page *page = vcpu->arch.shadow_pages[index];
 
-	kunmap(vcpu->arch.shadow_pages[index]);
-
 	if (get_tlb_v(stlbe)) {
 		if (kvmppc_44x_tlbe_is_writable(stlbe))
 			kvm_release_page_dirty(page);
@@ -144,18 +142,19 @@ void kvmppc_mmu_map(struct kvm_vcpu *vcpu, u64 gvaddr, gfn_t gfn, u64 asid,
 	stlbe = &vcpu->arch.shadow_tlb[victim];
 
 	/* Get reference to new page. */
-	down_write(&current->mm->mmap_sem);
+	down_read(&current->mm->mmap_sem);
 	new_page = gfn_to_page(vcpu->kvm, gfn);
 	if (is_error_page(new_page)) {
-		printk(KERN_ERR "Couldn't get guest page!\n");
+		printk(KERN_ERR "Couldn't get guest page for gfn %lx!\n", gfn);
 		kvm_release_page_clean(new_page);
+		up_read(&current->mm->mmap_sem);
 		return;
 	}
 	hpaddr = page_to_phys(new_page);
 
 	/* Drop reference to old page. */
 	kvmppc_44x_shadow_release(vcpu, victim);
-	up_write(&current->mm->mmap_sem);
+	up_read(&current->mm->mmap_sem);
 
 	vcpu->arch.shadow_pages[victim] = new_page;
 
diff --git a/arch/powerpc/kvm/booke_guest.c b/arch/powerpc/kvm/booke_guest.c
index 712d89a..9c8ad85 100644
--- a/arch/powerpc/kvm/booke_guest.c
+++ b/arch/powerpc/kvm/booke_guest.c
@@ -227,39 +227,6 @@ void kvmppc_check_and_deliver_interrupts(struct kvm_vcpu *vcpu)
 	}
 }
 
-static int kvmppc_emulate_mmio(struct kvm_run *run, struct kvm_vcpu *vcpu)
-{
-	enum emulation_result er;
-	int r;
-
-	er = kvmppc_emulate_instruction(run, vcpu);
-	switch (er) {
-	case EMULATE_DONE:
-		/* Future optimization: only reload non-volatiles if they were
-		 * actually modified. */
-		r = RESUME_GUEST_NV;
-		break;
-	case EMULATE_DO_MMIO:
-		run->exit_reason = KVM_EXIT_MMIO;
-		/* We must reload nonvolatiles because "update" load/store
-		 * instructions modify register state. */
-		/* Future optimization: only reload non-volatiles if they were
-		 * actually modified. */
-		r = RESUME_HOST_NV;
-		break;
-	case EMULATE_FAIL:
-		/* XXX Deliver Program interrupt to guest. */
-		printk(KERN_EMERG "%s: emulation failed (%08x)\n", __func__,
-		       vcpu->arch.last_inst);
-		r = RESUME_HOST;
-		break;
-	default:
-		BUG();
-	}
-
-	return r;
-}
-
 /**
  * kvmppc_handle_exit
  *
diff --git a/arch/powerpc/kvm/emulate.c b/arch/powerpc/kvm/emulate.c
index a03fe0c..0000974 100644
--- a/arch/powerpc/kvm/emulate.c
+++ b/arch/powerpc/kvm/emulate.c
@@ -246,6 +246,11 @@ int kvmppc_emulate_instruction(struct kvm_run *run, struct kvm_vcpu *vcpu)
 	case 31:
 		switch (get_xop(inst)) {
 
+		case 23:                                        /* lwzx */
+			rt = get_rt(inst);
+			emulated = kvmppc_handle_load(run, vcpu, rt, 4, 1);
+			break;
+
 		case 83:                                        /* mfmsr */
 			rt = get_rt(inst);
 			vcpu->arch.gpr[rt] = vcpu->arch.msr;
@@ -267,6 +272,13 @@ int kvmppc_emulate_instruction(struct kvm_run *run, struct kvm_vcpu *vcpu)
 			kvmppc_set_msr(vcpu, vcpu->arch.gpr[rs]);
 			break;
 
+		case 151:                                       /* stwx */
+			rs = get_rs(inst);
+			emulated = kvmppc_handle_store(run, vcpu,
+			                               vcpu->arch.gpr[rs],
+			                               4, 1);
+			break;
+
 		case 163:                                       /* wrteei */
 			vcpu->arch.msr = (vcpu->arch.msr & ~MSR_EE)
 			                 | (inst & MSR_EE);
diff --git a/arch/s390/kvm/diag.c b/arch/s390/kvm/diag.c
index f639a15..a0775e1 100644
--- a/arch/s390/kvm/diag.c
+++ b/arch/s390/kvm/diag.c
@@ -20,7 +20,7 @@ static int __diag_time_slice_end(struct kvm_vcpu *vcpu)
 	VCPU_EVENT(vcpu, 5, "%s", "diag time slice end");
 	vcpu->stat.diagnose_44++;
 	vcpu_put(vcpu);
-	schedule();
+	yield();
 	vcpu_load(vcpu);
 	return 0;
 }
diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index fcd1ed8..84a7fed 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -339,6 +339,11 @@ int kvm_s390_handle_wait(struct kvm_vcpu *vcpu)
 	if (kvm_cpu_has_interrupt(vcpu))
 		return 0;
 
+	__set_cpu_idle(vcpu);
+	spin_lock_bh(&vcpu->arch.local_int.lock);
+	vcpu->arch.local_int.timer_due = 0;
+	spin_unlock_bh(&vcpu->arch.local_int.lock);
+
 	if (psw_interrupts_disabled(vcpu)) {
 		VCPU_EVENT(vcpu, 3, "%s", "disabled wait");
 		__unset_cpu_idle(vcpu);
@@ -366,8 +371,6 @@ int kvm_s390_handle_wait(struct kvm_vcpu *vcpu)
 no_timer:
 	spin_lock_bh(&vcpu->arch.local_int.float_int->lock);
 	spin_lock_bh(&vcpu->arch.local_int.lock);
-	__set_cpu_idle(vcpu);
-	vcpu->arch.local_int.timer_due = 0;
 	add_wait_queue(&vcpu->arch.local_int.wq, &wait);
 	while (list_empty(&vcpu->arch.local_int.list) &&
 		list_empty(&vcpu->arch.local_int.float_int->list) &&
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 0ac36a6..6558b09 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -423,6 +423,8 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 	return -EINVAL; /* not implemented yet */
 }
 
+extern void s390_handle_mcck(void);
+
 static void __vcpu_run(struct kvm_vcpu *vcpu)
 {
 	memcpy(&vcpu->arch.sie_block->gg14, &vcpu->arch.guest_gprs[14], 16);
@@ -430,13 +432,21 @@ static void __vcpu_run(struct kvm_vcpu *vcpu)
 	if (need_resched())
 		schedule();
 
+	if (test_thread_flag(TIF_MCCK_PENDING))
+		s390_handle_mcck();
+
+	kvm_s390_deliver_pending_interrupts(vcpu);
+
 	vcpu->arch.sie_block->icptcode = 0;
 	local_irq_disable();
 	kvm_guest_enter();
 	local_irq_enable();
 	VCPU_EVENT(vcpu, 6, "entering sie flags %x",
 		   atomic_read(&vcpu->arch.sie_block->cpuflags));
-	sie64a(vcpu->arch.sie_block, vcpu->arch.guest_gprs);
+	if (sie64a(vcpu->arch.sie_block, vcpu->arch.guest_gprs)) {
+		VCPU_EVENT(vcpu, 3, "%s", "fault in sie instruction");
+		kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
+	}
 	VCPU_EVENT(vcpu, 6, "exit sie icptcode %d",
 		   vcpu->arch.sie_block->icptcode);
 	local_irq_disable();
@@ -475,7 +485,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	might_sleep();
 
 	do {
-		kvm_s390_deliver_pending_interrupts(vcpu);
 		__vcpu_run(vcpu);
 		rc = kvm_handle_sie_intercept(vcpu);
 	} while (!signal_pending(current) && !rc);
diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
index 5c1aea9..3d98ba8 100644
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -254,36 +254,46 @@ void disable_noexec(struct mm_struct *mm, struct task_struct *tsk)
 int s390_enable_sie(void)
 {
 	struct task_struct *tsk = current;
-	struct mm_struct *mm;
-	int rc;
+	struct mm_struct *mm, *old_mm;
 
-	task_lock(tsk);
-
-	rc = 0;
+	/* Do we have pgstes? if yes, we are done */
 	if (tsk->mm->context.pgstes)
-		goto unlock;
+		return 0;
 
-	rc = -EINVAL;
+	/* lets check if we are allowed to replace the mm */
+	task_lock(tsk);
 	if (!tsk->mm || atomic_read(&tsk->mm->mm_users) > 1 ||
-	    tsk->mm != tsk->active_mm || tsk->mm->ioctx_list)
-		goto unlock;
+	    tsk->mm != tsk->active_mm || tsk->mm->ioctx_list) {
+		task_unlock(tsk);
+		return -EINVAL;
+	}
+	task_unlock(tsk);
 
-	tsk->mm->context.pgstes = 1;	/* dirty little tricks .. */
+	/* we copy the mm with pgstes enabled */
+	tsk->mm->context.pgstes = 1;
 	mm = dup_mm(tsk);
 	tsk->mm->context.pgstes = 0;
-
-	rc = -ENOMEM;
 	if (!mm)
-		goto unlock;
-	mmput(tsk->mm);
+		return -ENOMEM;
+
+	/* Now lets check again if somebody attached ptrace etc */
+	task_lock(tsk);
+	if (!tsk->mm || atomic_read(&tsk->mm->mm_users) > 1 ||
+	    tsk->mm != tsk->active_mm || tsk->mm->ioctx_list) {
+		mmput(mm);
+		task_unlock(tsk);
+		return -EINVAL;
+	}
+
+	/* ok, we are alone. No ptrace, no threads, etc. */
+	old_mm = tsk->mm;
 	tsk->mm = tsk->active_mm = mm;
 	preempt_disable();
 	update_mm(mm, tsk);
 	cpu_set(smp_processor_id(), mm->cpu_vm_mask);
 	preempt_enable();
-	rc = 0;
-unlock:
 	task_unlock(tsk);
-	return rc;
+	mmput(old_mm);
+	return 0;
 }
 EXPORT_SYMBOL_GPL(s390_enable_sie);
diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 7c077a9..f2f5d26 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -200,7 +200,6 @@ int __pit_timer_fn(struct kvm_kpit_state *ps)
 
 	atomic_inc(&pt->pending);
 	smp_mb__after_atomic_inc();
-	/* FIXME: handle case where the guest is in guest mode */
 	if (vcpu0 && waitqueue_active(&vcpu0->wq)) {
 		vcpu0->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 		wake_up_interruptible(&vcpu0->wq);
@@ -237,6 +236,19 @@ static enum hrtimer_restart pit_timer_fn(struct hrtimer *data)
 		return HRTIMER_NORESTART;
 }
 
+void __kvm_migrate_pit_timer(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pit *pit = vcpu->kvm->arch.vpit;
+	struct hrtimer *timer;
+
+	if (vcpu->vcpu_id != 0 || !pit)
+		return;
+
+	timer = &pit->pit_state.pit_timer.timer;
+	if (hrtimer_cancel(timer))
+		hrtimer_start(timer, timer->expires, HRTIMER_MODE_ABS);
+}
+
 static void destroy_pit_timer(struct kvm_kpit_timer *pt)
 {
 	pr_debug("pit: execute del timer!\n");
diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index ce1f583..76d736b 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -94,3 +94,9 @@ void kvm_timer_intr_post(struct kvm_vcpu *vcpu, int vec)
 	/* TODO: PIT, RTC etc. */
 }
 EXPORT_SYMBOL_GPL(kvm_timer_intr_post);
+
+void __kvm_migrate_timers(struct kvm_vcpu *vcpu)
+{
+	__kvm_migrate_apic_timer(vcpu);
+	__kvm_migrate_pit_timer(vcpu);
+}
diff --git a/arch/x86/kvm/irq.h b/arch/x86/kvm/irq.h
index 1802134..2a15be2 100644
--- a/arch/x86/kvm/irq.h
+++ b/arch/x86/kvm/irq.h
@@ -84,6 +84,8 @@ void kvm_timer_intr_post(struct kvm_vcpu *vcpu, int vec);
 void kvm_inject_pending_timer_irqs(struct kvm_vcpu *vcpu);
 void kvm_inject_apic_timer_irqs(struct kvm_vcpu *vcpu);
 void __kvm_migrate_apic_timer(struct kvm_vcpu *vcpu);
+void __kvm_migrate_pit_timer(struct kvm_vcpu *vcpu);
+void __kvm_migrate_timers(struct kvm_vcpu *vcpu);
 
 int pit_has_pending_timer(struct kvm_vcpu *vcpu);
 int apic_has_pending_timer(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 7246b60..ee3f530 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -658,7 +658,7 @@ static int is_empty_shadow_page(u64 *spt)
 	u64 *end;
 
 	for (pos = spt, end = pos + PAGE_SIZE / sizeof(u64); pos != end; pos++)
-		if (*pos != shadow_trap_nonpresent_pte) {
+		if (is_shadow_present_pte(*pos)) {
 			printk(KERN_ERR "%s: %p %llx\n", __func__,
 			       pos, *pos);
 			return 0;
@@ -1858,6 +1858,7 @@ static void free_mmu_pages(struct kvm_vcpu *vcpu)
 		sp = container_of(vcpu->kvm->arch.active_mmu_pages.next,
 				  struct kvm_mmu_page, link);
 		kvm_mmu_zap_page(vcpu->kvm, sp);
+		cond_resched();
 	}
 	free_page((unsigned long)vcpu->arch.mmu.pae_root);
 }
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 156fe10..934c7b6 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -418,7 +418,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
 
 	/* mmio */
 	if (is_error_pfn(pfn)) {
-		pgprintk("gfn %x is mmio\n", walker.gfn);
+		pgprintk("gfn %lx is mmio\n", walker.gfn);
 		kvm_release_pfn_clean(pfn);
 		return 1;
 	}
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index ab22615..6b0d5fa 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -688,7 +688,7 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		delta = vcpu->arch.host_tsc - tsc_this;
 		svm->vmcb->control.tsc_offset += delta;
 		vcpu->cpu = cpu;
-		kvm_migrate_apic_timer(vcpu);
+		kvm_migrate_timers(vcpu);
 	}
 
 	for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++)
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index bfe4db1..02efbe7 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -608,7 +608,7 @@ static void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	if (vcpu->cpu != cpu) {
 		vcpu_clear(vmx);
-		kvm_migrate_apic_timer(vcpu);
+		kvm_migrate_timers(vcpu);
 		vpid_sync_vcpu_all(vmx);
 	}
 
@@ -1036,6 +1036,7 @@ static void hardware_enable(void *garbage)
 static void hardware_disable(void *garbage)
 {
 	asm volatile (ASM_VMX_VMXOFF : : : "cc");
+	write_cr4(read_cr4() & ~X86_CR4_VMXE);
 }
 
 static __init int adjust_vmx_controls(u32 ctl_min, u32 ctl_opt,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 21338bd..00acf13 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2758,7 +2758,7 @@ again:
 
 	if (vcpu->requests) {
 		if (test_and_clear_bit(KVM_REQ_MIGRATE_TIMER, &vcpu->requests))
-			__kvm_migrate_apic_timer(vcpu);
+			__kvm_migrate_timers(vcpu);
 		if (test_and_clear_bit(KVM_REQ_REPORT_TPR_ACCESS,
 				       &vcpu->requests)) {
 			kvm_run->exit_reason = KVM_EXIT_TPR_ACCESS;
diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index 8a96320..932f216 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -1727,7 +1727,8 @@ twobyte_insn:
 			if (rc)
 				goto done;
 
-			kvm_emulate_hypercall(ctxt->vcpu);
+			/* Let the processor re-execute the fixed hypercall */
+			c->eip = ctxt->vcpu->arch.rip;
 			/* Disable writeback. */
 			c->dst.type = OP_NONE;
 			break;
diff --git a/drivers/s390/s390mach.c b/drivers/s390/s390mach.c
index 5080f34..5bfbe76 100644
--- a/drivers/s390/s390mach.c
+++ b/drivers/s390/s390mach.c
@@ -207,6 +207,7 @@ s390_handle_mcck(void)
 		do_exit(SIGSEGV);
 	}
 }
+EXPORT_SYMBOL_GPL(s390_handle_mcck);
 
 /*
  * returns 0 if all registers could be validated
diff --git a/include/asm-powerpc/kvm_ppc.h b/include/asm-powerpc/kvm_ppc.h
index b35a7e3..5a21115 100644
--- a/include/asm-powerpc/kvm_ppc.h
+++ b/include/asm-powerpc/kvm_ppc.h
@@ -57,6 +57,7 @@ extern int kvmppc_handle_store(struct kvm_run *run, struct kvm_vcpu *vcpu,
 
 extern int kvmppc_emulate_instruction(struct kvm_run *run,
                                       struct kvm_vcpu *vcpu);
+extern int kvmppc_emulate_mmio(struct kvm_run *run, struct kvm_vcpu *vcpu);
 
 extern void kvmppc_mmu_map(struct kvm_vcpu *vcpu, u64 gvaddr, gfn_t gfn,
                            u64 asid, u32 flags);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 3989789..092b1b2 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -297,7 +297,7 @@ static inline gpa_t gfn_to_gpa(gfn_t gfn)
 	return (gpa_t)gfn << PAGE_SHIFT;
 }
 
-static inline void kvm_migrate_apic_timer(struct kvm_vcpu *vcpu)
+static inline void kvm_migrate_timers(struct kvm_vcpu *vcpu)
 {
 	set_bit(KVM_REQ_MIGRATE_TIMER, &vcpu->requests);
 }
diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index 4232fd7..98778cb 100644
--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -45,7 +45,7 @@
 #else
 #define ioapic_debug(fmt, arg...)
 #endif
-static void ioapic_deliver(struct kvm_ioapic *vioapic, int irq);
+static int ioapic_deliver(struct kvm_ioapic *vioapic, int irq);
 
 static unsigned long ioapic_read_indirect(struct kvm_ioapic *ioapic,
 					  unsigned long addr,
@@ -89,8 +89,8 @@ static void ioapic_service(struct kvm_ioapic *ioapic, unsigned int idx)
 	pent = &ioapic->redirtbl[idx];
 
 	if (!pent->fields.mask) {
-		ioapic_deliver(ioapic, idx);
-		if (pent->fields.trig_mode == IOAPIC_LEVEL_TRIG)
+		int injected = ioapic_deliver(ioapic, idx);
+		if (injected && pent->fields.trig_mode == IOAPIC_LEVEL_TRIG)
 			pent->fields.remote_irr = 1;
 	}
 	if (!pent->fields.trig_mode)
@@ -133,7 +133,7 @@ static void ioapic_write_indirect(struct kvm_ioapic *ioapic, u32 val)
 	}
 }
 
-static void ioapic_inj_irq(struct kvm_ioapic *ioapic,
+static int ioapic_inj_irq(struct kvm_ioapic *ioapic,
 			   struct kvm_vcpu *vcpu,
 			   u8 vector, u8 trig_mode, u8 delivery_mode)
 {
@@ -143,7 +143,7 @@ static void ioapic_inj_irq(struct kvm_ioapic *ioapic,
 	ASSERT((delivery_mode == IOAPIC_FIXED) ||
 	       (delivery_mode == IOAPIC_LOWEST_PRIORITY));
 
-	kvm_apic_set_irq(vcpu, vector, trig_mode);
+	return kvm_apic_set_irq(vcpu, vector, trig_mode);
 }
 
 static u32 ioapic_get_delivery_bitmask(struct kvm_ioapic *ioapic, u8 dest,
@@ -186,7 +186,7 @@ static u32 ioapic_get_delivery_bitmask(struct kvm_ioapic *ioapic, u8 dest,
 	return mask;
 }
 
-static void ioapic_deliver(struct kvm_ioapic *ioapic, int irq)
+static int ioapic_deliver(struct kvm_ioapic *ioapic, int irq)
 {
 	u8 dest = ioapic->redirtbl[irq].fields.dest_id;
 	u8 dest_mode = ioapic->redirtbl[irq].fields.dest_mode;
@@ -195,7 +195,7 @@ static void ioapic_deliver(struct kvm_ioapic *ioapic, int irq)
 	u8 trig_mode = ioapic->redirtbl[irq].fields.trig_mode;
 	u32 deliver_bitmask;
 	struct kvm_vcpu *vcpu;
-	int vcpu_id;
+	int vcpu_id, r = 0;
 
 	ioapic_debug("dest=%x dest_mode=%x delivery_mode=%x "
 		     "vector=%x trig_mode=%x\n",
@@ -204,7 +204,7 @@ static void ioapic_deliver(struct kvm_ioapic *ioapic, int irq)
 	deliver_bitmask = ioapic_get_delivery_bitmask(ioapic, dest, dest_mode);
 	if (!deliver_bitmask) {
 		ioapic_debug("no target on destination\n");
-		return;
+		return 0;
 	}
 
 	switch (delivery_mode) {
@@ -216,7 +216,7 @@ static void ioapic_deliver(struct kvm_ioapic *ioapic, int irq)
 			vcpu = ioapic->kvm->vcpus[0];
 #endif
 		if (vcpu != NULL)
-			ioapic_inj_irq(ioapic, vcpu, vector,
+			r = ioapic_inj_irq(ioapic, vcpu, vector,
 				       trig_mode, delivery_mode);
 		else
 			ioapic_debug("null lowest prio vcpu: "
@@ -234,7 +234,7 @@ static void ioapic_deliver(struct kvm_ioapic *ioapic, int irq)
 			deliver_bitmask &= ~(1 << vcpu_id);
 			vcpu = ioapic->kvm->vcpus[vcpu_id];
 			if (vcpu) {
-				ioapic_inj_irq(ioapic, vcpu, vector,
+				r = ioapic_inj_irq(ioapic, vcpu, vector,
 					       trig_mode, delivery_mode);
 			}
 		}
@@ -246,6 +246,7 @@ static void ioapic_deliver(struct kvm_ioapic *ioapic, int irq)
 		       delivery_mode);
 		break;
 	}
+	return r;
 }
 
 void kvm_ioapic_set_irq(struct kvm_ioapic *ioapic, int irq, int level)
