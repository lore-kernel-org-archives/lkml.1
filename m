Return-Path: <linux-kernel-owner+w=401wt.eu-S1754065AbZKBHmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065AbZKBHmi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 02:42:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753949AbZKBHmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 02:42:38 -0500
Received: from smtprelay06.ispgateway.de ([80.67.31.29]:39566 "EHLO
	smtprelay06.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbZKBHmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 02:42:37 -0500
Message-ID: <4AEE8D6F.60209@ladisch.de>
Date: Mon, 02 Nov 2009 08:42:39 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Dave Airlie <airlied@redhat.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Eric Anholt <eric@anholt.net>
CC: dri-devel@lists.sourceforge.net, linux-fbdev-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] drm/i915: allocate framebuffer cmap
References: <4AEE8CDD.10600@ladisch.de>
In-Reply-To: <4AEE8CDD.10600@ladisch.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without an allocated colormap, FBIOGETCMAP fails.  This would make
programs restore an all-black colormap ("links -g") or fail to work
altogether ("mplayer -vo fbdev2").

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
---
Untested.

--- linux-2.6/drivers/gpu/drm/i915/intel_fb.c
+++ linux-2.6/drivers/gpu/drm/i915/intel_fb.c
@@ -227,6 +227,10 @@ static int intelfb_create(struct drm_dev
 
 	fb->fbdev = info;
 
+	ret = fb_alloc_cmap(&info->cmap, 256, 0);
+	if (ret)
+		goto out_unpin;
+
 	par->intel_fb = intel_fb;
 
 	/* To allow resizeing without swapping buffers */
@@ -270,6 +274,7 @@ int intelfb_remove(struct drm_device *de
 		iounmap(info->screen_base);
 		if (info->par)
 			drm_fb_helper_free(&par->helper);
+		fb_dealloc_cmap(&info->cmap);
 		framebuffer_release(info);
 	}
 

