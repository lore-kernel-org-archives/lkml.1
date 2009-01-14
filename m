Return-Path: <linux-kernel-owner+w=401wt.eu-S1754144AbZANSQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144AbZANSQX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 13:16:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752316AbZANSQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 13:16:14 -0500
Received: from ppsw-0.csi.cam.ac.uk ([131.111.8.130]:45467 "EHLO
	ppsw-0.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbZANSQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 13:16:14 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <496E2BE5.1050803@cam.ac.uk>
Date: Wed, 14 Jan 2009 18:16:05 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Mark Brown <broonie@sirena.org.uk>, Mike Rapoport <mike@compulab.co.il>,
       Samuel Ortiz <sameo@openedhand.com>, eric miao <eric.y.miao@gmail.com>,
       felipe.balbi@nokia.com, Liam Girdwood <lrg@kernel.org>
Subject: [PATCH 2.6.29-rc1-git4] mfd: da9030 usb charge pump support within
 mfd driver.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Jonathan Cameron <jic23@cam.ac.uk>

Add support for changing the mode of the da9030 usb charge pump

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>

---

Minor changes from previous version to reflect changes in the
driver being patched. Addtional cc's as per Mark's suggestion.

This version simply adds the functionality to the da903x mfd driver
core. If anyone can suggest a way round simply maintaining a
global pointer to the device it would be good.

To be able to call this from a board config file the driver must be
built in rather than a module but enforcing that is down to the
board Kconfig entry.

diff --git a/drivers/mfd/da903x.c b/drivers/mfd/da903x.c
index 99f8dcf..70ec3b0 100644
--- a/drivers/mfd/da903x.c
+++ b/drivers/mfd/da903x.c
@@ -30,6 +30,7 @@
 #define DA9030_SYS_CTRL_A	0x08
 #define DA9030_SYS_CTRL_B	0x09
 #define DA9030_FAULT_LOG	0x0a
+#define DA9030_USBPUMP_REG	0x19
 
 #define DA9034_CHIP_ID		0x00
 #define DA9034_EVENT_A		0x01
@@ -484,6 +485,32 @@ failed:
 	return ret;
 }
 
+/* Single device assumption */
+struct device *da9030_mfd_dev;
+
+int da9030_set_usb_charge_pump_mode(int mode)
+{
+	uint8_t val = 0;
+
+	if (da9030_mfd_dev == NULL)
+		return -EINVAL;
+
+	switch (mode) {
+	case DA9030_USBPUMP_AUTO:
+		val = 0;
+		break;
+	case DA9030_USBPUMP_CHARGE_PUMP:
+		val = 0x40;
+		break;
+	case DA9030_USBPUMP_CURRENT_SOURCE:
+		val = 0x80;
+		break;
+	}
+
+	return da903x_write(da9030_mfd_dev, DA9030_USBPUMP_REG, val);
+}
+EXPORT_SYMBOL_GPL(da9030_set_usb_charge_pump_mode);
+
 static int __devinit da903x_probe(struct i2c_client *client,
 				  const struct i2c_device_id *id)
 {
@@ -499,6 +526,7 @@ static int __devinit da903x_probe(struct i2c_client *client,
 	chip->client = client;
 	chip->dev = &client->dev;
 	chip->ops = &da903x_ops[id->driver_data];
+	da9030_mfd_dev = &client->dev;
 
 	mutex_init(&chip->lock);
 	INIT_WORK(&chip->irq_work, da903x_irq_work);
@@ -559,6 +587,7 @@ static struct i2c_driver da903x_driver = {
 
 static int __init da903x_init(void)
 {
+	da9030_mfd_dev = NULL;
 	return i2c_add_driver(&da903x_driver);
 }
 module_init(da903x_init);
diff --git a/include/linux/mfd/da903x.h b/include/linux/mfd/da903x.h
index 115dbe9..5e15305 100644
--- a/include/linux/mfd/da903x.h
+++ b/include/linux/mfd/da903x.h
@@ -227,6 +227,11 @@ extern int da903x_unregister_notifier(struct device *dev,
 
 extern int da903x_query_status(struct device *dev, unsigned int status);
 
+#define DA9030_USBPUMP_AUTO		1
+#define DA9030_USBPUMP_CHARGE_PUMP	2
+#define DA9030_USBPUMP_CURRENT_SOURCE	3
+
+int da9030_set_usb_charge_pump_mode(int mode);
 
 /* NOTE: the functions below are not intended for use outside
  * of the DA903x sub-device drivers
