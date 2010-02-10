Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887Ab0BJRXW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 12:23:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43442 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755323Ab0BJRXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 12:23:12 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 07/40] KVM: VMX: Make guest cr4 mask more conservative
Date: Wed, 10 Feb 2010 19:22:36 +0200
Message-Id: <1265822589-11155-8-git-send-email-avi@redhat.com>
In-Reply-To: <1265822589-11155-1-git-send-email-avi@redhat.com>
References: <1265822589-11155-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of specifying the bits which we want to trap on, specify the bits
which we allow the guest to change transparently.  This is safer wrt future
changes to cr4.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/vmx.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 284e905..755811a 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -69,8 +69,10 @@ module_param(emulate_invalid_guest_state, bool, S_IRUGO);
 	(X86_CR0_WP | X86_CR0_NE | X86_CR0_TS | X86_CR0_MP)
 #define KVM_VM_CR0_ALWAYS_ON						\
 	(KVM_VM_CR0_ALWAYS_ON_UNRESTRICTED_GUEST | X86_CR0_PG | X86_CR0_PE)
-#define KVM_GUEST_CR4_MASK						\
-	(X86_CR4_VME | X86_CR4_PSE | X86_CR4_PAE | X86_CR4_PGE | X86_CR4_VMXE)
+#define KVM_CR4_GUEST_OWNED_BITS				      \
+	(X86_CR4_PVI | X86_CR4_DE | X86_CR4_PCE | X86_CR4_OSFXSR      \
+	 | X86_CR4_OSXMMEXCPT)
+
 #define KVM_PMODE_VM_CR4_ALWAYS_ON (X86_CR4_PAE | X86_CR4_VMXE)
 #define KVM_RMODE_VM_CR4_ALWAYS_ON (X86_CR4_VME | X86_CR4_PAE | X86_CR4_VMXE)
 
@@ -2421,8 +2423,8 @@ static int vmx_vcpu_setup(struct vcpu_vmx *vmx)
 	vmcs_write32(VM_ENTRY_CONTROLS, vmcs_config.vmentry_ctrl);
 
 	vmcs_writel(CR0_GUEST_HOST_MASK, ~0UL);
-	vmcs_writel(CR4_GUEST_HOST_MASK, KVM_GUEST_CR4_MASK);
-	vmx->vcpu.arch.cr4_guest_owned_bits = ~KVM_GUEST_CR4_MASK;
+	vmx->vcpu.arch.cr4_guest_owned_bits = KVM_CR4_GUEST_OWNED_BITS;
+	vmcs_writel(CR4_GUEST_HOST_MASK, ~vmx->vcpu.arch.cr4_guest_owned_bits);
 
 	tsc_base = vmx->vcpu.kvm->arch.vm_init_tsc;
 	rdtscll(tsc_this);
-- 
1.6.5.3

