Return-Path: <linux-kernel-owner+w=401wt.eu-S1762813AbYF3NUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762813AbYF3NUr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 09:20:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762327AbYF3NOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 09:14:51 -0400
Received: from gv-out-0910.google.com ([216.239.58.190]:57975 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761740AbYF3NOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 09:14:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:subject:from:date:message-id;
        b=yHBZ8gSuwVMaTnSZ6JArwHGFLDcBzKhynlGJZ/s/QoFcllujMtpy/+c5uHDEVuAQGv
         6+rDhDN0QgoGY7y/U0m7BNqBmQ+S6QM1Ps1bc5/wy3HseoDe8jmUkvGQqP4d9AuM3Dz6
         6ukLvj5v3sirM7a1vBE4I2Z1Y/hUB2dgl6n6k=
To: linux-kernel@vger.kernel.org
Subject: [patch 19/19] perfmon2 minimal v3:  AMD64 processor support
From: eranian@googlemail.com
Date: Mon, 30 Jun 2008 06:14:47 -0700 (PDT)
Message-ID: <4868dc47.095c5e0a.13df.ffffdeea@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for AMD64 processors for Family 6, 15, and 16.
Both 32-bit and 64-bit modes are supported.

Signed-off-by: Stephane Eranian <eranian@gmail.com>

--

Index: o/arch/x86/perfmon/perfmon_amd64.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ o/arch/x86/perfmon/perfmon_amd64.c	2008-06-25 16:00:48.000000000 +0200
@@ -0,0 +1,441 @@
+/*
+ * This file contains the PMU description for the Athlon64 and Opteron64
+ * processors. It supports 32 and 64-bit modes.
+ *
+ * Copyright (c) 2005-2007 Hewlett-Packard Development Company, L.P.
+ * Contributed by Stephane Eranian <eranian@hpl.hp.com>
+ *
+ * Copyright (c) 2007 Advanced Micro Devices, Inc.
+ * Contributed by Robert Richter <robert.richter@amd.com>
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
+#include <linux/kprobes.h>
+#include <linux/vmalloc.h>
+#include <linux/topology.h>
+#include <linux/pci.h>
+#include <linux/perfmon_kern.h>
+#include <asm/hw_irq.h>
+#include <asm/apic.h>
+
+static void __kprobes pfm_amd64_quiesce(void);
+static int pfm_amd64_has_ovfls(struct pfm_context *ctx);
+static int pfm_amd64_stop_save(struct pfm_context *ctx,
+			       struct pfm_event_set *set);
+
+static u64 enable_mask[PFM_MAX_PMCS];
+static u16 max_enable;
+
+static struct pfm_arch_pmu_info pfm_amd64_pmu_info = {
+	.stop_save = pfm_amd64_stop_save,
+	.has_ovfls = pfm_amd64_has_ovfls,
+	.quiesce = pfm_amd64_quiesce,
+};
+
+/*
+ * force Local APIC interrupt on overflow
+ */
+#define PFM_K8_VAL	(1ULL<<20)
+#define PFM_K8_NO64	(1ULL<<20)
+
+/*
+ * reserved bits must be 1
+ *
+ * for family 15:
+ * - upper 32 bits are reserved
+ * - bit 20, bit 21
+ *
+ * for family 16:
+ * - bits 36-39 are reserved
+ * - bits 42-63 are reserved
+ * - bit 20, bit 21
+ *
+ */
+#define PFM_K8_RSVD 	((~((1ULL<<32)-1)) | (1ULL<<20) | (1ULL<<21))
+#define PFM_16_RSVD ((0x3fffffULL<<42) | (0xfULL<<36) | (1ULL<<20) | (1ULL<<21))
+
+static struct pfm_regmap_desc pfm_amd64_pmc_desc[] = {
+/* pmc0  */ PMC_D(PFM_REG_I64, "PERFSEL0", PFM_K8_VAL, PFM_K8_RSVD, PFM_K8_NO64, MSR_K7_EVNTSEL0),
+/* pmc1  */ PMC_D(PFM_REG_I64, "PERFSEL1", PFM_K8_VAL, PFM_K8_RSVD, PFM_K8_NO64, MSR_K7_EVNTSEL1),
+/* pmc2  */ PMC_D(PFM_REG_I64, "PERFSEL2", PFM_K8_VAL, PFM_K8_RSVD, PFM_K8_NO64, MSR_K7_EVNTSEL2),
+/* pmc3  */ PMC_D(PFM_REG_I64, "PERFSEL3", PFM_K8_VAL, PFM_K8_RSVD, PFM_K8_NO64, MSR_K7_EVNTSEL3),
+};
+#define PFM_AMD_NUM_PMCS ARRAY_SIZE(pfm_amd64_pmc_desc)
+
+/*
+ * AMD64 counters are 48 bits, upper bits are reserved
+ */
+#define PFM_AMD64_CTR_RSVD	(~((1ULL<<48)-1))
+
+static struct pfm_regmap_desc pfm_amd64_pmd_desc[] = {
+/* pmd0  */ PMD_DR(PFM_REG_C,   "PERFCTR0",	MSR_K7_PERFCTR0, PFM_AMD64_CTR_RSVD),
+/* pmd1  */ PMD_DR(PFM_REG_C,   "PERFCTR1",	MSR_K7_PERFCTR1, PFM_AMD64_CTR_RSVD),
+/* pmd2  */ PMD_DR(PFM_REG_C,   "PERFCTR2",	MSR_K7_PERFCTR2, PFM_AMD64_CTR_RSVD),
+/* pmd3  */ PMD_DR(PFM_REG_C,   "PERFCTR3",	MSR_K7_PERFCTR3, PFM_AMD64_CTR_RSVD),
+};
+#define PFM_AMD_NUM_PMDS ARRAY_SIZE(pfm_amd64_pmd_desc)
+
+static struct pfm_context *pfm_nb_task_owner;
+
+static struct pfm_pmu_config pfm_amd64_pmu_conf;
+
+/*
+ * There can only be one user per socket for the Northbridge (NB) events,
+ * so we enforce mutual exclusion as follows:
+ * 	- per-thread : only one context machine-wide can use NB events
+ *
+ * Exclusion is enforced at:
+ * 	- pfm_load_context()
+ * 	- pfm_write_pmcs() for attached contexts
+ *
+ * Exclusion is released at:
+ * 	- pfm_unload_context() or any calls that implicitely uses it
+ *
+ * return:
+ * 	0  : successfully acquire NB access
+ * 	< 0:  errno, failed to acquire NB access
+ */
+static int pfm_amd64_acquire_nb(struct pfm_context *ctx)
+{
+	struct pfm_context **entry, *old;
+	int proc_id;
+
+#ifdef CONFIG_SMP
+	proc_id = cpu_data(smp_processor_id()).phys_proc_id;
+#else
+	proc_id = 0;
+#endif
+
+	entry = &pfm_nb_task_owner;
+
+	old = cmpxchg(entry, NULL, ctx);
+	if (!old) {
+		PFM_DBG("acquired Northbridge event access globally");
+	} else if (old != ctx) {
+		PFM_DBG("global NorthBridge event conflict");
+		return -EBUSY;
+	}
+	return 0;
+}
+
+/*
+ * invoked from pfm_write_pmcs() when pfm_nb_sys_owners is not NULL,i.e.,
+ * when we have detected a multi-core processor.
+ *
+ * context is locked, interrupts are masked
+ */
+static int pfm_amd64_pmc_write_check(struct pfm_context *ctx,
+			     struct pfm_event_set *set,
+			     struct pfarg_pmc *req)
+{
+	unsigned int event;
+
+	/*
+	 * delay checking NB event until we load the context
+	 */
+	if (ctx->state == PFM_CTX_UNLOADED)
+		return 0;
+
+	/*
+	 * check event is NB event
+	 */
+	event = (unsigned int)(req->reg_value & 0xff);
+	if (event < 0xee)
+		return 0;
+
+	return pfm_amd64_acquire_nb(ctx);
+}
+
+/*
+ * invoked on pfm_load_context().
+ * context is locked, interrupts are masked
+ */
+static int pfm_amd64_load_context(struct pfm_context *ctx)
+{
+	struct pfm_event_set *set;
+	unsigned int i, n;
+
+	set = ctx->active_set;
+	n = set->nused_pmcs;
+	for (i = 0; n; i++) {
+		if (!test_bit(i, cast_ulp(set->used_pmcs)))
+			continue;
+
+		if ((set->pmcs[i] & 0xff) >= 0xee)
+			goto found;
+		n--;
+	}
+	return 0;
+found:
+	return pfm_amd64_acquire_nb(ctx);
+}
+
+/*
+ * invoked on pfm_unload_context()
+ */
+static void pfm_amd64_unload_context(struct pfm_context *ctx)
+{
+	struct pfm_context **entry, *old;
+	int proc_id;
+
+#ifdef CONFIG_SMP
+	proc_id = cpu_data(smp_processor_id()).phys_proc_id;
+#else
+	proc_id = 0;
+#endif
+
+	entry = &pfm_nb_task_owner;
+
+	old = cmpxchg(entry, ctx, NULL);
+	if (old == ctx)
+		PFM_DBG("released NorthBridge events globally");
+}
+
+/*
+ * detect if we need to activate NorthBridge event access control
+ */
+static int pfm_amd64_setup_nb_event_control(void)
+{
+	unsigned int c, n = 0;
+	unsigned int max_phys = 0;
+
+#ifdef CONFIG_SMP
+	for_each_possible_cpu(c) {
+		if (cpu_data(c).phys_proc_id > max_phys)
+			max_phys = cpu_data(c).phys_proc_id;
+	}
+#else
+	max_phys = 0;
+#endif
+	if (max_phys > 255) {
+		PFM_INFO("socket id %d is too big to handle", max_phys);
+		return -ENOMEM;
+	}
+
+	n = max_phys + 1;
+	if (n < 2)
+		return 0;
+
+	pfm_nb_task_owner = NULL;
+
+	/*
+	 * activate write-checker for PMC registers
+	 */
+	for (c = 0; c < PFM_AMD_NUM_PMCS; c++)
+		pfm_amd64_pmc_desc[c].type |= PFM_REG_WC;
+
+	pfm_amd64_pmu_info.load_context = pfm_amd64_load_context;
+	pfm_amd64_pmu_info.unload_context = pfm_amd64_unload_context;
+
+	pfm_amd64_pmu_conf.pmc_write_check = pfm_amd64_pmc_write_check;
+
+	PFM_INFO("NorthBridge event access control enabled");
+
+	return 0;
+}
+
+static void pfm_amd64_setup_registers(void)
+{
+	u16 i;
+
+	__set_bit(0, cast_ulp(enable_mask));
+	__set_bit(1, cast_ulp(enable_mask));
+	__set_bit(2, cast_ulp(enable_mask));
+	__set_bit(3, cast_ulp(enable_mask));
+	max_enable = 3+1;
+
+	/*
+	 * adjust reserved bit fields for family 16
+	 */
+	if (current_cpu_data.x86 == 16) {
+		for (i = 0; i < PFM_AMD_NUM_PMCS; i++)
+			if (pfm_amd64_pmc_desc[i].rsvd_msk == PFM_K8_RSVD)
+				pfm_amd64_pmc_desc[i].rsvd_msk = PFM_16_RSVD;
+	}
+}
+
+static int pfm_amd64_probe_pmu(void)
+{
+	if (current_cpu_data.x86_vendor != X86_VENDOR_AMD)
+		return -1;
+
+	switch (current_cpu_data.x86) {
+	case  6:
+	case 15:
+	case 16:
+		PFM_INFO("found family=%d", current_cpu_data.x86);
+		break;
+	default:
+		PFM_INFO("unsupported family=%d", current_cpu_data.x86);
+		return -1;
+	}
+
+	/*
+	 * check for local APIC (required)
+	 */
+	if (!cpu_has_apic) {
+		PFM_INFO("no local APIC, unsupported");
+		return -1;
+	}
+
+	if (current_cpu_data.x86_max_cores > 1
+	    && pfm_amd64_setup_nb_event_control())
+		return -1;
+
+	pfm_amd64_setup_registers();
+
+	return 0;
+}
+
+/*
+ * detect is counters have overflowed.
+ * return:
+ * 	0 : no overflow
+ * 	1 : at least one overflow
+ */
+static int __kprobes pfm_amd64_has_ovfls(struct pfm_context *ctx)
+{
+	struct pfm_regmap_desc *xrd;
+	u64 *cnt_mask;
+	u64 wmask, val;
+	u16 i, num;
+
+	/*
+	 * Check regular counters
+	 */
+	cnt_mask = pfm_pmu_conf->regs.cnt_pmds;
+	num = pfm_pmu_conf->regs.num_counters;
+	wmask = 1ULL << pfm_pmu_conf->counter_width;
+	xrd = pfm_amd64_pmd_desc;
+
+	for (i = 0; num; i++) {
+		if (test_bit(i, cast_ulp(cnt_mask))) {
+			rdmsrl(xrd[i].hw_addr, val);
+			if (!(val & wmask))
+				return 1;
+			num--;
+		}
+	}
+	return 0;
+}
+
+static int pfm_amd64_stop_save(struct pfm_context *ctx,
+			       struct pfm_event_set *set)
+{
+	struct pfm_arch_pmu_info *pmu_info;
+	u64 used_mask[PFM_PMC_BV];
+	u64 *cnt_pmds;
+	u64 val, wmask, ovfl_mask;
+	u32 i, count;
+
+	pmu_info = pfm_pmu_info();
+
+	wmask = 1ULL << pfm_pmu_conf->counter_width;
+
+	bitmap_and(cast_ulp(used_mask),
+		   cast_ulp(set->used_pmcs),
+		   cast_ulp(enable_mask),
+		   max_enable);
+
+	count = bitmap_weight(cast_ulp(used_mask), max_enable);
+
+	/*
+	 * stop monitoring
+	 * Unfortunately, this is very expensive!
+	 * wrmsrl() is serializing.
+	 */
+	for (i = 0; count; i++) {
+		if (test_bit(i, cast_ulp(used_mask))) {
+			wrmsrl(pfm_pmu_conf->pmc_desc[i].hw_addr, 0);
+			count--;
+		}
+	}
+
+	/*
+	 * if we already having a pending overflow condition, we simply
+	 * return to take care of this first.
+	 */
+	if (set->npend_ovfls)
+		return 1;
+
+	ovfl_mask = pfm_pmu_conf->ovfl_mask;
+	cnt_pmds = pfm_pmu_conf->regs.cnt_pmds;
+
+	/*
+	 * check for pending overflows and save PMDs (combo)
+	 * we employ used_pmds because we also need to save
+	 * and not just check for pending interrupts.
+	 */
+	count = set->nused_pmds;
+	for (i = 0; count; i++) {
+		if (test_bit(i, cast_ulp(set->used_pmds))) {
+			val = pfm_arch_read_pmd(ctx, i);
+			if (likely(test_bit(i, cast_ulp(cnt_pmds)))) {
+				if (!(val & wmask)) {
+					__set_bit(i,cast_ulp(set->povfl_pmds));
+					set->npend_ovfls++;
+				}
+				val = (set->pmds[i].value & ~ovfl_mask)
+				    | (val & ovfl_mask);
+			}
+			set->pmds[i].value = val;
+			count--;
+		}
+	}
+	/* 0 means: no need to save PMDs at upper level */
+	return 0;
+}
+
+/**
+ * pfm_amd64_quiesce_pmu -- stop monitoring without grabbing any lock
+ *
+ * called from NMI interrupt handler to immediately stop monitoring
+ * cannot grab any lock, including perfmon related locks
+ */
+static void __kprobes pfm_amd64_quiesce(void)
+{
+	/*
+	 * quiesce PMU by clearing available registers that have
+	 * the start/stop capability
+	 */
+	if (test_bit(0, cast_ulp(pfm_pmu_conf->regs.pmcs)))
+		wrmsrl(MSR_K7_EVNTSEL0, 0);
+	if (test_bit(1, cast_ulp(pfm_pmu_conf->regs.pmcs)))
+		wrmsrl(MSR_K7_EVNTSEL0+1, 0);
+	if (test_bit(2, cast_ulp(pfm_pmu_conf->regs.pmcs)))
+		wrmsrl(MSR_K7_EVNTSEL0+2, 0);
+	if (test_bit(3, cast_ulp(pfm_pmu_conf->regs.pmcs)))
+		wrmsrl(MSR_K7_EVNTSEL0+3, 0);
+}
+
+static struct pfm_pmu_config pfm_amd64_pmu_conf = {
+	.pmu_name = "AMD64",
+	.counter_width = 47,
+	.pmd_desc = pfm_amd64_pmd_desc,
+	.pmc_desc = pfm_amd64_pmc_desc,
+	.num_pmc_entries = PFM_AMD_NUM_PMCS,
+	.num_pmd_entries = PFM_AMD_NUM_PMDS,
+	.version = "1.2",
+	.pmu_info = &pfm_amd64_pmu_info
+};
+
+static int __init pfm_amd64_pmu_init_module(void)
+{
+	if (pfm_amd64_probe_pmu())
+		return -ENOSYS;
+	return pfm_pmu_register(&pfm_amd64_pmu_conf);
+}
+
+device_initcall(pfm_amd64_pmu_init_module);
Index: o/arch/x86/perfmon/Kconfig
===================================================================
--- o.orig/arch/x86/perfmon/Kconfig	2008-06-23 13:17:29.000000000 +0200
+++ o/arch/x86/perfmon/Kconfig	2008-06-25 15:58:58.000000000 +0200
@@ -22,4 +22,12 @@
 	help
 	Enables support for Intel architectural performance counters.
 	This feature was introduced with Intel Core Solo/Core Duo processors.
+
+config	X86_PERFMON_AMD64
+	bool "Support AMD Athlon/Opteron hardware performance counters"
+	depends on PERFMON
+	default n
+	help
+	Enables support for Athlon/Opterton hardware performance counters.
+	Support for  family 6, 15 and 16 processors.
 endmenu
Index: o/arch/x86/perfmon/Makefile
===================================================================
--- o.orig/arch/x86/perfmon/Makefile	2008-06-23 13:17:29.000000000 +0200
+++ o/arch/x86/perfmon/Makefile	2008-06-25 15:58:58.000000000 +0200
@@ -4,3 +4,4 @@
 #
 obj-$(CONFIG_PERFMON)			+= perfmon.o
 obj-$(CONFIG_X86_PERFMON_INTEL_ARCH)	+= perfmon_intel_arch.o
+obj-$(CONFIG_X86_PERFMON_AMD64)   	+= perfmon_amd64.o

-- 

