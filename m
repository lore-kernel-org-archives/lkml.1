Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903Ab0BMIGu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 03:06:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752524Ab0BMICF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 03:02:05 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 18/39] KVM: Replace read accesses of vcpu->arch.cr0 by an accessor
Date: Sat, 13 Feb 2010 10:01:38 +0200
Message-Id: <1266048119-14325-19-git-send-email-avi@redhat.com>
In-Reply-To: <1266048119-14325-1-git-send-email-avi@redhat.com>
References: <1266048119-14325-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we'd like to allow the guest to own a few bits of cr0 at times, we need
to know when we access those bits.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/emulate.c        |    6 +++---
 arch/x86/kvm/kvm_cache_regs.h |   10 ++++++++++
 arch/x86/kvm/mmu.c            |    2 +-
 arch/x86/kvm/mmu.h            |    2 +-
 arch/x86/kvm/svm.c            |    9 +++++----
 arch/x86/kvm/vmx.c            |   16 ++++++++--------
 arch/x86/kvm/x86.c            |   20 ++++++++++----------
 7 files changed, 38 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 7e8faea..0f89e32 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1515,7 +1515,7 @@ emulate_syscall(struct x86_emulate_ctxt *ctxt)
 
 	/* syscall is not available in real mode */
 	if (c->lock_prefix || ctxt->mode == X86EMUL_MODE_REAL
-		|| !(ctxt->vcpu->arch.cr0 & X86_CR0_PE))
+	    || !kvm_read_cr0_bits(ctxt->vcpu, X86_CR0_PE))
 		return -1;
 
 	setup_syscalls_segments(ctxt, &cs, &ss);
@@ -1569,7 +1569,7 @@ emulate_sysenter(struct x86_emulate_ctxt *ctxt)
 
 	/* inject #GP if in real mode or paging is disabled */
 	if (ctxt->mode == X86EMUL_MODE_REAL ||
-		!(ctxt->vcpu->arch.cr0 & X86_CR0_PE)) {
+	    !kvm_read_cr0_bits(ctxt->vcpu, X86_CR0_PE)) {
 		kvm_inject_gp(ctxt->vcpu, 0);
 		return -1;
 	}
@@ -1635,7 +1635,7 @@ emulate_sysexit(struct x86_emulate_ctxt *ctxt)
 
 	/* inject #GP if in real mode or paging is disabled */
 	if (ctxt->mode == X86EMUL_MODE_REAL
-		|| !(ctxt->vcpu->arch.cr0 & X86_CR0_PE)) {
+	    || !kvm_read_cr0_bits(ctxt->vcpu, X86_CR0_PE)) {
 		kvm_inject_gp(ctxt->vcpu, 0);
 		return -1;
 	}
diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index 35acc36..f468597 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -38,6 +38,16 @@ static inline u64 kvm_pdptr_read(struct kvm_vcpu *vcpu, int index)
 	return vcpu->arch.pdptrs[index];
 }
 
+static inline ulong kvm_read_cr0_bits(struct kvm_vcpu *vcpu, ulong mask)
+{
+	return vcpu->arch.cr0 & mask;
+}
+
+static inline ulong kvm_read_cr0(struct kvm_vcpu *vcpu)
+{
+	return kvm_read_cr0_bits(vcpu, ~0UL);
+}
+
 static inline ulong kvm_read_cr4_bits(struct kvm_vcpu *vcpu, ulong mask)
 {
 	if (mask & vcpu->arch.cr4_guest_owned_bits)
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 4f5508c..276bf74 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -226,7 +226,7 @@ EXPORT_SYMBOL_GPL(kvm_mmu_set_mask_ptes);
 
 static int is_write_protection(struct kvm_vcpu *vcpu)
 {
-	return vcpu->arch.cr0 & X86_CR0_WP;
+	return kvm_read_cr0_bits(vcpu, X86_CR0_WP);
 }
 
 static int is_cpuid_PSE36(void)
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index ff58342..599159f 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -79,7 +79,7 @@ static inline int is_pse(struct kvm_vcpu *vcpu)
 
 static inline int is_paging(struct kvm_vcpu *vcpu)
 {
-	return vcpu->arch.cr0 & X86_CR0_PG;
+	return kvm_read_cr0_bits(vcpu, X86_CR0_PG);
 }
 
 static inline int is_present_gpte(unsigned long pte)
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index cf64fc0..d3246ce 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -980,7 +980,7 @@ static void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	if (npt_enabled)
 		goto set;
 
-	if ((vcpu->arch.cr0 & X86_CR0_TS) && !(cr0 & X86_CR0_TS)) {
+	if (kvm_read_cr0_bits(vcpu, X86_CR0_TS) && !(cr0 & X86_CR0_TS)) {
 		svm->vmcb->control.intercept_exceptions &= ~(1 << NM_VECTOR);
 		vcpu->fpu_active = 1;
 	}
@@ -1244,7 +1244,7 @@ static int ud_interception(struct vcpu_svm *svm)
 static int nm_interception(struct vcpu_svm *svm)
 {
 	svm->vmcb->control.intercept_exceptions &= ~(1 << NM_VECTOR);
-	if (!(svm->vcpu.arch.cr0 & X86_CR0_TS))
+	if (!kvm_read_cr0_bits(&svm->vcpu, X86_CR0_TS))
 		svm->vmcb->save.cr0 &= ~X86_CR0_TS;
 	svm->vcpu.fpu_active = 1;
 
@@ -1743,7 +1743,7 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 	hsave->save.gdtr   = vmcb->save.gdtr;
 	hsave->save.idtr   = vmcb->save.idtr;
 	hsave->save.efer   = svm->vcpu.arch.shadow_efer;
-	hsave->save.cr0    = svm->vcpu.arch.cr0;
+	hsave->save.cr0    = kvm_read_cr0(&svm->vcpu);
 	hsave->save.cr4    = svm->vcpu.arch.cr4;
 	hsave->save.rflags = vmcb->save.rflags;
 	hsave->save.rip    = svm->next_rip;
@@ -2387,7 +2387,8 @@ static int handle_exit(struct kvm_vcpu *vcpu)
 
 	if (npt_enabled) {
 		int mmu_reload = 0;
-		if ((vcpu->arch.cr0 ^ svm->vmcb->save.cr0) & X86_CR0_PG) {
+		if ((kvm_read_cr0_bits(vcpu, X86_CR0_PG) ^ svm->vmcb->save.cr0)
+		    & X86_CR0_PG) {
 			svm_set_cr0(vcpu, svm->vmcb->save.cr0);
 			mmu_reload = 1;
 		}
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 7c7b2ee..4c7177c 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -799,7 +799,7 @@ static void vmx_fpu_activate(struct kvm_vcpu *vcpu)
 		return;
 	vcpu->fpu_active = 1;
 	vmcs_clear_bits(GUEST_CR0, X86_CR0_TS);
-	if (vcpu->arch.cr0 & X86_CR0_TS)
+	if (kvm_read_cr0_bits(vcpu, X86_CR0_TS))
 		vmcs_set_bits(GUEST_CR0, X86_CR0_TS);
 	update_exception_bitmap(vcpu);
 }
@@ -1785,7 +1785,7 @@ static void vmx_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 
 	vmx_flush_tlb(vcpu);
 	vmcs_writel(GUEST_CR3, guest_cr3);
-	if (vcpu->arch.cr0 & X86_CR0_PE)
+	if (kvm_read_cr0_bits(vcpu, X86_CR0_PE))
 		vmx_fpu_deactivate(vcpu);
 }
 
@@ -1840,7 +1840,7 @@ static void vmx_get_segment(struct kvm_vcpu *vcpu,
 
 static int vmx_get_cpl(struct kvm_vcpu *vcpu)
 {
-	if (!(vcpu->arch.cr0 & X86_CR0_PE)) /* if real mode */
+	if (!kvm_read_cr0_bits(vcpu, X86_CR0_PE)) /* if real mode */
 		return 0;
 
 	if (vmx_get_rflags(vcpu) & X86_EFLAGS_VM) /* if virtual 8086 */
@@ -2095,7 +2095,7 @@ static bool cs_ss_rpl_check(struct kvm_vcpu *vcpu)
 static bool guest_state_valid(struct kvm_vcpu *vcpu)
 {
 	/* real mode guest state checks */
-	if (!(vcpu->arch.cr0 & X86_CR0_PE)) {
+	if (!kvm_read_cr0_bits(vcpu, X86_CR0_PE)) {
 		if (!rmode_segment_valid(vcpu, VCPU_SREG_CS))
 			return false;
 		if (!rmode_segment_valid(vcpu, VCPU_SREG_SS))
@@ -2580,7 +2580,7 @@ static int vmx_vcpu_reset(struct kvm_vcpu *vcpu)
 		vmcs_write16(VIRTUAL_PROCESSOR_ID, vmx->vpid);
 
 	vmx->vcpu.arch.cr0 = X86_CR0_NW | X86_CR0_CD | X86_CR0_ET;
-	vmx_set_cr0(&vmx->vcpu, vmx->vcpu.arch.cr0); /* enter rmode */
+	vmx_set_cr0(&vmx->vcpu, kvm_read_cr0(vcpu)); /* enter rmode */
 	vmx_set_cr4(&vmx->vcpu, 0);
 	vmx_set_efer(&vmx->vcpu, 0);
 	vmx_fpu_activate(&vmx->vcpu);
@@ -2996,8 +2996,8 @@ static int handle_cr(struct kvm_vcpu *vcpu)
 	case 2: /* clts */
 		vmx_fpu_deactivate(vcpu);
 		vcpu->arch.cr0 &= ~X86_CR0_TS;
-		vmcs_writel(CR0_READ_SHADOW, vcpu->arch.cr0);
-		trace_kvm_cr_write(0, vcpu->arch.cr0);
+		vmcs_writel(CR0_READ_SHADOW, kvm_read_cr0(vcpu));
+		trace_kvm_cr_write(0, kvm_read_cr0(vcpu));
 		vmx_fpu_activate(vcpu);
 		skip_emulated_instruction(vcpu);
 		return 1;
@@ -3018,7 +3018,7 @@ static int handle_cr(struct kvm_vcpu *vcpu)
 		break;
 	case 3: /* lmsw */
 		val = (exit_qualification >> LMSW_SOURCE_DATA_SHIFT) & 0x0f;
-		trace_kvm_cr_write(0, (vcpu->arch.cr0 & ~0xful) | val);
+		trace_kvm_cr_write(0, (kvm_read_cr0(vcpu) & ~0xful) | val);
 		kvm_lmsw(vcpu, val);
 
 		skip_emulated_instruction(vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c990424..748b15d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -430,7 +430,7 @@ void kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 {
 	if (cr0 & CR0_RESERVED_BITS) {
 		printk(KERN_DEBUG "set_cr0: 0x%lx #GP, reserved bits 0x%lx\n",
-		       cr0, vcpu->arch.cr0);
+		       cr0, kvm_read_cr0(vcpu));
 		kvm_inject_gp(vcpu, 0);
 		return;
 	}
@@ -488,7 +488,7 @@ EXPORT_SYMBOL_GPL(kvm_set_cr0);
 
 void kvm_lmsw(struct kvm_vcpu *vcpu, unsigned long msw)
 {
-	kvm_set_cr0(vcpu, (vcpu->arch.cr0 & ~0x0ful) | (msw & 0x0f));
+	kvm_set_cr0(vcpu, kvm_read_cr0_bits(vcpu, ~0x0ful) | (msw & 0x0f));
 }
 EXPORT_SYMBOL_GPL(kvm_lmsw);
 
@@ -3095,7 +3095,7 @@ int emulate_invlpg(struct kvm_vcpu *vcpu, gva_t address)
 
 int emulate_clts(struct kvm_vcpu *vcpu)
 {
-	kvm_x86_ops->set_cr0(vcpu, vcpu->arch.cr0 & ~X86_CR0_TS);
+	kvm_x86_ops->set_cr0(vcpu, kvm_read_cr0_bits(vcpu, ~X86_CR0_TS));
 	return X86EMUL_CONTINUE;
 }
 
@@ -3714,7 +3714,7 @@ unsigned long realmode_get_cr(struct kvm_vcpu *vcpu, int cr)
 
 	switch (cr) {
 	case 0:
-		value = vcpu->arch.cr0;
+		value = kvm_read_cr0(vcpu);
 		break;
 	case 2:
 		value = vcpu->arch.cr2;
@@ -3741,7 +3741,7 @@ void realmode_set_cr(struct kvm_vcpu *vcpu, int cr, unsigned long val,
 {
 	switch (cr) {
 	case 0:
-		kvm_set_cr0(vcpu, mk_cr_64(vcpu->arch.cr0, val));
+		kvm_set_cr0(vcpu, mk_cr_64(kvm_read_cr0(vcpu), val));
 		*rflags = kvm_get_rflags(vcpu);
 		break;
 	case 2:
@@ -4335,7 +4335,7 @@ int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
 	sregs->gdt.limit = dt.limit;
 	sregs->gdt.base = dt.base;
 
-	sregs->cr0 = vcpu->arch.cr0;
+	sregs->cr0 = kvm_read_cr0(vcpu);
 	sregs->cr2 = vcpu->arch.cr2;
 	sregs->cr3 = vcpu->arch.cr3;
 	sregs->cr4 = kvm_read_cr4(vcpu);
@@ -4521,7 +4521,7 @@ int kvm_load_segment_descriptor(struct kvm_vcpu *vcpu, u16 selector,
 {
 	struct kvm_segment kvm_seg;
 
-	if (is_vm86_segment(vcpu, seg) || !(vcpu->arch.cr0 & X86_CR0_PE))
+	if (is_vm86_segment(vcpu, seg) || !(kvm_read_cr0_bits(vcpu, X86_CR0_PE)))
 		return kvm_load_realmode_segment(vcpu, selector, seg);
 	if (load_segment_descriptor_to_kvm_desct(vcpu, selector, &kvm_seg))
 		return 1;
@@ -4799,7 +4799,7 @@ int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int reason)
 					      &nseg_desc);
 	}
 
-	kvm_x86_ops->set_cr0(vcpu, vcpu->arch.cr0 | X86_CR0_TS);
+	kvm_x86_ops->set_cr0(vcpu, kvm_read_cr0(vcpu) | X86_CR0_TS);
 	seg_desct_to_kvm_desct(&nseg_desc, tss_selector, &tr_seg);
 	tr_seg.type = 11;
 	kvm_set_segment(vcpu, &tr_seg, VCPU_SREG_TR);
@@ -4834,7 +4834,7 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 	kvm_x86_ops->set_efer(vcpu, sregs->efer);
 	kvm_set_apic_base(vcpu, sregs->apic_base);
 
-	mmu_reset_needed |= vcpu->arch.cr0 != sregs->cr0;
+	mmu_reset_needed |= kvm_read_cr0(vcpu) != sregs->cr0;
 	kvm_x86_ops->set_cr0(vcpu, sregs->cr0);
 	vcpu->arch.cr0 = sregs->cr0;
 
@@ -4873,7 +4873,7 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 	/* Older userspace won't unhalt the vcpu on reset. */
 	if (kvm_vcpu_is_bsp(vcpu) && kvm_rip_read(vcpu) == 0xfff0 &&
 	    sregs->cs.selector == 0xf000 && sregs->cs.base == 0xffff0000 &&
-	    !(vcpu->arch.cr0 & X86_CR0_PE))
+	    !(kvm_read_cr0_bits(vcpu, X86_CR0_PE)))
 		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 
 	vcpu_put(vcpu);
-- 
1.6.5.3

