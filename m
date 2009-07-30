Return-Path: <linux-kernel-owner+w=401wt.eu-S1752483AbZG3LGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbZG3LGy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 07:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751849AbZG3LGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 07:06:53 -0400
Received: from cpsmtpm-eml105.kpnxchange.com ([195.121.3.9]:57763 "EHLO
	CPSMTPM-EML105.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751668AbZG3LGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 07:06:52 -0400
From: Frans Pop <elendil@planet.nl>
To: Paul Rolland <rol@as2917.net>
Subject: Re: Linux-2.6.31-rc4 - shut the annoying "failed to acquire vblank..."
Date: Thu, 30 Jul 2009 13:06:50 +0200
User-Agent: KMail/1.9.9
Cc: torvalds@linux-foundation.org, jbarnes@virtuousgeek.org,
       linux-kernel@vger.kernel.org, rol@witbe.net
References: <20090728091622.50e9933b@tux.DEF.witbe.net> <200907281244.13467.elendil@planet.nl> <20090728145359.252ff759@tux.DEF.witbe.net> <20090728092319.52ea57f1@jbarnes-g45> <20090728092319.52ea57f1@jbarnes-g45> <20090729085402.3bb7e3d9@tux.DEF.witbe.net>
In-reply-To: <20090729085402.3bb7e3d9@tux.DEF.witbe.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907301306.51496.elendil@planet.nl>
X-OriginalArrivalTime: 30 Jul 2009 11:06:52.0010 (UTC) FILETIME=[D76AF4A0:01CA1105]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Rolland wrote:
> Some applications/hardware combinations are triggering the message
> "failed to acquire vblank counter" to be issued up to 20 times a second,
> which makes it both useless and dangerous, as this may hide other
> important messages. This changes makes it only appear when people are
> debugging. 
> 
> Signed-off-by: Paul Rolland <rol@as2917.net>
> Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
> 
> --- linux-2.6.31-rc4/drivers/gpu/drm/drm_irq.c.orig     2009-07-26 21:36:20.000000000 +0200
> +++ linux-2.6.31-rc4/drivers/gpu/drm/drm_irq.c  2009-07-26 21:36:34.000000000 +0200
> @@ -566,7 +566,7 @@ int drm_wait_vblank(struct drm_device *d
> 
> ret = drm_vblank_get(dev, crtc);
> 	if (ret) {
> -		DRM_ERROR("failed to acquire vblank counter, %d\n", ret);
> +		DRM_DEBUG("failed to acquire vblank counter, %d\n", ret);
> 		return ret;
> 	}
> 	seq = drm_vblank_count(dev, crtc);

Actually, I just see that I get a different, but related error on suspend
and when opening/closing a second X session:
   *ERROR* trying to get vblank count for disabled pipe 0/1

Would it make sense to add the following to this patch:

diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
index 7ba23a6..d8b86ed 100644
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -190,7 +190,7 @@ u32 i915_get_vblank_counter(struct drm_device *dev, int pipe)
 	low_frame = pipe ? PIPEBFRAMEPIXEL : PIPEAFRAMEPIXEL;
 
 	if (!i915_pipe_enabled(dev, pipe)) {
-		DRM_ERROR("trying to get vblank count for disabled pipe %d\n", pipe);
+		DRM_DEBUG("trying to get vblank count for disabled pipe %d\n", pipe);
 		return 0;
 	}
 
@@ -219,7 +219,7 @@ u32 gm45_get_vblank_counter(struct drm_device *dev, int pipe)
 	int reg = pipe ? PIPEB_FRMCOUNT_GM45 : PIPEA_FRMCOUNT_GM45;
 
 	if (!i915_pipe_enabled(dev, pipe)) {
-		DRM_ERROR("trying to get vblank count for disabled pipe %d\n", pipe);
+		DRM_DEBUG("trying to get vblank count for disabled pipe %d\n", pipe);
 		return 0;
 	}
 
