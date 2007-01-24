Return-Path: <linux-kernel-owner+w=401wt.eu-S1751258AbXAXL0D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751258AbXAXL0D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 06:26:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751197AbXAXL0B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 06:26:01 -0500
Received: from ipmail03.adl2.internode.on.net ([203.16.214.135]:11519 "EHLO
	ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751258AbXAXLZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 06:25:50 -0500
X-IronPort-AV: i="4.13,231,1167571800"; 
   d="scan'208"; a="39454279:sNHT43911350"
From: airlied@linux.ie
To: linux-kernel@vger.kernel.org
Cc: Dave Airlie <airlied@linux.ie>
Subject: [PATCH] drm/gpu/radeon: Add radeon DRM support to use GPU layer
Date: Wed, 24 Jan 2007 22:20:23 +1100
Message-Id: <11696376452577-git-send-email-airlied@linux.ie>
X-Mailer: git-send-email 1.4.1.ga3e6
In-Reply-To: <1169637642487-git-send-email-airlied@linux.ie>
References: <1169637623985-git-send-email-airlied@linux.ie> <11696376332395-git-send-email-airlied@linux.ie> <11696376362911-git-send-email-airlied@linux.ie> <11696376384021-git-send-email-airlied@linux.ie> <1169637642487-git-send-email-airlied@linux.ie>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Airlie <airlied@linux.ie>

This ports the radeon DRM to use the GPU layer to bind to the PCI device.

Signed-off-by: Dave Airlie <airlied@linux.ie>
---
 drivers/char/drm/Kconfig      |    1 +
 drivers/char/drm/radeon_drv.c |   54 ++++++++++++++++++++++++++++++++++++-----
 drivers/char/drm/radeon_drv.h |    4 ++-
 3 files changed, 50 insertions(+), 9 deletions(-)

diff --git a/drivers/char/drm/Kconfig b/drivers/char/drm/Kconfig
index ef833a1..18cf194 100644
--- a/drivers/char/drm/Kconfig
+++ b/drivers/char/drm/Kconfig
@@ -34,6 +34,7 @@ config DRM_R128
 config DRM_RADEON
 	tristate "ATI Radeon"
 	depends on DRM && PCI
+	select GPU_RADEON
 	help
 	  Choose this option if you have an ATI Radeon graphics card.  There
 	  are both PCI and AGP versions.  You don't need to choose this to
diff --git a/drivers/char/drm/radeon_drv.c b/drivers/char/drm/radeon_drv.c
index 2eb652e..d8911bc 100644
--- a/drivers/char/drm/radeon_drv.c
+++ b/drivers/char/drm/radeon_drv.c
@@ -31,6 +31,8 @@
 
 #include "drmP.h"
 #include "drm.h"
+#include <linux/pm.h>
+#include <linux/radeon_gpu.h>
 #include "radeon_drm.h"
 #include "radeon_drv.h"
 
@@ -52,10 +54,23 @@ static int dri_library_name(struct drm_d
 		        "r300"));
 }
 
+static int __devinit radeondrm_gpu_register (struct gpu_device *gdev, void *driver_id);
+static void __devexit radeondrm_gpu_unregister (struct gpu_device *gdev);
+
 static struct pci_device_id pciidlist[] = {
 	radeon_PCI_IDS
 };
 
+static int radeondrm_suspend(struct device *dev, pm_message_t state)
+{
+	return 0;
+}
+
+static int radeondrm_resume(struct device *dev)
+{
+	return 0;
+}
+
 static struct drm_driver driver = {
 	.driver_features =
 	    DRIVER_USE_AGP | DRIVER_USE_MTRR | DRIVER_PCI_DMA | DRIVER_SG |
@@ -92,12 +107,18 @@ #ifdef CONFIG_COMPAT
 		 .compat_ioctl = radeon_compat_ioctl,
 #endif
 	},
-
-	.pci_driver = {
+	.drv_type = DRM_DRV_GPU,
+	.gpu_driver = {
 		 .name = DRIVER_NAME,
-		 .id_table = pciidlist,
-	},
-
+		 .drv_type = GPU_DRM,
+		 .driver = {
+		             .suspend = radeondrm_suspend,
+			     .resume = radeondrm_resume,
+		 },
+		 .probe = radeondrm_gpu_register,
+		 .remove = __devexit_p(radeondrm_gpu_unregister),
+		 .id_table = (void *)pciidlist,
+	 },
 	.name = DRIVER_NAME,
 	.desc = DRIVER_DESC,
 	.date = DRIVER_DATE,
@@ -106,15 +127,34 @@ #endif
 	.patchlevel = DRIVER_PATCHLEVEL,
 };
 
+
+static int __devinit radeondrm_gpu_register(struct gpu_device *gdev, void *driver_id)
+{
+	int retval;
+	struct radeon_gpu_info *gpu_info;
+
+	gpu_info = dev_get_drvdata(gdev->dev.parent);
+
+	retval = drm_gpu_get_dev(gdev, &driver, driver_id, gpu_info->pdev);
+	return retval;
+}
+
+static void __devexit radeondrm_gpu_unregister (struct gpu_device *gdev)
+{
+	drm_gpu_cleanup(gdev);
+}
+
 static int __init radeon_init(void)
 {
 	driver.num_ioctls = radeon_max_ioctl;
-	return drm_init(&driver);
+	drm_mem_init();
+
+	return radeon_gpu_register_driver(&driver.gpu_driver, THIS_MODULE);
 }
 
 static void __exit radeon_exit(void)
 {
-	drm_exit(&driver);
+	gpu_unregister_driver(&driver.gpu_driver);
 }
 
 module_init(radeon_init);
diff --git a/drivers/char/drm/radeon_drv.h b/drivers/char/drm/radeon_drv.h
index 8b105f1..650fc8e 100644
--- a/drivers/char/drm/radeon_drv.h
+++ b/drivers/char/drm/radeon_drv.h
@@ -103,7 +103,7 @@ #define DRIVER_PATCHLEVEL	0
 /*
  * Radeon chip families
  */
-enum radeon_family {
+enum radeondrm_family {
 	CHIP_R100,
 	CHIP_RV100,
 	CHIP_RS100,
@@ -132,7 +132,7 @@ enum radeon_cp_microcode_version {
 /*
  * Chip flags
  */
-enum radeon_chip_flags {
+enum radeondrm_chip_flags {
 	RADEON_FAMILY_MASK = 0x0000ffffUL,
 	RADEON_FLAGS_MASK = 0xffff0000UL,
 	RADEON_IS_MOBILITY = 0x00010000UL,
-- 
1.4.1.ga3e6
