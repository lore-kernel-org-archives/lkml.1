Return-Path: <linux-kernel-owner+w=401wt.eu-S1755870AbYEZNnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870AbYEZNnY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 09:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752511AbYEZNmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 09:42:11 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54455 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751544AbYEZNmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 09:42:08 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Rodolfo Giometti <giometti@enneenne.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 3/4] wm97xx-core: Fix race on PHY init
Date: Mon, 26 May 2008 14:42:02 +0100
Message-Id: <1211809323-4742-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1211809323-4742-2-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1211809323-4742-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1211809323-4742-2-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The chip phy_init() function must be called before the dig_enable() function
but dig_enable() is called when the device is opened and we only call
phy_init() after having reigstered the device, meaning the two can race.
Fix this by doing the phy_init() before we register the input device.

Thanks to Rodolfo Giometti <giometti@enneenne.com> for the report.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/input/touchscreen/wm97xx-core.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/input/touchscreen/wm97xx-core.c b/drivers/input/touchscreen/wm97xx-core.c
index 8a00918..cdc24ad 100644
--- a/drivers/input/touchscreen/wm97xx-core.c
+++ b/drivers/input/touchscreen/wm97xx-core.c
@@ -608,6 +608,17 @@ static int wm97xx_probe(struct device *dev)
 		goto alloc_err;
 	}
 
+	/* set up physical characteristics */
+	wm->codec->phy_init(wm);
+
+	/* load gpio cache */
+	wm->gpio[0] = wm97xx_reg_read(wm, AC97_GPIO_CFG);
+	wm->gpio[1] = wm97xx_reg_read(wm, AC97_GPIO_POLARITY);
+	wm->gpio[2] = wm97xx_reg_read(wm, AC97_GPIO_STICKY);
+	wm->gpio[3] = wm97xx_reg_read(wm, AC97_GPIO_WAKEUP);
+	wm->gpio[4] = wm97xx_reg_read(wm, AC97_GPIO_STATUS);
+	wm->gpio[5] = wm97xx_reg_read(wm, AC97_MISC_AFE);
+
 	wm->input_dev = input_allocate_device();
 	if (wm->input_dev == NULL) {
 		ret = -ENOMEM;
@@ -635,17 +646,6 @@ static int wm97xx_probe(struct device *dev)
 	if (ret < 0)
 		goto dev_alloc_err;
 
-	/* set up physical characteristics */
-	wm->codec->phy_init(wm);
-
-	/* load gpio cache */
-	wm->gpio[0] = wm97xx_reg_read(wm, AC97_GPIO_CFG);
-	wm->gpio[1] = wm97xx_reg_read(wm, AC97_GPIO_POLARITY);
-	wm->gpio[2] = wm97xx_reg_read(wm, AC97_GPIO_STICKY);
-	wm->gpio[3] = wm97xx_reg_read(wm, AC97_GPIO_WAKEUP);
-	wm->gpio[4] = wm97xx_reg_read(wm, AC97_GPIO_STATUS);
-	wm->gpio[5] = wm97xx_reg_read(wm, AC97_MISC_AFE);
-
 	/* register our battery device */
 	wm->battery_dev = platform_device_alloc("wm97xx-battery", -1);
 	if (!wm->battery_dev) {
-- 
1.5.5.1

