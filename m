Return-Path: <linux-kernel-owner+w=401wt.eu-S1761990AbYJJPBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761990AbYJJPBi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 11:01:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760964AbYJJO6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 10:58:31 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42860 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757444AbYJJO6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 10:58:22 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@openedhand.com>, Liam Girdwood <lrg@kernel.org>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 14/14] mfd: Add WM8350 subdevice registration helper
Date: Fri, 10 Oct 2008 15:58:16 +0100
Message-Id: <1223650696-15552-14-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1223650696-15552-13-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1223649928.6814.333.camel@dell-desktop.example.com>
 <1223650696-15552-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1223650696-15552-2-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1223650696-15552-3-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1223650696-15552-4-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1223650696-15552-5-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1223650696-15552-6-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1223650696-15552-7-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1223650696-15552-8-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1223650696-15552-9-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1223650696-15552-10-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1223650696-15552-11-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1223650696-15552-12-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1223650696-15552-13-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of the subdevices for the WM8350 code are registered in the same
fashion so factor out the code to do the initial registration.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8350-core.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/wm8350-core.c b/drivers/mfd/wm8350-core.c
index 9a1a0b2..cd1f76e 100644
--- a/drivers/mfd/wm8350-core.c
+++ b/drivers/mfd/wm8350-core.c
@@ -1130,6 +1130,32 @@ out:
 }
 EXPORT_SYMBOL_GPL(wm8350_create_cache);
 
+/*
+ * Register a client device.  This is non-fatal since there is no need to
+ * fail the entire device init due to a single platform device failing.
+ */
+static void wm8350_client_dev_register(struct wm8350 *wm8350,
+				       const char *name,
+				       struct platform_device **pdev)
+{
+	int ret;
+
+	*pdev = platform_device_alloc(name, -1);
+	if (pdev == NULL) {
+		dev_err(wm8350->dev, "Failed to allocate %s\n", name);
+		return;
+	}
+
+	(*pdev)->dev.parent = wm8350->dev;
+	platform_set_drvdata(*pdev, wm8350);
+	ret = platform_device_add(*pdev);
+	if (ret != 0) {
+		dev_err(wm8350->dev, "Failed to register %s: %d\n", name, ret);
+		platform_device_put(*pdev);
+		*pdev = NULL;
+	}
+}
+
 int wm8350_device_init(struct wm8350 *wm8350, int irq,
 		       struct wm8350_platform_data *pdata)
 {
-- 
1.5.6.5

