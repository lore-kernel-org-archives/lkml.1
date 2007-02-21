Return-Path: <linux-kernel-owner+w=401wt.eu-S1945912AbXBUXZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945912AbXBUXZF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 18:25:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423258AbXBUXZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 18:25:05 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:35909 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423248AbXBUXZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 18:25:03 -0500
Subject: Re: [Cbe-oss-dev] [RFC, PATCH 3/4] Add support to OProfile for
	profiling Cell BE SPUs -- update 2
From: Carl Love <cel@us.ibm.com>
To: linuxppc-dev@ozlabs.org, cbe-oss-dev@ozlabs.org,
       oprofile-list@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Wed, 21 Feb 2007 15:25:01 -0800
Message-Id: <1172100301.5233.15.camel@dyn9047021078.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-2) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: Enable SPU switch notification to detect currently active SPU tasks.

From: Maynard Johnson <maynardj@us.ibm.com>, Carl Love <carll@us.ibm.com>

This repost contains the change to move the notify_active flag from ctx->spu to ctx as 
discussed and agreed to by Arnd on 1/30/07.  This patch is dependent on the series of SPU 
patches from Christopher Hellwig.

This patch adds to the capability of spu_switch_event_register so that the
caller is also notified of currently active SPU tasks.  It also exports
spu_switch_event_register and spu_switch_event_unregister.

Signed-off-by: Maynard Johnson <mpjohn@us.ibm.com>
Signed-off-by: Carl Love <carll@us.ibm.com>


Index: linux-2.6.20-be0706.1.20070213/arch/powerpc/platforms/cell/spufs/sched.c
===================================================================
--- linux-2.6.20-be0706.1.20070213.orig/arch/powerpc/platforms/cell/spufs/sched.c	2007-02-19 17:24:40.379148840 -0600
+++ linux-2.6.20-be0706.1.20070213/arch/powerpc/platforms/cell/spufs/sched.c	2007-02-20 08:25:08.077145400 -0600
@@ -137,21 +137,46 @@
 
 static BLOCKING_NOTIFIER_HEAD(spu_switch_notifier);
 
-static void spu_switch_notify(struct spu *spu, struct spu_context *ctx)
+void spu_switch_notify(struct spu *spu, struct spu_context *ctx)
 {
 	blocking_notifier_call_chain(&spu_switch_notifier,
 			    ctx ? ctx->object_id : 0, spu);
 }
 
+static void notify_spus_active(void)
+{
+	int node;
+	/* Wake up the active spu_contexts. When the awakened processes
+	 * see their "notify_active" flag is set, they will call
+	 * spu_switch_notify();
+	 */
+	for (node = 0; node < MAX_NUMNODES; node++) {
+		struct spu *spu;
+		mutex_lock(&spu_prio->active_mutex[node]);
+		list_for_each_entry(spu, &spu_prio->active_list[node], list) {
+			struct spu_context *ctx = spu->ctx;
+			set_bit(SPU_SCHED_NOTIFY_ACTIVE, &ctx->sched_flags);
+			wake_up_all(&ctx->stop_wq);
+		}
+		mutex_unlock(&spu_prio->active_mutex[node]);
+	}
+}
+
 int spu_switch_event_register(struct notifier_block * n)
 {
-	return blocking_notifier_chain_register(&spu_switch_notifier, n);
+	int ret;
+	ret = blocking_notifier_chain_register(&spu_switch_notifier, n);
+	if (!ret)
+		notify_spus_active();
+	return ret;
 }
+EXPORT_SYMBOL_GPL(spu_switch_event_register);
 
 int spu_switch_event_unregister(struct notifier_block * n)
 {
 	return blocking_notifier_chain_unregister(&spu_switch_notifier, n);
 }
+EXPORT_SYMBOL_GPL(spu_switch_event_unregister);
 
 /**
  * spu_bind_context - bind spu context to physical spu
Index: linux-2.6.20-be0706.1.20070213/arch/powerpc/platforms/cell/spufs/spufs.h
===================================================================
--- linux-2.6.20-be0706.1.20070213.orig/arch/powerpc/platforms/cell/spufs/spufs.h	2007-02-15 21:17:21.000000000 -0600
+++ linux-2.6.20-be0706.1.20070213/arch/powerpc/platforms/cell/spufs/spufs.h	2007-02-20 08:21:31.985246936 -0600
@@ -42,6 +42,7 @@
 /* ctx->sched_flags */
 enum {
 	SPU_SCHED_WAKE = 0,
+	SPU_SCHED_NOTIFY_ACTIVE,
 };
 
 struct spu_context {
@@ -220,6 +221,7 @@
 int spu_activate(struct spu_context *ctx, unsigned long flags);
 void spu_deactivate(struct spu_context *ctx);
 void spu_yield(struct spu_context *ctx);
+void spu_switch_notify(struct spu *spu, struct spu_context *ctx);
 void spu_start_tick(struct spu_context *ctx);
 void spu_stop_tick(struct spu_context *ctx);
 void spu_sched_tick(struct work_struct *work);
Index: linux-2.6.20-be0706.1.20070213/arch/powerpc/platforms/cell/spufs/run.c
===================================================================
--- linux-2.6.20-be0706.1.20070213.orig/arch/powerpc/platforms/cell/spufs/run.c	2007-02-15 21:17:20.000000000 -0600
+++ linux-2.6.20-be0706.1.20070213/arch/powerpc/platforms/cell/spufs/run.c	2007-02-20 08:41:08.230217536 -0600
@@ -45,9 +45,11 @@
 	u64 pte_fault;
 
 	*stat = ctx->ops->status_read(ctx);
-	if (ctx->state != SPU_STATE_RUNNABLE)
-		return 1;
+
 	spu = ctx->spu;
+	if (ctx->state != SPU_STATE_RUNNABLE || 
+	    test_bit(SPU_SCHED_NOTIFY_ACTIVE, &ctx->sched_flags))
+		return 1;
 	pte_fault = spu->dsisr &
 	    (MFC_DSISR_PTE_NOT_FOUND | MFC_DSISR_ACCESS_DENIED);
 	return (!(*stat & 0x1) || pte_fault || spu->class_0_pending) ? 1 : 0;
@@ -308,6 +310,7 @@
 		   u32 *npc, u32 *event)
 {
 	int ret;
+	struct spu * spu;
 	u32 status;
 
 	if (down_interruptible(&ctx->run_sema))
@@ -321,8 +324,17 @@
 
 	do {
 		ret = spufs_wait(ctx->stop_wq, spu_stopped(ctx, &status));
+		spu = ctx->spu;
 		if (unlikely(ret))
 			break;
+		if (unlikely(test_bit(SPU_SCHED_NOTIFY_ACTIVE,
+				      &ctx->sched_flags))) {
+			clear_bit(SPU_SCHED_NOTIFY_ACTIVE, &ctx->sched_flags);
+			if (!(status & SPU_STATUS_STOPPED_BY_STOP)) {
+				spu_switch_notify(spu, ctx);
+				continue;
+			}
+		}
 		if ((status & SPU_STATUS_STOPPED_BY_STOP) &&
 		    (status >> SPU_STOP_STATUS_SHIFT == 0x2104)) {
 			ret = spu_process_callback(ctx);


