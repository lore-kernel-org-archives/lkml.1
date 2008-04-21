Return-Path: <linux-kernel-owner+w=401wt.eu-S1757543AbYDUKcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543AbYDUKcV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 06:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756308AbYDUKaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 06:30:12 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:37873
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754632AbYDUKaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 06:30:02 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, "Feng (Eric) Liu" <eric.e.liu@intel.com>
Subject: [PATCH 06/31] KVM: Add trace markers
Date: Mon, 21 Apr 2008 13:29:32 +0300
Message-Id: <1208773797-7829-7-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208773797-7829-1-git-send-email-avi@qumranet.com>
References: <1208773797-7829-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Feng (Eric) Liu <eric.e.liu@intel.com>

Trace markers allow userspace to trace execution of a virtual machine
in order to monitor its performance.

Signed-off-by: Feng (Eric) Liu <eric.e.liu@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/vmx.c         |   35 ++++++++++++++++++++++++++++++-
 arch/x86/kvm/x86.c         |   26 +++++++++++++++++++++++
 include/asm-x86/kvm.h      |   20 ++++++++++++++++++
 include/asm-x86/kvm_host.h |   19 +++++++++++++++++
 include/linux/kvm.h        |   49 +++++++++++++++++++++++++++++++++++++++++++-
 5 files changed, 147 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 6249810..8e5d664 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1843,6 +1843,8 @@ static void vmx_inject_irq(struct kvm_vcpu *vcpu, int irq)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
+	KVMTRACE_1D(INJ_VIRQ, vcpu, (u32)irq, handler);
+
 	if (vcpu->arch.rmode.active) {
 		vmx->rmode.irq.pending = true;
 		vmx->rmode.irq.vector = irq;
@@ -1993,6 +1995,8 @@ static int handle_exception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		error_code = vmcs_read32(VM_EXIT_INTR_ERROR_CODE);
 	if (is_page_fault(intr_info)) {
 		cr2 = vmcs_readl(EXIT_QUALIFICATION);
+		KVMTRACE_3D(PAGE_FAULT, vcpu, error_code, (u32)cr2,
+			    (u32)((u64)cr2 >> 32), handler);
 		return kvm_mmu_page_fault(vcpu, cr2, error_code);
 	}
 
@@ -2021,6 +2025,7 @@ static int handle_external_interrupt(struct kvm_vcpu *vcpu,
 				     struct kvm_run *kvm_run)
 {
 	++vcpu->stat.irq_exits;
+	KVMTRACE_1D(INTR, vcpu, vmcs_read32(VM_EXIT_INTR_INFO), handler);
 	return 1;
 }
 
@@ -2078,6 +2083,8 @@ static int handle_cr(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	reg = (exit_qualification >> 8) & 15;
 	switch ((exit_qualification >> 4) & 3) {
 	case 0: /* mov to cr */
+		KVMTRACE_3D(CR_WRITE, vcpu, (u32)cr, (u32)vcpu->arch.regs[reg],
+			    (u32)((u64)vcpu->arch.regs[reg] >> 32), handler);
 		switch (cr) {
 		case 0:
 			vcpu_load_rsp_rip(vcpu);
@@ -2110,6 +2117,7 @@ static int handle_cr(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		vcpu->arch.cr0 &= ~X86_CR0_TS;
 		vmcs_writel(CR0_READ_SHADOW, vcpu->arch.cr0);
 		vmx_fpu_activate(vcpu);
+		KVMTRACE_0D(CLTS, vcpu, handler);
 		skip_emulated_instruction(vcpu);
 		return 1;
 	case 1: /*mov from cr*/
@@ -2118,12 +2126,18 @@ static int handle_cr(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 			vcpu_load_rsp_rip(vcpu);
 			vcpu->arch.regs[reg] = vcpu->arch.cr3;
 			vcpu_put_rsp_rip(vcpu);
+			KVMTRACE_3D(CR_READ, vcpu, (u32)cr,
+				    (u32)vcpu->arch.regs[reg],
+				    (u32)((u64)vcpu->arch.regs[reg] >> 32),
+				    handler);
 			skip_emulated_instruction(vcpu);
 			return 1;
 		case 8:
 			vcpu_load_rsp_rip(vcpu);
 			vcpu->arch.regs[reg] = kvm_get_cr8(vcpu);
 			vcpu_put_rsp_rip(vcpu);
+			KVMTRACE_2D(CR_READ, vcpu, (u32)cr,
+				    (u32)vcpu->arch.regs[reg], handler);
 			skip_emulated_instruction(vcpu);
 			return 1;
 		}
@@ -2169,6 +2183,7 @@ static int handle_dr(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 			val = 0;
 		}
 		vcpu->arch.regs[reg] = val;
+		KVMTRACE_2D(DR_READ, vcpu, (u32)dr, (u32)val, handler);
 	} else {
 		/* mov to dr */
 	}
@@ -2193,6 +2208,9 @@ static int handle_rdmsr(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		return 1;
 	}
 
+	KVMTRACE_3D(MSR_READ, vcpu, ecx, (u32)data, (u32)(data >> 32),
+		    handler);
+
 	/* FIXME: handling of bits 32:63 of rax, rdx */
 	vcpu->arch.regs[VCPU_REGS_RAX] = data & -1u;
 	vcpu->arch.regs[VCPU_REGS_RDX] = (data >> 32) & -1u;
@@ -2206,6 +2224,9 @@ static int handle_wrmsr(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	u64 data = (vcpu->arch.regs[VCPU_REGS_RAX] & -1u)
 		| ((u64)(vcpu->arch.regs[VCPU_REGS_RDX] & -1u) << 32);
 
+	KVMTRACE_3D(MSR_WRITE, vcpu, ecx, (u32)data, (u32)(data >> 32),
+		    handler);
+
 	if (vmx_set_msr(vcpu, ecx, data) != 0) {
 		kvm_inject_gp(vcpu, 0);
 		return 1;
@@ -2230,6 +2251,9 @@ static int handle_interrupt_window(struct kvm_vcpu *vcpu,
 	cpu_based_vm_exec_control = vmcs_read32(CPU_BASED_VM_EXEC_CONTROL);
 	cpu_based_vm_exec_control &= ~CPU_BASED_VIRTUAL_INTR_PENDING;
 	vmcs_write32(CPU_BASED_VM_EXEC_CONTROL, cpu_based_vm_exec_control);
+
+	KVMTRACE_0D(PEND_INTR, vcpu, handler);
+
 	/*
 	 * If the user space waits to inject interrupts, exit as soon as
 	 * possible
@@ -2272,6 +2296,8 @@ static int handle_apic_access(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	exit_qualification = vmcs_read64(EXIT_QUALIFICATION);
 	offset = exit_qualification & 0xffful;
 
+	KVMTRACE_1D(APIC_ACCESS, vcpu, (u32)offset, handler);
+
 	er = emulate_instruction(vcpu, kvm_run, 0, 0, 0);
 
 	if (er !=  EMULATE_DONE) {
@@ -2335,6 +2361,9 @@ static int kvm_handle_exit(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	u32 vectoring_info = vmx->idt_vectoring_info;
 
+	KVMTRACE_3D(VMEXIT, vcpu, exit_reason, (u32)vmcs_readl(GUEST_RIP),
+		    (u32)((u64)vmcs_readl(GUEST_RIP) >> 32), entryexit);
+
 	if (unlikely(vmx->fail)) {
 		kvm_run->exit_reason = KVM_EXIT_FAIL_ENTRY;
 		kvm_run->fail_entry.hardware_entry_failure_reason
@@ -2416,6 +2445,8 @@ static void vmx_intr_assist(struct kvm_vcpu *vcpu)
 			return;
 		}
 
+		KVMTRACE_1D(REDELIVER_EVT, vcpu, idtv_info_field, handler);
+
 		vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, idtv_info_field);
 		vmcs_write32(VM_ENTRY_INSTRUCTION_LEN,
 				vmcs_read32(VM_EXIT_INSTRUCTION_LEN));
@@ -2601,8 +2632,10 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
 
 	/* We need to handle NMIs before interrupts are enabled */
-	if ((intr_info & INTR_INFO_INTR_TYPE_MASK) == 0x200) /* nmi */
+	if ((intr_info & INTR_INFO_INTR_TYPE_MASK) == 0x200) { /* nmi */
+		KVMTRACE_0D(NMI, vcpu, handler);
 		asm("int $2");
+	}
 }
 
 static void vmx_free_vmcs(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c7ad235..f070f0a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -303,6 +303,9 @@ EXPORT_SYMBOL_GPL(kvm_set_cr0);
 void kvm_lmsw(struct kvm_vcpu *vcpu, unsigned long msw)
 {
 	kvm_set_cr0(vcpu, (vcpu->arch.cr0 & ~0x0ful) | (msw & 0x0f));
+	KVMTRACE_1D(LMSW, vcpu,
+		    (u32)((vcpu->arch.cr0 & ~0x0ful) | (msw & 0x0f)),
+		    handler);
 }
 EXPORT_SYMBOL_GPL(kvm_lmsw);
 
@@ -2269,6 +2272,13 @@ int kvm_emulate_pio(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
 	vcpu->arch.pio.guest_page_offset = 0;
 	vcpu->arch.pio.rep = 0;
 
+	if (vcpu->run->io.direction == KVM_EXIT_IO_IN)
+		KVMTRACE_2D(IO_READ, vcpu, vcpu->run->io.port, (u32)size,
+			    handler);
+	else
+		KVMTRACE_2D(IO_WRITE, vcpu, vcpu->run->io.port, (u32)size,
+			    handler);
+
 	kvm_x86_ops->cache_regs(vcpu);
 	memcpy(vcpu->arch.pio_data, &vcpu->arch.regs[VCPU_REGS_RAX], 4);
 	kvm_x86_ops->decache_regs(vcpu);
@@ -2307,6 +2317,13 @@ int kvm_emulate_pio_string(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
 	vcpu->arch.pio.guest_page_offset = offset_in_page(address);
 	vcpu->arch.pio.rep = rep;
 
+	if (vcpu->run->io.direction == KVM_EXIT_IO_IN)
+		KVMTRACE_2D(IO_READ, vcpu, vcpu->run->io.port, (u32)size,
+			    handler);
+	else
+		KVMTRACE_2D(IO_WRITE, vcpu, vcpu->run->io.port, (u32)size,
+			    handler);
+
 	if (!count) {
 		kvm_x86_ops->skip_emulated_instruction(vcpu);
 		return 1;
@@ -2414,6 +2431,7 @@ void kvm_arch_exit(void)
 int kvm_emulate_halt(struct kvm_vcpu *vcpu)
 {
 	++vcpu->stat.halt_exits;
+	KVMTRACE_0D(HLT, vcpu, handler);
 	if (irqchip_in_kernel(vcpu->kvm)) {
 		vcpu->arch.mp_state = VCPU_MP_STATE_HALTED;
 		up_read(&vcpu->kvm->slots_lock);
@@ -2451,6 +2469,8 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 	a2 = vcpu->arch.regs[VCPU_REGS_RDX];
 	a3 = vcpu->arch.regs[VCPU_REGS_RSI];
 
+	KVMTRACE_1D(VMMCALL, vcpu, (u32)nr, handler);
+
 	if (!is_long_mode(vcpu)) {
 		nr &= 0xFFFFFFFF;
 		a0 &= 0xFFFFFFFF;
@@ -2639,6 +2659,11 @@ void kvm_emulate_cpuid(struct kvm_vcpu *vcpu)
 	}
 	kvm_x86_ops->decache_regs(vcpu);
 	kvm_x86_ops->skip_emulated_instruction(vcpu);
+	KVMTRACE_5D(CPUID, vcpu, function,
+		    (u32)vcpu->arch.regs[VCPU_REGS_RAX],
+		    (u32)vcpu->arch.regs[VCPU_REGS_RBX],
+		    (u32)vcpu->arch.regs[VCPU_REGS_RCX],
+		    (u32)vcpu->arch.regs[VCPU_REGS_RDX], handler);
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_cpuid);
 
@@ -2794,6 +2819,7 @@ again:
 		if (test_and_clear_bit(KVM_REQ_TLB_FLUSH, &vcpu->requests))
 			kvm_x86_ops->tlb_flush(vcpu);
 
+	KVMTRACE_0D(VMENTRY, vcpu, entryexit);
 	kvm_x86_ops->run(vcpu, kvm_run);
 
 	vcpu->guest_mode = 0;
diff --git a/include/asm-x86/kvm.h b/include/asm-x86/kvm.h
index 12b4b25..80eefef 100644
--- a/include/asm-x86/kvm.h
+++ b/include/asm-x86/kvm.h
@@ -209,4 +209,24 @@ struct kvm_pit_state {
 	struct kvm_pit_channel_state channels[3];
 };
 
+#define KVM_TRC_INJ_VIRQ         (KVM_TRC_HANDLER + 0x02)
+#define KVM_TRC_REDELIVER_EVT    (KVM_TRC_HANDLER + 0x03)
+#define KVM_TRC_PEND_INTR        (KVM_TRC_HANDLER + 0x04)
+#define KVM_TRC_IO_READ          (KVM_TRC_HANDLER + 0x05)
+#define KVM_TRC_IO_WRITE         (KVM_TRC_HANDLER + 0x06)
+#define KVM_TRC_CR_READ          (KVM_TRC_HANDLER + 0x07)
+#define KVM_TRC_CR_WRITE         (KVM_TRC_HANDLER + 0x08)
+#define KVM_TRC_DR_READ          (KVM_TRC_HANDLER + 0x09)
+#define KVM_TRC_DR_WRITE         (KVM_TRC_HANDLER + 0x0A)
+#define KVM_TRC_MSR_READ         (KVM_TRC_HANDLER + 0x0B)
+#define KVM_TRC_MSR_WRITE        (KVM_TRC_HANDLER + 0x0C)
+#define KVM_TRC_CPUID            (KVM_TRC_HANDLER + 0x0D)
+#define KVM_TRC_INTR             (KVM_TRC_HANDLER + 0x0E)
+#define KVM_TRC_NMI              (KVM_TRC_HANDLER + 0x0F)
+#define KVM_TRC_VMMCALL          (KVM_TRC_HANDLER + 0x10)
+#define KVM_TRC_HLT              (KVM_TRC_HANDLER + 0x11)
+#define KVM_TRC_CLTS             (KVM_TRC_HANDLER + 0x12)
+#define KVM_TRC_LMSW             (KVM_TRC_HANDLER + 0x13)
+#define KVM_TRC_APIC_ACCESS      (KVM_TRC_HANDLER + 0x14)
+
 #endif
diff --git a/include/asm-x86/kvm_host.h b/include/asm-x86/kvm_host.h
index 2861178..15169cb 100644
--- a/include/asm-x86/kvm_host.h
+++ b/include/asm-x86/kvm_host.h
@@ -667,4 +667,23 @@ enum {
 	TASK_SWITCH_GATE = 3,
 };
 
+#define KVMTRACE_5D(evt, vcpu, d1, d2, d3, d4, d5, name) \
+	trace_mark(kvm_trace_##name, "%u %p %u %u %u %u %u %u", KVM_TRC_##evt, \
+						vcpu, 5, d1, d2, d3, d4, d5)
+#define KVMTRACE_4D(evt, vcpu, d1, d2, d3, d4, name) \
+	trace_mark(kvm_trace_##name, "%u %p %u %u %u %u %u %u", KVM_TRC_##evt, \
+						vcpu, 4, d1, d2, d3, d4, 0)
+#define KVMTRACE_3D(evt, vcpu, d1, d2, d3, name) \
+	trace_mark(kvm_trace_##name, "%u %p %u %u %u %u %u %u", KVM_TRC_##evt, \
+						vcpu, 3, d1, d2, d3, 0, 0)
+#define KVMTRACE_2D(evt, vcpu, d1, d2, name) \
+	trace_mark(kvm_trace_##name, "%u %p %u %u %u %u %u %u", KVM_TRC_##evt, \
+						vcpu, 2, d1, d2, 0, 0, 0)
+#define KVMTRACE_1D(evt, vcpu, d1, name) \
+	trace_mark(kvm_trace_##name, "%u %p %u %u %u %u %u %u", KVM_TRC_##evt, \
+						vcpu, 1, d1, 0, 0, 0, 0)
+#define KVMTRACE_0D(evt, vcpu, name) \
+	trace_mark(kvm_trace_##name, "%u %p %u %u %u %u %u %u", KVM_TRC_##evt, \
+						vcpu, 0, 0, 0, 0, 0, 0)
+
 #endif
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index f04bb42..d302d63 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -14,6 +14,12 @@
 
 #define KVM_API_VERSION 12
 
+/* for KVM_TRACE_ENABLE */
+struct kvm_user_trace_setup {
+	__u32 buf_size; /* sub_buffer size of each per-cpu */
+	__u32 buf_nr; /* the number of sub_buffers of each per-cpu */
+};
+
 /* for KVM_CREATE_MEMORY_REGION */
 struct kvm_memory_region {
 	__u32 slot;
@@ -242,6 +248,42 @@ struct kvm_s390_interrupt {
 	__u64 parm64;
 };
 
+#define KVM_TRC_SHIFT           16
+/*
+ * kvm trace categories
+ */
+#define KVM_TRC_ENTRYEXIT       (1 << KVM_TRC_SHIFT)
+#define KVM_TRC_HANDLER         (1 << (KVM_TRC_SHIFT + 1)) /* only 12 bits */
+
+/*
+ * kvm trace action
+ */
+#define KVM_TRC_VMENTRY         (KVM_TRC_ENTRYEXIT + 0x01)
+#define KVM_TRC_VMEXIT          (KVM_TRC_ENTRYEXIT + 0x02)
+#define KVM_TRC_PAGE_FAULT      (KVM_TRC_HANDLER + 0x01)
+
+#define KVM_TRC_HEAD_SIZE       12
+#define KVM_TRC_CYCLE_SIZE      8
+#define KVM_TRC_EXTRA_MAX       7
+
+/* This structure represents a single trace buffer record. */
+struct kvm_trace_rec {
+	__u32 event:28;
+	__u32 extra_u32:3;
+	__u32 cycle_in:1;
+	__u32 pid;
+	__u32 vcpu_id;
+	union {
+		struct {
+			__u32 cycle_lo, cycle_hi;
+			__u32 extra_u32[KVM_TRC_EXTRA_MAX];
+		} cycle;
+		struct {
+			__u32 extra_u32[KVM_TRC_EXTRA_MAX];
+		} nocycle;
+	} u;
+};
+
 #define KVMIO 0xAE
 
 /*
@@ -262,7 +304,12 @@ struct kvm_s390_interrupt {
  */
 #define KVM_GET_VCPU_MMAP_SIZE    _IO(KVMIO,   0x04) /* in bytes */
 #define KVM_GET_SUPPORTED_CPUID   _IOWR(KVMIO, 0x05, struct kvm_cpuid2)
-
+/*
+ * ioctls for kvm trace
+ */
+#define KVM_TRACE_ENABLE          _IOW(KVMIO, 0x06, struct kvm_user_trace_setup)
+#define KVM_TRACE_PAUSE           _IO(KVMIO,  0x07)
+#define KVM_TRACE_DISABLE         _IO(KVMIO,  0x08)
 /*
  * Extension capability list.
  */
-- 
1.5.5

