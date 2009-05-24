Return-Path: <linux-kernel-owner+w=401wt.eu-S1756105AbZEXPu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105AbZEXPu5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 11:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755000AbZEXPuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 11:50:35 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41820 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752613AbZEXPub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 11:50:31 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 04/45] KVM: Do not report TPR write to userspace if new value bigger or equal to a previous one.
Date: Sun, 24 May 2009 18:49:49 +0300
Message-Id: <1243180230-2480-5-git-send-email-avi@redhat.com>
In-Reply-To: <1243180230-2480-1-git-send-email-avi@redhat.com>
References: <1243180230-2480-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

Saves many exits to userspace in a case of IRQ chip in userspace.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/svm.c |    4 ++++
 arch/x86/kvm/vmx.c |   19 ++++++++++++-------
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 143818e..e283a63 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1862,9 +1862,13 @@ static int emulate_on_interception(struct vcpu_svm *svm,
 
 static int cr8_write_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 {
+	u8 cr8_prev = kvm_get_cr8(&svm->vcpu);
+	/* instruction emulation calls kvm_set_cr8() */
 	emulate_instruction(&svm->vcpu, NULL, 0, 0, 0);
 	if (irqchip_in_kernel(svm->vcpu.kvm))
 		return 1;
+	if (cr8_prev <= kvm_get_cr8(&svm->vcpu))
+		return 1;
 	kvm_run->exit_reason = KVM_EXIT_SET_TPR;
 	return 0;
 }
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 9162b4c..51f804c 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2724,13 +2724,18 @@ static int handle_cr(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 			kvm_set_cr4(vcpu, kvm_register_read(vcpu, reg));
 			skip_emulated_instruction(vcpu);
 			return 1;
-		case 8:
-			kvm_set_cr8(vcpu, kvm_register_read(vcpu, reg));
-			skip_emulated_instruction(vcpu);
-			if (irqchip_in_kernel(vcpu->kvm))
-				return 1;
-			kvm_run->exit_reason = KVM_EXIT_SET_TPR;
-			return 0;
+		case 8: {
+				u8 cr8_prev = kvm_get_cr8(vcpu);
+				u8 cr8 = kvm_register_read(vcpu, reg);
+				kvm_set_cr8(vcpu, cr8);
+				skip_emulated_instruction(vcpu);
+				if (irqchip_in_kernel(vcpu->kvm))
+					return 1;
+				if (cr8_prev <= cr8)
+					return 1;
+				kvm_run->exit_reason = KVM_EXIT_SET_TPR;
+				return 0;
+			}
 		};
 		break;
 	case 2: /* clts */
-- 
1.6.0.6

