Return-Path: <linux-kernel-owner+w=401wt.eu-S1751217AbZHKLvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751217AbZHKLvy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 07:51:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751162AbZHKLvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 07:51:52 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49546 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002AbZHKLvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 07:51:46 -0400
From: Dave Airlie <airlied@gmail.com>
To: jbarnes@virtuousgeek.org
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sf.net,
       Dave Airlie <airlied@redhat.com>
Subject: [PATCH] drm: add support for VGA arbitration
Date: Tue, 11 Aug 2009 15:52:07 +1000
Message-Id: <1249969927-884-2-git-send-email-airlied@gmail.com>
In-Reply-To: <1249969927-884-1-git-send-email-airlied@gmail.com>
References: <1249969927-884-1-git-send-email-airlied@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Airlie <airlied@redhat.com>

this patch has two components:
a) for legacy DRM drivers, we need a hook to enable/disable irqs around
arb when the command/memory is turned off.
b) for KMS drivers we provide a hook/callback to enable/disable VGA decoding.

We don't disable VGA decoding in the single device case, since we believe
some laptops ACPI implementation will react badly.

Signed-off-by: Dave Airlie <airlied@redhat.com>
---
 drivers/gpu/drm/drm_irq.c              |   27 +++++++++++++++++++++++++++
 drivers/gpu/drm/i915/i915_dma.c        |   20 ++++++++++++++++++++
 drivers/gpu/drm/i915/i915_drv.h        |    1 +
 drivers/gpu/drm/i915/i915_reg.h        |    1 +
 drivers/gpu/drm/i915/intel_display.c   |   23 +++++++++++++++++++++++
 drivers/gpu/drm/i915/intel_drv.h       |    1 +
 drivers/gpu/drm/radeon/r100.c          |   14 ++++++++++++++
 drivers/gpu/drm/radeon/radeon.h        |    2 ++
 drivers/gpu/drm/radeon/radeon_asic.h   |    9 +++++++++
 drivers/gpu/drm/radeon/radeon_device.c |   18 ++++++++++++++++++
 include/drm/drmP.h                     |    3 +++
 11 files changed, 119 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/drm_irq.c b/drivers/gpu/drm/drm_irq.c
index f85aaf2..0a6f0b3 100644
--- a/drivers/gpu/drm/drm_irq.c
+++ b/drivers/gpu/drm/drm_irq.c
@@ -37,6 +37,7 @@
 
 #include <linux/interrupt.h>	/* For task queue support */
 
+#include <linux/vgaarb.h>
 /**
  * Get interrupt from bus id.
  *
@@ -171,6 +172,26 @@ err:
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
+	if (!dev->irq_enabled)
+		return;
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
@@ -231,6 +252,9 @@ int drm_irq_install(struct drm_device *dev)
 		return ret;
 	}
 
+	if (!drm_core_check_feature(dev, DRIVER_MODESET))
+		vga_client_register(dev->pdev, (void *)dev, drm_irq_vgaarb_nokms, NULL);
+
 	/* After installing handler */
 	ret = dev->driver->irq_postinstall(dev);
 	if (ret < 0) {
@@ -279,6 +303,9 @@ int drm_irq_uninstall(struct drm_device * dev)
 
 	DRM_DEBUG("irq=%d\n", dev->pdev->irq);
 
+	if (!drm_core_check_feature(dev, DRIVER_MODESET))
+		vga_client_register(dev->pdev, NULL, NULL, NULL);
+
 	dev->driver->irq_uninstall(dev);
 
 	free_irq(dev->pdev->irq, dev);
diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 50d1f78..9b78c95 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -33,6 +33,7 @@
 #include "i915_drm.h"
 #include "i915_drv.h"
 
+#include <linux/vgaarb.h>
 #define I915_DRV	"i915_drv"
 
 /* Really want an OS-independent resettable timer.  Would like to have
@@ -984,6 +985,19 @@ static int i915_probe_agp(struct drm_device *dev, uint32_t *aperture_size,
 	return 0;
 }
 
+/* true = enable decode, false = disable decoder */
+static unsigned int i915_vga_set_decode(void *cookie, bool state)
+{
+	struct drm_device *dev = cookie;
+
+	intel_modeset_vga_set_state(dev, state);
+	if (state)
+		return VGA_RSRC_LEGACY_IO | VGA_RSRC_LEGACY_MEM |
+		       VGA_RSRC_NORMAL_IO | VGA_RSRC_NORMAL_MEM;
+	else
+		return VGA_RSRC_NORMAL_IO | VGA_RSRC_NORMAL_MEM;
+}
+
 static int i915_load_modeset_init(struct drm_device *dev,
 				  unsigned long prealloc_size,
 				  unsigned long agp_size)
@@ -1029,6 +1043,11 @@ static int i915_load_modeset_init(struct drm_device *dev,
 	if (ret)
 		DRM_INFO("failed to find VBIOS tables\n");
 
+	/* if we have > 1 VGA cards, then disable the radeon VGA resources */
+	ret = vga_client_register(dev->pdev, dev, NULL, i915_vga_set_decode);
+	if (ret)
+		goto destroy_ringbuffer;
+
 	ret = drm_irq_install(dev);
 	if (ret)
 		goto destroy_ringbuffer;
@@ -1289,6 +1308,7 @@ int i915_driver_unload(struct drm_device *dev)
 
 	if (drm_core_check_feature(dev, DRIVER_MODESET)) {
 		drm_irq_uninstall(dev);
+		vga_client_register(dev->pdev, NULL, NULL, NULL);
 	}
 
 	if (dev->pdev->msi_enabled)
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 7537f57..fd5f6fb 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -750,6 +750,7 @@ static inline void opregion_enable_asle(struct drm_device *dev) { return; }
 /* modesetting */
 extern void intel_modeset_init(struct drm_device *dev);
 extern void intel_modeset_cleanup(struct drm_device *dev);
+extern int intel_modeset_vga_set_state(struct drm_device *dev, bool state);
 
 /**
  * Lock test for when it's just for synchronization of ring access.
diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 2955083..2c9431b 100644
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
index d6fce21..7d80b0b 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -3447,3 +3447,26 @@ struct drm_encoder *intel_best_encoder(struct drm_connector *connector)
 
 	return &intel_output->enc;
 }
+
+/*
+ * set vga decode state - true == enable VGA decode
+ */
+int intel_modeset_vga_set_state(struct drm_device *dev, bool state)
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
+	if (state)
+		gmch_ctrl &= ~INTEL_GMCH_VGA_DISABLE;
+	else
+		gmch_ctrl |= INTEL_GMCH_VGA_DISABLE;
+	pci_write_config_word(bridge_dev, INTEL_GMCH_CTRL, gmch_ctrl);
+	return 0;
+}
diff --git a/drivers/gpu/drm/i915/intel_drv.h b/drivers/gpu/drm/i915/intel_drv.h
index d6f92ea..7b439ad 100644
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -157,4 +157,5 @@ extern int intel_framebuffer_create(struct drm_device *dev,
 				    struct drm_mode_fb_cmd *mode_cmd,
 				    struct drm_framebuffer **fb,
 				    struct drm_gem_object *obj);
+
 #endif /* __INTEL_DRV_H__ */
diff --git a/drivers/gpu/drm/radeon/r100.c b/drivers/gpu/drm/radeon/r100.c
index f1ba8ff..16448a4 100644
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -1492,6 +1492,20 @@ void r100_vram_init_sizes(struct radeon_device *rdev)
 		rdev->mc.real_vram_size = rdev->mc.aper_size;
 }
 
+void r100_vga_set_state(struct radeon_device *rdev, bool state)
+{
+	uint32_t temp;
+
+	temp = RREG32(RADEON_CONFIG_CNTL);
+	if (state == false) {
+		temp &= ~(1<<8);
+		temp |= (1<<9);
+	} else {
+		temp &= ~(1<<9);
+	}
+	WREG32(RADEON_CONFIG_CNTL, temp);
+}
+
 void r100_vram_info(struct radeon_device *rdev)
 {
 	r100_vram_get_type(rdev);
diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index b1d945b..4565538 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -559,6 +559,7 @@ struct radeon_asic {
 	int (*init)(struct radeon_device *rdev);
 	void (*errata)(struct radeon_device *rdev);
 	void (*vram_info)(struct radeon_device *rdev);
+	void (*vga_set_state)(struct radeon_device *rdev, bool state);
 	int (*gpu_reset)(struct radeon_device *rdev);
 	int (*mc_init)(struct radeon_device *rdev);
 	void (*mc_fini)(struct radeon_device *rdev);
@@ -847,6 +848,7 @@ static inline void radeon_ring_write(struct radeon_device *rdev, uint32_t v)
 #define radeon_cs_parse(p) rdev->asic->cs_parse((p))
 #define radeon_errata(rdev) (rdev)->asic->errata((rdev))
 #define radeon_vram_info(rdev) (rdev)->asic->vram_info((rdev))
+#define radeon_vga_set_state(rdev, state) (rdev)->asic->vga_set_state((rdev), (state))
 #define radeon_gpu_reset(rdev) (rdev)->asic->gpu_reset((rdev))
 #define radeon_mc_init(rdev) (rdev)->asic->mc_init((rdev))
 #define radeon_mc_fini(rdev) (rdev)->asic->mc_fini((rdev))
diff --git a/drivers/gpu/drm/radeon/radeon_asic.h b/drivers/gpu/drm/radeon/radeon_asic.h
index 9a75876..837d606 100644
--- a/drivers/gpu/drm/radeon/radeon_asic.h
+++ b/drivers/gpu/drm/radeon/radeon_asic.h
@@ -46,6 +46,7 @@ uint32_t r100_mm_rreg(struct radeon_device *rdev, uint32_t reg);
 void r100_mm_wreg(struct radeon_device *rdev, uint32_t reg, uint32_t v);
 void r100_errata(struct radeon_device *rdev);
 void r100_vram_info(struct radeon_device *rdev);
+void r100_vga_set_state(struct radeon_device *rdev, bool state);
 int r100_gpu_reset(struct radeon_device *rdev);
 int r100_mc_init(struct radeon_device *rdev);
 void r100_mc_fini(struct radeon_device *rdev);
@@ -81,6 +82,7 @@ static struct radeon_asic r100_asic = {
 	.init = &r100_init,
 	.errata = &r100_errata,
 	.vram_info = &r100_vram_info,
+	.vga_set_state = &r100_vga_set_state,
 	.gpu_reset = &r100_gpu_reset,
 	.mc_init = &r100_mc_init,
 	.mc_fini = &r100_mc_fini,
@@ -141,6 +143,7 @@ static struct radeon_asic r300_asic = {
 	.init = &r300_init,
 	.errata = &r300_errata,
 	.vram_info = &r300_vram_info,
+	.vga_set_state = &r100_vga_set_state,
 	.gpu_reset = &r300_gpu_reset,
 	.mc_init = &r300_mc_init,
 	.mc_fini = &r300_mc_fini,
@@ -181,6 +184,7 @@ static struct radeon_asic r420_asic = {
 	.init = &r300_init,
 	.errata = &r420_errata,
 	.vram_info = &r420_vram_info,
+	.vga_set_state = &r100_vga_set_state,
 	.gpu_reset = &r300_gpu_reset,
 	.mc_init = &r420_mc_init,
 	.mc_fini = &r420_mc_fini,
@@ -228,6 +232,7 @@ static struct radeon_asic rs400_asic = {
 	.init = &r300_init,
 	.errata = &rs400_errata,
 	.vram_info = &rs400_vram_info,
+	.vga_set_state = &r100_vga_set_state,
 	.gpu_reset = &r300_gpu_reset,
 	.mc_init = &rs400_mc_init,
 	.mc_fini = &rs400_mc_fini,
@@ -277,6 +282,7 @@ static struct radeon_asic rs600_asic = {
 	.init = &r300_init,
 	.errata = &rs600_errata,
 	.vram_info = &rs600_vram_info,
+	.vga_set_state = &r100_vga_set_state,
 	.gpu_reset = &r300_gpu_reset,
 	.mc_init = &rs600_mc_init,
 	.mc_fini = &rs600_mc_fini,
@@ -319,6 +325,7 @@ static struct radeon_asic rs690_asic = {
 	.init = &r300_init,
 	.errata = &rs690_errata,
 	.vram_info = &rs690_vram_info,
+	.vga_set_state = &r100_vga_set_state,
 	.gpu_reset = &r300_gpu_reset,
 	.mc_init = &rs690_mc_init,
 	.mc_fini = &rs690_mc_fini,
@@ -368,6 +375,7 @@ static struct radeon_asic rv515_asic = {
 	.init = &rv515_init,
 	.errata = &rv515_errata,
 	.vram_info = &rv515_vram_info,
+	.vga_set_state = &r100_vga_set_state,
 	.gpu_reset = &rv515_gpu_reset,
 	.mc_init = &rv515_mc_init,
 	.mc_fini = &rv515_mc_fini,
@@ -410,6 +418,7 @@ static struct radeon_asic r520_asic = {
 	.init = &rv515_init,
 	.errata = &r520_errata,
 	.vram_info = &r520_vram_info,
+	.vga_set_state = &r100_vga_set_state,
 	.gpu_reset = &rv515_gpu_reset,
 	.mc_init = &r520_mc_init,
 	.mc_fini = &r520_mc_fini,
diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index 9ff6dcb..c6f03c2 100644
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
@@ -446,7 +447,18 @@ void radeon_combios_fini(struct radeon_device *rdev)
 int radeon_modeset_init(struct radeon_device *rdev);
 void radeon_modeset_fini(struct radeon_device *rdev);
 
+/* if we get transitioned to only one device, tak VGA back */
+static unsigned int radeon_vga_set_decode(void *cookie, bool state)
+{
+	struct radeon_device *rdev = cookie;
 
+	radeon_vga_set_state(rdev, state);
+	if (state)
+		return VGA_RSRC_LEGACY_IO | VGA_RSRC_LEGACY_MEM |
+		       VGA_RSRC_NORMAL_IO | VGA_RSRC_NORMAL_MEM;
+	else
+		return VGA_RSRC_NORMAL_IO | VGA_RSRC_NORMAL_MEM;
+}
 /*
  * Radeon device.
  */
@@ -535,6 +547,11 @@ int radeon_device_init(struct radeon_device *rdev,
 	/* Initialize surface registers */
 	radeon_surface_init(rdev);
 
+	/* if we have > 1 VGA cards, then disable the radeon VGA resources */
+	ret = vga_client_register(rdev->pdev, rdev, NULL, radeon_vga_set_decode);
+	if (ret)
+		return -EINVAL;
+
 	/* TODO: disable VGA need to use VGA request */
 	/* BIOS*/
 	if (!radeon_get_bios(rdev)) {
@@ -669,6 +686,7 @@ void radeon_device_fini(struct radeon_device *rdev)
 	radeon_agp_fini(rdev);
 #endif
 	radeon_irq_kms_fini(rdev);
+	vga_client_register(rdev->pdev, NULL, NULL, NULL);
 	radeon_fence_driver_fini(rdev);
 	radeon_clocks_fini(rdev);
 	if (rdev->is_atom_bios) {
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
1.6.0.6

