Return-Path: <linux-kernel-owner+w=401wt.eu-S1756990AbYHGVP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756990AbYHGVP6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 17:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752528AbYHGVPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 17:15:16 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:56812 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344AbYHGVPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 17:15:12 -0400
Message-ID: <489B65E0.4040907@us.ibm.com>
Date: Thu, 07 Aug 2008 14:15:12 -0700
From: Corey Ashford <cjashfor@us.ibm.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] add POWER6 support to the perfmon2 minmal v3
Content-Type: multipart/mixed;
 boundary="------------060804090705070602020507"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060804090705070602020507
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This patch adds POWER6-specific support to the perfmon2 minimal v3 patch 
set posted to the mailing list by Stephane Eranian on 06/30/2008.

Thanks for your consideration,

- Corey

-- 
Corey Ashford
Software Engineer
IBM Linux Technology Center, Linux Toolchain
Beaverton, OR
503-578-3507
cjashfor@us.ibm.com

--------------060804090705070602020507
Content-Type: text/plain;
 name="perfmon-ppc64-power6.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="perfmon-ppc64-power6.diff"

This patch adds perfmon2 support for the POWER6 chip.

Two of the event counters (PMC5 and PMC6) on the POWER6 count fixed events,
are not gateable and do not generate interrupts upon overflow.  In order
that these counters be usable as per-thread 64-bit counters, they must be
periodically sampled at a rate faster than they could possibly overflow.  So
there is logic in this code to set up the necessary timer and process the
counters.


Signed-off-by: Corey Ashford <cjashfor@us.ibm.com>
--

Index: linux-next/arch/powerpc/perfmon/perfmon_power6.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-next/arch/powerpc/perfmon/perfmon_power6.c	2008-08-07 11:39:45.000000000 -0400
@@ -0,0 +1,446 @@
+/*
+ * This file contains the POWER6 PMU register description tables
+ * and pmc checker used by perfmon.c.
+ *
+ * Copyright (c) 2007, IBM Corporation
+ *
+ * Based on perfmon_power5.c, and written by Carl Love <carll@us.ibm.com>
+ * and Kevin Corry <kevcorry@us.ibm.com>.  Some fixes and refinement by
+ * Corey Ashford <cjashfor@us.ibm.com>
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
+#include <linux/perfmon_kern.h>
+
+MODULE_AUTHOR("Corey Ashford <cjashfor@us.ibm.com>");
+MODULE_DESCRIPTION("POWER6 PMU description table");
+MODULE_LICENSE("GPL");
+
+static struct pfm_regmap_desc pfm_power6_pmc_desc[] = {
+/* mmcr0 */ PMC_D(PFM_REG_I, "MMCR0", MMCR0_FC, 0, 0, SPRN_MMCR0),
+/* mmcr1 */ PMC_D(PFM_REG_I, "MMCR1", 0, 0, 0, SPRN_MMCR1),
+/* mmcra */ PMC_D(PFM_REG_I, "MMCRA", 0, 0, 0, SPRN_MMCRA)
+};
+#define PFM_PM_NUM_PMCS	ARRAY_SIZE(pfm_power6_pmc_desc)
+#define PFM_DELTA_TB    10000   /* Not a real registers */
+#define PFM_DELTA_PURR  10001
+
+/*
+ * counters wrap to zero at transition from 2^32-1 to 2^32.  Note:
+ * interrupt generated at transition from 2^31-1 to 2^31
+ */
+#define OVERFLOW_VALUE    0x100000000UL
+
+/* The TB and PURR registers are read-only. Also, note that the TB register
+ * actually consists of both the 32-bit SPRN_TBRU and SPRN_TBRL registers.
+ * For Perfmon2's purposes, we'll treat it as a single 64-bit register.
+ */
+static struct pfm_regmap_desc pfm_power6_pmd_desc[] = {
+	/* On POWER 6 PMC5 and PMC6 are not writable, they do not
+	 * generate interrupts, and do not qualify their counts
+	 * based on problem mode, supervisor mode or hypervisor mode.
+	 * These two counters are implemented as virtual counters
+	 * to make the appear to work like the other counters.  A
+	 * kernel timer is used sample the real PMC5 and PMC6 and
+	 * update the virtual counters.
+	 */
+/* tb    */ PMD_D((PFM_REG_I|PFM_REG_RO), "TB", SPRN_TBRL),
+/* pmd1  */ PMD_D(PFM_REG_C, "PMC1", SPRN_PMC1),
+/* pmd2  */ PMD_D(PFM_REG_C, "PMC2", SPRN_PMC2),
+/* pmd3  */ PMD_D(PFM_REG_C, "PMC3", SPRN_PMC3),
+/* pmd4  */ PMD_D(PFM_REG_C, "PMC4", SPRN_PMC4),
+/* pmd5  */ PMD_D((PFM_REG_I), "PMC5", SPRN_PMC5),
+/* pmd6  */ PMD_D((PFM_REG_I), "PMC6", SPRN_PMC6),
+/* purr  */ PMD_D((PFM_REG_I|PFM_REG_RO), "PURR", SPRN_PURR),
+/* delta purr */ PMD_D((PFM_REG_I), "DELTA_TB", PFM_DELTA_TB),
+/* delta tb   */ PMD_D((PFM_REG_I), "DELTA_PURR", PFM_DELTA_PURR),
+};
+
+#define PFM_PM_NUM_PMDS	ARRAY_SIZE(pfm_power6_pmd_desc)
+
+u32 pmc5_start_save[NR_CPUS];
+u32 pmc6_start_save[NR_CPUS];
+struct timer_list pmc5_6_update[NR_CPUS];
+
+u64 enable_cntrs_cnt;
+u64 disable_cntrs_cnt;
+u64 call_delta;
+u64 pm5_6_interrupt;
+u64 pm1_4_interrupt;
+/* need ctx_arch for kernel timer.  Can't get it in context of the kernel
+ * timer.
+ */
+struct pfm_arch_context *pmc5_6_ctx_arch[NR_CPUS];
+long int update_time;
+
+static void delta(int cpu_num, struct pfm_arch_context *ctx_arch)
+{
+	u32 tmp5, tmp6;
+
+	call_delta++;
+
+	tmp5 = (u32) mfspr(SPRN_PMC5);
+	tmp6 = (u32) mfspr(SPRN_PMC6);
+
+	/*
+	 * The following difference calculation relies on 32-bit modular
+	 * arithmetic for the deltas to come out correct (especially in the
+	 * presence of a 32-bit counter wrap).
+	 */
+	ctx_arch->powergs_pmc5 += (u64)(tmp5 - pmc5_start_save[cpu_num]);
+	ctx_arch->powergs_pmc6 += (u64)(tmp6 - pmc6_start_save[cpu_num]);
+
+	pmc5_start_save[cpu_num] = tmp5;
+	pmc6_start_save[cpu_num] = tmp6;
+
+	return;
+}
+
+
+static void pmc5_6_updater(unsigned long cpu_num)
+{
+	/* update the virtual pmd 5 and pmd 6 counters */
+
+	delta(cpu_num, pmc5_6_ctx_arch[cpu_num]);
+	mod_timer(&pmc5_6_update[cpu_num], jiffies + update_time);
+}
+
+
+static void pfm_power6_write_pmc(unsigned int cnum, u64 value)
+{
+	switch (pfm_pmu_conf->pmc_desc[cnum].hw_addr) {
+	case SPRN_MMCR0:
+		mtspr(SPRN_MMCR0, value);
+		break;
+	case SPRN_MMCR1:
+		mtspr(SPRN_MMCR1, value);
+		break;
+	case SPRN_MMCRA:
+		mtspr(SPRN_MMCRA, value);
+		break;
+	default:
+		BUG();
+	}
+}
+
+static void pfm_power6_write_pmd(struct pfm_context *ctx,
+				 unsigned int cnum,
+				 u64 value)
+{
+	struct pfm_arch_context *ctx_arch = pfm_ctx_arch(ctx);
+	int cpu_num = smp_processor_id();
+	u64 ovfl_mask = pfm_pmu_conf->ovfl_mask;
+
+	/* Mask off the overflow bit (and all others above it) before writing to the
+           HW PMC register */
+	switch (pfm_pmu_conf->pmd_desc[cnum].hw_addr) {
+	case SPRN_PMC1:
+		mtspr(SPRN_PMC1, value & ovfl_mask);
+		break;
+	case SPRN_PMC2:
+		mtspr(SPRN_PMC2, value & ovfl_mask);
+		break;
+	case SPRN_PMC3:
+		mtspr(SPRN_PMC3, value & ovfl_mask);
+		break;
+	case SPRN_PMC4:
+		mtspr(SPRN_PMC4, value & ovfl_mask);
+		break;
+	case SPRN_PMC5:
+		pmc5_start_save[cpu_num] = mfspr(SPRN_PMC5);
+		ctx_arch->powergs_pmc5 = value;
+		break;
+	case SPRN_PMC6:
+		pmc6_start_save[cpu_num] = mfspr(SPRN_PMC6);
+		ctx_arch->powergs_pmc6 = value;
+		break;
+	case PFM_DELTA_TB:
+		ctx_arch->delta_tb_start =
+			(((u64)mfspr(SPRN_TBRU) << 32) | mfspr(SPRN_TBRL));
+		ctx_arch->delta_tb = value;
+		break;
+	case PFM_DELTA_PURR:
+		ctx_arch->delta_purr_start = mfspr(SPRN_PURR);
+		ctx_arch->delta_purr = value;
+	case SPRN_TBRL:
+	case SPRN_PURR:
+		/* Ignore writes to read-only registers. */
+		break;
+	default:
+		BUG();
+	}
+}
+
+
+static u64 pfm_power6_read_pmd(struct pfm_context *ctx, unsigned int cnum)
+{
+	struct pfm_arch_context *ctx_arch = pfm_ctx_arch(ctx);
+	int cpu_num = smp_processor_id();
+	u64 temp;
+
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
+		return ctx_arch->powergs_pmc5 + (u64)((u32)mfspr(SPRN_PMC5) - pmc5_start_save[cpu_num]);
+	case SPRN_PMC6:
+		return ctx_arch->powergs_pmc6 + (u64)((u32)mfspr(SPRN_PMC6) - pmc6_start_save[cpu_num]);
+	case PFM_DELTA_TB:
+		return ctx_arch->delta_tb
+			+ (((u64)mfspr(SPRN_TBRU) << 32) | mfspr(SPRN_TBRL))
+			- ctx_arch->delta_tb_start;
+	case PFM_DELTA_PURR:
+		return ctx_arch->delta_purr
+			+ mfspr(SPRN_PURR)
+			- ctx_arch->delta_purr_start;
+	case SPRN_TBRL:
+		return ((u64)mfspr(SPRN_TBRU) << 32) | mfspr(SPRN_TBRL);
+	case SPRN_PURR:
+		if (cpu_has_feature(CPU_FTR_PURR))
+			return mfspr(SPRN_PURR);
+		else
+			return 0;
+	default:
+		BUG();
+	}
+}
+
+/**
+ * pfm_power6_enable_counters
+ *
+ **/
+static void pfm_power6_enable_counters(struct pfm_context *ctx,
+				       struct pfm_event_set *set)
+{
+
+	unsigned int i, max_pmc;
+	int cpu_num = smp_processor_id();
+	struct pfm_arch_context *ctx_arch;
+
+	enable_cntrs_cnt++;
+
+	/* need the ctx passed down to the routine */
+	ctx_arch = pfm_ctx_arch(ctx);
+	max_pmc = pfm_pmu_conf->regs.max_pmc;
+
+	/* Write MMCR0 last, and a fairly easy way to do this is to write
+	   the registers in the reverse order */
+	for (i = max_pmc; i != 0; i--)
+		if (test_bit(i - 1, set->used_pmcs))
+			pfm_power6_write_pmc(i - 1, set->pmcs[i - 1]);
+
+	/* save current free running HW event count */
+	pmc5_start_save[cpu_num] = mfspr(SPRN_PMC5);
+	pmc6_start_save[cpu_num] = mfspr(SPRN_PMC6);
+
+	ctx_arch->delta_purr_start = mfspr(SPRN_PURR);
+
+	if (cpu_has_feature(CPU_FTR_PURR))
+		ctx_arch->delta_tb_start =
+			((u64)mfspr(SPRN_TBRU) << 32) | mfspr(SPRN_TBRL);
+	else
+		ctx_arch->delta_tb_start = 0;
+
+	/* Start kernel timer for this cpu to periodically update
+	 * the virtual counters.
+	 */
+	init_timer(&pmc5_6_update[cpu_num]);
+	pmc5_6_update[cpu_num].function = pmc5_6_updater;
+	pmc5_6_update[cpu_num].data = (unsigned long) cpu_num;
+	pmc5_6_update[cpu_num].expires = jiffies + update_time;
+	pmc5_6_ctx_arch[cpu_num] = ctx_arch;
+	add_timer(&pmc5_6_update[cpu_num]);
+}
+
+/**
+ * pfm_power6_disable_counters
+ *
+ **/
+static void pfm_power6_disable_counters(struct pfm_context *ctx,
+					struct pfm_event_set *set)
+{
+	struct pfm_arch_context *ctx_arch;
+	int cpu_num = smp_processor_id();
+
+	disable_cntrs_cnt++;
+
+	/* Set the Freeze Counters bit */
+	mtspr(SPRN_MMCR0, mfspr(SPRN_MMCR0) | MMCR0_FC);
+	asm volatile ("sync");
+
+	/* delete kernel update timer */
+	del_timer_sync(&pmc5_6_update[cpu_num]);
+
+	/* Update the virtual pmd 5 and 6 counters from the free running
+	 * HW counters
+	 */
+	ctx_arch = pfm_ctx_arch(ctx);
+	delta(cpu_num, ctx_arch);
+
+	ctx_arch->delta_tb +=
+		(((u64)mfspr(SPRN_TBRU) << 32) | mfspr(SPRN_TBRL))
+		- ctx_arch->delta_tb_start;
+
+	ctx_arch->delta_purr += mfspr(SPRN_PURR)
+		- ctx_arch->delta_purr_start;
+}
+
+/**
+ * pfm_power6_get_ovfl_pmds
+ *
+ * Determine which counters in this set have overflowed and fill in the
+ * set->povfl_pmds mask and set->npend_ovfls count.
+ **/
+static void pfm_power6_get_ovfl_pmds(struct pfm_context *ctx,
+				     struct pfm_event_set *set)
+{
+	unsigned int i;
+	unsigned int max_intr_pmd = pfm_pmu_conf->regs.max_intr_pmd;
+	u64 *used_pmds = set->used_pmds;
+	u64 *cntr_pmds = pfm_pmu_conf->regs.cnt_pmds;
+	u64 width_mask = 1 << pfm_pmu_conf->counter_width;
+	u64 new_val, mask[PFM_PMD_BV];
+
+	bitmap_and(cast_ulp(mask), cast_ulp(cntr_pmds), cast_ulp(used_pmds), max_intr_pmd);
+
+	/* max_intr_pmd is actually the last interrupting pmd register + 1 */
+	for (i = 0; i < max_intr_pmd; i++) {
+		if (test_bit(i, mask)) {
+			new_val = pfm_power6_read_pmd(ctx, i);
+			if (new_val & width_mask) {
+				set_bit(i, set->povfl_pmds);
+				set->npend_ovfls++;
+			}
+		}
+	}
+}
+
+static void pfm_power6_irq_handler(struct pt_regs *regs,
+				   struct pfm_context *ctx)
+{
+	u32 mmcr0;
+	u64 mmcra;
+
+	/* Disable the counters (set the freeze bit) to not polute
+	 * the counts.
+	 */
+	mmcr0 = mfspr(SPRN_MMCR0);
+	mtspr(SPRN_MMCR0, (mmcr0 | MMCR0_FC));
+	mmcra = mfspr(SPRN_MMCRA);
+
+	/* Set the PMM bit (see comment below). */
+	mtmsrd(mfmsr() | MSR_PMM);
+
+	pm1_4_interrupt++;
+
+	pfm_interrupt_handler(instruction_pointer(regs), regs);
+
+	mmcr0 = mfspr(SPRN_MMCR0);
+	/* Reset the perfmon trigger. */
+	mmcr0 |= MMCR0_PMXE;
+
+	/*
+	 * We must clear the PMAO bit on some (GQ) chips. Just do it
+	 * all the time.
+	 */
+	mmcr0 &= ~MMCR0_PMAO;
+
+	/* Clear the appropriate bits in the MMCRA. */
+	mmcra &= ~(POWER6_MMCRA_THRM | POWER6_MMCRA_OTHER);
+	mtspr(SPRN_MMCRA, mmcra);
+
+	/*
+	 * Now clear the freeze bit, counting will not start until we
+	 * rfid from this exception, because only at that point will
+	 * the PMM bit be cleared.
+	 */
+	mmcr0 &= ~MMCR0_FC;
+	mtspr(SPRN_MMCR0, mmcr0);
+}
+
+static void pfm_power6_resend_irq(struct pfm_context *ctx)
+{
+	/*
+	 * Ensure that PMU exceptions are enabled, and set PMAO which will
+	 * cause a PMU exception immediately when MSR_EE is set.
+	 */
+	mtspr(SPRN_MMCR0, mfspr(SPRN_MMCR0) | (MMCR0_PMXE | MMCR0_PMAO));
+}
+
+struct pfm_arch_pmu_info pfm_power6_pmu_info = {
+	.pmu_style        = PFM_POWERPC_PMU_POWER6,
+	.write_pmc        = pfm_power6_write_pmc,
+	.write_pmd        = pfm_power6_write_pmd,
+	.read_pmd         = pfm_power6_read_pmd,
+	.irq_handler      = pfm_power6_irq_handler,
+	.get_ovfl_pmds    = pfm_power6_get_ovfl_pmds,
+	.enable_counters  = pfm_power6_enable_counters,
+	.disable_counters = pfm_power6_disable_counters,
+	.resend_irq       = pfm_power6_resend_irq
+};
+
+/*
+ * impl_pmcs, impl_pmds are computed at runtime to minimize errors!
+ */
+static struct pfm_pmu_config pfm_power6_pmu_conf = {
+	.pmu_name = "POWER6",
+	.counter_width = 31,
+	.pmd_desc = pfm_power6_pmd_desc,
+	.pmc_desc = pfm_power6_pmc_desc,
+	.num_pmc_entries = PFM_PM_NUM_PMCS,
+	.num_pmd_entries = PFM_PM_NUM_PMDS,
+	.version = "1.0",
+	.pmu_info = &pfm_power6_pmu_info,
+};
+
+static int __init pfm_power6_pmu_init_module(void)
+{
+	int ret;
+	disable_cntrs_cnt = 0;
+	enable_cntrs_cnt = 0;
+	call_delta = 0;
+	pm5_6_interrupt = 0;
+	pm1_4_interrupt = 0;
+
+	/* calculate the time for updating counters 5 and 6 */
+
+	/*
+	 * MAX_EVENT_RATE assumes a max instruction issue rate of 2
+	 * instructions per clock cycle.  Experience shows that this factor
+	 * of 2 is more than adequate.
+	 */
+
+# define MAX_EVENT_RATE (ppc_proc_freq * 2)
+
+	/*
+	 * Calculate the time, in jiffies, it takes for event counter 5 or
+	 * 6 to completely wrap when counting at the max event rate, and
+	 * then figure on sampling at twice that rate.
+	 */
+	update_time = (((unsigned long)HZ * OVERFLOW_VALUE)
+		       / ((unsigned long)MAX_EVENT_RATE)) / 2;
+
+	ret =  pfm_pmu_register(&pfm_power6_pmu_conf);
+	return ret;
+}
+
+device_initcall(pfm_power6_pmu_init_module);
Index: linux-next/include/asm-powerpc/reg.h
===================================================================
--- linux-next.orig/include/asm-powerpc/reg.h	2008-08-07 11:32:17.000000000 -0400
+++ linux-next/include/asm-powerpc/reg.h	2008-08-07 11:39:45.000000000 -0400
@@ -692,6 +692,7 @@
 #define PV_POWER5	0x003A
 #define PV_POWER5p	0x003B
 #define PV_970FX	0x003C
+#define PV_POWER6	0x003E
 #define PV_630		0x0040
 #define PV_630p	0x0041
 #define PV_970MP	0x0044
Index: linux-next/arch/powerpc/perfmon/Kconfig
===================================================================
--- linux-next.orig/arch/powerpc/perfmon/Kconfig	2008-08-07 11:39:06.000000000 -0400
+++ linux-next/arch/powerpc/perfmon/Kconfig	2008-08-07 11:39:45.000000000 -0400
@@ -23,4 +23,11 @@
 	debugfs. This is used for debugging and performance analysis of the
 	subsystem. The debugfs filesystem must be mounted.
 
+config PERFMON_POWER6
+	bool "Support for Power6 hardware performance counters"
+	depends on PERFMON && PPC64
+	default n
+	help
+	Enables support for the Power 6 hardware performance counters
+
 endmenu
Index: linux-next/arch/powerpc/perfmon/Makefile
===================================================================
--- linux-next.orig/arch/powerpc/perfmon/Makefile	2008-08-07 11:39:06.000000000 -0400
+++ linux-next/arch/powerpc/perfmon/Makefile	2008-08-07 11:39:45.000000000 -0400
@@ -1 +1,2 @@
 obj-$(CONFIG_PERFMON)		+= perfmon.o
+obj-$(CONFIG_PERFMON_POWER6)	+= perfmon_power6.o
Index: linux-next/include/asm-powerpc/perfmon_kern.h
===================================================================
--- linux-next.orig/include/asm-powerpc/perfmon_kern.h	2008-08-07 11:39:06.000000000 -0400
+++ linux-next/include/asm-powerpc/perfmon_kern.h	2008-08-07 11:39:45.000000000 -0400
@@ -32,7 +32,8 @@
 #include <asm/pmc.h>
 
 enum powerpc_pmu_type {
-	PFM_POWERPC_PMU_NONE
+	PFM_POWERPC_PMU_NONE,
+	PFM_POWERPC_PMU_POWER6
 };
 
 struct pfm_arch_pmu_info {
@@ -300,6 +301,9 @@
 {}
 
 struct pfm_arch_context {
+	u64 powergs_pmc5, powergs_pmc6;
+	u64 delta_tb, delta_tb_start;
+	u64 delta_purr, delta_purr_start;
 };
 
 #define PFM_ARCH_CTX_SIZE sizeof(struct pfm_arch_context)

--------------060804090705070602020507--

