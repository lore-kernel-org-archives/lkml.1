Return-Path: <linux-kernel-owner+w=401wt.eu-S1761431AbXE2ODh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761431AbXE2ODh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 10:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752147AbXE2OAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 10:00:04 -0400
Received: from madara.hpl.hp.com ([192.6.19.124]:56272 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188AbXE2N7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 09:59:49 -0400
X-Greylist: delayed 659 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 May 2007 09:59:42 EDT
Date: Tue, 29 May 2007 06:48:37 -0700
From: Stephane Eranian <eranian@frankl.hpl.hp.com>
Message-Id: <200705291348.l4TDmbhh019892@frankl.hpl.hp.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 22/22] 2.6.22-rc3 perfmon2 : new mips files
Cc: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@frankl.hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the new mips files


The files are as follows:

arch/mips/perfmon/Kconfig:
	- add menuconfig options

arch/mips/perfmon/Makefile:
	- makefile for arch specific files

arch/mips/perfmon/perfmon.c:
	- architecture specific perfmon support. Implements architecture specific
	  operations such as save/restore/start/stop/detect overflow counters

arch/mips/perfmon/perfmon_mips64.c:
	- PMU description table for various MIPS processors

include/asm-mips/perfmon.h:
	- MIPS specific perfmon definitions

include/asm-mips/perfmon_api.h:
	- MIPS user-visible constants





--- linux-2.6.22.base/arch/mips/perfmon/Kconfig	1969-12-31 16:00:00.000000000 -0800
+++ linux-2.6.22/arch/mips/perfmon/Kconfig	2007-05-29 03:24:14.000000000 -0700
@@ -0,0 +1,23 @@
+menu "Hardware Performance Monitoring support"
+config PERFMON
+	bool "Perfmon2 performance monitoring interface"
+	default n
+	help
+  	Enables the perfmon2 interface to access the hardware
+	performance counters. See <http://perfmon2.sf.net/> for
+ 	more details.
+
+config PERFMON_DEBUG
+ 	bool "Perfmon debugging"
+	default n
+	depends on PERFMON
+ 	help
+  	Enables perfmon debugging support
+
+config PERFMON_MIPS64
+	tristate "Support for MIPS64 hardware performance counters"
+	depends on PERFMON
+	default n
+	help
+	Enables support for the MIPS64 hardware performance counters"
+endmenu
--- linux-2.6.22.base/arch/mips/perfmon/Makefile	1969-12-31 16:00:00.000000000 -0800
+++ linux-2.6.22/arch/mips/perfmon/Makefile	2007-05-29 03:24:14.000000000 -0700
@@ -0,0 +1,2 @@
+obj-$(CONFIG_PERFMON)		+= perfmon.o
+obj-$(CONFIG_PERFMON_MIPS64)	+= perfmon_mips64.o
--- linux-2.6.22.base/arch/mips/perfmon/perfmon.c	1969-12-31 16:00:00.000000000 -0800
+++ linux-2.6.22/arch/mips/perfmon/perfmon.c	2007-05-29 03:24:14.000000000 -0700
@@ -0,0 +1,312 @@
+/*
+ * This file implements the MIPS64 specific
+ * support for the perfmon2 interface
+ *
+ * Copyright (c) 2005 Philip J. Mucci
+ *
+ * based on versions for other architectures:
+ * Copyright (c) 2005 Hewlett-Packard Development Company, L.P.
+ * Contributed by Stephane Eranian <eranian@htrpl.hp.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of version 2 of the GNU General Public
+ * License as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
+ * 02111-1307 USA
+  */
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/perfmon.h>
+
+/*
+ * collect pending overflowed PMDs. Called from pfm_ctxsw()
+ * and from PMU interrupt handler. Must fill in set->povfl_pmds[]
+ * and set->npend_ovfls. Interrupts are masked
+ */
+static void __pfm_get_ovfl_pmds(struct pfm_context *ctx, struct pfm_event_set *set)
+{
+ 	u64 new_val, wmask;
+	u64 *used_mask, *cnt_pmds;
+	u64 mask[PFM_PMD_BV];
+	unsigned int i, max;
+
+	max = pfm_pmu_conf->max_cnt_pmd;
+	cnt_pmds = pfm_pmu_conf->cnt_pmds;
+	used_mask = set->used_pmds;
+	wmask = 1ULL << pfm_pmu_conf->counter_width;
+	bitmap_and(ulp(mask),ulp(cnt_pmds),ulp(used_mask),max);
+	
+	for (i = 0; i < max; i++) {
+		/* assume all PMD are counters */
+		if (test_bit(i, mask)) {
+			new_val = pfm_arch_read_pmd(ctx, i);
+
+ 			PFM_DBG_ovfl("pmd%u new_val=0x%llx bit=%d\n",
+  				 i, (unsigned long long)new_val,
+				 (new_val&wmask) ? 1 : 0);
+
+  			if (new_val & wmask) {
+				__set_bit(i, set->povfl_pmds);
+				set->npend_ovfls++;
+			}
+		}
+	}
+}
+
+static void pfm_stop_active(struct task_struct *task, struct pfm_context *ctx,
+			       struct pfm_event_set *set)
+{
+	unsigned int i, max;
+
+	max = pfm_pmu_conf->max_pmc;
+
+	/*
+	 * clear enable bits
+	 */
+	for (i = 0; i < max; i++) {
+		if (test_bit(i, set->used_pmcs))
+			pfm_arch_write_pmc(ctx, i,0);
+	}
+
+	if (set->npend_ovfls)
+		return;
+
+	__pfm_get_ovfl_pmds(ctx, set);
+}
+
+/*
+ * Called from pfm_ctxsw(). Task is guaranteed to be current.
+ * Context is locked. Interrupts are masked. Monitoring is active.
+ * PMU access is guaranteed. PMC and PMD registers are live in PMU.
+ *
+ * for per-thread:
+ * 	must stop monitoring for the task
+ *
+ * Return:
+ * 	non-zero : did not save PMDs (as part of stopping the PMU)
+ * 	       0 : saved PMDs (no need to save them in caller)
+ */
+int pfm_arch_ctxswout_thread(struct task_struct *task, struct pfm_context *ctx,
+			      struct pfm_event_set *set)
+{
+	/*
+	 * disable lazy restore of PMC registers.
+	 */
+	set->priv_flags |= PFM_SETFL_PRIV_MOD_PMCS;
+
+	pfm_stop_active(task, ctx, set);
+
+	return 1;
+}
+
+/*
+ * Called from pfm_stop() and pfm_ctxsw() when idle
+ * task and EXCL_IDLE is on.
+ *
+ * Interrupts are masked. Context is locked. Set is the active set.
+ *
+ * For per-thread:
+ *   task is not necessarily current. If not current task, then
+ *   task is guaranteed stopped and off any cpu. Access to PMU
+ *   is not guaranteed. Interrupts are masked. Context is locked.
+ *   Set is the active set.
+ *
+ * For system-wide:
+ * 	task is current
+ *
+ * must disable active monitoring. ctx cannot be NULL
+ */
+void pfm_arch_stop(struct task_struct *task, struct pfm_context *ctx,
+		   struct pfm_event_set *set)
+{
+	/*
+	 * no need to go through stop_save()
+	 * if we are already stopped
+	 */
+	if (!ctx->flags.started)
+		return;
+
+	/*
+	 * stop live registers and collect pending overflow
+	 */
+	if (task == current)
+		pfm_stop_active(task, ctx, set);
+}
+
+/*
+ * function called from pfm_unload_context_*(). Context is locked.
+ * interrupts are masked. task is not guaranteed to be current task.
+ * Access to PMU is not guaranteed.
+ *
+ * function must do whatever arch-specific action is required on unload
+ * of a context.
+ *
+ * called for both system-wide and per-thread. task is NULL for ssytem-wide
+ */
+void pfm_arch_unload_context(struct pfm_context *ctx, struct task_struct *task)
+{
+}
+
+/*
+ * called from pfm_start() or pfm_ctxsw() when idle task and
+ * EXCL_IDLE is on.
+ *
+ * Interrupts are masked. Context is locked. Set is the active set.
+ *
+ * For per-trhead:
+ * 	Task is not necessarily current. If not current task, then task
+ * 	is guaranteed stopped and off any cpu. Access to PMU is not guaranteed.
+ *
+ * For system-wide:
+ * 	task is always current
+ *
+ * must enable active monitoring.
+ */
+void pfm_arch_start(struct task_struct *task, struct pfm_context *ctx,
+	            struct pfm_event_set *set)
+{
+	unsigned int i, max_pmc;
+
+	if (task != current)
+		return;
+
+	max_pmc = pfm_pmu_conf->max_pmc;
+
+	for (i = 0; i < max_pmc; i++) {
+		if (test_bit(i, set->used_pmcs))
+		    pfm_arch_write_pmc(ctx, i, set->pmcs[i]);
+	}
+}
+
+/*
+ * function called from pfm_switch_sets(), pfm_context_load_thread(),
+ * pfm_context_load_sys(), pfm_ctxsw(), pfm_switch_sets()
+ * context is locked. Interrupts are masked. set cannot be NULL.
+ * Access to the PMU is guaranteed.
+ *
+ * function must restore all PMD registers from set.
+ */
+void pfm_arch_restore_pmds(struct pfm_context *ctx, struct pfm_event_set *set)
+{
+	u64 ovfl_mask, val, *pmds;
+	u64 *impl_pmds;
+	unsigned int i;
+	unsigned int max_pmd;
+
+	max_pmd = pfm_pmu_conf->max_pmd;
+	ovfl_mask = pfm_pmu_conf->ovfl_mask;
+	impl_pmds = pfm_pmu_conf->impl_pmds;
+	pmds = set->view->set_pmds;
+
+	/*
+	 * must restore all pmds to avoid leaking
+	 * information to user.
+	 */
+	for (i = 0; i < max_pmd; i++) {
+
+		if (test_bit(i, impl_pmds) == 0)
+			continue;
+
+		val = pmds[i];
+
+		/*
+		 * set upper bits for counter to ensure
+		 * overflow will trigger
+		 */
+		val &= ovfl_mask;
+
+		pfm_arch_write_pmd(ctx, i, val);
+	}
+}
+
+/*
+ * function called from pfm_switch_sets(), pfm_context_load_thread(),
+ * pfm_context_load_sys(), pfm_ctxsw().
+ * Context is locked. Interrupts are masked. set cannot be NULL.
+ * Access to the PMU is guaranteed.
+ *
+ * function must restore all PMC registers from set, if needed.
+ */
+void pfm_arch_restore_pmcs(struct pfm_context *ctx, struct pfm_event_set *set)
+{
+	u64 *impl_pmcs;
+	unsigned int i, max_pmc;
+
+	max_pmc = pfm_pmu_conf->max_pmc;
+	impl_pmcs = pfm_pmu_conf->impl_pmcs;
+
+	/*
+	 * - by default no PMCS measures anything
+	 * - on ctxswout, all used PMCs are disabled (cccr enable bit cleared)
+	 * hence when masked we do not need to restore anything
+	 */
+	if (ctx->state == PFM_CTX_MASKED || ctx->flags.started == 0)
+		return;
+
+	/*
+	 * restore all pmcs
+	 */
+	for (i = 0; i < max_pmc; i++)
+		if (test_bit(i, impl_pmcs))
+			pfm_arch_write_pmc(ctx, i, set->pmcs[i]);
+}
+
+char *pfm_arch_get_pmu_module_name(void)
+{
+	switch(cpu_data->cputype) {
+#ifndef CONFIG_SMP
+	case CPU_34K:
+#if defined(CPU_74K)
+	case CPU_74K:
+#endif
+#endif
+	case CPU_SB1:
+	case CPU_SB1A:
+	case CPU_25KF:
+	case CPU_24K:
+	case CPU_20KC:
+	case CPU_5KC:
+	  return "perfmon_mips64";
+	default:
+	  return NULL;
+	}
+	return NULL;
+}
+
+int perfmon_perf_irq(void)
+{
+  /* BLATANTLY STOLEN FROM OPROFILE, then modified */
+  struct pt_regs *regs;
+  unsigned int counters = pfm_pmu_conf->max_pmc;
+  unsigned int control;
+  unsigned int counter;
+
+  regs = get_irq_regs();
+  switch (counters) {
+#define HANDLE_COUNTER(n)						\
+	case n + 1:							\
+		control = read_c0_perfctrl ## n();			\
+		counter = read_c0_perfcntr ## n();			\
+		if ((control & MIPS64_PMC_INT_ENABLE_MASK) &&		\
+		    (counter & MIPS64_PMD_INTERRUPT)) {			\
+			pfm_interrupt_handler(instruction_pointer(regs),\
+					      regs);                    \
+			return(1);					\
+		}
+      HANDLE_COUNTER(3)
+      HANDLE_COUNTER(2)
+      HANDLE_COUNTER(1)
+      HANDLE_COUNTER(0)
+      }
+
+  return 0;
+}
+EXPORT_SYMBOL(perfmon_perf_irq);
--- linux-2.6.22.base/arch/mips/perfmon/perfmon_mips64.c	1969-12-31 16:00:00.000000000 -0800
+++ linux-2.6.22/arch/mips/perfmon/perfmon_mips64.c	2007-05-29 03:24:14.000000000 -0700
@@ -0,0 +1,187 @@
+/*
+ * This file contains the MIPS64 and decendent PMU register description tables
+ * and pmc checker used by perfmon.c.
+ *
+ * Copyright (c) 2005 Philip Mucci
+ *
+ * Based on perfmon_p6.c:
+ * Copyright (c) 2005-2006 Hewlett-Packard Development Company, L.P.
+ * Contributed by Stephane Eranian <eranian@hpl.hp.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of version 2 of the GNU General Public
+ * License as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
+ * 02111-1307 USA
+ */
+#include <linux/module.h>
+#include <linux/perfmon.h>
+
+MODULE_AUTHOR("Philip Mucci <mucci@cs.utk.edu>");
+MODULE_DESCRIPTION("MIPS64 PMU description tables");
+MODULE_LICENSE("GPL");
+
+/*
+ * reserved:
+ * 	- bit 63-9
+ * RSVD: reserved bits must be 1
+ */
+#define PFM_MIPS64_PMC_RSVD 0xfffffffffffffe10ULL
+#define PFM_MIPS64_PMC_VAL  (1ULL<<4)
+
+extern int null_perf_irq(struct pt_regs *regs);
+extern int (*perf_irq)(struct pt_regs *regs);
+extern int perfmon_perf_irq(struct pt_regs *regs);
+
+static struct pfm_arch_pmu_info pfm_mips64_pmu_info;
+
+static struct pfm_reg_desc pfm_mips64_pmc_desc[]={
+/* pmc0 */  PMC_D(PFM_REG_I64, "CP0_25_0", PFM_MIPS64_PMC_VAL, PFM_MIPS64_PMC_RSVD, 0, 0),
+/* pmc1 */  PMC_D(PFM_REG_I64, "CP0_25_1", PFM_MIPS64_PMC_VAL, PFM_MIPS64_PMC_RSVD, 0, 1),
+/* pmc2 */  PMC_D(PFM_REG_I64, "CP0_25_2", PFM_MIPS64_PMC_VAL, PFM_MIPS64_PMC_RSVD, 0, 2),
+/* pmc3 */  PMC_D(PFM_REG_I64, "CP0_25_3", PFM_MIPS64_PMC_VAL, PFM_MIPS64_PMC_RSVD, 0, 3)
+};
+#define PFM_MIPS64_NUM_PMCS ARRAY_SIZE(pfm_mips64_pmc_desc)
+
+static struct pfm_reg_desc pfm_mips64_pmd_desc[]={
+/* pmd0 */ PMD_D(PFM_REG_C, "CP0_25_0", 0),
+/* pmd1 */ PMD_D(PFM_REG_C, "CP0_25_1", 1),
+/* pmd2 */ PMD_D(PFM_REG_C, "CP0_25_2", 2),
+/* pmd3 */ PMD_D(PFM_REG_C, "CP0_25_3", 3)
+};
+#define PFM_MIPS64_NUM_PMDS ARRAY_SIZE(pfm_mips64_pmd_desc)
+
+static int pfm_mips64_probe_pmu(void)
+{
+	struct cpuinfo_mips *c = &current_cpu_data;
+
+	switch (c->cputype) {
+#ifndef CONFIG_SMP
+	case CPU_34K:
+#if defined(CPU_74K)
+	case CPU_74K:
+#endif
+#endif
+	case CPU_SB1:
+	case CPU_SB1A:
+	case CPU_25KF:
+	case CPU_24K:
+	case CPU_20KC:
+	case CPU_5KC:
+		return 0;
+		break;
+	default:
+		PFM_INFO("Unknown cputype 0x%x",c->cputype);
+	}
+	return -1;
+}
+
+/*
+ * impl_pmcs, impl_pmds are computed at runtime to minimize errors!
+ */
+static struct pfm_pmu_config pfm_mips64_pmu_conf = {
+	.pmu_name = "MIPS", /* placeholder */
+	.counter_width = 31,
+	.pmd_desc = pfm_mips64_pmd_desc,
+	.pmc_desc = pfm_mips64_pmc_desc,
+	.num_pmc_entries = PFM_MIPS64_NUM_PMCS,
+	.num_pmd_entries = PFM_MIPS64_NUM_PMDS,
+	.probe_pmu = pfm_mips64_probe_pmu,
+	.flags = PFM_PMU_BUILTIN_FLAG,
+	.owner = THIS_MODULE,
+	.arch_info = &pfm_mips64_pmu_info
+};
+
+static inline int n_counters(void)
+{
+	if (!(read_c0_config1() & MIPS64_CONFIG_PMC_MASK))
+		return 0;
+	if (!(read_c0_perfctrl0() & MIPS64_PMC_CTR_MASK))
+		return 1;
+	if (!(read_c0_perfctrl1() & MIPS64_PMC_CTR_MASK))
+		return 2;
+	if (!(read_c0_perfctrl2() & MIPS64_PMC_CTR_MASK))
+		return 3;
+	return 4;
+}
+
+static int __init pfm_mips64_pmu_init_module(void)
+{
+	struct cpuinfo_mips *c = &current_cpu_data;
+	int i, ret, num;
+
+	switch (c->cputype) {
+	case CPU_5KC:
+		pfm_mips64_pmu_conf.pmu_name = "MIPS5KC";
+		break;
+	case CPU_20KC:
+		pfm_mips64_pmu_conf.pmu_name = "MIPS20KC";
+		break;
+	case CPU_24K:
+		pfm_mips64_pmu_conf.pmu_name = "MIPS24K";
+		break;
+	case CPU_25KF:
+		pfm_mips64_pmu_conf.pmu_name = "MIPS25KF";
+		break;
+	case CPU_SB1:
+		pfm_mips64_pmu_conf.pmu_name = "SB1";
+		break;
+	case CPU_SB1A:
+	pfm_mips64_pmu_conf.pmu_name = "SB1A";
+		break;
+#ifndef CONFIG_SMP
+	case CPU_34K:
+		pfm_mips64_pmu_conf.pmu_name = "MIPS34K";
+		break;
+#if defined(CPU_74K)
+	case CPU_74K:
+		pfm_mips64_pmu_conf.pmu_name = "MIPS74K";
+		break;
+#endif
+#endif
+	default:
+		PFM_INFO("Unknown cputype 0x%x",c->cputype);
+		return -1;
+	}
+
+	num = n_counters();
+	if (num == 0) {
+		PFM_INFO("cputype 0x%x has no counters",c->cputype);
+		return -1;
+	}
+	/* mark remaining counters unavailable */
+	for(i=num; i < PFM_MIPS64_NUM_PMCS; i++) {
+		pfm_mips64_pmc_desc[i].type = PFM_REG_NA;
+	}
+
+	for(i=num; i < PFM_MIPS64_NUM_PMDS; i++) {
+		pfm_mips64_pmd_desc[i].type = PFM_REG_NA;
+	}
+
+	pfm_mips64_pmu_conf.num_pmc_entries = num;
+	pfm_mips64_pmu_conf.num_pmd_entries = num;
+
+	pfm_mips64_pmu_info.pmu_style = c->cputype;
+
+	ret = pfm_pmu_register(&pfm_mips64_pmu_conf);
+	if (ret == 0)
+		perf_irq = perfmon_perf_irq;
+	return ret;
+}
+
+static void __exit pfm_mips64_pmu_cleanup_module(void)
+{
+	pfm_pmu_unregister(&pfm_mips64_pmu_conf);
+	perf_irq = null_perf_irq;
+}
+
+module_init(pfm_mips64_pmu_init_module);
+module_exit(pfm_mips64_pmu_cleanup_module);
--- linux-2.6.22.base/include/asm-mips/perfmon.h	1969-12-31 16:00:00.000000000 -0800
+++ linux-2.6.22/include/asm-mips/perfmon.h	2007-05-29 03:24:14.000000000 -0700
@@ -0,0 +1,370 @@
+/*
+ * Copyright (c) 2005 Philip Mucci.
+ *
+ * Based on other versions:
+ * Copyright (c) 2005-2006 Hewlett-Packard Development Company, L.P.
+ * Contributed by Stephane Eranian <eranian@hpl.hp.com>
+ *
+ * This file contains mips64 specific definitions for the perfmon
+ * interface.
+ *
+ * This file MUST never be included directly. Use linux/perfmon.h.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of version 2 of the GNU General Public
+ * License as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
+ * 02111-1307 USA
+  */
+#ifndef _ASM_MIPS64_PERFMON_H_
+#define _ASM_MIPS64_PERFMON_H_
+
+#ifdef __KERNEL__
+
+#define PFM_ARCH_PMD_STK_ARG	2
+#define PFM_ARCH_PMC_STK_ARG	2
+
+struct pfm_arch_pmu_info {
+	u32 pmu_style;
+};
+
+#define MIPS64_CONFIG_PMC_MASK (1 << 4)
+#define MIPS64_PMC_INT_ENABLE_MASK (1 << 4)
+#define MIPS64_PMC_CNT_ENABLE_MASK (0xf)
+#define MIPS64_PMC_EVT_MASK (0x7 << 6)
+#define MIPS64_PMC_CTR_MASK (1 << 31)
+#define MIPS64_PMD_INTERRUPT (1 << 31)
+
+/* Coprocessor register 25 contains the PMU interface. */
+/* Sel 0 is control for counter 0 */
+/* Sel 1 is count for counter 0. */
+/* Sel 2 is control for counter 1. */
+/* Sel 3 is count for counter 1. */
+
+/*
+
+31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4  3 2 1 0
+M  0--------------------------------------------------------------0 Event-- IE U S K EXL
+
+M 31 If this bit is one, another pair of Performance Control
+and Counter registers is implemented at a MTC0
+
+Event 8:5 Counter event enabled for this counter. Possible events
+are listed in Table 6-30. R/W Undefined
+
+IE 4 Counter Interrupt Enable. This bit masks bit 31 of the
+associated count register from the interrupt exception
+request output. R/W 0
+
+U 3 Count in User Mode. When this bit is set, the specified
+event is counted in User Mode. R/W Undefined
+
+S 2 Count in Supervisor Mode. When this bit is set, the
+specified event is counted in Supervisor Mode. R/W Undefined
+
+K 1 Count in Kernel Mode. When this bit is set, count the
+event in Kernel Mode when EXL and ERL both are 0. R/W Undefined
+
+EXL 0 Count when EXL. When this bit is set, count the event
+when EXL = 1 and ERL = 0. R/W Undefined
+*/
+
+static inline void pfm_arch_resend_irq(void)
+{}
+
+static inline void pfm_arch_serialize(void)
+{}
+
+
+static inline void pfm_arch_unfreeze_pmu(void)
+{}
+
+/*
+ * MIPS does not save the PMDs during pfm_arch_intr_freeze_pmu(), thus
+ * this routine needs to do it when switching sets on overflow
+ */
+static inline void pfm_arch_save_pmds_from_intr(struct pfm_context *ctx,
+					   struct pfm_event_set *set)
+{
+	pfm_save_pmds(ctx, set);
+}
+
+static inline void pfm_arch_write_pmc(struct pfm_context *ctx,
+				      unsigned int cnum, u64 value)
+{
+  /*
+   * we only write to the actual register when monitoring is
+   * active (pfm_start was issued)
+   */
+  if (ctx && (ctx->flags.started == 0))
+	  return;
+
+  switch(pfm_pmu_conf->pmc_desc[cnum].hw_addr) {
+  case 0:
+    write_c0_perfctrl0(value);
+    break;
+  case 1:
+    write_c0_perfctrl1(value);
+    break;
+  case 2:
+    write_c0_perfctrl2(value);
+    break;
+  case 3:
+    write_c0_perfctrl3(value);
+    break;
+  default:
+    BUG();
+  }
+}
+
+static inline void pfm_arch_write_pmd(struct pfm_context *ctx,
+				      unsigned int cnum, u64 value)
+{
+  value &= pfm_pmu_conf->ovfl_mask;
+
+  switch(pfm_pmu_conf->pmd_desc[cnum].hw_addr) {
+  case 0:
+    write_c0_perfcntr0(value);
+    break;
+  case 1:
+    write_c0_perfcntr1(value);
+    break;
+  case 2:
+    write_c0_perfcntr2(value);
+    break;
+  case 3:
+    write_c0_perfcntr3(value);
+    break;
+  default:
+    BUG();
+  }
+}
+
+static inline u64 pfm_arch_read_pmd(struct pfm_context *ctx, unsigned int cnum)
+{
+	switch(pfm_pmu_conf->pmd_desc[cnum].hw_addr) {
+	case 0:
+		return read_c0_perfcntr0();
+		break;
+	case 1:
+		return read_c0_perfcntr1();
+		break;
+	case 2:
+		return read_c0_perfcntr2();
+		break;
+	case 3:
+		return read_c0_perfcntr3();
+		break;
+	default:
+		BUG();
+		return 0;
+	}
+}
+
+static inline u64 pfm_arch_read_pmc(struct pfm_context *ctx, unsigned int cnum)
+{
+	switch(pfm_pmu_conf->pmc_desc[cnum].hw_addr) {
+	case 0:
+		return read_c0_perfctrl0();
+		break;
+	case 1:
+		return read_c0_perfctrl1();
+		break;
+	case 2:
+		return read_c0_perfctrl2();
+		break;
+	case 3:
+		return read_c0_perfctrl3();
+		break;
+	default:
+		BUG();
+		return 0;
+	}
+}
+
+/*
+ * For some CPUs, the upper bits of a counter must be set in order for the
+ * overflow interrupt to happen. On overflow, the counter has wrapped around,
+ * and the upper bits are cleared. This function may be used to set them back.
+ */
+static inline void pfm_arch_ovfl_reset_pmd(struct pfm_context *ctx,
+					   unsigned int cnum)
+{
+  u64 val;
+  val = pfm_arch_read_pmd(ctx, cnum);
+  /* This masks out overflow bit 31 */
+  pfm_arch_write_pmd(ctx, cnum, val);
+}
+
+/*
+ * At certain points, perfmon needs to know if monitoring has been
+ * explicitely started/stopped by user via pfm_start/pfm_stop. The
+ * information is tracked in ctx.flags.started. However on certain
+ * architectures, it may be possible to start/stop directly from
+ * user level with a single assembly instruction bypassing
+ * the kernel. This function must be used to determine by
+ * an arch-specific mean if monitoring is actually started/stopped.
+ */
+static inline int pfm_arch_is_active(struct pfm_context *ctx)
+{
+	return ctx->flags.started;
+}
+
+static inline void pfm_arch_ctxswout_sys(struct task_struct *task,
+					 struct pfm_context *ctx,
+					 struct pfm_event_set *set)
+{}
+
+static inline void pfm_arch_ctxswin_sys(struct task_struct *task,
+                                         struct pfm_context *ctx,
+                                         struct pfm_event_set *set)
+{}
+
+static inline void pfm_arch_ctxswin_thread(struct task_struct *task,
+                                         struct pfm_context *ctx,
+                                         struct pfm_event_set *set)
+{}
+
+int  pfm_arch_is_monitoring_active(struct pfm_context *ctx);
+int  pfm_arch_ctxswout_thread(struct task_struct *task,
+			      struct pfm_context *ctx, struct pfm_event_set *set);
+void pfm_arch_stop(struct task_struct *task, struct pfm_context *ctx,
+		   struct pfm_event_set *set);
+void pfm_arch_start(struct task_struct *task, struct pfm_context *ctx,
+		    struct pfm_event_set *set);
+void pfm_arch_restore_pmds(struct pfm_context *ctx, struct pfm_event_set *set);
+void pfm_arch_restore_pmcs(struct pfm_context *ctx, struct pfm_event_set *set);
+char *pfm_arch_get_pmu_module_name(void);
+
+static inline void pfm_arch_intr_freeze_pmu(struct pfm_context *ctx,
+					    struct pfm_event_set *set)
+{
+	pfm_arch_stop(current, ctx, set);
+	/*
+	 * we mark monitoring as stopped to avoid
+	 * certain side effects especially in
+	 * pfm_switch_sets_from_intr() on
+	 * pfm_arch_restore_pmcs()
+	 */
+	ctx->flags.started = 0;
+}
+
+/*
+ * unfreeze PMU from pfm_do_interrupt_handler()
+ * ctx may be NULL for spurious
+ */
+static inline void pfm_arch_intr_unfreeze_pmu(struct pfm_context *ctx)
+{
+	if (!ctx)
+		return;
+
+	PFM_DBG_ovfl("state=%d", ctx->state);
+
+	ctx->flags.started = 1;
+
+	if (ctx->state == PFM_CTX_MASKED)
+		return;
+
+	pfm_arch_restore_pmcs(ctx, ctx->active_set);
+}
+
+static inline int pfm_arch_pmu_config_init(struct _pfm_pmu_config *cfg)
+{
+	return 0;
+}
+
+/*
+ * this function is called from the PMU interrupt handler ONLY.
+ * On MIPS, the PMU is frozen via arch_stop, masking would be implemented
+ * via arch-stop as well. Given that the PMU is already stopped when
+ * entering the interrupt handler, we do not need to stop it again, so
+ * this function is a nop.
+ */
+static inline void pfm_arch_mask_monitoring(struct pfm_context *ctx,
+					    struct pfm_event_set *set)
+{}
+
+/*
+ * on MIPS masking/unmasking uses the start/stop mechanism, so we simply
+ * need to start here.
+ */
+static inline void pfm_arch_unmask_monitoring(struct pfm_context *ctx,
+					      struct pfm_event_set *set)
+{
+	pfm_arch_start(current, ctx, set);
+}
+
+static inline void pfm_arch_pmu_config_remove(void)
+{}
+
+static inline int pfm_arch_context_initialize(struct pfm_context *ctx,
+					      u32 ctx_flags)
+{
+	return 0;
+}
+
+void pfm_arch_unload_context(struct pfm_context *ctx, struct task_struct *task);
+
+/*
+ * function called from pfm_setfl_sane(). Context is locked
+ * and interrupts are masked.
+ * The value of flags is the value of ctx_flags as passed by
+ * user.
+ *
+ * function must check arch-specific set flags.
+ * Return:
+ * 	1 when flags are valid
+ *      0 on error
+ */
+static inline int
+pfm_arch_setfl_sane(struct pfm_context *ctx, u32 flags)
+{
+	return 0;
+}
+
+static inline int pfm_arch_init(void)
+{
+	return 0;
+}
+
+static inline void pfm_arch_init_percpu(void)
+{}
+
+static inline int pfm_arch_load_context(struct pfm_context *ctx,
+					struct pfm_event_set *set,
+					struct task_struct *task)
+{
+	return 0;
+}
+
+/*
+ * not used for mips
+ */
+static inline int pfm_smpl_buffer_alloc_compat(struct pfm_context *ctx,
+					       size_t rsize, struct file *filp)
+{
+	return -EINVAL;
+}
+
+static inline void pfm_arch_idle_notifier_register(void)
+{}
+
+static inline void pfm_arch_idle_notifier_unregister(void)
+{}
+
+struct pfm_arch_context {
+	/* empty */
+};
+
+#define PFM_ARCH_CTX_SIZE	sizeof(struct pfm_arch_context)
+
+#endif /* __KERNEL__ */
+#endif /* _ASM_MIPS64_PERFMON_H_ */
--- linux-2.6.22.base/include/asm-mips/perfmon_api.h	1969-12-31 16:00:00.000000000 -0800
+++ linux-2.6.22/include/asm-mips/perfmon_api.h	2007-05-29 03:24:14.000000000 -0700
@@ -0,0 +1,40 @@
+/*
+ * Copyright (c) 2007 Hewlett-Packard Development Company, L.P.
+ * Contributed by Stephane Eranian <eranian@hpl.hp.com>
+ *
+ * This file contains mips64 specific definitions for the perfmon
+ * interface.
+ *
+ * This file MUST never be included directly. Use linux/perfmon.h.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of version 2 of the GNU General Public
+ * License as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
+ * 02111-1307 USA
+  */
+#ifndef _ASM_MIPS64_PERFMON_API_H_
+#define _ASM_MIPS64_PERFMON_API_H_
+
+#define PFM_ARCH_MAX_HW_PMCS	256 /* maximum number of PMC registers */
+#define PFM_ARCH_MAX_HW_PMDS	256 /* maximum number of PMD registers */
+/*
+ * Virtual PMU registers: registers mapped to non-PMU resources
+ * IMPORTANT:
+ * 	- must appear in PMC/PMD namespace *AFTER* PMU registers
+ * 	- SW PMD can be specified as smpl_pmds, reset_pmds
+ * 	- SW PMD cannot overflow
+ * 	- SW PMD do not show up in pfarg_msg.ovfl_pmds/pfarg_setinfo_t.ovfl_pmds
+ */
+#define PFM_ARCH_MAX_SW_PMCS	64 /* max virtual PMCS */
+#define PFM_ARCH_MAX_SW_PMDS	64 /* max virtual PMDS */
+
+#endif /* _ASM_MIPS64_PERFMON_API_H_ */
