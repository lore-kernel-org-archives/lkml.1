Return-Path: <linux-kernel-owner+w=401wt.eu-S1760116AbXIQJF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760116AbXIQJF4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 05:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755055AbXIQIeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:34:08 -0400
Received: from il.qumranet.com ([82.166.9.18]:45251 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753415AbXIQIc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:26 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, "Yang, Sheng" <sheng.yang@intel.com>
Subject: [PATCH 026/104] KVM: VMX: Improve the method of writing vmcs control
Date: Mon, 17 Sep 2007 10:31:08 +0200
Message-Id: <11900179471701-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yang, Sheng <sheng.yang@intel.com>

Put cpu feature detecting part in hardware_setup, and stored the vmcs
condition in global variable for further check.

[glommer: fix for some i386-only machines not supporting CR8 load/store
 exiting]

Signed-off-by: Sheng Yang <sheng.yang@intel.com>
Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/vmx.c |  147 ++++++++++++++++++++++++++++++++++++----------------
 1 files changed, 102 insertions(+), 45 deletions(-)

diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index df57878..18f9b0b 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -71,18 +71,17 @@ static DEFINE_PER_CPU(struct vmcs *, current_vmcs);
 static struct page *vmx_io_bitmap_a;
 static struct page *vmx_io_bitmap_b;
 
-#ifdef CONFIG_X86_64
-#define HOST_IS_64 1
-#else
-#define HOST_IS_64 0
-#endif
 #define EFER_SAVE_RESTORE_BITS ((u64)EFER_SCE)
 
-static struct vmcs_descriptor {
+static struct vmcs_config {
 	int size;
 	int order;
 	u32 revision_id;
-} vmcs_descriptor;
+	u32 pin_based_exec_ctrl;
+	u32 cpu_based_exec_ctrl;
+	u32 vmexit_ctrl;
+	u32 vmentry_ctrl;
+} vmcs_config;
 
 #define VMX_SEGMENT_FIELD(seg)					\
 	[VCPU_SREG_##seg] = {                                   \
@@ -839,14 +838,93 @@ static void hardware_disable(void *garbage)
 	asm volatile (ASM_VMX_VMXOFF : : : "cc");
 }
 
-static __init void setup_vmcs_descriptor(void)
+static __init int adjust_vmx_controls(u32 ctl_min, u32 ctl_opt,
+				      u32 msr, u32* result)
+{
+	u32 vmx_msr_low, vmx_msr_high;
+	u32 ctl = ctl_min | ctl_opt;
+
+	rdmsr(msr, vmx_msr_low, vmx_msr_high);
+
+	ctl &= vmx_msr_high; /* bit == 0 in high word ==> must be zero */
+	ctl |= vmx_msr_low;  /* bit == 1 in low word  ==> must be one  */
+
+	/* Ensure minimum (required) set of control bits are supported. */
+	if (ctl_min & ~ctl)
+		return -1;
+
+	*result = ctl;
+	return 0;
+}
+
+static __init int setup_vmcs_config(void)
 {
 	u32 vmx_msr_low, vmx_msr_high;
+	u32 min, opt;
+	u32 _pin_based_exec_control = 0;
+	u32 _cpu_based_exec_control = 0;
+	u32 _vmexit_control = 0;
+	u32 _vmentry_control = 0;
+
+	min = PIN_BASED_EXT_INTR_MASK | PIN_BASED_NMI_EXITING;
+	opt = 0;
+	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_PINBASED_CTLS,
+				&_pin_based_exec_control) < 0)
+		return -1;
+
+	min = CPU_BASED_HLT_EXITING |
+#ifdef CONFIG_X86_64
+	      CPU_BASED_CR8_LOAD_EXITING |
+	      CPU_BASED_CR8_STORE_EXITING |
+#endif
+	      CPU_BASED_USE_IO_BITMAPS |
+	      CPU_BASED_MOV_DR_EXITING |
+	      CPU_BASED_USE_TSC_OFFSETING;
+	opt = 0;
+	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_PROCBASED_CTLS,
+				&_cpu_based_exec_control) < 0)
+		return -1;
+
+	min = 0;
+#ifdef CONFIG_X86_64
+	min |= VM_EXIT_HOST_ADDR_SPACE_SIZE;
+#endif
+	opt = 0;
+	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_EXIT_CTLS,
+				&_vmexit_control) < 0)
+		return -1;
+
+	min = opt = 0;
+	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_ENTRY_CTLS,
+				&_vmentry_control) < 0)
+		return -1;
 
 	rdmsr(MSR_IA32_VMX_BASIC, vmx_msr_low, vmx_msr_high);
-	vmcs_descriptor.size = vmx_msr_high & 0x1fff;
-	vmcs_descriptor.order = get_order(vmcs_descriptor.size);
-	vmcs_descriptor.revision_id = vmx_msr_low;
+
+	/* IA-32 SDM Vol 3B: VMCS size is never greater than 4kB. */
+	if ((vmx_msr_high & 0x1fff) > PAGE_SIZE)
+		return -1;
+
+#ifdef CONFIG_X86_64
+	/* IA-32 SDM Vol 3B: 64-bit CPUs always have VMX_BASIC_MSR[48]==0. */
+	if (vmx_msr_high & (1u<<16))
+		return -1;
+#endif
+
+	/* Require Write-Back (WB) memory type for VMCS accesses. */
+	if (((vmx_msr_high >> 18) & 15) != 6)
+		return -1;
+
+	vmcs_config.size = vmx_msr_high & 0x1fff;
+	vmcs_config.order = get_order(vmcs_config.size);
+	vmcs_config.revision_id = vmx_msr_low;
+
+	vmcs_config.pin_based_exec_ctrl = _pin_based_exec_control;
+	vmcs_config.cpu_based_exec_ctrl = _cpu_based_exec_control;
+	vmcs_config.vmexit_ctrl         = _vmexit_control;
+	vmcs_config.vmentry_ctrl        = _vmentry_control;
+
+	return 0;
 }
 
 static struct vmcs *alloc_vmcs_cpu(int cpu)
@@ -855,12 +933,12 @@ static struct vmcs *alloc_vmcs_cpu(int cpu)
 	struct page *pages;
 	struct vmcs *vmcs;
 
-	pages = alloc_pages_node(node, GFP_KERNEL, vmcs_descriptor.order);
+	pages = alloc_pages_node(node, GFP_KERNEL, vmcs_config.order);
 	if (!pages)
 		return NULL;
 	vmcs = page_address(pages);
-	memset(vmcs, 0, vmcs_descriptor.size);
-	vmcs->revision_id = vmcs_descriptor.revision_id; /* vmcs revision id */
+	memset(vmcs, 0, vmcs_config.size);
+	vmcs->revision_id = vmcs_config.revision_id; /* vmcs revision id */
 	return vmcs;
 }
 
@@ -871,7 +949,7 @@ static struct vmcs *alloc_vmcs(void)
 
 static void free_vmcs(struct vmcs *vmcs)
 {
-	free_pages((unsigned long)vmcs, vmcs_descriptor.order);
+	free_pages((unsigned long)vmcs, vmcs_config.order);
 }
 
 static void free_kvm_area(void)
@@ -904,7 +982,8 @@ static __init int alloc_kvm_area(void)
 
 static __init int hardware_setup(void)
 {
-	setup_vmcs_descriptor();
+	if (setup_vmcs_config() < 0)
+		return -1;
 	return alloc_kvm_area();
 }
 
@@ -1275,17 +1354,6 @@ static int init_rmode_tss(struct kvm* kvm)
 	return 1;
 }
 
-static void vmcs_write32_fixedbits(u32 msr, u32 vmcs_field, u32 val)
-{
-	u32 msr_high, msr_low;
-
-	rdmsr(msr, msr_low, msr_high);
-
-	val &= msr_high;
-	val |= msr_low;
-	vmcs_write32(vmcs_field, val);
-}
-
 static void seg_setup(int seg)
 {
 	struct kvm_vmx_segment_field *sf = &kvm_vmx_segment_fields[seg];
@@ -1382,20 +1450,10 @@ static int vmx_vcpu_setup(struct kvm_vcpu *vcpu)
 	vmcs_write64(GUEST_IA32_DEBUGCTL, 0);
 
 	/* Control */
-	vmcs_write32_fixedbits(MSR_IA32_VMX_PINBASED_CTLS,
-			       PIN_BASED_VM_EXEC_CONTROL,
-			       PIN_BASED_EXT_INTR_MASK   /* 20.6.1 */
-			       | PIN_BASED_NMI_EXITING   /* 20.6.1 */
-			);
-	vmcs_write32_fixedbits(MSR_IA32_VMX_PROCBASED_CTLS,
-			       CPU_BASED_VM_EXEC_CONTROL,
-			       CPU_BASED_HLT_EXITING         /* 20.6.2 */
-			       | CPU_BASED_CR8_LOAD_EXITING    /* 20.6.2 */
-			       | CPU_BASED_CR8_STORE_EXITING   /* 20.6.2 */
-			       | CPU_BASED_USE_IO_BITMAPS  /* 20.6.2 */
-			       | CPU_BASED_MOV_DR_EXITING
-			       | CPU_BASED_USE_TSC_OFFSETING   /* 21.3 */
-			);
+	vmcs_write32(PIN_BASED_VM_EXEC_CONTROL,
+		vmcs_config.pin_based_exec_ctrl);
+	vmcs_write32(CPU_BASED_VM_EXEC_CONTROL,
+		vmcs_config.cpu_based_exec_ctrl);
 
 	vmcs_write32(PAGE_FAULT_ERROR_CODE_MASK, 0);
 	vmcs_write32(PAGE_FAULT_ERROR_CODE_MATCH, 0);
@@ -1459,12 +1517,11 @@ static int vmx_vcpu_setup(struct kvm_vcpu *vcpu)
 
 	setup_msrs(vcpu);
 
-	vmcs_write32_fixedbits(MSR_IA32_VMX_EXIT_CTLS, VM_EXIT_CONTROLS,
-		     	       (HOST_IS_64 << 9));  /* 22.2,1, 20.7.1 */
+	vmcs_write32(VM_EXIT_CONTROLS, vmcs_config.vmexit_ctrl);
 
 	/* 22.2.1, 20.8.1 */
-	vmcs_write32_fixedbits(MSR_IA32_VMX_ENTRY_CTLS,
-                               VM_ENTRY_CONTROLS, 0);
+	vmcs_write32(VM_ENTRY_CONTROLS, vmcs_config.vmentry_ctrl);
+
 	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, 0);  /* 22.2.1 */
 
 #ifdef CONFIG_X86_64
-- 
1.5.3

