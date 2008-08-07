Return-Path: <linux-kernel-owner+w=401wt.eu-S1753846AbYHGVP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846AbYHGVP0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 17:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbYHGVPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 17:15:12 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:56775 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193AbYHGVPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 17:15:07 -0400
Message-ID: <489B65DB.7000407@us.ibm.com>
Date: Thu, 07 Aug 2008 14:15:07 -0700
From: Corey Ashford <cjashfor@us.ibm.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] adds base POWER arch support to perfmon2 minimal v3
Content-Type: multipart/mixed;
 boundary="------------020600030808070804000201"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020600030808070804000201
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This patch adds a base level of support for the POWER architecture to 
the perfmon2 minimal v3 patch set posted to the mailing list by Stephane 
Eranian on 06/30/2008.

Thanks for your consideration,

- Corey

-- 
Corey Ashford
Software Engineer
IBM Linux Technology Center, Linux Toolchain
Beaverton, OR
503-578-3507
cjashfor@us.ibm.com

--------------020600030808070804000201
Content-Type: text/plain;
 name="perfmon-ppc64-base.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="perfmon-ppc64-base.diff"

This patch adds chip-independent perfmon2 support for the PowerPC and POWER
architectures.  It does not implement perfmon2 for any specific PowerPC or
POWER chip, but does add the underpinnings for that implementation.

Prerequisites: The patch is built on top of Steven Rothwell's Linux git
tree, plus Stephane Eranian's minimal perfmon2 patch v2 posted to the LKML
mailing list on 6/30.

In addition to adding a new directory, arch/powerpc/perfmon, and several
files in that new directory, it also adds perfmon2 support for handling the
PMU exception on these processors.

In order to share the PMU exception handler with Oprofile, we continue to
use the same exception wrapper (STD_PSERIES_EXCEPTION), but mimmick what
the MASKABLE_PSERIES_EXCEPTION macro does from within powerpc_irq_handler
in arch/powerpc/perfmon/perfmon.c.  In order to do this correctly, a new
member was added to the paca structure to record that a PMU exception
occurred while interrupts were soft disabled.

Signed-off-by: Corey Ashford <cjashfor@us.ibm.com>
--

Index: linux-next/include/asm-powerpc/paca.h
===================================================================
--- linux-next.orig/include/asm-powerpc/paca.h	2008-08-07 11:32:17.000000000 -0400
+++ linux-next/include/asm-powerpc/paca.h	2008-08-07 11:39:06.000000000 -0400
@@ -99,6 +99,10 @@
 	u8 soft_enabled;		/* irq soft-enable flag */
 	u8 hard_enabled;		/* set if irqs are enabled in MSR */
 	u8 io_sync;			/* writel() needs spin_unlock sync */
+#ifdef CONFIG_PERFMON
+	u8 pmu_except_pending;          /* PMU exception occurred while soft
+					 * disabled */
+#endif
 
 	/* Stuff for accurate time accounting */
 	u64 user_time;			/* accumulated usermode TB ticks */
Index: linux-next/arch/powerpc/kernel/irq.c
===================================================================
--- linux-next.orig/arch/powerpc/kernel/irq.c	2008-08-07 11:32:01.000000000 -0400
+++ linux-next/arch/powerpc/kernel/irq.c	2008-08-07 11:39:06.000000000 -0400
@@ -114,6 +114,24 @@
 	: : "r" (enable), "i" (offsetof(struct paca_struct, soft_enabled)));
 }
 
+#ifdef CONFIG_PERFMON
+static inline unsigned long get_pmu_except_pending(void)
+{
+	unsigned long pending;
+
+	__asm__ __volatile__("lbz %0,%1(13)"
+	: "=r" (pending) : "i" (offsetof(struct paca_struct, pmu_except_pending)));
+
+	return pending;
+}
+
+static inline void set_pmu_except_pending(unsigned long pending)
+{
+	__asm__ __volatile__("stb %0,%1(13)"
+	: : "r" (pending), "i" (offsetof(struct paca_struct, pmu_except_pending)));
+}
+#endif /* CONFIG_PERFMON */
+
 notrace void raw_local_irq_restore(unsigned long en)
 {
 	/*
@@ -172,6 +190,21 @@
 		lv1_get_version_info(&tmp);
 	}
 
+#ifdef CONFIG_PERFMON
+	/*
+	 * If a PMU exception occurred while interrupts were soft disabled,
+	 * force a PMU exception.
+	 */
+	if (get_pmu_except_pending()) {
+		set_pmu_except_pending(0);
+		/*
+		 * When both MSR_EE and MMCR_PMAO are set, a PMU exception
+		 * will occur.
+		 */
+		mtspr(SPRN_MMCR0, mfspr(SPRN_MMCR0) | (MMCR0_PMXE | MMCR0_PMAO));
+	}
+#endif /* CONFIG_PERFMON */
+
 	__hard_irq_enable();
 }
 EXPORT_SYMBOL(raw_local_irq_restore);
Index: linux-next/arch/powerpc/perfmon/perfmon.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-next/arch/powerpc/perfmon/perfmon.c	2008-08-07 13:22:24.000000000 -0400
@@ -0,0 +1,310 @@
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
+#include <linux/perfmon_kern.h>
+//#include <linux/smp.h>
+
+static void pfm_stop_active(struct task_struct *task,
+			    struct pfm_context *ctx, struct pfm_event_set *set)
+{
+	struct pfm_arch_pmu_info *arch_info;
+
+	arch_info = pfm_pmu_info();
+	BUG_ON(!arch_info->disable_counters || !arch_info->get_ovfl_pmds);
+
+	arch_info->disable_counters(ctx, set);
+
+	if (set->npend_ovfls)
+		return;
+
+	arch_info->get_ovfl_pmds(ctx, set);
+}
+
+/*
+ * Called from pfm_save_pmds(). Interrupts are masked.  Registers are
+ * already saved away.
+ */
+void pfm_arch_clear_pmd_ovfl_cond(struct pfm_context *ctx, struct pfm_event_set *set)
+{
+	int i, num;
+	u64 *used_pmds, *intr_pmds;
+
+	set = ctx->active_set;
+
+	num = set->nused_pmds;
+	used_pmds = set->used_pmds;
+	intr_pmds = pfm_pmu_conf->regs.intr_pmds;
+
+	for (i = 0; num; i++)
+		if (likely(test_bit(i, used_pmds))) {
+			if (likely(test_bit(i, intr_pmds)))
+				pfm_write_pmd(ctx, i, 0);
+			num--;
+		}
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
+int pfm_arch_ctxswout_thread(struct task_struct *task, struct pfm_context *ctx)
+{
+	struct pfm_arch_pmu_info *arch_info;
+
+	arch_info = pfm_pmu_info();
+	/*
+	 * disable lazy restore of the PMC & PMD registers.
+	 */
+	ctx->active_set->priv_flags |= PFM_SETFL_PRIV_MOD_BOTH;
+
+	pfm_stop_active(task, ctx, ctx->active_set);
+
+	if (arch_info->ctxswout_thread)
+		arch_info->ctxswout_thread(task, ctx, ctx->active_set);
+
+	return pfm_arch_is_active(ctx);
+}
+
+/*
+ * Called from pfm_ctxsw
+ */
+void pfm_arch_ctxswin_thread(struct task_struct *task, struct pfm_context *ctx)
+{
+	struct pfm_arch_pmu_info *arch_info;
+
+	arch_info = pfm_pmu_info();
+	if (ctx->flags.started == 1) {
+		BUG_ON(!arch_info->enable_counters);
+		arch_info->enable_counters(ctx, ctx->active_set);
+	}
+
+	if (arch_info->ctxswin_thread)
+		arch_info->ctxswin_thread(task, ctx, ctx->active_set);
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
+void pfm_arch_stop(struct task_struct *task, struct pfm_context *ctx)
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
+		pfm_stop_active(task, ctx, ctx->active_set);
+}
+
+/*
+ * Enable active monitoring. Called from pfm_start() and
+ * pfm_arch_unmask_monitoring().
+ *
+ * Interrupts are masked. Context is locked. Set is the active set.
+ *
+ * For per-thread:
+ * 	Task is not necessarily current. If not current task, then task
+ * 	is guaranteed stopped and off any cpu. No access to PMU if task
+ *	is not current.
+ *
+ * For system-wide:
+ * 	Task is always current
+ */
+void pfm_arch_start(struct task_struct *task, struct pfm_context *ctx)
+{
+	struct pfm_arch_pmu_info *arch_info;
+
+	arch_info = pfm_pmu_info();
+	if (task != current)
+		return;
+
+	BUG_ON(!arch_info->enable_counters);
+
+	arch_info->enable_counters(ctx, ctx->active_set);
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
+	struct pfm_arch_pmu_info *arch_info;
+	u64 *used_pmds;
+	u16 i, num;
+
+	arch_info = pfm_pmu_info();
+
+	/* The model-specific module can override the default
+	 * restore-PMD method.
+	 */
+	if (arch_info->restore_pmds)
+		return arch_info->restore_pmds(set);
+
+	num = set->nused_pmds;
+	used_pmds = set->used_pmds;
+
+	for (i = 0; num; i++) {
+		if (likely(test_bit(i, used_pmds))) {
+			pfm_write_pmd(ctx, i, set->pmds[i].value);
+			num--;
+		}
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
+	struct pfm_arch_pmu_info *arch_info;
+	u64 *impl_pmcs;
+	unsigned int i, max_pmc, reg;
+
+	arch_info = pfm_pmu_info();
+	/* The model-specific module can override the default
+	 * restore-PMC method.
+	 */
+	if (arch_info->restore_pmcs)
+		return arch_info->restore_pmcs(set);
+
+	/* The "common" powerpc model's enable the counters simply by writing
+	 * all the control registers. Therefore, if we're stopped we
+	 * don't need to bother restoring the PMCs now.
+	 */
+	if (ctx->flags.started == 0)
+		return;
+
+	max_pmc = pfm_pmu_conf->regs.max_pmc;
+	impl_pmcs = pfm_pmu_conf->regs.pmcs;
+
+	/*
+	 * Restore all pmcs in reverse order to ensure the counters aren't
+	 * enabled before their event selectors are set correctly.
+	 */
+	reg = max_pmc - 1;
+	for (i = 0; i < max_pmc; i++) {
+		if (test_bit(reg, impl_pmcs))
+			pfm_arch_write_pmc(ctx, reg, set->pmcs[reg]);
+		reg--;
+	}
+}
+
+int pfm_arch_init(void)
+{
+#ifdef CONFIG_PPC64
+	extern void ppc64_enable_pmcs(void);
+
+	/* Tell the hypervisor to set the "PMU in use" bit on each CPU */
+	on_each_cpu(ppc64_enable_pmcs, NULL, 0, 1);
+#endif
+	return 0;
+}
+
+/**
+ * powerpc_irq_handler
+ *
+ * Get the perfmon context that belongs to the current CPU, and call the
+ * model-specific interrupt handler.
+ **/
+void powerpc_irq_handler(struct pt_regs *regs)
+{
+	struct pfm_arch_pmu_info *arch_info;
+	struct pfm_context *ctx;
+
+	if (! regs->softe) {
+		/*
+		 * We got a PMU interrupt while interrupts were soft
+		 * disabled.  Disable hardware interrupts by clearing
+		 * MSR_EE and also reset the PMU Alert Occurred bit.
+		 * Note that MMCR0_PMXE is cleared by the hardware.
+		 */
+		regs->msr &= ~MSR_EE;
+		get_paca()->pmu_except_pending = 1;
+		mtspr(SPRN_MMCR0, mfspr(SPRN_MMCR0) & ~MMCR0_PMAO);
+		return;
+	}
+
+	arch_info = pfm_pmu_info();
+	if (arch_info->irq_handler) {
+		ctx = __get_cpu_var(pmu_ctx);
+		if (likely(ctx))
+			arch_info->irq_handler(regs, ctx);
+	}
+}
+
+/**
+ * pfm_reserved_1, pfm_reserved_2, pfm_reserved_3, pfm_reserved_4
+ *
+ * These are placeholder system calls for future use by perfmon2 and are
+ * needed on POWER because the build check scripts do not tolerate gaps
+ * in the syscall numbering.
+ **/
+
+void sys_pfm_reserved_1(void)
+{}
+
+void sys_pfm_reserved_2(void)
+{}
+
+void sys_pfm_reserved_3(void)
+{}
+
+void sys_pfm_reserved_4(void)
+{}
Index: linux-next/arch/powerpc/perfmon/Kconfig
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-next/arch/powerpc/perfmon/Kconfig	2008-08-07 12:00:08.000000000 -0400
@@ -0,0 +1,26 @@
+menu "Hardware Performance Monitoring support"
+config PERFMON
+	bool "Perfmon2 performance monitoring interface"
+	default n
+	help
+	Enables the perfmon2 interface to access the hardware
+	performance counters. See <http://perfmon2.sf.net/> for
+	more details.
+
+config PERFMON_DEBUG
+	bool "Perfmon debugging"
+	default n
+	depends on PERFMON
+	help
+	Enables perfmon debugging support
+
+config PERFMON_DEBUG_FS
+	bool "Enable perfmon statistics reporting via debugfs"
+	default y
+	depends on PERFMON && DEBUG_FS
+	help
+	Enable collection and reporting of perfmon timing statistics under
+	debugfs. This is used for debugging and performance analysis of the
+	subsystem. The debugfs filesystem must be mounted.
+
+endmenu
Index: linux-next/arch/powerpc/Kconfig
===================================================================
--- linux-next.orig/arch/powerpc/Kconfig	2008-08-07 11:32:01.000000000 -0400
+++ linux-next/arch/powerpc/Kconfig	2008-08-07 11:39:06.000000000 -0400
@@ -219,6 +219,7 @@
 
 source "arch/powerpc/sysdev/Kconfig"
 source "arch/powerpc/platforms/Kconfig"
+source "arch/powerpc/perfmon/Kconfig"
 
 menu "Kernel options"
 
Index: linux-next/include/asm-powerpc/perfmon.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-next/include/asm-powerpc/perfmon.h	2008-08-07 11:39:06.000000000 -0400
@@ -0,0 +1,33 @@
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
+ */
+#ifndef _ASM_POWERPC_PERFMON_H_
+#define _ASM_POWERPC_PERFMON_H_
+
+/*
+ * arch-specific user visible interface definitions
+ */
+#define PFM_ARCH_MAX_PMCS	(256+64) /* 256 HW 64 SW */
+#define PFM_ARCH_MAX_PMDS	(256+64) /* 256 HW 64 SW */
+
+#endif /* _ASM_POWERPC_PERFMON_H_ */
Index: linux-next/include/asm-powerpc/perfmon_kern.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-next/include/asm-powerpc/perfmon_kern.h	2008-08-07 12:00:08.000000000 -0400
@@ -0,0 +1,314 @@
+/*
+ * Copyright (c) 2005-2008 David Gibson, IBM Corporation.
+ *
+ * Based on other versions:
+ * Copyright (c) 2005 Hewlett-Packard Development Company, L.P.
+ * Contributed by Stephane Eranian <eranian@hpl.hp.com>
+ *
+ * This file contains powerpc specific definitions for the perfmon
+ * interface.
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
+#ifndef _ASM_POWERPC_PERFMON_KERN_H_
+#define _ASM_POWERPC_PERFMON_KERN_H_
+
+#ifdef __KERNEL__
+
+#ifdef CONFIG_PERFMON
+
+#include <asm/pmc.h>
+
+enum powerpc_pmu_type {
+	PFM_POWERPC_PMU_NONE
+};
+
+struct pfm_arch_pmu_info {
+	enum powerpc_pmu_type pmu_style;
+
+	void (*write_pmc)(unsigned int cnum, u64 value);
+
+	void (*write_pmd)(struct pfm_context *ctx,
+			  unsigned int cnum,
+			  u64 value);
+
+	u64 (*read_pmd)(struct pfm_context *ctx, unsigned int cnum);
+
+	void (*enable_counters)(struct pfm_context *ctx,
+				struct pfm_event_set *set);
+	void (*disable_counters)(struct pfm_context *ctx,
+				 struct pfm_event_set *set);
+
+	void (*irq_handler)(struct pt_regs *regs, struct pfm_context *ctx);
+	void (*get_ovfl_pmds)(struct pfm_context *ctx,
+			      struct pfm_event_set *set);
+
+	/* The following routines are optional. */
+	void (*restore_pmcs)(struct pfm_event_set *set);
+	void (*restore_pmds)(struct pfm_event_set *set);
+
+	int  (*ctxswout_thread)(struct task_struct *task,
+				struct pfm_context *ctx,
+				struct pfm_event_set *set);
+	void (*ctxswin_thread)(struct task_struct *task,
+			       struct pfm_context *ctx,
+			       struct pfm_event_set *set);
+	int  (*load_context)(struct pfm_context *ctx);
+	void (*unload_context)(struct pfm_context *ctx);
+	int  (*acquire_pmu)(u64 *unavail_pmcs, u64 *unavail_pmds);
+	void (*release_pmu)(void);
+	void *platform_info;
+	void (*resend_irq)(struct pfm_context *ctx);
+};
+
+#define PFM_ARCH_PMD_STK_ARG	8 /* conservative value */
+#define PFM_ARCH_PMC_STK_ARG	8 /* conservative value */
+
+static inline void pfm_arch_resend_irq(struct pfm_context *ctx)
+{
+	struct pfm_arch_pmu_info *arch_info;
+
+	arch_info = pfm_pmu_info();
+	arch_info->resend_irq(ctx);
+}
+
+static inline void pfm_arch_serialize(void)
+{}
+
+static inline void pfm_arch_write_pmc(struct pfm_context *ctx,
+				      unsigned int cnum,
+				      u64 value)
+{
+	struct pfm_arch_pmu_info *arch_info;
+
+	arch_info =  pfm_pmu_info();
+
+	/*
+	 * we only write to the actual register when monitoring is
+	 * active (pfm_start was issued)
+	 */
+	if (ctx && ctx->flags.started == 0)
+		return;
+
+	BUG_ON(!arch_info->write_pmc);
+
+	arch_info->write_pmc(cnum, value);
+}
+
+static inline void pfm_arch_write_pmd(struct pfm_context *ctx,
+				      unsigned int cnum, u64 value)
+{
+	struct pfm_arch_pmu_info *arch_info;
+
+	arch_info = pfm_pmu_info();
+
+	value &= pfm_pmu_conf->ovfl_mask;
+
+	BUG_ON(!arch_info->write_pmd);
+
+	arch_info->write_pmd(ctx, cnum, value);
+}
+
+static inline u64 pfm_arch_read_pmd(struct pfm_context *ctx, unsigned int cnum)
+{
+	struct pfm_arch_pmu_info *arch_info;
+
+	arch_info = pfm_pmu_info();
+
+	BUG_ON(!arch_info->read_pmd);
+
+	return arch_info->read_pmd(ctx, cnum);
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
+					 struct pfm_context *ctx)
+{}
+
+static inline void pfm_arch_ctxswin_sys(struct task_struct *task,
+					struct pfm_context *ctx)
+{}
+
+int pfm_arch_init(void);
+int  pfm_arch_is_monitoring_active(struct pfm_context *ctx);
+int  pfm_arch_ctxswout_thread(struct task_struct *task, struct pfm_context *ctx);
+void pfm_arch_ctxswin_thread(struct task_struct *task, struct pfm_context *ctx);
+void pfm_arch_stop(struct task_struct *task, struct pfm_context *ctx);
+void pfm_arch_start(struct task_struct *task, struct pfm_context *ctx);
+void pfm_arch_restore_pmds(struct pfm_context *ctx, struct pfm_event_set *set);
+void pfm_arch_restore_pmcs(struct pfm_context *ctx, struct pfm_event_set *set);
+int  pfm_arch_get_ovfl_pmds(struct pfm_context *ctx,
+			    struct pfm_event_set *set);
+void pfm_arch_clear_pmd_ovfl_cond(struct pfm_context *ctx, struct pfm_event_set *set);
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
+	pfm_arch_stop(current, ctx);
+}
+
+void powerpc_irq_handler(struct pt_regs *regs);
+
+/*
+ * unfreeze PMU from pfm_do_interrupt_handler()
+ * ctx may be NULL for spurious
+ */
+static inline void pfm_arch_intr_unfreeze_pmu(struct pfm_context *ctx)
+{
+	struct pfm_arch_pmu_info *arch_info;
+
+	if (!ctx)
+		return;
+
+	PFM_DBG_ovfl("state=%d", ctx->state);
+
+	ctx->flags.started = 1;
+
+	arch_info = pfm_pmu_info();
+	BUG_ON(!arch_info->enable_counters);
+	arch_info->enable_counters(ctx, ctx->active_set);
+}
+
+static inline int pfm_arch_pmu_config_init(struct pfm_pmu_config *cfg)
+{
+	return 0;
+}
+
+static inline int pfm_arch_context_create(struct pfm_context *ctx,
+					  u32 ctx_flags)
+{
+	return 0;
+}
+
+static inline void pfm_arch_context_free(struct pfm_context *ctx)
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
+static inline int pfm_arch_load_context(struct pfm_context *ctx)
+{
+	struct pfm_arch_pmu_info *arch_info;
+	int rc = 0;
+
+	arch_info = pfm_pmu_info();
+	if (arch_info->load_context)
+		rc = arch_info->load_context(ctx);
+
+	return rc;
+}
+
+static inline void pfm_arch_unload_context(struct pfm_context *ctx)
+{
+	struct pfm_arch_pmu_info *arch_info;
+
+	arch_info = pfm_pmu_info();
+	if (arch_info->unload_context)
+		arch_info->unload_context(ctx);
+}
+
+static inline int pfm_arch_pmu_acquire(u64 *unavail_pmcs, u64 *unavail_pmds)
+{
+	struct pfm_arch_pmu_info *arch_info;
+	int rc = 0;
+
+	arch_info = pfm_pmu_info();
+	if (arch_info->acquire_pmu) {
+		rc = arch_info->acquire_pmu(unavail_pmcs, unavail_pmds);
+		if (rc)
+			return rc;
+	}
+
+	return reserve_pmc_hardware(powerpc_irq_handler);
+}
+
+static inline void pfm_arch_pmu_release(void)
+{
+	struct pfm_arch_pmu_info *arch_info;
+
+	arch_info = pfm_pmu_info();
+	if (arch_info->release_pmu)
+		arch_info->release_pmu();
+
+	release_pmc_hardware();
+}
+
+static inline void pfm_arch_arm_handle_work(struct task_struct *task)
+{}
+
+static inline void pfm_arch_disarm_handle_work(struct task_struct *task)
+{}
+
+struct pfm_arch_context {
+};
+
+#define PFM_ARCH_CTX_SIZE sizeof(struct pfm_arch_context)
+/*
+ * PowerPC does not need extra alignment requirements for the sampling buffer
+ */
+#define PFM_ARCH_SMPL_ALIGN_SIZE	0
+
+#endif /* CONFIG_PERFMON */
+
+#endif /* __KERNEL__ */
+#endif /* _ASM_POWERPC_PERFMON_KERN_H_ */
Index: linux-next/arch/powerpc/Makefile
===================================================================
--- linux-next.orig/arch/powerpc/Makefile	2008-08-07 11:32:01.000000000 -0400
+++ linux-next/arch/powerpc/Makefile	2008-08-07 11:39:06.000000000 -0400
@@ -147,6 +147,7 @@
 				   arch/powerpc/platforms/
 core-$(CONFIG_MATH_EMULATION)	+= arch/powerpc/math-emu/
 core-$(CONFIG_XMON)		+= arch/powerpc/xmon/
+core-$(CONFIG_PERFMON)		+= arch/powerpc/perfmon/
 core-$(CONFIG_KVM) 		+= arch/powerpc/kvm/
 
 drivers-$(CONFIG_OPROFILE)	+= arch/powerpc/oprofile/
Index: linux-next/arch/powerpc/perfmon/Makefile
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-next/arch/powerpc/perfmon/Makefile	2008-08-07 12:00:08.000000000 -0400
@@ -0,0 +1 @@
+obj-$(CONFIG_PERFMON)		+= perfmon.o
Index: linux-next/include/asm-powerpc/unistd.h
===================================================================
--- linux-next.orig/include/asm-powerpc/unistd.h	2008-08-07 11:32:20.000000000 -0400
+++ linux-next/include/asm-powerpc/unistd.h	2008-08-07 11:39:06.000000000 -0400
@@ -335,10 +335,22 @@
 #define __NR_subpage_prot	310
 #define __NR_timerfd_settime	311
 #define __NR_timerfd_gettime	312
+#define __NR_pfm_create_context	313
+#define __NR_pfm_write_pmcs	314
+#define __NR_pfm_write_pmds	315
+#define __NR_pfm_read_pmds	316
+#define __NR_pfm_load_context	317
+#define __NR_pfm_start		318
+#define __NR_pfm_stop		319
+#define __NR_pfm_reserved_1	320
+#define __NR_pfm_reserved_2	321
+#define __NR_pfm_reserved_3	322
+#define __NR_pfm_reserved_4	323
+#define __NR_pfm_unload_context	324
 
 #ifdef __KERNEL__
 
-#define __NR_syscalls		313
+#define __NR_syscalls		325
 
 #define __NR__exit __NR_exit
 #define NR_syscalls	__NR_syscalls
Index: linux-next/include/asm-powerpc/systbl.h
===================================================================
--- linux-next.orig/include/asm-powerpc/systbl.h	2008-08-07 11:32:20.000000000 -0400
+++ linux-next/include/asm-powerpc/systbl.h	2008-08-07 11:39:06.000000000 -0400
@@ -316,3 +316,15 @@
 SYSCALL(subpage_prot)
 COMPAT_SYS_SPU(timerfd_settime)
 COMPAT_SYS_SPU(timerfd_gettime)
+SYSCALL(pfm_create_context)
+SYSCALL(pfm_write_pmcs)
+SYSCALL(pfm_write_pmds)
+SYSCALL(pfm_read_pmds)
+SYSCALL(pfm_load_context)
+SYSCALL(pfm_start)
+SYSCALL(pfm_stop)
+SYSCALL(pfm_reserved_1)
+SYSCALL(pfm_reserved_2)
+SYSCALL(pfm_reserved_3)
+SYSCALL(pfm_reserved_4)
+SYSCALL(pfm_unload_context)
Index: linux-next/arch/powerpc/kernel/process.c
===================================================================
--- linux-next.orig/arch/powerpc/kernel/process.c	2008-08-07 11:32:01.000000000 -0400
+++ linux-next/arch/powerpc/kernel/process.c	2008-08-07 11:39:06.000000000 -0400
@@ -33,6 +33,7 @@
 #include <linux/mqueue.h>
 #include <linux/hardirq.h>
 #include <linux/utsname.h>
+#include <linux/perfmon_kern.h>
 
 #include <asm/pgtable.h>
 #include <asm/uaccess.h>
@@ -349,6 +350,11 @@
 
 	local_irq_save(flags);
 
+	if (test_tsk_thread_flag(prev, TIF_PERFMON_CTXSW))
+		pfm_ctxsw_out(prev, new);
+	if (test_tsk_thread_flag(new, TIF_PERFMON_CTXSW))
+		pfm_ctxsw_in(prev, new);
+
 	account_system_vtime(current);
 	account_process_vtime(current);
 	calculate_steal_time();
@@ -497,6 +503,7 @@
 void exit_thread(void)
 {
 	discard_lazy_cpu_state();
+	pfm_exit_thread();
 }
 
 void flush_thread(void)
@@ -617,6 +624,7 @@
 #else
 	kregs->nip = (unsigned long)ret_from_fork;
 #endif
+	pfm_copy_thread(p);
 
 	return 0;
 }
Index: linux-next/include/asm-x86/perfmon_kern.h
===================================================================
--- linux-next.orig/include/asm-x86/perfmon_kern.h	2008-08-07 11:35:28.000000000 -0400
+++ linux-next/include/asm-x86/perfmon_kern.h	2008-08-07 11:39:06.000000000 -0400
@@ -398,6 +398,16 @@
 }
 
 /*
+ * pfm_arch_clear_pmd_ovfl_cond - alter the pmds in such a way that they
+ * will not cause cause interrupts when unused.
+ *
+ * This is a nop on x86
+ */
+static inline void pfm_arch_clear_pmd_ovfl_cond(struct pfm_context *ctx,
+					        struct pfm_event_set *set)
+{}
+
+/*
  * functions implemented in arch/x86/perfmon/perfmon.c
  */
 int  pfm_arch_init(void);
Index: linux-next/perfmon/perfmon_ctxsw.c
===================================================================
--- linux-next.orig/perfmon/perfmon_ctxsw.c	2008-08-07 11:35:29.000000000 -0400
+++ linux-next/perfmon/perfmon_ctxsw.c	2008-08-07 11:39:06.000000000 -0400
@@ -65,6 +65,7 @@
 			num--;
 		}
 	}
+	pfm_arch_clear_pmd_ovfl_cond(ctx, set);
 }
 
 /*

--------------020600030808070804000201--

