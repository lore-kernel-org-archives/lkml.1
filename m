Return-Path: <linux-kernel-owner+w=401wt.eu-S1760941AbZJIOJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760941AbZJIOJf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 10:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760927AbZJIOJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 10:09:33 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:36492
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756715AbZJIOJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 10:09:29 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i2a8h6bh62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KR93AB-02-05R-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/9] KVM: SVM: Move INTR vmexit out of atomic code
Date: Fri, 9 Oct 2009 16:08:26 +0200
Message-ID: <1255097313-23267-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.4.3
In-Reply-To: <1255097313-23267-1-git-send-email-joerg.roedel@amd.com>
References: <1255097313-23267-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 09 Oct 2009 14:08:36.0309 (UTC) FILETIME=[FE373050:01CA48E9]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
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


