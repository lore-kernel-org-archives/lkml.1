Return-Path: <linux-kernel-owner+w=401wt.eu-S1752411AbZHJFOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411AbZHJFOW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 01:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751654AbZHJFOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 01:14:21 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36847 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751523AbZHJFOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 01:14:21 -0400
Date: Mon, 10 Aug 2009 15:14:13 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ma Ling <ling.ma@intel.com>, Eric Anholt <eric@anholt.net>,
       Zhao Yakui <yakui.zhao@intel.com>
Subject: linux-next: manual merge of the drm tree with the  tree
Message-Id: <20090810151413.f3e7a08f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

Today's linux-next merge of the drm tree got a conflict in
drivers/gpu/drm/i915/intel_sdvo.c between commit
fb7a46f3cc7d7dcf7c5edb3a38c84e3f730d7adb ("drm/i915: Choose real sdvo
output according to result from detection") from Linus' tree and commit
8a4c47f346cc7a12d0897c05eb3cc1add26b487f ("drm: Remove the unused prefix
in DRM_DEBUG_KMS/DRIVER/MODE") from the drm tree.

I fixed it up (see below) and can carry the fix as necessary.  This fix
may not be correct, so it would be better if you could fix it in the drm
tree by merging Linus' tree.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/i915/intel_sdvo.c
index 5371d93,abef69c..0000000
--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@@ -1519,7 -1459,7 +1518,7 @@@ static enum drm_connector_status intel_
  	intel_sdvo_write_cmd(intel_output, SDVO_CMD_GET_ATTACHED_DISPLAYS, NULL, 0);
  	status = intel_sdvo_read_response(intel_output, &response, 2);
  
- 	DRM_DEBUG("SDVO response %d %d\n", response & 0xff, response >> 8);
 -	DRM_DEBUG_KMS("SDVO response %d %d\n", response[0], response[1]);
++	DRM_DEBUG_KMS("SDVO response %d %d\n", response & 0xff, response >> 8);
  
  	if (status != SDVO_CMD_STATUS_SUCCESS)
  		return connector_status_unknown;
@@@ -1931,93 -1865,6 +1930,92 @@@ intel_sdvo_get_slave_addr(struct drm_de
  		return 0x72;
  }
  
 +static bool
 +intel_sdvo_output_setup(struct intel_output *intel_output, uint16_t flags)
 +{
 +	struct drm_connector *connector = &intel_output->base;
 +	struct drm_encoder *encoder = &intel_output->enc;
 +	struct intel_sdvo_priv *sdvo_priv = intel_output->dev_priv;
 +	bool ret = true, registered = false;
 +
 +	sdvo_priv->is_tv = false;
 +	intel_output->needs_tv_clock = false;
 +	sdvo_priv->is_lvds = false;
 +
 +	if (device_is_registered(&connector->kdev)) {
 +		drm_sysfs_connector_remove(connector);
 +		registered = true;
 +	}
 +
 +	if (flags &
 +	    (SDVO_OUTPUT_TMDS0 | SDVO_OUTPUT_TMDS1)) {
 +		if (sdvo_priv->caps.output_flags & SDVO_OUTPUT_TMDS0)
 +			sdvo_priv->controlled_output = SDVO_OUTPUT_TMDS0;
 +		else
 +			sdvo_priv->controlled_output = SDVO_OUTPUT_TMDS1;
 +
 +		encoder->encoder_type = DRM_MODE_ENCODER_TMDS;
 +		connector->connector_type = DRM_MODE_CONNECTOR_DVID;
 +
 +		if (intel_sdvo_get_supp_encode(intel_output,
 +					       &sdvo_priv->encode) &&
 +		    intel_sdvo_get_digital_encoding_mode(intel_output) &&
 +		    sdvo_priv->is_hdmi) {
 +			/* enable hdmi encoding mode if supported */
 +			intel_sdvo_set_encode(intel_output, SDVO_ENCODE_HDMI);
 +			intel_sdvo_set_colorimetry(intel_output,
 +						   SDVO_COLORIMETRY_RGB256);
 +			connector->connector_type = DRM_MODE_CONNECTOR_HDMIA;
 +		}
 +	} else if (flags & SDVO_OUTPUT_SVID0) {
 +
 +		sdvo_priv->controlled_output = SDVO_OUTPUT_SVID0;
 +		encoder->encoder_type = DRM_MODE_ENCODER_TVDAC;
 +		connector->connector_type = DRM_MODE_CONNECTOR_SVIDEO;
 +		sdvo_priv->is_tv = true;
 +		intel_output->needs_tv_clock = true;
 +	} else if (flags & SDVO_OUTPUT_RGB0) {
 +
 +		sdvo_priv->controlled_output = SDVO_OUTPUT_RGB0;
 +		encoder->encoder_type = DRM_MODE_ENCODER_DAC;
 +		connector->connector_type = DRM_MODE_CONNECTOR_VGA;
 +	} else if (flags & SDVO_OUTPUT_RGB1) {
 +
 +		sdvo_priv->controlled_output = SDVO_OUTPUT_RGB1;
 +		encoder->encoder_type = DRM_MODE_ENCODER_DAC;
 +		connector->connector_type = DRM_MODE_CONNECTOR_VGA;
 +	} else if (flags & SDVO_OUTPUT_LVDS0) {
 +
 +		sdvo_priv->controlled_output = SDVO_OUTPUT_LVDS0;
 +		encoder->encoder_type = DRM_MODE_ENCODER_LVDS;
 +		connector->connector_type = DRM_MODE_CONNECTOR_LVDS;
 +		sdvo_priv->is_lvds = true;
 +	} else if (flags & SDVO_OUTPUT_LVDS1) {
 +
 +		sdvo_priv->controlled_output = SDVO_OUTPUT_LVDS1;
 +		encoder->encoder_type = DRM_MODE_ENCODER_LVDS;
 +		connector->connector_type = DRM_MODE_CONNECTOR_LVDS;
 +		sdvo_priv->is_lvds = true;
 +	} else {
 +
 +		unsigned char bytes[2];
 +
 +		sdvo_priv->controlled_output = 0;
 +		memcpy(bytes, &sdvo_priv->caps.output_flags, 2);
- 		DRM_DEBUG_KMS(I915_SDVO,
- 				"%s: Unknown SDVO output type (0x%02x%02x)\n",
++		DRM_DEBUG_KMS("%s: Unknown SDVO output type (0x%02x%02x)\n",
 +				  SDVO_NAME(sdvo_priv),
 +				  bytes[0], bytes[1]);
 +		ret = false;
 +	}
 +
 +	if (ret && registered)
 +		ret = drm_sysfs_connector_add(connector) == 0 ? true : false;
 +
 +
 +	return ret;
 +
 +}
 +
  bool intel_sdvo_init(struct drm_device *dev, int output_device)
  {
  	struct drm_connector *connector;
@@@ -2075,12 -1923,75 +2072,12 @@@
  	intel_output->ddc_bus->algo = &intel_sdvo_i2c_bit_algo;
  
  	/* In defaut case sdvo lvds is false */
 -	sdvo_priv->is_lvds = false;
  	intel_sdvo_get_capabilities(intel_output, &sdvo_priv->caps);
  
 -	if (sdvo_priv->caps.output_flags &
 -	    (SDVO_OUTPUT_TMDS0 | SDVO_OUTPUT_TMDS1)) {
 -		if (sdvo_priv->caps.output_flags & SDVO_OUTPUT_TMDS0)
 -			sdvo_priv->controlled_output = SDVO_OUTPUT_TMDS0;
 -		else
 -			sdvo_priv->controlled_output = SDVO_OUTPUT_TMDS1;
 -
 -		encoder_type = DRM_MODE_ENCODER_TMDS;
 -		connector_type = DRM_MODE_CONNECTOR_DVID;
 -
 -		if (intel_sdvo_get_supp_encode(intel_output,
 -					       &sdvo_priv->encode) &&
 -		    intel_sdvo_get_digital_encoding_mode(intel_output) &&
 -		    sdvo_priv->is_hdmi) {
 -			/* enable hdmi encoding mode if supported */
 -			intel_sdvo_set_encode(intel_output, SDVO_ENCODE_HDMI);
 -			intel_sdvo_set_colorimetry(intel_output,
 -						   SDVO_COLORIMETRY_RGB256);
 -			connector_type = DRM_MODE_CONNECTOR_HDMIA;
 -		}
 -	}
 -	else if (sdvo_priv->caps.output_flags & SDVO_OUTPUT_SVID0)
 -	{
 -		sdvo_priv->controlled_output = SDVO_OUTPUT_SVID0;
 -		encoder_type = DRM_MODE_ENCODER_TVDAC;
 -		connector_type = DRM_MODE_CONNECTOR_SVIDEO;
 -		sdvo_priv->is_tv = true;
 -		intel_output->needs_tv_clock = true;
 -	}
 -	else if (sdvo_priv->caps.output_flags & SDVO_OUTPUT_RGB0)
 -	{
 -		sdvo_priv->controlled_output = SDVO_OUTPUT_RGB0;
 -		encoder_type = DRM_MODE_ENCODER_DAC;
 -		connector_type = DRM_MODE_CONNECTOR_VGA;
 -	}
 -	else if (sdvo_priv->caps.output_flags & SDVO_OUTPUT_RGB1)
 -	{
 -		sdvo_priv->controlled_output = SDVO_OUTPUT_RGB1;
 -		encoder_type = DRM_MODE_ENCODER_DAC;
 -		connector_type = DRM_MODE_CONNECTOR_VGA;
 -	}
 -	else if (sdvo_priv->caps.output_flags & SDVO_OUTPUT_LVDS0)
 -	{
 -		sdvo_priv->controlled_output = SDVO_OUTPUT_LVDS0;
 -		encoder_type = DRM_MODE_ENCODER_LVDS;
 -		connector_type = DRM_MODE_CONNECTOR_LVDS;
 -		sdvo_priv->is_lvds = true;
 -	}
 -	else if (sdvo_priv->caps.output_flags & SDVO_OUTPUT_LVDS1)
 -	{
 -		sdvo_priv->controlled_output = SDVO_OUTPUT_LVDS1;
 -		encoder_type = DRM_MODE_ENCODER_LVDS;
 -		connector_type = DRM_MODE_CONNECTOR_LVDS;
 -		sdvo_priv->is_lvds = true;
 -	}
 -	else
 -	{
 -		unsigned char bytes[2];
 -
 -		sdvo_priv->controlled_output = 0;
 -		memcpy (bytes, &sdvo_priv->caps.output_flags, 2);
 -		DRM_DEBUG_KMS("%s: Unknown SDVO output type (0x%02x%02x)\n",
 -				  SDVO_NAME(sdvo_priv),
 -				  bytes[0], bytes[1]);
 -		encoder_type = DRM_MODE_ENCODER_NONE;
 -		connector_type = DRM_MODE_CONNECTOR_Unknown;
 +	if (intel_sdvo_output_setup(intel_output,
 +				    sdvo_priv->caps.output_flags) != true) {
- 		DRM_DEBUG("SDVO output failed to setup on SDVO%c\n",
++		DRM_DEBUG_KMS("SDVO output failed to setup on SDVO%c\n",
 +			  output_device == SDVOB ? 'B' : 'C');
  		goto err_i2c;
  	}
  
