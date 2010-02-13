Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805Ab0BMIFr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 03:05:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23788 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596Ab0BMICF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 03:02:05 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 26/39] KVM: SVM: Selective cr0 intercept
Date: Sat, 13 Feb 2010 10:01:46 +0200
Message-Id: <1266048119-14325-27-git-send-email-avi@redhat.com>
In-Reply-To: <1266048119-14325-1-git-send-email-avi@redhat.com>
References: <1266048119-14325-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If two conditions apply:
 - no bits outside TS and EM differ between the host and guest cr0
 - the fpu is active

then we can activate the selective cr0 write intercept and drop the
unconditional cr0 read and write intercept, and allow the guest to run
with the host fpu state.  This reduces cr0 exits due to guest fpu management
while the guest fpu is loaded.

Acked-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/svm.c |   32 ++++++++++++++++++++++++++------
 1 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 27273ed..83c7ab1 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -571,6 +571,7 @@ static void init_vmcb(struct vcpu_svm *svm)
 	control->intercept = 	(1ULL << INTERCEPT_INTR) |
 				(1ULL << INTERCEPT_NMI) |
 				(1ULL << INTERCEPT_SMI) |
+				(1ULL << INTERCEPT_SELECTIVE_CR0) |
 				(1ULL << INTERCEPT_CPUID) |
 				(1ULL << INTERCEPT_INVD) |
 				(1ULL << INTERCEPT_HLT) |
@@ -963,6 +964,27 @@ static void svm_decache_cr4_guest_bits(struct kvm_vcpu *vcpu)
 {
 }
 
+static void update_cr0_intercept(struct vcpu_svm *svm)
+{
+	ulong gcr0 = svm->vcpu.arch.cr0;
+	u64 *hcr0 = &svm->vmcb->save.cr0;
+
+	if (!svm->vcpu.fpu_active)
+		*hcr0 |= SVM_CR0_SELECTIVE_MASK;
+	else
+		*hcr0 = (*hcr0 & ~SVM_CR0_SELECTIVE_MASK)
+			| (gcr0 & SVM_CR0_SELECTIVE_MASK);
+
+
+	if (gcr0 == *hcr0 && svm->vcpu.fpu_active) {
+		svm->vmcb->control.intercept_cr_read &= ~INTERCEPT_CR0_MASK;
+		svm->vmcb->control.intercept_cr_write &= ~INTERCEPT_CR0_MASK;
+	} else {
+		svm->vmcb->control.intercept_cr_read |= INTERCEPT_CR0_MASK;
+		svm->vmcb->control.intercept_cr_write |= INTERCEPT_CR0_MASK;
+	}
+}
+
 static void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -994,6 +1016,7 @@ static void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	 */
 	cr0 &= ~(X86_CR0_CD | X86_CR0_NW);
 	svm->vmcb->save.cr0 = cr0;
+	update_cr0_intercept(svm);
 }
 
 static void svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
@@ -1239,11 +1262,8 @@ static int ud_interception(struct vcpu_svm *svm)
 static int nm_interception(struct vcpu_svm *svm)
 {
 	svm->vmcb->control.intercept_exceptions &= ~(1 << NM_VECTOR);
-	if (!kvm_read_cr0_bits(&svm->vcpu, X86_CR0_TS))
-		svm->vmcb->save.cr0 &= ~X86_CR0_TS;
-	else
-		svm->vmcb->save.cr0 |= X86_CR0_TS;
 	svm->vcpu.fpu_active = 1;
+	update_cr0_intercept(svm);
 
 	return 1;
 }
@@ -2296,7 +2316,7 @@ static int (*svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_READ_CR3]           		= emulate_on_interception,
 	[SVM_EXIT_READ_CR4]           		= emulate_on_interception,
 	[SVM_EXIT_READ_CR8]           		= emulate_on_interception,
-	/* for now: */
+	[SVM_EXIT_CR0_SEL_WRITE]		= emulate_on_interception,
 	[SVM_EXIT_WRITE_CR0]          		= emulate_on_interception,
 	[SVM_EXIT_WRITE_CR3]          		= emulate_on_interception,
 	[SVM_EXIT_WRITE_CR4]          		= emulate_on_interception,
@@ -2914,8 +2934,8 @@ static void svm_fpu_deactivate(struct kvm_vcpu *vcpu)
 		return;
 	}
 
+	update_cr0_intercept(svm);
 	svm->vmcb->control.intercept_exceptions |= 1 << NM_VECTOR;
-	svm->vmcb->save.cr0 |= X86_CR0_TS;
 }
 
 static struct kvm_x86_ops svm_x86_ops = {
-- 
1.6.5.3

