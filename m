Return-Path: <linux-kernel-owner+w=401wt.eu-S1752426AbZHSNHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426AbZHSNHF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:07:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752299AbZHSNEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:04:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50578 "EHLO mx2.redhat.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752005AbZHSNCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:02:49 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 24/47] KVM: convert custom marker based tracing to event traces
Date: Wed, 19 Aug 2009 16:02:20 +0300
Message-Id: <1250686963-8357-25-git-send-email-avi@redhat.com>
In-Reply-To: <1250686963-8357-1-git-send-email-avi@redhat.com>
References: <1250686963-8357-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

This allows use of the powerful ftrace infrastructure.

See Documentation/trace/ for usage information.

[avi, stephen: various build fixes]
[sheng: fix control register breakage]

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    2 +
 arch/x86/kvm/Makefile           |    4 +
 arch/x86/kvm/lapic.c            |    7 +-
 arch/x86/kvm/svm.c              |   84 +++++++++----
 arch/x86/kvm/trace.h            |  260 +++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx.c              |   78 +++++++-----
 arch/x86/kvm/x86.c              |   48 +++-----
 include/trace/events/kvm.h      |   57 +++++++++
 virt/kvm/irq_comm.c             |    5 +
 virt/kvm/kvm_main.c             |    4 +
 10 files changed, 463 insertions(+), 86 deletions(-)
 create mode 100644 arch/x86/kvm/trace.h
 create mode 100644 include/trace/events/kvm.h

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c7b0cc2..19027ab 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -14,6 +14,7 @@
 #include <linux/types.h>
 #include <linux/mm.h>
 #include <linux/mmu_notifier.h>
+#include <linux/tracepoint.h>
 
 #include <linux/kvm.h>
 #include <linux/kvm_para.h>
@@ -527,6 +528,7 @@ struct kvm_x86_ops {
 	int (*set_tss_addr)(struct kvm *kvm, unsigned int addr);
 	int (*get_tdp_level)(void);
 	u64 (*get_mt_mask)(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
+	const struct trace_print_flags *exit_reasons_str;
 };
 
 extern struct kvm_x86_ops *kvm_x86_ops;
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 01e3c61..7c56850 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -1,6 +1,10 @@
 
 EXTRA_CFLAGS += -Ivirt/kvm -Iarch/x86/kvm
 
+CFLAGS_x86.o := -I.
+CFLAGS_svm.o := -I.
+CFLAGS_vmx.o := -I.
+
 kvm-y			+= $(addprefix ../../../virt/kvm/, kvm_main.o ioapic.o \
 				coalesced_mmio.o irq_comm.o eventfd.o)
 kvm-$(CONFIG_KVM_TRACE)	+= $(addprefix ../../../virt/kvm/, kvm_trace.o)
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 3bde43c..2e02865 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -34,6 +34,7 @@
 #include <asm/atomic.h>
 #include "kvm_cache_regs.h"
 #include "irq.h"
+#include "trace.h"
 
 #ifndef CONFIG_X86_64
 #define mod_64(x, y) ((x) - (y) * div64_u64(x, y))
@@ -515,8 +516,6 @@ static u32 __apic_read(struct kvm_lapic *apic, unsigned int offset)
 {
 	u32 val = 0;
 
-	KVMTRACE_1D(APIC_ACCESS, apic->vcpu, (u32)offset, handler);
-
 	if (offset >= LAPIC_MMIO_LENGTH)
 		return 0;
 
@@ -562,6 +561,8 @@ static void apic_mmio_read(struct kvm_io_device *this,
 	}
 	result = __apic_read(apic, offset & ~0xf);
 
+	trace_kvm_apic_read(offset, result);
+
 	switch (len) {
 	case 1:
 	case 2:
@@ -657,7 +658,7 @@ static void apic_mmio_write(struct kvm_io_device *this,
 
 	offset &= 0xff0;
 
-	KVMTRACE_1D(APIC_ACCESS, apic->vcpu, (u32)offset, handler);
+	trace_kvm_apic_write(offset, val);
 
 	switch (offset) {
 	case APIC_ID:		/* Local APIC ID */
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index b2e23c8..081d00a 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -25,10 +25,12 @@
 #include <linux/vmalloc.h>
 #include <linux/highmem.h>
 #include <linux/sched.h>
+#include <linux/ftrace_event.h>
 
 #include <asm/desc.h>
 
 #include <asm/virtext.h>
+#include "trace.h"
 
 #define __ex(x) __kvm_handle_fault_on_reboot(x)
 
@@ -1099,7 +1101,6 @@ static unsigned long svm_get_dr(struct kvm_vcpu *vcpu, int dr)
 		val = 0;
 	}
 
-	KVMTRACE_2D(DR_READ, vcpu, (u32)dr, (u32)val, handler);
 	return val;
 }
 
@@ -1108,8 +1109,6 @@ static void svm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long value,
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	KVMTRACE_2D(DR_WRITE, vcpu, (u32)dr, (u32)value, handler);
-
 	*exception = 0;
 
 	switch (dr) {
@@ -1157,14 +1156,7 @@ static int pf_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 	fault_address  = svm->vmcb->control.exit_info_2;
 	error_code = svm->vmcb->control.exit_info_1;
 
-	if (!npt_enabled)
-		KVMTRACE_3D(PAGE_FAULT, &svm->vcpu, error_code,
-			    (u32)fault_address, (u32)(fault_address >> 32),
-			    handler);
-	else
-		KVMTRACE_3D(TDP_FAULT, &svm->vcpu, error_code,
-			    (u32)fault_address, (u32)(fault_address >> 32),
-			    handler);
+	trace_kvm_page_fault(fault_address, error_code);
 	/*
 	 * FIXME: Tis shouldn't be necessary here, but there is a flush
 	 * missing in the MMU code. Until we find this bug, flush the
@@ -1291,14 +1283,12 @@ static int io_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 
 static int nmi_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 {
-	KVMTRACE_0D(NMI, &svm->vcpu, handler);
 	return 1;
 }
 
 static int intr_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 {
 	++svm->vcpu.stat.irq_exits;
-	KVMTRACE_0D(INTR, &svm->vcpu, handler);
 	return 1;
 }
 
@@ -2080,8 +2070,7 @@ static int rdmsr_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 	if (svm_get_msr(&svm->vcpu, ecx, &data))
 		kvm_inject_gp(&svm->vcpu, 0);
 	else {
-		KVMTRACE_3D(MSR_READ, &svm->vcpu, ecx, (u32)data,
-			    (u32)(data >> 32), handler);
+		trace_kvm_msr_read(ecx, data);
 
 		svm->vcpu.arch.regs[VCPU_REGS_RAX] = data & 0xffffffff;
 		svm->vcpu.arch.regs[VCPU_REGS_RDX] = data >> 32;
@@ -2164,8 +2153,7 @@ static int wrmsr_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 	u64 data = (svm->vcpu.arch.regs[VCPU_REGS_RAX] & -1u)
 		| ((u64)(svm->vcpu.arch.regs[VCPU_REGS_RDX] & -1u) << 32);
 
-	KVMTRACE_3D(MSR_WRITE, &svm->vcpu, ecx, (u32)data, (u32)(data >> 32),
-		    handler);
+	trace_kvm_msr_write(ecx, data);
 
 	svm->next_rip = kvm_rip_read(&svm->vcpu) + 2;
 	if (svm_set_msr(&svm->vcpu, ecx, data))
@@ -2186,8 +2174,6 @@ static int msr_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 static int interrupt_window_interception(struct vcpu_svm *svm,
 				   struct kvm_run *kvm_run)
 {
-	KVMTRACE_0D(PEND_INTR, &svm->vcpu, handler);
-
 	svm_clear_vintr(svm);
 	svm->vmcb->control.int_ctl &= ~V_IRQ_MASK;
 	/*
@@ -2266,8 +2252,7 @@ static int handle_exit(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 	u32 exit_code = svm->vmcb->control.exit_code;
 
-	KVMTRACE_3D(VMEXIT, vcpu, exit_code, (u32)svm->vmcb->save.rip,
-		    (u32)((u64)svm->vmcb->save.rip >> 32), entryexit);
+	trace_kvm_exit(exit_code, svm->vmcb->save.rip);
 
 	if (is_nested(svm)) {
 		nsvm_printk("nested handle_exit: 0x%x | 0x%lx | 0x%lx | 0x%lx\n",
@@ -2355,7 +2340,7 @@ static inline void svm_inject_irq(struct vcpu_svm *svm, int irq)
 {
 	struct vmcb_control_area *control;
 
-	KVMTRACE_1D(INJ_VIRQ, &svm->vcpu, (u32)irq, handler);
+	trace_kvm_inj_virq(irq);
 
 	++svm->vcpu.stat.irq_injections;
 	control = &svm->vmcb->control;
@@ -2718,6 +2703,59 @@ static u64 svm_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 	return 0;
 }
 
+static const struct trace_print_flags svm_exit_reasons_str[] = {
+	{ SVM_EXIT_READ_CR0,           		"read_cr0" },
+	{ SVM_EXIT_READ_CR3,	      		"read_cr3" },
+	{ SVM_EXIT_READ_CR4,	      		"read_cr4" },
+	{ SVM_EXIT_READ_CR8,  	      		"read_cr8" },
+	{ SVM_EXIT_WRITE_CR0,          		"write_cr0" },
+	{ SVM_EXIT_WRITE_CR3,	      		"write_cr3" },
+	{ SVM_EXIT_WRITE_CR4,          		"write_cr4" },
+	{ SVM_EXIT_WRITE_CR8, 	      		"write_cr8" },
+	{ SVM_EXIT_READ_DR0, 	      		"read_dr0" },
+	{ SVM_EXIT_READ_DR1,	      		"read_dr1" },
+	{ SVM_EXIT_READ_DR2,	      		"read_dr2" },
+	{ SVM_EXIT_READ_DR3,	      		"read_dr3" },
+	{ SVM_EXIT_WRITE_DR0,	      		"write_dr0" },
+	{ SVM_EXIT_WRITE_DR1,	      		"write_dr1" },
+	{ SVM_EXIT_WRITE_DR2,	      		"write_dr2" },
+	{ SVM_EXIT_WRITE_DR3,	      		"write_dr3" },
+	{ SVM_EXIT_WRITE_DR5,	      		"write_dr5" },
+	{ SVM_EXIT_WRITE_DR7,	      		"write_dr7" },
+	{ SVM_EXIT_EXCP_BASE + DB_VECTOR,	"DB excp" },
+	{ SVM_EXIT_EXCP_BASE + BP_VECTOR,	"BP excp" },
+	{ SVM_EXIT_EXCP_BASE + UD_VECTOR,	"UD excp" },
+	{ SVM_EXIT_EXCP_BASE + PF_VECTOR,	"PF excp" },
+	{ SVM_EXIT_EXCP_BASE + NM_VECTOR,	"NM excp" },
+	{ SVM_EXIT_EXCP_BASE + MC_VECTOR,	"MC excp" },
+	{ SVM_EXIT_INTR,			"interrupt" },
+	{ SVM_EXIT_NMI,				"nmi" },
+	{ SVM_EXIT_SMI,				"smi" },
+	{ SVM_EXIT_INIT,			"init" },
+	{ SVM_EXIT_VINTR,			"vintr" },
+	{ SVM_EXIT_CPUID,			"cpuid" },
+	{ SVM_EXIT_INVD,			"invd" },
+	{ SVM_EXIT_HLT,				"hlt" },
+	{ SVM_EXIT_INVLPG,			"invlpg" },
+	{ SVM_EXIT_INVLPGA,			"invlpga" },
+	{ SVM_EXIT_IOIO,			"io" },
+	{ SVM_EXIT_MSR,				"msr" },
+	{ SVM_EXIT_TASK_SWITCH,			"task_switch" },
+	{ SVM_EXIT_SHUTDOWN,			"shutdown" },
+	{ SVM_EXIT_VMRUN,			"vmrun" },
+	{ SVM_EXIT_VMMCALL,			"hypercall" },
+	{ SVM_EXIT_VMLOAD,			"vmload" },
+	{ SVM_EXIT_VMSAVE,			"vmsave" },
+	{ SVM_EXIT_STGI,			"stgi" },
+	{ SVM_EXIT_CLGI,			"clgi" },
+	{ SVM_EXIT_SKINIT,			"skinit" },
+	{ SVM_EXIT_WBINVD,			"wbinvd" },
+	{ SVM_EXIT_MONITOR,			"monitor" },
+	{ SVM_EXIT_MWAIT,			"mwait" },
+	{ SVM_EXIT_NPF,				"npf" },
+	{ -1, NULL }
+};
+
 static struct kvm_x86_ops svm_x86_ops = {
 	.cpu_has_kvm_support = has_svm,
 	.disabled_by_bios = is_disabled,
@@ -2779,6 +2817,8 @@ static struct kvm_x86_ops svm_x86_ops = {
 	.set_tss_addr = svm_set_tss_addr,
 	.get_tdp_level = get_npt_level,
 	.get_mt_mask = svm_get_mt_mask,
+
+	.exit_reasons_str = svm_exit_reasons_str,
 };
 
 static int __init svm_init(void)
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
new file mode 100644
index 0000000..cd8c90d
--- /dev/null
+++ b/arch/x86/kvm/trace.h
@@ -0,0 +1,260 @@
+#if !defined(_TRACE_KVM_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_KVM_H
+
+#include <linux/tracepoint.h>
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM kvm
+#define TRACE_INCLUDE_PATH arch/x86/kvm
+#define TRACE_INCLUDE_FILE trace
+
+/*
+ * Tracepoint for guest mode entry.
+ */
+TRACE_EVENT(kvm_entry,
+	TP_PROTO(unsigned int vcpu_id),
+	TP_ARGS(vcpu_id),
+
+	TP_STRUCT__entry(
+		__field(	unsigned int,	vcpu_id		)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu_id	= vcpu_id;
+	),
+
+	TP_printk("vcpu %u", __entry->vcpu_id)
+);
+
+/*
+ * Tracepoint for hypercall.
+ */
+TRACE_EVENT(kvm_hypercall,
+	TP_PROTO(unsigned long nr, unsigned long a0, unsigned long a1,
+		 unsigned long a2, unsigned long a3),
+	TP_ARGS(nr, a0, a1, a2, a3),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long, 	nr		)
+		__field(	unsigned long,	a0		)
+		__field(	unsigned long,	a1		)
+		__field(	unsigned long,	a2		)
+		__field(	unsigned long,	a3		)
+	),
+
+	TP_fast_assign(
+		__entry->nr		= nr;
+		__entry->a0		= a0;
+		__entry->a1		= a1;
+		__entry->a2		= a2;
+		__entry->a3		= a3;
+	),
+
+	TP_printk("nr 0x%lx a0 0x%lx a1 0x%lx a2 0x%lx a3 0x%lx",
+		 __entry->nr, __entry->a0, __entry->a1,  __entry->a2,
+		 __entry->a3)
+);
+
+/*
+ * Tracepoint for PIO.
+ */
+TRACE_EVENT(kvm_pio,
+	TP_PROTO(unsigned int rw, unsigned int port, unsigned int size,
+		 unsigned int count),
+	TP_ARGS(rw, port, size, count),
+
+	TP_STRUCT__entry(
+		__field(	unsigned int, 	rw		)
+		__field(	unsigned int, 	port		)
+		__field(	unsigned int, 	size		)
+		__field(	unsigned int,	count		)
+	),
+
+	TP_fast_assign(
+		__entry->rw		= rw;
+		__entry->port		= port;
+		__entry->size		= size;
+		__entry->count		= count;
+	),
+
+	TP_printk("pio_%s at 0x%x size %d count %d",
+		  __entry->rw ? "write" : "read",
+		  __entry->port, __entry->size, __entry->count)
+);
+
+/*
+ * Tracepoint for cpuid.
+ */
+TRACE_EVENT(kvm_cpuid,
+	TP_PROTO(unsigned int function, unsigned long rax, unsigned long rbx,
+		 unsigned long rcx, unsigned long rdx),
+	TP_ARGS(function, rax, rbx, rcx, rdx),
+
+	TP_STRUCT__entry(
+		__field(	unsigned int,	function	)
+		__field(	unsigned long,	rax		)
+		__field(	unsigned long,	rbx		)
+		__field(	unsigned long,	rcx		)
+		__field(	unsigned long,	rdx		)
+	),
+
+	TP_fast_assign(
+		__entry->function	= function;
+		__entry->rax		= rax;
+		__entry->rbx		= rbx;
+		__entry->rcx		= rcx;
+		__entry->rdx		= rdx;
+	),
+
+	TP_printk("func %x rax %lx rbx %lx rcx %lx rdx %lx",
+		  __entry->function, __entry->rax,
+		  __entry->rbx, __entry->rcx, __entry->rdx)
+);
+
+/*
+ * Tracepoint for apic access.
+ */
+TRACE_EVENT(kvm_apic,
+	TP_PROTO(unsigned int rw, unsigned int reg, unsigned int val),
+	TP_ARGS(rw, reg, val),
+
+	TP_STRUCT__entry(
+		__field(	unsigned int,	rw		)
+		__field(	unsigned int,	reg		)
+		__field(	unsigned int,	val		)
+	),
+
+	TP_fast_assign(
+		__entry->rw		= rw;
+		__entry->reg		= reg;
+		__entry->val		= val;
+	),
+
+	TP_printk("apic_%s 0x%x = 0x%x",
+		  __entry->rw ? "write" : "read",
+		  __entry->reg, __entry->val)
+);
+
+#define trace_kvm_apic_read(reg, val)		trace_kvm_apic(0, reg, val)
+#define trace_kvm_apic_write(reg, val)		trace_kvm_apic(1, reg, val)
+
+/*
+ * Tracepoint for kvm guest exit:
+ */
+TRACE_EVENT(kvm_exit,
+	TP_PROTO(unsigned int exit_reason, unsigned long guest_rip),
+	TP_ARGS(exit_reason, guest_rip),
+
+	TP_STRUCT__entry(
+		__field(	unsigned int,	exit_reason	)
+		__field(	unsigned long,	guest_rip	)
+	),
+
+	TP_fast_assign(
+		__entry->exit_reason	= exit_reason;
+		__entry->guest_rip	= guest_rip;
+	),
+
+	TP_printk("reason %s rip 0x%lx",
+		 ftrace_print_symbols_seq(p, __entry->exit_reason,
+					  kvm_x86_ops->exit_reasons_str),
+		 __entry->guest_rip)
+);
+
+/*
+ * Tracepoint for kvm interrupt injection:
+ */
+TRACE_EVENT(kvm_inj_virq,
+	TP_PROTO(unsigned int irq),
+	TP_ARGS(irq),
+
+	TP_STRUCT__entry(
+		__field(	unsigned int,	irq		)
+	),
+
+	TP_fast_assign(
+		__entry->irq		= irq;
+	),
+
+	TP_printk("irq %u", __entry->irq)
+);
+
+/*
+ * Tracepoint for page fault.
+ */
+TRACE_EVENT(kvm_page_fault,
+	TP_PROTO(unsigned long fault_address, unsigned int error_code),
+	TP_ARGS(fault_address, error_code),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,	fault_address	)
+		__field(	unsigned int,	error_code	)
+	),
+
+	TP_fast_assign(
+		__entry->fault_address	= fault_address;
+		__entry->error_code	= error_code;
+	),
+
+	TP_printk("address %lx error_code %x",
+		  __entry->fault_address, __entry->error_code)
+);
+
+/*
+ * Tracepoint for guest MSR access.
+ */
+TRACE_EVENT(kvm_msr,
+	TP_PROTO(unsigned int rw, unsigned int ecx, unsigned long data),
+	TP_ARGS(rw, ecx, data),
+
+	TP_STRUCT__entry(
+		__field(	unsigned int,	rw		)
+		__field(	unsigned int,	ecx		)
+		__field(	unsigned long,	data		)
+	),
+
+	TP_fast_assign(
+		__entry->rw		= rw;
+		__entry->ecx		= ecx;
+		__entry->data		= data;
+	),
+
+	TP_printk("msr_%s %x = 0x%lx",
+		  __entry->rw ? "write" : "read",
+		  __entry->ecx, __entry->data)
+);
+
+#define trace_kvm_msr_read(ecx, data)		trace_kvm_msr(0, ecx, data)
+#define trace_kvm_msr_write(ecx, data)		trace_kvm_msr(1, ecx, data)
+
+/*
+ * Tracepoint for guest CR access.
+ */
+TRACE_EVENT(kvm_cr,
+	TP_PROTO(unsigned int rw, unsigned int cr, unsigned long val),
+	TP_ARGS(rw, cr, val),
+
+	TP_STRUCT__entry(
+		__field(	unsigned int,	rw		)
+		__field(	unsigned int,	cr		)
+		__field(	unsigned long,	val		)
+	),
+
+	TP_fast_assign(
+		__entry->rw		= rw;
+		__entry->cr		= cr;
+		__entry->val		= val;
+	),
+
+	TP_printk("cr_%s %x = 0x%lx",
+		  __entry->rw ? "write" : "read",
+		  __entry->cr, __entry->val)
+);
+
+#define trace_kvm_cr_read(cr, val)		trace_kvm_cr(0, cr, val)
+#define trace_kvm_cr_write(cr, val)		trace_kvm_cr(1, cr, val)
+
+#endif /* _TRACE_KVM_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 1a84ca1..c6256b9 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -25,6 +25,7 @@
 #include <linux/highmem.h>
 #include <linux/sched.h>
 #include <linux/moduleparam.h>
+#include <linux/ftrace_event.h>
 #include "kvm_cache_regs.h"
 #include "x86.h"
 
@@ -34,6 +35,8 @@
 #include <asm/virtext.h>
 #include <asm/mce.h>
 
+#include "trace.h"
+
 #define __ex(x) __kvm_handle_fault_on_reboot(x)
 
 MODULE_AUTHOR("Qumranet");
@@ -2550,7 +2553,7 @@ static void vmx_inject_irq(struct kvm_vcpu *vcpu)
 	uint32_t intr;
 	int irq = vcpu->arch.interrupt.nr;
 
-	KVMTRACE_1D(INJ_VIRQ, vcpu, (u32)irq, handler);
+	trace_kvm_inj_virq(irq);
 
 	++vcpu->stat.irq_injections;
 	if (vmx->rmode.vm86_active) {
@@ -2751,8 +2754,8 @@ static int handle_exception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		if (enable_ept)
 			BUG();
 		cr2 = vmcs_readl(EXIT_QUALIFICATION);
-		KVMTRACE_3D(PAGE_FAULT, vcpu, error_code, (u32)cr2,
-			    (u32)((u64)cr2 >> 32), handler);
+		trace_kvm_page_fault(cr2, error_code);
+
 		if (kvm_event_needs_reinjection(vcpu))
 			kvm_mmu_unprotect_page_virt(vcpu, cr2);
 		return kvm_mmu_page_fault(vcpu, cr2, error_code);
@@ -2799,7 +2802,6 @@ static int handle_external_interrupt(struct kvm_vcpu *vcpu,
 				     struct kvm_run *kvm_run)
 {
 	++vcpu->stat.irq_exits;
-	KVMTRACE_1D(INTR, vcpu, vmcs_read32(VM_EXIT_INTR_INFO), handler);
 	return 1;
 }
 
@@ -2847,7 +2849,7 @@ vmx_patch_hypercall(struct kvm_vcpu *vcpu, unsigned char *hypercall)
 
 static int handle_cr(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
-	unsigned long exit_qualification;
+	unsigned long exit_qualification, val;
 	int cr;
 	int reg;
 
@@ -2856,21 +2858,19 @@ static int handle_cr(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	reg = (exit_qualification >> 8) & 15;
 	switch ((exit_qualification >> 4) & 3) {
 	case 0: /* mov to cr */
-		KVMTRACE_3D(CR_WRITE, vcpu, (u32)cr,
-			    (u32)kvm_register_read(vcpu, reg),
-			    (u32)((u64)kvm_register_read(vcpu, reg) >> 32),
-			    handler);
+		val = kvm_register_read(vcpu, reg);
+		trace_kvm_cr_write(cr, val);
 		switch (cr) {
 		case 0:
-			kvm_set_cr0(vcpu, kvm_register_read(vcpu, reg));
+			kvm_set_cr0(vcpu, val);
 			skip_emulated_instruction(vcpu);
 			return 1;
 		case 3:
-			kvm_set_cr3(vcpu, kvm_register_read(vcpu, reg));
+			kvm_set_cr3(vcpu, val);
 			skip_emulated_instruction(vcpu);
 			return 1;
 		case 4:
-			kvm_set_cr4(vcpu, kvm_register_read(vcpu, reg));
+			kvm_set_cr4(vcpu, val);
 			skip_emulated_instruction(vcpu);
 			return 1;
 		case 8: {
@@ -2892,23 +2892,19 @@ static int handle_cr(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		vcpu->arch.cr0 &= ~X86_CR0_TS;
 		vmcs_writel(CR0_READ_SHADOW, vcpu->arch.cr0);
 		vmx_fpu_activate(vcpu);
-		KVMTRACE_0D(CLTS, vcpu, handler);
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
+			trace_kvm_cr_read(cr, vcpu->arch.cr3);
 			skip_emulated_instruction(vcpu);
 			return 1;
 		case 8:
-			kvm_register_write(vcpu, reg, kvm_get_cr8(vcpu));
-			KVMTRACE_2D(CR_READ, vcpu, (u32)cr,
-				    (u32)kvm_register_read(vcpu, reg), handler);
+			val = kvm_get_cr8(vcpu);
+			kvm_register_write(vcpu, reg, val);
+			trace_kvm_cr_read(cr, val);
 			skip_emulated_instruction(vcpu);
 			return 1;
 		}
@@ -2976,7 +2972,6 @@ static int handle_dr(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 			val = 0;
 		}
 		kvm_register_write(vcpu, reg, val);
-		KVMTRACE_2D(DR_READ, vcpu, (u32)dr, (u32)val, handler);
 	} else {
 		val = vcpu->arch.regs[reg];
 		switch (dr) {
@@ -3009,7 +3004,6 @@ static int handle_dr(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 			}
 			break;
 		}
-		KVMTRACE_2D(DR_WRITE, vcpu, (u32)dr, (u32)val, handler);
 	}
 	skip_emulated_instruction(vcpu);
 	return 1;
@@ -3031,8 +3025,7 @@ static int handle_rdmsr(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		return 1;
 	}
 
-	KVMTRACE_3D(MSR_READ, vcpu, ecx, (u32)data, (u32)(data >> 32),
-		    handler);
+	trace_kvm_msr_read(ecx, data);
 
 	/* FIXME: handling of bits 32:63 of rax, rdx */
 	vcpu->arch.regs[VCPU_REGS_RAX] = data & -1u;
@@ -3047,8 +3040,7 @@ static int handle_wrmsr(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	u64 data = (vcpu->arch.regs[VCPU_REGS_RAX] & -1u)
 		| ((u64)(vcpu->arch.regs[VCPU_REGS_RDX] & -1u) << 32);
 
-	KVMTRACE_3D(MSR_WRITE, vcpu, ecx, (u32)data, (u32)(data >> 32),
-		    handler);
+	trace_kvm_msr_write(ecx, data);
 
 	if (vmx_set_msr(vcpu, ecx, data) != 0) {
 		kvm_inject_gp(vcpu, 0);
@@ -3075,7 +3067,6 @@ static int handle_interrupt_window(struct kvm_vcpu *vcpu,
 	cpu_based_vm_exec_control &= ~CPU_BASED_VIRTUAL_INTR_PENDING;
 	vmcs_write32(CPU_BASED_VM_EXEC_CONTROL, cpu_based_vm_exec_control);
 
-	KVMTRACE_0D(PEND_INTR, vcpu, handler);
 	++vcpu->stat.irq_window_exits;
 
 	/*
@@ -3227,6 +3218,7 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	}
 
 	gpa = vmcs_read64(GUEST_PHYSICAL_ADDRESS);
+	trace_kvm_page_fault(gpa, exit_qualification);
 	return kvm_mmu_page_fault(vcpu, gpa & PAGE_MASK, 0);
 }
 
@@ -3410,8 +3402,7 @@ static int vmx_handle_exit(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
 	u32 exit_reason = vmx->exit_reason;
 	u32 vectoring_info = vmx->idt_vectoring_info;
 
-	KVMTRACE_3D(VMEXIT, vcpu, exit_reason, (u32)kvm_rip_read(vcpu),
-		    (u32)((u64)kvm_rip_read(vcpu) >> 32), entryexit);
+	trace_kvm_exit(exit_reason, kvm_rip_read(vcpu));
 
 	/* If we need to emulate an MMIO from handle_invalid_guest_state
 	 * we just return 0 */
@@ -3500,10 +3491,8 @@ static void vmx_complete_interrupts(struct vcpu_vmx *vmx)
 
 	/* We need to handle NMIs before interrupts are enabled */
 	if ((exit_intr_info & INTR_INFO_INTR_TYPE_MASK) == INTR_TYPE_NMI_INTR &&
-	    (exit_intr_info & INTR_INFO_VALID_MASK)) {
-		KVMTRACE_0D(NMI, &vmx->vcpu, handler);
+	    (exit_intr_info & INTR_INFO_VALID_MASK))
 		asm("int $2");
-	}
 
 	idtv_info_valid = idt_vectoring_info & VECTORING_INFO_VALID_MASK;
 
@@ -3891,6 +3880,29 @@ static u64 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 	return ret;
 }
 
+static const struct trace_print_flags vmx_exit_reasons_str[] = {
+	{ EXIT_REASON_EXCEPTION_NMI,           "exception" },
+	{ EXIT_REASON_EXTERNAL_INTERRUPT,      "ext_irq" },
+	{ EXIT_REASON_TRIPLE_FAULT,            "triple_fault" },
+	{ EXIT_REASON_NMI_WINDOW,              "nmi_window" },
+	{ EXIT_REASON_IO_INSTRUCTION,          "io_instruction" },
+	{ EXIT_REASON_CR_ACCESS,               "cr_access" },
+	{ EXIT_REASON_DR_ACCESS,               "dr_access" },
+	{ EXIT_REASON_CPUID,                   "cpuid" },
+	{ EXIT_REASON_MSR_READ,                "rdmsr" },
+	{ EXIT_REASON_MSR_WRITE,               "wrmsr" },
+	{ EXIT_REASON_PENDING_INTERRUPT,       "interrupt_window" },
+	{ EXIT_REASON_HLT,                     "halt" },
+	{ EXIT_REASON_INVLPG,                  "invlpg" },
+	{ EXIT_REASON_VMCALL,                  "hypercall" },
+	{ EXIT_REASON_TPR_BELOW_THRESHOLD,     "tpr_below_thres" },
+	{ EXIT_REASON_APIC_ACCESS,             "apic_access" },
+	{ EXIT_REASON_WBINVD,                  "wbinvd" },
+	{ EXIT_REASON_TASK_SWITCH,             "task_switch" },
+	{ EXIT_REASON_EPT_VIOLATION,           "ept_violation" },
+	{ -1, NULL }
+};
+
 static struct kvm_x86_ops vmx_x86_ops = {
 	.cpu_has_kvm_support = cpu_has_kvm_support,
 	.disabled_by_bios = vmx_disabled_by_bios,
@@ -3950,6 +3962,8 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.set_tss_addr = vmx_set_tss_addr,
 	.get_tdp_level = get_ept_level,
 	.get_mt_mask = vmx_get_mt_mask,
+
+	.exit_reasons_str = vmx_exit_reasons_str,
 };
 
 static int __init vmx_init(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a066876..892a7a6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -37,6 +37,8 @@
 #include <linux/iommu.h>
 #include <linux/intel-iommu.h>
 #include <linux/cpufreq.h>
+#define CREATE_TRACE_POINTS
+#include "trace.h"
 
 #include <asm/uaccess.h>
 #include <asm/msr.h>
@@ -347,9 +349,6 @@ EXPORT_SYMBOL_GPL(kvm_set_cr0);
 void kvm_lmsw(struct kvm_vcpu *vcpu, unsigned long msw)
 {
 	kvm_set_cr0(vcpu, (vcpu->arch.cr0 & ~0x0ful) | (msw & 0x0f));
-	KVMTRACE_1D(LMSW, vcpu,
-		    (u32)((vcpu->arch.cr0 & ~0x0ful) | (msw & 0x0f)),
-		    handler);
 }
 EXPORT_SYMBOL_GPL(kvm_lmsw);
 
@@ -2568,7 +2567,6 @@ int emulate_invlpg(struct kvm_vcpu *vcpu, gva_t address)
 
 int emulate_clts(struct kvm_vcpu *vcpu)
 {
-	KVMTRACE_0D(CLTS, vcpu, handler);
 	kvm_x86_ops->set_cr0(vcpu, vcpu->arch.cr0 & ~X86_CR0_TS);
 	return X86EMUL_CONTINUE;
 }
@@ -2851,12 +2849,8 @@ int kvm_emulate_pio(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
 	vcpu->arch.pio.down = 0;
 	vcpu->arch.pio.rep = 0;
 
-	if (vcpu->run->io.direction == KVM_EXIT_IO_IN)
-		KVMTRACE_2D(IO_READ, vcpu, vcpu->run->io.port, (u32)size,
-			    handler);
-	else
-		KVMTRACE_2D(IO_WRITE, vcpu, vcpu->run->io.port, (u32)size,
-			    handler);
+	trace_kvm_pio(vcpu->run->io.direction == KVM_EXIT_IO_OUT, port,
+		      size, 1);
 
 	val = kvm_register_read(vcpu, VCPU_REGS_RAX);
 	memcpy(vcpu->arch.pio_data, &val, 4);
@@ -2892,12 +2886,8 @@ int kvm_emulate_pio_string(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
 	vcpu->arch.pio.down = down;
 	vcpu->arch.pio.rep = rep;
 
-	if (vcpu->run->io.direction == KVM_EXIT_IO_IN)
-		KVMTRACE_2D(IO_READ, vcpu, vcpu->run->io.port, (u32)size,
-			    handler);
-	else
-		KVMTRACE_2D(IO_WRITE, vcpu, vcpu->run->io.port, (u32)size,
-			    handler);
+	trace_kvm_pio(vcpu->run->io.direction == KVM_EXIT_IO_OUT, port,
+		      size, count);
 
 	if (!count) {
 		kvm_x86_ops->skip_emulated_instruction(vcpu);
@@ -3075,7 +3065,6 @@ void kvm_arch_exit(void)
 int kvm_emulate_halt(struct kvm_vcpu *vcpu)
 {
 	++vcpu->stat.halt_exits;
-	KVMTRACE_0D(HLT, vcpu, handler);
 	if (irqchip_in_kernel(vcpu->kvm)) {
 		vcpu->arch.mp_state = KVM_MP_STATE_HALTED;
 		return 1;
@@ -3106,7 +3095,7 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 	a2 = kvm_register_read(vcpu, VCPU_REGS_RDX);
 	a3 = kvm_register_read(vcpu, VCPU_REGS_RSI);
 
-	KVMTRACE_1D(VMMCALL, vcpu, (u32)nr, handler);
+	trace_kvm_hypercall(nr, a0, a1, a2, a3);
 
 	if (!is_long_mode(vcpu)) {
 		nr &= 0xFFFFFFFF;
@@ -3206,8 +3195,6 @@ unsigned long realmode_get_cr(struct kvm_vcpu *vcpu, int cr)
 		vcpu_printf(vcpu, "%s: unexpected cr %u\n", __func__, cr);
 		return 0;
 	}
-	KVMTRACE_3D(CR_READ, vcpu, (u32)cr, (u32)value,
-		    (u32)((u64)value >> 32), handler);
 
 	return value;
 }
@@ -3215,9 +3202,6 @@ unsigned long realmode_get_cr(struct kvm_vcpu *vcpu, int cr)
 void realmode_set_cr(struct kvm_vcpu *vcpu, int cr, unsigned long val,
 		     unsigned long *rflags)
 {
-	KVMTRACE_3D(CR_WRITE, vcpu, (u32)cr, (u32)val,
-		    (u32)((u64)val >> 32), handler);
-
 	switch (cr) {
 	case 0:
 		kvm_set_cr0(vcpu, mk_cr_64(vcpu->arch.cr0, val));
@@ -3327,11 +3311,11 @@ void kvm_emulate_cpuid(struct kvm_vcpu *vcpu)
 		kvm_register_write(vcpu, VCPU_REGS_RDX, best->edx);
 	}
 	kvm_x86_ops->skip_emulated_instruction(vcpu);
-	KVMTRACE_5D(CPUID, vcpu, function,
-		    (u32)kvm_register_read(vcpu, VCPU_REGS_RAX),
-		    (u32)kvm_register_read(vcpu, VCPU_REGS_RBX),
-		    (u32)kvm_register_read(vcpu, VCPU_REGS_RCX),
-		    (u32)kvm_register_read(vcpu, VCPU_REGS_RDX), handler);
+	trace_kvm_cpuid(function,
+			kvm_register_read(vcpu, VCPU_REGS_RAX),
+			kvm_register_read(vcpu, VCPU_REGS_RBX),
+			kvm_register_read(vcpu, VCPU_REGS_RCX),
+			kvm_register_read(vcpu, VCPU_REGS_RDX));
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_cpuid);
 
@@ -3527,7 +3511,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		set_debugreg(vcpu->arch.eff_db[3], 3);
 	}
 
-	KVMTRACE_0D(VMENTRY, vcpu, entryexit);
+	trace_kvm_entry(vcpu->vcpu_id);
 	kvm_x86_ops->run(vcpu, kvm_run);
 
 	if (unlikely(vcpu->arch.switch_db_regs)) {
@@ -4842,3 +4826,9 @@ int kvm_arch_interrupt_allowed(struct kvm_vcpu *vcpu)
 {
 	return kvm_x86_ops->interrupt_allowed(vcpu);
 }
+
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_inj_virq);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_page_fault);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_msr);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_cr);
diff --git a/include/trace/events/kvm.h b/include/trace/events/kvm.h
new file mode 100644
index 0000000..d74b23d
--- /dev/null
+++ b/include/trace/events/kvm.h
@@ -0,0 +1,57 @@
+#if !defined(_TRACE_KVM_MAIN_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_KVM_MAIN_H
+
+#include <linux/tracepoint.h>
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM kvm
+#define TRACE_INCLUDE_FILE kvm
+
+#if defined(__KVM_HAVE_IOAPIC)
+TRACE_EVENT(kvm_set_irq,
+	TP_PROTO(unsigned int gsi),
+	TP_ARGS(gsi),
+
+	TP_STRUCT__entry(
+		__field(	unsigned int,	gsi		)
+	),
+
+	TP_fast_assign(
+		__entry->gsi		= gsi;
+	),
+
+	TP_printk("gsi %u", __entry->gsi)
+);
+
+
+#define kvm_irqchips						\
+	{KVM_IRQCHIP_PIC_MASTER,	"PIC master"},		\
+	{KVM_IRQCHIP_PIC_SLAVE,		"PIC slave"},		\
+	{KVM_IRQCHIP_IOAPIC,		"IOAPIC"}
+
+TRACE_EVENT(kvm_ack_irq,
+	TP_PROTO(unsigned int irqchip, unsigned int pin),
+	TP_ARGS(irqchip, pin),
+
+	TP_STRUCT__entry(
+		__field(	unsigned int,	irqchip		)
+		__field(	unsigned int,	pin		)
+	),
+
+	TP_fast_assign(
+		__entry->irqchip	= irqchip;
+		__entry->pin		= pin;
+	),
+
+	TP_printk("irqchip %s pin %u",
+		  __print_symbolic(__entry->irqchip, kvm_irqchips),
+		 __entry->pin)
+);
+
+
+
+#endif /* defined(__KVM_HAVE_IOAPIC) */
+#endif /* _TRACE_KVM_MAIN_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
index bb8a1b5..94759ed 100644
--- a/virt/kvm/irq_comm.c
+++ b/virt/kvm/irq_comm.c
@@ -20,6 +20,7 @@
  */
 
 #include <linux/kvm_host.h>
+#include <trace/events/kvm.h>
 
 #include <asm/msidef.h>
 #ifdef CONFIG_IA64
@@ -125,6 +126,8 @@ int kvm_set_irq(struct kvm *kvm, int irq_source_id, int irq, int level)
 	unsigned long *irq_state, sig_level;
 	int ret = -1;
 
+	trace_kvm_set_irq(irq);
+
 	WARN_ON(!mutex_is_locked(&kvm->irq_lock));
 
 	if (irq < KVM_IOAPIC_NUM_PINS) {
@@ -161,6 +164,8 @@ void kvm_notify_acked_irq(struct kvm *kvm, unsigned irqchip, unsigned pin)
 	struct hlist_node *n;
 	unsigned gsi = pin;
 
+	trace_kvm_ack_irq(irqchip, pin);
+
 	list_for_each_entry(e, &kvm->irq_routing, link)
 		if (e->type == KVM_IRQ_ROUTING_IRQCHIP &&
 		    e->irqchip.irqchip == irqchip &&
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 48d5e69..04bdedd 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -59,6 +59,9 @@
 #include "irq.h"
 #endif
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/kvm.h>
+
 MODULE_AUTHOR("Qumranet");
 MODULE_LICENSE("GPL");
 
@@ -2718,6 +2721,7 @@ EXPORT_SYMBOL_GPL(kvm_init);
 void kvm_exit(void)
 {
 	kvm_trace_cleanup();
+	tracepoint_synchronize_unregister();
 	misc_deregister(&kvm_dev);
 	kmem_cache_destroy(kvm_vcpu_cache);
 	sysdev_unregister(&kvm_sysdev);
-- 
1.6.3.3

