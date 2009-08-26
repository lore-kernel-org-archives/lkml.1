Return-Path: <linux-kernel-owner+w=401wt.eu-S1757323AbZHZKka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323AbZHZKka (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 06:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757313AbZHZKif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 06:38:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28019 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757044AbZHZKaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 06:30:12 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 12/47] KVM: SVM: add helper functions for global interrupt flag
Date: Wed, 26 Aug 2009 13:29:34 +0300
Message-Id: <1251282609-12835-13-git-send-email-avi@redhat.com>
In-Reply-To: <1251282609-12835-1-git-send-email-avi@redhat.com>
References: <1251282609-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

This patch makes the code easier to read when it comes to setting,
clearing and checking the status of the virtualized global
interrupt flag for the VCPU.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/svm.c |   33 +++++++++++++++++++++++++--------
 1 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 10e718d..9f72772 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -129,6 +129,21 @@ static inline bool is_nested(struct vcpu_svm *svm)
 	return svm->nested_vmcb;
 }
 
+static inline void enable_gif(struct vcpu_svm *svm)
+{
+	svm->vcpu.arch.hflags |= HF_GIF_MASK;
+}
+
+static inline void disable_gif(struct vcpu_svm *svm)
+{
+	svm->vcpu.arch.hflags &= ~HF_GIF_MASK;
+}
+
+static inline bool gif_set(struct vcpu_svm *svm)
+{
+	return !!(svm->vcpu.arch.hflags & HF_GIF_MASK);
+}
+
 static unsigned long iopm_base;
 
 struct kvm_ldttss_desc {
@@ -621,7 +636,9 @@ static void init_vmcb(struct vcpu_svm *svm)
 	force_new_asid(&svm->vcpu);
 
 	svm->nested_vmcb = 0;
-	svm->vcpu.arch.hflags = HF_GIF_MASK;
+	svm->vcpu.arch.hflags = 0;
+
+	enable_gif(svm);
 }
 
 static int svm_vcpu_reset(struct kvm_vcpu *vcpu)
@@ -1629,7 +1646,7 @@ static int nested_svm_vmexit_real(struct vcpu_svm *svm, void *arg1,
 	svm->vmcb->save.cpl = 0;
 	svm->vmcb->control.exit_int_info = 0;
 
-	svm->vcpu.arch.hflags &= ~HF_GIF_MASK;
+	disable_gif(svm);
 	/* Exit nested SVM mode */
 	svm->nested_vmcb = 0;
 
@@ -1761,7 +1778,7 @@ static int nested_svm_vmrun(struct vcpu_svm *svm, void *arg1,
 	svm->vmcb->control.event_inj = nested_vmcb->control.event_inj;
 	svm->vmcb->control.event_inj_err = nested_vmcb->control.event_inj_err;
 
-	svm->vcpu.arch.hflags |= HF_GIF_MASK;
+	enable_gif(svm);
 
 	return 0;
 }
@@ -1850,7 +1867,7 @@ static int stgi_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 	svm->next_rip = kvm_rip_read(&svm->vcpu) + 3;
 	skip_emulated_instruction(&svm->vcpu);
 
-	svm->vcpu.arch.hflags |= HF_GIF_MASK;
+	enable_gif(svm);
 
 	return 1;
 }
@@ -1863,7 +1880,7 @@ static int clgi_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 	svm->next_rip = kvm_rip_read(&svm->vcpu) + 3;
 	skip_emulated_instruction(&svm->vcpu);
 
-	svm->vcpu.arch.hflags &= ~HF_GIF_MASK;
+	disable_gif(svm);
 
 	/* After a CLGI no interrupts should come */
 	svm_clear_vintr(svm);
@@ -2352,7 +2369,7 @@ static void svm_set_irq(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	BUG_ON(!(svm->vcpu.arch.hflags & HF_GIF_MASK));
+	BUG_ON(!(gif_set(svm)));
 
 	svm->vmcb->control.event_inj = vcpu->arch.interrupt.nr |
 		SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_INTR;
@@ -2383,7 +2400,7 @@ static int svm_interrupt_allowed(struct kvm_vcpu *vcpu)
 	struct vmcb *vmcb = svm->vmcb;
 	return (vmcb->save.rflags & X86_EFLAGS_IF) &&
 		!(vmcb->control.int_state & SVM_INTERRUPT_SHADOW_MASK) &&
-		(svm->vcpu.arch.hflags & HF_GIF_MASK) &&
+		gif_set(svm) &&
 		!is_nested(svm);
 }
 
@@ -2398,7 +2415,7 @@ static void enable_irq_window(struct kvm_vcpu *vcpu)
 	 * GIF becomes 1, because that's a separate STGI/VMRUN intercept.
 	 * The next time we get that intercept, this function will be
 	 * called again though and we'll get the vintr intercept. */
-	if (svm->vcpu.arch.hflags & HF_GIF_MASK) {
+	if (gif_set(svm)) {
 		svm_set_vintr(svm);
 		svm_inject_irq(svm, 0x0);
 	}
-- 
1.6.4.1

