Return-Path: <linux-kernel-owner+w=401wt.eu-S1753310Ab0AGXqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab0AGXqo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 18:46:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752276Ab0AGXqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 18:46:44 -0500
Received: from mail.df.lth.se ([194.47.250.12]:34900 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753166Ab0AGXqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 18:46:42 -0500
X-Greylist: delayed 2267 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Jan 2010 18:46:42 EST
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH] Convert the AB3100 driver to use threaded IRH
Date: Fri,  8 Jan 2010 00:08:45 +0100
Message-Id: <1262905725-4178-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts the AB3100 core MFD driver to use a threaded
interrupt handler instead of the explicit top/bottom-half
construction with a workqueue. This saves some code and make it
more similar to other modern MFD drivers.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/mfd/ab3100-core.c  |   43 +++++++++++++------------------------------
 include/linux/mfd/ab3100.h |    3 ---
 2 files changed, 13 insertions(+), 33 deletions(-)

diff --git a/drivers/mfd/ab3100-core.c b/drivers/mfd/ab3100-core.c
index fd42a80..93b2c14 100644
--- a/drivers/mfd/ab3100-core.c
+++ b/drivers/mfd/ab3100-core.c
@@ -365,10 +365,13 @@ int ab3100_event_registers_startup_state_get(struct ab3100 *ab3100,
 }
 EXPORT_SYMBOL(ab3100_event_registers_startup_state_get);
 
-/* Interrupt handling worker */
-static void ab3100_work(struct work_struct *work)
+/*
+ * This is a threaded interrupt handler so we can make some
+ * I2C calls etc.
+ */
+static irqreturn_t ab3100_irq_handler(int irq, void *data)
 {
-	struct ab3100 *ab3100 = container_of(work, struct ab3100, work);
+	struct ab3100 *ab3100 = data;
 	u8 event_regs[3];
 	u32 fatevent;
 	int err;
@@ -376,7 +379,7 @@ static void ab3100_work(struct work_struct *work)
 	err = ab3100_get_register_page_interruptible(ab3100, AB3100_EVENTA1,
 				       event_regs, 3);
 	if (err)
-		goto err_event_wq;
+		goto err_event;
 
 	fatevent = (event_regs[0] << 16) |
 		(event_regs[1] << 8) |
@@ -398,29 +401,11 @@ static void ab3100_work(struct work_struct *work)
 	dev_dbg(ab3100->dev,
 		"IRQ Event: 0x%08x\n", fatevent);
 
-	/* By now the IRQ should be acked and deasserted so enable it again */
-	enable_irq(ab3100->i2c_client->irq);
-	return;
+	return IRQ_HANDLED;
 
- err_event_wq:
+ err_event:
 	dev_dbg(ab3100->dev,
-		"error in event workqueue\n");
-	/* Enable the IRQ anyway, what choice do we have? */
-	enable_irq(ab3100->i2c_client->irq);
-	return;
-}
-
-static irqreturn_t ab3100_irq_handler(int irq, void *data)
-{
-	struct ab3100 *ab3100 = data;
-	/*
-	 * Disable the IRQ and dispatch a worker to handle the
-	 * event. Since the chip resides on I2C this is slow
-	 * stuff and we will re-enable the interrupts once th
-	 * worker has finished.
-	 */
-	disable_irq_nosync(irq);
-	schedule_work(&ab3100->work);
+		"error reading event status\n");
 	return IRQ_HANDLED;
 }
 
@@ -904,12 +889,10 @@ static int __init ab3100_probe(struct i2c_client *client,
 	if (err)
 		goto exit_no_setup;
 
-	INIT_WORK(&ab3100->work, ab3100_work);
-
 	/* This real unpredictable IRQ is of course sampled for entropy */
-	err = request_irq(client->irq, ab3100_irq_handler,
-			  IRQF_DISABLED | IRQF_SAMPLE_RANDOM,
-			  "AB3100 IRQ", ab3100);
+	err = request_threaded_irq(client->irq, NULL, ab3100_irq_handler,
+			  IRQF_ONESHOT | IRQF_SAMPLE_RANDOM,
+			  "ab3100-core", ab3100);
 	if (err)
 		goto exit_no_irq;
 
diff --git a/include/linux/mfd/ab3100.h b/include/linux/mfd/ab3100.h
index e9aa4c9..9a881c3 100644
--- a/include/linux/mfd/ab3100.h
+++ b/include/linux/mfd/ab3100.h
@@ -6,7 +6,6 @@
  */
 
 #include <linux/device.h>
-#include <linux/workqueue.h>
 #include <linux/regulator/machine.h>
 
 #ifndef MFD_AB3100_H
@@ -74,7 +73,6 @@
  * @testreg_client: secondary client for test registers
  * @chip_name: name of this chip variant
  * @chip_id: 8 bit chip ID for this chip variant
- * @work: an event handling worker
  * @event_subscribers: event subscribers are listed here
  * @startup_events: a copy of the first reading of the event registers
  * @startup_events_read: whether the first events have been read
@@ -90,7 +88,6 @@ struct ab3100 {
 	struct i2c_client *testreg_client;
 	char chip_name[32];
 	u8 chip_id;
-	struct work_struct work;
 	struct blocking_notifier_head event_subscribers;
 	u32 startup_events;
 	bool startup_events_read;
-- 
1.6.3.3

