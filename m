Return-Path: <linux-kernel-owner+w=401wt.eu-S1757738AbYAAPsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757738AbYAAPsa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:48:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754694AbYAAPgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:36:54 -0500
Received: from il.qumranet.com ([82.166.9.18]:33785 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754596AbYAAPg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:36:28 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 35/54] KVM: Use generalized exception queue for injecting #UD
Date: Tue,  1 Jan 2008 17:36:01 +0200
Message-Id: <1199201780-14001-36-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199201780-14001-1-git-send-email-avi@qumranet.com>
References: <1199201780-14001-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/svm.c |   12 ++----------
 drivers/kvm/vmx.c |   11 +----------
 2 files changed, 3 insertions(+), 20 deletions(-)

diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index b896614..8b1cc60 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -207,13 +207,6 @@ static bool svm_exception_injected(struct kvm_vcpu *vcpu)
 	return !(svm->vmcb->control.exit_int_info & SVM_EXITINTINFO_VALID);
 }
 
-static void inject_ud(struct kvm_vcpu *vcpu)
-{
-	to_svm(vcpu)->vmcb->control.event_inj = SVM_EVTINJ_VALID |
-						SVM_EVTINJ_TYPE_EXEPT |
-						UD_VECTOR;
-}
-
 static int is_external_interrupt(u32 info)
 {
 	info &= SVM_EVTINJ_TYPE_MASK | SVM_EVTINJ_VALID;
@@ -948,8 +941,7 @@ static int ud_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 
 	er = emulate_instruction(&svm->vcpu, kvm_run, 0, 0, 0);
 	if (er != EMULATE_DONE)
-		inject_ud(&svm->vcpu);
-
+		kvm_queue_exception(&svm->vcpu, UD_VECTOR);
 	return 1;
 }
 
@@ -1027,7 +1019,7 @@ static int vmmcall_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 static int invalid_op_interception(struct vcpu_svm *svm,
 				   struct kvm_run *kvm_run)
 {
-	inject_ud(&svm->vcpu);
+	kvm_queue_exception(&svm->vcpu, UD_VECTOR);
 	return 1;
 }
 
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 92660db..aa6bf2b 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -613,14 +613,6 @@ static bool vmx_exception_injected(struct kvm_vcpu *vcpu)
 	return !(vmx->idt_vectoring_info & VECTORING_INFO_VALID_MASK);
 }
 
-static void vmx_inject_ud(struct kvm_vcpu *vcpu)
-{
-	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD,
-		     UD_VECTOR |
-		     INTR_TYPE_EXCEPTION |
-		     INTR_INFO_VALID_MASK);
-}
-
 /*
  * Swap MSR entry in host/guest MSR entry array.
  */
@@ -1866,8 +1858,7 @@ static int handle_exception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	if (is_invalid_opcode(intr_info)) {
 		er = emulate_instruction(vcpu, kvm_run, 0, 0, 0);
 		if (er != EMULATE_DONE)
-			vmx_inject_ud(vcpu);
-
+			kvm_queue_exception(vcpu, UD_VECTOR);
 		return 1;
 	}
 
-- 
1.5.3.7

