Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758775Ab0BRWZv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 17:25:51 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:41032 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758550Ab0BRWZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 17:25:49 -0500
Subject: Re: [RFC] perf_events: how to add Intel LBR support
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       davem@davemloft.net, fweisbec@gmail.com, robert.richter@amd.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
In-Reply-To: <1266142321.5273.409.camel@laptop>
References: <bd4cb8901002100331id369b65lc944886f35067fb5@mail.gmail.com>
	 <1266142321.5273.409.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Feb 2010 23:25:36 +0100
Message-ID: <1266531936.2903.58.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-02-14 at 11:12 +0100, Peter Zijlstra wrote:
> 
> Dealing with context switches is also going to be tricky, where we have
> to safe and 'restore' LBR stacks for per-task counters. 

OK, so I poked at the LBR hardware a bit, sadly the TOS really doesn't
count beyond the few bits it requires :-(

I had hopes it would, since that would make it easier to share the LBR,
simply take a TOS snapshot when you schedule the counter in, and never
roll back further for that particular counter.

As it stands we'll have to wipe the full LBR state every time we 'touch'
it, which makes it less useful for cpu-bound counters.

Also, not all hw (core and pentium-m) supports the freeze_lbrs_on_pmi
bit, what we could do for those is stick an unconditional LBR disable
very early in the NMI path and simply roll back the stack until we hit a
branch into the NMI vector, that should leave a few usable LBR entries.

For AMD and P6 there is only a single LBR record, AMD seems to freeze
the thing on #DB traps but the PMI isn't qualified as one afaict,
rendering the single entry useless (didn't look at the P6 details).

hackery below..


---
 arch/x86/include/asm/perf_event.h |   24 +++
 arch/x86/kernel/cpu/perf_event.c  |  233 +++++++++++++++++++++++++++++++++++---
 arch/x86/kernel/traps.c           |    3 
 include/linux/perf_event.h        |    7 -
 4 files changed, 251 insertions(+), 16 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
@@ -104,6 +104,10 @@ struct amd_nb {
 	struct event_constraint event_constraints[X86_PMC_IDX_MAX];
 };
 
+struct lbr_entry {
+	u64 from, to, flags;
+};
+
 struct cpu_hw_events {
 	struct perf_event	*events[X86_PMC_IDX_MAX]; /* in counter order */
 	unsigned long		active_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
@@ -117,6 +121,10 @@ struct cpu_hw_events {
 	u64			tags[X86_PMC_IDX_MAX];
 	struct perf_event	*event_list[X86_PMC_IDX_MAX]; /* in enabled order */
 	struct amd_nb		*amd_nb;
+
+	int			lbr_users;
+	int			lbr_entries;
+	struct lbr_entry	lbr_stack[16];
 };
 
 #define __EVENT_CONSTRAINT(c, n, m, w) {\
@@ -187,6 +195,19 @@ struct x86_pmu {
 	void		(*put_event_constraints)(struct cpu_hw_events *cpuc,
 						 struct perf_event *event);
 	struct event_constraint *event_constraints;
+
+	unsigned long	lbr_tos;
+	unsigned long	lbr_from, lbr_to;
+	int		lbr_nr;
+	int		lbr_ctl;
+	int		lbr_format;
+};
+
+enum {
+	LBR_FORMAT_32 		= 0x00,
+	LBR_FORMAT_LIP		= 0x01,
+	LBR_FORMAT_EIP		= 0x02,
+	LBR_FORMAT_EIP_FLAGS	= 0x03,
 };
 
 static struct x86_pmu x86_pmu __read_mostly;
@@ -1203,6 +1224,52 @@ static void intel_pmu_disable_bts(void)
 	update_debugctlmsr(debugctlmsr);
 }
 
+static void __intel_pmu_enable_lbr(void)
+{
+	u64 debugctl;
+
+	rdmsrl(MSR_IA32_DEBUGCTLMSR, debugctl);
+	debugctl |= x86_pmu.lbr_ctl;
+	wrmsrl(MSR_IA32_DEBUGCTLMSR, debugctl);
+}
+
+static void intel_pmu_enable_lbr(void)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+
+	if (!x86_pmu.lbr_nr)
+		return;
+
+	if (!cpuc->lbr_users)
+		__intel_pmu_enable_lbr();
+
+	cpuc->lbr_users++;
+}
+
+static void __intel_pmu_disable_lbr(void)
+{
+	u64 debugctl;
+
+	rdmsrl(MSR_IA32_DEBUGCTLMSR, debugctl);
+	debugctl &= ~x86_pmu.lbr_ctl;
+	wrmsrl(MSR_IA32_DEBUGCTLMSR, debugctl);
+}
+
+static void intel_pmu_disable_lbr(void)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+
+	if (!x86_pmu.lbr_nr)
+		return;
+
+	cpuc->lbr_users--;
+
+	BUG_ON(cpuc->lbr_users < 0);
+
+	if (!cpuc->lbr_users)
+		__intel_pmu_disable_lbr();
+}
+
 static void intel_pmu_pebs_enable(struct hw_perf_event *hwc)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
@@ -1402,6 +1469,9 @@ void hw_perf_disable(void)
 	cpuc->enabled = 0;
 	barrier();
 
+	if (cpuc->lbr_users)
+		__intel_pmu_disable_lbr();
+
 	x86_pmu.disable_all();
 }
 
@@ -1703,6 +1773,10 @@ void hw_perf_enable(void)
 	barrier();
 
 	x86_pmu.enable_all();
+
+	// XXX
+	if (cpuc->lbr_users = 1)
+		__intel_pmu_enable_lbr();
 }
 
 static inline u64 intel_pmu_get_status(void)
@@ -2094,7 +2168,6 @@ static void intel_pmu_drain_pebs_core(st
 	struct perf_event_header header;
 	struct perf_sample_data data;
 	struct pt_regs regs;
-	u64
 
 	if (!event || !ds || !x86_pmu.pebs)
 		return;
@@ -2114,7 +2187,7 @@ static void intel_pmu_drain_pebs_core(st
 
 	perf_prepare_sample(&header, &data, event, &regs);
 
-	event.hw.interrupts += (top - at);
+	event->hw.interrupts += (top - at);
 	atomic64_add((top - at) * event->hw.last_period, &event->count);
 
 	if (perf_output_begin(&handle, event, header.size * (top - at), 1, 1))
@@ -2188,6 +2261,84 @@ static void intel_pmu_drain_pebs_nhm(str
 	}
 }
 
+static inline u64 intel_pmu_lbr_tos(void)
+{
+	u64 tos;
+
+	rdmsrl(x86_pmu.lbr_tos, tos);
+	return tos;
+}
+
+static void
+intel_pmu_read_lbr_32(struct cpu_hw_events *cpuc, struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+	unsigned long mask = x86_pmu.lbr_nr - 1;
+	u64 tos = intel_pmu_lbr_tos();
+	int i;
+
+	for (i = 0; tos > hwc->lbr_tos && i < x86_pmu.lbr_nr; i++, tos--) {
+		unsigned long lbr_idx = (tos - i) & mask;
+		union {
+			struct {
+				u32 from;
+				u32 to;
+			};
+			u64	lbr;
+		} msr_lastbranch;
+
+		rdmsrl(x86_pmu.lbr_from + lbr_idx, msr_lastbranch.lbr);
+
+		cpuc->lbr_stack[i].from  = msr_lastbranch.from;
+		cpuc->lbr_stack[i].to    = msr_lastbranch.to;
+		cpuc->lbr_stack[i].flags = 0;
+	}
+	cpuc->lbr_entries = i;
+}
+
+#define LBR_FROM_FLAG_MISPRED	(1ULL << 63)
+
+/*
+ * Due to lack of segmentation in Linux the effective address (offset)
+ * is the same as the linear address, allowing us to merge the LIP and EIP
+ * LBR formats.
+ */
+static void
+intel_pmu_read_lbr_64(struct cpu_hw_events *cpuc, struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+	unsigned long mask = x86_pmu.lbr_nr - 1;
+	u64 tos = intel_pmu_lbr_tos();
+	int i;
+
+	for (i = 0; tos > hwc->lbr_tos && i < x86_pmu.lbr_nr; i++, tos--) {
+		unsigned long lbr_idx = (tos - i) & mask;
+		u64 from, to, flags = 0;
+
+		rdmsrl(x86_pmu.lbr_from + lbr_idx, from);
+		rdmsrl(x86_pmu.lbr_to   + lbr_idx, to);
+
+		if (x86_pmu.lbr_format == LBR_FORMAT_EIP_FLAGS) {
+			flags = !!(from & LBR_FROM_FLAG_MISPRED);
+			from = (u64)((((s64)from) << 1) >> 1);
+		}
+
+		cpuc->lbr_stack[i].from  = from;
+		cpuc->lbr_stack[i].to    = to;
+		cpuc->lbr_stack[i].flags = flags;
+	}
+	cpuc->lbr_entries = i;
+}
+
+static void
+intel_pmu_read_lbr(struct cpu_hw_events *cpuc, struct perf_event *event)
+{
+	if (x86_pmu.lbr_format == LBR_FORMAT_32)
+		intel_pmu_read_lbr_32(cpuc, event);
+	else
+		intel_pmu_read_lbr_64(cpuc, event);
+}
+
 static void x86_pmu_stop(struct perf_event *event)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
@@ -2456,11 +2607,26 @@ perf_event_nmi_handler(struct notifier_b
 	 * If the first NMI handles both, the latter will be empty and daze
 	 * the CPU.
 	 */
+	trace_printk("LBR TOS: %Ld\n", intel_pmu_lbr_tos());
 	x86_pmu.handle_irq(regs);
 
 	return NOTIFY_STOP;
 }
 
+static __read_mostly struct notifier_block perf_event_nmi_notifier = {
+	.notifier_call		= perf_event_nmi_handler,
+	.next			= NULL,
+	.priority		= 1
+};
+
+void perf_nmi_exit(void)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+
+	if (cpuc->lbr_users)
+		__intel_pmu_enable_lbr();
+}
+
 static struct event_constraint unconstrained;	/* can schedule */
 static struct event_constraint null_constraint; /* can't schedule */
 static struct event_constraint bts_constraint =
@@ -2761,12 +2927,6 @@ undo:
 	return ret;
 }
 
-static __read_mostly struct notifier_block perf_event_nmi_notifier = {
-	.notifier_call		= perf_event_nmi_handler,
-	.next			= NULL,
-	.priority		= 1
-};
-
 static __initconst struct x86_pmu p6_pmu = {
 	.name			= "p6",
 	.handle_irq		= x86_pmu_handle_irq,
@@ -2793,7 +2953,7 @@ static __initconst struct x86_pmu p6_pmu
 	.event_bits		= 32,
 	.event_mask		= (1ULL << 32) - 1,
 	.get_event_constraints	= intel_get_event_constraints,
-	.event_constraints	= intel_p6_event_constraints
+	.event_constraints	= intel_p6_event_constraints,
 };
 
 static __initconst struct x86_pmu core_pmu = {
@@ -2873,18 +3033,26 @@ static __init int p6_pmu_init(void)
 	case 7:
 	case 8:
 	case 11: /* Pentium III */
+		x86_pmu = p6_pmu;
+
+		break;
 	case 9:
-	case 13:
-		/* Pentium M */
+	case 13: /* Pentium M */
+		x86_pmu = p6_pmu;
+
+		x86_pmu.lbr_nr = 8;
+		x86_pmu.lbr_tos = 0x01c9;
+		x86_pmu.lbr_ctl = X86_DEBUGCTL_LBR;
+		x86_pmu.lbr_from = 0x40;
+
 		break;
+
 	default:
 		pr_cont("unsupported p6 CPU model %d ",
 			boot_cpu_data.x86_model);
 		return -ENODEV;
 	}
 
-	x86_pmu = p6_pmu;
-
 	return 0;
 }
 
@@ -2925,6 +3093,9 @@ static __init int intel_pmu_init(void)
 	x86_pmu.event_bits		= eax.split.bit_width;
 	x86_pmu.event_mask		= (1ULL << eax.split.bit_width) - 1;
 
+	rdmsrl(MSR_IA32_PERF_CAPABILITIES, capabilities);
+	x86_pmu.lbr_format = capabilities & 0x1f;
+
 	/*
 	 * Quirk: v2 perfmon does not report fixed-purpose events, so
 	 * assume at least 3 events:
@@ -2973,6 +3144,10 @@ no_datastore:
 	 */
 	switch (boot_cpu_data.x86_model) {
 	case 14: /* 65 nm core solo/duo, "Yonah" */
+		x86_pmu.lbr_nr = 8;
+		x86_pmu.lbr_tos = 0x01c9;
+		x86_pmu.lbr_ctl = X86_DEBUGCTL_LBR;
+		x86_pmu.lbr_from = 0x40;
 		pr_cont("Core events, ");
 		break;
 
@@ -2980,6 +3155,13 @@ no_datastore:
 	case 22: /* single-core 65 nm celeron/core2solo "Merom-L"/"Conroe-L" */
 	case 23: /* current 45 nm celeron/core2/xeon "Penryn"/"Wolfdale" */
 	case 29: /* six-core 45 nm xeon "Dunnington" */
+		x86_pmu.lbr_nr = 4;
+		x86_pmu.lbr_tos = 0x01c9;
+		x86_pmu.lbr_ctl = X86_DEBUGCTL_LBR |
+				  X86_DEBUGCTL_FREEZE_LBRS_ON_PMI;
+		x86_pmu.lbr_from = 0x40;
+		x86_pmu.lbr_to = 0x60;
+
 		memcpy(hw_cache_event_ids, core2_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 
@@ -2989,13 +3171,28 @@ no_datastore:
 
 	case 26: /* 45 nm nehalem, "Bloomfield" */
 	case 30: /* 45 nm nehalem, "Lynnfield" */
+		x86_pmu.lbr_nr = 16;
+		x86_pmu.lbr_tos = 0x01c9;
+		x86_pmu.lbr_ctl = X86_DEBUGCTL_LBR |
+			          X86_DEBUGCTL_FREEZE_LBRS_ON_PMI;
+		x86_pmu.lbr_from = 0x680;
+		x86_pmu.lbr_to = 0x6c0;
+
 		memcpy(hw_cache_event_ids, nehalem_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 
 		x86_pmu.event_constraints = intel_nehalem_event_constraints;
 		pr_cont("Nehalem/Corei7 events, ");
 		break;
-	case 28:
+
+	case 28: /* Atom */
+		x86_pmu.lbr_nr = 8;
+		x86_pmu.lbr_tos = 0x01c9;
+		x86_pmu.lbr_ctl = X86_DEBUGCTL_LBR |
+			          X86_DEBUGCTL_FREEZE_LBRS_ON_PMI;
+		x86_pmu.lbr_from = 0x40;
+		x86_pmu.lbr_to = 0x60;
+
 		memcpy(hw_cache_event_ids, atom_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 
@@ -3005,12 +3202,20 @@ no_datastore:
 
 	case 37: /* 32 nm nehalem, "Clarkdale" */
 	case 44: /* 32 nm nehalem, "Gulftown" */
+		x86_pmu.lbr_nr = 16;
+		x86_pmu.lbr_tos = 0x01c9;
+		x86_pmu.lbr_ctl = X86_DEBUGCTL_LBR |
+			             X86_DEBUGCTL_FREEZE_LBRS_ON_PMI;
+		x86_pmu.lbr_from = 0x680;
+		x86_pmu.lbr_to = 0x6c0;
+
 		memcpy(hw_cache_event_ids, westmere_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 
 		x86_pmu.event_constraints = intel_westmere_event_constraints;
 		pr_cont("Westmere events, ");
 		break;
+
 	default:
 		/*
 		 * default constraints for v2 and up
Index: linux-2.6/arch/x86/include/asm/perf_event.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/perf_event.h
+++ linux-2.6/arch/x86/include/asm/perf_event.h
@@ -1,6 +1,8 @@
 #ifndef _ASM_X86_PERF_EVENT_H
 #define _ASM_X86_PERF_EVENT_H
 
+#include <asm/msr.h>
+
 /*
  * Performance event hw details:
  */
@@ -122,11 +124,31 @@ union cpuid10_edx {
 extern void init_hw_perf_events(void);
 extern void perf_events_lapic_init(void);
 
+#define X86_DEBUGCTL_LBR		(1 << 0)
+#define X86_DEBUGCTL_FREEZE_LBRS_ON_PMI	(1 << 11)
+
+static __always_inline void perf_nmi_enter(void)
+{
+	u64 debugctl;
+
+	/*
+	 * Unconditionally disable LBR so as to minimally pollute the LBR stack.
+	 * XXX: paravirt will screw us over massive
+	 */
+	rdmsrl(MSR_IA32_DEBUGCTLMSR, debugctl);
+	debugctl &= ~X86_DEBUGCTL_LBR;
+	wrmsrl(MSR_IA32_DEBUGCTLMSR, debugctl);
+}
+
+extern void perf_nmi_exit(void);
+
 #define PERF_EVENT_INDEX_OFFSET			0
 
 #else
 static inline void init_hw_perf_events(void)		{ }
-static inline void perf_events_lapic_init(void)	{ }
+static inline void perf_events_lapic_init(void)		{ }
+static inline void perf_nmi_enter(void)			{ }
+static inline void perf_nmi_exit(void)			{ }
 #endif
 
 #endif /* _ASM_X86_PERF_EVENT_H */
Index: linux-2.6/arch/x86/kernel/traps.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/traps.c
+++ linux-2.6/arch/x86/kernel/traps.c
@@ -45,6 +45,7 @@
 #endif
 
 #include <asm/kmemcheck.h>
+#include <asm/perf_event.h>
 #include <asm/stacktrace.h>
 #include <asm/processor.h>
 #include <asm/debugreg.h>
@@ -442,6 +443,7 @@ static notrace __kprobes void default_do
 dotraplinkage notrace __kprobes void
 do_nmi(struct pt_regs *regs, long error_code)
 {
+	perf_nmi_enter();
 	nmi_enter();
 
 	inc_irq_stat(__nmi_count);
@@ -450,6 +452,7 @@ do_nmi(struct pt_regs *regs, long error_
 		default_do_nmi(regs);
 
 	nmi_exit();
+	perf_nmi_exit();
 }
 
 void stop_nmi(void)
Index: linux-2.6/include/linux/perf_event.h
===================================================================
--- linux-2.6.orig/include/linux/perf_event.h
+++ linux-2.6/include/linux/perf_event.h
@@ -125,8 +125,9 @@ enum perf_event_sample_format {
 	PERF_SAMPLE_PERIOD			= 1U << 8,
 	PERF_SAMPLE_STREAM_ID			= 1U << 9,
 	PERF_SAMPLE_RAW				= 1U << 10,
+	PERF_SAMPLE_LBR				= 1U << 11,
 
-	PERF_SAMPLE_MAX = 1U << 11,		/* non-ABI */
+	PERF_SAMPLE_MAX = 1U << 12,		/* non-ABI */
 };
 
 /*
@@ -396,6 +397,9 @@ enum perf_event_type {
 	 *	{ u64			nr,
 	 *	  u64			ips[nr];  } && PERF_SAMPLE_CALLCHAIN
 	 *
+	 * 	{ u64			nr;
+	 * 	  struct lbr_format	lbr[nr];  } && PERF_SAMPLE_LBR
+	 *
 	 *	#
 	 *	# The RAW record below is opaque data wrt the ABI
 	 *	#
@@ -483,6 +487,7 @@ struct hw_perf_event {
 			int		idx;
 			int		last_cpu;
 			int		pebs;
+			u64		lbr_tos;
 		};
 		struct { /* software */
 			s64		remaining;


