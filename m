Return-Path: <linux-kernel-owner+w=401wt.eu-S1755016AbZEXQAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016AbZEXQAm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 12:00:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758842AbZEXPyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 11:54:19 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41825 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754012AbZEXPud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 11:50:33 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 05/45] KVM: Get rid of arch.interrupt_window_open & arch.nmi_window_open
Date: Sun, 24 May 2009 18:49:50 +0300
Message-Id: <1243180230-2480-6-git-send-email-avi@redhat.com>
In-Reply-To: <1243180230-2480-1-git-send-email-avi@redhat.com>
References: <1243180230-2480-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

They are recalculated before each use anyway.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    2 --
 arch/x86/kvm/svm.c              |    6 +-----
 arch/x86/kvm/vmx.c              |   35 +++++++++++------------------------
 3 files changed, 12 insertions(+), 31 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index aa5a54e..53533ea 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -266,7 +266,6 @@ struct kvm_mmu {
 
 struct kvm_vcpu_arch {
 	u64 host_tsc;
-	int interrupt_window_open;
 	unsigned long irq_summary; /* bit vector: 1 per word in irq_pending */
 	DECLARE_BITMAP(irq_pending, KVM_NR_INTERRUPTS);
 	/*
@@ -360,7 +359,6 @@ struct kvm_vcpu_arch {
 
 	bool nmi_pending;
 	bool nmi_injected;
-	bool nmi_window_open;
 
 	struct mtrr_state_type mtrr_state;
 	u32 pat;
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index e283a63..0f53439 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -216,8 +216,6 @@ static void skip_emulated_instruction(struct kvm_vcpu *vcpu)
 
 	kvm_rip_write(vcpu, svm->next_rip);
 	svm->vmcb->control.int_state &= ~SVM_INTERRUPT_SHADOW_MASK;
-
-	vcpu->arch.interrupt_window_open = (svm->vcpu.arch.hflags & HF_GIF_MASK);
 }
 
 static int has_svm(void)
@@ -2305,7 +2303,7 @@ static void svm_intr_inject(struct kvm_vcpu *vcpu)
 
 	/* try to inject new event if pending */
 	if (kvm_cpu_has_interrupt(vcpu)) {
-		if (vcpu->arch.interrupt_window_open) {
+		if (svm_interrupt_allowed(vcpu)) {
 			kvm_queue_interrupt(vcpu, kvm_cpu_get_interrupt(vcpu));
 			svm_queue_irq(to_svm(vcpu), vcpu->arch.interrupt.nr);
 		}
@@ -2321,8 +2319,6 @@ static void svm_intr_assist(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	if (nested_svm_intr(svm))
 		goto out;
 
-	svm->vcpu.arch.interrupt_window_open = svm_interrupt_allowed(vcpu);
-
 	svm_intr_inject(vcpu);
 
 	if (kvm_cpu_has_interrupt(vcpu) || req_int_win)
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 51f804c..116eac0 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -753,7 +753,6 @@ static void skip_emulated_instruction(struct kvm_vcpu *vcpu)
 	if (interruptibility & 3)
 		vmcs_write32(GUEST_INTERRUPTIBILITY_INFO,
 			     interruptibility & ~3);
-	vcpu->arch.interrupt_window_open = 1;
 }
 
 static void vmx_queue_exception(struct kvm_vcpu *vcpu, unsigned nr,
@@ -2482,27 +2481,21 @@ static void vmx_inject_nmi(struct kvm_vcpu *vcpu)
 			INTR_TYPE_NMI_INTR | INTR_INFO_VALID_MASK | NMI_VECTOR);
 }
 
-static void vmx_update_window_states(struct kvm_vcpu *vcpu)
+static int vmx_nmi_allowed(struct kvm_vcpu *vcpu)
 {
-	u32 guest_intr = vmcs_read32(GUEST_INTERRUPTIBILITY_INFO);
-
-	vcpu->arch.nmi_window_open =
-		!(guest_intr & (GUEST_INTR_STATE_STI |
-				GUEST_INTR_STATE_MOV_SS |
-				GUEST_INTR_STATE_NMI));
 	if (!cpu_has_virtual_nmis() && to_vmx(vcpu)->soft_vnmi_blocked)
-		vcpu->arch.nmi_window_open = 0;
+		return 0;
 
-	vcpu->arch.interrupt_window_open =
-		((vmcs_readl(GUEST_RFLAGS) & X86_EFLAGS_IF) &&
-		 !(guest_intr & (GUEST_INTR_STATE_STI |
-				 GUEST_INTR_STATE_MOV_SS)));
+	return	!(vmcs_read32(GUEST_INTERRUPTIBILITY_INFO) &
+			(GUEST_INTR_STATE_STI | GUEST_INTR_STATE_MOV_SS |
+				GUEST_INTR_STATE_NMI));
 }
 
 static int vmx_interrupt_allowed(struct kvm_vcpu *vcpu)
 {
-	vmx_update_window_states(vcpu);
-	return vcpu->arch.interrupt_window_open;
+	return (vmcs_readl(GUEST_RFLAGS) & X86_EFLAGS_IF) &&
+		!(vmcs_read32(GUEST_INTERRUPTIBILITY_INFO) &
+			(GUEST_INTR_STATE_STI | GUEST_INTR_STATE_MOV_SS));
 }
 
 static int vmx_set_tss_addr(struct kvm *kvm, unsigned int addr)
@@ -3194,9 +3187,8 @@ static int vmx_handle_exit(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
 		       __func__, vectoring_info, exit_reason);
 
 	if (unlikely(!cpu_has_virtual_nmis() && vmx->soft_vnmi_blocked)) {
-		if (vcpu->arch.interrupt_window_open) {
+		if (vmx_interrupt_allowed(vcpu)) {
 			vmx->soft_vnmi_blocked = 0;
-			vcpu->arch.nmi_window_open = 1;
 		} else if (vmx->vnmi_blocked_time > 1000000000LL &&
 			   vcpu->arch.nmi_pending) {
 			/*
@@ -3209,7 +3201,6 @@ static int vmx_handle_exit(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
 			       "state on VCPU %d after 1 s timeout\n",
 			       __func__, vcpu->vcpu_id);
 			vmx->soft_vnmi_blocked = 0;
-			vmx->vcpu.arch.nmi_window_open = 1;
 		}
 	}
 
@@ -3324,13 +3315,13 @@ static void vmx_intr_inject(struct kvm_vcpu *vcpu)
 
 	/* try to inject new event if pending */
 	if (vcpu->arch.nmi_pending) {
-		if (vcpu->arch.nmi_window_open) {
+		if (vmx_nmi_allowed(vcpu)) {
 			vcpu->arch.nmi_pending = false;
 			vcpu->arch.nmi_injected = true;
 			vmx_inject_nmi(vcpu);
 		}
 	} else if (kvm_cpu_has_interrupt(vcpu)) {
-		if (vcpu->arch.interrupt_window_open) {
+		if (vmx_interrupt_allowed(vcpu)) {
 			kvm_queue_interrupt(vcpu, kvm_cpu_get_interrupt(vcpu));
 			vmx_inject_irq(vcpu, vcpu->arch.interrupt.nr);
 		}
@@ -3344,8 +3335,6 @@ static void vmx_intr_assist(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 	update_tpr_threshold(vcpu);
 
-	vmx_update_window_states(vcpu);
-
 	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)
 		vmcs_clear_bits(GUEST_INTERRUPTIBILITY_INFO,
 				GUEST_INTR_STATE_STI |
@@ -3518,8 +3507,6 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	if (vmx->rmode.irq.pending)
 		fixup_rmode_irq(vmx);
 
-	vmx_update_window_states(vcpu);
-
 	asm("mov %0, %%ds; mov %0, %%es" : : "r"(__USER_DS));
 	vmx->launched = 1;
 
-- 
1.6.0.6

