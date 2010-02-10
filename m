Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583Ab0BJR3N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 12:29:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44666 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755518Ab0BJRXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 12:23:13 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 14/40] KVM: VMX: Add instruction rdtscp support for guest
Date: Wed, 10 Feb 2010 19:22:43 +0200
Message-Id: <1265822589-11155-15-git-send-email-avi@redhat.com>
In-Reply-To: <1265822589-11155-1-git-send-email-avi@redhat.com>
References: <1265822589-11155-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng@linux.intel.com>

Before enabling, execution of "rdtscp" in guest would result in #UD.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/include/asm/vmx.h      |    1 +
 arch/x86/kvm/svm.c              |    7 ++++
 arch/x86/kvm/vmx.c              |   60 +++++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/x86.c              |    3 +-
 5 files changed, 68 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7ff0ea3..fe4df46 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -521,6 +521,7 @@ struct kvm_x86_ops {
 	int (*get_tdp_level)(void);
 	u64 (*get_mt_mask)(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
 	bool (*gb_page_enable)(void);
+	bool (*rdtscp_supported)(void);
 
 	const struct trace_print_flags *exit_reasons_str;
 };
diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 8f6b011..713ed9a 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -53,6 +53,7 @@
  */
 #define SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES 0x00000001
 #define SECONDARY_EXEC_ENABLE_EPT               0x00000002
+#define SECONDARY_EXEC_RDTSCP			0x00000008
 #define SECONDARY_EXEC_ENABLE_VPID              0x00000020
 #define SECONDARY_EXEC_WBINVD_EXITING		0x00000040
 #define SECONDARY_EXEC_UNRESTRICTED_GUEST	0x00000080
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 41777e6..7f4e225 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2914,6 +2914,11 @@ static bool svm_gb_page_enable(void)
 	return true;
 }
 
+static bool svm_rdtscp_supported(void)
+{
+	return false;
+}
+
 static struct kvm_x86_ops svm_x86_ops = {
 	.cpu_has_kvm_support = has_svm,
 	.disabled_by_bios = is_disabled,
@@ -2982,6 +2987,8 @@ static struct kvm_x86_ops svm_x86_ops = {
 	.gb_page_enable = svm_gb_page_enable,
 
 	.cpuid_update = svm_cpuid_update,
+
+	.rdtscp_supported = svm_rdtscp_supported,
 };
 
 static int __init svm_init(void)
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 75e8931..74a66f0 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -151,6 +151,8 @@ struct vcpu_vmx {
 	ktime_t entry_time;
 	s64 vnmi_blocked_time;
 	u32 exit_reason;
+
+	bool rdtscp_enabled;
 };
 
 static inline struct vcpu_vmx *to_vmx(struct kvm_vcpu *vcpu)
@@ -225,7 +227,7 @@ static const u32 vmx_msr_index[] = {
 #ifdef CONFIG_X86_64
 	MSR_SYSCALL_MASK, MSR_LSTAR, MSR_CSTAR,
 #endif
-	MSR_EFER, MSR_K6_STAR,
+	MSR_EFER, MSR_TSC_AUX, MSR_K6_STAR,
 };
 #define NR_VMX_MSR ARRAY_SIZE(vmx_msr_index)
 
@@ -362,6 +364,12 @@ static inline int cpu_has_vmx_vpid(void)
 		SECONDARY_EXEC_ENABLE_VPID;
 }
 
+static inline int cpu_has_vmx_rdtscp(void)
+{
+	return vmcs_config.cpu_based_2nd_exec_ctrl &
+		SECONDARY_EXEC_RDTSCP;
+}
+
 static inline int cpu_has_virtual_nmis(void)
 {
 	return vmcs_config.pin_based_exec_ctrl & PIN_BASED_VIRTUAL_NMIS;
@@ -893,6 +901,11 @@ static void vmx_queue_exception(struct kvm_vcpu *vcpu, unsigned nr,
 	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, intr_info);
 }
 
+static bool vmx_rdtscp_supported(void)
+{
+	return cpu_has_vmx_rdtscp();
+}
+
 /*
  * Swap MSR entry in host/guest MSR entry array.
  */
@@ -928,6 +941,9 @@ static void setup_msrs(struct vcpu_vmx *vmx)
 		index = __find_msr_index(vmx, MSR_CSTAR);
 		if (index >= 0)
 			move_msr_up(vmx, index, save_nmsrs++);
+		index = __find_msr_index(vmx, MSR_TSC_AUX);
+		if (index >= 0 && vmx->rdtscp_enabled)
+			move_msr_up(vmx, index, save_nmsrs++);
 		/*
 		 * MSR_K6_STAR is only needed on long mode guests, and only
 		 * if efer.sce is enabled.
@@ -1017,6 +1033,10 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *pdata)
 	case MSR_IA32_SYSENTER_ESP:
 		data = vmcs_readl(GUEST_SYSENTER_ESP);
 		break;
+	case MSR_TSC_AUX:
+		if (!to_vmx(vcpu)->rdtscp_enabled)
+			return 1;
+		/* Otherwise falls through */
 	default:
 		vmx_load_host_state(to_vmx(vcpu));
 		msr = find_msr_entry(to_vmx(vcpu), msr_index);
@@ -1080,7 +1100,15 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
 			vcpu->arch.pat = data;
 			break;
 		}
-		/* Otherwise falls through to kvm_set_msr_common */
+		ret = kvm_set_msr_common(vcpu, msr_index, data);
+		break;
+	case MSR_TSC_AUX:
+		if (!vmx->rdtscp_enabled)
+			return 1;
+		/* Check reserved bit, higher 32 bits should be zero */
+		if ((data >> 32) != 0)
+			return 1;
+		/* Otherwise falls through */
 	default:
 		msr = find_msr_entry(vmx, msr_index);
 		if (msr) {
@@ -1260,7 +1288,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf)
 			SECONDARY_EXEC_ENABLE_VPID |
 			SECONDARY_EXEC_ENABLE_EPT |
 			SECONDARY_EXEC_UNRESTRICTED_GUEST |
-			SECONDARY_EXEC_PAUSE_LOOP_EXITING;
+			SECONDARY_EXEC_PAUSE_LOOP_EXITING |
+			SECONDARY_EXEC_RDTSCP;
 		if (adjust_vmx_controls(min2, opt2,
 					MSR_IA32_VMX_PROCBASED_CTLS2,
 					&_cpu_based_2nd_exec_control) < 0)
@@ -3988,8 +4017,31 @@ static bool vmx_gb_page_enable(void)
 	return false;
 }
 
+static inline u32 bit(int bitno)
+{
+	return 1 << (bitno & 31);
+}
+
 static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
 {
+	struct kvm_cpuid_entry2 *best;
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	u32 exec_control;
+
+	vmx->rdtscp_enabled = false;
+	if (vmx_rdtscp_supported()) {
+		exec_control = vmcs_read32(SECONDARY_VM_EXEC_CONTROL);
+		if (exec_control & SECONDARY_EXEC_RDTSCP) {
+			best = kvm_find_cpuid_entry(vcpu, 0x80000001, 0);
+			if (best && (best->edx & bit(X86_FEATURE_RDTSCP)))
+				vmx->rdtscp_enabled = true;
+			else {
+				exec_control &= ~SECONDARY_EXEC_RDTSCP;
+				vmcs_write32(SECONDARY_VM_EXEC_CONTROL,
+						exec_control);
+			}
+		}
+	}
 }
 
 static struct kvm_x86_ops vmx_x86_ops = {
@@ -4058,6 +4110,8 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.gb_page_enable = vmx_gb_page_enable,
 
 	.cpuid_update = vmx_cpuid_update,
+
+	.rdtscp_supported = vmx_rdtscp_supported,
 };
 
 static int __init vmx_init(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 153f4a1..1bdcf26 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1647,6 +1647,7 @@ static void do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 #else
 	unsigned f_lm = 0;
 #endif
+	unsigned f_rdtscp = kvm_x86_ops->rdtscp_supported() ? F(RDTSCP) : 0;
 
 	/* cpuid 1.edx */
 	const u32 kvm_supported_word0_x86_features =
@@ -1666,7 +1667,7 @@ static void do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 		F(MTRR) | F(PGE) | F(MCA) | F(CMOV) |
 		F(PAT) | F(PSE36) | 0 /* Reserved */ |
 		f_nx | 0 /* Reserved */ | F(MMXEXT) | F(MMX) |
-		F(FXSR) | F(FXSR_OPT) | f_gbpages | 0 /* RDTSCP */ |
+		F(FXSR) | F(FXSR_OPT) | f_gbpages | f_rdtscp |
 		0 /* Reserved */ | f_lm | F(3DNOWEXT) | F(3DNOW);
 	/* cpuid 1.ecx */
 	const u32 kvm_supported_word4_x86_features =
-- 
1.6.5.3

