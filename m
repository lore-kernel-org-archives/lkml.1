Return-Path: <linux-kernel-owner+w=401wt.eu-S1756729AbXIQIoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729AbXIQIoT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753904AbXIQIc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:32:57 -0400
Received: from il.qumranet.com ([82.166.9.18]:45309 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754364AbXIQIcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:32 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Eddie Dong <eddie.dong@intel.com>
Subject: [PATCH 065/104] KVM: Define and use cr8 access functions
Date: Mon, 17 Sep 2007 10:31:47 +0200
Message-Id: <11900179482597-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eddie Dong <eddie.dong@intel.com>

This patch is to wrap APIC base register and CR8 operation which can
provide a unique API for user level irqchip and kernel irqchip.
This is a preparation of merging lapic/ioapic patch.

Signed-off-by: Yaozu (Eddie) Dong <eddie.dong@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |    3 +++
 drivers/kvm/kvm_main.c |   32 +++++++++++++++++++++++++-------
 drivers/kvm/svm.c      |    8 ++++----
 drivers/kvm/vmx.c      |   14 ++++++++------
 4 files changed, 40 insertions(+), 17 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index d71712d..e0a2f13 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -568,6 +568,9 @@ void set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
 void set_cr3(struct kvm_vcpu *vcpu, unsigned long cr0);
 void set_cr4(struct kvm_vcpu *vcpu, unsigned long cr0);
 void set_cr8(struct kvm_vcpu *vcpu, unsigned long cr0);
+unsigned long get_cr8(struct kvm_vcpu *vcpu);
+u64 kvm_get_apic_base(struct kvm_vcpu *vcpu);
+void kvm_set_apic_base(struct kvm_vcpu *vcpu, u64 data);
 void lmsw(struct kvm_vcpu *vcpu, unsigned long msw);
 
 int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata);
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 09a04bc..f879efb 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -602,6 +602,24 @@ void set_cr8(struct kvm_vcpu *vcpu, unsigned long cr8)
 }
 EXPORT_SYMBOL_GPL(set_cr8);
 
+unsigned long get_cr8(struct kvm_vcpu *vcpu)
+{
+	return vcpu->cr8;
+}
+EXPORT_SYMBOL_GPL(get_cr8);
+
+u64 kvm_get_apic_base(struct kvm_vcpu *vcpu)
+{
+	return vcpu->apic_base;
+}
+EXPORT_SYMBOL_GPL(kvm_get_apic_base);
+
+void kvm_set_apic_base(struct kvm_vcpu *vcpu, u64 data)
+{
+	vcpu->apic_base = data;
+}
+EXPORT_SYMBOL_GPL(kvm_set_apic_base);
+
 void fx_init(struct kvm_vcpu *vcpu)
 {
 	unsigned after_mxcsr_mask;
@@ -1481,7 +1499,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 		data = 3;
 		break;
 	case MSR_IA32_APICBASE:
-		data = vcpu->apic_base;
+		data = kvm_get_apic_base(vcpu);
 		break;
 	case MSR_IA32_MISC_ENABLE:
 		data = vcpu->ia32_misc_enable_msr;
@@ -1559,7 +1577,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 	case 0x200 ... 0x2ff: /* MTRRs */
 		break;
 	case MSR_IA32_APICBASE:
-		vcpu->apic_base = data;
+		kvm_set_apic_base(vcpu, data);
 		break;
 	case MSR_IA32_MISC_ENABLE:
 		vcpu->ia32_misc_enable_msr = data;
@@ -1865,7 +1883,7 @@ static int kvm_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		sigprocmask(SIG_SETMASK, &vcpu->sigset, &sigsaved);
 
 	/* re-sync apic's tpr */
-	vcpu->cr8 = kvm_run->cr8;
+	set_cr8(vcpu, kvm_run->cr8);
 
 	if (vcpu->pio.cur_count) {
 		r = complete_pio(vcpu);
@@ -2013,9 +2031,9 @@ static int kvm_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
 	sregs->cr2 = vcpu->cr2;
 	sregs->cr3 = vcpu->cr3;
 	sregs->cr4 = vcpu->cr4;
-	sregs->cr8 = vcpu->cr8;
+	sregs->cr8 = get_cr8(vcpu);
 	sregs->efer = vcpu->shadow_efer;
-	sregs->apic_base = vcpu->apic_base;
+	sregs->apic_base = kvm_get_apic_base(vcpu);
 
 	memcpy(sregs->interrupt_bitmap, vcpu->irq_pending,
 	       sizeof sregs->interrupt_bitmap);
@@ -2051,13 +2069,13 @@ static int kvm_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 	mmu_reset_needed |= vcpu->cr3 != sregs->cr3;
 	vcpu->cr3 = sregs->cr3;
 
-	vcpu->cr8 = sregs->cr8;
+	set_cr8(vcpu, sregs->cr8);
 
 	mmu_reset_needed |= vcpu->shadow_efer != sregs->efer;
 #ifdef CONFIG_X86_64
 	kvm_arch_ops->set_efer(vcpu, sregs->efer);
 #endif
-	vcpu->apic_base = sregs->apic_base;
+	kvm_set_apic_base(vcpu, sregs->apic_base);
 
 	kvm_arch_ops->decache_cr4_guest_bits(vcpu);
 
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index 2237a59..57525e7 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -1339,10 +1339,10 @@ static void svm_intr_assist(struct vcpu_svm *svm)
 
 static void kvm_reput_irq(struct vcpu_svm *svm)
 {
-	struct kvm_vcpu *vcpu = &svm->vcpu;
 	struct vmcb_control_area *control = &svm->vmcb->control;
 
-	if ((control->int_ctl & V_IRQ_MASK) && !irqchip_in_kernel(vcpu->kvm)) {
+	if ((control->int_ctl & V_IRQ_MASK)
+	    && !irqchip_in_kernel(svm->vcpu.kvm)) {
 		control->int_ctl &= ~V_IRQ_MASK;
 		push_irq(&svm->vcpu, control->int_vector);
 	}
@@ -1396,8 +1396,8 @@ static void post_kvm_run_save(struct vcpu_svm *svm,
 		= (svm->vcpu.interrupt_window_open &&
 		   svm->vcpu.irq_summary == 0);
 	kvm_run->if_flag = (svm->vmcb->save.rflags & X86_EFLAGS_IF) != 0;
-	kvm_run->cr8 = svm->vcpu.cr8;
-	kvm_run->apic_base = svm->vcpu.apic_base;
+	kvm_run->cr8 = get_cr8(&svm->vcpu);
+	kvm_run->apic_base = kvm_get_apic_base(&svm->vcpu);
 }
 
 /*
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index f1e80a9..19676b5 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -1369,6 +1369,7 @@ static int vmx_vcpu_setup(struct vcpu_vmx *vmx)
 	int i;
 	int ret = 0;
 	unsigned long kvm_vmx_return;
+	u64 msr;
 
 	if (!init_rmode_tss(vmx->vcpu.kvm)) {
 		ret = -ENOMEM;
@@ -1376,10 +1377,11 @@ static int vmx_vcpu_setup(struct vcpu_vmx *vmx)
 	}
 
 	vmx->vcpu.regs[VCPU_REGS_RDX] = get_rdx_init_val();
-	vmx->vcpu.cr8 = 0;
-	vmx->vcpu.apic_base = 0xfee00000 | MSR_IA32_APICBASE_ENABLE;
+	set_cr8(&vmx->vcpu, 0);
+	msr = 0xfee00000 | MSR_IA32_APICBASE_ENABLE;
 	if (vmx->vcpu.vcpu_id == 0)
-		vmx->vcpu.apic_base |= MSR_IA32_APICBASE_BSP;
+		msr |= MSR_IA32_APICBASE_BSP;
+	kvm_set_apic_base(&vmx->vcpu, msr);
 
 	fx_init(&vmx->vcpu);
 
@@ -1860,7 +1862,7 @@ static int handle_cr(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 			return 1;
 		case 8:
 			vcpu_load_rsp_rip(vcpu);
-			vcpu->regs[reg] = vcpu->cr8;
+			vcpu->regs[reg] = get_cr8(vcpu);
 			vcpu_put_rsp_rip(vcpu);
 			skip_emulated_instruction(vcpu);
 			return 1;
@@ -1957,8 +1959,8 @@ static void post_kvm_run_save(struct kvm_vcpu *vcpu,
 			      struct kvm_run *kvm_run)
 {
 	kvm_run->if_flag = (vmcs_readl(GUEST_RFLAGS) & X86_EFLAGS_IF) != 0;
-	kvm_run->cr8 = vcpu->cr8;
-	kvm_run->apic_base = vcpu->apic_base;
+	kvm_run->cr8 = get_cr8(vcpu);
+	kvm_run->apic_base = kvm_get_apic_base(vcpu);
 	kvm_run->ready_for_interrupt_injection = (vcpu->interrupt_window_open &&
 						  vcpu->irq_summary == 0);
 }
-- 
1.5.3

