Return-Path: <linux-kernel-owner+w=401wt.eu-S1755010AbYKZIrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010AbYKZIrU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 03:47:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754031AbYKZImh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 03:42:37 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:25617 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013AbYKZImg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 03:42:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:from:date:message-id;
        b=QZmUQUjeIW9GI66LoeuFHb1syAO+2njbli4hNUT6hQPBAkbx67YdB9h0fO3BxTQNps
         PV0N7KvoVXrS0C4DoXYTcks1bWNnxXaGywYV7g3jzn75jpz7xIlDJpu40ooIYVCoWeZV
         +CrdDwK0uHwxKRKJSoS/VWf4OiqhlTsUehFCc=
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, mingo@elte.hu, x86@kernel.org,
       andi@firstfloor.org, eranian@gmail.com, sfr@canb.auug.org.au
Subject: [patch 14/24] perfmon: attach and detach session
From: eranian@googlemail.com
Date: Wed, 26 Nov 2008 00:42:34 -0800 (PST)
Message-ID: <492d0bfa.1438560a.4e2e.ffffbf94@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the attach and detach functionalities. A perfmon
session can be dynamically attached and detached from a thread.

Signed-off-by: Stephane Eranian <eranian@gmail.com>
--

Index: o3/perfmon/perfmon_attach.c
===================================================================
--- o3.orig/perfmon/perfmon_attach.c	2008-11-25 18:56:15.000000000 +0100
+++ o3/perfmon/perfmon_attach.c	2008-11-25 19:02:41.000000000 +0100
@@ -42,6 +42,257 @@
 #include "perfmon_priv.h"
 
 /**
+ * __pfm_load_ctx_thread - attach context to a thread
+ * @ctx: context to operate on
+ * @task: thread to attach to
+ *
+ * The function must be called with the context locked and interrupts disabled.
+ */
+static int pfm_load_ctx_thread(struct pfm_context *ctx,
+			       struct task_struct *task)
+{
+	struct pfm_event_set *set;
+	struct pfm_context *old;
+	int ret;
+	u16 max;
+
+	PFM_DBG("pid=%d",  task->pid);
+
+	/*
+	 * we must use cmpxchg to avoid race condition with another
+	 * context trying to attach to the same task.
+	 *
+	 * per-thread:
+	 *   - task to attach to is checked in sys_pfm_load_context() to avoid
+	 *     locking issues. if found, and not self,  task refcount was
+	 *     incremented.
+	 */
+	old = cmpxchg(&task->pfm_context, NULL, ctx);
+	if (old) {
+		PFM_DBG("load_pid=%d has a context "
+			"old=%p new=%p cur=%p",
+			task->pid,
+			old,
+			ctx,
+			task->pfm_context);
+		return -EEXIST;
+	}
+
+	/*
+	 * initialize sets
+	 */
+	set = ctx->active_set;
+
+	/*
+	 * cleanup bitvectors
+	 */
+	max = ctx->regs.max_intr_pmd;
+	pfm_arch_bv_zero(set->povfl_pmds, max);
+
+	set->npend_ovfls = 0;
+
+	/*
+	 * we cannot just use plain clear because of arch-specific flags
+	 */
+	set->priv_flags &= ~PFM_SETFL_PRIV_MOD_BOTH;
+
+	/*
+ 	 * link context to task
+ 	 */
+	ctx->task = task;
+
+	/*
+	 * perform any architecture specific actions
+	 */
+	ret = pfm_arch_load_context(ctx);
+	if (ret)
+		goto error_noload;
+
+	/*
+	 * now reserve the session, before we can proceed with
+	 * actually accessing the PMU hardware
+	 */
+	ret = pfm_session_acquire();
+	if (ret)
+		goto error;
+
+
+	if (ctx->task != current) {
+
+		/* not self-monitoring */
+		ctx->flags.is_self = 0;
+
+		/* force a full reload */
+		ctx->last_act = PFM_INVALID_ACTIVATION;
+		ctx->last_cpu = -1;
+		set->priv_flags |= PFM_SETFL_PRIV_MOD_BOTH;
+
+	} else {
+		/*
+ 		 * on UP, we may have to push out the PMU
+ 		 * state of the last monitored thread
+ 		 */
+		pfm_check_save_prev_ctx();
+
+		ctx->last_cpu = smp_processor_id();
+		__get_cpu_var(pmu_activation_number)++;
+		ctx->last_act = __get_cpu_var(pmu_activation_number);
+
+		ctx->flags.is_self = 1;
+
+		/*
+		 * load PMD from set
+		 * load PMC from set
+		 */
+		pfm_arch_restore_pmds(ctx, set);
+		pfm_arch_restore_pmcs(ctx, set);
+
+		/*
+		 * set new ownership
+		 */
+		pfm_set_pmu_owner(ctx->task, ctx);
+	}
+
+	/*
+ 	 * will cause switch_to() to invoke PMU
+ 	 * context switch code
+ 	 */
+	set_tsk_thread_flag(task, TIF_PERFMON_CTXSW);
+
+	ctx->state = PFM_CTX_LOADED;
+
+	return 0;
+
+error:
+	pfm_arch_unload_context(ctx);
+	ctx->task = NULL;
+error_noload:
+	/*
+	 * detach context
+	 */
+	task->pfm_context = NULL;
+	return ret;
+}
+
+/**
+ * __pfm_load_context - attach context to a thread
+ * @ctx: context to operate on
+ * @task: thread to attach to
+ */
+int __pfm_load_context(struct pfm_context *ctx, struct task_struct *task)
+{
+	return pfm_load_ctx_thread(ctx, task);
+}
+
+/**
+ * pfm_update_ovfl_pmds - account for pending ovfls on PMDs
+ * @ctx: context to operate on
+ *
+ * This function is always called after pfm_stop has been issued
+ */
+static void pfm_update_ovfl_pmds(struct pfm_context *ctx)
+{
+	struct pfm_event_set *set;
+	u64 *cnt_pmds;
+	u64 ovfl_mask;
+	u16 num_ovfls, i;
+
+	ovfl_mask = pfm_pmu_conf->ovfl_mask;
+	cnt_pmds = ctx->regs.cnt_pmds;
+	set = ctx->active_set;
+
+	if (!set->npend_ovfls)
+		return;
+
+	num_ovfls = set->npend_ovfls;
+	PFM_DBG("novfls=%u", num_ovfls);
+
+	for (i = 0; num_ovfls; i++) {
+		if (pfm_arch_bv_test_bit(i, set->povfl_pmds)) {
+			/* only correct value for counters */
+			if (pfm_arch_bv_test_bit(i, cnt_pmds))
+				set->pmds[i] += 1 + ovfl_mask;
+			num_ovfls--;
+		}
+		PFM_DBG("pmd%u val=0x%llx",
+			i,
+			(unsigned long long)set->pmds[i]);
+	}
+	/*
+	 * we need to clear to prevent a pfm_getinfo_evtsets() from
+	 * returning stale data even after the context is unloaded
+	 */
+	set->npend_ovfls = 0;
+	pfm_arch_bv_zero(set->povfl_pmds, ctx->regs.max_intr_pmd);
+}
+
+/**
+ * __pfm_unload_context - detach context from CPU or thread
+ * @ctx: context to operate on
+ *
+ * The function must be called with the context locked and interrupts disabled.
+ */
+int __pfm_unload_context(struct pfm_context *ctx)
+{
+	int ret;
+
+	PFM_DBG("ctx_state=%d task [%d]",
+		ctx->state,
+		ctx->task ? ctx->task->pid : -1);
+
+	/*
+	 * check unload-able state
+	 */
+	if (ctx->state == PFM_CTX_UNLOADED)
+		return -EINVAL;
+
+	/*
+	 * stop monitoring
+	 */
+	ret = __pfm_stop(ctx);
+	if (ret)
+		return ret;
+
+	ctx->state = PFM_CTX_UNLOADED;
+
+	/*
+	 * save active set
+	 * UP:
+	 * 	if not current task and due to lazy, state may
+	 * 	still be live
+	 * for system-wide, guaranteed to run on correct CPU
+	 */
+	if (__get_cpu_var(pmu_ctx) == ctx) {
+		/*
+		 * pending overflows have been saved by pfm_stop()
+		 */
+		pfm_save_pmds(ctx);
+		pfm_set_pmu_owner(NULL, NULL);
+		PFM_DBG("released ownership");
+	}
+
+	/*
+	 * account for pending overflows
+	 */
+	pfm_update_ovfl_pmds(ctx);
+
+	/*
+	 * arch-specific unload operations
+	 */
+	pfm_arch_unload_context(ctx);
+
+	/*
+	 * per-thread: disconnect from monitored task
+	 */
+	if (ctx->task) {
+		ctx->task->pfm_context = NULL;
+		clear_tsk_thread_flag(ctx->task, TIF_PERFMON_CTXSW);
+		ctx->task = NULL;
+	}
+	return 0;
+}
+
+/**
  * __pfm_exit_thread - detach and free context on thread exit
  */
 void __pfm_exit_thread(void)
Index: o3/perfmon/perfmon_priv.h
===================================================================
--- o3.orig/perfmon/perfmon_priv.h	2008-11-25 18:59:10.000000000 +0100
+++ o3/perfmon/perfmon_priv.h	2008-11-25 19:02:30.000000000 +0100
@@ -60,6 +60,9 @@
 int __pfm_stop(struct pfm_context *ctx);
 int __pfm_start(struct pfm_context *ctx);
 
+int __pfm_load_context(struct pfm_context *ctx, struct task_struct *task);
+int __pfm_unload_context(struct pfm_context *ctx);
+
 ssize_t pfm_sysfs_res_show(char *buf, size_t sz, int what);
 
 int pfm_pmu_acquire(struct pfm_context *ctx);

-- 

