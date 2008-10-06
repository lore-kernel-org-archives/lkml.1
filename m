Return-Path: <linux-kernel-owner+w=401wt.eu-S1755144AbYJFMjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144AbYJFMjt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 08:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753243AbYJFMiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 08:38:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40064 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753092AbYJFMiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 08:38:13 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@openedhand.com>, Liam Girdwood <lrg@kernel.org>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 11/13] mfd: Add initialisation callback for WM8350
Date: Mon,  6 Oct 2008 13:38:06 +0100
Message-Id: <1223296688-9960-11-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1223296688-9960-10-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20081006123254.GA9664@rakim.wolfsonmicro.main>
 <1223296688-9960-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1223296688-9960-2-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1223296688-9960-3-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1223296688-9960-4-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1223296688-9960-5-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1223296688-9960-6-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1223296688-9960-7-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1223296688-9960-8-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1223296688-9960-9-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1223296688-9960-10-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some functions of the WM8350 require board-specific initialisation on
startup. Provide a callback to the WM8350 driver in platform data
for platforms to use to configure the chip.  Use of a callback allows
platforms to control the ordering of initialisation which can be
important.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8350-core.c       |   12 +++++++++++-
 drivers/mfd/wm8350-i2c.c        |    2 +-
 include/linux/mfd/wm8350/core.h |   14 +++++++++++++-
 3 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/wm8350-core.c b/drivers/mfd/wm8350-core.c
index c7552c0..071834b 100644
--- a/drivers/mfd/wm8350-core.c
+++ b/drivers/mfd/wm8350-core.c
@@ -388,7 +388,8 @@ out:
 }
 EXPORT_SYMBOL_GPL(wm8350_create_cache);
 
-int wm8350_device_init(struct wm8350 *wm8350)
+int wm8350_device_init(struct wm8350 *wm8350,
+		       struct wm8350_platform_data *pdata)
 {
 	int ret = -EINVAL;
 	u16 id1, id2, mask, mode;
@@ -439,6 +440,15 @@ int wm8350_device_init(struct wm8350 *wm8350)
 		return ret;
 	}
 
+	if (pdata->init) {
+		ret = pdata->init(wm8350);
+		if (ret != 0) {
+			dev_err(wm8350->dev, "Platform init() failed: %d\n",
+				ret);
+			goto err;
+		}
+	}
+
 	return 0;
 
 err:
diff --git a/drivers/mfd/wm8350-i2c.c b/drivers/mfd/wm8350-i2c.c
index 2b0569c..245b790 100644
--- a/drivers/mfd/wm8350-i2c.c
+++ b/drivers/mfd/wm8350-i2c.c
@@ -65,7 +65,7 @@ static int wm8350_i2c_probe(struct i2c_client *i2c,
 	wm8350->read_dev = wm8350_i2c_read_device;
 	wm8350->write_dev = wm8350_i2c_write_device;
 
-	ret = wm8350_device_init(wm8350);
+	ret = wm8350_device_init(wm8350, i2c->dev.platform_data);
 	if (ret < 0)
 		goto err;
 
diff --git a/include/linux/mfd/wm8350/core.h b/include/linux/mfd/wm8350/core.h
index 94778c1..8f2beae 100644
--- a/include/linux/mfd/wm8350/core.h
+++ b/include/linux/mfd/wm8350/core.h
@@ -564,10 +564,22 @@ struct wm8350 {
 	u16 *reg_cache;
 };
 
+/**
+ * Data to be supplied by the platform to initialise the WM8350.
+ *
+ * @init: Function called during driver initialisation.  Should be
+ *        used by the platform to configure GPIO functions and similar.
+ */
+struct wm8350_platform_data {
+	int (*init)(struct wm8350 *wm8350);
+};
+
+
 /*
  * WM8350 device initialisation and exit.
  */
-int wm8350_device_init(struct wm8350 *wm8350);
+int wm8350_device_init(struct wm8350 *wm8350,
+		       struct wm8350_platform_data *pdata);
 void wm8350_device_exit(struct wm8350 *wm8350);
 
 /*
-- 
1.5.6.5

