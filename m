Return-Path: <linux-kernel-owner+w=401wt.eu-S1754515AbYLHLuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515AbYLHLuF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 06:50:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753626AbYLHLim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 06:38:42 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48231 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753130AbYLHLhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 06:37:04 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jan Kiszka <jan.kiszka@siemens.com>
Subject: [PATCH 12/45] KVM: x86: Support for user space injected NMIs
Date: Mon,  8 Dec 2008 13:36:23 +0200
Message-Id: <1228736216-15787-13-git-send-email-avi@redhat.com>
In-Reply-To: <1228736216-15787-1-git-send-email-avi@redhat.com>
References: <1228736216-15787-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

Introduces the KVM_NMI IOCTL to the generic x86 part of KVM for
injecting NMIs from user space and also extends the statistic report
accordingly.

Based on the original patch by Sheng Yang.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Sheng Yang <sheng.yang@intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    2 +
 arch/x86/kvm/x86.c              |   46 +++++++++++++++++++++++++++++++++++++-
 include/linux/kvm.h             |   11 +++++++-
 3 files changed, 55 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index bfbbdea..a40fa84 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -398,6 +398,7 @@ struct kvm_vcpu_stat {
 	u32 halt_exits;
 	u32 halt_wakeup;
 	u32 request_irq_exits;
+	u32 request_nmi_exits;
 	u32 irq_exits;
 	u32 host_state_reload;
 	u32 efer_reload;
@@ -406,6 +407,7 @@ struct kvm_vcpu_stat {
 	u32 insn_emulation_fail;
 	u32 hypercalls;
 	u32 irq_injections;
+	u32 nmi_injections;
 };
 
 struct descriptor_table {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1fa9a6d..0797145 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -86,6 +86,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ "halt_wakeup", VCPU_STAT(halt_wakeup) },
 	{ "hypercalls", VCPU_STAT(hypercalls) },
 	{ "request_irq", VCPU_STAT(request_irq_exits) },
+	{ "request_nmi", VCPU_STAT(request_nmi_exits) },
 	{ "irq_exits", VCPU_STAT(irq_exits) },
 	{ "host_state_reload", VCPU_STAT(host_state_reload) },
 	{ "efer_reload", VCPU_STAT(efer_reload) },
@@ -93,6 +94,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ "insn_emulation", VCPU_STAT(insn_emulation) },
 	{ "insn_emulation_fail", VCPU_STAT(insn_emulation_fail) },
 	{ "irq_injections", VCPU_STAT(irq_injections) },
+	{ "nmi_injections", VCPU_STAT(nmi_injections) },
 	{ "mmu_shadow_zapped", VM_STAT(mmu_shadow_zapped) },
 	{ "mmu_pte_write", VM_STAT(mmu_pte_write) },
 	{ "mmu_pte_updated", VM_STAT(mmu_pte_updated) },
@@ -1318,6 +1320,15 @@ static int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static int kvm_vcpu_ioctl_nmi(struct kvm_vcpu *vcpu)
+{
+	vcpu_load(vcpu);
+	kvm_inject_nmi(vcpu);
+	vcpu_put(vcpu);
+
+	return 0;
+}
+
 static int vcpu_ioctl_tpr_access_reporting(struct kvm_vcpu *vcpu,
 					   struct kvm_tpr_access_ctl *tac)
 {
@@ -1377,6 +1388,13 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		r = 0;
 		break;
 	}
+	case KVM_NMI: {
+		r = kvm_vcpu_ioctl_nmi(vcpu);
+		if (r)
+			goto out;
+		r = 0;
+		break;
+	}
 	case KVM_SET_CPUID: {
 		struct kvm_cpuid __user *cpuid_arg = argp;
 		struct kvm_cpuid cpuid;
@@ -2812,18 +2830,37 @@ static int dm_request_for_irq_injection(struct kvm_vcpu *vcpu,
 		(kvm_x86_ops->get_rflags(vcpu) & X86_EFLAGS_IF));
 }
 
+/*
+ * Check if userspace requested a NMI window, and that the NMI window
+ * is open.
+ *
+ * No need to exit to userspace if we already have a NMI queued.
+ */
+static int dm_request_for_nmi_injection(struct kvm_vcpu *vcpu,
+					struct kvm_run *kvm_run)
+{
+	return (!vcpu->arch.nmi_pending &&
+		kvm_run->request_nmi_window &&
+		vcpu->arch.nmi_window_open);
+}
+
 static void post_kvm_run_save(struct kvm_vcpu *vcpu,
 			      struct kvm_run *kvm_run)
 {
 	kvm_run->if_flag = (kvm_x86_ops->get_rflags(vcpu) & X86_EFLAGS_IF) != 0;
 	kvm_run->cr8 = kvm_get_cr8(vcpu);
 	kvm_run->apic_base = kvm_get_apic_base(vcpu);
-	if (irqchip_in_kernel(vcpu->kvm))
+	if (irqchip_in_kernel(vcpu->kvm)) {
 		kvm_run->ready_for_interrupt_injection = 1;
-	else
+		kvm_run->ready_for_nmi_injection = 1;
+	} else {
 		kvm_run->ready_for_interrupt_injection =
 					(vcpu->arch.interrupt_window_open &&
 					 vcpu->arch.irq_summary == 0);
+		kvm_run->ready_for_nmi_injection =
+					(vcpu->arch.nmi_window_open &&
+					 vcpu->arch.nmi_pending == 0);
+	}
 }
 
 static void vapic_enter(struct kvm_vcpu *vcpu)
@@ -2999,6 +3036,11 @@ static int __vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		}
 
 		if (r > 0) {
+			if (dm_request_for_nmi_injection(vcpu, kvm_run)) {
+				r = -EINTR;
+				kvm_run->exit_reason = KVM_EXIT_NMI;
+				++vcpu->stat.request_nmi_exits;
+			}
 			if (dm_request_for_irq_injection(vcpu, kvm_run)) {
 				r = -EINTR;
 				kvm_run->exit_reason = KVM_EXIT_INTR;
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index f18b86f..44fd7fa 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -83,18 +83,22 @@ struct kvm_irqchip {
 #define KVM_EXIT_S390_SIEIC       13
 #define KVM_EXIT_S390_RESET       14
 #define KVM_EXIT_DCR              15
+#define KVM_EXIT_NMI              16
+#define KVM_EXIT_NMI_WINDOW_OPEN  17
 
 /* for KVM_RUN, returned by mmap(vcpu_fd, offset=0) */
 struct kvm_run {
 	/* in */
 	__u8 request_interrupt_window;
-	__u8 padding1[7];
+	__u8 request_nmi_window;
+	__u8 padding1[6];
 
 	/* out */
 	__u32 exit_reason;
 	__u8 ready_for_interrupt_injection;
 	__u8 if_flag;
-	__u8 padding2[2];
+	__u8 ready_for_nmi_injection;
+	__u8 padding2;
 
 	/* in (pre_kvm_run), out (post_kvm_run) */
 	__u64 cr8;
@@ -387,6 +391,7 @@ struct kvm_trace_rec {
 #define KVM_CAP_DEVICE_ASSIGNMENT 17
 #endif
 #define KVM_CAP_IOMMU 18
+#define KVM_CAP_NMI 19
 
 /*
  * ioctls for VM fds
@@ -458,6 +463,8 @@ struct kvm_trace_rec {
 #define KVM_S390_INITIAL_RESET    _IO(KVMIO,  0x97)
 #define KVM_GET_MP_STATE          _IOR(KVMIO,  0x98, struct kvm_mp_state)
 #define KVM_SET_MP_STATE          _IOW(KVMIO,  0x99, struct kvm_mp_state)
+/* Available with KVM_CAP_NMI */
+#define KVM_NMI                   _IO(KVMIO,  0x9a)
 
 #define KVM_TRC_INJ_VIRQ         (KVM_TRC_HANDLER + 0x02)
 #define KVM_TRC_REDELIVER_EVT    (KVM_TRC_HANDLER + 0x03)
-- 
1.6.0.3

