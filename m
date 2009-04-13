Return-Path: <linux-kernel-owner+w=401wt.eu-S1754542AbZDMQ2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542AbZDMQ2g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 12:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752569AbZDMQ20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 12:28:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:48523 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546AbZDMQ2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 12:28:21 -0400
Subject: [PATCH] radeon_cp: use request_firmware
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: martin@valinux.com, gareth@valinux.com, airlied@linux.ie,
       dri-devel@lists.sourceforge.net, David Woodhouse <dwmw2@infradead.org>,
       Ben Hutchings <bhutchings@solarflare.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 13 Apr 2009 21:57:47 +0530
Message-Id: <1239640067.3237.4.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moved datah before datal because datah is required before datal.

Firmware blob looks like this...
	__be32 datah
	__be32 datal

Thanks to Ben for help and testing.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 drivers/gpu/drm/radeon/radeon_cp.c        |  123 ++-
 drivers/gpu/drm/radeon/radeon_drv.h       |    5 +
 drivers/gpu/drm/radeon/radeon_microcode.h | 1844 -----------------------------
 firmware/Makefile                         |    4 +
 firmware/WHENCE                           |   40 +
 firmware/radeon/R100_cp.bin.ihex          |  130 ++
 firmware/radeon/R200_cp.bin.ihex          |  130 ++
 firmware/radeon/R300_cp.bin.ihex          |  130 ++
 firmware/radeon/R420_cp.bin.ihex          |  130 ++
 firmware/radeon/R520_cp.bin.ihex          |  130 ++
 firmware/radeon/RS600_cp.bin.ihex         |  130 ++
 firmware/radeon/RS690_cp.bin.ihex         |  130 ++
 12 files changed, 1037 insertions(+), 1889 deletions(-)
 delete mode 100644 drivers/gpu/drm/radeon/radeon_microcode.h
 create mode 100644 firmware/radeon/R100_cp.bin.ihex
 create mode 100644 firmware/radeon/R200_cp.bin.ihex
 create mode 100644 firmware/radeon/R300_cp.bin.ihex
 create mode 100644 firmware/radeon/R420_cp.bin.ihex
 create mode 100644 firmware/radeon/R520_cp.bin.ihex
 create mode 100644 firmware/radeon/RS600_cp.bin.ihex
 create mode 100644 firmware/radeon/RS690_cp.bin.ihex

diff --git a/drivers/gpu/drm/radeon/radeon_cp.c b/drivers/gpu/drm/radeon/radeon_cp.c
index 77a7a4d..36bd50a 100644
--- a/drivers/gpu/drm/radeon/radeon_cp.c
+++ b/drivers/gpu/drm/radeon/radeon_cp.c
@@ -36,10 +36,25 @@
 #include "radeon_drv.h"
 #include "r300_reg.h"
 
-#include "radeon_microcode.h"
-
 #define RADEON_FIFO_DEBUG	0
 
+/* Firmware Name */
+#define FIRMWARE_R100		"radeon/R100_cp.bin"
+#define FIRMWARE_R200		"radeon/R200_cp.bin"
+#define FIRMWARE_R300		"radeon/R300_cp.bin"
+#define FIRMWARE_R420		"radeon/R420_cp.bin"
+#define FIRMWARE_RS600		"radeon/RS600_cp.bin"
+#define FIRMWARE_RS690		"radeon/RS690_cp.bin"
+#define FIRMWARE_R520		"radeon/R520_cp.bin"
+
+MODULE_FIRMWARE(FIRMWARE_R100);
+MODULE_FIRMWARE(FIRMWARE_R200);
+MODULE_FIRMWARE(FIRMWARE_R300);
+MODULE_FIRMWARE(FIRMWARE_R420);
+MODULE_FIRMWARE(FIRMWARE_RS600);
+MODULE_FIRMWARE(FIRMWARE_RS690);
+MODULE_FIRMWARE(FIRMWARE_R520);
+
 static int radeon_do_cleanup_cp(struct drm_device * dev);
 static void radeon_do_cp_start(drm_radeon_private_t * dev_priv);
 
@@ -451,12 +466,19 @@ static void radeon_init_pipes(drm_radeon_private_t *dev_priv)
  */
 
 /* Load the microcode for the CP */
-static void radeon_cp_load_microcode(drm_radeon_private_t * dev_priv)
+static int radeon_cp_init_microcode(drm_radeon_private_t *dev_priv)
 {
-	int i;
-	DRM_DEBUG("\n");
+	struct platform_device *pdev;
+	const char *fw_name = NULL;
+	int err;
 
-	radeon_do_wait_for_idle(dev_priv);
+	DRM_DEBUG("\n");
+	pdev = platform_device_register_simple("radeon_cp", 0, NULL, 0);
+	err = IS_ERR(pdev);
+	if (err) {
+		DRM_ERROR("radeon_cp: Failed to register firmware\n");
+		return -EINVAL;
+	}
 
 	RADEON_WRITE(RADEON_CP_ME_RAM_ADDR, 0);
 	if (((dev_priv->flags & RADEON_FAMILY_MASK) == CHIP_R100) ||
@@ -465,23 +487,13 @@ static void radeon_cp_load_microcode(drm_radeon_private_t * dev_priv)
 	    ((dev_priv->flags & RADEON_FAMILY_MASK) == CHIP_RS100) ||
 	    ((dev_priv->flags & RADEON_FAMILY_MASK) == CHIP_RS200)) {
 		DRM_INFO("Loading R100 Microcode\n");
-		for (i = 0; i < 256; i++) {
-			RADEON_WRITE(RADEON_CP_ME_RAM_DATAH,
-				     R100_cp_microcode[i][1]);
-			RADEON_WRITE(RADEON_CP_ME_RAM_DATAL,
-				     R100_cp_microcode[i][0]);
-		}
+		fw_name = FIRMWARE_R100;
 	} else if (((dev_priv->flags & RADEON_FAMILY_MASK) == CHIP_R200) ||
 		   ((dev_priv->flags & RADEON_FAMILY_MASK) == CHIP_RV250) ||
 		   ((dev_priv->flags & RADEON_FAMILY_MASK) == CHIP_RV280) ||
 		   ((dev_priv->flags & RADEON_FAMILY_MASK) == CHIP_RS300)) {
 		DRM_INFO("Loading R200 Microcode\n");
-		for (i = 0; i < 256; i++) {
-			RADEON_WRITE(RADEON_CP_ME_RAM_DATAH,
-				     R200_cp_microcode[i][1]);
-			RADEON_WRITE(RADEON_CP_ME_RAM_DATAL,
-				     R200_cp_microcode[i][0]);
-		}
+		fw_name = FIRMWARE_R200;
 	} else if (((dev_priv->flags & RADEON_FAMILY_MASK) == CHIP_R300) ||
 		   ((dev_priv->flags & RADEON_FAMILY_MASK) == CHIP_R350) ||
 		   ((dev_priv->flags & RADEON_FAMILY_MASK) == CHIP_RV350) ||
@@ -489,39 +501,19 @@ static void radeon_cp_load_microcode(drm_radeon_private_t * dev_priv)
 		   ((dev_priv->flags & RADEON_FAMILY_MASK) == CHIP_RS400) ||
 		   ((dev_priv->flags & RADEON_FAMILY_MASK) == CHIP_RS480)) {
 		DRM_INFO("Loading R300 Microcode\n");
-		for (i = 0; i < 256; i++) {
-			RADEON_WRITE(RADEON_CP_ME_RAM_DATAH,
-				     R300_cp_microcode[i][1]);
-			RADEON_WRITE(RADEON_CP_ME_RAM_DATAL,
-				     R300_cp_microcode[i][0]);
-		}
+		fw_name = FIRMWARE_R300;
 	} else if (((dev_priv->flags & RADEON_FAMILY_MASK) == CHIP_R420) ||
 		   ((dev_priv->flags & RADEON_FAMILY_MASK) == CHIP_R423) ||
 		   ((dev_priv->flags & RADEON_FAMILY_MASK) == CHIP_RV410)) {
 		DRM_INFO("Loading R400 Microcode\n");
-		for (i = 0; i < 256; i++) {
-			RADEON_WRITE(RADEON_CP_ME_RAM_DATAH,
-				     R420_cp_microcode[i][1]);
-			RADEON_WRITE(RADEON_CP_ME_RAM_DATAL,
-				     R420_cp_microcode[i][0]);
-		}
+		fw_name = FIRMWARE_R420;
 	} else if (((dev_priv->flags & RADEON_FAMILY_MASK) == CHIP_RS690) ||
 		   ((dev_priv->flags & RADEON_FAMILY_MASK) == CHIP_RS740)) {
 		DRM_INFO("Loading RS690/RS740 Microcode\n");
-		for (i = 0; i < 256; i++) {
-			RADEON_WRITE(RADEON_CP_ME_RAM_DATAH,
-				     RS690_cp_microcode[i][1]);
-			RADEON_WRITE(RADEON_CP_ME_RAM_DATAL,
-				     RS690_cp_microcode[i][0]);
-		}
+		fw_name = FIRMWARE_RS690;
 	} else if ((dev_priv->flags & RADEON_FAMILY_MASK) == CHIP_RS600) {
 		DRM_INFO("Loading RS600 Microcode\n");
-		for (i = 0; i < 256; i++) {
-			RADEON_WRITE(RADEON_CP_ME_RAM_DATAH,
-				     RS600_cp_microcode[i][1]);
-			RADEON_WRITE(RADEON_CP_ME_RAM_DATAL,
-				     RS600_cp_microcode[i][0]);
-		}
+		fw_name = FIRMWARE_RS600;
 	} else if (((dev_priv->flags & RADEON_FAMILY_MASK) == CHIP_RV515) ||
 		   ((dev_priv->flags & RADEON_FAMILY_MASK) == CHIP_R520) ||
 		   ((dev_priv->flags & RADEON_FAMILY_MASK) == CHIP_RV530) ||
@@ -529,11 +521,39 @@ static void radeon_cp_load_microcode(drm_radeon_private_t * dev_priv)
 		   ((dev_priv->flags & RADEON_FAMILY_MASK) == CHIP_RV560) ||
 		   ((dev_priv->flags & RADEON_FAMILY_MASK) == CHIP_RV570)) {
 		DRM_INFO("Loading R500 Microcode\n");
-		for (i = 0; i < 256; i++) {
+		fw_name = FIRMWARE_R520;
+	}
+
+	err = request_firmware(&dev_priv->fw, fw_name, &pdev->dev);
+	platform_device_unregister(pdev);
+	if (err)
+		pr_err("radeon_cp: Failed to load firmware \"%s\"\n", fw_name);
+	else if (dev_priv->fw->size % 8) {
+		pr_err("radeon_cp: Bogus length %zu in firmware \"%s\"\n",
+			dev_priv->fw->size, fw_name);
+		err = -EINVAL;
+		release_firmware(dev_priv->fw);
+		dev_priv->fw = NULL;
+	}
+	return err;
+}
+
+static void radeon_cp_load_microcode(drm_radeon_private_t *dev_priv)
+{
+	const __be32 *fw_data;
+	int i, size;
+
+	radeon_do_wait_for_idle(dev_priv);
+
+	if (dev_priv->fw) {
+		size = dev_priv->fw->size / 4;
+		fw_data = (const __be32 *)&dev_priv->fw->data[0];
+		RADEON_WRITE(RADEON_CP_ME_RAM_ADDR, 0);
+		for (i = 0; i < size; i += 2) {
 			RADEON_WRITE(RADEON_CP_ME_RAM_DATAH,
-				     R520_cp_microcode[i][1]);
+				     be32_to_cpup(&fw_data[i]));
 			RADEON_WRITE(RADEON_CP_ME_RAM_DATAL,
-				     R520_cp_microcode[i][0]);
+				     be32_to_cpup(&fw_data[i + 1]));
 		}
 	}
 }
@@ -1486,6 +1506,14 @@ static int radeon_do_init_cp(struct drm_device *dev, drm_radeon_init_t *init,
 		radeon_set_pcigart(dev_priv, 1);
 	}
 
+	if (!dev_priv->fw) {
+		int err = radeon_cp_init_microcode(dev_priv);
+		if (err) {
+			DRM_ERROR("Failed to load firmware!\n");
+			radeon_do_cleanup_cp(dev);
+			return err;
+		}
+	}
 	radeon_cp_load_microcode(dev_priv);
 	radeon_cp_init_ring_buffer(dev, dev_priv, file_priv);
 
@@ -1755,6 +1783,11 @@ void radeon_do_release(struct drm_device * dev)
 			r600_do_cleanup_cp(dev);
 		else
 			radeon_do_cleanup_cp(dev);
+
+		if (dev_priv->fw) {
+			release_firmware(dev_priv->fw);
+			dev_priv->fw = NULL;
+		}
 	}
 }
 
diff --git a/drivers/gpu/drm/radeon/radeon_drv.h b/drivers/gpu/drm/radeon/radeon_drv.h
index ed4d27e..829eefa 100644
--- a/drivers/gpu/drm/radeon/radeon_drv.h
+++ b/drivers/gpu/drm/radeon/radeon_drv.h
@@ -31,6 +31,9 @@
 #ifndef __RADEON_DRV_H__
 #define __RADEON_DRV_H__
 
+#include <linux/firmware.h>
+#include <linux/platform_device.h>
+
 /* General customization:
  */
 
@@ -348,6 +351,8 @@ typedef struct drm_radeon_private {
 	int r700_sc_hiz_tile_fifo_size;
 	int r700_sc_earlyz_tile_fifo_fize;
 
+	/* firmware */
+	const struct firmware *fw;
 } drm_radeon_private_t;
 
 typedef struct drm_radeon_buf_priv {
diff --git a/drivers/gpu/drm/radeon/radeon_microcode.h b/drivers/gpu/drm/radeon/radeon_microcode.h
deleted file mode 100644
index a348c9e..0000000
--- a/drivers/gpu/drm/radeon/radeon_microcode.h
+++ /dev/null
@@ -1,1844 +0,0 @@
-/*
- * Copyright 2007 Advanced Micro Devices, Inc.
- * All Rights Reserved.
- *
- * Permission is hereby granted, free of charge, to any person obtaining a
- * copy of this software and associated documentation files (the "Software"),
- * to deal in the Software without restriction, including without limitation
- * the rights to use, copy, modify, merge, publish, distribute, sublicense,
- * and/or sell copies of the Software, and to permit persons to whom the
- * Software is furnished to do so, subject to the following conditions:
- *
- * The above copyright notice and this permission notice (including the next
- * paragraph) shall be included in all copies or substantial portions of the
- * Software.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
- * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
- * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
- * IN NO EVENT SHALL THE COPYRIGHT OWNER(S) AND/OR ITS SUPPLIERS BE
- * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
- * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
- * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
- *
- */
-
-#ifndef RADEON_MICROCODE_H
-#define RADEON_MICROCODE_H
-
-/* production radeon ucode r1xx-r6xx */
-static const u32 R100_cp_microcode[][2] = {
-    { 0x21007000, 0000000000 },
-    { 0x20007000, 0000000000 },
-    { 0x000000b4, 0x00000004 },
-    { 0x000000b8, 0x00000004 },
-    { 0x6f5b4d4c, 0000000000 },
-    { 0x4c4c427f, 0000000000 },
-    { 0x5b568a92, 0000000000 },
-    { 0x4ca09c6d, 0000000000 },
-    { 0xad4c4c4c, 0000000000 },
-    { 0x4ce1af3d, 0000000000 },
-    { 0xd8afafaf, 0000000000 },
-    { 0xd64c4cdc, 0000000000 },
-    { 0x4cd10d10, 0000000000 },
-    { 0x000f0000, 0x00000016 },
-    { 0x362f242d, 0000000000 },
-    { 0x00000012, 0x00000004 },
-    { 0x000f0000, 0x00000016 },
-    { 0x362f282d, 0000000000 },
-    { 0x000380e7, 0x00000002 },
-    { 0x04002c97, 0x00000002 },
-    { 0x000f0001, 0x00000016 },
-    { 0x333a3730, 0000000000 },
-    { 0x000077ef, 0x00000002 },
-    { 0x00061000, 0x00000002 },
-    { 0x00000021, 0x0000001a },
-    { 0x00004000, 0x0000001e },
-    { 0x00061000, 0x00000002 },
-    { 0x00000021, 0x0000001a },
-    { 0x00004000, 0x0000001e },
-    { 0x00061000, 0x00000002 },
-    { 0x00000021, 0x0000001a },
-    { 0x00004000, 0x0000001e },
-    { 0x00000017, 0x00000004 },
-    { 0x0003802b, 0x00000002 },
-    { 0x040067e0, 0x00000002 },
-    { 0x00000017, 0x00000004 },
-    { 0x000077e0, 0x00000002 },
-    { 0x00065000, 0x00000002 },
-    { 0x000037e1, 0x00000002 },
-    { 0x040067e1, 0x00000006 },
-    { 0x000077e0, 0x00000002 },
-    { 0x000077e1, 0x00000002 },
-    { 0x000077e1, 0x00000006 },
-    { 0xffffffff, 0000000000 },
-    { 0x10000000, 0000000000 },
-    { 0x0003802b, 0x00000002 },
-    { 0x040067e0, 0x00000006 },
-    { 0x00007675, 0x00000002 },
-    { 0x00007676, 0x00000002 },
-    { 0x00007677, 0x00000002 },
-    { 0x00007678, 0x00000006 },
-    { 0x0003802c, 0x00000002 },
-    { 0x04002676, 0x00000002 },
-    { 0x00007677, 0x00000002 },
-    { 0x00007678, 0x00000006 },
-    { 0x0000002f, 0x00000018 },
-    { 0x0000002f, 0x00000018 },
-    { 0000000000, 0x00000006 },
-    { 0x00000030, 0x00000018 },
-    { 0x00000030, 0x00000018 },
-    { 0000000000, 0x00000006 },
-    { 0x01605000, 0x00000002 },
-    { 0x00065000, 0x00000002 },
-    { 0x00098000, 0x00000002 },
-    { 0x00061000, 0x00000002 },
-    { 0x64c0603e, 0x00000004 },
-    { 0x000380e6, 0x00000002 },
-    { 0x040025c5, 0x00000002 },
-    { 0x00080000, 0x00000016 },
-    { 0000000000, 0000000000 },
-    { 0x0400251d, 0x00000002 },
-    { 0x00007580, 0x00000002 },
-    { 0x00067581, 0x00000002 },
-    { 0x04002580, 0x00000002 },
-    { 0x00067581, 0x00000002 },
-    { 0x00000049, 0x00000004 },
-    { 0x00005000, 0000000000 },
-    { 0x000380e6, 0x00000002 },
-    { 0x040025c5, 0x00000002 },
-    { 0x00061000, 0x00000002 },
-    { 0x0000750e, 0x00000002 },
-    { 0x00019000, 0x00000002 },
-    { 0x00011055, 0x00000014 },
-    { 0x00000055, 0x00000012 },
-    { 0x0400250f, 0x00000002 },
-    { 0x0000504f, 0x00000004 },
-    { 0x000380e6, 0x00000002 },
-    { 0x040025c5, 0x00000002 },
-    { 0x00007565, 0x00000002 },
-    { 0x00007566, 0x00000002 },
-    { 0x00000058, 0x00000004 },
-    { 0x000380e6, 0x00000002 },
-    { 0x040025c5, 0x00000002 },
-    { 0x01e655b4, 0x00000002 },
-    { 0x4401b0e4, 0x00000002 },
-    { 0x01c110e4, 0x00000002 },
-    { 0x26667066, 0x00000018 },
-    { 0x040c2565, 0x00000002 },
-    { 0x00000066, 0x00000018 },
-    { 0x04002564, 0x00000002 },
-    { 0x00007566, 0x00000002 },
-    { 0x0000005d, 0x00000004 },
-    { 0x00401069, 0x00000008 },
-    { 0x00101000, 0x00000002 },
-    { 0x000d80ff, 0x00000002 },
-    { 0x0080006c, 0x00000008 },
-    { 0x000f9000, 0x00000002 },
-    { 0x000e00ff, 0x00000002 },
-    { 0000000000, 0x00000006 },
-    { 0x0000008f, 0x00000018 },
-    { 0x0000005b, 0x00000004 },
-    { 0x000380e6, 0x00000002 },
-    { 0x040025c5, 0x00000002 },
-    { 0x00007576, 0x00000002 },
-    { 0x00065000, 0x00000002 },
-    { 0x00009000, 0x00000002 },
-    { 0x00041000, 0x00000002 },
-    { 0x0c00350e, 0x00000002 },
-    { 0x00049000, 0x00000002 },
-    { 0x00051000, 0x00000002 },
-    { 0x01e785f8, 0x00000002 },
-    { 0x00200000, 0x00000002 },
-    { 0x0060007e, 0x0000000c },
-    { 0x00007563, 0x00000002 },
-    { 0x006075f0, 0x00000021 },
-    { 0x20007073, 0x00000004 },
-    { 0x00005073, 0x00000004 },
-    { 0x000380e6, 0x00000002 },
-    { 0x040025c5, 0x00000002 },
-    { 0x00007576, 0x00000002 },
-    { 0x00007577, 0x00000002 },
-    { 0x0000750e, 0x00000002 },
-    { 0x0000750f, 0x00000002 },
-    { 0x00a05000, 0x00000002 },
-    { 0x00600083, 0x0000000c },
-    { 0x006075f0, 0x00000021 },
-    { 0x000075f8, 0x00000002 },
-    { 0x00000083, 0x00000004 },
-    { 0x000a750e, 0x00000002 },
-    { 0x000380e6, 0x00000002 },
-    { 0x040025c5, 0x00000002 },
-    { 0x0020750f, 0x00000002 },
-    { 0x00600086, 0x00000004 },
-    { 0x00007570, 0x00000002 },
-    { 0x00007571, 0x00000002 },
-    { 0x00007572, 0x00000006 },
-    { 0x000380e6, 0x00000002 },
-    { 0x040025c5, 0x00000002 },
-    { 0x00005000, 0x00000002 },
-    { 0x00a05000, 0x00000002 },
-    { 0x00007568, 0x00000002 },
-    { 0x00061000, 0x00000002 },
-    { 0x00000095, 0x0000000c },
-    { 0x00058000, 0x00000002 },
-    { 0x0c607562, 0x00000002 },
-    { 0x00000097, 0x00000004 },
-    { 0x000380e6, 0x00000002 },
-    { 0x040025c5, 0x00000002 },
-    { 0x00600096, 0x00000004 },
-    { 0x400070e5, 0000000000 },
-    { 0x000380e6, 0x00000002 },
-    { 0x040025c5, 0x00000002 },
-    { 0x000380e5, 0x00000002 },
-    { 0x000000a8, 0x0000001c },
-    { 0x000650aa, 0x00000018 },
-    { 0x040025bb, 0x00000002 },
-    { 0x000610ab, 0x00000018 },
-    { 0x040075bc, 0000000000 },
-    { 0x000075bb, 0x00000002 },
-    { 0x000075bc, 0000000000 },
-    { 0x00090000, 0x00000006 },
-    { 0x00090000, 0x00000002 },
-    { 0x000d8002, 0x00000006 },
-    { 0x00007832, 0x00000002 },
-    { 0x00005000, 0x00000002 },
-    { 0x000380e7, 0x00000002 },
-    { 0x04002c97, 0x00000002 },
-    { 0x00007820, 0x00000002 },
-    { 0x00007821, 0x00000002 },
-    { 0x00007800, 0000000000 },
-    { 0x01200000, 0x00000002 },
-    { 0x20077000, 0x00000002 },
-    { 0x01200000, 0x00000002 },
-    { 0x20007000, 0x00000002 },
-    { 0x00061000, 0x00000002 },
-    { 0x0120751b, 0x00000002 },
-    { 0x8040750a, 0x00000002 },
-    { 0x8040750b, 0x00000002 },
-    { 0x00110000, 0x00000002 },
-    { 0x000380e5, 0x00000002 },
-    { 0x000000c6, 0x0000001c },
-    { 0x000610ab, 0x00000018 },
-    { 0x844075bd, 0x00000002 },
-    { 0x000610aa, 0x00000018 },
-    { 0x840075bb, 0x00000002 },
-    { 0x000610ab, 0x00000018 },
-    { 0x844075bc, 0x00000002 },
-    { 0x000000c9, 0x00000004 },
-    { 0x804075bd, 0x00000002 },
-    { 0x800075bb, 0x00000002 },
-    { 0x804075bc, 0x00000002 },
-    { 0x00108000, 0x00000002 },
-    { 0x01400000, 0x00000002 },
-    { 0x006000cd, 0x0000000c },
-    { 0x20c07000, 0x00000020 },
-    { 0x000000cf, 0x00000012 },
-    { 0x00800000, 0x00000006 },
-    { 0x0080751d, 0x00000006 },
-    { 0000000000, 0000000000 },
-    { 0x0000775c, 0x00000002 },
-    { 0x00a05000, 0x00000002 },
-    { 0x00661000, 0x00000002 },
-    { 0x0460275d, 0x00000020 },
-    { 0x00004000, 0000000000 },
-    { 0x01e00830, 0x00000002 },
-    { 0x21007000, 0000000000 },
-    { 0x6464614d, 0000000000 },
-    { 0x69687420, 0000000000 },
-    { 0x00000073, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0x00005000, 0x00000002 },
-    { 0x000380d0, 0x00000002 },
-    { 0x040025e0, 0x00000002 },
-    { 0x000075e1, 0000000000 },
-    { 0x00000001, 0000000000 },
-    { 0x000380e0, 0x00000002 },
-    { 0x04002394, 0x00000002 },
-    { 0x00005000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0x00000008, 0000000000 },
-    { 0x00000004, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-};
-
-static const u32 R200_cp_microcode[][2] = {
-    { 0x21007000, 0000000000 },
-    { 0x20007000, 0000000000 },
-    { 0x000000bf, 0x00000004 },
-    { 0x000000c3, 0x00000004 },
-    { 0x7a685e5d, 0000000000 },
-    { 0x5d5d5588, 0000000000 },
-    { 0x68659197, 0000000000 },
-    { 0x5da19f78, 0000000000 },
-    { 0x5d5d5d5d, 0000000000 },
-    { 0x5dee5d50, 0000000000 },
-    { 0xf2acacac, 0000000000 },
-    { 0xe75df9e9, 0000000000 },
-    { 0xb1dd0e11, 0000000000 },
-    { 0xe2afafaf, 0000000000 },
-    { 0x000f0000, 0x00000016 },
-    { 0x452f232d, 0000000000 },
-    { 0x00000013, 0x00000004 },
-    { 0x000f0000, 0x00000016 },
-    { 0x452f272d, 0000000000 },
-    { 0x000f0001, 0x00000016 },
-    { 0x3e4d4a37, 0000000000 },
-    { 0x000077ef, 0x00000002 },
-    { 0x00061000, 0x00000002 },
-    { 0x00000020, 0x0000001a },
-    { 0x00004000, 0x0000001e },
-    { 0x00061000, 0x00000002 },
-    { 0x00000020, 0x0000001a },
-    { 0x00004000, 0x0000001e },
-    { 0x00061000, 0x00000002 },
-    { 0x00000020, 0x0000001a },
-    { 0x00004000, 0x0000001e },
-    { 0x00000016, 0x00000004 },
-    { 0x0003802a, 0x00000002 },
-    { 0x040067e0, 0x00000002 },
-    { 0x00000016, 0x00000004 },
-    { 0x000077e0, 0x00000002 },
-    { 0x00065000, 0x00000002 },
-    { 0x000037e1, 0x00000002 },
-    { 0x040067e1, 0x00000006 },
-    { 0x000077e0, 0x00000002 },
-    { 0x000077e1, 0x00000002 },
-    { 0x000077e1, 0x00000006 },
-    { 0xffffffff, 0000000000 },
-    { 0x10000000, 0000000000 },
-    { 0x07f007f0, 0000000000 },
-    { 0x0003802a, 0x00000002 },
-    { 0x040067e0, 0x00000006 },
-    { 0x0003802c, 0x00000002 },
-    { 0x04002741, 0x00000002 },
-    { 0x04002741, 0x00000002 },
-    { 0x04002743, 0x00000002 },
-    { 0x00007675, 0x00000002 },
-    { 0x00007676, 0x00000002 },
-    { 0x00007677, 0x00000002 },
-    { 0x00007678, 0x00000006 },
-    { 0x0003802c, 0x00000002 },
-    { 0x04002741, 0x00000002 },
-    { 0x04002741, 0x00000002 },
-    { 0x04002743, 0x00000002 },
-    { 0x00007676, 0x00000002 },
-    { 0x00007677, 0x00000002 },
-    { 0x00007678, 0x00000006 },
-    { 0x0003802b, 0x00000002 },
-    { 0x04002676, 0x00000002 },
-    { 0x00007677, 0x00000002 },
-    { 0x0003802c, 0x00000002 },
-    { 0x04002741, 0x00000002 },
-    { 0x04002743, 0x00000002 },
-    { 0x00007678, 0x00000006 },
-    { 0x0003802c, 0x00000002 },
-    { 0x04002741, 0x00000002 },
-    { 0x04002741, 0x00000002 },
-    { 0x04002743, 0x00000002 },
-    { 0x00007678, 0x00000006 },
-    { 0x0000002f, 0x00000018 },
-    { 0x0000002f, 0x00000018 },
-    { 0000000000, 0x00000006 },
-    { 0x00000037, 0x00000018 },
-    { 0x00000037, 0x00000018 },
-    { 0000000000, 0x00000006 },
-    { 0x01605000, 0x00000002 },
-    { 0x00065000, 0x00000002 },
-    { 0x00098000, 0x00000002 },
-    { 0x00061000, 0x00000002 },
-    { 0x64c06051, 0x00000004 },
-    { 0x00080000, 0x00000016 },
-    { 0000000000, 0000000000 },
-    { 0x0400251d, 0x00000002 },
-    { 0x00007580, 0x00000002 },
-    { 0x00067581, 0x00000002 },
-    { 0x04002580, 0x00000002 },
-    { 0x00067581, 0x00000002 },
-    { 0x0000005a, 0x00000004 },
-    { 0x00005000, 0000000000 },
-    { 0x00061000, 0x00000002 },
-    { 0x0000750e, 0x00000002 },
-    { 0x00019000, 0x00000002 },
-    { 0x00011064, 0x00000014 },
-    { 0x00000064, 0x00000012 },
-    { 0x0400250f, 0x00000002 },
-    { 0x0000505e, 0x00000004 },
-    { 0x00007565, 0x00000002 },
-    { 0x00007566, 0x00000002 },
-    { 0x00000065, 0x00000004 },
-    { 0x01e655b4, 0x00000002 },
-    { 0x4401b0f0, 0x00000002 },
-    { 0x01c110f0, 0x00000002 },
-    { 0x26667071, 0x00000018 },
-    { 0x040c2565, 0x00000002 },
-    { 0x00000071, 0x00000018 },
-    { 0x04002564, 0x00000002 },
-    { 0x00007566, 0x00000002 },
-    { 0x00000068, 0x00000004 },
-    { 0x00401074, 0x00000008 },
-    { 0x00101000, 0x00000002 },
-    { 0x000d80ff, 0x00000002 },
-    { 0x00800077, 0x00000008 },
-    { 0x000f9000, 0x00000002 },
-    { 0x000e00ff, 0x00000002 },
-    { 0000000000, 0x00000006 },
-    { 0x00000094, 0x00000018 },
-    { 0x00000068, 0x00000004 },
-    { 0x00007576, 0x00000002 },
-    { 0x00065000, 0x00000002 },
-    { 0x00009000, 0x00000002 },
-    { 0x00041000, 0x00000002 },
-    { 0x0c00350e, 0x00000002 },
-    { 0x00049000, 0x00000002 },
-    { 0x00051000, 0x00000002 },
-    { 0x01e785f8, 0x00000002 },
-    { 0x00200000, 0x00000002 },
-    { 0x00600087, 0x0000000c },
-    { 0x00007563, 0x00000002 },
-    { 0x006075f0, 0x00000021 },
-    { 0x2000707c, 0x00000004 },
-    { 0x0000507c, 0x00000004 },
-    { 0x00007576, 0x00000002 },
-    { 0x00007577, 0x00000002 },
-    { 0x0000750e, 0x00000002 },
-    { 0x0000750f, 0x00000002 },
-    { 0x00a05000, 0x00000002 },
-    { 0x0060008a, 0x0000000c },
-    { 0x006075f0, 0x00000021 },
-    { 0x000075f8, 0x00000002 },
-    { 0x0000008a, 0x00000004 },
-    { 0x000a750e, 0x00000002 },
-    { 0x0020750f, 0x00000002 },
-    { 0x0060008d, 0x00000004 },
-    { 0x00007570, 0x00000002 },
-    { 0x00007571, 0x00000002 },
-    { 0x00007572, 0x00000006 },
-    { 0x00005000, 0x00000002 },
-    { 0x00a05000, 0x00000002 },
-    { 0x00007568, 0x00000002 },
-    { 0x00061000, 0x00000002 },
-    { 0x00000098, 0x0000000c },
-    { 0x00058000, 0x00000002 },
-    { 0x0c607562, 0x00000002 },
-    { 0x0000009a, 0x00000004 },
-    { 0x00600099, 0x00000004 },
-    { 0x400070f1, 0000000000 },
-    { 0x000380f1, 0x00000002 },
-    { 0x000000a7, 0x0000001c },
-    { 0x000650a9, 0x00000018 },
-    { 0x040025bb, 0x00000002 },
-    { 0x000610aa, 0x00000018 },
-    { 0x040075bc, 0000000000 },
-    { 0x000075bb, 0x00000002 },
-    { 0x000075bc, 0000000000 },
-    { 0x00090000, 0x00000006 },
-    { 0x00090000, 0x00000002 },
-    { 0x000d8002, 0x00000006 },
-    { 0x00005000, 0x00000002 },
-    { 0x00007821, 0x00000002 },
-    { 0x00007800, 0000000000 },
-    { 0x00007821, 0x00000002 },
-    { 0x00007800, 0000000000 },
-    { 0x01665000, 0x00000002 },
-    { 0x000a0000, 0x00000002 },
-    { 0x000671cc, 0x00000002 },
-    { 0x0286f1cd, 0x00000002 },
-    { 0x000000b7, 0x00000010 },
-    { 0x21007000, 0000000000 },
-    { 0x000000be, 0x0000001c },
-    { 0x00065000, 0x00000002 },
-    { 0x000a0000, 0x00000002 },
-    { 0x00061000, 0x00000002 },
-    { 0x000b0000, 0x00000002 },
-    { 0x38067000, 0x00000002 },
-    { 0x000a00ba, 0x00000004 },
-    { 0x20007000, 0000000000 },
-    { 0x01200000, 0x00000002 },
-    { 0x20077000, 0x00000002 },
-    { 0x01200000, 0x00000002 },
-    { 0x20007000, 0000000000 },
-    { 0x00061000, 0x00000002 },
-    { 0x0120751b, 0x00000002 },
-    { 0x8040750a, 0x00000002 },
-    { 0x8040750b, 0x00000002 },
-    { 0x00110000, 0x00000002 },
-    { 0x000380f1, 0x00000002 },
-    { 0x000000d1, 0x0000001c },
-    { 0x000610aa, 0x00000018 },
-    { 0x844075bd, 0x00000002 },
-    { 0x000610a9, 0x00000018 },
-    { 0x840075bb, 0x00000002 },
-    { 0x000610aa, 0x00000018 },
-    { 0x844075bc, 0x00000002 },
-    { 0x000000d4, 0x00000004 },
-    { 0x804075bd, 0x00000002 },
-    { 0x800075bb, 0x00000002 },
-    { 0x804075bc, 0x00000002 },
-    { 0x00108000, 0x00000002 },
-    { 0x01400000, 0x00000002 },
-    { 0x006000d8, 0x0000000c },
-    { 0x20c07000, 0x00000020 },
-    { 0x000000da, 0x00000012 },
-    { 0x00800000, 0x00000006 },
-    { 0x0080751d, 0x00000006 },
-    { 0x000025bb, 0x00000002 },
-    { 0x000040d4, 0x00000004 },
-    { 0x0000775c, 0x00000002 },
-    { 0x00a05000, 0x00000002 },
-    { 0x00661000, 0x00000002 },
-    { 0x0460275d, 0x00000020 },
-    { 0x00004000, 0000000000 },
-    { 0x00007999, 0x00000002 },
-    { 0x00a05000, 0x00000002 },
-    { 0x00661000, 0x00000002 },
-    { 0x0460299b, 0x00000020 },
-    { 0x00004000, 0000000000 },
-    { 0x01e00830, 0x00000002 },
-    { 0x21007000, 0000000000 },
-    { 0x00005000, 0x00000002 },
-    { 0x00038056, 0x00000002 },
-    { 0x040025e0, 0x00000002 },
-    { 0x000075e1, 0000000000 },
-    { 0x00000001, 0000000000 },
-    { 0x000380ed, 0x00000002 },
-    { 0x04007394, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0x000078c4, 0x00000002 },
-    { 0x000078c5, 0x00000002 },
-    { 0x000078c6, 0x00000002 },
-    { 0x00007924, 0x00000002 },
-    { 0x00007925, 0x00000002 },
-    { 0x00007926, 0x00000002 },
-    { 0x000000f2, 0x00000004 },
-    { 0x00007924, 0x00000002 },
-    { 0x00007925, 0x00000002 },
-    { 0x00007926, 0x00000002 },
-    { 0x000000f9, 0x00000004 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-};
-
-static const u32 R300_cp_microcode[][2] = {
-    { 0x4200e000, 0000000000 },
-    { 0x4000e000, 0000000000 },
-    { 0x000000ae, 0x00000008 },
-    { 0x000000b2, 0x00000008 },
-    { 0x67554b4a, 0000000000 },
-    { 0x4a4a4475, 0000000000 },
-    { 0x55527d83, 0000000000 },
-    { 0x4a8c8b65, 0000000000 },
-    { 0x4aef4af6, 0000000000 },
-    { 0x4ae14a4a, 0000000000 },
-    { 0xe4979797, 0000000000 },
-    { 0xdb4aebdd, 0000000000 },
-    { 0x9ccc4a4a, 0000000000 },
-    { 0xd1989898, 0000000000 },
-    { 0x4a0f9ad6, 0000000000 },
-    { 0x000ca000, 0x00000004 },
-    { 0x000d0012, 0x00000038 },
-    { 0x0000e8b4, 0x00000004 },
-    { 0x000d0014, 0x00000038 },
-    { 0x0000e8b6, 0x00000004 },
-    { 0x000d0016, 0x00000038 },
-    { 0x0000e854, 0x00000004 },
-    { 0x000d0018, 0x00000038 },
-    { 0x0000e855, 0x00000004 },
-    { 0x000d001a, 0x00000038 },
-    { 0x0000e856, 0x00000004 },
-    { 0x000d001c, 0x00000038 },
-    { 0x0000e857, 0x00000004 },
-    { 0x000d001e, 0x00000038 },
-    { 0x0000e824, 0x00000004 },
-    { 0x000d0020, 0x00000038 },
-    { 0x0000e825, 0x00000004 },
-    { 0x000d0022, 0x00000038 },
-    { 0x0000e830, 0x00000004 },
-    { 0x000d0024, 0x00000038 },
-    { 0x0000f0c0, 0x00000004 },
-    { 0x000d0026, 0x00000038 },
-    { 0x0000f0c1, 0x00000004 },
-    { 0x000d0028, 0x00000038 },
-    { 0x0000f041, 0x00000004 },
-    { 0x000d002a, 0x00000038 },
-    { 0x0000f184, 0x00000004 },
-    { 0x000d002c, 0x00000038 },
-    { 0x0000f185, 0x00000004 },
-    { 0x000d002e, 0x00000038 },
-    { 0x0000f186, 0x00000004 },
-    { 0x000d0030, 0x00000038 },
-    { 0x0000f187, 0x00000004 },
-    { 0x000d0032, 0x00000038 },
-    { 0x0000f180, 0x00000004 },
-    { 0x000d0034, 0x00000038 },
-    { 0x0000f393, 0x00000004 },
-    { 0x000d0036, 0x00000038 },
-    { 0x0000f38a, 0x00000004 },
-    { 0x000d0038, 0x00000038 },
-    { 0x0000f38e, 0x00000004 },
-    { 0x0000e821, 0x00000004 },
-    { 0x0140a000, 0x00000004 },
-    { 0x00000043, 0x00000018 },
-    { 0x00cce800, 0x00000004 },
-    { 0x001b0001, 0x00000004 },
-    { 0x08004800, 0x00000004 },
-    { 0x001b0001, 0x00000004 },
-    { 0x08004800, 0x00000004 },
-    { 0x001b0001, 0x00000004 },
-    { 0x08004800, 0x00000004 },
-    { 0x0000003a, 0x00000008 },
-    { 0x0000a000, 0000000000 },
-    { 0x2000451d, 0x00000004 },
-    { 0x0000e580, 0x00000004 },
-    { 0x000ce581, 0x00000004 },
-    { 0x08004580, 0x00000004 },
-    { 0x000ce581, 0x00000004 },
-    { 0x00000047, 0x00000008 },
-    { 0x0000a000, 0000000000 },
-    { 0x000c2000, 0x00000004 },
-    { 0x0000e50e, 0x00000004 },
-    { 0x00032000, 0x00000004 },
-    { 0x00022051, 0x00000028 },
-    { 0x00000051, 0x00000024 },
-    { 0x0800450f, 0x00000004 },
-    { 0x0000a04b, 0x00000008 },
-    { 0x0000e565, 0x00000004 },
-    { 0x0000e566, 0x00000004 },
-    { 0x00000052, 0x00000008 },
-    { 0x03cca5b4, 0x00000004 },
-    { 0x05432000, 0x00000004 },
-    { 0x00022000, 0x00000004 },
-    { 0x4ccce05e, 0x00000030 },
-    { 0x08274565, 0x00000004 },
-    { 0x0000005e, 0x00000030 },
-    { 0x08004564, 0x00000004 },
-    { 0x0000e566, 0x00000004 },
-    { 0x00000055, 0x00000008 },
-    { 0x00802061, 0x00000010 },
-    { 0x00202000, 0x00000004 },
-    { 0x001b00ff, 0x00000004 },
-    { 0x01000064, 0x00000010 },
-    { 0x001f2000, 0x00000004 },
-    { 0x001c00ff, 0x00000004 },
-    { 0000000000, 0x0000000c },
-    { 0x00000080, 0x00000030 },
-    { 0x00000055, 0x00000008 },
-    { 0x0000e576, 0x00000004 },
-    { 0x000ca000, 0x00000004 },
-    { 0x00012000, 0x00000004 },
-    { 0x00082000, 0x00000004 },
-    { 0x1800650e, 0x00000004 },
-    { 0x00092000, 0x00000004 },
-    { 0x000a2000, 0x00000004 },
-    { 0x000f0000, 0x00000004 },
-    { 0x00400000, 0x00000004 },
-    { 0x00000074, 0x00000018 },
-    { 0x0000e563, 0x00000004 },
-    { 0x00c0e5f9, 0x000000c2 },
-    { 0x00000069, 0x00000008 },
-    { 0x0000a069, 0x00000008 },
-    { 0x0000e576, 0x00000004 },
-    { 0x0000e577, 0x00000004 },
-    { 0x0000e50e, 0x00000004 },
-    { 0x0000e50f, 0x00000004 },
-    { 0x0140a000, 0x00000004 },
-    { 0x00000077, 0x00000018 },
-    { 0x00c0e5f9, 0x000000c2 },
-    { 0x00000077, 0x00000008 },
-    { 0x0014e50e, 0x00000004 },
-    { 0x0040e50f, 0x00000004 },
-    { 0x00c0007a, 0x00000008 },
-    { 0x0000e570, 0x00000004 },
-    { 0x0000e571, 0x00000004 },
-    { 0x0000e572, 0x0000000c },
-    { 0x0000a000, 0x00000004 },
-    { 0x0140a000, 0x00000004 },
-    { 0x0000e568, 0x00000004 },
-    { 0x000c2000, 0x00000004 },
-    { 0x00000084, 0x00000018 },
-    { 0x000b0000, 0x00000004 },
-    { 0x18c0e562, 0x00000004 },
-    { 0x00000086, 0x00000008 },
-    { 0x00c00085, 0x00000008 },
-    { 0x000700e3, 0x00000004 },
-    { 0x00000092, 0x00000038 },
-    { 0x000ca094, 0x00000030 },
-    { 0x080045bb, 0x00000004 },
-    { 0x000c2095, 0x00000030 },
-    { 0x0800e5bc, 0000000000 },
-    { 0x0000e5bb, 0x00000004 },
-    { 0x0000e5bc, 0000000000 },
-    { 0x00120000, 0x0000000c },
-    { 0x00120000, 0x00000004 },
-    { 0x001b0002, 0x0000000c },
-    { 0x0000a000, 0x00000004 },
-    { 0x0000e821, 0x00000004 },
-    { 0x0000e800, 0000000000 },
-    { 0x0000e821, 0x00000004 },
-    { 0x0000e82e, 0000000000 },
-    { 0x02cca000, 0x00000004 },
-    { 0x00140000, 0x00000004 },
-    { 0x000ce1cc, 0x00000004 },
-    { 0x050de1cd, 0x00000004 },
-    { 0x00400000, 0x00000004 },
-    { 0x000000a4, 0x00000018 },
-    { 0x00c0a000, 0x00000004 },
-    { 0x000000a1, 0x00000008 },
-    { 0x000000a6, 0x00000020 },
-    { 0x4200e000, 0000000000 },
-    { 0x000000ad, 0x00000038 },
-    { 0x000ca000, 0x00000004 },
-    { 0x00140000, 0x00000004 },
-    { 0x000c2000, 0x00000004 },
-    { 0x00160000, 0x00000004 },
-    { 0x700ce000, 0x00000004 },
-    { 0x001400a9, 0x00000008 },
-    { 0x4000e000, 0000000000 },
-    { 0x02400000, 0x00000004 },
-    { 0x400ee000, 0x00000004 },
-    { 0x02400000, 0x00000004 },
-    { 0x4000e000, 0000000000 },
-    { 0x000c2000, 0x00000004 },
-    { 0x0240e51b, 0x00000004 },
-    { 0x0080e50a, 0x00000005 },
-    { 0x0080e50b, 0x00000005 },
-    { 0x00220000, 0x00000004 },
-    { 0x000700e3, 0x00000004 },
-    { 0x000000c0, 0x00000038 },
-    { 0x000c2095, 0x00000030 },
-    { 0x0880e5bd, 0x00000005 },
-    { 0x000c2094, 0x00000030 },
-    { 0x0800e5bb, 0x00000005 },
-    { 0x000c2095, 0x00000030 },
-    { 0x0880e5bc, 0x00000005 },
-    { 0x000000c3, 0x00000008 },
-    { 0x0080e5bd, 0x00000005 },
-    { 0x0000e5bb, 0x00000005 },
-    { 0x0080e5bc, 0x00000005 },
-    { 0x00210000, 0x00000004 },
-    { 0x02800000, 0x00000004 },
-    { 0x00c000c7, 0x00000018 },
-    { 0x4180e000, 0x00000040 },
-    { 0x000000c9, 0x00000024 },
-    { 0x01000000, 0x0000000c },
-    { 0x0100e51d, 0x0000000c },
-    { 0x000045bb, 0x00000004 },
-    { 0x000080c3, 0x00000008 },
-    { 0x0000f3ce, 0x00000004 },
-    { 0x0140a000, 0x00000004 },
-    { 0x00cc2000, 0x00000004 },
-    { 0x08c053cf, 0x00000040 },
-    { 0x00008000, 0000000000 },
-    { 0x0000f3d2, 0x00000004 },
-    { 0x0140a000, 0x00000004 },
-    { 0x00cc2000, 0x00000004 },
-    { 0x08c053d3, 0x00000040 },
-    { 0x00008000, 0000000000 },
-    { 0x0000f39d, 0x00000004 },
-    { 0x0140a000, 0x00000004 },
-    { 0x00cc2000, 0x00000004 },
-    { 0x08c0539e, 0x00000040 },
-    { 0x00008000, 0000000000 },
-    { 0x03c00830, 0x00000004 },
-    { 0x4200e000, 0000000000 },
-    { 0x0000a000, 0x00000004 },
-    { 0x200045e0, 0x00000004 },
-    { 0x0000e5e1, 0000000000 },
-    { 0x00000001, 0000000000 },
-    { 0x000700e0, 0x00000004 },
-    { 0x0800e394, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0x0000e8c4, 0x00000004 },
-    { 0x0000e8c5, 0x00000004 },
-    { 0x0000e8c6, 0x00000004 },
-    { 0x0000e928, 0x00000004 },
-    { 0x0000e929, 0x00000004 },
-    { 0x0000e92a, 0x00000004 },
-    { 0x000000e4, 0x00000008 },
-    { 0x0000e928, 0x00000004 },
-    { 0x0000e929, 0x00000004 },
-    { 0x0000e92a, 0x00000004 },
-    { 0x000000eb, 0x00000008 },
-    { 0x02c02000, 0x00000004 },
-    { 0x00060000, 0x00000004 },
-    { 0x000000f3, 0x00000034 },
-    { 0x000000f0, 0x00000008 },
-    { 0x00008000, 0x00000004 },
-    { 0xc000e000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0x000c2000, 0x00000004 },
-    { 0x001d0018, 0x00000004 },
-    { 0x001a0001, 0x00000004 },
-    { 0x000000fb, 0x00000034 },
-    { 0x0000004a, 0x00000008 },
-    { 0x0500a04a, 0x00000008 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-};
-
-static const u32 R420_cp_microcode[][2] = {
-    { 0x4200e000, 0000000000 },
-    { 0x4000e000, 0000000000 },
-    { 0x00000099, 0x00000008 },
-    { 0x0000009d, 0x00000008 },
-    { 0x4a554b4a, 0000000000 },
-    { 0x4a4a4467, 0000000000 },
-    { 0x55526f75, 0000000000 },
-    { 0x4a7e7d65, 0000000000 },
-    { 0xd9d3dff6, 0000000000 },
-    { 0x4ac54a4a, 0000000000 },
-    { 0xc8828282, 0000000000 },
-    { 0xbf4acfc1, 0000000000 },
-    { 0x87b04a4a, 0000000000 },
-    { 0xb5838383, 0000000000 },
-    { 0x4a0f85ba, 0000000000 },
-    { 0x000ca000, 0x00000004 },
-    { 0x000d0012, 0x00000038 },
-    { 0x0000e8b4, 0x00000004 },
-    { 0x000d0014, 0x00000038 },
-    { 0x0000e8b6, 0x00000004 },
-    { 0x000d0016, 0x00000038 },
-    { 0x0000e854, 0x00000004 },
-    { 0x000d0018, 0x00000038 },
-    { 0x0000e855, 0x00000004 },
-    { 0x000d001a, 0x00000038 },
-    { 0x0000e856, 0x00000004 },
-    { 0x000d001c, 0x00000038 },
-    { 0x0000e857, 0x00000004 },
-    { 0x000d001e, 0x00000038 },
-    { 0x0000e824, 0x00000004 },
-    { 0x000d0020, 0x00000038 },
-    { 0x0000e825, 0x00000004 },
-    { 0x000d0022, 0x00000038 },
-    { 0x0000e830, 0x00000004 },
-    { 0x000d0024, 0x00000038 },
-    { 0x0000f0c0, 0x00000004 },
-    { 0x000d0026, 0x00000038 },
-    { 0x0000f0c1, 0x00000004 },
-    { 0x000d0028, 0x00000038 },
-    { 0x0000f041, 0x00000004 },
-    { 0x000d002a, 0x00000038 },
-    { 0x0000f184, 0x00000004 },
-    { 0x000d002c, 0x00000038 },
-    { 0x0000f185, 0x00000004 },
-    { 0x000d002e, 0x00000038 },
-    { 0x0000f186, 0x00000004 },
-    { 0x000d0030, 0x00000038 },
-    { 0x0000f187, 0x00000004 },
-    { 0x000d0032, 0x00000038 },
-    { 0x0000f180, 0x00000004 },
-    { 0x000d0034, 0x00000038 },
-    { 0x0000f393, 0x00000004 },
-    { 0x000d0036, 0x00000038 },
-    { 0x0000f38a, 0x00000004 },
-    { 0x000d0038, 0x00000038 },
-    { 0x0000f38e, 0x00000004 },
-    { 0x0000e821, 0x00000004 },
-    { 0x0140a000, 0x00000004 },
-    { 0x00000043, 0x00000018 },
-    { 0x00cce800, 0x00000004 },
-    { 0x001b0001, 0x00000004 },
-    { 0x08004800, 0x00000004 },
-    { 0x001b0001, 0x00000004 },
-    { 0x08004800, 0x00000004 },
-    { 0x001b0001, 0x00000004 },
-    { 0x08004800, 0x00000004 },
-    { 0x0000003a, 0x00000008 },
-    { 0x0000a000, 0000000000 },
-    { 0x2000451d, 0x00000004 },
-    { 0x0000e580, 0x00000004 },
-    { 0x000ce581, 0x00000004 },
-    { 0x08004580, 0x00000004 },
-    { 0x000ce581, 0x00000004 },
-    { 0x00000047, 0x00000008 },
-    { 0x0000a000, 0000000000 },
-    { 0x000c2000, 0x00000004 },
-    { 0x0000e50e, 0x00000004 },
-    { 0x00032000, 0x00000004 },
-    { 0x00022051, 0x00000028 },
-    { 0x00000051, 0x00000024 },
-    { 0x0800450f, 0x00000004 },
-    { 0x0000a04b, 0x00000008 },
-    { 0x0000e565, 0x00000004 },
-    { 0x0000e566, 0x00000004 },
-    { 0x00000052, 0x00000008 },
-    { 0x03cca5b4, 0x00000004 },
-    { 0x05432000, 0x00000004 },
-    { 0x00022000, 0x00000004 },
-    { 0x4ccce05e, 0x00000030 },
-    { 0x08274565, 0x00000004 },
-    { 0x0000005e, 0x00000030 },
-    { 0x08004564, 0x00000004 },
-    { 0x0000e566, 0x00000004 },
-    { 0x00000055, 0x00000008 },
-    { 0x00802061, 0x00000010 },
-    { 0x00202000, 0x00000004 },
-    { 0x001b00ff, 0x00000004 },
-    { 0x01000064, 0x00000010 },
-    { 0x001f2000, 0x00000004 },
-    { 0x001c00ff, 0x00000004 },
-    { 0000000000, 0x0000000c },
-    { 0x00000072, 0x00000030 },
-    { 0x00000055, 0x00000008 },
-    { 0x0000e576, 0x00000004 },
-    { 0x0000e577, 0x00000004 },
-    { 0x0000e50e, 0x00000004 },
-    { 0x0000e50f, 0x00000004 },
-    { 0x0140a000, 0x00000004 },
-    { 0x00000069, 0x00000018 },
-    { 0x00c0e5f9, 0x000000c2 },
-    { 0x00000069, 0x00000008 },
-    { 0x0014e50e, 0x00000004 },
-    { 0x0040e50f, 0x00000004 },
-    { 0x00c0006c, 0x00000008 },
-    { 0x0000e570, 0x00000004 },
-    { 0x0000e571, 0x00000004 },
-    { 0x0000e572, 0x0000000c },
-    { 0x0000a000, 0x00000004 },
-    { 0x0140a000, 0x00000004 },
-    { 0x0000e568, 0x00000004 },
-    { 0x000c2000, 0x00000004 },
-    { 0x00000076, 0x00000018 },
-    { 0x000b0000, 0x00000004 },
-    { 0x18c0e562, 0x00000004 },
-    { 0x00000078, 0x00000008 },
-    { 0x00c00077, 0x00000008 },
-    { 0x000700c7, 0x00000004 },
-    { 0x00000080, 0x00000038 },
-    { 0x0000e5bb, 0x00000004 },
-    { 0x0000e5bc, 0000000000 },
-    { 0x0000a000, 0x00000004 },
-    { 0x0000e821, 0x00000004 },
-    { 0x0000e800, 0000000000 },
-    { 0x0000e821, 0x00000004 },
-    { 0x0000e82e, 0000000000 },
-    { 0x02cca000, 0x00000004 },
-    { 0x00140000, 0x00000004 },
-    { 0x000ce1cc, 0x00000004 },
-    { 0x050de1cd, 0x00000004 },
-    { 0x00400000, 0x00000004 },
-    { 0x0000008f, 0x00000018 },
-    { 0x00c0a000, 0x00000004 },
-    { 0x0000008c, 0x00000008 },
-    { 0x00000091, 0x00000020 },
-    { 0x4200e000, 0000000000 },
-    { 0x00000098, 0x00000038 },
-    { 0x000ca000, 0x00000004 },
-    { 0x00140000, 0x00000004 },
-    { 0x000c2000, 0x00000004 },
-    { 0x00160000, 0x00000004 },
-    { 0x700ce000, 0x00000004 },
-    { 0x00140094, 0x00000008 },
-    { 0x4000e000, 0000000000 },
-    { 0x02400000, 0x00000004 },
-    { 0x400ee000, 0x00000004 },
-    { 0x02400000, 0x00000004 },
-    { 0x4000e000, 0000000000 },
-    { 0x000c2000, 0x00000004 },
-    { 0x0240e51b, 0x00000004 },
-    { 0x0080e50a, 0x00000005 },
-    { 0x0080e50b, 0x00000005 },
-    { 0x00220000, 0x00000004 },
-    { 0x000700c7, 0x00000004 },
-    { 0x000000a4, 0x00000038 },
-    { 0x0080e5bd, 0x00000005 },
-    { 0x0000e5bb, 0x00000005 },
-    { 0x0080e5bc, 0x00000005 },
-    { 0x00210000, 0x00000004 },
-    { 0x02800000, 0x00000004 },
-    { 0x00c000ab, 0x00000018 },
-    { 0x4180e000, 0x00000040 },
-    { 0x000000ad, 0x00000024 },
-    { 0x01000000, 0x0000000c },
-    { 0x0100e51d, 0x0000000c },
-    { 0x000045bb, 0x00000004 },
-    { 0x000080a7, 0x00000008 },
-    { 0x0000f3ce, 0x00000004 },
-    { 0x0140a000, 0x00000004 },
-    { 0x00cc2000, 0x00000004 },
-    { 0x08c053cf, 0x00000040 },
-    { 0x00008000, 0000000000 },
-    { 0x0000f3d2, 0x00000004 },
-    { 0x0140a000, 0x00000004 },
-    { 0x00cc2000, 0x00000004 },
-    { 0x08c053d3, 0x00000040 },
-    { 0x00008000, 0000000000 },
-    { 0x0000f39d, 0x00000004 },
-    { 0x0140a000, 0x00000004 },
-    { 0x00cc2000, 0x00000004 },
-    { 0x08c0539e, 0x00000040 },
-    { 0x00008000, 0000000000 },
-    { 0x03c00830, 0x00000004 },
-    { 0x4200e000, 0000000000 },
-    { 0x0000a000, 0x00000004 },
-    { 0x200045e0, 0x00000004 },
-    { 0x0000e5e1, 0000000000 },
-    { 0x00000001, 0000000000 },
-    { 0x000700c4, 0x00000004 },
-    { 0x0800e394, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0x0000e8c4, 0x00000004 },
-    { 0x0000e8c5, 0x00000004 },
-    { 0x0000e8c6, 0x00000004 },
-    { 0x0000e928, 0x00000004 },
-    { 0x0000e929, 0x00000004 },
-    { 0x0000e92a, 0x00000004 },
-    { 0x000000c8, 0x00000008 },
-    { 0x0000e928, 0x00000004 },
-    { 0x0000e929, 0x00000004 },
-    { 0x0000e92a, 0x00000004 },
-    { 0x000000cf, 0x00000008 },
-    { 0x02c02000, 0x00000004 },
-    { 0x00060000, 0x00000004 },
-    { 0x000000d7, 0x00000034 },
-    { 0x000000d4, 0x00000008 },
-    { 0x00008000, 0x00000004 },
-    { 0xc000e000, 0000000000 },
-    { 0x0000e1cc, 0x00000004 },
-    { 0x0500e1cd, 0x00000004 },
-    { 0x000ca000, 0x00000004 },
-    { 0x000000de, 0x00000034 },
-    { 0x000000da, 0x00000008 },
-    { 0x0000a000, 0000000000 },
-    { 0x0019e1cc, 0x00000004 },
-    { 0x001b0001, 0x00000004 },
-    { 0x0500a000, 0x00000004 },
-    { 0x080041cd, 0x00000004 },
-    { 0x000ca000, 0x00000004 },
-    { 0x000000fb, 0x00000034 },
-    { 0x0000004a, 0x00000008 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0x000c2000, 0x00000004 },
-    { 0x001d0018, 0x00000004 },
-    { 0x001a0001, 0x00000004 },
-    { 0x000000fb, 0x00000034 },
-    { 0x0000004a, 0x00000008 },
-    { 0x0500a04a, 0x00000008 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-};
-
-static const u32 RS600_cp_microcode[][2] = {
-    { 0x4200e000, 0000000000 },
-    { 0x4000e000, 0000000000 },
-    { 0x000000a0, 0x00000008 },
-    { 0x000000a4, 0x00000008 },
-    { 0x4a554b4a, 0000000000 },
-    { 0x4a4a4467, 0000000000 },
-    { 0x55526f75, 0000000000 },
-    { 0x4a7e7d65, 0000000000 },
-    { 0x4ae74af6, 0000000000 },
-    { 0x4ad34a4a, 0000000000 },
-    { 0xd6898989, 0000000000 },
-    { 0xcd4addcf, 0000000000 },
-    { 0x8ebe4ae2, 0000000000 },
-    { 0xc38a8a8a, 0000000000 },
-    { 0x4a0f8cc8, 0000000000 },
-    { 0x000ca000, 0x00000004 },
-    { 0x000d0012, 0x00000038 },
-    { 0x0000e8b4, 0x00000004 },
-    { 0x000d0014, 0x00000038 },
-    { 0x0000e8b6, 0x00000004 },
-    { 0x000d0016, 0x00000038 },
-    { 0x0000e854, 0x00000004 },
-    { 0x000d0018, 0x00000038 },
-    { 0x0000e855, 0x00000004 },
-    { 0x000d001a, 0x00000038 },
-    { 0x0000e856, 0x00000004 },
-    { 0x000d001c, 0x00000038 },
-    { 0x0000e857, 0x00000004 },
-    { 0x000d001e, 0x00000038 },
-    { 0x0000e824, 0x00000004 },
-    { 0x000d0020, 0x00000038 },
-    { 0x0000e825, 0x00000004 },
-    { 0x000d0022, 0x00000038 },
-    { 0x0000e830, 0x00000004 },
-    { 0x000d0024, 0x00000038 },
-    { 0x0000f0c0, 0x00000004 },
-    { 0x000d0026, 0x00000038 },
-    { 0x0000f0c1, 0x00000004 },
-    { 0x000d0028, 0x00000038 },
-    { 0x0000f041, 0x00000004 },
-    { 0x000d002a, 0x00000038 },
-    { 0x0000f184, 0x00000004 },
-    { 0x000d002c, 0x00000038 },
-    { 0x0000f185, 0x00000004 },
-    { 0x000d002e, 0x00000038 },
-    { 0x0000f186, 0x00000004 },
-    { 0x000d0030, 0x00000038 },
-    { 0x0000f187, 0x00000004 },
-    { 0x000d0032, 0x00000038 },
-    { 0x0000f180, 0x00000004 },
-    { 0x000d0034, 0x00000038 },
-    { 0x0000f393, 0x00000004 },
-    { 0x000d0036, 0x00000038 },
-    { 0x0000f38a, 0x00000004 },
-    { 0x000d0038, 0x00000038 },
-    { 0x0000f38e, 0x00000004 },
-    { 0x0000e821, 0x00000004 },
-    { 0x0140a000, 0x00000004 },
-    { 0x00000043, 0x00000018 },
-    { 0x00cce800, 0x00000004 },
-    { 0x001b0001, 0x00000004 },
-    { 0x08004800, 0x00000004 },
-    { 0x001b0001, 0x00000004 },
-    { 0x08004800, 0x00000004 },
-    { 0x001b0001, 0x00000004 },
-    { 0x08004800, 0x00000004 },
-    { 0x0000003a, 0x00000008 },
-    { 0x0000a000, 0000000000 },
-    { 0x2000451d, 0x00000004 },
-    { 0x0000e580, 0x00000004 },
-    { 0x000ce581, 0x00000004 },
-    { 0x08004580, 0x00000004 },
-    { 0x000ce581, 0x00000004 },
-    { 0x00000047, 0x00000008 },
-    { 0x0000a000, 0000000000 },
-    { 0x000c2000, 0x00000004 },
-    { 0x0000e50e, 0x00000004 },
-    { 0x00032000, 0x00000004 },
-    { 0x00022051, 0x00000028 },
-    { 0x00000051, 0x00000024 },
-    { 0x0800450f, 0x00000004 },
-    { 0x0000a04b, 0x00000008 },
-    { 0x0000e565, 0x00000004 },
-    { 0x0000e566, 0x00000004 },
-    { 0x00000052, 0x00000008 },
-    { 0x03cca5b4, 0x00000004 },
-    { 0x05432000, 0x00000004 },
-    { 0x00022000, 0x00000004 },
-    { 0x4ccce05e, 0x00000030 },
-    { 0x08274565, 0x00000004 },
-    { 0x0000005e, 0x00000030 },
-    { 0x08004564, 0x00000004 },
-    { 0x0000e566, 0x00000004 },
-    { 0x00000055, 0x00000008 },
-    { 0x00802061, 0x00000010 },
-    { 0x00202000, 0x00000004 },
-    { 0x001b00ff, 0x00000004 },
-    { 0x01000064, 0x00000010 },
-    { 0x001f2000, 0x00000004 },
-    { 0x001c00ff, 0x00000004 },
-    { 0000000000, 0x0000000c },
-    { 0x00000072, 0x00000030 },
-    { 0x00000055, 0x00000008 },
-    { 0x0000e576, 0x00000004 },
-    { 0x0000e577, 0x00000004 },
-    { 0x0000e50e, 0x00000004 },
-    { 0x0000e50f, 0x00000004 },
-    { 0x0140a000, 0x00000004 },
-    { 0x00000069, 0x00000018 },
-    { 0x00c0e5f9, 0x000000c2 },
-    { 0x00000069, 0x00000008 },
-    { 0x0014e50e, 0x00000004 },
-    { 0x0040e50f, 0x00000004 },
-    { 0x00c0006c, 0x00000008 },
-    { 0x0000e570, 0x00000004 },
-    { 0x0000e571, 0x00000004 },
-    { 0x0000e572, 0x0000000c },
-    { 0x0000a000, 0x00000004 },
-    { 0x0140a000, 0x00000004 },
-    { 0x0000e568, 0x00000004 },
-    { 0x000c2000, 0x00000004 },
-    { 0x00000076, 0x00000018 },
-    { 0x000b0000, 0x00000004 },
-    { 0x18c0e562, 0x00000004 },
-    { 0x00000078, 0x00000008 },
-    { 0x00c00077, 0x00000008 },
-    { 0x000700d5, 0x00000004 },
-    { 0x00000084, 0x00000038 },
-    { 0x000ca086, 0x00000030 },
-    { 0x080045bb, 0x00000004 },
-    { 0x000c2087, 0x00000030 },
-    { 0x0800e5bc, 0000000000 },
-    { 0x0000e5bb, 0x00000004 },
-    { 0x0000e5bc, 0000000000 },
-    { 0x00120000, 0x0000000c },
-    { 0x00120000, 0x00000004 },
-    { 0x001b0002, 0x0000000c },
-    { 0x0000a000, 0x00000004 },
-    { 0x0000e821, 0x00000004 },
-    { 0x0000e800, 0000000000 },
-    { 0x0000e821, 0x00000004 },
-    { 0x0000e82e, 0000000000 },
-    { 0x02cca000, 0x00000004 },
-    { 0x00140000, 0x00000004 },
-    { 0x000ce1cc, 0x00000004 },
-    { 0x050de1cd, 0x00000004 },
-    { 0x00400000, 0x00000004 },
-    { 0x00000096, 0x00000018 },
-    { 0x00c0a000, 0x00000004 },
-    { 0x00000093, 0x00000008 },
-    { 0x00000098, 0x00000020 },
-    { 0x4200e000, 0000000000 },
-    { 0x0000009f, 0x00000038 },
-    { 0x000ca000, 0x00000004 },
-    { 0x00140000, 0x00000004 },
-    { 0x000c2000, 0x00000004 },
-    { 0x00160000, 0x00000004 },
-    { 0x700ce000, 0x00000004 },
-    { 0x0014009b, 0x00000008 },
-    { 0x4000e000, 0000000000 },
-    { 0x02400000, 0x00000004 },
-    { 0x400ee000, 0x00000004 },
-    { 0x02400000, 0x00000004 },
-    { 0x4000e000, 0000000000 },
-    { 0x000c2000, 0x00000004 },
-    { 0x0240e51b, 0x00000004 },
-    { 0x0080e50a, 0x00000005 },
-    { 0x0080e50b, 0x00000005 },
-    { 0x00220000, 0x00000004 },
-    { 0x000700d5, 0x00000004 },
-    { 0x000000b2, 0x00000038 },
-    { 0x000c2087, 0x00000030 },
-    { 0x0880e5bd, 0x00000005 },
-    { 0x000c2086, 0x00000030 },
-    { 0x0800e5bb, 0x00000005 },
-    { 0x000c2087, 0x00000030 },
-    { 0x0880e5bc, 0x00000005 },
-    { 0x000000b5, 0x00000008 },
-    { 0x0080e5bd, 0x00000005 },
-    { 0x0000e5bb, 0x00000005 },
-    { 0x0080e5bc, 0x00000005 },
-    { 0x00210000, 0x00000004 },
-    { 0x02800000, 0x00000004 },
-    { 0x00c000b9, 0x00000018 },
-    { 0x4180e000, 0x00000040 },
-    { 0x000000bb, 0x00000024 },
-    { 0x01000000, 0x0000000c },
-    { 0x0100e51d, 0x0000000c },
-    { 0x000045bb, 0x00000004 },
-    { 0x000080b5, 0x00000008 },
-    { 0x0000f3ce, 0x00000004 },
-    { 0x0140a000, 0x00000004 },
-    { 0x00cc2000, 0x00000004 },
-    { 0x08c053cf, 0x00000040 },
-    { 0x00008000, 0000000000 },
-    { 0x0000f3d2, 0x00000004 },
-    { 0x0140a000, 0x00000004 },
-    { 0x00cc2000, 0x00000004 },
-    { 0x08c053d3, 0x00000040 },
-    { 0x00008000, 0000000000 },
-    { 0x0000f39d, 0x00000004 },
-    { 0x0140a000, 0x00000004 },
-    { 0x00cc2000, 0x00000004 },
-    { 0x08c0539e, 0x00000040 },
-    { 0x00008000, 0000000000 },
-    { 0x03c00830, 0x00000004 },
-    { 0x4200e000, 0000000000 },
-    { 0x0000a000, 0x00000004 },
-    { 0x200045e0, 0x00000004 },
-    { 0x0000e5e1, 0000000000 },
-    { 0x00000001, 0000000000 },
-    { 0x000700d2, 0x00000004 },
-    { 0x0800e394, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0x0000e8c4, 0x00000004 },
-    { 0x0000e8c5, 0x00000004 },
-    { 0x0000e8c6, 0x00000004 },
-    { 0x0000e928, 0x00000004 },
-    { 0x0000e929, 0x00000004 },
-    { 0x0000e92a, 0x00000004 },
-    { 0x000000d6, 0x00000008 },
-    { 0x0000e928, 0x00000004 },
-    { 0x0000e929, 0x00000004 },
-    { 0x0000e92a, 0x00000004 },
-    { 0x000000dd, 0x00000008 },
-    { 0x00e00116, 0000000000 },
-    { 0x000700e1, 0x00000004 },
-    { 0x0800401c, 0x00000004 },
-    { 0x200050e7, 0x00000004 },
-    { 0x0000e01d, 0x00000004 },
-    { 0x000000e4, 0x00000008 },
-    { 0x02c02000, 0x00000004 },
-    { 0x00060000, 0x00000004 },
-    { 0x000000eb, 0x00000034 },
-    { 0x000000e8, 0x00000008 },
-    { 0x00008000, 0x00000004 },
-    { 0xc000e000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0x000c2000, 0x00000004 },
-    { 0x001d0018, 0x00000004 },
-    { 0x001a0001, 0x00000004 },
-    { 0x000000fb, 0x00000034 },
-    { 0x0000004a, 0x00000008 },
-    { 0x0500a04a, 0x00000008 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-};
-
-static const u32 RS690_cp_microcode[][2] = {
-    { 0x000000dd, 0x00000008 },
-    { 0x000000df, 0x00000008 },
-    { 0x000000a0, 0x00000008 },
-    { 0x000000a4, 0x00000008 },
-    { 0x4a554b4a, 0000000000 },
-    { 0x4a4a4467, 0000000000 },
-    { 0x55526f75, 0000000000 },
-    { 0x4a7e7d65, 0000000000 },
-    { 0x4ad74af6, 0000000000 },
-    { 0x4ac94a4a, 0000000000 },
-    { 0xcc898989, 0000000000 },
-    { 0xc34ad3c5, 0000000000 },
-    { 0x8e4a4a4a, 0000000000 },
-    { 0x4a8a8a8a, 0000000000 },
-    { 0x4a0f8c4a, 0000000000 },
-    { 0x000ca000, 0x00000004 },
-    { 0x000d0012, 0x00000038 },
-    { 0x0000e8b4, 0x00000004 },
-    { 0x000d0014, 0x00000038 },
-    { 0x0000e8b6, 0x00000004 },
-    { 0x000d0016, 0x00000038 },
-    { 0x0000e854, 0x00000004 },
-    { 0x000d0018, 0x00000038 },
-    { 0x0000e855, 0x00000004 },
-    { 0x000d001a, 0x00000038 },
-    { 0x0000e856, 0x00000004 },
-    { 0x000d001c, 0x00000038 },
-    { 0x0000e857, 0x00000004 },
-    { 0x000d001e, 0x00000038 },
-    { 0x0000e824, 0x00000004 },
-    { 0x000d0020, 0x00000038 },
-    { 0x0000e825, 0x00000004 },
-    { 0x000d0022, 0x00000038 },
-    { 0x0000e830, 0x00000004 },
-    { 0x000d0024, 0x00000038 },
-    { 0x0000f0c0, 0x00000004 },
-    { 0x000d0026, 0x00000038 },
-    { 0x0000f0c1, 0x00000004 },
-    { 0x000d0028, 0x00000038 },
-    { 0x0000f041, 0x00000004 },
-    { 0x000d002a, 0x00000038 },
-    { 0x0000f184, 0x00000004 },
-    { 0x000d002c, 0x00000038 },
-    { 0x0000f185, 0x00000004 },
-    { 0x000d002e, 0x00000038 },
-    { 0x0000f186, 0x00000004 },
-    { 0x000d0030, 0x00000038 },
-    { 0x0000f187, 0x00000004 },
-    { 0x000d0032, 0x00000038 },
-    { 0x0000f180, 0x00000004 },
-    { 0x000d0034, 0x00000038 },
-    { 0x0000f393, 0x00000004 },
-    { 0x000d0036, 0x00000038 },
-    { 0x0000f38a, 0x00000004 },
-    { 0x000d0038, 0x00000038 },
-    { 0x0000f38e, 0x00000004 },
-    { 0x0000e821, 0x00000004 },
-    { 0x0140a000, 0x00000004 },
-    { 0x00000043, 0x00000018 },
-    { 0x00cce800, 0x00000004 },
-    { 0x001b0001, 0x00000004 },
-    { 0x08004800, 0x00000004 },
-    { 0x001b0001, 0x00000004 },
-    { 0x08004800, 0x00000004 },
-    { 0x001b0001, 0x00000004 },
-    { 0x08004800, 0x00000004 },
-    { 0x0000003a, 0x00000008 },
-    { 0x0000a000, 0000000000 },
-    { 0x2000451d, 0x00000004 },
-    { 0x0000e580, 0x00000004 },
-    { 0x000ce581, 0x00000004 },
-    { 0x08004580, 0x00000004 },
-    { 0x000ce581, 0x00000004 },
-    { 0x00000047, 0x00000008 },
-    { 0x0000a000, 0000000000 },
-    { 0x000c2000, 0x00000004 },
-    { 0x0000e50e, 0x00000004 },
-    { 0x00032000, 0x00000004 },
-    { 0x00022051, 0x00000028 },
-    { 0x00000051, 0x00000024 },
-    { 0x0800450f, 0x00000004 },
-    { 0x0000a04b, 0x00000008 },
-    { 0x0000e565, 0x00000004 },
-    { 0x0000e566, 0x00000004 },
-    { 0x00000052, 0x00000008 },
-    { 0x03cca5b4, 0x00000004 },
-    { 0x05432000, 0x00000004 },
-    { 0x00022000, 0x00000004 },
-    { 0x4ccce05e, 0x00000030 },
-    { 0x08274565, 0x00000004 },
-    { 0x0000005e, 0x00000030 },
-    { 0x08004564, 0x00000004 },
-    { 0x0000e566, 0x00000004 },
-    { 0x00000055, 0x00000008 },
-    { 0x00802061, 0x00000010 },
-    { 0x00202000, 0x00000004 },
-    { 0x001b00ff, 0x00000004 },
-    { 0x01000064, 0x00000010 },
-    { 0x001f2000, 0x00000004 },
-    { 0x001c00ff, 0x00000004 },
-    { 0000000000, 0x0000000c },
-    { 0x00000072, 0x00000030 },
-    { 0x00000055, 0x00000008 },
-    { 0x0000e576, 0x00000004 },
-    { 0x0000e577, 0x00000004 },
-    { 0x0000e50e, 0x00000004 },
-    { 0x0000e50f, 0x00000004 },
-    { 0x0140a000, 0x00000004 },
-    { 0x00000069, 0x00000018 },
-    { 0x00c0e5f9, 0x000000c2 },
-    { 0x00000069, 0x00000008 },
-    { 0x0014e50e, 0x00000004 },
-    { 0x0040e50f, 0x00000004 },
-    { 0x00c0006c, 0x00000008 },
-    { 0x0000e570, 0x00000004 },
-    { 0x0000e571, 0x00000004 },
-    { 0x0000e572, 0x0000000c },
-    { 0x0000a000, 0x00000004 },
-    { 0x0140a000, 0x00000004 },
-    { 0x0000e568, 0x00000004 },
-    { 0x000c2000, 0x00000004 },
-    { 0x00000076, 0x00000018 },
-    { 0x000b0000, 0x00000004 },
-    { 0x18c0e562, 0x00000004 },
-    { 0x00000078, 0x00000008 },
-    { 0x00c00077, 0x00000008 },
-    { 0x000700cb, 0x00000004 },
-    { 0x00000084, 0x00000038 },
-    { 0x000ca086, 0x00000030 },
-    { 0x080045bb, 0x00000004 },
-    { 0x000c2087, 0x00000030 },
-    { 0x0800e5bc, 0000000000 },
-    { 0x0000e5bb, 0x00000004 },
-    { 0x0000e5bc, 0000000000 },
-    { 0x00120000, 0x0000000c },
-    { 0x00120000, 0x00000004 },
-    { 0x001b0002, 0x0000000c },
-    { 0x0000a000, 0x00000004 },
-    { 0x0000e821, 0x00000004 },
-    { 0x0000e800, 0000000000 },
-    { 0x0000e821, 0x00000004 },
-    { 0x0000e82e, 0000000000 },
-    { 0x02cca000, 0x00000004 },
-    { 0x00140000, 0x00000004 },
-    { 0x000ce1cc, 0x00000004 },
-    { 0x050de1cd, 0x00000004 },
-    { 0x00400000, 0x00000004 },
-    { 0x00000096, 0x00000018 },
-    { 0x00c0a000, 0x00000004 },
-    { 0x00000093, 0x00000008 },
-    { 0x00000098, 0x00000020 },
-    { 0x4200e000, 0000000000 },
-    { 0x0000009f, 0x00000038 },
-    { 0x000ca000, 0x00000004 },
-    { 0x00140000, 0x00000004 },
-    { 0x000c2000, 0x00000004 },
-    { 0x00160000, 0x00000004 },
-    { 0x700ce000, 0x00000004 },
-    { 0x0014009b, 0x00000008 },
-    { 0x4000e000, 0000000000 },
-    { 0x02400000, 0x00000004 },
-    { 0x400ee000, 0x00000004 },
-    { 0x02400000, 0x00000004 },
-    { 0x4000e000, 0000000000 },
-    { 0x00100000, 0x0000002c },
-    { 0x00004000, 0000000000 },
-    { 0x080045c8, 0x00000004 },
-    { 0x00240005, 0x00000004 },
-    { 0x08004d0b, 0x00000004 },
-    { 0x000c2000, 0x00000004 },
-    { 0x0240e51b, 0x00000004 },
-    { 0x0080e50a, 0x00000005 },
-    { 0x0080e50b, 0x00000005 },
-    { 0x00220000, 0x00000004 },
-    { 0x000700cb, 0x00000004 },
-    { 0x000000b7, 0x00000038 },
-    { 0x000c2087, 0x00000030 },
-    { 0x0880e5bd, 0x00000005 },
-    { 0x000c2086, 0x00000030 },
-    { 0x0800e5bb, 0x00000005 },
-    { 0x000c2087, 0x00000030 },
-    { 0x0880e5bc, 0x00000005 },
-    { 0x000000ba, 0x00000008 },
-    { 0x0080e5bd, 0x00000005 },
-    { 0x0000e5bb, 0x00000005 },
-    { 0x0080e5bc, 0x00000005 },
-    { 0x00210000, 0x00000004 },
-    { 0x02800000, 0x00000004 },
-    { 0x00c000be, 0x00000018 },
-    { 0x4180e000, 0x00000040 },
-    { 0x000000c0, 0x00000024 },
-    { 0x01000000, 0x0000000c },
-    { 0x0100e51d, 0x0000000c },
-    { 0x000045bb, 0x00000004 },
-    { 0x000080ba, 0x00000008 },
-    { 0x03c00830, 0x00000004 },
-    { 0x4200e000, 0000000000 },
-    { 0x0000a000, 0x00000004 },
-    { 0x200045e0, 0x00000004 },
-    { 0x0000e5e1, 0000000000 },
-    { 0x00000001, 0000000000 },
-    { 0x000700c8, 0x00000004 },
-    { 0x0800e394, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0x0000e8c4, 0x00000004 },
-    { 0x0000e8c5, 0x00000004 },
-    { 0x0000e8c6, 0x00000004 },
-    { 0x0000e928, 0x00000004 },
-    { 0x0000e929, 0x00000004 },
-    { 0x0000e92a, 0x00000004 },
-    { 0x000000cc, 0x00000008 },
-    { 0x0000e928, 0x00000004 },
-    { 0x0000e929, 0x00000004 },
-    { 0x0000e92a, 0x00000004 },
-    { 0x000000d3, 0x00000008 },
-    { 0x02c02000, 0x00000004 },
-    { 0x00060000, 0x00000004 },
-    { 0x000000db, 0x00000034 },
-    { 0x000000d8, 0x00000008 },
-    { 0x00008000, 0x00000004 },
-    { 0xc000e000, 0000000000 },
-    { 0x000000e1, 0x00000030 },
-    { 0x4200e000, 0000000000 },
-    { 0x000000e1, 0x00000030 },
-    { 0x4000e000, 0000000000 },
-    { 0x0025001b, 0x00000004 },
-    { 0x00230000, 0x00000004 },
-    { 0x00250005, 0x00000004 },
-    { 0x000000e6, 0x00000034 },
-    { 0000000000, 0x0000000c },
-    { 0x00244000, 0x00000004 },
-    { 0x080045c8, 0x00000004 },
-    { 0x00240005, 0x00000004 },
-    { 0x08004d0b, 0x0000000c },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0x000c2000, 0x00000004 },
-    { 0x001d0018, 0x00000004 },
-    { 0x001a0001, 0x00000004 },
-    { 0x000000fb, 0x00000034 },
-    { 0x0000004a, 0x00000008 },
-    { 0x0500a04a, 0x00000008 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-};
-
-static const u32 R520_cp_microcode[][2] = {
-    { 0x4200e000, 0000000000 },
-    { 0x4000e000, 0000000000 },
-    { 0x00000099, 0x00000008 },
-    { 0x0000009d, 0x00000008 },
-    { 0x4a554b4a, 0000000000 },
-    { 0x4a4a4467, 0000000000 },
-    { 0x55526f75, 0000000000 },
-    { 0x4a7e7d65, 0000000000 },
-    { 0xe0dae6f6, 0000000000 },
-    { 0x4ac54a4a, 0000000000 },
-    { 0xc8828282, 0000000000 },
-    { 0xbf4acfc1, 0000000000 },
-    { 0x87b04ad5, 0000000000 },
-    { 0xb5838383, 0000000000 },
-    { 0x4a0f85ba, 0000000000 },
-    { 0x000ca000, 0x00000004 },
-    { 0x000d0012, 0x00000038 },
-    { 0x0000e8b4, 0x00000004 },
-    { 0x000d0014, 0x00000038 },
-    { 0x0000e8b6, 0x00000004 },
-    { 0x000d0016, 0x00000038 },
-    { 0x0000e854, 0x00000004 },
-    { 0x000d0018, 0x00000038 },
-    { 0x0000e855, 0x00000004 },
-    { 0x000d001a, 0x00000038 },
-    { 0x0000e856, 0x00000004 },
-    { 0x000d001c, 0x00000038 },
-    { 0x0000e857, 0x00000004 },
-    { 0x000d001e, 0x00000038 },
-    { 0x0000e824, 0x00000004 },
-    { 0x000d0020, 0x00000038 },
-    { 0x0000e825, 0x00000004 },
-    { 0x000d0022, 0x00000038 },
-    { 0x0000e830, 0x00000004 },
-    { 0x000d0024, 0x00000038 },
-    { 0x0000f0c0, 0x00000004 },
-    { 0x000d0026, 0x00000038 },
-    { 0x0000f0c1, 0x00000004 },
-    { 0x000d0028, 0x00000038 },
-    { 0x0000e000, 0x00000004 },
-    { 0x000d002a, 0x00000038 },
-    { 0x0000e000, 0x00000004 },
-    { 0x000d002c, 0x00000038 },
-    { 0x0000e000, 0x00000004 },
-    { 0x000d002e, 0x00000038 },
-    { 0x0000e000, 0x00000004 },
-    { 0x000d0030, 0x00000038 },
-    { 0x0000e000, 0x00000004 },
-    { 0x000d0032, 0x00000038 },
-    { 0x0000f180, 0x00000004 },
-    { 0x000d0034, 0x00000038 },
-    { 0x0000f393, 0x00000004 },
-    { 0x000d0036, 0x00000038 },
-    { 0x0000f38a, 0x00000004 },
-    { 0x000d0038, 0x00000038 },
-    { 0x0000f38e, 0x00000004 },
-    { 0x0000e821, 0x00000004 },
-    { 0x0140a000, 0x00000004 },
-    { 0x00000043, 0x00000018 },
-    { 0x00cce800, 0x00000004 },
-    { 0x001b0001, 0x00000004 },
-    { 0x08004800, 0x00000004 },
-    { 0x001b0001, 0x00000004 },
-    { 0x08004800, 0x00000004 },
-    { 0x001b0001, 0x00000004 },
-    { 0x08004800, 0x00000004 },
-    { 0x0000003a, 0x00000008 },
-    { 0x0000a000, 0000000000 },
-    { 0x2000451d, 0x00000004 },
-    { 0x0000e580, 0x00000004 },
-    { 0x000ce581, 0x00000004 },
-    { 0x08004580, 0x00000004 },
-    { 0x000ce581, 0x00000004 },
-    { 0x00000047, 0x00000008 },
-    { 0x0000a000, 0000000000 },
-    { 0x000c2000, 0x00000004 },
-    { 0x0000e50e, 0x00000004 },
-    { 0x00032000, 0x00000004 },
-    { 0x00022051, 0x00000028 },
-    { 0x00000051, 0x00000024 },
-    { 0x0800450f, 0x00000004 },
-    { 0x0000a04b, 0x00000008 },
-    { 0x0000e565, 0x00000004 },
-    { 0x0000e566, 0x00000004 },
-    { 0x00000052, 0x00000008 },
-    { 0x03cca5b4, 0x00000004 },
-    { 0x05432000, 0x00000004 },
-    { 0x00022000, 0x00000004 },
-    { 0x4ccce05e, 0x00000030 },
-    { 0x08274565, 0x00000004 },
-    { 0x0000005e, 0x00000030 },
-    { 0x08004564, 0x00000004 },
-    { 0x0000e566, 0x00000004 },
-    { 0x00000055, 0x00000008 },
-    { 0x00802061, 0x00000010 },
-    { 0x00202000, 0x00000004 },
-    { 0x001b00ff, 0x00000004 },
-    { 0x01000064, 0x00000010 },
-    { 0x001f2000, 0x00000004 },
-    { 0x001c00ff, 0x00000004 },
-    { 0000000000, 0x0000000c },
-    { 0x00000072, 0x00000030 },
-    { 0x00000055, 0x00000008 },
-    { 0x0000e576, 0x00000004 },
-    { 0x0000e577, 0x00000004 },
-    { 0x0000e50e, 0x00000004 },
-    { 0x0000e50f, 0x00000004 },
-    { 0x0140a000, 0x00000004 },
-    { 0x00000069, 0x00000018 },
-    { 0x00c0e5f9, 0x000000c2 },
-    { 0x00000069, 0x00000008 },
-    { 0x0014e50e, 0x00000004 },
-    { 0x0040e50f, 0x00000004 },
-    { 0x00c0006c, 0x00000008 },
-    { 0x0000e570, 0x00000004 },
-    { 0x0000e571, 0x00000004 },
-    { 0x0000e572, 0x0000000c },
-    { 0x0000a000, 0x00000004 },
-    { 0x0140a000, 0x00000004 },
-    { 0x0000e568, 0x00000004 },
-    { 0x000c2000, 0x00000004 },
-    { 0x00000076, 0x00000018 },
-    { 0x000b0000, 0x00000004 },
-    { 0x18c0e562, 0x00000004 },
-    { 0x00000078, 0x00000008 },
-    { 0x00c00077, 0x00000008 },
-    { 0x000700c7, 0x00000004 },
-    { 0x00000080, 0x00000038 },
-    { 0x0000e5bb, 0x00000004 },
-    { 0x0000e5bc, 0000000000 },
-    { 0x0000a000, 0x00000004 },
-    { 0x0000e821, 0x00000004 },
-    { 0x0000e800, 0000000000 },
-    { 0x0000e821, 0x00000004 },
-    { 0x0000e82e, 0000000000 },
-    { 0x02cca000, 0x00000004 },
-    { 0x00140000, 0x00000004 },
-    { 0x000ce1cc, 0x00000004 },
-    { 0x050de1cd, 0x00000004 },
-    { 0x00400000, 0x00000004 },
-    { 0x0000008f, 0x00000018 },
-    { 0x00c0a000, 0x00000004 },
-    { 0x0000008c, 0x00000008 },
-    { 0x00000091, 0x00000020 },
-    { 0x4200e000, 0000000000 },
-    { 0x00000098, 0x00000038 },
-    { 0x000ca000, 0x00000004 },
-    { 0x00140000, 0x00000004 },
-    { 0x000c2000, 0x00000004 },
-    { 0x00160000, 0x00000004 },
-    { 0x700ce000, 0x00000004 },
-    { 0x00140094, 0x00000008 },
-    { 0x4000e000, 0000000000 },
-    { 0x02400000, 0x00000004 },
-    { 0x400ee000, 0x00000004 },
-    { 0x02400000, 0x00000004 },
-    { 0x4000e000, 0000000000 },
-    { 0x000c2000, 0x00000004 },
-    { 0x0240e51b, 0x00000004 },
-    { 0x0080e50a, 0x00000005 },
-    { 0x0080e50b, 0x00000005 },
-    { 0x00220000, 0x00000004 },
-    { 0x000700c7, 0x00000004 },
-    { 0x000000a4, 0x00000038 },
-    { 0x0080e5bd, 0x00000005 },
-    { 0x0000e5bb, 0x00000005 },
-    { 0x0080e5bc, 0x00000005 },
-    { 0x00210000, 0x00000004 },
-    { 0x02800000, 0x00000004 },
-    { 0x00c000ab, 0x00000018 },
-    { 0x4180e000, 0x00000040 },
-    { 0x000000ad, 0x00000024 },
-    { 0x01000000, 0x0000000c },
-    { 0x0100e51d, 0x0000000c },
-    { 0x000045bb, 0x00000004 },
-    { 0x000080a7, 0x00000008 },
-    { 0x0000f3ce, 0x00000004 },
-    { 0x0140a000, 0x00000004 },
-    { 0x00cc2000, 0x00000004 },
-    { 0x08c053cf, 0x00000040 },
-    { 0x00008000, 0000000000 },
-    { 0x0000f3d2, 0x00000004 },
-    { 0x0140a000, 0x00000004 },
-    { 0x00cc2000, 0x00000004 },
-    { 0x08c053d3, 0x00000040 },
-    { 0x00008000, 0000000000 },
-    { 0x0000f39d, 0x00000004 },
-    { 0x0140a000, 0x00000004 },
-    { 0x00cc2000, 0x00000004 },
-    { 0x08c0539e, 0x00000040 },
-    { 0x00008000, 0000000000 },
-    { 0x03c00830, 0x00000004 },
-    { 0x4200e000, 0000000000 },
-    { 0x0000a000, 0x00000004 },
-    { 0x200045e0, 0x00000004 },
-    { 0x0000e5e1, 0000000000 },
-    { 0x00000001, 0000000000 },
-    { 0x000700c4, 0x00000004 },
-    { 0x0800e394, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0x0000e8c4, 0x00000004 },
-    { 0x0000e8c5, 0x00000004 },
-    { 0x0000e8c6, 0x00000004 },
-    { 0x0000e928, 0x00000004 },
-    { 0x0000e929, 0x00000004 },
-    { 0x0000e92a, 0x00000004 },
-    { 0x000000c8, 0x00000008 },
-    { 0x0000e928, 0x00000004 },
-    { 0x0000e929, 0x00000004 },
-    { 0x0000e92a, 0x00000004 },
-    { 0x000000cf, 0x00000008 },
-    { 0xdeadbeef, 0000000000 },
-    { 0x00000116, 0000000000 },
-    { 0x000700d3, 0x00000004 },
-    { 0x080050e7, 0x00000004 },
-    { 0x000700d4, 0x00000004 },
-    { 0x0800401c, 0x00000004 },
-    { 0x0000e01d, 0000000000 },
-    { 0x02c02000, 0x00000004 },
-    { 0x00060000, 0x00000004 },
-    { 0x000000de, 0x00000034 },
-    { 0x000000db, 0x00000008 },
-    { 0x00008000, 0x00000004 },
-    { 0xc000e000, 0000000000 },
-    { 0x0000e1cc, 0x00000004 },
-    { 0x0500e1cd, 0x00000004 },
-    { 0x000ca000, 0x00000004 },
-    { 0x000000e5, 0x00000034 },
-    { 0x000000e1, 0x00000008 },
-    { 0x0000a000, 0000000000 },
-    { 0x0019e1cc, 0x00000004 },
-    { 0x001b0001, 0x00000004 },
-    { 0x0500a000, 0x00000004 },
-    { 0x080041cd, 0x00000004 },
-    { 0x000ca000, 0x00000004 },
-    { 0x000000fb, 0x00000034 },
-    { 0x0000004a, 0x00000008 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0x000c2000, 0x00000004 },
-    { 0x001d0018, 0x00000004 },
-    { 0x001a0001, 0x00000004 },
-    { 0x000000fb, 0x00000034 },
-    { 0x0000004a, 0x00000008 },
-    { 0x0500a04a, 0x00000008 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-    { 0000000000, 0000000000 },
-};
-
-
-#endif
diff --git a/firmware/Makefile b/firmware/Makefile
index 142c17a..efd2d61 100644
--- a/firmware/Makefile
+++ b/firmware/Makefile
@@ -41,6 +41,10 @@ fw-shipped-$(CONFIG_COMPUTONE) += intelliport2.bin
 fw-shipped-$(CONFIG_CHELSIO_T3) += cxgb3/t3b_psram-1.1.0.bin \
 				   cxgb3/t3c_psram-1.1.0.bin \
 				   cxgb3/t3fw-7.1.0.bin
+fw-shipped-$(CONFIG_DRM_RADEON) += radeon/R100_cp.bin radeon/R200_cp.bin \
+				   radeon/R300_cp.bin radeon/R420_cp.bin \
+				   radeon/RS600_cp.bin radeon/RS690_cp.bin \
+				   radeon/R520_cp.bin
 fw-shipped-$(CONFIG_DVB_AV7110) += av7110/bootcode.bin
 fw-shipped-$(CONFIG_DVB_TTUSB_BUDGET) += ttusb-budget/dspbootcode.bin
 fw-shipped-$(CONFIG_E100) += e100/d101m_ucode.bin e100/d101s_ucode.bin \
diff --git a/firmware/WHENCE b/firmware/WHENCE
index 10f61c9..c7e4f66 100644
--- a/firmware/WHENCE
+++ b/firmware/WHENCE
@@ -648,3 +648,43 @@ Found in hex form in kernel source, with the following comment:
    Copyright (c) 1998-2002 by Paul Davis <pbd@op.net>
 
 --------------------------------------------------------------------------
+
+Driver: DRM_RADEON - ATI Radeon
+
+File: radeon/R100_cp.bin
+File: radeon/R200_cp.bin
+File: radeon/R300_cp.bin
+File: radeon/R420_cp.bin
+File: radeon/RS600_cp.bin
+File: radeon/RS690_cp.bin
+File: radeon/R520_cp.bin
+
+Licence:
+/*
+ * Copyright 2007 Advanced Micro Devices, Inc.
+ * All Rights Reserved.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the next
+ * paragraph) shall be included in all copies or substantial portions of the
+ * Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * IN NO EVENT SHALL THE COPYRIGHT OWNER(S) AND/OR ITS SUPPLIERS BE
+ * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
+ * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
+ * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
+ *
+ */
+
+Found in hex form in kernel source.
+
+--------------------------------------------------------------------------
diff --git a/firmware/radeon/R100_cp.bin.ihex b/firmware/radeon/R100_cp.bin.ihex
new file mode 100644
index 0000000..151647b
--- /dev/null
+++ b/firmware/radeon/R100_cp.bin.ihex
@@ -0,0 +1,130 @@
+:1000000000000000210070000000000020007000CF
+:1000100000000004000000B400000004000000B86C
+:10002000000000006F5B4D4C000000004C4C427F14
+:10003000000000005B568A92000000004CA09C6DFE
+:1000400000000000AD4C4C4C000000004CE1AF3D06
+:1000500000000000D8AFAFAF00000000D64C4CDC71
+:10006000000000004CD10D1000000016000F000031
+:1000700000000000362F242D0000000400000012B4
+:1000800000000016000F000000000000362F282D91
+:1000900000000002000380E70000000204002C972B
+:1000A00000000016000F000100000000333A373056
+:1000B00000000002000077EF0000000200061000C0
+:1000C0000000001A000000210000001E0000400097
+:1000D00000000002000610000000001A00000021CD
+:1000E0000000001E0000400000000002000610009A
+:1000F0000000001A000000210000001E0000400067
+:100100000000000400000017000000020003802B24
+:1001100000000002040067E0000000040000001777
+:1001200000000002000077E000000002000650001E
+:1001300000000002000037E100000006040067E153
+:1001400000000002000077E000000002000077E1FC
+:1001500000000006000077E100000000FFFFFFFF45
+:100160000000000010000000000000020003802BCF
+:1001700000000006040067E0000000020000767541
+:100180000000000200007676000000020000767792
+:100190000000000600007678000000020003802CBA
+:1001A00000000002040026760000000200007677BE
+:1001B0000000000600007678000000180000002F04
+:1001C000000000180000002F0000000600000000E2
+:1001D000000000180000003000000018000000308F
+:1001E0000000000600000000000000020160500056
+:1001F000000000020006500000000002000980001C
+:1002000000000002000610000000000464C0603E10
+:1002100000000002000380E600000002040025C583
+:1002200000000016000800000000000000000000B0
+:10023000000000020400251D00000002000075807F
+:100240000000000200067581000000020400258005
+:100250000000000200067581000000040000004953
+:10026000000000000000500000000002000380E6D3
+:1002700000000002040025C5000000020006100076
+:10028000000000020000750E000000020001900056
+:10029000000000140001105500000012000000557D
+:1002A000000000020400250F000000040000504F71
+:1002B00000000002000380E600000002040025C5E3
+:1002C0000000000200007565000000020000756675
+:1002D000000000040000005800000002000380E657
+:1002E00000000002040025C50000000201E655B42C
+:1002F000000000024401B0E40000000201C110E46B
+:10030000000000182666706600000002040C2565D7
+:1003100000000018000000660000000204002564D0
+:100320000000000200007566000000040000005D8F
+:1003300000000008004010690000000200101000DA
+:1003400000000002000D80FF000000080080006C2B
+:1003500000000002000F900000000002000E00FFED
+:100360000000000600000000000000180000008FE0
+:10037000000000040000005B00000002000380E6B3
+:1003800000000002040025C5000000020000757690
+:100390000000000200065000000000020000900073
+:1003A0000000000200041000000000020C00350EE6
+:1003B0000000000200049000000000020005100090
+:1003C0000000000201E785F80000000200200000A4
+:1003D0000000000C0060007E000000020000756359
+:1003E00000000021006075F0000000042000707320
+:1003F000000000040000507300000002000380E6CB
+:1004000000000002040025C500000002000075760F
+:100410000000000200007577000000020000750E69
+:10042000000000020000750F0000000200A0500054
+:100430000000000C0060008300000021006075F0E7
+:1004400000000002000075F80000000400000083B6
+:1004500000000002000A750E00000002000380E6A2
+:1004600000000002040025C5000000020020750FF6
+:1004700000000004006000860000000200007570AB
+:100480000000000200007571000000060000757297
+:1004900000000002000380E600000002040025C501
+:1004A00000000002000050000000000200A0500008
+:1004B0000000000200007568000000020006100045
+:1004C0000000000C00000095000000020005800004
+:1004D000000000020C60756200000004000000973C
+:1004E00000000002000380E600000002040025C5B1
+:1004F000000000040060009600000000400070E56D
+:1005000000000002000380E600000002040025C590
+:1005100000000002000380E50000001C000000A8AD
+:1005200000000018000650AA00000002040025BBCD
+:1005300000000018000610AB00000000040075BCAD
+:1005400000000002000075BB00000000000075BC48
+:100550000000000600090000000000020009000081
+:1005600000000006000D800200000002000078324A
+:10057000000000020000500000000002000380E7BD
+:100580000000000204002C97000000020000782008
+:100590000000000200007821000000000000780048
+:1005A000000000020120000000000002200770008F
+:1005B0000000000201200000000000022000700086
+:1005C0000000000200061000000000020120751B60
+:1005D000000000028040750A000000028040750B98
+:1005E000000000020011000000000002000380E58E
+:1005F0000000001C000000C600000018000610AB40
+:1006000000000002844075BD00000018000610AA1A
+:1006100000000002840075BB00000018000610AB4B
+:1006200000000002844075BC00000004000000C906
+:1006300000000002804075BD00000002800075BB14
+:1006400000000002804075BC000000020010800025
+:1006500000000002014000000000000C006000CD1E
+:100660000000002020C0700000000012000000CF39
+:100670000000000600800000000000060080751DDC
+:100680000000000000000000000000020000775C95
+:100690000000000200A050000000000200661000F0
+:1006A000000000200460275D000000000000400002
+:1006B0000000000201E0083000000000210070008E
+:1006C000000000006464614D00000000696874204F
+:1006D00000000000000000730000000000000000A7
+:1006E000000000020000500000000002000380D063
+:1006F00000000002040025E000000000000075E199
+:10070000000000000000000100000002000380E083
+:1007100000000002040023940000000000005000CC
+:1007200000000000000000000000000000000000C9
+:1007300000000000000000080000000000000004AD
+:1007400000000000000000000000000000000000A9
+:100750000000000000000000000000000000000099
+:100760000000000000000000000000000000000089
+:100770000000000000000000000000000000000079
+:100780000000000000000000000000000000000069
+:100790000000000000000000000000000000000059
+:1007A0000000000000000000000000000000000049
+:1007B0000000000000000000000000000000000039
+:1007C0000000000000000000000000000000000029
+:1007D0000000000000000000000000000000000019
+:1007E0000000000000000000000000000000000009
+:1007F00000000000000000000000000000000000F9
+:00000001FF
+/* production radeon ucode r1xx-r6xx */
diff --git a/firmware/radeon/R200_cp.bin.ihex b/firmware/radeon/R200_cp.bin.ihex
new file mode 100644
index 0000000..3a0bd73
--- /dev/null
+++ b/firmware/radeon/R200_cp.bin.ihex
@@ -0,0 +1,130 @@
+:1000000000000000210070000000000020007000CF
+:1000100000000004000000BF00000004000000C356
+:10002000000000007A685E5D000000005D5D55889C
+:100030000000000068659197000000005DA19F78B6
+:10004000000000005D5D5D5D000000005DEE5D5044
+:1000500000000000F2ACACAC00000000E75DF9E984
+:1000600000000000B1DD0E1100000000E2AFAFAFF4
+:1000700000000016000F000000000000452F232D97
+:10008000000000040000001300000016000F000034
+:1000900000000000452F272D00000016000F000172
+:1000A000000000003E4D4A3700000002000077EFDC
+:1000B00000000002000610000000001A00000020EE
+:1000C0000000001E000040000000000200061000BA
+:1000D0000000001A000000200000001E0000400088
+:1000E00000000002000610000000001A00000020BE
+:1000F0000000001E00004000000000040000001688
+:10010000000000020003802A00000002040067E0F3
+:10011000000000040000001600000002000077E06C
+:10012000000000020006500000000002000037E15D
+:1001300000000006040067E100000002000077E014
+:1001400000000002000077E100000006000077E1F7
+:1001500000000000FFFFFFFF000000001000000093
+:100160000000000007F007F0000000020003802AF2
+:1001700000000006040067E0000000020003802C7D
+:100180000000000204002741000000020400274193
+:100190000000000204002743000000020000767502
+:1001A0000000000200007676000000020000767772
+:1001B0000000000600007678000000020003802C9A
+:1001C0000000000204002741000000020400274153
+:1001D00000000002040027430000000200007676C1
+:1001E000000000020000767700000006000076782C
+:1001F000000000020003802B0000000204002676AD
+:100200000000000200007677000000020003802C4E
+:100210000000000204002741000000020400274300
+:100220000000000600007678000000020003802C29
+:1002300000000002040027410000000204002741E2
+:10024000000000020400274300000006000076784A
+:10025000000000180000002F000000180000002F10
+:100260000000000600000000000000180000003739
+:100270000000001800000037000000060000000029
+:100280000000000201605000000000020006500063
+:1002900000000002000980000000000200061000BB
+:1002A0000000000464C06051000000160008000057
+:1002B0000000000000000000000000020400251DF6
+:1002C0000000000200007580000000020006758139
+:1002D0000000000204002580000000020006758175
+:1002E000000000040000005A000000000000500060
+:1002F0000000000200061000000000020000750E61
+:1003000000000002000190000000001400011064D1
+:100310000000001200000064000000020400250F2D
+:10032000000000040000505E00000002000075653F
+:100330000000000200007566000000040000006577
+:100340000000000201E655B4000000024401B0F0D4
+:100350000000000201C110F0000000182666707154
+:1003600000000002040C2565000000180000007168
+:100370000000000204002564000000020000756611
+:100380000000000400000068000000080040107435
+:10039000000000020010100000000002000D80FFAD
+:1003A000000000080080007700000002000F9000AD
+:1003B00000000002000E00FF000000060000000028
+:1003C0000000001800000094000000040000006815
+:1003D00000000002000075760000000200065000D8
+:1003E0000000000200009000000000020004100065
+:1003F000000000020C00350E000000020004900016
+:1004000000000002000510000000000201E785F86E
+:1004100000000002002000000000000C00600087C7
+:10042000000000020000756300000021006075F00C
+:10043000000000042000707C000000040000507CDC
+:1004400000000002000075760000000200007577D1
+:10045000000000020000750E000000020000750F91
+:100460000000000200A050000000000C0060008AA4
+:1004700000000021006075F000000002000075F827
+:10048000000000040000008A00000002000A750E4F
+:10049000000000020020750F000000040060008DC5
+:1004A000000000020000757000000002000075717D
+:1004B00000000006000075720000000200005000FD
+:1004C0000000000200A0500000000002000075685B
+:1004D00000000002000610000000000C0000009860
+:1004E0000000000200058000000000020C60756240
+:1004F000000000040000009A000000040060009961
+:1005000000000000400070F100000002000380F1D4
+:100510000000001C000000A700000018000650A901
+:1005200000000002040025BB00000018000610AA0D
+:1005300000000000040075BC00000002000075BB54
+:1005400000000000000075BC00000006000900006B
+:10055000000000020009000000000006000D8002FB
+:10056000000000020000500000000002000078219E
+:100570000000000000007800000000020000782168
+:10058000000000000000780000000002016650003A
+:1005900000000002000A000000000002000671CC0A
+:1005A000000000020286F1CD00000010000000B73C
+:1005B00000000000210070000000001C000000BED0
+:1005C000000000020006500000000002000A0000C7
+:1005D000000000020006100000000002000B0000F6
+:1005E000000000023806700000000004000A00BA93
+:1005F0000000000020007000000000020120000048
+:10060000000000022007700000000002012000002E
+:100610000000000020007000000000020006100032
+:10062000000000020120751B000000028040750AD6
+:10063000000000028040750B000000020011000065
+:1006400000000002000380F10000001C000000D147
+:1006500000000018000610AA00000002844075BDCA
+:1006600000000018000610A900000002840075BBFD
+:1006700000000018000610AA00000002844075BCAB
+:1006800000000004000000D400000002804075BD9E
+:1006900000000002800075BB00000002804075BCB5
+:1006A0000000000200108000000000020140000075
+:1006B0000000000C006000D80000002020C0700086
+:1006C00000000012000000DA0000000600800000B8
+:1006D000000000060080751D00000002000025BB20
+:1006E00000000004000040D4000000020000775C1D
+:1006F0000000000200A05000000000020066100090
+:10070000000000200460275D0000000000004000A1
+:1007100000000002000079990000000200A05000D3
+:100720000000000200661000000000200460299B09
+:1007300000000000000040000000000201E008305E
+:1007400000000000210070000000000200005000C6
+:10075000000000020003805600000002040025E0B3
+:1007600000000000000075E1000000000000000132
+:1007700000000002000380ED0000000004007394FC
+:100780000000000000000000000000000000000069
+:1007900000000002000078C400000002000078C5DC
+:1007A00000000002000078C600000002000079246A
+:1007B00000000002000079250000000200007926F8
+:1007C00000000004000000F2000000020000792494
+:1007D00000000002000079250000000200007926D8
+:1007E00000000004000000F900000000000000000C
+:1007F00000000000000000000000000000000000F9
+:00000001FF
+/* production radeon ucode r1xx-r6xx */
diff --git a/firmware/radeon/R300_cp.bin.ihex b/firmware/radeon/R300_cp.bin.ihex
new file mode 100644
index 0000000..d307d56
--- /dev/null
+++ b/firmware/radeon/R300_cp.bin.ihex
@@ -0,0 +1,130 @@
+:10000000000000004200E000000000004000E000AE
+:1000100000000008000000AE00000008000000B270
+:100020000000000067554B4A000000004A4A447532
+:100030000000000055527D83000000004A8C8B6553
+:10004000000000004AEF4AF6000000004AE14A4A78
+:1000500000000000E497979700000000DB4AEBDD0A
+:10006000000000009CCC4A4A00000000D1989898FB
+:10007000000000004A0F9AD600000004000CA00007
+:1000800000000038000D0012000000040000E8B479
+:1000900000000038000D0014000000040000E8B665
+:1000A00000000038000D0016000000040000E854B5
+:1000B00000000038000D0018000000040000E855A2
+:1000C00000000038000D001A000000040000E8568F
+:1000D00000000038000D001C000000040000E8577C
+:1000E00000000038000D001E000000040000E8249D
+:1000F00000000038000D0020000000040000E8258A
+:1001000000000038000D0022000000040000E8306C
+:1001100000000038000D0024000000040000F0C0C2
+:1001200000000038000D0026000000040000F0C1AF
+:1001300000000038000D0028000000040000F0411D
+:1001400000000038000D002A000000040000F184C7
+:1001500000000038000D002C000000040000F185B4
+:1001600000000038000D002E000000040000F186A1
+:1001700000000038000D0030000000040000F1878E
+:1001800000000038000D0032000000040000F18083
+:1001900000000038000D0034000000040000F3935C
+:1001A00000000038000D0036000000040000F38A53
+:1001B00000000038000D0038000000040000F38E3D
+:1001C000000000040000E821000000040140A0003D
+:1001D00000000018000000430000000400CCE8000C
+:1001E00000000004001B000100000004080048009B
+:1001F00000000004001B000100000004080048008B
+:1002000000000004001B000100000004080048007A
+:10021000000000080000003A000000000000A000FC
+:10022000000000042000451D000000040000E580DF
+:1002300000000004000CE581000000040800458077
+:1002400000000004000CE5810000000800000047E9
+:10025000000000000000A00000000004000C2000CE
+:10026000000000040000E50E000000040003200070
+:10027000000000280002205100000024000000516E
+:10028000000000040800450F000000080000A04B1B
+:10029000000000040000E565000000040000E566C1
+:1002A00000000008000000520000000403CCA5B4C8
+:1002B00000000004054320000000000400022000AC
+:1002C000000000304CCCE05E0000000408274565CB
+:1002D000000000300000005E0000000408004564DB
+:1002E000000000040000E566000000080000005562
+:1002F00000000010008020610000000400202000A9
+:1003000000000004001B00FF00000010010000645A
+:1003100000000004001F200000000004001C00FF7B
+:100320000000000C00000000000000300000008011
+:100330000000000800000055000000040000E57601
+:1003400000000004000CA0000000000400012000D8
+:100350000000000400082000000000041800650EE2
+:10036000000000040009200000000004000A200032
+:1003700000000004000F0000000000040040000026
+:100380000000001800000074000000040000E56395
+:10039000000000C200C0E5F900000008000000698C
+:1003A000000000080000A069000000040000E576DD
+:1003B000000000040000E577000000040000E50EE6
+:1003C000000000040000E50F000000040140A00050
+:1003D0000000001800000077000000C200C0E5F92E
+:1003E0000000000800000077000000040014E50E83
+:1003F000000000040040E50F0000000800C0007A83
+:10040000000000040000E570000000040000E57139
+:100410000000000C0000E572000000040000A000D5
+:10042000000000040140A000000000040000E56896
+:1004300000000004000C20000000001800000084F0
+:1004400000000004000B00000000000418C0E5627A
+:1004500000000008000000860000000800C00085C1
+:1004600000000004000700E30000003800000092D4
+:1004700000000030000CA09400000004080045BB00
+:1004800000000030000C2095000000000800E5BCD2
+:10049000000000040000E5BB000000000000E5BC17
+:1004A0000000000C00120000000000040012000018
+:1004B0000000000C001B0002000000040000A0006F
+:1004C000000000040000E821000000000000E80037
+:1004D000000000040000E821000000000000E82EF9
+:1004E0000000000402CCA000000000040014000082
+:1004F00000000004000CE1CC00000004050DE1CD7B
+:10050000000000040040000000000018000000A4EB
+:100510000000000400C0A00000000008000000A1CE
+:1005200000000020000000A6000000004200E000E3
+:1005300000000038000000AD00000004000CA00026
+:10054000000000040014000000000004000C200063
+:10055000000000040016000000000004700CE00021
+:1005600000000008001400A9000000004000E000A6
+:10057000000000040240000000000004400EE00003
+:100580000000000402400000000000004000E00005
+:1005900000000004000C2000000000040240E51BE5
+:1005A000000000050080E50A000000050080E50B62
+:1005B000000000040022000000000004000700E327
+:1005C00000000038000000C000000030000C209542
+:1005D000000000050880E5BD00000030000C2094FC
+:1005E000000000050800E5BB00000030000C20956D
+:1005F000000000050880E5BC00000008000000C302
+:10060000000000050080E5BD000000050000E5BB1E
+:10061000000000050080E5BC00000004002100008F
+:1006200000000004028000000000001800C000C7A5
+:10063000000000404180E00000000024000000C9EC
+:100640000000000C010000000000000C0100E51D8E
+:1006500000000004000045BB00000008000080C34B
+:10066000000000040000F3CE000000040140A000E0
+:100670000000000400CC20000000004008C053CF60
+:100680000000000000008000000000040000F3D221
+:10069000000000040140A0000000000400CC200085
+:1006A0000000004008C053D300000000000080009C
+:1006B000000000040000F39D000000040140A000C1
+:1006C0000000000400CC20000000004008C0539E41
+:1006D00000000000000080000000000403C008309B
+:1006E000000000004200E000000000040000A00044
+:1006F00000000004200045E0000000000000E5E1EB
+:10070000000000000000000100000004000700E0FD
+:10071000000000000800E39400000000000000005A
+:10072000000000040000E8C4000000040000E8C568
+:10073000000000040000E8C6000000040000E928F2
+:10074000000000040000E929000000040000E92A7C
+:1007500000000008000000E4000000040000E92898
+:10076000000000040000E929000000040000E92A5C
+:1007700000000008000000EB0000000402C02000A0
+:10078000000000040006000000000034000000F338
+:1007900000000008000000F00000000400008000DD
+:1007A00000000000C000E0000000000000000000A9
+:1007B00000000004000C200000000004001D0018D0
+:1007C00000000004001A000100000034000000FBDB
+:1007D000000000080000004A000000080500A04AD0
+:1007E0000000000000000000000000000000000009
+:1007F00000000000000000000000000000000000F9
+:00000001FF
+/* production radeon ucode r1xx-r6xx */
diff --git a/firmware/radeon/R420_cp.bin.ihex b/firmware/radeon/R420_cp.bin.ihex
new file mode 100644
index 0000000..3815891
--- /dev/null
+++ b/firmware/radeon/R420_cp.bin.ihex
@@ -0,0 +1,130 @@
+:10000000000000004200E000000000004000E000AE
+:100010000000000800000099000000080000009D9A
+:10002000000000004A554B4A000000004A4A44675D
+:100030000000000055526F75000000004A7E7D658B
+:1000400000000000D9D3DFF6000000004AC54A4A8C
+:1000500000000000C882828200000000BF4ACFC1B9
+:100060000000000087B04A4A00000000B583838387
+:10007000000000004A0F85BA00000004000CA00038
+:1000800000000038000D0012000000040000E8B479
+:1000900000000038000D0014000000040000E8B665
+:1000A00000000038000D0016000000040000E854B5
+:1000B00000000038000D0018000000040000E855A2
+:1000C00000000038000D001A000000040000E8568F
+:1000D00000000038000D001C000000040000E8577C
+:1000E00000000038000D001E000000040000E8249D
+:1000F00000000038000D0020000000040000E8258A
+:1001000000000038000D0022000000040000E8306C
+:1001100000000038000D0024000000040000F0C0C2
+:1001200000000038000D0026000000040000F0C1AF
+:1001300000000038000D0028000000040000F0411D
+:1001400000000038000D002A000000040000F184C7
+:1001500000000038000D002C000000040000F185B4
+:1001600000000038000D002E000000040000F186A1
+:1001700000000038000D0030000000040000F1878E
+:1001800000000038000D0032000000040000F18083
+:1001900000000038000D0034000000040000F3935C
+:1001A00000000038000D0036000000040000F38A53
+:1001B00000000038000D0038000000040000F38E3D
+:1001C000000000040000E821000000040140A0003D
+:1001D00000000018000000430000000400CCE8000C
+:1001E00000000004001B000100000004080048009B
+:1001F00000000004001B000100000004080048008B
+:1002000000000004001B000100000004080048007A
+:10021000000000080000003A000000000000A000FC
+:10022000000000042000451D000000040000E580DF
+:1002300000000004000CE581000000040800458077
+:1002400000000004000CE5810000000800000047E9
+:10025000000000000000A00000000004000C2000CE
+:10026000000000040000E50E000000040003200070
+:10027000000000280002205100000024000000516E
+:10028000000000040800450F000000080000A04B1B
+:10029000000000040000E565000000040000E566C1
+:1002A00000000008000000520000000403CCA5B4C8
+:1002B00000000004054320000000000400022000AC
+:1002C000000000304CCCE05E0000000408274565CB
+:1002D000000000300000005E0000000408004564DB
+:1002E000000000040000E566000000080000005562
+:1002F00000000010008020610000000400202000A9
+:1003000000000004001B00FF00000010010000645A
+:1003100000000004001F200000000004001C00FF7B
+:100320000000000C0000000000000030000000721F
+:100330000000000800000055000000040000E57601
+:10034000000000040000E577000000040000E50E56
+:10035000000000040000E50F000000040140A000C0
+:100360000000001800000069000000C200C0E5F9AC
+:100370000000000800000069000000040014E50E01
+:10038000000000040040E50F0000000800C0006C01
+:10039000000000040000E570000000040000E571AA
+:1003A0000000000C0000E572000000040000A00046
+:1003B000000000040140A000000000040000E56807
+:1003C00000000004000C200000000018000000766F
+:1003D00000000004000B00000000000418C0E562EB
+:1003E00000000008000000780000000800C000774E
+:1003F00000000004000700C7000000380000008073
+:10040000000000040000E5BB000000000000E5BCA7
+:10041000000000040000A000000000040000E8212B
+:10042000000000000000E800000000040000E821D7
+:10043000000000000000E82E0000000402CCA00034
+:10044000000000040014000000000004000CE1CCD7
+:1004500000000004050DE1CD000000040040000094
+:10046000000000180000008F0000000400C0A00081
+:10047000000000080000008C000000200000009137
+:10048000000000004200E00000000038000000987A
+:1004900000000004000CA000000000040014000094
+:1004A00000000004000C2000000000040016000002
+:1004B00000000004700CE00000000008001400942C
+:1004C000000000004000E0000000000402400000C6
+:1004D00000000004400EE0000000000402400000A4
+:1004E000000000004000E00000000004000C2000BC
+:1004F000000000040240E51B000000050080E50A42
+:10050000000000050080E50B000000040022000050
+:1005100000000004000700C700000038000000A42D
+:10052000000000050080E5BD000000050000E5BBFF
+:10053000000000050080E5BC000000040021000070
+:1005400000000004028000000000001800C000ABA2
+:10055000000000404180E00000000024000000ADE9
+:100560000000000C010000000000000C0100E51D6F
+:1005700000000004000045BB00000008000080A748
+:10058000000000040000F3CE000000040140A000C1
+:100590000000000400CC20000000004008C053CF41
+:1005A0000000000000008000000000040000F3D202
+:1005B000000000040140A0000000000400CC200066
+:1005C0000000004008C053D300000000000080007D
+:1005D000000000040000F39D000000040140A000A2
+:1005E0000000000400CC20000000004008C0539E22
+:1005F00000000000000080000000000403C008307C
+:10060000000000004200E000000000040000A00024
+:1006100000000004200045E0000000000000E5E1CB
+:10062000000000000000000100000004000700C4FA
+:10063000000000000800E39400000000000000003B
+:10064000000000040000E8C4000000040000E8C549
+:10065000000000040000E8C6000000040000E928D3
+:10066000000000040000E929000000040000E92A5D
+:1006700000000008000000C8000000040000E92895
+:10068000000000040000E929000000040000E92A3D
+:1006900000000008000000CF0000000402C020009D
+:1006A000000000040006000000000034000000D735
+:1006B00000000008000000D40000000400008000DA
+:1006C00000000000C000E000000000040000E1CCD9
+:1006D000000000040500E1CD00000004000CA000B3
+:1006E00000000034000000DE00000008000000DA16
+:1006F000000000000000A000000000040019E1CC90
+:1007000000000004001B0001000000040500A00020
+:1007100000000004080041CD00000004000CA0000F
+:1007200000000034000000FB000000080000004A48
+:1007300000000000000000000000000000000000B9
+:1007400000000000000000000000000000000000A9
+:100750000000000000000000000000000000000099
+:100760000000000000000000000000000000000089
+:100770000000000000000000000000000000000079
+:100780000000000000000000000000000000000069
+:100790000000000000000000000000000000000059
+:1007A0000000000000000000000000000000000049
+:1007B00000000004000C200000000004001D0018D0
+:1007C00000000004001A000100000034000000FBDB
+:1007D000000000080000004A000000080500A04AD0
+:1007E0000000000000000000000000000000000009
+:1007F00000000000000000000000000000000000F9
+:00000001FF
+/* production radeon ucode r1xx-r6xx */
diff --git a/firmware/radeon/R520_cp.bin.ihex b/firmware/radeon/R520_cp.bin.ihex
new file mode 100644
index 0000000..372ff82
--- /dev/null
+++ b/firmware/radeon/R520_cp.bin.ihex
@@ -0,0 +1,130 @@
+:10000000000000004200E000000000004000E000AE
+:100010000000000800000099000000080000009D9A
+:10002000000000004A554B4A000000004A4A44675D
+:100030000000000055526F75000000004A7E7D658B
+:1000400000000000E0DAE6F6000000004AC54A4A77
+:1000500000000000C882828200000000BF4ACFC1B9
+:100060000000000087B04AD500000000B5838383FC
+:10007000000000004A0F85BA00000004000CA00038
+:1000800000000038000D0012000000040000E8B479
+:1000900000000038000D0014000000040000E8B665
+:1000A00000000038000D0016000000040000E854B5
+:1000B00000000038000D0018000000040000E855A2
+:1000C00000000038000D001A000000040000E8568F
+:1000D00000000038000D001C000000040000E8577C
+:1000E00000000038000D001E000000040000E8249D
+:1000F00000000038000D0020000000040000E8258A
+:1001000000000038000D0022000000040000E8306C
+:1001100000000038000D0024000000040000F0C0C2
+:1001200000000038000D0026000000040000F0C1AF
+:1001300000000038000D0028000000040000E0006E
+:1001400000000038000D002A000000040000E0005C
+:1001500000000038000D002C000000040000E0004A
+:1001600000000038000D002E000000040000E00038
+:1001700000000038000D0030000000040000E00026
+:1001800000000038000D0032000000040000F18083
+:1001900000000038000D0034000000040000F3935C
+:1001A00000000038000D0036000000040000F38A53
+:1001B00000000038000D0038000000040000F38E3D
+:1001C000000000040000E821000000040140A0003D
+:1001D00000000018000000430000000400CCE8000C
+:1001E00000000004001B000100000004080048009B
+:1001F00000000004001B000100000004080048008B
+:1002000000000004001B000100000004080048007A
+:10021000000000080000003A000000000000A000FC
+:10022000000000042000451D000000040000E580DF
+:1002300000000004000CE581000000040800458077
+:1002400000000004000CE5810000000800000047E9
+:10025000000000000000A00000000004000C2000CE
+:10026000000000040000E50E000000040003200070
+:10027000000000280002205100000024000000516E
+:10028000000000040800450F000000080000A04B1B
+:10029000000000040000E565000000040000E566C1
+:1002A00000000008000000520000000403CCA5B4C8
+:1002B00000000004054320000000000400022000AC
+:1002C000000000304CCCE05E0000000408274565CB
+:1002D000000000300000005E0000000408004564DB
+:1002E000000000040000E566000000080000005562
+:1002F00000000010008020610000000400202000A9
+:1003000000000004001B00FF00000010010000645A
+:1003100000000004001F200000000004001C00FF7B
+:100320000000000C0000000000000030000000721F
+:100330000000000800000055000000040000E57601
+:10034000000000040000E577000000040000E50E56
+:10035000000000040000E50F000000040140A000C0
+:100360000000001800000069000000C200C0E5F9AC
+:100370000000000800000069000000040014E50E01
+:10038000000000040040E50F0000000800C0006C01
+:10039000000000040000E570000000040000E571AA
+:1003A0000000000C0000E572000000040000A00046
+:1003B000000000040140A000000000040000E56807
+:1003C00000000004000C200000000018000000766F
+:1003D00000000004000B00000000000418C0E562EB
+:1003E00000000008000000780000000800C000774E
+:1003F00000000004000700C7000000380000008073
+:10040000000000040000E5BB000000000000E5BCA7
+:10041000000000040000A000000000040000E8212B
+:10042000000000000000E800000000040000E821D7
+:10043000000000000000E82E0000000402CCA00034
+:10044000000000040014000000000004000CE1CCD7
+:1004500000000004050DE1CD000000040040000094
+:10046000000000180000008F0000000400C0A00081
+:10047000000000080000008C000000200000009137
+:10048000000000004200E00000000038000000987A
+:1004900000000004000CA000000000040014000094
+:1004A00000000004000C2000000000040016000002
+:1004B00000000004700CE00000000008001400942C
+:1004C000000000004000E0000000000402400000C6
+:1004D00000000004400EE0000000000402400000A4
+:1004E000000000004000E00000000004000C2000BC
+:1004F000000000040240E51B000000050080E50A42
+:10050000000000050080E50B000000040022000050
+:1005100000000004000700C700000038000000A42D
+:10052000000000050080E5BD000000050000E5BBFF
+:10053000000000050080E5BC000000040021000070
+:1005400000000004028000000000001800C000ABA2
+:10055000000000404180E00000000024000000ADE9
+:100560000000000C010000000000000C0100E51D6F
+:1005700000000004000045BB00000008000080A748
+:10058000000000040000F3CE000000040140A000C1
+:100590000000000400CC20000000004008C053CF41
+:1005A0000000000000008000000000040000F3D202
+:1005B000000000040140A0000000000400CC200066
+:1005C0000000004008C053D300000000000080007D
+:1005D000000000040000F39D000000040140A000A2
+:1005E0000000000400CC20000000004008C0539E22
+:1005F00000000000000080000000000403C008307C
+:10060000000000004200E000000000040000A00024
+:1006100000000004200045E0000000000000E5E1CB
+:10062000000000000000000100000004000700C4FA
+:10063000000000000800E39400000000000000003B
+:10064000000000040000E8C4000000040000E8C549
+:10065000000000040000E8C6000000040000E928D3
+:10066000000000040000E929000000040000E92A5D
+:1006700000000008000000C8000000040000E92895
+:10068000000000040000E929000000040000E92A3D
+:1006900000000008000000CF00000000DEADBEEF4B
+:1006A000000000000000011600000004000700D355
+:1006B00000000004080050E700000004000700D418
+:1006C000000000040800401C000000000000E01DC5
+:1006D0000000000402C0200000000004000600002A
+:1006E00000000034000000DE00000008000000DB15
+:1006F000000000040000800000000000C000E000D6
+:10070000000000040000E1CC000000040500E1CD81
+:1007100000000004000CA00000000034000000E510
+:1007200000000008000000E1000000000000A00040
+:10073000000000040019E1CC00000004001B0001CF
+:10074000000000040500A00000000004080041CDE6
+:1007500000000004000CA00000000034000000FBBA
+:10076000000000080000004A000000000000000037
+:100770000000000000000000000000000000000079
+:100780000000000000000000000000000000000069
+:100790000000000000000000000000000000000059
+:1007A0000000000000000000000000000000000049
+:1007B00000000004000C200000000004001D0018D0
+:1007C00000000004001A000100000034000000FBDB
+:1007D000000000080000004A000000080500A04AD0
+:1007E0000000000000000000000000000000000009
+:1007F00000000000000000000000000000000000F9
+:00000001FF
+/* production radeon ucode r1xx-r6xx */
diff --git a/firmware/radeon/RS600_cp.bin.ihex b/firmware/radeon/RS600_cp.bin.ihex
new file mode 100644
index 0000000..4a89501
--- /dev/null
+++ b/firmware/radeon/RS600_cp.bin.ihex
@@ -0,0 +1,130 @@
+:10000000000000004200E000000000004000E000AE
+:1000100000000008000000A000000008000000A48C
+:10002000000000004A554B4A000000004A4A44675D
+:100030000000000055526F75000000004A7E7D658B
+:10004000000000004AE74AF6000000004AD34A4A8E
+:1000500000000000D689898900000000CD4ADDCF6C
+:10006000000000008EBE4AE200000000C38A8A8AB7
+:10007000000000004A0F8CC800000004000CA00023
+:1000800000000038000D0012000000040000E8B479
+:1000900000000038000D0014000000040000E8B665
+:1000A00000000038000D0016000000040000E854B5
+:1000B00000000038000D0018000000040000E855A2
+:1000C00000000038000D001A000000040000E8568F
+:1000D00000000038000D001C000000040000E8577C
+:1000E00000000038000D001E000000040000E8249D
+:1000F00000000038000D0020000000040000E8258A
+:1001000000000038000D0022000000040000E8306C
+:1001100000000038000D0024000000040000F0C0C2
+:1001200000000038000D0026000000040000F0C1AF
+:1001300000000038000D0028000000040000F0411D
+:1001400000000038000D002A000000040000F184C7
+:1001500000000038000D002C000000040000F185B4
+:1001600000000038000D002E000000040000F186A1
+:1001700000000038000D0030000000040000F1878E
+:1001800000000038000D0032000000040000F18083
+:1001900000000038000D0034000000040000F3935C
+:1001A00000000038000D0036000000040000F38A53
+:1001B00000000038000D0038000000040000F38E3D
+:1001C000000000040000E821000000040140A0003D
+:1001D00000000018000000430000000400CCE8000C
+:1001E00000000004001B000100000004080048009B
+:1001F00000000004001B000100000004080048008B
+:1002000000000004001B000100000004080048007A
+:10021000000000080000003A000000000000A000FC
+:10022000000000042000451D000000040000E580DF
+:1002300000000004000CE581000000040800458077
+:1002400000000004000CE5810000000800000047E9
+:10025000000000000000A00000000004000C2000CE
+:10026000000000040000E50E000000040003200070
+:10027000000000280002205100000024000000516E
+:10028000000000040800450F000000080000A04B1B
+:10029000000000040000E565000000040000E566C1
+:1002A00000000008000000520000000403CCA5B4C8
+:1002B00000000004054320000000000400022000AC
+:1002C000000000304CCCE05E0000000408274565CB
+:1002D000000000300000005E0000000408004564DB
+:1002E000000000040000E566000000080000005562
+:1002F00000000010008020610000000400202000A9
+:1003000000000004001B00FF00000010010000645A
+:1003100000000004001F200000000004001C00FF7B
+:100320000000000C0000000000000030000000721F
+:100330000000000800000055000000040000E57601
+:10034000000000040000E577000000040000E50E56
+:10035000000000040000E50F000000040140A000C0
+:100360000000001800000069000000C200C0E5F9AC
+:100370000000000800000069000000040014E50E01
+:10038000000000040040E50F0000000800C0006C01
+:10039000000000040000E570000000040000E571AA
+:1003A0000000000C0000E572000000040000A00046
+:1003B000000000040140A000000000040000E56807
+:1003C00000000004000C200000000018000000766F
+:1003D00000000004000B00000000000418C0E562EB
+:1003E00000000008000000780000000800C000774E
+:1003F00000000004000700D5000000380000008461
+:1004000000000030000CA08600000004080045BB7E
+:1004100000000030000C2087000000000800E5BC50
+:10042000000000040000E5BB000000000000E5BC87
+:100430000000000C00120000000000040012000088
+:100440000000000C001B0002000000040000A000DF
+:10045000000000040000E821000000000000E800A7
+:10046000000000040000E821000000000000E82E69
+:100470000000000402CCA0000000000400140000F2
+:1004800000000004000CE1CC00000004050DE1CDEB
+:10049000000000040040000000000018000000966A
+:1004A0000000000400C0A00000000008000000934D
+:1004B0000000002000000098000000004200E00062
+:1004C000000000380000009F00000004000CA000A5
+:1004D000000000040014000000000004000C2000D4
+:1004E000000000040016000000000004700CE00092
+:1004F000000000080014009B000000004000E00025
+:10050000000000040240000000000004400EE00073
+:100510000000000402400000000000004000E00075
+:1005200000000004000C2000000000040240E51B55
+:10053000000000050080E50A000000050080E50BD2
+:10054000000000040022000000000004000700D5A5
+:1005500000000038000000B200000030000C2087CE
+:10056000000000050880E5BD00000030000C20867A
+:10057000000000050800E5BB00000030000C2087EB
+:10058000000000050880E5BC00000008000000B580
+:10059000000000050080E5BD000000050000E5BB8F
+:1005A000000000050080E5BC000000040021000000
+:1005B00000000004028000000000001800C000B924
+:1005C000000000404180E00000000024000000BB6B
+:1005D0000000000C010000000000000C0100E51DFF
+:1005E00000000004000045BB00000008000080B5CA
+:1005F000000000040000F3CE000000040140A00051
+:100600000000000400CC20000000004008C053CFD0
+:100610000000000000008000000000040000F3D291
+:10062000000000040140A0000000000400CC2000F5
+:100630000000004008C053D300000000000080000C
+:10064000000000040000F39D000000040140A00031
+:100650000000000400CC20000000004008C0539EB1
+:1006600000000000000080000000000403C008300B
+:10067000000000004200E000000000040000A000B4
+:1006800000000004200045E0000000000000E5E15B
+:10069000000000000000000100000004000700D27C
+:1006A000000000000800E3940000000000000000CB
+:1006B000000000040000E8C4000000040000E8C5D9
+:1006C000000000040000E8C6000000040000E92863
+:1006D000000000040000E929000000040000E92AED
+:1006E00000000008000000D6000000040000E92817
+:1006F000000000040000E929000000040000E92ACD
+:1007000000000008000000DD0000000000E001160D
+:1007100000000004000700E1000000040800401C85
+:1007200000000004200050E7000000040000E01D6D
+:1007300000000008000000E40000000402C02000E7
+:10074000000000040006000000000034000000EB80
+:1007500000000008000000E8000000040000800025
+:1007600000000000C000E0000000000000000000E9
+:100770000000000000000000000000000000000079
+:100780000000000000000000000000000000000069
+:100790000000000000000000000000000000000059
+:1007A0000000000000000000000000000000000049
+:1007B00000000004000C200000000004001D0018D0
+:1007C00000000004001A000100000034000000FBDB
+:1007D000000000080000004A000000080500A04AD0
+:1007E0000000000000000000000000000000000009
+:1007F00000000000000000000000000000000000F9
+:00000001FF
+/* production radeon ucode r1xx-r6xx */
diff --git a/firmware/radeon/RS690_cp.bin.ihex b/firmware/radeon/RS690_cp.bin.ihex
new file mode 100644
index 0000000..6896274
--- /dev/null
+++ b/firmware/radeon/RS690_cp.bin.ihex
@@ -0,0 +1,130 @@
+:1000000000000008000000DD00000008000000DF24
+:1000100000000008000000A000000008000000A48C
+:10002000000000004A554B4A000000004A4A44675D
+:100030000000000055526F75000000004A7E7D658B
+:10004000000000004AD74AF6000000004AC94A4AA8
+:1000500000000000CC89898900000000C34AD3C594
+:10006000000000008E4A4A4A000000004A8A8A8A3C
+:10007000000000004A0F8C4A00000004000CA000A1
+:1000800000000038000D0012000000040000E8B479
+:1000900000000038000D0014000000040000E8B665
+:1000A00000000038000D0016000000040000E854B5
+:1000B00000000038000D0018000000040000E855A2
+:1000C00000000038000D001A000000040000E8568F
+:1000D00000000038000D001C000000040000E8577C
+:1000E00000000038000D001E000000040000E8249D
+:1000F00000000038000D0020000000040000E8258A
+:1001000000000038000D0022000000040000E8306C
+:1001100000000038000D0024000000040000F0C0C2
+:1001200000000038000D0026000000040000F0C1AF
+:1001300000000038000D0028000000040000F0411D
+:1001400000000038000D002A000000040000F184C7
+:1001500000000038000D002C000000040000F185B4
+:1001600000000038000D002E000000040000F186A1
+:1001700000000038000D0030000000040000F1878E
+:1001800000000038000D0032000000040000F18083
+:1001900000000038000D0034000000040000F3935C
+:1001A00000000038000D0036000000040000F38A53
+:1001B00000000038000D0038000000040000F38E3D
+:1001C000000000040000E821000000040140A0003D
+:1001D00000000018000000430000000400CCE8000C
+:1001E00000000004001B000100000004080048009B
+:1001F00000000004001B000100000004080048008B
+:1002000000000004001B000100000004080048007A
+:10021000000000080000003A000000000000A000FC
+:10022000000000042000451D000000040000E580DF
+:1002300000000004000CE581000000040800458077
+:1002400000000004000CE5810000000800000047E9
+:10025000000000000000A00000000004000C2000CE
+:10026000000000040000E50E000000040003200070
+:10027000000000280002205100000024000000516E
+:10028000000000040800450F000000080000A04B1B
+:10029000000000040000E565000000040000E566C1
+:1002A00000000008000000520000000403CCA5B4C8
+:1002B00000000004054320000000000400022000AC
+:1002C000000000304CCCE05E0000000408274565CB
+:1002D000000000300000005E0000000408004564DB
+:1002E000000000040000E566000000080000005562
+:1002F00000000010008020610000000400202000A9
+:1003000000000004001B00FF00000010010000645A
+:1003100000000004001F200000000004001C00FF7B
+:100320000000000C0000000000000030000000721F
+:100330000000000800000055000000040000E57601
+:10034000000000040000E577000000040000E50E56
+:10035000000000040000E50F000000040140A000C0
+:100360000000001800000069000000C200C0E5F9AC
+:100370000000000800000069000000040014E50E01
+:10038000000000040040E50F0000000800C0006C01
+:10039000000000040000E570000000040000E571AA
+:1003A0000000000C0000E572000000040000A00046
+:1003B000000000040140A000000000040000E56807
+:1003C00000000004000C200000000018000000766F
+:1003D00000000004000B00000000000418C0E562EB
+:1003E00000000008000000780000000800C000774E
+:1003F00000000004000700CB00000038000000846B
+:1004000000000030000CA08600000004080045BB7E
+:1004100000000030000C2087000000000800E5BC50
+:10042000000000040000E5BB000000000000E5BC87
+:100430000000000C00120000000000040012000088
+:100440000000000C001B0002000000040000A000DF
+:10045000000000040000E821000000000000E800A7
+:10046000000000040000E821000000000000E82E69
+:100470000000000402CCA0000000000400140000F2
+:1004800000000004000CE1CC00000004050DE1CDEB
+:10049000000000040040000000000018000000966A
+:1004A0000000000400C0A00000000008000000934D
+:1004B0000000002000000098000000004200E00062
+:1004C000000000380000009F00000004000CA000A5
+:1004D000000000040014000000000004000C2000D4
+:1004E000000000040016000000000004700CE00092
+:1004F000000000080014009B000000004000E00025
+:10050000000000040240000000000004400EE00073
+:100510000000000402400000000000004000E00075
+:100520000000002C0010000000000000000040004F
+:1005300000000004080045C8000000040024000575
+:100540000000000408004D0B00000004000C200017
+:10055000000000040240E51B000000050080E50AE1
+:10056000000000050080E50B0000000400220000F0
+:1005700000000004000700CB00000038000000B7B6
+:1005800000000030000C2087000000050880E5BD59
+:1005900000000030000C2086000000050800E5BBCC
+:1005A00000000030000C2087000000050880E5BC3A
+:1005B00000000008000000BA000000050080E5BD52
+:1005C000000000050000E5BB000000050080E5BC60
+:1005D0000000000400210000000000040280000070
+:1005E0000000001800C000BE000000404180E00094
+:1005F00000000024000000C00000000C010000000A
+:100600000000000C0100E51D00000004000045BBD7
+:1006100000000008000080BA0000000403C0083099
+:10062000000000004200E000000000040000A00004
+:1006300000000004200045E0000000000000E5E1AB
+:10064000000000000000000100000004000700C8D6
+:10065000000000000800E39400000000000000001B
+:10066000000000040000E8C4000000040000E8C529
+:10067000000000040000E8C6000000040000E928B3
+:10068000000000040000E929000000040000E92A3D
+:1006900000000008000000CC000000040000E92871
+:1006A000000000040000E929000000040000E92A1D
+:1006B00000000008000000D30000000402C0200079
+:1006C000000000040006000000000034000000DB11
+:1006D00000000008000000D80000000400008000B6
+:1006E00000000000C000E00000000030000000E159
+:1006F000000000004200E00000000030000000E1C7
+:10070000000000004000E000000000040025001B85
+:100710000000000400230000000000040025000584
+:1007200000000034000000E60000000C00000000A3
+:10073000000000040024400000000004080045C838
+:1007400000000004002400050000000C08004D0B10
+:100750000000000000000000000000000000000099
+:100760000000000000000000000000000000000089
+:100770000000000000000000000000000000000079
+:100780000000000000000000000000000000000069
+:100790000000000000000000000000000000000059
+:1007A0000000000000000000000000000000000049
+:1007B00000000004000C200000000004001D0018D0
+:1007C00000000004001A000100000034000000FBDB
+:1007D000000000080000004A000000080500A04AD0
+:1007E0000000000000000000000000000000000009
+:1007F00000000000000000000000000000000000F9
+:00000001FF
+/* production radeon ucode r1xx-r6xx */
-- 
1.6.0.6



