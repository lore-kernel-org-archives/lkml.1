Return-Path: <linux-kernel-owner+w=401wt.eu-S933735AbZHWMCL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933735AbZHWMCL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 08:02:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933569AbZHWMCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 08:02:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30543 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933543AbZHWL4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 07:56:50 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 24/46] KVM: Move exception handling to the same place as other events
Date: Sun, 23 Aug 2009 14:56:23 +0300
Message-Id: <1251028605-31977-25-git-send-email-avi@redhat.com>
In-Reply-To: <1251028605-31977-1-git-send-email-avi@redhat.com>
References: <1251028605-31977-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c |   21 +++++++++------------
 1 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a2f5a9c..d2e1ffb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -223,13 +223,6 @@ void kvm_queue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code)
 }
 EXPORT_SYMBOL_GPL(kvm_queue_exception_e);
 
-static void __queue_exception(struct kvm_vcpu *vcpu)
-{
-	kvm_x86_ops->queue_exception(vcpu, vcpu->arch.exception.nr,
-				     vcpu->arch.exception.has_error_code,
-				     vcpu->arch.exception.error_code);
-}
-
 /*
  * Load the pae pdptrs.  Return true is they are all valid.
  */
@@ -3487,9 +3480,16 @@ static void update_cr8_intercept(struct kvm_vcpu *vcpu)
 	kvm_x86_ops->update_cr8_intercept(vcpu, tpr, max_irr);
 }
 
-static void inject_pending_irq(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+static void inject_pending_event(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	/* try to reinject previous events if any */
+	if (vcpu->arch.exception.pending) {
+		kvm_x86_ops->queue_exception(vcpu, vcpu->arch.exception.nr,
+					  vcpu->arch.exception.has_error_code,
+					  vcpu->arch.exception.error_code);
+		return;
+	}
+
 	if (vcpu->arch.nmi_injected) {
 		kvm_x86_ops->set_nmi(vcpu);
 		return;
@@ -3570,10 +3570,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		goto out;
 	}
 
-	if (vcpu->arch.exception.pending)
-		__queue_exception(vcpu);
-	else
-		inject_pending_irq(vcpu, kvm_run);
+	inject_pending_event(vcpu, kvm_run);
 
 	/* enable NMI/IRQ window open exits if needed */
 	if (vcpu->arch.nmi_pending)
-- 
1.6.4.1

