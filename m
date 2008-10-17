Return-Path: <linux-kernel-owner+w=401wt.eu-S1756214AbYJQPKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214AbYJQPKU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 11:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755934AbYJQPFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 11:05:49 -0400
Received: from gv-out-0910.google.com ([216.239.58.184]:55326 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755629AbYJQPFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 11:05:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:subject:from:date:message-id;
        b=S+Lqdcmd3WBbTEhZ4zFk2STcuLIn03hblUhtOQHcQ70eyh4u3X8hwcBtkSmBMRGi7h
         2vSWc8YRjDAdvIsQ6WcC/WfH3ntUgYOkbHoAGE0fI5pHQodRjdCXY7KQinv0napVuxz6
         F0sLA+HMMprAf7SN9eSiG/NMZ1I50+cauAyho=
To: linux-kernel@vger.kernel.org
Subject: [patch 14/24] perfmon3:  attach and detach session
From: eranian@googlemail.com
Date: Fri, 17 Oct 2008 08:05:45 -0700 (PDT)
Message-ID: <48f8a9c9.0af5660a.44c2.2646@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the attach and detach functionalities. A perfmon
session can be dynamically attached and detached from a thread.

Signed-off-by: Stephane Eranian <eranian@gmail.com>
--

Index: o3/perfmon/perfmon_attach.c
===================================================================
--- o3.orig/perfmon/perfmon_attach.c	2008-10-15 15:53:09.000000000 +0200
+++ o3/perfmon/perfmon_attach.c	2008-10-16 09:30:05.000000000 +0200
@@ -42,6 +42,258 @@
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
+	bitmap_zero(cast_ulp(set->povfl_pmds), max);
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
+		if (test_bit(i, cast_ulp(set->povfl_pmds))) {
+			/* only correct value for counters */
+			if (test_bit(i, cast_ulp(cnt_pmds)))
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
+	bitmap_zero(cast_ulp(set->povfl_pmds),
+		    ctx->regs.max_intr_pmd);
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
--- o3.orig/perfmon/perfmon_priv.h	2008-10-15 15:53:37.000000000 +0200
+++ o3/perfmon/perfmon_priv.h	2008-10-16 12:14:40.000000000 +0200
@@ -60,6 +60,9 @@
 int __pfm_stop(struct pfm_context *ctx);
 int __pfm_start(struct pfm_context *ctx);
 
+int __pfm_load_context(struct pfm_context *ctx, struct task_struct *task);
+int __pfm_unload_context(struct pfm_context *ctx);
+
 ssize_t pfm_sysfs_res_show(char *buf, size_t sz, int what);
 
 int pfm_pmu_acquire(struct pfm_context *ctx);

-- 

