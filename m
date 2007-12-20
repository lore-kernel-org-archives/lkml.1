Return-Path: <linux-kernel-owner+w=401wt.eu-S1759354AbXLTEmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759354AbXLTEmf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 23:42:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757804AbXLTElv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 23:41:51 -0500
Received: from vms048pub.verizon.net ([206.46.252.48]:37603 "EHLO
	vms048pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757388AbXLTElt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 23:41:49 -0500
Date: Wed, 19 Dec 2007 23:41:46 -0500
From: Jon Smirl <jonsmirl@gmail.com>
Subject: [PATCH 5/5] Convert pfc8563 i2c driver from old style to new style
In-reply-to: <20071220044136.20091.70984.stgit@terra.home>
To: i2c@lm-sensors.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Message-id: <20071220044146.20091.3069.stgit@terra.home>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
References: <20071220044136.20091.70984.stgit@terra.home>
User-Agent: StGIT/0.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert pfc8563 i2c driver from old style to new style. The
driver is also modified to support device tree names via the
i2c mod alias mechanism.

Signed-off-by: Jon Smirl <jonsmirl@gmail.com>
---

 drivers/rtc/rtc-pcf8563.c |  107 +++++++++++----------------------------------
 1 files changed, 27 insertions(+), 80 deletions(-)


diff --git a/drivers/rtc/rtc-pcf8563.c b/drivers/rtc/rtc-pcf8563.c
index 0242d80..e1ea2a0 100644
--- a/drivers/rtc/rtc-pcf8563.c
+++ b/drivers/rtc/rtc-pcf8563.c
@@ -25,10 +25,6 @@
  * located at 0x51 will pass the validation routine due to
  * the way the registers are implemented.
  */
-static unsigned short normal_i2c[] = { I2C_CLIENT_END };
-
-/* Module parameters */
-I2C_CLIENT_INSMOD;
 
 #define PCF8563_REG_ST1		0x00 /* status */
 #define PCF8563_REG_ST2		0x01
@@ -72,9 +68,6 @@ struct pcf8563 {
 	int c_polarity;	/* 0: MO_C=1 means 19xx, otherwise MO_C=1 means 20xx */
 };
 
-static int pcf8563_probe(struct i2c_adapter *adapter, int address, int kind);
-static int pcf8563_detach(struct i2c_client *client);
-
 /*
  * In the routines that deal directly with the pcf8563 hardware, we use
  * rtc_time -- month 0-11, hour 0-23, yr = calendar year-epoch.
@@ -257,98 +250,52 @@ static const struct rtc_class_ops pcf8563_rtc_ops = {
 	.set_time	= pcf8563_rtc_set_time,
 };
 
-static int pcf8563_attach(struct i2c_adapter *adapter)
+static int pcf8563_remove(struct i2c_client *client)
 {
-	return i2c_probe(adapter, &addr_data, pcf8563_probe);
+	struct rtc_device *rtc = i2c_get_clientdata(client);
+
+	if (rtc)
+		rtc_device_unregister(rtc);
+
+	return 0;
 }
 
+static struct i2c_device_id pcf8563_id[] = {
+	OF_I2C_ID("philips,pcf8563", 0)
+	OF_I2C_ID("epson,rtc8564", 0)
+	{},
+};
+MODULE_DEVICE_TABLE(i2c, pcf8563_id);
+
+static int pcf8563_probe(struct i2c_client *client, const struct i2c_device_id *id);
+
 static struct i2c_driver pcf8563_driver = {
 	.driver		= {
-		.name	= "pcf8563",
+		.name	= "rtc-pcf8563",
 	},
 	.id		= I2C_DRIVERID_PCF8563,
-	.attach_adapter = &pcf8563_attach,
-	.detach_client	= &pcf8563_detach,
+	.probe = &pcf8563_probe,
+	.remove = &pcf8563_remove,
+	.id_table	= pcf8563_id,
 };
 
-static int pcf8563_probe(struct i2c_adapter *adapter, int address, int kind)
+static int pcf8563_probe(struct i2c_client *client, const struct i2c_device_id *id)
 {
-	struct pcf8563 *pcf8563;
-	struct i2c_client *client;
+	int result;
 	struct rtc_device *rtc;
 
-	int err = 0;
-
-	dev_dbg(&adapter->dev, "%s\n", __FUNCTION__);
-
-	if (!i2c_check_functionality(adapter, I2C_FUNC_I2C)) {
-		err = -ENODEV;
-		goto exit;
-	}
-
-	if (!(pcf8563 = kzalloc(sizeof(struct pcf8563), GFP_KERNEL))) {
-		err = -ENOMEM;
-		goto exit;
-	}
-
-	client = &pcf8563->client;
-	client->addr = address;
-	client->driver = &pcf8563_driver;
-	client->adapter	= adapter;
-
-	strlcpy(client->name, pcf8563_driver.driver.name, I2C_NAME_SIZE);
-
-	/* Verify the chip is really an PCF8563 */
-	if (kind < 0) {
-		if (pcf8563_validate_client(client) < 0) {
-			err = -ENODEV;
-			goto exit_kfree;
-		}
-	}
-
-	/* Inform the i2c layer */
-	if ((err = i2c_attach_client(client)))
-		goto exit_kfree;
-
-	dev_info(&client->dev, "chip found, driver version " DRV_VERSION "\n");
+	result = pcf8563_validate_client(client);
+	if (result)
+		return result;
 
 	rtc = rtc_device_register(pcf8563_driver.driver.name, &client->dev,
 				&pcf8563_rtc_ops, THIS_MODULE);
-
-	if (IS_ERR(rtc)) {
-		err = PTR_ERR(rtc);
-		goto exit_detach;
-	}
+	if (IS_ERR(rtc))
+		return PTR_ERR(rtc);
 
 	i2c_set_clientdata(client, rtc);
 
 	return 0;
-
-exit_detach:
-	i2c_detach_client(client);
-
-exit_kfree:
-	kfree(pcf8563);
-
-exit:
-	return err;
-}
-
-static int pcf8563_detach(struct i2c_client *client)
-{
-	struct pcf8563 *pcf8563 = container_of(client, struct pcf8563, client);
-	int err;
-	struct rtc_device *rtc = i2c_get_clientdata(client);
-
-	if (rtc)
-		rtc_device_unregister(rtc);
-
-	if ((err = i2c_detach_client(client)))
-		return err;
-
-	kfree(pcf8563);
-
-	return 0;
 }
 
 static int __init pcf8563_init(void)

