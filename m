Return-Path: <linux-kernel-owner+w=401wt.eu-S1756124AbZDDSbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124AbZDDSbf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 14:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754678AbZDDSb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 14:31:27 -0400
Received: from [213.79.90.228] ([213.79.90.228]:7935 "EHLO
	buildserver.ru.mvista.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753737AbZDDSb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 14:31:26 -0400
Date: Sat, 4 Apr 2009 22:31:20 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Antonino Daplas <adaplas@gmail.com>, Timur Tabi <timur@freescale.com>,
       Kumar Gala <galak@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] fsl-diu-fb: Pass the proper device for dma mapping routines
Message-ID: <20090404183120.GA21671@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver should pass a device that specifies internal DMA ops, but
currently NULL pointers are passed, and thus following bug pops up:

  Freescale DIU driver
  ------------[ cut here ]------------
  kernel BUG at arch/powerpc/include/asm/dma-mapping.h:237!
  Oops: Exception in kernel mode, sig: 5 [#1]
  ...
  NIP [c01658b4] allocate_buf+0x0/0x8
  LR [c0306554] fsl_diu_probe+0x2b4/0x518
  Call Trace:
  [df02be10] [c030638c] fsl_diu_probe+0xec/0x518 (unreliable)
  [df02be60] [c020cdec] of_platform_device_probe+0x5c/0x84
  [df02be80] [c018f5d0] really_probe+0x78/0x1a0
  [df02bea0] [c018f7c0] __driver_attach+0xa4/0xa8
  [df02bec0] [c018ea00] bus_for_each_dev+0x60/0x9c
  [df02bef0] [c018f414] driver_attach+0x24/0x34
  [df02bf00] [c018f168] bus_add_driver+0x12c/0x1cc
  [df02bf20] [c018fbdc] driver_register+0x6c/0x110
  [df02bf30] [c020ccb4] of_register_driver+0x54/0x70
  [df02bf40] [c03d0a50] fsl_diu_init+0x70/0xa4
  ...

This patch fixes the issue.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/video/fsl-diu-fb.c |   34 +++++++++++++++++++++-------------
 1 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/drivers/video/fsl-diu-fb.c b/drivers/video/fsl-diu-fb.c
index fb51197..f153c58 100644
--- a/drivers/video/fsl-diu-fb.c
+++ b/drivers/video/fsl-diu-fb.c
@@ -1352,14 +1352,15 @@ static int fsl_diu_resume(struct of_device *ofdev)
 #endif				/* CONFIG_PM */
 
 /* Align to 64-bit(8-byte), 32-byte, etc. */
-static int allocate_buf(struct diu_addr *buf, u32 size, u32 bytes_align)
+static int allocate_buf(struct device *dev, struct diu_addr *buf, u32 size,
+			u32 bytes_align)
 {
 	u32 offset, ssize;
 	u32 mask;
 	dma_addr_t paddr = 0;
 
 	ssize = size + bytes_align;
-	buf->vaddr = dma_alloc_coherent(NULL, ssize, &paddr, GFP_DMA |
+	buf->vaddr = dma_alloc_coherent(dev, ssize, &paddr, GFP_DMA |
 							     __GFP_ZERO);
 	if (!buf->vaddr)
 		return -ENOMEM;
@@ -1376,9 +1377,10 @@ static int allocate_buf(struct diu_addr *buf, u32 size, u32 bytes_align)
 	return 0;
 }
 
-static void free_buf(struct diu_addr *buf, u32 size, u32 bytes_align)
+static void free_buf(struct device *dev, struct diu_addr *buf, u32 size,
+		     u32 bytes_align)
 {
-	dma_free_coherent(NULL, size + bytes_align,
+	dma_free_coherent(dev, size + bytes_align,
 				buf->vaddr, (buf->paddr - buf->offset));
 	return;
 }
@@ -1476,17 +1478,19 @@ static int __devinit fsl_diu_probe(struct of_device *ofdev,
 	machine_data->monitor_port = monitor_port;
 
 	/* Area descriptor memory pool aligns to 64-bit boundary */
-	if (allocate_buf(&pool.ad, sizeof(struct diu_ad) * FSL_AOI_NUM, 8))
+	if (allocate_buf(&ofdev->dev, &pool.ad,
+			 sizeof(struct diu_ad) * FSL_AOI_NUM, 8))
 		return -ENOMEM;
 
 	/* Get memory for Gamma Table  - 32-byte aligned memory */
-	if (allocate_buf(&pool.gamma, 768, 32)) {
+	if (allocate_buf(&ofdev->dev, &pool.gamma, 768, 32)) {
 		ret = -ENOMEM;
 		goto error;
 	}
 
 	/* For performance, cursor bitmap buffer aligns to 32-byte boundary */
-	if (allocate_buf(&pool.cursor, MAX_CURS * MAX_CURS * 2, 32)) {
+	if (allocate_buf(&ofdev->dev, &pool.cursor, MAX_CURS * MAX_CURS * 2,
+			 32)) {
 		ret = -ENOMEM;
 		goto error;
 	}
@@ -1554,11 +1558,13 @@ error:
 		i > 0; i--)
 		uninstall_fb(machine_data->fsl_diu_info[i - 1]);
 	if (pool.ad.vaddr)
-		free_buf(&pool.ad, sizeof(struct diu_ad) * FSL_AOI_NUM, 8);
+		free_buf(&ofdev->dev, &pool.ad,
+			 sizeof(struct diu_ad) * FSL_AOI_NUM, 8);
 	if (pool.gamma.vaddr)
-		free_buf(&pool.gamma, 768, 32);
+		free_buf(&ofdev->dev, &pool.gamma, 768, 32);
 	if (pool.cursor.vaddr)
-		free_buf(&pool.cursor, MAX_CURS * MAX_CURS * 2, 32);
+		free_buf(&ofdev->dev, &pool.cursor, MAX_CURS * MAX_CURS * 2,
+			 32);
 	if (machine_data->dummy_aoi_virt)
 		fsl_diu_free(machine_data->dummy_aoi_virt, 64);
 	iounmap(dr.diu_reg);
@@ -1584,11 +1590,13 @@ static int fsl_diu_remove(struct of_device *ofdev)
 	for (i = ARRAY_SIZE(machine_data->fsl_diu_info); i > 0; i--)
 		uninstall_fb(machine_data->fsl_diu_info[i - 1]);
 	if (pool.ad.vaddr)
-		free_buf(&pool.ad, sizeof(struct diu_ad) * FSL_AOI_NUM, 8);
+		free_buf(&ofdev->dev, &pool.ad,
+			 sizeof(struct diu_ad) * FSL_AOI_NUM, 8);
 	if (pool.gamma.vaddr)
-		free_buf(&pool.gamma, 768, 32);
+		free_buf(&ofdev->dev, &pool.gamma, 768, 32);
 	if (pool.cursor.vaddr)
-		free_buf(&pool.cursor, MAX_CURS * MAX_CURS * 2, 32);
+		free_buf(&ofdev->dev, &pool.cursor, MAX_CURS * MAX_CURS * 2,
+			 32);
 	if (machine_data->dummy_aoi_virt)
 		fsl_diu_free(machine_data->dummy_aoi_virt, 64);
 	iounmap(dr.diu_reg);
-- 
1.5.6.5
