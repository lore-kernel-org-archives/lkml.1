Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896Ab0BMIEd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 03:04:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1485 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752678Ab0BMICF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 03:02:05 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 36/39] KVM: Implement bare minimum of HYPER-V MSRs
Date: Sat, 13 Feb 2010 10:01:56 +0200
Message-Id: <1266048119-14325-37-git-send-email-avi@redhat.com>
In-Reply-To: <1266048119-14325-1-git-send-email-avi@redhat.com>
References: <1266048119-14325-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

Minimum HYPER-V implementation should have GUEST_OS_ID, HYPERCALL and
VP_INDEX MSRs.

[avi: fix build on i386]

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Vadim Rozenfeld <vrozenfe@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    4 +
 arch/x86/include/asm/kvm_para.h |    1 +
 arch/x86/kvm/trace.h            |   32 +++++++
 arch/x86/kvm/x86.c              |  193 ++++++++++++++++++++++++++++++++++++++-
 include/linux/kvm.h             |    1 +
 5 files changed, 230 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 93bee7a..67d19e4 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -413,6 +413,10 @@ struct kvm_arch {
 	s64 kvmclock_offset;
 
 	struct kvm_xen_hvm_config xen_hvm_config;
+
+	/* fields used by HYPER-V emulation */
+	u64 hv_guest_os_id;
+	u64 hv_hypercall;
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index c584076..ffae142 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -2,6 +2,7 @@
 #define _ASM_X86_KVM_PARA_H
 
 #include <linux/types.h>
+#include <asm/hyperv.h>
 
 /* This CPUID returns the signature 'KVMKVMKVM' in ebx, ecx, and edx.  It
  * should be used to determine that a VM is running under KVM.
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 816e044..1cb3d0e 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -56,6 +56,38 @@ TRACE_EVENT(kvm_hypercall,
 );
 
 /*
+ * Tracepoint for hypercall.
+ */
+TRACE_EVENT(kvm_hv_hypercall,
+	TP_PROTO(__u16 code, bool fast, __u16 rep_cnt, __u16 rep_idx,
+		 __u64 ingpa, __u64 outgpa),
+	TP_ARGS(code, fast, rep_cnt, rep_idx, ingpa, outgpa),
+
+	TP_STRUCT__entry(
+		__field(	__u16, 		code		)
+		__field(	bool,		fast		)
+		__field(	__u16,		rep_cnt		)
+		__field(	__u16,		rep_idx		)
+		__field(	__u64,		ingpa		)
+		__field(	__u64,		outgpa		)
+	),
+
+	TP_fast_assign(
+		__entry->code		= code;
+		__entry->fast		= fast;
+		__entry->rep_cnt	= rep_cnt;
+		__entry->rep_idx	= rep_idx;
+		__entry->ingpa		= ingpa;
+		__entry->outgpa		= outgpa;
+	),
+
+	TP_printk("code 0x%x %s cnt 0x%x idx 0x%x in 0x%llx out 0x%llx",
+		  __entry->code, __entry->fast ? "fast" : "slow",
+		  __entry->rep_cnt, __entry->rep_idx,  __entry->ingpa,
+		  __entry->outgpa)
+);
+
+/*
  * Tracepoint for PIO.
  */
 TRACE_EVENT(kvm_pio,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1ad34d1..480137d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -622,9 +622,10 @@ static inline u32 bit(int bitno)
  * kvm-specific. Those are put in the beginning of the list.
  */
 
-#define KVM_SAVE_MSRS_BEGIN	2
+#define KVM_SAVE_MSRS_BEGIN	4
 static u32 msrs_to_save[] = {
 	MSR_KVM_SYSTEM_TIME, MSR_KVM_WALL_CLOCK,
+	HV_X64_MSR_GUEST_OS_ID, HV_X64_MSR_HYPERCALL,
 	MSR_IA32_SYSENTER_CS, MSR_IA32_SYSENTER_ESP, MSR_IA32_SYSENTER_EIP,
 	MSR_K6_STAR,
 #ifdef CONFIG_X86_64
@@ -1004,6 +1005,74 @@ out:
 	return r;
 }
 
+static bool kvm_hv_hypercall_enabled(struct kvm *kvm)
+{
+	return kvm->arch.hv_hypercall & HV_X64_MSR_HYPERCALL_ENABLE;
+}
+
+static bool kvm_hv_msr_partition_wide(u32 msr)
+{
+	bool r = false;
+	switch (msr) {
+	case HV_X64_MSR_GUEST_OS_ID:
+	case HV_X64_MSR_HYPERCALL:
+		r = true;
+		break;
+	}
+
+	return r;
+}
+
+static int set_msr_hyperv_pw(struct kvm_vcpu *vcpu, u32 msr, u64 data)
+{
+	struct kvm *kvm = vcpu->kvm;
+
+	switch (msr) {
+	case HV_X64_MSR_GUEST_OS_ID:
+		kvm->arch.hv_guest_os_id = data;
+		/* setting guest os id to zero disables hypercall page */
+		if (!kvm->arch.hv_guest_os_id)
+			kvm->arch.hv_hypercall &= ~HV_X64_MSR_HYPERCALL_ENABLE;
+		break;
+	case HV_X64_MSR_HYPERCALL: {
+		u64 gfn;
+		unsigned long addr;
+		u8 instructions[4];
+
+		/* if guest os id is not set hypercall should remain disabled */
+		if (!kvm->arch.hv_guest_os_id)
+			break;
+		if (!(data & HV_X64_MSR_HYPERCALL_ENABLE)) {
+			kvm->arch.hv_hypercall = data;
+			break;
+		}
+		gfn = data >> HV_X64_MSR_HYPERCALL_PAGE_ADDRESS_SHIFT;
+		addr = gfn_to_hva(kvm, gfn);
+		if (kvm_is_error_hva(addr))
+			return 1;
+		kvm_x86_ops->patch_hypercall(vcpu, instructions);
+		((unsigned char *)instructions)[3] = 0xc3; /* ret */
+		if (copy_to_user((void __user *)addr, instructions, 4))
+			return 1;
+		kvm->arch.hv_hypercall = data;
+		break;
+	}
+	default:
+		pr_unimpl(vcpu, "HYPER-V unimplemented wrmsr: 0x%x "
+			  "data 0x%llx\n", msr, data);
+		return 1;
+	}
+	return 0;
+}
+
+static int set_msr_hyperv(struct kvm_vcpu *vcpu, u32 msr, u64 data)
+{
+	pr_unimpl(vcpu, "HYPER-V unimplemented wrmsr: 0x%x data 0x%llx\n",
+		  msr, data);
+
+	return 1;
+}
+
 int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 {
 	switch (msr) {
@@ -1118,6 +1187,16 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 		pr_unimpl(vcpu, "unimplemented perfctr wrmsr: "
 			"0x%x data 0x%llx\n", msr, data);
 		break;
+	case HV_X64_MSR_GUEST_OS_ID ... HV_X64_MSR_SINT15:
+		if (kvm_hv_msr_partition_wide(msr)) {
+			int r;
+			mutex_lock(&vcpu->kvm->lock);
+			r = set_msr_hyperv_pw(vcpu, msr, data);
+			mutex_unlock(&vcpu->kvm->lock);
+			return r;
+		} else
+			return set_msr_hyperv(vcpu, msr, data);
+		break;
 	default:
 		if (msr && (msr == vcpu->kvm->arch.xen_hvm_config.msr))
 			return xen_hvm_config(vcpu, data);
@@ -1217,6 +1296,48 @@ static int get_msr_mce(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 	return 0;
 }
 
+static int get_msr_hyperv_pw(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
+{
+	u64 data = 0;
+	struct kvm *kvm = vcpu->kvm;
+
+	switch (msr) {
+	case HV_X64_MSR_GUEST_OS_ID:
+		data = kvm->arch.hv_guest_os_id;
+		break;
+	case HV_X64_MSR_HYPERCALL:
+		data = kvm->arch.hv_hypercall;
+		break;
+	default:
+		pr_unimpl(vcpu, "Hyper-V unhandled rdmsr: 0x%x\n", msr);
+		return 1;
+	}
+
+	*pdata = data;
+	return 0;
+}
+
+static int get_msr_hyperv(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
+{
+	u64 data = 0;
+
+	switch (msr) {
+	case HV_X64_MSR_VP_INDEX: {
+		int r;
+		struct kvm_vcpu *v;
+		kvm_for_each_vcpu(r, v, vcpu->kvm)
+			if (v == vcpu)
+				data = r;
+		break;
+	}
+	default:
+		pr_unimpl(vcpu, "Hyper-V unhandled rdmsr: 0x%x\n", msr);
+		return 1;
+	}
+	*pdata = data;
+	return 0;
+}
+
 int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 {
 	u64 data;
@@ -1283,6 +1404,16 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 	case MSR_IA32_MCG_STATUS:
 	case MSR_IA32_MC0_CTL ... MSR_IA32_MC0_CTL + 4 * KVM_MAX_MCE_BANKS - 1:
 		return get_msr_mce(vcpu, msr, pdata);
+	case HV_X64_MSR_GUEST_OS_ID ... HV_X64_MSR_SINT15:
+		if (kvm_hv_msr_partition_wide(msr)) {
+			int r;
+			mutex_lock(&vcpu->kvm->lock);
+			r = get_msr_hyperv_pw(vcpu, msr, pdata);
+			mutex_unlock(&vcpu->kvm->lock);
+			return r;
+		} else
+			return get_msr_hyperv(vcpu, msr, pdata);
+		break;
 	default:
 		if (!ignore_msrs) {
 			pr_unimpl(vcpu, "unhandled rdmsr: 0x%x\n", msr);
@@ -1398,6 +1529,7 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_XEN_HVM:
 	case KVM_CAP_ADJUST_CLOCK:
 	case KVM_CAP_VCPU_EVENTS:
+	case KVM_CAP_HYPERV:
 		r = 1;
 		break;
 	case KVM_CAP_COALESCED_MMIO:
@@ -3618,11 +3750,70 @@ static inline gpa_t hc_gpa(struct kvm_vcpu *vcpu, unsigned long a0,
 		return a0 | ((gpa_t)a1 << 32);
 }
 
+int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
+{
+	u64 param, ingpa, outgpa, ret;
+	uint16_t code, rep_idx, rep_cnt, res = HV_STATUS_SUCCESS, rep_done = 0;
+	bool fast, longmode;
+	int cs_db, cs_l;
+
+	/*
+	 * hypercall generates UD from non zero cpl and real mode
+	 * per HYPER-V spec
+	 */
+	if (kvm_x86_ops->get_cpl(vcpu) != 0 ||
+	    !kvm_read_cr0_bits(vcpu, X86_CR0_PE)) {
+		kvm_queue_exception(vcpu, UD_VECTOR);
+		return 0;
+	}
+
+	kvm_x86_ops->get_cs_db_l_bits(vcpu, &cs_db, &cs_l);
+	longmode = is_long_mode(vcpu) && cs_l == 1;
+
+	if (!longmode) {
+		param = (kvm_register_read(vcpu, VCPU_REGS_RDX) << 32) |
+			(kvm_register_read(vcpu, VCPU_REGS_RAX) & 0xffffff);
+		ingpa = (kvm_register_read(vcpu, VCPU_REGS_RBX) << 32) |
+			(kvm_register_read(vcpu, VCPU_REGS_RCX) & 0xffffff);
+		outgpa = (kvm_register_read(vcpu, VCPU_REGS_RDI) << 32) |
+			(kvm_register_read(vcpu, VCPU_REGS_RSI) & 0xffffff);
+	}
+#ifdef CONFIG_X86_64
+	else {
+		param = kvm_register_read(vcpu, VCPU_REGS_RCX);
+		ingpa = kvm_register_read(vcpu, VCPU_REGS_RDX);
+		outgpa = kvm_register_read(vcpu, VCPU_REGS_R8);
+	}
+#endif
+
+	code = param & 0xffff;
+	fast = (param >> 16) & 0x1;
+	rep_cnt = (param >> 32) & 0xfff;
+	rep_idx = (param >> 48) & 0xfff;
+
+	trace_kvm_hv_hypercall(code, fast, rep_cnt, rep_idx, ingpa, outgpa);
+
+	res = HV_STATUS_INVALID_HYPERCALL_CODE;
+
+	ret = res | (((u64)rep_done & 0xfff) << 32);
+	if (longmode) {
+		kvm_register_write(vcpu, VCPU_REGS_RAX, ret);
+	} else {
+		kvm_register_write(vcpu, VCPU_REGS_RDX, ret >> 32);
+		kvm_register_write(vcpu, VCPU_REGS_RAX, ret & 0xffffffff);
+	}
+
+	return 1;
+}
+
 int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 {
 	unsigned long nr, a0, a1, a2, a3, ret;
 	int r = 1;
 
+	if (kvm_hv_hypercall_enabled(vcpu->kvm))
+		return kvm_hv_hypercall(vcpu);
+
 	nr = kvm_register_read(vcpu, VCPU_REGS_RAX);
 	a0 = kvm_register_read(vcpu, VCPU_REGS_RBX);
 	a1 = kvm_register_read(vcpu, VCPU_REGS_RCX);
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index f2feef6..e227cba 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -497,6 +497,7 @@ struct kvm_ioeventfd {
 #endif
 #define KVM_CAP_S390_PSW 42
 #define KVM_CAP_PPC_SEGSTATE 43
+#define KVM_CAP_HYPERV 44
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
1.6.5.3

