Return-Path: <linux-kernel-owner+w=401wt.eu-S1764824AbXILHpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764824AbXILHpP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 03:45:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757632AbXILHnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 03:43:45 -0400
Received: from ozlabs.org ([203.10.76.45]:46314 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755900AbXILHnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 03:43:43 -0400
To: <linuxppc-dev@ozlabs.org>
Cc: Jeremy Kerr <jk@ozlabs.org>, <linux-kernel@vger.kernel.org>
Message-Id: <b5facc2fa4801181f21f5f0705892adf28766569.1189583010.git.michael@ellerman.id.au>
In-Reply-To: <2900ea4dbfd6e98e71ff400cbd25d1283a278972.1189583010.git.michael@ellerman.id.au>
References: <2900ea4dbfd6e98e71ff400cbd25d1283a278972.1189583010.git.michael@ellerman.id.au>
From: Michael Ellerman <michael@ellerman.id.au>
Subject: [PATCH 05/15] Write some SPU coredump values as ASCII
Date: Wed, 12 Sep 2007 17:43:42 +1000 (EST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Unfortunately GDB expects some of the SPU coredump values to be identical
in format to what is found in spufs. This means we need to dump some of
the values as ASCII strings, not the actual values.

Because we don't know what the values will be, we always print the values
with the format "0x%.16lx", that way we know the result will be 19 bytes.

do_coredump_read() doesn't take a __user buffer, so remove the annotation,
and because we know that it's safe to just snprintf() directly to it.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
---
 arch/powerpc/platforms/cell/spufs/coredump.c |    8 +++++---
 arch/powerpc/platforms/cell/spufs/file.c     |   14 +++++++-------
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/platforms/cell/spufs/coredump.c b/arch/powerpc/platforms/cell/spufs/coredump.c
index 21283f6..c65b717 100644
--- a/arch/powerpc/platforms/cell/spufs/coredump.c
+++ b/arch/powerpc/platforms/cell/spufs/coredump.c
@@ -31,7 +31,7 @@
 
 #include "spufs.h"
 
-static ssize_t do_coredump_read(int num, struct spu_context *ctx, void __user *buffer,
+static ssize_t do_coredump_read(int num, struct spu_context *ctx, void *buffer,
 				size_t size, loff_t *off)
 {
 	u64 data;
@@ -41,8 +41,10 @@ static ssize_t do_coredump_read(int num, struct spu_context *ctx, void __user *b
 		return spufs_coredump_read[num].read(ctx, buffer, size, off);
 
 	data = spufs_coredump_read[num].get(ctx);
-	ret = copy_to_user(buffer, &data, 8);
-	return ret ? -EFAULT : 8;
+	ret = snprintf(buffer, size, "0x%.16lx", data);
+	if (ret >= size)
+		return size;
+	return ++ret; /* count trailing NULL */
 }
 
 /*
diff --git a/arch/powerpc/platforms/cell/spufs/file.c b/arch/powerpc/platforms/cell/spufs/file.c
index 18ddde8..85edbec 100644
--- a/arch/powerpc/platforms/cell/spufs/file.c
+++ b/arch/powerpc/platforms/cell/spufs/file.c
@@ -2233,16 +2233,16 @@ struct tree_descr spufs_dir_nosched_contents[] = {
 struct spufs_coredump_reader spufs_coredump_read[] = {
 	{ "regs", __spufs_regs_read, NULL, sizeof(struct spu_reg128[128])},
 	{ "fpcr", __spufs_fpcr_read, NULL, sizeof(struct spu_reg128) },
-	{ "lslr", NULL, __spufs_lslr_get, 11 },
-	{ "decr", NULL, __spufs_decr_get, 11 },
-	{ "decr_status", NULL, __spufs_decr_status_get, 11 },
+	{ "lslr", NULL, __spufs_lslr_get, 19 },
+	{ "decr", NULL, __spufs_decr_get, 19 },
+	{ "decr_status", NULL, __spufs_decr_status_get, 19 },
 	{ "mem", __spufs_mem_read, NULL, LS_SIZE, },
 	{ "signal1", __spufs_signal1_read, NULL, sizeof(u32) },
-	{ "signal1_type", NULL, __spufs_signal1_type_get, 2 },
+	{ "signal1_type", NULL, __spufs_signal1_type_get, 19 },
 	{ "signal2", __spufs_signal2_read, NULL, sizeof(u32) },
-	{ "signal2_type", NULL, __spufs_signal2_type_get, 2 },
-	{ "event_mask", NULL, __spufs_event_mask_get, 8 },
-	{ "event_status", NULL, __spufs_event_status_get, 8 },
+	{ "signal2_type", NULL, __spufs_signal2_type_get, 19 },
+	{ "event_mask", NULL, __spufs_event_mask_get, 19 },
+	{ "event_status", NULL, __spufs_event_status_get, 19 },
 	{ "mbox_info", __spufs_mbox_info_read, NULL, sizeof(u32) },
 	{ "ibox_info", __spufs_ibox_info_read, NULL, sizeof(u32) },
 	{ "wbox_info", __spufs_wbox_info_read, NULL, 4 * sizeof(u32)},
-- 
1.5.1.3.g7a33b

