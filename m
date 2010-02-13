Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757037Ab0BMIFx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 03:05:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38489 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752541Ab0BMICF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 03:02:05 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 25/39] KVM: SVM: Restore unconditional cr0 intercept under npt
Date: Sat, 13 Feb 2010 10:01:45 +0200
Message-Id: <1266048119-14325-26-git-send-email-avi@redhat.com>
In-Reply-To: <1266048119-14325-1-git-send-email-avi@redhat.com>
References: <1266048119-14325-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we don't intercept cr0 at all when npt is enabled.  This improves
performance but requires us to activate the fpu at all times.

Remove this behaviour in preparation for adding selective cr0 intercepts.

Acked-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/svm.c |   29 +++++++----------------------
 1 files changed, 7 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 949990e..27273ed 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -643,10 +643,8 @@ static void init_vmcb(struct vcpu_svm *svm)
 		control->intercept &= ~((1ULL << INTERCEPT_TASK_SWITCH) |
 					(1ULL << INTERCEPT_INVLPG));
 		control->intercept_exceptions &= ~(1 << PF_VECTOR);
-		control->intercept_cr_read &= ~(INTERCEPT_CR0_MASK|
-						INTERCEPT_CR3_MASK);
-		control->intercept_cr_write &= ~(INTERCEPT_CR0_MASK|
-						 INTERCEPT_CR3_MASK);
+		control->intercept_cr_read &= ~INTERCEPT_CR3_MASK;
+		control->intercept_cr_write &= ~INTERCEPT_CR3_MASK;
 		save->g_pat = 0x0007040600070406ULL;
 		save->cr3 = 0;
 		save->cr4 = 0;
@@ -982,15 +980,13 @@ static void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 		}
 	}
 #endif
-	if (npt_enabled)
-		goto set;
-
 	vcpu->arch.cr0 = cr0;
-	cr0 |= X86_CR0_PG | X86_CR0_WP;
+
+	if (!npt_enabled)
+		cr0 |= X86_CR0_PG | X86_CR0_WP;
 
 	if (!vcpu->fpu_active)
 		cr0 |= X86_CR0_TS;
-set:
 	/*
 	 * re-enable caching here because the QEMU bios
 	 * does not do it - this results in some delay at
@@ -2386,21 +2382,10 @@ static int handle_exit(struct kvm_vcpu *vcpu)
 
 	svm_complete_interrupts(svm);
 
-	if (npt_enabled) {
-		int mmu_reload = 0;
-		if ((kvm_read_cr0_bits(vcpu, X86_CR0_PG) ^ svm->vmcb->save.cr0)
-		    & X86_CR0_PG) {
-			svm_set_cr0(vcpu, svm->vmcb->save.cr0);
-			mmu_reload = 1;
-		}
+	if (!(svm->vmcb->control.intercept_cr_write & INTERCEPT_CR0_MASK))
 		vcpu->arch.cr0 = svm->vmcb->save.cr0;
+	if (npt_enabled)
 		vcpu->arch.cr3 = svm->vmcb->save.cr3;
-		if (mmu_reload) {
-			kvm_mmu_reset_context(vcpu);
-			kvm_mmu_load(vcpu);
-		}
-	}
-
 
 	if (svm->vmcb->control.exit_code == SVM_EXIT_ERR) {
 		kvm_run->exit_reason = KVM_EXIT_FAIL_ENTRY;
-- 
1.6.5.3

