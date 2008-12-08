Return-Path: <linux-kernel-owner+w=401wt.eu-S1754309AbYLHLso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309AbYLHLso (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 06:48:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753833AbYLHLi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 06:38:28 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48250 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290AbYLHLhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 06:37:04 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sheng Yang <sheng@linux.intel.com>
Subject: [PATCH 19/45] KVM: VMX: Add PAT support for EPT
Date: Mon,  8 Dec 2008 13:36:30 +0200
Message-Id: <1228736216-15787-20-git-send-email-avi@redhat.com>
In-Reply-To: <1228736216-15787-1-git-send-email-avi@redhat.com>
References: <1228736216-15787-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng@linux.intel.com>

GUEST_PAT support is a new feature introduced by Intel Core i7 architecture.
With this, cpu would save/load guest and host PAT automatically, for EPT memory
type in guest depends on MSR_IA32_CR_PAT.

Also add save/restore for MSR_IA32_CR_PAT.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/vmx.c |   29 ++++++++++++++++++++++++++---
 arch/x86/kvm/vmx.h |    7 +++++++
 arch/x86/kvm/x86.c |    2 +-
 3 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 2180109..b4c95a5 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -962,6 +962,13 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
 		pr_unimpl(vcpu, "unimplemented perfctr wrmsr: 0x%x data 0x%llx\n", msr_index, data);
 
 		break;
+	case MSR_IA32_CR_PAT:
+		if (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_PAT) {
+			vmcs_write64(GUEST_IA32_PAT, data);
+			vcpu->arch.pat = data;
+			break;
+		}
+		/* Otherwise falls through to kvm_set_msr_common */
 	default:
 		vmx_load_host_state(vmx);
 		msr = find_msr_entry(vmx, msr_index);
@@ -1181,12 +1188,13 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf)
 #ifdef CONFIG_X86_64
 	min |= VM_EXIT_HOST_ADDR_SPACE_SIZE;
 #endif
-	opt = 0;
+	opt = VM_EXIT_SAVE_IA32_PAT | VM_EXIT_LOAD_IA32_PAT;
 	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_EXIT_CTLS,
 				&_vmexit_control) < 0)
 		return -EIO;
 
-	min = opt = 0;
+	min = 0;
+	opt = VM_ENTRY_LOAD_IA32_PAT;
 	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_ENTRY_CTLS,
 				&_vmentry_control) < 0)
 		return -EIO;
@@ -2092,8 +2100,9 @@ static void vmx_disable_intercept_for_msr(struct page *msr_bitmap, u32 msr)
  */
 static int vmx_vcpu_setup(struct vcpu_vmx *vmx)
 {
-	u32 host_sysenter_cs;
+	u32 host_sysenter_cs, msr_low, msr_high;
 	u32 junk;
+	u64 host_pat;
 	unsigned long a;
 	struct descriptor_table dt;
 	int i;
@@ -2181,6 +2190,20 @@ static int vmx_vcpu_setup(struct vcpu_vmx *vmx)
 	rdmsrl(MSR_IA32_SYSENTER_EIP, a);
 	vmcs_writel(HOST_IA32_SYSENTER_EIP, a);   /* 22.2.3 */
 
+	if (vmcs_config.vmexit_ctrl & VM_EXIT_LOAD_IA32_PAT) {
+		rdmsr(MSR_IA32_CR_PAT, msr_low, msr_high);
+		host_pat = msr_low | ((u64) msr_high << 32);
+		vmcs_write64(HOST_IA32_PAT, host_pat);
+	}
+	if (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_PAT) {
+		rdmsr(MSR_IA32_CR_PAT, msr_low, msr_high);
+		host_pat = msr_low | ((u64) msr_high << 32);
+		/* Write the default value follow host pat */
+		vmcs_write64(GUEST_IA32_PAT, host_pat);
+		/* Keep arch.pat sync with GUEST_IA32_PAT */
+		vmx->vcpu.arch.pat = host_pat;
+	}
+
 	for (i = 0; i < NR_VMX_MSR; ++i) {
 		u32 index = vmx_msr_index[i];
 		u32 data_low, data_high;
diff --git a/arch/x86/kvm/vmx.h b/arch/x86/kvm/vmx.h
index ec5edc3..18598af 100644
--- a/arch/x86/kvm/vmx.h
+++ b/arch/x86/kvm/vmx.h
@@ -63,10 +63,13 @@
 
 #define VM_EXIT_HOST_ADDR_SPACE_SIZE            0x00000200
 #define VM_EXIT_ACK_INTR_ON_EXIT                0x00008000
+#define VM_EXIT_SAVE_IA32_PAT			0x00040000
+#define VM_EXIT_LOAD_IA32_PAT			0x00080000
 
 #define VM_ENTRY_IA32E_MODE                     0x00000200
 #define VM_ENTRY_SMM                            0x00000400
 #define VM_ENTRY_DEACT_DUAL_MONITOR             0x00000800
+#define VM_ENTRY_LOAD_IA32_PAT			0x00004000
 
 /* VMCS Encodings */
 enum vmcs_field {
@@ -112,6 +115,8 @@ enum vmcs_field {
 	VMCS_LINK_POINTER_HIGH          = 0x00002801,
 	GUEST_IA32_DEBUGCTL             = 0x00002802,
 	GUEST_IA32_DEBUGCTL_HIGH        = 0x00002803,
+	GUEST_IA32_PAT			= 0x00002804,
+	GUEST_IA32_PAT_HIGH		= 0x00002805,
 	GUEST_PDPTR0                    = 0x0000280a,
 	GUEST_PDPTR0_HIGH               = 0x0000280b,
 	GUEST_PDPTR1                    = 0x0000280c,
@@ -120,6 +125,8 @@ enum vmcs_field {
 	GUEST_PDPTR2_HIGH               = 0x0000280f,
 	GUEST_PDPTR3                    = 0x00002810,
 	GUEST_PDPTR3_HIGH               = 0x00002811,
+	HOST_IA32_PAT			= 0x00002c00,
+	HOST_IA32_PAT_HIGH		= 0x00002c01,
 	PIN_BASED_VM_EXEC_CONTROL       = 0x00004000,
 	CPU_BASED_VM_EXEC_CONTROL       = 0x00004002,
 	EXCEPTION_BITMAP                = 0x00004004,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f5b2334..0edf753 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -452,7 +452,7 @@ static u32 msrs_to_save[] = {
 	MSR_CSTAR, MSR_KERNEL_GS_BASE, MSR_SYSCALL_MASK, MSR_LSTAR,
 #endif
 	MSR_IA32_TIME_STAMP_COUNTER, MSR_KVM_SYSTEM_TIME, MSR_KVM_WALL_CLOCK,
-	MSR_IA32_PERF_STATUS,
+	MSR_IA32_PERF_STATUS, MSR_IA32_CR_PAT
 };
 
 static unsigned num_msrs_to_save;
-- 
1.6.0.3

