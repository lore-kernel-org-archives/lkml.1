Return-Path: <linux-kernel-owner+w=401wt.eu-S1763833AbZEHUX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763833AbZEHUX4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 16:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757573AbZEHUXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 16:23:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33810 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754813AbZEHUXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 16:23:12 -0400
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com,
       "H. Peter Anvin" <hpa@zytor.com>, Gleb Natapov <gleb@redhat.com>
Subject: [PATCH 1/2] replace drop_interrupt_shadow by set_interrupt_shadow
Date: Fri,  8 May 2009 16:23:06 -0400
Message-Id: <1241814187-5973-2-git-send-email-glommer@redhat.com>
In-Reply-To: <1241814187-5973-1-git-send-email-glommer@redhat.com>
References: <1241814187-5973-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces drop_interrupt_shadow with the more
general set_interrupt_shadow, that can either drop or raise
it, depending on its parameter.

Signed-off-by: Glauber Costa <glommer@redhat.com>
CC: H. Peter Anvin <hpa@zytor.com>
CC: Avi Kivity <avi@redhat.com>
CC: Gleb Natapov <gleb@redhat.com>
---
 arch/x86/include/asm/kvm_host.h        |    3 +-
 arch/x86/include/asm/kvm_x86_emulate.h |    3 ++
 arch/x86/kvm/svm.c                     |   32 +++++++++++++----
 arch/x86/kvm/vmx.c                     |   56 ++++++++++++++++++++++---------
 arch/x86/kvm/x86.c                     |    2 +-
 5 files changed, 70 insertions(+), 26 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 8e680c3..b63a3b2 100644
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
@@ -521,7 +523,6 @@ struct kvm_x86_ops {
 	void (*enable_nmi_window)(struct kvm_vcpu *vcpu);
 	void (*enable_irq_window)(struct kvm_vcpu *vcpu);
 	void (*update_cr8_intercept)(struct kvm_vcpu *vcpu, int tpr, int irr);
-	void (*drop_interrupt_shadow)(struct kvm_vcpu *vcpu);
 	int (*set_tss_addr)(struct kvm *kvm, unsigned int addr);
 	int (*get_tdp_level)(void);
 	u64 (*get_mt_mask)(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
diff --git a/arch/x86/include/asm/kvm_x86_emulate.h b/arch/x86/include/asm/kvm_x86_emulate.h
index 6a15973..be40d6e 100644
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
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index ef43a18..a9669ff 100644
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
@@ -2229,12 +2250,6 @@ static void pre_svm_run(struct vcpu_svm *svm)
 		new_asid(svm, svm_data);
 }
 
-static void svm_drop_interrupt_shadow(struct kvm_vcpu *vcpu)
-{
-	struct vcpu_svm *svm = to_svm(vcpu);
-	svm->vmcb->control.int_state &= ~SVM_INTERRUPT_SHADOW_MASK;
-}
-
 static void svm_inject_nmi(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -2637,6 +2652,8 @@ static struct kvm_x86_ops svm_x86_ops = {
 	.run = svm_vcpu_run,
 	.handle_exit = handle_exit,
 	.skip_emulated_instruction = skip_emulated_instruction,
+	.set_interrupt_shadow= svm_set_interrupt_shadow,
+	.get_interrupt_shadow = svm_get_interrupt_shadow,
 	.patch_hypercall = svm_patch_hypercall,
 	.set_irq = svm_set_irq,
 	.set_nmi = svm_inject_nmi,
@@ -2646,7 +2663,6 @@ static struct kvm_x86_ops svm_x86_ops = {
 	.enable_nmi_window = enable_nmi_window,
 	.enable_irq_window = enable_irq_window,
 	.update_cr8_intercept = update_cr8_intercept,
-	.drop_interrupt_shadow = svm_drop_interrupt_shadow,
 
 	.set_tss_addr = svm_set_tss_addr,
 	.get_tdp_level = get_npt_level,
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index e8a5649..6c805c6 100644
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
@@ -2400,12 +2429,6 @@ out:
 	return ret;
 }
 
-void vmx_drop_interrupt_shadow(struct kvm_vcpu *vcpu)
-{
-	vmcs_clear_bits(GUEST_INTERRUPTIBILITY_INFO,
-			GUEST_INTR_STATE_STI | GUEST_INTR_STATE_MOV_SS);
-}
-
 static void enable_irq_window(struct kvm_vcpu *vcpu)
 {
 	u32 cpu_based_vm_exec_control;
@@ -3649,6 +3672,8 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.run = vmx_vcpu_run,
 	.handle_exit = vmx_handle_exit,
 	.skip_emulated_instruction = skip_emulated_instruction,
+	.set_interrupt_shadow = vmx_set_interrupt_shadow,
+	.get_interrupt_shadow = vmx_get_interrupt_shadow,
 	.patch_hypercall = vmx_patch_hypercall,
 	.set_irq = vmx_inject_irq,
 	.set_nmi = vmx_inject_nmi,
@@ -3658,7 +3683,6 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.enable_nmi_window = enable_nmi_window,
 	.enable_irq_window = enable_irq_window,
 	.update_cr8_intercept = update_cr8_intercept,
-	.drop_interrupt_shadow = vmx_drop_interrupt_shadow,
 
 	.set_tss_addr = vmx_set_tss_addr,
 	.get_tdp_level = get_ept_level,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2d7082c..3d8fcc5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3161,7 +3161,7 @@ static void inject_pending_irq(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		kvm_run->request_interrupt_window;
 
 	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)
-		kvm_x86_ops->drop_interrupt_shadow(vcpu);
+		kvm_x86_ops->set_interrupt_shadow(vcpu, 0);
 
 	inject_irq(vcpu);
 
-- 
1.5.6.6

