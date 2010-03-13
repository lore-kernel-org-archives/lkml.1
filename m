Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936402Ab0CMBW0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:22:26 -0500
Received: from kroah.org ([198.145.64.141]:60892 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934852Ab0CMAUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:20:21 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:10 2010
Message-Id: <20100313001510.854784404@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:12:43 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jean Delvare <khali@linux-fr.org>, Hans de Goede <hdegoede@redhat.com>,
       Andre Prendel <andre.prendel@gmx.de>
Subject: [patch 065/123] hwmon: Fix off-by-one kind values
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Jean Delvare <khali@linux-fr.org>

commit dc71afe5ac7e8d049bb991330518e4c898a7d92e upstream.

Recent changes on the I2C front have left off-by-one array indexes in
3 hwmon drivers. Fix them.

Faulty commit:
e5e9f44c2 i2c: Drop I2C_CLIENT_INSMOD_2 to 8

Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Andre Prendel <andre.prendel@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/fschmd.c |   15 ++++++---------
 drivers/hwmon/tmp401.c |    7 +++----
 drivers/hwmon/tmp421.c |    4 ++--
 3 files changed, 11 insertions(+), 15 deletions(-)

--- a/drivers/hwmon/fschmd.c
+++ b/drivers/hwmon/fschmd.c
@@ -267,7 +267,7 @@ struct fschmd_data {
 	struct list_head list; /* member of the watchdog_data_list */
 	struct kref kref;
 	struct miscdevice watchdog_miscdev;
-	int kind;
+	enum chips kind;
 	unsigned long watchdog_is_open;
 	char watchdog_expect_close;
 	char watchdog_name[10]; /* must be unique to avoid sysfs conflict */
@@ -325,8 +325,7 @@ static ssize_t show_in_value(struct devi
 	int index = to_sensor_dev_attr(devattr)->index;
 	struct fschmd_data *data = fschmd_update_device(dev);
 
-	/* fscher / fschrc - 1 as data->kind is an array index, not a chips */
-	if (data->kind == (fscher - 1) || data->kind >= (fschrc - 1))
+	if (data->kind == fscher || data->kind >= fschrc)
 		return sprintf(buf, "%d\n", (data->volt[index] * dmi_vref *
 			dmi_mult[index]) / 255 + dmi_offset[index]);
 	else
@@ -492,7 +491,7 @@ static ssize_t show_pwm_auto_point1_pwm(
 	int val = data->fan_min[index];
 
 	/* 0 = allow turning off (except on the syl), 1-255 = 50-100% */
-	if (val || data->kind == fscsyl - 1)
+	if (val || data->kind == fscsyl)
 		val = val / 2 + 128;
 
 	return sprintf(buf, "%d\n", val);
@@ -506,7 +505,7 @@ static ssize_t store_pwm_auto_point1_pwm
 	unsigned long v = simple_strtoul(buf, NULL, 10);
 
 	/* reg: 0 = allow turning off (except on the syl), 1-255 = 50-100% */
-	if (v || data->kind == fscsyl - 1) {
+	if (v || data->kind == fscsyl) {
 		v = SENSORS_LIMIT(v, 128, 255);
 		v = (v - 128) * 2 + 1;
 	}
@@ -1037,7 +1036,7 @@ static int fschmd_detect(struct i2c_clie
 	else
 		return -ENODEV;
 
-	strlcpy(info->type, fschmd_id[kind - 1].name, I2C_NAME_SIZE);
+	strlcpy(info->type, fschmd_id[kind].name, I2C_NAME_SIZE);
 
 	return 0;
 }
@@ -1065,6 +1064,7 @@ static int fschmd_probe(struct i2c_clien
 	   (where the client is found through a data ptr instead of the
 	   otherway around) */
 	data->client = client;
+	data->kind = kind;
 
 	if (kind == fscpos) {
 		/* The Poseidon has hardwired temp limits, fill these
@@ -1085,9 +1085,6 @@ static int fschmd_probe(struct i2c_clien
 		}
 	}
 
-	/* i2c kind goes from 1-6, we want from 0-5 to address arrays */
-	data->kind = kind - 1;
-
 	/* Read in some never changing registers */
 	data->revision = i2c_smbus_read_byte_data(client, FSCHMD_REG_REVISION);
 	data->global_control = i2c_smbus_read_byte_data(client,
--- a/drivers/hwmon/tmp401.c
+++ b/drivers/hwmon/tmp401.c
@@ -134,7 +134,7 @@ struct tmp401_data {
 	struct mutex update_lock;
 	char valid; /* zero until following fields are valid */
 	unsigned long last_updated; /* in jiffies */
-	int kind;
+	enum chips kind;
 
 	/* register values */
 	u8 status;
@@ -524,7 +524,7 @@ static int tmp401_detect(struct i2c_clie
 	if (reg > 15)
 		return -ENODEV;
 
-	strlcpy(info->type, tmp401_id[kind - 1].name, I2C_NAME_SIZE);
+	strlcpy(info->type, tmp401_id[kind].name, I2C_NAME_SIZE);
 
 	return 0;
 }
@@ -572,8 +572,7 @@ static int tmp401_probe(struct i2c_clien
 		goto exit_remove;
 	}
 
-	dev_info(&client->dev, "Detected TI %s chip\n",
-		 names[data->kind - 1]);
+	dev_info(&client->dev, "Detected TI %s chip\n", names[data->kind]);
 
 	return 0;
 
--- a/drivers/hwmon/tmp421.c
+++ b/drivers/hwmon/tmp421.c
@@ -254,9 +254,9 @@ static int tmp421_detect(struct i2c_clie
 		return -ENODEV;
 	}
 
-	strlcpy(info->type, tmp421_id[kind - 1].name, I2C_NAME_SIZE);
+	strlcpy(info->type, tmp421_id[kind].name, I2C_NAME_SIZE);
 	dev_info(&adapter->dev, "Detected TI %s chip at 0x%02x\n",
-		 names[kind - 1], client->addr);
+		 names[kind], client->addr);
 
 	return 0;
 }


