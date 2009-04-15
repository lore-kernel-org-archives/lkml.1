Return-Path: <linux-kernel-owner+w=401wt.eu-S1755950AbZDOUqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbZDOUqs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 16:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbZDOUqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 16:46:39 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:44518 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbZDOUqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 16:46:38 -0400
Date: Wed, 15 Apr 2009 21:46:36 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: intel-gfx@lists.freedesktop.org
Cc: acpi-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] i915: Register ACPI video even when not modesetting
Message-ID: <20090415204636.GA32365@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ACPI video driver defers registration to the i915 driver if the 
system supports opregion-mediated backlight control. This registration 
was only being performed in the KMS case. Ensure it's done even if we 
don't have modesetting enabled.

Signed-off-by: Matthew Garrett <mjg@redhat.com>

diff --git a/drivers/gpu/drm/i915/i915_opregion.c b/drivers/gpu/drm/i915/i915_opregion.c
index 6942772..8dc1fd3 100644
--- a/drivers/gpu/drm/i915/i915_opregion.c
+++ b/drivers/gpu/drm/i915/i915_opregion.c
@@ -370,11 +370,8 @@ int intel_opregion_init(struct drm_device *dev, int resume)
 	if (mboxes & MBOX_ACPI) {
 		DRM_DEBUG("Public ACPI methods supported\n");
 		opregion->acpi = base + OPREGION_ACPI_OFFSET;
-		if (drm_core_check_feature(dev, DRIVER_MODESET)) {
+		if (drm_core_check_feature(dev, DRIVER_MODESET))
 			intel_didl_outputs(dev);
-			if (!resume)
-				acpi_video_register();
-		}
 	} else {
 		DRM_DEBUG("Public ACPI methods not supported\n");
 		err = -ENOTSUPP;
@@ -391,6 +388,10 @@ int intel_opregion_init(struct drm_device *dev, int resume)
 		opregion->asle = base + OPREGION_ASLE_OFFSET;
 	}
 
+	if (!resume)
+		acpi_video_register();
+
+
 	/* Notify BIOS we are ready to handle ACPI video ext notifs.
 	 * Right now, all the events are handled by the ACPI video module.
 	 * We don't actually need to do anything with them. */

-- 
Matthew Garrett | mjg59@srcf.ucam.org
