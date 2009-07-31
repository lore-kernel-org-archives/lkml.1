Return-Path: <linux-kernel-owner+w=401wt.eu-S1751925AbZGaI4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925AbZGaI4w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 04:56:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751577AbZGaI4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 04:56:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33661 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549AbZGaI4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 04:56:22 -0400
From: Xiaotian Feng <dfeng@redhat.com>
To: airlied@linux.ie, dri-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Xiaotian Feng <dfeng@redhat.com>
Subject: [PATCH 3/4] gpu/drm: introduce drm_cleanup_dev to cleanup memories allocated from drm_fill_in_dev
Date: Fri, 31 Jul 2009 16:55:57 +0800
Message-Id: <1249030558-24143-4-git-send-email-dfeng@redhat.com>
In-Reply-To: <1249030558-24143-3-git-send-email-dfeng@redhat.com>
References: <1249030558-24143-1-git-send-email-dfeng@redhat.com>
 <1249030558-24143-2-git-send-email-dfeng@redhat.com>
 <1249030558-24143-3-git-send-email-dfeng@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drm_fill_in_dev may allocate memories for agp/gem/ht, introduce new function
drm_cleanup_dev(derived from drm_put_dev) to cleanup what drm_fill_in_dev.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
---
 drivers/gpu/drm/drm_stub.c |   47 +++++++++++++++++++++++++------------------
 1 files changed, 27 insertions(+), 20 deletions(-)

diff --git a/drivers/gpu/drm/drm_stub.c b/drivers/gpu/drm/drm_stub.c
index 8ac1ddb..fe7f5c4 100644
--- a/drivers/gpu/drm/drm_stub.c
+++ b/drivers/gpu/drm/drm_stub.c
@@ -308,6 +308,31 @@ error_agp:
 	return retcode;
 }
 
+static int drm_cleanup_dev(struct drm_device *dev)
+{
+	drm_ctxbitmap_cleanup(dev);
+
+	if (drm_core_has_MTRR(dev) && drm_core_has_AGP(dev) &&
+		dev->agp && dev->agp->agp_mtrr >= 0) {
+		int retval;
+		retval = mtrr_del(dev->agp->agp_mtrr,
+				  dev->agp->agp_info.aper_base,
+				  dev->agp->agp_info.aper_size * 1024 * 1024);
+		DRM_DEBUG("mtrr_del=%d\n", retval);
+	}
+
+	if (drm_core_has_AGP(dev) && dev->agp) {
+		kfree(dev->agp);
+		dev->agp = NULL;
+	}
+
+	drm_ht_remove(&dev->map_hash);
+
+	if (dev->driver->driver_features & DRIVER_GEM)
+		drm_gem_destroy(dev);
+
+	return 0;
+}
 
 /**
  * Get a secondary minor number.
@@ -519,37 +544,19 @@ void drm_put_dev(struct drm_device *dev)
 
 	drm_lastclose(dev);
 
-	if (drm_core_has_MTRR(dev) && drm_core_has_AGP(dev) &&
-	    dev->agp && dev->agp->agp_mtrr >= 0) {
-		int retval;
-		retval = mtrr_del(dev->agp->agp_mtrr,
-				  dev->agp->agp_info.aper_base,
-				  dev->agp->agp_info.aper_size * 1024 * 1024);
-		DRM_DEBUG("mtrr_del=%d\n", retval);
-	}
-
 	if (dev->driver->unload)
 		dev->driver->unload(dev);
 
-	if (drm_core_has_AGP(dev) && dev->agp) {
-		kfree(dev->agp);
-		dev->agp = NULL;
-	}
-
 	list_for_each_entry_safe(r_list, list_temp, &dev->maplist, head)
 		drm_rmmap(dev, r_list->map);
-	drm_ht_remove(&dev->map_hash);
-
-	drm_ctxbitmap_cleanup(dev);
 
 	if (drm_core_check_feature(dev, DRIVER_MODESET))
 		drm_put_minor(&dev->control);
 
-	if (driver->driver_features & DRIVER_GEM)
-		drm_gem_destroy(dev);
-
 	drm_put_minor(&dev->primary);
 
+	drm_cleanup_dev(dev);
+
 	if (dev->devname) {
 		kfree(dev->devname);
 		dev->devname = NULL;
-- 
1.6.2.5

