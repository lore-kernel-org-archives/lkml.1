Return-Path: <linux-kernel-owner+w=401wt.eu-S1756813AbYGYWYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813AbYGYWYT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 18:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbYGYWYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 18:24:11 -0400
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:43083 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751935AbYGYWYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 18:24:10 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:To:Subject:Content-Disposition:From:Date:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=LQHrnUQuGxZZ9HhS4+zQH/f1hIlat37ZGQkjfWLcME/UyB501QDL6z3Id+q4f9Fou92sJzbHcaQWKJRVQxIBv5RhoaNd20aWy3NwerShbOvn9/nskBPKP6pp8o+sFxDhuKpSD7v9o1ayhe4lnsXkC+G1A6dQ4NnBYWtFm7vCYc4=  ;
X-YMail-OSG: rvjVME8VM1mH_M4XNHKIAPIOOrwTb6Vro78SC632MIwNTVjlveQtWbAa5gW4uYv7NRRoU45URlfkg72thUxVGng4sGvkDb3ZJKCTgExu8GzylnhNJGr8Tg12qWx1RpRoACA-
X-Yahoo-Newman-Property: ymail-3
To: "Mark M. Hoffman" <mhoffman@lightlink.com>, lm-sensors@lm-sensors.org
Subject: [RESEND x9+ patch 2.6.26-git 1/2] lm75:  cleanup and reorg
Content-Disposition: inline
From: David Brownell <david-b@pacbell.net>
Date: Fri, 25 Jul 2008 15:23:28 -0700
Cc: lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200807251523.28242.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ added LKML to cc list ]

From: David Brownell <dbrownell@users.sourceforge.net>

Minor cleanup and reorg of the lm75 code.

 - Kconfig provides a larger list of lm75-compatible chips

 - A top comment now says what the driver does (!) ... as in, just
   what sort of sensor is this??

 - Section comments now delineate the various sections of the driver:
   hwmon attributes, driver binding, register access, module glue.
   One driver binding function moved out of the attribute section,
   as did the driver struct itself.

 - Minor tweaks to legacy probe logic:  correct a comment, and
   remove a pointless variable.

 - Whitespace, linelength, and comment fixes.

This patch should include no functional changes.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Acked-by: Jean Delvare <khali@linux-fr.org>
Acked-by: Laurent Pinchart <laurentp@cse-semaphore.com>
---
 drivers/hwmon/Kconfig |   18 ++++++----
 drivers/hwmon/lm75.c  |   90 ++++++++++++++++++++++++++++----------------------
 2 files changed, 63 insertions(+), 45 deletions(-)

--- a/drivers/hwmon/Kconfig	2008-06-30 21:20:50.000000000 -0700
+++ b/drivers/hwmon/Kconfig	2008-06-30 21:21:39.000000000 -0700
@@ -394,13 +394,19 @@ config SENSORS_LM75
 	tristate "National Semiconductor LM75 and compatibles"
 	depends on I2C
 	help
-	  If you say yes here you get support for National Semiconductor LM75
-	  sensor chips and clones: Dallas Semiconductor DS75 and DS1775 (in
-	  9-bit precision mode), and TelCom (now Microchip) TCN75.
+	  If you say yes here you get support for one common type of
+	  temperature sensor chip, with models including:
 
-	  The DS75 and DS1775 in 10- to 12-bit precision modes will require
-	  a force module parameter. The driver will not handle the extra
-	  precision anyhow.
+		- Dallas Semiconductor DS75 and DS1775
+		- Maxim MAX6625 and MAX6626
+		- Microchip MCP980x
+		- National Semiconductor LM75
+		- NXP's LM75A
+		- ST Microelectronics STDS75
+		- TelCom (now Microchip) TCN75
+		- Texas Instruments TMP100, TMP101, TMP75, TMP175, TMP275
+
+	  Most of these chips will require a "force" module parameter.
 
 	  This driver can also be built as a module.  If so, the module
 	  will be called lm75.
--- a/drivers/hwmon/lm75.c	2008-06-30 21:20:50.000000000 -0700
+++ b/drivers/hwmon/lm75.c	2008-06-30 21:21:39.000000000 -0700
@@ -30,14 +30,19 @@
 #include "lm75.h"
 
 
-/* Addresses to scan */
+/*
+ * This driver handles the LM75 and compatible digital temperature sensors.
+ * Compatibles include at least the DS75, DS1775, MCP980x, STDS75, TCN75,
+ * TMP100, TMP101, TMP75, TMP175, and TMP275.
+ */
+
+/* Addresses scanned by legacy style driver binding */
 static const unsigned short normal_i2c[] = { 0x48, 0x49, 0x4a, 0x4b, 0x4c,
 					0x4d, 0x4e, 0x4f, I2C_CLIENT_END };
 
-/* Insmod parameters */
+/* Insmod parameters (only for legacy style driver binding) */
 I2C_CLIENT_INSMOD_1(lm75);
 
-/* Many LM75 constants specified below */
 
 /* The LM75 registers */
 #define LM75_REG_CONF		0x01
@@ -50,9 +55,9 @@ static const u8 LM75_REG_TEMP[3] = {
 /* Each client has this additional data */
 struct lm75_data {
 	struct i2c_client	client;
-	struct device *hwmon_dev;
+	struct device		*hwmon_dev;
 	struct mutex		update_lock;
-	char			valid;		/* !=0 if following fields are valid */
+	char			valid;		/* !=0 if registers are valid */
 	unsigned long		last_updated;	/* In jiffies */
 	u16			temp[3];	/* Register values,
 						   0 = input
@@ -60,23 +65,15 @@ struct lm75_data {
 						   2 = hyst */
 };
 
-static int lm75_attach_adapter(struct i2c_adapter *adapter);
-static int lm75_detect(struct i2c_adapter *adapter, int address, int kind);
 static void lm75_init_client(struct i2c_client *client);
-static int lm75_detach_client(struct i2c_client *client);
 static int lm75_read_value(struct i2c_client *client, u8 reg);
 static int lm75_write_value(struct i2c_client *client, u8 reg, u16 value);
 static struct lm75_data *lm75_update_device(struct device *dev);
 
 
-/* This is the driver that will be inserted */
-static struct i2c_driver lm75_driver = {
-	.driver = {
-		.name	= "lm75",
-	},
-	.attach_adapter	= lm75_attach_adapter,
-	.detach_client	= lm75_detach_client,
-};
+/*-----------------------------------------------------------------------*/
+
+/* sysfs attributes for hwmon */
 
 static ssize_t show_temp(struct device *dev, struct device_attribute *da,
 			 char *buf)
@@ -109,13 +106,6 @@ static SENSOR_DEVICE_ATTR(temp1_max_hyst
 			show_temp, set_temp, 2);
 static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO, show_temp, NULL, 0);
 
-static int lm75_attach_adapter(struct i2c_adapter *adapter)
-{
-	if (!(adapter->class & I2C_CLASS_HWMON))
-		return 0;
-	return i2c_probe(adapter, &addr_data, lm75_detect);
-}
-
 static struct attribute *lm75_attributes[] = {
 	&sensor_dev_attr_temp1_input.dev_attr.attr,
 	&sensor_dev_attr_temp1_max.dev_attr.attr,
@@ -128,6 +118,12 @@ static const struct attribute_group lm75
 	.attrs = lm75_attributes,
 };
 
+/*-----------------------------------------------------------------------*/
+
+/* "Legacy" I2C driver binding */
+
+static struct i2c_driver lm75_driver;
+
 /* This function is called by i2c_probe */
 static int lm75_detect(struct i2c_adapter *adapter, int address, int kind)
 {
@@ -135,15 +131,14 @@ static int lm75_detect(struct i2c_adapte
 	struct i2c_client *new_client;
 	struct lm75_data *data;
 	int err = 0;
-	const char *name = "";
 
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA |
 				     I2C_FUNC_SMBUS_WORD_DATA))
 		goto exit;
 
-	/* OK. For now, we presume we have a valid client. We now create the
-	   client structure, even though we cannot fill it completely yet.
-	   But it allows us to access lm75_{read,write}_value. */
+	/* OK. For now, we presume we have a valid address. We create the
+	   client structure, even though there may be no sensor present.
+	   But it allows us to use i2c_smbus_read_*_data() calls. */
 	if (!(data = kzalloc(sizeof(struct lm75_data), GFP_KERNEL))) {
 		err = -ENOMEM;
 		goto exit;
@@ -174,17 +169,17 @@ static int lm75_detect(struct i2c_adapte
 		 || i2c_smbus_read_word_data(new_client, 5) != hyst
 		 || i2c_smbus_read_word_data(new_client, 6) != hyst
 		 || i2c_smbus_read_word_data(new_client, 7) != hyst)
-		 	goto exit_free;
+			goto exit_free;
 		os = i2c_smbus_read_word_data(new_client, 3);
 		if (i2c_smbus_read_word_data(new_client, 4) != os
 		 || i2c_smbus_read_word_data(new_client, 5) != os
 		 || i2c_smbus_read_word_data(new_client, 6) != os
 		 || i2c_smbus_read_word_data(new_client, 7) != os)
-		 	goto exit_free;
+			goto exit_free;
 
 		/* Unused bits */
 		if (conf & 0xe0)
-		 	goto exit_free;
+			goto exit_free;
 
 		/* Addresses cycling */
 		for (i = 8; i < 0xff; i += 8)
@@ -194,16 +189,10 @@ static int lm75_detect(struct i2c_adapte
 				goto exit_free;
 	}
 
-	/* Determine the chip type - only one kind supported! */
-	if (kind <= 0)
-		kind = lm75;
-
-	if (kind == lm75) {
-		name = "lm75";
-	}
+	/* NOTE: we treat "force=..." and "force_lm75=..." the same. */
+	strlcpy(new_client->name, "lm75", I2C_NAME_SIZE);
 
 	/* Fill in the remaining client fields and put it into the global list */
-	strlcpy(new_client->name, name, I2C_NAME_SIZE);
 	data->valid = 0;
 	mutex_init(&data->update_lock);
 
@@ -213,7 +202,7 @@ static int lm75_detect(struct i2c_adapte
 
 	/* Initialize the LM75 chip */
 	lm75_init_client(new_client);
-	
+
 	/* Register sysfs hooks */
 	if ((err = sysfs_create_group(&new_client->dev.kobj, &lm75_group)))
 		goto exit_detach;
@@ -236,6 +225,13 @@ exit:
 	return err;
 }
 
+static int lm75_attach_adapter(struct i2c_adapter *adapter)
+{
+	if (!(adapter->class & I2C_CLASS_HWMON))
+		return 0;
+	return i2c_probe(adapter, &addr_data, lm75_detect);
+}
+
 static int lm75_detach_client(struct i2c_client *client)
 {
 	struct lm75_data *data = i2c_get_clientdata(client);
@@ -246,6 +242,18 @@ static int lm75_detach_client(struct i2c
 	return 0;
 }
 
+static struct i2c_driver lm75_driver = {
+	.driver = {
+		.name	= "lm75",
+	},
+	.attach_adapter	= lm75_attach_adapter,
+	.detach_client	= lm75_detach_client,
+};
+
+/*-----------------------------------------------------------------------*/
+
+/* register access */
+
 /* All registers are word-sized, except for the configuration register.
    LM75 uses a high-byte first convention, which is exactly opposite to
    the SMBus standard. */
@@ -309,6 +317,10 @@ static struct lm75_data *lm75_update_dev
 	return data;
 }
 
+/*-----------------------------------------------------------------------*/
+
+/* module glue */
+
 static int __init sensors_lm75_init(void)
 {
 	return i2c_add_driver(&lm75_driver);
