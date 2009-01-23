Return-Path: <linux-kernel-owner+w=401wt.eu-S1761381AbZAWQSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761381AbZAWQSs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 11:18:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757298AbZAWQSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 11:18:39 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59678 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756577AbZAWQSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 11:18:38 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@openedhand.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/3] mfd: Initialise WM8350 interrupts earlier
Date: Fri, 23 Jan 2009 16:18:35 +0000
Message-Id: <1232727516-5049-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1232727516-5049-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1232727516-5049-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure that the interrupt handling is configured before we do platform
specific init. This allows the platform specific initialisation to
configure things which use interrupts safely.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8350-core.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/mfd/wm8350-core.c b/drivers/mfd/wm8350-core.c
index f92595c..70f5e77 100644
--- a/drivers/mfd/wm8350-core.c
+++ b/drivers/mfd/wm8350-core.c
@@ -1404,15 +1404,6 @@ int wm8350_device_init(struct wm8350 *wm8350, int irq,
 		return ret;
 	}
 
-	if (pdata && pdata->init) {
-		ret = pdata->init(wm8350);
-		if (ret != 0) {
-			dev_err(wm8350->dev, "Platform init() failed: %d\n",
-				ret);
-			goto err;
-		}
-	}
-
 	mutex_init(&wm8350->auxadc_mutex);
 	mutex_init(&wm8350->irq_mutex);
 	INIT_WORK(&wm8350->irq_work, wm8350_irq_worker);
@@ -1430,6 +1421,15 @@ int wm8350_device_init(struct wm8350 *wm8350, int irq,
 	}
 	wm8350->chip_irq = irq;
 
+	if (pdata && pdata->init) {
+		ret = pdata->init(wm8350);
+		if (ret != 0) {
+			dev_err(wm8350->dev, "Platform init() failed: %d\n",
+				ret);
+			goto err;
+		}
+	}
+
 	wm8350_reg_write(wm8350, WM8350_SYSTEM_INTERRUPTS_MASK, 0x0);
 
 	wm8350_client_dev_register(wm8350, "wm8350-codec",
-- 
1.5.6.5

