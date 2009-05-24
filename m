Return-Path: <linux-kernel-owner+w=401wt.eu-S1758204AbZEXPwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758204AbZEXPwR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 11:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756809AbZEXPvB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 11:51:01 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41863 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755236AbZEXPuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 11:50:35 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 41/45] KVM: Always request IRQ/NMI window if an interrupt is pending
Date: Sun, 24 May 2009 18:50:26 +0300
Message-Id: <1243180230-2480-42-git-send-email-avi@redhat.com>
In-Reply-To: <1243180230-2480-1-git-send-email-avi@redhat.com>
References: <1243180230-2480-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

Currently they are not requested if there is pending exception.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c |   30 ++++++++++++------------------
 1 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e395ca4..efba9bc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3148,8 +3148,11 @@ static void update_cr8_intercept(struct kvm_vcpu *vcpu)
 	kvm_x86_ops->update_cr8_intercept(vcpu, tpr, max_irr);
 }
 
-static void inject_irq(struct kvm_vcpu *vcpu)
+static void inject_pending_irq(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
+	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)
+		kvm_x86_ops->set_interrupt_shadow(vcpu, 0);
+
 	/* try to reinject previous events if any */
 	if (vcpu->arch.nmi_injected) {
 		kvm_x86_ops->set_nmi(vcpu);
@@ -3177,26 +3180,11 @@ static void inject_irq(struct kvm_vcpu *vcpu)
 	}
 }
 
-static void inject_pending_irq(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
-{
-	bool req_int_win = !irqchip_in_kernel(vcpu->kvm) &&
-		kvm_run->request_interrupt_window;
-
-	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)
-		kvm_x86_ops->set_interrupt_shadow(vcpu, 0);
-
-	inject_irq(vcpu);
-
-	/* enable NMI/IRQ window open exits if needed */
-	if (vcpu->arch.nmi_pending)
-		kvm_x86_ops->enable_nmi_window(vcpu);
-	else if (kvm_cpu_has_interrupt(vcpu) || req_int_win)
-		kvm_x86_ops->enable_irq_window(vcpu);
-}
-
 static int vcpu_enter_guest(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	int r;
+	bool req_int_win = !irqchip_in_kernel(vcpu->kvm) &&
+		kvm_run->request_interrupt_window;
 
 	if (vcpu->requests)
 		if (test_and_clear_bit(KVM_REQ_MMU_RELOAD, &vcpu->requests))
@@ -3250,6 +3238,12 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	else
 		inject_pending_irq(vcpu, kvm_run);
 
+	/* enable NMI/IRQ window open exits if needed */
+	if (vcpu->arch.nmi_pending)
+		kvm_x86_ops->enable_nmi_window(vcpu);
+	else if (kvm_cpu_has_interrupt(vcpu) || req_int_win)
+		kvm_x86_ops->enable_irq_window(vcpu);
+
 	if (kvm_lapic_enabled(vcpu)) {
 		if (!vcpu->arch.apic->vapic_addr)
 			update_cr8_intercept(vcpu);
-- 
1.6.0.6

