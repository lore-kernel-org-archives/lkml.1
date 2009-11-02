Return-Path: <linux-kernel-owner+w=401wt.eu-S1754104AbZKBHop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104AbZKBHop (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 02:44:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753973AbZKBHoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 02:44:44 -0500
Received: from smtprelay03.ispgateway.de ([80.67.31.26]:59411 "EHLO
	smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942AbZKBHon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 02:44:43 -0500
Message-ID: <4AEE8D4D.7070703@ladisch.de>
Date: Mon, 02 Nov 2009 08:42:05 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Dave Airlie <airlied@redhat.com>
CC: dri-devel@lists.sourceforge.net, linux-fbdev-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] drm/radeon/kms: allocate framebuffer cmap
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

--- linux-2.6/drivers/gpu/drm/radeon/radeon_fb.c
+++ linux-2.6/drivers/gpu/drm/radeon/radeon_fb.c
@@ -242,6 +242,10 @@ int radeonfb_create(struct drm_device *d
 		goto out_unref;
 	}
 
+	ret = fb_alloc_cmap(&info->cmap, 256, 0);
+	if (ret)
+		goto out_unref;
+
 	memset_io(fbptr, 0, aligned_size);
 
 	strcpy(info->fix.id, "radeondrmfb");
@@ -341,6 +345,7 @@ int radeonfb_remove(struct drm_device *d
 		radeon_object_kunmap(robj);
 		radeon_object_unpin(robj);
 		drm_fb_helper_free(&rfbdev->helper);
+		fb_dealloc_cmap(&info->cmap);
 		framebuffer_release(info);
 	}
 

