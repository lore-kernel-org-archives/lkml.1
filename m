Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab0BSPYJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 10:24:09 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:49066 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754339Ab0BSPYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 10:24:03 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i6bh87h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KY3HET-02-7NI-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>, stable@kernel.org
Subject: [PATCH 07/11] KVM: SVM: Don't sync nested cr8 to lapic and back
Date: Fri, 19 Feb 2010 16:23:06 +0100
Message-ID: <1266592990-8911-8-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1266592990-8911-1-git-send-email-joerg.roedel@amd.com>
References: <1266592990-8911-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 19 Feb 2010 15:23:12.0886 (UTC) FILETIME=[73676160:01CAB177]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes syncing of the guest tpr to the lapic
conditional on !nested. Otherwise a nested guest using the
TPR could freeze the guest.
Another important change this patch introduces is that the
cr8 intercept bits are no longer ORed at vmrun emulation if
the guest sets VINTR_MASKING in its VMCB. The reason is that
nested cr8 accesses need alway be handled by the nested
hypervisor because they change the shadow version of the
tpr.

Cc: stable@kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   46 +++++++++++++++++++++++++++++++---------------
 1 files changed, 31 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index f22ced1..d7b75fb 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1827,21 +1827,6 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 	svm->vmcb->save.dr6 = nested_vmcb->save.dr6;
 	svm->vmcb->save.cpl = nested_vmcb->save.cpl;
 
-	/* We don't want a nested guest to be more powerful than the guest,
-	   so all intercepts are ORed */
-	svm->vmcb->control.intercept_cr_read |=
-		nested_vmcb->control.intercept_cr_read;
-	svm->vmcb->control.intercept_cr_write |=
-		nested_vmcb->control.intercept_cr_write;
-	svm->vmcb->control.intercept_dr_read |=
-		nested_vmcb->control.intercept_dr_read;
-	svm->vmcb->control.intercept_dr_write |=
-		nested_vmcb->control.intercept_dr_write;
-	svm->vmcb->control.intercept_exceptions |=
-		nested_vmcb->control.intercept_exceptions;
-
-	svm->vmcb->control.intercept |= nested_vmcb->control.intercept;
-
 	svm->nested.vmcb_msrpm = nested_vmcb->control.msrpm_base_pa;
 
 	/* cache intercepts */
@@ -1859,6 +1844,28 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 	else
 		svm->vcpu.arch.hflags &= ~HF_VINTR_MASK;
 
+	if (svm->vcpu.arch.hflags & HF_VINTR_MASK) {
+		/* We only want the cr8 intercept bits of the guest */
+		svm->vmcb->control.intercept_cr_read &= ~INTERCEPT_CR8_MASK;
+		svm->vmcb->control.intercept_cr_write &= ~INTERCEPT_CR8_MASK;
+	}
+
+	/* We don't want a nested guest to be more powerful than the guest,
+	   so all intercepts are ORed */
+	svm->vmcb->control.intercept_cr_read |=
+		nested_vmcb->control.intercept_cr_read;
+	svm->vmcb->control.intercept_cr_write |=
+		nested_vmcb->control.intercept_cr_write;
+	svm->vmcb->control.intercept_dr_read |=
+		nested_vmcb->control.intercept_dr_read;
+	svm->vmcb->control.intercept_dr_write |=
+		nested_vmcb->control.intercept_dr_write;
+	svm->vmcb->control.intercept_exceptions |=
+		nested_vmcb->control.intercept_exceptions;
+
+	svm->vmcb->control.intercept |= nested_vmcb->control.intercept;
+
+	svm->vmcb->control.lbr_ctl = nested_vmcb->control.lbr_ctl;
 	svm->vmcb->control.int_vector = nested_vmcb->control.int_vector;
 	svm->vmcb->control.int_state = nested_vmcb->control.int_state;
 	svm->vmcb->control.tsc_offset += nested_vmcb->control.tsc_offset;
@@ -2521,6 +2528,9 @@ static void update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	if (is_nested(svm) && (vcpu->arch.hflags & HF_VINTR_MASK))
+		return;
+
 	if (irr == -1)
 		return;
 
@@ -2622,6 +2632,9 @@ static inline void sync_cr8_to_lapic(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	if (is_nested(svm) && (vcpu->arch.hflags & HF_VINTR_MASK))
+		return;
+
 	if (!(svm->vmcb->control.intercept_cr_write & INTERCEPT_CR8_MASK)) {
 		int cr8 = svm->vmcb->control.int_ctl & V_TPR_MASK;
 		kvm_set_cr8(vcpu, cr8);
@@ -2633,6 +2646,9 @@ static inline void sync_lapic_to_cr8(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 	u64 cr8;
 
+	if (is_nested(svm) && (vcpu->arch.hflags & HF_VINTR_MASK))
+		return;
+
 	cr8 = kvm_get_cr8(vcpu);
 	svm->vmcb->control.int_ctl &= ~V_TPR_MASK;
 	svm->vmcb->control.int_ctl |= cr8 & V_TPR_MASK;
-- 
1.6.6


