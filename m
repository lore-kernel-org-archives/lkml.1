Return-Path: <linux-kernel-owner+w=401wt.eu-S1760774AbYGQQBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760774AbYGQQBR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 12:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757557AbYGQQAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 12:00:45 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:58835 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755043AbYGQQAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 12:00:43 -0400
Message-Id: <20080717160003.359557938@polymtl.ca>
References: <20080717155724.897537670@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 17 Jul 2008 11:57:28 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Avi Kivity <avi@qumranet.com>, kvm@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "Feng(Eric) Liu" <eric.e.liu@intel.com>
Subject: [patch 4/4] KVM-trace port to tracepoints
Content-Disposition: inline; filename=kvm-trace-port-to-tracepoints.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Thu, 17 Jul 2008 16:00:14 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Port/cleanup of KVM-trace to tracepoints.

Tracepoints allow dormat instrumentation, like the kernel markers, but also
allows to describe the trace points in global headers so they can be easily
managed. They also do not use format strings.

Anything that would involve an action (dereference a pointer, vmcs read, ...)
only required when tracing is placed in the probes created in kvm_trace.c

This patch depends on the "Tracepoints" patch.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: 'Peter Zijlstra' <peterz@infradead.org>
CC: 'Feng(Eric) Liu' <eric.e.liu@intel.com>
CC: Avi Kivity <avi@qumranet.com>
CC: kvm@vger.kernel.org
---
 arch/x86/kvm/vmx.c   |   38 ++---
 arch/x86/kvm/x86.c   |   43 ++----
 include/trace/kvm.h  |   83 ++++++++++++
 virt/kvm/kvm_trace.c |  336 +++++++++++++++++++++++++++++++++++++++++++--------
 4 files changed, 398 insertions(+), 102 deletions(-)

Index: linux-2.6-lttng/arch/x86/kvm/vmx.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kvm/vmx.c	2008-07-17 11:54:36.000000000 -0400
+++ linux-2.6-lttng/arch/x86/kvm/vmx.c	2008-07-17 11:54:54.000000000 -0400
@@ -26,6 +26,7 @@
 #include <linux/highmem.h>
 #include <linux/sched.h>
 #include <linux/moduleparam.h>
+#include <trace/kvm.h>
 #include "x86.h"
 
 #include <asm/kvm_cache_regs.h>
@@ -2094,7 +2095,7 @@ static void vmx_inject_irq(struct kvm_vc
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
-	KVMTRACE_1D(INJ_VIRQ, vcpu, (u32)irq, handler);
+	trace_kvm_inj_virq(vcpu, irq);
 
 	if (vcpu->arch.rmode.active) {
 		vmx->rmode.irq.pending = true;
@@ -2252,8 +2253,7 @@ static int handle_exception(struct kvm_v
 		if (vm_need_ept())
 			BUG();
 		cr2 = vmcs_readl(EXIT_QUALIFICATION);
-		KVMTRACE_3D(PAGE_FAULT, vcpu, error_code, (u32)cr2,
-			    (u32)((u64)cr2 >> 32), handler);
+		trace_kvm_page_fault(vcpu, error_code, cr2);
 		return kvm_mmu_page_fault(vcpu, cr2, error_code);
 	}
 
@@ -2282,7 +2282,7 @@ static int handle_external_interrupt(str
 				     struct kvm_run *kvm_run)
 {
 	++vcpu->stat.irq_exits;
-	KVMTRACE_1D(INTR, vcpu, vmcs_read32(VM_EXIT_INTR_INFO), handler);
+	trace_kvm_intr(vcpu);
 	return 1;
 }
 
@@ -2340,10 +2340,7 @@ static int handle_cr(struct kvm_vcpu *vc
 	reg = (exit_qualification >> 8) & 15;
 	switch ((exit_qualification >> 4) & 3) {
 	case 0: /* mov to cr */
-		KVMTRACE_3D(CR_WRITE, vcpu, (u32)cr,
-			    (u32)kvm_register_read(vcpu, reg),
-			    (u32)((u64)kvm_register_read(vcpu, reg) >> 32),
-			    handler);
+		trace_kvm_cr_write(vcpu, cr, reg);
 		switch (cr) {
 		case 0:
 			kvm_set_cr0(vcpu, kvm_register_read(vcpu, reg));
@@ -2371,23 +2368,19 @@ static int handle_cr(struct kvm_vcpu *vc
 		vcpu->arch.cr0 &= ~X86_CR0_TS;
 		vmcs_writel(CR0_READ_SHADOW, vcpu->arch.cr0);
 		vmx_fpu_activate(vcpu);
-		KVMTRACE_0D(CLTS, vcpu, handler);
+		trace_kvm_clts(vcpu);
 		skip_emulated_instruction(vcpu);
 		return 1;
 	case 1: /*mov from cr*/
 		switch (cr) {
 		case 3:
 			kvm_register_write(vcpu, reg, vcpu->arch.cr3);
-			KVMTRACE_3D(CR_READ, vcpu, (u32)cr,
-				    (u32)kvm_register_read(vcpu, reg),
-				    (u32)((u64)kvm_register_read(vcpu, reg) >> 32),
-				    handler);
+			trace_kvm_cr_read(vcpu, cr, reg);
 			skip_emulated_instruction(vcpu);
 			return 1;
 		case 8:
 			kvm_register_write(vcpu, reg, kvm_get_cr8(vcpu));
-			KVMTRACE_2D(CR_READ, vcpu, (u32)cr,
-				    (u32)kvm_register_read(vcpu, reg), handler);
+			trace_kvm_cr_read(vcpu, cr, reg);
 			skip_emulated_instruction(vcpu);
 			return 1;
 		}
@@ -2432,7 +2425,7 @@ static int handle_dr(struct kvm_vcpu *vc
 			val = 0;
 		}
 		kvm_register_write(vcpu, reg, val);
-		KVMTRACE_2D(DR_READ, vcpu, (u32)dr, (u32)val, handler);
+		trace_kvm_dr_read(vcpu, dr, val);
 	} else {
 		/* mov to dr */
 	}
@@ -2456,8 +2449,7 @@ static int handle_rdmsr(struct kvm_vcpu 
 		return 1;
 	}
 
-	KVMTRACE_3D(MSR_READ, vcpu, ecx, (u32)data, (u32)(data >> 32),
-		    handler);
+	trace_kvm_msr_read(vcpu, ecx, data);
 
 	/* FIXME: handling of bits 32:63 of rax, rdx */
 	vcpu->arch.regs[VCPU_REGS_RAX] = data & -1u;
@@ -2472,8 +2464,7 @@ static int handle_wrmsr(struct kvm_vcpu 
 	u64 data = (vcpu->arch.regs[VCPU_REGS_RAX] & -1u)
 		| ((u64)(vcpu->arch.regs[VCPU_REGS_RDX] & -1u) << 32);
 
-	KVMTRACE_3D(MSR_WRITE, vcpu, ecx, (u32)data, (u32)(data >> 32),
-		    handler);
+	trace_kvm_msr_write(vcpu, ecx, data);
 
 	if (vmx_set_msr(vcpu, ecx, data) != 0) {
 		kvm_inject_gp(vcpu, 0);
@@ -2500,7 +2491,7 @@ static int handle_interrupt_window(struc
 	cpu_based_vm_exec_control &= ~CPU_BASED_VIRTUAL_INTR_PENDING;
 	vmcs_write32(CPU_BASED_VM_EXEC_CONTROL, cpu_based_vm_exec_control);
 
-	KVMTRACE_0D(PEND_INTR, vcpu, handler);
+	trace_kvm_pend_intr(vcpu);
 
 	/*
 	 * If the user space waits to inject interrupts, exit as soon as
@@ -2680,8 +2671,7 @@ static int kvm_handle_exit(struct kvm_ru
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	u32 vectoring_info = vmx->idt_vectoring_info;
 
-	KVMTRACE_3D(VMEXIT, vcpu, exit_reason, (u32)kvm_rip_read(vcpu),
-		    (u32)((u64)kvm_rip_read(vcpu) >> 32), entryexit);
+	trace_kvm_vmexit(vcpu, exit_reason);
 
 	/* Access CR3 don't cause VMExit in paging mode, so we need
 	 * to sync with guest real CR3. */
@@ -3037,7 +3027,7 @@ static void vmx_vcpu_run(struct kvm_vcpu
 	/* We need to handle NMIs before interrupts are enabled */
 	if ((intr_info & INTR_INFO_INTR_TYPE_MASK) == 0x200 &&
 	    (intr_info & INTR_INFO_VALID_MASK)) {
-		KVMTRACE_0D(NMI, vcpu, handler);
+		trace_kvm_nmi(vcpu);
 		asm("int $2");
 	}
 
Index: linux-2.6-lttng/arch/x86/kvm/x86.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kvm/x86.c	2008-07-17 11:54:36.000000000 -0400
+++ linux-2.6-lttng/arch/x86/kvm/x86.c	2008-07-17 11:54:37.000000000 -0400
@@ -28,6 +28,7 @@
 #include <linux/module.h>
 #include <linux/mman.h>
 #include <linux/highmem.h>
+#include <trace/kvm.h>
 
 #include <asm/kvm_cache_regs.h>
 #include <asm/uaccess.h>
@@ -312,10 +313,10 @@ EXPORT_SYMBOL_GPL(kvm_set_cr0);
 
 void kvm_lmsw(struct kvm_vcpu *vcpu, unsigned long msw)
 {
-	kvm_set_cr0(vcpu, (vcpu->arch.cr0 & ~0x0ful) | (msw & 0x0f));
-	KVMTRACE_1D(LMSW, vcpu,
-		    (u32)((vcpu->arch.cr0 & ~0x0ful) | (msw & 0x0f)),
-		    handler);
+	unsigned long cr0 = (vcpu->arch.cr0 & ~0x0ful) | (msw & 0x0f);
+
+	kvm_set_cr0(vcpu, cr0);
+	trace_kvm_lmsw(vcpu, cr0);
 }
 EXPORT_SYMBOL_GPL(kvm_lmsw);
 
@@ -2045,7 +2046,7 @@ int emulate_invlpg(struct kvm_vcpu *vcpu
 
 int emulate_clts(struct kvm_vcpu *vcpu)
 {
-	KVMTRACE_0D(CLTS, vcpu, handler);
+	trace_kvm_clts(vcpu);
 	kvm_x86_ops->set_cr0(vcpu, vcpu->arch.cr0 & ~X86_CR0_TS);
 	return X86EMUL_CONTINUE;
 }
@@ -2345,12 +2346,7 @@ int kvm_emulate_pio(struct kvm_vcpu *vcp
 	vcpu->arch.pio.guest_page_offset = 0;
 	vcpu->arch.pio.rep = 0;
 
-	if (vcpu->run->io.direction == KVM_EXIT_IO_IN)
-		KVMTRACE_2D(IO_READ, vcpu, vcpu->run->io.port, (u32)size,
-			    handler);
-	else
-		KVMTRACE_2D(IO_WRITE, vcpu, vcpu->run->io.port, (u32)size,
-			    handler);
+	trace_kvm_io(vcpu, size);
 
 	val = kvm_register_read(vcpu, VCPU_REGS_RAX);
 	memcpy(vcpu->arch.pio_data, &val, 4);
@@ -2389,12 +2385,7 @@ int kvm_emulate_pio_string(struct kvm_vc
 	vcpu->arch.pio.guest_page_offset = offset_in_page(address);
 	vcpu->arch.pio.rep = rep;
 
-	if (vcpu->run->io.direction == KVM_EXIT_IO_IN)
-		KVMTRACE_2D(IO_READ, vcpu, vcpu->run->io.port, (u32)size,
-			    handler);
-	else
-		KVMTRACE_2D(IO_WRITE, vcpu, vcpu->run->io.port, (u32)size,
-			    handler);
+	trace_kvm_io(vcpu, size);
 
 	if (!count) {
 		kvm_x86_ops->skip_emulated_instruction(vcpu);
@@ -2508,7 +2499,7 @@ void kvm_arch_exit(void)
 int kvm_emulate_halt(struct kvm_vcpu *vcpu)
 {
 	++vcpu->stat.halt_exits;
-	KVMTRACE_0D(HLT, vcpu, handler);
+	trace_kvm_hlt(vcpu);
 	if (irqchip_in_kernel(vcpu->kvm)) {
 		vcpu->arch.mp_state = KVM_MP_STATE_HALTED;
 		up_read(&vcpu->kvm->slots_lock);
@@ -2544,7 +2535,7 @@ int kvm_emulate_hypercall(struct kvm_vcp
 	a2 = kvm_register_read(vcpu, VCPU_REGS_RDX);
 	a3 = kvm_register_read(vcpu, VCPU_REGS_RSI);
 
-	KVMTRACE_1D(VMMCALL, vcpu, (u32)nr, handler);
+	trace_kvm_vmmcall(vcpu, nr);
 
 	if (!is_long_mode(vcpu)) {
 		nr &= 0xFFFFFFFF;
@@ -2644,8 +2635,7 @@ unsigned long realmode_get_cr(struct kvm
 		vcpu_printf(vcpu, "%s: unexpected cr %u\n", __func__, cr);
 		return 0;
 	}
-	KVMTRACE_3D(CR_READ, vcpu, (u32)cr, (u32)value,
-		    (u32)((u64)value >> 32), handler);
+	trace_kvm_cr_read_realmode(vcpu, cr, value);
 
 	return value;
 }
@@ -2653,8 +2643,7 @@ unsigned long realmode_get_cr(struct kvm
 void realmode_set_cr(struct kvm_vcpu *vcpu, int cr, unsigned long val,
 		     unsigned long *rflags)
 {
-	KVMTRACE_3D(CR_WRITE, vcpu, (u32)cr, (u32)val,
-		    (u32)((u64)val >> 32), handler);
+	trace_kvm_cr_write_realmode(vcpu, cr, val);
 
 	switch (cr) {
 	case 0:
@@ -2745,11 +2734,7 @@ void kvm_emulate_cpuid(struct kvm_vcpu *
 		kvm_register_write(vcpu, VCPU_REGS_RDX, best->edx);
 	}
 	kvm_x86_ops->skip_emulated_instruction(vcpu);
-	KVMTRACE_5D(CPUID, vcpu, function,
-		    (u32)kvm_register_read(vcpu, VCPU_REGS_RAX),
-		    (u32)kvm_register_read(vcpu, VCPU_REGS_RBX),
-		    (u32)kvm_register_read(vcpu, VCPU_REGS_RCX),
-		    (u32)kvm_register_read(vcpu, VCPU_REGS_RDX), handler);
+	trace_kvm_cpuid(vcpu, function);
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_cpuid);
 
@@ -2904,8 +2889,8 @@ again:
 
 	kvm_guest_enter();
 
+	trace_kvm_vmentry(vcpu);
 
-	KVMTRACE_0D(VMENTRY, vcpu, entryexit);
 	kvm_x86_ops->run(vcpu, kvm_run);
 
 	vcpu->guest_mode = 0;
Index: linux-2.6-lttng/include/trace/kvm.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/trace/kvm.h	2008-07-17 11:54:37.000000000 -0400
@@ -0,0 +1,83 @@
+#ifndef _TRACE_KVM_H
+#define _TRACE_KVM_H
+
+#include <linux/kvm_host.h>
+#include <linux/tracepoint.h>
+
+/*
+ * ENTRYEXIT events.
+ */
+DEFINE_TRACE(kvm_vmentry,
+	TPPROTO(struct kvm_vcpu *vcpu),
+	TPARGS(vcpu));
+DEFINE_TRACE(kvm_vmexit,
+	TPPROTO(struct kvm_vcpu *vcpu, u32 exit_reason),
+	TPARGS(vcpu, exit_reason));
+
+/*
+ * HANDLER events.
+ */
+DEFINE_TRACE(kvm_page_fault,
+	TPPROTO(struct kvm_vcpu *vcpu, u32 error_code, unsigned long cr2),
+	TPARGS(vcpu, error_code, cr2));
+
+DEFINE_TRACE(kvm_inj_virq,
+	TPPROTO(struct kvm_vcpu *vcpu, int irq),
+	TPARGS(vcpu, irq));
+DEFINE_TRACE(kvm_redeliver_evt,
+	TPPROTO(struct kvm_vcpu *vcpu, u32 idtv_info_field),
+	TPARGS(vcpu, idtv_info_field));
+DEFINE_TRACE(kvm_pend_intr,
+	TPPROTO(struct kvm_vcpu *vcpu),
+	TPARGS(vcpu));
+DEFINE_TRACE(kvm_io,
+	TPPROTO(struct kvm_vcpu *vcpu, int size),
+	TPARGS(vcpu, size));
+DEFINE_TRACE(kvm_cr_read,
+	TPPROTO(struct kvm_vcpu *vcpu, int cr, int reg),
+	TPARGS(vcpu, cr, reg));
+DEFINE_TRACE(kvm_cr_write,
+	TPPROTO(struct kvm_vcpu *vcpu, int cr, int reg),
+	TPARGS(vcpu, cr, reg));
+DEFINE_TRACE(kvm_cr_read_realmode,
+	TPPROTO(struct kvm_vcpu *vcpu, int cr, unsigned long value),
+	TPARGS(vcpu, cr, value));
+DEFINE_TRACE(kvm_cr_write_realmode,
+	TPPROTO(struct kvm_vcpu *vcpu, int cr, unsigned long value),
+	TPARGS(vcpu, cr, value));
+DEFINE_TRACE(kvm_dr_read,
+	TPPROTO(struct kvm_vcpu *vcpu, int dr, unsigned long val),
+	TPARGS(vcpu, dr, val));
+/* FIXME : missing dr_write in the original instrumentation */
+DEFINE_TRACE(kvm_msr_read,
+	TPPROTO(struct kvm_vcpu *vcpu, u32 ecx, u64 data),
+	TPARGS(vcpu, ecx, data));
+DEFINE_TRACE(kvm_msr_write,
+	TPPROTO(struct kvm_vcpu *vcpu, u32 ecx, u64 data),
+	TPARGS(vcpu, ecx, data));
+DEFINE_TRACE(kvm_cpuid,
+	TPPROTO(struct kvm_vcpu *vcpu, u32 function),
+	TPARGS(vcpu, function));
+DEFINE_TRACE(kvm_intr,
+	TPPROTO(struct kvm_vcpu *vcpu),
+	TPARGS(vcpu));
+DEFINE_TRACE(kvm_nmi,
+	TPPROTO(struct kvm_vcpu *vcpu),
+	TPARGS(vcpu));
+DEFINE_TRACE(kvm_vmmcall,
+	TPPROTO(struct kvm_vcpu *vcpu, unsigned long nr),
+	TPARGS(vcpu, nr));
+DEFINE_TRACE(kvm_hlt,
+	TPPROTO(struct kvm_vcpu *vcpu),
+	TPARGS(vcpu));
+DEFINE_TRACE(kvm_clts,
+	TPPROTO(struct kvm_vcpu *vcpu),
+	TPARGS(vcpu));
+DEFINE_TRACE(kvm_lmsw,
+	TPPROTO(struct kvm_vcpu *vcpu, unsigned long cr0),
+	TPARGS(vcpu, cr0));
+DEFINE_TRACE(kvm_apic_access,
+	TPPROTO(struct kvm_vcpu *vcpu, unsigned long offset),
+	TPARGS(vcpu, offset));
+
+#endif
Index: linux-2.6-lttng/virt/kvm/kvm_trace.c
===================================================================
--- linux-2.6-lttng.orig/virt/kvm/kvm_trace.c	2008-07-17 11:54:12.000000000 -0400
+++ linux-2.6-lttng/virt/kvm/kvm_trace.c	2008-07-17 11:55:40.000000000 -0400
@@ -6,6 +6,7 @@
  * it's possible to reconstruct a chronological record of trace events.
  * The implementation refers to blktrace kernel support.
  *
+ * Copyright (c) 2008 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
  * Copyright (c) 2008 Intel Corporation
  * Copyright (C) 2006 Jens Axboe <axboe@kernel.dk>
  *
@@ -19,6 +20,8 @@
 #include <linux/debugfs.h>
 
 #include <linux/kvm_host.h>
+#include <trace/kvm.h>
+#include <asm/kvm_cache_regs.h>
 
 #define KVM_TRACE_STATE_RUNNING 	(1 << 0)
 #define KVM_TRACE_STATE_PAUSE 		(1 << 1)
@@ -32,12 +35,8 @@ struct kvm_trace {
 };
 static struct kvm_trace *kvm_trace;
 
-struct kvm_trace_probe {
-	const char *name;
-	const char *format;
-	u32 cycle_in;
-	marker_probe_func *probe_func;
-};
+static int register_tracepoints(void);
+static void unregister_tracepoints(void);
 
 static inline int calc_rec_size(int cycle, int extra)
 {
@@ -47,48 +46,58 @@ static inline int calc_rec_size(int cycl
 	return cycle ? rec_size += KVM_TRC_CYCLE_SIZE : rec_size;
 }
 
-static void kvm_add_trace(void *probe_private, void *call_data,
-			  const char *format, va_list *args)
+static void kvm_add_trace_timestamp(unsigned int evid, struct kvm_vcpu *vcpu,
+		int nr_args, u32 *args)
 {
-	struct kvm_trace_probe *p = probe_private;
 	struct kvm_trace *kt = kvm_trace;
 	struct kvm_trace_rec rec;
-	struct kvm_vcpu *vcpu;
-	int    i, extra, size;
+	int    size;
 
 	if (unlikely(kt->trace_state != KVM_TRACE_STATE_RUNNING))
 		return;
 
-	rec.event	= va_arg(*args, u32);
-	vcpu		= va_arg(*args, struct kvm_vcpu *);
+	rec.event	= evid;
 	rec.pid		= current->tgid;
 	rec.vcpu_id	= vcpu->vcpu_id;
+	rec.cycle_in 	= 1;
 
-	extra   	= va_arg(*args, u32);
-	WARN_ON(!(extra <= KVM_TRC_EXTRA_MAX));
-	extra 		= min_t(u32, extra, KVM_TRC_EXTRA_MAX);
-	rec.extra_u32   = extra;
-
-	rec.cycle_in 	= p->cycle_in;
-
-	if (rec.cycle_in) {
-		rec.u.cycle.cycle_u64 = get_cycles();
-
-		for (i = 0; i < rec.extra_u32; i++)
-			rec.u.cycle.extra_u32[i] = va_arg(*args, u32);
-	} else {
-		for (i = 0; i < rec.extra_u32; i++)
-			rec.u.nocycle.extra_u32[i] = va_arg(*args, u32);
-	}
+	WARN_ON(!(nr_args <= KVM_TRC_EXTRA_MAX));
+	nr_args		= min_t(u32, nr_args, KVM_TRC_EXTRA_MAX);
+	rec.extra_u32   = nr_args;
+
+	rec.u.cycle.cycle_u64 = get_cycles();
+	if (nr_args > 0)
+		memcpy(rec.u.cycle.extra_u32, args, nr_args * sizeof(u32));
 
 	size = calc_rec_size(rec.cycle_in, rec.extra_u32 * sizeof(u32));
 	relay_write(kt->rchan, &rec, size);
 }
 
-static struct kvm_trace_probe kvm_trace_probes[] = {
-	{ "kvm_trace_entryexit", "%u %p %u %u %u %u %u %u", 1, kvm_add_trace },
-	{ "kvm_trace_handler", "%u %p %u %u %u %u %u %u", 0, kvm_add_trace },
-};
+static void kvm_add_trace(unsigned int evid, struct kvm_vcpu *vcpu,
+		int nr_args, u32 *args)
+{
+	struct kvm_trace *kt = kvm_trace;
+	struct kvm_trace_rec rec;
+	int    size;
+
+	if (unlikely(kt->trace_state != KVM_TRACE_STATE_RUNNING))
+		return;
+
+	rec.event	= evid;
+	rec.pid		= current->tgid;
+	rec.vcpu_id	= vcpu->vcpu_id;
+	rec.cycle_in 	= 0;
+
+	WARN_ON(!(nr_args <= KVM_TRC_EXTRA_MAX));
+	nr_args		= min_t(u32, nr_args, KVM_TRC_EXTRA_MAX);
+	rec.extra_u32   = nr_args;
+
+	if (nr_args > 0)
+		memcpy(rec.u.nocycle.extra_u32, args, nr_args * sizeof(u32));
+
+	size = calc_rec_size(rec.cycle_in, rec.extra_u32 * sizeof(u32));
+	relay_write(kt->rchan, &rec, size);
+}
 
 static int lost_records_get(void *data, u64 *val)
 {
@@ -154,7 +163,7 @@ static struct rchan_callbacks kvm_relay_
 static int do_kvm_trace_enable(struct kvm_user_trace_setup *kuts)
 {
 	struct kvm_trace *kt;
-	int i, r = -ENOMEM;
+	int r = -ENOMEM;
 
 	if (!kuts->buf_size || !kuts->buf_nr)
 		return -EINVAL;
@@ -177,14 +186,8 @@ static int do_kvm_trace_enable(struct kv
 
 	kvm_trace = kt;
 
-	for (i = 0; i < ARRAY_SIZE(kvm_trace_probes); i++) {
-		struct kvm_trace_probe *p = &kvm_trace_probes[i];
-
-		r = marker_probe_register(p->name, p->format, p->probe_func, p);
-		if (r)
-			printk(KERN_INFO "Unable to register probe %s\n",
-			       p->name);
-	}
+	r = register_tracepoints();
+	WARN_ON(r);
 
 	kvm_trace->trace_state = KVM_TRACE_STATE_RUNNING;
 
@@ -236,7 +239,6 @@ static int kvm_trace_pause(void)
 void kvm_trace_cleanup(void)
 {
 	struct kvm_trace *kt = kvm_trace;
-	int i;
 
 	if (kt == NULL)
 		return;
@@ -245,12 +247,7 @@ void kvm_trace_cleanup(void)
 	    kt->trace_state == KVM_TRACE_STATE_PAUSE) {
 
 		kt->trace_state = KVM_TRACE_STATE_CLEARUP;
-
-		for (i = 0; i < ARRAY_SIZE(kvm_trace_probes); i++) {
-			struct kvm_trace_probe *p = &kvm_trace_probes[i];
-			marker_probe_unregister(p->name, p->probe_func, p);
-		}
-
+		unregister_tracepoints();
 		relay_close(kt->rchan);
 		debugfs_remove(kt->lost_file);
 		kfree(kt);
@@ -280,3 +277,244 @@ int kvm_trace_ioctl(unsigned int ioctl, 
 
 	return r;
 }
+
+/*
+ * Tracepoint probes for KVM-trace.
+ *
+ * The probes end up calling either kvm_add_trace_timestamp (the cycle counter
+ * is read) or kvm_add_trace (no timestamp saved in the trace).
+ */
+
+/*
+ * Probes with timestamp.
+ */
+static void probe_kvm_vmentry(struct kvm_vcpu *vcpu)
+{
+	kvm_add_trace_timestamp(KVM_TRC_VMENTRY, vcpu, 0, NULL);
+}
+
+static void probe_kvm_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason)
+{
+	kvm_add_trace_timestamp(KVM_TRC_VMEXIT, vcpu, 3,
+		(u32 []){ exit_reason,
+		(u32)kvm_rip_read(vcpu),
+		(u32)((u64)kvm_rip_read(vcpu) >> 32) });
+}
+
+/*
+ * Probes without timestamp.
+ */
+static void probe_kvm_page_fault(struct kvm_vcpu *vcpu, u32 error_code,
+		unsigned long cr2)
+{
+	kvm_add_trace(KVM_TRC_PAGE_FAULT, vcpu, 3,
+		(u32 []){ error_code, (u32)cr2, (u32)((u64)cr2 >> 32) });
+}
+
+static void probe_kvm_inj_virq(struct kvm_vcpu *vcpu, int irq)
+{
+	kvm_add_trace(KVM_TRC_VMENTRY, vcpu, 1, (u32 []){ (u32)irq });
+}
+
+static void probe_kvm_redeliver_evt(struct kvm_vcpu *vcpu, u32 idtv_info_field)
+{
+	kvm_add_trace(KVM_TRC_REDELIVER_EVT, vcpu, 1,
+		(u32 []){ idtv_info_field });
+}
+
+static void probe_kvm_pend_intr(struct kvm_vcpu *vcpu)
+{
+	kvm_add_trace(KVM_TRC_PEND_INTR, vcpu, 0, NULL);
+}
+
+static void probe_kvm_io(struct kvm_vcpu *vcpu, int size)
+{
+	if (vcpu->run->io.direction == KVM_EXIT_IO_IN)
+		kvm_add_trace(KVM_TRC_IO_READ, vcpu, 2,
+			(u32 []){ vcpu->run->io.port, (u32)size });
+	else
+		kvm_add_trace(KVM_TRC_IO_WRITE, vcpu, 2,
+			(u32 []){ vcpu->run->io.port, (u32)size });
+}
+
+static void probe_kvm_cr_read(struct kvm_vcpu *vcpu, int cr, int reg)
+{
+	switch (cr) {
+	case 3:
+		kvm_add_trace(KVM_TRC_CR_READ, vcpu, 3,
+			(u32 []){ (u32)cr,
+			(u32)kvm_register_read(vcpu, reg),
+			(u32)((u64)kvm_register_read(vcpu, reg) >> 32) });
+		break;
+	case 8:
+		kvm_add_trace(KVM_TRC_CR_READ, vcpu, 2,
+			(u32 []){ (u32)cr, (u32)kvm_register_read(vcpu, reg) });
+		break;
+	}
+}
+
+static void probe_kvm_cr_write(struct kvm_vcpu *vcpu, int cr, int reg)
+{
+	kvm_add_trace(KVM_TRC_CR_WRITE, vcpu, 3,
+		(u32 []){ (u32)cr,
+			(u32)kvm_register_read(vcpu, reg),
+			(u32)((u64)kvm_register_read(vcpu, reg) >> 32) });
+}
+
+
+static void probe_kvm_cr_read_realmode(struct kvm_vcpu *vcpu, int cr,
+		unsigned long value)
+{
+	kvm_add_trace(KVM_TRC_CR_READ, vcpu, 3,
+		(u32 []){ (u32)cr, (u32)value, (u32)((u64)value >> 32) });
+}
+
+static void probe_kvm_cr_write_realmode(struct kvm_vcpu *vcpu, int cr,
+		unsigned long value)
+{
+	kvm_add_trace(KVM_TRC_CR_WRITE, vcpu, 3,
+		(u32 []){ (u32)cr, (u32)value, (u32)((u64)value >> 32) });
+}
+
+static void probe_kvm_dr_read(struct kvm_vcpu *vcpu, int dr, unsigned long val)
+{
+	kvm_add_trace(KVM_TRC_DR_READ, vcpu, 2,
+		(u32 []){ (u32)dr, (u32)val });
+}
+
+static void probe_kvm_msr_read(struct kvm_vcpu *vcpu, u32 ecx, u64 data)
+{
+	kvm_add_trace(KVM_TRC_MSR_READ, vcpu, 3,
+		(u32 []){ ecx, (u32)data, (u32)(data >> 32) });
+}
+
+static void probe_kvm_msr_write(struct kvm_vcpu *vcpu, u32 ecx, u64 data)
+{
+	kvm_add_trace(KVM_TRC_MSR_WRITE, vcpu, 3,
+		(u32 []){ ecx, (u32)data, (u32)(data >> 32) });
+}
+
+static void probe_kvm_cpuid(struct kvm_vcpu *vcpu, u32 function)
+{
+	kvm_add_trace(KVM_TRC_CPUID, vcpu, 5,
+		(u32 []){ function,
+			(u32)kvm_register_read(vcpu, VCPU_REGS_RAX),
+			(u32)kvm_register_read(vcpu, VCPU_REGS_RBX),
+			(u32)kvm_register_read(vcpu, VCPU_REGS_RCX),
+			(u32)kvm_register_read(vcpu, VCPU_REGS_RDX) });
+}
+
+static void probe_kvm_intr(struct kvm_vcpu *vcpu)
+{
+	kvm_add_trace(KVM_TRC_INTR, vcpu, 1,
+		(u32 []){ vmcs_read32(VM_EXIT_INTR_INFO) });
+}
+
+static void probe_kvm_nmi(struct kvm_vcpu *vcpu)
+{
+	kvm_add_trace(KVM_TRC_NMI, vcpu, 0, NULL);
+}
+
+static void probe_kvm_vmmcall(struct kvm_vcpu *vcpu, unsigned long nr)
+{
+	kvm_add_trace(KVM_TRC_VMMCALL, vcpu, 1, (u32 []){ (u32)nr });
+}
+
+static void probe_kvm_hlt(struct kvm_vcpu *vcpu)
+{
+	kvm_add_trace(KVM_TRC_HLT, vcpu, 0, NULL);
+}
+
+static void probe_kvm_clts(struct kvm_vcpu *vcpu)
+{
+	kvm_add_trace(KVM_TRC_CLTS, vcpu, 0, NULL);
+}
+
+static void probe_kvm_lmsw(struct kvm_vcpu *vcpu, unsigned long cr0)
+{
+	kvm_add_trace(KVM_TRC_LMSW, vcpu, 1, (u32 []){ (u32)cr0 });
+}
+
+static void probe_kvm_apic_access(struct kvm_vcpu *vcpu, unsigned long offset)
+{
+	kvm_add_trace(KVM_TRC_LMSW, vcpu, 1, (u32 []){ (u32)offset });
+}
+
+static int register_tracepoints(void)
+{
+	int ret;
+
+	ret = register_trace_kvm_vmentry(probe_kvm_vmentry);
+	WARN_ON(ret);
+	ret = register_trace_kvm_vmexit(probe_kvm_vmexit);
+	WARN_ON(ret);
+	ret = register_trace_kvm_page_fault(probe_kvm_page_fault);
+	WARN_ON(ret);
+	ret = register_trace_kvm_inj_virq(probe_kvm_inj_virq);
+	WARN_ON(ret);
+	ret = register_trace_kvm_redeliver_evt(probe_kvm_redeliver_evt);
+	WARN_ON(ret);
+	ret = register_trace_kvm_pend_intr(probe_kvm_pend_intr);
+	WARN_ON(ret);
+	ret = register_trace_kvm_io(probe_kvm_io);
+	WARN_ON(ret);
+	ret = register_trace_kvm_cr_read(probe_kvm_cr_read);
+	WARN_ON(ret);
+	ret = register_trace_kvm_cr_write(probe_kvm_cr_write);
+	WARN_ON(ret);
+	ret = register_trace_kvm_cr_read_realmode(probe_kvm_cr_read_realmode);
+	WARN_ON(ret);
+	ret = register_trace_kvm_cr_write_realmode(probe_kvm_cr_write_realmode);
+	WARN_ON(ret);
+	ret = register_trace_kvm_dr_read(probe_kvm_dr_read);
+	WARN_ON(ret);
+	ret = register_trace_kvm_msr_read(probe_kvm_msr_read);
+	WARN_ON(ret);
+	ret = register_trace_kvm_msr_write(probe_kvm_msr_write);
+	WARN_ON(ret);
+	ret = register_trace_kvm_cpuid(probe_kvm_cpuid);
+	WARN_ON(ret);
+	ret = register_trace_kvm_intr(probe_kvm_intr);
+	WARN_ON(ret);
+	ret = register_trace_kvm_nmi(probe_kvm_nmi);
+	WARN_ON(ret);
+	ret = register_trace_kvm_vmmcall(probe_kvm_vmmcall);
+	WARN_ON(ret);
+	ret = register_trace_kvm_hlt(probe_kvm_hlt);
+	WARN_ON(ret);
+	ret = register_trace_kvm_clts(probe_kvm_clts);
+	WARN_ON(ret);
+	ret = register_trace_kvm_lmsw(probe_kvm_lmsw);
+	WARN_ON(ret);
+	ret = register_trace_kvm_apic_access(probe_kvm_apic_access);
+	WARN_ON(ret);
+
+	return 0;
+}
+
+static void unregister_tracepoints(void)
+{
+	unregister_trace_kvm_apic_access(probe_kvm_apic_access);
+	unregister_trace_kvm_lmsw(probe_kvm_lmsw);
+	unregister_trace_kvm_clts(probe_kvm_clts);
+	unregister_trace_kvm_hlt(probe_kvm_hlt);
+	unregister_trace_kvm_vmmcall(probe_kvm_vmmcall);
+	unregister_trace_kvm_nmi(probe_kvm_nmi);
+	unregister_trace_kvm_intr(probe_kvm_intr);
+	unregister_trace_kvm_cpuid(probe_kvm_cpuid);
+	unregister_trace_kvm_msr_write(probe_kvm_msr_write);
+	unregister_trace_kvm_msr_read(probe_kvm_msr_read);
+	unregister_trace_kvm_dr_read(probe_kvm_dr_read);
+	unregister_trace_kvm_cr_write_realmode(probe_kvm_cr_write_realmode);
+	unregister_trace_kvm_cr_read_realmode(probe_kvm_cr_read_realmode);
+	unregister_trace_kvm_cr_write(probe_kvm_cr_write);
+	unregister_trace_kvm_cr_read(probe_kvm_cr_read);
+	unregister_trace_kvm_io(probe_kvm_io);
+	unregister_trace_kvm_pend_intr(probe_kvm_pend_intr);
+	unregister_trace_kvm_redeliver_evt(probe_kvm_redeliver_evt);
+	unregister_trace_kvm_inj_virq(probe_kvm_inj_virq);
+	unregister_trace_kvm_page_fault(probe_kvm_page_fault);
+	unregister_trace_kvm_vmexit(probe_kvm_vmexit);
+	unregister_trace_kvm_vmentry(probe_kvm_vmentry);
+
+}

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
