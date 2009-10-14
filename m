Return-Path: <linux-kernel-owner+w=401wt.eu-S1760532AbZJNVX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760532AbZJNVX5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 17:23:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758024AbZJNVX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 17:23:56 -0400
Received: from outbound-mail-156.bluehost.com ([67.222.39.36]:57013 "HELO
	outbound-mail-156.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757266AbZJNVXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 17:23:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:X-Identified-User;
	b=jPc8B6E4aoZHd7NqyoAQT0SVq5bLVIqVR8ThijOb7dCLjkV2OyegVP96Cdt7iu99VAayTdJc3jr/206o5dhyG/Kvnk2jZIIbDBBpw5oiaD2Ox3PN+XhLycbMT6bCGBFG;
Date: Wed, 14 Oct 2009 14:22:52 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Theodore Tso <tytso@mit.edu>, "Carlos R. Mafra" <crmafra2@gmail.com>,
       Eric Anholt <eric@anholt.net>, linux-kernel@vger.kernel.org,
       Keith Packard <keithp@keithp.com>,
       Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: 2.6.32 regression (bisected): Video tearing/glitching with T400
 laptops
Message-ID: <20091014142252.009d03a5@jbarnes-g45>
In-Reply-To: <20091013121426.35f409ff@jbarnes-g45>
References: <E1Mtqnb-0002x7-TJ@closure.thunk.org>
	<20091008103620.5e5aae66@jbarnes-g45>
	<20091010204106.GA8251@mit.edu>
	<20091012095438.1e82b54f@jbarnes-g45>
	<20091012184651.GA4603@Pilar.aei.mpg.de>
	<20091012120510.16bd1194@jbarnes-g45>
	<20091013023146.GA8414@mit.edu>
	<20091013100135.2b3d914f@jbarnes-g45>
	<20091013190055.GI8175@mit.edu>
	<20091013121426.35f409ff@jbarnes-g45>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/_TvCOQ4bUwcwU6U9aAj5wVz"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/_TvCOQ4bUwcwU6U9aAj5wVz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tue, 13 Oct 2009 12:14:26 -0700
Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> According to the chipset team that form of display corruption is
> likely related to RAM self-refresh... Sounds like the display plane
> isn't getting its memory requests serviced fast enough when in
> self-refresh mode, which might mean we have to program the
> self-refresh watermarks more aggressively on GM45.

Ok, like any good bug there was more than one thing wrong:
  - we weren't setting up a fence for the object before enabling FBC.
    Chris caught this and posted a patch to
    intel-gfx@lists.freedesktop.org titled "drm/i915: Install a fence
    register for fbc on g4x" (attached for convenience)
  - turns out we *do* need to set watermarks on G4x, despite some hw
    documentation indicating otherwise, patch for that attached

Hopefully with these two you'll have a solid display and some power
saving!

-- 
Jesse Barnes, Intel Open Source Technology Center

--MP_/_TvCOQ4bUwcwU6U9aAj5wVz
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=i915-g4x-watermarks-hack.patch

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index a0f6bbe..ed11591 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -1047,7 +1047,7 @@ static void g4x_enable_fbc(struct drm_crtc *crtc, unsigned long interval)
 	dev_priv->cfb_fence = obj_priv->fence_reg;
 	dev_priv->cfb_plane = intel_crtc->plane;
 
-	dpfc_ctl = plane | DPFC_SR_EN | DPFC_CTL_LIMIT_1X;
+	dpfc_ctl = plane | DPFC_CTL_LIMIT_1X;
 	if (obj_priv->tiling_mode != I915_TILING_NONE) {
 		dpfc_ctl |= DPFC_CTL_FENCE_EN | dev_priv->cfb_fence;
 		I915_WRITE(DPFC_CHICKEN, DPFC_HT_MODIFY);
@@ -1055,14 +1055,13 @@ static void g4x_enable_fbc(struct drm_crtc *crtc, unsigned long interval)
 		I915_WRITE(DPFC_CHICKEN, ~DPFC_HT_MODIFY);
 	}
 
-	I915_WRITE(DPFC_CONTROL, dpfc_ctl);
 	I915_WRITE(DPFC_RECOMP_CTL, DPFC_RECOMP_STALL_EN |
 		   (stall_watermark << DPFC_RECOMP_STALL_WM_SHIFT) |
 		   (interval << DPFC_RECOMP_TIMER_COUNT_SHIFT));
 	I915_WRITE(DPFC_FENCE_YOFF, crtc->y);
 
 	/* enable it... */
-	I915_WRITE(DPFC_CONTROL, I915_READ(DPFC_CONTROL) | DPFC_CTL_EN);
+	I915_WRITE(DPFC_CONTROL, dpfc_ctl | DPFC_CTL_EN);
 
 	DRM_DEBUG("enabled fbc on plane %d\n", intel_crtc->plane);
 }
@@ -2443,6 +2442,10 @@ static void g4x_update_wm(struct drm_device *dev, int unused, int unused2,
 	else
 		fw_blc_self &= ~FW_BLC_SELF_EN;
 	I915_WRITE(FW_BLC_SELF, fw_blc_self);
+
+	I915_WRITE(DSPFW1, (64 << 23) | (32 << 16) | (32 << 8) | (32 << 0));
+	I915_WRITE(DSPFW2, (32 << 8) | (32 << 0));
+	I915_WRITE(DSPFW3, 32 << 24);
 }
 
 static void i965_update_wm(struct drm_device *dev, int unused, int unused2,

--MP_/_TvCOQ4bUwcwU6U9aAj5wVz
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=i915-install-fence.patch

Received: from virtuous by box514.bluehost.com with local-bsmtp (Exim 4.69)
	(envelope-from <chris@chris-wilson.co.uk>)
	id 1My9I5-000222-1X
	for jbarnes@virtuousgeek.org; Wed, 14 Oct 2009 13:13:41 -0600
X-Spam-Checker-Version: SpamAssassin 3.2.5 (2008-06-10) on box514.bluehost.com
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED
	shortcircuit=no autolearn=ham version=3.2.5
Received: from mga05.intel.com ([192.55.52.89] helo=fmsmga101.fm.intel.com)
	by box514.bluehost.com with esmtp (Exim 4.69)
	(envelope-from <chris@chris-wilson.co.uk>)
	id 1My9I4-0001zV-9H
	for jbarnes@virtuousgeek.org; Wed, 14 Oct 2009 13:13:40 -0600
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP; 14 Oct 2009 12:07:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,560,1249282800"; 
   d="scan'208";a="736384260"
Received: from unknown (HELO localhost.localdomain) ([10.255.17.79])
  by fmsmga001.fm.intel.com with ESMTP; 14 Oct 2009 12:16:28 -0700
From: Chris Wilson <chris@chris-wilson.co.uk>
To: intel-gfx@lists.freedesktop.org
Cc: Chris Wilson <chris@chris-wilson.co.uk>, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH] drm/i915: Install a fence register for fbc on g4x
Date: Wed, 14 Oct 2009 20:12:46 +0100
Message-Id: <1255547566-9426-1-git-send-email-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 1.6.4.3
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:program running on server}

To enable framebuffer compression on a g4x, we not only need the buffer
to tiled (X only), we also need to hold a fence register for the buffer.
Currently we only install a fence register for pre-i965s when setting up
the scanout buffer. Rather than adding some convoluted logic to
g4x_enable_fbc() to acquire a fence register, and perhaps to
g4x_disable_fbc() to release it again, we can extend the acquisition
during setup to all chipsets.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 drivers/gpu/drm/i915/intel_display.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 1a40b9a..9dfb82f 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -1262,9 +1262,11 @@ intel_pipe_set_base(struct drm_crtc *crtc, int x, int y,
 		return ret;
 	}
 
-	/* Pre-i965 needs to install a fence for tiled scan-out */
-	if (!IS_I965G(dev) &&
-	    obj_priv->fence_reg == I915_FENCE_REG_NONE &&
+	/* Install a fence for tiled scan-out. Pre-i965 always needs a fence,
+	 * whereas 965+ only requires a fence if using framebuffer compression.
+	 * For simplicity, we always install a fence as the cost is not that onerous.
+	 */
+	if (obj_priv->fence_reg == I915_FENCE_REG_NONE &&
 	    obj_priv->tiling_mode != I915_TILING_NONE) {
 		ret = i915_gem_object_get_fence_reg(obj);
 		if (ret != 0) {
-- 
1.6.4.3



--MP_/_TvCOQ4bUwcwU6U9aAj5wVz--
