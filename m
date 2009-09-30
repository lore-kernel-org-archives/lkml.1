Return-Path: <linux-kernel-owner+w=401wt.eu-S1752854AbZI3UTL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbZI3UTL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 16:19:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbZI3UTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 16:19:10 -0400
Received: from nox.protox.org ([88.191.38.29]:42524 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034AbZI3UTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 16:19:09 -0400
From: Jerome Glisse <jglisse@redhat.com>
To: airlied@gmail.com
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       Jerome Glisse <jglisse@redhat.com>
Subject: [PATCH] drm/radeon/kms: Fix irq handling on AVIVO hw
Date: Wed, 30 Sep 2009 22:18:43 +0200
Message-Id: <1254341923-15392-1-git-send-email-jglisse@redhat.com>
X-Mailer: git-send-email 1.6.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avivo hw have vblank interrupt in different place, fixes
irq handling (especialy irq disabling while suspending or
shuting down the module).

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
---
 drivers/gpu/drm/radeon/r520.c   |    2 +-
 drivers/gpu/drm/radeon/radeon.h |    2 ++
 drivers/gpu/drm/radeon/rs600.c  |   13 ++++++++++++-
 drivers/gpu/drm/radeon/rs690.c  |    4 ++--
 drivers/gpu/drm/radeon/rv515.c  |    4 ++--
 5 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/radeon/r520.c b/drivers/gpu/drm/radeon/r520.c
index 0bf13fc..9e17aa1 100644
--- a/drivers/gpu/drm/radeon/r520.c
+++ b/drivers/gpu/drm/radeon/r520.c
@@ -186,7 +186,7 @@ static int r520_startup(struct radeon_device *rdev)
 	}
 	/* Enable IRQ */
 	rdev->irq.sw_int = true;
-	r100_irq_set(rdev);
+	rs600_irq_set(rdev);
 	/* 1M ring buffer */
 	r = r100_cp_init(rdev, 1024 * 1024);
 	if (r) {
diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index 2f084e1..8e18128 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -1090,6 +1090,8 @@ extern void rs400_gart_fini(struct radeon_device *rdev);
 
 /* rs600 */
 extern void rs600_set_safe_registers(struct radeon_device *rdev);
+extern int rs600_irq_set(struct radeon_device *rdev);
+extern void rs600_irq_disable(struct radeon_device *rdev);
 
 /* rs690, rs740 */
 extern void rs690_line_buffer_adjust(struct radeon_device *rdev,
diff --git a/drivers/gpu/drm/radeon/rs600.c b/drivers/gpu/drm/radeon/rs600.c
index 9e4fdc1..985c594 100644
--- a/drivers/gpu/drm/radeon/rs600.c
+++ b/drivers/gpu/drm/radeon/rs600.c
@@ -229,6 +229,17 @@ static inline uint32_t rs600_irq_ack(struct radeon_device *rdev, u32 *r500_disp_
 	return irqs & irq_mask;
 }
 
+void rs600_irq_disable(struct radeon_device *rdev)
+{
+	u32 tmp;
+
+	WREG32(R_000040_GEN_INT_CNTL, 0);
+	WREG32(R_006540_DxMODE_INT_MASK, 0);
+	/* Wait and acknowledge irq */
+	mdelay(1);
+	rs600_irq_ack(rdev, &tmp);
+}
+
 int rs600_irq_process(struct radeon_device *rdev)
 {
 	uint32_t status;
@@ -403,7 +414,7 @@ int rs600_suspend(struct radeon_device *rdev)
 {
 	r100_cp_disable(rdev);
 	r100_wb_disable(rdev);
-	r100_irq_disable(rdev);
+	rs600_irq_disable(rdev);
 	rs600_gart_disable(rdev);
 	return 0;
 }
diff --git a/drivers/gpu/drm/radeon/rs690.c b/drivers/gpu/drm/radeon/rs690.c
index 0028db5..3040ae9 100644
--- a/drivers/gpu/drm/radeon/rs690.c
+++ b/drivers/gpu/drm/radeon/rs690.c
@@ -606,7 +606,7 @@ static int rs690_startup(struct radeon_device *rdev)
 		return r;
 	/* Enable IRQ */
 	rdev->irq.sw_int = true;
-	r100_irq_set(rdev);
+	rs600_irq_set(rdev);
 	/* 1M ring buffer */
 	r = r100_cp_init(rdev, 1024 * 1024);
 	if (r) {
@@ -647,7 +647,7 @@ int rs690_suspend(struct radeon_device *rdev)
 {
 	r100_cp_disable(rdev);
 	r100_wb_disable(rdev);
-	r100_irq_disable(rdev);
+	rs600_irq_disable(rdev);
 	rs400_gart_disable(rdev);
 	return 0;
 }
diff --git a/drivers/gpu/drm/radeon/rv515.c b/drivers/gpu/drm/radeon/rv515.c
index e53b5ca..cc342aa 100644
--- a/drivers/gpu/drm/radeon/rv515.c
+++ b/drivers/gpu/drm/radeon/rv515.c
@@ -478,7 +478,7 @@ static int rv515_startup(struct radeon_device *rdev)
 	}
 	/* Enable IRQ */
 	rdev->irq.sw_int = true;
-	r100_irq_set(rdev);
+	rs600_irq_set(rdev);
 	/* 1M ring buffer */
 	r = r100_cp_init(rdev, 1024 * 1024);
 	if (r) {
@@ -520,7 +520,7 @@ int rv515_suspend(struct radeon_device *rdev)
 {
 	r100_cp_disable(rdev);
 	r100_wb_disable(rdev);
-	r100_irq_disable(rdev);
+	rs600_irq_disable(rdev);
 	if (rdev->flags & RADEON_IS_PCIE)
 		rv370_pcie_gart_disable(rdev);
 	return 0;
-- 
1.6.4.4

