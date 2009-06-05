Return-Path: <linux-kernel-owner+w=401wt.eu-S1753382AbZFEXYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbZFEXYQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 19:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752641AbZFEXYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 19:24:01 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53258 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbZFEXYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 19:24:00 -0400
Date: Sat, 6 Jun 2009 01:23:56 +0200
From: Andi Kleen <andi@firstfloor.org>
To: avi@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       ying.huang@intel.com
Subject: [PATCH] KVM: Add VT-x machine check support v2
Message-ID: <20090605232356.GA7091@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sorry took a bit longer to do this, had some trouble with my test rig.
This addresses the preemptible kernel problem discussed earlier. I tried
to not add more vmcb reads, so I'm caching the exit_reason in memory
over callbacks.

Note I'm on offline for some time, if there further issues please
contact Ying Huang (cc'ed)

-Andi

---

KVM: Add VT-x machine check support v2

VT-x needs an explicit MC vector intercept to handle machine checks in the 
hyper visor.

It also has a special option to catch machine checks that happen
during VT entry.

Do these interceptions and forward them to the Linux machine check
handler. Make it always look like user space is interrupted because
the machine check handler treats kernel/user space differently.

Thanks to Huang Ying and Jiang Yunhong for help and testing.

Cc: ying.huang@intel.com

v2: Handle machine checks still in interrupt off context
to avoid problems on preemptible kernels.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/include/asm/kvm_host.h |    2 +
 arch/x86/include/asm/vmx.h      |    1 
 arch/x86/kvm/vmx.c              |   41 +++++++++++++++++++++++++++++++++++++---
 3 files changed, 41 insertions(+), 3 deletions(-)

Index: linux/arch/x86/include/asm/vmx.h
===================================================================
--- linux.orig/arch/x86/include/asm/vmx.h	2009-06-04 16:12:31.000000000 +0200
+++ linux/arch/x86/include/asm/vmx.h	2009-06-04 16:12:58.000000000 +0200
@@ -247,6 +247,7 @@
 #define EXIT_REASON_MSR_READ            31
 #define EXIT_REASON_MSR_WRITE           32
 #define EXIT_REASON_MWAIT_INSTRUCTION   36
+#define EXIT_REASON_MCE_DURING_VMENTRY	 41
 #define EXIT_REASON_TPR_BELOW_THRESHOLD 43
 #define EXIT_REASON_APIC_ACCESS         44
 #define EXIT_REASON_EPT_VIOLATION       48
Index: linux/arch/x86/kvm/vmx.c
===================================================================
--- linux.orig/arch/x86/kvm/vmx.c	2009-06-04 16:12:51.000000000 +0200
+++ linux/arch/x86/kvm/vmx.c	2009-06-04 16:40:58.000000000 +0200
@@ -32,6 +32,7 @@
 #include <asm/desc.h>
 #include <asm/vmx.h>
 #include <asm/virtext.h>
+#include <asm/mce.h>
 
 #define __ex(x) __kvm_handle_fault_on_reboot(x)
 
@@ -478,7 +479,7 @@
 {
 	u32 eb;
 
-	eb = (1u << PF_VECTOR) | (1u << UD_VECTOR);
+	eb = (1u << PF_VECTOR) | (1u << UD_VECTOR) | (1u << MC_VECTOR);
 	if (!vcpu->fpu_active)
 		eb |= 1u << NM_VECTOR;
 	if (vcpu->guest_debug & KVM_GUESTDBG_ENABLE) {
@@ -2585,6 +2586,29 @@
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
@@ -2596,6 +2620,10 @@
 	vect_info = vmx->idt_vectoring_info;
 	intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
 
+	ex_no = intr_info & INTR_INFO_VECTOR_MASK;
+	if (ex_no == MCE_VECTOR)
+		return handle_machine_check(vcpu, kvm_run);
+
 	if ((vect_info & VECTORING_INFO_VALID_MASK) &&
 						!is_page_fault(intr_info))
 		printk(KERN_ERR "%s: unexpected, vectoring info 0x%x "
@@ -2648,7 +2676,6 @@
 		return 1;
 	}
 
-	ex_no = intr_info & INTR_INFO_VECTOR_MASK;
 	switch (ex_no) {
 	case DB_VECTOR:
 		dr6 = vmcs_readl(EXIT_QUALIFICATION);
@@ -3150,6 +3177,7 @@
 	[EXIT_REASON_WBINVD]                  = handle_wbinvd,
 	[EXIT_REASON_TASK_SWITCH]             = handle_task_switch,
 	[EXIT_REASON_EPT_VIOLATION]	      = handle_ept_violation,
+	[EXIT_REASON_MCE_DURING_VMENTRY]      = handle_machine_check,
 };
 
 static const int kvm_vmx_max_exit_handlers =
@@ -3161,7 +3189,7 @@
  */
 static int kvm_handle_exit(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
 {
-	u32 exit_reason = vmcs_read32(VM_EXIT_REASON);
+	u32 exit_reason = vcpu->arch.exit_reason;
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	u32 vectoring_info = vmx->idt_vectoring_info;
 
@@ -3512,6 +3540,13 @@
 
 	intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
 
+	vcpu->arch.exit_reason = vmcs_read32(VM_EXIT_REASON);
+
+	/* Handle machine checks before interrupts are enabled */
+	if ((vcpu->arch.exit_reason == EXIT_REASON_MCE_DURING_VMENTRY) ||
+		(intr_info & INTR_INFO_VECTOR_MASK) == MCE_VECTOR)
+		kvm_machine_check();
+
 	/* We need to handle NMIs before interrupts are enabled */
 	if ((intr_info & INTR_INFO_INTR_TYPE_MASK) == INTR_TYPE_NMI_INTR &&
 	    (intr_info & INTR_INFO_VALID_MASK)) {
Index: linux/arch/x86/include/asm/kvm_host.h
===================================================================
--- linux.orig/arch/x86/include/asm/kvm_host.h	2009-06-04 16:12:31.000000000 +0200
+++ linux/arch/x86/include/asm/kvm_host.h	2009-06-04 16:15:20.000000000 +0200
@@ -371,6 +371,8 @@
 	unsigned long dr6;
 	unsigned long dr7;
 	unsigned long eff_db[KVM_NR_DB_REGS];
+
+	u32 exit_reason;
 };
 
 struct kvm_mem_alias {
