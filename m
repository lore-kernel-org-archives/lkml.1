Return-Path: <linux-kernel-owner+w=401wt.eu-S1757771AbXIQIt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757771AbXIQIt1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754726AbXIQIdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:33:17 -0400
Received: from il.qumranet.com ([82.166.9.18]:45250 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754459AbXIQIcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:33 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, "Yang, Sheng" <sheng.yang@intel.com>
Subject: [PATCH 075/104] KVM: VMX: Use shadow TPR/cr8 for 64-bits guests
Date: Mon, 17 Sep 2007 10:31:57 +0200
Message-Id: <11900179482330-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yang, Sheng <sheng.yang@intel.com>

This patch enables TPR shadow of VMX on CR8 access. 64bit Windows using
CR8 access TPR frequently. The TPR shadow can improve the performance of
access TPR by not causing vmexit.

Signed-off-by: Sheng Yang <sheng.yang@intel.com>
Signed-off-by: Yaozu (Eddie) Dong <eddie.dong@intel.com>
Signed-off-by: Qing He <qing.he@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/irq.h   |    2 +
 drivers/kvm/lapic.c |   17 +++++++++++++
 drivers/kvm/vmx.c   |   65 +++++++++++++++++++++++++++++++++++++++++++++++---
 drivers/kvm/vmx.h   |    1 +
 4 files changed, 81 insertions(+), 4 deletions(-)

diff --git a/drivers/kvm/irq.h b/drivers/kvm/irq.h
index 24b871f..07035e8 100644
--- a/drivers/kvm/irq.h
+++ b/drivers/kvm/irq.h
@@ -152,5 +152,7 @@ int kvm_apic_set_irq(struct kvm_lapic *apic, u8 vec, u8 trig);
 void kvm_apic_post_state_restore(struct kvm_vcpu *vcpu);
 int kvm_ioapic_init(struct kvm *kvm);
 void kvm_ioapic_set_irq(struct kvm_ioapic *ioapic, int irq, int level);
+int kvm_lapic_enabled(struct kvm_vcpu *vcpu);
+int kvm_lapic_find_highest_irr(struct kvm_vcpu *vcpu);
 
 #endif
diff --git a/drivers/kvm/lapic.c b/drivers/kvm/lapic.c
index df636bf..68bbbb3 100644
--- a/drivers/kvm/lapic.c
+++ b/drivers/kvm/lapic.c
@@ -170,6 +170,19 @@ static inline int apic_find_highest_irr(struct kvm_lapic *apic)
 	return result;
 }
 
+int kvm_lapic_find_highest_irr(struct kvm_vcpu *vcpu)
+{
+	struct kvm_lapic *apic = (struct kvm_lapic *)vcpu->apic;
+	int highest_irr;
+
+	if (!apic)
+		return 0;
+	highest_irr = apic_find_highest_irr(apic);
+
+	return highest_irr;
+}
+EXPORT_SYMBOL_GPL(kvm_lapic_find_highest_irr);
+
 int kvm_apic_set_irq(struct kvm_lapic *apic, u8 vec, u8 trig)
 {
 	if (!apic_test_and_set_irr(vec, apic)) {
@@ -483,6 +496,7 @@ static u32 __apic_read(struct kvm_lapic *apic, unsigned int offset)
 		break;
 
 	default:
+		apic_update_ppr(apic);
 		val = apic_get_reg(apic, offset);
 		break;
 	}
@@ -723,6 +737,7 @@ u64 kvm_lapic_get_cr8(struct kvm_vcpu *vcpu)
 
 	return (tpr & 0xf0) >> 4;
 }
+EXPORT_SYMBOL_GPL(kvm_lapic_get_cr8);
 
 void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
 {
@@ -809,6 +824,7 @@ int kvm_lapic_enabled(struct kvm_vcpu *vcpu)
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(kvm_lapic_enabled);
 
 /*
  *----------------------------------------------------------------------
@@ -911,6 +927,7 @@ int kvm_apic_has_interrupt(struct kvm_vcpu *vcpu)
 	if (!apic || !apic_enabled(apic))
 		return -1;
 
+	apic_update_ppr(apic);
 	highest_irr = apic_find_highest_irr(apic);
 	if ((highest_irr == -1) ||
 	    ((highest_irr & 0xF0) <= apic_get_reg(apic, APIC_PROCPRI)))
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 6c371ea..5c2c6e7 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -170,6 +170,16 @@ static inline int is_external_interrupt(u32 intr_info)
 		== (INTR_TYPE_EXT_INTR | INTR_INFO_VALID_MASK);
 }
 
+static inline int cpu_has_vmx_tpr_shadow(void)
+{
+	return (vmcs_config.cpu_based_exec_ctrl & CPU_BASED_TPR_SHADOW);
+}
+
+static inline int vm_need_tpr_shadow(struct kvm *kvm)
+{
+	return ((cpu_has_vmx_tpr_shadow()) && (irqchip_in_kernel(kvm)));
+}
+
 static int __find_msr_index(struct vcpu_vmx *vmx, u32 msr)
 {
 	int i;
@@ -888,10 +898,19 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf)
 	      CPU_BASED_USE_IO_BITMAPS |
 	      CPU_BASED_MOV_DR_EXITING |
 	      CPU_BASED_USE_TSC_OFFSETING;
+#ifdef CONFIG_X86_64
+	opt = CPU_BASED_TPR_SHADOW;
+#else
 	opt = 0;
+#endif
 	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_PROCBASED_CTLS,
 				&_cpu_based_exec_control) < 0)
 		return -EIO;
+#ifdef CONFIG_X86_64
+	if ((_cpu_based_exec_control & CPU_BASED_TPR_SHADOW))
+		_cpu_based_exec_control &= ~CPU_BASED_CR8_LOAD_EXITING &
+					   ~CPU_BASED_CR8_STORE_EXITING;
+#endif
 
 	min = 0;
 #ifdef CONFIG_X86_64
@@ -1384,6 +1403,7 @@ static int vmx_vcpu_setup(struct vcpu_vmx *vmx)
 	int ret = 0;
 	unsigned long kvm_vmx_return;
 	u64 msr;
+	u32 exec_control;
 
 	if (!init_rmode_tss(vmx->vcpu.kvm)) {
 		ret = -ENOMEM;
@@ -1459,8 +1479,16 @@ static int vmx_vcpu_setup(struct vcpu_vmx *vmx)
 	/* Control */
 	vmcs_write32(PIN_BASED_VM_EXEC_CONTROL,
 		vmcs_config.pin_based_exec_ctrl);
-	vmcs_write32(CPU_BASED_VM_EXEC_CONTROL,
-		vmcs_config.cpu_based_exec_ctrl);
+
+	exec_control = vmcs_config.cpu_based_exec_ctrl;
+	if (!vm_need_tpr_shadow(vmx->vcpu.kvm)) {
+		exec_control &= ~CPU_BASED_TPR_SHADOW;
+#ifdef CONFIG_X86_64
+		exec_control |= CPU_BASED_CR8_STORE_EXITING |
+				CPU_BASED_CR8_LOAD_EXITING;
+#endif
+	}
+	vmcs_write32(CPU_BASED_VM_EXEC_CONTROL, exec_control);
 
 	vmcs_write32(PAGE_FAULT_ERROR_CODE_MASK, 0);
 	vmcs_write32(PAGE_FAULT_ERROR_CODE_MATCH, 0);
@@ -1532,8 +1560,11 @@ static int vmx_vcpu_setup(struct vcpu_vmx *vmx)
 	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, 0);  /* 22.2.1 */
 
 #ifdef CONFIG_X86_64
-	vmcs_writel(VIRTUAL_APIC_PAGE_ADDR, 0);
-	vmcs_writel(TPR_THRESHOLD, 0);
+	vmcs_write64(VIRTUAL_APIC_PAGE_ADDR, 0);
+	if (vm_need_tpr_shadow(vmx->vcpu.kvm))
+		vmcs_write64(VIRTUAL_APIC_PAGE_ADDR,
+			     page_to_phys(vmx->vcpu.apic->regs_page));
+	vmcs_write32(TPR_THRESHOLD, 0);
 #endif
 
 	vmcs_writel(CR0_GUEST_HOST_MASK, ~0UL);
@@ -1969,6 +2000,12 @@ static int handle_wrmsr(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	return 1;
 }
 
+static int handle_tpr_below_threshold(struct kvm_vcpu *vcpu,
+				      struct kvm_run *kvm_run)
+{
+	return 1;
+}
+
 static void post_kvm_run_save(struct kvm_vcpu *vcpu,
 			      struct kvm_run *kvm_run)
 {
@@ -2036,6 +2073,7 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu,
 	[EXIT_REASON_PENDING_INTERRUPT]       = handle_interrupt_window,
 	[EXIT_REASON_HLT]                     = handle_halt,
 	[EXIT_REASON_VMCALL]                  = handle_vmcall,
+	[EXIT_REASON_TPR_BELOW_THRESHOLD]     = handle_tpr_below_threshold
 };
 
 static const int kvm_vmx_max_exit_handlers =
@@ -2083,6 +2121,23 @@ static void vmx_flush_tlb(struct kvm_vcpu *vcpu)
 {
 }
 
+static void update_tpr_threshold(struct kvm_vcpu *vcpu)
+{
+	int max_irr, tpr;
+
+	if (!vm_need_tpr_shadow(vcpu->kvm))
+		return;
+
+	if (!kvm_lapic_enabled(vcpu) ||
+	    ((max_irr = kvm_lapic_find_highest_irr(vcpu)) == -1)) {
+		vmcs_write32(TPR_THRESHOLD, 0);
+		return;
+	}
+
+	tpr = (kvm_lapic_get_cr8(vcpu) & 0x0f) << 4;
+	vmcs_write32(TPR_THRESHOLD, (max_irr > tpr) ? tpr >> 4 : max_irr >> 4);
+}
+
 static void enable_irq_window(struct kvm_vcpu *vcpu)
 {
 	u32 cpu_based_vm_exec_control;
@@ -2097,6 +2152,8 @@ static void vmx_intr_assist(struct kvm_vcpu *vcpu)
 	u32 idtv_info_field, intr_info_field;
 	int has_ext_irq, interrupt_window_open;
 
+	update_tpr_threshold(vcpu);
+
 	has_ext_irq = kvm_cpu_has_interrupt(vcpu);
 	intr_info_field = vmcs_read32(VM_ENTRY_INTR_INFO_FIELD);
 	idtv_info_field = vmcs_read32(IDT_VECTORING_INFO_FIELD);
diff --git a/drivers/kvm/vmx.h b/drivers/kvm/vmx.h
index 35d0b58..fd4e146 100644
--- a/drivers/kvm/vmx.h
+++ b/drivers/kvm/vmx.h
@@ -213,6 +213,7 @@ enum vmcs_field {
 #define EXIT_REASON_MSR_READ            31
 #define EXIT_REASON_MSR_WRITE           32
 #define EXIT_REASON_MWAIT_INSTRUCTION   36
+#define EXIT_REASON_TPR_BELOW_THRESHOLD 43
 
 /*
  * Interruption-information format
-- 
1.5.3

