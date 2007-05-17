Return-Path: <linux-kernel-owner+w=401wt.eu-S1760138AbXEQWkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760138AbXEQWkx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 18:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755450AbXEQWkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 18:40:45 -0400
Received: from mga03.intel.com ([143.182.124.21]:61414 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756027AbXEQWkl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 18:40:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,550,1170662400"; 
   d="scan'208";a="229293343"
From: Jesse Barnes <jesse.barnes@intel.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] Intel support for DRM modesetting
Date: Thu, 17 May 2007 15:40:31 -0700
User-Agent: KMail/1.9.6
Cc: "Antonino A. Daplas" <adaplas@gmail.com>,
       James Simmons <jsimmons@pentafluge.infradead.org>,
       Dave Airlie <airlied@gmail.com>,
       "Jakob Bornecrantz" <wallbraker@gmail.com>,
       dri-devel@lists.sourceforge.net
References: <200705171423.46748.jesse.barnes@intel.com>
In-Reply-To: <200705171423.46748.jesse.barnes@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200705171540.31433.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for DRM modesetting to the Intel DRM driver and
stubs out a simple FB driver to sit underneath.  The code had to be
refactored a bit, since current DRM drivers tend to be fully initialized
by userspace via ioctls.  This patch makes the driver load routine do
most of the heavy lifting, since it's necessary in order to fully bring up
a console driver.

It also relies on the TTM patch Dave posted recently for allocating the
initial framebuffer used by the FB layer.

Jesse

diff --git a/linux-core/i915_drv.c b/linux-core/i915_drv.c
index 7fdb083..50ff977 100644
--- a/linux-core/i915_drv.c
+++ b/linux-core/i915_drv.c
@@ -79,7 +79,7 @@ static struct drm_driver driver = {
 	    DRIVER_HAVE_IRQ | DRIVER_IRQ_SHARED | DRIVER_IRQ_VBL |
 	    DRIVER_IRQ_VBL2,
 	.load = i915_driver_load,
-	.firstopen = i915_driver_firstopen,
+	.unload = i915_driver_unload,
 	.lastclose = i915_driver_lastclose,
 	.preclose = i915_driver_preclose,
 	.device_is_agp = i915_driver_device_is_agp,
diff --git a/linux-core/i915_init.c b/linux-core/i915_init.c
new file mode 100644
index 0000000..0c9ef4d
--- /dev/null
+++ b/linux-core/i915_init.c
@@ -0,0 +1,305 @@
+/*
+ * Copyright (c) 2007 Intel Corporation
+ *   Jesse Barnes <jesse.barnes@intel.com>
+ *
+ * Copyright © 2002, 2003 David Dawes <dawes@xfree86.org>
+ *                   2004 Sylvain Meyer
+ *
+ * GPL/BSD dual license
+ */
+#include "drmP.h"
+#include "drm.h"
+#include "drm_sarea.h"
+#include "i915_drm.h"
+#include "i915_drv.h"
+
+/**
+ * i915_probe_agp - get AGP bootup configuration
+ * @pdev: PCI device
+ * @aperture_size: returns AGP aperture configured size
+ * @preallocated_size: returns size of BIOS preallocated AGP space
+ *
+ * Since Intel integrated graphics are UMA, the BIOS has to set aside
+ * some RAM for the framebuffer at early boot.  This code figures out
+ * how much was set aside so we can use it for our own purposes.
+ */
+int i915_probe_agp(struct pci_dev *pdev, unsigned long *aperture_size,
+		   unsigned long *preallocated_size)
+{
+	struct pci_dev *bridge_dev;
+	u16 tmp = 0;
+	unsigned long overhead;
+
+	bridge_dev = pci_get_bus_and_slot(0, PCI_DEVFN(0,0));
+	if (!bridge_dev) {
+		DRM_ERROR("bridge device not found\n");
+		return -1;
+	}
+
+	/* Get the fb aperture size and "stolen" memory amount. */
+	pci_read_config_word(bridge_dev, INTEL_GMCH_CTRL, &tmp);
+	pci_dev_put(bridge_dev);
+
+	*aperture_size = 1024 * 1024;
+	*preallocated_size = 1024 * 1024;
+
+	switch (pdev->device) {
+	case PCI_DEVICE_ID_INTEL_82830_CGC:
+	case PCI_DEVICE_ID_INTEL_82845G_IG:
+	case PCI_DEVICE_ID_INTEL_82855GM_IG:
+	case PCI_DEVICE_ID_INTEL_82865_IG:
+		if ((tmp & INTEL_GMCH_MEM_MASK) == INTEL_GMCH_MEM_64M)
+			*aperture_size *= 64;
+		else
+			*aperture_size *= 128;
+		break;
+	default:
+		/* 9xx supports large sizes, just look at the length */
+		*aperture_size = pci_resource_len(pdev, 2);
+		break;
+	}
+
+	/*
+	 * Some of the preallocated space is taken by the GTT
+	 * and popup.  GTT is 1K per MB of aperture size, and popup is 4K.
+	 */
+	overhead = (*aperture_size / 1024) + 4096;
+	switch (tmp & INTEL_855_GMCH_GMS_MASK) {
+	case INTEL_855_GMCH_GMS_STOLEN_1M:
+		break; /* 1M already */
+	case INTEL_855_GMCH_GMS_STOLEN_4M:
+		*preallocated_size *= 4;
+		break;
+	case INTEL_855_GMCH_GMS_STOLEN_8M:
+		*preallocated_size *= 8;
+		break;
+	case INTEL_855_GMCH_GMS_STOLEN_16M:
+		*preallocated_size *= 16;
+		break;
+	case INTEL_855_GMCH_GMS_STOLEN_32M:
+		*preallocated_size *= 32;
+		break;
+	case INTEL_915G_GMCH_GMS_STOLEN_48M:
+		*preallocated_size *= 48;
+		break;
+	case INTEL_915G_GMCH_GMS_STOLEN_64M:
+		*preallocated_size *= 64;
+		break;
+	case INTEL_855_GMCH_GMS_DISABLED:
+		DRM_ERROR("video memory is disabled\n");
+		return -1;
+	default:
+		DRM_ERROR("unexpected GMCH_GMS value: 0x%02x\n",
+			tmp & INTEL_855_GMCH_GMS_MASK);
+		return -1;
+	}
+	*preallocated_size -= overhead;
+
+	return 0;
+}
+
+/**
+ * i915_driver_load - setup chip and create an initial config
+ * @dev: DRM device
+ * @flags: startup flags
+ *
+ * The driver load routine has to do several things:
+ *   - drive output discovery via intel_modeset_init()
+ *   - initialize the memory manager
+ *   - allocate initial config memory
+ *   - setup the DRM framebuffer with the allocated memory
+ */
+int i915_driver_load(drm_device_t *dev, unsigned long flags)
+{
+	drm_i915_private_t *dev_priv;
+	unsigned long agp_size, prealloc_size;
+	unsigned long sareapage;
+	int size, ret;
+
+	dev_priv = drm_alloc(sizeof(drm_i915_private_t), DRM_MEM_DRIVER);
+	if (dev_priv == NULL)
+		return DRM_ERR(ENOMEM);
+
+	memset(dev_priv, 0, sizeof(drm_i915_private_t));
+	dev->dev_private = (void *)dev_priv;
+//	dev_priv->flags = flags;
+
+	/* i915 has 4 more counters */
+	dev->counters += 4;
+	dev->types[6] = _DRM_STAT_IRQ;
+	dev->types[7] = _DRM_STAT_PRIMARY;
+	dev->types[8] = _DRM_STAT_SECONDARY;
+	dev->types[9] = _DRM_STAT_DMA;
+
+	if (IS_I9XX(dev)) {
+		dev_priv->mmiobase = drm_get_resource_start(dev, 0);
+		dev_priv->mmiolen = drm_get_resource_len(dev, 0);
+		dev->mode_config.fb_base =
+			drm_get_resource_start(dev, 2) & 0xff000000;
+	} else if (drm_get_resource_start(dev, 1)) {
+		dev_priv->mmiobase = drm_get_resource_start(dev, 1);
+		dev_priv->mmiolen = drm_get_resource_len(dev, 1);
+		dev->mode_config.fb_base =
+			drm_get_resource_start(dev, 0) & 0xff000000;
+	} else {
+		DRM_ERROR("Unable to find MMIO registers\n");
+		return -ENODEV;
+	}
+
+	DRM_DEBUG("fb_base: 0x%08lx\n", dev->mode_config.fb_base);
+
+	ret = drm_addmap(dev, dev_priv->mmiobase, dev_priv->mmiolen,
+			 _DRM_REGISTERS, _DRM_READ_ONLY|_DRM_DRIVER, &dev_priv->mmio_map);
+	if (ret != 0) {
+		DRM_ERROR("Cannot add mapping for MMIO registers\n");
+		return ret;
+	}
+
+	/* prebuild the SAREA */
+	sareapage = max(SAREA_MAX, PAGE_SIZE);
+	ret = drm_addmap(dev, 0, sareapage, _DRM_SHM, _DRM_CONTAINS_LOCK|_DRM_DRIVER,
+			 &dev_priv->sarea);
+	if (ret) {
+		DRM_ERROR("SAREA setup failed\n");
+		return ret;
+	}
+
+	init_waitqueue_head(&dev->lock.lock_queue);
+
+	/* FIXME: assume sarea_priv is right after SAREA */
+        dev_priv->sarea_priv = dev_priv->sarea->handle + sizeof(drm_sarea_t);
+
+	/*
+	 * Initialize the memory manager for local and AGP space
+	 */
+	drm_bo_driver_init(dev);
+
+	i915_probe_agp(dev->pdev, &agp_size, &prealloc_size);
+	DRM_DEBUG("setting up %ld bytes of PRIV0 space\n", prealloc_size);
+	drm_bo_init_mm(dev, DRM_BO_MEM_PRIV0, 0, prealloc_size >> PAGE_SHIFT);
+
+	I915_WRITE(LP_RING + RING_LEN, 0);
+	I915_WRITE(LP_RING + RING_HEAD, 0);
+	I915_WRITE(LP_RING + RING_TAIL, 0);
+
+	size = PRIMARY_RINGBUFFER_SIZE;
+	ret = drm_buffer_object_create(dev, size, drm_bo_type_kernel,
+				       DRM_BO_FLAG_READ | DRM_BO_FLAG_WRITE |
+				       DRM_BO_FLAG_MEM_PRIV0 |
+				       DRM_BO_FLAG_NO_EVICT,
+				       DRM_BO_HINT_DONT_FENCE, 0x1, 0,
+				       &dev_priv->ring_buffer);
+	if (ret < 0) {
+		DRM_ERROR("Unable to allocate ring buffer\n");
+		return -EINVAL;
+	}
+
+	/* remap the buffer object properly */
+	dev_priv->ring.Start = dev_priv->ring_buffer->offset;
+	dev_priv->ring.End = dev_priv->ring.Start + size;
+	dev_priv->ring.Size = size;
+	dev_priv->ring.tail_mask = dev_priv->ring.Size - 1;
+
+	/* FIXME: need wrapper with PCI mem checks */
+	ret = drm_mem_reg_ioremap(dev, &dev_priv->ring_buffer->mem,
+				  &dev_priv->ring.virtual_start);
+	if (ret)
+		DRM_ERROR("error mapping ring buffer: %d\n", ret);
+
+	DRM_DEBUG("ring start %08lX, %p, %08lX\n", dev_priv->ring.Start,
+		  dev_priv->ring.virtual_start, dev_priv->ring.Size);
+
+	dev_priv->sarea_priv->pf_current_page = 0;
+
+	/* We are using separate values as placeholders for mechanisms for
+	 * private backbuffer/depthbuffer usage.
+	 */
+	dev_priv->use_mi_batchbuffer_start = 0;
+
+	/* Allow hardware batchbuffers unless told otherwise.
+	 */
+	dev_priv->allow_batchbuffer = 1;
+
+	/* Program Hardware Status Page */
+	dev_priv->status_page_dmah = drm_pci_alloc(dev, PAGE_SIZE, PAGE_SIZE, 
+	    0xffffffff);
+
+	if (!dev_priv->status_page_dmah) {
+		dev->dev_private = (void *)dev_priv;
+		i915_dma_cleanup(dev);
+		DRM_ERROR("Can not allocate hardware status page\n");
+		return DRM_ERR(ENOMEM);
+	}
+	dev_priv->hw_status_page = dev_priv->status_page_dmah->vaddr;
+	dev_priv->dma_status_page = dev_priv->status_page_dmah->busaddr;
+	
+	memset(dev_priv->hw_status_page, 0, PAGE_SIZE);
+	DRM_DEBUG("hw status page @ %p\n", dev_priv->hw_status_page);
+
+	I915_WRITE(0x02080, dev_priv->dma_status_page);
+	DRM_DEBUG("Enabled hardware status page\n");
+
+	intel_modeset_init(dev);
+	drm_initial_config(dev, false);
+
+	return 0;
+}
+
+int i915_driver_unload(drm_device_t *dev)
+{
+	drm_i915_private_t *dev_priv = dev->dev_private;
+
+	if (dev_priv->status_page_dmah) {
+		drm_pci_free(dev, dev_priv->status_page_dmah);
+		dev_priv->status_page_dmah = NULL;
+		dev_priv->hw_status_page = NULL;
+		dev_priv->dma_status_page = 0;
+		/* Need to rewrite hardware status page */
+		I915_WRITE(0x02080, 0x1ffff000);
+	}
+
+	I915_WRITE(LP_RING + RING_LEN, 0);
+
+	intel_modeset_cleanup(dev);
+
+	drm_mem_reg_iounmap(dev, &dev_priv->ring_buffer->mem,
+			    dev_priv->ring.virtual_start);
+
+	DRM_DEBUG("usage is %d\n", dev_priv->ring_buffer->usage);
+	mutex_lock(&dev->struct_mutex);
+	drm_bo_usage_deref_locked(dev_priv->ring_buffer);
+	mutex_unlock(&dev->struct_mutex);
+
+	if (drm_bo_clean_mm(dev, DRM_BO_MEM_PRIV0)) {
+		DRM_ERROR("Memory manager type 3 not clean. "
+			  "Delaying takedown\n");
+	}
+
+	drm_bo_driver_finish(dev);
+
+        DRM_DEBUG("%p, %p\n", dev_priv->mmio_map, dev_priv->sarea);
+        drm_rmmap(dev, dev_priv->mmio_map);
+        drm_rmmap(dev, dev_priv->sarea);
+
+	drm_free(dev_priv, sizeof(*dev_priv), DRM_MEM_DRIVER);
+
+	dev->dev_private = NULL;
+	return 0;
+}
+
+void i915_driver_lastclose(drm_device_t * dev)
+{
+	drm_i915_private_t *dev_priv = dev->dev_private;
+	
+	i915_mem_takedown(&(dev_priv->agp_heap));
+
+	i915_dma_cleanup(dev);
+
+}
+
+void i915_driver_preclose(drm_device_t * dev, DRMFILE filp)
+{
+	drm_i915_private_t *dev_priv = dev->dev_private;
+	i915_mem_release(dev, filp, dev_priv->agp_heap);
+}
+
diff --git a/linux-core/intel_crt.c b/linux-core/intel_crt.c
new file mode 100644
index 0000000..cdfb314
--- /dev/null
+++ b/linux-core/intel_crt.c
@@ -0,0 +1,248 @@
+/*
+ * Copyright © 2006-2007 Intel Corporation
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
+ * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ *
+ * Authors:
+ *	Eric Anholt <eric@anholt.net>
+ */
+
+#include <linux/i2c.h>
+#include "drmP.h"
+#include "drm.h"
+#include "drm_crtc.h"
+#include "intel_drv.h"
+#include "i915_drm.h"
+#include "i915_drv.h"
+
+static void intel_crt_dpms(struct drm_output *output, int mode)
+{
+	drm_device_t *dev = output->dev;
+	drm_i915_private_t *dev_priv = dev->dev_private;
+	u32 temp;
+	
+	temp = I915_READ(ADPA);
+	temp &= ~(ADPA_HSYNC_CNTL_DISABLE | ADPA_VSYNC_CNTL_DISABLE);
+	temp &= ~ADPA_DAC_ENABLE;
+	
+	switch(mode) {
+	case DPMSModeOn:
+		temp |= ADPA_DAC_ENABLE;
+		break;
+	case DPMSModeStandby:
+		temp |= ADPA_DAC_ENABLE | ADPA_HSYNC_CNTL_DISABLE;
+		break;
+	case DPMSModeSuspend:
+		temp |= ADPA_DAC_ENABLE | ADPA_VSYNC_CNTL_DISABLE;
+		break;
+	case DPMSModeOff:
+		temp |= ADPA_HSYNC_CNTL_DISABLE | ADPA_VSYNC_CNTL_DISABLE;
+		break;
+	}
+	
+	I915_WRITE(ADPA, temp);
+}
+
+static void intel_crt_save(struct drm_output *output)
+{
+	
+}
+
+static void intel_crt_restore(struct drm_output *output)
+{
+
+}
+
+static int intel_crt_mode_valid(struct drm_output *output,
+				struct drm_display_mode *mode)
+{
+	if (mode->flags & V_DBLSCAN)
+		return MODE_NO_DBLESCAN;
+
+	if (mode->clock > 400000 || mode->clock < 25000)
+		return MODE_CLOCK_RANGE;
+
+	return MODE_OK;
+}
+
+static bool intel_crt_mode_fixup(struct drm_output *output,
+				 struct drm_display_mode *mode,
+				 struct drm_display_mode *adjusted_mode)
+{
+	return true;
+}
+
+static void intel_crt_mode_set(struct drm_output *output,
+			       struct drm_display_mode *mode,
+			       struct drm_display_mode *adjusted_mode)
+{
+	drm_device_t *dev = output->dev;
+	struct drm_crtc *crtc = output->crtc;
+	struct intel_crtc *intel_crtc = crtc->driver_private;
+	drm_i915_private_t *dev_priv = dev->dev_private;
+	int dpll_md_reg;
+	u32 adpa, dpll_md;
+
+	if (intel_crtc->pipe == 0) 
+		dpll_md_reg = DPLL_A_MD;
+	else
+		dpll_md_reg = DPLL_B_MD;
+
+	/*
+	 * Disable separate mode multiplier used when cloning SDVO to CRT
+	 * XXX this needs to be adjusted when we really are cloning
+	 */
+	if (IS_I965G(dev)) {
+		dpll_md = I915_READ(dpll_md_reg);
+		I915_WRITE(dpll_md_reg,
+			   dpll_md & ~DPLL_MD_UDI_MULTIPLIER_MASK);
+	}
+	
+	adpa = 0;
+	if (adjusted_mode->flags & V_PHSYNC)
+		adpa |= ADPA_HSYNC_ACTIVE_HIGH;
+	if (adjusted_mode->flags & V_PVSYNC)
+		adpa |= ADPA_VSYNC_ACTIVE_HIGH;
+	
+	if (intel_crtc->pipe == 0)
+		adpa |= ADPA_PIPE_A_SELECT;
+	else
+		adpa |= ADPA_PIPE_B_SELECT;
+	
+	I915_WRITE(ADPA, adpa);
+}
+
+/**
+ * Uses CRT_HOTPLUG_EN and CRT_HOTPLUG_STAT to detect CRT presence.
+ *
+ * Only for I945G/GM.
+ *
+ * \return TRUE if CRT is connected.
+ * \return FALSE if CRT is disconnected.
+ */
+static bool intel_crt_detect_hotplug(struct drm_output *output)
+{
+	drm_device_t *dev = output->dev;
+	drm_i915_private_t *dev_priv = dev->dev_private;
+	u32 temp;
+	unsigned long timeout = jiffies + msecs_to_jiffies(1000);
+
+	temp = I915_READ(PORT_HOTPLUG_EN);
+
+	I915_WRITE(PORT_HOTPLUG_EN,
+		   temp | CRT_HOTPLUG_FORCE_DETECT | (1 << 5));
+
+	do {
+		if (!(I915_READ(PORT_HOTPLUG_EN) & CRT_HOTPLUG_FORCE_DETECT))
+			break;
+		msleep(1);
+	} while (time_after(timeout, jiffies));
+
+	if ((I915_READ(PORT_HOTPLUG_STAT) & CRT_HOTPLUG_MONITOR_MASK) ==
+	    CRT_HOTPLUG_MONITOR_COLOR)
+		return true;
+
+	return false;
+}
+
+static bool intel_crt_detect_ddc(struct drm_output *output)
+{
+	struct intel_output *intel_output = output->driver_private;
+
+	/* CRT should always be at 0, but check anyway */
+	if (intel_output->type != INTEL_OUTPUT_ANALOG)
+		return false;
+	
+	return intel_ddc_probe(output);
+}
+
+static enum drm_output_status intel_crt_detect(struct drm_output *output)
+{
+	drm_device_t *dev = output->dev;
+	
+	if (IS_I945G(dev)| IS_I945GM(dev) || IS_I965G(dev)) {
+		if (intel_crt_detect_hotplug(output))
+			return output_status_connected;
+		else
+			return output_status_disconnected;
+	}
+
+	if (intel_crt_detect_ddc(output))
+		return output_status_connected;
+
+	/* TODO use load detect */
+	return output_status_unknown;
+}
+
+static void intel_crt_destroy(struct drm_output *output)
+{
+	struct intel_output *intel_output = output->driver_private;
+
+	intel_i2c_destroy(intel_output->ddc_bus);
+	kfree(output->driver_private);
+}
+
+static int intel_crt_get_modes(struct drm_output *output)
+{
+	return intel_ddc_get_modes(output);
+}
+
+/*
+ * Routines for controlling stuff on the analog port
+ */
+static const struct drm_output_funcs intel_crt_output_funcs = {
+	.dpms = intel_crt_dpms,
+	.save = intel_crt_save,
+	.restore = intel_crt_restore,
+	.mode_valid = intel_crt_mode_valid,
+	.mode_fixup = intel_crt_mode_fixup,
+	.prepare = intel_output_prepare,
+	.mode_set = intel_crt_mode_set,
+	.commit = intel_output_commit,
+	.detect = intel_crt_detect,
+	.get_modes = intel_crt_get_modes,
+	.cleanup = intel_crt_destroy,
+};
+
+void intel_crt_init(drm_device_t *dev)
+{
+	struct drm_output *output;
+	struct intel_output *intel_output;
+
+	output = drm_output_create(dev, &intel_crt_output_funcs, "VGA");
+
+	intel_output = kmalloc(sizeof(struct intel_output), GFP_KERNEL);
+	if (!intel_output) {
+		drm_output_destroy(output);
+		return;
+	}
+	/* Set up the DDC bus. */
+	intel_output->ddc_bus = intel_i2c_create(dev, GPIOA, "CRTDDC_A");
+	if (!intel_output->ddc_bus) {
+		dev_printk(KERN_ERR, &dev->pdev->dev, "DDC bus registration "
+			   "failed.\n");
+		return;
+	}
+
+	intel_output->type = INTEL_OUTPUT_ANALOG;
+	output->driver_private = intel_output;
+	output->interlace_allowed = 0;
+	output->doublescan_allowed = 0;
+}
diff --git a/linux-core/intel_display.c b/linux-core/intel_display.c
new file mode 100644
index 0000000..7d58117
--- /dev/null
+++ b/linux-core/intel_display.c
@@ -0,0 +1,1232 @@
+/*
+ * Copyright © 2006-2007 Intel Corporation
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
+ * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ *
+ * Authors:
+ *	Eric Anholt <eric@anholt.net>
+ */
+
+#include <linux/i2c.h>
+#include "drmP.h"
+#include "intel_drv.h"
+#include "i915_drm.h"
+#include "i915_drv.h"
+
+bool intel_pipe_has_type (struct drm_crtc *crtc, int type);
+
+typedef struct {
+    /* given values */    
+    int n;
+    int m1, m2;
+    int p1, p2;
+    /* derived values */
+    int	dot;
+    int	vco;
+    int	m;
+    int	p;
+} intel_clock_t;
+
+typedef struct {
+    int	min, max;
+} intel_range_t;
+
+typedef struct {
+    int	dot_limit;
+    int	p2_slow, p2_fast;
+} intel_p2_t;
+
+#define INTEL_P2_NUM		      2
+
+typedef struct {
+    intel_range_t   dot, vco, n, m, m1, m2, p, p1;
+    intel_p2_t	    p2;
+} intel_limit_t;
+
+#define I8XX_DOT_MIN		  25000
+#define I8XX_DOT_MAX		 350000
+#define I8XX_VCO_MIN		 930000
+#define I8XX_VCO_MAX		1400000
+#define I8XX_N_MIN		      3
+#define I8XX_N_MAX		     16
+#define I8XX_M_MIN		     96
+#define I8XX_M_MAX		    140
+#define I8XX_M1_MIN		     18
+#define I8XX_M1_MAX		     26
+#define I8XX_M2_MIN		      6
+#define I8XX_M2_MAX		     16
+#define I8XX_P_MIN		      4
+#define I8XX_P_MAX		    128
+#define I8XX_P1_MIN		      2
+#define I8XX_P1_MAX		     33
+#define I8XX_P1_LVDS_MIN	      1
+#define I8XX_P1_LVDS_MAX	      6
+#define I8XX_P2_SLOW		      4
+#define I8XX_P2_FAST		      2
+#define I8XX_P2_LVDS_SLOW	      14
+#define I8XX_P2_LVDS_FAST	      14 /* No fast option */
+#define I8XX_P2_SLOW_LIMIT	 165000
+
+#define I9XX_DOT_MIN		  20000
+#define I9XX_DOT_MAX		 400000
+#define I9XX_VCO_MIN		1400000
+#define I9XX_VCO_MAX		2800000
+#define I9XX_N_MIN		      3
+#define I9XX_N_MAX		      8
+#define I9XX_M_MIN		     70
+#define I9XX_M_MAX		    120
+#define I9XX_M1_MIN		     10
+#define I9XX_M1_MAX		     20
+#define I9XX_M2_MIN		      5
+#define I9XX_M2_MAX		      9
+#define I9XX_P_SDVO_DAC_MIN	      5
+#define I9XX_P_SDVO_DAC_MAX	     80
+#define I9XX_P_LVDS_MIN		      7
+#define I9XX_P_LVDS_MAX		     98
+#define I9XX_P1_MIN		      1
+#define I9XX_P1_MAX		      8
+#define I9XX_P2_SDVO_DAC_SLOW		     10
+#define I9XX_P2_SDVO_DAC_FAST		      5
+#define I9XX_P2_SDVO_DAC_SLOW_LIMIT	 200000
+#define I9XX_P2_LVDS_SLOW		     14
+#define I9XX_P2_LVDS_FAST		      7
+#define I9XX_P2_LVDS_SLOW_LIMIT		 112000
+
+#define INTEL_LIMIT_I8XX_DVO_DAC    0
+#define INTEL_LIMIT_I8XX_LVDS	    1
+#define INTEL_LIMIT_I9XX_SDVO_DAC   2
+#define INTEL_LIMIT_I9XX_LVDS	    3
+
+static const intel_limit_t intel_limits[] = {
+    { /* INTEL_LIMIT_I8XX_DVO_DAC */
+        .dot = { .min = I8XX_DOT_MIN,		.max = I8XX_DOT_MAX },
+        .vco = { .min = I8XX_VCO_MIN,		.max = I8XX_VCO_MAX },
+        .n   = { .min = I8XX_N_MIN,		.max = I8XX_N_MAX },
+        .m   = { .min = I8XX_M_MIN,		.max = I8XX_M_MAX },
+        .m1  = { .min = I8XX_M1_MIN,		.max = I8XX_M1_MAX },
+        .m2  = { .min = I8XX_M2_MIN,		.max = I8XX_M2_MAX },
+        .p   = { .min = I8XX_P_MIN,		.max = I8XX_P_MAX },
+        .p1  = { .min = I8XX_P1_MIN,		.max = I8XX_P1_MAX },
+	.p2  = { .dot_limit = I8XX_P2_SLOW_LIMIT,
+		 .p2_slow = I8XX_P2_SLOW,	.p2_fast = I8XX_P2_FAST },
+    },
+    { /* INTEL_LIMIT_I8XX_LVDS */
+        .dot = { .min = I8XX_DOT_MIN,		.max = I8XX_DOT_MAX },
+        .vco = { .min = I8XX_VCO_MIN,		.max = I8XX_VCO_MAX },
+        .n   = { .min = I8XX_N_MIN,		.max = I8XX_N_MAX },
+        .m   = { .min = I8XX_M_MIN,		.max = I8XX_M_MAX },
+        .m1  = { .min = I8XX_M1_MIN,		.max = I8XX_M1_MAX },
+        .m2  = { .min = I8XX_M2_MIN,		.max = I8XX_M2_MAX },
+        .p   = { .min = I8XX_P_MIN,		.max = I8XX_P_MAX },
+        .p1  = { .min = I8XX_P1_LVDS_MIN,	.max = I8XX_P1_LVDS_MAX },
+	.p2  = { .dot_limit = I8XX_P2_SLOW_LIMIT,
+		 .p2_slow = I8XX_P2_LVDS_SLOW,	.p2_fast = I8XX_P2_LVDS_FAST },
+    },
+    { /* INTEL_LIMIT_I9XX_SDVO_DAC */
+        .dot = { .min = I9XX_DOT_MIN,		.max = I9XX_DOT_MAX },
+        .vco = { .min = I9XX_VCO_MIN,		.max = I9XX_VCO_MAX },
+        .n   = { .min = I9XX_N_MIN,		.max = I9XX_N_MAX },
+        .m   = { .min = I9XX_M_MIN,		.max = I9XX_M_MAX },
+        .m1  = { .min = I9XX_M1_MIN,		.max = I9XX_M1_MAX },
+        .m2  = { .min = I9XX_M2_MIN,		.max = I9XX_M2_MAX },
+        .p   = { .min = I9XX_P_SDVO_DAC_MIN,	.max = I9XX_P_SDVO_DAC_MAX },
+        .p1  = { .min = I9XX_P1_MIN,		.max = I9XX_P1_MAX },
+	.p2  = { .dot_limit = I9XX_P2_SDVO_DAC_SLOW_LIMIT,
+		 .p2_slow = I9XX_P2_SDVO_DAC_SLOW,	.p2_fast = I9XX_P2_SDVO_DAC_FAST },
+    },
+    { /* INTEL_LIMIT_I9XX_LVDS */
+        .dot = { .min = I9XX_DOT_MIN,		.max = I9XX_DOT_MAX },
+        .vco = { .min = I9XX_VCO_MIN,		.max = I9XX_VCO_MAX },
+        .n   = { .min = I9XX_N_MIN,		.max = I9XX_N_MAX },
+        .m   = { .min = I9XX_M_MIN,		.max = I9XX_M_MAX },
+        .m1  = { .min = I9XX_M1_MIN,		.max = I9XX_M1_MAX },
+        .m2  = { .min = I9XX_M2_MIN,		.max = I9XX_M2_MAX },
+        .p   = { .min = I9XX_P_LVDS_MIN,	.max = I9XX_P_LVDS_MAX },
+        .p1  = { .min = I9XX_P1_MIN,		.max = I9XX_P1_MAX },
+	/* The single-channel range is 25-112Mhz, and dual-channel
+	 * is 80-224Mhz.  Prefer single channel as much as possible.
+	 */
+	.p2  = { .dot_limit = I9XX_P2_LVDS_SLOW_LIMIT,
+		 .p2_slow = I9XX_P2_LVDS_SLOW,	.p2_fast = I9XX_P2_LVDS_FAST },
+    },
+};
+
+static const intel_limit_t *intel_limit(struct drm_crtc *crtc)
+{
+	drm_device_t *dev = crtc->dev;
+	const intel_limit_t *limit;
+	
+	if (IS_I9XX(dev)) {
+		if (intel_pipe_has_type(crtc, INTEL_OUTPUT_LVDS))
+			limit = &intel_limits[INTEL_LIMIT_I9XX_LVDS];
+		else
+			limit = &intel_limits[INTEL_LIMIT_I9XX_SDVO_DAC];
+	} else {
+		if (intel_pipe_has_type(crtc, INTEL_OUTPUT_LVDS))
+			limit = &intel_limits[INTEL_LIMIT_I8XX_LVDS];
+		else
+			limit = &intel_limits[INTEL_LIMIT_I8XX_DVO_DAC];
+	}
+	return limit;
+}
+
+/** Derive the pixel clock for the given refclk and divisors for 8xx chips. */
+
+static void i8xx_clock(int refclk, intel_clock_t *clock)
+{
+	clock->m = 5 * (clock->m1 + 2) + (clock->m2 + 2);
+	clock->p = clock->p1 * clock->p2;
+	clock->vco = refclk * clock->m / (clock->n + 2);
+	clock->dot = clock->vco / clock->p;
+}
+
+/** Derive the pixel clock for the given refclk and divisors for 9xx chips. */
+
+static void i9xx_clock(int refclk, intel_clock_t *clock)
+{
+	clock->m = 5 * (clock->m1 + 2) + (clock->m2 + 2);
+	clock->p = clock->p1 * clock->p2;
+	clock->vco = refclk * clock->m / (clock->n + 2);
+	clock->dot = clock->vco / clock->p;
+}
+
+static void intel_clock(struct drm_device *dev, int refclk,
+			intel_clock_t *clock)
+{
+	if (IS_I9XX(dev))
+		return i9xx_clock (refclk, clock);
+	else
+		return i8xx_clock (refclk, clock);
+}
+
+/**
+ * Returns whether any output on the specified pipe is of the specified type
+ */
+bool intel_pipe_has_type (struct drm_crtc *crtc, int type)
+{
+    struct drm_device *dev = crtc->dev;
+    struct drm_mode_config *mode_config = &dev->mode_config;
+    struct drm_output *l_entry;
+
+    list_for_each_entry(l_entry, &mode_config->output_list, head) {
+	    if (l_entry->crtc == crtc) {
+		    struct intel_output *intel_output = l_entry->driver_private;
+		    if (intel_output->type == type)
+			    return true;
+	    }
+    }
+    return false;
+}
+
+#define INTELPllInvalid(s)   { /* ErrorF (s) */; return false; }
+/**
+ * Returns whether the given set of divisors are valid for a given refclk with
+ * the given outputs.
+ */
+
+static bool intel_PLL_is_valid(struct drm_crtc *crtc, intel_clock_t *clock)
+{
+	const intel_limit_t *limit = intel_limit (crtc);
+	
+	if (clock->p1  < limit->p1.min  || limit->p1.max  < clock->p1)
+		INTELPllInvalid ("p1 out of range\n");
+	if (clock->p   < limit->p.min   || limit->p.max   < clock->p)
+		INTELPllInvalid ("p out of range\n");
+	if (clock->m2  < limit->m2.min  || limit->m2.max  < clock->m2)
+		INTELPllInvalid ("m2 out of range\n");
+	if (clock->m1  < limit->m1.min  || limit->m1.max  < clock->m1)
+		INTELPllInvalid ("m1 out of range\n");
+	if (clock->m1 <= clock->m2)
+		INTELPllInvalid ("m1 <= m2\n");
+	if (clock->m   < limit->m.min   || limit->m.max   < clock->m)
+		INTELPllInvalid ("m out of range\n");
+	if (clock->n   < limit->n.min   || limit->n.max   < clock->n)
+		INTELPllInvalid ("n out of range\n");
+	if (clock->vco < limit->vco.min || limit->vco.max < clock->vco)
+		INTELPllInvalid ("vco out of range\n");
+	/* XXX: We may need to be checking "Dot clock" depending on the multiplier,
+	 * output, etc., rather than just a single range.
+	 */
+	if (clock->dot < limit->dot.min || limit->dot.max < clock->dot)
+		INTELPllInvalid ("dot out of range\n");
+	
+	return true;
+}
+
+/**
+ * Returns a set of divisors for the desired target clock with the given
+ * refclk, or FALSE.  The returned values represent the clock equation:
+ * reflck * (5 * (m1 + 2) + (m2 + 2)) / (n + 2) / p1 / p2.
+ */
+static bool intel_find_best_PLL(struct drm_crtc *crtc, int target,
+				int refclk, intel_clock_t *best_clock)
+{
+	drm_device_t *dev = crtc->dev;
+	drm_i915_private_t *dev_priv = dev->dev_private;
+	intel_clock_t clock;
+	const intel_limit_t *limit = intel_limit(crtc);
+	int err = target;
+
+	if (IS_I9XX(dev) && intel_pipe_has_type(crtc, INTEL_OUTPUT_LVDS) &&
+	    (I915_READ(LVDS) & LVDS_PORT_EN) != 0) {
+		/*
+		 * For LVDS, if the panel is on, just rely on its current
+		 * settings for dual-channel.  We haven't figured out how to
+		 * reliably set up different single/dual channel state, if we
+		 * even can.
+		 */
+		if ((I915_READ(LVDS) & LVDS_CLKB_POWER_MASK) ==
+		    LVDS_CLKB_POWER_UP)
+			clock.p2 = limit->p2.p2_fast;
+		else
+			clock.p2 = limit->p2.p2_slow;
+	} else {
+		if (target < limit->p2.dot_limit)
+			clock.p2 = limit->p2.p2_slow;
+		else
+			clock.p2 = limit->p2.p2_fast;
+	}
+	
+	memset (best_clock, 0, sizeof (*best_clock));
+	
+	for (clock.m1 = limit->m1.min; clock.m1 <= limit->m1.max; clock.m1++) {
+		for (clock.m2 = limit->m2.min; clock.m2 < clock.m1 &&
+			     clock.m2 <= limit->m2.max; clock.m2++) {
+			for (clock.n = limit->n.min; clock.n <= limit->n.max;
+			     clock.n++) {
+				for (clock.p1 = limit->p1.min;
+				     clock.p1 <= limit->p1.max; clock.p1++) {
+					int this_err;
+					
+					intel_clock(dev, refclk, &clock);
+					
+					if (!intel_PLL_is_valid(crtc, &clock))
+						continue;
+					
+					this_err = abs(clock.dot - target);
+					if (this_err < err) {
+						*best_clock = clock;
+						err = this_err;
+					}
+				}
+			}
+		}
+	}
+
+	return (err != target);
+}
+
+void
+intel_set_vblank(drm_device_t *dev)
+{
+	drm_i915_private_t *dev_priv = dev->dev_private;
+	struct drm_crtc *crtc;
+	struct intel_crtc *intel_crtc;
+	int vbl_pipe = 0;
+
+	list_for_each_entry(crtc, &dev->mode_config.crtc_list, head) {
+		intel_crtc = crtc->driver_private;
+
+		if (crtc->enabled)
+			vbl_pipe |= (1<<intel_crtc->pipe);
+	}
+
+	dev_priv->vblank_pipe = vbl_pipe;
+	i915_enable_interrupt(dev);
+}
+void
+intel_wait_for_vblank(drm_device_t *dev)
+{
+	/* Wait for 20ms, i.e. one cycle at 50hz. */
+	udelay(20000);
+}
+
+void
+intel_pipe_set_base(struct drm_crtc *crtc, int x, int y)
+{
+	drm_device_t *dev = crtc->dev;
+	drm_i915_private_t *dev_priv = dev->dev_private;
+	struct intel_crtc *intel_crtc = crtc->driver_private;
+	int pipe = intel_crtc->pipe;
+	unsigned long Start, Offset;
+	int dspbase = (pipe == 0 ? DSPABASE : DSPBBASE);
+	int dspsurf = (pipe == 0 ? DSPASURF : DSPBSURF);
+
+	Start = crtc->fb->offset;
+	Offset = ((y * crtc->fb->pitch + x) * (crtc->fb->bits_per_pixel / 8));
+
+	DRM_DEBUG("Writing base %08lX %08lX %d %d\n", Start, Offset, x, y);
+	if (IS_I965G(dev)) {
+		I915_WRITE(dspbase, Offset);
+		I915_READ(dspbase);
+		I915_WRITE(dspsurf, Start);
+		I915_READ(dspsurf);
+	} else {
+		I915_WRITE(dspbase, Start + Offset);
+		I915_READ(dspbase);
+	}
+	
+
+	if (!dev_priv->sarea_priv) 
+		return;
+		
+	switch (pipe) {
+	case 0:
+		dev_priv->sarea_priv->pipeA_x = x;
+		dev_priv->sarea_priv->pipeA_y = y;
+		break;
+	case 1:
+		dev_priv->sarea_priv->pipeB_x = x;
+		dev_priv->sarea_priv->pipeB_y = y;
+		break;
+	default:
+		DRM_ERROR("Can't update pipe %d in SAREA\n", pipe);
+		break;
+	}
+}
+
+/**
+ * Sets the power management mode of the pipe and plane.
+ *
+ * This code should probably grow support for turning the cursor off and back
+ * on appropriately at the same time as we're turning the pipe off/on.
+ */
+static void intel_crtc_dpms(struct drm_crtc *crtc, int mode)
+{
+	drm_device_t *dev = crtc->dev;
+	drm_i915_private_t *dev_priv = dev->dev_private;
+	struct intel_crtc *intel_crtc = crtc->driver_private;
+	int pipe = intel_crtc->pipe;
+	int dpll_reg = (pipe == 0) ? DPLL_A : DPLL_B;
+	int dspcntr_reg = (pipe == 0) ? DSPACNTR : DSPBCNTR;
+	int dspbase_reg = (pipe == 0) ? DSPABASE : DSPBBASE;
+	int pipeconf_reg = (pipe == 0) ? PIPEACONF : PIPEBCONF;
+	u32 temp;
+	bool enabled;
+
+	/* XXX: When our outputs are all unaware of DPMS modes other than off
+	 * and on, we should map those modes to DPMSModeOff in the CRTC.
+	 */
+	switch (mode) {
+	case DPMSModeOn:
+	case DPMSModeStandby:
+	case DPMSModeSuspend:
+		/* Enable the DPLL */
+		temp = I915_READ(dpll_reg);
+		if ((temp & DPLL_VCO_ENABLE) == 0) {
+			I915_WRITE(dpll_reg, temp);
+			I915_READ(dpll_reg);
+			/* Wait for the clocks to stabilize. */
+			udelay(150);
+			I915_WRITE(dpll_reg, temp | DPLL_VCO_ENABLE);
+			I915_READ(dpll_reg);
+			/* Wait for the clocks to stabilize. */
+			udelay(150);
+			I915_WRITE(dpll_reg, temp | DPLL_VCO_ENABLE);
+			I915_READ(dpll_reg);
+			/* Wait for the clocks to stabilize. */
+			udelay(150);
+		}
+		
+		/* Enable the pipe */
+		temp = I915_READ(pipeconf_reg);
+		if ((temp & PIPEACONF_ENABLE) == 0)
+			I915_WRITE(pipeconf_reg, temp | PIPEACONF_ENABLE);
+		
+		/* Enable the plane */
+		temp = I915_READ(dspcntr_reg);
+		if ((temp & DISPLAY_PLANE_ENABLE) == 0) {
+			I915_WRITE(dspcntr_reg, temp | DISPLAY_PLANE_ENABLE);
+			/* Flush the plane changes */
+			I915_WRITE(dspbase_reg, I915_READ(dspbase_reg));
+		}
+		
+		intel_crtc_load_lut(crtc);
+		
+		/* Give the overlay scaler a chance to enable if it's on this pipe */
+		//intel_crtc_dpms_video(crtc, TRUE); TODO
+	break;
+	case DPMSModeOff:
+		/* Give the overlay scaler a chance to disable if it's on this pipe */
+		//intel_crtc_dpms_video(crtc, FALSE); TODO
+		
+		/* Disable the VGA plane that we never use */
+		I915_WRITE(VGACNTRL, VGA_DISP_DISABLE);
+		
+		/* Disable display plane */
+		temp = I915_READ(dspcntr_reg);
+		if ((temp & DISPLAY_PLANE_ENABLE) != 0) {
+			I915_WRITE(dspcntr_reg, temp & ~DISPLAY_PLANE_ENABLE);
+			/* Flush the plane changes */
+			I915_WRITE(dspbase_reg, I915_READ(dspbase_reg));
+			I915_READ(dspbase_reg);
+		}
+		
+		if (!IS_I9XX(dev)) {
+			/* Wait for vblank for the disable to take effect */
+			intel_wait_for_vblank(dev);
+		}
+		
+		/* Next, disable display pipes */
+		temp = I915_READ(pipeconf_reg);
+		if ((temp & PIPEACONF_ENABLE) != 0) {
+			I915_WRITE(pipeconf_reg, temp & ~PIPEACONF_ENABLE);
+			I915_READ(pipeconf_reg);
+		}
+		
+		/* Wait for vblank for the disable to take effect. */
+		intel_wait_for_vblank(dev);
+		
+		temp = I915_READ(dpll_reg);
+		if ((temp & DPLL_VCO_ENABLE) != 0) {
+			I915_WRITE(dpll_reg, temp & ~DPLL_VCO_ENABLE);
+			I915_READ(dpll_reg);
+		}
+		
+		/* Wait for the clocks to turn off. */
+		udelay(150);
+		break;
+	}
+	
+
+	if (!dev_priv->sarea_priv)
+		return;
+
+	enabled = crtc->enabled && mode != DPMSModeOff;
+	
+	switch (pipe) {
+	case 0:
+		dev_priv->sarea_priv->pipeA_w = enabled ? crtc->mode.hdisplay : 0;
+		dev_priv->sarea_priv->pipeA_h = enabled ? crtc->mode.vdisplay : 0;
+		break;
+	case 1:
+		dev_priv->sarea_priv->pipeB_w = enabled ? crtc->mode.hdisplay : 0;
+		dev_priv->sarea_priv->pipeB_h = enabled ? crtc->mode.vdisplay : 0;
+		break;
+	default:
+		DRM_ERROR("Can't update pipe %d in SAREA\n", pipe);
+		break;
+	}
+}
+
+static bool intel_crtc_lock(struct drm_crtc *crtc)
+{
+   /* Sync the engine before mode switch */
+//   i830WaitSync(crtc->scrn);
+
+#if 0 // TODO def XF86DRI
+    return I830DRILock(crtc->scrn);
+#else
+    return FALSE;
+#endif
+}
+
+static void intel_crtc_unlock (struct drm_crtc *crtc)
+{
+#if 0 // TODO def XF86DRI
+    I830DRIUnlock (crtc->scrn);
+#endif
+}
+
+static void intel_crtc_prepare (struct drm_crtc *crtc)
+{
+	crtc->funcs->dpms(crtc, DPMSModeOff);
+}
+
+static void intel_crtc_commit (struct drm_crtc *crtc)
+{
+	crtc->funcs->dpms(crtc, DPMSModeOn);
+}
+
+void intel_output_prepare (struct drm_output *output)
+{
+	/* lvds has its own version of prepare see intel_lvds_prepare */
+	output->funcs->dpms(output, DPMSModeOff);
+}
+
+void intel_output_commit (struct drm_output *output)
+{
+	/* lvds has its own version of commit see intel_lvds_commit */
+	output->funcs->dpms(output, DPMSModeOn);
+}
+
+static bool intel_crtc_mode_fixup(struct drm_crtc *crtc,
+				  struct drm_display_mode *mode,
+				  struct drm_display_mode *adjusted_mode)
+{
+	return true;
+}
+
+
+/** Returns the core display clock speed for i830 - i945 */
+static int intel_get_core_clock_speed(drm_device_t *dev)
+{
+
+	/* Core clock values taken from the published datasheets.
+	 * The 830 may go up to 166 Mhz, which we should check.
+	 */
+	if (IS_I945G(dev))
+		return 400000;
+	else if (IS_I915G(dev))
+		return 333000;
+	else if (IS_I945GM(dev) || IS_845G(dev))
+		return 200000;
+	else if (IS_I915GM(dev)) {
+		u16 gcfgc = 0;
+
+		pci_read_config_word(dev->pdev, I915_GCFGC, &gcfgc);
+		
+		if (gcfgc & I915_LOW_FREQUENCY_ENABLE)
+			return 133000;
+		else {
+			switch (gcfgc & I915_DISPLAY_CLOCK_MASK) {
+			case I915_DISPLAY_CLOCK_333_MHZ:
+				return 333000;
+			default:
+			case I915_DISPLAY_CLOCK_190_200_MHZ:
+				return 190000;
+			}
+		}
+	} else if (IS_I865G(dev))
+		return 266000;
+	else if (IS_I855(dev)) {
+#if 0
+		PCITAG bridge = pciTag(0, 0, 0); /* This is always the host bridge */
+		u16 hpllcc = pciReadWord(bridge, I855_HPLLCC);
+		
+#endif
+		u16 hpllcc = 0;
+		/* Assume that the hardware is in the high speed state.  This
+		 * should be the default.
+		 */
+		switch (hpllcc & I855_CLOCK_CONTROL_MASK) {
+		case I855_CLOCK_133_200:
+		case I855_CLOCK_100_200:
+			return 200000;
+		case I855_CLOCK_166_250:
+			return 250000;
+		case I855_CLOCK_100_133:
+			return 133000;
+		}
+	} else /* 852, 830 */
+		return 133000;
+	
+	return 0; /* Silence gcc warning */
+}
+
+
+/**
+ * Return the pipe currently connected to the panel fitter,
+ * or -1 if the panel fitter is not present or not in use
+ */
+static int intel_panel_fitter_pipe (drm_device_t *dev)
+{
+	drm_i915_private_t *dev_priv = dev->dev_private;
+	u32  pfit_control;
+    
+	/* i830 doesn't have a panel fitter */
+	if (IS_I830(dev))
+		return -1;
+    
+	pfit_control = I915_READ(PFIT_CONTROL);
+    
+	/* See if the panel fitter is in use */
+	if ((pfit_control & PFIT_ENABLE) == 0)
+		return -1;
+	
+	/* 965 can place panel fitter on either pipe */
+	if (IS_I965G(dev))
+		return (pfit_control >> 29) & 0x3;
+	
+	/* older chips can only use pipe 1 */
+	return 1;
+}
+
+static void intel_crtc_mode_set(struct drm_crtc *crtc,
+				struct drm_display_mode *mode,
+				struct drm_display_mode *adjusted_mode,
+				int x, int y)
+{
+	drm_device_t *dev = crtc->dev;
+	drm_i915_private_t *dev_priv = dev->dev_private;
+	struct intel_crtc *intel_crtc = crtc->driver_private;
+	int pipe = intel_crtc->pipe;
+	int fp_reg = (pipe == 0) ? FPA0 : FPB0;
+	int dpll_reg = (pipe == 0) ? DPLL_A : DPLL_B;
+	int dpll_md_reg = (intel_crtc->pipe == 0) ? DPLL_A_MD : DPLL_B_MD;
+	int dspcntr_reg = (pipe == 0) ? DSPACNTR : DSPBCNTR;
+	int pipeconf_reg = (pipe == 0) ? PIPEACONF : PIPEBCONF;
+	int htot_reg = (pipe == 0) ? HTOTAL_A : HTOTAL_B;
+	int hblank_reg = (pipe == 0) ? HBLANK_A : HBLANK_B;
+	int hsync_reg = (pipe == 0) ? HSYNC_A : HSYNC_B;
+	int vtot_reg = (pipe == 0) ? VTOTAL_A : VTOTAL_B;
+	int vblank_reg = (pipe == 0) ? VBLANK_A : VBLANK_B;
+	int vsync_reg = (pipe == 0) ? VSYNC_A : VSYNC_B;
+	int dspsize_reg = (pipe == 0) ? DSPASIZE : DSPBSIZE;
+	int dspstride_reg = (pipe == 0) ? DSPASTRIDE : DSPBSTRIDE;
+	int dsppos_reg = (pipe == 0) ? DSPAPOS : DSPBPOS;
+	int pipesrc_reg = (pipe == 0) ? PIPEASRC : PIPEBSRC;
+	int refclk;
+	intel_clock_t clock;
+	u32 dpll = 0, fp = 0, dspcntr, pipeconf;
+	bool ok, is_sdvo = false, is_dvo = false;
+	bool is_crt = false, is_lvds = false, is_tv = false;
+	struct drm_mode_config *mode_config = &dev->mode_config;
+	struct drm_output *output;
+
+	list_for_each_entry(output, &mode_config->output_list, head) {
+		struct intel_output *intel_output = output->driver_private;
+
+		if (output->crtc != crtc)
+			continue;
+
+		switch (intel_output->type) {
+		case INTEL_OUTPUT_LVDS:
+			is_lvds = TRUE;
+			break;
+		case INTEL_OUTPUT_SDVO:
+			is_sdvo = TRUE;
+			break;
+		case INTEL_OUTPUT_DVO:
+			is_dvo = TRUE;
+			break;
+		case INTEL_OUTPUT_TVOUT:
+			is_tv = TRUE;
+			break;
+		case INTEL_OUTPUT_ANALOG:
+			is_crt = TRUE;
+			break;
+		}
+	}
+	
+	if (IS_I9XX(dev)) {
+		refclk = 96000;
+	} else {
+		refclk = 48000;
+	}
+
+	ok = intel_find_best_PLL(crtc, adjusted_mode->clock, refclk, &clock);
+	if (!ok) {
+		DRM_ERROR("Couldn't find PLL settings for mode!\n");
+		return;
+	}
+
+	fp = clock.n << 16 | clock.m1 << 8 | clock.m2;
+	
+	dpll = DPLL_VGA_MODE_DIS;
+	if (IS_I9XX(dev)) {
+		if (is_lvds)
+			dpll |= DPLLB_MODE_LVDS;
+		else
+			dpll |= DPLLB_MODE_DAC_SERIAL;
+		if (is_sdvo) {
+			dpll |= DPLL_DVO_HIGH_SPEED;
+			if (IS_I945G(dev) || IS_I945GM(dev)) {
+				int sdvo_pixel_multiply = adjusted_mode->clock / mode->clock;
+				dpll |= (sdvo_pixel_multiply - 1) << SDVO_MULTIPLIER_SHIFT_HIRES;
+			}
+		}
+		
+		/* compute bitmask from p1 value */
+		dpll |= (1 << (clock.p1 - 1)) << 16;
+		switch (clock.p2) {
+		case 5:
+			dpll |= DPLL_DAC_SERIAL_P2_CLOCK_DIV_5;
+			break;
+		case 7:
+			dpll |= DPLLB_LVDS_P2_CLOCK_DIV_7;
+			break;
+		case 10:
+			dpll |= DPLL_DAC_SERIAL_P2_CLOCK_DIV_10;
+			break;
+		case 14:
+			dpll |= DPLLB_LVDS_P2_CLOCK_DIV_14;
+			break;
+		}
+		if (IS_I965G(dev))
+			dpll |= (6 << PLL_LOAD_PULSE_PHASE_SHIFT);
+	} else {
+		if (is_lvds) {
+			dpll |= (1 << (clock.p1 - 1)) << DPLL_FPA01_P1_POST_DIV_SHIFT;
+		} else {
+			if (clock.p1 == 2)
+				dpll |= PLL_P1_DIVIDE_BY_TWO;
+			else
+				dpll |= (clock.p1 - 2) << DPLL_FPA01_P1_POST_DIV_SHIFT;
+			if (clock.p2 == 4)
+				dpll |= PLL_P2_DIVIDE_BY_4;
+		}
+	}
+	
+	if (is_tv) {
+		/* XXX: just matching BIOS for now */
+/*	dpll |= PLL_REF_INPUT_TVCLKINBC; */
+		dpll |= 3;
+	}
+#if 0
+	else if (is_lvds)
+		dpll |= PLLB_REF_INPUT_SPREADSPECTRUMIN;
+#endif
+	else
+		dpll |= PLL_REF_INPUT_DREFCLK;
+	
+	/* Set up the display plane register */
+	dspcntr = DISPPLANE_GAMMA_ENABLE;
+
+	switch (crtc->fb->bits_per_pixel) {
+	case 8:
+		dspcntr |= DISPPLANE_8BPP;
+		break;
+	case 16:
+		if (crtc->fb->depth == 15)
+			dspcntr |= DISPPLANE_15_16BPP;
+		else
+			dspcntr |= DISPPLANE_16BPP;
+		break;
+	case 32:
+		dspcntr |= DISPPLANE_32BPP_NO_ALPHA;
+		break;
+	default:
+		DRM_ERROR("Unknown color depth\n");
+		return;
+	}
+	
+
+	if (pipe == 0)
+		dspcntr |= DISPPLANE_SEL_PIPE_A;
+	else
+		dspcntr |= DISPPLANE_SEL_PIPE_B;
+	
+	pipeconf = I915_READ(pipeconf_reg);
+	if (pipe == 0 && !IS_I965G(dev)) {
+		/* Enable pixel doubling when the dot clock is > 90% of the (display)
+		 * core speed.
+		 *
+		 * XXX: No double-wide on 915GM pipe B. Is that the only reason for the
+		 * pipe == 0 check?
+		 */
+		if (mode->clock > intel_get_core_clock_speed(dev) * 9 / 10)
+			pipeconf |= PIPEACONF_DOUBLE_WIDE;
+		else
+			pipeconf &= ~PIPEACONF_DOUBLE_WIDE;
+	}
+
+	dspcntr |= DISPLAY_PLANE_ENABLE;
+	pipeconf |= PIPEACONF_ENABLE;
+	dpll |= DPLL_VCO_ENABLE;
+
+	
+	/* Disable the panel fitter if it was on our pipe */
+	if (intel_panel_fitter_pipe(dev) == pipe)
+		I915_WRITE(PFIT_CONTROL, 0);
+
+	DRM_DEBUG("Mode for pipe %c:\n", pipe == 0 ? 'A' : 'B');
+	drm_mode_debug_printmodeline(dev, mode);
+	
+#if 0
+	if (!xf86ModesEqual(mode, adjusted_mode)) {
+		xf86DrvMsg(pScrn->scrnIndex, X_INFO,
+			   "Adjusted mode for pipe %c:\n", pipe == 0 ? 'A' : 'B');
+		xf86PrintModeline(pScrn->scrnIndex, mode);
+	}
+	i830PrintPll("chosen", &clock);
+#endif
+
+	if (dpll & DPLL_VCO_ENABLE) {
+		I915_WRITE(fp_reg, fp);
+		I915_WRITE(dpll_reg, dpll & ~DPLL_VCO_ENABLE);
+		I915_READ(dpll_reg);
+		udelay(150);
+	}
+	
+	/* The LVDS pin pair needs to be on before the DPLLs are enabled.
+	 * This is an exception to the general rule that mode_set doesn't turn
+	 * things on.
+	 */
+	if (is_lvds) {
+		u32 lvds = I915_READ(LVDS);
+		
+		lvds |= LVDS_PORT_EN | LVDS_A0A2_CLKA_POWER_UP | LVDS_PIPEB_SELECT;
+		/* Set the B0-B3 data pairs corresponding to whether we're going to
+		 * set the DPLLs for dual-channel mode or not.
+		 */
+		if (clock.p2 == 7)
+			lvds |= LVDS_B0B3_POWER_UP | LVDS_CLKB_POWER_UP;
+		else
+			lvds &= ~(LVDS_B0B3_POWER_UP | LVDS_CLKB_POWER_UP);
+		
+		/* It would be nice to set 24 vs 18-bit mode (LVDS_A3_POWER_UP)
+		 * appropriately here, but we need to look more thoroughly into how
+		 * panels behave in the two modes.
+		 */
+		
+		I915_WRITE(LVDS, lvds);
+		I915_READ(LVDS);
+	}
+	
+	I915_WRITE(fp_reg, fp);
+	I915_WRITE(dpll_reg, dpll);
+	I915_READ(dpll_reg);
+	/* Wait for the clocks to stabilize. */
+	udelay(150);
+	
+	if (IS_I965G(dev)) {
+		int sdvo_pixel_multiply = adjusted_mode->clock / mode->clock;
+		I915_WRITE(dpll_md_reg, (0 << DPLL_MD_UDI_DIVIDER_SHIFT) |
+			   ((sdvo_pixel_multiply - 1) << DPLL_MD_UDI_MULTIPLIER_SHIFT));
+	} else {
+		/* write it again -- the BIOS does, after all */
+		I915_WRITE(dpll_reg, dpll);
+	}
+	I915_READ(dpll_reg);
+	/* Wait for the clocks to stabilize. */
+	udelay(150);
+	
+	I915_WRITE(htot_reg, (adjusted_mode->crtc_hdisplay - 1) |
+		   ((adjusted_mode->crtc_htotal - 1) << 16));
+	I915_WRITE(hblank_reg, (adjusted_mode->crtc_hblank_start - 1) |
+		   ((adjusted_mode->crtc_hblank_end - 1) << 16));
+	I915_WRITE(hsync_reg, (adjusted_mode->crtc_hsync_start - 1) |
+		   ((adjusted_mode->crtc_hsync_end - 1) << 16));
+	I915_WRITE(vtot_reg, (adjusted_mode->crtc_vdisplay - 1) |
+		   ((adjusted_mode->crtc_vtotal - 1) << 16));
+	I915_WRITE(vblank_reg, (adjusted_mode->crtc_vblank_start - 1) |
+		   ((adjusted_mode->crtc_vblank_end - 1) << 16));
+	I915_WRITE(vsync_reg, (adjusted_mode->crtc_vsync_start - 1) |
+		   ((adjusted_mode->crtc_vsync_end - 1) << 16));
+	I915_WRITE(dspstride_reg, crtc->fb->pitch * (crtc->fb->bits_per_pixel / 8));
+	/* pipesrc and dspsize control the size that is scaled from, which should
+	 * always be the user's requested size.
+	 */
+	I915_WRITE(dspsize_reg, ((mode->vdisplay - 1) << 16) | (mode->hdisplay - 1));
+	I915_WRITE(dsppos_reg, 0);
+	I915_WRITE(pipesrc_reg, ((mode->hdisplay - 1) << 16) | (mode->vdisplay - 1));
+	I915_WRITE(pipeconf_reg, pipeconf);
+	I915_READ(pipeconf_reg);
+	
+	intel_wait_for_vblank(dev);
+	
+	I915_WRITE(dspcntr_reg, dspcntr);
+	
+	/* Flush the plane changes */
+	intel_pipe_set_base(crtc, x, y);
+	
+	intel_set_vblank(dev);
+
+	intel_wait_for_vblank(dev);    
+}
+
+/** Loads the palette/gamma unit for the CRTC with the prepared values */
+void intel_crtc_load_lut(struct drm_crtc *crtc)
+{
+	drm_device_t *dev = crtc->dev;
+	drm_i915_private_t *dev_priv = dev->dev_private;
+	struct intel_crtc *intel_crtc = crtc->driver_private;
+	int palreg = (intel_crtc->pipe == 0) ? PALETTE_A : PALETTE_B;
+	int i;
+
+	/* The clocks have to be on to load the palette. */
+	if (!crtc->enabled)
+		return;
+
+	for (i = 0; i < 256; i++) {
+		I915_WRITE(palreg + 4 * i,
+			   (intel_crtc->lut_r[i] << 16) |
+			   (intel_crtc->lut_g[i] << 8) |
+			   intel_crtc->lut_b[i]);
+	}
+}
+
+/** Sets the color ramps on behalf of RandR */
+static void intel_crtc_gamma_set(struct drm_crtc *crtc, u16 *red, u16 *green,
+				 u16 *blue, int size)
+{
+	struct intel_crtc *intel_crtc = crtc->driver_private;
+	int i;
+	
+	for (i = 0; i < 256; i++) {
+		intel_crtc->lut_r[i] = red[i] >> 8;
+		intel_crtc->lut_g[i] = green[i] >> 8;
+		intel_crtc->lut_b[i] = blue[i] >> 8;
+	}
+	
+	intel_crtc_load_lut(crtc);
+}
+
+/* Returns the clock of the currently programmed mode of the given pipe. */
+static int intel_crtc_clock_get(struct drm_device *dev, struct drm_crtc *crtc)
+{
+	drm_i915_private_t *dev_priv = dev->dev_private;
+	struct intel_crtc *intel_crtc = crtc->driver_private;
+	int pipe = intel_crtc->pipe;
+	u32 dpll = I915_READ((pipe == 0) ? DPLL_A : DPLL_B);
+	u32 fp;
+	intel_clock_t clock;
+
+	if ((dpll & DISPLAY_RATE_SELECT_FPA1) == 0)
+		fp = I915_READ((pipe == 0) ? FPA0 : FPB0);
+	else
+		fp = I915_READ((pipe == 0) ? FPA1 : FPB1);
+
+	clock.m1 = (fp & FP_M1_DIV_MASK) >> FP_M1_DIV_SHIFT;
+	clock.m2 = (fp & FP_M2_DIV_MASK) >> FP_M2_DIV_SHIFT;
+	clock.n = (fp & FP_N_DIV_MASK) >> FP_N_DIV_SHIFT;
+	if (IS_I9XX(dev)) {
+		clock.p1 = ffs((dpll & DPLL_FPA01_P1_POST_DIV_MASK) >>
+			       DPLL_FPA01_P1_POST_DIV_SHIFT);
+
+		switch (dpll & DPLL_MODE_MASK) {
+		case DPLLB_MODE_DAC_SERIAL:
+			clock.p2 = dpll & DPLL_DAC_SERIAL_P2_CLOCK_DIV_5 ?
+				5 : 10;
+			break;
+		case DPLLB_MODE_LVDS:
+			clock.p2 = dpll & DPLLB_LVDS_P2_CLOCK_DIV_7 ?
+				7 : 14;
+			break;
+		default:
+			DRM_DEBUG("Unknown DPLL mode %08x in programmed "
+				  "mode\n", (int)(dpll & DPLL_MODE_MASK));
+			return 0;
+		}
+
+		/* XXX: Handle the 100Mhz refclk */
+		i9xx_clock(96000, &clock);
+	} else {
+		bool is_lvds = (pipe == 1) && (I915_READ(LVDS) & LVDS_PORT_EN);
+
+		if (is_lvds) {
+			clock.p1 = ffs((dpll & DPLL_FPA01_P1_POST_DIV_MASK_I830_LVDS) >>
+				       DPLL_FPA01_P1_POST_DIV_SHIFT);
+			clock.p2 = 14;
+
+			if ((dpll & PLL_REF_INPUT_MASK) ==
+			    PLLB_REF_INPUT_SPREADSPECTRUMIN) {
+				/* XXX: might not be 66MHz */
+				i8xx_clock(66000, &clock);
+			} else
+				i8xx_clock(48000, &clock);		
+		} else {
+			if (dpll & PLL_P1_DIVIDE_BY_TWO)
+				clock.p1 = 2;
+			else {
+				clock.p1 = ((dpll & DPLL_FPA01_P1_POST_DIV_MASK_I830) >>
+					    DPLL_FPA01_P1_POST_DIV_SHIFT) + 2;
+			}
+			if (dpll & PLL_P2_DIVIDE_BY_4)
+				clock.p2 = 4;
+			else
+				clock.p2 = 2;
+
+			i8xx_clock(48000, &clock);
+		}
+	}
+
+	/* XXX: It would be nice to validate the clocks, but we can't reuse
+	 * i830PllIsValid() because it relies on the xf86_config output
+	 * configuration being accurate, which it isn't necessarily.
+	 */
+
+	return clock.dot;
+}
+
+/** Returns the currently programmed mode of the given pipe. */
+struct drm_display_mode *intel_crtc_mode_get(drm_device_t *dev,
+					     struct drm_crtc *crtc)
+{
+	drm_i915_private_t *dev_priv = dev->dev_private;
+	struct intel_crtc *intel_crtc = crtc->driver_private;
+	int pipe = intel_crtc->pipe;
+	struct drm_display_mode *mode;
+	int htot = I915_READ((pipe == 0) ? HTOTAL_A : HTOTAL_B);
+	int hsync = I915_READ((pipe == 0) ? HSYNC_A : HSYNC_B);
+	int vtot = I915_READ((pipe == 0) ? VTOTAL_A : VTOTAL_B);
+	int vsync = I915_READ((pipe == 0) ? VSYNC_A : VSYNC_B);
+
+	mode = kzalloc(sizeof(*mode), GFP_KERNEL);
+	if (!mode)
+		return NULL;
+
+	mode->clock = intel_crtc_clock_get(dev, crtc);
+	mode->hdisplay = (htot & 0xffff) + 1;
+	mode->htotal = ((htot & 0xffff0000) >> 16) + 1;
+	mode->hsync_start = (hsync & 0xffff) + 1;
+	mode->hsync_end = ((hsync & 0xffff0000) >> 16) + 1;
+	mode->vdisplay = (vtot & 0xffff) + 1;
+	mode->vtotal = ((vtot & 0xffff0000) >> 16) + 1;
+	mode->vsync_start = (vsync & 0xffff) + 1;
+	mode->vsync_end = ((vsync & 0xffff0000) >> 16) + 1;
+
+	drm_mode_set_name(mode);
+	drm_mode_set_crtcinfo(mode, 0);
+
+	return mode;
+}
+
+static const struct drm_crtc_funcs intel_crtc_funcs = {
+	.dpms = intel_crtc_dpms,
+	.lock = intel_crtc_lock,
+	.unlock = intel_crtc_unlock,
+	.mode_fixup = intel_crtc_mode_fixup,
+	.mode_set = intel_crtc_mode_set,
+	.gamma_set = intel_crtc_gamma_set,
+	.prepare = intel_crtc_prepare,
+	.commit = intel_crtc_commit,
+};
+
+
+void intel_crtc_init(drm_device_t *dev, int pipe)
+{
+	struct drm_crtc *crtc;
+	struct intel_crtc *intel_crtc;
+	int i;
+
+	crtc = drm_crtc_create(dev, &intel_crtc_funcs);
+	if (crtc == NULL)
+		return;
+
+	intel_crtc = kzalloc(sizeof(struct intel_crtc), GFP_KERNEL);
+	if (intel_crtc == NULL) {
+		kfree(crtc);
+		return;
+	}
+
+	intel_crtc->pipe = pipe;
+	for (i = 0; i < 256; i++) {
+		intel_crtc->lut_r[i] = i;
+		intel_crtc->lut_g[i] = i;
+		intel_crtc->lut_b[i] = i;
+	}
+
+	crtc->driver_private = intel_crtc;
+}
+
+struct drm_crtc *intel_get_crtc_from_pipe(drm_device_t *dev, int pipe)
+{
+	struct drm_crtc *crtc = NULL;
+
+	list_for_each_entry(crtc, &dev->mode_config.crtc_list, head) {
+		struct intel_crtc *intel_crtc = crtc->driver_private;
+		if (intel_crtc->pipe == pipe)
+			break;
+	}
+	return crtc;
+}
+
+int intel_output_clones(drm_device_t *dev, int type_mask)
+{
+	int index_mask = 0;
+	struct drm_output *output;
+	int entry = 0;
+
+        list_for_each_entry(output, &dev->mode_config.output_list, head) {
+		struct intel_output *intel_output = output->driver_private;
+		if (type_mask & (1 << intel_output->type))
+			index_mask |= (1 << entry);
+		entry++;
+	}
+	return index_mask;
+}
+
+
+static void intel_setup_outputs(drm_device_t *dev)
+{
+	struct drm_output *output;
+
+	intel_crt_init(dev);
+
+	/* Set up integrated LVDS */
+	if (IS_MOBILE(dev) && !IS_I830(dev))
+		intel_lvds_init(dev);
+
+	if (IS_I9XX(dev)) {
+		intel_sdvo_init(dev, SDVOB);
+		intel_sdvo_init(dev, SDVOC);
+	}
+
+	list_for_each_entry(output, &dev->mode_config.output_list, head) {
+		struct intel_output *intel_output = output->driver_private;
+		int crtc_mask = 0, clone_mask = 0;
+		
+		/* valid crtcs */
+		switch(intel_output->type) {
+		case INTEL_OUTPUT_DVO:
+		case INTEL_OUTPUT_SDVO:
+			crtc_mask = ((1 << 0)|
+				     (1 << 1));
+			clone_mask = ((1 << INTEL_OUTPUT_ANALOG) |
+				      (1 << INTEL_OUTPUT_DVO) |
+				      (1 << INTEL_OUTPUT_SDVO));
+			break;
+		case INTEL_OUTPUT_ANALOG:
+			crtc_mask = ((1 << 0));
+			clone_mask = ((1 << INTEL_OUTPUT_ANALOG) |
+				      (1 << INTEL_OUTPUT_DVO) |
+				      (1 << INTEL_OUTPUT_SDVO));
+			break;
+		case INTEL_OUTPUT_LVDS:
+			crtc_mask = (1 << 1);
+			clone_mask = (1 << INTEL_OUTPUT_LVDS);
+			break;
+		case INTEL_OUTPUT_TVOUT:
+			crtc_mask = ((1 << 0) |
+				     (1 << 1));
+			clone_mask = (1 << INTEL_OUTPUT_TVOUT);
+			break;
+		}
+		output->possible_crtcs = crtc_mask;
+		output->possible_clones = intel_output_clones(dev, clone_mask);
+	}
+}
+
+void intel_modeset_init(drm_device_t *dev)
+{
+	int num_pipe;
+	int i;
+
+	drm_mode_config_init(dev);
+
+	dev->mode_config.min_width = 0;
+	dev->mode_config.min_height = 0;
+
+	dev->mode_config.max_width = 4096;
+	dev->mode_config.max_height = 4096;
+
+	if (IS_MOBILE(dev) || IS_I9XX(dev))
+		num_pipe = 2;
+	else
+		num_pipe = 1;
+	DRM_DEBUG("%d display pipe%s available.\n",
+		  num_pipe, num_pipe > 1 ? "s" : "");
+
+	for (i = 0; i < num_pipe; i++) {
+		intel_crtc_init(dev, i);
+	}
+
+	intel_setup_outputs(dev);
+
+	//drm_initial_config(dev, false);
+	//drm_set_desired_modes(dev);
+}
+
+void intel_modeset_cleanup(drm_device_t *dev)
+{
+	drm_mode_config_cleanup(dev);
+}
diff --git a/linux-core/intel_drv.h b/linux-core/intel_drv.h
new file mode 100644
index 0000000..aa33437
--- /dev/null
+++ b/linux-core/intel_drv.h
@@ -0,0 +1,79 @@
+/*
+ * Copyright (c) 2006 Dave Airlie <airlied@linux.ie>
+ * Copyright (c) 2007 Intel Corporation
+ *   Jesse Barnes <jesse.barnes@intel.com>
+ */
+#ifndef __INTEL_DRV_H__
+#define __INTEL_DRV_H__
+
+#include <linux/i2c.h>
+#include <linux/i2c-id.h>
+#include <linux/i2c-algo-bit.h>
+#include "drm_crtc.h"
+
+/*
+ * Display related stuff
+ */
+
+/* store information about an Ixxx DVO */
+/* The i830->i865 use multiple DVOs with multiple i2cs */
+/* the i915, i945 have a single sDVO i2c bus - which is different */
+#define MAX_OUTPUTS 6
+
+#define INTEL_I2C_BUS_DVO 1
+#define INTEL_I2C_BUS_SDVO 2
+
+/* these are outputs from the chip - integrated only 
+   external chips are via DVO or SDVO output */
+#define INTEL_OUTPUT_UNUSED 0
+#define INTEL_OUTPUT_ANALOG 1
+#define INTEL_OUTPUT_DVO 2
+#define INTEL_OUTPUT_SDVO 3
+#define INTEL_OUTPUT_LVDS 4
+#define INTEL_OUTPUT_TVOUT 5
+
+#define INTEL_DVO_CHIP_NONE 0
+#define INTEL_DVO_CHIP_LVDS 1
+#define INTEL_DVO_CHIP_TMDS 2
+#define INTEL_DVO_CHIP_TVOUT 4
+
+struct intel_i2c_chan {
+	drm_device_t *drm_dev; /* for getting at dev. private (mmio etc.) */
+	u32 reg; /* GPIO reg */
+	struct i2c_adapter adapter;
+	struct i2c_algo_bit_data algo;
+        u8 slave_addr;
+};
+
+struct intel_output {
+	int type;
+	struct intel_i2c_chan *i2c_bus; /* for control functions */
+	struct intel_i2c_chan *ddc_bus; /* for DDC only stuff */
+	bool load_detect_tmp;
+	void *dev_priv;
+};
+
+struct intel_crtc {
+	int pipe;
+	u8 lut_r[256], lut_g[256], lut_b[256];
+};
+
+struct intel_i2c_chan *intel_i2c_create(drm_device_t *dev, const u32 reg,
+					const char *name);
+void intel_i2c_destroy(struct intel_i2c_chan *chan);
+int intel_ddc_get_modes(struct drm_output *output);
+extern bool intel_ddc_probe(struct drm_output *output);
+
+extern void intel_crt_init(drm_device_t *dev);
+extern void intel_sdvo_init(drm_device_t *dev, int output_device);
+extern void intel_lvds_init(drm_device_t *dev);
+
+extern void intel_crtc_load_lut(struct drm_crtc *crtc);
+extern void intel_output_prepare (struct drm_output *output);
+extern void intel_output_commit (struct drm_output *output);
+extern struct drm_display_mode *intel_crtc_mode_get(drm_device_t *dev,
+						    struct drm_crtc *crtc);
+extern void intel_wait_for_vblank(drm_device_t *dev);
+extern struct drm_crtc *intel_get_crtc_from_pipe(drm_device_t *dev, int pipe);
+
+#endif /* __INTEL_DRV_H__ */
diff --git a/linux-core/intel_i2c.c b/linux-core/intel_i2c.c
new file mode 100644
index 0000000..d4cf7ee
--- /dev/null
+++ b/linux-core/intel_i2c.c
@@ -0,0 +1,187 @@
+/*
+ * Copyright © 2006-2007 Intel Corporation
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
+ * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ *
+ * Authors:
+ *	Eric Anholt <eric@anholt.net>
+ */
+/*
+ * Copyright (c) 2006 Dave Airlie <airlied@linux.ie>
+ *   Jesse Barnes <jesse.barnes@intel.com>
+ */
+
+#include <linux/i2c.h>
+#include <linux/i2c-id.h>
+#include <linux/i2c-algo-bit.h>
+#include "drmP.h"
+#include "drm.h"
+#include "intel_drv.h"
+#include "i915_drm.h"
+#include "i915_drv.h"
+
+/*
+ * Intel GPIO access functions
+ */
+
+#define I2C_RISEFALL_TIME 20
+
+static int get_clock(void *data)
+{
+	struct intel_i2c_chan *chan = data;
+	drm_i915_private_t *dev_priv = chan->drm_dev->dev_private;
+	u32 val;
+
+	val = I915_READ(chan->reg);
+	return ((val & GPIO_CLOCK_VAL_IN) != 0);
+}
+
+static int get_data(void *data)
+{
+	struct intel_i2c_chan *chan = data;
+	drm_i915_private_t *dev_priv = chan->drm_dev->dev_private;
+	u32 val;
+
+	val = I915_READ(chan->reg);
+	return ((val & GPIO_DATA_VAL_IN) != 0);
+}
+
+static void set_clock(void *data, int state_high)
+{
+	struct intel_i2c_chan *chan = data;
+	drm_device_t *dev = chan->drm_dev;
+	drm_i915_private_t *dev_priv = chan->drm_dev->dev_private;
+	u32 reserved = 0, clock_bits;
+
+	/* On most chips, these bits must be preserved in software. */
+	if (!IS_I830(dev) && !IS_845G(dev))
+		reserved = I915_READ(chan->reg) & (GPIO_DATA_PULLUP_DISABLE |
+						   GPIO_CLOCK_PULLUP_DISABLE);
+
+	if (state_high)
+		clock_bits = GPIO_CLOCK_DIR_IN | GPIO_CLOCK_DIR_MASK;
+	else
+		clock_bits = GPIO_CLOCK_DIR_OUT | GPIO_CLOCK_DIR_MASK |
+			GPIO_CLOCK_VAL_MASK;
+	I915_WRITE(chan->reg, reserved | clock_bits);
+	udelay(I2C_RISEFALL_TIME); /* wait for the line to change state */
+}
+
+static void set_data(void *data, int state_high)
+{
+	struct intel_i2c_chan *chan = data;
+	drm_device_t *dev = chan->drm_dev;
+	drm_i915_private_t *dev_priv = chan->drm_dev->dev_private;
+	u32 reserved = 0, data_bits;
+
+	/* On most chips, these bits must be preserved in software. */
+	if (!IS_I830(dev) && !IS_845G(dev))
+		reserved = I915_READ(chan->reg) & (GPIO_DATA_PULLUP_DISABLE |
+						   GPIO_CLOCK_PULLUP_DISABLE);
+
+	if (state_high)
+		data_bits = GPIO_DATA_DIR_IN | GPIO_DATA_DIR_MASK;
+	else
+		data_bits = GPIO_DATA_DIR_OUT | GPIO_DATA_DIR_MASK |
+			GPIO_DATA_VAL_MASK;
+
+	I915_WRITE(chan->reg, reserved | data_bits);
+	udelay(I2C_RISEFALL_TIME); /* wait for the line to change state */
+}
+
+/**
+ * intel_i2c_create - instantiate an Intel i2c bus using the specified GPIO reg
+ * @dev: DRM device
+ * @output: driver specific output device
+ * @reg: GPIO reg to use
+ * @name: name for this bus
+ *
+ * Creates and registers a new i2c bus with the Linux i2c layer, for use
+ * in output probing and control (e.g. DDC or SDVO control functions).
+ *
+ * Possible values for @reg include:
+ *   %GPIOA
+ *   %GPIOB
+ *   %GPIOC
+ *   %GPIOD
+ *   %GPIOE
+ *   %GPIOF
+ *   %GPIOG
+ *   %GPIOH
+ * see PRM for details on how these different busses are used.
+ */
+struct intel_i2c_chan *intel_i2c_create(drm_device_t *dev, const u32 reg,
+					const char *name)
+{
+	struct intel_i2c_chan *chan;
+
+	chan = kzalloc(sizeof(struct intel_i2c_chan), GFP_KERNEL);
+	if (!chan)
+		goto out_free;
+
+	chan->drm_dev = dev;
+	chan->reg = reg;
+	snprintf(chan->adapter.name, I2C_NAME_SIZE, "intel drm %s", name);
+	chan->adapter.owner = THIS_MODULE;
+	chan->adapter.id = I2C_HW_B_INTELFB;
+	chan->adapter.algo_data	= &chan->algo;
+	chan->adapter.dev.parent = &dev->pdev->dev;
+	chan->algo.setsda = set_data;
+	chan->algo.setscl = set_clock;
+	chan->algo.getsda = get_data;
+	chan->algo.getscl = get_clock;
+	chan->algo.udelay = 20;
+	chan->algo.timeout = usecs_to_jiffies(2200);
+	chan->algo.data = chan;
+
+	i2c_set_adapdata(&chan->adapter, chan);
+
+	if(i2c_bit_add_bus(&chan->adapter))
+		goto out_free;
+
+	/* JJJ:  raise SCL and SDA? */
+	set_data(chan, 1);
+	set_clock(chan, 1);
+	udelay(20);
+
+	return chan;
+
+out_free:
+	kfree(chan);
+	return NULL;
+}
+
+/**
+ * intel_i2c_destroy - unregister and free i2c bus resources
+ * @output: channel to free
+ *
+ * Unregister the adapter from the i2c layer, then free the structure.
+ */
+void intel_i2c_destroy(struct intel_i2c_chan *chan)
+{
+	if (!chan)
+		return;
+
+	i2c_del_adapter(&chan->adapter);
+	kfree(chan);
+}
+
+	
+	
diff --git a/linux-core/intel_lvds.c b/linux-core/intel_lvds.c
new file mode 100644
index 0000000..74b040b
--- /dev/null
+++ b/linux-core/intel_lvds.c
@@ -0,0 +1,500 @@
+/*
+ * Copyright © 2006-2007 Intel Corporation
+ * Copyright (c) 2006 Dave Airlie <airlied@linux.ie>
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
+ * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ *
+ * Authors:
+ *	Eric Anholt <eric@anholt.net>
+ *      Dave Airlie <airlied@linux.ie>
+ *      Jesse Barnes <jesse.barnes@intel.com>
+ */
+
+#include <linux/i2c.h>
+#include "drmP.h"
+#include "drm.h"
+#include "drm_crtc.h"
+#include "drm_edid.h"
+#include "intel_drv.h"
+#include "i915_drm.h"
+#include "i915_drv.h"
+
+/**
+ * Sets the backlight level.
+ *
+ * \param level backlight level, from 0 to intel_lvds_get_max_backlight().
+ */
+static void intel_lvds_set_backlight(struct drm_device *dev, int level)
+{
+	drm_i915_private_t *dev_priv = dev->dev_private;
+	u32 blc_pwm_ctl;
+
+	blc_pwm_ctl = I915_READ(BLC_PWM_CTL) & ~BACKLIGHT_DUTY_CYCLE_MASK;
+	I915_WRITE(BLC_PWM_CTL, (blc_pwm_ctl |
+				 (level << BACKLIGHT_DUTY_CYCLE_SHIFT)));
+}
+
+/**
+ * Returns the maximum level of the backlight duty cycle field.
+ */
+static u32 intel_lvds_get_max_backlight(struct drm_device *dev)
+{
+	drm_i915_private_t *dev_priv = dev->dev_private;
+    
+	return ((I915_READ(BLC_PWM_CTL) & BACKLIGHT_MODULATION_FREQ_MASK) >>
+		BACKLIGHT_MODULATION_FREQ_SHIFT) * 2;
+}
+
+/**
+ * Sets the power state for the panel.
+ */
+static void intel_lvds_set_power(struct drm_device *dev, bool on)
+{
+	drm_i915_private_t *dev_priv = dev->dev_private;
+	u32 pp_status;
+
+	if (on) {
+		I915_WRITE(PP_CONTROL, I915_READ(PP_CONTROL) |
+			   POWER_TARGET_ON);
+		do {
+			pp_status = I915_READ(PP_STATUS);
+		} while ((pp_status & PP_ON) == 0);
+
+		intel_lvds_set_backlight(dev, dev_priv->backlight_duty_cycle);
+	} else {
+		intel_lvds_set_backlight(dev, 0);
+
+		I915_WRITE(PP_CONTROL, I915_READ(PP_CONTROL) &
+			   ~POWER_TARGET_ON);
+		do {
+			pp_status = I915_READ(PP_STATUS);
+		} while (pp_status & PP_ON);
+	}
+}
+
+static void intel_lvds_dpms(struct drm_output *output, int mode)
+{
+	struct drm_device *dev = output->dev;
+
+	if (mode == DPMSModeOn)
+		intel_lvds_set_power(dev, true);
+	else
+		intel_lvds_set_power(dev, false);
+
+	/* XXX: We never power down the LVDS pairs. */
+}
+
+static void intel_lvds_save(struct drm_output *output)
+{
+	struct drm_device *dev = output->dev;
+	drm_i915_private_t *dev_priv = dev->dev_private;
+
+	dev_priv->savePP_ON = I915_READ(LVDSPP_ON);
+	dev_priv->savePP_OFF = I915_READ(LVDSPP_OFF);
+	dev_priv->savePP_CONTROL = I915_READ(PP_CONTROL);
+	dev_priv->savePP_CYCLE = I915_READ(PP_CYCLE);
+	dev_priv->saveBLC_PWM_CTL = I915_READ(BLC_PWM_CTL);
+	dev_priv->backlight_duty_cycle = (dev_priv->saveBLC_PWM_CTL &
+				       BACKLIGHT_DUTY_CYCLE_MASK);
+
+	/*
+	 * If the light is off at server startup, just make it full brightness
+	 */
+	if (dev_priv->backlight_duty_cycle == 0)
+		dev_priv->backlight_duty_cycle =
+			intel_lvds_get_max_backlight(dev);
+}
+
+static void intel_lvds_restore(struct drm_output *output)
+{
+	struct drm_device *dev = output->dev;
+	drm_i915_private_t *dev_priv = dev->dev_private;
+
+	I915_WRITE(BLC_PWM_CTL, dev_priv->saveBLC_PWM_CTL);
+	I915_WRITE(LVDSPP_ON, dev_priv->savePP_ON);
+	I915_WRITE(LVDSPP_OFF, dev_priv->savePP_OFF);
+	I915_WRITE(PP_CYCLE, dev_priv->savePP_CYCLE);
+	I915_WRITE(PP_CONTROL, dev_priv->savePP_CONTROL);
+	if (dev_priv->savePP_CONTROL & POWER_TARGET_ON)
+		intel_lvds_set_power(dev, true);
+	else
+		intel_lvds_set_power(dev, false);
+}
+
+static int intel_lvds_mode_valid(struct drm_output *output,
+				 struct drm_display_mode *mode)
+{
+	struct drm_device *dev = output->dev;
+	drm_i915_private_t *dev_priv = dev->dev_private;
+	struct drm_display_mode *fixed_mode = dev_priv->panel_fixed_mode;
+
+	if (fixed_mode)	{
+		if (mode->hdisplay > fixed_mode->hdisplay)
+			return MODE_PANEL;
+		if (mode->vdisplay > fixed_mode->vdisplay)
+			return MODE_PANEL;
+	}
+
+	return MODE_OK;
+}
+
+static bool intel_lvds_mode_fixup(struct drm_output *output,
+				  struct drm_display_mode *mode,
+				  struct drm_display_mode *adjusted_mode)
+{
+	struct drm_device *dev = output->dev;
+	drm_i915_private_t *dev_priv = dev->dev_private;
+	struct intel_crtc *intel_crtc = output->crtc->driver_private;
+	struct drm_output *tmp_output;
+
+	list_for_each_entry(tmp_output, &dev->mode_config.output_list, head) {
+		if (tmp_output != output && tmp_output->crtc == output->crtc) {
+			printk(KERN_ERR "Can't enable LVDS and another "
+			       "output on the same pipe\n");
+			return false;
+		}
+	}
+
+	if (intel_crtc->pipe == 0) {
+		printk(KERN_ERR "Can't support LVDS on pipe A\n");
+		return false;
+	}
+
+	/*
+	 * If we have timings from the BIOS for the panel, put them in
+	 * to the adjusted mode.  The CRTC will be set up for this mode,
+	 * with the panel scaling set up to source from the H/VDisplay
+	 * of the original mode.
+	 */
+	if (dev_priv->panel_fixed_mode != NULL) {
+		adjusted_mode->hdisplay = dev_priv->panel_fixed_mode->hdisplay;
+		adjusted_mode->hsync_start =
+			dev_priv->panel_fixed_mode->hsync_start;
+		adjusted_mode->hsync_end =
+			dev_priv->panel_fixed_mode->hsync_end;
+		adjusted_mode->htotal = dev_priv->panel_fixed_mode->htotal;
+		adjusted_mode->vdisplay = dev_priv->panel_fixed_mode->vdisplay;
+		adjusted_mode->vsync_start =
+			dev_priv->panel_fixed_mode->vsync_start;
+		adjusted_mode->vsync_end =
+			dev_priv->panel_fixed_mode->vsync_end;
+		adjusted_mode->vtotal = dev_priv->panel_fixed_mode->vtotal;
+		adjusted_mode->clock = dev_priv->panel_fixed_mode->clock;
+		drm_mode_set_crtcinfo(adjusted_mode, CRTC_INTERLACE_HALVE_V);
+	}
+
+	/*
+	 * XXX: It would be nice to support lower refresh rates on the
+	 * panels to reduce power consumption, and perhaps match the
+	 * user's requested refresh rate.
+	 */
+
+	return true;
+}
+
+static void intel_lvds_prepare(struct drm_output *output)
+{
+	struct drm_device *dev = output->dev;
+	drm_i915_private_t *dev_priv = dev->dev_private;
+
+	dev_priv->saveBLC_PWM_CTL = I915_READ(BLC_PWM_CTL);
+	dev_priv->backlight_duty_cycle = (dev_priv->saveBLC_PWM_CTL &
+				       BACKLIGHT_DUTY_CYCLE_MASK);
+
+	intel_lvds_set_power(dev, false);
+}
+
+static void intel_lvds_commit( struct drm_output *output)
+{
+	struct drm_device *dev = output->dev;
+	drm_i915_private_t *dev_priv = dev->dev_private;
+
+	if (dev_priv->backlight_duty_cycle == 0)
+		dev_priv->backlight_duty_cycle =
+			intel_lvds_get_max_backlight(dev);
+
+	intel_lvds_set_power(dev, true);
+}
+
+static void intel_lvds_mode_set(struct drm_output *output,
+				struct drm_display_mode *mode,
+				struct drm_display_mode *adjusted_mode)
+{
+	struct drm_device *dev = output->dev;
+	drm_i915_private_t *dev_priv = dev->dev_private;
+	struct intel_crtc *intel_crtc = output->crtc->driver_private;
+	u32 pfit_control;
+
+	/*
+	 * The LVDS pin pair will already have been turned on in the
+	 * intel_crtc_mode_set since it has a large impact on the DPLL
+	 * settings.
+	 */
+
+	/*
+	 * Enable automatic panel scaling so that non-native modes fill the
+	 * screen.  Should be enabled before the pipe is enabled, according to
+	 * register description and PRM.
+	 */
+	pfit_control = (PFIT_ENABLE | VERT_AUTO_SCALE | HORIZ_AUTO_SCALE |
+			VERT_INTERP_BILINEAR | HORIZ_INTERP_BILINEAR);
+
+	if (!IS_I965G(dev)) {
+		if (dev_priv->panel_wants_dither)
+			pfit_control |= PANEL_8TO6_DITHER_ENABLE;
+	}
+	else
+		pfit_control |= intel_crtc->pipe << PFIT_PIPE_SHIFT;
+
+	I915_WRITE(PFIT_CONTROL, pfit_control);
+}
+
+/**
+ * Detect the LVDS connection.
+ *
+ * This always returns OUTPUT_STATUS_CONNECTED.  This output should only have
+ * been set up if the LVDS was actually connected anyway.
+ */
+static enum drm_output_status intel_lvds_detect(struct drm_output *output)
+{
+	return output_status_connected;
+}
+
+/**
+ * Return the list of DDC modes if available, or the BIOS fixed mode otherwise.
+ */
+static int intel_lvds_get_modes(struct drm_output *output)
+{
+	struct drm_device *dev = output->dev;
+	drm_i915_private_t *dev_priv = dev->dev_private;
+	int ret = 0;
+
+	ret = intel_ddc_get_modes(output);
+
+	if (ret)
+		return ret;
+
+	/* Didn't get an EDID */
+	if (!output->monitor_info) {
+		struct drm_display_info *dspinfo;
+		dspinfo = kzalloc(sizeof(*output->monitor_info), GFP_KERNEL);
+		if (!dspinfo)
+			goto out;
+
+		/* Set wide sync ranges so we get all modes
+		 * handed to valid_mode for checking
+		 */
+		dspinfo->min_vfreq = 0;
+		dspinfo->max_vfreq = 200;
+		dspinfo->min_hfreq = 0;
+		dspinfo->max_hfreq = 200;
+		output->monitor_info = dspinfo;
+	}
+
+out:
+	if (dev_priv->panel_fixed_mode != NULL) {
+		struct drm_display_mode *mode =
+			drm_mode_duplicate(dev, dev_priv->panel_fixed_mode);
+		drm_mode_probed_add(output, mode);
+		return 1;
+	}
+
+	return 0;
+}
+
+/**
+ * intel_lvds_destroy - unregister and free LVDS structures
+ * @output: output to free
+ *
+ * Unregister the DDC bus for this output then free the driver private
+ * structure.
+ */
+static void intel_lvds_destroy(struct drm_output *output)
+{
+	struct intel_output *intel_output = output->driver_private;
+
+	intel_i2c_destroy(intel_output->ddc_bus);
+	kfree(output->driver_private);
+}
+
+static const struct drm_output_funcs intel_lvds_output_funcs = {
+	.dpms = intel_lvds_dpms,
+	.save = intel_lvds_save,
+	.restore = intel_lvds_restore,
+	.mode_valid = intel_lvds_mode_valid,
+	.mode_fixup = intel_lvds_mode_fixup,
+	.prepare = intel_lvds_prepare,
+	.mode_set = intel_lvds_mode_set,
+	.commit = intel_lvds_commit,
+	.detect = intel_lvds_detect,
+	.get_modes = intel_lvds_get_modes,
+	.cleanup = intel_lvds_destroy
+};
+
+/**
+ * intel_lvds_init - setup LVDS outputs on this device
+ * @dev: drm device
+ *
+ * Create the output, register the LVDS DDC bus, and try to figure out what
+ * modes we can display on the LVDS panel (if present).
+ */
+void intel_lvds_init(struct drm_device *dev)
+{
+	drm_i915_private_t *dev_priv = dev->dev_private;
+	struct drm_output *output;
+	struct intel_output *intel_output;
+	struct drm_display_mode *scan; /* *modes, *bios_mode; */
+	struct drm_crtc *crtc;
+	u32 lvds;
+	int pipe;
+
+	output = drm_output_create(dev, &intel_lvds_output_funcs, "LVDS");
+	if (!output)
+		return;
+
+	intel_output = kmalloc(sizeof(struct intel_output), GFP_KERNEL);
+	if (!intel_output) {
+		drm_output_destroy(output);
+		return;
+	}
+
+	intel_output->type = INTEL_OUTPUT_LVDS;
+	output->driver_private = intel_output;
+	output->subpixel_order = SubPixelHorizontalRGB;
+	output->interlace_allowed = FALSE;
+	output->doublescan_allowed = FALSE;
+
+	/* Set up the DDC bus. */
+	intel_output->ddc_bus = intel_i2c_create(dev, GPIOC, "LVDSDDC_C");
+	if (!intel_output->ddc_bus) {
+		dev_printk(KERN_ERR, &dev->pdev->dev, "DDC bus registration "
+			   "failed.\n");
+		return;
+	}
+
+	/*
+	 * Attempt to get the fixed panel mode from DDC.  Assume that the
+	 * preferred mode is the right one.
+	 */
+	intel_ddc_get_modes(output);
+
+	list_for_each_entry(scan, &output->probed_modes, head) {
+		if (scan->type & DRM_MODE_TYPE_PREFERRED) {
+			dev_priv->panel_fixed_mode = 
+				drm_mode_duplicate(dev, scan);
+			goto out; /* FIXME: check for quirks */
+		}
+	}
+
+	/*
+	 * If we didn't get EDID, try checking if the panel is already turned
+	 * on.  If so, assume that whatever is currently programmed is the
+	 * correct mode.
+	 */
+	lvds = I915_READ(LVDS);
+	pipe = (lvds & LVDS_PIPEB_SELECT) ? 1 : 0;
+	crtc = intel_get_crtc_from_pipe(dev, pipe);
+		
+	if (crtc && (lvds & LVDS_PORT_EN)) {
+		dev_priv->panel_fixed_mode = intel_crtc_mode_get(dev, crtc);
+		if (dev_priv->panel_fixed_mode) {
+			dev_priv->panel_fixed_mode->type |=
+				DRM_MODE_TYPE_PREFERRED;
+			goto out; /* FIXME: check for quirks */
+		}
+	}
+
+	/* If we still don't have a mode after all that, give up. */
+	if (!dev_priv->panel_fixed_mode)
+		goto failed;
+
+	/* FIXME: probe the BIOS for modes and check for LVDS quirks */
+#if 0
+	/* Get the LVDS fixed mode out of the BIOS.  We should support LVDS
+	 * with the BIOS being unavailable or broken, but lack the
+	 * configuration options for now.
+	 */
+	bios_mode = intel_bios_get_panel_mode(pScrn);
+	if (bios_mode != NULL) {
+		if (dev_priv->panel_fixed_mode != NULL) {
+			if (dev_priv->debug_modes &&
+			    !xf86ModesEqual(dev_priv->panel_fixed_mode,
+					    bios_mode))
+			{
+				xf86DrvMsg(pScrn->scrnIndex, X_WARNING,
+					   "BIOS panel mode data doesn't match probed data, "
+					   "continuing with probed.\n");
+				xf86DrvMsg(pScrn->scrnIndex, X_INFO, "BIOS mode:\n");
+				xf86PrintModeline(pScrn->scrnIndex, bios_mode);
+				xf86DrvMsg(pScrn->scrnIndex, X_INFO, "probed mode:\n");
+				xf86PrintModeline(pScrn->scrnIndex, dev_priv->panel_fixed_mode);
+				xfree(bios_mode->name);
+				xfree(bios_mode);
+			}
+		}  else {
+			dev_priv->panel_fixed_mode = bios_mode;
+		}
+	} else {
+		xf86DrvMsg(pScrn->scrnIndex, X_WARNING,
+			   "Couldn't detect panel mode.  Disabling panel\n");
+		goto disable_exit;
+	}
+
+	/*
+	 * Blacklist machines with BIOSes that list an LVDS panel without
+	 * actually having one.
+	 */
+	if (dev_priv->PciInfo->chipType == PCI_CHIP_I945_GM) {
+		/* aopen mini pc */
+		if (dev_priv->PciInfo->subsysVendor == 0xa0a0)
+			goto disable_exit;
+
+		if ((dev_priv->PciInfo->subsysVendor == 0x8086) &&
+		    (dev_priv->PciInfo->subsysCard == 0x7270)) {
+			/* It's a Mac Mini or Macbook Pro.
+			 *
+			 * Apple hardware is out to get us.  The macbook pro
+			 * has a real LVDS panel, but the mac mini does not,
+			 * and they have the same device IDs.  We'll
+			 * distinguish by panel size, on the assumption
+			 * that Apple isn't about to make any machines with an
+			 * 800x600 display.
+			 */
+
+			if (dev_priv->panel_fixed_mode != NULL &&
+			    dev_priv->panel_fixed_mode->HDisplay == 800 &&
+			    dev_priv->panel_fixed_mode->VDisplay == 600)
+			{
+				xf86DrvMsg(pScrn->scrnIndex, X_INFO,
+					   "Suspected Mac Mini, ignoring the LVDS\n");
+				goto disable_exit;
+			}
+		}
+	}
+
+#endif
+
+out:
+	return;
+
+failed:
+        DRM_DEBUG("No LVDS modes found, disabling.\n");
+	drm_output_destroy(output); /* calls intel_lvds_destroy above */
+}
diff --git a/linux-core/intel_modes.c b/linux-core/intel_modes.c
new file mode 100644
index 0000000..601770e
--- /dev/null
+++ b/linux-core/intel_modes.c
@@ -0,0 +1,55 @@
+/*
+ * Copyright (c) 2007 Dave Airlie <airlied@linux.ie>
+ * Copyright (c) 2007 Intel Corporation
+ *   Jesse Barnes <jesse.barnes@intel.com>
+ */
+
+#include <linux/i2c.h>
+#include <linux/fb.h>
+#include "drmP.h"
+#include "intel_drv.h"
+
+/**
+ * intel_ddc_probe
+ *
+ */
+bool intel_ddc_probe(struct drm_output *output)
+{
+	struct intel_output *intel_output = output->driver_private;
+	u8 out_buf[] = { 0x0, 0x0};
+	u8 buf[2];
+	int ret;
+	struct i2c_msg msgs[] = {
+		{
+			.addr = 0x50,
+			.flags = 0,
+			.len = 1,
+			.buf = out_buf,
+		},
+		{
+			.addr = 0x50,
+			.flags = I2C_M_RD,
+			.len = 1,
+			.buf = buf,
+		}
+	};
+
+	ret = i2c_transfer(&intel_output->ddc_bus->adapter, msgs, 2);
+	if (ret == 2)
+		return true;
+
+	return false;
+}
+
+/**
+ * intel_ddc_get_modes - get modelist from monitor
+ * @output: DRM output device to use
+ *
+ * Fetch the EDID information from @output using the DDC bus.
+ */
+int intel_ddc_get_modes(struct drm_output *output)
+{
+	struct intel_output *intel_output = output->driver_private;
+
+	return drm_add_edid_modes(output, &intel_output->ddc_bus->adapter);
+}
diff --git a/linux-core/intel_sdvo.c b/linux-core/intel_sdvo.c
new file mode 100644
index 0000000..98c4034
--- /dev/null
+++ b/linux-core/intel_sdvo.c
@@ -0,0 +1,1095 @@
+/*
+ * Copyright © 2006-2007 Intel Corporation
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
+ * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ *
+ * Authors:
+ *	Eric Anholt <eric@anholt.net>
+ */
+/*
+ * Copyright 2006 Dave Airlie <airlied@linux.ie>
+ *   Jesse Barnes <jesse.barnes@intel.com>
+ */
+
+#include <linux/i2c.h>
+#include <linux/delay.h>
+#include "drmP.h"
+#include "drm.h"
+#include "drm_crtc.h"
+#include "intel_drv.h"
+#include "i915_drm.h"
+#include "i915_drv.h"
+#include "intel_sdvo_regs.h"
+
+struct intel_sdvo_priv {
+	struct intel_i2c_chan *i2c_bus;
+	int slaveaddr;
+	int output_device;
+
+	u16 active_outputs;
+
+	struct intel_sdvo_caps caps;
+	int pixel_clock_min, pixel_clock_max;
+
+	int save_sdvo_mult;
+	u16 save_active_outputs;
+	struct intel_sdvo_dtd save_input_dtd_1, save_input_dtd_2;
+	struct intel_sdvo_dtd save_output_dtd[16];
+	u32 save_SDVOX;
+};
+
+/**
+ * Writes the SDVOB or SDVOC with the given value, but always writes both
+ * SDVOB and SDVOC to work around apparent hardware issues (according to
+ * comments in the BIOS).
+ */
+static void intel_sdvo_write_sdvox(struct drm_output *output, u32 val)
+{
+	drm_device_t *dev = output->dev;
+	drm_i915_private_t *dev_priv = dev->dev_private;
+	struct intel_output *intel_output = output->driver_private;
+	struct intel_sdvo_priv   *sdvo_priv = intel_output->dev_priv;
+	u32 bval = val, cval = val;
+	int i;
+
+	if (sdvo_priv->output_device == SDVOB)
+		cval = I915_READ(SDVOC);
+	else
+		bval = I915_READ(SDVOB);
+	/*
+	 * Write the registers twice for luck. Sometimes,
+	 * writing them only once doesn't appear to 'stick'.
+	 * The BIOS does this too. Yay, magic
+	 */
+	for (i = 0; i < 2; i++)
+	{
+		I915_WRITE(SDVOB, bval);
+		I915_READ(SDVOB);
+		I915_WRITE(SDVOC, cval);
+		I915_READ(SDVOC);
+	}
+}
+
+static bool intel_sdvo_read_byte(struct drm_output *output, u8 addr,
+				 u8 *ch)
+{
+	struct intel_output *intel_output = output->driver_private;
+	struct intel_sdvo_priv *sdvo_priv = intel_output->dev_priv;
+	u8 out_buf[2];
+	u8 buf[2];
+	int ret;
+
+	struct i2c_msg msgs[] = {
+		{ 
+			.addr = sdvo_priv->i2c_bus->slave_addr,
+			.flags = 0,
+			.len = 1,
+			.buf = out_buf,
+		}, 
+		{
+			.addr = sdvo_priv->i2c_bus->slave_addr,
+			.flags = I2C_M_RD,
+			.len = 1,
+			.buf = buf,
+		}
+	};
+
+	out_buf[0] = addr;
+	out_buf[1] = 0;
+
+	if ((ret = i2c_transfer(&sdvo_priv->i2c_bus->adapter, msgs, 2)) == 2)
+	{
+//		DRM_DEBUG("got back from addr %02X = %02x\n", out_buf[0], buf[0]); 
+		*ch = buf[0];
+		return true;
+	}
+
+	DRM_DEBUG("i2c transfer returned %d\n", ret);
+	return false;
+}
+
+
+static bool intel_sdvo_read_byte_quiet(struct drm_output *output, int addr,
+				       u8 *ch)
+{
+	return true;
+
+}
+
+static bool intel_sdvo_write_byte(struct drm_output *output, int addr,
+				  u8 ch)
+{
+	struct intel_output *intel_output = output->driver_private;
+	u8 out_buf[2];
+	struct i2c_msg msgs[] = {
+		{ 
+			.addr = intel_output->i2c_bus->slave_addr,
+			.flags = 0,
+			.len = 2,
+			.buf = out_buf,
+		}
+	};
+
+	out_buf[0] = addr;
+	out_buf[1] = ch;
+
+	if (i2c_transfer(&intel_output->i2c_bus->adapter, msgs, 1) == 1)
+	{
+		return true;
+	}
+	return false;
+}
+
+#define SDVO_CMD_NAME_ENTRY(cmd) {cmd, #cmd}
+/** Mapping of command numbers to names, for debug output */
+const static struct _sdvo_cmd_name {
+    u8 cmd;
+    char *name;
+} sdvo_cmd_names[] = {
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_RESET),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_DEVICE_CAPS),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_FIRMWARE_REV),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_TRAINED_INPUTS),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_ACTIVE_OUTPUTS),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_ACTIVE_OUTPUTS),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_IN_OUT_MAP),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_IN_OUT_MAP),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_ATTACHED_DISPLAYS),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_HOT_PLUG_SUPPORT),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_ACTIVE_HOT_PLUG),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_ACTIVE_HOT_PLUG),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_INTERRUPT_EVENT_SOURCE),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_TARGET_INPUT),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_TARGET_OUTPUT),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_INPUT_TIMINGS_PART1),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_INPUT_TIMINGS_PART2),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_INPUT_TIMINGS_PART1),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_INPUT_TIMINGS_PART2),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_INPUT_TIMINGS_PART1),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_OUTPUT_TIMINGS_PART1),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_OUTPUT_TIMINGS_PART2),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_OUTPUT_TIMINGS_PART1),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_OUTPUT_TIMINGS_PART2),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_CREATE_PREFERRED_INPUT_TIMING),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_PREFERRED_INPUT_TIMING_PART1),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_PREFERRED_INPUT_TIMING_PART2),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_INPUT_PIXEL_CLOCK_RANGE),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_OUTPUT_PIXEL_CLOCK_RANGE),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_SUPPORTED_CLOCK_RATE_MULTS),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_CLOCK_RATE_MULT),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_CLOCK_RATE_MULT),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_SUPPORTED_TV_FORMATS),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_TV_FORMAT),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_TV_FORMAT),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_TV_RESOLUTION_SUPPORT),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_CONTROL_BUS_SWITCH),
+};
+
+#define SDVO_NAME(dev_priv) ((dev_priv)->output_device == SDVOB ? "SDVOB" : "SDVOC")
+#define SDVO_PRIV(output)   ((struct intel_sdvo_priv *) (output)->dev_priv)
+
+static void intel_sdvo_write_cmd(struct drm_output *output, u8 cmd,
+				 void *args, int args_len)
+{
+	struct intel_output *intel_output = output->driver_private;
+	struct intel_sdvo_priv *sdvo_priv = intel_output->dev_priv;
+	int i;
+
+        if (1) {
+                printk("%s: W: %02X ", SDVO_NAME(sdvo_priv), cmd);
+                for (i = 0; i < args_len; i++)
+                        printk("%02X ", ((u8 *)args)[i]);
+                for (; i < 8; i++)
+                        printk("   ");
+                for (i = 0; i < sizeof(sdvo_cmd_names) / sizeof(sdvo_cmd_names[0]); i++) {
+                        if (cmd == sdvo_cmd_names[i].cmd) {
+                                printk("(%s)", sdvo_cmd_names[i].name);
+                                break;
+                        }
+                }
+                if (i == sizeof(sdvo_cmd_names)/ sizeof(sdvo_cmd_names[0]))
+                        printk("(%02X)",cmd);
+                printk("\n");
+        }
+                        
+	for (i = 0; i < args_len; i++) {
+		intel_sdvo_write_byte(output, SDVO_I2C_ARG_0 - i, ((u8*)args)[i]);
+	}
+
+	intel_sdvo_write_byte(output, SDVO_I2C_OPCODE, cmd);
+}
+
+static const char *cmd_status_names[] = {
+	"Power on",
+	"Success",
+	"Not supported",
+	"Invalid arg",
+	"Pending",
+	"Target not specified",
+	"Scaling not supported"
+};
+
+static u8 intel_sdvo_read_response(struct drm_output *output, void *response,
+				   int response_len)
+{
+	struct intel_output *intel_output = output->driver_private;
+	struct intel_sdvo_priv *sdvo_priv = intel_output->dev_priv;
+	int i;
+	u8 status;
+	u8 retry = 50;
+
+	while (retry--) {
+		/* Read the command response */
+		for (i = 0; i < response_len; i++) {
+			intel_sdvo_read_byte(output, SDVO_I2C_RETURN_0 + i,
+				     &((u8 *)response)[i]);
+		}
+
+		/* read the return status */
+		intel_sdvo_read_byte(output, SDVO_I2C_CMD_STATUS, &status);
+
+	        if (1) {
+			printk("%s: R: ", SDVO_NAME(sdvo_priv));
+       			for (i = 0; i < response_len; i++)
+                        	printk("%02X ", ((u8 *)response)[i]);
+                	for (; i < 8; i++)
+                        	printk("   ");
+                	if (status <= SDVO_CMD_STATUS_SCALING_NOT_SUPP)
+                        	printk("(%s)", cmd_status_names[status]);
+                	else
+                        	printk("(??? %d)", status);
+                	printk("\n");
+        	}
+
+		if (status != SDVO_CMD_STATUS_PENDING)
+			return status;
+
+		mdelay(50);
+	}
+
+	return status;
+}
+
+int intel_sdvo_get_pixel_multiplier(struct drm_display_mode *mode)
+{
+	if (mode->clock >= 100000)
+		return 1;
+	else if (mode->clock >= 50000)
+		return 2;
+	else
+		return 4;
+}
+
+/**
+ * Don't check status code from this as it switches the bus back to the
+ * SDVO chips which defeats the purpose of doing a bus switch in the first
+ * place.
+ */
+void intel_sdvo_set_control_bus_switch(struct drm_output *output, u8 target)
+{
+	intel_sdvo_write_cmd(output, SDVO_CMD_SET_CONTROL_BUS_SWITCH, &target, 1);
+}
+
+static bool intel_sdvo_set_target_input(struct drm_output *output, bool target_0, bool target_1)
+{
+	struct intel_sdvo_set_target_input_args targets = {0};
+	u8 status;
+
+	if (target_0 && target_1)
+		return SDVO_CMD_STATUS_NOTSUPP;
+
+	if (target_1)
+		targets.target_1 = 1;
+
+	intel_sdvo_write_cmd(output, SDVO_CMD_SET_TARGET_INPUT, &targets,
+			     sizeof(targets));
+
+	status = intel_sdvo_read_response(output, NULL, 0);
+
+	return (status == SDVO_CMD_STATUS_SUCCESS);
+}
+
+/**
+ * Return whether each input is trained.
+ *
+ * This function is making an assumption about the layout of the response,
+ * which should be checked against the docs.
+ */
+static bool intel_sdvo_get_trained_inputs(struct drm_output *output, bool *input_1, bool *input_2)
+{
+	struct intel_sdvo_get_trained_inputs_response response;
+	u8 status;
+
+	intel_sdvo_write_cmd(output, SDVO_CMD_GET_TRAINED_INPUTS, NULL, 0);
+	status = intel_sdvo_read_response(output, &response, sizeof(response));
+	if (status != SDVO_CMD_STATUS_SUCCESS)
+		return false;
+
+	*input_1 = response.input0_trained;
+	*input_2 = response.input1_trained;
+	return true;
+}
+
+static bool intel_sdvo_get_active_outputs(struct drm_output *output,
+					  u16 *outputs)
+{
+	u8 status;
+
+	intel_sdvo_write_cmd(output, SDVO_CMD_GET_ACTIVE_OUTPUTS, NULL, 0);
+	status = intel_sdvo_read_response(output, outputs, sizeof(*outputs));
+
+	return (status == SDVO_CMD_STATUS_SUCCESS);
+}
+
+static bool intel_sdvo_set_active_outputs(struct drm_output *output,
+					  u16 outputs)
+{
+	u8 status;
+
+	intel_sdvo_write_cmd(output, SDVO_CMD_SET_ACTIVE_OUTPUTS, &outputs,
+			     sizeof(outputs));
+	status = intel_sdvo_read_response(output, NULL, 0);
+	return (status == SDVO_CMD_STATUS_SUCCESS);
+}
+
+static bool intel_sdvo_set_encoder_power_state(struct drm_output *output,
+					       int mode)
+{
+	u8 status, state = SDVO_ENCODER_STATE_ON;
+
+	switch (mode) {
+	case DPMSModeOn:
+		state = SDVO_ENCODER_STATE_ON;
+		break;
+	case DPMSModeStandby:
+		state = SDVO_ENCODER_STATE_STANDBY;
+		break;
+	case DPMSModeSuspend:
+		state = SDVO_ENCODER_STATE_SUSPEND;
+		break;
+	case DPMSModeOff:
+		state = SDVO_ENCODER_STATE_OFF;
+		break;
+	}
+	
+	intel_sdvo_write_cmd(output, SDVO_CMD_SET_ENCODER_POWER_STATE, &state,
+			     sizeof(state));
+	status = intel_sdvo_read_response(output, NULL, 0);
+
+	return (status == SDVO_CMD_STATUS_SUCCESS);
+}
+
+static bool intel_sdvo_get_input_pixel_clock_range(struct drm_output *output,
+						   int *clock_min,
+						   int *clock_max)
+{
+	struct intel_sdvo_pixel_clock_range clocks;
+	u8 status;
+
+	intel_sdvo_write_cmd(output, SDVO_CMD_GET_INPUT_PIXEL_CLOCK_RANGE,
+			     NULL, 0);
+
+	status = intel_sdvo_read_response(output, &clocks, sizeof(clocks));
+
+	if (status != SDVO_CMD_STATUS_SUCCESS)
+		return false;
+
+	/* Convert the values from units of 10 kHz to kHz. */
+	*clock_min = clocks.min * 10;
+	*clock_max = clocks.max * 10;
+
+	return true;
+}
+
+static bool intel_sdvo_set_target_output(struct drm_output *output,
+					 u16 outputs)
+{
+	u8 status;
+
+	intel_sdvo_write_cmd(output, SDVO_CMD_SET_TARGET_OUTPUT, &outputs,
+			     sizeof(outputs));
+
+	status = intel_sdvo_read_response(output, NULL, 0);
+	return (status == SDVO_CMD_STATUS_SUCCESS);
+}
+
+static bool intel_sdvo_get_timing(struct drm_output *output, u8 cmd,
+				  struct intel_sdvo_dtd *dtd)
+{
+	u8 status;
+
+	intel_sdvo_write_cmd(output, cmd, NULL, 0);
+	status = intel_sdvo_read_response(output, &dtd->part1,
+					  sizeof(dtd->part1));
+	if (status != SDVO_CMD_STATUS_SUCCESS)
+		return false;
+
+	intel_sdvo_write_cmd(output, cmd + 1, NULL, 0);
+	status = intel_sdvo_read_response(output, &dtd->part2,
+					  sizeof(dtd->part2));
+	if (status != SDVO_CMD_STATUS_SUCCESS)
+		return false;
+
+	return true;
+}
+
+static bool intel_sdvo_get_input_timing(struct drm_output *output,
+					 struct intel_sdvo_dtd *dtd)
+{
+	return intel_sdvo_get_timing(output,
+				     SDVO_CMD_GET_INPUT_TIMINGS_PART1, dtd);
+}
+
+static bool intel_sdvo_get_output_timing(struct drm_output *output,
+					 struct intel_sdvo_dtd *dtd)
+{
+	return intel_sdvo_get_timing(output,
+				     SDVO_CMD_GET_OUTPUT_TIMINGS_PART1, dtd);
+}
+
+static bool intel_sdvo_set_timing(struct drm_output *output, u8 cmd,
+				  struct intel_sdvo_dtd *dtd)
+{
+	u8 status;
+
+	intel_sdvo_write_cmd(output, cmd, &dtd->part1, sizeof(dtd->part1));
+	status = intel_sdvo_read_response(output, NULL, 0);
+	if (status != SDVO_CMD_STATUS_SUCCESS)
+		return false;
+
+	intel_sdvo_write_cmd(output, cmd + 1, &dtd->part2, sizeof(dtd->part2));
+	status = intel_sdvo_read_response(output, NULL, 0);
+	if (status != SDVO_CMD_STATUS_SUCCESS)
+		return false;
+
+	return true;
+}
+
+static bool intel_sdvo_set_input_timing(struct drm_output *output,
+					 struct intel_sdvo_dtd *dtd)
+{
+	return intel_sdvo_set_timing(output,
+				     SDVO_CMD_SET_INPUT_TIMINGS_PART1, dtd);
+}
+
+static bool intel_sdvo_set_output_timing(struct drm_output *output,
+					 struct intel_sdvo_dtd *dtd)
+{
+	return intel_sdvo_set_timing(output,
+				     SDVO_CMD_SET_OUTPUT_TIMINGS_PART1, dtd);
+}
+
+#if 0
+static bool intel_sdvo_get_preferred_input_timing(struct drm_output *output,
+						  struct intel_sdvo_dtd *dtd)
+{
+	struct intel_output *intel_output = output->driver_private;
+	struct intel_sdvo_priv *sdvo_priv = intel_output->dev_priv;
+	u8 status;
+
+	intel_sdvo_write_cmd(output, SDVO_CMD_GET_PREFERRED_INPUT_TIMING_PART1,
+			     NULL, 0);
+
+	status = intel_sdvo_read_response(output, &dtd->part1,
+					  sizeof(dtd->part1));
+	if (status != SDVO_CMD_STATUS_SUCCESS)
+		return false;
+
+	intel_sdvo_write_cmd(output, SDVO_CMD_GET_PREFERRED_INPUT_TIMING_PART2,
+			     NULL, 0);
+	status = intel_sdvo_read_response(output, &dtd->part2,
+					  sizeof(dtd->part2));
+	if (status != SDVO_CMD_STATUS_SUCCESS)
+		return false;
+
+	return true;
+}
+#endif
+
+static int intel_sdvo_get_clock_rate_mult(struct drm_output *output)
+{
+	struct intel_output *intel_output = output->driver_private;
+	u8 response, status;
+
+	intel_sdvo_write_cmd(output, SDVO_CMD_GET_CLOCK_RATE_MULT, NULL, 0);
+	status = intel_sdvo_read_response(output, &response, 1);
+
+	if (status != SDVO_CMD_STATUS_SUCCESS) {
+		DRM_DEBUG("Couldn't get SDVO clock rate multiplier\n");
+		return SDVO_CLOCK_RATE_MULT_1X;
+	} else {
+		DRM_DEBUG("Current clock rate multiplier: %d\n", response);
+	}
+
+	return response;
+}
+
+static bool intel_sdvo_set_clock_rate_mult(struct drm_output *output, u8 val)
+{
+	u8 status;
+
+	intel_sdvo_write_cmd(output, SDVO_CMD_SET_CLOCK_RATE_MULT, &val, 1);
+	status = intel_sdvo_read_response(output, NULL, 0);
+	if (status != SDVO_CMD_STATUS_SUCCESS)
+		return false;
+
+	return true;
+}
+
+static bool intel_sdvo_mode_fixup(struct drm_output *output,
+				  struct drm_display_mode *mode,
+				  struct drm_display_mode *adjusted_mode)
+{
+	/* Make the CRTC code factor in the SDVO pixel multiplier.  The SDVO
+	 * device will be told of the multiplier during mode_set.
+	 */
+	adjusted_mode->clock *= intel_sdvo_get_pixel_multiplier(mode);
+	return true;
+}
+
+static void intel_sdvo_mode_set(struct drm_output *output,
+				struct drm_display_mode *mode,
+				struct drm_display_mode *adjusted_mode)
+{
+	drm_device_t *dev = output->dev;
+	drm_i915_private_t *dev_priv = dev->dev_private;
+	struct drm_crtc *crtc = output->crtc;
+	struct intel_crtc *intel_crtc = crtc->driver_private;
+	struct intel_output *intel_output = output->driver_private;
+	struct intel_sdvo_priv *sdvo_priv = intel_output->dev_priv;
+	u16 width, height;
+	u16 h_blank_len, h_sync_len, v_blank_len, v_sync_len;
+	u16 h_sync_offset, v_sync_offset;
+	u32 sdvox;
+	struct intel_sdvo_dtd output_dtd;
+	int sdvo_pixel_multiply;
+
+	if (!mode)
+		return;
+
+	width = mode->crtc_hdisplay;
+	height = mode->crtc_vdisplay;
+
+	/* do some mode translations */
+	h_blank_len = mode->crtc_hblank_end - mode->crtc_hblank_start;
+	h_sync_len = mode->crtc_hsync_end - mode->crtc_hsync_start;
+
+	v_blank_len = mode->crtc_vblank_end - mode->crtc_vblank_start;
+	v_sync_len = mode->crtc_vsync_end - mode->crtc_vsync_start;
+
+	h_sync_offset = mode->crtc_hsync_start - mode->crtc_hblank_start;
+	v_sync_offset = mode->crtc_vsync_start - mode->crtc_vblank_start;
+
+	output_dtd.part1.clock = mode->clock / 10;
+	output_dtd.part1.h_active = width & 0xff;
+	output_dtd.part1.h_blank = h_blank_len & 0xff;
+	output_dtd.part1.h_high = (((width >> 8) & 0xf) << 4) |
+		((h_blank_len >> 8) & 0xf);
+	output_dtd.part1.v_active = height & 0xff;
+	output_dtd.part1.v_blank = v_blank_len & 0xff;
+	output_dtd.part1.v_high = (((height >> 8) & 0xf) << 4) |
+		((v_blank_len >> 8) & 0xf);
+	
+	output_dtd.part2.h_sync_off = h_sync_offset;
+	output_dtd.part2.h_sync_width = h_sync_len & 0xff;
+	output_dtd.part2.v_sync_off_width = (v_sync_offset & 0xf) << 4 |
+		(v_sync_len & 0xf);
+	output_dtd.part2.sync_off_width_high = ((h_sync_offset & 0x300) >> 2) |
+		((h_sync_len & 0x300) >> 4) | ((v_sync_offset & 0x30) >> 2) |
+		((v_sync_len & 0x30) >> 4);
+	
+	output_dtd.part2.dtd_flags = 0x18;
+	if (mode->flags & V_PHSYNC)
+		output_dtd.part2.dtd_flags |= 0x2;
+	if (mode->flags & V_PVSYNC)
+		output_dtd.part2.dtd_flags |= 0x4;
+
+	output_dtd.part2.sdvo_flags = 0;
+	output_dtd.part2.v_sync_off_high = v_sync_offset & 0xc0;
+	output_dtd.part2.reserved = 0;
+
+	/* Set the output timing to the screen */
+	intel_sdvo_set_target_output(output, sdvo_priv->active_outputs);
+	intel_sdvo_set_output_timing(output, &output_dtd);
+
+	/* Set the input timing to the screen. Assume always input 0. */
+	intel_sdvo_set_target_input(output, true, false);
+
+	/* We would like to use i830_sdvo_create_preferred_input_timing() to
+	 * provide the device with a timing it can support, if it supports that
+	 * feature.  However, presumably we would need to adjust the CRTC to
+	 * output the preferred timing, and we don't support that currently.
+	 */
+#if 0
+	success = intel_sdvo_create_preferred_input_timing(output, clock,
+							   width, height);
+	if (success) {
+		struct intel_sdvo_dtd *input_dtd;
+		
+		intel_sdvo_get_preferred_input_timing(output, &input_dtd);
+		intel_sdvo_set_input_timing(output, &input_dtd);
+	}
+#else
+	intel_sdvo_set_input_timing(output, &output_dtd);
+#endif	
+
+	switch (intel_sdvo_get_pixel_multiplier(mode)) {
+	case 1:
+		intel_sdvo_set_clock_rate_mult(output,
+					       SDVO_CLOCK_RATE_MULT_1X);
+		break;
+	case 2:
+		intel_sdvo_set_clock_rate_mult(output,
+					       SDVO_CLOCK_RATE_MULT_2X);
+		break;
+	case 4:
+		intel_sdvo_set_clock_rate_mult(output,
+					       SDVO_CLOCK_RATE_MULT_4X);
+		break;
+	}	
+
+	/* Set the SDVO control regs. */
+        if (0/*IS_I965GM(dev)*/) {
+                sdvox = SDVO_BORDER_ENABLE;
+        } else {
+                sdvox = I915_READ(sdvo_priv->output_device);
+                switch (sdvo_priv->output_device) {
+                case SDVOB:
+                        sdvox &= SDVOB_PRESERVE_MASK;
+                        break;
+                case SDVOC:
+                        sdvox &= SDVOC_PRESERVE_MASK;
+                        break;
+                }
+                sdvox |= (9 << 19) | SDVO_BORDER_ENABLE;
+        }
+	if (intel_crtc->pipe == 1)
+		sdvox |= SDVO_PIPE_B_SELECT;
+
+	sdvo_pixel_multiply = intel_sdvo_get_pixel_multiplier(mode);
+	if (IS_I965G(dev)) {
+		/* done in crtc_mode_set as the dpll_md reg must be written 
+		   early */
+	} else if (IS_I945G(dev) || IS_I945GM(dev)) {
+		/* done in crtc_mode_set as it lives inside the 
+		   dpll register */
+	} else {
+		sdvox |= (sdvo_pixel_multiply - 1) << SDVO_PORT_MULTIPLY_SHIFT;
+	}
+
+	intel_sdvo_write_sdvox(output, sdvox);
+}
+
+static void intel_sdvo_dpms(struct drm_output *output, int mode)
+{
+	drm_device_t *dev = output->dev;
+	drm_i915_private_t *dev_priv = dev->dev_private;
+	struct intel_output *intel_output = output->driver_private;
+	struct intel_sdvo_priv *sdvo_priv = intel_output->dev_priv;
+	u32 temp;
+
+	if (mode != DPMSModeOn) {
+		intel_sdvo_set_active_outputs(output, 0);
+		if (0)
+			intel_sdvo_set_encoder_power_state(output, mode);
+
+		if (mode == DPMSModeOff) {
+			temp = I915_READ(sdvo_priv->output_device);
+			if ((temp & SDVO_ENABLE) != 0) {
+				intel_sdvo_write_sdvox(output, temp & ~SDVO_ENABLE);
+			}
+		}
+	} else {
+		bool input1, input2;
+		int i;
+		u8 status;
+		
+		temp = I915_READ(sdvo_priv->output_device);
+		if ((temp & SDVO_ENABLE) == 0)
+			intel_sdvo_write_sdvox(output, temp | SDVO_ENABLE);
+		for (i = 0; i < 2; i++)
+		  intel_wait_for_vblank(dev);
+		
+		status = intel_sdvo_get_trained_inputs(output, &input1,
+						       &input2);
+
+		
+		/* Warn if the device reported failure to sync. */
+		if (status == SDVO_CMD_STATUS_SUCCESS && !input1) {
+			DRM_ERROR("First %s output reported failure to sync\n",
+				   SDVO_NAME(sdvo_priv));
+		}
+		
+		if (0)
+			intel_sdvo_set_encoder_power_state(output, mode);
+		intel_sdvo_set_active_outputs(output, sdvo_priv->active_outputs);
+	}	
+	return;
+}
+
+static void intel_sdvo_save(struct drm_output *output)
+{
+	drm_device_t *dev = output->dev;
+	drm_i915_private_t *dev_priv = dev->dev_private;
+	struct intel_output *intel_output = output->driver_private;
+	struct intel_sdvo_priv *sdvo_priv = intel_output->dev_priv;
+	int o;
+
+	sdvo_priv->save_sdvo_mult = intel_sdvo_get_clock_rate_mult(output);
+	intel_sdvo_get_active_outputs(output, &sdvo_priv->save_active_outputs);
+
+	if (sdvo_priv->caps.sdvo_inputs_mask & 0x1) {
+		intel_sdvo_set_target_input(output, true, false);
+		intel_sdvo_get_input_timing(output,
+					    &sdvo_priv->save_input_dtd_1);
+	}
+
+	if (sdvo_priv->caps.sdvo_inputs_mask & 0x2) {
+		intel_sdvo_set_target_input(output, false, true);
+		intel_sdvo_get_input_timing(output,
+					    &sdvo_priv->save_input_dtd_2);
+	}
+
+	for (o = SDVO_OUTPUT_FIRST; o <= SDVO_OUTPUT_LAST; o++)
+	{
+	        u16  this_output = (1 << o);
+		if (sdvo_priv->caps.output_flags & this_output)
+		{
+			intel_sdvo_set_target_output(output, this_output);
+			intel_sdvo_get_output_timing(output,
+						     &sdvo_priv->save_output_dtd[o]);
+		}
+	}
+
+	sdvo_priv->save_SDVOX = I915_READ(sdvo_priv->output_device);
+}
+
+static void intel_sdvo_restore(struct drm_output *output)
+{
+	drm_device_t *dev = output->dev;
+	drm_i915_private_t *dev_priv = dev->dev_private;
+	struct intel_output *intel_output = output->driver_private;
+	struct intel_sdvo_priv *sdvo_priv = intel_output->dev_priv;
+	int o;
+	int i;
+	bool input1, input2;
+	u8 status;
+
+	intel_sdvo_set_active_outputs(output, 0);
+
+	for (o = SDVO_OUTPUT_FIRST; o <= SDVO_OUTPUT_LAST; o++)
+	{
+		u16  this_output = (1 << o);
+		if (sdvo_priv->caps.output_flags & this_output) {
+			intel_sdvo_set_target_output(output, this_output);
+			intel_sdvo_set_output_timing(output, &sdvo_priv->save_output_dtd[o]);
+		}
+	}
+
+	if (sdvo_priv->caps.sdvo_inputs_mask & 0x1) {
+		intel_sdvo_set_target_input(output, true, false);
+		intel_sdvo_set_input_timing(output, &sdvo_priv->save_input_dtd_1);
+	}
+
+	if (sdvo_priv->caps.sdvo_inputs_mask & 0x2) {
+		intel_sdvo_set_target_input(output, false, true);
+		intel_sdvo_set_input_timing(output, &sdvo_priv->save_input_dtd_2);
+	}
+	
+	intel_sdvo_set_clock_rate_mult(output, sdvo_priv->save_sdvo_mult);
+	
+	I915_WRITE(sdvo_priv->output_device, sdvo_priv->save_SDVOX);
+	
+	if (sdvo_priv->save_SDVOX & SDVO_ENABLE)
+	{
+		for (i = 0; i < 2; i++)
+			intel_wait_for_vblank(dev);
+		status = intel_sdvo_get_trained_inputs(output, &input1, &input2);
+		if (status == SDVO_CMD_STATUS_SUCCESS && !input1)
+			DRM_DEBUG("First %s output reported failure to sync\n",
+				   SDVO_NAME(sdvo_priv));
+	}
+	
+	intel_sdvo_set_active_outputs(output, sdvo_priv->save_active_outputs);
+}
+
+static int intel_sdvo_mode_valid(struct drm_output *output,
+				 struct drm_display_mode *mode)
+{
+	struct intel_output *intel_output = output->driver_private;
+	struct intel_sdvo_priv *sdvo_priv = intel_output->dev_priv;
+
+	if (mode->flags & V_DBLSCAN)
+		return MODE_NO_DBLESCAN;
+
+	if (sdvo_priv->pixel_clock_min > mode->clock)
+		return MODE_CLOCK_HIGH;
+
+	if (sdvo_priv->pixel_clock_max < mode->clock)
+		return MODE_CLOCK_LOW;
+
+	return MODE_OK;
+}
+
+static bool intel_sdvo_get_capabilities(struct drm_output *output, struct intel_sdvo_caps *caps)
+{
+	u8 status;
+
+	intel_sdvo_write_cmd(output, SDVO_CMD_GET_DEVICE_CAPS, NULL, 0);
+	status = intel_sdvo_read_response(output, caps, sizeof(*caps));
+	if (status != SDVO_CMD_STATUS_SUCCESS)
+		return false;
+
+	return true;
+}
+
+
+static void intel_sdvo_dump_cmd(struct drm_output *output, int opcode)
+{
+
+
+}
+
+static void intel_sdvo_dump_device(struct drm_output *output)
+{
+
+}
+
+void intel_sdvo_dump(void)
+{
+
+}
+
+
+static enum drm_output_status intel_sdvo_detect(struct drm_output *output)
+{
+	u8 response[2];
+	u8 status;
+
+	intel_sdvo_write_cmd(output, SDVO_CMD_GET_ATTACHED_DISPLAYS, NULL, 0);
+	status = intel_sdvo_read_response(output, &response, 2);
+
+	DRM_DEBUG("SDVO response %d %d\n", response[0], response[1]);
+	if ((response[0] != 0) || (response[1] != 0))
+		return output_status_connected;
+	else
+		return output_status_disconnected;
+}
+
+static int intel_sdvo_get_modes(struct drm_output *output)
+{
+	struct drm_display_mode *modes;
+
+	/* set the bus switch and get the modes */
+	intel_sdvo_set_control_bus_switch(output, SDVO_CONTROL_BUS_DDC2);
+	intel_ddc_get_modes(output);
+
+	if (list_empty(&output->probed_modes))
+		return 0;
+	return 1;
+#if 0
+	/* Mac mini hack.  On this device, I get DDC through the analog, which
+	 * load-detects as disconnected.  I fail to DDC through the SDVO DDC,
+	 * but it does load-detect as connected.  So, just steal the DDC bits 
+	 * from analog when we fail at finding it the right way.
+	 */
+	/* TODO */
+	return NULL;
+
+	return NULL;
+#endif
+}
+
+static void intel_sdvo_destroy(struct drm_output *output)
+{
+	struct intel_output *intel_output = output->driver_private;
+
+	if (intel_output->i2c_bus)
+		intel_i2c_destroy(intel_output->i2c_bus);
+
+	if (intel_output) {
+		kfree(intel_output);
+		output->driver_private = NULL;
+	}
+}
+
+static const struct drm_output_funcs intel_sdvo_output_funcs = {
+	.dpms = intel_sdvo_dpms,
+	.save = intel_sdvo_save,
+	.restore = intel_sdvo_restore,
+	.mode_valid = intel_sdvo_mode_valid,
+	.mode_fixup = intel_sdvo_mode_fixup,
+	.prepare = intel_output_prepare,
+	.mode_set = intel_sdvo_mode_set,
+	.commit = intel_output_commit,
+	.detect = intel_sdvo_detect,
+	.get_modes = intel_sdvo_get_modes,
+	.cleanup = intel_sdvo_destroy
+};
+
+void intel_sdvo_init(drm_device_t *dev, int output_device)
+{
+	struct drm_output *output;
+	struct intel_output *intel_output;
+	struct intel_sdvo_priv *sdvo_priv;
+	struct intel_i2c_chan *i2cbus = NULL;
+	u8 ch[0x40];
+	int i;
+	char name[DRM_OUTPUT_LEN];
+	char *name_prefix;
+	char *name_suffix;
+	
+
+	output = drm_output_create(dev, &intel_sdvo_output_funcs, NULL);
+	if (!output)
+		return;
+
+	intel_output = kcalloc(sizeof(struct intel_output)+sizeof(struct intel_sdvo_priv), 1, GFP_KERNEL);
+	if (!intel_output) {
+		drm_output_destroy(output);
+		return;
+	}
+
+	sdvo_priv = (struct intel_sdvo_priv *)(intel_output + 1);
+	intel_output->type = INTEL_OUTPUT_SDVO;
+	output->driver_private = intel_output;
+	output->interlace_allowed = 0;
+	output->doublescan_allowed = 0;
+
+	/* setup the DDC bus. */
+	if (output_device == SDVOB)
+		i2cbus = intel_i2c_create(dev, GPIOE, "SDVOCTRL_E for SDVOB");
+	else
+		i2cbus = intel_i2c_create(dev, GPIOE, "SDVOCTRL_E for SDVOC");
+
+	if (i2cbus == NULL) {
+		drm_output_destroy(output);
+		return;
+	}
+
+	sdvo_priv->i2c_bus = i2cbus;
+
+	if (output_device == SDVOB) {
+		name_suffix = "-1";
+		sdvo_priv->i2c_bus->slave_addr = 0x38;
+	} else {
+		name_suffix = "-2";
+		sdvo_priv->i2c_bus->slave_addr = 0x39;
+	}
+
+	sdvo_priv->output_device = output_device;
+	intel_output->i2c_bus = i2cbus;
+	intel_output->dev_priv = sdvo_priv;
+
+
+	/* Read the regs to test if we can talk to the device */
+	for (i = 0; i < 0x40; i++) {
+		if (!intel_sdvo_read_byte(output, i, &ch[i])) {
+			DRM_DEBUG("No SDVO device found on SDVO%c\n",
+				  output_device == SDVOB ? 'B' : 'C');
+			drm_output_destroy(output);
+			return;
+		}
+	}
+
+	intel_sdvo_get_capabilities(output, &sdvo_priv->caps);
+
+	memset(&sdvo_priv->active_outputs, 0, sizeof(sdvo_priv->active_outputs));
+
+	/* TODO, CVBS, SVID, YPRPB & SCART outputs.
+	 * drm_initial_config probably wants tweaking too to support the
+	 * above. But has fixed VGA, TMDS and LVDS checking code. That should
+	 * be dealt with.
+	 */
+	if (sdvo_priv->caps.output_flags & SDVO_OUTPUT_RGB0)
+	{
+		sdvo_priv->active_outputs = SDVO_OUTPUT_RGB0;
+		output->subpixel_order = SubPixelHorizontalRGB;
+		/* drm_initial_config wants this name, but should be RGB */
+		/* Use this for now.... */
+		name_prefix="VGA";
+	}
+	else if (sdvo_priv->caps.output_flags & SDVO_OUTPUT_RGB1)
+	{
+		sdvo_priv->active_outputs = SDVO_OUTPUT_RGB1;
+		output->subpixel_order = SubPixelHorizontalRGB;
+		/* drm_initial_config wants this name, but should be RGB */
+		/* Use this for now.... */
+		name_prefix="VGA";
+	}
+	else if (sdvo_priv->caps.output_flags & SDVO_OUTPUT_TMDS0)
+	{
+		sdvo_priv->active_outputs = SDVO_OUTPUT_TMDS0;
+		output->subpixel_order = SubPixelHorizontalRGB;
+		name_prefix="TMDS";
+	}
+	else if (sdvo_priv->caps.output_flags & SDVO_OUTPUT_TMDS1)
+	{
+		sdvo_priv->active_outputs = SDVO_OUTPUT_TMDS1;
+		output->subpixel_order = SubPixelHorizontalRGB;
+		name_prefix="TMDS";
+	}
+	else
+	{
+		unsigned char bytes[2];
+		
+		memcpy (bytes, &sdvo_priv->caps.output_flags, 2);
+		DRM_DEBUG("%s: No active RGB or TMDS outputs (0x%02x%02x)\n",
+			  SDVO_NAME(sdvo_priv),
+			  bytes[0], bytes[1]);
+		drm_output_destroy(output);
+		return;
+	}
+	strcpy (name, name_prefix);
+	strcat (name, name_suffix);
+	if (!drm_output_rename(output, name))
+	{
+		drm_output_destroy(output);
+		return;
+	}
+		
+
+	/* Set the input timing to the screen. Assume always input 0. */
+	intel_sdvo_set_target_input(output, true, false);
+	
+	intel_sdvo_get_input_pixel_clock_range(output,
+					       &sdvo_priv->pixel_clock_min,
+					       &sdvo_priv->pixel_clock_max);
+
+
+	DRM_DEBUG("%s device VID/DID: %02X:%02X.%02X, "
+		  "clock range %dMHz - %dMHz, "
+		  "input 1: %c, input 2: %c, "
+		  "output 1: %c, output 2: %c\n",
+		  SDVO_NAME(sdvo_priv),
+		  sdvo_priv->caps.vendor_id, sdvo_priv->caps.device_id,
+		  sdvo_priv->caps.device_rev_id,
+		  sdvo_priv->pixel_clock_min / 1000,
+		  sdvo_priv->pixel_clock_max / 1000,
+		  (sdvo_priv->caps.sdvo_inputs_mask & 0x1) ? 'Y' : 'N',
+		  (sdvo_priv->caps.sdvo_inputs_mask & 0x2) ? 'Y' : 'N',
+		  /* check currently supported outputs */
+		  sdvo_priv->caps.output_flags & 
+		  	(SDVO_OUTPUT_TMDS0 | SDVO_OUTPUT_RGB0) ? 'Y' : 'N',
+		  sdvo_priv->caps.output_flags & 
+		  	(SDVO_OUTPUT_TMDS1 | SDVO_OUTPUT_RGB1) ? 'Y' : 'N');
+
+	intel_output->ddc_bus = i2cbus;	
+}
diff --git a/linux-core/intel_sdvo_regs.h b/linux-core/intel_sdvo_regs.h
new file mode 100644
index 0000000..a9d1671
--- /dev/null
+++ b/linux-core/intel_sdvo_regs.h
@@ -0,0 +1,328 @@
+/*
+ * Copyright � 2006-2007 Intel Corporation
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
+ * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ *
+ * Authors:
+ *	Eric Anholt <eric@anholt.net>
+ */
+
+/**
+ * @file SDVO command definitions and structures.
+ */
+
+#define SDVO_OUTPUT_FIRST   (0)
+#define SDVO_OUTPUT_TMDS0   (1 << 0)
+#define SDVO_OUTPUT_RGB0    (1 << 1)
+#define SDVO_OUTPUT_CVBS0   (1 << 2)
+#define SDVO_OUTPUT_SVID0   (1 << 3)
+#define SDVO_OUTPUT_YPRPB0  (1 << 4)
+#define SDVO_OUTPUT_SCART0  (1 << 5)
+#define SDVO_OUTPUT_LVDS0   (1 << 6)
+#define SDVO_OUTPUT_TMDS1   (1 << 8)
+#define SDVO_OUTPUT_RGB1    (1 << 9)
+#define SDVO_OUTPUT_CVBS1   (1 << 10)
+#define SDVO_OUTPUT_SVID1   (1 << 11)
+#define SDVO_OUTPUT_YPRPB1  (1 << 12)
+#define SDVO_OUTPUT_SCART1  (1 << 13)
+#define SDVO_OUTPUT_LVDS1   (1 << 14)
+#define SDVO_OUTPUT_LAST    (14)
+
+struct intel_sdvo_caps {
+    u8 vendor_id;
+    u8 device_id;
+    u8 device_rev_id;
+    u8 sdvo_version_major;
+    u8 sdvo_version_minor;
+    unsigned int sdvo_inputs_mask:2;
+    unsigned int smooth_scaling:1;
+    unsigned int sharp_scaling:1;
+    unsigned int up_scaling:1;
+    unsigned int down_scaling:1;
+    unsigned int stall_support:1;
+    unsigned int pad:1;
+    u16 output_flags;
+} __attribute__((packed));
+
+/** This matches the EDID DTD structure, more or less */
+struct intel_sdvo_dtd {
+    struct {
+	u16 clock;		/**< pixel clock, in 10kHz units */
+	u8 h_active;		/**< lower 8 bits (pixels) */
+	u8 h_blank;		/**< lower 8 bits (pixels) */
+	u8 h_high;		/**< upper 4 bits each h_active, h_blank */
+	u8 v_active;		/**< lower 8 bits (lines) */
+	u8 v_blank;		/**< lower 8 bits (lines) */
+	u8 v_high;		/**< upper 4 bits each v_active, v_blank */
+    } part1;
+
+    struct {
+	u8 h_sync_off;	/**< lower 8 bits, from hblank start */
+	u8 h_sync_width;	/**< lower 8 bits (pixels) */
+	/** lower 4 bits each vsync offset, vsync width */
+	u8 v_sync_off_width;
+	/**
+	 * 2 high bits of hsync offset, 2 high bits of hsync width,
+	 * bits 4-5 of vsync offset, and 2 high bits of vsync width.
+	 */
+	u8 sync_off_width_high;
+	u8 dtd_flags;
+	u8 sdvo_flags;
+	/** bits 6-7 of vsync offset at bits 6-7 */
+	u8 v_sync_off_high;
+	u8 reserved;
+    } part2;
+} __attribute__((packed));
+
+struct intel_sdvo_pixel_clock_range {
+    u16 min;			/**< pixel clock, in 10kHz units */
+    u16 max;			/**< pixel clock, in 10kHz units */
+} __attribute__((packed));
+
+struct intel_sdvo_preferred_input_timing_args {
+    u16 clock;
+    u16 width;
+    u16 height;
+} __attribute__((packed));
+
+/* I2C registers for SDVO */
+#define SDVO_I2C_ARG_0				0x07
+#define SDVO_I2C_ARG_1				0x06
+#define SDVO_I2C_ARG_2				0x05
+#define SDVO_I2C_ARG_3				0x04
+#define SDVO_I2C_ARG_4				0x03
+#define SDVO_I2C_ARG_5				0x02
+#define SDVO_I2C_ARG_6				0x01
+#define SDVO_I2C_ARG_7				0x00
+#define SDVO_I2C_OPCODE				0x08
+#define SDVO_I2C_CMD_STATUS			0x09
+#define SDVO_I2C_RETURN_0			0x0a
+#define SDVO_I2C_RETURN_1			0x0b
+#define SDVO_I2C_RETURN_2			0x0c
+#define SDVO_I2C_RETURN_3			0x0d
+#define SDVO_I2C_RETURN_4			0x0e
+#define SDVO_I2C_RETURN_5			0x0f
+#define SDVO_I2C_RETURN_6			0x10
+#define SDVO_I2C_RETURN_7			0x11
+#define SDVO_I2C_VENDOR_BEGIN			0x20
+
+/* Status results */
+#define SDVO_CMD_STATUS_POWER_ON		0x0
+#define SDVO_CMD_STATUS_SUCCESS			0x1
+#define SDVO_CMD_STATUS_NOTSUPP			0x2
+#define SDVO_CMD_STATUS_INVALID_ARG		0x3
+#define SDVO_CMD_STATUS_PENDING			0x4
+#define SDVO_CMD_STATUS_TARGET_NOT_SPECIFIED	0x5
+#define SDVO_CMD_STATUS_SCALING_NOT_SUPP	0x6
+
+/* SDVO commands, argument/result registers */
+
+#define SDVO_CMD_RESET					0x01
+
+/** Returns a struct intel_sdvo_caps */
+#define SDVO_CMD_GET_DEVICE_CAPS			0x02
+
+#define SDVO_CMD_GET_FIRMWARE_REV			0x86
+# define SDVO_DEVICE_FIRMWARE_MINOR			SDVO_I2C_RETURN_0
+# define SDVO_DEVICE_FIRMWARE_MAJOR			SDVO_I2C_RETURN_1
+# define SDVO_DEVICE_FIRMWARE_PATCH			SDVO_I2C_RETURN_2
+
+/**
+ * Reports which inputs are trained (managed to sync).
+ *
+ * Devices must have trained within 2 vsyncs of a mode change.
+ */
+#define SDVO_CMD_GET_TRAINED_INPUTS			0x03
+struct intel_sdvo_get_trained_inputs_response {
+    unsigned int input0_trained:1;
+    unsigned int input1_trained:1;
+    unsigned int pad:6;
+} __attribute__((packed));
+
+/** Returns a struct intel_sdvo_output_flags of active outputs. */
+#define SDVO_CMD_GET_ACTIVE_OUTPUTS			0x04
+
+/**
+ * Sets the current set of active outputs.
+ *
+ * Takes a struct intel_sdvo_output_flags.  Must be preceded by a SET_IN_OUT_MAP
+ * on multi-output devices.
+ */
+#define SDVO_CMD_SET_ACTIVE_OUTPUTS			0x05
+
+/**
+ * Returns the current mapping of SDVO inputs to outputs on the device.
+ *
+ * Returns two struct intel_sdvo_output_flags structures.
+ */
+#define SDVO_CMD_GET_IN_OUT_MAP				0x06
+
+/**
+ * Sets the current mapping of SDVO inputs to outputs on the device.
+ *
+ * Takes two struct i380_sdvo_output_flags structures.
+ */
+#define SDVO_CMD_SET_IN_OUT_MAP				0x07
+
+/**
+ * Returns a struct intel_sdvo_output_flags of attached displays.
+ */
+#define SDVO_CMD_GET_ATTACHED_DISPLAYS			0x0b
+
+/**
+ * Returns a struct intel_sdvo_ouptut_flags of displays supporting hot plugging.
+ */
+#define SDVO_CMD_GET_HOT_PLUG_SUPPORT			0x0c
+
+/**
+ * Takes a struct intel_sdvo_output_flags.
+ */
+#define SDVO_CMD_SET_ACTIVE_HOT_PLUG			0x0d
+
+/**
+ * Returns a struct intel_sdvo_output_flags of displays with hot plug
+ * interrupts enabled.
+ */
+#define SDVO_CMD_GET_ACTIVE_HOT_PLUG			0x0e
+
+#define SDVO_CMD_GET_INTERRUPT_EVENT_SOURCE		0x0f
+struct intel_sdvo_get_interrupt_event_source_response {
+    u16 interrupt_status;
+    unsigned int ambient_light_interrupt:1;
+    unsigned int pad:7;
+} __attribute__((packed));
+
+/**
+ * Selects which input is affected by future input commands.
+ *
+ * Commands affected include SET_INPUT_TIMINGS_PART[12],
+ * GET_INPUT_TIMINGS_PART[12], GET_PREFERRED_INPUT_TIMINGS_PART[12],
+ * GET_INPUT_PIXEL_CLOCK_RANGE, and CREATE_PREFERRED_INPUT_TIMINGS.
+ */
+#define SDVO_CMD_SET_TARGET_INPUT			0x10
+struct intel_sdvo_set_target_input_args {
+    unsigned int target_1:1;
+    unsigned int pad:7;
+} __attribute__((packed));
+
+/**
+ * Takes a struct intel_sdvo_output_flags of which outputs are targetted by
+ * future output commands.
+ *
+ * Affected commands inclue SET_OUTPUT_TIMINGS_PART[12],
+ * GET_OUTPUT_TIMINGS_PART[12], and GET_OUTPUT_PIXEL_CLOCK_RANGE.
+ */
+#define SDVO_CMD_SET_TARGET_OUTPUT			0x11
+
+#define SDVO_CMD_GET_INPUT_TIMINGS_PART1		0x12
+#define SDVO_CMD_GET_INPUT_TIMINGS_PART2		0x13
+#define SDVO_CMD_SET_INPUT_TIMINGS_PART1		0x14
+#define SDVO_CMD_SET_INPUT_TIMINGS_PART2		0x15
+#define SDVO_CMD_SET_OUTPUT_TIMINGS_PART1		0x16
+#define SDVO_CMD_SET_OUTPUT_TIMINGS_PART2		0x17
+#define SDVO_CMD_GET_OUTPUT_TIMINGS_PART1		0x18
+#define SDVO_CMD_GET_OUTPUT_TIMINGS_PART2		0x19
+/* Part 1 */
+# define SDVO_DTD_CLOCK_LOW				SDVO_I2C_ARG_0
+# define SDVO_DTD_CLOCK_HIGH				SDVO_I2C_ARG_1
+# define SDVO_DTD_H_ACTIVE				SDVO_I2C_ARG_2
+# define SDVO_DTD_H_BLANK				SDVO_I2C_ARG_3
+# define SDVO_DTD_H_HIGH				SDVO_I2C_ARG_4
+# define SDVO_DTD_V_ACTIVE				SDVO_I2C_ARG_5
+# define SDVO_DTD_V_BLANK				SDVO_I2C_ARG_6
+# define SDVO_DTD_V_HIGH				SDVO_I2C_ARG_7
+/* Part 2 */
+# define SDVO_DTD_HSYNC_OFF				SDVO_I2C_ARG_0
+# define SDVO_DTD_HSYNC_WIDTH				SDVO_I2C_ARG_1
+# define SDVO_DTD_VSYNC_OFF_WIDTH			SDVO_I2C_ARG_2
+# define SDVO_DTD_SYNC_OFF_WIDTH_HIGH			SDVO_I2C_ARG_3
+# define SDVO_DTD_DTD_FLAGS				SDVO_I2C_ARG_4
+# define SDVO_DTD_DTD_FLAG_INTERLACED				(1 << 7)
+# define SDVO_DTD_DTD_FLAG_STEREO_MASK				(3 << 5)
+# define SDVO_DTD_DTD_FLAG_INPUT_MASK				(3 << 3)
+# define SDVO_DTD_DTD_FLAG_SYNC_MASK				(3 << 1)
+# define SDVO_DTD_SDVO_FLAS				SDVO_I2C_ARG_5
+# define SDVO_DTD_SDVO_FLAG_STALL				(1 << 7)
+# define SDVO_DTD_SDVO_FLAG_CENTERED				(0 << 6)
+# define SDVO_DTD_SDVO_FLAG_UPPER_LEFT				(1 << 6)
+# define SDVO_DTD_SDVO_FLAG_SCALING_MASK			(3 << 4)
+# define SDVO_DTD_SDVO_FLAG_SCALING_NONE			(0 << 4)
+# define SDVO_DTD_SDVO_FLAG_SCALING_SHARP			(1 << 4)
+# define SDVO_DTD_SDVO_FLAG_SCALING_SMOOTH			(2 << 4)
+# define SDVO_DTD_VSYNC_OFF_HIGH			SDVO_I2C_ARG_6
+
+/**
+ * Generates a DTD based on the given width, height, and flags.
+ *
+ * This will be supported by any device supporting scaling or interlaced
+ * modes.
+ */
+#define SDVO_CMD_CREATE_PREFERRED_INPUT_TIMING		0x1a
+# define SDVO_PREFERRED_INPUT_TIMING_CLOCK_LOW		SDVO_I2C_ARG_0
+# define SDVO_PREFERRED_INPUT_TIMING_CLOCK_HIGH		SDVO_I2C_ARG_1
+# define SDVO_PREFERRED_INPUT_TIMING_WIDTH_LOW		SDVO_I2C_ARG_2
+# define SDVO_PREFERRED_INPUT_TIMING_WIDTH_HIGH		SDVO_I2C_ARG_3
+# define SDVO_PREFERRED_INPUT_TIMING_HEIGHT_LOW		SDVO_I2C_ARG_4
+# define SDVO_PREFERRED_INPUT_TIMING_HEIGHT_HIGH	SDVO_I2C_ARG_5
+# define SDVO_PREFERRED_INPUT_TIMING_FLAGS		SDVO_I2C_ARG_6
+# define SDVO_PREFERRED_INPUT_TIMING_FLAGS_INTERLACED		(1 << 0)
+# define SDVO_PREFERRED_INPUT_TIMING_FLAGS_SCALED		(1 << 1)
+
+#define SDVO_CMD_GET_PREFERRED_INPUT_TIMING_PART1	0x1b
+#define SDVO_CMD_GET_PREFERRED_INPUT_TIMING_PART2	0x1c
+
+/** Returns a struct intel_sdvo_pixel_clock_range */
+#define SDVO_CMD_GET_INPUT_PIXEL_CLOCK_RANGE		0x1d
+/** Returns a struct intel_sdvo_pixel_clock_range */
+#define SDVO_CMD_GET_OUTPUT_PIXEL_CLOCK_RANGE		0x1e
+
+/** Returns a byte bitfield containing SDVO_CLOCK_RATE_MULT_* flags */
+#define SDVO_CMD_GET_SUPPORTED_CLOCK_RATE_MULTS		0x1f
+
+/** Returns a byte containing a SDVO_CLOCK_RATE_MULT_* flag */
+#define SDVO_CMD_GET_CLOCK_RATE_MULT			0x20
+/** Takes a byte containing a SDVO_CLOCK_RATE_MULT_* flag */
+#define SDVO_CMD_SET_CLOCK_RATE_MULT			0x21
+# define SDVO_CLOCK_RATE_MULT_1X				(1 << 0)
+# define SDVO_CLOCK_RATE_MULT_2X				(1 << 1)
+# define SDVO_CLOCK_RATE_MULT_4X				(1 << 3)
+
+#define SDVO_CMD_GET_SUPPORTED_TV_FORMATS		0x27
+
+#define SDVO_CMD_GET_TV_FORMAT				0x28
+
+#define SDVO_CMD_SET_TV_FORMAT				0x29
+
+#define SDVO_CMD_GET_SUPPORTED_POWER_STATES		0x2a
+#define SDVO_CMD_GET_ENCODER_POWER_STATE		0x2b
+#define SDVO_CMD_SET_ENCODER_POWER_STATE		0x2c
+# define SDVO_ENCODER_STATE_ON					(1 << 0)
+# define SDVO_ENCODER_STATE_STANDBY				(1 << 1)
+# define SDVO_ENCODER_STATE_SUSPEND				(1 << 2)
+# define SDVO_ENCODER_STATE_OFF					(1 << 3)
+
+#define SDVO_CMD_SET_TV_RESOLUTION_SUPPORT		0x93
+
+#define SDVO_CMD_SET_CONTROL_BUS_SWITCH			0x7a
+# define SDVO_CONTROL_BUS_PROM				0x0
+# define SDVO_CONTROL_BUS_DDC1				0x1
+# define SDVO_CONTROL_BUS_DDC2				0x2
+# define SDVO_CONTROL_BUS_DDC3				0x3
+
