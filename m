Return-Path: <linux-kernel-owner+w=401wt.eu-S1753512AbYAPQ2F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbYAPQ2F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 11:28:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751269AbYAPQ1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 11:27:51 -0500
Received: from LAubervilliers-151-12-100-178.w193-252.abo.wanadoo.fr ([193.252.204.178]:35120
	"EHLO smtp.til-technologies.fr" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751014AbYAPQ1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 11:27:50 -0500
X-Greylist: delayed 1319 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Jan 2008 11:27:48 EST
Message-ID: <478E3043.2070709@til-technologies.fr>
Date: Wed, 16 Jan 2008 17:26:43 +0100
From: frederic RODO <f.rodo@til-technologies.fr>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] rtc-ds1307 : add sysfs support for trickle charger
X-Enigmail-Version: 0.95.6
OpenPGP: id=A61987DC
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-MDHeloLookup-Result: pass smtp.helo=[172.16.90.43] (ip=172.16.90.43) (smtp.til-technologies.fr)
X-MDMailLookup-Result: pass smtp.mail=f.rodo@til-technologies.fr (ip=172.16.90.43) (smtp.til-technologies.fr)
X-Spam-Processed: smtp.til-technologies.fr, Wed, 16 Jan 2008 17:26:47 +0100
	(not processed: message from valid local sender)
X-Return-Path: prvs=19016a249a=f.rodo@til-technologies.fr
X-Envelope-From: f.rodo@til-technologies.fr
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
X-Info: Locally scanned for viruses
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch add two callbacks (show and store) to support the trickle 
charger for ds_1339 and ds_1340 (it can also be used for the ds1388).

I'm not sure if it'is the right way for adding this support. Can someone 
explain me a better way?

It was test on a custom board with a ds_1340. The ds_1339 support was 
not tested.

If you have any comments, please CC me


log from test

Linux version 2.6.24-rc7 (fredo@srv-devhard) (gcc version 3.4.6) #14 Wed 
Jan 16 15:40:55 CET 2008
..........
i2c /dev entries driver
rtc-ds1307 0-0068: rtc core: registered ds1340 as rtc0
rtc-ds1307 0-0068: trickle charger
i2c-gpio i2c-gpio: using pins 55 (SDA) and 56 (SCL)
....
# cd /sys/class/rtc/rtc0/device/
# cat trickle
0xaa (trickle charger enabled)
# echo 0 > trickle
# cat trickle
0x00 (trickle charger disabled)


Signed-off-by: Frederic RODO <f.rodo@til-technologies.fr>

diff --git a/drivers/rtc/rtc-ds1307.c b/drivers/rtc/rtc-ds1307.c
index 3a86898..4564238 100644
--- a/drivers/rtc/rtc-ds1307.c
+++ b/drivers/rtc/rtc-ds1307.c
@@ -77,6 +77,7 @@ enum ds_type {
  #	define DS1340_BIT_FT		0x40
  #	define DS1340_BIT_CALIB_SIGN	0x20
  #	define DS1340_M_CALIBRATION	0x1f
+#define DS1340_REG_TRICKLE	0x08
  #define DS1340_REG_FLAG		0x09
  #	define DS1340_BIT_OSF		0x80
  #define DS1337_REG_STATUS	0x0f
@@ -90,6 +91,7 @@ enum ds_type {
  struct ds1307 {
  	u8			reg_addr;
  	bool			has_nvram;
+	bool			has_trickle;
  	u8			regs[8];
  	enum ds_type		type;
  	struct i2c_msg		msg[2];
@@ -102,6 +104,7 @@ struct chip_desc {
  	char			name[9];
  	unsigned		nvram56:1;
  	unsigned		alarm:1;
+	unsigned		trickle:1;
  	enum ds_type		type;
  };

@@ -121,9 +124,11 @@ static const struct chip_desc chips[] = { {
  	.name		= "ds1339",
  	.type		= ds_1339,
  	.alarm		= 1,
+	.trickle	= 1,
  }, {
  	.name		= "ds1340",
  	.type		= ds_1340,
+	.trickle	= 1,
  }, {
  	.name		= "m41t00",
  	.type		= m41t00,
@@ -322,6 +327,72 @@ static struct bin_attribute nvram = {
  	.size	= NVRAM_SIZE,
  };

+static ssize_t ds1307_sysfs_show_trickle(struct device *dev,
+				       struct device_attribute *attr,
+				       char *buf)
+{
+	struct ds1307		*ds1307 = dev_get_drvdata(dev);
+	struct i2c_client	*client = to_i2c_client(dev);
+	int trickle;
+
+	switch (ds1307->type) {
+	case ds_1339:
+		trickle = i2c_smbus_read_byte_data(client, DS1339_REG_TRICKLE);
+		break;
+	case ds_1340:
+		trickle = i2c_smbus_read_byte_data(client, DS1340_REG_TRICKLE);
+		break;
+	default: return -EIO;
+	}
+
+	if (trickle < 0)
+		return trickle;
+
+	return sprintf(buf, "0x%02x (trickle charger %s)\n", (u8) trickle,
+					     (((trickle & 0xf0) != 0xa0) ||
+					      ((trickle & 0x0c) == 0x0c) ||
+					      ((trickle & 0x0c) == 0) ||
+					      ((trickle & 0x03) == 0))
+					      ? "disabled" : "enabled");
+}
+
+static ssize_t ds1307_sysfs_store_trickle(struct device *dev,
+				       struct device_attribute *attr,
+				       const char *buf, size_t count)
+{
+	struct ds1307		*ds1307 = dev_get_drvdata(dev);
+	struct i2c_client	*client = to_i2c_client(dev);
+	int err;
+	int trickle = -1;
+
+	if (buf[0] == '0' && (buf[1] == 'x' || buf[1] == 'X')) {
+		if (sscanf(buf, "%x", &trickle) != 1)
+			return -EINVAL;
+	} else {
+		if (sscanf(buf, "%d", &trickle) != 1)
+			return -EINVAL;
+	}
+
+	if (trickle < 0 || trickle > 0xff)
+		return -EINVAL;
+
+	switch (ds1307->type) {
+	case ds_1339:
+		err = i2c_smbus_write_byte_data(client,	DS1339_REG_TRICKLE,
+						trickle);
+		break;
+	case ds_1340:
+		err = i2c_smbus_write_byte_data(client,	DS1340_REG_TRICKLE,
+						trickle);
+		break;
+	default: return -EIO;
+	}
+
+	return (err < 0) ? -EIO : 1;
+}
+static DEVICE_ATTR(trickle, S_IRUGO | S_IWUSR, ds1307_sysfs_show_trickle,
+		   ds1307_sysfs_store_trickle);
+
  /*----------------------------------------------------------------------*/

  static struct i2c_driver ds1307_driver;
@@ -526,6 +597,14 @@ read_rtc:
  		}
  	}

+	if (chip->trickle) {
+		err = device_create_file(&client->dev, &dev_attr_trickle);
+		if (err == 0) {
+			ds1307->has_trickle = true;
+			dev_info(&client->dev, "trickle charger\n");
+		}
+	}
+
  	return 0;

  exit_bad:
@@ -548,6 +627,9 @@ static int __devexit ds1307_remove(struct i2c_client 
*client)
  	if (ds1307->has_nvram)
  		sysfs_remove_bin_file(&client->dev.kobj, &nvram);

+	if (ds1307->has_trickle)
+		device_remove_file(&client->dev, &dev_attr_trickle);
+
  	rtc_device_unregister(ds1307->rtc);
  	kfree(ds1307);
  	return 0;


-------------------------------------------------------------------------
Les informations précédentes peuvent être confidentielles ou privilégiées.
Si vous n'êtes pas le destinataire prévu de ce mail, veuillez en notifier 
l'expéditeur en répondant à ce message puis supprimez-en toute trace 
de vos systèmes.

TIL Technologies
Parc du Golf, Bat 43
350 rue J.R Guilibert Gautier de la Lauzière 
13856 AIX EN PROVENCE
Tel. : +33 4 42 37 11 77
-------------------------------------------------------------------------


