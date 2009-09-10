Return-Path: <linux-kernel-owner+w=401wt.eu-S1753490AbZIJTqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbZIJTqq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 15:46:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752988AbZIJTqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 15:46:45 -0400
Received: from nox.protox.org ([88.191.38.29]:57570 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652AbZIJTqo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 15:46:44 -0400
From: Jerome Glisse <jglisse@redhat.com>
To: airlied@gmail.com
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       Jerome Glisse <jglisse@redhat.com>
Subject: [PATCH 1/3] drm/radeon/kms: move modeset init outside of GPU init
Date: Thu, 10 Sep 2009 21:46:48 +0200
Message-Id: <1252612008-1944-1-git-send-email-jglisse@redhat.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are splitting GPU & modeset init so that it's easier
to abord only remaining GPU init when somethings fails.
We want to always provide enough funcionalities to get
fbcon and a shadowfb X working. Only acceptable error
during initialization are memory allocation failure or
io mapping failure.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
---
 drivers/gpu/drm/radeon/radeon.h        |    4 ++++
 drivers/gpu/drm/radeon/radeon_device.c |   20 +++-----------------
 drivers/gpu/drm/radeon/radeon_kms.c    |   22 ++++++++++++++++++----
 3 files changed, 25 insertions(+), 21 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index d6ff4e0..23ede0e 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -933,6 +933,10 @@ static inline void radeon_ring_write(struct radeon_device *rdev, uint32_t v)
 #define radeon_clear_surface_reg(rdev, r) ((rdev)->asic->clear_surface_reg((rdev), (r)))
 #define radeon_bandwidth_update(rdev) (rdev)->asic->bandwidth_update((rdev))
 
+/* Common functions */
+int radeon_modeset_init(struct radeon_device *rdev);
+void radeon_modeset_fini(struct radeon_device *rdev);
+
 /* r100,rv100,rs100,rv200,rs200,r200,rv250,rs300,rv280 */
 void r100_cp_disable(struct radeon_device *rdev);
 void r100_pci_gart_tlb_flush(struct radeon_device *rdev);
diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index bf69394..72f6262 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -469,9 +469,6 @@ void radeon_combios_fini(struct radeon_device *rdev)
 {
 }
 
-int radeon_modeset_init(struct radeon_device *rdev);
-void radeon_modeset_fini(struct radeon_device *rdev);
-
 
 /*
  * Radeon device.
@@ -481,7 +478,7 @@ int radeon_device_init(struct radeon_device *rdev,
 		       struct pci_dev *pdev,
 		       uint32_t flags)
 {
-	int r, ret = 0;
+	int r;
 	int dma_bits;
 
 	DRM_INFO("radeon: Initializing kernel modesetting.\n");
@@ -660,33 +657,22 @@ int radeon_device_init(struct radeon_device *rdev,
 				return r;
 			}
 		}
-		ret = r;
-	}
-	r = radeon_modeset_init(rdev);
-	if (r) {
-		return r;
-	}
-	if (!ret) {
-		DRM_INFO("radeon: kernel modesetting successfully initialized.\n");
 	}
+	DRM_INFO("radeon: kernel modesetting successfully initialized.\n");
 	if (radeon_testing) {
 		radeon_test_moves(rdev);
 	}
 	if (radeon_benchmarking) {
 		radeon_benchmark(rdev);
 	}
-	return ret;
+	return 0;
 }
 
 void radeon_device_fini(struct radeon_device *rdev)
 {
-	if (rdev == NULL || rdev->rmmio == NULL) {
-		return;
-	}
 	DRM_INFO("radeon: finishing device.\n");
 	rdev->shutdown = true;
 	/* Order matter so becarefull if you rearrange anythings */
-	radeon_modeset_fini(rdev);
 	if (!rdev->new_init_path) {
 		radeon_ib_pool_fini(rdev);
 		radeon_cp_fini(rdev);
diff --git a/drivers/gpu/drm/radeon/radeon_kms.c b/drivers/gpu/drm/radeon/radeon_kms.c
index dce09ad..ac8505f 100644
--- a/drivers/gpu/drm/radeon/radeon_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_kms.c
@@ -54,12 +54,23 @@ int radeon_driver_load_kms(struct drm_device *dev, unsigned long flags)
 		flags |= RADEON_IS_PCI;
 	}
 
+	/* radeon_device_init should report only fatal error
+	 * like memory allocation failure or iomapping failure,
+	 * or memory manager initialization failure, it must
+	 * properly initialize the GPU MC controller and permit
+	 * VRAM allocation
+	 */
 	r = radeon_device_init(rdev, dev, dev->pdev, flags);
 	if (r) {
-		DRM_ERROR("Failed to initialize radeon, disabling IOCTL\n");
-		radeon_device_fini(rdev);
-		kfree(rdev);
-		dev->dev_private = NULL;
+		DRM_ERROR("Fatal error while trying to initialize radeon.\n");
+		return r;
+	}
+	/* Again modeset_init should fail only on fatal error
+	 * otherwise it should provide enough functionalities
+	 * for shadowfb to run
+	 */
+	r = radeon_modeset_init(rdev);
+	if (r) {
 		return r;
 	}
 	return 0;
@@ -69,6 +80,9 @@ int radeon_driver_unload_kms(struct drm_device *dev)
 {
 	struct radeon_device *rdev = dev->dev_private;
 
+	if (rdev == NULL)
+		return 0;
+	radeon_modeset_fini(rdev);
 	radeon_device_fini(rdev);
 	kfree(rdev);
 	dev->dev_private = NULL;
-- 
1.6.4.2

