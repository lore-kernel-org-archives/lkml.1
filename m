Return-Path: <linux-kernel-owner+w=401wt.eu-S1756383AbZKSNjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756383AbZKSNjv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 08:39:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753572AbZKSNjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 08:39:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47821 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753570AbZKSNfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 08:35:08 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 20/35] KVM: VMX: Move MSR_KERNEL_GS_BASE out of the vmx autoload msr area
Date: Thu, 19 Nov 2009 15:34:56 +0200
Message-Id: <1258637711-11674-21-git-send-email-avi@redhat.com>
In-Reply-To: <1258637711-11674-1-git-send-email-avi@redhat.com>
References: <1258637711-11674-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently MSR_KERNEL_GS_BASE is saved and restored as part of the
guest/host msr reloading.  Since we wish to lazy-restore all the other
msrs, save and reload MSR_KERNEL_GS_BASE explicitly instead of using
the common code.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/vmx.c |   39 ++++++++++++++++++++++++++-------------
 1 files changed, 26 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 1773017..3251251 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -99,7 +99,8 @@ struct vcpu_vmx {
 	int                   save_nmsrs;
 	int                   msr_offset_efer;
 #ifdef CONFIG_X86_64
-	int                   msr_offset_kernel_gs_base;
+	u64 		      msr_host_kernel_gs_base;
+	u64 		      msr_guest_kernel_gs_base;
 #endif
 	struct vmcs          *vmcs;
 	struct {
@@ -202,7 +203,7 @@ static void ept_save_pdptrs(struct kvm_vcpu *vcpu);
  */
 static const u32 vmx_msr_index[] = {
 #ifdef CONFIG_X86_64
-	MSR_SYSCALL_MASK, MSR_LSTAR, MSR_CSTAR, MSR_KERNEL_GS_BASE,
+	MSR_SYSCALL_MASK, MSR_LSTAR, MSR_CSTAR,
 #endif
 	MSR_EFER, MSR_K6_STAR,
 };
@@ -674,10 +675,10 @@ static void vmx_save_host_state(struct kvm_vcpu *vcpu)
 #endif
 
 #ifdef CONFIG_X86_64
-	if (is_long_mode(&vmx->vcpu))
-		save_msrs(vmx->host_msrs +
-			  vmx->msr_offset_kernel_gs_base, 1);
-
+	if (is_long_mode(&vmx->vcpu)) {
+		rdmsrl(MSR_KERNEL_GS_BASE, vmx->msr_host_kernel_gs_base);
+		wrmsrl(MSR_KERNEL_GS_BASE, vmx->msr_guest_kernel_gs_base);
+	}
 #endif
 	load_msrs(vmx->guest_msrs, vmx->save_nmsrs);
 	load_transition_efer(vmx);
@@ -711,6 +712,12 @@ static void __vmx_load_host_state(struct vcpu_vmx *vmx)
 	save_msrs(vmx->guest_msrs, vmx->save_nmsrs);
 	load_msrs(vmx->host_msrs, vmx->save_nmsrs);
 	reload_host_efer(vmx);
+#ifdef CONFIG_X86_64
+	if (is_long_mode(&vmx->vcpu)) {
+		rdmsrl(MSR_KERNEL_GS_BASE, vmx->msr_guest_kernel_gs_base);
+		wrmsrl(MSR_KERNEL_GS_BASE, vmx->msr_host_kernel_gs_base);
+	}
+#endif
 }
 
 static void vmx_load_host_state(struct vcpu_vmx *vmx)
@@ -940,9 +947,6 @@ static void setup_msrs(struct vcpu_vmx *vmx)
 		index = __find_msr_index(vmx, MSR_CSTAR);
 		if (index >= 0)
 			move_msr_up(vmx, index, save_nmsrs++);
-		index = __find_msr_index(vmx, MSR_KERNEL_GS_BASE);
-		if (index >= 0)
-			move_msr_up(vmx, index, save_nmsrs++);
 		/*
 		 * MSR_K6_STAR is only needed on long mode guests, and only
 		 * if efer.sce is enabled.
@@ -954,10 +958,6 @@ static void setup_msrs(struct vcpu_vmx *vmx)
 #endif
 	vmx->save_nmsrs = save_nmsrs;
 
-#ifdef CONFIG_X86_64
-	vmx->msr_offset_kernel_gs_base =
-		__find_msr_index(vmx, MSR_KERNEL_GS_BASE);
-#endif
 	vmx->msr_offset_efer = __find_msr_index(vmx, MSR_EFER);
 
 	if (cpu_has_vmx_msr_bitmap()) {
@@ -1015,6 +1015,10 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *pdata)
 	case MSR_GS_BASE:
 		data = vmcs_readl(GUEST_GS_BASE);
 		break;
+	case MSR_KERNEL_GS_BASE:
+		vmx_load_host_state(to_vmx(vcpu));
+		data = to_vmx(vcpu)->msr_guest_kernel_gs_base;
+		break;
 	case MSR_EFER:
 		return kvm_get_msr_common(vcpu, msr_index, pdata);
 #endif
@@ -1068,6 +1072,10 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
 	case MSR_GS_BASE:
 		vmcs_writel(GUEST_GS_BASE, data);
 		break;
+	case MSR_KERNEL_GS_BASE:
+		vmx_load_host_state(vmx);
+		vmx->msr_guest_kernel_gs_base = data;
+		break;
 #endif
 	case MSR_IA32_SYSENTER_CS:
 		vmcs_write32(GUEST_SYSENTER_CS, data);
@@ -1559,6 +1567,11 @@ static void vmx_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct kvm_msr_entry *msr = find_msr_entry(vmx, MSR_EFER);
 
+	/*
+	 * Force kernel_gs_base reloading before EFER changes, as control
+	 * of this msr depends on is_long_mode().
+	 */
+	vmx_load_host_state(to_vmx(vcpu));
 	vcpu->arch.shadow_efer = efer;
 	if (!msr)
 		return;
-- 
1.6.5.2

