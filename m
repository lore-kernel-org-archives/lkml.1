Return-Path: <linux-kernel-owner+w=401wt.eu-S1753420AbXIQJGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420AbXIQJGT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 05:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755075AbXIQIeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:34:10 -0400
Received: from il.qumranet.com ([82.166.9.18]:45249 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753253AbXIQIcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:25 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, "Yang, Sheng" <sheng.yang@intel.com>
Subject: [PATCH 021/104] KVM: VMX: Import some constants of vmcs from IA32 SDM
Date: Mon, 17 Sep 2007 10:31:03 +0200
Message-Id: <11900179471871-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yang, Sheng <sheng.yang@intel.com>

This patch mainly imports some constants and rename two exist constants
of vmcs according to IA32 SDM.

It also adds two constants to indicate Lock bit and Enable bit in
MSR_IA32_FEATURE_CONTROL, and replace the hardcode _5_ with these two
bits.

Signed-off-by: Sheng Yang <sheng.yang@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/vmx.c |   16 +++++++++---
 drivers/kvm/vmx.h |   69 +++++++++++++++++++++++++++++++++--------------------
 2 files changed, 55 insertions(+), 30 deletions(-)

diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 79674a7..dac2f93 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -751,7 +751,10 @@ static __init int vmx_disabled_by_bios(void)
 	u64 msr;
 
 	rdmsrl(MSR_IA32_FEATURE_CONTROL, msr);
-	return (msr & 5) == 1; /* locked but not enabled */
+	return (msr & (MSR_IA32_FEATURE_CONTROL_LOCKED |
+		       MSR_IA32_FEATURE_CONTROL_VMXON_ENABLED))
+	    == MSR_IA32_FEATURE_CONTROL_LOCKED;
+	/* locked but not enabled */
 }
 
 static void hardware_enable(void *garbage)
@@ -761,9 +764,14 @@ static void hardware_enable(void *garbage)
 	u64 old;
 
 	rdmsrl(MSR_IA32_FEATURE_CONTROL, old);
-	if ((old & 5) != 5)
+	if ((old & (MSR_IA32_FEATURE_CONTROL_LOCKED |
+		    MSR_IA32_FEATURE_CONTROL_VMXON_ENABLED))
+	    != (MSR_IA32_FEATURE_CONTROL_LOCKED |
+		MSR_IA32_FEATURE_CONTROL_VMXON_ENABLED))
 		/* enable and lock */
-		wrmsrl(MSR_IA32_FEATURE_CONTROL, old | 5);
+		wrmsrl(MSR_IA32_FEATURE_CONTROL, old |
+		       MSR_IA32_FEATURE_CONTROL_LOCKED |
+		       MSR_IA32_FEATURE_CONTROL_VMXON_ENABLED);
 	write_cr4(read_cr4() | X86_CR4_VMXE); /* FIXME: not cpu hotplug safe */
 	asm volatile (ASM_VMX_VMXON_RAX : : "a"(&phys_addr), "m"(phys_addr)
 		      : "memory", "cc");
@@ -1326,7 +1334,7 @@ static int vmx_vcpu_setup(struct kvm_vcpu *vcpu)
 			       CPU_BASED_HLT_EXITING         /* 20.6.2 */
 			       | CPU_BASED_CR8_LOAD_EXITING    /* 20.6.2 */
 			       | CPU_BASED_CR8_STORE_EXITING   /* 20.6.2 */
-			       | CPU_BASED_ACTIVATE_IO_BITMAP  /* 20.6.2 */
+			       | CPU_BASED_USE_IO_BITMAPS  /* 20.6.2 */
 			       | CPU_BASED_MOV_DR_EXITING
 			       | CPU_BASED_USE_TSC_OFFSETING   /* 21.3 */
 			);
diff --git a/drivers/kvm/vmx.h b/drivers/kvm/vmx.h
index 76ad793..7e4dc12 100644
--- a/drivers/kvm/vmx.h
+++ b/drivers/kvm/vmx.h
@@ -25,29 +25,36 @@
  *
  */
 
-#define CPU_BASED_VIRTUAL_INTR_PENDING  0x00000004
-#define CPU_BASED_USE_TSC_OFFSETING     0x00000008
-#define CPU_BASED_HLT_EXITING           0x00000080
-#define CPU_BASED_INVDPG_EXITING        0x00000200
-#define CPU_BASED_MWAIT_EXITING         0x00000400
-#define CPU_BASED_RDPMC_EXITING         0x00000800
-#define CPU_BASED_RDTSC_EXITING         0x00001000
-#define CPU_BASED_CR8_LOAD_EXITING      0x00080000
-#define CPU_BASED_CR8_STORE_EXITING     0x00100000
-#define CPU_BASED_TPR_SHADOW            0x00200000
-#define CPU_BASED_MOV_DR_EXITING        0x00800000
-#define CPU_BASED_UNCOND_IO_EXITING     0x01000000
-#define CPU_BASED_ACTIVATE_IO_BITMAP    0x02000000
-#define CPU_BASED_MSR_BITMAPS           0x10000000
-#define CPU_BASED_MONITOR_EXITING       0x20000000
-#define CPU_BASED_PAUSE_EXITING         0x40000000
+#define CPU_BASED_VIRTUAL_INTR_PENDING          0x00000004
+#define CPU_BASED_USE_TSC_OFFSETING             0x00000008
+#define CPU_BASED_HLT_EXITING                   0x00000080
+#define CPU_BASED_INVLPG_EXITING                0x00000200
+#define CPU_BASED_MWAIT_EXITING                 0x00000400
+#define CPU_BASED_RDPMC_EXITING                 0x00000800
+#define CPU_BASED_RDTSC_EXITING                 0x00001000
+#define CPU_BASED_CR8_LOAD_EXITING              0x00080000
+#define CPU_BASED_CR8_STORE_EXITING             0x00100000
+#define CPU_BASED_TPR_SHADOW                    0x00200000
+#define CPU_BASED_MOV_DR_EXITING                0x00800000
+#define CPU_BASED_UNCOND_IO_EXITING             0x01000000
+#define CPU_BASED_USE_IO_BITMAPS                0x02000000
+#define CPU_BASED_USE_MSR_BITMAPS               0x10000000
+#define CPU_BASED_MONITOR_EXITING               0x20000000
+#define CPU_BASED_PAUSE_EXITING                 0x40000000
+#define CPU_BASED_ACTIVATE_SECONDARY_CONTROLS   0x80000000
 
-#define PIN_BASED_EXT_INTR_MASK 0x1
-#define PIN_BASED_NMI_EXITING   0x8
+#define PIN_BASED_EXT_INTR_MASK                 0x00000001
+#define PIN_BASED_NMI_EXITING                   0x00000008
+#define PIN_BASED_VIRTUAL_NMIS                  0x00000020
 
-#define VM_EXIT_ACK_INTR_ON_EXIT        0x00008000
-#define VM_EXIT_HOST_ADD_SPACE_SIZE     0x00000200
+#define VM_EXIT_HOST_ADDR_SPACE_SIZE            0x00000200
+#define VM_EXIT_ACK_INTR_ON_EXIT                0x00008000
 
+#define VM_ENTRY_IA32E_MODE                     0x00000200
+#define VM_ENTRY_SMM                            0x00000400
+#define VM_ENTRY_DEACT_DUAL_MONITOR             0x00000800
+
+#define SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES 0x00000001
 
 /* VMCS Encodings */
 enum vmcs_field {
@@ -285,11 +292,21 @@ enum vmcs_field {
 
 #define AR_RESERVD_MASK 0xfffe0f00
 
-#define MSR_IA32_VMX_BASIC   		0x480
-#define MSR_IA32_FEATURE_CONTROL 		0x03a
-#define MSR_IA32_VMX_PINBASED_CTLS		0x481
-#define MSR_IA32_VMX_PROCBASED_CTLS		0x482
-#define MSR_IA32_VMX_EXIT_CTLS		0x483
-#define MSR_IA32_VMX_ENTRY_CTLS		0x484
+#define MSR_IA32_VMX_BASIC                      0x480
+#define MSR_IA32_VMX_PINBASED_CTLS              0x481
+#define MSR_IA32_VMX_PROCBASED_CTLS             0x482
+#define MSR_IA32_VMX_EXIT_CTLS                  0x483
+#define MSR_IA32_VMX_ENTRY_CTLS                 0x484
+#define MSR_IA32_VMX_MISC                       0x485
+#define MSR_IA32_VMX_CR0_FIXED0                 0x486
+#define MSR_IA32_VMX_CR0_FIXED1                 0x487
+#define MSR_IA32_VMX_CR4_FIXED0                 0x488
+#define MSR_IA32_VMX_CR4_FIXED1                 0x489
+#define MSR_IA32_VMX_VMCS_ENUM                  0x48a
+#define MSR_IA32_VMX_PROCBASED_CTLS2            0x48b
+
+#define MSR_IA32_FEATURE_CONTROL                0x3a
+#define MSR_IA32_FEATURE_CONTROL_LOCKED         0x1
+#define MSR_IA32_FEATURE_CONTROL_VMXON_ENABLED  0x4
 
 #endif
-- 
1.5.3

