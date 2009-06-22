Return-Path: <linux-kernel-owner+w=401wt.eu-S1756380AbZFVNij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756380AbZFVNij (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 09:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752357AbZFVNiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 09:38:19 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:50740 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbZFVNiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 09:38:18 -0400
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <daniel@caiaq.de>, Pavel Machek <pavel@ucw.cz>,
       Eric Piel <eric.piel@tremplin-utc.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/4] lis3: add free-fall/wakeup function via platform_data
Date: Mon, 22 Jun 2009 15:38:06 +0200
Message-Id: <1245677888-16634-2-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1245677888-16634-1-git-send-email-daniel@caiaq.de>
References: <1245677888-16634-1-git-send-email-daniel@caiaq.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This offers a way for platforms to define flags and thresholds for the
free-fall/wakeup functions of the lis302d chips.

More registers needed to be seperated as they are specific to the
different models.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Eric Piel <eric.piel@tremplin-utc.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/hwmon/lis3lv02d.c |    9 +++++++++
 drivers/hwmon/lis3lv02d.h |   24 ++++++++++++++++++------
 include/linux/lis3lv02d.h |    9 +++++++++
 3 files changed, 36 insertions(+), 6 deletions(-)

diff --git a/drivers/hwmon/lis3lv02d.c b/drivers/hwmon/lis3lv02d.c
index 271338b..cf5afb9 100644
--- a/drivers/hwmon/lis3lv02d.c
+++ b/drivers/hwmon/lis3lv02d.c
@@ -454,6 +454,15 @@ int lis3lv02d_init_device(struct lis3lv02d *dev)
 					(p->click_thresh_y << 4));
 		}
 
+		if (p->wakeup_flags && (dev->whoami == LIS_SINGLE_ID)) {
+			dev->write(dev, FF_WU_CFG_1, p->wakeup_flags);
+			dev->write(dev, FF_WU_THS_1, p->wakeup_thresh & 0x7f);
+			/* default to 2.5ms for now */
+			dev->write(dev, FF_WU_DURATION_1, 1);
+			/* enable high pass filter for both free-fall units */
+			dev->write(dev, CTRL_REG2, HP_FF_WU1 | HP_FF_WU2);
+		}
+
 		if (p->irq_cfg)
 			dev->write(dev, CTRL_REG3, p->irq_cfg);
 	}
diff --git a/drivers/hwmon/lis3lv02d.h b/drivers/hwmon/lis3lv02d.h
index e320e2f..3e1ff46 100644
--- a/drivers/hwmon/lis3lv02d.h
+++ b/drivers/hwmon/lis3lv02d.h
@@ -58,15 +58,17 @@ enum lis3_reg {
 	OUTZ_L		= 0x2C,
 	OUTZ_H		= 0x2D,
 	OUTZ		= 0x2D,
-	FF_WU_CFG	= 0x30,
-	FF_WU_SRC	= 0x31,
-	FF_WU_ACK	= 0x32,
-	FF_WU_THS_L	= 0x34,
-	FF_WU_THS_H	= 0x35,
-	FF_WU_DURATION	= 0x36,
 };
 
 enum lis302d_reg {
+	FF_WU_CFG_1	= 0x30,
+	FF_WU_SRC_1	= 0x31,
+	FF_WU_THS_1	= 0x32,
+	FF_WU_DURATION_1 = 0x33,
+	FF_WU_CFG_2	= 0x34,
+	FF_WU_SRC_2	= 0x35,
+	FF_WU_THS_2	= 0x36,
+	FF_WU_DURATION_2 = 0x37,
 	CLICK_CFG	= 0x38,
 	CLICK_SRC	= 0x39,
 	CLICK_THSY_X	= 0x3B,
@@ -77,6 +79,12 @@ enum lis302d_reg {
 };
 
 enum lis3lv02d_reg {
+	FF_WU_CFG	= 0x30,
+	FF_WU_SRC	= 0x31,
+	FF_WU_ACK	= 0x32,
+	FF_WU_THS_L	= 0x34,
+	FF_WU_THS_H	= 0x35,
+	FF_WU_DURATION	= 0x36,
 	DD_CFG		= 0x38,
 	DD_SRC		= 0x39,
 	DD_ACK		= 0x3A,
@@ -107,6 +115,10 @@ enum lis3lv02d_ctrl2 {
 	CTRL2_FS	= 0x80, /* Full Scale selection */
 };
 
+enum lis302d_ctrl2 {
+	HP_FF_WU2	= 0x08,
+	HP_FF_WU1	= 0x04,
+};
 
 enum lis3lv02d_ctrl3 {
 	CTRL3_CFS0	= 0x01,
diff --git a/include/linux/lis3lv02d.h b/include/linux/lis3lv02d.h
index 113778b..3cc2f2c 100644
--- a/include/linux/lis3lv02d.h
+++ b/include/linux/lis3lv02d.h
@@ -34,6 +34,15 @@ struct lis3lv02d_platform_data {
 #define LIS3_IRQ_OPEN_DRAIN	(1 << 6)
 #define LIS3_IRQ_ACTIVE_LOW	(1 << 7)
 	unsigned char irq_cfg;
+
+#define LIS3_WAKEUP_X_LO	(1 << 0)
+#define LIS3_WAKEUP_X_HI	(1 << 1)
+#define LIS3_WAKEUP_Y_LO	(1 << 2)
+#define LIS3_WAKEUP_Y_HI	(1 << 3)
+#define LIS3_WAKEUP_Z_LO	(1 << 4)
+#define LIS3_WAKEUP_Z_HI	(1 << 5)
+	unsigned char wakeup_flags;
+	unsigned char wakeup_thresh;
 };
 
 #endif /* __LIS3LV02D_H_ */
-- 
1.6.3.1

