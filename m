Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab0CFLGJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 06:06:09 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:56510 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241Ab0CFLGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 06:06:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=JmLHjqQ9oPghRZKigL0LvdybAuFSF5uEOB71bkBf/eRgfR0GfRBw0++lATXhjzWb5X
         1GCwFBL2voyQQK6OTByUrfBQUcU1A7mzexy7TjnCp3ams44u++XqbO2ga1K1W8cvzi9B
         U0ulJjSr9mcQjWOYI5IA2nR4PYu1gy4bbjPcE=
Date: Sat, 6 Mar 2010 14:05:39 +0300
From: Dan Carpenter <error27@gmail.com>
To: David Airlie <airlied@linux.ie>
Cc: Eric Anholt <eric@anholt.net>, Daniel Vetter <daniel.vetter@ffwll.ch>,
       maximlevitsky@gmail.com, Chris Wilson <chris@chris-wilson.co.uk>,
       Luca Barbieri <luca@luca-barbieri.com>, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] i915: fix small leak on error path
Message-ID: <20100306110539.GD4958@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	David Airlie <airlied@linux.ie>, Eric Anholt <eric@anholt.net>,
	Daniel Vetter <daniel.vetter@ffwll.ch>, maximlevitsky@gmail.com,
	Chris Wilson <chris@chris-wilson.co.uk>,
	Luca Barbieri <luca@luca-barbieri.com>,
	dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should free "params" before returning.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/gpu/drm/i915/intel_overlay.c b/drivers/gpu/drm/i915/intel_overlay.c
index d355d1d..60595fc 100644
--- a/drivers/gpu/drm/i915/intel_overlay.c
+++ b/drivers/gpu/drm/i915/intel_overlay.c
@@ -1068,14 +1068,18 @@ int intel_overlay_put_image(struct drm_device *dev, void *data,
 
 	drmmode_obj = drm_mode_object_find(dev, put_image_rec->crtc_id,
                         DRM_MODE_OBJECT_CRTC);
-	if (!drmmode_obj)
-		return -ENOENT;
+	if (!drmmode_obj) {
+		ret = -ENOENT;
+		goto out_free;
+	}
 	crtc = to_intel_crtc(obj_to_crtc(drmmode_obj));
 
 	new_bo = drm_gem_object_lookup(dev, file_priv,
 			put_image_rec->bo_handle);
-	if (!new_bo)
-		return -ENOENT;
+	if (!new_bo) {
+		ret = -ENOENT;
+		goto out_free;
+	}
 
 	mutex_lock(&dev->mode_config.mutex);
 	mutex_lock(&dev->struct_mutex);
@@ -1165,6 +1169,7 @@ out_unlock:
 	mutex_unlock(&dev->struct_mutex);
 	mutex_unlock(&dev->mode_config.mutex);
 	drm_gem_object_unreference_unlocked(new_bo);
+out_free:
 	kfree(params);
 
 	return ret;
