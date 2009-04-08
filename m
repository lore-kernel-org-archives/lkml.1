Return-Path: <linux-kernel-owner+w=401wt.eu-S1765807AbZDHVnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765807AbZDHVnH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 17:43:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761544AbZDHVmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 17:42:50 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55277 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756219AbZDHVmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 17:42:49 -0400
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] deal with interrupt shadow state for emulated instruction
Date: Wed,  8 Apr 2009 17:42:46 -0400
Message-Id: <1239226966-8205-1-git-send-email-glommer@redhat.com>
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
 arch/x86/include/asm/kvm_host.h        |    2 +
 arch/x86/include/asm/kvm_x86_emulate.h |    2 +-
 arch/x86/kvm/svm.c                     |   21 +++++++++++++++-
 arch/x86/kvm/vmx.c                     |   39 ++++++++++++++++++++++++-------
 arch/x86/kvm/x86.c                     |   10 ++++++-
 arch/x86/kvm/x86_emulate.c             |   16 ++++++++++++-
 6 files changed, 75 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3fc4623..9853aa9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -513,6 +513,8 @@ struct kvm_x86_ops {
 	void (*run)(struct kvm_vcpu *vcpu, struct kvm_run *run);
 	int (*handle_exit)(struct kvm_run *run, struct kvm_vcpu *vcpu);
 	void (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
+	void (*block_interrupt_shadow)(struct kvm_vcpu *vcpu);
+	void (*unblock_interrupt_shadow)(struct kvm_vcpu *vcpu);
 	void (*patch_hypercall)(struct kvm_vcpu *vcpu,
 				unsigned char *hypercall_addr);
 	int (*get_irq)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/include/asm/kvm_x86_emulate.h b/arch/x86/include/asm/kvm_x86_emulate.h
index 6a15973..800c5b1 100644
--- a/arch/x86/include/asm/kvm_x86_emulate.h
+++ b/arch/x86/include/asm/kvm_x86_emulate.h
@@ -176,6 +176,6 @@ struct x86_emulate_ctxt {
 int x86_decode_insn(struct x86_emulate_ctxt *ctxt,
 		    struct x86_emulate_ops *ops);
 int x86_emulate_insn(struct x86_emulate_ctxt *ctxt,
-		     struct x86_emulate_ops *ops);
+		     struct x86_emulate_ops *ops, int *interruptibility);
 
 #endif /* _ASM_X86_KVM_X86_EMULATE_H */
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 3ffb695..86038a3 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -210,6 +210,22 @@ static int is_external_interrupt(u32 info)
 	return info == (SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_INTR);
 }
 
+static void svm_block_interrupt_shadow(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	svm->vmcb->control.int_state |= SVM_INTERRUPT_SHADOW_MASK;
+	vcpu->arch.interrupt_window_open = 0;
+}
+
+static void svm_unblock_interrupt_shadow(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	svm->vmcb->control.int_state &= ~SVM_INTERRUPT_SHADOW_MASK;
+	vcpu->arch.interrupt_window_open = (svm->vcpu.arch.hflags & HF_GIF_MASK);
+}
+
 static void skip_emulated_instruction(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -223,9 +239,8 @@ static void skip_emulated_instruction(struct kvm_vcpu *vcpu)
 		       __func__, kvm_rip_read(vcpu), svm->next_rip);
 
 	kvm_rip_write(vcpu, svm->next_rip);
-	svm->vmcb->control.int_state &= ~SVM_INTERRUPT_SHADOW_MASK;
 
-	vcpu->arch.interrupt_window_open = (svm->vcpu.arch.hflags & HF_GIF_MASK);
+	svm_unblock_interrupt_shadow(vcpu);
 }
 
 static int has_svm(void)
@@ -2660,6 +2675,8 @@ static struct kvm_x86_ops svm_x86_ops = {
 	.run = svm_vcpu_run,
 	.handle_exit = handle_exit,
 	.skip_emulated_instruction = skip_emulated_instruction,
+	.block_interrupt_shadow = svm_block_interrupt_shadow,
+	.unblock_interrupt_shadow = svm_unblock_interrupt_shadow,
 	.patch_hypercall = svm_patch_hypercall,
 	.get_irq = svm_get_irq,
 	.set_irq = svm_set_irq,
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index c6997c0..5158c2b 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -736,26 +736,45 @@ static void vmx_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
 	vmcs_writel(GUEST_RFLAGS, rflags);
 }
 
-static void skip_emulated_instruction(struct kvm_vcpu *vcpu)
+static void vmx_block_interrupt_shadow(struct kvm_vcpu *vcpu)
 {
-	unsigned long rip;
-	u32 interruptibility;
+	u32 interruptibility = vmcs_read32(GUEST_INTERRUPTIBILITY_INFO);
+	u32 interruptibility_mask = ((GUEST_INTR_STATE_STI | GUEST_INTR_STATE_MOV_SS));
 
-	rip = kvm_rip_read(vcpu);
-	rip += vmcs_read32(VM_EXIT_INSTRUCTION_LEN);
-	kvm_rip_write(vcpu, rip);
+	if (!(interruptibility & interruptibility_mask))
+		vmcs_write32(GUEST_INTERRUPTIBILITY_INFO,
+			     interruptibility | interruptibility_mask);
+	vcpu->arch.interrupt_window_open = 0;
+}
 
+static void vmx_unblock_interrupt_shadow(struct kvm_vcpu *vcpu)
+{
 	/*
 	 * We emulated an instruction, so temporary interrupt blocking
 	 * should be removed, if set.
 	 */
-	interruptibility = vmcs_read32(GUEST_INTERRUPTIBILITY_INFO);
-	if (interruptibility & 3)
+	u32 interruptibility = vmcs_read32(GUEST_INTERRUPTIBILITY_INFO);
+	u32 interruptibility_mask = ((GUEST_INTR_STATE_STI | GUEST_INTR_STATE_MOV_SS));
+
+	if (interruptibility & interruptibility_mask)
 		vmcs_write32(GUEST_INTERRUPTIBILITY_INFO,
-			     interruptibility & ~3);
+			     interruptibility & ~interruptibility_mask);
 	vcpu->arch.interrupt_window_open = 1;
 }
 
+static void skip_emulated_instruction(struct kvm_vcpu *vcpu)
+{
+	unsigned long rip;
+
+	rip = kvm_rip_read(vcpu);
+	rip += vmcs_read32(VM_EXIT_INSTRUCTION_LEN);
+	kvm_rip_write(vcpu, rip);
+
+	/* skipping an emulated instruction also counts */
+	vmx_unblock_interrupt_shadow(vcpu);
+}
+
+
 static void vmx_queue_exception(struct kvm_vcpu *vcpu, unsigned nr,
 				bool has_error_code, u32 error_code)
 {
@@ -3727,6 +3746,8 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.run = vmx_vcpu_run,
 	.handle_exit = vmx_handle_exit,
 	.skip_emulated_instruction = skip_emulated_instruction,
+	.block_interrupt_shadow = vmx_block_interrupt_shadow,
+	.unblock_interrupt_shadow = vmx_unblock_interrupt_shadow,
 	.patch_hypercall = vmx_patch_hypercall,
 	.get_irq = vmx_get_irq,
 	.set_irq = vmx_inject_irq,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0bb4131..47daa23 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2364,7 +2364,7 @@ int emulate_instruction(struct kvm_vcpu *vcpu,
 			u16 error_code,
 			int emulation_type)
 {
-	int r;
+	int r, interruptibility;
 	struct decode_cache *c;
 
 	kvm_clear_exception_queue(vcpu);
@@ -2412,7 +2412,13 @@ int emulate_instruction(struct kvm_vcpu *vcpu,
 		}
 	}
 
-	r = x86_emulate_insn(&vcpu->arch.emulate_ctxt, &emulate_ops);
+	interruptibility = 0;
+	r = x86_emulate_insn(&vcpu->arch.emulate_ctxt, &emulate_ops, &interruptibility);
+
+	if (interruptibility)
+		kvm_x86_ops->block_interrupt_shadow(vcpu);
+	else
+		kvm_x86_ops->unblock_interrupt_shadow(vcpu);
 
 	if (vcpu->arch.pio.string)
 		return EMULATE_DO_MMIO;
diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index d7c9f6f..f3507ec 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -1350,7 +1350,8 @@ static inline int writeback(struct x86_emulate_ctxt *ctxt,
 }
 
 int
-x86_emulate_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
+x86_emulate_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops,
+						int *interruptibility)
 {
 	unsigned long memop = 0;
 	u64 msr_data;
@@ -1359,6 +1360,10 @@ x86_emulate_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 	unsigned int port;
 	int io_dir_in;
 	int rc = 0;
+	static int movss_int_flag, movss_int_flag_old;
+
+	movss_int_flag_old = movss_int_flag;
+	movss_int_flag = 0;
 
 	/* Shadow copy of register state. Committed on successful emulation.
 	 * NOTE: we can copy them from vcpu as x86_decode_insn() doesn't
@@ -1610,6 +1615,13 @@ special_insn:
 
 		sel = c->src.val;
 		if (c->modrm_reg <= 5) {
+			if (c->modrm_reg == VCPU_SREG_SS) {
+				if (movss_int_flag_old)
+					*interruptibility = 1;
+				else
+					movss_int_flag = 1;
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
+			*interruptibility = 1;
 		ctxt->eflags |= X86_EFLAGS_IF;
 		c->dst.type = OP_NONE;	/* Disable writeback. */
 		break;
-- 
1.5.6.6

