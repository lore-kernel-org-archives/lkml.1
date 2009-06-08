Return-Path: <linux-kernel-owner+w=401wt.eu-S1753769AbZFHJhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769AbZFHJhX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 05:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753188AbZFHJhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 05:37:10 -0400
Received: from mga09.intel.com ([134.134.136.24]:42895 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752966AbZFHJhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 05:37:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,323,1241420400"; 
   d="scan'208";a="522580168"
Subject: [PATCH -v4] KVM: Add VT-x machine check support
From: Huang Ying <ying.huang@intel.com>
To: "avi@redhat.com" <avi@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain
Date: Mon, 08 Jun 2009 17:37:09 +0800
Message-Id: <1244453829.8361.602.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

VT-x needs an explicit MC vector intercept to handle machine checks in the 
hyper visor.

It also has a special option to catch machine checks that happen
during VT entry.

Do these interceptions and forward them to the Linux machine check
handler. Make it always look like user space is interrupted because
the machine check handler treats kernel/user space differently.

Thanks to Jiang Yunhong for help and testing.

v4: move exit_reason to struct vcpu_vmx, add is_machine_check()

v3: Rebased on kvm.git

v2: Handle machine checks still in interrupt off context
to avoid problems on preemptible kernels.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/include/asm/vmx.h          |    1 
 arch/x86/kernel/cpu/mcheck/mce_64.c |    1 
 arch/x86/kvm/vmx.c                  |   47 ++++++++++++++++++++++++++++++++++--
 3 files changed, 47 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -247,6 +247,7 @@ enum vmcs_field {
 #define EXIT_REASON_MSR_READ            31
 #define EXIT_REASON_MSR_WRITE           32
 #define EXIT_REASON_MWAIT_INSTRUCTION   36
+#define EXIT_REASON_MCE_DURING_VMENTRY	 41
 #define EXIT_REASON_TPR_BELOW_THRESHOLD 43
 #define EXIT_REASON_APIC_ACCESS         44
 #define EXIT_REASON_EPT_VIOLATION       48
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -32,6 +32,7 @@
 #include <asm/desc.h>
 #include <asm/vmx.h>
 #include <asm/virtext.h>
+#include <asm/mce.h>
 
 #define __ex(x) __kvm_handle_fault_on_reboot(x)
 
@@ -97,6 +98,7 @@ struct vcpu_vmx {
 	int soft_vnmi_blocked;
 	ktime_t entry_time;
 	s64 vnmi_blocked_time;
+	u32 exit_reason;
 };
 
 static inline struct vcpu_vmx *to_vmx(struct kvm_vcpu *vcpu)
@@ -216,6 +218,13 @@ static inline int is_external_interrupt(
 		== (INTR_TYPE_EXT_INTR | INTR_INFO_VALID_MASK);
 }
 
+static inline int is_machine_check(u32 intr_info)
+{
+	return (intr_info & (INTR_INFO_INTR_TYPE_MASK | INTR_INFO_VECTOR_MASK |
+			     INTR_INFO_VALID_MASK)) ==
+		(INTR_TYPE_HARD_EXCEPTION | MC_VECTOR | INTR_INFO_VALID_MASK);
+}
+
 static inline int cpu_has_vmx_msr_bitmap(void)
 {
 	return vmcs_config.cpu_based_exec_ctrl & CPU_BASED_USE_MSR_BITMAPS;
@@ -487,7 +496,7 @@ static void update_exception_bitmap(stru
 {
 	u32 eb;
 
-	eb = (1u << PF_VECTOR) | (1u << UD_VECTOR);
+	eb = (1u << PF_VECTOR) | (1u << UD_VECTOR) | (1u << MC_VECTOR);
 	if (!vcpu->fpu_active)
 		eb |= 1u << NM_VECTOR;
 	if (vcpu->guest_debug & KVM_GUESTDBG_ENABLE) {
@@ -2605,6 +2614,29 @@ static int handle_rmode_exception(struct
 	return 0;
 }
 
+/*
+ * Trigger machine check on the host. We assume all the MSRs are already set up
+ * by the CPU and that we still run on the same CPU as the MCE occurred on.
+ * We pass a fake environment to the machine check handler because we want
+ * the guest to be always treated like user space, no matter what context
+ * it used internally.
+ */
+static void kvm_machine_check(void)
+{
+	struct pt_regs regs = {
+		.cs = 3, /* Fake ring 3 no matter what the guest ran on */
+		.flags = X86_EFLAGS_IF,
+	};
+
+	do_machine_check(&regs, 0);
+}
+
+static int handle_machine_check(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+{
+	/* already handled by vcpu_run */
+	return 1;
+}
+
 static int handle_exception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -2616,6 +2648,9 @@ static int handle_exception(struct kvm_v
 	vect_info = vmx->idt_vectoring_info;
 	intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
 
+	if (is_machine_check(intr_info))
+		return handle_machine_check(vcpu, kvm_run);
+
 	if ((vect_info & VECTORING_INFO_VALID_MASK) &&
 						!is_page_fault(intr_info))
 		printk(KERN_ERR "%s: unexpected, vectoring info 0x%x "
@@ -3189,6 +3224,7 @@ static int (*kvm_vmx_exit_handlers[])(st
 	[EXIT_REASON_WBINVD]                  = handle_wbinvd,
 	[EXIT_REASON_TASK_SWITCH]             = handle_task_switch,
 	[EXIT_REASON_EPT_VIOLATION]	      = handle_ept_violation,
+	[EXIT_REASON_MCE_DURING_VMENTRY]      = handle_machine_check,
 };
 
 static const int kvm_vmx_max_exit_handlers =
@@ -3200,8 +3236,8 @@ static const int kvm_vmx_max_exit_handle
  */
 static int vmx_handle_exit(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
 {
-	u32 exit_reason = vmcs_read32(VM_EXIT_REASON);
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	u32 exit_reason = vmx->exit_reason;
 	u32 vectoring_info = vmx->idt_vectoring_info;
 
 	KVMTRACE_3D(VMEXIT, vcpu, exit_reason, (u32)kvm_rip_read(vcpu),
@@ -3284,6 +3320,13 @@ static void vmx_complete_interrupts(stru
 
 	exit_intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
 
+	vmx->exit_reason = vmcs_read32(VM_EXIT_REASON);
+
+	/* Handle machine checks before interrupts are enabled */
+	if ((vmx->exit_reason == EXIT_REASON_MCE_DURING_VMENTRY) ||
+	    is_machine_check(exit_intr_info))
+		kvm_machine_check();
+
 	/* We need to handle NMIs before interrupts are enabled */
 	if ((exit_intr_info & INTR_INFO_INTR_TYPE_MASK) == INTR_TYPE_NMI_INTR &&
 	    (exit_intr_info & INTR_INFO_VALID_MASK)) {
--- a/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -420,6 +420,7 @@ void do_machine_check(struct pt_regs * r
  out2:
 	atomic_dec(&mce_entry);
 }
+EXPORT_SYMBOL_GPL(do_machine_check);
 
 #ifdef CONFIG_X86_MCE_INTEL
 /***


