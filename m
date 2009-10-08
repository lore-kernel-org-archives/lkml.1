Return-Path: <linux-kernel-owner+w=401wt.eu-S1756807AbZJHKEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807AbZJHKEZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 06:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756788AbZJHKEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 06:04:24 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:43550
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754363AbZJHKEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 06:04:23 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KR6X9Z-03-4RQ-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/9] KVM: SVM: Move INTR vmexit out of atomic code
Date: Thu, 8 Oct 2009 12:03:12 +0200
Message-ID: <1254996199-17667-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.4.3
In-Reply-To: <1254996199-17667-1-git-send-email-joerg.roedel@amd.com>
References: <1254996199-17667-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 08 Oct 2009 10:03:23.0541 (UTC) FILETIME=[924F3450:01CA47FE]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The nested SVM code emulates a #vmexit caused by a request
to open the irq window right in the request function. This
is a bug because the request function runs with preemption
and interrupts disabled but the #vmexit emulation might
sleep. This can cause a schedule()-while-atomic bug and is
fixed with this patch.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   26 +++++++++++++++++++++++++-
 1 files changed, 25 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index e372854..884bffc 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -85,6 +85,9 @@ struct nested_state {
 	/* gpa pointers to the real vectors */
 	u64 vmcb_msrpm;
 
+	/* A VMEXIT is required but not yet emulated */
+	bool exit_required;
+
 	/* cache for intercepts of the guest */
 	u16 intercept_cr_read;
 	u16 intercept_cr_write;
@@ -1379,7 +1382,14 @@ static inline int nested_svm_intr(struct vcpu_svm *svm)
 
 	svm->vmcb->control.exit_code = SVM_EXIT_INTR;
 
-	if (nested_svm_exit_handled(svm)) {
+	if (svm->nested.intercept & 1ULL) {
+		/*
+		 * The #vmexit can't be emulated here directly because this
+		 * code path runs with irqs and preemtion disabled. A
+		 * #vmexit emulation might sleep. Only signal request for
+		 * the #vmexit here.
+		 */
+		svm->nested.exit_required = true;
 		nsvm_printk("VMexit -> INTR\n");
 		return 1;
 	}
@@ -2340,6 +2350,13 @@ static int handle_exit(struct kvm_vcpu *vcpu)
 
 	trace_kvm_exit(exit_code, svm->vmcb->save.rip);
 
+	if (unlikely(svm->nested.exit_required)) {
+		nested_svm_vmexit(svm);
+		svm->nested.exit_required = false;
+
+		return 1;
+	}
+
 	if (is_nested(svm)) {
 		int vmexit;
 
@@ -2615,6 +2632,13 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
 	u16 gs_selector;
 	u16 ldt_selector;
 
+	/*
+	 * A vmexit emulation is required before the vcpu can be executed
+	 * again.
+	 */
+	if (unlikely(svm->nested.exit_required))
+		return;
+
 	svm->vmcb->save.rax = vcpu->arch.regs[VCPU_REGS_RAX];
 	svm->vmcb->save.rsp = vcpu->arch.regs[VCPU_REGS_RSP];
 	svm->vmcb->save.rip = vcpu->arch.regs[VCPU_REGS_RIP];
-- 
1.6.4.3


