Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872Ab0BSRSk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:18:40 -0500
Received: from kroah.org ([198.145.64.141]:57374 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754286Ab0BSRAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:00:12 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:33 2010
Message-Id: <20100219163233.279165708@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:29:06 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eric Anholt <eric@anholt.net>, maximilian attems <max@stro.at>
Subject: [13/93] drm/i915: Fix DDC on some systems by clearing BIOS GMBUS setup.
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Anholt <eric@anholt.net>

commit f0217c42c9ab3d772e543f635ce628b9478f70b6 upstream.

This is a sync of a fix I made in the old UMS code.  If the BIOS uses
the GMBUS and doesn't clear that setup, then our bit-banging I2C can
fail, leading to monitors not being detected.

Signed-off-by: Eric Anholt <eric@anholt.net>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_reg.h     |   14 ++++++++++++++
 drivers/gpu/drm/i915/i915_suspend.c |    5 ++++-
 drivers/gpu/drm/i915/intel_drv.h    |    2 ++
 drivers/gpu/drm/i915/intel_i2c.c    |   19 +++++++++++++++++++
 4 files changed, 39 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -405,6 +405,13 @@
 # define GPIO_DATA_VAL_IN		(1 << 12)
 # define GPIO_DATA_PULLUP_DISABLE	(1 << 13)
 
+#define GMBUS0			0x5100
+#define GMBUS1			0x5104
+#define GMBUS2			0x5108
+#define GMBUS3			0x510c
+#define GMBUS4			0x5110
+#define GMBUS5			0x5120
+
 /*
  * Clock control & power management
  */
@@ -2153,6 +2160,13 @@
 #define PCH_GPIOE               0xc5020
 #define PCH_GPIOF               0xc5024
 
+#define PCH_GMBUS0		0xc5100
+#define PCH_GMBUS1		0xc5104
+#define PCH_GMBUS2		0xc5108
+#define PCH_GMBUS3		0xc510c
+#define PCH_GMBUS4		0xc5110
+#define PCH_GMBUS5		0xc5120
+
 #define PCH_DPLL_A              0xc6014
 #define PCH_DPLL_B              0xc6018
 
--- a/drivers/gpu/drm/i915/i915_suspend.c
+++ b/drivers/gpu/drm/i915/i915_suspend.c
@@ -27,7 +27,7 @@
 #include "drmP.h"
 #include "drm.h"
 #include "i915_drm.h"
-#include "i915_drv.h"
+#include "intel_drv.h"
 
 static bool i915_pipe_enabled(struct drm_device *dev, enum pipe pipe)
 {
@@ -846,6 +846,9 @@ int i915_restore_state(struct drm_device
 	for (i = 0; i < 3; i++)
 		I915_WRITE(SWF30 + (i << 2), dev_priv->saveSWF2[i]);
 
+	/* I2C state */
+	intel_i2c_reset_gmbus(dev);
+
 	return 0;
 }
 
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -134,6 +134,8 @@ void intel_i2c_destroy(struct i2c_adapte
 int intel_ddc_get_modes(struct intel_output *intel_output);
 extern bool intel_ddc_probe(struct intel_output *intel_output);
 void intel_i2c_quirk_set(struct drm_device *dev, bool enable);
+void intel_i2c_reset_gmbus(struct drm_device *dev);
+
 extern void intel_crt_init(struct drm_device *dev);
 extern void intel_hdmi_init(struct drm_device *dev, int sdvox_reg);
 extern bool intel_sdvo_init(struct drm_device *dev, int output_device);
--- a/drivers/gpu/drm/i915/intel_i2c.c
+++ b/drivers/gpu/drm/i915/intel_i2c.c
@@ -118,6 +118,23 @@ static void set_data(void *data, int sta
 	udelay(I2C_RISEFALL_TIME); /* wait for the line to change state */
 }
 
+/* Clears the GMBUS setup.  Our driver doesn't make use of the GMBUS I2C
+ * engine, but if the BIOS leaves it enabled, then that can break our use
+ * of the bit-banging I2C interfaces.  This is notably the case with the
+ * Mac Mini in EFI mode.
+ */
+void
+intel_i2c_reset_gmbus(struct drm_device *dev)
+{
+	struct drm_i915_private *dev_priv = dev->dev_private;
+
+	if (IS_IGDNG(dev)) {
+		I915_WRITE(PCH_GMBUS0, 0);
+	} else {
+		I915_WRITE(GMBUS0, 0);
+	}
+}
+
 /**
  * intel_i2c_create - instantiate an Intel i2c bus using the specified GPIO reg
  * @dev: DRM device
@@ -168,6 +185,8 @@ struct i2c_adapter *intel_i2c_create(str
 	if(i2c_bit_add_bus(&chan->adapter))
 		goto out_free;
 
+	intel_i2c_reset_gmbus(dev);
+
 	/* JJJ:  raise SCL and SDA? */
 	intel_i2c_quirk_set(dev, true);
 	set_data(chan, 1);


