Return-Path: <linux-kernel-owner+w=401wt.eu-S1756817AbZKSNmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817AbZKSNmp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 08:42:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756087AbZKSNmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 08:42:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10352 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753422AbZKSNfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 08:35:08 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 06/35] KVM: VMX: Add support for Pause-Loop Exiting
Date: Thu, 19 Nov 2009 15:34:42 +0200
Message-Id: <1258637711-11674-7-git-send-email-avi@redhat.com>
In-Reply-To: <1258637711-11674-1-git-send-email-avi@redhat.com>
References: <1258637711-11674-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhai, Edwin <edwin.zhai@intel.com>

New NHM processors will support Pause-Loop Exiting by adding 2 VM-execution
control fields:
PLE_Gap    - upper bound on the amount of time between two successive
             executions of PAUSE in a loop.
PLE_Window - upper bound on the amount of time a guest is allowed to execute in
             a PAUSE loop

If the time, between this execution of PAUSE and previous one, exceeds the
PLE_Gap, processor consider this PAUSE belongs to a new loop.
Otherwise, processor determins the the total execution time of this loop(since
1st PAUSE in this loop), and triggers a VM exit if total time exceeds the
PLE_Window.
* Refer SDM volume 3b section 21.6.13 & 22.1.3.

Pause-Loop Exiting can be used to detect Lock-Holder Preemption, where one VP
is sched-out after hold a spinlock, then other VPs for same lock are sched-in
to waste the CPU time.

Our tests indicate that most spinlocks are held for less than 212 cycles.
Performance tests show that with 2X LP over-commitment we can get +2% perf
improvement for kernel build(Even more perf gain with more LPs).

Signed-off-by: Zhai Edwin <edwin.zhai@intel.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/include/asm/vmx.h |    4 +++
 arch/x86/kvm/vmx.c         |   51 +++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 54 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 272514c..2b49454 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -56,6 +56,7 @@
 #define SECONDARY_EXEC_ENABLE_VPID              0x00000020
 #define SECONDARY_EXEC_WBINVD_EXITING		0x00000040
 #define SECONDARY_EXEC_UNRESTRICTED_GUEST	0x00000080
+#define SECONDARY_EXEC_PAUSE_LOOP_EXITING	0x00000400
 
 
 #define PIN_BASED_EXT_INTR_MASK                 0x00000001
@@ -144,6 +145,8 @@ enum vmcs_field {
 	VM_ENTRY_INSTRUCTION_LEN        = 0x0000401a,
 	TPR_THRESHOLD                   = 0x0000401c,
 	SECONDARY_VM_EXEC_CONTROL       = 0x0000401e,
+	PLE_GAP                         = 0x00004020,
+	PLE_WINDOW                      = 0x00004022,
 	VM_INSTRUCTION_ERROR            = 0x00004400,
 	VM_EXIT_REASON                  = 0x00004402,
 	VM_EXIT_INTR_INFO               = 0x00004404,
@@ -248,6 +251,7 @@ enum vmcs_field {
 #define EXIT_REASON_MSR_READ            31
 #define EXIT_REASON_MSR_WRITE           32
 #define EXIT_REASON_MWAIT_INSTRUCTION   36
+#define EXIT_REASON_PAUSE_INSTRUCTION   40
 #define EXIT_REASON_MCE_DURING_VMENTRY	 41
 #define EXIT_REASON_TPR_BELOW_THRESHOLD 43
 #define EXIT_REASON_APIC_ACCESS         44
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 70020e5..a4580d6 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -61,6 +61,25 @@ module_param_named(unrestricted_guest,
 static int __read_mostly emulate_invalid_guest_state = 0;
 module_param(emulate_invalid_guest_state, bool, S_IRUGO);
 
+/*
+ * These 2 parameters are used to config the controls for Pause-Loop Exiting:
+ * ple_gap:    upper bound on the amount of time between two successive
+ *             executions of PAUSE in a loop. Also indicate if ple enabled.
+ *             According to test, this time is usually small than 41 cycles.
+ * ple_window: upper bound on the amount of time a guest is allowed to execute
+ *             in a PAUSE loop. Tests indicate that most spinlocks are held for
+ *             less than 2^12 cycles
+ * Time is measured based on a counter that runs at the same rate as the TSC,
+ * refer SDM volume 3b section 21.6.13 & 22.1.3.
+ */
+#define KVM_VMX_DEFAULT_PLE_GAP    41
+#define KVM_VMX_DEFAULT_PLE_WINDOW 4096
+static int ple_gap = KVM_VMX_DEFAULT_PLE_GAP;
+module_param(ple_gap, int, S_IRUGO);
+
+static int ple_window = KVM_VMX_DEFAULT_PLE_WINDOW;
+module_param(ple_window, int, S_IRUGO);
+
 struct vmcs {
 	u32 revision_id;
 	u32 abort;
@@ -319,6 +338,12 @@ static inline int cpu_has_vmx_unrestricted_guest(void)
 		SECONDARY_EXEC_UNRESTRICTED_GUEST;
 }
 
+static inline int cpu_has_vmx_ple(void)
+{
+	return vmcs_config.cpu_based_2nd_exec_ctrl &
+		SECONDARY_EXEC_PAUSE_LOOP_EXITING;
+}
+
 static inline int vm_need_virtualize_apic_accesses(struct kvm *kvm)
 {
 	return flexpriority_enabled &&
@@ -1240,7 +1265,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf)
 			SECONDARY_EXEC_WBINVD_EXITING |
 			SECONDARY_EXEC_ENABLE_VPID |
 			SECONDARY_EXEC_ENABLE_EPT |
-			SECONDARY_EXEC_UNRESTRICTED_GUEST;
+			SECONDARY_EXEC_UNRESTRICTED_GUEST |
+			SECONDARY_EXEC_PAUSE_LOOP_EXITING;
 		if (adjust_vmx_controls(min2, opt2,
 					MSR_IA32_VMX_PROCBASED_CTLS2,
 					&_cpu_based_2nd_exec_control) < 0)
@@ -1386,6 +1412,9 @@ static __init int hardware_setup(void)
 	if (enable_ept && !cpu_has_vmx_ept_2m_page())
 		kvm_disable_largepages();
 
+	if (!cpu_has_vmx_ple())
+		ple_gap = 0;
+
 	return alloc_kvm_area();
 }
 
@@ -2298,9 +2327,16 @@ static int vmx_vcpu_setup(struct vcpu_vmx *vmx)
 			exec_control &= ~SECONDARY_EXEC_ENABLE_EPT;
 		if (!enable_unrestricted_guest)
 			exec_control &= ~SECONDARY_EXEC_UNRESTRICTED_GUEST;
+		if (!ple_gap)
+			exec_control &= ~SECONDARY_EXEC_PAUSE_LOOP_EXITING;
 		vmcs_write32(SECONDARY_VM_EXEC_CONTROL, exec_control);
 	}
 
+	if (ple_gap) {
+		vmcs_write32(PLE_GAP, ple_gap);
+		vmcs_write32(PLE_WINDOW, ple_window);
+	}
+
 	vmcs_write32(PAGE_FAULT_ERROR_CODE_MASK, !!bypass_guest_pf);
 	vmcs_write32(PAGE_FAULT_ERROR_CODE_MATCH, !!bypass_guest_pf);
 	vmcs_write32(CR3_TARGET_COUNT, 0);           /* 22.2.1 */
@@ -3348,6 +3384,18 @@ out:
 }
 
 /*
+ * Indicate a busy-waiting vcpu in spinlock. We do not enable the PAUSE
+ * exiting, so only get here on cpu with PAUSE-Loop-Exiting.
+ */
+static int handle_pause(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+{
+	skip_emulated_instruction(vcpu);
+	kvm_vcpu_on_spin(vcpu);
+
+	return 1;
+}
+
+/*
  * The exit handlers return 1 if the exit was handled fully and guest execution
  * may resume.  Otherwise they set the kvm_run parameter to indicate what needs
  * to be done to userspace and return 0.
@@ -3383,6 +3431,7 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[EXIT_REASON_MCE_DURING_VMENTRY]      = handle_machine_check,
 	[EXIT_REASON_EPT_VIOLATION]	      = handle_ept_violation,
 	[EXIT_REASON_EPT_MISCONFIG]           = handle_ept_misconfig,
+	[EXIT_REASON_PAUSE_INSTRUCTION]       = handle_pause,
 };
 
 static const int kvm_vmx_max_exit_handlers =
-- 
1.6.5.2

