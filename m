Return-Path: <linux-kernel-owner+w=401wt.eu-S1751659AbXLZLR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659AbXLZLR5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 06:17:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752580AbXLZLGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 06:06:53 -0500
Received: from il.qumranet.com ([82.166.9.18]:50478 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847AbXLZLGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 06:06:08 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Hollis Blanchard <hollisb@us.ibm.com>
Subject: [PATCH 35/55] KVM: Portability: Move x86 vcpu ioctl handlers to x86.c
Date: Wed, 26 Dec 2007 13:05:40 +0200
Message-Id: <1198667160-22953-36-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198667160-22953-1-git-send-email-avi@qumranet.com>
References: <1198667160-22953-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |   10 +
 drivers/kvm/kvm_main.c |  442 +-----------------------------------------------
 drivers/kvm/x86.c      |  427 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 443 insertions(+), 436 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 469ca42..3f5ffc3 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -636,6 +636,16 @@ void kvm_arch_destroy_vm(struct kvm *kvm);
 int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu);
 int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu);
 
+int kvm_arch_vcpu_ioctl_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs);
+int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs);
+int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
+				  struct kvm_sregs *sregs);
+int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
+				  struct kvm_sregs *sregs);
+int kvm_arch_vcpu_ioctl_debug_guest(struct kvm_vcpu *vcpu,
+				    struct kvm_debug_guest *dbg);
+int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run);
+
 __init void kvm_arch_init(void);
 
 static inline void kvm_guest_enter(void)
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 4620885..e12bdc1 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -779,422 +779,6 @@ void kvm_resched(struct kvm_vcpu *vcpu)
 EXPORT_SYMBOL_GPL(kvm_resched);
 
 /*
- * Check if userspace requested an interrupt window, and that the
- * interrupt window is open.
- *
- * No need to exit to userspace if we already have an interrupt queued.
- */
-static int dm_request_for_irq_injection(struct kvm_vcpu *vcpu,
-					  struct kvm_run *kvm_run)
-{
-	return (!vcpu->irq_summary &&
-		kvm_run->request_interrupt_window &&
-		vcpu->interrupt_window_open &&
-		(kvm_x86_ops->get_rflags(vcpu) & X86_EFLAGS_IF));
-}
-
-static void post_kvm_run_save(struct kvm_vcpu *vcpu,
-			      struct kvm_run *kvm_run)
-{
-	kvm_run->if_flag = (kvm_x86_ops->get_rflags(vcpu) & X86_EFLAGS_IF) != 0;
-	kvm_run->cr8 = get_cr8(vcpu);
-	kvm_run->apic_base = kvm_get_apic_base(vcpu);
-	if (irqchip_in_kernel(vcpu->kvm))
-		kvm_run->ready_for_interrupt_injection = 1;
-	else
-		kvm_run->ready_for_interrupt_injection =
-					(vcpu->interrupt_window_open &&
-					 vcpu->irq_summary == 0);
-}
-
-static int __vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
-{
-	int r;
-
-	if (unlikely(vcpu->mp_state == VCPU_MP_STATE_SIPI_RECEIVED)) {
-		pr_debug("vcpu %d received sipi with vector # %x\n",
-		       vcpu->vcpu_id, vcpu->sipi_vector);
-		kvm_lapic_reset(vcpu);
-		r = kvm_x86_ops->vcpu_reset(vcpu);
-		if (r)
-			return r;
-		vcpu->mp_state = VCPU_MP_STATE_RUNNABLE;
-	}
-
-preempted:
-	if (vcpu->guest_debug.enabled)
-		kvm_x86_ops->guest_debug_pre(vcpu);
-
-again:
-	r = kvm_mmu_reload(vcpu);
-	if (unlikely(r))
-		goto out;
-
-	kvm_inject_pending_timer_irqs(vcpu);
-
-	preempt_disable();
-
-	kvm_x86_ops->prepare_guest_switch(vcpu);
-	kvm_load_guest_fpu(vcpu);
-
-	local_irq_disable();
-
-	if (signal_pending(current)) {
-		local_irq_enable();
-		preempt_enable();
-		r = -EINTR;
-		kvm_run->exit_reason = KVM_EXIT_INTR;
-		++vcpu->stat.signal_exits;
-		goto out;
-	}
-
-	if (irqchip_in_kernel(vcpu->kvm))
-		kvm_x86_ops->inject_pending_irq(vcpu);
-	else if (!vcpu->mmio_read_completed)
-		kvm_x86_ops->inject_pending_vectors(vcpu, kvm_run);
-
-	vcpu->guest_mode = 1;
-	kvm_guest_enter();
-
-	if (vcpu->requests)
-		if (test_and_clear_bit(KVM_REQ_TLB_FLUSH, &vcpu->requests))
-			kvm_x86_ops->tlb_flush(vcpu);
-
-	kvm_x86_ops->run(vcpu, kvm_run);
-
-	vcpu->guest_mode = 0;
-	local_irq_enable();
-
-	++vcpu->stat.exits;
-
-	/*
-	 * We must have an instruction between local_irq_enable() and
-	 * kvm_guest_exit(), so the timer interrupt isn't delayed by
-	 * the interrupt shadow.  The stat.exits increment will do nicely.
-	 * But we need to prevent reordering, hence this barrier():
-	 */
-	barrier();
-
-	kvm_guest_exit();
-
-	preempt_enable();
-
-	/*
-	 * Profile KVM exit RIPs:
-	 */
-	if (unlikely(prof_on == KVM_PROFILING)) {
-		kvm_x86_ops->cache_regs(vcpu);
-		profile_hit(KVM_PROFILING, (void *)vcpu->rip);
-	}
-
-	r = kvm_x86_ops->handle_exit(kvm_run, vcpu);
-
-	if (r > 0) {
-		if (dm_request_for_irq_injection(vcpu, kvm_run)) {
-			r = -EINTR;
-			kvm_run->exit_reason = KVM_EXIT_INTR;
-			++vcpu->stat.request_irq_exits;
-			goto out;
-		}
-		if (!need_resched()) {
-			++vcpu->stat.light_exits;
-			goto again;
-		}
-	}
-
-out:
-	if (r > 0) {
-		kvm_resched(vcpu);
-		goto preempted;
-	}
-
-	post_kvm_run_save(vcpu, kvm_run);
-
-	return r;
-}
-
-
-static int kvm_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
-{
-	int r;
-	sigset_t sigsaved;
-
-	vcpu_load(vcpu);
-
-	if (unlikely(vcpu->mp_state == VCPU_MP_STATE_UNINITIALIZED)) {
-		kvm_vcpu_block(vcpu);
-		vcpu_put(vcpu);
-		return -EAGAIN;
-	}
-
-	if (vcpu->sigset_active)
-		sigprocmask(SIG_SETMASK, &vcpu->sigset, &sigsaved);
-
-	/* re-sync apic's tpr */
-	if (!irqchip_in_kernel(vcpu->kvm))
-		set_cr8(vcpu, kvm_run->cr8);
-
-	if (vcpu->pio.cur_count) {
-		r = complete_pio(vcpu);
-		if (r)
-			goto out;
-	}
-#if CONFIG_HAS_IOMEM
-	if (vcpu->mmio_needed) {
-		memcpy(vcpu->mmio_data, kvm_run->mmio.data, 8);
-		vcpu->mmio_read_completed = 1;
-		vcpu->mmio_needed = 0;
-		r = emulate_instruction(vcpu, kvm_run,
-					vcpu->mmio_fault_cr2, 0, 1);
-		if (r == EMULATE_DO_MMIO) {
-			/*
-			 * Read-modify-write.  Back to userspace.
-			 */
-			r = 0;
-			goto out;
-		}
-	}
-#endif
-	if (kvm_run->exit_reason == KVM_EXIT_HYPERCALL) {
-		kvm_x86_ops->cache_regs(vcpu);
-		vcpu->regs[VCPU_REGS_RAX] = kvm_run->hypercall.ret;
-		kvm_x86_ops->decache_regs(vcpu);
-	}
-
-	r = __vcpu_run(vcpu, kvm_run);
-
-out:
-	if (vcpu->sigset_active)
-		sigprocmask(SIG_SETMASK, &sigsaved, NULL);
-
-	vcpu_put(vcpu);
-	return r;
-}
-
-static int kvm_vcpu_ioctl_get_regs(struct kvm_vcpu *vcpu,
-				   struct kvm_regs *regs)
-{
-	vcpu_load(vcpu);
-
-	kvm_x86_ops->cache_regs(vcpu);
-
-	regs->rax = vcpu->regs[VCPU_REGS_RAX];
-	regs->rbx = vcpu->regs[VCPU_REGS_RBX];
-	regs->rcx = vcpu->regs[VCPU_REGS_RCX];
-	regs->rdx = vcpu->regs[VCPU_REGS_RDX];
-	regs->rsi = vcpu->regs[VCPU_REGS_RSI];
-	regs->rdi = vcpu->regs[VCPU_REGS_RDI];
-	regs->rsp = vcpu->regs[VCPU_REGS_RSP];
-	regs->rbp = vcpu->regs[VCPU_REGS_RBP];
-#ifdef CONFIG_X86_64
-	regs->r8 = vcpu->regs[VCPU_REGS_R8];
-	regs->r9 = vcpu->regs[VCPU_REGS_R9];
-	regs->r10 = vcpu->regs[VCPU_REGS_R10];
-	regs->r11 = vcpu->regs[VCPU_REGS_R11];
-	regs->r12 = vcpu->regs[VCPU_REGS_R12];
-	regs->r13 = vcpu->regs[VCPU_REGS_R13];
-	regs->r14 = vcpu->regs[VCPU_REGS_R14];
-	regs->r15 = vcpu->regs[VCPU_REGS_R15];
-#endif
-
-	regs->rip = vcpu->rip;
-	regs->rflags = kvm_x86_ops->get_rflags(vcpu);
-
-	/*
-	 * Don't leak debug flags in case they were set for guest debugging
-	 */
-	if (vcpu->guest_debug.enabled && vcpu->guest_debug.singlestep)
-		regs->rflags &= ~(X86_EFLAGS_TF | X86_EFLAGS_RF);
-
-	vcpu_put(vcpu);
-
-	return 0;
-}
-
-static int kvm_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu,
-				   struct kvm_regs *regs)
-{
-	vcpu_load(vcpu);
-
-	vcpu->regs[VCPU_REGS_RAX] = regs->rax;
-	vcpu->regs[VCPU_REGS_RBX] = regs->rbx;
-	vcpu->regs[VCPU_REGS_RCX] = regs->rcx;
-	vcpu->regs[VCPU_REGS_RDX] = regs->rdx;
-	vcpu->regs[VCPU_REGS_RSI] = regs->rsi;
-	vcpu->regs[VCPU_REGS_RDI] = regs->rdi;
-	vcpu->regs[VCPU_REGS_RSP] = regs->rsp;
-	vcpu->regs[VCPU_REGS_RBP] = regs->rbp;
-#ifdef CONFIG_X86_64
-	vcpu->regs[VCPU_REGS_R8] = regs->r8;
-	vcpu->regs[VCPU_REGS_R9] = regs->r9;
-	vcpu->regs[VCPU_REGS_R10] = regs->r10;
-	vcpu->regs[VCPU_REGS_R11] = regs->r11;
-	vcpu->regs[VCPU_REGS_R12] = regs->r12;
-	vcpu->regs[VCPU_REGS_R13] = regs->r13;
-	vcpu->regs[VCPU_REGS_R14] = regs->r14;
-	vcpu->regs[VCPU_REGS_R15] = regs->r15;
-#endif
-
-	vcpu->rip = regs->rip;
-	kvm_x86_ops->set_rflags(vcpu, regs->rflags);
-
-	kvm_x86_ops->decache_regs(vcpu);
-
-	vcpu_put(vcpu);
-
-	return 0;
-}
-
-static void get_segment(struct kvm_vcpu *vcpu,
-			struct kvm_segment *var, int seg)
-{
-	return kvm_x86_ops->get_segment(vcpu, var, seg);
-}
-
-static int kvm_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
-				    struct kvm_sregs *sregs)
-{
-	struct descriptor_table dt;
-	int pending_vec;
-
-	vcpu_load(vcpu);
-
-	get_segment(vcpu, &sregs->cs, VCPU_SREG_CS);
-	get_segment(vcpu, &sregs->ds, VCPU_SREG_DS);
-	get_segment(vcpu, &sregs->es, VCPU_SREG_ES);
-	get_segment(vcpu, &sregs->fs, VCPU_SREG_FS);
-	get_segment(vcpu, &sregs->gs, VCPU_SREG_GS);
-	get_segment(vcpu, &sregs->ss, VCPU_SREG_SS);
-
-	get_segment(vcpu, &sregs->tr, VCPU_SREG_TR);
-	get_segment(vcpu, &sregs->ldt, VCPU_SREG_LDTR);
-
-	kvm_x86_ops->get_idt(vcpu, &dt);
-	sregs->idt.limit = dt.limit;
-	sregs->idt.base = dt.base;
-	kvm_x86_ops->get_gdt(vcpu, &dt);
-	sregs->gdt.limit = dt.limit;
-	sregs->gdt.base = dt.base;
-
-	kvm_x86_ops->decache_cr4_guest_bits(vcpu);
-	sregs->cr0 = vcpu->cr0;
-	sregs->cr2 = vcpu->cr2;
-	sregs->cr3 = vcpu->cr3;
-	sregs->cr4 = vcpu->cr4;
-	sregs->cr8 = get_cr8(vcpu);
-	sregs->efer = vcpu->shadow_efer;
-	sregs->apic_base = kvm_get_apic_base(vcpu);
-
-	if (irqchip_in_kernel(vcpu->kvm)) {
-		memset(sregs->interrupt_bitmap, 0,
-		       sizeof sregs->interrupt_bitmap);
-		pending_vec = kvm_x86_ops->get_irq(vcpu);
-		if (pending_vec >= 0)
-			set_bit(pending_vec,
-				(unsigned long *)sregs->interrupt_bitmap);
-	} else
-		memcpy(sregs->interrupt_bitmap, vcpu->irq_pending,
-		       sizeof sregs->interrupt_bitmap);
-
-	vcpu_put(vcpu);
-
-	return 0;
-}
-
-static void set_segment(struct kvm_vcpu *vcpu,
-			struct kvm_segment *var, int seg)
-{
-	return kvm_x86_ops->set_segment(vcpu, var, seg);
-}
-
-static int kvm_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
-				    struct kvm_sregs *sregs)
-{
-	int mmu_reset_needed = 0;
-	int i, pending_vec, max_bits;
-	struct descriptor_table dt;
-
-	vcpu_load(vcpu);
-
-	dt.limit = sregs->idt.limit;
-	dt.base = sregs->idt.base;
-	kvm_x86_ops->set_idt(vcpu, &dt);
-	dt.limit = sregs->gdt.limit;
-	dt.base = sregs->gdt.base;
-	kvm_x86_ops->set_gdt(vcpu, &dt);
-
-	vcpu->cr2 = sregs->cr2;
-	mmu_reset_needed |= vcpu->cr3 != sregs->cr3;
-	vcpu->cr3 = sregs->cr3;
-
-	set_cr8(vcpu, sregs->cr8);
-
-	mmu_reset_needed |= vcpu->shadow_efer != sregs->efer;
-#ifdef CONFIG_X86_64
-	kvm_x86_ops->set_efer(vcpu, sregs->efer);
-#endif
-	kvm_set_apic_base(vcpu, sregs->apic_base);
-
-	kvm_x86_ops->decache_cr4_guest_bits(vcpu);
-
-	mmu_reset_needed |= vcpu->cr0 != sregs->cr0;
-	vcpu->cr0 = sregs->cr0;
-	kvm_x86_ops->set_cr0(vcpu, sregs->cr0);
-
-	mmu_reset_needed |= vcpu->cr4 != sregs->cr4;
-	kvm_x86_ops->set_cr4(vcpu, sregs->cr4);
-	if (!is_long_mode(vcpu) && is_pae(vcpu))
-		load_pdptrs(vcpu, vcpu->cr3);
-
-	if (mmu_reset_needed)
-		kvm_mmu_reset_context(vcpu);
-
-	if (!irqchip_in_kernel(vcpu->kvm)) {
-		memcpy(vcpu->irq_pending, sregs->interrupt_bitmap,
-		       sizeof vcpu->irq_pending);
-		vcpu->irq_summary = 0;
-		for (i = 0; i < ARRAY_SIZE(vcpu->irq_pending); ++i)
-			if (vcpu->irq_pending[i])
-				__set_bit(i, &vcpu->irq_summary);
-	} else {
-		max_bits = (sizeof sregs->interrupt_bitmap) << 3;
-		pending_vec = find_first_bit(
-			(const unsigned long *)sregs->interrupt_bitmap,
-			max_bits);
-		/* Only pending external irq is handled here */
-		if (pending_vec < max_bits) {
-			kvm_x86_ops->set_irq(vcpu, pending_vec);
-			pr_debug("Set back pending irq %d\n",
-				 pending_vec);
-		}
-	}
-
-	set_segment(vcpu, &sregs->cs, VCPU_SREG_CS);
-	set_segment(vcpu, &sregs->ds, VCPU_SREG_DS);
-	set_segment(vcpu, &sregs->es, VCPU_SREG_ES);
-	set_segment(vcpu, &sregs->fs, VCPU_SREG_FS);
-	set_segment(vcpu, &sregs->gs, VCPU_SREG_GS);
-	set_segment(vcpu, &sregs->ss, VCPU_SREG_SS);
-
-	set_segment(vcpu, &sregs->tr, VCPU_SREG_TR);
-	set_segment(vcpu, &sregs->ldt, VCPU_SREG_LDTR);
-
-	vcpu_put(vcpu);
-
-	return 0;
-}
-
-void kvm_get_cs_db_l_bits(struct kvm_vcpu *vcpu, int *db, int *l)
-{
-	struct kvm_segment cs;
-
-	get_segment(vcpu, &cs, VCPU_SREG_CS);
-	*db = cs.db;
-	*l = cs.l;
-}
-EXPORT_SYMBOL_GPL(kvm_get_cs_db_l_bits);
-
-/*
  * Translate a guest virtual address to a guest physical address.
  */
 static int kvm_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
@@ -1233,20 +817,6 @@ static int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
-static int kvm_vcpu_ioctl_debug_guest(struct kvm_vcpu *vcpu,
-				      struct kvm_debug_guest *dbg)
-{
-	int r;
-
-	vcpu_load(vcpu);
-
-	r = kvm_x86_ops->set_guest_debug(vcpu, dbg);
-
-	vcpu_put(vcpu);
-
-	return r;
-}
-
 static struct page *kvm_vcpu_nopage(struct vm_area_struct *vma,
 				    unsigned long address,
 				    int *type)
@@ -1392,13 +962,13 @@ static long kvm_vcpu_ioctl(struct file *filp,
 		r = -EINVAL;
 		if (arg)
 			goto out;
-		r = kvm_vcpu_ioctl_run(vcpu, vcpu->run);
+		r = kvm_arch_vcpu_ioctl_run(vcpu, vcpu->run);
 		break;
 	case KVM_GET_REGS: {
 		struct kvm_regs kvm_regs;
 
 		memset(&kvm_regs, 0, sizeof kvm_regs);
-		r = kvm_vcpu_ioctl_get_regs(vcpu, &kvm_regs);
+		r = kvm_arch_vcpu_ioctl_get_regs(vcpu, &kvm_regs);
 		if (r)
 			goto out;
 		r = -EFAULT;
@@ -1413,7 +983,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
 		r = -EFAULT;
 		if (copy_from_user(&kvm_regs, argp, sizeof kvm_regs))
 			goto out;
-		r = kvm_vcpu_ioctl_set_regs(vcpu, &kvm_regs);
+		r = kvm_arch_vcpu_ioctl_set_regs(vcpu, &kvm_regs);
 		if (r)
 			goto out;
 		r = 0;
@@ -1423,7 +993,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
 		struct kvm_sregs kvm_sregs;
 
 		memset(&kvm_sregs, 0, sizeof kvm_sregs);
-		r = kvm_vcpu_ioctl_get_sregs(vcpu, &kvm_sregs);
+		r = kvm_arch_vcpu_ioctl_get_sregs(vcpu, &kvm_sregs);
 		if (r)
 			goto out;
 		r = -EFAULT;
@@ -1438,7 +1008,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
 		r = -EFAULT;
 		if (copy_from_user(&kvm_sregs, argp, sizeof kvm_sregs))
 			goto out;
-		r = kvm_vcpu_ioctl_set_sregs(vcpu, &kvm_sregs);
+		r = kvm_arch_vcpu_ioctl_set_sregs(vcpu, &kvm_sregs);
 		if (r)
 			goto out;
 		r = 0;
@@ -1477,7 +1047,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
 		r = -EFAULT;
 		if (copy_from_user(&dbg, argp, sizeof dbg))
 			goto out;
-		r = kvm_vcpu_ioctl_debug_guest(vcpu, &dbg);
+		r = kvm_arch_vcpu_ioctl_debug_guest(vcpu, &dbg);
 		if (r)
 			goto out;
 		r = 0;
diff --git a/drivers/kvm/x86.c b/drivers/kvm/x86.c
index ef1661f..394da66 100644
--- a/drivers/kvm/x86.c
+++ b/drivers/kvm/x86.c
@@ -1787,6 +1787,433 @@ void kvm_emulate_cpuid(struct kvm_vcpu *vcpu)
 EXPORT_SYMBOL_GPL(kvm_emulate_cpuid);
 
 /*
+ * Check if userspace requested an interrupt window, and that the
+ * interrupt window is open.
+ *
+ * No need to exit to userspace if we already have an interrupt queued.
+ */
+static int dm_request_for_irq_injection(struct kvm_vcpu *vcpu,
+					  struct kvm_run *kvm_run)
+{
+	return (!vcpu->irq_summary &&
+		kvm_run->request_interrupt_window &&
+		vcpu->interrupt_window_open &&
+		(kvm_x86_ops->get_rflags(vcpu) & X86_EFLAGS_IF));
+}
+
+static void post_kvm_run_save(struct kvm_vcpu *vcpu,
+			      struct kvm_run *kvm_run)
+{
+	kvm_run->if_flag = (kvm_x86_ops->get_rflags(vcpu) & X86_EFLAGS_IF) != 0;
+	kvm_run->cr8 = get_cr8(vcpu);
+	kvm_run->apic_base = kvm_get_apic_base(vcpu);
+	if (irqchip_in_kernel(vcpu->kvm))
+		kvm_run->ready_for_interrupt_injection = 1;
+	else
+		kvm_run->ready_for_interrupt_injection =
+					(vcpu->interrupt_window_open &&
+					 vcpu->irq_summary == 0);
+}
+
+static int __vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+{
+	int r;
+
+	if (unlikely(vcpu->mp_state == VCPU_MP_STATE_SIPI_RECEIVED)) {
+		pr_debug("vcpu %d received sipi with vector # %x\n",
+		       vcpu->vcpu_id, vcpu->sipi_vector);
+		kvm_lapic_reset(vcpu);
+		r = kvm_x86_ops->vcpu_reset(vcpu);
+		if (r)
+			return r;
+		vcpu->mp_state = VCPU_MP_STATE_RUNNABLE;
+	}
+
+preempted:
+	if (vcpu->guest_debug.enabled)
+		kvm_x86_ops->guest_debug_pre(vcpu);
+
+again:
+	r = kvm_mmu_reload(vcpu);
+	if (unlikely(r))
+		goto out;
+
+	kvm_inject_pending_timer_irqs(vcpu);
+
+	preempt_disable();
+
+	kvm_x86_ops->prepare_guest_switch(vcpu);
+	kvm_load_guest_fpu(vcpu);
+
+	local_irq_disable();
+
+	if (signal_pending(current)) {
+		local_irq_enable();
+		preempt_enable();
+		r = -EINTR;
+		kvm_run->exit_reason = KVM_EXIT_INTR;
+		++vcpu->stat.signal_exits;
+		goto out;
+	}
+
+	if (irqchip_in_kernel(vcpu->kvm))
+		kvm_x86_ops->inject_pending_irq(vcpu);
+	else if (!vcpu->mmio_read_completed)
+		kvm_x86_ops->inject_pending_vectors(vcpu, kvm_run);
+
+	vcpu->guest_mode = 1;
+	kvm_guest_enter();
+
+	if (vcpu->requests)
+		if (test_and_clear_bit(KVM_REQ_TLB_FLUSH, &vcpu->requests))
+			kvm_x86_ops->tlb_flush(vcpu);
+
+	kvm_x86_ops->run(vcpu, kvm_run);
+
+	vcpu->guest_mode = 0;
+	local_irq_enable();
+
+	++vcpu->stat.exits;
+
+	/*
+	 * We must have an instruction between local_irq_enable() and
+	 * kvm_guest_exit(), so the timer interrupt isn't delayed by
+	 * the interrupt shadow.  The stat.exits increment will do nicely.
+	 * But we need to prevent reordering, hence this barrier():
+	 */
+	barrier();
+
+	kvm_guest_exit();
+
+	preempt_enable();
+
+	/*
+	 * Profile KVM exit RIPs:
+	 */
+	if (unlikely(prof_on == KVM_PROFILING)) {
+		kvm_x86_ops->cache_regs(vcpu);
+		profile_hit(KVM_PROFILING, (void *)vcpu->rip);
+	}
+
+	r = kvm_x86_ops->handle_exit(kvm_run, vcpu);
+
+	if (r > 0) {
+		if (dm_request_for_irq_injection(vcpu, kvm_run)) {
+			r = -EINTR;
+			kvm_run->exit_reason = KVM_EXIT_INTR;
+			++vcpu->stat.request_irq_exits;
+			goto out;
+		}
+		if (!need_resched()) {
+			++vcpu->stat.light_exits;
+			goto again;
+		}
+	}
+
+out:
+	if (r > 0) {
+		kvm_resched(vcpu);
+		goto preempted;
+	}
+
+	post_kvm_run_save(vcpu, kvm_run);
+
+	return r;
+}
+
+int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+{
+	int r;
+	sigset_t sigsaved;
+
+	vcpu_load(vcpu);
+
+	if (unlikely(vcpu->mp_state == VCPU_MP_STATE_UNINITIALIZED)) {
+		kvm_vcpu_block(vcpu);
+		vcpu_put(vcpu);
+		return -EAGAIN;
+	}
+
+	if (vcpu->sigset_active)
+		sigprocmask(SIG_SETMASK, &vcpu->sigset, &sigsaved);
+
+	/* re-sync apic's tpr */
+	if (!irqchip_in_kernel(vcpu->kvm))
+		set_cr8(vcpu, kvm_run->cr8);
+
+	if (vcpu->pio.cur_count) {
+		r = complete_pio(vcpu);
+		if (r)
+			goto out;
+	}
+#if CONFIG_HAS_IOMEM
+	if (vcpu->mmio_needed) {
+		memcpy(vcpu->mmio_data, kvm_run->mmio.data, 8);
+		vcpu->mmio_read_completed = 1;
+		vcpu->mmio_needed = 0;
+		r = emulate_instruction(vcpu, kvm_run,
+					vcpu->mmio_fault_cr2, 0, 1);
+		if (r == EMULATE_DO_MMIO) {
+			/*
+			 * Read-modify-write.  Back to userspace.
+			 */
+			r = 0;
+			goto out;
+		}
+	}
+#endif
+	if (kvm_run->exit_reason == KVM_EXIT_HYPERCALL) {
+		kvm_x86_ops->cache_regs(vcpu);
+		vcpu->regs[VCPU_REGS_RAX] = kvm_run->hypercall.ret;
+		kvm_x86_ops->decache_regs(vcpu);
+	}
+
+	r = __vcpu_run(vcpu, kvm_run);
+
+out:
+	if (vcpu->sigset_active)
+		sigprocmask(SIG_SETMASK, &sigsaved, NULL);
+
+	vcpu_put(vcpu);
+	return r;
+}
+
+int kvm_arch_vcpu_ioctl_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
+{
+	vcpu_load(vcpu);
+
+	kvm_x86_ops->cache_regs(vcpu);
+
+	regs->rax = vcpu->regs[VCPU_REGS_RAX];
+	regs->rbx = vcpu->regs[VCPU_REGS_RBX];
+	regs->rcx = vcpu->regs[VCPU_REGS_RCX];
+	regs->rdx = vcpu->regs[VCPU_REGS_RDX];
+	regs->rsi = vcpu->regs[VCPU_REGS_RSI];
+	regs->rdi = vcpu->regs[VCPU_REGS_RDI];
+	regs->rsp = vcpu->regs[VCPU_REGS_RSP];
+	regs->rbp = vcpu->regs[VCPU_REGS_RBP];
+#ifdef CONFIG_X86_64
+	regs->r8 = vcpu->regs[VCPU_REGS_R8];
+	regs->r9 = vcpu->regs[VCPU_REGS_R9];
+	regs->r10 = vcpu->regs[VCPU_REGS_R10];
+	regs->r11 = vcpu->regs[VCPU_REGS_R11];
+	regs->r12 = vcpu->regs[VCPU_REGS_R12];
+	regs->r13 = vcpu->regs[VCPU_REGS_R13];
+	regs->r14 = vcpu->regs[VCPU_REGS_R14];
+	regs->r15 = vcpu->regs[VCPU_REGS_R15];
+#endif
+
+	regs->rip = vcpu->rip;
+	regs->rflags = kvm_x86_ops->get_rflags(vcpu);
+
+	/*
+	 * Don't leak debug flags in case they were set for guest debugging
+	 */
+	if (vcpu->guest_debug.enabled && vcpu->guest_debug.singlestep)
+		regs->rflags &= ~(X86_EFLAGS_TF | X86_EFLAGS_RF);
+
+	vcpu_put(vcpu);
+
+	return 0;
+}
+
+int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
+{
+	vcpu_load(vcpu);
+
+	vcpu->regs[VCPU_REGS_RAX] = regs->rax;
+	vcpu->regs[VCPU_REGS_RBX] = regs->rbx;
+	vcpu->regs[VCPU_REGS_RCX] = regs->rcx;
+	vcpu->regs[VCPU_REGS_RDX] = regs->rdx;
+	vcpu->regs[VCPU_REGS_RSI] = regs->rsi;
+	vcpu->regs[VCPU_REGS_RDI] = regs->rdi;
+	vcpu->regs[VCPU_REGS_RSP] = regs->rsp;
+	vcpu->regs[VCPU_REGS_RBP] = regs->rbp;
+#ifdef CONFIG_X86_64
+	vcpu->regs[VCPU_REGS_R8] = regs->r8;
+	vcpu->regs[VCPU_REGS_R9] = regs->r9;
+	vcpu->regs[VCPU_REGS_R10] = regs->r10;
+	vcpu->regs[VCPU_REGS_R11] = regs->r11;
+	vcpu->regs[VCPU_REGS_R12] = regs->r12;
+	vcpu->regs[VCPU_REGS_R13] = regs->r13;
+	vcpu->regs[VCPU_REGS_R14] = regs->r14;
+	vcpu->regs[VCPU_REGS_R15] = regs->r15;
+#endif
+
+	vcpu->rip = regs->rip;
+	kvm_x86_ops->set_rflags(vcpu, regs->rflags);
+
+	kvm_x86_ops->decache_regs(vcpu);
+
+	vcpu_put(vcpu);
+
+	return 0;
+}
+
+static void get_segment(struct kvm_vcpu *vcpu,
+			struct kvm_segment *var, int seg)
+{
+	return kvm_x86_ops->get_segment(vcpu, var, seg);
+}
+
+void kvm_get_cs_db_l_bits(struct kvm_vcpu *vcpu, int *db, int *l)
+{
+	struct kvm_segment cs;
+
+	get_segment(vcpu, &cs, VCPU_SREG_CS);
+	*db = cs.db;
+	*l = cs.l;
+}
+EXPORT_SYMBOL_GPL(kvm_get_cs_db_l_bits);
+
+int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
+				  struct kvm_sregs *sregs)
+{
+	struct descriptor_table dt;
+	int pending_vec;
+
+	vcpu_load(vcpu);
+
+	get_segment(vcpu, &sregs->cs, VCPU_SREG_CS);
+	get_segment(vcpu, &sregs->ds, VCPU_SREG_DS);
+	get_segment(vcpu, &sregs->es, VCPU_SREG_ES);
+	get_segment(vcpu, &sregs->fs, VCPU_SREG_FS);
+	get_segment(vcpu, &sregs->gs, VCPU_SREG_GS);
+	get_segment(vcpu, &sregs->ss, VCPU_SREG_SS);
+
+	get_segment(vcpu, &sregs->tr, VCPU_SREG_TR);
+	get_segment(vcpu, &sregs->ldt, VCPU_SREG_LDTR);
+
+	kvm_x86_ops->get_idt(vcpu, &dt);
+	sregs->idt.limit = dt.limit;
+	sregs->idt.base = dt.base;
+	kvm_x86_ops->get_gdt(vcpu, &dt);
+	sregs->gdt.limit = dt.limit;
+	sregs->gdt.base = dt.base;
+
+	kvm_x86_ops->decache_cr4_guest_bits(vcpu);
+	sregs->cr0 = vcpu->cr0;
+	sregs->cr2 = vcpu->cr2;
+	sregs->cr3 = vcpu->cr3;
+	sregs->cr4 = vcpu->cr4;
+	sregs->cr8 = get_cr8(vcpu);
+	sregs->efer = vcpu->shadow_efer;
+	sregs->apic_base = kvm_get_apic_base(vcpu);
+
+	if (irqchip_in_kernel(vcpu->kvm)) {
+		memset(sregs->interrupt_bitmap, 0,
+		       sizeof sregs->interrupt_bitmap);
+		pending_vec = kvm_x86_ops->get_irq(vcpu);
+		if (pending_vec >= 0)
+			set_bit(pending_vec,
+				(unsigned long *)sregs->interrupt_bitmap);
+	} else
+		memcpy(sregs->interrupt_bitmap, vcpu->irq_pending,
+		       sizeof sregs->interrupt_bitmap);
+
+	vcpu_put(vcpu);
+
+	return 0;
+}
+
+static void set_segment(struct kvm_vcpu *vcpu,
+			struct kvm_segment *var, int seg)
+{
+	return kvm_x86_ops->set_segment(vcpu, var, seg);
+}
+
+int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
+				  struct kvm_sregs *sregs)
+{
+	int mmu_reset_needed = 0;
+	int i, pending_vec, max_bits;
+	struct descriptor_table dt;
+
+	vcpu_load(vcpu);
+
+	dt.limit = sregs->idt.limit;
+	dt.base = sregs->idt.base;
+	kvm_x86_ops->set_idt(vcpu, &dt);
+	dt.limit = sregs->gdt.limit;
+	dt.base = sregs->gdt.base;
+	kvm_x86_ops->set_gdt(vcpu, &dt);
+
+	vcpu->cr2 = sregs->cr2;
+	mmu_reset_needed |= vcpu->cr3 != sregs->cr3;
+	vcpu->cr3 = sregs->cr3;
+
+	set_cr8(vcpu, sregs->cr8);
+
+	mmu_reset_needed |= vcpu->shadow_efer != sregs->efer;
+#ifdef CONFIG_X86_64
+	kvm_x86_ops->set_efer(vcpu, sregs->efer);
+#endif
+	kvm_set_apic_base(vcpu, sregs->apic_base);
+
+	kvm_x86_ops->decache_cr4_guest_bits(vcpu);
+
+	mmu_reset_needed |= vcpu->cr0 != sregs->cr0;
+	vcpu->cr0 = sregs->cr0;
+	kvm_x86_ops->set_cr0(vcpu, sregs->cr0);
+
+	mmu_reset_needed |= vcpu->cr4 != sregs->cr4;
+	kvm_x86_ops->set_cr4(vcpu, sregs->cr4);
+	if (!is_long_mode(vcpu) && is_pae(vcpu))
+		load_pdptrs(vcpu, vcpu->cr3);
+
+	if (mmu_reset_needed)
+		kvm_mmu_reset_context(vcpu);
+
+	if (!irqchip_in_kernel(vcpu->kvm)) {
+		memcpy(vcpu->irq_pending, sregs->interrupt_bitmap,
+		       sizeof vcpu->irq_pending);
+		vcpu->irq_summary = 0;
+		for (i = 0; i < ARRAY_SIZE(vcpu->irq_pending); ++i)
+			if (vcpu->irq_pending[i])
+				__set_bit(i, &vcpu->irq_summary);
+	} else {
+		max_bits = (sizeof sregs->interrupt_bitmap) << 3;
+		pending_vec = find_first_bit(
+			(const unsigned long *)sregs->interrupt_bitmap,
+			max_bits);
+		/* Only pending external irq is handled here */
+		if (pending_vec < max_bits) {
+			kvm_x86_ops->set_irq(vcpu, pending_vec);
+			pr_debug("Set back pending irq %d\n",
+				 pending_vec);
+		}
+	}
+
+	set_segment(vcpu, &sregs->cs, VCPU_SREG_CS);
+	set_segment(vcpu, &sregs->ds, VCPU_SREG_DS);
+	set_segment(vcpu, &sregs->es, VCPU_SREG_ES);
+	set_segment(vcpu, &sregs->fs, VCPU_SREG_FS);
+	set_segment(vcpu, &sregs->gs, VCPU_SREG_GS);
+	set_segment(vcpu, &sregs->ss, VCPU_SREG_SS);
+
+	set_segment(vcpu, &sregs->tr, VCPU_SREG_TR);
+	set_segment(vcpu, &sregs->ldt, VCPU_SREG_LDTR);
+
+	vcpu_put(vcpu);
+
+	return 0;
+}
+
+int kvm_arch_vcpu_ioctl_debug_guest(struct kvm_vcpu *vcpu,
+				    struct kvm_debug_guest *dbg)
+{
+	int r;
+
+	vcpu_load(vcpu);
+
+	r = kvm_x86_ops->set_guest_debug(vcpu, dbg);
+
+	vcpu_put(vcpu);
+
+	return r;
+}
+
+/*
  * fxsave fpu state.  Taken from x86_64/processor.h.  To be killed when
  * we have asm/x86/processor.h
  */
-- 
1.5.3.7

