Return-Path: <linux-kernel-owner+w=401wt.eu-S1753274AbZKPM1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbZKPM1L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 07:27:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752911AbZKPMUB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 07:20:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43779 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752975AbZKPMTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 07:19:43 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 39/42] KVM: SVM: Move INTR vmexit out of atomic code
Date: Mon, 16 Nov 2009 14:19:40 +0200
Message-Id: <1258373983-8693-40-git-send-email-avi@redhat.com>
In-Reply-To: <1258373983-8693-1-git-send-email-avi@redhat.com>
References: <1258373983-8693-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

The nested SVM code emulates a #vmexit caused by a request
to open the irq window right in the request function. This
is a bug because the request function runs with preemption
and interrupts disabled but the #vmexit emulation might
sleep. This can cause a schedule()-while-atomic bug and is
fixed with this patch.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
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
1.6.5.2

