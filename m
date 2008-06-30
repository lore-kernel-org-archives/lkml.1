Return-Path: <linux-kernel-owner+w=401wt.eu-S1762775AbYF3NRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762775AbYF3NRi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 09:17:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762098AbYF3NOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 09:14:19 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:63631 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757710AbYF3NOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 09:14:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:subject:from:date:message-id;
        b=q7HSyVOqFdfmCqx3l+4YlAIkiCg2YoBH+E1gY+3bdC4bxxJyYUP4kqQZhgKRAj9EYZ
         hXC8sCgUyR6hitjJAU6TxZcBI+tu7h+5IV4KoQJe9VLGTILkqo8uG0dQf7kUWsmeQt5n
         23HCGnMjEissZ2ROvoYjQRUe6ejiEbqMsNXHQ=
To: linux-kernel@vger.kernel.org
Subject: [patch 11/19] perfmon2 minimal v3:  read-write registers
From: eranian@googlemail.com
Date: Mon, 30 Jun 2008 06:14:14 -0700 (PDT)
Message-ID: <4868dc26.0af6660a.61c0.528e@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the functions to read and write PMU data and
config registers.

Signed-off-by: Stephane Eranian <eranian@gmail.com>
--

Index: o/perfmon/perfmon_rw.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ o/perfmon/perfmon_rw.c	2008-06-23 13:13:55.000000000 +0200
@@ -0,0 +1,368 @@
+/*
+ * perfmon.c: perfmon2 PMC/PMD read/write system calls
+ *
+ * This file implements the perfmon2 interface which
+ * provides access to the hardware performance counters
+ * of the host processor.
+ *
+ * The initial version of perfmon.c was written by
+ * Ganesh Venkitachalam, IBM Corp.
+ *
+ * Then it was modified for perfmon-1.x by Stephane Eranian and
+ * David Mosberger, Hewlett Packard Co.
+ *
+ * Version Perfmon-2.x is a complete rewrite of perfmon-1.x
+ * by Stephane Eranian, Hewlett Packard Co.
+ *
+ * Copyright (c) 1999-2006 Hewlett-Packard Development Company, L.P.
+ * Contributed by Stephane Eranian <eranian@hpl.hp.com>
+ *                David Mosberger-Tang <davidm@hpl.hp.com>
+ *
+ * More information about perfmon available at:
+ * 	http://perfmon2.sf.net/
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
+#include <linux/kernel.h>
+#include <linux/perfmon_kern.h>
+#include "perfmon_priv.h"
+
+/**
+ * __pfm_write_pmds - modify data registers
+ * @ctx: context to operate on
+ * @req: pfarg_pmd_t request from user
+ * @count: number of element in the pfarg_pmd_t vector
+ *
+ * The function succeeds whether the context is attached or not.
+ * When attached to another thread, that thread must be stopped.
+ *
+ * The context is locked and interrupts are disabled.
+ */
+int __pfm_write_pmds(struct pfm_context *ctx, struct pfarg_pmd *req, int count)
+{
+	struct pfm_event_set *set;
+	u64 value, ovfl_mask;
+	u64 *impl_pmds;
+	u16 cnum, pmd_type, max_pmd;
+	int i, can_access_pmu;
+	int ret;
+	pfm_pmd_check_t	wr_func;
+
+	ovfl_mask = pfm_pmu_conf->ovfl_mask;
+	max_pmd	= pfm_pmu_conf->regs.max_pmd;
+	impl_pmds = pfm_pmu_conf->regs.pmds;
+	wr_func = pfm_pmu_conf->pmd_write_check;
+
+	can_access_pmu = 0;
+
+	/*
+	 * we cannot access the actual PMD registers when monitoring is masked
+	 */
+	if (unlikely(ctx->state == PFM_CTX_LOADED))
+		can_access_pmu = __get_cpu_var(pmu_owner) == ctx->task;
+
+	ret = -EINVAL;
+	set = ctx->active_set;
+
+	for (i = 0; i < count; i++, req++) {
+
+		cnum = req->reg_num;
+
+		/*
+		 * cannot write to unexisting
+		 * writes to read-only register are ignored
+		 */
+		if (unlikely(cnum >= max_pmd
+			|| !test_bit(cnum, cast_ulp(impl_pmds)))) {
+			PFM_DBG("pmd%u is not available", cnum);
+			goto error;
+		}
+
+		pmd_type = pfm_pmu_conf->pmd_desc[cnum].type;
+
+		/*
+		 * execute write checker, if any
+		 */
+		if (unlikely(wr_func && (pmd_type & PFM_REG_WC))) {
+			ret = (*wr_func)(ctx, set, req);
+			if (ret)
+				goto error;
+
+		}
+
+		value = req->reg_value;
+
+		/*
+		 * we reprogram the PMD hence, we clear any pending
+		 * ovfl. Does affect ovfl switch on restart but new
+		 * value has already been established here
+		 */
+		if (test_bit(cnum, cast_ulp(set->povfl_pmds))) {
+			set->npend_ovfls--;
+			__clear_bit(cnum, cast_ulp(set->povfl_pmds));
+		}
+
+		/*
+		 * set last value to new value for all types of PMD
+		 */
+		set->pmds[cnum].lval = value;
+		/*
+		 * update set values
+		 */
+		set->pmds[cnum].value = value;
+
+		__set_bit(cnum, cast_ulp(set->used_pmds));
+
+		set->priv_flags |= PFM_SETFL_PRIV_MOD_PMDS;
+		if (can_access_pmu)
+			pfm_write_pmd(ctx, cnum, value);
+
+		/*
+		 * update number of used PMD registers
+		 */
+		set->nused_pmds = bitmap_weight(cast_ulp(set->used_pmds),
+						max_pmd);
+
+		PFM_DBG("pmd%u=0x%llx a_pmu=%d "
+			"ctx_pmd=0x%llx "
+			" u_pmds=0x%llx nu_pmds=%u ",
+			cnum,
+			(unsigned long long)value,
+			can_access_pmu,
+			(unsigned long long)set->pmds[cnum].value,
+			(unsigned long long)set->used_pmds[0],
+			set->nused_pmds);
+	}
+	ret = 0;
+error:
+	/*
+	 * make changes visible
+	 */
+	if (can_access_pmu)
+		pfm_arch_serialize();
+
+	return ret;
+}
+
+/**
+ * __pfm_write_pmcs - modify config registers
+ * @ctx: context to operate on
+ * @req: pfarg_pmc_t request from user
+ * @count: number of element in the pfarg_pmc_t vector
+ *
+ *
+ * The function succeeds whether the context is * attached or not.
+ * When attached to another thread, that thread must be stopped.
+ *
+ * The context is locked and interrupts are disabled.
+ */
+int __pfm_write_pmcs(struct pfm_context *ctx, struct pfarg_pmc *req, int count)
+{
+	struct pfm_event_set *set;
+	u64 value, dfl_val, rsvd_msk;
+	u64 *impl_pmcs;
+	int i, can_access_pmu;
+	int ret;
+	u16 cnum, pmc_type, max_pmc;
+	pfm_pmc_check_t	wr_func;
+
+	wr_func = pfm_pmu_conf->pmc_write_check;
+	max_pmc = pfm_pmu_conf->regs.max_pmc;
+	impl_pmcs = pfm_pmu_conf->regs.pmcs;
+
+	can_access_pmu = 0;
+
+	/*
+	 * we cannot access the actual PMC registers when monitoring is masked
+	 */
+	if (unlikely(ctx->state == PFM_CTX_LOADED))
+		can_access_pmu = __get_cpu_var(pmu_owner) == ctx->task;
+
+	ret = -EINVAL;
+	set = ctx->active_set;
+
+	for (i = 0; i < count; i++, req++) {
+
+		cnum = req->reg_num;
+		value = req->reg_value;
+
+		/*
+		 * no access to unavailable PMC register
+		 */
+		if (unlikely(cnum >= max_pmc
+			     || !test_bit(cnum, cast_ulp(impl_pmcs)))) {
+			PFM_DBG("pmc%u is not available", cnum);
+			goto error;
+		}
+
+		pmc_type = pfm_pmu_conf->pmc_desc[cnum].type;
+		dfl_val = pfm_pmu_conf->pmc_desc[cnum].dfl_val;
+		rsvd_msk = pfm_pmu_conf->pmc_desc[cnum].rsvd_msk;
+
+		/*
+		 * set reserved bits to default values
+		 * (reserved bits must be 1 in rsvd_msk)
+		 */
+		value = (value & ~rsvd_msk) | (dfl_val & rsvd_msk);
+
+		/*
+		 * execute write checker, if any
+		 */
+		if (likely(wr_func && (pmc_type & PFM_REG_WC))) {
+			req->reg_value = value;
+			ret = (*wr_func)(ctx, set, req);
+			if (ret)
+				goto error;
+			value = req->reg_value;
+		}
+
+		/*
+		 * Now we commit the changes
+		 */
+
+		/*
+		 * mark PMC register as used
+		 * We do not track associated PMC register based on
+		 * the fact that they will likely need to be written
+		 * in order to become useful at which point the statement
+		 * below will catch that.
+		 *
+		 * The used_pmcs bitmask is only useful on architectures where
+		 * the PMC needs to be modified for particular bits, especially
+		 * on overflow or to stop/start.
+		 */
+		if (!test_bit(cnum, cast_ulp(set->used_pmcs))) {
+			__set_bit(cnum, cast_ulp(set->used_pmcs));
+			set->nused_pmcs++;
+		}
+
+		set->pmcs[cnum] = value;
+
+		set->priv_flags |= PFM_SETFL_PRIV_MOD_PMCS;
+		if (can_access_pmu)
+			pfm_arch_write_pmc(ctx, cnum, value);
+
+		PFM_DBG("pmc%u=0x%llx a_pmu=%d "
+			"u_pmcs=0x%llx nu_pmcs=%u",
+			cnum,
+			(unsigned long long)value,
+			can_access_pmu,
+			(unsigned long long)set->used_pmcs[0],
+			set->nused_pmcs);
+	}
+	ret = 0;
+error:
+	/*
+	 * make sure the changes are visible
+	 */
+	if (can_access_pmu)
+		pfm_arch_serialize();
+
+	return ret;
+}
+
+/**
+ * __pfm_read_pmds - read data registers
+ * @ctx: context to operate on
+ * @req: pfarg_pmd_t request from user
+ * @count: number of element in the pfarg_pmd_t vector
+ *
+ *
+ * The function succeeds whether the context is attached or not.
+ * When attached to another thread, that thread must be stopped.
+ *
+ * The context is locked and interrupts are disabled.
+ */
+int __pfm_read_pmds(struct pfm_context *ctx, struct pfarg_pmd *req, int count)
+{
+	u64 val = 0, lval, ovfl_mask, hw_val;
+	u64 *impl_pmds;
+	struct pfm_event_set *set;
+	int i, ret, can_access_pmu = 0;
+	u16 cnum, pmd_type, max_pmd;
+
+	ovfl_mask = pfm_pmu_conf->ovfl_mask;
+	impl_pmds = pfm_pmu_conf->regs.pmds;
+	max_pmd   = pfm_pmu_conf->regs.max_pmd;
+
+	if (likely(ctx->state == PFM_CTX_LOADED)) {
+		can_access_pmu = __get_cpu_var(pmu_owner) == ctx->task;
+		if (can_access_pmu)
+			pfm_arch_serialize();
+	}
+
+	/*
+	 * on both UP and SMP, we can only read the PMD from the hardware
+	 * register when the task is the owner of the local PMU.
+	 */
+	ret = -EINVAL;
+	set = ctx->active_set;
+	for (i = 0; i < count; i++, req++) {
+
+		cnum = req->reg_num;
+
+		if (unlikely(cnum >= max_pmd
+			     || !test_bit(cnum, cast_ulp(impl_pmds)))) {
+			PFM_DBG("pmd%u is not implemented/unaccessible", cnum);
+			goto error;
+		}
+
+		pmd_type = pfm_pmu_conf->pmd_desc[cnum].type;
+		/*
+		 * it is not possible to read a PMD which was not requested:
+		 * 	- explicitly written via pfm_write_pmds()
+		 * 	- provided as a reg_smpl_pmds[] to another PMD during
+		 * 	  pfm_write_pmds()
+		 *
+		 * This is motivated by security and for optimization purposes:
+		 * 	- on context switch restore, we can restore only what
+		 * 	  we use (except when regs directly readable at user
+		 * 	  level, e.g., IA-64 self-monitoring, I386 RDPMC).
+		 * 	- do not need to maintain PMC -> PMD dependencies
+		 */
+		if (unlikely(!test_bit(cnum, cast_ulp(set->used_pmds)))) {
+			PFM_DBG("pmd%u cannot read, because not used", cnum);
+			goto error;
+		}
+
+		val = set->pmds[cnum].value;
+		lval = set->pmds[cnum].lval;
+
+		/*
+		 * If the task is not the current one, then we check if the
+		 * PMU state is still in the local live register due to lazy
+		 * ctxsw. If true, then we read directly from the registers.
+		 */
+		if (can_access_pmu) {
+			hw_val = pfm_read_pmd(ctx, cnum);
+			if (pmd_type & PFM_REG_C64)
+				val = (val & ~ovfl_mask)
+				    | (hw_val & ovfl_mask);
+			else
+				val = hw_val;
+		}
+
+		PFM_DBG("pmd%u=0x%llx lval=0x%llx",
+			cnum,
+			(unsigned long long)val,
+			(unsigned long long)lval);
+
+		req->reg_value = val;
+	}
+	ret = 0;
+error:
+	return ret;
+}
Index: o/include/linux/perfmon.h
===================================================================
--- o.orig/include/linux/perfmon.h	2008-06-23 13:07:06.000000000 +0200
+++ o/include/linux/perfmon.h	2008-06-23 13:13:55.000000000 +0200
@@ -46,6 +46,30 @@
 #define PFM_PMC_BV	PFM_BVSIZE(PFM_MAX_PMCS)
 
 /*
+ * argument to pfm_write_pmcs() system call.
+ * structure shared with user level
+ */
+struct pfarg_pmc {
+	__u16 reg_num;		/* which register */
+	__u16 reg_reserved0;	/* for future use */
+	__u32 reg_reserved1;	/* for future use */
+	__u64 reg_value;	/* pmc value */
+	__u64 reg_reserved2[4];	/* for future use */
+};
+
+/*
+ * argument to pfm_write_pmds() and pfm_read_pmds() system calls.
+ * structure shared with user level
+ */
+struct pfarg_pmd {
+	__u16 reg_num;	   	/* which register */
+	__u16 reg_reserved0;   	/* for future use */
+	__u32 reg_reserved1; 	/* for future use */
+	__u64 reg_value;	/* initial pmc/pmd value */
+	__u64 reg_reserved2[10+PFM_PMD_BV+PFM_PMC_BV];	/* for future use */
+};
+
+/*
  * default value for the user and group security parameters in
  * /proc/sys/kernel/perfmon/sys_group
  * /proc/sys/kernel/perfmon/task_group
Index: o/perfmon/Makefile
===================================================================
--- o.orig/perfmon/Makefile	2008-06-23 13:13:47.000000000 +0200
+++ o/perfmon/Makefile	2008-06-23 13:14:11.000000000 +0200
@@ -6,4 +6,4 @@
 	perfmon_attach.o perfmon_res.o \
 	perfmon_init.o perfmon_ctxsw.o \
 	perfmon_intr.o perfmon_pmu.o \
-	perfmon_sysfs.o
+	perfmon_sysfs.o perfmon_rw.o
Index: o/perfmon/perfmon_priv.h
===================================================================
--- o.orig/perfmon/perfmon_priv.h	2008-06-23 13:13:31.000000000 +0200
+++ o/perfmon/perfmon_priv.h	2008-06-23 13:13:55.000000000 +0200
@@ -44,6 +44,11 @@
 }
 
 int pfm_init_ctx(void);
+int __pfm_write_pmcs(struct pfm_context *ctx, struct pfarg_pmc *req,
+		     int count);
+int __pfm_write_pmds(struct pfm_context *ctx, struct pfarg_pmd *req,
+		     int count);
+int __pfm_read_pmds(struct pfm_context *ctx, struct pfarg_pmd *req, int count);
 
 int pfm_session_acquire(void);
 void pfm_session_release(void);

-- 

