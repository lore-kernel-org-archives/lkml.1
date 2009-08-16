Return-Path: <linux-kernel-owner+w=401wt.eu-S1755312AbZHPJiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312AbZHPJiz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 05:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755261AbZHPJit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 05:38:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45339 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753969AbZHPJaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 05:30:11 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 09/48] KVM: Drop interrupt shadow when single stepping should be done only on VMX
Date: Sun, 16 Aug 2009 12:29:29 +0300
Message-Id: <1250415008-17175-10-git-send-email-avi@redhat.com>
In-Reply-To: <1250415008-17175-1-git-send-email-avi@redhat.com>
References: <1250415008-17175-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

The problem exists only on VMX. Also currently we skip this step if
there is pending exception. The patch fixes this too.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/vmx.c |    8 ++++++++
 arch/x86/kvm/x86.c |    3 ---
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index c87c93f..c14bffc 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3453,6 +3453,14 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	if (test_bit(VCPU_REGS_RIP, (unsigned long *)&vcpu->arch.regs_dirty))
 		vmcs_writel(GUEST_RIP, vcpu->arch.regs[VCPU_REGS_RIP]);
 
+	/* When single-stepping over STI and MOV SS, we must clear the
+	 * corresponding interruptibility bits in the guest state. Otherwise
+	 * vmentry fails as it then expects bit 14 (BS) in pending debug
+	 * exceptions being set, but that's not correct for the guest debugging
+	 * case. */
+	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)
+		vmx_set_interrupt_shadow(vcpu, 0);
+
 	/*
 	 * Loading guest fpu may have cleared host cr0.ts
 	 */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 25a1c57..f064239 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3361,9 +3361,6 @@ static void update_cr8_intercept(struct kvm_vcpu *vcpu)
 
 static void inject_pending_irq(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
-	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)
-		kvm_x86_ops->set_interrupt_shadow(vcpu, 0);
-
 	/* try to reinject previous events if any */
 	if (vcpu->arch.nmi_injected) {
 		kvm_x86_ops->set_nmi(vcpu);
-- 
1.6.3.3

