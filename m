Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127Ab0BMIEa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 03:04:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31861 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752684Ab0BMICF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 03:02:05 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 34/39] KVM: PPC: Move Shadow MSR calculation to function
Date: Sat, 13 Feb 2010 10:01:54 +0200
Message-Id: <1266048119-14325-35-git-send-email-avi@redhat.com>
In-Reply-To: <1266048119-14325-1-git-send-email-avi@redhat.com>
References: <1266048119-14325-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Graf <agraf@suse.de>

We keep a copy of the MSR around that we use when we go into the guest context.

That copy is basically the normal process MSR flags OR some allowed guest
specified MSR flags. We also AND the external providers into this, so we get
traps on FPU usage when we haven't activated it on the host yet.

Currently this calculation is part of the set_msr function that we use whenever
we set the guest MSR value. With the external providers, we also have the case
that we don't modify the guest's MSR, but only want to update the shadow MSR.

So let's move the shadow MSR parts to a separate function that we then use
whenever we only need to update it. That way we don't accidently kvm_vcpu_block
within a preempt notifier context.

Signed-off-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/kvm/book3s.c |   27 +++++++++++++++++++++------
 1 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index 58f5200..9a271f0 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -94,6 +94,23 @@ static u32 kvmppc_get_dec(struct kvm_vcpu *vcpu)
 }
 #endif
 
+static void kvmppc_recalc_shadow_msr(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.shadow_msr = vcpu->arch.msr;
+	/* Guest MSR values */
+	vcpu->arch.shadow_msr &= MSR_FE0 | MSR_FE1 | MSR_SF | MSR_SE |
+				 MSR_BE | MSR_DE;
+	/* Process MSR values */
+	vcpu->arch.shadow_msr |= MSR_ME | MSR_RI | MSR_IR | MSR_DR | MSR_PR |
+				 MSR_EE;
+	/* External providers the guest reserved */
+	vcpu->arch.shadow_msr |= (vcpu->arch.msr & vcpu->arch.guest_owned_ext);
+	/* 64-bit Process MSR values */
+#ifdef CONFIG_PPC_BOOK3S_64
+	vcpu->arch.shadow_msr |= MSR_ISF | MSR_HV;
+#endif
+}
+
 void kvmppc_set_msr(struct kvm_vcpu *vcpu, u64 msr)
 {
 	ulong old_msr = vcpu->arch.msr;
@@ -101,12 +118,10 @@ void kvmppc_set_msr(struct kvm_vcpu *vcpu, u64 msr)
 #ifdef EXIT_DEBUG
 	printk(KERN_INFO "KVM: Set MSR to 0x%llx\n", msr);
 #endif
+
 	msr &= to_book3s(vcpu)->msr_mask;
 	vcpu->arch.msr = msr;
-	vcpu->arch.shadow_msr = msr | MSR_USER32;
-	vcpu->arch.shadow_msr &= (MSR_FE0 | MSR_USER64 | MSR_SE | MSR_BE |
-				  MSR_DE | MSR_FE1);
-	vcpu->arch.shadow_msr |= (msr & vcpu->arch.guest_owned_ext);
+	kvmppc_recalc_shadow_msr(vcpu);
 
 	if (msr & (MSR_WE|MSR_POW)) {
 		if (!vcpu->arch.pending_exceptions) {
@@ -610,7 +625,7 @@ static void kvmppc_giveup_ext(struct kvm_vcpu *vcpu, ulong msr)
 
 	vcpu->arch.guest_owned_ext &= ~msr;
 	current->thread.regs->msr &= ~msr;
-	kvmppc_set_msr(vcpu, vcpu->arch.msr);
+	kvmppc_recalc_shadow_msr(vcpu);
 }
 
 /* Handle external providers (FPU, Altivec, VSX) */
@@ -664,7 +679,7 @@ static int kvmppc_handle_ext(struct kvm_vcpu *vcpu, unsigned int exit_nr,
 
 	vcpu->arch.guest_owned_ext |= msr;
 
-	kvmppc_set_msr(vcpu, vcpu->arch.msr);
+	kvmppc_recalc_shadow_msr(vcpu);
 
 	return RESUME_GUEST;
 }
-- 
1.6.5.3

