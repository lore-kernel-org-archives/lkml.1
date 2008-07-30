Return-Path: <linux-kernel-owner+w=401wt.eu-S1755337AbYG3I2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337AbYG3I2Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 04:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751559AbYG3I2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 04:28:00 -0400
Received: from mail.hevs.ch ([153.109.23.10]:40214 "EHLO mail.hevs.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246AbYG3I17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 04:27:59 -0400
To: a.zummo@towertech.it
Subject: [RFC,PATCH v2] rtc: DS1374 wakeup support
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
       David Brownell <david-b@pacbell.net>
Content-Disposition: inline
From: Marc Pignat <marc.pignat@hevs.ch>
Organization: HEVs
Date: Wed, 30 Jul 2008 10:27:52 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200807301027.53074.marc.pignat@hevs.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wakeup support implementation.

Signed-off-by: Marc Pignat <marc.pignat@hevs.ch>
---

Hi all!

If your system can wakup using this device, add the I2C_CLIENT_WAKE in your i2c
board info flags, and that's it.

This patch depends on the I2C_CLIENT_WAKE functionnality which is fixed in the
patch '[RFC,PATCH] i2c: fix device_init_wakeup place' (http://lkml.org/lkml/2008/7/29/194).

Changes since v1:
 * patch against 2.6.27-rc1
 * removed device_init_wakeup(...) calls, they should be handled in i2c-core.c

Best regards

Marc



diff --git a/drivers/rtc/rtc-ds1374.c b/drivers/rtc/rtc-ds1374.c
index 640acd2..b6219c6 100644
--- a/drivers/rtc/rtc-ds1374.c
+++ b/drivers/rtc/rtc-ds1374.c
@@ -429,12 +429,33 @@ static int __devexit ds1374_remove(struct i2c_client *client)
 	return 0;
 }
 
+#ifdef CONFIG_PM
+static int ds1374_suspend(struct i2c_client *client, pm_message_t state)
+{
+	if (client->irq >= 0 && device_may_wakeup(&client->dev))
+		enable_irq_wake(client->irq);
+	return 0;
+}
+
+static int ds1374_resume(struct i2c_client *client)
+{
+	if (client->irq >= 0 && device_may_wakeup(&client->dev))
+		disable_irq_wake(client->irq);
+	return 0;
+}
+#else
+#define ds1374_suspend	NULL
+#define ds1374_resume	NULL
+#endif
+
 static struct i2c_driver ds1374_driver = {
 	.driver = {
 		.name = "rtc-ds1374",
 		.owner = THIS_MODULE,
 	},
 	.probe = ds1374_probe,
+	.suspend = ds1374_suspend,
+	.resume = ds1374_resume,
 	.remove = __devexit_p(ds1374_remove),
 	.id_table = ds1374_id,
 };
