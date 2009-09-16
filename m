Return-Path: <linux-kernel-owner+w=401wt.eu-S1759240AbZIPPW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759240AbZIPPW6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 11:22:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751464AbZIPPW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 11:22:57 -0400
Received: from nox.protox.org ([88.191.38.29]:48708 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751430AbZIPPW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 11:22:56 -0400
From: Jerome Glisse <jglisse@redhat.com>
To: airlied@gmail.com
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       Jerome Glisse <jglisse@redhat.com>
Subject: [PATCH] drm/radeon/kms: don't fail if we fail to init GPU acceleration
Date: Wed, 16 Sep 2009 15:24:21 +0200
Message-Id: <1253107461-12750-1-git-send-email-jglisse@redhat.com>
X-Mailer: git-send-email 1.6.4.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Userspace can query if acceleration is working or not true get
info ioctl and could fallback to software if for some reason
kernel failed to initialize KMS. This should allow to give a
working KMS setup in all case (even with non functionning accel).

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
---
 drivers/gpu/drm/radeon/r420.c          |    2 +
 drivers/gpu/drm/radeon/r600.c          |   33 +++++++++++++-----------
 drivers/gpu/drm/radeon/radeon.h        |    1 +
 drivers/gpu/drm/radeon/radeon_device.c |   44 +++++++++++++-------------------
 drivers/gpu/drm/radeon/radeon_kms.c    |    3 ++
 drivers/gpu/drm/radeon/rv770.c         |   33 +++++++++++++-----------
 include/drm/radeon_drm.h               |    1 +
 7 files changed, 61 insertions(+), 56 deletions(-)

diff --git a/drivers/gpu/drm/radeon/r420.c b/drivers/gpu/drm/radeon/r420.c
index 33a25a4..2142a47 100644
--- a/drivers/gpu/drm/radeon/r420.c
+++ b/drivers/gpu/drm/radeon/r420.c
@@ -329,6 +329,7 @@ int r420_init(struct radeon_device *rdev)
 			return r;
 	}
 	r300_set_reg_safe(rdev);
+	rdev->accel_working = true;
 	r = r420_resume(rdev);
 	if (r) {
 		/* Somethings want wront with the accel init stop accel */
@@ -343,6 +344,7 @@ int r420_init(struct radeon_device *rdev)
 			r100_pci_gart_fini(rdev);
 		radeon_agp_fini(rdev);
 		radeon_irq_kms_fini(rdev);
+		rdev->accel_working = false;
 	}
 	return 0;
 }
diff --git a/drivers/gpu/drm/radeon/r600.c b/drivers/gpu/drm/radeon/r600.c
index 65699e9..af430d7 100644
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -1573,6 +1573,7 @@ int r600_init(struct radeon_device *rdev)
 	if (r)
 		return r;
 
+	rdev->accel_working = true;
 	r = r600_resume(rdev);
 	if (r) {
 		if (rdev->flags & RADEON_IS_AGP) {
@@ -1581,22 +1582,24 @@ int r600_init(struct radeon_device *rdev)
 			rdev->flags &= ~RADEON_IS_AGP;
 			return r600_init(rdev);
 		}
-		return r;
-	}
-	r = radeon_ib_pool_init(rdev);
-	if (r) {
-		DRM_ERROR("radeon: failled initializing IB pool (%d).\n", r);
-		return r;
+		rdev->accel_working = false;
 	}
-	r = r600_blit_init(rdev);
-	if (r) {
-		DRM_ERROR("radeon: failled blitter (%d).\n", r);
-		return r;
-	}
-	r = radeon_ib_test(rdev);
-	if (r) {
-		DRM_ERROR("radeon: failled testing IB (%d).\n", r);
-			return r;
+	if (rdev->accel_working) {
+		r = radeon_ib_pool_init(rdev);
+		if (r) {
+			DRM_ERROR("radeon: failled initializing IB pool (%d).\n", r);
+			rdev->accel_working = false;
+		}
+		r = r600_blit_init(rdev);
+		if (r) {
+			DRM_ERROR("radeon: failled blitter (%d).\n", r);
+			rdev->accel_working = false;
+		}
+		r = radeon_ib_test(rdev);
+		if (r) {
+			DRM_ERROR("radeon: failled testing IB (%d).\n", r);
+			rdev->accel_working = false;
+		}
 	}
 	return 0;
 }
diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index 5bfc056..d7c4efd 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -793,6 +793,7 @@ struct radeon_device {
 	bool				suspend;
 	bool				need_dma32;
 	bool				new_init_path;
+	bool				accel_working;
 	struct radeon_surface_reg surface_regs[RADEON_GEM_MAX_SURFACES];
 	const struct firmware *me_fw;	/* all family ME firmware */
 	const struct firmware *pfp_fw;	/* r6/700 PFP firmware */
diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index db5ae73..0b5014c 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -504,6 +504,7 @@ int radeon_device_init(struct radeon_device *rdev,
 	rdev->usec_timeout = RADEON_MAX_USEC_TIMEOUT;
 	rdev->mc.gtt_size = radeon_gart_size * 1024 * 1024;
 	rdev->gpu_lockup = false;
+	rdev->accel_working = false;
 	/* mutex initialization are all done here so we
 	 * can recall function without having locking issues */
 	mutex_init(&rdev->cs_mutex);
@@ -649,35 +650,26 @@ int radeon_device_init(struct radeon_device *rdev,
 		/* Initialize GART (initialize after TTM so we can allocate
 		 * memory through TTM but finalize after TTM) */
 		r = radeon_gart_enable(rdev);
-		if (!r) {
+		if (r)
+			return 0;
 			r = radeon_gem_init(rdev);
-		}
+		if (r)
+			return 0;
 
 		/* 1M ring buffer */
-		if (!r) {
-			r = radeon_cp_init(rdev, 1024 * 1024);
-		}
-		if (!r) {
-			r = radeon_wb_init(rdev);
-			if (r) {
-				DRM_ERROR("radeon: failled initializing WB (%d).\n", r);
-				return r;
-			}
-		}
-		if (!r) {
-			r = radeon_ib_pool_init(rdev);
-			if (r) {
-				DRM_ERROR("radeon: failled initializing IB pool (%d).\n", r);
-				return r;
-			}
-		}
-		if (!r) {
-			r = radeon_ib_test(rdev);
-			if (r) {
-				DRM_ERROR("radeon: failled testing IB (%d).\n", r);
-				return r;
-			}
-		}
+		r = radeon_cp_init(rdev, 1024 * 1024);
+		if (r)
+			return 0;
+		r = radeon_wb_init(rdev);
+		if (r)
+			DRM_ERROR("radeon: failled initializing WB (%d).\n", r);
+		r = radeon_ib_pool_init(rdev);
+		if (r)
+			return 0;
+		r = radeon_ib_test(rdev);
+		if (r)
+			return 0;
+		rdev->accel_working = true;
 	}
 	DRM_INFO("radeon: kernel modesetting successfully initialized.\n");
 	if (radeon_testing) {
diff --git a/drivers/gpu/drm/radeon/radeon_kms.c b/drivers/gpu/drm/radeon/radeon_kms.c
index ac8505f..709bd89 100644
--- a/drivers/gpu/drm/radeon/radeon_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_kms.c
@@ -112,6 +112,9 @@ int radeon_info_ioctl(struct drm_device *dev, void *data, struct drm_file *filp)
 	case RADEON_INFO_NUM_Z_PIPES:
 		value = rdev->num_z_pipes;
 		break;
+	case RADEON_INFO_ACCEL_WORKING:
+		value = rdev->accel_working;
+		break;
 	default:
 		DRM_DEBUG("Invalid request %d\n", info->request);
 		return -EINVAL;
diff --git a/drivers/gpu/drm/radeon/rv770.c b/drivers/gpu/drm/radeon/rv770.c
index 4f2098b..be2f865 100644
--- a/drivers/gpu/drm/radeon/rv770.c
+++ b/drivers/gpu/drm/radeon/rv770.c
@@ -953,6 +953,7 @@ int rv770_init(struct radeon_device *rdev)
 	if (r)
 		return r;
 
+	rdev->accel_working = true;
 	r = rv770_resume(rdev);
 	if (r) {
 		if (rdev->flags & RADEON_IS_AGP) {
@@ -961,22 +962,24 @@ int rv770_init(struct radeon_device *rdev)
 			rdev->flags &= ~RADEON_IS_AGP;
 			return rv770_init(rdev);
 		}
-		return r;
-	}
-	r = r600_blit_init(rdev);
-	if (r) {
-		DRM_ERROR("radeon: failled blitter (%d).\n", r);
-		return r;
+		rdev->accel_working = false;
 	}
-	r = radeon_ib_pool_init(rdev);
-	if (r) {
-		DRM_ERROR("radeon: failled initializing IB pool (%d).\n", r);
-		return r;
-	}
-	r = radeon_ib_test(rdev);
-	if (r) {
-		DRM_ERROR("radeon: failled testing IB (%d).\n", r);
-			return r;
+	if (rdev->accel_working) {
+		r = r600_blit_init(rdev);
+		if (r) {
+			DRM_ERROR("radeon: failled blitter (%d).\n", r);
+			rdev->accel_working = false;
+		}
+		r = radeon_ib_pool_init(rdev);
+		if (r) {
+			DRM_ERROR("radeon: failled initializing IB pool (%d).\n", r);
+			rdev->accel_working = false;
+		}
+		r = radeon_ib_test(rdev);
+		if (r) {
+			DRM_ERROR("radeon: failled testing IB (%d).\n", r);
+			rdev->accel_working = false;
+		}
 	}
 	return 0;
 }
diff --git a/include/drm/radeon_drm.h b/include/drm/radeon_drm.h
index 2ba61e1..b67bbd7 100644
--- a/include/drm/radeon_drm.h
+++ b/include/drm/radeon_drm.h
@@ -899,6 +899,7 @@ struct drm_radeon_cs {
 #define RADEON_INFO_DEVICE_ID		0x00
 #define RADEON_INFO_NUM_GB_PIPES	0x01
 #define RADEON_INFO_NUM_Z_PIPES 	0x02
+#define RADEON_INFO_ACCEL_WORKING	0x03
 
 struct drm_radeon_info {
 	uint32_t		request;
-- 
1.6.4.3

