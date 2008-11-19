Return-Path: <linux-kernel-owner+w=401wt.eu-S1753923AbYKSQrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923AbYKSQrT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 11:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752498AbYKSQrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 11:47:05 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50375 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752199AbYKSQrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 11:47:04 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@openedhand.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] mfd: Refactor WM8350 chip identification
Date: Wed, 19 Nov 2008 16:47:00 +0000
Message-Id: <1227113220-17468-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1227113220-17468-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1227113220-17468-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the WM8350 driver was originally written the semantics for the
identification registers of the chip have been clarified, allowing
us to do an exact match on all the fields. This avoids mistakenly
running on unsupported hardware.

Also change to using the datasheet names more consistently for
legibility and fix a printk() that should be dev_err().

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8350-core.c       |   54 ++++++++++++++++++++++++++------------
 include/linux/mfd/wm8350/core.h |    6 ++++
 2 files changed, 43 insertions(+), 17 deletions(-)

diff --git a/drivers/mfd/wm8350-core.c b/drivers/mfd/wm8350-core.c
index 84fc90e..d7836ad 100644
--- a/drivers/mfd/wm8350-core.c
+++ b/drivers/mfd/wm8350-core.c
@@ -1227,52 +1227,72 @@ int wm8350_device_init(struct wm8350 *wm8350, int irq,
 		       struct wm8350_platform_data *pdata)
 {
 	int ret = -EINVAL;
-	u16 id1, id2, mask, mode;
+	u16 id1, id2, mask_rev;
+	u16 cust_id, mode, chip_rev;
 
 	/* get WM8350 revision and config mode */
 	wm8350->read_dev(wm8350, WM8350_RESET_ID, sizeof(id1), &id1);
 	wm8350->read_dev(wm8350, WM8350_ID, sizeof(id2), &id2);
+	wm8350->read_dev(wm8350, WM8350_REVISION, sizeof(mask_rev), &mask_rev);
 
 	id1 = be16_to_cpu(id1);
 	id2 = be16_to_cpu(id2);
+	mask_rev = be16_to_cpu(mask_rev);
 
-	if (id1 == 0x6143) {
-		switch ((id2 & WM8350_CHIP_REV_MASK) >> 12) {
+	if (id1 != 0x6143) {
+		dev_err(wm8350->dev,
+			"Device with ID %x is not a WM8350\n", id1);
+		ret = -ENODEV;
+		goto err;
+	}
+
+	mode = id2 & WM8350_CONF_STS_MASK >> 10;
+	cust_id = id2 & WM8350_CUST_ID_MASK;
+	chip_rev = (id2 & WM8350_CHIP_REV_MASK) >> 12;
+	dev_info(wm8350->dev,
+		 "CONF_STS %d, CUST_ID %d, MASK_REV %d, CHIP_REV %d\n",
+		 mode, cust_id, mask_rev, chip_rev);
+
+	if (cust_id != 0) {
+		dev_err(wm8350->dev, "Unsupported CUST_ID\n");
+		ret = -ENODEV;
+		goto err;
+	}
+
+	switch (mask_rev) {
+	case 0:
+		switch (chip_rev) {
 		case 0x4:
-			dev_info(wm8350->dev, "Found Rev E device\n");
+			dev_info(wm8350->dev, "WM8350 Rev E\n");
 			break;
 		case 0x5:
-			dev_info(wm8350->dev, "Found Rev F device\n");
+			dev_info(wm8350->dev, "WM8350 Rev F\n");
 			break;
 		case 0x6:
-			dev_info(wm8350->dev, "Found Rev G device\n");
+			dev_info(wm8350->dev, "WM8350 Rev G\n");
 			wm8350->power.rev_g_coeff = 1;
 			break;
 		case 0x7:
-			dev_info(wm8350->dev, "Found Rev H device\n");
+			dev_info(wm8350->dev, "WM8350 Rev H\n");
 			wm8350->power.rev_g_coeff = 1;
 			break;
 		default:
 			/* For safety we refuse to run on unknown hardware */
-			dev_info(wm8350->dev, "Found unknown rev %x\n",
-				 (id2 & WM8350_CHIP_REV_MASK) >> 12);
+			dev_err(wm8350->dev, "Unknown WM8350 CHIP_REV\n");
 			ret = -ENODEV;
 			goto err;
 		}
-	} else {
-		dev_info(wm8350->dev, "Device with ID %x is not a WM8350\n",
-			 id1);
+		break;
+
+	default:
+		dev_err(wm8350->dev, "Unknown MASK_REV\n");
 		ret = -ENODEV;
 		goto err;
 	}
 
-	mode = id2 & WM8350_CONF_STS_MASK >> 10;
-	mask = id2 & WM8350_CUST_ID_MASK;
-	dev_info(wm8350->dev, "Config mode %d, ROM mask %d\n", mode, mask);
-
 	ret = wm8350_create_cache(wm8350, mode);
 	if (ret < 0) {
-		printk(KERN_ERR "wm8350: failed to create register cache\n");
+		dev_err(wm8350->dev, "Failed to create register cache\n");
 		return ret;
 	}
 
diff --git a/include/linux/mfd/wm8350/core.h b/include/linux/mfd/wm8350/core.h
index 8563408..0d37572 100644
--- a/include/linux/mfd/wm8350/core.h
+++ b/include/linux/mfd/wm8350/core.h
@@ -29,6 +29,7 @@
  */
 #define WM8350_RESET_ID                         0x00
 #define WM8350_ID                               0x01
+#define WM8350_REVISION				0x02
 #define WM8350_SYSTEM_CONTROL_1                 0x03
 #define WM8350_SYSTEM_CONTROL_2                 0x04
 #define WM8350_SYSTEM_HIBERNATE                 0x05
@@ -80,6 +81,11 @@
 #define WM8350_CUST_ID_MASK                     0x00FF
 
 /*
+ * R2 (0x02) - Revision
+ */
+#define WM8350_MASK_REV_MASK			0x00FF
+
+/*
  * R3 (0x03) - System Control 1
  */
 #define WM8350_CHIP_ON                          0x8000
-- 
1.5.6.5

