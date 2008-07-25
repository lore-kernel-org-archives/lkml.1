Return-Path: <linux-kernel-owner+w=401wt.eu-S1757312AbYGYWYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312AbYGYWYd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 18:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbYGYWYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 18:24:12 -0400
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:43093 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751937AbYGYWYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 18:24:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:To:Subject:Content-Disposition:From:Date:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=wV34XTAwzm0J2IgFuq+i4ldwnJi0WoD8wEBCt3M/Dtd0ez0z5k/pHRZ/P6dUAcL0//n3a9CkJbyeVOypVJQgxzdzIONt4fP/HuxB1kJ9NFsHr0UJH0ZcSUiNl7HTW9I71AAwhqoi0/S3Ca/kRqVW7eRwTl7uo2oYWVzziKUiVX4=  ;
X-YMail-OSG: DwcBGp0VM1mvqQtz3M8h.qrnb.AnzUjjQGseuRh2jJWjLoP.XmDZI7pSaS9x1Xmyaqy_VlhWYSfGFZuCqQkiRyflLrzQf_6mw74_ec4WZ2GC7zAPXkQ8N2gglOCJRBLOoc0-
X-Yahoo-Newman-Property: ymail-3
To: "Mark M. Hoffman" <mhoffman@lightlink.com>, lm-sensors@lm-sensors.org
Subject: [RESEND x9+ patch 2.6.26-git 2/2] lm75:  new style driver binding
Content-Disposition: inline
From: David Brownell <david-b@pacbell.net>
Date: Fri, 25 Jul 2008 15:24:08 -0700
Cc: lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200807251524.08382.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[add lkml to cc list]

From: David Brownell <dbrownell@users.sourceforge.net>

More LM75 updates:

 - Teach the LM75 driver to use new-style driver binding:

     * Create a second driver struct, using new-style driver binding
       methods cribbed from the legacy code.

     * Add a MODULE_DEVICE_TABLE ("newER-style binding")

     * The legacy probe logic delegates its work to this new code.

     * The legacy driver uses the name "lm75_legacy".

 - More careful initialization.  Chips are put into 9-bit mode so
   the current interconversion routines will never fail.

 - Save the original chip configuration, and restore it on exit.
   (Among other things, this normally turns off the mode where
   the chip is constantly sampling, and thus saves power.)

So the new-style code should catch all chips that boards declare,
while the legacy code catches others.  This particular coexistence
strategy may need some work yet ... legacy modes might best be set
up explicitly by some tool not unlike "sensors-detect".  (Or else
completely eradicated...)

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Acked-by: Jean Delvare <khali@linux-fr.org>
---
Yeah, I know there is now *YET ANOTHER* way to handle the legacy
probe logic.  Someone else can switch to use that; I'm tired of
seeing these patches not get merged.


 drivers/hwmon/Kconfig |    7 +
 drivers/hwmon/lm75.c  |  206 ++++++++++++++++++++++++++++++++++++++------------
 2 files changed, 165 insertions(+), 48 deletions(-)

--- a/drivers/hwmon/Kconfig	2008-06-30 21:21:39.000000000 -0700
+++ b/drivers/hwmon/Kconfig	2008-06-30 21:21:40.000000000 -0700
@@ -406,7 +406,12 @@ config SENSORS_LM75
 		- TelCom (now Microchip) TCN75
 		- Texas Instruments TMP100, TMP101, TMP75, TMP175, TMP275
 
-	  Most of these chips will require a "force" module parameter.
+	  This driver supports driver model based binding through board
+	  specific I2C device tables.
+
+	  It also supports the "legacy" style of driver binding.  To use
+	  that with some chips which don't replicate LM75 quirks exactly,
+	  you may need the "force" module parameter.
 
 	  This driver can also be built as a module.  If so, the module
 	  will be called lm75.
--- a/drivers/hwmon/lm75.c	2008-06-30 21:21:39.000000000 -0700
+++ b/drivers/hwmon/lm75.c	2008-06-30 21:21:40.000000000 -0700
@@ -32,10 +32,28 @@
 
 /*
  * This driver handles the LM75 and compatible digital temperature sensors.
- * Compatibles include at least the DS75, DS1775, MCP980x, STDS75, TCN75,
- * TMP100, TMP101, TMP75, TMP175, and TMP275.
+ * Only types which are _not_ listed in I2C_CLIENT_INSMOD_*() need to be
+ * listed here.  We start at 9 since I2C_CLIENT_INSMOD_*() currently allow
+ * definition of up to 8 chip types (plus zero).
  */
 
+enum lm75_type {		/* keep sorted in alphabetical order */
+	ds1775 = 9,
+	ds75,
+	/* lm75 -- in I2C_CLIENT_INSMOD_1() */
+	lm75a,
+	max6625,
+	max6626,
+	mcp980x,
+	stds75,
+	tcn75,
+	tmp100,
+	tmp101,
+	tmp175,
+	tmp275,
+	tmp75,
+};
+
 /* Addresses scanned by legacy style driver binding */
 static const unsigned short normal_i2c[] = { 0x48, 0x49, 0x4a, 0x4b, 0x4c,
 					0x4d, 0x4e, 0x4f, I2C_CLIENT_END };
@@ -54,9 +72,10 @@ static const u8 LM75_REG_TEMP[3] = {
 
 /* Each client has this additional data */
 struct lm75_data {
-	struct i2c_client	client;
+	struct i2c_client	*client;
 	struct device		*hwmon_dev;
 	struct mutex		update_lock;
+	u8			orig_conf;
 	char			valid;		/* !=0 if registers are valid */
 	unsigned long		last_updated;	/* In jiffies */
 	u16			temp[3];	/* Register values,
@@ -65,7 +84,6 @@ struct lm75_data {
 						   2 = hyst */
 };
 
-static void lm75_init_client(struct i2c_client *client);
 static int lm75_read_value(struct i2c_client *client, u8 reg);
 static int lm75_write_value(struct i2c_client *client, u8 reg, u16 value);
 static struct lm75_data *lm75_update_device(struct device *dev);
@@ -120,16 +138,124 @@ static const struct attribute_group lm75
 
 /*-----------------------------------------------------------------------*/
 
+/* "New style" I2C driver binding -- following the driver model */
+
+static int
+lm75_probe(struct i2c_client *client, const struct i2c_device_id *id)
+{
+	struct lm75_data *data;
+	int status;
+	u8 set_mask, clr_mask;
+	int new;
+
+	if (!i2c_check_functionality(client->adapter,
+			I2C_FUNC_SMBUS_BYTE_DATA | I2C_FUNC_SMBUS_WORD_DATA))
+		return -EIO;
+
+	data = kzalloc(sizeof(struct lm75_data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	i2c_set_clientdata(client, data);
+
+	data->client = client;
+	mutex_init(&data->update_lock);
+
+	/* Set to LM75 resolution (9 bits, 1/2 degree C) and range.
+	 * Then tweak to be more precise when appropriate.
+	 */
+	set_mask = 0;
+	clr_mask = (1 << 0)			/* continuous conversions */
+		| (1 << 6) | (1 << 5);		/* 9-bit mode */
+
+	/* configure as specified */
+	status = lm75_read_value(client, LM75_REG_CONF);
+	if (status < 0) {
+		dev_dbg(&client->dev, "Can't read config? %d\n", status);
+		goto exit_free;
+	}
+	data->orig_conf = status;
+	new = status & ~clr_mask;
+	new |= set_mask;
+	if (status != new)
+		lm75_write_value(client, LM75_REG_CONF, new);
+	dev_dbg(&client->dev, "Config %02x\n", new);
+
+	/* Register sysfs hooks */
+	status = sysfs_create_group(&client->dev.kobj, &lm75_group);
+	if (status)
+		goto exit_free;
+
+	data->hwmon_dev = hwmon_device_register(&client->dev);
+	if (IS_ERR(data->hwmon_dev)) {
+		status = PTR_ERR(data->hwmon_dev);
+		goto exit_remove;
+	}
+
+	dev_info(&client->dev, "%s: sensor '%s'\n",
+		data->hwmon_dev->bus_id, client->name);
+
+	return 0;
+
+exit_remove:
+	sysfs_remove_group(&client->dev.kobj, &lm75_group);
+exit_free:
+	i2c_set_clientdata(client, NULL);
+	kfree(data);
+	return status;
+}
+
+static int lm75_remove(struct i2c_client *client)
+{
+	struct lm75_data *data = i2c_get_clientdata(client);
+
+	hwmon_device_unregister(data->hwmon_dev);
+	sysfs_remove_group(&client->dev.kobj, &lm75_group);
+	lm75_write_value(client, LM75_REG_CONF, data->orig_conf);
+	i2c_set_clientdata(client, NULL);
+	kfree(data);
+	return 0;
+}
+
+static const struct i2c_device_id lm75_ids[] = {
+	{ "ds1775", ds1775, },
+	{ "ds75", ds75, },
+	{ "lm75", lm75, },
+	{ "lm75a", lm75a, },
+	{ "max6625", max6625, },
+	{ "max6626", max6626, },
+	{ "mcp980x", mcp980x, },
+	{ "stds75", stds75, },
+	{ "tcn75", tcn75, },
+	{ "tmp100", tmp100, },
+	{ "tmp101", tmp101, },
+	{ "tmp175", tmp175, },
+	{ "tmp275", tmp275, },
+	{ "tmp75", tmp75, },
+	{ /* LIST END */ }
+};
+MODULE_DEVICE_TABLE(i2c, lm75_ids);
+
+static struct i2c_driver lm75_driver = {
+	.driver = {
+		.name	= "lm75",
+	},
+	.probe		= lm75_probe,
+	.remove		= lm75_remove,
+	.id_table	= lm75_ids,
+};
+
+/*-----------------------------------------------------------------------*/
+
 /* "Legacy" I2C driver binding */
 
-static struct i2c_driver lm75_driver;
+static struct i2c_driver lm75_legacy_driver;
 
 /* This function is called by i2c_probe */
 static int lm75_detect(struct i2c_adapter *adapter, int address, int kind)
 {
 	int i;
 	struct i2c_client *new_client;
-	struct lm75_data *data;
 	int err = 0;
 
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA |
@@ -139,16 +265,15 @@ static int lm75_detect(struct i2c_adapte
 	/* OK. For now, we presume we have a valid address. We create the
 	   client structure, even though there may be no sensor present.
 	   But it allows us to use i2c_smbus_read_*_data() calls. */
-	if (!(data = kzalloc(sizeof(struct lm75_data), GFP_KERNEL))) {
+	new_client = kzalloc(sizeof *new_client, GFP_KERNEL);
+	if (!new_client) {
 		err = -ENOMEM;
 		goto exit;
 	}
 
-	new_client = &data->client;
-	i2c_set_clientdata(new_client, data);
 	new_client->addr = address;
 	new_client->adapter = adapter;
-	new_client->driver = &lm75_driver;
+	new_client->driver = &lm75_legacy_driver;
 	new_client->flags = 0;
 
 	/* Now, we do the remaining detection. There is no identification-
@@ -189,38 +314,26 @@ static int lm75_detect(struct i2c_adapte
 				goto exit_free;
 	}
 
-	/* NOTE: we treat "force=..." and "force_lm75=..." the same. */
+	/* NOTE: we treat "force=..." and "force_lm75=..." the same.
+	 * Only new-style driver binding distinguishes chip types.
+	 */
 	strlcpy(new_client->name, "lm75", I2C_NAME_SIZE);
 
-	/* Fill in the remaining client fields and put it into the global list */
-	data->valid = 0;
-	mutex_init(&data->update_lock);
-
 	/* Tell the I2C layer a new client has arrived */
-	if ((err = i2c_attach_client(new_client)))
+	err = i2c_attach_client(new_client);
+	if (err)
 		goto exit_free;
 
-	/* Initialize the LM75 chip */
-	lm75_init_client(new_client);
-
-	/* Register sysfs hooks */
-	if ((err = sysfs_create_group(&new_client->dev.kobj, &lm75_group)))
+	err = lm75_probe(new_client, NULL);
+	if (err < 0)
 		goto exit_detach;
 
-	data->hwmon_dev = hwmon_device_register(&new_client->dev);
-	if (IS_ERR(data->hwmon_dev)) {
-		err = PTR_ERR(data->hwmon_dev);
-		goto exit_remove;
-	}
-
 	return 0;
 
-exit_remove:
-	sysfs_remove_group(&new_client->dev.kobj, &lm75_group);
 exit_detach:
 	i2c_detach_client(new_client);
 exit_free:
-	kfree(data);
+	kfree(new_client);
 exit:
 	return err;
 }
@@ -234,17 +347,15 @@ static int lm75_attach_adapter(struct i2
 
 static int lm75_detach_client(struct i2c_client *client)
 {
-	struct lm75_data *data = i2c_get_clientdata(client);
-	hwmon_device_unregister(data->hwmon_dev);
-	sysfs_remove_group(&client->dev.kobj, &lm75_group);
+	lm75_remove(client);
 	i2c_detach_client(client);
-	kfree(data);
+	kfree(client);
 	return 0;
 }
 
-static struct i2c_driver lm75_driver = {
+static struct i2c_driver lm75_legacy_driver = {
 	.driver = {
-		.name	= "lm75",
+		.name	= "lm75_legacy",
 	},
 	.attach_adapter	= lm75_attach_adapter,
 	.detach_client	= lm75_detach_client,
@@ -276,16 +387,6 @@ static int lm75_write_value(struct i2c_c
 		return i2c_smbus_write_word_data(client, reg, swab16(value));
 }
 
-static void lm75_init_client(struct i2c_client *client)
-{
-	int reg;
-
-	/* Enable if in shutdown mode */
-	reg = lm75_read_value(client, LM75_REG_CONF);
-	if (reg >= 0 && (reg & 0x01))
-		lm75_write_value(client, LM75_REG_CONF, reg & 0xfe);
-}
-
 static struct lm75_data *lm75_update_device(struct device *dev)
 {
 	struct i2c_client *client = to_i2c_client(dev);
@@ -323,11 +424,22 @@ static struct lm75_data *lm75_update_dev
 
 static int __init sensors_lm75_init(void)
 {
-	return i2c_add_driver(&lm75_driver);
+	int status;
+
+	status = i2c_add_driver(&lm75_driver);
+	if (status < 0)
+		return status;
+
+	status = i2c_add_driver(&lm75_legacy_driver);
+	if (status < 0)
+		i2c_del_driver(&lm75_driver);
+
+	return status;
 }
 
 static void __exit sensors_lm75_exit(void)
 {
+	i2c_del_driver(&lm75_legacy_driver);
 	i2c_del_driver(&lm75_driver);
 }
 
