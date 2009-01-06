Return-Path: <linux-kernel-owner+w=401wt.eu-S1757902AbZAFWZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757902AbZAFWZ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:25:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756015AbZAFWNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:13:54 -0500
Received: from wf-out-1314.google.com ([209.85.200.171]:9428 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735AbZAFWNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:13:52 -0500
Subject: Re: [PATCH] rtc-ds1307: True SMBus compatibility
From: Ed Swierk <eswierk@aristanetworks.com>
To: BARRE Sebastien <sbarre@sdelcc.com>
Cc: linux-i2c@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       Alessandro Zummo <a.zummo@towertech.it>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <C1C62166118DFA4A8BBA01A2411F0D171224AECDC1@PRI-MBX-101.dom1.vinci-energies.net>
References: <1231176979.13443.19.camel@localhost.localdomain>
	 <C1C62166118DFA4A8BBA01A2411F0D171224AECDC1@PRI-MBX-101.dom1.vinci-energies.net>
Content-Type: multipart/mixed; boundary="=-HKD5X0y6qWXtY0G5eVk8"
Date: Tue, 06 Jan 2009 14:13:44 -0800
Message-Id: <1231280024.12030.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 (2.24.2-2.fc10) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-HKD5X0y6qWXtY0G5eVk8
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Tue, Jan 6, 2009 at 5:35 AM, BARRE Sebastien <sbarre@sdelcc.com> wrote:
> I've read your patch quicly, I will test it on my board as soon as possible.

Thanks.

> You can delete the next 3 lines, they are not useful:
>
>> +     ret = ds1307_read_block_data_once(client, command, length, currvalues);
>> +     if (ret < 0)
>> +             return ret;

Oops! Here is an updated patch with these lines removed, and a minor formatting fix.

Signed-off-by: Ed Swierk <eswierk@aristanetworks.com>

--Ed


--=-HKD5X0y6qWXtY0G5eVk8
Content-Disposition: attachment; filename="rtc-ds1307-pure-smbus-compatibility.patch"
Content-Type: text/x-patch; name="rtc-ds1307-pure-smbus-compatibility.patch"; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Index: linux-2.6.27.4/drivers/rtc/rtc-ds1307.c
===================================================================
--- linux-2.6.27.4.orig/drivers/rtc/rtc-ds1307.c
+++ linux-2.6.27.4/drivers/rtc/rtc-ds1307.c
@@ -132,6 +132,62 @@ MODULE_DEVICE_TABLE(i2c, ds1307_id);
 
 /*----------------------------------------------------------------------*/
 
+static s32 ds1307_read_block_data_once(struct i2c_client *client, u8 command,
+				  u8 length, u8 *values)
+{
+	s32 i, data;
+	for (i = 0; i < length; i++) {
+		data = i2c_smbus_read_byte_data(client, command + i);
+		if (data < 0)
+			return data;
+		*(values + i) = data;
+	}
+	return i;
+}
+
+static s32 ds1307_read_block_data(struct i2c_client *client, u8 command,
+				  u8 length, u8 *values)
+{
+	u8 oldvalues[I2C_SMBUS_BLOCK_MAX];
+	s32 ret;
+	pr_debug("ds1307_read_block_data (length=%d)\n", length);
+	ret = ds1307_read_block_data_once(client, command, length, values);
+	if (ret < 0)
+		return ret;
+	do {
+		s32 ret;
+		memcpy(oldvalues, values, length);
+		ret = ds1307_read_block_data_once(client, command, length, values);
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
+	s32 ret;
+	pr_debug("ds1307_write_block_data (length=%d)\n", length);
+	do {
+		s32 i, ret;
+		for (i = 0; i < length; i++) {
+			ret = i2c_smbus_write_byte_data(client, command + i,
+							*(values + i));
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
@@ -202,7 +258,7 @@ static int ds1307_get_time(struct device
 	int		tmp;
 
 	/* read the RTC date and time registers all at once */
-	tmp = i2c_smbus_read_i2c_block_data(ds1307->client,
+	tmp = ds1307_read_block_data(ds1307->client,
 		DS1307_REG_SECS, 7, ds1307->regs);
 	if (tmp != 7) {
 		dev_err(dev, "%s error %d\n", "read", tmp);
@@ -279,7 +335,7 @@ static int ds1307_set_time(struct device
 		"write", buf[0], buf[1], buf[2], buf[3],
 		buf[4], buf[5], buf[6]);
 
-	result = i2c_smbus_write_i2c_block_data(ds1307->client, 0, 7, buf);
+	result = ds1307_write_block_data(ds1307->client, 0, 7, buf);
 	if (result < 0) {
 		dev_err(dev, "%s error %d\n", "write", result);
 		return result;
@@ -297,7 +353,7 @@ static int ds1307_read_alarm(struct devi
 		return -EINVAL;
 
 	/* read all ALARM1, ALARM2, and status registers at once */
-	ret = i2c_smbus_read_i2c_block_data(client,
+	ret = ds1307_read_block_data(client,
 			DS1339_REG_ALARM1_SECS, 9, ds1307->regs);
 	if (ret != 9) {
 		dev_err(dev, "%s error %d\n", "alarm read", ret);
@@ -356,7 +412,7 @@ static int ds1307_set_alarm(struct devic
 		t->enabled, t->pending);
 
 	/* read current status of both alarms and the chip */
-	ret = i2c_smbus_read_i2c_block_data(client,
+	ret = ds1307_read_block_data(client,
 			DS1339_REG_ALARM1_SECS, 9, buf);
 	if (ret != 9) {
 		dev_err(dev, "%s error %d\n", "alarm write", ret);
@@ -391,7 +447,7 @@ static int ds1307_set_alarm(struct devic
 	}
 	buf[8] = status & ~(DS1337_BIT_A1I | DS1337_BIT_A2I);
 
-	ret = i2c_smbus_write_i2c_block_data(client,
+	ret = ds1307_write_block_data(client,
 			DS1339_REG_ALARM1_SECS, 9, buf);
 	if (ret < 0) {
 		dev_err(dev, "can't set alarm time\n");
@@ -479,7 +535,7 @@ ds1307_nvram_read(struct kobject *kobj, 
 	if (unlikely(!count))
 		return count;
 
-	result = i2c_smbus_read_i2c_block_data(client, 8 + off, count, buf);
+	result = ds1307_read_block_data(client, 8 + off, count, buf);
 	if (result < 0)
 		dev_err(&client->dev, "%s error %d\n", "nvram read", result);
 	return result;
@@ -501,7 +557,7 @@ ds1307_nvram_write(struct kobject *kobj,
 	if (unlikely(!count))
 		return count;
 
-	result = i2c_smbus_write_i2c_block_data(client, 8 + off, count, buf);
+	result = ds1307_write_block_data(client, 8 + off, count, buf);
 	if (result < 0) {
 		dev_err(&client->dev, "%s error %d\n", "nvram write", result);
 		return result;
@@ -537,8 +593,7 @@ static int __devinit ds1307_probe(struct
 	unsigned char		*buf;
 
 	if (!i2c_check_functionality(adapter,
-			I2C_FUNC_SMBUS_WRITE_BYTE_DATA |
-			I2C_FUNC_SMBUS_I2C_BLOCK))
+			I2C_FUNC_SMBUS_BYTE_DATA))
 		return -EIO;
 
 	if (!(ds1307 = kzalloc(sizeof(struct ds1307), GFP_KERNEL)))
@@ -558,7 +613,7 @@ static int __devinit ds1307_probe(struct
 			want_irq = true;
 		}
 		/* get registers that the "rtc" read below won't read... */
-		tmp = i2c_smbus_read_i2c_block_data(ds1307->client,
+		tmp = ds1307_read_block_data(ds1307->client,
 				DS1337_REG_CONTROL, 2, buf);
 		if (tmp != 2) {
 			pr_debug("read error %d\n", tmp);
@@ -596,7 +651,7 @@ static int __devinit ds1307_probe(struct
 
 read_rtc:
 	/* read RTC registers */
-	tmp = i2c_smbus_read_i2c_block_data(ds1307->client, 0, 8, buf);
+	tmp = ds1307_read_block_data(ds1307->client, 0, 8, buf);
 	if (tmp != 8) {
 		pr_debug("read error %d\n", tmp);
 		err = -EIO;

--=-HKD5X0y6qWXtY0G5eVk8--

