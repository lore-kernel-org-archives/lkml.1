Return-Path: <linux-kernel-owner+w=401wt.eu-S1759489AbZBESOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759489AbZBESOa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 13:14:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760041AbZBESNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 13:13:50 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:2663 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759972AbZBESNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 13:13:49 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@openedhand.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Thu,  5 Feb 2009 18:13:40 +0000
Message-Id: <1233857621-5050-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20090205181235.GA4851@sirena.org.uk>
References: <20090205181235.GA4851@sirena.org.uk>
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH 1/2] mfd: Support active high IRQs on WM835x
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8350-core.c       |   16 +++++++++++++++-
 include/linux/mfd/wm8350/core.h |    2 ++
 2 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/wm8350-core.c b/drivers/mfd/wm8350-core.c
index d34ac97..d784b3e 100644
--- a/drivers/mfd/wm8350-core.c
+++ b/drivers/mfd/wm8350-core.c
@@ -1426,7 +1426,21 @@ int wm8350_device_init(struct wm8350 *wm8350, int irq,
 	mutex_init(&wm8350->irq_mutex);
 	INIT_WORK(&wm8350->irq_work, wm8350_irq_worker);
 	if (irq) {
-		ret = request_irq(irq, wm8350_irq, 0,
+		int flags = 0;
+
+		if (pdata && pdata->irq_high) {
+			flags |= IRQF_TRIGGER_HIGH;
+
+			wm8350_set_bits(wm8350, WM8350_SYSTEM_CONTROL_1,
+					WM8350_IRQ_POL);
+		} else {
+			flags |= IRQF_TRIGGER_LOW;
+
+			wm8350_clear_bits(wm8350, WM8350_SYSTEM_CONTROL_1,
+					  WM8350_IRQ_POL);
+		}
+
+		ret = request_irq(irq, wm8350_irq, flags,
 				  "wm8350", wm8350);
 		if (ret != 0) {
 			dev_err(wm8350->dev, "Failed to request IRQ: %d\n",
diff --git a/include/linux/mfd/wm8350/core.h b/include/linux/mfd/wm8350/core.h
index 980669d..42cca67 100644
--- a/include/linux/mfd/wm8350/core.h
+++ b/include/linux/mfd/wm8350/core.h
@@ -640,9 +640,11 @@ struct wm8350 {
  *
  * @init: Function called during driver initialisation.  Should be
  *        used by the platform to configure GPIO functions and similar.
+ * @irq_high: Set if WM8350 IRQ is active high.
  */
 struct wm8350_platform_data {
 	int (*init)(struct wm8350 *wm8350);
+	int irq_high;
 };
 
 
-- 
1.5.6.5

