Return-Path: <linux-kernel-owner+w=401wt.eu-S1762205AbZEHOFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762205AbZEHOFY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 10:05:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757913AbZEHOBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 10:01:35 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:58249 "EHLO
	pophost.sonytel.be" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758628AbZEHOBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 10:01:33 -0400
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: cbe-oss-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Jim Paris <jim@jtan.com>
Subject: [PATCH 10/15] ps3vram: GPU memory mapping cleanup
Date: Fri,  8 May 2009 16:01:19 +0200
Message-Id: <1241791284-11490-11-git-send-email-Geert.Uytterhoeven@sonycom.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1241791284-11490-10-git-send-email-Geert.Uytterhoeven@sonycom.com>
References: <1241791284-11490-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1241791284-11490-2-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1241791284-11490-3-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1241791284-11490-4-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1241791284-11490-5-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1241791284-11490-6-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1241791284-11490-7-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1241791284-11490-8-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1241791284-11490-9-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1241791284-11490-10-git-send-email-Geert.Uytterhoeven@sonycom.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  - Make the IOMMU flags used for mapping main memory into the GPU's I/O space
    explicit, instead of relying on the default in the hypervisor,
  - Add missing calls to lv1_gpu_context_iomap(..., IOPTE_M) to unmap the
    memory during cleanup.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Jim Paris <jim@jtan.com>
---
 drivers/block/ps3vram.c |   18 +++++++++++++-----
 1 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/block/ps3vram.c b/drivers/block/ps3vram.c
index 1396038..c58ac15 100644
--- a/drivers/block/ps3vram.c
+++ b/drivers/block/ps3vram.c
@@ -14,6 +14,7 @@
 #include <linux/seq_file.h>
 
 #include <asm/firmware.h>
+#include <asm/iommu.h>
 #include <asm/lv1call.h>
 #include <asm/ps3.h>
 
@@ -628,8 +629,8 @@ static int __devinit ps3vram_probe(struct ps3_system_bus_device *dev)
 	int error, status;
 	struct request_queue *queue;
 	struct gendisk *gendisk;
-	u64 ddr_lpar, ctrl_lpar, info_lpar, reports_lpar, ddr_size,
-	    reports_size;
+	u64 ddr_size, ddr_lpar, ctrl_lpar, info_lpar, reports_lpar,
+	    reports_size, xdr_lpar;
 	char *rest;
 
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
@@ -700,9 +701,10 @@ static int __devinit ps3vram_probe(struct ps3_system_bus_device *dev)
 	}
 
 	/* Map XDR buffer to RSX */
+	xdr_lpar = ps3_mm_phys_to_lpar(__pa(priv->xdr_buf));
 	status = lv1_gpu_context_iomap(priv->context_handle, XDR_IOIF,
-				       ps3_mm_phys_to_lpar(__pa(priv->xdr_buf)),
-				       XDR_BUF_SIZE, 0);
+				       xdr_lpar, XDR_BUF_SIZE,
+				       IOPTE_PP_W | IOPTE_PP_R | IOPTE_M);
 	if (status) {
 		dev_err(&dev->core, "lv1_gpu_context_iomap failed %d\n",
 			status);
@@ -715,7 +717,7 @@ static int __devinit ps3vram_probe(struct ps3_system_bus_device *dev)
 	if (!priv->ddr_base) {
 		dev_err(&dev->core, "ioremap DDR failed\n");
 		error = -ENOMEM;
-		goto out_free_context;
+		goto out_unmap_context;
 	}
 
 	priv->ctrl = ioremap(ctrl_lpar, 64 * 1024);
@@ -801,6 +803,9 @@ out_unmap_ctrl:
 	iounmap(priv->ctrl);
 out_unmap_vram:
 	iounmap(priv->ddr_base);
+out_unmap_context:
+	lv1_gpu_context_iomap(priv->context_handle, XDR_IOIF, xdr_lpar,
+			      XDR_BUF_SIZE, IOPTE_M);
 out_free_context:
 	lv1_gpu_context_free(priv->context_handle);
 out_free_memory:
@@ -828,6 +833,9 @@ static int ps3vram_remove(struct ps3_system_bus_device *dev)
 	iounmap(priv->reports);
 	iounmap(priv->ctrl);
 	iounmap(priv->ddr_base);
+	lv1_gpu_context_iomap(priv->context_handle, XDR_IOIF,
+			      ps3_mm_phys_to_lpar(__pa(priv->xdr_buf)),
+			      XDR_BUF_SIZE, IOPTE_M);
 	lv1_gpu_context_free(priv->context_handle);
 	lv1_gpu_memory_free(priv->memory_handle);
 	ps3_close_hv_device(dev);
-- 
1.6.2.4

