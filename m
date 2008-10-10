Return-Path: <linux-kernel-owner+w=401wt.eu-S1753647AbYJJKUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647AbYJJKUB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 06:20:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbYJJKTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 06:19:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53962 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752303AbYJJKTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 06:19:50 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>, Samuel Ortiz <sameo@openedhand.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Add WM8350 subdevice registration helper
Date: Fri, 10 Oct 2008 11:19:46 +0100
Message-Id: <1223633986-14171-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of the subdevices for the WM8350 code are registered in the same
fashion so factor out the code to do the initial registration.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
This patch applies on top of the previously posted WM8350 patch series
so needs to be merged via the regulator tree too.

 drivers/mfd/wm8350-core.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/wm8350-core.c b/drivers/mfd/wm8350-core.c
index c7ae776..d925eb8 100644
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

