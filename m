Return-Path: <linux-kernel-owner+w=401wt.eu-S1752772AbZL2Juh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbZL2Juh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 04:50:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399AbZL2Jug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 04:50:36 -0500
Received: from lo.gmane.org ([80.91.229.12]:40582 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752716AbZL2Juf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 04:50:35 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Miguel Calleja <mcalleja1@telecable.es>
Subject: Re: Linux 2.6.33-rc2 - Blank screen for Intel KMS
Date: Tue, 29 Dec 2009 09:50:09 +0000 (UTC)
Message-ID: <hhcjch$5ns$1@ger.gmane.org>
References: <alpine.LFD.2.00.0912241350510.11961@localhost.localdomain>
	<hh2dl2$ler$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: cm-83-97-192-133.telecable.es
User-Agent: Pan/0.133 (House of Butterflies)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Fri, 25 Dec 2009 13:10:58 +0000, Miguel Calleja escribió:

> I've upgraded from 2.6.32 and I get a blank screen when the system is
> starting KMS. My motherboard is an Intel DG43NB with onboard video. I
> traced back to the patch that stopped working on my system and it is
> patch-2.6.32-git7. patch-2.6.32-git6 works fine.

I've bisected the kernel and have found that my problem is due to this 
commit:

commit fc816655236cd9da162356e96e74c7cfb0834d92

drm/i915: Don't set up HDMI ports that aren't in the BIOS device table.

author	Zhao Yakui <yakui.zhao@intel.com>	
	Tue, 24 Nov 2009 01:48:45 +0000 (09:48 +0800)
committer	Eric Anholt <eric@anholt.net>	
	Tue, 1 Dec 2009 00:41:48 +0000 (16:41 -0800)
Use the child device array to decide whether the given HDMI output should 
be
initialized. If the given HDMI port can't be found in child device array,
it is not present and won't be initialized.

Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
Signed-off-by: Eric Anholt <eric@anholt.net>

diff --git a/drivers/gpu/drm/i915/intel_hdmi.c  b/drivers/gpu/drm/i915/
intel_hdmi.c
index c33451a..2ff5d03 100644 (file)
--- a/drivers/gpu/drm/i915/intel_hdmi.c
+++ b/drivers/gpu/drm/i915/intel_hdmi.c
@@ -225,7 +225,52 @@ static const struct drm_encoder_funcs 
intel_hdmi_enc_funcs = {
        .destroy = intel_hdmi_enc_destroy,
 };
 
-
+/*
+ * Enumerate the child dev array parsed from VBT to check whether
+ * the given HDMI is present.
+ * If it is present, return 1.
+ * If it is not present, return false.
+ * If no child dev is parsed from VBT, it assumes that the given
+ * HDMI is present.
+ */
+int hdmi_is_present_in_vbt(struct drm_device *dev, int hdmi_reg)
+{
+       struct drm_i915_private *dev_priv = dev->dev_private;
+       struct child_device_config *p_child;
+       int i, hdmi_port, ret;
+
+       if (!dev_priv->child_dev_num)
+               return 1;
+
+       if (hdmi_reg == SDVOB)
+               hdmi_port = DVO_B;
+       else if (hdmi_reg == SDVOC)
+               hdmi_port = DVO_C;
+       else if (hdmi_reg == HDMIB)
+               hdmi_port = DVO_B;
+       else if (hdmi_reg == HDMIC)
+               hdmi_port = DVO_C;
+       else if (hdmi_reg == HDMID)
+               hdmi_port = DVO_D;
+       else
+               return 0;
+
+       ret = 0;
+       for (i = 0; i < dev_priv->child_dev_num; i++) {
+               p_child = dev_priv->child_dev + i;
+               /*
+                * If the device type is not HDMI, continue.
+                */
+               if (p_child->device_type != DEVICE_TYPE_HDMI)
+                       continue;
+               /* Find the HDMI port */
+               if (p_child->dvo_port == hdmi_port) {
+                       ret = 1;
+                       break;
+               }
+       }
+       return ret;
+}
 void intel_hdmi_init(struct drm_device *dev, int sdvox_reg)
 {
        struct drm_i915_private *dev_priv = dev->dev_private;
@@ -233,6 +278,10 @@ void intel_hdmi_init(struct drm_device *dev, int 
sdvox_reg)
        struct intel_output *intel_output;
        struct intel_hdmi_priv *hdmi_priv;
 
+       if (!hdmi_is_present_in_vbt(dev, sdvox_reg)) {
+               DRM_DEBUG_KMS("HDMI is not present. Ignored it \n");
+               return;
+       }
        intel_output = kcalloc(sizeof(struct intel_output) +
                               sizeof(struct intel_hdmi_priv), 1, 
GFP_KERNEL);
        if (!intel_output)

