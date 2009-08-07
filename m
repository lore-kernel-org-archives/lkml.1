Return-Path: <linux-kernel-owner+w=401wt.eu-S932155AbZHGJu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155AbZHGJu5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 05:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757292AbZHGJux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 05:50:53 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:38189
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756049AbZHGJuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 05:50:24 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KO03B6-03-0WO-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 01/21] kvm/svm: add helper functions for global interrupt flag
Date: Fri, 7 Aug 2009 11:49:28 +0200
Message-ID: <1249638588-10982-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1249638588-10982-1-git-send-email-joerg.roedel@amd.com>
References: <1249638588-10982-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 07 Aug 2009 09:49:50.0624 (UTC) FILETIME=[68296A00:01CA1744]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the code easier to read when it comes to setting,
clearing and checking the status of the virtualized global
interrupt flag for the VCPU.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   33 +++++++++++++++++++++++++--------
 1 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 70e81f5..8eb0852 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -130,6 +130,21 @@ static inline bool is_nested(struct vcpu_svm *svm)
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
@@ -624,7 +639,9 @@ static void init_vmcb(struct vcpu_svm *svm)
 	force_new_asid(&svm->vcpu);
 
 	svm->nested_vmcb = 0;
-	svm->vcpu.arch.hflags = HF_GIF_MASK;
+	svm->vcpu.arch.hflags = 0;
+
+	enable_gif(svm);
 }
 
 static int svm_vcpu_reset(struct kvm_vcpu *vcpu)
@@ -1632,7 +1649,7 @@ static int nested_svm_vmexit_real(struct vcpu_svm *svm, void *arg1,
 	svm->vmcb->save.cpl = 0;
 	svm->vmcb->control.exit_int_info = 0;
 
-	svm->vcpu.arch.hflags &= ~HF_GIF_MASK;
+	disable_gif(svm);
 	/* Exit nested SVM mode */
 	svm->nested_vmcb = 0;
 
@@ -1764,7 +1781,7 @@ static int nested_svm_vmrun(struct vcpu_svm *svm, void *arg1,
 	svm->vmcb->control.event_inj = nested_vmcb->control.event_inj;
 	svm->vmcb->control.event_inj_err = nested_vmcb->control.event_inj_err;
 
-	svm->vcpu.arch.hflags |= HF_GIF_MASK;
+	enable_gif(svm);
 
 	return 0;
 }
@@ -1853,7 +1870,7 @@ static int stgi_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 	svm->next_rip = kvm_rip_read(&svm->vcpu) + 3;
 	skip_emulated_instruction(&svm->vcpu);
 
-	svm->vcpu.arch.hflags |= HF_GIF_MASK;
+	enable_gif(svm);
 
 	return 1;
 }
@@ -1866,7 +1883,7 @@ static int clgi_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 	svm->next_rip = kvm_rip_read(&svm->vcpu) + 3;
 	skip_emulated_instruction(&svm->vcpu);
 
-	svm->vcpu.arch.hflags &= ~HF_GIF_MASK;
+	disable_gif(svm);
 
 	/* After a CLGI no interrupts should come */
 	svm_clear_vintr(svm);
@@ -2353,7 +2370,7 @@ static void svm_set_irq(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	BUG_ON(!(svm->vcpu.arch.hflags & HF_GIF_MASK));
+	BUG_ON(!(gif_set(svm)));
 
 	svm->vmcb->control.event_inj = vcpu->arch.interrupt.nr |
 		SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_INTR;
@@ -2384,7 +2401,7 @@ static int svm_interrupt_allowed(struct kvm_vcpu *vcpu)
 	struct vmcb *vmcb = svm->vmcb;
 	return (vmcb->save.rflags & X86_EFLAGS_IF) &&
 		!(vmcb->control.int_state & SVM_INTERRUPT_SHADOW_MASK) &&
-		(svm->vcpu.arch.hflags & HF_GIF_MASK) &&
+		gif_set(svm) &&
 		!is_nested(svm);
 }
 
@@ -2399,7 +2416,7 @@ static void enable_irq_window(struct kvm_vcpu *vcpu)
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


