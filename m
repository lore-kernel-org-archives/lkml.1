Return-Path: <linux-kernel-owner+w=401wt.eu-S1753831AbZKPMZE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831AbZKPMZE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 07:25:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753392AbZKPMUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 07:20:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59336 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752922AbZKPMTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 07:19:42 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 25/42] KVM: SVM: reorganize svm_interrupt_allowed
Date: Mon, 16 Nov 2009 14:19:26 +0200
Message-Id: <1258373983-8693-26-git-send-email-avi@redhat.com>
In-Reply-To: <1258373983-8693-1-git-send-email-avi@redhat.com>
References: <1258373983-8693-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

This patch reorganizes the logic in svm_interrupt_allowed to
make it better to read. This is important because the logic
is a lot more complicated with Nested SVM.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/kvm/svm.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 59fe4d5..3f3fe81 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2472,10 +2472,18 @@ static int svm_interrupt_allowed(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct vmcb *vmcb = svm->vmcb;
-	return (vmcb->save.rflags & X86_EFLAGS_IF) &&
-		!(vmcb->control.int_state & SVM_INTERRUPT_SHADOW_MASK) &&
-		gif_set(svm) &&
-		!(is_nested(svm) && (svm->vcpu.arch.hflags & HF_VINTR_MASK));
+	int ret;
+
+	if (!gif_set(svm) ||
+	     (vmcb->control.int_state & SVM_INTERRUPT_SHADOW_MASK))
+		return 0;
+
+	ret = !!(vmcb->save.rflags & X86_EFLAGS_IF);
+
+	if (is_nested(svm))
+		return ret && !(svm->vcpu.arch.hflags & HF_VINTR_MASK);
+
+	return ret;
 }
 
 static void enable_irq_window(struct kvm_vcpu *vcpu)
-- 
1.6.5.2

