Return-Path: <linux-kernel-owner+w=401wt.eu-S1758332AbZETLZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758332AbZETLZt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 07:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756677AbZETLT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 07:19:58 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55286 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755713AbZETLSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 07:18:50 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 31/46] KVM: SVM: Skip instruction on a task switch only when appropriate
Date: Wed, 20 May 2009 14:18:28 +0300
Message-Id: <1242818323-10413-32-git-send-email-avi@redhat.com>
In-Reply-To: <1242818323-10413-1-git-send-email-avi@redhat.com>
References: <1242818323-10413-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

If a task switch was initiated because off a task gate in IDT and IDT
was accessed because of an external even the instruction should not
be skipped.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/svm.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index bba67b7..8fc6eea 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1828,6 +1828,7 @@ static int task_switch_interception(struct vcpu_svm *svm,
 	int reason;
 	int int_type = svm->vmcb->control.exit_int_info &
 		SVM_EXITINTINFO_TYPE_MASK;
+	int int_vec = svm->vmcb->control.exit_int_info & SVM_EVTINJ_VEC_MASK;
 
 	tss_selector = (u16)svm->vmcb->control.exit_info_1;
 
@@ -1843,8 +1844,14 @@ static int task_switch_interception(struct vcpu_svm *svm,
 		reason = TASK_SWITCH_CALL;
 
 
-	if (reason != TASK_SWITCH_GATE || int_type == SVM_EXITINTINFO_TYPE_SOFT)
-		skip_emulated_instruction(&svm->vcpu);
+	if (reason != TASK_SWITCH_GATE ||
+	    int_type == SVM_EXITINTINFO_TYPE_SOFT ||
+	    (int_type == SVM_EXITINTINFO_TYPE_EXEPT &&
+	     (int_vec == OF_VECTOR || int_vec == BP_VECTOR))) {
+		if (emulate_instruction(&svm->vcpu, kvm_run, 0, 0,
+					EMULTYPE_SKIP) != EMULATE_DONE)
+			return 0;
+	}
 
 	return kvm_task_switch(&svm->vcpu, tss_selector, reason);
 }
-- 
1.6.0.6

