Return-Path: <linux-kernel-owner+w=401wt.eu-S1753107AbZFFGe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107AbZFFGe4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 02:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750879AbZFFGes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 02:34:48 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:40692 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbZFFGer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 02:34:47 -0400
Date: Sat, 6 Jun 2009 09:34:47 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: akpm@linux-foundation.org
cc: linux-kernel@vger.kernel.org, apw@canonical.com, jbarnes@virtuousgeek.org,
       tim.gardner@canonical.com, stefan.bader@canonical.com
Subject: [PATCH 1/2] i915: enable MCHBAR if needed
Message-ID: <Pine.LNX.4.64.0906060933110.11247@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesse Barnes <jbarnes@virtuousgeek.org>

Using the new PNP resource checking code, this patch allows the i915
driver to allocate MCHBAR space if needed and use the BAR to determine
current memory settings.

This patch fixes a serious performance regression on Asus Eee PC 701 (and
probably other) systems. See the following URL for details:

  http://bugs.launchpad.net/bugs/349314

[ apw@canonical.com: moved to the new generic PNP resource interface]
[ penberg@cs.helsinki.fi: rediff to 2.6.30-rc8 ]
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andy Whitcroft <apw@canonical.com>
Acked-by: Tim Gardner <tim.gardner@canonical.com>
Acked-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/gpu/drm/i915/i915_drv.h        |    2 +
 drivers/gpu/drm/i915/i915_gem_tiling.c |  145 ++++++++++++++++++++++++++++++++
 2 files changed, 147 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index c431fa5..1c67e0c 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -143,6 +143,8 @@ typedef struct drm_i915_private {
 	drm_local_map_t hws_map;
 	struct drm_gem_object *hws_obj;
 
+	struct resource mch_res;
+
 	unsigned int cpp;
 	int back_offset;
 	int front_offset;
diff --git a/drivers/gpu/drm/i915/i915_gem_tiling.c b/drivers/gpu/drm/i915/i915_gem_tiling.c
index 540dd33..43a95e9 100644
--- a/drivers/gpu/drm/i915/i915_gem_tiling.c
+++ b/drivers/gpu/drm/i915/i915_gem_tiling.c
@@ -24,6 +24,8 @@
  *    Eric Anholt <eric@anholt.net>
  *
  */
+#include <linux/acpi.h>
+#include <linux/pnp.h>
 
 #include "linux/string.h"
 #include "linux/bitops.h"
@@ -81,6 +83,143 @@
  * to match what the GPU expects.
  */
 
+#define MCHBAR_I915 0x44
+#define MCHBAR_I965 0x48
+#define MCHBAR_SIZE (4*4096)
+
+#define DEVEN_REG 0x54
+#define   DEVEN_MCHBAR_EN (1 << 28)
+
+/* Allocate space for the MCH regs if needed, return nonzero on error */
+static int
+intel_alloc_mchbar_resource(struct drm_device *dev)
+{
+	struct pci_dev *bridge_dev;
+	drm_i915_private_t *dev_priv = dev->dev_private;
+	int reg = IS_I965G(dev) ? MCHBAR_I965 : MCHBAR_I915;
+	u32 temp_lo, temp_hi = 0;
+	u64 mchbar_addr;
+	int ret = 0;
+
+	bridge_dev = pci_get_bus_and_slot(0, PCI_DEVFN(0,0));
+	if (!bridge_dev) {
+		DRM_DEBUG("no bridge dev?!\n");
+		ret = -ENODEV;
+		goto out;
+	}
+
+	if (IS_I965G(dev))
+		pci_read_config_dword(bridge_dev, reg + 4, &temp_hi);
+	pci_read_config_dword(bridge_dev, reg, &temp_lo);
+	mchbar_addr = ((u64)temp_hi << 32) | temp_lo;
+
+	/* If ACPI doesn't have it, assume we need to allocate it ourselves */
+	if (mchbar_addr &&
+	    pnp_range_reserved(mchbar_addr, mchbar_addr + MCHBAR_SIZE)) {
+		ret = 0;
+		goto out_put;
+	}
+
+	/* Get some space for it */
+	ret = pci_bus_alloc_resource(bridge_dev->bus, &dev_priv->mch_res,
+				     MCHBAR_SIZE, MCHBAR_SIZE,
+				     PCIBIOS_MIN_MEM,
+				     0,   pcibios_align_resource,
+				     bridge_dev);
+	if (ret) {
+		DRM_DEBUG("failed bus alloc: %d\n", ret);
+		dev_priv->mch_res.start = 0;
+		goto out_put;
+	}
+
+	if (IS_I965G(dev))
+		pci_write_config_dword(bridge_dev, reg + 4,
+				       upper_32_bits(dev_priv->mch_res.start));
+
+	pci_write_config_dword(bridge_dev, reg,
+			       lower_32_bits(dev_priv->mch_res.start));
+out_put:
+	pci_dev_put(bridge_dev);
+out:
+	return ret;
+}
+
+/* Setup MCHBAR if possible, return true if we should disable it again */
+static bool
+intel_setup_mchbar(struct drm_device *dev)
+{
+	struct pci_dev *bridge_dev;
+	int mchbar_reg = IS_I965G(dev) ? MCHBAR_I965 : MCHBAR_I915;
+	u32 temp;
+	bool need_disable = false, enabled;
+
+	bridge_dev = pci_get_bus_and_slot(0, PCI_DEVFN(0,0));
+	if (!bridge_dev) {
+		DRM_DEBUG("no bridge dev?!\n");
+		goto out;
+	}
+
+	if (IS_I915G(dev) || IS_I915GM(dev)) {
+		pci_read_config_dword(bridge_dev, DEVEN_REG, &temp);
+		enabled = !!(temp & DEVEN_MCHBAR_EN);
+	} else {
+		pci_read_config_dword(bridge_dev, mchbar_reg, &temp);
+		enabled = temp & 1;
+	}
+
+	/* If it's already enabled, don't have to do anything */
+	if (enabled)
+		goto out_put;
+
+	if (intel_alloc_mchbar_resource(dev))
+		goto out_put;
+
+	need_disable = true;
+
+	/* Space is allocated or reserved, so enable it. */
+	if (IS_I915G(dev) || IS_I915GM(dev)) {
+		pci_write_config_dword(bridge_dev, DEVEN_REG,
+				       temp | DEVEN_MCHBAR_EN);
+	} else {
+		pci_read_config_dword(bridge_dev, mchbar_reg, &temp);
+		pci_write_config_dword(bridge_dev, mchbar_reg, temp | 1);
+	}
+out_put:
+	pci_dev_put(bridge_dev);
+out:
+	return need_disable;
+}
+
+static void
+intel_teardown_mchbar(struct drm_device *dev, bool disable)
+{
+	drm_i915_private_t *dev_priv = dev->dev_private;
+	struct pci_dev *bridge_dev;
+	int mchbar_reg = IS_I965G(dev) ? MCHBAR_I965 : MCHBAR_I915;
+	u32 temp;
+
+	bridge_dev = pci_get_bus_and_slot(0, PCI_DEVFN(0,0));
+	if (!bridge_dev) {
+		DRM_DEBUG("no bridge dev?!\n");
+		return;
+	}
+
+	if (disable) {
+		if (IS_I915G(dev) || IS_I915GM(dev)) {
+			pci_read_config_dword(bridge_dev, DEVEN_REG, &temp);
+			temp &= ~DEVEN_MCHBAR_EN;
+			pci_write_config_dword(bridge_dev, DEVEN_REG, temp);
+		} else {
+			pci_read_config_dword(bridge_dev, mchbar_reg, &temp);
+			temp &= ~1;
+			pci_write_config_dword(bridge_dev, mchbar_reg, temp);
+		}
+	}
+
+	if (dev_priv->mch_res.start)
+		release_resource(&dev_priv->mch_res);
+}
+
 /**
  * Detects bit 6 swizzling of address lookup between IGD access and CPU
  * access through main memory.
@@ -91,6 +230,7 @@ i915_gem_detect_bit_6_swizzle(struct drm_device *dev)
 	drm_i915_private_t *dev_priv = dev->dev_private;
 	uint32_t swizzle_x = I915_BIT_6_SWIZZLE_UNKNOWN;
 	uint32_t swizzle_y = I915_BIT_6_SWIZZLE_UNKNOWN;
+	bool need_disable;
 
 	if (!IS_I9XX(dev)) {
 		/* As far as we know, the 865 doesn't have these bit 6
@@ -101,6 +241,9 @@ i915_gem_detect_bit_6_swizzle(struct drm_device *dev)
 	} else if (IS_MOBILE(dev)) {
 		uint32_t dcc;
 
+		/* Try to make sure MCHBAR is enabled before poking at it */
+		need_disable = intel_setup_mchbar(dev);
+
 		/* On mobile 9xx chipsets, channel interleave by the CPU is
 		 * determined by DCC.  For single-channel, neither the CPU
 		 * nor the GPU do swizzling.  For dual channel interleaved,
@@ -140,6 +283,8 @@ i915_gem_detect_bit_6_swizzle(struct drm_device *dev)
 			swizzle_x = I915_BIT_6_SWIZZLE_UNKNOWN;
 			swizzle_y = I915_BIT_6_SWIZZLE_UNKNOWN;
 		}
+
+		intel_teardown_mchbar(dev, need_disable);
 	} else {
 		/* The 965, G33, and newer, have a very flexible memory
 		 * configuration.  It will enable dual-channel mode
-- 
1.5.6.3

