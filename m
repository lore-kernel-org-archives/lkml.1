Return-Path: <linux-kernel-owner+w=401wt.eu-S1756484AbZIPNZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484AbZIPNZQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 09:25:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755930AbZIPNZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 09:25:15 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:34064
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752501AbZIPNYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 09:24:53 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i203h64h)
X-Spam-TCS-SCL: 3:0
X-FB-SS: 5,
X-WSS-ID: 0KQ2FX2-01-3ND-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alexander Graf <agraf@suse.de>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/5] KVM: SVM: reorganize svm_interrupt_allowed
Date: Wed, 16 Sep 2009 15:24:15 +0200
Message-ID: <1253107459-8967-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253107459-8967-1-git-send-email-joerg.roedel@amd.com>
References: <1253107459-8967-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 16 Sep 2009 13:24:23.0156 (UTC) FILETIME=[014FEB40:01CA36D1]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch reorganizes the logic in svm_interrupt_allowed to
make it better to read. This is important because the logic
is a lot more complicated with Nested SVM.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index a2f2d43..668460c 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2454,10 +2454,18 @@ static int svm_interrupt_allowed(struct kvm_vcpu *vcpu)
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
1.6.3.3


