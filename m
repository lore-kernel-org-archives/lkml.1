Return-Path: <linux-kernel-owner+w=401wt.eu-S1764857AbXILHor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764857AbXILHor (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 03:44:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757105AbXILHno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 03:43:44 -0400
Received: from ozlabs.org ([203.10.76.45]:46334 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754833AbXILHnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 03:43:43 -0400
To: <linuxppc-dev@ozlabs.org>
Cc: Jeremy Kerr <jk@ozlabs.org>, <linux-kernel@vger.kernel.org>
Message-Id: <ad6cad45f34ae70d042e21c0a6e3a0fb36e3c496.1189583010.git.michael@ellerman.id.au>
In-Reply-To: <2900ea4dbfd6e98e71ff400cbd25d1283a278972.1189583010.git.michael@ellerman.id.au>
References: <2900ea4dbfd6e98e71ff400cbd25d1283a278972.1189583010.git.michael@ellerman.id.au>
From: Michael Ellerman <michael@ellerman.id.au>
Subject: [PATCH 04/15] Use computed sizes/#defines rather than literals in SPU coredump code
Date: Wed, 12 Sep 2007 17:43:41 +1000 (EST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The spufs_coredump_reader array contains the size of the data that will be
returned by the read routine. Currently these are specified as literals, and
though some are obvious, sizeof(u32) == 4, others are not, 69 * 8 ==  ???

Instead, use sizeof() whatever type is returned by each routine, or in
the case of spufs_mem_read() the #define LS_SIZE.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
---
 arch/powerpc/platforms/cell/spufs/file.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/platforms/cell/spufs/file.c b/arch/powerpc/platforms/cell/spufs/file.c
index a4a8770..18ddde8 100644
--- a/arch/powerpc/platforms/cell/spufs/file.c
+++ b/arch/powerpc/platforms/cell/spufs/file.c
@@ -2231,23 +2231,24 @@ struct tree_descr spufs_dir_nosched_contents[] = {
 };
 
 struct spufs_coredump_reader spufs_coredump_read[] = {
-	{ "regs", __spufs_regs_read, NULL, 128 * 16 },
-	{ "fpcr", __spufs_fpcr_read, NULL, 16 },
+	{ "regs", __spufs_regs_read, NULL, sizeof(struct spu_reg128[128])},
+	{ "fpcr", __spufs_fpcr_read, NULL, sizeof(struct spu_reg128) },
 	{ "lslr", NULL, __spufs_lslr_get, 11 },
 	{ "decr", NULL, __spufs_decr_get, 11 },
 	{ "decr_status", NULL, __spufs_decr_status_get, 11 },
-	{ "mem", __spufs_mem_read, NULL, 256 * 1024, },
-	{ "signal1", __spufs_signal1_read, NULL, 4 },
+	{ "mem", __spufs_mem_read, NULL, LS_SIZE, },
+	{ "signal1", __spufs_signal1_read, NULL, sizeof(u32) },
 	{ "signal1_type", NULL, __spufs_signal1_type_get, 2 },
-	{ "signal2", __spufs_signal2_read, NULL, 4 },
+	{ "signal2", __spufs_signal2_read, NULL, sizeof(u32) },
 	{ "signal2_type", NULL, __spufs_signal2_type_get, 2 },
 	{ "event_mask", NULL, __spufs_event_mask_get, 8 },
 	{ "event_status", NULL, __spufs_event_status_get, 8 },
-	{ "mbox_info", __spufs_mbox_info_read, NULL, 4 },
-	{ "ibox_info", __spufs_ibox_info_read, NULL, 4 },
-	{ "wbox_info", __spufs_wbox_info_read, NULL, 16 },
-	{ "dma_info", __spufs_dma_info_read, NULL, 69 * 8 },
-	{ "proxydma_info", __spufs_proxydma_info_read, NULL, 35 * 8 },
+	{ "mbox_info", __spufs_mbox_info_read, NULL, sizeof(u32) },
+	{ "ibox_info", __spufs_ibox_info_read, NULL, sizeof(u32) },
+	{ "wbox_info", __spufs_wbox_info_read, NULL, 4 * sizeof(u32)},
+	{ "dma_info", __spufs_dma_info_read, NULL, sizeof(struct spu_dma_info)},
+	{ "proxydma_info", __spufs_proxydma_info_read,
+			   NULL, sizeof(struct spu_proxydma_info)},
 	{ "object-id", NULL, __spufs_object_id_get, 19 },
 	{ },
 };
-- 
1.5.1.3.g7a33b

