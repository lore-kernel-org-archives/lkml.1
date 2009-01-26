Return-Path: <linux-kernel-owner+w=401wt.eu-S1752014AbZAZGeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014AbZAZGeP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 01:34:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751153AbZAZGd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 01:33:59 -0500
Received: from wf-out-1314.google.com ([209.85.200.173]:9657 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbZAZGd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 01:33:57 -0500
Subject: Re: [PATCH] rtc-ds1307: True SMBus compatibility
From: Ed Swierk <eswierk@aristanetworks.com>
To: Jean Delvare <khali@linux-fr.org>, linux-i2c@vger.kernel.org,
       David Brownell <david-b@pacbell.net>,
       Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       BARRE Sebastien <sbarre@sdelcc.com>
In-Reply-To: <20090120114304.3b956189@hyperion.delvare>
References: <1231177261.13443.20.camel@localhost.localdomain>
	 <20090107142426.4be04d4d@hyperion.delvare>
	 <9ae48b020901070722l77bebc6boc8fa2fd0bcc8da28@mail.gmail.com>
	 <20090107162709.755982c0@hyperion.delvare>
	 <1232409577.25123.11.camel@localhost.localdomain>
	 <20090120114304.3b956189@hyperion.delvare>
Content-Type: multipart/mixed; boundary="=-p6Xk1+gmvUPY+YKZ8fD2"
Date: Sun, 25 Jan 2009 22:33:50 -0800
Message-Id: <1232951630.1329.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-p6Xk1+gmvUPY+YKZ8fD2
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Here's another attempt at a patch for rtc-ds1307 that allows the driver
to work with SMBus controllers like nforce2 that do not support i2c
block transfers.  The byte-oriented compatibility routines now give up
after 10 unsuccessful attempts to read or write a block of registers
without conflict.

Signed-off-by: Ed Swierk <eswierk@aristanetworks.com>


--=-p6Xk1+gmvUPY+YKZ8fD2
Content-Disposition: attachment; filename="rtc-ds1307-pure-smbus-compatibility.patch"
Content-Type: text/x-patch; name="rtc-ds1307-pure-smbus-compatibility.patch"; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Index: linux-2.6.27.4/drivers/rtc/rtc-ds1307.c
===================================================================
--- linux-2.6.27.4.orig/drivers/rtc/rtc-ds1307.c
+++ linux-2.6.27.4/drivers/rtc/rtc-ds1307.c
@@ -94,6 +94,10 @@ struct ds1307 {
 	struct i2c_client	*client;
 	struct rtc_device	*rtc;
 	struct work_struct	work;
+	s32 (*read_block_data)(struct i2c_client *client, u8 command,
+			       u8 length, u8 *values);
+	s32 (*write_block_data)(struct i2c_client *client, u8 command,
+				u8 length, const u8 *values);
 };
 
 struct chip_desc {
@@ -132,6 +136,75 @@ MODULE_DEVICE_TABLE(i2c, ds1307_id);
 
 /*----------------------------------------------------------------------*/
 
+#define BLOCK_DATA_MAX_TRIES 10
+
+static s32 ds1307_read_block_data_once(struct i2c_client *client, u8 command,
+				  u8 length, u8 *values)
+{
+	s32 i, data;
+	for (i = 0; i < length; i++) {
+		data = i2c_smbus_read_byte_data(client, command + i);
+		if (data < 0)
+			return data;
+		values[i] = data;
+	}
+	return i;
+}
+
+static s32 ds1307_read_block_data(struct i2c_client *client, u8 command,
+				  u8 length, u8 *values)
+{
+	u8 oldvalues[I2C_SMBUS_BLOCK_MAX];
+	s32 ret;
+	int tries = 0;
+	dev_dbg(&client->dev, "ds1307_read_block_data (length=%d)\n", length);
+	ret = ds1307_read_block_data_once(client, command, length, values);
+	if (ret < 0)
+		return ret;
+	do {
+		if (++tries > BLOCK_DATA_MAX_TRIES) {
+			dev_err(&client->dev,
+				"ds1307_read_block_data failed\n");
+			return -EIO;
+		}
+		memcpy(oldvalues, values, length);
+		ret = ds1307_read_block_data_once(client, command, length,
+						  values);
+		if (ret < 0)
+			return ret;
+	} while (memcmp(oldvalues, values, length));
+	return length;
+}
+
+static s32 ds1307_write_block_data(struct i2c_client *client, u8 command,
+				   u8 length, const u8 *values)
+{
+	u8 currvalues[I2C_SMBUS_BLOCK_MAX];
+	int tries = 0;
+	dev_dbg(&client->dev, "ds1307_write_block_data (length=%d)\n", length);
+	do {
+		s32 i, ret;
+		if (++tries > BLOCK_DATA_MAX_TRIES) {
+			dev_err(&client->dev,
+				"ds1307_write_block_data failed\n");
+			return -EIO;
+		}
+		for (i = 0; i < length; i++) {
+			ret = i2c_smbus_write_byte_data(client, command + i,
+							values[i]);
+			if (ret < 0)
+				return ret;
+		}
+		ret = ds1307_read_block_data_once(client, command, length,
+						  currvalues);
+		if (ret < 0)
+			return ret;
+	} while (memcmp(currvalues, values, length));
+	return length;
+}
+
+/*----------------------------------------------------------------------*/
+
 /*
  * The IRQ logic includes a "real" handler running in IRQ context just
  * long enough to schedule this workqueue entry.   We need a task context
@@ -202,7 +275,7 @@ static int ds1307_get_time(struct device
 	int		tmp;
 
 	/* read the RTC date and time registers all at once */
-	tmp = i2c_smbus_read_i2c_block_data(ds1307->client,
+	tmp = ds1307->read_block_data(ds1307->client,
 		DS1307_REG_SECS, 7, ds1307->regs);
 	if (tmp != 7) {
 		dev_err(dev, "%s error %d\n", "read", tmp);
@@ -279,7 +352,7 @@ static int ds1307_set_time(struct device
 		"write", buf[0], buf[1], buf[2], buf[3],
 		buf[4], buf[5], buf[6]);
 
-	result = i2c_smbus_write_i2c_block_data(ds1307->client, 0, 7, buf);
+	result = ds1307->write_block_data(ds1307->client, 0, 7, buf);
 	if (result < 0) {
 		dev_err(dev, "%s error %d\n", "write", result);
 		return result;
@@ -297,7 +370,7 @@ static int ds1307_read_alarm(struct devi
 		return -EINVAL;
 
 	/* read all ALARM1, ALARM2, and status registers at once */
-	ret = i2c_smbus_read_i2c_block_data(client,
+	ret = ds1307->read_block_data(client,
 			DS1339_REG_ALARM1_SECS, 9, ds1307->regs);
 	if (ret != 9) {
 		dev_err(dev, "%s error %d\n", "alarm read", ret);
@@ -356,7 +429,7 @@ static int ds1307_set_alarm(struct devic
 		t->enabled, t->pending);
 
 	/* read current status of both alarms and the chip */
-	ret = i2c_smbus_read_i2c_block_data(client,
+	ret = ds1307->read_block_data(client,
 			DS1339_REG_ALARM1_SECS, 9, buf);
 	if (ret != 9) {
 		dev_err(dev, "%s error %d\n", "alarm write", ret);
@@ -391,7 +464,7 @@ static int ds1307_set_alarm(struct devic
 	}
 	buf[8] = status & ~(DS1337_BIT_A1I | DS1337_BIT_A2I);
 
-	ret = i2c_smbus_write_i2c_block_data(client,
+	ret = ds1307->write_block_data(client,
 			DS1339_REG_ALARM1_SECS, 9, buf);
 	if (ret < 0) {
 		dev_err(dev, "can't set alarm time\n");
@@ -479,7 +552,7 @@ ds1307_nvram_read(struct kobject *kobj, 
 	if (unlikely(!count))
 		return count;
 
-	result = i2c_smbus_read_i2c_block_data(client, 8 + off, count, buf);
+	result = ds1307->read_block_data(client, 8 + off, count, buf);
 	if (result < 0)
 		dev_err(&client->dev, "%s error %d\n", "nvram read", result);
 	return result;
@@ -490,9 +563,11 @@ ds1307_nvram_write(struct kobject *kobj,
 		char *buf, loff_t off, size_t count)
 {
 	struct i2c_client	*client;
+	struct ds1307		*ds1307;
 	int			result;
 
 	client = kobj_to_i2c_client(kobj);
+	ds1307 = i2c_get_clientdata(client);
 
 	if (unlikely(off >= NVRAM_SIZE))
 		return -EFBIG;
@@ -501,7 +576,7 @@ ds1307_nvram_write(struct kobject *kobj,
 	if (unlikely(!count))
 		return count;
 
-	result = i2c_smbus_write_i2c_block_data(client, 8 + off, count, buf);
+	result = ds1307->write_block_data(client, 8 + off, count, buf);
 	if (result < 0) {
 		dev_err(&client->dev, "%s error %d\n", "nvram write", result);
 		return result;
@@ -536,9 +611,8 @@ static int __devinit ds1307_probe(struct
 	int			want_irq = false;
 	unsigned char		*buf;
 
-	if (!i2c_check_functionality(adapter,
-			I2C_FUNC_SMBUS_WRITE_BYTE_DATA |
-			I2C_FUNC_SMBUS_I2C_BLOCK))
+	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA)
+	    && !i2c_check_functionality(adapter, I2C_FUNC_SMBUS_I2C_BLOCK))
 		return -EIO;
 
 	if (!(ds1307 = kzalloc(sizeof(struct ds1307), GFP_KERNEL)))
@@ -548,6 +622,13 @@ static int __devinit ds1307_probe(struct
 	i2c_set_clientdata(client, ds1307);
 	ds1307->type = id->driver_data;
 	buf = ds1307->regs;
+	if (i2c_check_functionality(adapter, I2C_FUNC_SMBUS_I2C_BLOCK)) {
+		ds1307->read_block_data = i2c_smbus_read_i2c_block_data;
+		ds1307->write_block_data = i2c_smbus_write_i2c_block_data;
+	} else {
+		ds1307->read_block_data = ds1307_read_block_data;
+		ds1307->write_block_data = ds1307_write_block_data;
+	}
 
 	switch (ds1307->type) {
 	case ds_1337:
@@ -558,7 +639,7 @@ static int __devinit ds1307_probe(struct
 			want_irq = true;
 		}
 		/* get registers that the "rtc" read below won't read... */
-		tmp = i2c_smbus_read_i2c_block_data(ds1307->client,
+		tmp = ds1307->read_block_data(ds1307->client,
 				DS1337_REG_CONTROL, 2, buf);
 		if (tmp != 2) {
 			pr_debug("read error %d\n", tmp);
@@ -596,7 +677,7 @@ static int __devinit ds1307_probe(struct
 
 read_rtc:
 	/* read RTC registers */
-	tmp = i2c_smbus_read_i2c_block_data(ds1307->client, 0, 8, buf);
+	tmp = ds1307->read_block_data(ds1307->client, 0, 8, buf);
 	if (tmp != 8) {
 		pr_debug("read error %d\n", tmp);
 		err = -EIO;

--=-p6Xk1+gmvUPY+YKZ8fD2--

