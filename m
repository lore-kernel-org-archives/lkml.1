Return-Path: <linux-kernel-owner+w=401wt.eu-S1756788AbZKSNme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788AbZKSNme (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 08:42:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756377AbZKSNma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 08:42:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52929 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753423AbZKSNfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 08:35:08 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 13/35] KVM: SVM: Cleanup NMI singlestep
Date: Thu, 19 Nov 2009 15:34:49 +0200
Message-Id: <1258637711-11674-14-git-send-email-avi@redhat.com>
In-Reply-To: <1258637711-11674-1-git-send-email-avi@redhat.com>
References: <1258637711-11674-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@web.de>

Push the NMI-related singlestep variable into vcpu_svm. It's dealing
with an AMD-specific deficit, nothing generic for x86.

Acked-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>

 arch/x86/include/asm/kvm_host.h |    1 -
 arch/x86/kvm/svm.c              |   12 +++++++-----
 2 files changed, 7 insertions(+), 6 deletions(-)
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    1 -
 arch/x86/kvm/svm.c              |   12 +++++++-----
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2536fbd..4d994ad 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -354,7 +354,6 @@ struct kvm_vcpu_arch {
 	unsigned int time_offset;
 	struct page *time_page;
 
-	bool singlestep; /* guest is single stepped by KVM */
 	bool nmi_pending;
 	bool nmi_injected;
 
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 170b2d9..ffa6ad2 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -107,6 +107,8 @@ struct vcpu_svm {
 	u32 *msrpm;
 
 	struct nested_state nested;
+
+	bool nmi_singlestep;
 };
 
 /* enable NPT for AMD64 and X86 with PAE */
@@ -1050,7 +1052,7 @@ static void update_db_intercept(struct kvm_vcpu *vcpu)
 	svm->vmcb->control.intercept_exceptions &=
 		~((1 << DB_VECTOR) | (1 << BP_VECTOR));
 
-	if (vcpu->arch.singlestep)
+	if (svm->nmi_singlestep)
 		svm->vmcb->control.intercept_exceptions |= (1 << DB_VECTOR);
 
 	if (vcpu->guest_debug & KVM_GUESTDBG_ENABLE) {
@@ -1195,13 +1197,13 @@ static int db_interception(struct vcpu_svm *svm)
 
 	if (!(svm->vcpu.guest_debug &
 	      (KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP)) &&
-		!svm->vcpu.arch.singlestep) {
+		!svm->nmi_singlestep) {
 		kvm_queue_exception(&svm->vcpu, DB_VECTOR);
 		return 1;
 	}
 
-	if (svm->vcpu.arch.singlestep) {
-		svm->vcpu.arch.singlestep = false;
+	if (svm->nmi_singlestep) {
+		svm->nmi_singlestep = false;
 		if (!(svm->vcpu.guest_debug & KVM_GUESTDBG_SINGLESTEP))
 			svm->vmcb->save.rflags &=
 				~(X86_EFLAGS_TF | X86_EFLAGS_RF);
@@ -2543,7 +2545,7 @@ static void enable_nmi_window(struct kvm_vcpu *vcpu)
 	/* Something prevents NMI from been injected. Single step over
 	   possible problem (IRET or exception injection or interrupt
 	   shadow) */
-	vcpu->arch.singlestep = true;
+	svm->nmi_singlestep = true;
 	svm->vmcb->save.rflags |= (X86_EFLAGS_TF | X86_EFLAGS_RF);
 	update_db_intercept(vcpu);
 }
-- 
1.6.5.2

