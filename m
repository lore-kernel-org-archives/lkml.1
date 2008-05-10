Return-Path: <linux-kernel-owner+w=401wt.eu-S1756778AbYEJQkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778AbYEJQkV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 12:40:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754925AbYEJQkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 12:40:08 -0400
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:34316 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754780AbYEJQkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 12:40:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=N9kNP7Ejo3Q7bZZHCzJKLnOs3KonhjpO/s6VIp9c/Oas9JjgMQrHq15xIgYqasw540286oUdzymxAeuMAsYCLU4jBJpJxYY0qttTuC2ZbNR/NG8slGJh3nLrBbMNqC8rtG7gLFseOFyT11ZGnPQibBX6Reo8DR7dtwsOr3ewsYQ=  ;
X-YMail-OSG: otf8KZAVM1nvzFtQI6osUUpw9Xi5DpGth28ef.aytRA438dUlShuAlEK.6Ec50CxWVQTDr1r7EODEUl05lFZtoccpc9UDzNUivZYf3CVVWJD3sr_gu33ltuAtWOIhEZkEL0-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: [i2c] [RFC][PATCH 4/4] RTC: SMBus support for the M41T80,
Date: Sat, 10 May 2008 09:36:50 -0700
User-Agent: KMail/1.9.6
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>, linux-mips@linux-mips.org,
       mgreer@mvista.com, rtc-linux@googlegroups.com,
       Atsushi Nemoto <anemo@mba.ocn.ne.jp>, linux-kernel@vger.kernel.org,
       i2c@lm-sensors.org, ab@mycable.de,
       Alessandro Zummo <alessandro.zummo@towertech.it>
References: <200805070120.03821.david-b@pacbell.net> <Pine.LNX.4.55.0805100301100.10552@cliff.in.clinika.pl> <20080510085340.29c26aef@hyperion.delvare>
In-Reply-To: <20080510085340.29c26aef@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200805100936.52057.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 May 2008, Jean Delvare wrote:
> 
> > > On a related note, you will notice that the other i2c_smbus_* functions
> > > do not follow the naming of SMBus transactions. Again that's something
> > > I regret but I feel that changing the names now would cause a lot of
> > > confusion amongst developers, so I'm not doing it.
> > 
> > It may not be worth the effort, but if done in bulk for all the users in
> > the tree, there should be no problem with that.  ...
> 
> It's not that easy. There are some drivers which are both in-tree and
> out-of-tree, for which such a change means adding ifdefs.

Actually, I thought it *WAS* that easy.  See the appended patch,
which goes on top of the various doc and (mostly SMBus) fault
handling patches I've sent ... the old names are still available
(only needed by out-of-tree drivers), but marked as __deprecated.
So:  no #ifdefs required.

I agree it's not worth while for *all* the SMBus functions that
use names-made-up-for-Linux.  But for the two which are really
badly misnamed (after *different* SMBus operations), I suggest
fixing would be a reasonable thing.


> And there is 
> i2c-dev.h (the user-space one) which has similar functions,

That's problematic in its own right though.  Not only that
the *kernel* file Documentation/i2c/dev-interface referring
to those functions, which are unavailable from the header
provided by the kernel.  Or that there's no relationship
between the kernel and userspace files of the same name.
But also that those functions are actually a bit too large
to be appropriate as inlines, even once you manage to track
it down (as part of a "tools" package, not a "library").


> if we 
> rename only the kernel variants, there will be some confusion. But if
> we rename also the user-space variants, then it's up to 2.4 kernel
> users to have different names for kernel-space and user-space functions.

True, but that would be a question for a "libsmbus" or somesuch
to deal with.  Not a kernel issue.

- Dave


===========
Two of the SMBus operations are using confusingly inappropriate names:

  i2c_smbus_read_byte() does not execute the SMBus "Read Byte" protocol
  	... it implements the SMBus "Receive Byte" protocol instead!!

  i2c_smbus_write_byte() does not execute the SMBus "Write Byte" protocol
  	... it implements the SMBus "Send Byte" protocol instead!!

This patch changes the names of those functions, so they no longer
use names of different operations (which they do not implement).

---
 Documentation/i2c/chips/max6875   |    4 ++--
 Documentation/i2c/smbus-protocol  |   12 +++++-------
 Documentation/i2c/writing-clients |    4 ++--
 drivers/gpio/pcf857x.c            |    8 ++++----
 drivers/hwmon/ds1621.c            |    2 +-
 drivers/hwmon/lm90.c              |    2 +-
 drivers/i2c/chips/eeprom.c        |   10 +++++-----
 drivers/i2c/chips/max6875.c       |    2 +-
 drivers/i2c/chips/pcf8574.c       |    4 ++--
 drivers/i2c/chips/pcf8591.c       |   10 +++++-----
 drivers/i2c/chips/tsl2550.c       |   16 ++++++++--------
 drivers/i2c/i2c-core.c            |   12 ++++++------
 drivers/media/video/saa7110.c     |    2 +-
 drivers/media/video/saa7185.c     |    2 +-
 drivers/media/video/tda9840.c     |    8 ++++----
 drivers/media/video/tea6415c.c    |    4 ++--
 drivers/media/video/tea6420.c     |    4 ++--
 drivers/w1/masters/ds2482.c       |   10 +++++-----
 include/linux/i2c.h               |   20 ++++++++++++++++++--
 19 files changed, 75 insertions(+), 61 deletions(-)

--- g26.orig/include/linux/i2c.h	2008-05-07 16:32:18.000000000 -0700
+++ g26/include/linux/i2c.h	2008-05-10 00:13:48.000000000 -0700
@@ -73,8 +73,8 @@ extern s32 i2c_smbus_xfer (struct i2c_ad
    conventions of smbus_access. */
 
 extern s32 i2c_smbus_write_quick(struct i2c_client * client, u8 value);
-extern s32 i2c_smbus_read_byte(struct i2c_client * client);
-extern s32 i2c_smbus_write_byte(struct i2c_client * client, u8 value);
+extern s32 i2c_smbus_receive_byte(struct i2c_client *client);
+extern s32 i2c_smbus_send_byte(struct i2c_client *client, u8 value);
 extern s32 i2c_smbus_read_byte_data(struct i2c_client * client, u8 command);
 extern s32 i2c_smbus_write_byte_data(struct i2c_client * client,
                                      u8 command, u8 value);
@@ -94,6 +94,22 @@ extern s32 i2c_smbus_write_i2c_block_dat
 					  u8 command, u8 length,
 					  const u8 *values);
 
+/* Stop using these legacy names in new code.
+ * - the SMBus "Read Byte" operation is i2c_smbus_read_byte_data()
+ * - the SMBus "Write Byte" operation is i2c_smbus_write_byte_data()
+ *
+ */
+static inline s32 __deprecated i2c_smbus_read_byte(struct i2c_client *client)
+{
+	return i2c_smbus_receive_byte(client);
+}
+
+static inline s32 __deprecated i2c_smbus_write_byte(struct i2c_client *client,
+		u8 value)
+{
+	return i2c_smbus_send_byte(client, value);
+}
+
 /*
  * A driver is capable of handling one or more physical devices present on
  * I2C adapters. This information is used to inform the driver of adapter
--- g26.orig/drivers/i2c/i2c-core.c	2008-05-07 16:32:18.000000000 -0700
+++ g26/drivers/i2c/i2c-core.c	2008-05-10 00:08:45.000000000 -0700
@@ -1529,13 +1529,13 @@ s32 i2c_smbus_write_quick(struct i2c_cli
 EXPORT_SYMBOL(i2c_smbus_write_quick);
 
 /**
- * i2c_smbus_read_byte - SMBus "receive byte" protocol
+ * i2c_smbus_receive_byte - SMBus "receive byte" protocol
  * @client: Handle to slave device
  *
  * This executes the SMBus "receive byte" protocol, returning negative errno
  * else the byte received from the device.
  */
-s32 i2c_smbus_read_byte(struct i2c_client *client)
+s32 i2c_smbus_receive_byte(struct i2c_client *client)
 {
 	union i2c_smbus_data data;
 	int status;
@@ -1545,22 +1545,22 @@ s32 i2c_smbus_read_byte(struct i2c_clien
 			I2C_SMBUS_BYTE, &data);
 	return (status < 0) ? status : data.byte;
 }
-EXPORT_SYMBOL(i2c_smbus_read_byte);
+EXPORT_SYMBOL(i2c_smbus_receive_byte);
 
 /**
- * i2c_smbus_write_byte - SMBus "send byte" protocol
+ * i2c_smbus_send_byte - SMBus "send byte" protocol
  * @client: Handle to slave device
  * @value: Byte to be sent
  *
  * This executes the SMBus "send byte" protocol, returning negative errno
  * else zero on success.
  */
-s32 i2c_smbus_write_byte(struct i2c_client *client, u8 value)
+s32 i2c_smbus_send_byte(struct i2c_client *client, u8 value)
 {
 	return i2c_smbus_xfer(client->adapter,client->addr,client->flags,
 	                      I2C_SMBUS_WRITE, value, I2C_SMBUS_BYTE, NULL);
 }
-EXPORT_SYMBOL(i2c_smbus_write_byte);
+EXPORT_SYMBOL(i2c_smbus_send_byte);
 
 /**
  * i2c_smbus_read_byte_data - SMBus "read byte" protocol
--- g26.orig/Documentation/i2c/chips/max6875	2007-07-12 16:32:15.000000000 -0700
+++ g26/Documentation/i2c/chips/max6875	2008-05-10 00:07:50.000000000 -0700
@@ -88,14 +88,14 @@ To write 0x5a to address 0x8003:
 
 Reading data from the EEPROM is a little more complicated.
 Use i2c_smbus_write_byte_data() to set the read address and then
-i2c_smbus_read_byte() or i2c_smbus_read_i2c_block_data() to read the data.
+i2c_smbus_receive_byte() or i2c_smbus_read_i2c_block_data() to read the data.
 
 Example:
 To read data starting at offset 0x8100, first set the address:
   i2c_smbus_write_byte_data(fd, 0x81, 0x00);
 
 And then read the data
-  value = i2c_smbus_read_byte(fd);
+  value = i2c_smbus_receive_byte(fd);
 
   or
 
--- g26.orig/Documentation/i2c/smbus-protocol	2008-05-10 00:13:59.000000000 -0700
+++ g26/Documentation/i2c/smbus-protocol	2008-05-10 00:15:14.000000000 -0700
@@ -18,9 +18,7 @@ handled at all on most pure SMBus adapte
 
 Below is a list of SMBus protocol operations, and the functions executing
 them.  Note that the names used in the SMBus protocol specifications usually
-don't match these function names.  For some of the operations which pass a
-single data byte, the functions using SMBus protocol operation names execute
-a different protocol operation entirely.
+don't match these function names.
 
 
 Key to symbols
@@ -49,8 +47,8 @@ This sends a single bit to the device, a
 A Addr Rd/Wr [A] P
 
 
-SMBus Receive Byte:  i2c_smbus_read_byte()
-==========================================
+SMBus Receive Byte:  i2c_smbus_receive_byte()
+=============================================
 
 This reads a single byte from a device, without specifying a device
 register. Some devices are so simple that this interface is enough; for
@@ -60,8 +58,8 @@ the previous SMBus command.
 S Addr Rd [A] [Data] NA P
 
 
-SMBus Send Byte:  i2c_smbus_write_byte()
-========================================
+SMBus Send Byte:  i2c_smbus_send_byte()
+=======================================
 
 This operation is the reverse of Receive Byte: it sends a single byte
 to a device.  See Receive Byte for more information.
--- g26.orig/Documentation/i2c/writing-clients	2008-04-29 21:51:55.000000000 -0700
+++ g26/Documentation/i2c/writing-clients	2008-05-10 00:07:50.000000000 -0700
@@ -560,8 +560,8 @@ SMBus communication
 
 
   extern s32 i2c_smbus_write_quick(struct i2c_client * client, u8 value);
-  extern s32 i2c_smbus_read_byte(struct i2c_client * client);
-  extern s32 i2c_smbus_write_byte(struct i2c_client * client, u8 value);
+  extern s32 i2c_smbus_receive_byte(struct i2c_client * client);
+  extern s32 i2c_smbus_send_byte(struct i2c_client * client, u8 value);
   extern s32 i2c_smbus_read_byte_data(struct i2c_client * client, u8 command);
   extern s32 i2c_smbus_write_byte_data(struct i2c_client * client,
                                        u8 command, u8 value);
--- g26.orig/drivers/gpio/pcf857x.c	2008-05-07 16:32:18.000000000 -0700
+++ g26/drivers/gpio/pcf857x.c	2008-05-10 00:07:50.000000000 -0700
@@ -68,7 +68,7 @@ static int pcf857x_input8(struct gpio_ch
 	struct pcf857x	*gpio = container_of(chip, struct pcf857x, chip);
 
 	gpio->out |= (1 << offset);
-	return i2c_smbus_write_byte(gpio->client, gpio->out);
+	return i2c_smbus_send_byte(gpio->client, gpio->out);
 }
 
 static int pcf857x_get8(struct gpio_chip *chip, unsigned offset)
@@ -76,7 +76,7 @@ static int pcf857x_get8(struct gpio_chip
 	struct pcf857x	*gpio = container_of(chip, struct pcf857x, chip);
 	s32		value;
 
-	value = i2c_smbus_read_byte(gpio->client);
+	value = i2c_smbus_receive_byte(gpio->client);
 	return (value < 0) ? 0 : (value & (1 << offset));
 }
 
@@ -89,7 +89,7 @@ static int pcf857x_output8(struct gpio_c
 		gpio->out |= bit;
 	else
 		gpio->out &= ~bit;
-	return i2c_smbus_write_byte(gpio->client, gpio->out);
+	return i2c_smbus_send_byte(gpio->client, gpio->out);
 }
 
 static void pcf857x_set8(struct gpio_chip *chip, unsigned offset, int value)
@@ -202,7 +202,7 @@ static int pcf857x_probe(struct i2c_clie
 
 		/* fail if there's no chip present */
 		else
-			status = i2c_smbus_read_byte(client);
+			status = i2c_smbus_receive_byte(client);
 
 	/* '75/'75c addresses are 0x20..0x27, just like the '74;
 	 * the '75c doesn't have a current source pulling high.
--- g26.orig/drivers/hwmon/ds1621.c	2008-03-28 11:08:28.000000000 -0700
+++ g26/drivers/hwmon/ds1621.c	2008-05-10 00:07:50.000000000 -0700
@@ -132,7 +132,7 @@ static void ds1621_init_client(struct i2
 	ds1621_write_value(client, DS1621_REG_CONF, reg);
 	
 	/* start conversion */
-	i2c_smbus_write_byte(client, DS1621_COM_START);
+	i2c_smbus_send_byte(client, DS1621_COM_START);
 }
 
 static ssize_t show_temp(struct device *dev, struct device_attribute *da,
--- g26.orig/drivers/hwmon/lm90.c	2008-03-28 11:08:29.000000000 -0700
+++ g26/drivers/hwmon/lm90.c	2008-05-10 00:07:50.000000000 -0700
@@ -463,7 +463,7 @@ static int lm90_read_reg(struct i2c_clie
  	if (client->flags & I2C_CLIENT_PEC) {
  		err = adm1032_write_byte(client, reg);
  		if (err >= 0)
- 			err = i2c_smbus_read_byte(client);
+			err = i2c_smbus_receive_byte(client);
  	} else
  		err = i2c_smbus_read_byte_data(client, reg);
 
--- g26.orig/drivers/i2c/chips/eeprom.c	2008-03-28 11:08:29.000000000 -0700
+++ g26/drivers/i2c/chips/eeprom.c	2008-05-10 00:07:50.000000000 -0700
@@ -93,12 +93,12 @@ static void eeprom_update_client(struct 
 							!= 32)
 					goto exit;
 		} else {
-			if (i2c_smbus_write_byte(client, slice << 5)) {
+			if (i2c_smbus_send_byte(client, slice << 5)) {
 				dev_dbg(&client->dev, "eeprom read start has failed!\n");
 				goto exit;
 			}
 			for (i = slice << 5; i < (slice + 1) << 5; i++) {
-				j = i2c_smbus_read_byte(client);
+				j = i2c_smbus_receive_byte(client);
 				if (j < 0)
 					goto exit;
 				data->data[i] = (u8) j;
@@ -208,9 +208,9 @@ static int eeprom_detect(struct i2c_adap
 		char name[4];
 
 		name[0] = i2c_smbus_read_byte_data(new_client, 0x80);
-		name[1] = i2c_smbus_read_byte(new_client);
-		name[2] = i2c_smbus_read_byte(new_client);
-		name[3] = i2c_smbus_read_byte(new_client);
+		name[1] = i2c_smbus_receive_byte(new_client);
+		name[2] = i2c_smbus_receive_byte(new_client);
+		name[3] = i2c_smbus_receive_byte(new_client);
 
 		if (!memcmp(name, "PCG-", 4) || !memcmp(name, "VGN-", 4)) {
 			dev_info(&new_client->dev, "Vaio EEPROM detected, "
--- g26.orig/drivers/i2c/chips/max6875.c	2008-03-28 10:42:32.000000000 -0700
+++ g26/drivers/i2c/chips/max6875.c	2008-05-10 00:07:50.000000000 -0700
@@ -112,7 +112,7 @@ static void max6875_update_slice(struct 
 			}
 		} else {
 			for (i = 0; i < SLICE_SIZE; i++) {
-				j = i2c_smbus_read_byte(client);
+				j = i2c_smbus_receive_byte(client);
 				if (j < 0) {
 					goto exit_up;
 				}
--- g26.orig/drivers/i2c/chips/pcf8574.c	2008-03-28 11:08:29.000000000 -0700
+++ g26/drivers/i2c/chips/pcf8574.c	2008-05-10 00:07:50.000000000 -0700
@@ -75,7 +75,7 @@ static struct i2c_driver pcf8574_driver 
 static ssize_t show_read(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct i2c_client *client = to_i2c_client(dev);
-	return sprintf(buf, "%u\n", i2c_smbus_read_byte(client));
+	return sprintf(buf, "%u\n", i2c_smbus_receive_byte(client));
 }
 
 static DEVICE_ATTR(read, S_IRUGO, show_read, NULL);
@@ -101,7 +101,7 @@ static ssize_t set_write(struct device *
 		return -EINVAL;
 
 	data->write = val;
-	i2c_smbus_write_byte(client, data->write);
+	i2c_smbus_send_byte(client, data->write);
 	return count;
 }
 
--- g26.orig/drivers/i2c/chips/pcf8591.c	2008-03-28 11:08:29.000000000 -0700
+++ g26/drivers/i2c/chips/pcf8591.c	2008-05-10 00:07:50.000000000 -0700
@@ -149,7 +149,7 @@ static ssize_t set_out0_enable(struct de
 		data->control |= PCF8591_CONTROL_AOEF;
 	else
 		data->control &= ~PCF8591_CONTROL_AOEF;
-	i2c_smbus_write_byte(client, data->control);
+	i2c_smbus_send_byte(client, data->control);
 	mutex_unlock(&data->update_lock);
 	return count;
 }
@@ -288,7 +288,7 @@ static void pcf8591_init_client(struct i
 	
 	/* The first byte transmitted contains the conversion code of the 
 	   previous read cycle. FLUSH IT! */
-	i2c_smbus_read_byte(client);
+	i2c_smbus_receive_byte(client);
 }
 
 static int pcf8591_read_channel(struct device *dev, int channel)
@@ -302,13 +302,13 @@ static int pcf8591_read_channel(struct d
 	if ((data->control & PCF8591_CONTROL_AICH_MASK) != channel) {
 		data->control = (data->control & ~PCF8591_CONTROL_AICH_MASK)
 			      | channel;
-		i2c_smbus_write_byte(client, data->control);
+		i2c_smbus_send_byte(client, data->control);
 	
 		/* The first byte transmitted contains the conversion code of 
 		   the previous read cycle. FLUSH IT! */
-		i2c_smbus_read_byte(client);
+		i2c_smbus_receive_byte(client);
 	}
-	value = i2c_smbus_read_byte(client);
+	value = i2c_smbus_receive_byte(client);
 
 	mutex_unlock(&data->update_lock);
 
--- g26.orig/drivers/i2c/chips/tsl2550.c	2008-04-29 21:51:56.000000000 -0700
+++ g26/drivers/i2c/chips/tsl2550.c	2008-05-10 00:07:50.000000000 -0700
@@ -68,7 +68,7 @@ static int tsl2550_set_operating_mode(st
 {
 	struct tsl2550_data *data = i2c_get_clientdata(client);
 
-	int ret = i2c_smbus_write_byte(client, TSL2550_MODE_RANGE[mode]);
+	int ret = i2c_smbus_send_byte(client, TSL2550_MODE_RANGE[mode]);
 
 	data->operating_mode = mode;
 
@@ -81,9 +81,9 @@ static int tsl2550_set_power_state(struc
 	int ret;
 
 	if (state == 0)
-		ret = i2c_smbus_write_byte(client, TSL2550_POWER_DOWN);
+		ret = i2c_smbus_send_byte(client, TSL2550_POWER_DOWN);
 	else {
-		ret = i2c_smbus_write_byte(client, TSL2550_POWER_UP);
+		ret = i2c_smbus_send_byte(client, TSL2550_POWER_UP);
 
 		/* On power up we should reset operating mode also... */
 		tsl2550_set_operating_mode(client, data->operating_mode);
@@ -107,14 +107,14 @@ static int tsl2550_get_adc_value(struct 
 	 */
 	end = jiffies + msecs_to_jiffies(400);
 	while (time_before(jiffies, end)) {
-		i2c_smbus_write_byte(client, cmd);
+		i2c_smbus_send_byte(client, cmd);
 
 		if (loop++ < 5)
 			mdelay(1);
 		else
 			msleep(1);
 
-		ret = i2c_smbus_read_byte(client);
+		ret = i2c_smbus_receive_byte(client);
 		if (ret < 0)
 			return ret;
 		else if (ret & 0x0080)
@@ -342,16 +342,16 @@ static int tsl2550_init_client(struct i2
 	 * Probe the chip. To do so we try to power up the device and then to
 	 * read back the 0x03 code
 	 */
-	err = i2c_smbus_write_byte(client, TSL2550_POWER_UP);
+	err = i2c_smbus_send_byte(client, TSL2550_POWER_UP);
 	if (err < 0)
 		return err;
 	mdelay(1);
-	if (i2c_smbus_read_byte(client) != TSL2550_POWER_UP)
+	if (i2c_smbus_receive_byte(client) != TSL2550_POWER_UP)
 		return -ENODEV;
 	data->power_state = 1;
 
 	/* Set the default operating mode */
-	err = i2c_smbus_write_byte(client,
+	err = i2c_smbus_send_byte(client,
 				   TSL2550_MODE_RANGE[data->operating_mode]);
 	if (err < 0)
 		return err;
--- g26.orig/drivers/media/video/saa7110.c	2008-04-24 13:45:59.000000000 -0700
+++ g26/drivers/media/video/saa7110.c	2008-05-10 00:07:51.000000000 -0700
@@ -127,7 +127,7 @@ saa7110_write_block (struct i2c_client *
 static inline int
 saa7110_read (struct i2c_client *client)
 {
-	return i2c_smbus_read_byte(client);
+	return i2c_smbus_receive_byte(client);
 }
 
 /* ----------------------------------------------------------------------- */
--- g26.orig/drivers/media/video/saa7185.c	2008-04-24 13:45:59.000000000 -0700
+++ g26/drivers/media/video/saa7185.c	2008-05-10 00:07:51.000000000 -0700
@@ -82,7 +82,7 @@ struct saa7185 {
 static inline int
 saa7185_read (struct i2c_client *client)
 {
-	return i2c_smbus_read_byte(client);
+	return i2c_smbus_receive_byte(client);
 }
 
 static int
--- g26.orig/drivers/media/video/tda9840.c	2008-04-24 13:45:59.000000000 -0700
+++ g26/drivers/media/video/tda9840.c	2008-05-10 00:07:51.000000000 -0700
@@ -74,7 +74,7 @@ static int command(struct i2c_client *cl
 
 		result = i2c_smbus_write_byte_data(client, SWITCH, byte);
 		if (result)
-			dprintk("i2c_smbus_write_byte() failed, ret:%d\n", result);
+			dprintk("i2c_smbus_write_byte_data() failed, ret:%d\n", result);
 		break;
 
 	case TDA9840_LEVEL_ADJUST:
@@ -94,7 +94,7 @@ static int command(struct i2c_client *cl
 
 		result = i2c_smbus_write_byte_data(client, LEVEL_ADJUST, byte);
 		if (result)
-			dprintk("i2c_smbus_write_byte() failed, ret:%d\n", result);
+			dprintk("i2c_smbus_write_byte_data() failed, ret:%d\n", result);
 		break;
 
 	case TDA9840_STEREO_ADJUST:
@@ -114,7 +114,7 @@ static int command(struct i2c_client *cl
 
 		result = i2c_smbus_write_byte_data(client, STEREO_ADJUST, byte);
 		if (result)
-			dprintk("i2c_smbus_write_byte() failed, ret:%d\n", result);
+			dprintk("i2c_smbus_write_byte_data() failed, ret:%d\n", result);
 		break;
 
 	case TDA9840_DETECT: {
@@ -144,7 +144,7 @@ static int command(struct i2c_client *cl
 
 		result = i2c_smbus_write_byte_data(client, TEST, byte);
 		if (result)
-			dprintk("i2c_smbus_write_byte() failed, ret:%d\n", result);
+			dprintk("i2c_smbus_write_byte_data() failed, ret:%d\n", result);
 		break;
 	default:
 		return -ENOIOCTLCMD;
--- g26.orig/drivers/media/video/tea6415c.c	2008-04-24 13:45:59.000000000 -0700
+++ g26/drivers/media/video/tea6415c.c	2008-05-10 00:07:51.000000000 -0700
@@ -165,9 +165,9 @@ static int switch_matrix(struct i2c_clie
 		break;
 	};
 
-	ret = i2c_smbus_write_byte(client, byte);
+	ret = i2c_smbus_send_byte(client, byte);
 	if (ret) {
-		dprintk("i2c_smbus_write_byte() failed, ret:%d\n", ret);
+		dprintk("i2c_smbus_send_byte() failed, ret:%d\n", ret);
 		return -EIO;
 	}
 
--- g26.orig/drivers/media/video/tea6420.c	2008-04-24 13:45:59.000000000 -0700
+++ g26/drivers/media/video/tea6420.c	2008-05-10 00:07:51.000000000 -0700
@@ -79,9 +79,9 @@ static int tea6420_switch(struct i2c_cli
 		break;
 	}
 
-	ret = i2c_smbus_write_byte(client, byte);
+	ret = i2c_smbus_send_byte(client, byte);
 	if (ret) {
-		dprintk("i2c_smbus_write_byte() failed, ret:%d\n", ret);
+		dprintk("i2c_smbus_send_byte() failed, ret:%d\n", ret);
 		return -EIO;
 	}
 
--- g26.orig/drivers/w1/masters/ds2482.c	2008-03-28 10:42:44.000000000 -0700
+++ g26/drivers/w1/masters/ds2482.c	2008-05-10 00:07:51.000000000 -0700
@@ -167,7 +167,7 @@ static inline int ds2482_select_register
  */
 static inline int ds2482_send_cmd(struct ds2482_data *pdev, u8 cmd)
 {
-	if (i2c_smbus_write_byte(&pdev->client, cmd) < 0)
+	if (i2c_smbus_send_byte(&pdev->client, cmd) < 0)
 		return -1;
 
 	pdev->read_prt = DS2482_PTR_CODE_STATUS;
@@ -216,7 +216,7 @@ static int ds2482_wait_1wire_idle(struct
 
 	if (!ds2482_select_register(pdev, DS2482_PTR_CODE_STATUS)) {
 		do {
-			temp = i2c_smbus_read_byte(&pdev->client);
+			temp = i2c_smbus_receive_byte(&pdev->client);
 		} while ((temp >= 0) && (temp & DS2482_REG_STS_1WB) &&
 			 (++retries < DS2482_WAIT_IDLE_TIMEOUT));
 	}
@@ -244,7 +244,7 @@ static int ds2482_set_channel(struct ds2
 
 	pdev->read_prt = DS2482_PTR_CODE_CHANNEL;
 	pdev->channel = -1;
-	if (i2c_smbus_read_byte(&pdev->client) == ds2482_chan_rd[channel]) {
+	if (i2c_smbus_receive_byte(&pdev->client) == ds2482_chan_rd[channel]) {
 		pdev->channel = channel;
 		return 0;
 	}
@@ -368,7 +368,7 @@ static u8 ds2482_w1_read_byte(void *data
 	ds2482_select_register(pdev, DS2482_PTR_CODE_DATA);
 
 	/* Read the data byte */
-	result = i2c_smbus_read_byte(&pdev->client);
+	result = i2c_smbus_receive_byte(&pdev->client);
 
 	mutex_unlock(&pdev->access_lock);
 
@@ -463,7 +463,7 @@ static int ds2482_detect(struct i2c_adap
 	ndelay(525);
 
 	/* Read the status byte - only reset bit and line should be set */
-	temp1 = i2c_smbus_read_byte(new_client);
+	temp1 = i2c_smbus_receive_byte(new_client);
 	if (temp1 != (DS2482_REG_STS_LL | DS2482_REG_STS_RST)) {
 		dev_dbg(&adapter->dev, "DS2482 (0x%02x) reset status "
 			"0x%02X - not a DS2482\n", address, temp1);

