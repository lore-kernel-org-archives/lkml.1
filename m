Return-Path: <linux-kernel-owner+w=401wt.eu-S1760555AbZBZO2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760555AbZBZO2c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 09:28:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757266AbZBZORS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 09:17:18 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43085 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754743AbZBZOPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 09:15:42 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jan Kiszka <jan.kiszka@siemens.com>
Subject: [PATCH 15/40] KVM: x86: Virtualize debug registers
Date: Thu, 26 Feb 2009 16:15:05 +0200
Message-Id: <1235657730-27683-16-git-send-email-avi@redhat.com>
In-Reply-To: <1235657730-27683-1-git-send-email-avi@redhat.com>
References: <1235657730-27683-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

So far KVM only had basic x86 debug register support, once introduced to
realize guest debugging that way. The guest itself was not able to use
those registers.

This patch now adds (almost) full support for guest self-debugging via
hardware registers. It refactors the code, moving generic parts out of
SVM (VMX was already cleaned up by the KVM_SET_GUEST_DEBUG patches), and
it ensures that the registers are properly switched between host and
guest.

This patch also prepares debug register usage by the host. The latter
will (once wired-up by the following patch) allow for hardware
breakpoints/watchpoints in guest code. If this is enabled, the guest
will only see faked debug registers without functionality, but with
content reflecting the guest's modifications.

Tested on Intel only, but SVM /should/ work as well, but who knows...

Known limitations: Trapping on tss switch won't work - most probably on
Intel.

Credits also go to Joerg Roedel - I used his once posted debugging
series as platform for this patch.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |   22 +++++++
 arch/x86/include/asm/vmx.h      |    2 +-
 arch/x86/kvm/kvm_svm.h          |    6 --
 arch/x86/kvm/svm.c              |  116 ++++++++++++++------------------------
 arch/x86/kvm/vmx.c              |  114 +++++++++++++++++++++++++++++++++-----
 arch/x86/kvm/x86.c              |   29 ++++++++++
 6 files changed, 193 insertions(+), 96 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c430cd5..0a4dab2 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -135,6 +135,19 @@ enum {
 
 #define KVM_NR_MEM_OBJS 40
 
+#define KVM_NR_DB_REGS	4
+
+#define DR6_BD		(1 << 13)
+#define DR6_BS		(1 << 14)
+#define DR6_FIXED_1	0xffff0ff0
+#define DR6_VOLATILE	0x0000e00f
+
+#define DR7_BP_EN_MASK	0x000000ff
+#define DR7_GE		(1 << 9)
+#define DR7_GD		(1 << 13)
+#define DR7_FIXED_1	0x00000400
+#define DR7_VOLATILE	0xffff23ff
+
 /*
  * We don't want allocation failures within the mmu code, so we preallocate
  * enough memory for a single page fault in a cache.
@@ -334,6 +347,15 @@ struct kvm_vcpu_arch {
 
 	struct mtrr_state_type mtrr_state;
 	u32 pat;
+
+	int switch_db_regs;
+	unsigned long host_db[KVM_NR_DB_REGS];
+	unsigned long host_dr6;
+	unsigned long host_dr7;
+	unsigned long db[KVM_NR_DB_REGS];
+	unsigned long dr6;
+	unsigned long dr7;
+	unsigned long eff_db[KVM_NR_DB_REGS];
 };
 
 struct kvm_mem_alias {
diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 32159f0..498f944 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -312,7 +312,7 @@ enum vmcs_field {
 #define DEBUG_REG_ACCESS_TYPE           0x10    /* 4, direction of access */
 #define TYPE_MOV_TO_DR                  (0 << 4)
 #define TYPE_MOV_FROM_DR                (1 << 4)
-#define DEBUG_REG_ACCESS_REG            0xf00   /* 11:8, general purpose reg. */
+#define DEBUG_REG_ACCESS_REG(eq)        (((eq) >> 8) & 0xf) /* 11:8, general purpose reg. */
 
 
 /* segment AR */
diff --git a/arch/x86/kvm/kvm_svm.h b/arch/x86/kvm/kvm_svm.h
index 9167341..ed66e4c 100644
--- a/arch/x86/kvm/kvm_svm.h
+++ b/arch/x86/kvm/kvm_svm.h
@@ -18,7 +18,6 @@ static const u32 host_save_user_msrs[] = {
 };
 
 #define NR_HOST_SAVE_USER_MSRS ARRAY_SIZE(host_save_user_msrs)
-#define NUM_DB_REGS 4
 
 struct kvm_vcpu;
 
@@ -29,16 +28,11 @@ struct vcpu_svm {
 	struct svm_cpu_data *svm_data;
 	uint64_t asid_generation;
 
-	unsigned long db_regs[NUM_DB_REGS];
-
 	u64 next_rip;
 
 	u64 host_user_msrs[NR_HOST_SAVE_USER_MSRS];
 	u64 host_gs_base;
 	unsigned long host_cr2;
-	unsigned long host_db_regs[NUM_DB_REGS];
-	unsigned long host_dr6;
-	unsigned long host_dr7;
 
 	u32 *msrpm;
 	struct vmcb *hsave;
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 88d9062..815f50e 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -38,9 +38,6 @@ MODULE_LICENSE("GPL");
 #define IOPM_ALLOC_ORDER 2
 #define MSRPM_ALLOC_ORDER 1
 
-#define DR7_GD_MASK (1 << 13)
-#define DR6_BD_MASK (1 << 13)
-
 #define SEG_TYPE_LDT 2
 #define SEG_TYPE_BUSY_TSS16 3
 
@@ -181,32 +178,6 @@ static inline void kvm_write_cr2(unsigned long val)
 	asm volatile ("mov %0, %%cr2" :: "r" (val));
 }
 
-static inline unsigned long read_dr6(void)
-{
-	unsigned long dr6;
-
-	asm volatile ("mov %%dr6, %0" : "=r" (dr6));
-	return dr6;
-}
-
-static inline void write_dr6(unsigned long val)
-{
-	asm volatile ("mov %0, %%dr6" :: "r" (val));
-}
-
-static inline unsigned long read_dr7(void)
-{
-	unsigned long dr7;
-
-	asm volatile ("mov %%dr7, %0" : "=r" (dr7));
-	return dr7;
-}
-
-static inline void write_dr7(unsigned long val)
-{
-	asm volatile ("mov %0, %%dr7" :: "r" (val));
-}
-
 static inline void force_new_asid(struct kvm_vcpu *vcpu)
 {
 	to_svm(vcpu)->asid_generation--;
@@ -695,7 +666,6 @@ static struct kvm_vcpu *svm_create_vcpu(struct kvm *kvm, unsigned int id)
 	clear_page(svm->vmcb);
 	svm->vmcb_pa = page_to_pfn(page) << PAGE_SHIFT;
 	svm->asid_generation = 0;
-	memset(svm->db_regs, 0, sizeof(svm->db_regs));
 	init_vmcb(svm);
 
 	fx_init(&svm->vcpu);
@@ -1035,7 +1005,29 @@ static void new_asid(struct vcpu_svm *svm, struct svm_cpu_data *svm_data)
 
 static unsigned long svm_get_dr(struct kvm_vcpu *vcpu, int dr)
 {
-	unsigned long val = to_svm(vcpu)->db_regs[dr];
+	struct vcpu_svm *svm = to_svm(vcpu);
+	unsigned long val;
+
+	switch (dr) {
+	case 0 ... 3:
+		val = vcpu->arch.db[dr];
+		break;
+	case 6:
+		if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP)
+			val = vcpu->arch.dr6;
+		else
+			val = svm->vmcb->save.dr6;
+		break;
+	case 7:
+		if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP)
+			val = vcpu->arch.dr7;
+		else
+			val = svm->vmcb->save.dr7;
+		break;
+	default:
+		val = 0;
+	}
+
 	KVMTRACE_2D(DR_READ, vcpu, (u32)dr, (u32)val, handler);
 	return val;
 }
@@ -1045,33 +1037,40 @@ static void svm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long value,
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	*exception = 0;
+	KVMTRACE_2D(DR_WRITE, vcpu, (u32)dr, (u32)value, handler);
 
-	if (svm->vmcb->save.dr7 & DR7_GD_MASK) {
-		svm->vmcb->save.dr7 &= ~DR7_GD_MASK;
-		svm->vmcb->save.dr6 |= DR6_BD_MASK;
-		*exception = DB_VECTOR;
-		return;
-	}
+	*exception = 0;
 
 	switch (dr) {
 	case 0 ... 3:
-		svm->db_regs[dr] = value;
+		vcpu->arch.db[dr] = value;
+		if (!(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP))
+			vcpu->arch.eff_db[dr] = value;
 		return;
 	case 4 ... 5:
-		if (vcpu->arch.cr4 & X86_CR4_DE) {
+		if (vcpu->arch.cr4 & X86_CR4_DE)
 			*exception = UD_VECTOR;
+		return;
+	case 6:
+		if (value & 0xffffffff00000000ULL) {
+			*exception = GP_VECTOR;
 			return;
 		}
-	case 7: {
-		if (value & ~((1ULL << 32) - 1)) {
+		vcpu->arch.dr6 = (value & DR6_VOLATILE) | DR6_FIXED_1;
+		return;
+	case 7:
+		if (value & 0xffffffff00000000ULL) {
 			*exception = GP_VECTOR;
 			return;
 		}
-		svm->vmcb->save.dr7 = value;
+		vcpu->arch.dr7 = (value & DR7_VOLATILE) | DR7_FIXED_1;
+		if (!(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP)) {
+			svm->vmcb->save.dr7 = vcpu->arch.dr7;
+			vcpu->arch.switch_db_regs = (value & DR7_BP_EN_MASK);
+		}
 		return;
-	}
 	default:
+		/* FIXME: Possible case? */
 		printk(KERN_DEBUG "%s: unexpected dr %u\n",
 		       __func__, dr);
 		*exception = UD_VECTOR;
@@ -2365,22 +2364,6 @@ static int svm_set_tss_addr(struct kvm *kvm, unsigned int addr)
 	return 0;
 }
 
-static void save_db_regs(unsigned long *db_regs)
-{
-	asm volatile ("mov %%dr0, %0" : "=r"(db_regs[0]));
-	asm volatile ("mov %%dr1, %0" : "=r"(db_regs[1]));
-	asm volatile ("mov %%dr2, %0" : "=r"(db_regs[2]));
-	asm volatile ("mov %%dr3, %0" : "=r"(db_regs[3]));
-}
-
-static void load_db_regs(unsigned long *db_regs)
-{
-	asm volatile ("mov %0, %%dr0" : : "r"(db_regs[0]));
-	asm volatile ("mov %0, %%dr1" : : "r"(db_regs[1]));
-	asm volatile ("mov %0, %%dr2" : : "r"(db_regs[2]));
-	asm volatile ("mov %0, %%dr3" : : "r"(db_regs[3]));
-}
-
 static void svm_flush_tlb(struct kvm_vcpu *vcpu)
 {
 	force_new_asid(vcpu);
@@ -2439,20 +2422,12 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	gs_selector = kvm_read_gs();
 	ldt_selector = kvm_read_ldt();
 	svm->host_cr2 = kvm_read_cr2();
-	svm->host_dr6 = read_dr6();
-	svm->host_dr7 = read_dr7();
 	if (!is_nested(svm))
 		svm->vmcb->save.cr2 = vcpu->arch.cr2;
 	/* required for live migration with NPT */
 	if (npt_enabled)
 		svm->vmcb->save.cr3 = vcpu->arch.cr3;
 
-	if (svm->vmcb->save.dr7 & 0xff) {
-		write_dr7(0);
-		save_db_regs(svm->host_db_regs);
-		load_db_regs(svm->db_regs);
-	}
-
 	clgi();
 
 	local_irq_enable();
@@ -2528,16 +2503,11 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 #endif
 		);
 
-	if ((svm->vmcb->save.dr7 & 0xff))
-		load_db_regs(svm->host_db_regs);
-
 	vcpu->arch.cr2 = svm->vmcb->save.cr2;
 	vcpu->arch.regs[VCPU_REGS_RAX] = svm->vmcb->save.rax;
 	vcpu->arch.regs[VCPU_REGS_RSP] = svm->vmcb->save.rsp;
 	vcpu->arch.regs[VCPU_REGS_RIP] = svm->vmcb->save.rip;
 
-	write_dr6(svm->host_dr6);
-	write_dr7(svm->host_dr7);
 	kvm_write_cr2(svm->host_cr2);
 
 	kvm_load_fs(fs_selector);
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index c776868..0989776 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2311,7 +2311,6 @@ static int vmx_vcpu_reset(struct kvm_vcpu *vcpu)
 		kvm_rip_write(vcpu, 0);
 	kvm_register_write(vcpu, VCPU_REGS_RSP, 0);
 
-	/* todo: dr0 = dr1 = dr2 = dr3 = 0; dr6 = 0xffff0ff0 */
 	vmcs_writel(GUEST_DR7, 0x400);
 
 	vmcs_writel(GUEST_GDTR_BASE, 0);
@@ -2577,7 +2576,7 @@ static int handle_exception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	u32 intr_info, ex_no, error_code;
-	unsigned long cr2, rip;
+	unsigned long cr2, rip, dr6;
 	u32 vect_info;
 	enum emulation_result er;
 
@@ -2637,14 +2636,28 @@ static int handle_exception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	}
 
 	ex_no = intr_info & INTR_INFO_VECTOR_MASK;
-	if (ex_no == DB_VECTOR || ex_no == BP_VECTOR) {
+	switch (ex_no) {
+	case DB_VECTOR:
+		dr6 = vmcs_readl(EXIT_QUALIFICATION);
+		if (!(vcpu->guest_debug &
+		      (KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP))) {
+			vcpu->arch.dr6 = dr6 | DR6_FIXED_1;
+			kvm_queue_exception(vcpu, DB_VECTOR);
+			return 1;
+		}
+		kvm_run->debug.arch.dr6 = dr6 | DR6_FIXED_1;
+		kvm_run->debug.arch.dr7 = vmcs_readl(GUEST_DR7);
+		/* fall through */
+	case BP_VECTOR:
 		kvm_run->exit_reason = KVM_EXIT_DEBUG;
 		kvm_run->debug.arch.pc = vmcs_readl(GUEST_CS_BASE) + rip;
 		kvm_run->debug.arch.exception = ex_no;
-	} else {
+		break;
+	default:
 		kvm_run->exit_reason = KVM_EXIT_EXCEPTION;
 		kvm_run->ex.exception = ex_no;
 		kvm_run->ex.error_code = error_code;
+		break;
 	}
 	return 0;
 }
@@ -2784,21 +2797,44 @@ static int handle_dr(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	unsigned long val;
 	int dr, reg;
 
-	/*
-	 * FIXME: this code assumes the host is debugging the guest.
-	 *        need to deal with guest debugging itself too.
-	 */
+	dr = vmcs_readl(GUEST_DR7);
+	if (dr & DR7_GD) {
+		/*
+		 * As the vm-exit takes precedence over the debug trap, we
+		 * need to emulate the latter, either for the host or the
+		 * guest debugging itself.
+		 */
+		if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP) {
+			kvm_run->debug.arch.dr6 = vcpu->arch.dr6;
+			kvm_run->debug.arch.dr7 = dr;
+			kvm_run->debug.arch.pc =
+				vmcs_readl(GUEST_CS_BASE) +
+				vmcs_readl(GUEST_RIP);
+			kvm_run->debug.arch.exception = DB_VECTOR;
+			kvm_run->exit_reason = KVM_EXIT_DEBUG;
+			return 0;
+		} else {
+			vcpu->arch.dr7 &= ~DR7_GD;
+			vcpu->arch.dr6 |= DR6_BD;
+			vmcs_writel(GUEST_DR7, vcpu->arch.dr7);
+			kvm_queue_exception(vcpu, DB_VECTOR);
+			return 1;
+		}
+	}
+
 	exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
-	dr = exit_qualification & 7;
-	reg = (exit_qualification >> 8) & 15;
-	if (exit_qualification & 16) {
-		/* mov from dr */
+	dr = exit_qualification & DEBUG_REG_ACCESS_NUM;
+	reg = DEBUG_REG_ACCESS_REG(exit_qualification);
+	if (exit_qualification & TYPE_MOV_FROM_DR) {
 		switch (dr) {
+		case 0 ... 3:
+			val = vcpu->arch.db[dr];
+			break;
 		case 6:
-			val = 0xffff0ff0;
+			val = vcpu->arch.dr6;
 			break;
 		case 7:
-			val = 0x400;
+			val = vcpu->arch.dr7;
 			break;
 		default:
 			val = 0;
@@ -2806,7 +2842,38 @@ static int handle_dr(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		kvm_register_write(vcpu, reg, val);
 		KVMTRACE_2D(DR_READ, vcpu, (u32)dr, (u32)val, handler);
 	} else {
-		/* mov to dr */
+		val = vcpu->arch.regs[reg];
+		switch (dr) {
+		case 0 ... 3:
+			vcpu->arch.db[dr] = val;
+			if (!(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP))
+				vcpu->arch.eff_db[dr] = val;
+			break;
+		case 4 ... 5:
+			if (vcpu->arch.cr4 & X86_CR4_DE)
+				kvm_queue_exception(vcpu, UD_VECTOR);
+			break;
+		case 6:
+			if (val & 0xffffffff00000000ULL) {
+				kvm_queue_exception(vcpu, GP_VECTOR);
+				break;
+			}
+			vcpu->arch.dr6 = (val & DR6_VOLATILE) | DR6_FIXED_1;
+			break;
+		case 7:
+			if (val & 0xffffffff00000000ULL) {
+				kvm_queue_exception(vcpu, GP_VECTOR);
+				break;
+			}
+			vcpu->arch.dr7 = (val & DR7_VOLATILE) | DR7_FIXED_1;
+			if (!(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP)) {
+				vmcs_writel(GUEST_DR7, vcpu->arch.dr7);
+				vcpu->arch.switch_db_regs =
+					(val & DR7_BP_EN_MASK);
+			}
+			break;
+		}
+		KVMTRACE_2D(DR_WRITE, vcpu, (u32)dr, (u32)val, handler);
 	}
 	skip_emulated_instruction(vcpu);
 	return 1;
@@ -2957,7 +3024,18 @@ static int handle_task_switch(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	}
 	tss_selector = exit_qualification;
 
-	return kvm_task_switch(vcpu, tss_selector, reason);
+	if (!kvm_task_switch(vcpu, tss_selector, reason))
+		return 0;
+
+	/* clear all local breakpoint enable flags */
+	vmcs_writel(GUEST_DR7, vmcs_readl(GUEST_DR7) & ~55);
+
+	/*
+	 * TODO: What about debug traps on tss switch?
+	 *       Are we supposed to inject them and update dr6?
+	 */
+
+	return 1;
 }
 
 static int handle_ept_violation(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
@@ -3342,6 +3420,8 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	 */
 	vmcs_writel(HOST_CR0, read_cr0());
 
+	set_debugreg(vcpu->arch.dr6, 6);
+
 	asm(
 		/* Store host registers */
 		"push %%"R"dx; push %%"R"bp;"
@@ -3436,6 +3516,8 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	vcpu->arch.regs_avail = ~((1 << VCPU_REGS_RIP) | (1 << VCPU_REGS_RSP));
 	vcpu->arch.regs_dirty = 0;
 
+	get_debugreg(vcpu->arch.dr6, 6);
+
 	vmx->idt_vectoring_info = vmcs_read32(IDT_VECTORING_INFO_FIELD);
 	if (vmx->rmode.irq.pending)
 		fixup_rmode_irq(vmx);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e990d16..300bc4d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3025,10 +3025,34 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 	kvm_guest_enter();
 
+	get_debugreg(vcpu->arch.host_dr6, 6);
+	get_debugreg(vcpu->arch.host_dr7, 7);
+	if (unlikely(vcpu->arch.switch_db_regs)) {
+		get_debugreg(vcpu->arch.host_db[0], 0);
+		get_debugreg(vcpu->arch.host_db[1], 1);
+		get_debugreg(vcpu->arch.host_db[2], 2);
+		get_debugreg(vcpu->arch.host_db[3], 3);
+
+		set_debugreg(0, 7);
+		set_debugreg(vcpu->arch.eff_db[0], 0);
+		set_debugreg(vcpu->arch.eff_db[1], 1);
+		set_debugreg(vcpu->arch.eff_db[2], 2);
+		set_debugreg(vcpu->arch.eff_db[3], 3);
+	}
 
 	KVMTRACE_0D(VMENTRY, vcpu, entryexit);
 	kvm_x86_ops->run(vcpu, kvm_run);
 
+	if (unlikely(vcpu->arch.switch_db_regs)) {
+		set_debugreg(0, 7);
+		set_debugreg(vcpu->arch.host_db[0], 0);
+		set_debugreg(vcpu->arch.host_db[1], 1);
+		set_debugreg(vcpu->arch.host_db[2], 2);
+		set_debugreg(vcpu->arch.host_db[3], 3);
+	}
+	set_debugreg(vcpu->arch.host_dr6, 6);
+	set_debugreg(vcpu->arch.host_dr7, 7);
+
 	vcpu->guest_mode = 0;
 	local_irq_enable();
 
@@ -4035,6 +4059,11 @@ int kvm_arch_vcpu_reset(struct kvm_vcpu *vcpu)
 	vcpu->arch.nmi_pending = false;
 	vcpu->arch.nmi_injected = false;
 
+	vcpu->arch.switch_db_regs = 0;
+	memset(vcpu->arch.db, 0, sizeof(vcpu->arch.db));
+	vcpu->arch.dr6 = DR6_FIXED_1;
+	vcpu->arch.dr7 = DR7_FIXED_1;
+
 	return kvm_x86_ops->vcpu_reset(vcpu);
 }
 
-- 
1.6.0.6

