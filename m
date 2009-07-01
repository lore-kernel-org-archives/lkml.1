Return-Path: <linux-kernel-owner+w=401wt.eu-S1755047AbZGANYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047AbZGANYi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 09:24:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752239AbZGANYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 09:24:30 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57300 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbZGANYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 09:24:30 -0400
To: Avi Kivity <avi@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>, Greg KH <gregkh@suse.de>,
       Stefan Lippers-Hollmann <s.L-H@gmx.de>, linux-kernel@vger.kernel.org,
       ying.huang@intel.com, stable@kernel.org
Subject: Re: patch kvm-add-vt-x-machine-check-support.patch added to	2.6.30-stable tree
From: Andi Kleen <andi@firstfloor.org>
References: <20090629184144.76C9948FD3@coco.kroah.org>
	<200907010053.40900.s.L-H@gmx.de> <20090630234206.GA22546@suse.de>
	<4A4B0BB1.2010102@linux.intel.com> <4A4B11A6.6080402@redhat.com>
Date: Wed, 01 Jul 2009 15:24:29 +0200
In-Reply-To: <4A4B11A6.6080402@redhat.com> (Avi Kivity's message of "Wed, 01 Jul 2009 10:35:02 +0300")
Message-ID: <87d48kiliq.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity <avi@redhat.com> writes:

> On 07/01/2009 10:09 AM, Andi Kleen wrote:
>>
>>> Thanks, I was building without kvm enabled in my configs and missed this
>>> one.
>>>
>>> I've added these two other patches and everything looks better.
>>
>> If you prefer I also have an original patch which didn't depend on any
>> other KVM patches. But the other ones look harmless enough and it's
>> probably
>> better to stay nearer mainline.
>
> I'd prefer your standalone patch Andi.  Patches often look harmless
> but aren't, and I'd hate to introduce regressions into 2.6.30.*.

Here's the 2.6.30 standalone patch, slightly updated.

-Andi

---

KVM: Add VT-x machine check support v3

VT-x needs an explicit MC vector intercept to handle machine checks in the 
hypervisor.

It also has a special option to catch machine checks that happen
during VT entry.

Do these interceptions and forward them to the Linux machine check
handler. Make it always look like user space is interrupted because
the machine check handler treats kernel/user space differently.

Thanks to Huang Ying and Jiang Yunhong for help and testing.

Cc: ying.huang@intel.com

v2: Handle machine checks still in interrupt off context
to avoid problems on preemptible kernels.
v3: Handle old style 32bit and make fully standalone

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/include/asm/kvm_host.h     |    2 +
 arch/x86/include/asm/mce.h          |    2 +
 arch/x86/include/asm/vmx.h          |    1 
 arch/x86/kernel/cpu/mcheck/mce_32.c |    1 
 arch/x86/kernel/cpu/mcheck/mce_64.c |    1 
 arch/x86/kvm/vmx.c                  |   47 +++++++++++++++++++++++++++++++++---
 6 files changed, 51 insertions(+), 3 deletions(-)

Index: linux-2.6.30-ak/arch/x86/include/asm/vmx.h
===================================================================
--- linux-2.6.30-ak.orig/arch/x86/include/asm/vmx.h
+++ linux-2.6.30-ak/arch/x86/include/asm/vmx.h
@@ -247,6 +247,7 @@ enum vmcs_field {
 #define EXIT_REASON_MSR_READ            31
 #define EXIT_REASON_MSR_WRITE           32
 #define EXIT_REASON_MWAIT_INSTRUCTION   36
+#define EXIT_REASON_MCE_DURING_VMENTRY	 41
 #define EXIT_REASON_TPR_BELOW_THRESHOLD 43
 #define EXIT_REASON_APIC_ACCESS         44
 #define EXIT_REASON_EPT_VIOLATION       48
Index: linux-2.6.30-ak/arch/x86/kvm/vmx.c
===================================================================
--- linux-2.6.30-ak.orig/arch/x86/kvm/vmx.c
+++ linux-2.6.30-ak/arch/x86/kvm/vmx.c
@@ -32,6 +32,7 @@
 #include <asm/desc.h>
 #include <asm/vmx.h>
 #include <asm/virtext.h>
+#include <asm/mce.h>
 
 #define __ex(x) __kvm_handle_fault_on_reboot(x)
 
@@ -478,7 +479,7 @@ static void update_exception_bitmap(stru
 {
 	u32 eb;
 
-	eb = (1u << PF_VECTOR) | (1u << UD_VECTOR);
+	eb = (1u << PF_VECTOR) | (1u << UD_VECTOR) | (1u << MC_VECTOR);
 	if (!vcpu->fpu_active)
 		eb |= 1u << NM_VECTOR;
 	if (vcpu->guest_debug & KVM_GUESTDBG_ENABLE) {
@@ -2585,6 +2586,35 @@ static int handle_rmode_exception(struct
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
+#ifdef CONFIG_X86_MCE
+	struct pt_regs regs = {
+		.cs = 3, /* Fake ring 3 no matter what the guest ran on */
+		.flags = X86_EFLAGS_IF,
+	};
+
+#ifdef CONFIG_X86_64
+	do_machine_check(&regs, 0);
+#else
+	machine_check_vector(&regs, 0);
+#endif
+#endif
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
@@ -2596,6 +2626,10 @@ static int handle_exception(struct kvm_v
 	vect_info = vmx->idt_vectoring_info;
 	intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
 
+	ex_no = intr_info & INTR_INFO_VECTOR_MASK;
+	if (ex_no == MC_VECTOR)
+		return handle_machine_check(vcpu, kvm_run);
+
 	if ((vect_info & VECTORING_INFO_VALID_MASK) &&
 						!is_page_fault(intr_info))
 		printk(KERN_ERR "%s: unexpected, vectoring info 0x%x "
@@ -2648,7 +2682,6 @@ static int handle_exception(struct kvm_v
 		return 1;
 	}
 
-	ex_no = intr_info & INTR_INFO_VECTOR_MASK;
 	switch (ex_no) {
 	case DB_VECTOR:
 		dr6 = vmcs_readl(EXIT_QUALIFICATION);
@@ -3150,6 +3183,7 @@ static int (*kvm_vmx_exit_handlers[])(st
 	[EXIT_REASON_WBINVD]                  = handle_wbinvd,
 	[EXIT_REASON_TASK_SWITCH]             = handle_task_switch,
 	[EXIT_REASON_EPT_VIOLATION]	      = handle_ept_violation,
+	[EXIT_REASON_MCE_DURING_VMENTRY]      = handle_machine_check,
 };
 
 static const int kvm_vmx_max_exit_handlers =
@@ -3161,7 +3195,7 @@ static const int kvm_vmx_max_exit_handle
  */
 static int kvm_handle_exit(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
 {
-	u32 exit_reason = vmcs_read32(VM_EXIT_REASON);
+	u32 exit_reason = vcpu->arch.exit_reason;
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	u32 vectoring_info = vmx->idt_vectoring_info;
 
@@ -3512,6 +3546,13 @@ static void vmx_vcpu_run(struct kvm_vcpu
 
 	intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
 
+	vcpu->arch.exit_reason = vmcs_read32(VM_EXIT_REASON);
+
+	/* Handle machine checks before interrupts are enabled */
+	if ((vcpu->arch.exit_reason == EXIT_REASON_MCE_DURING_VMENTRY) ||
+		(intr_info & INTR_INFO_VECTOR_MASK) == MC_VECTOR)
+		kvm_machine_check();
+
 	/* We need to handle NMIs before interrupts are enabled */
 	if ((intr_info & INTR_INFO_INTR_TYPE_MASK) == INTR_TYPE_NMI_INTR &&
 	    (intr_info & INTR_INFO_VALID_MASK)) {
Index: linux-2.6.30-ak/arch/x86/include/asm/kvm_host.h
===================================================================
--- linux-2.6.30-ak.orig/arch/x86/include/asm/kvm_host.h
+++ linux-2.6.30-ak/arch/x86/include/asm/kvm_host.h
@@ -371,6 +371,8 @@ struct kvm_vcpu_arch {
 	unsigned long dr6;
 	unsigned long dr7;
 	unsigned long eff_db[KVM_NR_DB_REGS];
+
+	u32 exit_reason;
 };
 
 struct kvm_mem_alias {
Index: linux-2.6.30-ak/arch/x86/include/asm/mce.h
===================================================================
--- linux-2.6.30-ak.orig/arch/x86/include/asm/mce.h
+++ linux-2.6.30-ak/arch/x86/include/asm/mce.h
@@ -153,5 +153,7 @@ extern void mcheck_init(struct cpuinfo_x
 
 extern void (*mce_threshold_vector)(void);
 
+extern void (*machine_check_vector)(struct pt_regs *, long error_code);
+
 #endif /* __KERNEL__ */
 #endif /* _ASM_X86_MCE_H */
Index: linux-2.6.30-ak/arch/x86/kernel/cpu/mcheck/mce_32.c
===================================================================
--- linux-2.6.30-ak.orig/arch/x86/kernel/cpu/mcheck/mce_32.c
+++ linux-2.6.30-ak/arch/x86/kernel/cpu/mcheck/mce_32.c
@@ -29,6 +29,7 @@ static void unexpected_machine_check(str
 
 /* Call the installed machine check handler for this CPU setup. */
 void (*machine_check_vector)(struct pt_regs *, long error_code) = unexpected_machine_check;
+EXPORT_SYMBOL_GPL(machine_check_vector);
 
 /* This has to be run for each processor */
 void mcheck_init(struct cpuinfo_x86 *c)
Index: linux-2.6.30-ak/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux-2.6.30-ak.orig/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ linux-2.6.30-ak/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -420,6 +420,7 @@ void do_machine_check(struct pt_regs * r
  out2:
 	atomic_dec(&mce_entry);
 }
+EXPORT_SYMBOL_GPL(do_machine_check);
 
 #ifdef CONFIG_X86_MCE_INTEL
 /***


-- 
ak@linux.intel.com -- Speaking for myself only.
