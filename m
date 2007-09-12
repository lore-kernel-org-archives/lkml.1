Return-Path: <linux-kernel-owner+w=401wt.eu-S1765264AbXILHt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765264AbXILHt3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 03:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763988AbXILHnz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 03:43:55 -0400
Received: from ozlabs.org ([203.10.76.45]:46507 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763268AbXILHnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 03:43:53 -0400
To: <linuxppc-dev@ozlabs.org>
Cc: Jeremy Kerr <jk@ozlabs.org>, <linux-kernel@vger.kernel.org>
Message-Id: <f5fe712aef37d925902f3f6183f024b916cc89db.1189583010.git.michael@ellerman.id.au>
In-Reply-To: <2900ea4dbfd6e98e71ff400cbd25d1283a278972.1189583010.git.michael@ellerman.id.au>
References: <2900ea4dbfd6e98e71ff400cbd25d1283a278972.1189583010.git.michael@ellerman.id.au>
From: Michael Ellerman <michael@ellerman.id.au>
Subject: [PATCH 15/15] Add DEFINE_SPUFS_ATTRIBUTE()
Date: Wed, 12 Sep 2007 17:43:52 +1000 (EST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds DEFINE_SPUFS_ATTRIBUTE(), a wraper around
DEFINE_SIMPLE_ATTRIBUTE which does the specified locking for the get
routine for us.

Unfortunately we need two get routines (a locked and unlocked version) to
support the coredump code. This patch hides one of those (the locked version)
inside the macro foo.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
---
 arch/powerpc/platforms/cell/spufs/file.c |  216 +++++++++++-------------------
 1 files changed, 76 insertions(+), 140 deletions(-)

diff --git a/arch/powerpc/platforms/cell/spufs/file.c b/arch/powerpc/platforms/cell/spufs/file.c
index 52f020a..46ec8eb 100644
--- a/arch/powerpc/platforms/cell/spufs/file.c
+++ b/arch/powerpc/platforms/cell/spufs/file.c
@@ -1076,6 +1076,36 @@ static const struct file_operations spufs_signal2_nosched_fops = {
 	.mmap = spufs_signal2_mmap,
 };
 
+/*
+ * This is a wrapper around DEFINE_SIMPLE_ATTRIBUTE which does the
+ * work of acquiring (or not) the SPU context before calling through
+ * to the actual get routine. The set routine is called directly.
+ */
+#define SPU_ATTR_NOACQUIRE	0
+#define SPU_ATTR_ACQUIRE	1
+#define SPU_ATTR_ACQUIRE_SAVED	2
+
+#define DEFINE_SPUFS_ATTRIBUTE(__name, __get, __set, __fmt, __acquire)	\
+static u64 __##__get(void *data)					\
+{									\
+	struct spu_context *ctx = data;					\
+	u64 ret;							\
+									\
+	if (__acquire == SPU_ATTR_ACQUIRE) {				\
+		spu_acquire(ctx);					\
+		ret = __get(ctx);					\
+		spu_release(ctx);					\
+	} else if (__acquire == SPU_ATTR_ACQUIRE_SAVED)	{		\
+		spu_acquire_saved(ctx);					\
+		ret = __get(ctx);					\
+		spu_release_saved(ctx);					\
+	} else								\
+		ret = __get(ctx);					\
+									\
+	return ret;							\
+}									\
+DEFINE_SIMPLE_ATTRIBUTE(__name, __##__get, __set, __fmt);
+
 static void spufs_signal1_type_set(void *data, u64 val)
 {
 	struct spu_context *ctx = data;
@@ -1085,24 +1115,13 @@ static void spufs_signal1_type_set(void *data, u64 val)
 	spu_release(ctx);
 }
 
-static u64 __spufs_signal1_type_get(struct spu_context *ctx)
+static u64 spufs_signal1_type_get(struct spu_context *ctx)
 {
 	return ctx->ops->signal1_type_get(ctx);
 }
+DEFINE_SPUFS_ATTRIBUTE(spufs_signal1_type, spufs_signal1_type_get,
+		       spufs_signal1_type_set, "%llu", SPU_ATTR_ACQUIRE);
 
-static u64 spufs_signal1_type_get(void *data)
-{
-	struct spu_context *ctx = data;
-	u64 ret;
-
-	spu_acquire(ctx);
-	ret = __spufs_signal1_type_get(ctx);
-	spu_release(ctx);
-
-	return ret;
-}
-DEFINE_SIMPLE_ATTRIBUTE(spufs_signal1_type, spufs_signal1_type_get,
-					spufs_signal1_type_set, "%llu");
 
 static void spufs_signal2_type_set(void *data, u64 val)
 {
@@ -1113,24 +1132,12 @@ static void spufs_signal2_type_set(void *data, u64 val)
 	spu_release(ctx);
 }
 
-static u64 __spufs_signal2_type_get(struct spu_context *ctx)
+static u64 spufs_signal2_type_get(struct spu_context *ctx)
 {
 	return ctx->ops->signal2_type_get(ctx);
 }
-
-static u64 spufs_signal2_type_get(void *data)
-{
-	struct spu_context *ctx = data;
-	u64 ret;
-
-	spu_acquire(ctx);
-	ret = __spufs_signal2_type_get(ctx);
-	spu_release(ctx);
-
-	return ret;
-}
-DEFINE_SIMPLE_ATTRIBUTE(spufs_signal2_type, spufs_signal2_type_get,
-					spufs_signal2_type_set, "%llu");
+DEFINE_SPUFS_ATTRIBUTE(spufs_signal2_type, spufs_signal2_type_get,
+		       spufs_signal2_type_set, "%llu", SPU_ATTR_ACQUIRE);
 
 #if SPUFS_MMAP_4K
 static unsigned long spufs_mss_mmap_nopfn(struct vm_area_struct *vma,
@@ -1606,22 +1613,12 @@ static void spufs_npc_set(void *data, u64 val)
 	spu_release(ctx);
 }
 
-static u64 __spufs_npc_get(struct spu_context *ctx)
+static u64 spufs_npc_get(struct spu_context *ctx)
 {
 	return ctx->ops->npc_read(ctx);
 }
-
-static u64 spufs_npc_get(void *data)
-{
-	struct spu_context *ctx = data;
-	u64 ret;
-	spu_acquire(ctx);
-	ret = __spufs_npc_get(ctx);
-	spu_release(ctx);
-	return ret;
-}
-DEFINE_SIMPLE_ATTRIBUTE(spufs_npc_ops, spufs_npc_get, spufs_npc_set,
-			"0x%llx\n")
+DEFINE_SPUFS_ATTRIBUTE(spufs_npc_ops, spufs_npc_get, spufs_npc_set,
+		       "0x%llx\n", SPU_ATTR_ACQUIRE);
 
 static void spufs_decr_set(void *data, u64 val)
 {
@@ -1632,23 +1629,13 @@ static void spufs_decr_set(void *data, u64 val)
 	spu_release_saved(ctx);
 }
 
-static u64 __spufs_decr_get(struct spu_context *ctx)
+static u64 spufs_decr_get(struct spu_context *ctx)
 {
 	struct spu_lscsa *lscsa = ctx->csa.lscsa;
 	return lscsa->decr.slot[0];
 }
-
-static u64 spufs_decr_get(void *data)
-{
-	struct spu_context *ctx = data;
-	u64 ret;
-	spu_acquire_saved(ctx);
-	ret = __spufs_decr_get(ctx);
-	spu_release_saved(ctx);
-	return ret;
-}
-DEFINE_SIMPLE_ATTRIBUTE(spufs_decr_ops, spufs_decr_get, spufs_decr_set,
-			"0x%llx\n")
+DEFINE_SPUFS_ATTRIBUTE(spufs_decr_ops, spufs_decr_get, spufs_decr_set,
+		       "0x%llx\n", SPU_ATTR_ACQUIRE_SAVED);
 
 static void spufs_decr_status_set(void *data, u64 val)
 {
@@ -1661,25 +1648,16 @@ static void spufs_decr_status_set(void *data, u64 val)
 	spu_release_saved(ctx);
 }
 
-static u64 __spufs_decr_status_get(struct spu_context *ctx)
+static u64 spufs_decr_status_get(struct spu_context *ctx)
 {
 	if (ctx->csa.priv2.mfc_control_RW & MFC_CNTL_DECREMENTER_RUNNING)
 		return SPU_DECR_STATUS_RUNNING;
 	else
 		return 0;
 }
-
-static u64 spufs_decr_status_get(void *data)
-{
-	struct spu_context *ctx = data;
-	u64 ret;
-	spu_acquire_saved(ctx);
-	ret = __spufs_decr_status_get(ctx);
-	spu_release_saved(ctx);
-	return ret;
-}
-DEFINE_SIMPLE_ATTRIBUTE(spufs_decr_status_ops, spufs_decr_status_get,
-			spufs_decr_status_set, "0x%llx\n")
+DEFINE_SPUFS_ATTRIBUTE(spufs_decr_status_ops, spufs_decr_status_get,
+		       spufs_decr_status_set, "0x%llx\n",
+		       SPU_ATTR_ACQUIRE_SAVED);
 
 static void spufs_event_mask_set(void *data, u64 val)
 {
@@ -1690,25 +1668,17 @@ static void spufs_event_mask_set(void *data, u64 val)
 	spu_release_saved(ctx);
 }
 
-static u64 __spufs_event_mask_get(struct spu_context *ctx)
+static u64 spufs_event_mask_get(struct spu_context *ctx)
 {
 	struct spu_lscsa *lscsa = ctx->csa.lscsa;
 	return lscsa->event_mask.slot[0];
 }
 
-static u64 spufs_event_mask_get(void *data)
-{
-	struct spu_context *ctx = data;
-	u64 ret;
-	spu_acquire_saved(ctx);
-	ret = __spufs_event_mask_get(ctx);
-	spu_release_saved(ctx);
-	return ret;
-}
-DEFINE_SIMPLE_ATTRIBUTE(spufs_event_mask_ops, spufs_event_mask_get,
-			spufs_event_mask_set, "0x%llx\n")
+DEFINE_SPUFS_ATTRIBUTE(spufs_event_mask_ops, spufs_event_mask_get,
+		       spufs_event_mask_set, "0x%llx\n",
+		       SPU_ATTR_ACQUIRE_SAVED);
 
-static u64 __spufs_event_status_get(struct spu_context *ctx)
+static u64 spufs_event_status_get(struct spu_context *ctx)
 {
 	struct spu_state *state = &ctx->csa;
 	u64 stat;
@@ -1717,19 +1687,8 @@ static u64 __spufs_event_status_get(struct spu_context *ctx)
 		return state->spu_chnldata_RW[0];
 	return 0;
 }
-
-static u64 spufs_event_status_get(void *data)
-{
-	struct spu_context *ctx = data;
-	u64 ret = 0;
-
-	spu_acquire_saved(ctx);
-	ret = __spufs_event_status_get(ctx);
-	spu_release_saved(ctx);
-	return ret;
-}
-DEFINE_SIMPLE_ATTRIBUTE(spufs_event_status_ops, spufs_event_status_get,
-			NULL, "0x%llx\n")
+DEFINE_SPUFS_ATTRIBUTE(spufs_event_status_ops, spufs_event_status_get,
+		       NULL, "0x%llx\n", SPU_ATTR_ACQUIRE_SAVED)
 
 static void spufs_srr0_set(void *data, u64 val)
 {
@@ -1740,44 +1699,32 @@ static void spufs_srr0_set(void *data, u64 val)
 	spu_release_saved(ctx);
 }
 
-static u64 spufs_srr0_get(void *data)
+static u64 spufs_srr0_get(struct spu_context *ctx)
 {
-	struct spu_context *ctx = data;
 	struct spu_lscsa *lscsa = ctx->csa.lscsa;
-	u64 ret;
-	spu_acquire_saved(ctx);
-	ret = lscsa->srr0.slot[0];
-	spu_release_saved(ctx);
-	return ret;
+	return lscsa->srr0.slot[0];
 }
-DEFINE_SIMPLE_ATTRIBUTE(spufs_srr0_ops, spufs_srr0_get, spufs_srr0_set,
-			"0x%llx\n")
+DEFINE_SPUFS_ATTRIBUTE(spufs_srr0_ops, spufs_srr0_get, spufs_srr0_set,
+		       "0x%llx\n", SPU_ATTR_ACQUIRE_SAVED)
 
-static u64 spufs_id_get(void *data)
+static u64 spufs_id_get(struct spu_context *ctx)
 {
-	struct spu_context *ctx = data;
 	u64 num;
 
-	spu_acquire(ctx);
 	if (ctx->state == SPU_STATE_RUNNABLE)
 		num = ctx->spu->number;
 	else
 		num = (unsigned int)-1;
-	spu_release(ctx);
 
 	return num;
 }
-DEFINE_SIMPLE_ATTRIBUTE(spufs_id_ops, spufs_id_get, NULL, "0x%llx\n")
+DEFINE_SPUFS_ATTRIBUTE(spufs_id_ops, spufs_id_get, NULL, "0x%llx\n",
+		       SPU_ATTR_ACQUIRE)
 
-static u64 __spufs_object_id_get(struct spu_context *ctx)
-{
-	return ctx->object_id;
-}
-
-static u64 spufs_object_id_get(void *data)
+static u64 spufs_object_id_get(struct spu_context *ctx)
 {
 	/* FIXME: Should there really be no locking here? */
-	return __spufs_object_id_get((struct spu_context *)data);
+	return ctx->object_id;
 }
 
 static void spufs_object_id_set(void *data, u64 id)
@@ -1786,26 +1733,15 @@ static void spufs_object_id_set(void *data, u64 id)
 	ctx->object_id = id;
 }
 
-DEFINE_SIMPLE_ATTRIBUTE(spufs_object_id_ops, spufs_object_id_get,
-		spufs_object_id_set, "0x%llx\n");
+DEFINE_SPUFS_ATTRIBUTE(spufs_object_id_ops, spufs_object_id_get,
+		       spufs_object_id_set, "0x%llx\n", SPU_ATTR_NOACQUIRE);
 
-static u64 __spufs_lslr_get(struct spu_context *ctx)
+static u64 spufs_lslr_get(struct spu_context *ctx)
 {
 	return ctx->csa.priv2.spu_lslr_RW;
 }
-
-static u64 spufs_lslr_get(void *data)
-{
-	struct spu_context *ctx = data;
-	u64 ret;
-
-	spu_acquire_saved(ctx);
-	ret = __spufs_lslr_get(ctx);
-	spu_release_saved(ctx);
-
-	return ret;
-}
-DEFINE_SIMPLE_ATTRIBUTE(spufs_lslr_ops, spufs_lslr_get, NULL, "0x%llx\n")
+DEFINE_SPUFS_ATTRIBUTE(spufs_lslr_ops, spufs_lslr_get, NULL, "0x%llx\n",
+		       SPU_ATTR_ACQUIRE_SAVED);
 
 static int spufs_info_open(struct inode *inode, struct file *file)
 {
@@ -2230,24 +2166,24 @@ struct tree_descr spufs_dir_nosched_contents[] = {
 struct spufs_coredump_reader spufs_coredump_read[] = {
 	{ "regs", __spufs_regs_read, NULL, sizeof(struct spu_reg128[128])},
 	{ "fpcr", __spufs_fpcr_read, NULL, sizeof(struct spu_reg128) },
-	{ "lslr", NULL, __spufs_lslr_get, 19 },
-	{ "decr", NULL, __spufs_decr_get, 19 },
-	{ "decr_status", NULL, __spufs_decr_status_get, 19 },
+	{ "lslr", NULL, spufs_lslr_get, 19 },
+	{ "decr", NULL, spufs_decr_get, 19 },
+	{ "decr_status", NULL, spufs_decr_status_get, 19 },
 	{ "mem", __spufs_mem_read, NULL, LS_SIZE, },
 	{ "signal1", __spufs_signal1_read, NULL, sizeof(u32) },
-	{ "signal1_type", NULL, __spufs_signal1_type_get, 19 },
+	{ "signal1_type", NULL, spufs_signal1_type_get, 19 },
 	{ "signal2", __spufs_signal2_read, NULL, sizeof(u32) },
-	{ "signal2_type", NULL, __spufs_signal2_type_get, 19 },
-	{ "event_mask", NULL, __spufs_event_mask_get, 19 },
-	{ "event_status", NULL, __spufs_event_status_get, 19 },
+	{ "signal2_type", NULL, spufs_signal2_type_get, 19 },
+	{ "event_mask", NULL, spufs_event_mask_get, 19 },
+	{ "event_status", NULL, spufs_event_status_get, 19 },
 	{ "mbox_info", __spufs_mbox_info_read, NULL, sizeof(u32) },
 	{ "ibox_info", __spufs_ibox_info_read, NULL, sizeof(u32) },
 	{ "wbox_info", __spufs_wbox_info_read, NULL, 4 * sizeof(u32)},
 	{ "dma_info", __spufs_dma_info_read, NULL, sizeof(struct spu_dma_info)},
 	{ "proxydma_info", __spufs_proxydma_info_read,
 			   NULL, sizeof(struct spu_proxydma_info)},
-	{ "object-id", NULL, __spufs_object_id_get, 19 },
-	{ "npc", NULL, __spufs_npc_get, 19 },
+	{ "object-id", NULL, spufs_object_id_get, 19 },
+	{ "npc", NULL, spufs_npc_get, 19 },
 };
 
 int spufs_coredump_num_notes = ARRAY_SIZE(spufs_coredump_read);
-- 
1.5.1.3.g7a33b

