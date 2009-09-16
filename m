Return-Path: <linux-kernel-owner+w=401wt.eu-S1758955AbZIPMpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758955AbZIPMpq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 08:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758945AbZIPMpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 08:45:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58766 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758930AbZIPMpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 08:45:38 -0400
From: Avi Kivity <avi@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] KVM: VMX: Move MSR_KERNEL_GS_BASE out of the vmx autoload msr area
Date: Wed, 16 Sep 2009 15:45:32 +0300
Message-Id: <1253105134-8862-3-git-send-email-avi@redhat.com>
In-Reply-To: <1253105134-8862-1-git-send-email-avi@redhat.com>
References: <1253105134-8862-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently MSR_KERNEL_GS_BASE is saved and restored as part of the
guest/host msr reloading.  Since we wish to lazy-restore all the other
msrs, save and reload MSR_KERNEL_GS_BASE explicitly instead of using
the common code.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/vmx.c |   34 +++++++++++++++++++++-------------
 1 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index d3213ac..547881a 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -80,7 +80,8 @@ struct vcpu_vmx {
 	int                   save_nmsrs;
 	int                   msr_offset_efer;
 #ifdef CONFIG_X86_64
-	int                   msr_offset_kernel_gs_base;
+	u64 		      msr_host_kernel_gs_base;
+	u64 		      msr_guest_kernel_gs_base;
 #endif
 	struct vmcs          *vmcs;
 	struct {
@@ -183,7 +184,7 @@ static void ept_save_pdptrs(struct kvm_vcpu *vcpu);
  */
 static const u32 vmx_msr_index[] = {
 #ifdef CONFIG_X86_64
-	MSR_SYSCALL_MASK, MSR_LSTAR, MSR_CSTAR, MSR_KERNEL_GS_BASE,
+	MSR_SYSCALL_MASK, MSR_LSTAR, MSR_CSTAR,
 #endif
 	MSR_EFER, MSR_K6_STAR,
 };
@@ -649,10 +650,10 @@ static void vmx_save_host_state(struct kvm_vcpu *vcpu)
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
@@ -686,6 +687,12 @@ static void __vmx_load_host_state(struct vcpu_vmx *vmx)
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
@@ -915,9 +922,6 @@ static void setup_msrs(struct vcpu_vmx *vmx)
 		index = __find_msr_index(vmx, MSR_CSTAR);
 		if (index >= 0)
 			move_msr_up(vmx, index, save_nmsrs++);
-		index = __find_msr_index(vmx, MSR_KERNEL_GS_BASE);
-		if (index >= 0)
-			move_msr_up(vmx, index, save_nmsrs++);
 		/*
 		 * MSR_K6_STAR is only needed on long mode guests, and only
 		 * if efer.sce is enabled.
@@ -929,10 +933,6 @@ static void setup_msrs(struct vcpu_vmx *vmx)
 #endif
 	vmx->save_nmsrs = save_nmsrs;
 
-#ifdef CONFIG_X86_64
-	vmx->msr_offset_kernel_gs_base =
-		__find_msr_index(vmx, MSR_KERNEL_GS_BASE);
-#endif
 	vmx->msr_offset_efer = __find_msr_index(vmx, MSR_EFER);
 
 	if (cpu_has_vmx_msr_bitmap()) {
@@ -990,6 +990,10 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *pdata)
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
@@ -1043,6 +1047,10 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
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
-- 
1.6.4.1

