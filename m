Return-Path: <linux-kernel-owner+w=401wt.eu-S1756872AbZFDLMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872AbZFDLMc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 07:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754585AbZFDLMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 07:12:09 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55287 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbZFDLMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 07:12:06 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20090604112.650907584@firstfloor.org>
In-Reply-To: <20090604112.650907584@firstfloor.org>
To: ying.huang@intel.com, avi@redhat.com, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [2/2] KVM: Add VT-x machine check support
Message-Id: <20090604111205.C47C31D0282@basil.firstfloor.org>
Date: Thu,  4 Jun 2009 13:12:05 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[Avi could you please still consider this patch for your 2.6.31 patchqueue?
It's fairly simple, but important to handle memory errors in guests]

VT-x needs an explicit MC vector intercept to handle machine checks in the 
hyper visor.

It also has a special option to catch machine checks that happen
during VT entry.

Do these interceptions and forward them to the Linux machine check
handler. Make it always look like user space is interrupted because
the machine check handler treats kernel/user space differently.

Thanks to Huang Ying and Jiang Yunhong for help and testing.

Cc: ying.huang@intel.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/include/asm/vmx.h |    1 +
 arch/x86/kvm/vmx.c         |   26 ++++++++++++++++++++++++--
 2 files changed, 25 insertions(+), 2 deletions(-)

Index: linux/arch/x86/include/asm/vmx.h
===================================================================
--- linux.orig/arch/x86/include/asm/vmx.h	2009-05-28 10:47:53.000000000 +0200
+++ linux/arch/x86/include/asm/vmx.h	2009-06-04 11:58:49.000000000 +0200
@@ -247,6 +247,7 @@
 #define EXIT_REASON_MSR_READ            31
 #define EXIT_REASON_MSR_WRITE           32
 #define EXIT_REASON_MWAIT_INSTRUCTION   36
+#define EXIT_REASON_MACHINE_CHECK	41
 #define EXIT_REASON_TPR_BELOW_THRESHOLD 43
 #define EXIT_REASON_APIC_ACCESS         44
 #define EXIT_REASON_EPT_VIOLATION       48
Index: linux/arch/x86/kvm/vmx.c
===================================================================
--- linux.orig/arch/x86/kvm/vmx.c	2009-05-28 10:47:53.000000000 +0200
+++ linux/arch/x86/kvm/vmx.c	2009-06-04 12:05:44.000000000 +0200
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
@@ -2585,6 +2586,23 @@
 	return 0;
 }
 
+/*
+ * Trigger machine check on the host. We assume all the MSRs are already set up
+ * by the CPU and that we still run on the same CPU as the MCE occurred on.
+ * We pass a fake environment to the machine check handler because we want
+ * the guest to be always treated like user space, no matter what context
+ * it used internally.
+ */
+static int handle_machine_check(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+{
+	struct pt_regs regs = {
+		.cs = 3, /* Fake ring 3 no matter what the guest ran on */
+		.flags = X86_EFLAGS_IF,
+	};
+	do_machine_check(&regs, 0);
+	return 1;
+}
+
 static int handle_exception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -2596,6 +2614,10 @@
 	vect_info = vmx->idt_vectoring_info;
 	intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
 
+	ex_no = intr_info & INTR_INFO_VECTOR_MASK;
+	if (ex_no == MCE_VECTOR)
+		return handle_machine_check(vcpu, kvm_run);
+
 	if ((vect_info & VECTORING_INFO_VALID_MASK) &&
 						!is_page_fault(intr_info))
 		printk(KERN_ERR "%s: unexpected, vectoring info 0x%x "
@@ -2648,7 +2670,6 @@
 		return 1;
 	}
 
-	ex_no = intr_info & INTR_INFO_VECTOR_MASK;
 	switch (ex_no) {
 	case DB_VECTOR:
 		dr6 = vmcs_readl(EXIT_QUALIFICATION);
@@ -3150,6 +3171,7 @@
 	[EXIT_REASON_WBINVD]                  = handle_wbinvd,
 	[EXIT_REASON_TASK_SWITCH]             = handle_task_switch,
 	[EXIT_REASON_EPT_VIOLATION]	      = handle_ept_violation,
+	[EXIT_REASON_MACHINE_CHECK]	      = handle_machine_check,
 };
 
 static const int kvm_vmx_max_exit_handlers =
