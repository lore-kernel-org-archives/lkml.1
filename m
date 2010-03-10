Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756414Ab0CJNTk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 08:19:40 -0500
Received: from hera.kernel.org ([140.211.167.34]:57409 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756357Ab0CJNTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 08:19:37 -0500
Date: Wed, 10 Mar 2010 13:19:13 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       acme@infradead.org, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, acme@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20100304140100.544191154@chello.nl>
References: <20100304140100.544191154@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/pebs] perf, x86: Implement simple LBR support
Message-ID: <tip-caff2befffe899e63df5cc760b7ed01cfd902685@git.kernel.org>
Git-Commit-ID: caff2befffe899e63df5cc760b7ed01cfd902685
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Mar 2010 13:19:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  caff2befffe899e63df5cc760b7ed01cfd902685
Gitweb:     http://git.kernel.org/tip/caff2befffe899e63df5cc760b7ed01cfd902685
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 3 Mar 2010 12:02:30 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 10 Mar 2010 13:23:32 +0100

perf, x86: Implement simple LBR support

Implement simple suport Intel Last-Branch-Record, it supports all
hardware that implements FREEZE_LBRS_ON_PMI, but does not (yet) implement
the LBR config register.

The Intel LBR is a FIFO of From,To addresses describing the last few
branches the hardware took.

This patch does not add perf interface to the LBR, but merely provides an
interface for internal use.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: paulus@samba.org
Cc: eranian@google.com
Cc: robert.richter@amd.com
Cc: fweisbec@gmail.com
LKML-Reference: <20100304140100.544191154@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c           |   18 +++
 arch/x86/kernel/cpu/perf_event_intel.c     |   13 ++
 arch/x86/kernel/cpu/perf_event_intel_lbr.c |  228 ++++++++++++++++++++++++++++
 include/linux/perf_event.h                 |   11 ++
 4 files changed, 270 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 0c03d5c..1badff6 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -48,6 +48,8 @@ struct amd_nb {
 	struct event_constraint event_constraints[X86_PMC_IDX_MAX];
 };
 
+#define MAX_LBR_ENTRIES		16
+
 struct cpu_hw_events {
 	/*
 	 * Generic x86 PMC bits
@@ -70,6 +72,14 @@ struct cpu_hw_events {
 	u64			pebs_enabled;
 
 	/*
+	 * Intel LBR bits
+	 */
+	int				lbr_users;
+	void				*lbr_context;
+	struct perf_branch_stack	lbr_stack;
+	struct perf_branch_entry	lbr_entries[MAX_LBR_ENTRIES];
+
+	/*
 	 * AMD specific bits
 	 */
 	struct amd_nb		*amd_nb;
@@ -159,6 +169,13 @@ struct x86_pmu {
 	int		pebs_record_size;
 	void		(*drain_pebs)(struct pt_regs *regs);
 	struct event_constraint *pebs_constraints;
+
+	/*
+	 * Intel LBR
+	 */
+	unsigned long	lbr_tos, lbr_from, lbr_to; /* MSR base regs       */
+	int		lbr_nr;			   /* hardware stack size */
+	int		lbr_format;		   /* hardware format     */
 };
 
 static struct x86_pmu x86_pmu __read_mostly;
@@ -1237,6 +1254,7 @@ undo:
 
 #include "perf_event_amd.c"
 #include "perf_event_p6.c"
+#include "perf_event_intel_lbr.c"
 #include "perf_event_intel_ds.c"
 #include "perf_event_intel.c"
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 1144641..44f6ed4 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -480,6 +480,7 @@ static void intel_pmu_disable_all(void)
 		intel_pmu_disable_bts();
 
 	intel_pmu_pebs_disable_all();
+	intel_pmu_lbr_disable_all();
 }
 
 static void intel_pmu_enable_all(void)
@@ -499,6 +500,7 @@ static void intel_pmu_enable_all(void)
 	}
 
 	intel_pmu_pebs_enable_all();
+	intel_pmu_lbr_enable_all();
 }
 
 static inline u64 intel_pmu_get_status(void)
@@ -674,6 +676,8 @@ again:
 	inc_irq_stat(apic_perf_irqs);
 	ack = status;
 
+	intel_pmu_lbr_read();
+
 	/*
 	 * PEBS overflow sets bit 62 in the global status register
 	 */
@@ -848,6 +852,8 @@ static __init int intel_pmu_init(void)
 		memcpy(hw_cache_event_ids, core2_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 
+		intel_pmu_lbr_init_core();
+
 		x86_pmu.event_constraints = intel_core2_event_constraints;
 		pr_cont("Core2 events, ");
 		break;
@@ -857,13 +863,18 @@ static __init int intel_pmu_init(void)
 		memcpy(hw_cache_event_ids, nehalem_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 
+		intel_pmu_lbr_init_nhm();
+
 		x86_pmu.event_constraints = intel_nehalem_event_constraints;
 		pr_cont("Nehalem/Corei7 events, ");
 		break;
+
 	case 28: /* Atom */
 		memcpy(hw_cache_event_ids, atom_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 
+		intel_pmu_lbr_init_atom();
+
 		x86_pmu.event_constraints = intel_gen_event_constraints;
 		pr_cont("Atom events, ");
 		break;
@@ -873,6 +884,8 @@ static __init int intel_pmu_init(void)
 		memcpy(hw_cache_event_ids, westmere_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 
+		intel_pmu_lbr_init_nhm();
+
 		x86_pmu.event_constraints = intel_westmere_event_constraints;
 		pr_cont("Westmere events, ");
 		break;
diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
new file mode 100644
index 0000000..ea3e99e
--- /dev/null
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -0,0 +1,228 @@
+#ifdef CONFIG_CPU_SUP_INTEL
+
+enum {
+	LBR_FORMAT_32		= 0x00,
+	LBR_FORMAT_LIP		= 0x01,
+	LBR_FORMAT_EIP		= 0x02,
+	LBR_FORMAT_EIP_FLAGS	= 0x03,
+};
+
+/*
+ * We only support LBR implementations that have FREEZE_LBRS_ON_PMI
+ * otherwise it becomes near impossible to get a reliable stack.
+ */
+
+#define X86_DEBUGCTL_LBR               		(1 << 0)
+#define X86_DEBUGCTL_FREEZE_LBRS_ON_PMI		(1 << 11)
+
+static void __intel_pmu_lbr_enable(void)
+{
+	u64 debugctl;
+
+	rdmsrl(MSR_IA32_DEBUGCTLMSR, debugctl);
+	debugctl |= (X86_DEBUGCTL_LBR | X86_DEBUGCTL_FREEZE_LBRS_ON_PMI);
+	wrmsrl(MSR_IA32_DEBUGCTLMSR, debugctl);
+}
+
+static void __intel_pmu_lbr_disable(void)
+{
+	u64 debugctl;
+
+	rdmsrl(MSR_IA32_DEBUGCTLMSR, debugctl);
+	debugctl &= ~(X86_DEBUGCTL_LBR | X86_DEBUGCTL_FREEZE_LBRS_ON_PMI);
+	wrmsrl(MSR_IA32_DEBUGCTLMSR, debugctl);
+}
+
+static void intel_pmu_lbr_reset_32(void)
+{
+	int i;
+
+	for (i = 0; i < x86_pmu.lbr_nr; i++)
+		wrmsrl(x86_pmu.lbr_from + i, 0);
+}
+
+static void intel_pmu_lbr_reset_64(void)
+{
+	int i;
+
+	for (i = 0; i < x86_pmu.lbr_nr; i++) {
+		wrmsrl(x86_pmu.lbr_from + i, 0);
+		wrmsrl(x86_pmu.lbr_to   + i, 0);
+	}
+}
+
+static void intel_pmu_lbr_reset(void)
+{
+	if (x86_pmu.lbr_format == LBR_FORMAT_32)
+		intel_pmu_lbr_reset_32();
+	else
+		intel_pmu_lbr_reset_64();
+}
+
+static void intel_pmu_lbr_enable(struct perf_event *event)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+
+	if (!x86_pmu.lbr_nr)
+		return;
+
+	WARN_ON(cpuc->enabled);
+
+	/*
+	 * Reset the LBR stack if this is the first LBR user or
+	 * we changed task context so as to avoid data leaks.
+	 */
+
+	if (!cpuc->lbr_users ||
+	    (event->ctx->task && cpuc->lbr_context != event->ctx)) {
+		intel_pmu_lbr_reset();
+		cpuc->lbr_context = event->ctx;
+	}
+
+	cpuc->lbr_users++;
+}
+
+static void intel_pmu_lbr_disable(struct perf_event *event)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+
+	if (!x86_pmu.lbr_nr)
+		return;
+
+	cpuc->lbr_users--;
+
+	BUG_ON(cpuc->lbr_users < 0);
+	WARN_ON(cpuc->enabled);
+}
+
+static void intel_pmu_lbr_enable_all(void)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+
+	if (cpuc->lbr_users)
+		__intel_pmu_lbr_enable();
+}
+
+static void intel_pmu_lbr_disable_all(void)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+
+	if (cpuc->lbr_users)
+		__intel_pmu_lbr_disable();
+}
+
+static inline u64 intel_pmu_lbr_tos(void)
+{
+	u64 tos;
+
+	rdmsrl(x86_pmu.lbr_tos, tos);
+
+	return tos;
+}
+
+static void intel_pmu_lbr_read_32(struct cpu_hw_events *cpuc)
+{
+	unsigned long mask = x86_pmu.lbr_nr - 1;
+	u64 tos = intel_pmu_lbr_tos();
+	int i;
+
+	for (i = 0; i < x86_pmu.lbr_nr; i++, tos--) {
+		unsigned long lbr_idx = (tos - i) & mask;
+		union {
+			struct {
+				u32 from;
+				u32 to;
+			};
+			u64     lbr;
+		} msr_lastbranch;
+
+		rdmsrl(x86_pmu.lbr_from + lbr_idx, msr_lastbranch.lbr);
+
+		cpuc->lbr_entries[i].from  = msr_lastbranch.from;
+		cpuc->lbr_entries[i].to    = msr_lastbranch.to;
+		cpuc->lbr_entries[i].flags = 0;
+	}
+	cpuc->lbr_stack.nr = i;
+}
+
+#define LBR_FROM_FLAG_MISPRED  (1ULL << 63)
+
+/*
+ * Due to lack of segmentation in Linux the effective address (offset)
+ * is the same as the linear address, allowing us to merge the LIP and EIP
+ * LBR formats.
+ */
+static void intel_pmu_lbr_read_64(struct cpu_hw_events *cpuc)
+{
+	unsigned long mask = x86_pmu.lbr_nr - 1;
+	u64 tos = intel_pmu_lbr_tos();
+	int i;
+
+	for (i = 0; i < x86_pmu.lbr_nr; i++, tos--) {
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
+		cpuc->lbr_entries[i].from  = from;
+		cpuc->lbr_entries[i].to    = to;
+		cpuc->lbr_entries[i].flags = flags;
+	}
+	cpuc->lbr_stack.nr = i;
+}
+
+static void intel_pmu_lbr_read(void)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+
+	if (!cpuc->lbr_users)
+		return;
+
+	if (x86_pmu.lbr_format == LBR_FORMAT_32)
+		intel_pmu_lbr_read_32(cpuc);
+	else
+		intel_pmu_lbr_read_64(cpuc);
+}
+
+static int intel_pmu_lbr_format(void)
+{
+	u64 capabilities;
+
+	rdmsrl(MSR_IA32_PERF_CAPABILITIES, capabilities);
+	return capabilities & 0x1f;
+}
+
+static void intel_pmu_lbr_init_core(void)
+{
+	x86_pmu.lbr_format = intel_pmu_lbr_format();
+	x86_pmu.lbr_nr     = 4;
+	x86_pmu.lbr_tos    = 0x01c9;
+	x86_pmu.lbr_from   = 0x40;
+	x86_pmu.lbr_to     = 0x60;
+}
+
+static void intel_pmu_lbr_init_nhm(void)
+{
+	x86_pmu.lbr_format = intel_pmu_lbr_format();
+	x86_pmu.lbr_nr     = 16;
+	x86_pmu.lbr_tos    = 0x01c9;
+	x86_pmu.lbr_from   = 0x680;
+	x86_pmu.lbr_to     = 0x6c0;
+}
+
+static void intel_pmu_lbr_init_atom(void)
+{
+	x86_pmu.lbr_format = intel_pmu_lbr_format();
+	x86_pmu.lbr_nr	   = 8;
+	x86_pmu.lbr_tos    = 0x01c9;
+	x86_pmu.lbr_from   = 0x40;
+	x86_pmu.lbr_to     = 0x60;
+}
+
+#endif /* CONFIG_CPU_SUP_INTEL */
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 42307b5..ab4fd9e 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -467,6 +467,17 @@ struct perf_raw_record {
 	void				*data;
 };
 
+struct perf_branch_entry {
+	__u64				from;
+	__u64				to;
+	__u64				flags;
+};
+
+struct perf_branch_stack {
+	__u64				nr;
+	struct perf_branch_entry	entries[0];
+};
+
 struct task_struct;
 
 /**
