Return-Path: <linux-kernel-owner+w=401wt.eu-S1751527AbZGaI4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527AbZGaI4c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 04:56:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751805AbZGaI43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 04:56:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33663 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527AbZGaI4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 04:56:25 -0400
From: Xiaotian Feng <dfeng@redhat.com>
To: airlied@linux.ie, dri-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Xiaotian Feng <dfeng@redhat.com>
Subject: [PATCH 4/4] gpu/drm: fix memory leak if dev->driver->load fails
Date: Fri, 31 Jul 2009 16:55:58 +0800
Message-Id: <1249030558-24143-5-git-send-email-dfeng@redhat.com>
In-Reply-To: <1249030558-24143-4-git-send-email-dfeng@redhat.com>
References: <1249030558-24143-1-git-send-email-dfeng@redhat.com>
 <1249030558-24143-2-git-send-email-dfeng@redhat.com>
 <1249030558-24143-3-git-send-email-dfeng@redhat.com>
 <1249030558-24143-4-git-send-email-dfeng@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Noticed a bundle of memory leaks after radeon_driver_load_kms fails.
After dev->driver->load failes, drm_get_dev doesn't free memories
allocated from drm_fill_in_dev.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
---
 drivers/gpu/drm/drm_stub.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/drm_stub.c b/drivers/gpu/drm/drm_stub.c
index fe7f5c4..db9057c 100644
--- a/drivers/gpu/drm/drm_stub.c
+++ b/drivers/gpu/drm/drm_stub.c
@@ -448,23 +448,23 @@ int drm_get_dev(struct pci_dev *pdev, const struct pci_device_id *ent,
 		pci_set_drvdata(pdev, dev);
 		ret = drm_get_minor(dev, &dev->control, DRM_MINOR_CONTROL);
 		if (ret)
-			goto err_g2;
+			goto err_g3;
 	}
 
 	if ((ret = drm_get_minor(dev, &dev->primary, DRM_MINOR_LEGACY)))
-		goto err_g3;
+		goto err_g4;
 
 	if (dev->driver->load) {
 		ret = dev->driver->load(dev, ent->driver_data);
 		if (ret)
-			goto err_g4;
+			goto err_g5;
 	}
 
         /* setup the grouping for the legacy output */
 	if (drm_core_check_feature(dev, DRIVER_MODESET)) {
 		ret = drm_mode_group_init_legacy_group(dev, &dev->primary->mode_group);
 		if (ret)
-			goto err_g4;
+			goto err_g5;
 	}
 
 	list_add_tail(&dev->driver_item, &driver->device_list);
@@ -475,11 +475,13 @@ int drm_get_dev(struct pci_dev *pdev, const struct pci_device_id *ent,
 
 	return 0;
 
-err_g4:
+err_g5:
 	drm_put_minor(&dev->primary);
-err_g3:
+err_g4:
 	if (drm_core_check_feature(dev, DRIVER_MODESET))
 		drm_put_minor(&dev->control);
+err_g3:
+	drm_cleanup_dev(dev);
 err_g2:
 	pci_disable_device(pdev);
 err_g1:
-- 
1.6.2.5

