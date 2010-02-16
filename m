Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932967Ab0BPKlZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 05:41:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18228 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932802Ab0BPKfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 05:35:40 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 25/38] KVM: VMX: Pass cr0.mp through to the guest when the fpu is active
Date: Tue, 16 Feb 2010 12:35:23 +0200
Message-Id: <1266316536-28936-26-git-send-email-avi@redhat.com>
In-Reply-To: <1266316536-28936-1-git-send-email-avi@redhat.com>
References: <1266316536-28936-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When cr0.mp is clear, the guest doesn't expect a #NM in response to
a WAIT instruction.  Because we always keep cr0.mp set, it will get
a #NM, and potentially be confused.

Fix by keeping cr0.mp set only when the fpu is inactive, and passing
it through when inactive.

Reported-by: Lorenzo Martignoni <martignlo@gmail.com>
Analyzed-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/kvm/vmx.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index a680d93..7a56879 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -66,7 +66,7 @@ module_param(emulate_invalid_guest_state, bool, S_IRUGO);
 #define KVM_GUEST_CR0_MASK						\
 	(KVM_GUEST_CR0_MASK_UNRESTRICTED_GUEST | X86_CR0_PG | X86_CR0_PE)
 #define KVM_VM_CR0_ALWAYS_ON_UNRESTRICTED_GUEST				\
-	(X86_CR0_WP | X86_CR0_NE | X86_CR0_MP)
+	(X86_CR0_WP | X86_CR0_NE)
 #define KVM_VM_CR0_ALWAYS_ON						\
 	(KVM_VM_CR0_ALWAYS_ON_UNRESTRICTED_GUEST | X86_CR0_PG | X86_CR0_PE)
 #define KVM_CR4_GUEST_OWNED_BITS				      \
@@ -791,12 +791,15 @@ static void vmx_vcpu_put(struct kvm_vcpu *vcpu)
 
 static void vmx_fpu_activate(struct kvm_vcpu *vcpu)
 {
+	ulong cr0;
+
 	if (vcpu->fpu_active)
 		return;
 	vcpu->fpu_active = 1;
-	vmcs_clear_bits(GUEST_CR0, X86_CR0_TS);
-	if (kvm_read_cr0_bits(vcpu, X86_CR0_TS))
-		vmcs_set_bits(GUEST_CR0, X86_CR0_TS);
+	cr0 = vmcs_readl(GUEST_CR0);
+	cr0 &= ~(X86_CR0_TS | X86_CR0_MP);
+	cr0 |= kvm_read_cr0_bits(vcpu, X86_CR0_TS | X86_CR0_MP);
+	vmcs_writel(GUEST_CR0, cr0);
 	update_exception_bitmap(vcpu);
 	vcpu->arch.cr0_guest_owned_bits = X86_CR0_TS;
 	vmcs_writel(CR0_GUEST_HOST_MASK, ~vcpu->arch.cr0_guest_owned_bits);
@@ -807,7 +810,7 @@ static void vmx_decache_cr0_guest_bits(struct kvm_vcpu *vcpu);
 static void vmx_fpu_deactivate(struct kvm_vcpu *vcpu)
 {
 	vmx_decache_cr0_guest_bits(vcpu);
-	vmcs_set_bits(GUEST_CR0, X86_CR0_TS);
+	vmcs_set_bits(GUEST_CR0, X86_CR0_TS | X86_CR0_MP);
 	update_exception_bitmap(vcpu);
 	vcpu->arch.cr0_guest_owned_bits = 0;
 	vmcs_writel(CR0_GUEST_HOST_MASK, ~vcpu->arch.cr0_guest_owned_bits);
@@ -1757,7 +1760,7 @@ static void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 		ept_update_paging_mode_cr0(&hw_cr0, cr0, vcpu);
 
 	if (!vcpu->fpu_active)
-		hw_cr0 |= X86_CR0_TS;
+		hw_cr0 |= X86_CR0_TS | X86_CR0_MP;
 
 	vmcs_writel(CR0_READ_SHADOW, cr0);
 	vmcs_writel(GUEST_CR0, hw_cr0);
-- 
1.6.5.3

