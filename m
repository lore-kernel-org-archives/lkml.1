Return-Path: <linux-kernel-owner+w=401wt.eu-S1757695AbZGPPud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757695AbZGPPud (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 11:50:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757694AbZGPPuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 11:50:32 -0400
Received: from smtp.nokia.com ([192.100.105.134]:17064 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757600AbZGPPu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 11:50:29 -0400
From: Tiago Vignatti <tiago.vignatti@nokia.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Dave Airlie <airlied@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] drm: add support to drm for VGA arbitration.
Date: Thu, 16 Jul 2009 18:48:31 +0300
Message-Id: <1247759311-6254-4-git-send-email-tiago.vignatti@nokia.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1247759311-6254-3-git-send-email-tiago.vignatti@nokia.com>
References: <1247759311-6254-1-git-send-email-tiago.vignatti@nokia.com>
 <1247759311-6254-2-git-send-email-tiago.vignatti@nokia.com>
 <1247759311-6254-3-git-send-email-tiago.vignatti@nokia.com>
X-OriginalArrivalTime: 16 Jul 2009 15:49:50.0015 (UTC) FILETIME=[0D506CF0:01CA062D]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Airlie <airlied@redhat.com>

This adds 3 things to the drm,

for non-modesetting drivers, it adds an irq hook
for the vga arb to disable/enable irqs around vga arb times.

radeon/kms: adds support to disable VGA decoding on r100->r500 under KMS
intel/kms: add support to disable VGA decoding on hopefully all Intel GPUs

Signed-off-by: Dave Airlie <airlied@redhat.com>
Acked-by: Tiago Vignatti <tiago.vignatti@nokia.com>
---
 drivers/gpu/drm/drm_irq.c              |   24 ++++++++++++++++++++++++
 drivers/gpu/drm/i915/i915_dma.c        |    6 ++++++
 drivers/gpu/drm/i915/i915_reg.h        |    1 +
 drivers/gpu/drm/i915/intel_display.c   |   17 +++++++++++++++++
 drivers/gpu/drm/i915/intel_drv.h       |    1 +
 drivers/gpu/drm/radeon/r100.c          |    9 +++++++++
 drivers/gpu/drm/radeon/radeon.h        |    2 ++
 drivers/gpu/drm/radeon/radeon_asic.h   |    9 +++++++++
 drivers/gpu/drm/radeon/radeon_device.c |    5 ++++-
 include/drm/drmP.h                     |    3 +++
 10 files changed, 76 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/drm_irq.c b/drivers/gpu/drm/drm_irq.c
index b4a3dbc..436889e 100644
--- a/drivers/gpu/drm/drm_irq.c
+++ b/drivers/gpu/drm/drm_irq.c
@@ -37,6 +37,7 @@
 
 #include <linux/interrupt.h>	/* For task queue support */
 
+#include <linux/vgaarb.h>
 /**
  * Get interrupt from bus id.
  *
@@ -171,6 +172,23 @@ err:
 }
 EXPORT_SYMBOL(drm_vblank_init);
 
+static void drm_irq_vgaarb_nokms(void *cookie, bool state)
+{
+	struct drm_device *dev = cookie;
+
+	if (dev->driver->vgaarb_irq) {
+		dev->driver->vgaarb_irq(dev, state);
+		return;
+	}
+
+	if (state)
+		dev->driver->irq_uninstall(dev);
+	else {
+		dev->driver->irq_preinstall(dev);
+		dev->driver->irq_postinstall(dev);
+	}
+}
+
 /**
  * Install IRQ handler.
  *
@@ -231,6 +249,9 @@ int drm_irq_install(struct drm_device *dev)
 		return ret;
 	}
 
+	if (!drm_core_check_feature(dev, DRIVER_MODESET))
+		vga_set_irq_callback(dev->pdev, (void *)dev, drm_irq_vgaarb_nokms);
+
 	/* After installing handler */
 	ret = dev->driver->irq_postinstall(dev);
 	if (ret < 0) {
@@ -279,6 +300,9 @@ int drm_irq_uninstall(struct drm_device * dev)
 
 	DRM_DEBUG("irq=%d\n", dev->pdev->irq);
 
+	if (!drm_core_check_feature(dev, DRIVER_MODESET))
+		vga_set_irq_callback(dev->pdev, NULL, NULL);
+
 	dev->driver->irq_uninstall(dev);
 
 	free_irq(dev->pdev->irq, dev);
diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 8c47831..391e496 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -33,6 +33,7 @@
 #include "i915_drm.h"
 #include "i915_drv.h"
 
+#include <linux/vgaarb.h>
 #define I915_DRV	"i915_drv"
 
 /* Really want an OS-independent resettable timer.  Would like to have
@@ -1029,6 +1030,11 @@ static int i915_load_modeset_init(struct drm_device *dev,
 	if (ret)
 		DRM_INFO("failed to find VBIOS tables\n");
 
+	/* tell the VGA arbiter to set off */
+	ret = intel_modeset_vga_disable(dev);
+	if (ret == 0)
+		vga_set_legacy_decoding(dev->pdev, VGA_RSRC_NONE);
+
 	ret = drm_irq_install(dev);
 	if (ret)
 		goto destroy_ringbuffer;
diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 6c08584..3e3145e 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -30,6 +30,7 @@
  * fb aperture size and the amount of pre-reserved memory.
  */
 #define INTEL_GMCH_CTRL		0x52
+#define INTEL_GMCH_VGA_DISABLE  (1 << 1)
 #define INTEL_GMCH_ENABLED	0x4
 #define INTEL_GMCH_MEM_MASK	0x1
 #define INTEL_GMCH_MEM_64M	0x1
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 508838e..ad7ef01 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -3188,3 +3188,20 @@ struct drm_encoder *intel_best_encoder(struct drm_connector *connector)
 
 	return &intel_output->enc;
 }
+
+int intel_modeset_vga_disable(struct drm_device *dev)
+{
+	struct pci_dev *bridge_dev;
+	u16 gmch_ctrl;
+
+	bridge_dev = pci_get_bus_and_slot(0, PCI_DEVFN(0, 0));
+	if (!bridge_dev) {
+		DRM_ERROR("Can't disable VGA, no bridge\n");
+		return -1;
+	}
+
+	pci_read_config_word(bridge_dev, INTEL_GMCH_CTRL, &gmch_ctrl);
+	gmch_ctrl |= INTEL_GMCH_VGA_DISABLE;
+	pci_write_config_word(bridge_dev, INTEL_GMCH_CTRL, gmch_ctrl);
+	return 0;
+}
diff --git a/drivers/gpu/drm/i915/intel_drv.h b/drivers/gpu/drm/i915/intel_drv.h
index 004541c..ab5be5b 100644
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -154,4 +154,5 @@ extern int intel_framebuffer_create(struct drm_device *dev,
 				    struct drm_mode_fb_cmd *mode_cmd,
 				    struct drm_framebuffer **fb,
 				    struct drm_gem_object *obj);
+extern int intel_modeset_vga_disable(struct drm_device *dev);
 #endif /* __INTEL_DRV_H__ */
diff --git a/drivers/gpu/drm/radeon/r100.c b/drivers/gpu/drm/radeon/r100.c
index c550932..1fa6723 100644
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -1256,6 +1256,15 @@ static void r100_vram_get_type(struct radeon_device *rdev)
 	}
 }
 
+void r100_vga_disable(struct radeon_device *rdev)
+{
+	uint32_t temp;
+	temp = RREG32(RADEON_CONFIG_CNTL);
+	temp &= ~(1<<8);
+	temp |= (1<<9);
+	WREG32(RADEON_CONFIG_CNTL, temp);
+}
+
 void r100_vram_info(struct radeon_device *rdev)
 {
 	r100_vram_get_type(rdev);
diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index d61f2fc..583bfb2 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -499,6 +499,7 @@ struct radeon_asic {
 	int (*init)(struct radeon_device *rdev);
 	void (*errata)(struct radeon_device *rdev);
 	void (*vram_info)(struct radeon_device *rdev);
+	void (*vga_disable)(struct radeon_device *rdev);
 	int (*gpu_reset)(struct radeon_device *rdev);
 	int (*mc_init)(struct radeon_device *rdev);
 	void (*mc_fini)(struct radeon_device *rdev);
@@ -773,6 +774,7 @@ static inline void radeon_ring_write(struct radeon_device *rdev, uint32_t v)
 #define radeon_cs_parse(p) rdev->asic->cs_parse((p))
 #define radeon_errata(rdev) (rdev)->asic->errata((rdev))
 #define radeon_vram_info(rdev) (rdev)->asic->vram_info((rdev))
+#define radeon_vga_disable(rdev) (rdev)->asic->vga_disable((rdev))
 #define radeon_gpu_reset(rdev) (rdev)->asic->gpu_reset((rdev))
 #define radeon_mc_init(rdev) (rdev)->asic->mc_init((rdev))
 #define radeon_mc_fini(rdev) (rdev)->asic->mc_fini((rdev))
diff --git a/drivers/gpu/drm/radeon/radeon_asic.h b/drivers/gpu/drm/radeon/radeon_asic.h
index e2e5673..4586819 100644
--- a/drivers/gpu/drm/radeon/radeon_asic.h
+++ b/drivers/gpu/drm/radeon/radeon_asic.h
@@ -46,6 +46,7 @@ uint32_t r100_mm_rreg(struct radeon_device *rdev, uint32_t reg);
 void r100_mm_wreg(struct radeon_device *rdev, uint32_t reg, uint32_t v);
 void r100_errata(struct radeon_device *rdev);
 void r100_vram_info(struct radeon_device *rdev);
+void r100_vga_disable(struct radeon_device *rdev);
 int r100_gpu_reset(struct radeon_device *rdev);
 int r100_mc_init(struct radeon_device *rdev);
 void r100_mc_fini(struct radeon_device *rdev);
@@ -76,6 +77,7 @@ static struct radeon_asic r100_asic = {
 	.init = &r100_init,
 	.errata = &r100_errata,
 	.vram_info = &r100_vram_info,
+	.vga_disable = &r100_vga_disable,
 	.gpu_reset = &r100_gpu_reset,
 	.mc_init = &r100_mc_init,
 	.mc_fini = &r100_mc_fini,
@@ -132,6 +134,7 @@ static struct radeon_asic r300_asic = {
 	.init = &r300_init,
 	.errata = &r300_errata,
 	.vram_info = &r300_vram_info,
+	.vga_disable = &r100_vga_disable,
 	.gpu_reset = &r300_gpu_reset,
 	.mc_init = &r300_mc_init,
 	.mc_fini = &r300_mc_fini,
@@ -169,6 +172,7 @@ static struct radeon_asic r420_asic = {
 	.init = &r300_init,
 	.errata = &r420_errata,
 	.vram_info = &r420_vram_info,
+	.vga_disable = &r100_vga_disable,
 	.gpu_reset = &r300_gpu_reset,
 	.mc_init = &r420_mc_init,
 	.mc_fini = &r420_mc_fini,
@@ -213,6 +217,7 @@ static struct radeon_asic rs400_asic = {
 	.init = &r300_init,
 	.errata = &rs400_errata,
 	.vram_info = &rs400_vram_info,
+	.vga_disable = &r100_vga_disable,
 	.gpu_reset = &r300_gpu_reset,
 	.mc_init = &rs400_mc_init,
 	.mc_fini = &rs400_mc_fini,
@@ -258,6 +263,7 @@ static struct radeon_asic rs600_asic = {
 	.init = &r300_init,
 	.errata = &rs600_errata,
 	.vram_info = &rs600_vram_info,
+	.vga_disable = &r100_vga_disable,
 	.gpu_reset = &r300_gpu_reset,
 	.mc_init = &rs600_mc_init,
 	.mc_fini = &rs600_mc_fini,
@@ -298,6 +304,7 @@ static struct radeon_asic rs690_asic = {
 	.init = &r300_init,
 	.errata = &rs690_errata,
 	.vram_info = &rs690_vram_info,
+	.vga_disable = &r100_vga_disable,
 	.gpu_reset = &r300_gpu_reset,
 	.mc_init = &rs690_mc_init,
 	.mc_fini = &rs690_mc_fini,
@@ -343,6 +350,7 @@ static struct radeon_asic rv515_asic = {
 	.init = &rv515_init,
 	.errata = &rv515_errata,
 	.vram_info = &rv515_vram_info,
+	.vga_disable = &r100_vga_disable,
 	.gpu_reset = &rv515_gpu_reset,
 	.mc_init = &rv515_mc_init,
 	.mc_fini = &rv515_mc_fini,
@@ -381,6 +389,7 @@ static struct radeon_asic r520_asic = {
 	.init = &rv515_init,
 	.errata = &r520_errata,
 	.vram_info = &r520_vram_info,
+	.vga_disable = &r100_vga_disable,
 	.gpu_reset = &rv515_gpu_reset,
 	.mc_init = &r520_mc_init,
 	.mc_fini = &r520_mc_fini,
diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index f97563d..c02f655 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -29,6 +29,7 @@
 #include <drm/drmP.h>
 #include <drm/drm_crtc_helper.h>
 #include <drm/radeon_drm.h>
+#include <linux/vgaarb.h>
 #include "radeon_reg.h"
 #include "radeon.h"
 #include "radeon_asic.h"
@@ -516,7 +517,9 @@ int radeon_device_init(struct radeon_device *rdev,
 	/* Initialize surface registers */
 	radeon_surface_init(rdev);
 
-	/* TODO: disable VGA need to use VGA request */
+	radeon_vga_disable(rdev);
+	vga_set_legacy_decoding(rdev->pdev, VGA_RSRC_NONE);
+
 	/* BIOS*/
 	if (!radeon_get_bios(rdev)) {
 		if (ASIC_IS_AVIVO(rdev))
diff --git a/include/drm/drmP.h b/include/drm/drmP.h
index 45b67d9..95106c7 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -786,6 +786,9 @@ struct drm_driver {
 	int (*gem_init_object) (struct drm_gem_object *obj);
 	void (*gem_free_object) (struct drm_gem_object *obj);
 
+	/* vga arb irq handler */
+	void (*vgaarb_irq)(struct drm_device *dev, bool state);
+
 	/* Driver private ops for this object */
 	struct vm_operations_struct *gem_vm_ops;
 
-- 
1.5.6.3

