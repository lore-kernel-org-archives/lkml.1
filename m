Return-Path: <linux-kernel-owner+w=401wt.eu-S1754127AbZIIUe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbZIIUe3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 16:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752924AbZIIUe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 16:34:28 -0400
Received: from nox.protox.org ([88.191.38.29]:47366 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752967AbZIIUe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 16:34:26 -0400
From: Jerome Glisse <jglisse@redhat.com>
To: airlied@gmail.com
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       Jerome Glisse <jglisse@redhat.com>
Subject: [PATCH] drm/radeon/kms: add R4XX mc register access helper.
Date: Wed,  9 Sep 2009 22:24:20 +0200
Message-Id: <1252527860-2355-1-git-send-email-jglisse@redhat.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Atombios will use the mc register access helper and R4XX hw have a
bigger mc range than R3XX so add R4XX specific mc register access
helper.

igned-off-by: Jerome Glisse <jglisse@redhat.com>
---
 drivers/gpu/drm/radeon/r420.c          |   17 ++++++++++++
 drivers/gpu/drm/radeon/r420d.h         |   43 ++++++++++++++++++++++++++++++++
 drivers/gpu/drm/radeon/radeon.h        |    4 +++
 drivers/gpu/drm/radeon/radeon_device.c |    4 +++
 4 files changed, 68 insertions(+), 0 deletions(-)
 create mode 100644 drivers/gpu/drm/radeon/r420d.h

diff --git a/drivers/gpu/drm/radeon/r420.c b/drivers/gpu/drm/radeon/r420.c
index 029cee2..551d699 100644
--- a/drivers/gpu/drm/radeon/r420.c
+++ b/drivers/gpu/drm/radeon/r420.c
@@ -29,6 +29,7 @@
 #include "drmP.h"
 #include "radeon_reg.h"
 #include "radeon.h"
+#include "r420d.h"
 
 /* r420,r423,rv410 depends on : */
 void r100_pci_gart_disable(struct radeon_device *rdev);
@@ -237,3 +238,19 @@ int r420_debugfs_pipes_info_init(struct radeon_device *rdev)
 	return 0;
 #endif
 }
+
+u32 r420_mc_rreg(struct radeon_device *rdev, u32 reg)
+{
+	u32 r;
+
+	WREG32(R_0001F8_MC_IND_INDEX, S_0001F8_MC_IND_ADDR(reg));
+	r = RREG32(R_0001FC_MC_IND_DATA);
+	return r;
+}
+
+void r420_mc_wreg(struct radeon_device *rdev, u32 reg, u32 v)
+{
+	WREG32(R_0001F8_MC_IND_INDEX, S_0001F8_MC_IND_ADDR(reg) |
+		S_0001F8_MC_IND_WR_EN(1));
+	WREG32(R_0001FC_MC_IND_DATA, v);
+}
diff --git a/drivers/gpu/drm/radeon/r420d.h b/drivers/gpu/drm/radeon/r420d.h
new file mode 100644
index 0000000..8b946c1
--- /dev/null
+++ b/drivers/gpu/drm/radeon/r420d.h
@@ -0,0 +1,43 @@
+/*
+ * Copyright 2008 Advanced Micro Devices, Inc.
+ * Copyright 2008 Red Hat Inc.
+ * Copyright 2009 Jerome Glisse.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDER(S) OR AUTHOR(S) BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
+ * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+ * OTHER DEALINGS IN THE SOFTWARE.
+ *
+ * Authors: Dave Airlie
+ *          Alex Deucher
+ *          Jerome Glisse
+ */
+#ifndef R420D_H
+#define R420D_H
+
+#define R_0001F8_MC_IND_INDEX                        0x0001F8
+#define   S_0001F8_MC_IND_ADDR(x)                      (((x) & 0x7F) << 0)
+#define   G_0001F8_MC_IND_ADDR(x)                      (((x) >> 0) & 0x7F)
+#define   C_0001F8_MC_IND_ADDR                         0xFFFFFF80
+#define   S_0001F8_MC_IND_WR_EN(x)                     (((x) & 0x1) << 8)
+#define   G_0001F8_MC_IND_WR_EN(x)                     (((x) >> 8) & 0x1)
+#define   C_0001F8_MC_IND_WR_EN                        0xFFFFFEFF
+#define R_0001FC_MC_IND_DATA                         0x0001FC
+#define   S_0001FC_MC_IND_DATA(x)                      (((x) & 0xFFFFFFFF) << 0)
+#define   G_0001FC_MC_IND_DATA(x)                      (((x) >> 0) & 0xFFFFFFFF)
+#define   C_0001FC_MC_IND_DATA                         0x00000000
+
+#endif
diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index fe86b20..868d7c1 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -940,4 +940,8 @@ int r100_pci_gart_set_page(struct radeon_device *rdev, int i, uint64_t addr);
 int r100_pci_gart_enable(struct radeon_device *rdev);
 void r100_pci_gart_tlb_flush(struct radeon_device *rdev);
 
+/* r420,r423,rv410 */
+u32 r420_mc_rreg(struct radeon_device *rdev, u32 reg);
+void r420_mc_wreg(struct radeon_device *rdev, u32 reg, u32 v);
+
 #endif
diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index da8646a..d1e356b 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -266,6 +266,10 @@ void radeon_register_accessor_init(struct radeon_device *rdev)
 		rdev->pll_rreg = &r100_pll_rreg;
 		rdev->pll_wreg = &r100_pll_wreg;
 	}
+	if (rdev->family >= CHIP_R420) {
+		rdev->mc_rreg = &r420_mc_rreg;
+		rdev->mc_wreg = &r420_mc_wreg;
+	}
 	if (rdev->family >= CHIP_RV515) {
 		rdev->mc_rreg = &rv515_mc_rreg;
 		rdev->mc_wreg = &rv515_mc_wreg;
-- 
1.6.4.1

