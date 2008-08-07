Return-Path: <linux-kernel-owner+w=401wt.eu-S1759058AbYHGWuB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759058AbYHGWuB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 18:50:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754030AbYHGWtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 18:49:50 -0400
Received: from smtp1.stealer.net ([88.198.224.204]:60325 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758666AbYHGWtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 18:49:49 -0400
Date: Fri, 8 Aug 2008 00:49:40 +0200 (CEST)
From: Sven Wegener <sven.wegener@stealer.net>
To: Riku Voipio <riku.voipio@iki.fi>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] leds-pca9532: Fix memory leak and properly handle errors
Message-ID: <alpine.LNX.1.10.0808080047290.16201@titan.stealer.net>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
Organization: STEALER.net
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -1.0
X-Spam-Bar: -
X-Spam-Report: Scanned by SpamAssassin 3.2.1-gr1 2007-05-02 on smtp1.stealer.net at Thu, 07 Aug 2008 22:49:47 +0000
	Bayes: 0.0100 Tokens: new, 233; hammy, 4; neutral, 2; spammy, 0.
	AutoLearn: no
	*  0.1 RDNS_NONE Delivered to trusted network by a host with no rDNS
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0100]
X-Spam-Signature: 4edbdbf5e687e89e95cffb3f0c069aa5c2a4f32c
X-DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the registration fails, we need to release the memory we allocated. Also
we need to save the error from led_classdev_register and propagate it up, else
we'll return success, even if we failed.

Not-yet-signed-off-by: Sven Wegener <sven.wegener@stealer.net>
Cc: Riku Voipio <riku.voipio@iki.fi>
---
 drivers/leds/leds-pca9532.c |   22 +++++++++++++---------
 1 files changed, 13 insertions(+), 9 deletions(-)

I don't have the hardware. Riku, can you please test if it still works as 
expected.

diff --git a/drivers/leds/leds-pca9532.c b/drivers/leds/leds-pca9532.c
index 4064d4f..16af817 100644
--- a/drivers/leds/leds-pca9532.c
+++ b/drivers/leds/leds-pca9532.c
@@ -204,8 +204,8 @@ static int pca9532_configure(struct i2c_client *client,
 			led->ldev.brightness = LED_OFF;
 			led->ldev.brightness_set = pca9532_set_brightness;
 			led->ldev.blink_set = pca9532_set_blink;
-			if (led_classdev_register(&client->dev,
-				&led->ldev) < 0)	{
+			err = led_classdev_register(&client->dev, &led->ldev);
+			if (err < 0) {
 				dev_err(&client->dev,
 					"couldn't register LED %s\n",
 					led->name);
@@ -263,7 +263,6 @@ exit:
 			}
 
 	return err;
-
 }
 
 static int pca9532_probe(struct i2c_client *client,
@@ -271,12 +270,16 @@ static int pca9532_probe(struct i2c_client *client,
 {
 	struct pca9532_data *data = i2c_get_clientdata(client);
 	struct pca9532_platform_data *pca9532_pdata = client->dev.platform_data;
+	int err;
+
+	if (!pca9532_pdata)
+		return -EIO;
 
 	if (!i2c_check_functionality(client->adapter,
 		I2C_FUNC_SMBUS_BYTE_DATA))
 		return -EIO;
 
-	data = kzalloc(sizeof(struct pca9532_data), GFP_KERNEL);
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 
@@ -285,12 +288,13 @@ static int pca9532_probe(struct i2c_client *client,
 	data->client = client;
 	mutex_init(&data->update_lock);
 
-	if (pca9532_pdata == NULL)
-		return -EIO;
-
-	pca9532_configure(client, data, pca9532_pdata);
-	return 0;
+	err = pca9532_configure(client, data, pca9532_pdata);
+	if (err) {
+		kfree(data);
+		i2c_set_clientdata(client, NULL);
+	}
 
+	return err;
 }
 
 static int pca9532_remove(struct i2c_client *client)
