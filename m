Return-Path: <linux-kernel-owner+w=401wt.eu-S1755974AbZEXPvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974AbZEXPvN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 11:51:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755504AbZEXPuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 11:50:37 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41822 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926AbZEXPub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 11:50:31 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 03/45] KVM: sync_lapic_to_cr8() should always sync cr8 to V_TPR
Date: Sun, 24 May 2009 18:49:48 +0300
Message-Id: <1243180230-2480-4-git-send-email-avi@redhat.com>
In-Reply-To: <1243180230-2480-1-git-send-email-avi@redhat.com>
References: <1243180230-2480-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

Even if IRQ chip is in userspace.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/svm.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 2905475..143818e 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2348,7 +2348,7 @@ static inline void sync_cr8_to_lapic(struct kvm_vcpu *vcpu)
 
 	if (!(svm->vmcb->control.intercept_cr_write & INTERCEPT_CR8_MASK)) {
 		int cr8 = svm->vmcb->control.int_ctl & V_TPR_MASK;
-		kvm_lapic_set_tpr(vcpu, cr8);
+		kvm_set_cr8(vcpu, cr8);
 	}
 }
 
@@ -2357,9 +2357,6 @@ static inline void sync_lapic_to_cr8(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 	u64 cr8;
 
-	if (!irqchip_in_kernel(vcpu->kvm))
-		return;
-
 	cr8 = kvm_get_cr8(vcpu);
 	svm->vmcb->control.int_ctl &= ~V_TPR_MASK;
 	svm->vmcb->control.int_ctl |= cr8 & V_TPR_MASK;
-- 
1.6.0.6

