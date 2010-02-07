Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790Ab0BGAla (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 19:41:30 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:50067 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754447Ab0BGAl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 19:41:28 -0500
Date: Sun, 07 Feb 2010 09:41:26 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
Subject: [PATCH] regulator: Add enable_time on probe of WM8994
To: lrg@slimlogic.co.uk
Cc: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com,
       kyungmin.park@samsung.com
Message-id: <4B6E0C36.3090608@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
X-OriginalArrivalTime: 07 Feb 2010 00:40:36.0963 (UTC)
 FILETIME=[2A41CB30:01CAA78E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WM8994 regulator needs some delay to enable when it is probed too.

Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
---
 drivers/regulator/wm8994-regulator.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/wm8994-regulator.c b/drivers/regulator/wm8994-regulator.c
index 1639806..a9f0c89 100644
--- a/drivers/regulator/wm8994-regulator.c
+++ b/drivers/regulator/wm8994-regulator.c
@@ -15,6 +15,7 @@
 #include <linux/moduleparam.h>
 #include <linux/init.h>
 #include <linux/bitops.h>
+#include <linux/delay.h>
 #include <linux/err.h>
 #include <linux/platform_device.h>
 #include <linux/regulator/driver.h>
@@ -206,7 +207,7 @@ static __devinit int wm8994_ldo_probe(struct platform_device *pdev)
 	struct wm8994_pdata *pdata = wm8994->dev->platform_data;
 	int id = pdev->id % ARRAY_SIZE(pdata->ldo);
 	struct wm8994_ldo *ldo;
-	int ret;
+	int ret, delay;
 
 	dev_dbg(&pdev->dev, "Probing LDO%d\n", id + 1);
 
@@ -239,6 +240,12 @@ static __devinit int wm8994_ldo_probe(struct platform_device *pdev)
 				ret);
 			goto err_gpio;
 		}
+
+		delay = wm8994_ldo_enable_time(NULL);
+		if (delay >= 1000)
+			mdelay(delay / 1000);
+		else if (delay)
+			udelay(delay);
 	}
 
 	ldo->regulator = regulator_register(&wm8994_ldo_desc[id], &pdev->dev,
-- 
1.6.3.3
