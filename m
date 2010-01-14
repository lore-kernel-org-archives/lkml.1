Return-Path: <linux-kernel-owner+w=401wt.eu-S1753535Ab0ANUsJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab0ANUsJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 15:48:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043Ab0ANUsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 15:48:08 -0500
Received: from outbound-mail-158.bluehost.com ([67.222.39.38]:59320 "HELO
	outbound-mail-158.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751754Ab0ANUsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 15:48:07 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=pp/JC+y470UdZFSHm6syvrgYfTn+Mnz6zEpucAdIXYSyvbBEYmOyQS3wDklw1fzGhe4Bc1cAJDfXE1kafsCovNb3tdbF1AhmwuVvvEw98At7qWoq38u9cGtwUX8VS37B;
Date: Thu, 14 Jan 2010 12:48:02 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       airlied@linux.ie, eric@anholt.net, intel-gfx@lists.freedesktop.org
Subject: [PATCH] drm/i915: disable LVDS downclock by default
Message-ID: <20100114124802.025bbcae@jbarnes-piketon>
In-Reply-To: <20100114202803.GA1749@emergent.ellipticsemi.com>
References: <alpine.LFD.2.00.1001122139411.17145@localhost.localdomain>
	<84144f021001131303u56fa5470ua1c27dfef9f3de81@mail.gmail.com>
	<20100113133357.67f9df6d@jbarnes-piketon>
	<4B4E403C.1050509@cs.helsinki.fi>
	<20100113165530.2a7e7645@jbarnes-piketon>
	<4B4F6D5F.10008@cs.helsinki.fi>
	<20100114193118.GA1203@emergent.ellipticsemi.com>
	<84144f021001141218pa3cd71co76165532618145a8@mail.gmail.com>
	<20100114202803.GA1749@emergent.ellipticsemi.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many platform support this feature, and it can provide significant
power savings when the reduced refresh rate is low.  However, on some
platforms a secondary (reduced) timing is provided but not actually
supported by the hardware.  This results in undesirable flicker at
runtime.

So disable the feature by default, but allow users to opt-in to the
reduced clock behavior with a new module parameter, lvds_downclock,
that can be set to 1 to enable the feature.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>

--

Nick and Pekka, please try this out and reply with your Tested-by
(assuming it works, if not I'll fix it up).

Thanks,
Jesse

diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
index 66f7bac..46d8896 100644
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -45,6 +45,9 @@ module_param_named(fbpercrtc, i915_fbpercrtc, int, 0400);
 unsigned int i915_powersave = 1;
 module_param_named(powersave, i915_powersave, int, 0400);
 
+unsigned int i915_lvds_downclock = 0;
+module_param_named(lvds_downclock, i915_lvds_downclock, int, 0400);
+
 static struct drm_driver driver;
 
 #define INTEL_VGA_DEVICE(id, info) {		\
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 445c49c..5f781a7 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -722,6 +722,7 @@ extern struct drm_ioctl_desc i915_ioctls[];
 extern int i915_max_ioctl;
 extern unsigned int i915_fbpercrtc;
 extern unsigned int i915_powersave;
+extern unsigned int i915_lvds_downclock;
 
 extern void i915_save_display(struct drm_device *dev);
 extern void i915_restore_display(struct drm_device *dev);
diff --git a/drivers/gpu/drm/i915/intel_bios.c b/drivers/gpu/drm/i915/intel_bios.c
index f275677..b53c46f 100644
--- a/drivers/gpu/drm/i915/intel_bios.c
+++ b/drivers/gpu/drm/i915/intel_bios.c
@@ -197,7 +197,8 @@ parse_lfp_panel_data(struct drm_i915_private *dev_priv,
 		memset(temp_mode, 0, sizeof(*temp_mode));
 	}
 	kfree(temp_mode);
-	if (temp_downclock < panel_fixed_mode->clock) {
+	if (temp_downclock < panel_fixed_mode->clock &&
+	    i915_lvds_downclock) {
 		dev_priv->lvds_downclock_avail = 1;
 		dev_priv->lvds_downclock = temp_downclock;
 		DRM_DEBUG_KMS("LVDS downclock is found in VBT. ",
diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index 5041590..aa74e59 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -926,7 +926,8 @@ static void intel_find_lvds_downclock(struct drm_device *dev,
 		}
 	}
 	mutex_unlock(&dev->mode_config.mutex);
-	if (temp_downclock < panel_fixed_mode->clock) {
+	if (temp_downclock < panel_fixed_mode->clock &&
+	    i915_lvds_downclock) {
 		/* We found the downclock for LVDS. */
 		dev_priv->lvds_downclock_avail = 1;
 		dev_priv->lvds_downclock = temp_downclock;
