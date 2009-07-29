Return-Path: <linux-kernel-owner+w=401wt.eu-S1755029AbZG2M53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029AbZG2M53 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 08:57:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754934AbZG2M50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 08:57:26 -0400
Received: from sg2ehsobe005.messaging.microsoft.com ([207.46.51.79]:18589 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754793AbZG2M5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 08:57:03 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0KNJNYL-03-5SX-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 02/12] kvm/svm: add helper functions for global interrupt flag
Date: Wed, 29 Jul 2009 14:56:22 +0200
Message-ID: <1248872192-30881-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248872192-30881-1-git-send-email-joerg.roedel@amd.com>
References: <1248872192-30881-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 29 Jul 2009 12:56:36.0967 (UTC) FILETIME=[01F1E770:01CA104C]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   31 +++++++++++++++++++++++--------
 1 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 27d26c3..9f69b25 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -136,6 +136,21 @@ static inline bool is_nested(struct vcpu_svm *svm)
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
@@ -630,7 +645,7 @@ static void init_vmcb(struct vcpu_svm *svm)
 	force_new_asid(&svm->vcpu);
 
 	svm->nested_vmcb = 0;
-	svm->vcpu.arch.hflags = HF_GIF_MASK;
+	enable_gif(svm);
 }
 
 static int svm_vcpu_reset(struct kvm_vcpu *vcpu)
@@ -1638,7 +1653,7 @@ static int nested_svm_vmexit_real(struct vcpu_svm *svm, void *arg1,
 	svm->vmcb->save.cpl = 0;
 	svm->vmcb->control.exit_int_info = 0;
 
-	svm->vcpu.arch.hflags &= ~HF_GIF_MASK;
+	disable_gif(svm);
 	/* Exit nested SVM mode */
 	svm->nested_vmcb = 0;
 
@@ -1770,7 +1785,7 @@ static int nested_svm_vmrun(struct vcpu_svm *svm, void *arg1,
 	svm->vmcb->control.event_inj = nested_vmcb->control.event_inj;
 	svm->vmcb->control.event_inj_err = nested_vmcb->control.event_inj_err;
 
-	svm->vcpu.arch.hflags |= HF_GIF_MASK;
+	enable_gif(svm);
 
 	return 0;
 }
@@ -1859,7 +1874,7 @@ static int stgi_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 	svm->next_rip = kvm_rip_read(&svm->vcpu) + 3;
 	skip_emulated_instruction(&svm->vcpu);
 
-	svm->vcpu.arch.hflags |= HF_GIF_MASK;
+	enable_gif(svm);
 
 	return 1;
 }
@@ -1872,7 +1887,7 @@ static int clgi_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 	svm->next_rip = kvm_rip_read(&svm->vcpu) + 3;
 	skip_emulated_instruction(&svm->vcpu);
 
-	svm->vcpu.arch.hflags &= ~HF_GIF_MASK;
+	disable_gif(svm);
 
 	/* After a CLGI no interrupts should come */
 	svm_clear_vintr(svm);
@@ -2359,7 +2374,7 @@ static void svm_set_irq(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	BUG_ON(!(svm->vcpu.arch.hflags & HF_GIF_MASK));
+	BUG_ON(!(gif_set(svm)));
 
 	svm->vmcb->control.event_inj = vcpu->arch.interrupt.nr |
 		SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_INTR;
@@ -2390,7 +2405,7 @@ static int svm_interrupt_allowed(struct kvm_vcpu *vcpu)
 	struct vmcb *vmcb = svm->vmcb;
 	return (vmcb->save.rflags & X86_EFLAGS_IF) &&
 		!(vmcb->control.int_state & SVM_INTERRUPT_SHADOW_MASK) &&
-		(svm->vcpu.arch.hflags & HF_GIF_MASK) &&
+		gif_set(svm) &&
 		!is_nested(svm);
 }
 
@@ -2405,7 +2420,7 @@ static void enable_irq_window(struct kvm_vcpu *vcpu)
 	 * GIF becomes 1, because that's a separate STGI/VMRUN intercept.
 	 * The next time we get that intercept, this function will be
 	 * called again though and we'll get the vintr intercept. */
-	if (svm->vcpu.arch.hflags & HF_GIF_MASK) {
+	if (gif_set(svm)) {
 		svm_set_vintr(svm);
 		svm_inject_irq(svm, 0x0);
 	}
-- 
1.6.3.3


