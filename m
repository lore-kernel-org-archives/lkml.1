Return-Path: <linux-kernel-owner+w=401wt.eu-S1758205AbZEXPyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205AbZEXPyv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 11:54:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757666AbZEXPvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 11:51:35 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41858 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755086AbZEXPuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 11:50:35 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 39/45] KVM: skip_emulated_instruction() decode instruction if size is not known
Date: Sun, 24 May 2009 18:50:24 +0300
Message-Id: <1243180230-2480-40-git-send-email-avi@redhat.com>
In-Reply-To: <1243180230-2480-1-git-send-email-avi@redhat.com>
References: <1243180230-2480-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/svm.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index ac3d5ba..1315ce0 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -228,7 +228,9 @@ static void skip_emulated_instruction(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	if (!svm->next_rip) {
-		printk(KERN_DEBUG "%s: NOP\n", __func__);
+		if (emulate_instruction(vcpu, vcpu->run, 0, 0, EMULTYPE_SKIP) !=
+				EMULATE_DONE)
+			printk(KERN_DEBUG "%s: NOP\n", __func__);
 		return;
 	}
 	if (svm->next_rip - kvm_rip_read(vcpu) > MAX_INST_SIZE)
@@ -1868,11 +1870,8 @@ static int task_switch_interception(struct vcpu_svm *svm,
 	if (reason != TASK_SWITCH_GATE ||
 	    int_type == SVM_EXITINTINFO_TYPE_SOFT ||
 	    (int_type == SVM_EXITINTINFO_TYPE_EXEPT &&
-	     (int_vec == OF_VECTOR || int_vec == BP_VECTOR))) {
-		if (emulate_instruction(&svm->vcpu, kvm_run, 0, 0,
-					EMULTYPE_SKIP) != EMULATE_DONE)
-			return 0;
-	}
+	     (int_vec == OF_VECTOR || int_vec == BP_VECTOR)))
+		skip_emulated_instruction(&svm->vcpu);
 
 	return kvm_task_switch(&svm->vcpu, tss_selector, reason);
 }
-- 
1.6.0.6

