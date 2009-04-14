Return-Path: <linux-kernel-owner+w=401wt.eu-S1755450AbZDNPLN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450AbZDNPLN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 11:11:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755641AbZDNPKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 11:10:45 -0400
Received: from mail.southpole.se ([193.12.106.18]:37252 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754295AbZDNPKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 11:10:44 -0400
X-Greylist: delayed 1221 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Apr 2009 11:10:43 EDT
From: Jonas Bonn <jonas@southpole.se>
To: dri-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Jonas Bonn <jonas@southpole.se>
Subject: [PATCH] [drm] Determine type before initialising connector
Date: Tue, 14 Apr 2009 16:50:19 +0200
Message-Id: <1239720620-6082-1-git-send-email-jonas@southpole.se>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drm_connector_init sets both the connector type and the connector type_id
on the newly initialised connector.  As the connector type_id is coupled to
the connector type, the connector type cannot simply be modified on an
initialised connector.

This patch changes the order of operations on intel_sdvo_init so that the
type is determined before the connector is intialised.

This fixes a bug whereby the name card0-VGA-1 would be allocted to both a
CRT and an SDVO connector since the SDVO connector would be initialised
with type 'unknown' and hence have its type_id assigned from the wrong pool.

Signed-off-by: Jonas Bonn <jonas@southpole.se>
---
 drivers/gpu/drm/i915/intel_sdvo.c |   33 ++++++++++++++-------------------
 1 files changed, 14 insertions(+), 19 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_sdvo.c b/drivers/gpu/drm/i915/intel_sdvo.c
index 7b31f55..f2188eb 100644
--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -1658,17 +1658,9 @@ bool intel_sdvo_init(struct drm_device *dev, int output_device)
 		return false;
 	}
 
-	connector = &intel_output->base;
-
-	drm_connector_init(dev, connector, &intel_sdvo_connector_funcs,
-			   DRM_MODE_CONNECTOR_Unknown);
-	drm_connector_helper_add(connector, &intel_sdvo_connector_helper_funcs);
 	sdvo_priv = (struct intel_sdvo_priv *)(intel_output + 1);
 	intel_output->type = INTEL_OUTPUT_SDVO;
 
-	connector->interlace_allowed = 0;
-	connector->doublescan_allowed = 0;
-
 	/* setup the DDC bus. */
 	if (output_device == SDVOB)
 		i2cbus = intel_i2c_create(dev, GPIOE, "SDVOCTRL_E for SDVOB");
@@ -1676,7 +1668,7 @@ bool intel_sdvo_init(struct drm_device *dev, int output_device)
 		i2cbus = intel_i2c_create(dev, GPIOE, "SDVOCTRL_E for SDVOC");
 
 	if (!i2cbus)
-		goto err_connector;
+		goto err_inteloutput;
 
 	sdvo_priv->i2c_bus = i2cbus;
 
@@ -1692,7 +1684,6 @@ bool intel_sdvo_init(struct drm_device *dev, int output_device)
 	intel_output->i2c_bus = i2cbus;
 	intel_output->dev_priv = sdvo_priv;
 
-
 	/* Read the regs to test if we can talk to the device */
 	for (i = 0; i < 0x40; i++) {
 		if (!intel_sdvo_read_byte(intel_output, i, &ch[i])) {
@@ -1711,7 +1702,6 @@ bool intel_sdvo_init(struct drm_device *dev, int output_device)
 		else
 			sdvo_priv->controlled_output = SDVO_OUTPUT_TMDS1;
 
-		connector->display_info.subpixel_order = SubPixelHorizontalRGB;
 		encoder_type = DRM_MODE_ENCODER_TMDS;
 		connector_type = DRM_MODE_CONNECTOR_DVID;
 
@@ -1729,7 +1719,6 @@ bool intel_sdvo_init(struct drm_device *dev, int output_device)
 	else if (sdvo_priv->caps.output_flags & SDVO_OUTPUT_SVID0)
 	{
 		sdvo_priv->controlled_output = SDVO_OUTPUT_SVID0;
-		connector->display_info.subpixel_order = SubPixelHorizontalRGB;
 		encoder_type = DRM_MODE_ENCODER_TVDAC;
 		connector_type = DRM_MODE_CONNECTOR_SVIDEO;
 		sdvo_priv->is_tv = true;
@@ -1738,28 +1727,24 @@ bool intel_sdvo_init(struct drm_device *dev, int output_device)
 	else if (sdvo_priv->caps.output_flags & SDVO_OUTPUT_RGB0)
 	{
 		sdvo_priv->controlled_output = SDVO_OUTPUT_RGB0;
-		connector->display_info.subpixel_order = SubPixelHorizontalRGB;
 		encoder_type = DRM_MODE_ENCODER_DAC;
 		connector_type = DRM_MODE_CONNECTOR_VGA;
 	}
 	else if (sdvo_priv->caps.output_flags & SDVO_OUTPUT_RGB1)
 	{
 		sdvo_priv->controlled_output = SDVO_OUTPUT_RGB1;
-		connector->display_info.subpixel_order = SubPixelHorizontalRGB;
 		encoder_type = DRM_MODE_ENCODER_DAC;
 		connector_type = DRM_MODE_CONNECTOR_VGA;
 	}
 	else if (sdvo_priv->caps.output_flags & SDVO_OUTPUT_LVDS0)
 	{
 		sdvo_priv->controlled_output = SDVO_OUTPUT_LVDS0;
-		connector->display_info.subpixel_order = SubPixelHorizontalRGB;
 		encoder_type = DRM_MODE_ENCODER_LVDS;
 		connector_type = DRM_MODE_CONNECTOR_LVDS;
 	}
 	else if (sdvo_priv->caps.output_flags & SDVO_OUTPUT_LVDS1)
 	{
 		sdvo_priv->controlled_output = SDVO_OUTPUT_LVDS1;
-		connector->display_info.subpixel_order = SubPixelHorizontalRGB;
 		encoder_type = DRM_MODE_ENCODER_LVDS;
 		connector_type = DRM_MODE_CONNECTOR_LVDS;
 	}
@@ -1777,9 +1762,16 @@ bool intel_sdvo_init(struct drm_device *dev, int output_device)
 		goto err_i2c;
 	}
 
+	connector = &intel_output->base;
+	drm_connector_init(dev, connector, &intel_sdvo_connector_funcs,
+			   connector_type);
+	drm_connector_helper_add(connector, &intel_sdvo_connector_helper_funcs);
+	connector->interlace_allowed = 0;
+	connector->doublescan_allowed = 0;
+	connector->display_info.subpixel_order = SubPixelHorizontalRGB;
+
 	drm_encoder_init(dev, &intel_output->enc, &intel_sdvo_enc_funcs, encoder_type);
 	drm_encoder_helper_add(&intel_output->enc, &intel_sdvo_helper_funcs);
-	connector->connector_type = connector_type;
 
 	drm_mode_connector_attach_encoder(&intel_output->base, &intel_output->enc);
 	drm_sysfs_connector_add(connector);
@@ -1815,10 +1807,13 @@ bool intel_sdvo_init(struct drm_device *dev, int output_device)
 
 	return true;
 
-err_i2c:
-	intel_i2c_destroy(intel_output->i2c_bus);
+/*
 err_connector:
 	drm_connector_cleanup(connector);
+*/
+err_i2c:
+	intel_i2c_destroy(intel_output->i2c_bus);
+err_inteloutput:
 	kfree(intel_output);
 
 	return false;
-- 
1.6.0.4


