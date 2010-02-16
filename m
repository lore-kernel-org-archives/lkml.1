Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932962Ab0BPKkZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 05:40:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47431 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932807Ab0BPKfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 05:35:40 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 19/38] KVM: Optimize kvm_read_cr[04]_bits()
Date: Tue, 16 Feb 2010 12:35:17 +0200
Message-Id: <1266316536-28936-20-git-send-email-avi@redhat.com>
In-Reply-To: <1266316536-28936-1-git-send-email-avi@redhat.com>
References: <1266316536-28936-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'mask' is always a constant, so we can check whether it includes a bit that
might be owned by the guest very cheaply, and avoid the decache call.  Saves
a few hundred bytes of module text.

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/kvm/kvm_cache_regs.h |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index 6b419a3..cff851c 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -1,6 +1,11 @@
 #ifndef ASM_KVM_CACHE_REGS_H
 #define ASM_KVM_CACHE_REGS_H
 
+#define KVM_POSSIBLE_CR0_GUEST_BITS X86_CR0_TS
+#define KVM_POSSIBLE_CR4_GUEST_BITS				  \
+	(X86_CR4_PVI | X86_CR4_DE | X86_CR4_PCE | X86_CR4_OSFXSR  \
+	 | X86_CR4_OSXMMEXCPT | X86_CR4_PGE)
+
 static inline unsigned long kvm_register_read(struct kvm_vcpu *vcpu,
 					      enum kvm_reg reg)
 {
@@ -40,7 +45,8 @@ static inline u64 kvm_pdptr_read(struct kvm_vcpu *vcpu, int index)
 
 static inline ulong kvm_read_cr0_bits(struct kvm_vcpu *vcpu, ulong mask)
 {
-	if (mask & vcpu->arch.cr0_guest_owned_bits)
+	ulong tmask = mask & KVM_POSSIBLE_CR0_GUEST_BITS;
+	if (tmask & vcpu->arch.cr0_guest_owned_bits)
 		kvm_x86_ops->decache_cr0_guest_bits(vcpu);
 	return vcpu->arch.cr0 & mask;
 }
@@ -52,7 +58,8 @@ static inline ulong kvm_read_cr0(struct kvm_vcpu *vcpu)
 
 static inline ulong kvm_read_cr4_bits(struct kvm_vcpu *vcpu, ulong mask)
 {
-	if (mask & vcpu->arch.cr4_guest_owned_bits)
+	ulong tmask = mask & KVM_POSSIBLE_CR4_GUEST_BITS;
+	if (tmask & vcpu->arch.cr4_guest_owned_bits)
 		kvm_x86_ops->decache_cr4_guest_bits(vcpu);
 	return vcpu->arch.cr4 & mask;
 }
-- 
1.6.5.3

