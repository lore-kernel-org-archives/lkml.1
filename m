Return-Path: <linux-kernel-owner+w=401wt.eu-S1751963AbXE2OEE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963AbXE2OEE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 10:04:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753793AbXE2OAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 10:00:08 -0400
Received: from madara.hpl.hp.com ([192.6.19.124]:56272 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752224AbXE2N7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 09:59:50 -0400
X-Greylist: delayed 659 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 May 2007 09:59:42 EDT
Date: Tue, 29 May 2007 06:48:32 -0700
From: Stephane Eranian <eranian@frankl.hpl.hp.com>
Message-Id: <200705291348.l4TDmWSE019840@frankl.hpl.hp.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 18/22] 2.6.22-rc3 perfmon2 : new powerpc files
Cc: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@frankl.hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the new files for powerpc.

The files are as follows:


arch/powerpc/perfmon/Kconfig:
	- add menuconfig options

arch/powerpc/perfmon/Makefile:
	- makefile for arch specific files

arch/powerpc/perfmon/perfmon.c:
	- architecture specific perfmon support. Implements architecrure specific
	  operations such as save/restore/start/stop/detect overflow counters, ...

arch/powerpc/perfmon/perfmon_power5.c:
	- PMU description table for Power 5

arch/powerpc/perfmon/perfmon_ppc32.c:
	- PMU description table for32-bit PowerPC

include/asm-powerpc/perfmon.h:
	- architecture specific header definitions

include/asm-powerpc/perfmon_api.h:
	- PPC specific user-visible constants


--- linux-2.6.22.base/arch/powerpc/perfmon/Kconfig	1969-12-31 16:00:00.000000000 -0800
+++ linux-2.6.22/arch/powerpc/perfmon/Kconfig	2007-05-29 03:24:14.000000000 -0700
@@ -0,0 +1,32 @@
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
+config PERFMON_POWER5
+	tristate "Support for Power5 hardware performance counters"
+ 	depends on PERFMON && PPC64
+	default n
+	help
+	Enables support for the Power 5 hardware performance counters
+	If unsure, say M.
+
+config PERFMON_PPC32
+	tristate "Support for PPC32 hardware performance counters"
+ 	depends on PERFMON && PPC32
+	default n
+	help
+	Enables support for the PPC32 hardware performance counters
+	If unsure, say M.
+endmenu
--- linux-2.6.22.base/arch/powerpc/perfmon/Makefile	1969-12-31 16:00:00.000000000 -0800
+++ linux-2.6.22/arch/powerpc/perfmon/Makefile	2007-05-29 03:24:14.000000000 -0700
@@ -0,0 +1,3 @@
+obj-$(CONFIG_PERFMON)		+= perfmon.o
+obj-$(CONFIG_PERFMON_POWER5)	+= perfmon_power5.o
+obj-$(CONFIG_PERFMON_PPC32)	+= perfmon_ppc32.o
--- linux-2.6.22.base/arch/powerpc/perfmon/perfmon.c	1969-12-31 16:00:00.000000000 -0800
+++ linux-2.6.22/arch/powerpc/perfmon/perfmon.c	2007-05-29 03:24:14.000000000 -0700
@@ -0,0 +1,285 @@
+/*
+ * This file implements the powerpc specific
+ * support for the perfmon2 interface
+ *
+ * Copyright (c) 2005 David Gibson, IBM Corporation.
+ *
+ * based on versions for other architectures:
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
+#include <linux/interrupt.h>
+#include <linux/perfmon.h>
+
+/*
+ * collect pending overflowed PMDs. Called from pfm_ctxsw()
+ * and from PMU interrupt handler. Must fill in set->povfl_pmds[]
+ * and set->npend_ovfls. Interrupts are masked
+ */
+static void __pfm_get_ovfl_pmds(struct pfm_context *ctx,
+				struct pfm_event_set *set)
+{
+	u64 new_val, wmask;
+	u64 *used_mask, *cnt_pmds;
+	u64 mask[PFM_PMD_BV];
+	unsigned int i, max;
+
+	max = pfm_pmu_conf->max_cnt_pmd;
+	used_mask = set->used_pmds;
+	cnt_pmds = pfm_pmu_conf->cnt_pmds;
+	wmask = 1ULL << pfm_pmu_conf->counter_width;
+	bitmap_and(ulp(mask), ulp(cnt_pmds), ulp(used_mask), max);
+
+	for (i = 0; i < max; i++) {
+		/* assume all PMD are counters */
+		if (test_bit(i, mask)) {
+			new_val = pfm_arch_read_pmd(ctx, i);
+
+			PFM_DBG_ovfl("pmd%u new_val=0x%llx bit=%d",
+				     i, (unsigned long long)new_val,
+				     (new_val & wmask) ? 1 : 0);
+
+			if (!(new_val & wmask)) {
+				__set_bit(i, set->povfl_pmds);
+				set->npend_ovfls++;
+			}
+		}
+	}
+}
+
+static void pfm_stop_active(struct task_struct *task,
+			    struct pfm_context *ctx, struct pfm_event_set *set)
+{
+	unsigned int i, max;
+
+	max = pfm_pmu_conf->max_pmc;
+	/*
+	 * clear enable bits
+	 */
+	for (i = 0; i < max; i++)
+		if (test_bit(i, set->used_pmcs))
+			pfm_arch_write_pmc(ctx, i,0);
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
+ * Return:
+ * 	non-zero : did not save PMDs (as part of stopping the PMU)
+ * 	       0 : saved PMDs (no need to save them in caller)
+ */
+int pfm_arch_ctxswout_thread(struct task_struct *task,
+			     struct pfm_context *ctx, struct pfm_event_set *set)
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
+ * Called from pfm_stop() and idle notifier
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
+void pfm_arch_stop(struct task_struct *task,
+		   struct pfm_context *ctx, struct pfm_event_set *set)
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
+ * called from pfm_start() and idle notifier
+ *
+ * Interrupts are masked. Context is locked. Set is the active set.
+ *
+ * For per-thread:
+ * 	Task is not necessarily current. If not current task, then task
+ * 	is guaranteed stopped and off any cpu. No access to PMU is task
+ *	is not current.
+ *
+ * For system-wide:
+ * 	task is always current
+ *
+ * must enable active monitoring.
+ */
+void pfm_arch_start(struct task_struct *task,
+		    struct pfm_context *ctx, struct pfm_event_set *set)
+{
+	unsigned int i, max_pmc;
+
+	if (task != current)
+		return;
+
+	max_pmc = pfm_pmu_conf->max_pmc;
+
+	for (i = 0; i < max_pmc; i++)
+		if (test_bit(i,set->used_pmcs))
+		    pfm_arch_write_pmc(ctx, i, set->pmcs[i]);
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
+		if (!test_bit(i, impl_pmds))
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
+ * pfm_context_load_sys(), pfm_ctxsw(), pfm_switch_sets()
+ * context is locked. Interrupts are masked. set cannot be NULL.
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
+	unsigned int pvr = mfspr(SPRN_PVR);
+
+	switch (PVR_VER(pvr)) {
+	case 0x0004: /* 604 */
+	case 0x0009: /* 604e;  */
+	case 0x000A: /* 604ev */
+	case 0x0008: /* 750/740 */
+	case 0x7000: /* 750FX */
+	case 0x7001:
+	case 0x7002: /* 750GX */
+	case 0x000C: /* 7400 */
+	case 0x800C: /* 7410 */
+	case 0x8000: /* 7451/7441 */
+	case 0x8001: /* 7455/7445 */
+	case 0x8002: /* 7457/7447 */
+	case 0x8003: /* 7447A */
+	case 0x8004: /* 7448 */
+		return("perfmon_ppc32");
+	case PV_POWER4:
+	case PV_POWER4p:
+		return "perfmon_power4";
+	case PV_POWER5:
+	case PV_POWER5p:
+		return "perfmon_power5";
+	case PV_970:
+	case PV_970FX:
+	case PV_970MP:
+		return "perfmon_ppc970";
+	case PV_BE:
+		return "perfmon_cell";
+	}
+	return NULL;
+}
+
+void pfm_arch_init_percpu(void)
+{
+#ifdef CONFIG_PPC64
+	extern void ppc64_enable_pmcs(void);
+	ppc64_enable_pmcs();
+#endif
+}
--- linux-2.6.22.base/arch/powerpc/perfmon/perfmon_power5.c	1969-12-31 16:00:00.000000000 -0800
+++ linux-2.6.22/arch/powerpc/perfmon/perfmon_power5.c	2007-05-29 03:24:14.000000000 -0700
@@ -0,0 +1,96 @@
+/*
+ * This file contains the POWER5 PMU register description tables
+ * and pmc checker used by perfmon.c.
+ *
+ * Copyright (c) 2005 David Gibson, IBM Corporation.
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
+MODULE_AUTHOR("David Gibson <dwg@au1.ibm.com>");
+MODULE_DESCRIPTION("POWER5 PMU description table");
+MODULE_LICENSE("GPL");
+
+struct pfm_arch_pmu_info pfm_power5_pmu_info = {
+	.pmu_style = PFM_POWERPC_PMU_POWER5,
+};
+
+static struct pfm_reg_desc pfm_power5_pmc_desc[]={
+/* mmcr0 */ PMC_D(PFM_REG_I, "MMCR0", MMCR0_FC, 0, 0, SPRN_MMCR0),
+/* mmcr1 */ PMC_D(PFM_REG_I, "MMCR1", 0, 0, 0, SPRN_MMCR1),
+/* mmcra */ PMC_D(PFM_REG_I, "MMCRA", 0, 0, 0, SPRN_MMCRA)
+};
+#define PFM_PM_NUM_PMCS	ARRAY_SIZE(pfm_power5_pmc_desc)
+
+/* The TB and PURR registers are read-only. Also, note that the TB register
+ * actually consists of both the 32-bit SPRN_TBRU and SPRN_TBRL registers.
+ * For Perfmon2's purposes, we'll treat it as a single 64-bit register.
+ */
+static struct pfm_reg_desc pfm_power5_pmd_desc[]={
+/* tb    */ PMD_D((PFM_REG_I|PFM_REG_RO), "TB", SPRN_TBRL),
+/* pmd1  */ PMD_D(PFM_REG_C, "PMC1", SPRN_PMC1),
+/* pmd2  */ PMD_D(PFM_REG_C, "PMC2", SPRN_PMC2),
+/* pmd3  */ PMD_D(PFM_REG_C, "PMC3", SPRN_PMC3),
+/* pmd4  */ PMD_D(PFM_REG_C, "PMC4", SPRN_PMC4),
+/* pmd5  */ PMD_D(PFM_REG_C, "PMC5", SPRN_PMC5),
+/* pmd6  */ PMD_D(PFM_REG_C, "PMC6", SPRN_PMC6),
+/* purr  */ PMD_D((PFM_REG_I|PFM_REG_RO), "PURR", SPRN_PURR),
+};
+#define PFM_PM_NUM_PMDS	ARRAY_SIZE(pfm_power5_pmd_desc)
+
+static int pfm_power5_probe_pmu(void)
+{
+	unsigned long pvr = mfspr(SPRN_PVR);
+
+	if (PVR_VER(pvr) != PV_POWER5)
+		return -1;
+
+	return 0;
+}
+
+/*
+ * impl_pmcs, impl_pmds are computed at runtime to minimize errors!
+ */
+static struct pfm_pmu_config pfm_power5_pmu_conf = {
+	.pmu_name = "POWER5",
+	.counter_width = 31,
+	.pmd_desc = pfm_power5_pmd_desc,
+	.pmc_desc = pfm_power5_pmc_desc,
+	.num_pmc_entries = PFM_PM_NUM_PMCS,
+	.num_pmd_entries = PFM_PM_NUM_PMDS,
+	.probe_pmu  = pfm_power5_probe_pmu,
+	.arch_info = &pfm_power5_pmu_info,
+	.flags = PFM_PMU_BUILTIN_FLAG,
+	.owner = THIS_MODULE
+};
+	
+static int __init pfm_power5_pmu_init_module(void)
+{
+	return pfm_pmu_register(&pfm_power5_pmu_conf);
+}
+
+static void __exit pfm_power5_pmu_cleanup_module(void)
+{
+	pfm_pmu_unregister(&pfm_power5_pmu_conf);
+}
+
+module_init(pfm_power5_pmu_init_module);
+module_exit(pfm_power5_pmu_cleanup_module);
--- linux-2.6.22.base/arch/powerpc/perfmon/perfmon_ppc32.c	1969-12-31 16:00:00.000000000 -0800
+++ linux-2.6.22/arch/powerpc/perfmon/perfmon_ppc32.c	2007-05-29 03:24:14.000000000 -0700
@@ -0,0 +1,207 @@
+/*
+ * This file contains the PPC32 PMU register description tables
+ * and pmc checker used by perfmon.c.
+ *
+ * Philip Mucci, mucci@cs.utk.edu
+ *
+ * Based on code from:
+ * Copyright (c) 2005 David Gibson, IBM Corporation.
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
+#include <asm/reg.h>
+
+MODULE_AUTHOR("Philip Mucci <mucci@cs.utk.edu>");
+MODULE_DESCRIPTION("PPC32 PMU description table");
+MODULE_LICENSE("GPL");
+
+struct pfm_arch_pmu_info pfm_ppc32_pmu_info = {
+	.pmu_style = PFM_POWERPC_PMU_NONE,
+};
+
+static struct pfm_pmu_config pfm_ppc32_pmu_conf;
+
+static struct pfm_reg_desc pfm_ppc32_pmc_desc[] = {
+/* mmcr0 */ PMC_D(PFM_REG_I, "MMCR0", 0x0, 0, 0, SPRN_MMCR0),
+/* mmcr1 */ PMC_D(PFM_REG_I, "MMCR1", 0x0, 0, 0, SPRN_MMCR1),
+/* mmcr2 */ PMC_D(PFM_REG_I, "MMCR2", 0x0, 0, 0, SPRN_MMCR2),
+};
+#define PFM_PM_NUM_PMCS	ARRAY_SIZE(pfm_ppc32_pmc_desc)
+
+static struct pfm_reg_desc pfm_ppc32_pmd_desc[] = {
+/* pmd0  */ PMD_D(PFM_REG_C, "PMC1", SPRN_PMC1),
+/* pmd1  */ PMD_D(PFM_REG_C, "PMC2", SPRN_PMC2),
+/* pmd2  */ PMD_D(PFM_REG_C, "PMC3", SPRN_PMC3),
+/* pmd3  */ PMD_D(PFM_REG_C, "PMC4", SPRN_PMC4),
+/* pmd4  */ PMD_D(PFM_REG_C, "PMC5", SPRN_PMC5),
+/* pmd5  */ PMD_D(PFM_REG_C, "PMC6", SPRN_PMC6),
+};
+#define PFM_PM_NUM_PMDS	ARRAY_SIZE(pfm_ppc32_pmd_desc)
+
+static void perfmon_perf_irq(struct pt_regs *regs)
+{
+	u32 mmcr0;
+
+	/* BLATANTLY STOLEN FROM OPROFILE, then modified */
+
+	/* set the PMM bit (see comment below) */
+	mtmsr(mfmsr() | MSR_PMM);
+
+	pfm_interrupt_handler(instruction_pointer(regs), regs);
+
+	/* The freeze bit was set by the interrupt.
+	 * Clear the freeze bit, and reenable the interrupt.
+	 * The counters won't actually start until the rfi clears
+	 * the PMM bit.
+	 */
+
+	/* Unfreezes the counters on this CPU, enables the interrupt,
+	 * enables the counters to trigger the interrupt, and sets the
+	 * counters to only count when the mark bit is not set.
+	 */
+	mmcr0 = mfspr(SPRN_MMCR0);
+
+	mmcr0 &= ~(MMCR0_FC | MMCR0_FCM0);
+	mmcr0 |= (MMCR0_FCECE | MMCR0_PMC1CE | MMCR0_PMCnCE | MMCR0_PMXE);
+
+	mtspr(SPRN_MMCR0, mmcr0);
+}
+
+static int pfm_ppc32_probe_pmu(void)
+{
+	enum ppc32_pmu_type pm_type;
+	int nmmcr = 0, npmds = 0, intsok = 0, i;
+	unsigned int pvr;
+	char *str;
+
+	pvr = mfspr(SPRN_PVR);
+
+	switch (PVR_VER(pvr)) {
+	case 0x0004: /* 604 */
+		str = "PPC604";
+		pm_type = PFM_POWERPC_PMU_604;
+		nmmcr = 1;
+		npmds = 2;
+		break;
+	case 0x0009: /* 604e;  */
+	case 0x000A: /* 604ev */
+		str = "PPC604e";
+		pm_type = PFM_POWERPC_PMU_604e;
+		nmmcr = 2;
+		npmds = 4;
+		break;
+	case 0x0008: /* 750/740 */
+		str = "PPC750";
+		pm_type = PFM_POWERPC_PMU_750;
+		nmmcr = 2;
+		npmds = 4;
+		break;
+	case 0x7000: /* 750FX */
+	case 0x7001:
+		str = "PPC750";
+		pm_type = PFM_POWERPC_PMU_750;
+		nmmcr = 2;
+		npmds = 4;
+		if ((pvr & 0xFF0F) >= 0x0203)
+			intsok = 1;
+		break;
+	case 0x7002: /* 750GX */
+		str = "PPC750";
+		pm_type = PFM_POWERPC_PMU_750;
+		nmmcr = 2;
+		npmds = 4;
+		intsok = 1;
+	case 0x000C: /* 7400 */
+		str = "PPC7400";
+		pm_type = PFM_POWERPC_PMU_7400;
+		nmmcr = 3;
+		npmds = 4;
+		break;
+	case 0x800C: /* 7410 */
+		str = "PPC7410";
+		pm_type = PFM_POWERPC_PMU_7400;
+		nmmcr = 3;
+		npmds = 4;
+		if ((pvr & 0xFFFF) >= 0x01103)
+			intsok = 1;
+		break;
+	case 0x8000: /* 7451/7441 */
+	case 0x8001: /* 7455/7445 */
+	case 0x8002: /* 7457/7447 */
+	case 0x8003: /* 7447A */
+	case 0x8004: /* 7448 */
+		str = "PPC7450";
+		pm_type = PFM_POWERPC_PMU_7450;
+		nmmcr = 3; npmds = 6;
+		intsok = 1;
+		break;
+	default:
+		PFM_INFO("Unknown PVR_VER(0x%x)\n", PVR_VER(pvr));
+		return -1;
+	}
+
+	/*
+	 * deconfigure unimplemented registers
+	 */
+	for (i = npmds; i < PFM_PM_NUM_PMDS; i++)
+		pfm_ppc32_pmd_desc[i].type = PFM_REG_NA;
+
+	for (i = nmmcr; i < PFM_PM_NUM_PMCS; i++)
+		pfm_ppc32_pmc_desc[i].type = PFM_REG_NA;
+
+	/*
+	 * update PMU description structure
+	 */
+	pfm_ppc32_pmu_conf.pmu_name = str;
+	pfm_ppc32_pmu_info.pmu_style = pm_type;
+	pfm_ppc32_pmu_conf.num_pmc_entries = nmmcr;
+	pfm_ppc32_pmu_conf.num_pmd_entries = npmds;
+
+	if (intsok == 0)
+		PFM_INFO("Interrupts unlikely to work\n");
+
+	return reserve_pmc_hardware(perfmon_perf_irq);
+}
+
+static struct pfm_pmu_config pfm_ppc32_pmu_conf = {
+	.counter_width = 31,
+	.pmd_desc = pfm_ppc32_pmd_desc,
+	.pmc_desc = pfm_ppc32_pmc_desc,
+	.probe_pmu  = pfm_ppc32_probe_pmu,
+	.flags = PFM_PMU_BUILTIN_FLAG,
+	.owner = THIS_MODULE,
+	.version = "0.1",
+	.arch_info = &pfm_ppc32_pmu_info,
+};
+	
+static int __init pfm_ppc32_pmu_init_module(void)
+{
+	return pfm_pmu_register(&pfm_ppc32_pmu_conf);
+}
+
+static void __exit pfm_ppc32_pmu_cleanup_module(void)
+{
+	release_pmc_hardware();
+	pfm_pmu_unregister(&pfm_ppc32_pmu_conf);
+}
+
+module_init(pfm_ppc32_pmu_init_module);
+module_exit(pfm_ppc32_pmu_cleanup_module);
--- linux-2.6.22.base/include/asm-powerpc/perfmon.h	1969-12-31 16:00:00.000000000 -0800
+++ linux-2.6.22/include/asm-powerpc/perfmon.h	2007-05-29 03:24:14.000000000 -0700
@@ -0,0 +1,365 @@
+/*
+ * Copyright (c) 2005 David Gibson, IBM Corporation.
+ *
+ * Based on other versions:
+ * Copyright (c) 2005 Hewlett-Packard Development Company, L.P.
+ * Contributed by Stephane Eranian <eranian@hpl.hp.com>
+ *
+ * This file contains powerpc specific definitions for the perfmon
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
+ */
+#ifndef _ASM_POWERPC_PERFMON_H_
+#define _ASM_POWERPC_PERFMON_H_
+
+#ifdef __KERNEL__
+
+#include <asm/pmc.h>
+
+enum powerpc_pmu_type {
+	PFM_POWERPC_PMU_NONE,
+	PFM_POWERPC_PMU_604,
+	PFM_POWERPC_PMU_604e,
+	PFM_POWERPC_PMU_750,	/* XXX: Minor event set diffs between IBM and Moto. */
+	PFM_POWERPC_PMU_7400,
+	PFM_POWERPC_PMU_7450,
+	PFM_POWERPC_PMU_POWER5,
+};
+
+struct pfm_arch_pmu_info {
+	enum powerpc_pmu_type pmu_style;
+};
+
+#ifdef CONFIG_PPC32
+#define PFM_ARCH_PMD_STK_ARG	6 /* conservative value */
+#define PFM_ARCH_PMC_STK_ARG	6 /* conservative value */
+#else
+#define PFM_ARCH_PMD_STK_ARG	8 /* conservative value */
+#define PFM_ARCH_PMC_STK_ARG	8 /* conservative value */
+#endif
+
+static inline void pfm_arch_resend_irq(void)
+{}
+
+static inline void pfm_arch_serialize(void)
+{}
+
+static inline void pfm_arch_write_pmc(struct pfm_context *ctx,
+				      unsigned int cnum,
+				      u64 value)
+{
+	/*
+	 * we only write to the actual register when monitoring is
+	 * active (pfm_start was issued)
+	 */
+	if (ctx && (ctx->flags.started == 0))
+		return;
+
+	switch (pfm_pmu_conf->pmc_desc[cnum].hw_addr) {
+	case SPRN_MMCR0:
+		mtspr(SPRN_MMCR0, value);
+		break;
+	case SPRN_MMCR1:
+		mtspr(SPRN_MMCR1, value);
+		break;
+#ifdef CONFIG_PPC64
+	case SPRN_MMCRA:
+		mtspr(SPRN_MMCRA, value);
+		break;
+#else
+	case SPRN_MMCR2:
+		mtspr(SPRN_MMCR2, value);
+		break;
+#endif
+	default:
+		BUG();
+	}
+}
+
+static inline u64 pfm_arch_read_pmc(struct pfm_context *ctx, unsigned int cnum)
+{
+	switch (pfm_pmu_conf->pmc_desc[cnum].hw_addr) {
+	case SPRN_MMCR0:
+		return mfspr(SPRN_MMCR0);
+	case SPRN_MMCR1:
+		return mfspr(SPRN_MMCR1);
+#ifdef CONFIG_PPC64
+	case SPRN_MMCRA:
+		return mfspr(SPRN_MMCRA);
+#else
+	case SPRN_MMCR2:
+		return mfspr(SPRN_MMCR2);
+#endif
+	default:
+		BUG();
+	}
+}
+
+static inline void pfm_arch_write_pmd(struct pfm_context *ctx,
+				      unsigned int cnum, u64 value)
+{
+	value &= pfm_pmu_conf->ovfl_mask;
+
+	switch (pfm_pmu_conf->pmd_desc[cnum].hw_addr) {
+	case SPRN_PMC1:
+		mtspr(SPRN_PMC1, value);
+		break;
+	case SPRN_PMC2:
+		mtspr(SPRN_PMC2, value);
+		break;
+	case SPRN_PMC3:
+		mtspr(SPRN_PMC3, value);
+		break;
+	case SPRN_PMC4:
+		mtspr(SPRN_PMC4, value);
+		break;
+	case SPRN_PMC5:
+		mtspr(SPRN_PMC5, value);
+		break;
+	case SPRN_PMC6:
+		mtspr(SPRN_PMC6, value);
+		break;
+#ifdef CONFIG_PPC64
+	case SPRN_PMC7:
+		mtspr(SPRN_PMC7, value);
+		break;
+	case SPRN_PMC8:
+		mtspr(SPRN_PMC8, value);
+		break;
+#endif
+	default:
+		BUG();
+	}
+}
+
+static inline u64 pfm_arch_read_pmd(struct pfm_context *ctx, unsigned int cnum)
+{
+	switch (pfm_pmu_conf->pmd_desc[cnum].hw_addr) {
+	case SPRN_PMC1:
+		return mfspr(SPRN_PMC1);
+	case SPRN_PMC2:
+		return mfspr(SPRN_PMC2);
+	case SPRN_PMC3:
+		return mfspr(SPRN_PMC3);
+	case SPRN_PMC4:
+		return mfspr(SPRN_PMC4);
+	case SPRN_PMC5:
+		return mfspr(SPRN_PMC5);
+	case SPRN_PMC6:
+		return mfspr(SPRN_PMC6);
+#ifdef CONFIG_PPC64
+	case SPRN_PMC7:
+		return mfspr(SPRN_PMC7);
+	case SPRN_PMC8:
+		return mfspr(SPRN_PMC8);
+#endif
+	default:
+		BUG();
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
+	u64 val = pfm_arch_read_pmd(ctx, cnum);
+
+	/* This masks out overflow bit 31 */
+	pfm_arch_write_pmd(ctx, cnum, val);
+}
+
+/*
+ * At certain points, perfmon needs to know if monitoring has been
+ * explicitely started/stopped by user via pfm_start/pfm_stop. The
+ * information is tracked in flags.started. However on certain
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
+		           		 struct pfm_context *ctx,
+					 struct pfm_event_set *set)
+{}
+
+static inline void pfm_arch_ctxswin_sys(struct task_struct *task,
+					struct pfm_context *ctx,
+					struct pfm_event_set *set)
+{}
+
+static inline void pfm_arch_ctxswin_thread(struct task_struct *task,
+					   struct pfm_context *ctx,
+					   struct pfm_event_set *set)
+{}
+
+void pfm_arch_init_percpu(void);
+int  pfm_arch_is_monitoring_active(struct pfm_context *ctx);
+int  pfm_arch_ctxswout_thread(struct task_struct *task, struct pfm_context *ctx,
+			      struct pfm_event_set *set);
+void pfm_arch_stop(struct task_struct *task, struct pfm_context *ctx,
+			  struct pfm_event_set *set);
+void pfm_arch_start(struct task_struct *task, struct pfm_context *ctx,
+			   struct pfm_event_set *set);
+void pfm_arch_restore_pmds(struct pfm_context *ctx, struct pfm_event_set *set);
+void pfm_arch_restore_pmcs(struct pfm_context *ctx, struct pfm_event_set *set);
+int  pfm_arch_get_ovfl_pmds(struct pfm_context *ctx,
+			    struct pfm_event_set *set);
+char *pfm_arch_get_pmu_module_name(void);
+/*
+ * called from __pfm_interrupt_handler(). ctx is not NULL.
+ * ctx is locked. PMU interrupt is masked.
+ *
+ * must stop all monitoring to ensure handler has consistent view.
+ * must collect overflowed PMDs bitmask  into povfls_pmds and
+ * npend_ovfls. If no interrupt detected then npend_ovfls
+ * must be set to zero.
+ */
+static inline void pfm_arch_intr_freeze_pmu(struct pfm_context *ctx, struct pfm_event_set *set)
+{
+	pfm_arch_stop(current, ctx, set);
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
+/*
+ * PowerPC does not save the PMDs during pfm_arch_intr_freeze_pmu(), thus
+ * this routine needs to do it when switching sets on overflow
+ */
+static inline void pfm_arch_save_pmds_from_intr(struct pfm_context *ctx,
+					   struct pfm_event_set *set)
+{
+	pfm_save_pmds(ctx, set);
+}
+
+/*
+ * this function is called from the PMU interrupt handler ONLY.
+ * On PPC, the PMU is frozen via arch_stop, masking would be implemented
+ * via arch-stop as well. Given that the PMU is already stopped when
+ * entering the interrupt handler, we do not need to stop it again, so
+ * this function is a nop.
+ */
+static inline void pfm_arch_mask_monitoring(struct pfm_context *ctx,
+					    struct pfm_event_set *set)
+{}
+
+/*
+ * on x86 masking/unmasking uses the start/stop mechanism, so we simply
+ * need to start here.
+ */
+static inline void pfm_arch_unmask_monitoring(struct pfm_context *ctx,
+					      struct pfm_event_set *set)
+{
+	pfm_arch_start(current, ctx, set);
+}
+
+
+static inline int pfm_arch_pmu_config_init(struct _pfm_pmu_config *cfg)
+{
+	return 0;
+}
+
+static inline void pfm_arch_pmu_config_remove(void)
+{}
+
+static inline int pfm_arch_context_initialize(struct pfm_context *ctx,
+					       u32 ctx_flags)
+{
+	return 0;
+}
+
+static inline void pfm_arch_unload_context(struct pfm_context *ctx,
+					   struct task_struct *task)
+{}
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
+static inline int pfm_arch_setfl_sane(struct pfm_context *ctx, u32 flags)
+{
+	return 0;
+}
+
+static inline int pfm_arch_init(void)
+{
+	return 0;
+}
+
+static inline int pfm_arch_load_context(struct pfm_context *ctx,
+					struct pfm_event_set *set,
+					struct task_struct *task)
+{
+	return 0;
+}
+
+/*
+ * not applicable to powerpc
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
+#define PFM_ARCH_CTX_SIZE sizeof(struct pfm_arch_context)
+
+#endif /* __KERNEL__ */
+#endif /* _ASM_POWERPC_PERFMON_H_ */
--- linux-2.6.22.base/include/asm-powerpc/perfmon_api.h	1969-12-31 16:00:00.000000000 -0800
+++ linux-2.6.22/include/asm-powerpc/perfmon_api.h	2007-05-29 03:24:14.000000000 -0700
@@ -0,0 +1,41 @@
+/*
+ * Copyright (c) 2007 Hewlett-Packard Development Company, L.P.
+ * Contributed by Stephane Eranian <eranian@hpl.hp.com>
+ *
+ * This file contains powerpc specific definitions for the perfmon
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
+#ifndef _ASM_POWERPC_PERFMON_API_H_
+#define _ASM_POWERPC_PERFMON_API_H_
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
+
+#endif /* _ASM_POWERPC_PERFMON_API_H_ */
