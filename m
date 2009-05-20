Return-Path: <linux-kernel-owner+w=401wt.eu-S1758986AbZETL3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758986AbZETL3W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 07:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756922AbZETLUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 07:20:35 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55270 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755374AbZETLSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 07:18:48 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 15/46] KVM: Fix unneeded instruction skipping during task switching.
Date: Wed, 20 May 2009 14:18:12 +0300
Message-Id: <1242818323-10413-16-git-send-email-avi@redhat.com>
In-Reply-To: <1242818323-10413-1-git-send-email-avi@redhat.com>
References: <1242818323-10413-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

There is no need to skip instruction if the reason for a task switch
is a task gate in IDT and access to it is caused by an external even.
The problem  is currently solved only for VMX since there is no reliable
way to skip an instruction in SVM. We should emulate it instead.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/svm.h |    1 +
 arch/x86/kvm/svm.c         |   25 ++++++++++++++++++-------
 arch/x86/kvm/vmx.c         |   38 ++++++++++++++++++++++++++++----------
 arch/x86/kvm/x86.c         |    5 ++++-
 4 files changed, 51 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 82ada75..85574b7 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -225,6 +225,7 @@ struct __attribute__ ((__packed__)) vmcb {
 #define SVM_EVTINJ_VALID_ERR (1 << 11)
 
 #define SVM_EXITINTINFO_VEC_MASK SVM_EVTINJ_VEC_MASK
+#define SVM_EXITINTINFO_TYPE_MASK SVM_EVTINJ_TYPE_MASK
 
 #define	SVM_EXITINTINFO_TYPE_INTR SVM_EVTINJ_TYPE_INTR
 #define	SVM_EXITINTINFO_TYPE_NMI SVM_EVTINJ_TYPE_NMI
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index de74104..bba67b7 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1825,17 +1825,28 @@ static int task_switch_interception(struct vcpu_svm *svm,
 				    struct kvm_run *kvm_run)
 {
 	u16 tss_selector;
+	int reason;
+	int int_type = svm->vmcb->control.exit_int_info &
+		SVM_EXITINTINFO_TYPE_MASK;
 
 	tss_selector = (u16)svm->vmcb->control.exit_info_1;
+
 	if (svm->vmcb->control.exit_info_2 &
 	    (1ULL << SVM_EXITINFOSHIFT_TS_REASON_IRET))
-		return kvm_task_switch(&svm->vcpu, tss_selector,
-				       TASK_SWITCH_IRET);
-	if (svm->vmcb->control.exit_info_2 &
-	    (1ULL << SVM_EXITINFOSHIFT_TS_REASON_JMP))
-		return kvm_task_switch(&svm->vcpu, tss_selector,
-				       TASK_SWITCH_JMP);
-	return kvm_task_switch(&svm->vcpu, tss_selector, TASK_SWITCH_CALL);
+		reason = TASK_SWITCH_IRET;
+	else if (svm->vmcb->control.exit_info_2 &
+		 (1ULL << SVM_EXITINFOSHIFT_TS_REASON_JMP))
+		reason = TASK_SWITCH_JMP;
+	else if (svm->vmcb->control.exit_int_info & SVM_EXITINTINFO_VALID)
+		reason = TASK_SWITCH_GATE;
+	else
+		reason = TASK_SWITCH_CALL;
+
+
+	if (reason != TASK_SWITCH_GATE || int_type == SVM_EXITINTINFO_TYPE_SOFT)
+		skip_emulated_instruction(&svm->vcpu);
+
+	return kvm_task_switch(&svm->vcpu, tss_selector, reason);
 }
 
 static int cpuid_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index e4ad9d3..c6997c0 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3038,22 +3038,40 @@ static int handle_task_switch(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned long exit_qualification;
 	u16 tss_selector;
-	int reason;
+	int reason, type, idt_v;
+
+	idt_v = (vmx->idt_vectoring_info & VECTORING_INFO_VALID_MASK);
+	type = (vmx->idt_vectoring_info & VECTORING_INFO_TYPE_MASK);
 
 	exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
 
 	reason = (u32)exit_qualification >> 30;
-	if (reason == TASK_SWITCH_GATE && vmx->vcpu.arch.nmi_injected &&
-	    (vmx->idt_vectoring_info & VECTORING_INFO_VALID_MASK) &&
-	    (vmx->idt_vectoring_info & VECTORING_INFO_TYPE_MASK)
-	    == INTR_TYPE_NMI_INTR) {
-		vcpu->arch.nmi_injected = false;
-		if (cpu_has_virtual_nmis())
-			vmcs_set_bits(GUEST_INTERRUPTIBILITY_INFO,
-				      GUEST_INTR_STATE_NMI);
+	if (reason == TASK_SWITCH_GATE && idt_v) {
+		switch (type) {
+		case INTR_TYPE_NMI_INTR:
+			vcpu->arch.nmi_injected = false;
+			if (cpu_has_virtual_nmis())
+				vmcs_set_bits(GUEST_INTERRUPTIBILITY_INFO,
+					      GUEST_INTR_STATE_NMI);
+			break;
+		case INTR_TYPE_EXT_INTR:
+			kvm_clear_interrupt_queue(vcpu);
+			break;
+		case INTR_TYPE_HARD_EXCEPTION:
+		case INTR_TYPE_SOFT_EXCEPTION:
+			kvm_clear_exception_queue(vcpu);
+			break;
+		default:
+			break;
+		}
 	}
 	tss_selector = exit_qualification;
 
+	if (!idt_v || (type != INTR_TYPE_HARD_EXCEPTION &&
+		       type != INTR_TYPE_EXT_INTR &&
+		       type != INTR_TYPE_NMI_INTR))
+		skip_emulated_instruction(vcpu);
+
 	if (!kvm_task_switch(vcpu, tss_selector, reason))
 		return 0;
 
@@ -3306,7 +3324,7 @@ static void vmx_complete_interrupts(struct vcpu_vmx *vmx)
 	vector = idt_vectoring_info & VECTORING_INFO_VECTOR_MASK;
 	type = idt_vectoring_info & VECTORING_INFO_TYPE_MASK;
 
-	switch(type) {
+	switch (type) {
 	case INTR_TYPE_NMI_INTR:
 		vmx->vcpu.arch.nmi_injected = true;
 		/*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 157d54b..95f1369 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3931,7 +3931,10 @@ int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int reason)
 		kvm_x86_ops->set_rflags(vcpu, eflags & ~X86_EFLAGS_NT);
 	}
 
-	kvm_x86_ops->skip_emulated_instruction(vcpu);
+	/* set back link to prev task only if NT bit is set in eflags
+	   note that old_tss_sel is not used afetr this point */
+	if (reason != TASK_SWITCH_CALL && reason != TASK_SWITCH_GATE)
+		old_tss_sel = 0xffff;
 
 	/* set back link to prev task only if NT bit is set in eflags
 	   note that old_tss_sel is not used afetr this point */
-- 
1.6.0.6

