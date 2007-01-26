Return-Path: <linux-kernel-owner+w=401wt.eu-S1751666AbXAZWjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751666AbXAZWjS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 17:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752136AbXAZWjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 17:39:18 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:56225 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbXAZWjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 17:39:16 -0500
Message-ID: <45BA8310.6020809@us.ibm.com>
Date: Fri, 26 Jan 2007 16:39:12 -0600
From: Maynard Johnson <maynardj@us.ibm.com>
Reply-To: maynardj@us.ibm.com
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.7.3) Gecko/20040910
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Maynard Johnson <maynardj@us.ibm.com>
CC: Christoph Hellwig <hch@lst.de>, cbe-oss-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Arnd Bergmann <arnd.bergmann@de.ibm.com>
Subject: Re: [Cbe-oss-dev] [PATCH] Cell SPU task notification - repost of
 patch with updates
References: <45A805A0.2080000@us.ibm.com> <20070117003018.GA17955@lst.de> <45AE471C.8040909@us.ibm.com>
In-Reply-To: <45AE471C.8040909@us.ibm.com>
Content-Type: multipart/mixed;
 boundary="------------010206080901080700090209"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010206080901080700090209
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

This patch makes all the changes suggested by Christopher, with the 
exception of the suggestion to use the sched_flags field versus a new 
member to the spu_context struct to signal the need to "notify already 
active".  I don't have the sched_flags change in my 2.6.20-rc1 tree.  I 
can send another patch later if/when the sched_flags changes appears in 
the kernel version we end up picking for final oprofile-spu development.

Comments welcome.  Thanks.

-Maynard

--------------010206080901080700090209
Content-Type: text/x-diff;
 name="spu-notifier.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="spu-notifier.patch"

Subject: Enable SPU switch notification to detect currently active SPU tasks.

From: Maynard Johnson <maynardj@us.ibm.com>

This patch adds to the capability of spu_switch_event_register so that the
caller is also notified of currently active SPU tasks.  It also exports
spu_switch_event_register and spu_switch_event_unregister.

Signed-off-by: Maynard Johnson <mpjohn@us.ibm.com>


Index: linux-2.6.20-rc1/arch/powerpc/platforms/cell/spufs/sched.c
===================================================================
--- linux-2.6.20-rc1.orig/arch/powerpc/platforms/cell/spufs/sched.c	2007-01-18 16:43:14.324526032 -0600
+++ linux-2.6.20-rc1/arch/powerpc/platforms/cell/spufs/sched.c	2007-01-26 16:16:35.219668640 -0600
@@ -78,21 +78,46 @@
 
 static BLOCKING_NOTIFIER_HEAD(spu_switch_notifier);
 
-static void spu_switch_notify(struct spu *spu, struct spu_context *ctx)
+void spu_switch_notify(struct spu *spu, struct spu_context *ctx)
 {
 	blocking_notifier_call_chain(&spu_switch_notifier,
 			    ctx ? ctx->object_id : 0, spu);
 }
 
+static void notify_spus_active(void)
+{
+       int node;
+	/* Wake up the active spu_contexts. When the awakened processes 
+	 * sees their notify_active flag is set, they will call
+	 * spu_switch_notify();
+	 */
+	for (node = 0; node < MAX_NUMNODES; node++) {
+		struct spu *spu;
+		mutex_lock(&spu_prio->active_mutex[node]);
+                list_for_each_entry(spu, &spu_prio->active_list[node], list) {
+			struct spu_context *ctx = spu->ctx;
+			spu->notify_active = 1;
+			wake_up_all(&ctx->stop_wq);
+		}
+                mutex_unlock(&spu_prio->active_mutex[node]);
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
 
 
 static inline void bind_context(struct spu *spu, struct spu_context *ctx)
Index: linux-2.6.20-rc1/arch/powerpc/platforms/cell/spufs/spufs.h
===================================================================
--- linux-2.6.20-rc1.orig/arch/powerpc/platforms/cell/spufs/spufs.h	2007-01-18 16:43:14.340523600 -0600
+++ linux-2.6.20-rc1/arch/powerpc/platforms/cell/spufs/spufs.h	2007-01-26 16:26:49.733703448 -0600
@@ -180,6 +180,7 @@
 int spu_activate(struct spu_context *ctx, u64 flags);
 void spu_deactivate(struct spu_context *ctx);
 void spu_yield(struct spu_context *ctx);
+void spu_switch_notify(struct spu *spu, struct spu_context *ctx);
 int __init spu_sched_init(void);
 void __exit spu_sched_exit(void);
 
Index: linux-2.6.20-rc1/arch/powerpc/platforms/cell/spufs/run.c
===================================================================
--- linux-2.6.20-rc1.orig/arch/powerpc/platforms/cell/spufs/run.c	2007-01-18 16:43:14.340523600 -0600
+++ linux-2.6.20-rc1/arch/powerpc/platforms/cell/spufs/run.c	2007-01-26 16:24:38.979744856 -0600
@@ -45,9 +45,10 @@
 	u64 pte_fault;
 
 	*stat = ctx->ops->status_read(ctx);
-	if (ctx->state != SPU_STATE_RUNNABLE)
-		return 1;
+
 	spu = ctx->spu;
+	if (ctx->state != SPU_STATE_RUNNABLE || spu->notify_active)
+		return 1;
 	pte_fault = spu->dsisr &
 	    (MFC_DSISR_PTE_NOT_FOUND | MFC_DSISR_ACCESS_DENIED);
 	return (!(*stat & 0x1) || pte_fault || spu->class_0_pending) ? 1 : 0;
@@ -305,6 +306,7 @@
 		   u32 *npc, u32 *event)
 {
 	int ret;
+	struct spu * spu;
 	u32 status;
 
 	if (down_interruptible(&ctx->run_sema))
@@ -318,8 +320,16 @@
 
 	do {
 		ret = spufs_wait(ctx->stop_wq, spu_stopped(ctx, &status));
+		spu = ctx->spu;
 		if (unlikely(ret))
 			break;
+		if (unlikely(spu->notify_active)) {
+			spu->notify_active = 0;
+			if (!(status & SPU_STATUS_STOPPED_BY_STOP)) {
+				spu_switch_notify(spu, ctx);
+				continue;
+			}
+		}
 		if ((status & SPU_STATUS_STOPPED_BY_STOP) &&
 		    (status >> SPU_STOP_STATUS_SHIFT == 0x2104)) {
 			ret = spu_process_callback(ctx);
Index: linux-2.6.20-rc1/include/asm-powerpc/spu.h
===================================================================
--- linux-2.6.20-rc1.orig/include/asm-powerpc/spu.h	2007-01-18 16:43:19.932605072 -0600
+++ linux-2.6.20-rc1/include/asm-powerpc/spu.h	2007-01-24 12:17:30.209676992 -0600
@@ -144,6 +144,7 @@
 
 	void* pdata; /* platform private data */
 	struct sys_device sysdev;
+	int notify_active;
 };
 
 struct spu *spu_alloc(void);

--------------010206080901080700090209--

