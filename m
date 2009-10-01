Return-Path: <linux-kernel-owner+w=401wt.eu-S1755228AbZJAQEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228AbZJAQEW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 12:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755139AbZJAQEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 12:04:20 -0400
Received: from nox.protox.org ([88.191.38.29]:37903 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754927AbZJAQEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 12:04:15 -0400
From: Jerome Glisse <jglisse@redhat.com>
To: airlied@gmail.com
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       Jerome Glisse <jglisse@redhat.com>
Subject: [PATCH 4/5] drm/radeon/kms: Fix R600/RV770 disable acceleration path
Date: Thu,  1 Oct 2009 18:02:14 +0200
Message-Id: <1254412935-9976-4-git-send-email-jglisse@redhat.com>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <1254412935-9976-3-git-send-email-jglisse@redhat.com>
References: <1254412935-9976-1-git-send-email-jglisse@redhat.com>
 <1254412935-9976-2-git-send-email-jglisse@redhat.com>
 <1254412935-9976-3-git-send-email-jglisse@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When acceleration doesn't work we should free associated memory
and stop GPU block responsible for hardware acceleration so we
don't waste resource or let think one component of the driver that
a GPU feature is working/running while it doesn't actualy work.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
---
 drivers/gpu/drm/radeon/r600.c  |    5 +++++
 drivers/gpu/drm/radeon/rv770.c |    5 +++++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/radeon/r600.c b/drivers/gpu/drm/radeon/r600.c
index cf4be70..e74e7a7 100644
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -1605,6 +1605,11 @@ int r600_init(struct radeon_device *rdev)
 			rdev->flags &= ~RADEON_IS_AGP;
 			return r600_init(rdev);
 		}
+		r600_suspend(rdev);
+		r600_wb_fini(rdev);
+		radeon_ib_pool_fini(rdev);
+		radeon_ring_fini(rdev);
+		r600_pcie_gart_fini(rdev);
 		rdev->accel_working = false;
 	}
 	if (rdev->accel_working) {
diff --git a/drivers/gpu/drm/radeon/rv770.c b/drivers/gpu/drm/radeon/rv770.c
index a06e749..a04e6ee 100644
--- a/drivers/gpu/drm/radeon/rv770.c
+++ b/drivers/gpu/drm/radeon/rv770.c
@@ -968,6 +968,11 @@ int rv770_init(struct radeon_device *rdev)
 			rdev->flags &= ~RADEON_IS_AGP;
 			return rv770_init(rdev);
 		}
+		rv770_suspend(rdev);
+		r600_wb_fini(rdev);
+		radeon_ib_pool_fini(rdev);
+		radeon_ring_fini(rdev);
+		rv770_pcie_gart_fini(rdev);
 		rdev->accel_working = false;
 	}
 	if (rdev->accel_working) {
-- 
1.6.4.4

