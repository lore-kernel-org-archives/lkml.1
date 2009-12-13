Return-Path: <linux-kernel-owner+w=401wt.eu-S1753279AbZLMNLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279AbZLMNLY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 08:11:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753138AbZLMNLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 08:11:16 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:36226 "HELO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753276AbZLMNLM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 08:11:12 -0500
Date: Sun, 13 Dec 2009 14:11:09 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: airlied@linux.ie, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 1/2] drivers/gpu/drm: introduce missing kfree
Message-ID: <Pine.LNX.4.64.0912131410330.24267@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Error handling code following a kzalloc should free the allocated data.
Similarly for usb-alloc urb.

The semantic match that finds the first problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression x;
statement S;
expression E;
identifier f,f1,l;
position p1,p2;
expression *ptr != NULL;
@@

x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...);
...
if (x == NULL) S
<... when != x
     when != if (...) { <+...x...+> }
(
x->f1 = E
|
 (x->f1 == NULL || ...)
|
 f(...,x->f1,...)
)
...>
(
 return \(0\|<+...x...+>\|ptr\);
|
 return@p2 ...;
)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

print "* file: %s kmalloc %s return %s" % (p1[0].file,p1[0].line,p2[0].line)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---
 drivers/gpu/drm/i915/intel_overlay.c           |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_overlay.c b/drivers/gpu/drm/i915/intel_overlay.c
index 49110b3..8ad6851 100644
--- a/drivers/gpu/drm/i915/intel_overlay.c
+++ b/drivers/gpu/drm/i915/intel_overlay.c
@@ -1083,14 +1083,18 @@ int intel_overlay_put_image(struct drm_device *dev, void *data,
 
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
@@ -1180,6 +1184,7 @@ out_unlock:
 	mutex_unlock(&dev->struct_mutex);
 	mutex_unlock(&dev->mode_config.mutex);
 	drm_gem_object_unreference(new_bo);
+out_free:
 	kfree(params);
 
 	return ret;
