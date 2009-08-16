Return-Path: <linux-kernel-owner+w=401wt.eu-S1755401AbZHPJi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbZHPJi7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 05:38:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755347AbZHPJi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 05:38:58 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45334 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753736AbZHPJaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 05:30:10 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 03/48] KVM: Add MCE support
Date: Sun, 16 Aug 2009 12:29:23 +0300
Message-Id: <1250415008-17175-4-git-send-email-avi@redhat.com>
In-Reply-To: <1250415008-17175-1-git-send-email-avi@redhat.com>
References: <1250415008-17175-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huang Ying <ying.huang@intel.com>

The related MSRs are emulated. MCE capability is exported via
extension KVM_CAP_MCE and ioctl KVM_X86_GET_MCE_CAP_SUPPORTED.  A new
vcpu ioctl command KVM_X86_SETUP_MCE is used to setup MCE emulation
such as the mcg_cap. MCE is injected via vcpu ioctl command
KVM_X86_SET_MCE. Extended machine-check state (MCG_EXT_P) and CMCI are
not implemented.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm.h      |    1 +
 arch/x86/include/asm/kvm_host.h |    5 +
 arch/x86/kvm/x86.c              |  220 ++++++++++++++++++++++++++++++++++----
 include/linux/kvm.h             |   20 ++++
 4 files changed, 222 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/kvm.h b/arch/x86/include/asm/kvm.h
index 125be8b..708b9c3 100644
--- a/arch/x86/include/asm/kvm.h
+++ b/arch/x86/include/asm/kvm.h
@@ -17,6 +17,7 @@
 #define __KVM_HAVE_USER_NMI
 #define __KVM_HAVE_GUEST_DEBUG
 #define __KVM_HAVE_MSIX
+#define __KVM_HAVE_MCE
 
 /* Architectural interrupt line count. */
 #define KVM_NR_INTERRUPTS 256
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7956175..81c68f6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -373,6 +373,11 @@ struct kvm_vcpu_arch {
 	unsigned long dr6;
 	unsigned long dr7;
 	unsigned long eff_db[KVM_NR_DB_REGS];
+
+	u64 mcg_cap;
+	u64 mcg_status;
+	u64 mcg_ctl;
+	u64 *mce_banks;
 };
 
 struct kvm_mem_alias {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6d46079..55a9dd1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -42,6 +42,7 @@
 #include <asm/msr.h>
 #include <asm/desc.h>
 #include <asm/mtrr.h>
+#include <asm/mce.h>
 
 #define MAX_IO_MSRS 256
 #define CR0_RESERVED_BITS						\
@@ -55,6 +56,10 @@
 			  | X86_CR4_OSXMMEXCPT | X86_CR4_VMXE))
 
 #define CR8_RESERVED_BITS (~(unsigned long)X86_CR8_TPR)
+
+#define KVM_MAX_MCE_BANKS 32
+#define KVM_MCE_CAP_SUPPORTED MCG_CTL_P
+
 /* EFER defaults:
  * - enable syscall per default because its emulated by KVM
  * - enable LME and LMA per default on 64 bit KVM
@@ -777,23 +782,43 @@ static int set_msr_mtrr(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 	return 0;
 }
 
-int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
+static int set_msr_mce(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 {
+	u64 mcg_cap = vcpu->arch.mcg_cap;
+	unsigned bank_num = mcg_cap & 0xff;
+
 	switch (msr) {
-	case MSR_EFER:
-		set_efer(vcpu, data);
-		break;
-	case MSR_IA32_MC0_STATUS:
-		pr_unimpl(vcpu, "%s: MSR_IA32_MC0_STATUS 0x%llx, nop\n",
-		       __func__, data);
-		break;
 	case MSR_IA32_MCG_STATUS:
-		pr_unimpl(vcpu, "%s: MSR_IA32_MCG_STATUS 0x%llx, nop\n",
-			__func__, data);
+		vcpu->arch.mcg_status = data;
 		break;
 	case MSR_IA32_MCG_CTL:
-		pr_unimpl(vcpu, "%s: MSR_IA32_MCG_CTL 0x%llx, nop\n",
-			__func__, data);
+		if (!(mcg_cap & MCG_CTL_P))
+			return 1;
+		if (data != 0 && data != ~(u64)0)
+			return -1;
+		vcpu->arch.mcg_ctl = data;
+		break;
+	default:
+		if (msr >= MSR_IA32_MC0_CTL &&
+		    msr < MSR_IA32_MC0_CTL + 4 * bank_num) {
+			u32 offset = msr - MSR_IA32_MC0_CTL;
+			/* only 0 or all 1s can be written to IA32_MCi_CTL */
+			if ((offset & 0x3) == 0 &&
+			    data != 0 && data != ~(u64)0)
+				return -1;
+			vcpu->arch.mce_banks[offset] = data;
+			break;
+		}
+		return 1;
+	}
+	return 0;
+}
+
+int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
+{
+	switch (msr) {
+	case MSR_EFER:
+		set_efer(vcpu, data);
 		break;
 	case MSR_IA32_DEBUGCTLMSR:
 		if (!data) {
@@ -849,6 +874,10 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 		kvm_request_guest_time_update(vcpu);
 		break;
 	}
+	case MSR_IA32_MCG_CTL:
+	case MSR_IA32_MCG_STATUS:
+	case MSR_IA32_MC0_CTL ... MSR_IA32_MC0_CTL + 4 * KVM_MAX_MCE_BANKS - 1:
+		return set_msr_mce(vcpu, msr, data);
 	default:
 		pr_unimpl(vcpu, "unhandled wrmsr: 0x%x data %llx\n", msr, data);
 		return 1;
@@ -904,26 +933,49 @@ static int get_msr_mtrr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 	return 0;
 }
 
-int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
+static int get_msr_mce(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 {
 	u64 data;
+	u64 mcg_cap = vcpu->arch.mcg_cap;
+	unsigned bank_num = mcg_cap & 0xff;
 
 	switch (msr) {
-	case 0xc0010010: /* SYSCFG */
-	case 0xc0010015: /* HWCR */
-	case MSR_IA32_PLATFORM_ID:
 	case MSR_IA32_P5_MC_ADDR:
 	case MSR_IA32_P5_MC_TYPE:
-	case MSR_IA32_MC0_CTL:
-	case MSR_IA32_MCG_STATUS:
+		data = 0;
+		break;
 	case MSR_IA32_MCG_CAP:
+		data = vcpu->arch.mcg_cap;
+		break;
 	case MSR_IA32_MCG_CTL:
-	case MSR_IA32_MC0_MISC:
-	case MSR_IA32_MC0_MISC+4:
-	case MSR_IA32_MC0_MISC+8:
-	case MSR_IA32_MC0_MISC+12:
-	case MSR_IA32_MC0_MISC+16:
-	case MSR_IA32_MC0_MISC+20:
+		if (!(mcg_cap & MCG_CTL_P))
+			return 1;
+		data = vcpu->arch.mcg_ctl;
+		break;
+	case MSR_IA32_MCG_STATUS:
+		data = vcpu->arch.mcg_status;
+		break;
+	default:
+		if (msr >= MSR_IA32_MC0_CTL &&
+		    msr < MSR_IA32_MC0_CTL + 4 * bank_num) {
+			u32 offset = msr - MSR_IA32_MC0_CTL;
+			data = vcpu->arch.mce_banks[offset];
+			break;
+		}
+		return 1;
+	}
+	*pdata = data;
+	return 0;
+}
+
+int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
+{
+	u64 data;
+
+	switch (msr) {
+	case 0xc0010010: /* SYSCFG */
+	case 0xc0010015: /* HWCR */
+	case MSR_IA32_PLATFORM_ID:
 	case MSR_IA32_UCODE_REV:
 	case MSR_IA32_EBL_CR_POWERON:
 	case MSR_IA32_DEBUGCTLMSR:
@@ -966,6 +1018,13 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 	case MSR_KVM_SYSTEM_TIME:
 		data = vcpu->arch.time;
 		break;
+	case MSR_IA32_P5_MC_ADDR:
+	case MSR_IA32_P5_MC_TYPE:
+	case MSR_IA32_MCG_CAP:
+	case MSR_IA32_MCG_CTL:
+	case MSR_IA32_MCG_STATUS:
+	case MSR_IA32_MC0_CTL ... MSR_IA32_MC0_CTL + 4 * KVM_MAX_MCE_BANKS - 1:
+		return get_msr_mce(vcpu, msr, pdata);
 	default:
 		pr_unimpl(vcpu, "unhandled rdmsr: 0x%x\n", msr);
 		return 1;
@@ -1087,6 +1146,9 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_IOMMU:
 		r = iommu_found();
 		break;
+	case KVM_CAP_MCE:
+		r = KVM_MAX_MCE_BANKS;
+		break;
 	default:
 		r = 0;
 		break;
@@ -1146,6 +1208,16 @@ long kvm_arch_dev_ioctl(struct file *filp,
 		r = 0;
 		break;
 	}
+	case KVM_X86_GET_MCE_CAP_SUPPORTED: {
+		u64 mce_cap;
+
+		mce_cap = KVM_MCE_CAP_SUPPORTED;
+		r = -EFAULT;
+		if (copy_to_user(argp, &mce_cap, sizeof mce_cap))
+			goto out;
+		r = 0;
+		break;
+	}
 	default:
 		r = -EINVAL;
 	}
@@ -1502,6 +1574,80 @@ static int vcpu_ioctl_tpr_access_reporting(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static int kvm_vcpu_ioctl_x86_setup_mce(struct kvm_vcpu *vcpu,
+					u64 mcg_cap)
+{
+	int r;
+	unsigned bank_num = mcg_cap & 0xff, bank;
+
+	r = -EINVAL;
+	if (!bank_num)
+		goto out;
+	if (mcg_cap & ~(KVM_MCE_CAP_SUPPORTED | 0xff | 0xff0000))
+		goto out;
+	r = 0;
+	vcpu->arch.mcg_cap = mcg_cap;
+	/* Init IA32_MCG_CTL to all 1s */
+	if (mcg_cap & MCG_CTL_P)
+		vcpu->arch.mcg_ctl = ~(u64)0;
+	/* Init IA32_MCi_CTL to all 1s */
+	for (bank = 0; bank < bank_num; bank++)
+		vcpu->arch.mce_banks[bank*4] = ~(u64)0;
+out:
+	return r;
+}
+
+static int kvm_vcpu_ioctl_x86_set_mce(struct kvm_vcpu *vcpu,
+				      struct kvm_x86_mce *mce)
+{
+	u64 mcg_cap = vcpu->arch.mcg_cap;
+	unsigned bank_num = mcg_cap & 0xff;
+	u64 *banks = vcpu->arch.mce_banks;
+
+	if (mce->bank >= bank_num || !(mce->status & MCI_STATUS_VAL))
+		return -EINVAL;
+	/*
+	 * if IA32_MCG_CTL is not all 1s, the uncorrected error
+	 * reporting is disabled
+	 */
+	if ((mce->status & MCI_STATUS_UC) && (mcg_cap & MCG_CTL_P) &&
+	    vcpu->arch.mcg_ctl != ~(u64)0)
+		return 0;
+	banks += 4 * mce->bank;
+	/*
+	 * if IA32_MCi_CTL is not all 1s, the uncorrected error
+	 * reporting is disabled for the bank
+	 */
+	if ((mce->status & MCI_STATUS_UC) && banks[0] != ~(u64)0)
+		return 0;
+	if (mce->status & MCI_STATUS_UC) {
+		if ((vcpu->arch.mcg_status & MCG_STATUS_MCIP) ||
+		    !(vcpu->arch.cr4 & X86_CR4_MCE)) {
+			printk(KERN_DEBUG "kvm: set_mce: "
+			       "injects mce exception while "
+			       "previous one is in progress!\n");
+			set_bit(KVM_REQ_TRIPLE_FAULT, &vcpu->requests);
+			return 0;
+		}
+		if (banks[1] & MCI_STATUS_VAL)
+			mce->status |= MCI_STATUS_OVER;
+		banks[2] = mce->addr;
+		banks[3] = mce->misc;
+		vcpu->arch.mcg_status = mce->mcg_status;
+		banks[1] = mce->status;
+		kvm_queue_exception(vcpu, MC_VECTOR);
+	} else if (!(banks[1] & MCI_STATUS_VAL)
+		   || !(banks[1] & MCI_STATUS_UC)) {
+		if (banks[1] & MCI_STATUS_VAL)
+			mce->status |= MCI_STATUS_OVER;
+		banks[2] = mce->addr;
+		banks[3] = mce->misc;
+		banks[1] = mce->status;
+	} else
+		banks[1] |= MCI_STATUS_OVER;
+	return 0;
+}
+
 long kvm_arch_vcpu_ioctl(struct file *filp,
 			 unsigned int ioctl, unsigned long arg)
 {
@@ -1635,6 +1781,24 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		kvm_lapic_set_vapic_addr(vcpu, va.vapic_addr);
 		break;
 	}
+	case KVM_X86_SETUP_MCE: {
+		u64 mcg_cap;
+
+		r = -EFAULT;
+		if (copy_from_user(&mcg_cap, argp, sizeof mcg_cap))
+			goto out;
+		r = kvm_vcpu_ioctl_x86_setup_mce(vcpu, mcg_cap);
+		break;
+	}
+	case KVM_X86_SET_MCE: {
+		struct kvm_x86_mce mce;
+
+		r = -EFAULT;
+		if (copy_from_user(&mce, argp, sizeof mce))
+			goto out;
+		r = kvm_vcpu_ioctl_x86_set_mce(vcpu, &mce);
+		break;
+	}
 	default:
 		r = -EINVAL;
 	}
@@ -4440,6 +4604,14 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 			goto fail_mmu_destroy;
 	}
 
+	vcpu->arch.mce_banks = kzalloc(KVM_MAX_MCE_BANKS * sizeof(u64) * 4,
+				       GFP_KERNEL);
+	if (!vcpu->arch.mce_banks) {
+		r = -ENOMEM;
+		goto fail_mmu_destroy;
+	}
+	vcpu->arch.mcg_cap = KVM_MAX_MCE_BANKS;
+
 	return 0;
 
 fail_mmu_destroy:
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 3db5d8d..7b17141 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -415,6 +415,9 @@ struct kvm_trace_rec {
 #define KVM_CAP_ASSIGN_DEV_IRQ 29
 /* Another bug in KVM_SET_USER_MEMORY_REGION fixed: */
 #define KVM_CAP_JOIN_MEMORY_REGIONS_WORKS 30
+#ifdef __KVM_HAVE_MCE
+#define KVM_CAP_MCE 31
+#endif
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -454,6 +457,19 @@ struct kvm_irq_routing {
 
 #endif
 
+#ifdef KVM_CAP_MCE
+/* x86 MCE */
+struct kvm_x86_mce {
+	__u64 status;
+	__u64 addr;
+	__u64 misc;
+	__u64 mcg_status;
+	__u8 bank;
+	__u8 pad1[7];
+	__u64 pad2[3];
+};
+#endif
+
 /*
  * ioctls for VM fds
  */
@@ -541,6 +557,10 @@ struct kvm_irq_routing {
 #define KVM_NMI                   _IO(KVMIO,  0x9a)
 /* Available with KVM_CAP_SET_GUEST_DEBUG */
 #define KVM_SET_GUEST_DEBUG       _IOW(KVMIO,  0x9b, struct kvm_guest_debug)
+/* MCE for x86 */
+#define KVM_X86_SETUP_MCE         _IOW(KVMIO,  0x9c, __u64)
+#define KVM_X86_GET_MCE_CAP_SUPPORTED _IOR(KVMIO,  0x9d, __u64)
+#define KVM_X86_SET_MCE           _IOW(KVMIO,  0x9e, struct kvm_x86_mce)
 
 /*
  * Deprecated interfaces
-- 
1.6.3.3

