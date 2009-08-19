Return-Path: <linux-kernel-owner+w=401wt.eu-S1752477AbZHSNGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477AbZHSNGM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:06:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752347AbZHSNEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:04:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50576 "EHLO mx2.redhat.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751997AbZHSNCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:02:49 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 23/47] KVM: SVM: Improve nested interrupt injection
Date: Wed, 19 Aug 2009 16:02:19 +0300
Message-Id: <1250686963-8357-24-git-send-email-avi@redhat.com>
In-Reply-To: <1250686963-8357-1-git-send-email-avi@redhat.com>
References: <1250686963-8357-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Graf <agraf@suse.de>

While trying to get Hyper-V running, I realized that the interrupt injection
mechanisms that are in place right now are not 100% correct.

This patch makes nested SVM's interrupt injection behave more like on a
real machine.

Signed-off-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/svm.c |   39 ++++++++++++++++++++++++---------------
 1 files changed, 24 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index cd5a081..b2e23c8 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1615,7 +1615,8 @@ static int nested_svm_vmexit_real(struct vcpu_svm *svm, void *arg1,
 	/* Kill any pending exceptions */
 	if (svm->vcpu.arch.exception.pending == true)
 		nsvm_printk("WARNING: Pending Exception\n");
-	svm->vcpu.arch.exception.pending = false;
+	kvm_clear_exception_queue(&svm->vcpu);
+	kvm_clear_interrupt_queue(&svm->vcpu);
 
 	/* Restore selected save entries */
 	svm->vmcb->save.es = hsave->save.es;
@@ -1683,7 +1684,8 @@ static int nested_svm_vmrun(struct vcpu_svm *svm, void *arg1,
 	svm->nested_vmcb = svm->vmcb->save.rax;
 
 	/* Clear internal status */
-	svm->vcpu.arch.exception.pending = false;
+	kvm_clear_exception_queue(&svm->vcpu);
+	kvm_clear_interrupt_queue(&svm->vcpu);
 
 	/* Save the old vmcb, so we don't need to pick what we save, but
 	   can restore everything when a VMEXIT occurs */
@@ -2363,21 +2365,14 @@ static inline void svm_inject_irq(struct vcpu_svm *svm, int irq)
 		((/*control->int_vector >> 4*/ 0xf) << V_INTR_PRIO_SHIFT);
 }
 
-static void svm_queue_irq(struct kvm_vcpu *vcpu, unsigned nr)
-{
-	struct vcpu_svm *svm = to_svm(vcpu);
-
-	svm->vmcb->control.event_inj = nr |
-		SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_INTR;
-}
-
 static void svm_set_irq(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	nested_svm_intr(svm);
+	BUG_ON(!(svm->vcpu.arch.hflags & HF_GIF_MASK));
 
-	svm_queue_irq(vcpu, vcpu->arch.interrupt.nr);
+	svm->vmcb->control.event_inj = vcpu->arch.interrupt.nr |
+		SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_INTR;
 }
 
 static void update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
@@ -2405,13 +2400,25 @@ static int svm_interrupt_allowed(struct kvm_vcpu *vcpu)
 	struct vmcb *vmcb = svm->vmcb;
 	return (vmcb->save.rflags & X86_EFLAGS_IF) &&
 		!(vmcb->control.int_state & SVM_INTERRUPT_SHADOW_MASK) &&
-		(svm->vcpu.arch.hflags & HF_GIF_MASK);
+		(svm->vcpu.arch.hflags & HF_GIF_MASK) &&
+		!is_nested(svm);
 }
 
 static void enable_irq_window(struct kvm_vcpu *vcpu)
 {
-	svm_set_vintr(to_svm(vcpu));
-	svm_inject_irq(to_svm(vcpu), 0x0);
+	struct vcpu_svm *svm = to_svm(vcpu);
+	nsvm_printk("Trying to open IRQ window\n");
+
+	nested_svm_intr(svm);
+
+	/* In case GIF=0 we can't rely on the CPU to tell us when
+	 * GIF becomes 1, because that's a separate STGI/VMRUN intercept.
+	 * The next time we get that intercept, this function will be
+	 * called again though and we'll get the vintr intercept. */
+	if (svm->vcpu.arch.hflags & HF_GIF_MASK) {
+		svm_set_vintr(svm);
+		svm_inject_irq(svm, 0x0);
+	}
 }
 
 static void enable_nmi_window(struct kvm_vcpu *vcpu)
@@ -2490,6 +2497,8 @@ static void svm_complete_interrupts(struct vcpu_svm *svm)
 	case SVM_EXITINTINFO_TYPE_EXEPT:
 		/* In case of software exception do not reinject an exception
 		   vector, but re-execute and instruction instead */
+		if (is_nested(svm))
+			break;
 		if (kvm_exception_is_soft(vector))
 			break;
 		if (exitintinfo & SVM_EXITINTINFO_VALID_ERR) {
-- 
1.6.3.3

