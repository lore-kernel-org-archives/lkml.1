Return-Path: <linux-kernel-owner+w=401wt.eu-S1757899AbZEESka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757899AbZEESka (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 14:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753044AbZEESkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 14:40:16 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49035 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676AbZEESkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 14:40:14 -0400
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] deal with interrupt shadow state for emulated instruction
Date: Tue,  5 May 2009 14:40:11 -0400
Message-Id: <1241548811-8138-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we currently unblock shadow interrupt state when we skip an instruction,
but failing to do so when we actually emulate one. This blocks interrupts
in key instruction blocks, in particular sti; hlt; sequences

If the instruction emulated is an sti, we have to block shadow interrupts.
The same goes for mov ss. pop ss also needs it, but we don't currently
emulate it.

Without this patch, I cannot boot gpxe option roms at vmx machines.
This is described at https://bugzilla.redhat.com/show_bug.cgi?id=494469

Signed-off-by: Glauber Costa <glommer@redhat.com>
CC: H. Peter Anvin <hpa@zytor.com>
CC: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm_host.h        |    2 +
 arch/x86/include/asm/kvm_x86_emulate.h |    6 ++++
 arch/x86/kvm/svm.c                     |   25 +++++++++++++++-
 arch/x86/kvm/vmx.c                     |   49 ++++++++++++++++++++++++++------
 arch/x86/kvm/x86.c                     |    7 ++++-
 arch/x86/kvm/x86_emulate.c             |   21 +++++++++++++-
 6 files changed, 98 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 8e680c3..a49d07b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -510,6 +510,8 @@ struct kvm_x86_ops {
 	void (*run)(struct kvm_vcpu *vcpu, struct kvm_run *run);
 	int (*handle_exit)(struct kvm_run *run, struct kvm_vcpu *vcpu);
 	void (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
+	void (*set_interrupt_shadow)(struct kvm_vcpu *vcpu, int mask);
+	u32 (*get_interrupt_shadow)(struct kvm_vcpu *vcpu);
 	void (*patch_hypercall)(struct kvm_vcpu *vcpu,
 				unsigned char *hypercall_addr);
 	void (*set_irq)(struct kvm_vcpu *vcpu, int vec);
diff --git a/arch/x86/include/asm/kvm_x86_emulate.h b/arch/x86/include/asm/kvm_x86_emulate.h
index 6a15973..b7ed2c4 100644
--- a/arch/x86/include/asm/kvm_x86_emulate.h
+++ b/arch/x86/include/asm/kvm_x86_emulate.h
@@ -143,6 +143,9 @@ struct decode_cache {
 	struct fetch_cache fetch;
 };
 
+#define X86_SHADOW_INT_MOV_SS  1
+#define X86_SHADOW_INT_STI     2
+
 struct x86_emulate_ctxt {
 	/* Register state before/after emulation. */
 	struct kvm_vcpu *vcpu;
@@ -152,6 +155,9 @@ struct x86_emulate_ctxt {
 	int mode;
 	u32 cs_base;
 
+	/* interruptibility state, as a result of execution of STI or MOV SS */
+	int interruptibility;
+
 	/* decode cache */
 	struct decode_cache decode;
 };
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index ef43a18..4941dea 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -202,6 +202,27 @@ static int is_external_interrupt(u32 info)
 	return info == (SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_INTR);
 }
 
+static u32 svm_get_interrupt_shadow(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	u32 ret = 0;
+
+	if (svm->vmcb->control.int_state & SVM_INTERRUPT_SHADOW_MASK)
+		ret |= (X86_SHADOW_INT_STI && X86_SHADOW_INT_MOV_SS);
+	return ret;
+}
+
+static void svm_set_interrupt_shadow(struct kvm_vcpu *vcpu, int mask)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	if (mask == 0)
+		svm->vmcb->control.int_state &= ~SVM_INTERRUPT_SHADOW_MASK;
+	else
+		svm->vmcb->control.int_state |= SVM_INTERRUPT_SHADOW_MASK;
+
+}
+
 static void skip_emulated_instruction(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -215,7 +236,7 @@ static void skip_emulated_instruction(struct kvm_vcpu *vcpu)
 		       __func__, kvm_rip_read(vcpu), svm->next_rip);
 
 	kvm_rip_write(vcpu, svm->next_rip);
-	svm->vmcb->control.int_state &= ~SVM_INTERRUPT_SHADOW_MASK;
+	svm_set_interrupt_shadow(vcpu, 0);
 }
 
 static int has_svm(void)
@@ -2637,6 +2658,8 @@ static struct kvm_x86_ops svm_x86_ops = {
 	.run = svm_vcpu_run,
 	.handle_exit = handle_exit,
 	.skip_emulated_instruction = skip_emulated_instruction,
+	.set_interrupt_shadow= svm_set_interrupt_shadow,
+	.get_interrupt_shadow = svm_get_interrupt_shadow,
 	.patch_hypercall = svm_patch_hypercall,
 	.set_irq = svm_set_irq,
 	.set_nmi = svm_inject_nmi,
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index e8a5649..bbfe894 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -736,23 +736,52 @@ static void vmx_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
 	vmcs_writel(GUEST_RFLAGS, rflags);
 }
 
+static u32 vmx_get_interrupt_shadow(struct kvm_vcpu *vcpu)
+{
+	u32 interruptibility = vmcs_read32(GUEST_INTERRUPTIBILITY_INFO);
+	int ret = 0;
+
+	if (interruptibility & GUEST_INTR_STATE_STI)
+		ret |= X86_SHADOW_INT_STI;
+	if (interruptibility & GUEST_INTR_STATE_MOV_SS)
+		ret |= X86_SHADOW_INT_MOV_SS;
+
+	return ret;
+}
+
+static void vmx_set_interrupt_shadow(struct kvm_vcpu *vcpu, int mask)
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
+	/* skipping an emulated instruction also counts */
+	vmx_set_interrupt_shadow(vcpu, 0);
 }
 
 static void vmx_queue_exception(struct kvm_vcpu *vcpu, unsigned nr,
@@ -3649,6 +3678,8 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.run = vmx_vcpu_run,
 	.handle_exit = vmx_handle_exit,
 	.skip_emulated_instruction = skip_emulated_instruction,
+	.set_interrupt_shadow = vmx_set_interrupt_shadow,
+	.get_interrupt_shadow = vmx_get_interrupt_shadow,
 	.patch_hypercall = vmx_patch_hypercall,
 	.set_irq = vmx_inject_irq,
 	.set_nmi = vmx_inject_nmi,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2d7082c..fc468cc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2362,7 +2362,7 @@ int emulate_instruction(struct kvm_vcpu *vcpu,
 			u16 error_code,
 			int emulation_type)
 {
-	int r;
+	int r, shadow_mask;
 	struct decode_cache *c;
 
 	kvm_clear_exception_queue(vcpu);
@@ -2415,7 +2415,12 @@ int emulate_instruction(struct kvm_vcpu *vcpu,
 		return EMULATE_DONE;
 	}
 
+	vcpu->arch.emulate_ctxt.interruptibility = 0;
 	r = x86_emulate_insn(&vcpu->arch.emulate_ctxt, &emulate_ops);
+	shadow_mask = vcpu->arch.emulate_ctxt.interruptibility;
+
+	if (r == 0)
+		kvm_x86_ops->set_interrupt_shadow(vcpu, shadow_mask);
 
 	if (vcpu->arch.pio.string)
 		return EMULATE_DO_MMIO;
diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index d2664fc..1d042d4 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -1618,6 +1618,14 @@ special_insn:
 		int err;
 
 		sel = c->src.val;
+		if (c->modrm_reg == VCPU_SREG_SS) {
+			u32 int_shadow =
+				kvm_x86_ops->get_interrupt_shadow(ctxt->vcpu);
+			/* See sti emulation for an explanation of this */
+			if (!(int_shadow & X86_SHADOW_INT_MOV_SS))
+				ctxt->interruptibility = X86_SHADOW_INT_MOV_SS;
+		}
+
 		if (c->modrm_reg <= 5) {
 			type_bits = (c->modrm_reg == 1) ? 9 : 1;
 			err = kvm_load_segment_descriptor(ctxt->vcpu, sel,
@@ -1846,10 +1854,21 @@ special_insn:
 		ctxt->eflags &= ~X86_EFLAGS_IF;
 		c->dst.type = OP_NONE;	/* Disable writeback. */
 		break;
-	case 0xfb: /* sti */
+	case 0xfb: { /* sti */
+		u32 int_shadow = kvm_x86_ops->get_interrupt_shadow(ctxt->vcpu);
+		/*
+		 * an sti; sti; sequence only disable interrupts for the first
+		 * instruction. So, if the last instruction, be it emulated or
+		 * not, left the system with the INT_STI flag enabled, it
+		 * means that the last instruction is an sti. We should not
+		 * leave the flag on in this case
+		 */
+		if (!(int_shadow & X86_SHADOW_INT_STI))
+			ctxt->interruptibility = X86_SHADOW_INT_STI;
 		ctxt->eflags |= X86_EFLAGS_IF;
 		c->dst.type = OP_NONE;	/* Disable writeback. */
 		break;
+	}
 	case 0xfc: /* cld */
 		ctxt->eflags &= ~EFLG_DF;
 		c->dst.type = OP_NONE;	/* Disable writeback. */
-- 
1.5.6.6

