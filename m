Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768Ab0BTJwH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 04:52:07 -0500
Received: from inca-roads.misterjones.org ([213.251.177.50]:38544 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752906Ab0BTJwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 04:52:04 -0500
Date: Sat, 20 Feb 2010 09:51:53 +0000
From: Marc Zyngier <maz@misterjones.org>
To: Eduardo Valentin <eduardo.valentin@nokia.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] si4713: enable support for si4711 FM-RDS transmitter
Message-ID: <20100220095153.06ae2dff@taxman.wild-wind.fr.eu.org>
Organization: Metropolis -- Nowhere
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 77.203.141.186
X-SA-Exim-Rcpt-To: eduardo.valentin@nokia.com, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@misterjones.org
X-SA-Exim-Scanned: No (on inca-roads.misterjones.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

si4711 is extremely similar to si4713, except for the RNL measure
feature which is absent.

This patch introduce a 'features' field in the driver private structure
which is then used to do the right thing. It should be generic enough
to support the other members of the si471x family.

Signed-off-by: Marc Zyngier <maz@misterjones.org>
---
 Documentation/video4linux/si4713.txt |    6 +++---
 drivers/media/radio/Kconfig          |    8 ++++----
 drivers/media/radio/si4713-i2c.c     |   26 +++++++++++++++++++++-----
 drivers/media/radio/si4713-i2c.h     |    2 ++
 4 files changed, 30 insertions(+), 12 deletions(-)

diff --git a/Documentation/video4linux/si4713.txt b/Documentation/video4linux/si4713.txt
index 2e7392a..4ea63b2 100644
--- a/Documentation/video4linux/si4713.txt
+++ b/Documentation/video4linux/si4713.txt
@@ -1,4 +1,4 @@
-Driver for I2C radios for the Silicon Labs Si4713 FM Radio Transmitters
+Driver for I2C radios for the Silicon Labs Si4711/13 FM Radio Transmitters
 
 Copyright (c) 2009 Nokia Corporation
 Contact: Eduardo Valentin <eduardo.valentin@nokia.com>
@@ -127,8 +127,8 @@ rds_pty - Sets the RDS PTY field for transmission.
 
 preemphasis - sets the preemphasis to be applied for transmission.
 
-RNL
-===
+RNL (si4713 only)
+=================
 
 This device also has an interface to measure received noise level. To do that, you should
 ioctl the device node. Here is an code of example:
diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
index 3f40f37..1367e44 100644
--- a/drivers/media/radio/Kconfig
+++ b/drivers/media/radio/Kconfig
@@ -346,21 +346,21 @@ config RADIO_ZOLTRIX_PORT
 	  Enter the I/O port of your Zoltrix radio card.
 
 config I2C_SI4713
-	tristate "I2C driver for Silicon Labs Si4713 device"
+	tristate "I2C driver for Silicon Labs Si4711/13 device"
 	depends on I2C && VIDEO_V4L2
 	---help---
-	  Say Y here if you want support to Si4713 I2C device.
+	  Say Y here if you want support to Si4711/13 I2C device.
 	  This device driver supports only i2c bus.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called si4713.
 
 config RADIO_SI4713
-	tristate "Silicon Labs Si4713 FM Radio Transmitter support"
+	tristate "Silicon Labs Si4711/13 FM Radio Transmitter support"
 	depends on I2C && VIDEO_V4L2
 	select I2C_SI4713
 	---help---
-	  Say Y here if you want support to Si4713 FM Radio Transmitter.
+	  Say Y here if you want support to Si4711/13 FM Radio Transmitter.
 	  This device can transmit audio through FM. It can transmit
 	  RDS and RBDS signals as well. This module is the v4l2 radio
 	  interface for the i2c driver of this device.
diff --git a/drivers/media/radio/si4713-i2c.c b/drivers/media/radio/si4713-i2c.c
index 6a0028e..2cece0b 100644
--- a/drivers/media/radio/si4713-i2c.c
+++ b/drivers/media/radio/si4713-i2c.c
@@ -42,6 +42,9 @@ MODULE_AUTHOR("Eduardo Valentin <eduardo.valentin@nokia.com>");
 MODULE_DESCRIPTION("I2C driver for Si4713 FM Radio Transmitter");
 MODULE_VERSION("0.0.1");
 
+#define SI471X_ID_MASK			0xff
+#define SI471X_HAS_RNL			(1 << 8)
+
 #define DEFAULT_RDS_PI			0x00
 #define DEFAULT_RDS_PTY			0x00
 #define DEFAULT_RDS_PS_NAME		""
@@ -437,11 +440,14 @@ static int si4713_checkrev(struct si4713_device *sdev)
 	if (rval < 0)
 		goto unlock;
 
-	if (resp[1] == SI4713_PRODUCT_NUMBER) {
+	if (resp[1] == (sdev->features & SI471X_ID_MASK)) {
 		v4l2_info(&sdev->sd, "chip found @ 0x%02x (%s)\n",
 				client->addr << 1, client->adapter->name);
 	} else {
-		v4l2_err(&sdev->sd, "Invalid product number\n");
+		v4l2_err(&sdev->sd, "Invalid product number: "
+				    "%02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x\n",
+				    resp[0], resp[1], resp[2], resp[3],
+				    resp[4], resp[5], resp[6], resp[7]);
 		rval = -EINVAL;
 	}
 
@@ -1296,11 +1302,15 @@ static int si4713_setup(struct si4713_device *sdev)
 /*
  * si4713_initialize - Sets the device up with default configuration.
  * @sdev: si4713_device structure for the device we are communicating
+ * @id: i2c_device_id structure identifying the si471x device
  */
-static int si4713_initialize(struct si4713_device *sdev)
+static int si4713_initialize(struct si4713_device *sdev,
+			     const struct i2c_device_id *id)
 {
 	int rval;
 
+	sdev->features = (u32) id->driver_data;
+
 	rval = si4713_set_power_state(sdev, POWER_ON);
 	if (rval < 0)
 		goto exit;
@@ -1743,6 +1753,11 @@ long si4713_ioctl(struct v4l2_subdev *sd, unsigned int cmd, void *arg)
 	mutex_lock(&sdev->mutex);
 	switch (cmd) {
 	case SI4713_IOC_MEASURE_RNL:
+		if (!(sdev->features & SI471X_HAS_RNL)) {
+			rval = -EOPNOTSUPP;
+			break;
+		}
+
 		frequency = v4l2_to_si4713(rnl->frequency);
 
 		if (sdev->power_state) {
@@ -1992,7 +2007,7 @@ static int si4713_probe(struct i2c_client *client,
 		v4l2_warn(&sdev->sd, "IRQ not configured. Using timeouts.\n");
 	}
 
-	rval = si4713_initialize(sdev);
+	rval = si4713_initialize(sdev, id);
 	if (rval < 0) {
 		v4l2_err(&sdev->sd, "Failed to probe device information.\n");
 		goto free_irq;
@@ -2030,7 +2045,8 @@ static int si4713_remove(struct i2c_client *client)
 
 /* si4713_i2c_driver - i2c driver interface */
 static const struct i2c_device_id si4713_id[] = {
-	{ "si4713" , 0 },
+	{ "si4711" , SI4711_PRODUCT_NUMBER },
+	{ "si4713" , SI4713_PRODUCT_NUMBER | SI471X_HAS_RNL },
 	{ },
 };
 MODULE_DEVICE_TABLE(i2c, si4713_id);
diff --git a/drivers/media/radio/si4713-i2c.h b/drivers/media/radio/si4713-i2c.h
index faf8cff..f7649a2 100644
--- a/drivers/media/radio/si4713-i2c.h
+++ b/drivers/media/radio/si4713-i2c.h
@@ -18,6 +18,7 @@
 #include <media/v4l2-subdev.h>
 #include <media/si4713.h>
 
+#define SI4711_PRODUCT_NUMBER		0x0B
 #define SI4713_PRODUCT_NUMBER		0x0D
 
 /* Command Timeouts */
@@ -233,5 +234,6 @@ struct si4713_device {
 	u32 antenna_capacitor;
 	u32 stereo;
 	u32 tune_rnl;
+	u32 features;
 };
 #endif /* ifndef SI4713_I2C_H */
-- 
1.7.0



-- 
I'm the slime oozin' out from your TV set...
