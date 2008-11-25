Return-Path: <linux-kernel-owner+w=401wt.eu-S1753745AbYKYVhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745AbYKYVhn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 16:37:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752769AbYKYVgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 16:36:09 -0500
Received: from fk-out-0910.google.com ([209.85.128.185]:18210 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbYKYVgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 16:36:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:subject:from:date:message-id;
        b=tJ/HJAKo0WDArveZ1MqTHIgynW/yVTJEoSKSxm5IFrXgxPdIVXCoQ196Idq0Juvmk8
         fN72WOCpeqCdkEXmJFXfqlI71tNIFE7q6YiHiSItP5PiTEyqsnxcgyqwYq4E0MPWYgau
         zRyuoJA3G8l/ofw3sGmTbbptANSj0+pgJ92hA=
To: linux-kernel@vger.kernel.org
Subject: [patch 03/24] perfmon: context switch
From: eranian@googlemail.com
Date: Tue, 25 Nov 2008 13:36:00 -0800 (PST)
Message-ID: <492c6fc0.1d255e0a.1caa.7405@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the support for context switching the PMU
state in per-thread monitoring mode. The code uses a lazy
approach to be more efficient for both UP and SMP kernels.

Note that this patch provides the generic switching
functionality, actual access to the registers is provided
separately for each architecture.

Signed-off-by: Stephane Eranian <eranian@gmail.com>
--

Index: o3/perfmon/perfmon_ctxsw.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ o3/perfmon/perfmon_ctxsw.c	2008-11-25 18:57:07.000000000 +0100
@@ -0,0 +1,252 @@
+/*
+ * perfmon_cxtsw.c: perfmon2 context switch code
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
+ * Contributed by Stephane Eranian <eranian@gmail.com>
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
+#include <linux/perfmon_kern.h>
+#include "perfmon_priv.h"
+
+void pfm_save_pmds(struct pfm_context *ctx)
+{
+	struct pfm_event_set *set;
+	u64 val, ovfl_mask;
+	u64 *used_pmds, *cnt_pmds;
+	u16 i, num;
+
+	set = ctx->active_set;
+	ovfl_mask = pfm_pmu_conf->ovfl_mask;
+	num = set->nused_pmds;
+	cnt_pmds = ctx->regs.cnt_pmds;
+	used_pmds = set->used_pmds;
+
+	/*
+	 * save HW PMD, for counters, reconstruct 64-bit value
+	 */
+	for (i = 0; num; i++) {
+		if (pfm_arch_bv_test_bit(i, used_pmds)) {
+			val = pfm_read_pmd(ctx, i);
+			if (likely(pfm_arch_bv_test_bit(i, cnt_pmds)))
+				val = (set->pmds[i] & ~ovfl_mask) |
+					(val & ovfl_mask);
+			set->pmds[i] = val;
+			num--;
+		}
+	}
+}
+
+/*
+ * interrupts are  disabled (no preemption)
+ */
+void __pfm_ctxswin_thread(struct task_struct *task,
+			  struct pfm_context *ctx)
+{
+	u64 cur_act;
+	struct pfm_event_set *set;
+	int reload_pmcs, reload_pmds;
+	int mycpu, is_active;
+
+	mycpu = smp_processor_id();
+
+	cur_act = __get_cpu_var(pmu_activation_number);
+	/*
+	 * we need to lock context because it could be accessed
+	 * from another CPU. Normally the schedule() functions
+	 * has masked interrupts which should be enough to
+	 * protect against PMU interrupts.
+	 */
+	spin_lock(&ctx->lock);
+
+	is_active = pfm_arch_is_active(ctx);
+
+	set = ctx->active_set;
+
+	/*
+	 * in case fo zombie, we do not complete ctswin of the
+	 * PMU, and we force a call to pfm_handle_work() to finish
+	 * cleanup, i.e., free context + smpl_buff. The reason for
+	 * deferring to pfm_handle_work() is that it is not possible
+	 * to vfree() with interrupts disabled.
+	 */
+	if (unlikely(ctx->state == PFM_CTX_ZOMBIE)) {
+		pfm_post_work(task, ctx, PFM_WORK_ZOMBIE);
+		goto done;
+	}
+
+	/*
+	 * if we were the last user of the PMU on that CPU,
+	 * then nothing to do except restore psr
+	 */
+	if (ctx->last_cpu == mycpu && ctx->last_act == cur_act) {
+		/*
+		 * check for forced reload conditions
+		 */
+		reload_pmcs = set->priv_flags & PFM_SETFL_PRIV_MOD_PMCS;
+		reload_pmds = set->priv_flags & PFM_SETFL_PRIV_MOD_PMDS;
+	} else {
+#ifndef CONFIG_SMP
+		pfm_check_save_prev_ctx();
+#endif
+		reload_pmcs = 1;
+		reload_pmds = 1;
+	}
+	/* consumed */
+	set->priv_flags &= ~PFM_SETFL_PRIV_MOD_BOTH;
+
+	if (reload_pmds)
+		pfm_arch_restore_pmds(ctx, set);
+
+	/*
+	 * need to check if had in-flight interrupt in
+	 * pfm_ctxswout_thread(). If at least one bit set, then we must replay
+	 * the interrupt to avoid losing some important performance data.
+	 *
+	 * npend_ovfls is cleared in interrupt handler
+	 */
+	if (set->npend_ovfls)
+		pfm_arch_resend_irq(ctx);
+
+	if (reload_pmcs)
+		pfm_arch_restore_pmcs(ctx, set);
+
+	/*
+	 * record current activation for this context
+	 */
+	__get_cpu_var(pmu_activation_number)++;
+	ctx->last_cpu = mycpu;
+	ctx->last_act = __get_cpu_var(pmu_activation_number);
+
+	/*
+	 * establish new ownership.
+	 */
+	pfm_set_pmu_owner(task, ctx);
+
+	pfm_arch_ctxswin_thread(task, ctx);
+done:
+	spin_unlock(&ctx->lock);
+}
+
+/*
+ * interrupts are masked, runqueue lock is held.
+ *
+ * In UP. we simply stop monitoring and leave the state
+ * in place, i.e., lazy save
+ */
+void __pfm_ctxswout_thread(struct task_struct *task,
+			   struct pfm_context *ctx)
+{
+	int need_save_pmds, is_active;
+
+	/*
+	 * we need to lock context because it could be accessed
+	 * from another CPU. Normally the schedule() functions
+	 * has masked interrupts which should be enough to
+	 * protect against PMU interrupts.
+	 */
+
+	spin_lock(&ctx->lock);
+
+	is_active = pfm_arch_is_active(ctx);
+
+	/*
+	 * stop monitoring and
+	 * collect pending overflow information
+	 * needed on ctxswin. We cannot afford to lose
+	 * a PMU interrupt.
+	 */
+	need_save_pmds = pfm_arch_ctxswout_thread(task, ctx);
+
+#ifdef CONFIG_SMP
+	/*
+	 * in SMP, release ownership of this PMU.
+	 * PMU interrupts are masked, so nothing
+	 * can happen.
+	 */
+	pfm_set_pmu_owner(NULL, NULL);
+
+	/*
+	 * On some architectures, it is necessary to read the
+	 * PMD registers to check for pending overflow in
+	 * pfm_arch_ctxswout_thread(). In that case, saving of
+	 * the PMDs  may be  done there and not here.
+	 */
+	if (need_save_pmds)
+		pfm_save_pmds(ctx);
+#endif
+	spin_unlock(&ctx->lock);
+}
+
+/**
+ * pfm_ctxsw_out - save PMU state on context switch out
+ * @prev: thread being switched out
+ * @next: thread being switched in
+ *
+ * We pass the next thread as on some platforms it may be necessary to
+ * pass some settings from the current thread to the next
+ *
+ * Interrupts are masked
+ */
+void pfm_ctxsw_out(struct task_struct *prev,
+		   struct task_struct *next)
+{
+	struct pfm_context *ctxp;
+
+	ctxp = prev->pfm_context;
+
+	if (ctxp)
+		__pfm_ctxswout_thread(prev, ctxp);
+}
+
+/**
+ * pfm_ctxsw_in - restore PMU state on context switch in
+ * @prev: thread being switched out
+ * @next: thread being switched in
+ *
+ * We pass the prev thread as on some platforms it may be necessary to
+ * pass some settings from the current thread to the next
+ *
+ * Interrupts are masked
+ */
+void pfm_ctxsw_in(struct task_struct *prev,
+		  struct task_struct *next)
+{
+	struct pfm_context *ctxn;
+
+	ctxn = next->pfm_context;
+
+	if (ctxn)
+		__pfm_ctxswin_thread(next, ctxn);
+
+}
Index: o3/include/linux/perfmon_kern.h
===================================================================
--- o3.orig/include/linux/perfmon_kern.h	2008-11-25 18:54:25.000000000 +0100
+++ o3/include/linux/perfmon_kern.h	2008-11-25 18:56:17.000000000 +0100
@@ -184,6 +184,8 @@
 
 void pfm_handle_work(struct pt_regs *regs);
 void __pfm_exit_thread(void);
+void pfm_ctxsw_in(struct task_struct *prev, struct task_struct *next);
+void pfm_ctxsw_out(struct task_struct *prev, struct task_struct *next);
 void __pfm_init_percpu(void *dummy);
 
 static inline void pfm_exit_thread(void)
@@ -261,5 +263,10 @@
 static inline void pfm_copy_thread(struct task_struct *t)
 {}
 
+static inline void pfm_ctxsw_in(struct task_struct *p, struct task_struct *n)
+{}
+
+static inline void pfm_ctxsw_out(struct task_struct *p, struct task_struct *n)
+{}
 #endif /* CONFIG_PERFMON */
 #endif /* __LINUX_PERFMON_KERN_H__ */

-- 

