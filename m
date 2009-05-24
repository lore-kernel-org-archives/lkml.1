Return-Path: <linux-kernel-owner+w=401wt.eu-S1759461AbZEXP6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759461AbZEXP6d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 11:58:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758687AbZEXPx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 11:53:28 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41844 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754583AbZEXPue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 11:50:34 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 16/45] KVM: SVM: Don't reinject event that caused a task switch
Date: Sun, 24 May 2009 18:50:01 +0300
Message-Id: <1243180230-2480-17-git-send-email-avi@redhat.com>
In-Reply-To: <1243180230-2480-1-git-send-email-avi@redhat.com>
References: <1243180230-2480-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

If a task switch caused by an event remove it from the event queue.
VMX already does that.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/svm.c |   23 +++++++++++++++++++++--
 1 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index e3ea982..f994c6d 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1811,6 +1811,10 @@ static int task_switch_interception(struct vcpu_svm *svm,
 	int int_type = svm->vmcb->control.exit_int_info &
 		SVM_EXITINTINFO_TYPE_MASK;
 	int int_vec = svm->vmcb->control.exit_int_info & SVM_EVTINJ_VEC_MASK;
+	uint32_t type =
+		svm->vmcb->control.exit_int_info & SVM_EXITINTINFO_TYPE_MASK;
+	uint32_t idt_v =
+		svm->vmcb->control.exit_int_info & SVM_EXITINTINFO_VALID;
 
 	tss_selector = (u16)svm->vmcb->control.exit_info_1;
 
@@ -1820,11 +1824,26 @@ static int task_switch_interception(struct vcpu_svm *svm,
 	else if (svm->vmcb->control.exit_info_2 &
 		 (1ULL << SVM_EXITINFOSHIFT_TS_REASON_JMP))
 		reason = TASK_SWITCH_JMP;
-	else if (svm->vmcb->control.exit_int_info & SVM_EXITINTINFO_VALID)
+	else if (idt_v)
 		reason = TASK_SWITCH_GATE;
 	else
 		reason = TASK_SWITCH_CALL;
 
+	if (reason == TASK_SWITCH_GATE) {
+		switch (type) {
+		case SVM_EXITINTINFO_TYPE_NMI:
+			svm->vcpu.arch.nmi_injected = false;
+			break;
+		case SVM_EXITINTINFO_TYPE_EXEPT:
+			kvm_clear_exception_queue(&svm->vcpu);
+			break;
+		case SVM_EXITINTINFO_TYPE_INTR:
+			kvm_clear_interrupt_queue(&svm->vcpu);
+			break;
+		default:
+			break;
+		}
+	}
 
 	if (reason != TASK_SWITCH_GATE ||
 	    int_type == SVM_EXITINTINFO_TYPE_SOFT ||
@@ -2203,7 +2222,7 @@ static int handle_exit(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
 
 	if (is_external_interrupt(svm->vmcb->control.exit_int_info) &&
 	    exit_code != SVM_EXIT_EXCP_BASE + PF_VECTOR &&
-	    exit_code != SVM_EXIT_NPF)
+	    exit_code != SVM_EXIT_NPF && exit_code != SVM_EXIT_TASK_SWITCH)
 		printk(KERN_ERR "%s: unexpected exit_ini_info 0x%x "
 		       "exit_code 0x%x\n",
 		       __func__, svm->vmcb->control.exit_int_info,
-- 
1.6.0.6

