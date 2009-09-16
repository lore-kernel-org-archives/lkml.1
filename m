Return-Path: <linux-kernel-owner+w=401wt.eu-S1759854AbZIPSHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759854AbZIPSHf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 14:07:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755707AbZIPSHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 14:07:30 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56447 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753557AbZIPSHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 14:07:30 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Convert WM8350 to use request_threaded_irq()
Date: Wed, 16 Sep 2009 19:07:32 +0100
Message-Id: <1253124452-10318-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of hand rolling our own variant.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8350-core.c       |   24 ++++++------------------
 include/linux/mfd/wm8350/core.h |    1 -
 2 files changed, 6 insertions(+), 19 deletions(-)

diff --git a/drivers/mfd/wm8350-core.c b/drivers/mfd/wm8350-core.c
index 9d662a5..ba27c9d 100644
--- a/drivers/mfd/wm8350-core.c
+++ b/drivers/mfd/wm8350-core.c
@@ -353,15 +353,15 @@ static void wm8350_irq_call_handler(struct wm8350 *wm8350, int irq)
 }
 
 /*
- * wm8350_irq_worker actually handles the interrupts.  Since all
+ * This is a threaded IRQ handler so can access I2C/SPI.  Since all
  * interrupts are clear on read the IRQ line will be reasserted and
  * the physical IRQ will be handled again if another interrupt is
  * asserted while we run - in the normal course of events this is a
  * rare occurrence so we save I2C/SPI reads.
  */
-static void wm8350_irq_worker(struct work_struct *work)
+static irqreturn_t wm8350_irq(int irq, void *data)
 {
-	struct wm8350 *wm8350 = container_of(work, struct wm8350, irq_work);
+	struct wm8350 *wm8350 = data;
 	u16 level_one, status1, status2, comp;
 
 	/* TODO: Use block reads to improve performance? */
@@ -552,16 +552,6 @@ static void wm8350_irq_worker(struct work_struct *work)
 		}
 	}
 
-	enable_irq(wm8350->chip_irq);
-}
-
-static irqreturn_t wm8350_irq(int irq, void *data)
-{
-	struct wm8350 *wm8350 = data;
-
-	disable_irq_nosync(irq);
-	schedule_work(&wm8350->irq_work);
-
 	return IRQ_HANDLED;
 }
 
@@ -1428,9 +1418,8 @@ int wm8350_device_init(struct wm8350 *wm8350, int irq,
 
 	mutex_init(&wm8350->auxadc_mutex);
 	mutex_init(&wm8350->irq_mutex);
-	INIT_WORK(&wm8350->irq_work, wm8350_irq_worker);
 	if (irq) {
-		int flags = 0;
+		int flags = IRQF_ONESHOT;
 
 		if (pdata && pdata->irq_high) {
 			flags |= IRQF_TRIGGER_HIGH;
@@ -1444,8 +1433,8 @@ int wm8350_device_init(struct wm8350 *wm8350, int irq,
 					  WM8350_IRQ_POL);
 		}
 
-		ret = request_irq(irq, wm8350_irq, flags,
-				  "wm8350", wm8350);
+		ret = request_threaded_irq(irq, NULL, wm8350_irq, flags,
+					   "wm8350", wm8350);
 		if (ret != 0) {
 			dev_err(wm8350->dev, "Failed to request IRQ: %d\n",
 				ret);
@@ -1505,7 +1494,6 @@ void wm8350_device_exit(struct wm8350 *wm8350)
 	platform_device_unregister(wm8350->codec.pdev);
 
 	free_irq(wm8350->chip_irq, wm8350);
-	flush_work(&wm8350->irq_work);
 	kfree(wm8350->reg_cache);
 }
 EXPORT_SYMBOL_GPL(wm8350_device_exit);
diff --git a/include/linux/mfd/wm8350/core.h b/include/linux/mfd/wm8350/core.h
index 969b0b5..1d595de 100644
--- a/include/linux/mfd/wm8350/core.h
+++ b/include/linux/mfd/wm8350/core.h
@@ -626,7 +626,6 @@ struct wm8350 {
 	struct mutex auxadc_mutex;
 
 	/* Interrupt handling */
-	struct work_struct irq_work;
 	struct mutex irq_mutex; /* IRQ table mutex */
 	struct wm8350_irq irq[WM8350_NUM_IRQ];
 	int chip_irq;
-- 
1.6.3.3

