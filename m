Return-Path: <linux-kernel-owner+w=401wt.eu-S1752901AbZIHXMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901AbZIHXMM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 19:12:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752812AbZIHXML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 19:12:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49060 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752770AbZIHXMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 19:12:10 -0400
Date: Tue, 8 Sep 2009 16:11:44 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Knut Petersen <Knut_Petersen@t-online.de>
cc: airlied@linux.ie, linux-kernel@vger.kernel.org
Subject: Re: Regression DRM/i915/KMS: VGA connector unusable after 2.6.31-rc8-git1,
 DVI connector ok
In-Reply-To: <4AA6D858.6040505@t-online.de>
Message-ID: <alpine.LFD.2.01.0909081607400.7458@localhost.localdomain>
References: <4AA6D858.6040505@t-online.de>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 9 Sep 2009, Knut Petersen wrote:
> 
> During the release cycle of the 2.6.31-rc* kernels KMS started to work
> on my computer.
> 
> Booting with a monitor attached to both the VAG and the DVI connectors, 
> kernel 2.6.31-rc8-git1 detects both monitors correctly and sets the 
> native video mode.
> 
> Booting the same configuration with kernel 2.6.31-rc8-git2 ... -rc9-git1 
> gives a different result: the DVI-attached monitor is still working 
> perfectly, the VGA-attached monitor does not detect a valid video signal 
> and switches off.

I just pushed out something that may fix it. It was reported to fix 
another situation that sounds _somewhat_ similar (ie VGA out on a mobile 
chipset)

It's commit 7c8460d: "drm/i915: fix mask bits setting", but it may take a 
few minutes to mirror out to the public machines, so if you don't see it 
yet, here's the patch if you want to try.

			Linus

---
>From 7c8460db30dfd085ef3837c8fb02ecf2e718b983 Mon Sep 17 00:00:00 2001
From: Zhenyu Wang <zhenyuw@linux.intel.com>
Date: Tue, 8 Sep 2009 14:52:25 +0800
Subject: [PATCH] drm/i915: fix mask bits setting

eDP is exclusive connector too, and add missing crtc_mask
setting for TV.

This fixes

	http://bugzilla.kernel.org/show_bug.cgi?id=14139

Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Reported-and-tested-by: Carlos R. Mafra <crmafra2@gmail.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 drivers/gpu/drm/i915/intel_dp.c  |    2 +-
 drivers/gpu/drm/i915/intel_drv.h |    1 +
 drivers/gpu/drm/i915/intel_tv.c  |    1 +
 3 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index f2afc4a..2b914d7 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -1263,7 +1263,7 @@ intel_dp_init(struct drm_device *dev, int output_reg)
 
 	if (IS_eDP(intel_output)) {
 		intel_output->crtc_mask = (1 << 1);
-		intel_output->clone_mask = (1 << INTEL_OUTPUT_EDP);
+		intel_output->clone_mask = (1 << INTEL_EDP_CLONE_BIT);
 	} else
 		intel_output->crtc_mask = (1 << 0) | (1 << 1);
 	connector->interlace_allowed = true;
diff --git a/drivers/gpu/drm/i915/intel_drv.h b/drivers/gpu/drm/i915/intel_drv.h
index 25aa6fa..26a6227 100644
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -74,6 +74,7 @@
 #define INTEL_LVDS_CLONE_BIT 14
 #define INTEL_DVO_TMDS_CLONE_BIT 15
 #define INTEL_DVO_LVDS_CLONE_BIT 16
+#define INTEL_EDP_CLONE_BIT 17
 
 #define INTEL_DVO_CHIP_NONE 0
 #define INTEL_DVO_CHIP_LVDS 1
diff --git a/drivers/gpu/drm/i915/intel_tv.c b/drivers/gpu/drm/i915/intel_tv.c
index 2fbe13a..5b1c9e9 100644
--- a/drivers/gpu/drm/i915/intel_tv.c
+++ b/drivers/gpu/drm/i915/intel_tv.c
@@ -1730,6 +1730,7 @@ intel_tv_init(struct drm_device *dev)
 	drm_mode_connector_attach_encoder(&intel_output->base, &intel_output->enc);
 	tv_priv = (struct intel_tv_priv *)(intel_output + 1);
 	intel_output->type = INTEL_OUTPUT_TVOUT;
+	intel_output->crtc_mask = (1 << 0) | (1 << 1);
 	intel_output->clone_mask = (1 << INTEL_TV_CLONE_BIT);
 	intel_output->enc.possible_crtcs = ((1 << 0) | (1 << 1));
 	intel_output->enc.possible_clones = (1 << INTEL_OUTPUT_TVOUT);
