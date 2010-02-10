Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283Ab0BJRb7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 12:31:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39559 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755362Ab0BJRXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 12:23:13 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 09/40] KVM: VMX: Fold ept_update_paging_mode_cr4() into its caller
Date: Wed, 10 Feb 2010 19:22:38 +0200
Message-Id: <1265822589-11155-10-git-send-email-avi@redhat.com>
In-Reply-To: <1265822589-11155-1-git-send-email-avi@redhat.com>
References: <1265822589-11155-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ept_update_paging_mode_cr4() accesses vcpu->arch.cr4 directly, which usually
needs to be accessed via kvm_read_cr4().  In this case, we can't, since cr4
is in the process of being updated.  Instead of adding inane comments, fold
the function into its caller (vmx_set_cr4), so it can use the not-yet-committed
cr4 directly.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/vmx.c |   20 ++++++++------------
 1 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index a7ebaa5..694baed 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1680,16 +1680,6 @@ static void ept_update_paging_mode_cr0(unsigned long *hw_cr0,
 		*hw_cr0 &= ~X86_CR0_WP;
 }
 
-static void ept_update_paging_mode_cr4(unsigned long *hw_cr4,
-					struct kvm_vcpu *vcpu)
-{
-	if (!is_paging(vcpu)) {
-		*hw_cr4 &= ~X86_CR4_PAE;
-		*hw_cr4 |= X86_CR4_PSE;
-	} else if (!(vcpu->arch.cr4 & X86_CR4_PAE))
-		*hw_cr4 &= ~X86_CR4_PAE;
-}
-
 static void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -1767,8 +1757,14 @@ static void vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 		    KVM_RMODE_VM_CR4_ALWAYS_ON : KVM_PMODE_VM_CR4_ALWAYS_ON);
 
 	vcpu->arch.cr4 = cr4;
-	if (enable_ept)
-		ept_update_paging_mode_cr4(&hw_cr4, vcpu);
+	if (enable_ept) {
+		if (!is_paging(vcpu)) {
+			hw_cr4 &= ~X86_CR4_PAE;
+			hw_cr4 |= X86_CR4_PSE;
+		} else if (!(cr4 & X86_CR4_PAE)) {
+			hw_cr4 &= ~X86_CR4_PAE;
+		}
+	}
 
 	vmcs_writel(CR4_READ_SHADOW, cr4);
 	vmcs_writel(GUEST_CR4, hw_cr4);
-- 
1.6.5.3

