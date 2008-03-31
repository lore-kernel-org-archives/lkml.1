Return-Path: <linux-kernel-owner+w=401wt.eu-S1758275AbYCaOmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758275AbYCaOmp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 10:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779AbYCaOhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 10:37:41 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:51311
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbYCaOhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 10:37:33 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 19/40] KVM: allow access to EFER in 32bit KVM
Date: Mon, 31 Mar 2008 17:37:03 +0300
Message-Id: <1206974244-9716-20-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1206974244-9716-1-git-send-email-avi@qumranet.com>
References: <1206974244-9716-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

This patch makes the EFER register accessible on a 32bit KVM host. This is
necessary to boot 32 bit PAE guests under SVM.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86.c |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index db16f23..38edb2f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -432,8 +432,6 @@ static u32 emulated_msrs[] = {
 	MSR_IA32_MISC_ENABLE,
 };
 
-#ifdef CONFIG_X86_64
-
 static void set_efer(struct kvm_vcpu *vcpu, u64 efer)
 {
 	if (efer & efer_reserved_bits) {
@@ -458,8 +456,6 @@ static void set_efer(struct kvm_vcpu *vcpu, u64 efer)
 	vcpu->arch.shadow_efer = efer;
 }
 
-#endif
-
 void kvm_enable_efer_bits(u64 mask)
 {
        efer_reserved_bits &= ~mask;
@@ -489,11 +485,9 @@ static int do_set_msr(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
 int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 {
 	switch (msr) {
-#ifdef CONFIG_X86_64
 	case MSR_EFER:
 		set_efer(vcpu, data);
 		break;
-#endif
 	case MSR_IA32_MC0_STATUS:
 		pr_unimpl(vcpu, "%s: MSR_IA32_MC0_STATUS 0x%llx, nop\n",
 		       __FUNCTION__, data);
@@ -571,11 +565,9 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 	case MSR_IA32_MISC_ENABLE:
 		data = vcpu->arch.ia32_misc_enable_msr;
 		break;
-#ifdef CONFIG_X86_64
 	case MSR_EFER:
 		data = vcpu->arch.shadow_efer;
 		break;
-#endif
 	default:
 		pr_unimpl(vcpu, "unhandled rdmsr: 0x%x\n", msr);
 		return 1;
@@ -2880,9 +2872,7 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 	set_cr8(vcpu, sregs->cr8);
 
 	mmu_reset_needed |= vcpu->arch.shadow_efer != sregs->efer;
-#ifdef CONFIG_X86_64
 	kvm_x86_ops->set_efer(vcpu, sregs->efer);
-#endif
 	kvm_set_apic_base(vcpu, sregs->apic_base);
 
 	kvm_x86_ops->decache_cr4_guest_bits(vcpu);
-- 
1.5.4.5

