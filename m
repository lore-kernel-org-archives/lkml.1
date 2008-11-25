Return-Path: <linux-kernel-owner+w=401wt.eu-S1752404AbYKYViD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404AbYKYViD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 16:38:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752806AbYKYVgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 16:36:11 -0500
Received: from gv-out-0910.google.com ([216.239.58.184]:55788 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbYKYVgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 16:36:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:subject:from:date:message-id;
        b=JefK+X4aYmxX4Qz41sfT0Ng0qlhiWfgmZrAv14A7FtK/TUTdjKGIBAOjkhEVF2e2ox
         2Bk1SR+ODU4N1Iqs0Aks6W9IPyCm+2FgBHaQO7Yxz5kDu8To9fRH28gSYghfodpMm4xr
         ZRrPLicTJ1yk+2MP3pdu8pVe4rJyYdBF9Mc1k=
To: linux-kernel@vger.kernel.org
Subject: [patch 04/24] perfmon: interrupt handling
From: eranian@googlemail.com
Date: Tue, 25 Nov 2008 13:36:02 -0800 (PST)
Message-ID: <492c6fc2.02e2660a.1587.42da@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the generic code to handle PMU interrupts.
On interrupt, the handler checks for register overflows, and
if the register is a counter, the 64-bit software maintained
register is updated, i.e., it ensures 64-bit virtualization
of the counters whenever necessary.

Signed-off-by: Stephane Eranian <eranian@gmail.com>
--

Index: o3/perfmon/perfmon_intr.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ o3/perfmon/perfmon_intr.c	2008-11-25 18:57:46.000000000 +0100
@@ -0,0 +1,295 @@
+/*
+ * perfmon_intr.c: perfmon2 interrupt handling
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
+ * 	http://perfmon2.sf.net
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
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/perfmon_kern.h>
+#include "perfmon_priv.h"
+
+/**
+ * pfm_intr_process_64bit_ovfls - handle 64-bit counter emulation
+ * @ctx: context to operate on
+ * @set: set to operate on
+ *
+ * The function returns the number of 64-bit overflows detected.
+ *
+ * 64-bit software pmds are updated for overflowed pmd registers
+ *
+ * In any case, set->npend_ovfls is cleared
+ */
+static u16 pfm_intr_process_64bit_ovfls(struct pfm_context *ctx,
+					struct pfm_event_set *set)
+{
+	u16 i, num_ovfls, max_pmd, max_intr;
+	u16 num_64b_ovfls;
+	u64 old_val, new_val, ovfl_mask;
+
+	num_64b_ovfls = 0;
+
+	ovfl_mask = pfm_pmu_conf->ovfl_mask;
+	max_pmd = ctx->regs.max_pmd;
+	max_intr = ctx->regs.max_intr_pmd;
+
+	num_ovfls = set->npend_ovfls;
+
+	for (i = 0; num_ovfls; i++) {
+		/*
+		 * skip pmd which did not overflow
+		 */
+		if (!pfm_arch_bv_test_bit(i, set->povfl_pmds))
+			continue;
+
+		num_ovfls--;
+
+		/*
+		 * Update software value for counters ONLY
+		 *
+		 * Note that the pmd is not necessarily 0 at this point as
+		 * qualified events may have happened before the PMU was
+		 * frozen. The residual count is not taken into consideration
+		 * here but will be with any read of the pmd
+		 */
+		if (likely(pfm_arch_bv_test_bit(i, ctx->regs.cnt_pmds))) {
+			old_val = new_val = set->pmds[i];
+			new_val += 1 + ovfl_mask;
+			set->pmds[i] = new_val;
+		}  else {
+			/*
+			 * for non counters which interrupt, e.g., AMD IBS,
+			 * we consider this equivalent to a 64-bit counter
+			 * overflow.
+			 */
+			old_val = 1; new_val = 0;
+		}
+
+		/*
+		 * check for 64-bit overflow condition
+		 */
+		if (likely(old_val > new_val)) {
+			num_64b_ovfls++;
+		} else {
+			/*
+			 * on some PMU, it may be necessary to re-arm the PMD
+			 */
+			pfm_arch_ovfl_reset_pmd(ctx, i);
+		}
+
+		PFM_DBG_ovfl("pmd%u ovfl=%s new=0x%llx old=0x%llx "
+			     "hw_pmd=0x%llx",
+			     i,
+			     old_val > new_val ? "64-bit" : "HW",
+			     (unsigned long long)new_val,
+			     (unsigned long long)old_val,
+			     (unsigned long long)pfm_read_pmd(ctx, i));
+	}
+	/*
+	 * mark the overflows as consumed
+	 */
+	set->npend_ovfls = 0;
+	pfm_arch_bv_zero(set->povfl_pmds, max_intr);
+
+	return num_64b_ovfls;
+}
+
+/**
+ * pfm_overflow_handler - main overflow processing routine.
+ * @ctx: context to work on (always current context)
+ * @set: current event set
+ * @ip: interrupt instruction pointer
+ * @regs: machine state
+ */
+static void pfm_overflow_handler(struct pfm_context *ctx,
+				 struct pfm_event_set *set,
+				 unsigned long ip,
+				 struct pt_regs *regs)
+{
+	/*
+	 * skip ZOMBIE case
+	 */
+	if (unlikely(ctx->state == PFM_CTX_ZOMBIE))
+		goto stop_monitoring;
+
+	PFM_DBG_ovfl("intr_pmds=0x%llx npend=%u ip=%p u_pmds=0x%llx",
+		     (unsigned long long)set->povfl_pmds[0],
+		     set->npend_ovfls,
+		     (void *)ip,
+		     (unsigned long long)set->used_pmds[0]);
+
+	/*
+	 * return number of 64-bit overflows
+	 */
+	pfm_intr_process_64bit_ovfls(ctx, set);
+
+	return;
+
+stop_monitoring:
+	/*
+	 * Does not happen for a self-monitored context.
+	 * We cannot attach to kernel-only thread, thus it is safe to
+	 * set TIF bits, i.e., the thread will eventually leave the kernel
+	 * or die and either we will catch the context and clean it up in
+	 * pfm_handler_work() or pfm_exit_thread().
+	 *
+	 * Mask until we get to pfm_handle_work()
+	 * pfm_mask_monitoring(ctx, set);
+	 */
+	PFM_DBG_ovfl("ctx is zombie, converted to spurious");
+	pfm_post_work(current, ctx, PFM_WORK_ZOMBIE);
+}
+
+/**
+ * __pfm_interrupt_handler - 1st level interrupt handler
+ * @ip: interrupted instruction pointer
+ * @regs: machine state
+ *
+ * Function is static because we use a wrapper to easily capture timing infos.
+ *
+ * Context locking necessary to avoid concurrent accesses from other CPUs
+ */
+static void __pfm_interrupt_handler(unsigned long ip, struct pt_regs *regs)
+{
+	struct task_struct *task;
+	struct pfm_context *ctx;
+	struct pfm_event_set *set;
+
+
+	task = __get_cpu_var(pmu_owner);
+	ctx = __get_cpu_var(pmu_ctx);
+
+	/*
+	 * verify if there is a context on this CPU
+	 */
+	if (unlikely(ctx == NULL)) {
+		PFM_DBG_ovfl("no ctx");
+		goto spurious;
+	}
+
+	/*
+	 * we need to lock context because it could be accessed
+	 * from another CPU. Depending on the priority level of
+	 * the PMU interrupt or the arch, it may be necessary to
+	 * mask interrupts alltogether to avoid race condition with
+	 * the timer interrupt in case of time-based set switching,
+	 * for instance.
+	 */
+	spin_lock(&ctx->lock);
+
+	set = ctx->active_set;
+
+	/*
+	 * For SMP per-thread, it is not possible to have
+	 * owner != NULL && task != current.
+	 *
+	 * For UP per-thread, because of lazy save, it
+	 * is possible to receive an interrupt in another task
+	 * which is not using the PMU. This means
+	 * that the interrupt was in-flight at the
+	 * time of pfm_ctxswout_thread(). In that
+	 * case, it will be replayed when the task
+	 * is scheduled again. Hence we convert to spurious.
+	 *
+	 * The basic rule is that an overflow is always
+	 * processed in the context of the task that
+	 * generated it for all per-thread contexts.
+	 */
+#ifndef CONFIG_SMP
+	if (unlikely((task && current->pfm_context != ctx))) {
+		PFM_DBG_ovfl("spurious: not owned by current task");
+		goto spurious;
+	}
+#endif
+	/*
+	 * check that monitoring is active, otherwise convert
+	 * to spurious
+	 */
+	if (unlikely(!pfm_arch_is_active(ctx))) {
+		PFM_DBG_ovfl("spurious: monitoring non active");
+		goto spurious;
+	}
+
+	/*
+	 * freeze PMU and collect overflowed PMD registers
+	 * into set->povfl_pmds. Number of overflowed PMDs
+	 * reported in set->npend_ovfls
+	 */
+	pfm_arch_intr_freeze_pmu(ctx, set);
+
+	/*
+	 * no overflow detected, interrupt may have come
+	 * from the previous thread running on this CPU
+	 */
+	if (unlikely(!set->npend_ovfls)) {
+		PFM_DBG_ovfl("no npend_ovfls");
+		goto spurious;
+	}
+
+	/*
+	 * invoke actual handler
+	 */
+	pfm_overflow_handler(ctx, set, ip, regs);
+
+	/*
+	 * unfreeze PMU
+	 */
+	pfm_arch_intr_unfreeze_pmu(ctx);
+
+	spin_unlock(&ctx->lock);
+
+	return;
+
+spurious:
+	/* ctx may be NULL */
+	pfm_arch_intr_unfreeze_pmu(ctx);
+	if (ctx)
+		spin_unlock(&ctx->lock);
+}
+
+
+/**
+ * pfm_interrupt_handler - 1st level interrupt handler
+ * @ip: interrupt instruction pointer
+ * @regs: machine state
+ *
+ * Function called from the low-level assembly code or arch-specific perfmon
+ * code. Simple wrapper used for timing purpose. Actual work done in
+ * __pfm_overflow_handler()
+ */
+void pfm_interrupt_handler(unsigned long ip, struct pt_regs *regs)
+{
+	BUG_ON(!irqs_disabled());
+	__pfm_interrupt_handler(ip, regs);
+}
Index: o3/include/linux/perfmon_kern.h
===================================================================
--- o3.orig/include/linux/perfmon_kern.h	2008-11-25 18:56:17.000000000 +0100
+++ o3/include/linux/perfmon_kern.h	2008-11-25 18:57:23.000000000 +0100
@@ -188,6 +188,8 @@
 void pfm_ctxsw_out(struct task_struct *prev, struct task_struct *next);
 void __pfm_init_percpu(void *dummy);
 
+void pfm_interrupt_handler(unsigned long ip, struct pt_regs *regs);
+
 static inline void pfm_exit_thread(void)
 {
 	if (current->pfm_context)

-- 

