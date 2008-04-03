Return-Path: <linux-kernel-owner+w=401wt.eu-S1762491AbYDCTgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762491AbYDCTgl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 15:36:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760970AbYDCTdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 15:33:07 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:53024
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756954AbYDCTc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 15:32:57 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 09/35] KVM: Prefix control register accessors with kvm_ to avoid namespace pollution
Date: Thu,  3 Apr 2008 22:32:24 +0300
Message-Id: <1207251170-5013-10-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1207251170-5013-1-git-send-email-avi@qumranet.com>
References: <1207251170-5013-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Names like 'set_cr3()' look dangerously close to affecting the host.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/vmx.c         |   14 ++++++------
 arch/x86/kvm/x86.c         |   46 ++++++++++++++++++++++----------------------
 include/asm-x86/kvm_host.h |   12 +++++-----
 3 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index f46ad03..5034503 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1683,7 +1683,7 @@ static int vmx_vcpu_reset(struct kvm_vcpu *vcpu)
 	vmx->vcpu.arch.rmode.active = 0;
 
 	vmx->vcpu.arch.regs[VCPU_REGS_RDX] = get_rdx_init_val();
-	set_cr8(&vmx->vcpu, 0);
+	kvm_set_cr8(&vmx->vcpu, 0);
 	msr = 0xfee00000 | MSR_IA32_APICBASE_ENABLE;
 	if (vmx->vcpu.vcpu_id == 0)
 		msr |= MSR_IA32_APICBASE_BSP;
@@ -2026,22 +2026,22 @@ static int handle_cr(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		switch (cr) {
 		case 0:
 			vcpu_load_rsp_rip(vcpu);
-			set_cr0(vcpu, vcpu->arch.regs[reg]);
+			kvm_set_cr0(vcpu, vcpu->arch.regs[reg]);
 			skip_emulated_instruction(vcpu);
 			return 1;
 		case 3:
 			vcpu_load_rsp_rip(vcpu);
-			set_cr3(vcpu, vcpu->arch.regs[reg]);
+			kvm_set_cr3(vcpu, vcpu->arch.regs[reg]);
 			skip_emulated_instruction(vcpu);
 			return 1;
 		case 4:
 			vcpu_load_rsp_rip(vcpu);
-			set_cr4(vcpu, vcpu->arch.regs[reg]);
+			kvm_set_cr4(vcpu, vcpu->arch.regs[reg]);
 			skip_emulated_instruction(vcpu);
 			return 1;
 		case 8:
 			vcpu_load_rsp_rip(vcpu);
-			set_cr8(vcpu, vcpu->arch.regs[reg]);
+			kvm_set_cr8(vcpu, vcpu->arch.regs[reg]);
 			skip_emulated_instruction(vcpu);
 			if (irqchip_in_kernel(vcpu->kvm))
 				return 1;
@@ -2067,14 +2067,14 @@ static int handle_cr(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 			return 1;
 		case 8:
 			vcpu_load_rsp_rip(vcpu);
-			vcpu->arch.regs[reg] = get_cr8(vcpu);
+			vcpu->arch.regs[reg] = kvm_get_cr8(vcpu);
 			vcpu_put_rsp_rip(vcpu);
 			skip_emulated_instruction(vcpu);
 			return 1;
 		}
 		break;
 	case 3: /* lmsw */
-		lmsw(vcpu, (exit_qualification >> LMSW_SOURCE_DATA_SHIFT) & 0x0f);
+		kvm_lmsw(vcpu, (exit_qualification >> LMSW_SOURCE_DATA_SHIFT) & 0x0f);
 
 		skip_emulated_instruction(vcpu);
 		return 1;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0458bd5..dbcff38 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -237,7 +237,7 @@ out:
 	return changed;
 }
 
-void set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
+void kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 {
 	if (cr0 & CR0_RESERVED_BITS) {
 		printk(KERN_DEBUG "set_cr0: 0x%lx #GP, reserved bits 0x%lx\n",
@@ -295,15 +295,15 @@ void set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	kvm_mmu_reset_context(vcpu);
 	return;
 }
-EXPORT_SYMBOL_GPL(set_cr0);
+EXPORT_SYMBOL_GPL(kvm_set_cr0);
 
-void lmsw(struct kvm_vcpu *vcpu, unsigned long msw)
+void kvm_lmsw(struct kvm_vcpu *vcpu, unsigned long msw)
 {
-	set_cr0(vcpu, (vcpu->arch.cr0 & ~0x0ful) | (msw & 0x0f));
+	kvm_set_cr0(vcpu, (vcpu->arch.cr0 & ~0x0ful) | (msw & 0x0f));
 }
-EXPORT_SYMBOL_GPL(lmsw);
+EXPORT_SYMBOL_GPL(kvm_lmsw);
 
-void set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
+void kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
 	if (cr4 & CR4_RESERVED_BITS) {
 		printk(KERN_DEBUG "set_cr4: #GP, reserved bits\n");
@@ -334,9 +334,9 @@ void set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 	vcpu->arch.cr4 = cr4;
 	kvm_mmu_reset_context(vcpu);
 }
-EXPORT_SYMBOL_GPL(set_cr4);
+EXPORT_SYMBOL_GPL(kvm_set_cr4);
 
-void set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
+void kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 {
 	if (cr3 == vcpu->arch.cr3 && !pdptrs_changed(vcpu)) {
 		kvm_mmu_flush_tlb(vcpu);
@@ -388,9 +388,9 @@ void set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 	}
 	up_read(&vcpu->kvm->slots_lock);
 }
-EXPORT_SYMBOL_GPL(set_cr3);
+EXPORT_SYMBOL_GPL(kvm_set_cr3);
 
-void set_cr8(struct kvm_vcpu *vcpu, unsigned long cr8)
+void kvm_set_cr8(struct kvm_vcpu *vcpu, unsigned long cr8)
 {
 	if (cr8 & CR8_RESERVED_BITS) {
 		printk(KERN_DEBUG "set_cr8: #GP, reserved bits 0x%lx\n", cr8);
@@ -402,16 +402,16 @@ void set_cr8(struct kvm_vcpu *vcpu, unsigned long cr8)
 	else
 		vcpu->arch.cr8 = cr8;
 }
-EXPORT_SYMBOL_GPL(set_cr8);
+EXPORT_SYMBOL_GPL(kvm_set_cr8);
 
-unsigned long get_cr8(struct kvm_vcpu *vcpu)
+unsigned long kvm_get_cr8(struct kvm_vcpu *vcpu)
 {
 	if (irqchip_in_kernel(vcpu->kvm))
 		return kvm_lapic_get_cr8(vcpu);
 	else
 		return vcpu->arch.cr8;
 }
-EXPORT_SYMBOL_GPL(get_cr8);
+EXPORT_SYMBOL_GPL(kvm_get_cr8);
 
 /*
  * List of msr numbers which we expose to userspace through KVM_GET_MSRS
@@ -2462,7 +2462,7 @@ void realmode_lidt(struct kvm_vcpu *vcpu, u16 limit, unsigned long base)
 void realmode_lmsw(struct kvm_vcpu *vcpu, unsigned long msw,
 		   unsigned long *rflags)
 {
-	lmsw(vcpu, msw);
+	kvm_lmsw(vcpu, msw);
 	*rflags = kvm_x86_ops->get_rflags(vcpu);
 }
 
@@ -2479,7 +2479,7 @@ unsigned long realmode_get_cr(struct kvm_vcpu *vcpu, int cr)
 	case 4:
 		return vcpu->arch.cr4;
 	case 8:
-		return get_cr8(vcpu);
+		return kvm_get_cr8(vcpu);
 	default:
 		vcpu_printf(vcpu, "%s: unexpected cr %u\n", __FUNCTION__, cr);
 		return 0;
@@ -2491,20 +2491,20 @@ void realmode_set_cr(struct kvm_vcpu *vcpu, int cr, unsigned long val,
 {
 	switch (cr) {
 	case 0:
-		set_cr0(vcpu, mk_cr_64(vcpu->arch.cr0, val));
+		kvm_set_cr0(vcpu, mk_cr_64(vcpu->arch.cr0, val));
 		*rflags = kvm_x86_ops->get_rflags(vcpu);
 		break;
 	case 2:
 		vcpu->arch.cr2 = val;
 		break;
 	case 3:
-		set_cr3(vcpu, val);
+		kvm_set_cr3(vcpu, val);
 		break;
 	case 4:
-		set_cr4(vcpu, mk_cr_64(vcpu->arch.cr4, val));
+		kvm_set_cr4(vcpu, mk_cr_64(vcpu->arch.cr4, val));
 		break;
 	case 8:
-		set_cr8(vcpu, val & 0xfUL);
+		kvm_set_cr8(vcpu, val & 0xfUL);
 		break;
 	default:
 		vcpu_printf(vcpu, "%s: unexpected cr %u\n", __FUNCTION__, cr);
@@ -2602,7 +2602,7 @@ static void post_kvm_run_save(struct kvm_vcpu *vcpu,
 			      struct kvm_run *kvm_run)
 {
 	kvm_run->if_flag = (kvm_x86_ops->get_rflags(vcpu) & X86_EFLAGS_IF) != 0;
-	kvm_run->cr8 = get_cr8(vcpu);
+	kvm_run->cr8 = kvm_get_cr8(vcpu);
 	kvm_run->apic_base = kvm_get_apic_base(vcpu);
 	if (irqchip_in_kernel(vcpu->kvm))
 		kvm_run->ready_for_interrupt_injection = 1;
@@ -2803,7 +2803,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 	/* re-sync apic's tpr */
 	if (!irqchip_in_kernel(vcpu->kvm))
-		set_cr8(vcpu, kvm_run->cr8);
+		kvm_set_cr8(vcpu, kvm_run->cr8);
 
 	if (vcpu->arch.pio.cur_count) {
 		r = complete_pio(vcpu);
@@ -2961,7 +2961,7 @@ int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
 	sregs->cr2 = vcpu->arch.cr2;
 	sregs->cr3 = vcpu->arch.cr3;
 	sregs->cr4 = vcpu->arch.cr4;
-	sregs->cr8 = get_cr8(vcpu);
+	sregs->cr8 = kvm_get_cr8(vcpu);
 	sregs->efer = vcpu->arch.shadow_efer;
 	sregs->apic_base = kvm_get_apic_base(vcpu);
 
@@ -3007,7 +3007,7 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 	mmu_reset_needed |= vcpu->arch.cr3 != sregs->cr3;
 	vcpu->arch.cr3 = sregs->cr3;
 
-	set_cr8(vcpu, sregs->cr8);
+	kvm_set_cr8(vcpu, sregs->cr8);
 
 	mmu_reset_needed |= vcpu->arch.shadow_efer != sregs->efer;
 	kvm_x86_ops->set_efer(vcpu, sregs->efer);
diff --git a/include/asm-x86/kvm_host.h b/include/asm-x86/kvm_host.h
index 58291a6..024b57c 100644
--- a/include/asm-x86/kvm_host.h
+++ b/include/asm-x86/kvm_host.h
@@ -469,12 +469,12 @@ int emulator_get_dr(struct x86_emulate_ctxt *ctxt, int dr,
 int emulator_set_dr(struct x86_emulate_ctxt *ctxt, int dr,
 		    unsigned long value);
 
-void set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
-void set_cr3(struct kvm_vcpu *vcpu, unsigned long cr0);
-void set_cr4(struct kvm_vcpu *vcpu, unsigned long cr0);
-void set_cr8(struct kvm_vcpu *vcpu, unsigned long cr0);
-unsigned long get_cr8(struct kvm_vcpu *vcpu);
-void lmsw(struct kvm_vcpu *vcpu, unsigned long msw);
+void kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
+void kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr0);
+void kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr0);
+void kvm_set_cr8(struct kvm_vcpu *vcpu, unsigned long cr0);
+unsigned long kvm_get_cr8(struct kvm_vcpu *vcpu);
+void kvm_lmsw(struct kvm_vcpu *vcpu, unsigned long msw);
 void kvm_get_cs_db_l_bits(struct kvm_vcpu *vcpu, int *db, int *l);
 
 int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata);
-- 
1.5.4.5

