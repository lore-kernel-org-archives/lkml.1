Return-Path: <linux-kernel-owner+w=401wt.eu-S1762767AbZBZObh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762767AbZBZObh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 09:31:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757613AbZBZORz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 09:17:55 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43063 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754429AbZBZOPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 09:15:41 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alexander Graf <agraf@suse.de>
Subject: [PATCH 08/40] KVM: SVM: Add VMEXIT handler and intercepts
Date: Thu, 26 Feb 2009 16:14:58 +0200
Message-Id: <1235657730-27683-9-git-send-email-avi@redhat.com>
In-Reply-To: <1235657730-27683-1-git-send-email-avi@redhat.com>
References: <1235657730-27683-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Graf <agraf@suse.de>

This adds the #VMEXIT intercept, so we return to the level 1 guest
when something happens in the level 2 guest that should return to
the level 1 guest.

v2 implements HIF handling and cleans up exception interception
v3 adds support for V_INTR_MASKING_MASK
v4 uses the host page hsave
v5 removes IOPM merging code
v6 moves mmu code out of the atomic section

Acked-by: Joerg Roedel <joro@8bytes.org>
Signed-off-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/svm.c |  293 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 293 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index fad187c..4cb2920 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -72,6 +72,13 @@ module_param(npt, int, S_IRUGO);
 static void kvm_reput_irq(struct vcpu_svm *svm);
 static void svm_flush_tlb(struct kvm_vcpu *vcpu);
 
+static int nested_svm_exit_handled(struct vcpu_svm *svm, bool kvm_override);
+static int nested_svm_vmexit(struct vcpu_svm *svm);
+static int nested_svm_vmsave(struct vcpu_svm *svm, void *nested_vmcb,
+			     void *arg2, void *opaque);
+static int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
+				      bool has_error_code, u32 error_code);
+
 static inline struct vcpu_svm *to_svm(struct kvm_vcpu *vcpu)
 {
 	return container_of(vcpu, struct vcpu_svm, vcpu);
@@ -221,6 +228,11 @@ static void svm_queue_exception(struct kvm_vcpu *vcpu, unsigned nr,
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	/* If we are within a nested VM we'd better #VMEXIT and let the
+	   guest handle the exception */
+	if (nested_svm_check_exception(svm, nr, has_error_code, error_code))
+		return;
+
 	svm->vmcb->control.event_inj = nr
 		| SVM_EVTINJ_VALID
 		| (has_error_code ? SVM_EVTINJ_VALID_ERR : 0)
@@ -1198,6 +1210,46 @@ static int nested_svm_check_permissions(struct vcpu_svm *svm)
        return 0;
 }
 
+static int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
+				      bool has_error_code, u32 error_code)
+{
+	if (is_nested(svm)) {
+		svm->vmcb->control.exit_code = SVM_EXIT_EXCP_BASE + nr;
+		svm->vmcb->control.exit_code_hi = 0;
+		svm->vmcb->control.exit_info_1 = error_code;
+		svm->vmcb->control.exit_info_2 = svm->vcpu.arch.cr2;
+		if (nested_svm_exit_handled(svm, false)) {
+			nsvm_printk("VMexit -> EXCP 0x%x\n", nr);
+
+			nested_svm_vmexit(svm);
+			return 1;
+		}
+	}
+
+	return 0;
+}
+
+static inline int nested_svm_intr(struct vcpu_svm *svm)
+{
+	if (is_nested(svm)) {
+		if (!(svm->vcpu.arch.hflags & HF_VINTR_MASK))
+			return 0;
+
+		if (!(svm->vcpu.arch.hflags & HF_HIF_MASK))
+			return 0;
+
+		svm->vmcb->control.exit_code = SVM_EXIT_INTR;
+
+		if (nested_svm_exit_handled(svm, false)) {
+			nsvm_printk("VMexit -> INTR\n");
+			nested_svm_vmexit(svm);
+			return 1;
+		}
+	}
+
+	return 0;
+}
+
 static struct page *nested_svm_get_page(struct vcpu_svm *svm, u64 gpa)
 {
 	struct page *page;
@@ -1258,6 +1310,228 @@ static int nested_svm_do(struct vcpu_svm *svm,
 	return retval;
 }
 
+static int nested_svm_exit_handled_real(struct vcpu_svm *svm,
+					void *arg1,
+					void *arg2,
+					void *opaque)
+{
+	struct vmcb *nested_vmcb = (struct vmcb *)arg1;
+	bool kvm_overrides = *(bool *)opaque;
+	u32 exit_code = svm->vmcb->control.exit_code;
+
+	if (kvm_overrides) {
+		switch (exit_code) {
+		case SVM_EXIT_INTR:
+		case SVM_EXIT_NMI:
+			return 0;
+		/* For now we are always handling NPFs when using them */
+		case SVM_EXIT_NPF:
+			if (npt_enabled)
+				return 0;
+			break;
+		/* When we're shadowing, trap PFs */
+		case SVM_EXIT_EXCP_BASE + PF_VECTOR:
+			if (!npt_enabled)
+				return 0;
+			break;
+		default:
+			break;
+		}
+	}
+
+	switch (exit_code) {
+	case SVM_EXIT_READ_CR0 ... SVM_EXIT_READ_CR8: {
+		u32 cr_bits = 1 << (exit_code - SVM_EXIT_READ_CR0);
+		if (nested_vmcb->control.intercept_cr_read & cr_bits)
+			return 1;
+		break;
+	}
+	case SVM_EXIT_WRITE_CR0 ... SVM_EXIT_WRITE_CR8: {
+		u32 cr_bits = 1 << (exit_code - SVM_EXIT_WRITE_CR0);
+		if (nested_vmcb->control.intercept_cr_write & cr_bits)
+			return 1;
+		break;
+	}
+	case SVM_EXIT_READ_DR0 ... SVM_EXIT_READ_DR7: {
+		u32 dr_bits = 1 << (exit_code - SVM_EXIT_READ_DR0);
+		if (nested_vmcb->control.intercept_dr_read & dr_bits)
+			return 1;
+		break;
+	}
+	case SVM_EXIT_WRITE_DR0 ... SVM_EXIT_WRITE_DR7: {
+		u32 dr_bits = 1 << (exit_code - SVM_EXIT_WRITE_DR0);
+		if (nested_vmcb->control.intercept_dr_write & dr_bits)
+			return 1;
+		break;
+	}
+	case SVM_EXIT_EXCP_BASE ... SVM_EXIT_EXCP_BASE + 0x1f: {
+		u32 excp_bits = 1 << (exit_code - SVM_EXIT_EXCP_BASE);
+		if (nested_vmcb->control.intercept_exceptions & excp_bits)
+			return 1;
+		break;
+	}
+	default: {
+		u64 exit_bits = 1ULL << (exit_code - SVM_EXIT_INTR);
+		nsvm_printk("exit code: 0x%x\n", exit_code);
+		if (nested_vmcb->control.intercept & exit_bits)
+			return 1;
+	}
+	}
+
+	return 0;
+}
+
+static int nested_svm_exit_handled_msr(struct vcpu_svm *svm,
+				       void *arg1, void *arg2,
+				       void *opaque)
+{
+	struct vmcb *nested_vmcb = (struct vmcb *)arg1;
+	u8 *msrpm = (u8 *)arg2;
+        u32 t0, t1;
+	u32 msr = svm->vcpu.arch.regs[VCPU_REGS_RCX];
+	u32 param = svm->vmcb->control.exit_info_1 & 1;
+
+	if (!(nested_vmcb->control.intercept & (1ULL << INTERCEPT_MSR_PROT)))
+		return 0;
+
+	switch(msr) {
+	case 0 ... 0x1fff:
+		t0 = (msr * 2) % 8;
+		t1 = msr / 8;
+		break;
+	case 0xc0000000 ... 0xc0001fff:
+		t0 = (8192 + msr - 0xc0000000) * 2;
+		t1 = (t0 / 8);
+		t0 %= 8;
+		break;
+	case 0xc0010000 ... 0xc0011fff:
+		t0 = (16384 + msr - 0xc0010000) * 2;
+		t1 = (t0 / 8);
+		t0 %= 8;
+		break;
+	default:
+		return 1;
+		break;
+	}
+	if (msrpm[t1] & ((1 << param) << t0))
+		return 1;
+
+	return 0;
+}
+
+static int nested_svm_exit_handled(struct vcpu_svm *svm, bool kvm_override)
+{
+	bool k = kvm_override;
+
+	switch (svm->vmcb->control.exit_code) {
+	case SVM_EXIT_MSR:
+		return nested_svm_do(svm, svm->nested_vmcb,
+				     svm->nested_vmcb_msrpm, NULL,
+				     nested_svm_exit_handled_msr);
+	default: break;
+	}
+
+	return nested_svm_do(svm, svm->nested_vmcb, 0, &k,
+			     nested_svm_exit_handled_real);
+}
+
+static int nested_svm_vmexit_real(struct vcpu_svm *svm, void *arg1,
+				  void *arg2, void *opaque)
+{
+	struct vmcb *nested_vmcb = (struct vmcb *)arg1;
+	struct vmcb *hsave = svm->hsave;
+	u64 nested_save[] = { nested_vmcb->save.cr0,
+			      nested_vmcb->save.cr3,
+			      nested_vmcb->save.cr4,
+			      nested_vmcb->save.efer,
+			      nested_vmcb->control.intercept_cr_read,
+			      nested_vmcb->control.intercept_cr_write,
+			      nested_vmcb->control.intercept_dr_read,
+			      nested_vmcb->control.intercept_dr_write,
+			      nested_vmcb->control.intercept_exceptions,
+			      nested_vmcb->control.intercept,
+			      nested_vmcb->control.msrpm_base_pa,
+			      nested_vmcb->control.iopm_base_pa,
+			      nested_vmcb->control.tsc_offset };
+
+	/* Give the current vmcb to the guest */
+	memcpy(nested_vmcb, svm->vmcb, sizeof(struct vmcb));
+	nested_vmcb->save.cr0 = nested_save[0];
+	if (!npt_enabled)
+		nested_vmcb->save.cr3 = nested_save[1];
+	nested_vmcb->save.cr4 = nested_save[2];
+	nested_vmcb->save.efer = nested_save[3];
+	nested_vmcb->control.intercept_cr_read = nested_save[4];
+	nested_vmcb->control.intercept_cr_write = nested_save[5];
+	nested_vmcb->control.intercept_dr_read = nested_save[6];
+	nested_vmcb->control.intercept_dr_write = nested_save[7];
+	nested_vmcb->control.intercept_exceptions = nested_save[8];
+	nested_vmcb->control.intercept = nested_save[9];
+	nested_vmcb->control.msrpm_base_pa = nested_save[10];
+	nested_vmcb->control.iopm_base_pa = nested_save[11];
+	nested_vmcb->control.tsc_offset = nested_save[12];
+
+	/* We always set V_INTR_MASKING and remember the old value in hflags */
+	if (!(svm->vcpu.arch.hflags & HF_VINTR_MASK))
+		nested_vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
+
+	if ((nested_vmcb->control.int_ctl & V_IRQ_MASK) &&
+	    (nested_vmcb->control.int_vector)) {
+		nsvm_printk("WARNING: IRQ 0x%x still enabled on #VMEXIT\n",
+				nested_vmcb->control.int_vector);
+	}
+
+	/* Restore the original control entries */
+	svm->vmcb->control = hsave->control;
+
+	/* Kill any pending exceptions */
+	if (svm->vcpu.arch.exception.pending == true)
+		nsvm_printk("WARNING: Pending Exception\n");
+	svm->vcpu.arch.exception.pending = false;
+
+	/* Restore selected save entries */
+	svm->vmcb->save.es = hsave->save.es;
+	svm->vmcb->save.cs = hsave->save.cs;
+	svm->vmcb->save.ss = hsave->save.ss;
+	svm->vmcb->save.ds = hsave->save.ds;
+	svm->vmcb->save.gdtr = hsave->save.gdtr;
+	svm->vmcb->save.idtr = hsave->save.idtr;
+	svm->vmcb->save.rflags = hsave->save.rflags;
+	svm_set_efer(&svm->vcpu, hsave->save.efer);
+	svm_set_cr0(&svm->vcpu, hsave->save.cr0 | X86_CR0_PE);
+	svm_set_cr4(&svm->vcpu, hsave->save.cr4);
+	if (npt_enabled) {
+		svm->vmcb->save.cr3 = hsave->save.cr3;
+		svm->vcpu.arch.cr3 = hsave->save.cr3;
+	} else {
+		kvm_set_cr3(&svm->vcpu, hsave->save.cr3);
+	}
+	kvm_register_write(&svm->vcpu, VCPU_REGS_RAX, hsave->save.rax);
+	kvm_register_write(&svm->vcpu, VCPU_REGS_RSP, hsave->save.rsp);
+	kvm_register_write(&svm->vcpu, VCPU_REGS_RIP, hsave->save.rip);
+	svm->vmcb->save.dr7 = 0;
+	svm->vmcb->save.cpl = 0;
+	svm->vmcb->control.exit_int_info = 0;
+
+	svm->vcpu.arch.hflags &= ~HF_GIF_MASK;
+	/* Exit nested SVM mode */
+	svm->nested_vmcb = 0;
+
+	return 0;
+}
+
+static int nested_svm_vmexit(struct vcpu_svm *svm)
+{
+	nsvm_printk("VMexit\n");
+	if (nested_svm_do(svm, svm->nested_vmcb, 0,
+			  NULL, nested_svm_vmexit_real))
+		return 1;
+
+	kvm_mmu_reset_context(&svm->vcpu);
+	kvm_mmu_load(&svm->vcpu);
+
+	return 0;
+}
 
 static int nested_svm_vmrun_msrpm(struct vcpu_svm *svm, void *arg1,
 				  void *arg2, void *opaque)
@@ -1805,6 +2079,17 @@ static int handle_exit(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
 	KVMTRACE_3D(VMEXIT, vcpu, exit_code, (u32)svm->vmcb->save.rip,
 		    (u32)((u64)svm->vmcb->save.rip >> 32), entryexit);
 
+	if (is_nested(svm)) {
+		nsvm_printk("nested handle_exit: 0x%x | 0x%lx | 0x%lx | 0x%lx\n",
+			    exit_code, svm->vmcb->control.exit_info_1,
+			    svm->vmcb->control.exit_info_2, svm->vmcb->save.rip);
+		if (nested_svm_exit_handled(svm, true)) {
+			nested_svm_vmexit(svm);
+			nsvm_printk("-> #VMEXIT\n");
+			return 1;
+		}
+	}
+
 	if (npt_enabled) {
 		int mmu_reload = 0;
 		if ((vcpu->arch.cr0 ^ svm->vmcb->save.cr0) & X86_CR0_PG) {
@@ -1892,6 +2177,8 @@ static void svm_set_irq(struct kvm_vcpu *vcpu, int irq)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	nested_svm_intr(svm);
+
 	svm_inject_irq(svm, irq);
 }
 
@@ -1937,6 +2224,9 @@ static void svm_intr_assist(struct kvm_vcpu *vcpu)
 	if (!kvm_cpu_has_interrupt(vcpu))
 		goto out;
 
+	if (nested_svm_intr(svm))
+		goto out;
+
 	if (!(svm->vcpu.arch.hflags & HF_GIF_MASK))
 		goto out;
 
@@ -1989,6 +2279,9 @@ static void do_interrupt_requests(struct kvm_vcpu *vcpu,
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct vmcb_control_area *control = &svm->vmcb->control;
 
+	if (nested_svm_intr(svm))
+		return;
+
 	svm->vcpu.arch.interrupt_window_open =
 		(!(control->int_state & SVM_INTERRUPT_SHADOW_MASK) &&
 		 (svm->vmcb->save.rflags & X86_EFLAGS_IF) &&
-- 
1.6.0.6

