Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab0BMIDu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 03:03:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1120 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725Ab0BMICH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 03:02:07 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 37/39] KVM: Add HYPER-V apic access MSRs
Date: Sat, 13 Feb 2010 10:01:57 +0200
Message-Id: <1266048119-14325-38-git-send-email-avi@redhat.com>
In-Reply-To: <1266048119-14325-1-git-send-email-avi@redhat.com>
References: <1266048119-14325-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

Implement HYPER-V apic MSRs. Spec defines three MSRs that speed-up
access to EOI/TPR/ICR apic registers for PV guests.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Vadim Rozenfeld <vrozenfe@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    2 +
 arch/x86/kvm/lapic.c            |   31 ++++++++++++++++++++++++++++
 arch/x86/kvm/lapic.h            |    8 +++++++
 arch/x86/kvm/x86.c              |   42 +++++++++++++++++++++++++++++++++++---
 include/linux/kvm.h             |    1 +
 5 files changed, 80 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 67d19e4..a1f0b5d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -363,6 +363,8 @@ struct kvm_vcpu_arch {
 	/* used for guest single stepping over the given code position */
 	u16 singlestep_cs;
 	unsigned long singlestep_rip;
+	/* fields used by HYPER-V emulation */
+	u64 hv_vapic;
 };
 
 struct kvm_mem_alias {
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index ba8c045..4b224f9 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1246,3 +1246,34 @@ int kvm_x2apic_msr_read(struct kvm_vcpu *vcpu, u32 msr, u64 *data)
 
 	return 0;
 }
+
+int kvm_hv_vapic_msr_write(struct kvm_vcpu *vcpu, u32 reg, u64 data)
+{
+	struct kvm_lapic *apic = vcpu->arch.apic;
+
+	if (!irqchip_in_kernel(vcpu->kvm))
+		return 1;
+
+	/* if this is ICR write vector before command */
+	if (reg == APIC_ICR)
+		apic_reg_write(apic, APIC_ICR2, (u32)(data >> 32));
+	return apic_reg_write(apic, reg, (u32)data);
+}
+
+int kvm_hv_vapic_msr_read(struct kvm_vcpu *vcpu, u32 reg, u64 *data)
+{
+	struct kvm_lapic *apic = vcpu->arch.apic;
+	u32 low, high = 0;
+
+	if (!irqchip_in_kernel(vcpu->kvm))
+		return 1;
+
+	if (apic_reg_read(apic, reg, 4, &low))
+		return 1;
+	if (reg == APIC_ICR)
+		apic_reg_read(apic, APIC_ICR2, 4, &high);
+
+	*data = (((u64)high) << 32) | low;
+
+	return 0;
+}
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 40010b0..f5fe32c 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -48,4 +48,12 @@ void kvm_lapic_sync_to_vapic(struct kvm_vcpu *vcpu);
 
 int kvm_x2apic_msr_write(struct kvm_vcpu *vcpu, u32 msr, u64 data);
 int kvm_x2apic_msr_read(struct kvm_vcpu *vcpu, u32 msr, u64 *data);
+
+int kvm_hv_vapic_msr_write(struct kvm_vcpu *vcpu, u32 msr, u64 data);
+int kvm_hv_vapic_msr_read(struct kvm_vcpu *vcpu, u32 msr, u64 *data);
+
+static inline bool kvm_hv_vapic_assist_page_enabled(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.hv_vapic & HV_X64_MSR_APIC_ASSIST_PAGE_ENABLE;
+}
 #endif
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 480137d..552be51 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -622,10 +622,11 @@ static inline u32 bit(int bitno)
  * kvm-specific. Those are put in the beginning of the list.
  */
 
-#define KVM_SAVE_MSRS_BEGIN	4
+#define KVM_SAVE_MSRS_BEGIN	5
 static u32 msrs_to_save[] = {
 	MSR_KVM_SYSTEM_TIME, MSR_KVM_WALL_CLOCK,
 	HV_X64_MSR_GUEST_OS_ID, HV_X64_MSR_HYPERCALL,
+	HV_X64_MSR_APIC_ASSIST_PAGE,
 	MSR_IA32_SYSENTER_CS, MSR_IA32_SYSENTER_ESP, MSR_IA32_SYSENTER_EIP,
 	MSR_K6_STAR,
 #ifdef CONFIG_X86_64
@@ -1067,10 +1068,36 @@ static int set_msr_hyperv_pw(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 
 static int set_msr_hyperv(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 {
-	pr_unimpl(vcpu, "HYPER-V unimplemented wrmsr: 0x%x data 0x%llx\n",
-		  msr, data);
+	switch (msr) {
+	case HV_X64_MSR_APIC_ASSIST_PAGE: {
+		unsigned long addr;
 
-	return 1;
+		if (!(data & HV_X64_MSR_APIC_ASSIST_PAGE_ENABLE)) {
+			vcpu->arch.hv_vapic = data;
+			break;
+		}
+		addr = gfn_to_hva(vcpu->kvm, data >>
+				  HV_X64_MSR_APIC_ASSIST_PAGE_ADDRESS_SHIFT);
+		if (kvm_is_error_hva(addr))
+			return 1;
+		if (clear_user((void __user *)addr, PAGE_SIZE))
+			return 1;
+		vcpu->arch.hv_vapic = data;
+		break;
+	}
+	case HV_X64_MSR_EOI:
+		return kvm_hv_vapic_msr_write(vcpu, APIC_EOI, data);
+	case HV_X64_MSR_ICR:
+		return kvm_hv_vapic_msr_write(vcpu, APIC_ICR, data);
+	case HV_X64_MSR_TPR:
+		return kvm_hv_vapic_msr_write(vcpu, APIC_TASKPRI, data);
+	default:
+		pr_unimpl(vcpu, "HYPER-V unimplemented wrmsr: 0x%x "
+			  "data 0x%llx\n", msr, data);
+		return 1;
+	}
+
+	return 0;
 }
 
 int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
@@ -1330,6 +1357,12 @@ static int get_msr_hyperv(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 				data = r;
 		break;
 	}
+	case HV_X64_MSR_EOI:
+		return kvm_hv_vapic_msr_read(vcpu, APIC_EOI, pdata);
+	case HV_X64_MSR_ICR:
+		return kvm_hv_vapic_msr_read(vcpu, APIC_ICR, pdata);
+	case HV_X64_MSR_TPR:
+		return kvm_hv_vapic_msr_read(vcpu, APIC_TASKPRI, pdata);
 	default:
 		pr_unimpl(vcpu, "Hyper-V unhandled rdmsr: 0x%x\n", msr);
 		return 1;
@@ -1530,6 +1563,7 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_ADJUST_CLOCK:
 	case KVM_CAP_VCPU_EVENTS:
 	case KVM_CAP_HYPERV:
+	case KVM_CAP_HYPERV_VAPIC:
 		r = 1;
 		break;
 	case KVM_CAP_COALESCED_MMIO:
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index e227cba..5ce6173 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -498,6 +498,7 @@ struct kvm_ioeventfd {
 #define KVM_CAP_S390_PSW 42
 #define KVM_CAP_PPC_SEGSTATE 43
 #define KVM_CAP_HYPERV 44
+#define KVM_CAP_HYPERV_VAPIC 45
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
1.6.5.3

