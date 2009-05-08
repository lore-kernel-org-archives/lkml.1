Return-Path: <linux-kernel-owner+w=401wt.eu-S1763171AbZEHOFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763171AbZEHOFr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 10:05:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758728AbZEHOBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 10:01:36 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:58274 "EHLO
	pophost.sonytel.be" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755472AbZEHOBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 10:01:33 -0400
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: cbe-oss-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [PATCH 09/15] ps3fb: GPU memory mapping cleanup
Date: Fri,  8 May 2009 16:01:18 +0200
Message-Id: <1241791284-11490-10-git-send-email-Geert.Uytterhoeven@sonycom.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1241791284-11490-9-git-send-email-Geert.Uytterhoeven@sonycom.com>
References: <1241791284-11490-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1241791284-11490-2-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1241791284-11490-3-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1241791284-11490-4-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1241791284-11490-5-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1241791284-11490-6-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1241791284-11490-7-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1241791284-11490-8-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1241791284-11490-9-git-send-email-Geert.Uytterhoeven@sonycom.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  - Make the IOMMU flags used for mapping main memory into the GPU's I/O space
    explicit, instead of relying on the default in the hypervisor,
  - Add missing calls to lv1_gpu_context_iomap(..., IOPTE_M) to unmap the
    memory during cleanup.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 drivers/video/ps3fb.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/video/ps3fb.c b/drivers/video/ps3fb.c
index 542ffc3..43c58a9 100644
--- a/drivers/video/ps3fb.c
+++ b/drivers/video/ps3fb.c
@@ -32,6 +32,7 @@
 #include <linux/init.h>
 
 #include <asm/abs_addr.h>
+#include <asm/iommu.h>
 #include <asm/lv1call.h>
 #include <asm/ps3av.h>
 #include <asm/ps3fb.h>
@@ -1122,7 +1123,8 @@ static int __devinit ps3fb_probe(struct ps3_system_bus_device *dev)
 	xdr_lpar = ps3_mm_phys_to_lpar(__pa(ps3fb_videomemory.address));
 
 	status = lv1_gpu_context_iomap(ps3fb.context_handle, GPU_IOIF,
-				       xdr_lpar, ps3fb_videomemory.size, 0);
+				       xdr_lpar, ps3fb_videomemory.size,
+				       IOPTE_PP_W | IOPTE_PP_R | IOPTE_M);
 	if (status) {
 		dev_err(&dev->core, "%s: lv1_gpu_context_iomap failed: %d\n",
 			__func__, status);
@@ -1143,12 +1145,12 @@ static int __devinit ps3fb_probe(struct ps3_system_bus_device *dev)
 			"%s: lv1_gpu_context_attribute FB_SETUP failed: %d\n",
 			__func__, status);
 		retval = -ENXIO;
-		goto err_free_irq;
+		goto err_context_unmap;
 	}
 
 	info = framebuffer_alloc(sizeof(struct ps3fb_par), &dev->core);
 	if (!info)
-		goto err_free_irq;
+		goto err_context_unmap;
 
 	par = info->par;
 	par->mode_id = ~ps3fb_mode;	/* != ps3fb_mode, to trigger change */
@@ -1213,6 +1215,9 @@ err_fb_dealloc:
 	fb_dealloc_cmap(&info->cmap);
 err_framebuffer_release:
 	framebuffer_release(info);
+err_context_unmap:
+	lv1_gpu_context_iomap(ps3fb.context_handle, GPU_IOIF, xdr_lpar,
+			      ps3fb_videomemory.size, IOPTE_M);
 err_free_irq:
 	free_irq(ps3fb.irq_no, &dev->core);
 err_destroy_plug:
@@ -1232,6 +1237,7 @@ err:
 static int ps3fb_shutdown(struct ps3_system_bus_device *dev)
 {
 	struct fb_info *info = dev->core.driver_data;
+	u64 xdr_lpar = ps3_mm_phys_to_lpar(__pa(ps3fb_videomemory.address));
 
 	dev_dbg(&dev->core, " -> %s:%d\n", __func__, __LINE__);
 
@@ -1254,6 +1260,8 @@ static int ps3fb_shutdown(struct ps3_system_bus_device *dev)
 		info = dev->core.driver_data = NULL;
 	}
 	iounmap((u8 __force __iomem *)ps3fb.dinfo);
+	lv1_gpu_context_iomap(ps3fb.context_handle, GPU_IOIF, xdr_lpar,
+			      ps3fb_videomemory.size, IOPTE_M);
 	lv1_gpu_context_free(ps3fb.context_handle);
 	lv1_gpu_memory_free(ps3fb.memory_handle);
 	ps3_close_hv_device(dev);
-- 
1.6.2.4

