Return-Path: <linux-kernel-owner+w=401wt.eu-S1758903AbYCaOoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758903AbYCaOoX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 10:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753099AbYCaOho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 10:37:44 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:51321
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbYCaOhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 10:37:34 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 18/40] KVM: VMX: unifdef the EFER specific code
Date: Mon, 31 Mar 2008 17:37:02 +0300
Message-Id: <1206974244-9716-19-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1206974244-9716-1-git-send-email-avi@qumranet.com>
References: <1206974244-9716-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

To allow access to the EFER register in 32bit KVM the EFER specific code has to
be exported to the x86 generic code. This patch does this in a backwards
compatible manner.

[avi: add check for EFER-less hosts]

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/vmx.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index a509910..76944f2 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1335,14 +1335,14 @@ static void vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 	vcpu->arch.cr4 = cr4;
 }
 
-#ifdef CONFIG_X86_64
-
 static void vmx_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct kvm_msr_entry *msr = find_msr_entry(vmx, MSR_EFER);
 
 	vcpu->arch.shadow_efer = efer;
+	if (!msr)
+		return;
 	if (efer & EFER_LMA) {
 		vmcs_write32(VM_ENTRY_CONTROLS,
 				     vmcs_read32(VM_ENTRY_CONTROLS) |
@@ -1359,8 +1359,6 @@ static void vmx_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 	setup_msrs(vmx);
 }
 
-#endif
-
 static u64 vmx_get_segment_base(struct kvm_vcpu *vcpu, int seg)
 {
 	struct kvm_vmx_segment_field *sf = &kvm_vmx_segment_fields[seg];
@@ -1775,9 +1773,7 @@ static int vmx_vcpu_reset(struct kvm_vcpu *vcpu)
 	vmx->vcpu.arch.cr0 = 0x60000010;
 	vmx_set_cr0(&vmx->vcpu, vmx->vcpu.arch.cr0); /* enter rmode */
 	vmx_set_cr4(&vmx->vcpu, 0);
-#ifdef CONFIG_X86_64
 	vmx_set_efer(&vmx->vcpu, 0);
-#endif
 	vmx_fpu_activate(&vmx->vcpu);
 	update_exception_bitmap(&vmx->vcpu);
 
@@ -2668,9 +2664,7 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.set_cr0 = vmx_set_cr0,
 	.set_cr3 = vmx_set_cr3,
 	.set_cr4 = vmx_set_cr4,
-#ifdef CONFIG_X86_64
 	.set_efer = vmx_set_efer,
-#endif
 	.get_idt = vmx_get_idt,
 	.set_idt = vmx_set_idt,
 	.get_gdt = vmx_get_gdt,
-- 
1.5.4.5

