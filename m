Return-Path: <linux-kernel-owner+w=401wt.eu-S1754289AbYLHLmD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289AbYLHLmD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 06:42:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753469AbYLHLhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 06:37:35 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48256 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753300AbYLHLhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 06:37:04 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jan Kiszka <jan.kiszka@siemens.com>
Subject: [PATCH 14/45] KVM: VMX: work around lacking VNMI support
Date: Mon,  8 Dec 2008 13:36:25 +0200
Message-Id: <1228736216-15787-15-git-send-email-avi@redhat.com>
In-Reply-To: <1228736216-15787-1-git-send-email-avi@redhat.com>
References: <1228736216-15787-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

Older VMX supporting CPUs do not provide the "Virtual NMI" feature for
tracking the NMI-blocked state after injecting such events. For now
KVM is unable to inject NMIs on those CPUs.

Derived from Sheng Yang's suggestion to use the IRQ window notification
for detecting the end of NMI handlers, this patch implements virtual
NMI support without impact on the host's ability to receive real NMIs.
The downside is that the given approach requires some heuristics that
can cause NMI nesting in vary rare corner cases.

The approach works as follows:
 - inject NMI and set a software-based NMI-blocked flag
 - arm the IRQ window start notification whenever an NMI window is
   requested
 - if the guest exits due to an opening IRQ window, clear the emulated
   NMI-blocked flag
 - if the guest net execution time with NMI-blocked but without an IRQ
   window exceeds 1 second, force NMI-blocked reset and inject anyway

This approach covers most practical scenarios:
 - succeeding NMIs are seperated by at least one open IRQ window
 - the guest may spin with IRQs disabled (e.g. due to a bug), but
   leaving the NMI handler takes much less time than one second
 - the guest does not rely on strict ordering or timing of NMIs
   (would be problematic in virtualized environments anyway)

Successfully tested with the 'nmi n' monitor command, the kgdbts
testsuite on smp guests (additional patches required to add debug
register support to kvm) + the kernel's nmi_watchdog=1, and a Siemens-
specific board emulation (+ guest) that comes with its own NMI
watchdog mechanism.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/vmx.c |  174 ++++++++++++++++++++++++++++++++++------------------
 1 files changed, 115 insertions(+), 59 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index f16a62c..2180109 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -90,6 +90,11 @@ struct vcpu_vmx {
 	} rmode;
 	int vpid;
 	bool emulation_required;
+
+	/* Support for vnmi-less CPUs */
+	int soft_vnmi_blocked;
+	ktime_t entry_time;
+	s64 vnmi_blocked_time;
 };
 
 static inline struct vcpu_vmx *to_vmx(struct kvm_vcpu *vcpu)
@@ -2230,6 +2235,8 @@ static int vmx_vcpu_reset(struct kvm_vcpu *vcpu)
 
 	vmx->vcpu.arch.rmode.active = 0;
 
+	vmx->soft_vnmi_blocked = 0;
+
 	vmx->vcpu.arch.regs[VCPU_REGS_RDX] = get_rdx_init_val();
 	kvm_set_cr8(&vmx->vcpu, 0);
 	msr = 0xfee00000 | MSR_IA32_APICBASE_ENABLE;
@@ -2335,6 +2342,29 @@ out:
 	return ret;
 }
 
+static void enable_irq_window(struct kvm_vcpu *vcpu)
+{
+	u32 cpu_based_vm_exec_control;
+
+	cpu_based_vm_exec_control = vmcs_read32(CPU_BASED_VM_EXEC_CONTROL);
+	cpu_based_vm_exec_control |= CPU_BASED_VIRTUAL_INTR_PENDING;
+	vmcs_write32(CPU_BASED_VM_EXEC_CONTROL, cpu_based_vm_exec_control);
+}
+
+static void enable_nmi_window(struct kvm_vcpu *vcpu)
+{
+	u32 cpu_based_vm_exec_control;
+
+	if (!cpu_has_virtual_nmis()) {
+		enable_irq_window(vcpu);
+		return;
+	}
+
+	cpu_based_vm_exec_control = vmcs_read32(CPU_BASED_VM_EXEC_CONTROL);
+	cpu_based_vm_exec_control |= CPU_BASED_VIRTUAL_NMI_PENDING;
+	vmcs_write32(CPU_BASED_VM_EXEC_CONTROL, cpu_based_vm_exec_control);
+}
+
 static void vmx_inject_irq(struct kvm_vcpu *vcpu, int irq)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -2360,6 +2390,19 @@ static void vmx_inject_nmi(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
+	if (!cpu_has_virtual_nmis()) {
+		/*
+		 * Tracking the NMI-blocked state in software is built upon
+		 * finding the next open IRQ window. This, in turn, depends on
+		 * well-behaving guests: They have to keep IRQs disabled at
+		 * least as long as the NMI handler runs. Otherwise we may
+		 * cause NMI nesting, maybe breaking the guest. But as this is
+		 * highly unlikely, we can live with the residual risk.
+		 */
+		vmx->soft_vnmi_blocked = 1;
+		vmx->vnmi_blocked_time = 0;
+	}
+
 	++vcpu->stat.nmi_injections;
 	if (vcpu->arch.rmode.active) {
 		vmx->rmode.irq.pending = true;
@@ -2384,6 +2427,8 @@ static void vmx_update_window_states(struct kvm_vcpu *vcpu)
 		!(guest_intr & (GUEST_INTR_STATE_STI |
 				GUEST_INTR_STATE_MOV_SS |
 				GUEST_INTR_STATE_NMI));
+	if (!cpu_has_virtual_nmis() && to_vmx(vcpu)->soft_vnmi_blocked)
+		vcpu->arch.nmi_window_open = 0;
 
 	vcpu->arch.interrupt_window_open =
 		((vmcs_readl(GUEST_RFLAGS) & X86_EFLAGS_IF) &&
@@ -2403,55 +2448,31 @@ static void kvm_do_inject_irq(struct kvm_vcpu *vcpu)
 	kvm_queue_interrupt(vcpu, irq);
 }
 
-static void enable_irq_window(struct kvm_vcpu *vcpu)
-{
-	u32 cpu_based_vm_exec_control;
-
-	cpu_based_vm_exec_control = vmcs_read32(CPU_BASED_VM_EXEC_CONTROL);
-	cpu_based_vm_exec_control |= CPU_BASED_VIRTUAL_INTR_PENDING;
-	vmcs_write32(CPU_BASED_VM_EXEC_CONTROL, cpu_based_vm_exec_control);
-}
-
-static void enable_nmi_window(struct kvm_vcpu *vcpu)
-{
-	u32 cpu_based_vm_exec_control;
-
-	if (!cpu_has_virtual_nmis())
-		return;
-
-	cpu_based_vm_exec_control = vmcs_read32(CPU_BASED_VM_EXEC_CONTROL);
-	cpu_based_vm_exec_control |= CPU_BASED_VIRTUAL_NMI_PENDING;
-	vmcs_write32(CPU_BASED_VM_EXEC_CONTROL, cpu_based_vm_exec_control);
-}
-
 static void do_interrupt_requests(struct kvm_vcpu *vcpu,
 				       struct kvm_run *kvm_run)
 {
 	vmx_update_window_states(vcpu);
 
-	if (cpu_has_virtual_nmis()) {
-		if (vcpu->arch.nmi_pending && !vcpu->arch.nmi_injected) {
-			if (vcpu->arch.nmi_window_open) {
-				vcpu->arch.nmi_pending = false;
-				vcpu->arch.nmi_injected = true;
-			} else {
-				enable_nmi_window(vcpu);
-				return;
-			}
-		}
-		if (vcpu->arch.nmi_injected) {
-			vmx_inject_nmi(vcpu);
-			if (vcpu->arch.nmi_pending
-			    || kvm_run->request_nmi_window)
-				enable_nmi_window(vcpu);
-			else if (vcpu->arch.irq_summary
-				 || kvm_run->request_interrupt_window)
-				enable_irq_window(vcpu);
+	if (vcpu->arch.nmi_pending && !vcpu->arch.nmi_injected) {
+		if (vcpu->arch.nmi_window_open) {
+			vcpu->arch.nmi_pending = false;
+			vcpu->arch.nmi_injected = true;
+		} else {
+			enable_nmi_window(vcpu);
 			return;
 		}
-		if (!vcpu->arch.nmi_window_open || kvm_run->request_nmi_window)
+	}
+	if (vcpu->arch.nmi_injected) {
+		vmx_inject_nmi(vcpu);
+		if (vcpu->arch.nmi_pending || kvm_run->request_nmi_window)
 			enable_nmi_window(vcpu);
+		else if (vcpu->arch.irq_summary
+			 || kvm_run->request_interrupt_window)
+			enable_irq_window(vcpu);
+		return;
 	}
+	if (!vcpu->arch.nmi_window_open || kvm_run->request_nmi_window)
+		enable_nmi_window(vcpu);
 
 	if (vcpu->arch.interrupt_window_open) {
 		if (vcpu->arch.irq_summary && !vcpu->arch.interrupt.pending)
@@ -3097,6 +3118,37 @@ static int kvm_handle_exit(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
 		printk(KERN_WARNING "%s: unexpected, valid vectoring info "
 		       "(0x%x) and exit reason is 0x%x\n",
 		       __func__, vectoring_info, exit_reason);
+
+	if (unlikely(!cpu_has_virtual_nmis() && vmx->soft_vnmi_blocked)) {
+		if (vcpu->arch.interrupt_window_open) {
+			vmx->soft_vnmi_blocked = 0;
+			vcpu->arch.nmi_window_open = 1;
+		} else if (vmx->vnmi_blocked_time > 1000000000LL &&
+		    (kvm_run->request_nmi_window || vcpu->arch.nmi_pending)) {
+			/*
+			 * This CPU don't support us in finding the end of an
+			 * NMI-blocked window if the guest runs with IRQs
+			 * disabled. So we pull the trigger after 1 s of
+			 * futile waiting, but inform the user about this.
+			 */
+			printk(KERN_WARNING "%s: Breaking out of NMI-blocked "
+			       "state on VCPU %d after 1 s timeout\n",
+			       __func__, vcpu->vcpu_id);
+			vmx->soft_vnmi_blocked = 0;
+			vmx->vcpu.arch.nmi_window_open = 1;
+		}
+
+		/*
+		 * If the user space waits to inject an NNI, exit ASAP
+		 */
+		if (vcpu->arch.nmi_window_open && kvm_run->request_nmi_window
+		    && !vcpu->arch.nmi_pending) {
+			kvm_run->exit_reason = KVM_EXIT_NMI_WINDOW_OPEN;
+			++vcpu->stat.nmi_window_exits;
+			return 0;
+		}
+	}
+
 	if (exit_reason < kvm_vmx_max_exit_handlers
 	    && kvm_vmx_exit_handlers[exit_reason])
 		return kvm_vmx_exit_handlers[exit_reason](vcpu, kvm_run);
@@ -3146,7 +3198,9 @@ static void vmx_complete_interrupts(struct vcpu_vmx *vmx)
 		if (unblock_nmi && vector != DF_VECTOR)
 			vmcs_set_bits(GUEST_INTERRUPTIBILITY_INFO,
 				      GUEST_INTR_STATE_NMI);
-	}
+	} else if (unlikely(vmx->soft_vnmi_blocked))
+		vmx->vnmi_blocked_time +=
+			ktime_to_ns(ktime_sub(ktime_get(), vmx->entry_time));
 
 	idt_vectoring_info = vmx->idt_vectoring_info;
 	idtv_info_valid = idt_vectoring_info & VECTORING_INFO_VALID_MASK;
@@ -3186,27 +3240,25 @@ static void vmx_intr_assist(struct kvm_vcpu *vcpu)
 
 	vmx_update_window_states(vcpu);
 
-	if (cpu_has_virtual_nmis()) {
-		if (vcpu->arch.nmi_pending && !vcpu->arch.nmi_injected) {
-			if (vcpu->arch.interrupt.pending) {
-				enable_nmi_window(vcpu);
-			} else if (vcpu->arch.nmi_window_open) {
-				vcpu->arch.nmi_pending = false;
-				vcpu->arch.nmi_injected = true;
-			} else {
-				enable_nmi_window(vcpu);
-				return;
-			}
-		}
-		if (vcpu->arch.nmi_injected) {
-			vmx_inject_nmi(vcpu);
-			if (vcpu->arch.nmi_pending)
-				enable_nmi_window(vcpu);
-			else if (kvm_cpu_has_interrupt(vcpu))
-				enable_irq_window(vcpu);
+	if (vcpu->arch.nmi_pending && !vcpu->arch.nmi_injected) {
+		if (vcpu->arch.interrupt.pending) {
+			enable_nmi_window(vcpu);
+		} else if (vcpu->arch.nmi_window_open) {
+			vcpu->arch.nmi_pending = false;
+			vcpu->arch.nmi_injected = true;
+		} else {
+			enable_nmi_window(vcpu);
 			return;
 		}
 	}
+	if (vcpu->arch.nmi_injected) {
+		vmx_inject_nmi(vcpu);
+		if (vcpu->arch.nmi_pending)
+			enable_nmi_window(vcpu);
+		else if (kvm_cpu_has_interrupt(vcpu))
+			enable_irq_window(vcpu);
+		return;
+	}
 	if (!vcpu->arch.interrupt.pending && kvm_cpu_has_interrupt(vcpu)) {
 		if (vcpu->arch.interrupt_window_open)
 			kvm_queue_interrupt(vcpu, kvm_cpu_get_interrupt(vcpu));
@@ -3255,6 +3307,10 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	u32 intr_info;
 
+	/* Record the guest's net vcpu time for enforced NMI injections. */
+	if (unlikely(!cpu_has_virtual_nmis() && vmx->soft_vnmi_blocked))
+		vmx->entry_time = ktime_get();
+
 	/* Handle invalid guest state instead of entering VMX */
 	if (vmx->emulation_required && emulate_invalid_guest_state) {
 		handle_invalid_guest_state(vcpu, kvm_run);
-- 
1.6.0.3

