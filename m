Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357Ab0BMIHn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 03:07:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39303 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752487Ab0BMICE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 03:02:04 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 21/39] KVM: VMX: Give the guest ownership of cr0.ts when the fpu is active
Date: Sat, 13 Feb 2010 10:01:41 +0200
Message-Id: <1266048119-14325-22-git-send-email-avi@redhat.com>
In-Reply-To: <1266048119-14325-1-git-send-email-avi@redhat.com>
References: <1266048119-14325-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the guest fpu is loaded, there is nothing interesing about cr0.ts; let
the guest play with it as it will.  This makes context switches between fpu
intensive guest processes faster, as we won't trap the clts and cr0 write
instructions.

[marcelo: fix cr0 read shadow update on fpu deactivation; kills F8 install]

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/kvm/vmx.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index d11be3f..fc1964d 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -803,12 +803,20 @@ static void vmx_fpu_activate(struct kvm_vcpu *vcpu)
 	if (kvm_read_cr0_bits(vcpu, X86_CR0_TS))
 		vmcs_set_bits(GUEST_CR0, X86_CR0_TS);
 	update_exception_bitmap(vcpu);
+	vcpu->arch.cr0_guest_owned_bits = X86_CR0_TS;
+	vmcs_writel(CR0_GUEST_HOST_MASK, ~vcpu->arch.cr0_guest_owned_bits);
 }
 
+static void vmx_decache_cr0_guest_bits(struct kvm_vcpu *vcpu);
+
 static void vmx_fpu_deactivate(struct kvm_vcpu *vcpu)
 {
+	vmx_decache_cr0_guest_bits(vcpu);
 	vmcs_set_bits(GUEST_CR0, X86_CR0_TS);
 	update_exception_bitmap(vcpu);
+	vcpu->arch.cr0_guest_owned_bits = 0;
+	vmcs_writel(CR0_GUEST_HOST_MASK, ~vcpu->arch.cr0_guest_owned_bits);
+	vmcs_writel(CR0_READ_SHADOW, vcpu->arch.cr0);
 }
 
 static unsigned long vmx_get_rflags(struct kvm_vcpu *vcpu)
@@ -2996,8 +3004,7 @@ static int handle_cr(struct kvm_vcpu *vcpu)
 		};
 		break;
 	case 2: /* clts */
-		vcpu->arch.cr0 &= ~X86_CR0_TS;
-		vmcs_writel(CR0_READ_SHADOW, kvm_read_cr0(vcpu));
+		vmx_set_cr0(vcpu, kvm_read_cr0_bits(vcpu, ~X86_CR0_TS));
 		trace_kvm_cr_write(0, kvm_read_cr0(vcpu));
 		skip_emulated_instruction(vcpu);
 		return 1;
-- 
1.6.5.3

