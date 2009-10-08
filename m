Return-Path: <linux-kernel-owner+w=401wt.eu-S932901AbZJHRhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932901AbZJHRhN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 13:37:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932703AbZJHRhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 13:37:13 -0400
Received: from outbound-mail-08.bluehost.com ([69.89.17.208]:37970 "HELO
	outbound-mail-08.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755504AbZJHRhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 13:37:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=jw61K5RTh2Z971CQUHToxvBocIYRZL3G1x87CPWDmXn1RiOrlZihLYfvfIG21VgR16wfNZ3gklm/IgXvplxSAaBAHv/1hE+MvL1PQUqWJ+bs/Ni+SRIOhMEvDXpHeNPw;
Date: Thu, 8 Oct 2009 10:36:20 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Eric Anholt <eric@anholt.net>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.32 regression (bisected): Video tearing/glitching with T400
 laptops
Message-ID: <20091008103620.5e5aae66@jbarnes-g45>
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

Can you give this patch a try?  It seems to work for Keith at least,
and it sounds like he was seeing the same problem.

-- 
Jesse Barnes, Intel Open Source Technology Center

diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 0466ddb..3bef091 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -1791,6 +1791,7 @@
 
 #define DSPFW1			0x70034
 #define DSPFW2			0x70038
+#define   G4X_FBC_WM_EN		(1<<31) /* GM45+ only */
 #define DSPFW3			0x7003c
 #define   IGD_SELF_REFRESH_EN	(1<<30)
 
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 7a5fb79..be1fb2b 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -1061,6 +1061,9 @@ static void g4x_enable_fbc(struct drm_crtc *crtc, unsigned long interval)
 		   (interval << DPFC_RECOMP_TIMER_COUNT_SHIFT));
 	I915_WRITE(DPFC_FENCE_YOFF, crtc->y);
 
+	/* Use FBC watermark calculations */
+	I915_WRITE(DSPFW2, I915_READ(DSPFW2) | G4X_FBC_WM_EN);
+
 	/* enable it... */
 	I915_WRITE(DPFC_CONTROL, I915_READ(DPFC_CONTROL) | DPFC_CTL_EN);
 
@@ -1078,6 +1081,8 @@ void g4x_disable_fbc(struct drm_device *dev)
 	I915_WRITE(DPFC_CONTROL, dpfc_ctl);
 	intel_wait_for_vblank(dev);
 
+	I915_WRITE(DSPFW2, I915_READ(DSPFW2) & ~G4X_FBC_WM_EN);
+
 	DRM_DEBUG("disabled FBC\n");
 }
 

