Return-Path: <linux-kernel-owner+w=401wt.eu-S1761677AbZAWQTB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761677AbZAWQTB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 11:19:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757858AbZAWQSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 11:18:40 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59679 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756663AbZAWQSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 11:18:38 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@openedhand.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 3/3] mfd: Improve diagnostics for WM8350 ID register probe
Date: Fri, 23 Jan 2009 16:18:36 +0000
Message-Id: <1232727516-5049-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1232727516-5049-2-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1232727516-5049-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1232727516-5049-2-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check the return value of the device I/O functions when reading the
ID registers so we can provide a more useful diagnostic when we're
having trouble talking to the device.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8350-core.c |   23 +++++++++++++++++++----
 1 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/wm8350-core.c b/drivers/mfd/wm8350-core.c
index 70f5e77..e5e82c7 100644
--- a/drivers/mfd/wm8350-core.c
+++ b/drivers/mfd/wm8350-core.c
@@ -1297,14 +1297,29 @@ static void wm8350_client_dev_register(struct wm8350 *wm8350,
 int wm8350_device_init(struct wm8350 *wm8350, int irq,
 		       struct wm8350_platform_data *pdata)
 {
-	int ret = -EINVAL;
+	int ret;
 	u16 id1, id2, mask_rev;
 	u16 cust_id, mode, chip_rev;
 
 	/* get WM8350 revision and config mode */
-	wm8350->read_dev(wm8350, WM8350_RESET_ID, sizeof(id1), &id1);
-	wm8350->read_dev(wm8350, WM8350_ID, sizeof(id2), &id2);
-	wm8350->read_dev(wm8350, WM8350_REVISION, sizeof(mask_rev), &mask_rev);
+	ret = wm8350->read_dev(wm8350, WM8350_RESET_ID, sizeof(id1), &id1);
+	if (ret != 0) {
+		dev_err(wm8350->dev, "Failed to read ID: %d\n", ret);
+		goto err;
+	}
+
+	ret = wm8350->read_dev(wm8350, WM8350_ID, sizeof(id2), &id2);
+	if (ret != 0) {
+		dev_err(wm8350->dev, "Failed to read ID: %d\n", ret);
+		goto err;
+	}
+
+	ret = wm8350->read_dev(wm8350, WM8350_REVISION, sizeof(mask_rev),
+			       &mask_rev);
+	if (ret != 0) {
+		dev_err(wm8350->dev, "Failed to read revision: %d\n", ret);
+		goto err;
+	}
 
 	id1 = be16_to_cpu(id1);
 	id2 = be16_to_cpu(id2);
-- 
1.5.6.5

