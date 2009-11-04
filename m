Return-Path: <linux-kernel-owner+w=401wt.eu-S1754770AbZKDInA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770AbZKDInA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 03:43:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754765AbZKDIm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 03:42:58 -0500
Received: from smtprelay05.ispgateway.de ([80.67.18.43]:43574 "EHLO
	smtprelay05.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754759AbZKDIm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 03:42:56 -0500
Message-ID: <4AF13E94.7030909@ladisch.de>
Date: Wed, 04 Nov 2009 09:43:00 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: James Simmons <jsimmons@infradead.org>
CC: Dave Airlie <airlied@redhat.com>, dri-devel@lists.sourceforge.net,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/3] drm/kms: allocate framebuffer cmap
References: <4AEE8CDD.10600@ladisch.de> <4AEE8D6F.60209@ladisch.de> <alpine.LFD.2.00.0911021431360.30135@casper.infradead.org> <4AF01F72.2030605@ladisch.de> <4AF01FFD.50409@ladisch.de> <alpine.LFD.2.00.0911031718160.14442@casper.infradead.org> <4AF13E04.8000005@ladisch.de>
In-Reply-To: <4AF13E04.8000005@ladisch.de>
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
v3: bugfix by James Simmons

 drivers/gpu/drm/drm_fb_helper.c |   7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- linux-2.6/drivers/gpu/drm/drm_fb_helper.c
+++ linux-2.6/drivers/gpu/drm/drm_fb_helper.c
@@ -905,8 +905,13 @@ int drm_fb_helper_single_fb_probe(struct
 
 	if (new_fb) {
 		info->var.pixclock = 0;
-		if (register_framebuffer(info) < 0)
+		ret = fb_alloc_cmap(&info->cmap, crtc->gamma_size, 0);
+		if (ret)
+			return ret;
+		if (register_framebuffer(info) < 0) {
+			fb_dealloc_cmap(&info->cmap);
 			return -EINVAL;
+		}
 	} else {
 		drm_fb_helper_set_par(info);
 	}
@@ -936,6 +941,7 @@ void drm_fb_helper_free(struct drm_fb_he
 		unregister_sysrq_key('v', &sysrq_drm_fb_helper_restore_op);
 	}
 	drm_fb_helper_crtc_free(helper);
+	fb_dealloc_cmap(&helper->fb->fbdev->cmap);
 }
 EXPORT_SYMBOL(drm_fb_helper_free);
 

