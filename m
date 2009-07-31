Return-Path: <linux-kernel-owner+w=401wt.eu-S1751885AbZGaI4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885AbZGaI4g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 04:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751852AbZGaI4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 04:56:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33662 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557AbZGaI4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 04:56:23 -0400
From: Xiaotian Feng <dfeng@redhat.com>
To: airlied@linux.ie, dri-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Xiaotian Feng <dfeng@redhat.com>
Subject: [PATCH 2/4] gpu/drm: fix memory leak in drm_fill_in_dev fail path
Date: Fri, 31 Jul 2009 16:55:56 +0800
Message-Id: <1249030558-24143-3-git-send-email-dfeng@redhat.com>
In-Reply-To: <1249030558-24143-2-git-send-email-dfeng@redhat.com>
References: <1249030558-24143-1-git-send-email-dfeng@redhat.com>
 <1249030558-24143-2-git-send-email-dfeng@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In drm_fill_in_dev, drm_ht_create/drm_agp_init/drm_gem_init all allocate
memories. but in the fail path, those memory is not freed, then memory
leaks is resulted.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
---
 drivers/gpu/drm/drm_stub.c |   25 ++++++++++++++++++++-----
 1 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/drm_stub.c b/drivers/gpu/drm/drm_stub.c
index 55bb8a8..8ac1ddb 100644
--- a/drivers/gpu/drm/drm_stub.c
+++ b/drivers/gpu/drm/drm_stub.c
@@ -259,7 +259,7 @@ static int drm_fill_in_dev(struct drm_device * dev, struct pci_dev *pdev,
 		    && (dev->agp == NULL)) {
 			DRM_ERROR("Cannot initialize the agpgart module.\n");
 			retcode = -EINVAL;
-			goto error_out_unreg;
+			goto error_agp;
 		}
 		if (drm_core_has_MTRR(dev)) {
 			if (dev->agp)
@@ -274,7 +274,7 @@ static int drm_fill_in_dev(struct drm_device * dev, struct pci_dev *pdev,
 	retcode = drm_ctxbitmap_init(dev);
 	if (retcode) {
 		DRM_ERROR("Cannot allocate memory for context bitmap.\n");
-		goto error_out_unreg;
+		goto error_ctxbitmap;
 	}
 
 	if (driver->driver_features & DRIVER_GEM) {
@@ -282,14 +282,29 @@ static int drm_fill_in_dev(struct drm_device * dev, struct pci_dev *pdev,
 		if (retcode) {
 			DRM_ERROR("Cannot initialize graphics execution "
 				  "manager (GEM)\n");
-			goto error_out_unreg;
+			goto error_gem;
 		}
 	}
 
 	return 0;
 
-      error_out_unreg:
-	drm_lastclose(dev);
+error_gem:
+	drm_ctxbitmap_cleanup(dev);
+error_ctxbitmap:
+	if (drm_core_has_MTRR(dev) && drm_core_has_AGP(dev) &&
+	    dev->agp && dev->agp->agp_mtrr >= 0) {
+		int retval;
+		retval = mtrr_del(dev->agp->agp_mtrr,
+				  dev->agp->agp_info.aper_base,
+				  dev->agp->agp_info.aper_size * 1024 * 1024);
+		DRM_DEBUG("mtrr_del=%d\n", retval);
+	}
+	if (drm_core_has_AGP(dev) && dev->agp) {
+		kfree(dev->agp);
+		dev->agp = NULL;
+	}
+error_agp:
+	drm_ht_remove(&dev->map_hash);
 	return retcode;
 }
 
-- 
1.6.2.5

