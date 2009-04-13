Return-Path: <linux-kernel-owner+w=401wt.eu-S1753131AbZDMUHL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131AbZDMUHL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 16:07:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751985AbZDMUGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 16:06:55 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47741 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314AbZDMUGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 16:06:53 -0400
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] deal with interrupt shadow state for emulated instruction
Date: Mon, 13 Apr 2009 16:06:50 -0400
Message-Id: <1239653210-10422-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we currently unblock shadow interrupt state when we skip an instruction,
but failing to do so when we actually emulate one. This blocks interrupts
in key instruction blocks, in particular sti; hlt; sequences

If the instruction emulated is an sti, we have to block shadow interrupts.
The same goes for mov ss. pop ss also needs it, but we don't currently
emulate it. For sequences of two or more instructions of the same type
among those instructions, only the first one has this effect.

Without this patch, I cannot boot gpxe option roms at vmx machines.
This is described at https://bugzilla.redhat.com/show_bug.cgi?id=494469

Signed-off-by: Glauber Costa <glommer@redhat.com>
CC: H. Peter Anvin <hpa@zytor.com>
CC: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm_host.h        |    1 +
 arch/x86/include/asm/kvm_x86_emulate.h |    7 +++++
 arch/x86/kvm/svm.c                     |   19 +++++++++++++-
 arch/x86/kvm/vmx.c                     |   42 ++++++++++++++++++++++++-------
 arch/x86/kvm/x86.c                     |    6 ++++-
 arch/x86/kvm/x86_emulate.c             |   14 ++++++++++
 6 files changed, 76 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3fc4623..0db1be7 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -513,6 +513,7 @@ struct kvm_x86_ops {
 	void (*run)(struct kvm_vcpu *vcpu, struct kvm_run *run);
 	int (*handle_exit)(struct kvm_run *run, struct kvm_vcpu *vcpu);
 	void (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
+	void (*interrupt_shadow_mask)(struct kvm_vcpu *vcpu, int mask);
 	void (*patch_hypercall)(struct kvm_vcpu *vcpu,
 				unsigned char *hypercall_addr);
 	int (*get_irq)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/include/asm/kvm_x86_emulate.h b/arch/x86/include/asm/kvm_x86_emulate.h
index 6a15973..6c15498 100644
--- a/arch/x86/include/asm/kvm_x86_emulate.h
+++ b/arch/x86/include/asm/kvm_x86_emulate.h
@@ -143,6 +143,9 @@ struct decode_cache {
 	struct fetch_cache fetch;
 };
 
+#define X86_SHADOW_INT_MOV_SS	1
+#define X86_SHADOW_INT_STI	2
+
 struct x86_emulate_ctxt {
 	/* Register state before/after emulation. */
 	struct kvm_vcpu *vcpu;
@@ -152,6 +155,10 @@ struct x86_emulate_ctxt {
 	int mode;
 	u32 cs_base;
 
+	/* interruptibility state, as a result of execution of STI or MOV SS */
+	int interruptibility;
+	int movss_int_flag, movss_int_flag_old;
+
 	/* decode cache */
 	struct decode_cache decode;
 };
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 3ffb695..f41cb08 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -210,6 +210,21 @@ static int is_external_interrupt(u32 info)
 	return info == (SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_INTR);
 }
 
+static void svm_interrupt_shadow_mask(struct kvm_vcpu *vcpu, int mask)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	if (mask == 0)
+		svm->vmcb->control.int_state &= ~SVM_INTERRUPT_SHADOW_MASK;
+	else
+		svm->vmcb->control.int_state |= SVM_INTERRUPT_SHADOW_MASK;
+
+	svm->vcpu.arch.interrupt_window_open =
+		(!(svm->vmcb->control.int_state & SVM_INTERRUPT_SHADOW_MASK) &&
+		 (svm->vmcb->save.rflags & X86_EFLAGS_IF) &&
+		 (svm->vcpu.arch.hflags & HF_GIF_MASK));
+}
+
 static void skip_emulated_instruction(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -223,9 +238,8 @@ static void skip_emulated_instruction(struct kvm_vcpu *vcpu)
 		       __func__, kvm_rip_read(vcpu), svm->next_rip);
 
 	kvm_rip_write(vcpu, svm->next_rip);
-	svm->vmcb->control.int_state &= ~SVM_INTERRUPT_SHADOW_MASK;
 
-	vcpu->arch.interrupt_window_open = (svm->vcpu.arch.hflags & HF_GIF_MASK);
+	svm_interrupt_shadow_mask(vcpu, 0);
 }
 
 static int has_svm(void)
@@ -2660,6 +2674,7 @@ static struct kvm_x86_ops svm_x86_ops = {
 	.run = svm_vcpu_run,
 	.handle_exit = handle_exit,
 	.skip_emulated_instruction = skip_emulated_instruction,
+	.interrupt_shadow_mask = svm_interrupt_shadow_mask,
 	.patch_hypercall = svm_patch_hypercall,
 	.get_irq = svm_get_irq,
 	.set_irq = svm_set_irq,
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index c6997c0..07b0203 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -736,26 +736,47 @@ static void vmx_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
 	vmcs_writel(GUEST_RFLAGS, rflags);
 }
 
+static void vmx_interrupt_shadow_mask(struct kvm_vcpu *vcpu, int mask)
+{
+	u32 interruptibility_old = vmcs_read32(GUEST_INTERRUPTIBILITY_INFO);
+	u32 interruptibility = interruptibility_old;
+
+	switch (mask) {
+	case 0:
+		interruptibility &= ~((GUEST_INTR_STATE_STI | GUEST_INTR_STATE_MOV_SS));
+		break;
+	case X86_SHADOW_INT_MOV_SS:
+		interruptibility |= GUEST_INTR_STATE_MOV_SS;
+		break;
+	case X86_SHADOW_INT_STI:
+		interruptibility |= GUEST_INTR_STATE_STI;
+		break;
+	default:
+		printk(KERN_ERR "Bogus mask for interrupt shadow!\n");
+	}
+
+	if ((interruptibility != interruptibility_old))
+		vmcs_write32(GUEST_INTERRUPTIBILITY_INFO, interruptibility);
+
+	vcpu->arch.interrupt_window_open =
+		((vmcs_readl(GUEST_RFLAGS) & X86_EFLAGS_IF) &&
+		 !(interruptibility & (GUEST_INTR_STATE_STI |
+				       GUEST_INTR_STATE_MOV_SS)));
+}
+
 static void skip_emulated_instruction(struct kvm_vcpu *vcpu)
 {
 	unsigned long rip;
-	u32 interruptibility;
 
 	rip = kvm_rip_read(vcpu);
 	rip += vmcs_read32(VM_EXIT_INSTRUCTION_LEN);
 	kvm_rip_write(vcpu, rip);
 
-	/*
-	 * We emulated an instruction, so temporary interrupt blocking
-	 * should be removed, if set.
-	 */
-	interruptibility = vmcs_read32(GUEST_INTERRUPTIBILITY_INFO);
-	if (interruptibility & 3)
-		vmcs_write32(GUEST_INTERRUPTIBILITY_INFO,
-			     interruptibility & ~3);
-	vcpu->arch.interrupt_window_open = 1;
+	/* skipping an emulated instruction also counts */
+	vmx_interrupt_shadow_mask(vcpu, 0);
 }
 
+
 static void vmx_queue_exception(struct kvm_vcpu *vcpu, unsigned nr,
 				bool has_error_code, u32 error_code)
 {
@@ -3727,6 +3748,7 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.run = vmx_vcpu_run,
 	.handle_exit = vmx_handle_exit,
 	.skip_emulated_instruction = skip_emulated_instruction,
+	.interrupt_shadow_mask = vmx_interrupt_shadow_mask,
 	.patch_hypercall = vmx_patch_hypercall,
 	.get_irq = vmx_get_irq,
 	.set_irq = vmx_inject_irq,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0bb4131..b1fc8b6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2364,7 +2364,7 @@ int emulate_instruction(struct kvm_vcpu *vcpu,
 			u16 error_code,
 			int emulation_type)
 {
-	int r;
+	int r, shadow_mask;
 	struct decode_cache *c;
 
 	kvm_clear_exception_queue(vcpu);
@@ -2412,8 +2412,12 @@ int emulate_instruction(struct kvm_vcpu *vcpu,
 		}
 	}
 
+	vcpu->arch.emulate_ctxt.interruptibility = 0;
 	r = x86_emulate_insn(&vcpu->arch.emulate_ctxt, &emulate_ops);
 
+	shadow_mask = vcpu->arch.emulate_ctxt.interruptibility;
+	kvm_x86_ops->interrupt_shadow_mask(vcpu, shadow_mask);
+
 	if (vcpu->arch.pio.string)
 		return EMULATE_DO_MMIO;
 
diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index d7c9f6f..1369a2e 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -1360,6 +1360,10 @@ x86_emulate_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 	int io_dir_in;
 	int rc = 0;
 
+	ctxt->movss_int_flag_old = ctxt->movss_int_flag;
+
+	ctxt->movss_int_flag = 0;
+
 	/* Shadow copy of register state. Committed on successful emulation.
 	 * NOTE: we can copy them from vcpu as x86_decode_insn() doesn't
 	 * modify them.
@@ -1610,6 +1614,14 @@ special_insn:
 
 		sel = c->src.val;
 		if (c->modrm_reg <= 5) {
+			if (c->modrm_reg == VCPU_SREG_SS) {
+				if (ctxt->movss_int_flag_old)
+					ctxt->interruptibility |=
+						X86_SHADOW_INT_MOV_SS;
+				else
+					ctxt->movss_int_flag = 1;
+			}
+
 			type_bits = (c->modrm_reg == 1) ? 9 : 1;
 			err = kvm_load_segment_descriptor(ctxt->vcpu, sel,
 							  type_bits, c->modrm_reg);
@@ -1864,6 +1876,8 @@ special_insn:
 		c->dst.type = OP_NONE;	/* Disable writeback. */
 		break;
 	case 0xfb: /* sti */
+		if (!(ctxt->eflags & X86_EFLAGS_IF))
+			ctxt->interruptibility |= X86_SHADOW_INT_STI;
 		ctxt->eflags |= X86_EFLAGS_IF;
 		c->dst.type = OP_NONE;	/* Disable writeback. */
 		break;
-- 
1.5.6.6

