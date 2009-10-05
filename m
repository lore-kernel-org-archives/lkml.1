Return-Path: <linux-kernel-owner+w=401wt.eu-S1754382AbZJEUsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382AbZJEUsO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 16:48:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754091AbZJEUsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 16:48:13 -0400
Received: from outbound-mail-14.bluehost.com ([69.89.18.114]:42424 "HELO
	outbound-mail-14.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754082AbZJEUsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 16:48:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=VefOA0NqLKCgu/ZdKwpLFkqhaG9oqeD/OlQElfAeko8pqQE5+tpoAhAy+It43uiVIwv+9HYo9qNffgWg5t/oLbebRtBlKtpkGBpNHxvAw7/oOLrisDoW+Z27WsFD64Sf;
Date: Mon, 5 Oct 2009 13:47:26 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Eric Anholt <eric@anholt.net>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.32 regression (bisected): Video tearing/glitching with T400
 laptops
Message-ID: <20091005134726.58370f89@jbarnes-g45>
In-Reply-To: <E1Mtqnb-0002x7-TJ@closure.thunk.org>
References: <E1Mtqnb-0002x7-TJ@closure.thunk.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Oct 2009 18:40:27 -0400
"Theodore Ts'o" <tytso@mit.edu> wrote:

> Hi, 
> 
> In recent kernels, my X display (running with a KMS-enabled X server)
> has been very jittery and with lots of glitching and tearing --- sorry
> if this isn't the correct technical term, not sure what it is --- on
> my T400 Lenovo laptop.   It seems related to what is on the desktop,
> and moving the mouse does seem to affect the rate and percentage of
> the screen which jitters --- which is enough to be very distracting,
> although I can still read the contents of the windows where the screen
> is tearing/glitching/flashing.
> 
> I bisected it down to this commit:
> 
> 74dff282237ea8c0a5df1afd8526eac4b6cee063 is the first bad commit
> commit 74dff282237ea8c0a5df1afd8526eac4b6cee063
> Author: Jesse Barnes <jbarnes@virtuousgeek.org>
> Date:   Mon Sep 14 15:39:40 2009 -0700
> 
>     drm/i915: framebuffer compression for GM45+
>     
>     Add support for framebuffer compression on GM45 and above.
> Removes some unnecessary I915_HAS_FBC checks as well (this is now
> part of the FBC display function).
>     
>     Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
>     Signed-off-by: Eric Anholt <eric@anholt.net>
> 
> ... and taking the latest git mainline, and I confirmed that the
> problem was still present, and then after reverting this commit, the
> problem went away.
> 
> I've included my Xorg.0.log file in case that's helpful.  Please let
> me know if there's anything else you need.

I still haven't seen this issue myself, so I'm not sure if this patch
will help.  I think it's a necessary one nonetheless though.

diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 6035d3d..5dd5354 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -342,6 +342,7 @@ typedef struct drm_i915_private {
 	u32 savePFIT_CONTROL;
 	u32 save_palette_a[256];
 	u32 save_palette_b[256];
+	u32 saveDPFC_CB_BASE;
 	u32 saveFBC_CFB_BASE;
 	u32 saveFBC_LL_BASE;
 	u32 saveFBC_CONTROL;
diff --git a/drivers/gpu/drm/i915/i915_suspend.c b/drivers/gpu/drm/i915/i915_suspend.c
index bd6d8d9..660c5f3 100644
--- a/drivers/gpu/drm/i915/i915_suspend.c
+++ b/drivers/gpu/drm/i915/i915_suspend.c
@@ -437,10 +437,14 @@ void i915_save_display(struct drm_device *dev)
 	/* FIXME: save TV & SDVO state */
 
 	/* FBC state */
-	dev_priv->saveFBC_CFB_BASE = I915_READ(FBC_CFB_BASE);
-	dev_priv->saveFBC_LL_BASE = I915_READ(FBC_LL_BASE);
-	dev_priv->saveFBC_CONTROL2 = I915_READ(FBC_CONTROL2);
-	dev_priv->saveFBC_CONTROL = I915_READ(FBC_CONTROL);
+	if (IS_GM45(dev)) {
+		dev_priv->saveDPFC_CB_BASE = I915_READ(DPFC_CB_BASE);
+	} else {
+		dev_priv->saveFBC_CFB_BASE = I915_READ(FBC_CFB_BASE);
+		dev_priv->saveFBC_LL_BASE = I915_READ(FBC_LL_BASE);
+		dev_priv->saveFBC_CONTROL2 = I915_READ(FBC_CONTROL2);
+		dev_priv->saveFBC_CONTROL = I915_READ(FBC_CONTROL);
+	}
 
 	/* VGA state */
 	dev_priv->saveVGA0 = I915_READ(VGA0);
@@ -511,10 +515,16 @@ void i915_restore_display(struct drm_device *dev)
 	/* FIXME: restore TV & SDVO state */
 
 	/* FBC info */
-	I915_WRITE(FBC_CFB_BASE, dev_priv->saveFBC_CFB_BASE);
-	I915_WRITE(FBC_LL_BASE, dev_priv->saveFBC_LL_BASE);
-	I915_WRITE(FBC_CONTROL2, dev_priv->saveFBC_CONTROL2);
-	I915_WRITE(FBC_CONTROL, dev_priv->saveFBC_CONTROL);
+	if (IS_GM45(dev)) {
+		g4x_disable_fbc(dev);
+		I915_WRITE(DPFC_CB_BASE, dev_priv->saveDPFC_CB_BASE);
+	} else {
+		i8xx_disable_fbc(dev);
+		I915_WRITE(FBC_CFB_BASE, dev_priv->saveFBC_CFB_BASE);
+		I915_WRITE(FBC_LL_BASE, dev_priv->saveFBC_LL_BASE);
+		I915_WRITE(FBC_CONTROL2, dev_priv->saveFBC_CONTROL2);
+		I915_WRITE(FBC_CONTROL, dev_priv->saveFBC_CONTROL);
+	}
 
 	/* VGA state */
 	I915_WRITE(VGACNTRL, dev_priv->saveVGACNTRL);
