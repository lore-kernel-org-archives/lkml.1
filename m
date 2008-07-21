Return-Path: <linux-kernel-owner+w=401wt.eu-S1753524AbYGUMUE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524AbYGUMUE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 08:20:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750847AbYGUMTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 08:19:54 -0400
Received: from mail.hevs.ch ([153.109.23.10]:33034 "EHLO mail.hevs.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698AbYGUMTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 08:19:54 -0400
X-Greylist: delayed 1195 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Jul 2008 08:19:54 EDT
From: Marc Pignat <marc.pignat@hevs.ch>
Organization: HEVs
To: a.zummo@towertech.it
Subject: [PATCH] rtc: DS1374 wakup support
Date: Mon, 21 Jul 2008 13:59:50 +0200
User-Agent: KMail/1.9.9
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807211359.51592.marc.pignat@hevs.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wakeup support implementation.

Signed-off-by: Marc Pignat <marc.pignat@hevs.ch>
---

Hi all!

patch agaist 2.6.26, tested on custom ARM board.

Best Regards

Marc



diff --git a/drivers/rtc/rtc-ds1374.c b/drivers/rtc/rtc-ds1374.c
index 640acd2..0527dec 100644
--- a/drivers/rtc/rtc-ds1374.c
+++ b/drivers/rtc/rtc-ds1374.c
@@ -388,6 +388,7 @@ static int ds1374_probe(struct i2c_client *client,
 			dev_err(&client->dev, "unable to request IRQ\n");
 			goto out_free;
 		}
+		device_init_wakeup(&client->dev, 1);
 	}
 
 	ds1374->rtc = rtc_device_register(client->name, &client->dev,
@@ -401,8 +402,10 @@ static int ds1374_probe(struct i2c_client *client,
 	return 0;
 
 out_irq:
-	if (client->irq >= 0)
+	if (client->irq >= 0) {
+		device_init_wakeup(&client->dev, 0);
 		free_irq(client->irq, client);
+	}
 
 out_free:
 	i2c_set_clientdata(client, NULL);
@@ -419,6 +422,7 @@ static int __devexit ds1374_remove(struct i2c_client *client)
 		ds1374->exiting = 1;
 		mutex_unlock(&ds1374->mutex);
 
+		device_init_wakeup(&client->dev, 0);
 		free_irq(client->irq, client);
 		flush_scheduled_work();
 	}
@@ -429,12 +433,33 @@ static int __devexit ds1374_remove(struct i2c_client *client)
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
