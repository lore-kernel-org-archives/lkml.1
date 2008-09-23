Return-Path: <linux-kernel-owner+w=401wt.eu-S1754242AbYIWNsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242AbYIWNsn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 09:48:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752555AbYIWNrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 09:47:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52337 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815AbYIWNrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 09:47:03 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 02/40] KVM: x86: accessors for guest registers
Date: Tue, 23 Sep 2008 16:46:16 +0300
Message-Id: <1222177614-26669-3-git-send-email-avi@redhat.com>
In-Reply-To: <1222177614-26669-1-git-send-email-avi@redhat.com>
References: <1222177614-26669-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

As suggested by Avi, introduce accessors to read/write guest registers.
This simplifies the ->cache_regs/->decache_regs interface, and improves
register caching which is important for VMX, where the cost of
vmcs_read/vmcs_write is significant.

[avi: fix warnings]

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/kvm_cache_regs.h |   32 +++++
 arch/x86/kvm/lapic.c          |    4 +-
 arch/x86/kvm/svm.c            |   56 ++++-----
 arch/x86/kvm/vmx.c            |  103 ++++++++--------
 arch/x86/kvm/x86.c            |  268 +++++++++++++++++++++--------------------
 arch/x86/kvm/x86_emulate.c    |   19 ++--
 include/asm-x86/kvm_host.h    |   15 ++-
 7 files changed, 264 insertions(+), 233 deletions(-)
 create mode 100644 arch/x86/kvm/kvm_cache_regs.h

diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
new file mode 100644
index 0000000..1ff819d
--- /dev/null
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -0,0 +1,32 @@
+#ifndef ASM_KVM_CACHE_REGS_H
+#define ASM_KVM_CACHE_REGS_H
+
+static inline unsigned long kvm_register_read(struct kvm_vcpu *vcpu,
+					      enum kvm_reg reg)
+{
+	if (!test_bit(reg, (unsigned long *)&vcpu->arch.regs_avail))
+		kvm_x86_ops->cache_reg(vcpu, reg);
+
+	return vcpu->arch.regs[reg];
+}
+
+static inline void kvm_register_write(struct kvm_vcpu *vcpu,
+				      enum kvm_reg reg,
+				      unsigned long val)
+{
+	vcpu->arch.regs[reg] = val;
+	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_dirty);
+	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
+}
+
+static inline unsigned long kvm_rip_read(struct kvm_vcpu *vcpu)
+{
+	return kvm_register_read(vcpu, VCPU_REGS_RIP);
+}
+
+static inline void kvm_rip_write(struct kvm_vcpu *vcpu, unsigned long val)
+{
+	kvm_register_write(vcpu, VCPU_REGS_RIP, val);
+}
+
+#endif
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 73f43de..9fde0ac 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -32,6 +32,7 @@
 #include <asm/current.h>
 #include <asm/apicdef.h>
 #include <asm/atomic.h>
+#include "kvm_cache_regs.h"
 #include "irq.h"
 
 #define PRId64 "d"
@@ -558,8 +559,7 @@ static void __report_tpr_access(struct kvm_lapic *apic, bool write)
 	struct kvm_run *run = vcpu->run;
 
 	set_bit(KVM_REQ_REPORT_TPR_ACCESS, &vcpu->requests);
-	kvm_x86_ops->cache_regs(vcpu);
-	run->tpr_access.rip = vcpu->arch.rip;
+	run->tpr_access.rip = kvm_rip_read(vcpu);
 	run->tpr_access.is_write = write;
 }
 
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 8233b86..54b0bf3 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -18,6 +18,7 @@
 #include "kvm_svm.h"
 #include "irq.h"
 #include "mmu.h"
+#include "kvm_cache_regs.h"
 
 #include <linux/module.h>
 #include <linux/kernel.h>
@@ -236,13 +237,11 @@ static void skip_emulated_instruction(struct kvm_vcpu *vcpu)
 		printk(KERN_DEBUG "%s: NOP\n", __func__);
 		return;
 	}
-	if (svm->next_rip - svm->vmcb->save.rip > MAX_INST_SIZE)
-		printk(KERN_ERR "%s: ip 0x%llx next 0x%llx\n",
-		       __func__,
-		       svm->vmcb->save.rip,
-		       svm->next_rip);
+	if (svm->next_rip - kvm_rip_read(vcpu) > MAX_INST_SIZE)
+		printk(KERN_ERR "%s: ip 0x%lx next 0x%llx\n",
+		       __func__, kvm_rip_read(vcpu), svm->next_rip);
 
-	vcpu->arch.rip = svm->vmcb->save.rip = svm->next_rip;
+	kvm_rip_write(vcpu, svm->next_rip);
 	svm->vmcb->control.int_state &= ~SVM_INTERRUPT_SHADOW_MASK;
 
 	vcpu->arch.interrupt_window_open = 1;
@@ -581,6 +580,7 @@ static void init_vmcb(struct vcpu_svm *svm)
 	save->dr7 = 0x400;
 	save->rflags = 2;
 	save->rip = 0x0000fff0;
+	svm->vcpu.arch.regs[VCPU_REGS_RIP] = save->rip;
 
 	/*
 	 * cr0 val on cpu init should be 0x60000010, we enable cpu
@@ -615,10 +615,12 @@ static int svm_vcpu_reset(struct kvm_vcpu *vcpu)
 	init_vmcb(svm);
 
 	if (vcpu->vcpu_id != 0) {
-		svm->vmcb->save.rip = 0;
+		kvm_rip_write(vcpu, 0);
 		svm->vmcb->save.cs.base = svm->vcpu.arch.sipi_vector << 12;
 		svm->vmcb->save.cs.selector = svm->vcpu.arch.sipi_vector << 8;
 	}
+	vcpu->arch.regs_avail = ~0;
+	vcpu->arch.regs_dirty = ~0;
 
 	return 0;
 }
@@ -721,23 +723,6 @@ static void svm_vcpu_put(struct kvm_vcpu *vcpu)
 	rdtscll(vcpu->arch.host_tsc);
 }
 
-static void svm_cache_regs(struct kvm_vcpu *vcpu)
-{
-	struct vcpu_svm *svm = to_svm(vcpu);
-
-	vcpu->arch.regs[VCPU_REGS_RAX] = svm->vmcb->save.rax;
-	vcpu->arch.regs[VCPU_REGS_RSP] = svm->vmcb->save.rsp;
-	vcpu->arch.rip = svm->vmcb->save.rip;
-}
-
-static void svm_decache_regs(struct kvm_vcpu *vcpu)
-{
-	struct vcpu_svm *svm = to_svm(vcpu);
-	svm->vmcb->save.rax = vcpu->arch.regs[VCPU_REGS_RAX];
-	svm->vmcb->save.rsp = vcpu->arch.regs[VCPU_REGS_RSP];
-	svm->vmcb->save.rip = vcpu->arch.rip;
-}
-
 static unsigned long svm_get_rflags(struct kvm_vcpu *vcpu)
 {
 	return to_svm(vcpu)->vmcb->save.rflags;
@@ -1139,14 +1124,14 @@ static int nop_on_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 
 static int halt_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 {
-	svm->next_rip = svm->vmcb->save.rip + 1;
+	svm->next_rip = kvm_rip_read(&svm->vcpu) + 1;
 	skip_emulated_instruction(&svm->vcpu);
 	return kvm_emulate_halt(&svm->vcpu);
 }
 
 static int vmmcall_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 {
-	svm->next_rip = svm->vmcb->save.rip + 3;
+	svm->next_rip = kvm_rip_read(&svm->vcpu) + 3;
 	skip_emulated_instruction(&svm->vcpu);
 	kvm_emulate_hypercall(&svm->vcpu);
 	return 1;
@@ -1178,7 +1163,7 @@ static int task_switch_interception(struct vcpu_svm *svm,
 
 static int cpuid_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 {
-	svm->next_rip = svm->vmcb->save.rip + 2;
+	svm->next_rip = kvm_rip_read(&svm->vcpu) + 2;
 	kvm_emulate_cpuid(&svm->vcpu);
 	return 1;
 }
@@ -1273,9 +1258,9 @@ static int rdmsr_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 		KVMTRACE_3D(MSR_READ, &svm->vcpu, ecx, (u32)data,
 			    (u32)(data >> 32), handler);
 
-		svm->vmcb->save.rax = data & 0xffffffff;
+		svm->vcpu.arch.regs[VCPU_REGS_RAX] = data & 0xffffffff;
 		svm->vcpu.arch.regs[VCPU_REGS_RDX] = data >> 32;
-		svm->next_rip = svm->vmcb->save.rip + 2;
+		svm->next_rip = kvm_rip_read(&svm->vcpu) + 2;
 		skip_emulated_instruction(&svm->vcpu);
 	}
 	return 1;
@@ -1359,13 +1344,13 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, unsigned ecx, u64 data)
 static int wrmsr_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 {
 	u32 ecx = svm->vcpu.arch.regs[VCPU_REGS_RCX];
-	u64 data = (svm->vmcb->save.rax & -1u)
+	u64 data = (svm->vcpu.arch.regs[VCPU_REGS_RAX] & -1u)
 		| ((u64)(svm->vcpu.arch.regs[VCPU_REGS_RDX] & -1u) << 32);
 
 	KVMTRACE_3D(MSR_WRITE, &svm->vcpu, ecx, (u32)data, (u32)(data >> 32),
 		    handler);
 
-	svm->next_rip = svm->vmcb->save.rip + 2;
+	svm->next_rip = kvm_rip_read(&svm->vcpu) + 2;
 	if (svm_set_msr(&svm->vcpu, ecx, data))
 		kvm_inject_gp(&svm->vcpu, 0);
 	else
@@ -1723,6 +1708,10 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	u16 gs_selector;
 	u16 ldt_selector;
 
+	svm->vmcb->save.rax = vcpu->arch.regs[VCPU_REGS_RAX];
+	svm->vmcb->save.rsp = vcpu->arch.regs[VCPU_REGS_RSP];
+	svm->vmcb->save.rip = vcpu->arch.regs[VCPU_REGS_RIP];
+
 	pre_svm_run(svm);
 
 	sync_lapic_to_cr8(vcpu);
@@ -1858,6 +1847,9 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		load_db_regs(svm->host_db_regs);
 
 	vcpu->arch.cr2 = svm->vmcb->save.cr2;
+	vcpu->arch.regs[VCPU_REGS_RAX] = svm->vmcb->save.rax;
+	vcpu->arch.regs[VCPU_REGS_RSP] = svm->vmcb->save.rsp;
+	vcpu->arch.regs[VCPU_REGS_RIP] = svm->vmcb->save.rip;
 
 	write_dr6(svm->host_dr6);
 	write_dr7(svm->host_dr7);
@@ -1977,8 +1969,6 @@ static struct kvm_x86_ops svm_x86_ops = {
 	.set_gdt = svm_set_gdt,
 	.get_dr = svm_get_dr,
 	.set_dr = svm_set_dr,
-	.cache_regs = svm_cache_regs,
-	.decache_regs = svm_decache_regs,
 	.get_rflags = svm_get_rflags,
 	.set_rflags = svm_set_rflags,
 
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 81dac72..5a3a032 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -26,6 +26,7 @@
 #include <linux/highmem.h>
 #include <linux/sched.h>
 #include <linux/moduleparam.h>
+#include "kvm_cache_regs.h"
 
 #include <asm/io.h>
 #include <asm/desc.h>
@@ -715,9 +716,9 @@ static void skip_emulated_instruction(struct kvm_vcpu *vcpu)
 	unsigned long rip;
 	u32 interruptibility;
 
-	rip = vmcs_readl(GUEST_RIP);
+	rip = kvm_rip_read(vcpu);
 	rip += vmcs_read32(VM_EXIT_INSTRUCTION_LEN);
-	vmcs_writel(GUEST_RIP, rip);
+	kvm_rip_write(vcpu, rip);
 
 	/*
 	 * We emulated an instruction, so temporary interrupt blocking
@@ -947,24 +948,19 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
 	return ret;
 }
 
-/*
- * Sync the rsp and rip registers into the vcpu structure.  This allows
- * registers to be accessed by indexing vcpu->arch.regs.
- */
-static void vcpu_load_rsp_rip(struct kvm_vcpu *vcpu)
-{
-	vcpu->arch.regs[VCPU_REGS_RSP] = vmcs_readl(GUEST_RSP);
-	vcpu->arch.rip = vmcs_readl(GUEST_RIP);
-}
-
-/*
- * Syncs rsp and rip back into the vmcs.  Should be called after possible
- * modification.
- */
-static void vcpu_put_rsp_rip(struct kvm_vcpu *vcpu)
+static void vmx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
 {
-	vmcs_writel(GUEST_RSP, vcpu->arch.regs[VCPU_REGS_RSP]);
-	vmcs_writel(GUEST_RIP, vcpu->arch.rip);
+	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
+	switch (reg) {
+	case VCPU_REGS_RSP:
+		vcpu->arch.regs[VCPU_REGS_RSP] = vmcs_readl(GUEST_RSP);
+		break;
+	case VCPU_REGS_RIP:
+		vcpu->arch.regs[VCPU_REGS_RIP] = vmcs_readl(GUEST_RIP);
+		break;
+	default:
+		break;
+	}
 }
 
 static int set_guest_debug(struct kvm_vcpu *vcpu, struct kvm_debug_guest *dbg)
@@ -2019,6 +2015,7 @@ static int vmx_vcpu_reset(struct kvm_vcpu *vcpu)
 	u64 msr;
 	int ret;
 
+	vcpu->arch.regs_avail = ~((1 << VCPU_REGS_RIP) | (1 << VCPU_REGS_RSP));
 	down_read(&vcpu->kvm->slots_lock);
 	if (!init_rmode(vmx->vcpu.kvm)) {
 		ret = -ENOMEM;
@@ -2072,10 +2069,10 @@ static int vmx_vcpu_reset(struct kvm_vcpu *vcpu)
 
 	vmcs_writel(GUEST_RFLAGS, 0x02);
 	if (vmx->vcpu.vcpu_id == 0)
-		vmcs_writel(GUEST_RIP, 0xfff0);
+		kvm_rip_write(vcpu, 0xfff0);
 	else
-		vmcs_writel(GUEST_RIP, 0);
-	vmcs_writel(GUEST_RSP, 0);
+		kvm_rip_write(vcpu, 0);
+	kvm_register_write(vcpu, VCPU_REGS_RSP, 0);
 
 	/* todo: dr0 = dr1 = dr2 = dr3 = 0; dr6 = 0xffff0ff0 */
 	vmcs_writel(GUEST_DR7, 0x400);
@@ -2139,11 +2136,11 @@ static void vmx_inject_irq(struct kvm_vcpu *vcpu, int irq)
 	if (vcpu->arch.rmode.active) {
 		vmx->rmode.irq.pending = true;
 		vmx->rmode.irq.vector = irq;
-		vmx->rmode.irq.rip = vmcs_readl(GUEST_RIP);
+		vmx->rmode.irq.rip = kvm_rip_read(vcpu);
 		vmcs_write32(VM_ENTRY_INTR_INFO_FIELD,
 			     irq | INTR_TYPE_SOFT_INTR | INTR_INFO_VALID_MASK);
 		vmcs_write32(VM_ENTRY_INSTRUCTION_LEN, 1);
-		vmcs_writel(GUEST_RIP, vmx->rmode.irq.rip - 1);
+		kvm_rip_write(vcpu, vmx->rmode.irq.rip - 1);
 		return;
 	}
 	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD,
@@ -2288,7 +2285,7 @@ static int handle_exception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	}
 
 	error_code = 0;
-	rip = vmcs_readl(GUEST_RIP);
+	rip = kvm_rip_read(vcpu);
 	if (intr_info & INTR_INFO_DELIVER_CODE_MASK)
 		error_code = vmcs_read32(VM_EXIT_INTR_ERROR_CODE);
 	if (is_page_fault(intr_info)) {
@@ -2386,27 +2383,25 @@ static int handle_cr(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	reg = (exit_qualification >> 8) & 15;
 	switch ((exit_qualification >> 4) & 3) {
 	case 0: /* mov to cr */
-		KVMTRACE_3D(CR_WRITE, vcpu, (u32)cr, (u32)vcpu->arch.regs[reg],
-			    (u32)((u64)vcpu->arch.regs[reg] >> 32), handler);
+		KVMTRACE_3D(CR_WRITE, vcpu, (u32)cr,
+			    (u32)kvm_register_read(vcpu, reg),
+			    (u32)((u64)kvm_register_read(vcpu, reg) >> 32),
+			    handler);
 		switch (cr) {
 		case 0:
-			vcpu_load_rsp_rip(vcpu);
-			kvm_set_cr0(vcpu, vcpu->arch.regs[reg]);
+			kvm_set_cr0(vcpu, kvm_register_read(vcpu, reg));
 			skip_emulated_instruction(vcpu);
 			return 1;
 		case 3:
-			vcpu_load_rsp_rip(vcpu);
-			kvm_set_cr3(vcpu, vcpu->arch.regs[reg]);
+			kvm_set_cr3(vcpu, kvm_register_read(vcpu, reg));
 			skip_emulated_instruction(vcpu);
 			return 1;
 		case 4:
-			vcpu_load_rsp_rip(vcpu);
-			kvm_set_cr4(vcpu, vcpu->arch.regs[reg]);
+			kvm_set_cr4(vcpu, kvm_register_read(vcpu, reg));
 			skip_emulated_instruction(vcpu);
 			return 1;
 		case 8:
-			vcpu_load_rsp_rip(vcpu);
-			kvm_set_cr8(vcpu, vcpu->arch.regs[reg]);
+			kvm_set_cr8(vcpu, kvm_register_read(vcpu, reg));
 			skip_emulated_instruction(vcpu);
 			if (irqchip_in_kernel(vcpu->kvm))
 				return 1;
@@ -2415,7 +2410,6 @@ static int handle_cr(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		};
 		break;
 	case 2: /* clts */
-		vcpu_load_rsp_rip(vcpu);
 		vmx_fpu_deactivate(vcpu);
 		vcpu->arch.cr0 &= ~X86_CR0_TS;
 		vmcs_writel(CR0_READ_SHADOW, vcpu->arch.cr0);
@@ -2426,21 +2420,17 @@ static int handle_cr(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	case 1: /*mov from cr*/
 		switch (cr) {
 		case 3:
-			vcpu_load_rsp_rip(vcpu);
-			vcpu->arch.regs[reg] = vcpu->arch.cr3;
-			vcpu_put_rsp_rip(vcpu);
+			kvm_register_write(vcpu, reg, vcpu->arch.cr3);
 			KVMTRACE_3D(CR_READ, vcpu, (u32)cr,
-				    (u32)vcpu->arch.regs[reg],
-				    (u32)((u64)vcpu->arch.regs[reg] >> 32),
+				    (u32)kvm_register_read(vcpu, reg),
+				    (u32)((u64)kvm_register_read(vcpu, reg) >> 32),
 				    handler);
 			skip_emulated_instruction(vcpu);
 			return 1;
 		case 8:
-			vcpu_load_rsp_rip(vcpu);
-			vcpu->arch.regs[reg] = kvm_get_cr8(vcpu);
-			vcpu_put_rsp_rip(vcpu);
+			kvm_register_write(vcpu, reg, kvm_get_cr8(vcpu));
 			KVMTRACE_2D(CR_READ, vcpu, (u32)cr,
-				    (u32)vcpu->arch.regs[reg], handler);
+				    (u32)kvm_register_read(vcpu, reg), handler);
 			skip_emulated_instruction(vcpu);
 			return 1;
 		}
@@ -2472,7 +2462,6 @@ static int handle_dr(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
 	dr = exit_qualification & 7;
 	reg = (exit_qualification >> 8) & 15;
-	vcpu_load_rsp_rip(vcpu);
 	if (exit_qualification & 16) {
 		/* mov from dr */
 		switch (dr) {
@@ -2485,12 +2474,11 @@ static int handle_dr(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		default:
 			val = 0;
 		}
-		vcpu->arch.regs[reg] = val;
+		kvm_register_write(vcpu, reg, val);
 		KVMTRACE_2D(DR_READ, vcpu, (u32)dr, (u32)val, handler);
 	} else {
 		/* mov to dr */
 	}
-	vcpu_put_rsp_rip(vcpu);
 	skip_emulated_instruction(vcpu);
 	return 1;
 }
@@ -2735,8 +2723,8 @@ static int kvm_handle_exit(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	u32 vectoring_info = vmx->idt_vectoring_info;
 
-	KVMTRACE_3D(VMEXIT, vcpu, exit_reason, (u32)vmcs_readl(GUEST_RIP),
-		    (u32)((u64)vmcs_readl(GUEST_RIP) >> 32), entryexit);
+	KVMTRACE_3D(VMEXIT, vcpu, exit_reason, (u32)kvm_rip_read(vcpu),
+		    (u32)((u64)kvm_rip_read(vcpu) >> 32), entryexit);
 
 	/* Access CR3 don't cause VMExit in paging mode, so we need
 	 * to sync with guest real CR3. */
@@ -2922,9 +2910,9 @@ static void vmx_intr_assist(struct kvm_vcpu *vcpu)
 static void fixup_rmode_irq(struct vcpu_vmx *vmx)
 {
 	vmx->rmode.irq.pending = 0;
-	if (vmcs_readl(GUEST_RIP) + 1 != vmx->rmode.irq.rip)
+	if (kvm_rip_read(&vmx->vcpu) + 1 != vmx->rmode.irq.rip)
 		return;
-	vmcs_writel(GUEST_RIP, vmx->rmode.irq.rip);
+	kvm_rip_write(&vmx->vcpu, vmx->rmode.irq.rip);
 	if (vmx->idt_vectoring_info & VECTORING_INFO_VALID_MASK) {
 		vmx->idt_vectoring_info &= ~VECTORING_INFO_TYPE_MASK;
 		vmx->idt_vectoring_info |= INTR_TYPE_EXT_INTR;
@@ -2941,6 +2929,11 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	u32 intr_info;
 
+	if (test_bit(VCPU_REGS_RSP, (unsigned long *)&vcpu->arch.regs_dirty))
+		vmcs_writel(GUEST_RSP, vcpu->arch.regs[VCPU_REGS_RSP]);
+	if (test_bit(VCPU_REGS_RIP, (unsigned long *)&vcpu->arch.regs_dirty))
+		vmcs_writel(GUEST_RIP, vcpu->arch.regs[VCPU_REGS_RIP]);
+
 	/*
 	 * Loading guest fpu may have cleared host cr0.ts
 	 */
@@ -3061,6 +3054,9 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 #endif
 	      );
 
+	vcpu->arch.regs_avail = ~((1 << VCPU_REGS_RIP) | (1 << VCPU_REGS_RSP));
+	vcpu->arch.regs_dirty = 0;
+
 	vmx->idt_vectoring_info = vmcs_read32(IDT_VECTORING_INFO_FIELD);
 	if (vmx->rmode.irq.pending)
 		fixup_rmode_irq(vmx);
@@ -3224,8 +3220,7 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.set_idt = vmx_set_idt,
 	.get_gdt = vmx_get_gdt,
 	.set_gdt = vmx_set_gdt,
-	.cache_regs = vcpu_load_rsp_rip,
-	.decache_regs = vcpu_put_rsp_rip,
+	.cache_reg = vmx_cache_reg,
 	.get_rflags = vmx_get_rflags,
 	.set_rflags = vmx_set_rflags,
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0d682fc..2f0696b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -19,6 +19,7 @@
 #include "mmu.h"
 #include "i8254.h"
 #include "tss.h"
+#include "kvm_cache_regs.h"
 
 #include <linux/clocksource.h>
 #include <linux/kvm.h>
@@ -61,6 +62,7 @@ static int kvm_dev_ioctl_get_supported_cpuid(struct kvm_cpuid2 *cpuid,
 				    struct kvm_cpuid_entry2 __user *entries);
 
 struct kvm_x86_ops *kvm_x86_ops;
+EXPORT_SYMBOL_GPL(kvm_x86_ops);
 
 struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ "pf_fixed", VCPU_STAT(pf_fixed) },
@@ -2080,7 +2082,7 @@ int emulator_set_dr(struct x86_emulate_ctxt *ctxt, int dr, unsigned long value)
 void kvm_report_emulation_failure(struct kvm_vcpu *vcpu, const char *context)
 {
 	u8 opcodes[4];
-	unsigned long rip = vcpu->arch.rip;
+	unsigned long rip = kvm_rip_read(vcpu);
 	unsigned long rip_linear;
 
 	if (!printk_ratelimit())
@@ -2102,6 +2104,14 @@ static struct x86_emulate_ops emulate_ops = {
 	.cmpxchg_emulated    = emulator_cmpxchg_emulated,
 };
 
+static void cache_all_regs(struct kvm_vcpu *vcpu)
+{
+	kvm_register_read(vcpu, VCPU_REGS_RAX);
+	kvm_register_read(vcpu, VCPU_REGS_RSP);
+	kvm_register_read(vcpu, VCPU_REGS_RIP);
+	vcpu->arch.regs_dirty = ~0;
+}
+
 int emulate_instruction(struct kvm_vcpu *vcpu,
 			struct kvm_run *run,
 			unsigned long cr2,
@@ -2112,7 +2122,13 @@ int emulate_instruction(struct kvm_vcpu *vcpu,
 	struct decode_cache *c;
 
 	vcpu->arch.mmio_fault_cr2 = cr2;
-	kvm_x86_ops->cache_regs(vcpu);
+	/*
+	 * TODO: fix x86_emulate.c to use guest_read/write_register
+	 * instead of direct ->regs accesses, can save hundred cycles
+	 * on Intel for instructions that don't read/change RSP, for
+	 * for example.
+	 */
+	cache_all_regs(vcpu);
 
 	vcpu->mmio_is_write = 0;
 	vcpu->arch.pio.string = 0;
@@ -2172,7 +2188,6 @@ int emulate_instruction(struct kvm_vcpu *vcpu,
 		return EMULATE_DO_MMIO;
 	}
 
-	kvm_x86_ops->decache_regs(vcpu);
 	kvm_x86_ops->set_rflags(vcpu, vcpu->arch.emulate_ctxt.eflags);
 
 	if (vcpu->mmio_is_write) {
@@ -2225,20 +2240,19 @@ int complete_pio(struct kvm_vcpu *vcpu)
 	struct kvm_pio_request *io = &vcpu->arch.pio;
 	long delta;
 	int r;
-
-	kvm_x86_ops->cache_regs(vcpu);
+	unsigned long val;
 
 	if (!io->string) {
-		if (io->in)
-			memcpy(&vcpu->arch.regs[VCPU_REGS_RAX], vcpu->arch.pio_data,
-			       io->size);
+		if (io->in) {
+			val = kvm_register_read(vcpu, VCPU_REGS_RAX);
+			memcpy(&val, vcpu->arch.pio_data, io->size);
+			kvm_register_write(vcpu, VCPU_REGS_RAX, val);
+		}
 	} else {
 		if (io->in) {
 			r = pio_copy_data(vcpu);
-			if (r) {
-				kvm_x86_ops->cache_regs(vcpu);
+			if (r)
 				return r;
-			}
 		}
 
 		delta = 1;
@@ -2248,19 +2262,24 @@ int complete_pio(struct kvm_vcpu *vcpu)
 			 * The size of the register should really depend on
 			 * current address size.
 			 */
-			vcpu->arch.regs[VCPU_REGS_RCX] -= delta;
+			val = kvm_register_read(vcpu, VCPU_REGS_RCX);
+			val -= delta;
+			kvm_register_write(vcpu, VCPU_REGS_RCX, val);
 		}
 		if (io->down)
 			delta = -delta;
 		delta *= io->size;
-		if (io->in)
-			vcpu->arch.regs[VCPU_REGS_RDI] += delta;
-		else
-			vcpu->arch.regs[VCPU_REGS_RSI] += delta;
+		if (io->in) {
+			val = kvm_register_read(vcpu, VCPU_REGS_RDI);
+			val += delta;
+			kvm_register_write(vcpu, VCPU_REGS_RDI, val);
+		} else {
+			val = kvm_register_read(vcpu, VCPU_REGS_RSI);
+			val += delta;
+			kvm_register_write(vcpu, VCPU_REGS_RSI, val);
+		}
 	}
 
-	kvm_x86_ops->decache_regs(vcpu);
-
 	io->count -= io->cur_count;
 	io->cur_count = 0;
 
@@ -2313,6 +2332,7 @@ int kvm_emulate_pio(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
 		  int size, unsigned port)
 {
 	struct kvm_io_device *pio_dev;
+	unsigned long val;
 
 	vcpu->run->exit_reason = KVM_EXIT_IO;
 	vcpu->run->io.direction = in ? KVM_EXIT_IO_IN : KVM_EXIT_IO_OUT;
@@ -2333,8 +2353,8 @@ int kvm_emulate_pio(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
 		KVMTRACE_2D(IO_WRITE, vcpu, vcpu->run->io.port, (u32)size,
 			    handler);
 
-	kvm_x86_ops->cache_regs(vcpu);
-	memcpy(vcpu->arch.pio_data, &vcpu->arch.regs[VCPU_REGS_RAX], 4);
+	val = kvm_register_read(vcpu, VCPU_REGS_RAX);
+	memcpy(vcpu->arch.pio_data, &val, 4);
 
 	kvm_x86_ops->skip_emulated_instruction(vcpu);
 
@@ -2519,13 +2539,11 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 	unsigned long nr, a0, a1, a2, a3, ret;
 	int r = 1;
 
-	kvm_x86_ops->cache_regs(vcpu);
-
-	nr = vcpu->arch.regs[VCPU_REGS_RAX];
-	a0 = vcpu->arch.regs[VCPU_REGS_RBX];
-	a1 = vcpu->arch.regs[VCPU_REGS_RCX];
-	a2 = vcpu->arch.regs[VCPU_REGS_RDX];
-	a3 = vcpu->arch.regs[VCPU_REGS_RSI];
+	nr = kvm_register_read(vcpu, VCPU_REGS_RAX);
+	a0 = kvm_register_read(vcpu, VCPU_REGS_RBX);
+	a1 = kvm_register_read(vcpu, VCPU_REGS_RCX);
+	a2 = kvm_register_read(vcpu, VCPU_REGS_RDX);
+	a3 = kvm_register_read(vcpu, VCPU_REGS_RSI);
 
 	KVMTRACE_1D(VMMCALL, vcpu, (u32)nr, handler);
 
@@ -2548,8 +2566,7 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 		ret = -KVM_ENOSYS;
 		break;
 	}
-	vcpu->arch.regs[VCPU_REGS_RAX] = ret;
-	kvm_x86_ops->decache_regs(vcpu);
+	kvm_register_write(vcpu, VCPU_REGS_RAX, ret);
 	++vcpu->stat.hypercalls;
 	return r;
 }
@@ -2559,6 +2576,7 @@ int kvm_fix_hypercall(struct kvm_vcpu *vcpu)
 {
 	char instruction[3];
 	int ret = 0;
+	unsigned long rip = kvm_rip_read(vcpu);
 
 
 	/*
@@ -2568,9 +2586,8 @@ int kvm_fix_hypercall(struct kvm_vcpu *vcpu)
 	 */
 	kvm_mmu_zap_all(vcpu->kvm);
 
-	kvm_x86_ops->cache_regs(vcpu);
 	kvm_x86_ops->patch_hypercall(vcpu, instruction);
-	if (emulator_write_emulated(vcpu->arch.rip, instruction, 3, vcpu)
+	if (emulator_write_emulated(rip, instruction, 3, vcpu)
 	    != X86EMUL_CONTINUE)
 		ret = -EFAULT;
 
@@ -2700,13 +2717,12 @@ void kvm_emulate_cpuid(struct kvm_vcpu *vcpu)
 	u32 function, index;
 	struct kvm_cpuid_entry2 *e, *best;
 
-	kvm_x86_ops->cache_regs(vcpu);
-	function = vcpu->arch.regs[VCPU_REGS_RAX];
-	index = vcpu->arch.regs[VCPU_REGS_RCX];
-	vcpu->arch.regs[VCPU_REGS_RAX] = 0;
-	vcpu->arch.regs[VCPU_REGS_RBX] = 0;
-	vcpu->arch.regs[VCPU_REGS_RCX] = 0;
-	vcpu->arch.regs[VCPU_REGS_RDX] = 0;
+	function = kvm_register_read(vcpu, VCPU_REGS_RAX);
+	index = kvm_register_read(vcpu, VCPU_REGS_RCX);
+	kvm_register_write(vcpu, VCPU_REGS_RAX, 0);
+	kvm_register_write(vcpu, VCPU_REGS_RBX, 0);
+	kvm_register_write(vcpu, VCPU_REGS_RCX, 0);
+	kvm_register_write(vcpu, VCPU_REGS_RDX, 0);
 	best = NULL;
 	for (i = 0; i < vcpu->arch.cpuid_nent; ++i) {
 		e = &vcpu->arch.cpuid_entries[i];
@@ -2724,18 +2740,17 @@ void kvm_emulate_cpuid(struct kvm_vcpu *vcpu)
 				best = e;
 	}
 	if (best) {
-		vcpu->arch.regs[VCPU_REGS_RAX] = best->eax;
-		vcpu->arch.regs[VCPU_REGS_RBX] = best->ebx;
-		vcpu->arch.regs[VCPU_REGS_RCX] = best->ecx;
-		vcpu->arch.regs[VCPU_REGS_RDX] = best->edx;
+		kvm_register_write(vcpu, VCPU_REGS_RAX, best->eax);
+		kvm_register_write(vcpu, VCPU_REGS_RBX, best->ebx);
+		kvm_register_write(vcpu, VCPU_REGS_RCX, best->ecx);
+		kvm_register_write(vcpu, VCPU_REGS_RDX, best->edx);
 	}
-	kvm_x86_ops->decache_regs(vcpu);
 	kvm_x86_ops->skip_emulated_instruction(vcpu);
 	KVMTRACE_5D(CPUID, vcpu, function,
-		    (u32)vcpu->arch.regs[VCPU_REGS_RAX],
-		    (u32)vcpu->arch.regs[VCPU_REGS_RBX],
-		    (u32)vcpu->arch.regs[VCPU_REGS_RCX],
-		    (u32)vcpu->arch.regs[VCPU_REGS_RDX], handler);
+		    (u32)kvm_register_read(vcpu, VCPU_REGS_RAX),
+		    (u32)kvm_register_read(vcpu, VCPU_REGS_RBX),
+		    (u32)kvm_register_read(vcpu, VCPU_REGS_RCX),
+		    (u32)kvm_register_read(vcpu, VCPU_REGS_RDX), handler);
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_cpuid);
 
@@ -2917,8 +2932,8 @@ again:
 	 * Profile KVM exit RIPs:
 	 */
 	if (unlikely(prof_on == KVM_PROFILING)) {
-		kvm_x86_ops->cache_regs(vcpu);
-		profile_hit(KVM_PROFILING, (void *)vcpu->arch.rip);
+		unsigned long rip = kvm_rip_read(vcpu);
+		profile_hit(KVM_PROFILING, (void *)rip);
 	}
 
 	if (vcpu->arch.exception.pending && kvm_x86_ops->exception_injected(vcpu))
@@ -2999,11 +3014,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		}
 	}
 #endif
-	if (kvm_run->exit_reason == KVM_EXIT_HYPERCALL) {
-		kvm_x86_ops->cache_regs(vcpu);
-		vcpu->arch.regs[VCPU_REGS_RAX] = kvm_run->hypercall.ret;
-		kvm_x86_ops->decache_regs(vcpu);
-	}
+	if (kvm_run->exit_reason == KVM_EXIT_HYPERCALL)
+		kvm_register_write(vcpu, VCPU_REGS_RAX,
+				     kvm_run->hypercall.ret);
 
 	r = __vcpu_run(vcpu, kvm_run);
 
@@ -3019,28 +3032,26 @@ int kvm_arch_vcpu_ioctl_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 {
 	vcpu_load(vcpu);
 
-	kvm_x86_ops->cache_regs(vcpu);
-
-	regs->rax = vcpu->arch.regs[VCPU_REGS_RAX];
-	regs->rbx = vcpu->arch.regs[VCPU_REGS_RBX];
-	regs->rcx = vcpu->arch.regs[VCPU_REGS_RCX];
-	regs->rdx = vcpu->arch.regs[VCPU_REGS_RDX];
-	regs->rsi = vcpu->arch.regs[VCPU_REGS_RSI];
-	regs->rdi = vcpu->arch.regs[VCPU_REGS_RDI];
-	regs->rsp = vcpu->arch.regs[VCPU_REGS_RSP];
-	regs->rbp = vcpu->arch.regs[VCPU_REGS_RBP];
+	regs->rax = kvm_register_read(vcpu, VCPU_REGS_RAX);
+	regs->rbx = kvm_register_read(vcpu, VCPU_REGS_RBX);
+	regs->rcx = kvm_register_read(vcpu, VCPU_REGS_RCX);
+	regs->rdx = kvm_register_read(vcpu, VCPU_REGS_RDX);
+	regs->rsi = kvm_register_read(vcpu, VCPU_REGS_RSI);
+	regs->rdi = kvm_register_read(vcpu, VCPU_REGS_RDI);
+	regs->rsp = kvm_register_read(vcpu, VCPU_REGS_RSP);
+	regs->rbp = kvm_register_read(vcpu, VCPU_REGS_RBP);
 #ifdef CONFIG_X86_64
-	regs->r8 = vcpu->arch.regs[VCPU_REGS_R8];
-	regs->r9 = vcpu->arch.regs[VCPU_REGS_R9];
-	regs->r10 = vcpu->arch.regs[VCPU_REGS_R10];
-	regs->r11 = vcpu->arch.regs[VCPU_REGS_R11];
-	regs->r12 = vcpu->arch.regs[VCPU_REGS_R12];
-	regs->r13 = vcpu->arch.regs[VCPU_REGS_R13];
-	regs->r14 = vcpu->arch.regs[VCPU_REGS_R14];
-	regs->r15 = vcpu->arch.regs[VCPU_REGS_R15];
+	regs->r8 = kvm_register_read(vcpu, VCPU_REGS_R8);
+	regs->r9 = kvm_register_read(vcpu, VCPU_REGS_R9);
+	regs->r10 = kvm_register_read(vcpu, VCPU_REGS_R10);
+	regs->r11 = kvm_register_read(vcpu, VCPU_REGS_R11);
+	regs->r12 = kvm_register_read(vcpu, VCPU_REGS_R12);
+	regs->r13 = kvm_register_read(vcpu, VCPU_REGS_R13);
+	regs->r14 = kvm_register_read(vcpu, VCPU_REGS_R14);
+	regs->r15 = kvm_register_read(vcpu, VCPU_REGS_R15);
 #endif
 
-	regs->rip = vcpu->arch.rip;
+	regs->rip = kvm_rip_read(vcpu);
 	regs->rflags = kvm_x86_ops->get_rflags(vcpu);
 
 	/*
@@ -3058,29 +3069,29 @@ int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 {
 	vcpu_load(vcpu);
 
-	vcpu->arch.regs[VCPU_REGS_RAX] = regs->rax;
-	vcpu->arch.regs[VCPU_REGS_RBX] = regs->rbx;
-	vcpu->arch.regs[VCPU_REGS_RCX] = regs->rcx;
-	vcpu->arch.regs[VCPU_REGS_RDX] = regs->rdx;
-	vcpu->arch.regs[VCPU_REGS_RSI] = regs->rsi;
-	vcpu->arch.regs[VCPU_REGS_RDI] = regs->rdi;
-	vcpu->arch.regs[VCPU_REGS_RSP] = regs->rsp;
-	vcpu->arch.regs[VCPU_REGS_RBP] = regs->rbp;
+	kvm_register_write(vcpu, VCPU_REGS_RAX, regs->rax);
+	kvm_register_write(vcpu, VCPU_REGS_RBX, regs->rbx);
+	kvm_register_write(vcpu, VCPU_REGS_RCX, regs->rcx);
+	kvm_register_write(vcpu, VCPU_REGS_RDX, regs->rdx);
+	kvm_register_write(vcpu, VCPU_REGS_RSI, regs->rsi);
+	kvm_register_write(vcpu, VCPU_REGS_RDI, regs->rdi);
+	kvm_register_write(vcpu, VCPU_REGS_RSP, regs->rsp);
+	kvm_register_write(vcpu, VCPU_REGS_RBP, regs->rbp);
 #ifdef CONFIG_X86_64
-	vcpu->arch.regs[VCPU_REGS_R8] = regs->r8;
-	vcpu->arch.regs[VCPU_REGS_R9] = regs->r9;
-	vcpu->arch.regs[VCPU_REGS_R10] = regs->r10;
-	vcpu->arch.regs[VCPU_REGS_R11] = regs->r11;
-	vcpu->arch.regs[VCPU_REGS_R12] = regs->r12;
-	vcpu->arch.regs[VCPU_REGS_R13] = regs->r13;
-	vcpu->arch.regs[VCPU_REGS_R14] = regs->r14;
-	vcpu->arch.regs[VCPU_REGS_R15] = regs->r15;
+	kvm_register_write(vcpu, VCPU_REGS_R8, regs->r8);
+	kvm_register_write(vcpu, VCPU_REGS_R9, regs->r9);
+	kvm_register_write(vcpu, VCPU_REGS_R10, regs->r10);
+	kvm_register_write(vcpu, VCPU_REGS_R11, regs->r11);
+	kvm_register_write(vcpu, VCPU_REGS_R12, regs->r12);
+	kvm_register_write(vcpu, VCPU_REGS_R13, regs->r13);
+	kvm_register_write(vcpu, VCPU_REGS_R14, regs->r14);
+	kvm_register_write(vcpu, VCPU_REGS_R15, regs->r15);
+
 #endif
 
-	vcpu->arch.rip = regs->rip;
+	kvm_rip_write(vcpu, regs->rip);
 	kvm_x86_ops->set_rflags(vcpu, regs->rflags);
 
-	kvm_x86_ops->decache_regs(vcpu);
 
 	vcpu->arch.exception.pending = false;
 
@@ -3316,17 +3327,16 @@ static void save_state_to_tss32(struct kvm_vcpu *vcpu,
 				struct tss_segment_32 *tss)
 {
 	tss->cr3 = vcpu->arch.cr3;
-	tss->eip = vcpu->arch.rip;
+	tss->eip = kvm_rip_read(vcpu);
 	tss->eflags = kvm_x86_ops->get_rflags(vcpu);
-	tss->eax = vcpu->arch.regs[VCPU_REGS_RAX];
-	tss->ecx = vcpu->arch.regs[VCPU_REGS_RCX];
-	tss->edx = vcpu->arch.regs[VCPU_REGS_RDX];
-	tss->ebx = vcpu->arch.regs[VCPU_REGS_RBX];
-	tss->esp = vcpu->arch.regs[VCPU_REGS_RSP];
-	tss->ebp = vcpu->arch.regs[VCPU_REGS_RBP];
-	tss->esi = vcpu->arch.regs[VCPU_REGS_RSI];
-	tss->edi = vcpu->arch.regs[VCPU_REGS_RDI];
-
+	tss->eax = kvm_register_read(vcpu, VCPU_REGS_RAX);
+	tss->ecx = kvm_register_read(vcpu, VCPU_REGS_RCX);
+	tss->edx = kvm_register_read(vcpu, VCPU_REGS_RDX);
+	tss->ebx = kvm_register_read(vcpu, VCPU_REGS_RBX);
+	tss->esp = kvm_register_read(vcpu, VCPU_REGS_RSP);
+	tss->ebp = kvm_register_read(vcpu, VCPU_REGS_RBP);
+	tss->esi = kvm_register_read(vcpu, VCPU_REGS_RSI);
+	tss->edi = kvm_register_read(vcpu, VCPU_REGS_RDI);
 	tss->es = get_segment_selector(vcpu, VCPU_SREG_ES);
 	tss->cs = get_segment_selector(vcpu, VCPU_SREG_CS);
 	tss->ss = get_segment_selector(vcpu, VCPU_SREG_SS);
@@ -3342,17 +3352,17 @@ static int load_state_from_tss32(struct kvm_vcpu *vcpu,
 {
 	kvm_set_cr3(vcpu, tss->cr3);
 
-	vcpu->arch.rip = tss->eip;
+	kvm_rip_write(vcpu, tss->eip);
 	kvm_x86_ops->set_rflags(vcpu, tss->eflags | 2);
 
-	vcpu->arch.regs[VCPU_REGS_RAX] = tss->eax;
-	vcpu->arch.regs[VCPU_REGS_RCX] = tss->ecx;
-	vcpu->arch.regs[VCPU_REGS_RDX] = tss->edx;
-	vcpu->arch.regs[VCPU_REGS_RBX] = tss->ebx;
-	vcpu->arch.regs[VCPU_REGS_RSP] = tss->esp;
-	vcpu->arch.regs[VCPU_REGS_RBP] = tss->ebp;
-	vcpu->arch.regs[VCPU_REGS_RSI] = tss->esi;
-	vcpu->arch.regs[VCPU_REGS_RDI] = tss->edi;
+	kvm_register_write(vcpu, VCPU_REGS_RAX, tss->eax);
+	kvm_register_write(vcpu, VCPU_REGS_RCX, tss->ecx);
+	kvm_register_write(vcpu, VCPU_REGS_RDX, tss->edx);
+	kvm_register_write(vcpu, VCPU_REGS_RBX, tss->ebx);
+	kvm_register_write(vcpu, VCPU_REGS_RSP, tss->esp);
+	kvm_register_write(vcpu, VCPU_REGS_RBP, tss->ebp);
+	kvm_register_write(vcpu, VCPU_REGS_RSI, tss->esi);
+	kvm_register_write(vcpu, VCPU_REGS_RDI, tss->edi);
 
 	if (kvm_load_segment_descriptor(vcpu, tss->ldt_selector, 0, VCPU_SREG_LDTR))
 		return 1;
@@ -3380,16 +3390,16 @@ static int load_state_from_tss32(struct kvm_vcpu *vcpu,
 static void save_state_to_tss16(struct kvm_vcpu *vcpu,
 				struct tss_segment_16 *tss)
 {
-	tss->ip = vcpu->arch.rip;
+	tss->ip = kvm_rip_read(vcpu);
 	tss->flag = kvm_x86_ops->get_rflags(vcpu);
-	tss->ax = vcpu->arch.regs[VCPU_REGS_RAX];
-	tss->cx = vcpu->arch.regs[VCPU_REGS_RCX];
-	tss->dx = vcpu->arch.regs[VCPU_REGS_RDX];
-	tss->bx = vcpu->arch.regs[VCPU_REGS_RBX];
-	tss->sp = vcpu->arch.regs[VCPU_REGS_RSP];
-	tss->bp = vcpu->arch.regs[VCPU_REGS_RBP];
-	tss->si = vcpu->arch.regs[VCPU_REGS_RSI];
-	tss->di = vcpu->arch.regs[VCPU_REGS_RDI];
+	tss->ax = kvm_register_read(vcpu, VCPU_REGS_RAX);
+	tss->cx = kvm_register_read(vcpu, VCPU_REGS_RCX);
+	tss->dx = kvm_register_read(vcpu, VCPU_REGS_RDX);
+	tss->bx = kvm_register_read(vcpu, VCPU_REGS_RBX);
+	tss->sp = kvm_register_read(vcpu, VCPU_REGS_RSP);
+	tss->bp = kvm_register_read(vcpu, VCPU_REGS_RBP);
+	tss->si = kvm_register_read(vcpu, VCPU_REGS_RSI);
+	tss->di = kvm_register_read(vcpu, VCPU_REGS_RDI);
 
 	tss->es = get_segment_selector(vcpu, VCPU_SREG_ES);
 	tss->cs = get_segment_selector(vcpu, VCPU_SREG_CS);
@@ -3402,16 +3412,16 @@ static void save_state_to_tss16(struct kvm_vcpu *vcpu,
 static int load_state_from_tss16(struct kvm_vcpu *vcpu,
 				 struct tss_segment_16 *tss)
 {
-	vcpu->arch.rip = tss->ip;
+	kvm_rip_write(vcpu, tss->ip);
 	kvm_x86_ops->set_rflags(vcpu, tss->flag | 2);
-	vcpu->arch.regs[VCPU_REGS_RAX] = tss->ax;
-	vcpu->arch.regs[VCPU_REGS_RCX] = tss->cx;
-	vcpu->arch.regs[VCPU_REGS_RDX] = tss->dx;
-	vcpu->arch.regs[VCPU_REGS_RBX] = tss->bx;
-	vcpu->arch.regs[VCPU_REGS_RSP] = tss->sp;
-	vcpu->arch.regs[VCPU_REGS_RBP] = tss->bp;
-	vcpu->arch.regs[VCPU_REGS_RSI] = tss->si;
-	vcpu->arch.regs[VCPU_REGS_RDI] = tss->di;
+	kvm_register_write(vcpu, VCPU_REGS_RAX, tss->ax);
+	kvm_register_write(vcpu, VCPU_REGS_RCX, tss->cx);
+	kvm_register_write(vcpu, VCPU_REGS_RDX, tss->dx);
+	kvm_register_write(vcpu, VCPU_REGS_RBX, tss->bx);
+	kvm_register_write(vcpu, VCPU_REGS_RSP, tss->sp);
+	kvm_register_write(vcpu, VCPU_REGS_RBP, tss->bp);
+	kvm_register_write(vcpu, VCPU_REGS_RSI, tss->si);
+	kvm_register_write(vcpu, VCPU_REGS_RDI, tss->di);
 
 	if (kvm_load_segment_descriptor(vcpu, tss->ldt, 0, VCPU_SREG_LDTR))
 		return 1;
@@ -3534,7 +3544,6 @@ int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int reason)
 	}
 
 	kvm_x86_ops->skip_emulated_instruction(vcpu);
-	kvm_x86_ops->cache_regs(vcpu);
 
 	if (nseg_desc.type & 8)
 		ret = kvm_task_switch_32(vcpu, tss_selector, old_tss_base,
@@ -3559,7 +3568,6 @@ int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int reason)
 	tr_seg.type = 11;
 	kvm_set_segment(vcpu, &tr_seg, VCPU_SREG_TR);
 out:
-	kvm_x86_ops->decache_regs(vcpu);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(kvm_task_switch);
diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index f2f9046..d5da7f1 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -26,6 +26,7 @@
 #define DPRINTF(_f, _a ...) printf(_f , ## _a)
 #else
 #include <linux/kvm_host.h>
+#include "kvm_cache_regs.h"
 #define DPRINTF(x...) do {} while (0)
 #endif
 #include <linux/module.h>
@@ -839,7 +840,7 @@ x86_decode_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 	/* Shadow copy of register state. Committed on successful emulation. */
 
 	memset(c, 0, sizeof(struct decode_cache));
-	c->eip = ctxt->vcpu->arch.rip;
+	c->eip = kvm_rip_read(ctxt->vcpu);
 	ctxt->cs_base = seg_base(ctxt, VCPU_SREG_CS);
 	memcpy(c->regs, ctxt->vcpu->arch.regs, sizeof c->regs);
 
@@ -1267,7 +1268,7 @@ x86_emulate_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 	if (c->rep_prefix && (c->d & String)) {
 		/* All REP prefixes have the same first termination condition */
 		if (c->regs[VCPU_REGS_RCX] == 0) {
-			ctxt->vcpu->arch.rip = c->eip;
+			kvm_rip_write(ctxt->vcpu, c->eip);
 			goto done;
 		}
 		/* The second termination condition only applies for REPE
@@ -1281,17 +1282,17 @@ x86_emulate_insn(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 				(c->b == 0xae) || (c->b == 0xaf)) {
 			if ((c->rep_prefix == REPE_PREFIX) &&
 				((ctxt->eflags & EFLG_ZF) == 0)) {
-					ctxt->vcpu->arch.rip = c->eip;
+					kvm_rip_write(ctxt->vcpu, c->eip);
 					goto done;
 			}
 			if ((c->rep_prefix == REPNE_PREFIX) &&
 				((ctxt->eflags & EFLG_ZF) == EFLG_ZF)) {
-				ctxt->vcpu->arch.rip = c->eip;
+				kvm_rip_write(ctxt->vcpu, c->eip);
 				goto done;
 			}
 		}
 		c->regs[VCPU_REGS_RCX]--;
-		c->eip = ctxt->vcpu->arch.rip;
+		c->eip = kvm_rip_read(ctxt->vcpu);
 	}
 
 	if (c->src.type == OP_MEM) {
@@ -1768,7 +1769,7 @@ writeback:
 
 	/* Commit shadow register state. */
 	memcpy(ctxt->vcpu->arch.regs, c->regs, sizeof c->regs);
-	ctxt->vcpu->arch.rip = c->eip;
+	kvm_rip_write(ctxt->vcpu, c->eip);
 
 done:
 	if (rc == X86EMUL_UNHANDLEABLE) {
@@ -1793,7 +1794,7 @@ twobyte_insn:
 				goto done;
 
 			/* Let the processor re-execute the fixed hypercall */
-			c->eip = ctxt->vcpu->arch.rip;
+			c->eip = kvm_rip_read(ctxt->vcpu);
 			/* Disable writeback. */
 			c->dst.type = OP_NONE;
 			break;
@@ -1889,7 +1890,7 @@ twobyte_insn:
 		rc = kvm_set_msr(ctxt->vcpu, c->regs[VCPU_REGS_RCX], msr_data);
 		if (rc) {
 			kvm_inject_gp(ctxt->vcpu, 0);
-			c->eip = ctxt->vcpu->arch.rip;
+			c->eip = kvm_rip_read(ctxt->vcpu);
 		}
 		rc = X86EMUL_CONTINUE;
 		c->dst.type = OP_NONE;
@@ -1899,7 +1900,7 @@ twobyte_insn:
 		rc = kvm_get_msr(ctxt->vcpu, c->regs[VCPU_REGS_RCX], &msr_data);
 		if (rc) {
 			kvm_inject_gp(ctxt->vcpu, 0);
-			c->eip = ctxt->vcpu->arch.rip;
+			c->eip = kvm_rip_read(ctxt->vcpu);
 		} else {
 			c->regs[VCPU_REGS_RAX] = (u32)msr_data;
 			c->regs[VCPU_REGS_RDX] = msr_data >> 32;
diff --git a/include/asm-x86/kvm_host.h b/include/asm-x86/kvm_host.h
index c2e34c2..6187a1c 100644
--- a/include/asm-x86/kvm_host.h
+++ b/include/asm-x86/kvm_host.h
@@ -89,7 +89,7 @@ extern struct list_head vm_list;
 struct kvm_vcpu;
 struct kvm;
 
-enum {
+enum kvm_reg {
 	VCPU_REGS_RAX = 0,
 	VCPU_REGS_RCX = 1,
 	VCPU_REGS_RDX = 2,
@@ -108,6 +108,7 @@ enum {
 	VCPU_REGS_R14 = 14,
 	VCPU_REGS_R15 = 15,
 #endif
+	VCPU_REGS_RIP,
 	NR_VCPU_REGS
 };
 
@@ -219,8 +220,13 @@ struct kvm_vcpu_arch {
 	int interrupt_window_open;
 	unsigned long irq_summary; /* bit vector: 1 per word in irq_pending */
 	DECLARE_BITMAP(irq_pending, KVM_NR_INTERRUPTS);
-	unsigned long regs[NR_VCPU_REGS]; /* for rsp: vcpu_load_rsp_rip() */
-	unsigned long rip;      /* needs vcpu_load_rsp_rip() */
+	/*
+	 * rip and regs accesses must go through
+	 * kvm_{register,rip}_{read,write} functions.
+	 */
+	unsigned long regs[NR_VCPU_REGS];
+	u32 regs_avail;
+	u32 regs_dirty;
 
 	unsigned long cr0;
 	unsigned long cr2;
@@ -414,8 +420,7 @@ struct kvm_x86_ops {
 	unsigned long (*get_dr)(struct kvm_vcpu *vcpu, int dr);
 	void (*set_dr)(struct kvm_vcpu *vcpu, int dr, unsigned long value,
 		       int *exception);
-	void (*cache_regs)(struct kvm_vcpu *vcpu);
-	void (*decache_regs)(struct kvm_vcpu *vcpu);
+	void (*cache_reg)(struct kvm_vcpu *vcpu, enum kvm_reg reg);
 	unsigned long (*get_rflags)(struct kvm_vcpu *vcpu);
 	void (*set_rflags)(struct kvm_vcpu *vcpu, unsigned long rflags);
 
-- 
1.6.0.1

