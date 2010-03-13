Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936401Ab0CMBWe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:22:34 -0500
Received: from kroah.org ([198.145.64.141]:60889 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934871Ab0CMAUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:20:20 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:10 2010
Message-Id: <20100313001510.769587613@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:12:42 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jean Delvare <khali@linux-fr.org>
Subject: [patch 064/123] hwmon: (tmp421) Restore missing inputs
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Jean Delvare <khali@linux-fr.org>

commit 8d59582a867470a3e0c3eced4a01625ae8dc546b upstream.

An off-by-one error caused some inputs to not be created by the driver
when they should. TMP421 gets only one input instead of two, TMP422
gets two instead of three, etc. Fix the bug by listing explicitly the
number of inputs each device has.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Tested-by: Andre Prendel <andre.prendel@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/tmp421.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/hwmon/tmp421.c
+++ b/drivers/hwmon/tmp421.c
@@ -61,9 +61,9 @@ static const u8 TMP421_TEMP_LSB[4]		= {
 #define TMP423_DEVICE_ID			0x23
 
 static const struct i2c_device_id tmp421_id[] = {
-	{ "tmp421", tmp421 },
-	{ "tmp422", tmp422 },
-	{ "tmp423", tmp423 },
+	{ "tmp421", 2 },
+	{ "tmp422", 3 },
+	{ "tmp423", 4 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, tmp421_id);
@@ -73,7 +73,7 @@ struct tmp421_data {
 	struct mutex update_lock;
 	char valid;
 	unsigned long last_updated;
-	int kind;
+	int channels;
 	u8 config;
 	s16 temp[4];
 };
@@ -109,7 +109,7 @@ static struct tmp421_data *tmp421_update
 		data->config = i2c_smbus_read_byte_data(client,
 			TMP421_CONFIG_REG_1);
 
-		for (i = 0; i <= data->kind; i++) {
+		for (i = 0; i < data->channels; i++) {
 			data->temp[i] = i2c_smbus_read_byte_data(client,
 				TMP421_TEMP_MSB[i]) << 8;
 			data->temp[i] |= i2c_smbus_read_byte_data(client,
@@ -168,7 +168,7 @@ static mode_t tmp421_is_visible(struct k
 	devattr = container_of(a, struct device_attribute, attr);
 	index = to_sensor_dev_attr(devattr)->index;
 
-	if (data->kind > index)
+	if (index < data->channels)
 		return a->mode;
 
 	return 0;
@@ -273,7 +273,7 @@ static int tmp421_probe(struct i2c_clien
 
 	i2c_set_clientdata(client, data);
 	mutex_init(&data->update_lock);
-	data->kind = id->driver_data;
+	data->channels = id->driver_data;
 
 	err = tmp421_init_client(client);
 	if (err)


