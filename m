Return-Path: <linux-kernel-owner+w=401wt.eu-S1763328AbZEHOGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763328AbZEHOGV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 10:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756577AbZEHOBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 10:01:37 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:58241 "EHLO
	pophost.sonytel.be" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757305AbZEHOBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 10:01:34 -0400
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: cbe-oss-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Jim Paris <jim@jtan.com>
Subject: [PATCH 11/15] ps3fb/vram: Extract common GPU stuff into <asm/ps3gpu.h>
Date: Fri,  8 May 2009 16:01:20 +0200
Message-Id: <1241791284-11490-12-git-send-email-Geert.Uytterhoeven@sonycom.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1241791284-11490-11-git-send-email-Geert.Uytterhoeven@sonycom.com>
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
 <1241791284-11490-11-git-send-email-Geert.Uytterhoeven@sonycom.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Jim Paris <jim@jtan.com>
---
 arch/powerpc/include/asm/ps3.h     |    3 -
 arch/powerpc/include/asm/ps3gpu.h  |   78 ++++++++++++++++++++++++++++++++++++
 arch/powerpc/platforms/ps3/setup.c |    1 +
 drivers/block/ps3vram.c            |   21 +++------
 drivers/ps3/ps3av_cmd.c            |    3 +-
 drivers/video/ps3fb.c              |   72 ++++++++++-----------------------
 6 files changed, 110 insertions(+), 68 deletions(-)
 create mode 100644 arch/powerpc/include/asm/ps3gpu.h

diff --git a/arch/powerpc/include/asm/ps3.h b/arch/powerpc/include/asm/ps3.h
index cdb6fd8..b9e4987 100644
--- a/arch/powerpc/include/asm/ps3.h
+++ b/arch/powerpc/include/asm/ps3.h
@@ -520,7 +520,4 @@ void ps3_sync_irq(int node);
 u32 ps3_get_hw_thread_id(int cpu);
 u64 ps3_get_spe_id(void *arg);
 
-/* mutex synchronizing GPU accesses and video mode changes */
-extern struct mutex ps3_gpu_mutex;
-
 #endif
diff --git a/arch/powerpc/include/asm/ps3gpu.h b/arch/powerpc/include/asm/ps3gpu.h
new file mode 100644
index 0000000..1037efa
--- /dev/null
+++ b/arch/powerpc/include/asm/ps3gpu.h
@@ -0,0 +1,78 @@
+/*
+ *  PS3 GPU declarations.
+ *
+ *  Copyright 2009 Sony Corporation
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program.
+ *  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef _ASM_POWERPC_PS3GPU_H
+#define _ASM_POWERPC_PS3GPU_H
+
+#include <linux/mutex.h>
+
+#include <asm/lv1call.h>
+
+
+#define L1GPU_CONTEXT_ATTRIBUTE_DISPLAY_SYNC	0x101
+#define L1GPU_CONTEXT_ATTRIBUTE_DISPLAY_FLIP	0x102
+
+#define L1GPU_CONTEXT_ATTRIBUTE_FB_SETUP	0x600
+#define L1GPU_CONTEXT_ATTRIBUTE_FB_BLIT		0x601
+#define L1GPU_CONTEXT_ATTRIBUTE_FB_BLIT_SYNC	0x602
+
+#define L1GPU_FB_BLIT_WAIT_FOR_COMPLETION	(1ULL << 32)
+
+#define L1GPU_DISPLAY_SYNC_HSYNC		1
+#define L1GPU_DISPLAY_SYNC_VSYNC		2
+
+
+/* mutex synchronizing GPU accesses and video mode changes */
+extern struct mutex ps3_gpu_mutex;
+
+
+static inline int lv1_gpu_display_sync(u64 context_handle, u64 head,
+				       u64 ddr_offset)
+{
+	return lv1_gpu_context_attribute(context_handle,
+					 L1GPU_CONTEXT_ATTRIBUTE_DISPLAY_SYNC,
+					 head, ddr_offset, 0, 0);
+}
+
+static inline int lv1_gpu_display_flip(u64 context_handle, u64 head,
+				       u64 ddr_offset)
+{
+	return lv1_gpu_context_attribute(context_handle,
+					 L1GPU_CONTEXT_ATTRIBUTE_DISPLAY_FLIP,
+					 head, ddr_offset, 0, 0);
+}
+
+static inline int lv1_gpu_fb_setup(u64 context_handle, u64 xdr_lpar,
+				   u64 xdr_size, u64 ioif_offset)
+{
+	return lv1_gpu_context_attribute(context_handle,
+					 L1GPU_CONTEXT_ATTRIBUTE_FB_SETUP,
+					 xdr_lpar, xdr_size, ioif_offset, 0);
+}
+
+static inline int lv1_gpu_fb_blit(u64 context_handle, u64 ddr_offset,
+				  u64 ioif_offset, u64 sync_width, u64 pitch)
+{
+	return lv1_gpu_context_attribute(context_handle,
+					 L1GPU_CONTEXT_ATTRIBUTE_FB_BLIT,
+					 ddr_offset, ioif_offset, sync_width,
+					 pitch);
+}
+
+#endif /* _ASM_POWERPC_PS3GPU_H */
diff --git a/arch/powerpc/platforms/ps3/setup.c b/arch/powerpc/platforms/ps3/setup.c
index 1a7b5ae..149bea2 100644
--- a/arch/powerpc/platforms/ps3/setup.c
+++ b/arch/powerpc/platforms/ps3/setup.c
@@ -32,6 +32,7 @@
 #include <asm/udbg.h>
 #include <asm/prom.h>
 #include <asm/lv1call.h>
+#include <asm/ps3gpu.h>
 
 #include "platform.h"
 
diff --git a/drivers/block/ps3vram.c b/drivers/block/ps3vram.c
index c58ac15..e85f09d 100644
--- a/drivers/block/ps3vram.c
+++ b/drivers/block/ps3vram.c
@@ -17,6 +17,7 @@
 #include <asm/iommu.h>
 #include <asm/lv1call.h>
 #include <asm/ps3.h>
+#include <asm/ps3gpu.h>
 
 
 #define DEVICE_NAME		"ps3vram"
@@ -46,8 +47,6 @@
 #define NV_MEMORY_TO_MEMORY_FORMAT_OFFSET_IN	0x0000030c
 #define NV_MEMORY_TO_MEMORY_FORMAT_NOTIFY	0x00000104
 
-#define L1GPU_CONTEXT_ATTRIBUTE_FB_BLIT 0x601
-
 #define CACHE_PAGE_PRESENT 1
 #define CACHE_PAGE_DIRTY   2
 
@@ -184,13 +183,10 @@ static void ps3vram_rewind_ring(struct ps3_system_bus_device *dev)
 	priv->ctrl[CTRL_PUT] = FIFO_BASE + FIFO_OFFSET;
 
 	/* asking the HV for a blit will kick the FIFO */
-	status = lv1_gpu_context_attribute(priv->context_handle,
-					   L1GPU_CONTEXT_ATTRIBUTE_FB_BLIT, 0,
-					   0, 0, 0);
+	status = lv1_gpu_fb_blit(priv->context_handle, 0, 0, 0, 0);
 	if (status)
-		dev_err(&dev->core,
-			"%s: lv1_gpu_context_attribute failed %d\n", __func__,
-			status);
+		dev_err(&dev->core, "%s: lv1_gpu_fb_blit failed %d\n",
+			__func__, status);
 
 	priv->fifo_ptr = priv->fifo_base;
 }
@@ -206,13 +202,10 @@ static void ps3vram_fire_ring(struct ps3_system_bus_device *dev)
 			       (priv->fifo_ptr - priv->fifo_base) * sizeof(u32);
 
 	/* asking the HV for a blit will kick the FIFO */
-	status = lv1_gpu_context_attribute(priv->context_handle,
-					   L1GPU_CONTEXT_ATTRIBUTE_FB_BLIT, 0,
-					   0, 0, 0);
+	status = lv1_gpu_fb_blit(priv->context_handle, 0, 0, 0, 0);
 	if (status)
-		dev_err(&dev->core,
-			"%s: lv1_gpu_context_attribute failed %d\n", __func__,
-			status);
+		dev_err(&dev->core, "%s: lv1_gpu_fb_blit failed %d\n",
+			__func__, status);
 
 	if ((priv->fifo_ptr - priv->fifo_base) * sizeof(u32) >
 	    FIFO_SIZE - 1024) {
diff --git a/drivers/ps3/ps3av_cmd.c b/drivers/ps3/ps3av_cmd.c
index 716596e..f555fed 100644
--- a/drivers/ps3/ps3av_cmd.c
+++ b/drivers/ps3/ps3av_cmd.c
@@ -21,9 +21,10 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/delay.h>
+
 #include <asm/ps3av.h>
-#include <asm/ps3fb.h>
 #include <asm/ps3.h>
+#include <asm/ps3gpu.h>
 
 #include "vuart.h"
 
diff --git a/drivers/video/ps3fb.c b/drivers/video/ps3fb.c
index 43c58a9..3bbdc9d 100644
--- a/drivers/video/ps3fb.c
+++ b/drivers/video/ps3fb.c
@@ -37,21 +37,11 @@
 #include <asm/ps3av.h>
 #include <asm/ps3fb.h>
 #include <asm/ps3.h>
+#include <asm/ps3gpu.h>
 
 
 #define DEVICE_NAME		"ps3fb"
 
-#define L1GPU_CONTEXT_ATTRIBUTE_DISPLAY_SYNC	0x101
-#define L1GPU_CONTEXT_ATTRIBUTE_DISPLAY_FLIP	0x102
-#define L1GPU_CONTEXT_ATTRIBUTE_FB_SETUP	0x600
-#define L1GPU_CONTEXT_ATTRIBUTE_FB_BLIT		0x601
-#define L1GPU_CONTEXT_ATTRIBUTE_FB_BLIT_SYNC	0x602
-
-#define L1GPU_FB_BLIT_WAIT_FOR_COMPLETION	(1ULL << 32)
-
-#define L1GPU_DISPLAY_SYNC_HSYNC		1
-#define L1GPU_DISPLAY_SYNC_VSYNC		2
-
 #define GPU_CMD_BUF_SIZE			(2 * 1024 * 1024)
 #define GPU_FB_START				(64 * 1024)
 #define GPU_IOIF				(0x0d000000UL)
@@ -463,33 +453,27 @@ static void ps3fb_sync_image(struct device *dev, u64 frame_offset,
 	src_offset += GPU_FB_START;
 
 	mutex_lock(&ps3_gpu_mutex);
-	status = lv1_gpu_context_attribute(ps3fb.context_handle,
-					   L1GPU_CONTEXT_ATTRIBUTE_FB_BLIT,
-					   dst_offset, GPU_IOIF + src_offset,
-					   L1GPU_FB_BLIT_WAIT_FOR_COMPLETION |
-					   (width << 16) | height,
-					   line_length);
+	status = lv1_gpu_fb_blit(ps3fb.context_handle, dst_offset,
+				 GPU_IOIF + src_offset,
+				 L1GPU_FB_BLIT_WAIT_FOR_COMPLETION |
+				 (width << 16) | height,
+				 line_length);
 	mutex_unlock(&ps3_gpu_mutex);
 
 	if (status)
-		dev_err(dev,
-			"%s: lv1_gpu_context_attribute FB_BLIT failed: %d\n",
-			__func__, status);
+		dev_err(dev, "%s: lv1_gpu_fb_blit failed: %d\n", __func__,
+			status);
 #ifdef HEAD_A
-	status = lv1_gpu_context_attribute(ps3fb.context_handle,
-					   L1GPU_CONTEXT_ATTRIBUTE_DISPLAY_FLIP,
-					   0, frame_offset, 0, 0);
+	status = lv1_gpu_display_flip(ps3fb.context_handle, 0, frame_offset);
 	if (status)
-		dev_err(dev, "%s: lv1_gpu_context_attribute FLIP failed: %d\n",
-			__func__, status);
+		dev_err(dev, "%s: lv1_gpu_display_flip failed: %d\n", __func__,
+			status);
 #endif
 #ifdef HEAD_B
-	status = lv1_gpu_context_attribute(ps3fb.context_handle,
-					   L1GPU_CONTEXT_ATTRIBUTE_DISPLAY_FLIP,
-					   1, frame_offset, 0, 0);
+	status = lv1_gpu_display_flip(ps3fb.context_handle, 1, frame_offset);
 	if (status)
-		dev_err(dev, "%s: lv1_gpu_context_attribute FLIP failed: %d\n",
-			__func__, status);
+		dev_err(dev, "%s: lv1_gpu_display_flip failed: %d\n", __func__,
+			status);
 #endif
 }
 
@@ -1020,27 +1004,18 @@ static int __devinit ps3fb_probe(struct ps3_system_bus_device *dev)
 	init_waitqueue_head(&ps3fb.wait_vsync);
 
 #ifdef HEAD_A
-	status = lv1_gpu_context_attribute(0x0,
-					   L1GPU_CONTEXT_ATTRIBUTE_DISPLAY_SYNC,
-					   0, L1GPU_DISPLAY_SYNC_VSYNC, 0, 0);
+	status = lv1_gpu_display_sync(0x0, 0, L1GPU_DISPLAY_SYNC_VSYNC);
 	if (status) {
-		dev_err(&dev->core,
-			"%s: lv1_gpu_context_attribute DISPLAY_SYNC failed: "
-			"%d\n",
+		dev_err(&dev->core, "%s: lv1_gpu_display_sync failed: %d\n",
 			__func__, status);
 		retval = -ENODEV;
 		goto err_close_device;
 	}
 #endif
 #ifdef HEAD_B
-	status = lv1_gpu_context_attribute(0x0,
-					   L1GPU_CONTEXT_ATTRIBUTE_DISPLAY_SYNC,
-					   1, L1GPU_DISPLAY_SYNC_VSYNC, 0, 0);
-
+	status = lv1_gpu_display_sync(0x0, 1, L1GPU_DISPLAY_SYNC_VSYNC);
 	if (status) {
-		dev_err(&dev->core,
-			"%s: lv1_gpu_context_attribute DISPLAY_SYNC failed: "
-			"%d\n",
+		dev_err(&dev->core, "%s: lv1_gpu_display_sync failed: %d\n",
 			__func__, status);
 		retval = -ENODEV;
 		goto err_close_device;
@@ -1070,7 +1045,7 @@ static int __devinit ps3fb_probe(struct ps3_system_bus_device *dev)
 					  &lpar_reports, &lpar_reports_size);
 	if (status) {
 		dev_err(&dev->core,
-			"%s: lv1_gpu_context_attribute failed: %d\n", __func__,
+			"%s: lv1_gpu_context_allocate failed: %d\n", __func__,
 			status);
 		goto err_gpu_memory_free;
 	}
@@ -1136,13 +1111,10 @@ static int __devinit ps3fb_probe(struct ps3_system_bus_device *dev)
 		ps3fb_videomemory.address, GPU_IOIF, xdr_lpar,
 		ps3fb_videomemory.size);
 
-	status = lv1_gpu_context_attribute(ps3fb.context_handle,
-					   L1GPU_CONTEXT_ATTRIBUTE_FB_SETUP,
-					   xdr_lpar, GPU_CMD_BUF_SIZE,
-					   GPU_IOIF, 0);
+	status = lv1_gpu_fb_setup(ps3fb.context_handle, xdr_lpar,
+				  GPU_CMD_BUF_SIZE, GPU_IOIF);
 	if (status) {
-		dev_err(&dev->core,
-			"%s: lv1_gpu_context_attribute FB_SETUP failed: %d\n",
+		dev_err(&dev->core, "%s: lv1_gpu_fb_setup failed: %d\n",
 			__func__, status);
 		retval = -ENXIO;
 		goto err_context_unmap;
-- 
1.6.2.4

