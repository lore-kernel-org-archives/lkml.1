Return-Path: <linux-kernel-owner+w=401wt.eu-S1757142AbZJBBuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142AbZJBBuZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756412AbZJBBuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:50:23 -0400
Received: from kroah.org ([198.145.64.141]:33208 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756108AbZJBBdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:33:22 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:16 2009
Message-Id: <20091002012416.152671060@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:16:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Keith Packard <keithp@keithp.com>, Zhao Yakui <yakui.zhao@intel.com>,
       Eric Anholt <eric@anholt.net>
Subject: [064/136] drm/I915: Use the CRT DDC to get the EDID for DVI-connector on Mac
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=drm-i915-use-the-crt-ddc-to-get-the-edid-for-dvi-connector-on-mac.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Keith Packard <keithp@keithp.com>

commit 57cdaf90f5f607eb029356074fefb66c9b1c0659 upstream.

mac Mini's have a single DDC line on the DVI connector, shared between the
analog link and the digital link. So, if DDC isn't detected on GPIOE (the
usual SDVO DDC link), try GPIOA (the usual VGA DDC link) when there isn't a
VGA monitor connected.

Signed-off-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_sdvo.c |   96 +++++++++++++++++++++++++++++---------
 1 file changed, 74 insertions(+), 22 deletions(-)

--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -114,6 +114,9 @@ struct intel_sdvo_priv {
 	/* DDC bus used by this SDVO output */
 	uint8_t ddc_bus;
 
+	/* Mac mini hack -- use the same DDC as the analog connector */
+	struct i2c_adapter *analog_ddc_bus;
+
 	int save_sdvo_mult;
 	u16 save_active_outputs;
 	struct intel_sdvo_dtd save_input_dtd_1, save_input_dtd_2;
@@ -1478,6 +1481,36 @@ intel_sdvo_multifunc_encoder(struct inte
 	return (caps > 1);
 }
 
+static struct drm_connector *
+intel_find_analog_connector(struct drm_device *dev)
+{
+	struct drm_connector *connector;
+	struct intel_output *intel_output;
+
+	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
+		intel_output = to_intel_output(connector);
+		if (intel_output->type == INTEL_OUTPUT_ANALOG)
+			return connector;
+	}
+	return NULL;
+}
+
+static int
+intel_analog_is_connected(struct drm_device *dev)
+{
+	struct drm_connector *analog_connector;
+	analog_connector = intel_find_analog_connector(dev);
+
+	if (!analog_connector)
+		return false;
+
+	if (analog_connector->funcs->detect(analog_connector) ==
+			connector_status_disconnected)
+		return false;
+
+	return true;
+}
+
 enum drm_connector_status
 intel_sdvo_hdmi_sink_detect(struct drm_connector *connector, u16 response)
 {
@@ -1488,6 +1521,15 @@ intel_sdvo_hdmi_sink_detect(struct drm_c
 
 	edid = drm_get_edid(&intel_output->base,
 			    intel_output->ddc_bus);
+
+	/* when there is no edid and no monitor is connected with VGA
+	 * port, try to use the CRT ddc to read the EDID for DVI-connector
+	 */
+	if (edid == NULL &&
+	    sdvo_priv->analog_ddc_bus &&
+	    !intel_analog_is_connected(intel_output->base.dev))
+		edid = drm_get_edid(&intel_output->base,
+				    sdvo_priv->analog_ddc_bus);
 	if (edid != NULL) {
 		/* Don't report the output as connected if it's a DVI-I
 		 * connector with a non-digital EDID coming out.
@@ -1540,31 +1582,32 @@ static enum drm_connector_status intel_s
 static void intel_sdvo_get_ddc_modes(struct drm_connector *connector)
 {
 	struct intel_output *intel_output = to_intel_output(connector);
+	struct intel_sdvo_priv *sdvo_priv = intel_output->dev_priv;
+	int num_modes;
 
 	/* set the bus switch and get the modes */
-	intel_ddc_get_modes(intel_output);
+	num_modes = intel_ddc_get_modes(intel_output);
 
-#if 0
-	struct drm_device *dev = encoder->dev;
-	struct drm_i915_private *dev_priv = dev->dev_private;
-	/* Mac mini hack.  On this device, I get DDC through the analog, which
-	 * load-detects as disconnected.  I fail to DDC through the SDVO DDC,
-	 * but it does load-detect as connected.  So, just steal the DDC bits
-	 * from analog when we fail at finding it the right way.
+	/*
+	 * Mac mini hack.  On this device, the DVI-I connector shares one DDC
+	 * link between analog and digital outputs. So, if the regular SDVO
+	 * DDC fails, check to see if the analog output is disconnected, in
+	 * which case we'll look there for the digital DDC data.
 	 */
-	crt = xf86_config->output[0];
-	intel_output = crt->driver_private;
-	if (intel_output->type == I830_OUTPUT_ANALOG &&
-	    crt->funcs->detect(crt) == XF86OutputStatusDisconnected) {
-		I830I2CInit(pScrn, &intel_output->pDDCBus, GPIOA, "CRTDDC_A");
-		edid_mon = xf86OutputGetEDID(crt, intel_output->pDDCBus);
-		xf86DestroyI2CBusRec(intel_output->pDDCBus, true, true);
-	}
-	if (edid_mon) {
-		xf86OutputSetEDID(output, edid_mon);
-		modes = xf86OutputGetEDIDModes(output);
+	if (num_modes == 0 &&
+	    sdvo_priv->analog_ddc_bus &&
+	    !intel_analog_is_connected(intel_output->base.dev)) {
+		struct i2c_adapter *digital_ddc_bus;
+
+		/* Switch to the analog ddc bus and try that
+		 */
+		digital_ddc_bus = intel_output->ddc_bus;
+		intel_output->ddc_bus = sdvo_priv->analog_ddc_bus;
+
+		(void) intel_ddc_get_modes(intel_output);
+
+		intel_output->ddc_bus = digital_ddc_bus;
 	}
-#endif
 }
 
 /**
@@ -1748,6 +1791,8 @@ static void intel_sdvo_destroy(struct dr
 		intel_i2c_destroy(intel_output->i2c_bus);
 	if (intel_output->ddc_bus)
 		intel_i2c_destroy(intel_output->ddc_bus);
+	if (sdvo_priv->analog_ddc_bus)
+		intel_i2c_destroy(sdvo_priv->analog_ddc_bus);
 
 	if (sdvo_priv->sdvo_lvds_fixed_mode != NULL)
 		drm_mode_destroy(connector->dev,
@@ -2074,10 +2119,15 @@ bool intel_sdvo_init(struct drm_device *
 	}
 
 	/* setup the DDC bus. */
-	if (output_device == SDVOB)
+	if (output_device == SDVOB) {
 		intel_output->ddc_bus = intel_i2c_create(dev, GPIOE, "SDVOB DDC BUS");
-	else
+		sdvo_priv->analog_ddc_bus = intel_i2c_create(dev, GPIOA,
+						"SDVOB/VGA DDC BUS");
+	} else {
 		intel_output->ddc_bus = intel_i2c_create(dev, GPIOE, "SDVOC DDC BUS");
+		sdvo_priv->analog_ddc_bus = intel_i2c_create(dev, GPIOA,
+						"SDVOC/VGA DDC BUS");
+	}
 
 	if (intel_output->ddc_bus == NULL)
 		goto err_i2c;
@@ -2143,6 +2193,8 @@ bool intel_sdvo_init(struct drm_device *
 	return true;
 
 err_i2c:
+	if (sdvo_priv->analog_ddc_bus != NULL)
+		intel_i2c_destroy(sdvo_priv->analog_ddc_bus);
 	if (intel_output->ddc_bus != NULL)
 		intel_i2c_destroy(intel_output->ddc_bus);
 	if (intel_output->i2c_bus != NULL)


