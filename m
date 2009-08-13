Return-Path: <linux-kernel-owner+w=401wt.eu-S1755925AbZHMUMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbZHMUMv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 16:12:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755892AbZHMT7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:59:23 -0400
Received: from kroah.org ([198.145.64.141]:41669 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755875AbZHMT7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:59:20 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:51:26 2009
Message-Id: <20090813195126.482792691@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:49:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eric Anholt <eric@anholt.net>
Subject: [patch 13/74] drm/i915: Save/restore cursor state on suspend/resume.
References: <20090813194935.985368088@mini.kroah.org>
Content-Disposition: inline; filename=drm-i915-save-restore-cursor-state-on-suspend-resume.patch
In-Reply-To: <20090813195705.GA22393@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Anholt <eric@anholt.net>

(cherry picked from commit 1fd1c624362819ecc36db2458c6a972c48ae92d6)

This may fix cursor corruption in X on resume, which would persist until
the cursor was hidden and then shown again.

V2: Also include the cursor control regs.

Signed-off-by: Eric Anholt <eric@anholt.net>
Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_drv.h     |    8 ++++++++
 drivers/gpu/drm/i915/i915_suspend.c |   20 ++++++++++++++++++++
 2 files changed, 28 insertions(+)

--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -285,6 +285,13 @@ typedef struct drm_i915_private {
 	u8 saveDACMASK;
 	u8 saveCR[37];
 	uint64_t saveFENCE[16];
+	u32 saveCURACNTR;
+	u32 saveCURAPOS;
+	u32 saveCURABASE;
+	u32 saveCURBCNTR;
+	u32 saveCURBPOS;
+	u32 saveCURBBASE;
+	u32 saveCURSIZE;
 
 	struct {
 		struct drm_mm gtt_space;
@@ -642,6 +649,7 @@ void i915_gem_detach_phys_object(struct 
 void i915_gem_free_all_phys_object(struct drm_device *dev);
 int i915_gem_object_get_pages(struct drm_gem_object *obj);
 void i915_gem_object_put_pages(struct drm_gem_object *obj);
+void i915_gem_release(struct drm_device * dev, struct drm_file *file_priv);
 
 /* i915_gem_tiling.c */
 void i915_gem_detect_bit_6_swizzle(struct drm_device *dev);
--- a/drivers/gpu/drm/i915/i915_suspend.c
+++ b/drivers/gpu/drm/i915/i915_suspend.c
@@ -295,6 +295,16 @@ int i915_save_state(struct drm_device *d
 	i915_save_palette(dev, PIPE_B);
 	dev_priv->savePIPEBSTAT = I915_READ(PIPEBSTAT);
 
+	/* Cursor state */
+	dev_priv->saveCURACNTR = I915_READ(CURACNTR);
+	dev_priv->saveCURAPOS = I915_READ(CURAPOS);
+	dev_priv->saveCURABASE = I915_READ(CURABASE);
+	dev_priv->saveCURBCNTR = I915_READ(CURBCNTR);
+	dev_priv->saveCURBPOS = I915_READ(CURBPOS);
+	dev_priv->saveCURBBASE = I915_READ(CURBBASE);
+	if (!IS_I9XX(dev))
+		dev_priv->saveCURSIZE = I915_READ(CURSIZE);
+
 	/* CRT state */
 	dev_priv->saveADPA = I915_READ(ADPA);
 
@@ -480,6 +490,16 @@ int i915_restore_state(struct drm_device
 	I915_WRITE(DSPBCNTR, dev_priv->saveDSPBCNTR);
 	I915_WRITE(DSPBADDR, I915_READ(DSPBADDR));
 
+	/* Cursor state */
+	I915_WRITE(CURAPOS, dev_priv->saveCURAPOS);
+	I915_WRITE(CURACNTR, dev_priv->saveCURACNTR);
+	I915_WRITE(CURABASE, dev_priv->saveCURABASE);
+	I915_WRITE(CURBPOS, dev_priv->saveCURBPOS);
+	I915_WRITE(CURBCNTR, dev_priv->saveCURBCNTR);
+	I915_WRITE(CURBBASE, dev_priv->saveCURBBASE);
+	if (!IS_I9XX(dev))
+		I915_WRITE(CURSIZE, dev_priv->saveCURSIZE);
+
 	/* CRT state */
 	I915_WRITE(ADPA, dev_priv->saveADPA);
 


