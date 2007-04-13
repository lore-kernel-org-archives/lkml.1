Return-Path: <linux-kernel-owner+w=401wt.eu-S1752203AbXDMGkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbXDMGkg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 02:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752264AbXDMGkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 02:40:36 -0400
Received: from 42.mail-out.ovh.net ([213.251.189.42]:59951 "HELO
	42.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752203AbXDMGkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 02:40:35 -0400
Message-ID: <461F2578.5000604@boichat.ch>
Date: Fri, 13 Apr 2007 14:38:48 +0800
From: Nicolas Boichat <nicolas@boichat.ch>
User-Agent: Thunderbird 1.5.0.10 (X11/20070309)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
       linux-kernel@hansmi.ch, rlove@rlove.org, lm-sensors@lm-sensors.org,
       benh@kernel.crashing.org, paulus@samba.org, dtor@insightbb.com
Subject: [PATCH 2/2] Apple SMC driver - implement key enumeration
References: <45F7C083.7090504@boichat.ch> <20070411142556.16cd1e44@hyperion.delvare> <461F1620.1010808@boichat.ch>
In-Reply-To: <461F1620.1010808@boichat.ch>
X-Enigmail-Version: 0.94.3.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Ovh-Remote: 137.132.232.72 (nusnet-232-72.dynip.nus.edu.sg)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|H 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Apple SMC allows to enumerate all keys available on the device. This is
useful to discover new sensors. With this feature, I'll be able to ask
people with different macintel for their key lists, and update the
driver accordingly. (note: I don't think it is reasonable to auto-detect
temperature sensors when the driver is loaded, as enumerating all the
keys takes a long time)

It works this way:
# cd /sys/devices/platform/applesmc
# echo 2 > key_at_index
(replace 2 with any number between 0 and the value you can read in
key_count)
# cat key_at_index_name
ACID
# cat key_at_index_type
ch8*
# cat key_at_index_data_length
8
# hexdump -C key_at_index_data
00000000  ba 31 96 0b 50 05 10 74 |.1..P..t|
(key_at_index_data output is binary, is it acceptable for a sysfs file?)

Please tell me if you think there is a better way to implement the sysfs
interface.

Best regards,

Nicolas

Implement key enumeration in applesmc.

Signed-off-by: Nicolas Boichat <nicolas@boichat.ch>
---

 drivers/hwmon/applesmc.c |  263 ++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 262 insertions(+), 1 deletions(-)

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index 531bc9a..4ec38ef 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -51,6 +51,10 @@
 #define APPLESMC_STATUS_MASK	0x0f
 #define APPLESMC_READ_CMD	0x10
 #define APPLESMC_WRITE_CMD	0x11
+#define APPLESMC_GET_KEY_BY_INDEX_CMD	0x12
+#define APPLESMC_GET_KEY_TYPE_CMD	0x13
+
+#define KEY_COUNT_KEY		"#KEY" /* r-o ui32 */
 
 #define LIGHT_SENSOR_LEFT_KEY	"ALV0" /* r-o {alv (6 bytes) */
 #define LIGHT_SENSOR_RIGHT_KEY	"ALV1" /* r-o {alv (6 bytes) */
@@ -131,6 +135,12 @@ static unsigned int applesmc_temperature_set;
 
 static struct mutex applesmc_lock;
 
+/* 
+ * Last index written to key_at_index sysfs file, and value to use for all other
+ * key_at_index_* sysfs files.
+ */
+static unsigned int key_at_index;
+
 /*
  * __wait_status - Wait up to 100ms for the status port to get a certain value
  * (masked with 0x0f), returning zero if the value is obtained.  Callers must
@@ -235,6 +245,73 @@ static int applesmc_write_key(const char* key, u8* buffer, u8 len)
 }
 
 /*
+ * applesmc_get_key_at_index - get key at index, and put the result in key
+ * (char[6]). Returns zero on success or a negative error on failure. Callers
+ * must hold applesmc_lock.
+ */
+static int applesmc_get_key_at_index(int index, char* key)
+{
+	int i;
+	u8 readkey[4];
+	readkey[0] = index >> 24;
+	readkey[1] = index >> 16;
+	readkey[2] = index >> 8;
+	readkey[3] = index;
+
+	outb(APPLESMC_GET_KEY_BY_INDEX_CMD, APPLESMC_CMD_PORT);
+	if (__wait_status(0x0c))
+		return -EIO;
+
+	for (i = 0; i < 4; i++) {
+		outb(readkey[i], APPLESMC_DATA_PORT);
+		if (__wait_status(0x04))
+			return -EIO;
+	}
+	
+	outb(4, APPLESMC_DATA_PORT);
+
+	for (i = 0; i < 4; i++) {
+		if (__wait_status(0x05))
+			return -EIO;
+		key[i] = inb(APPLESMC_DATA_PORT);
+	}
+	key[4] = 0;
+
+	return 0;
+}
+
+/*
+ * applesmc_get_key_type - get key type, and put the result in type (char[6]).
+ * Returns zero on success or a negative error on failure. Callers must
+ * hold applesmc_lock.
+ */
+static int applesmc_get_key_type(char* key, char* type)
+{
+	int i;
+
+	outb(APPLESMC_GET_KEY_TYPE_CMD, APPLESMC_CMD_PORT);
+	if (__wait_status(0x0c))
+		return -EIO;
+
+	for (i = 0; i < 4; i++) {
+		outb(key[i], APPLESMC_DATA_PORT);
+		if (__wait_status(0x04))
+			return -EIO;
+	}
+	
+	outb(5, APPLESMC_DATA_PORT);
+
+	for (i = 0; i < 6; i++) {
+		if (__wait_status(0x05))
+			return -EIO;
+		type[i] = inb(APPLESMC_DATA_PORT);
+	}
+	type[5] = 0;
+
+	return 0;
+}
+
+/*
  * applesmc_read_motion_sensor - Read motion sensor (X, Y or Z). Callers must
  * hold applesmc_lock.
  */
@@ -656,6 +733,157 @@ static void applesmc_backlight_set(struct led_classdev *led_cdev,
 	mutex_unlock(&applesmc_lock);
 }
 
+static ssize_t applesmc_key_count_show(struct device *dev,
+				struct device_attribute *attr, char *sysfsbuf)
+{
+	int ret;
+	u8 buffer[4];
+	u32 count;
+
+	mutex_lock(&applesmc_lock);
+
+	ret = applesmc_read_key(KEY_COUNT_KEY, buffer, 4);
+	count = ((u32)buffer[0]<<24) + ((u32)buffer[1]<<16) +
+						((u32)buffer[2]<<8) + buffer[3];
+
+	mutex_unlock(&applesmc_lock);
+	if (ret)
+		return ret;
+	else
+		return snprintf(sysfsbuf, PAGE_SIZE, "%d\n", count);
+}
+
+static ssize_t applesmc_key_at_index_read_show(struct device *dev,
+				struct device_attribute *attr, char *sysfsbuf)
+{
+	char key[5];
+	char info[6];
+	int ret;
+
+	mutex_lock(&applesmc_lock);
+
+	ret = applesmc_get_key_at_index(key_at_index, key);
+
+	if (ret || !key[0]) {
+		mutex_unlock(&applesmc_lock);
+
+		return -EINVAL;
+	}
+
+	ret = applesmc_get_key_type(key, info);
+
+	if (ret) {
+		mutex_unlock(&applesmc_lock);
+
+		return ret;	
+	}
+
+	/* 
+	 * info[0] maximum value (APPLESMC_MAX_DATA_LENGTH) is much lower than
+	 * PAGE_SIZE, so we don't need any checks before writing to sysfsbuf.
+	 */
+	ret = applesmc_read_key(key, sysfsbuf, info[0]);
+
+	mutex_unlock(&applesmc_lock);
+
+	if (!ret) {
+		return info[0];
+	}
+	else {
+		return ret;
+	}
+}
+
+static ssize_t applesmc_key_at_index_data_length_show(struct device *dev,
+				struct device_attribute *attr, char *sysfsbuf)
+{
+	char key[5];
+	char info[6];
+	int ret;
+
+	mutex_lock(&applesmc_lock);
+
+	ret = applesmc_get_key_at_index(key_at_index, key);
+
+	if (ret || !key[0]) {
+		mutex_unlock(&applesmc_lock);
+
+		return -EINVAL;
+	}
+
+	ret = applesmc_get_key_type(key, info);
+
+	mutex_unlock(&applesmc_lock);
+
+	if (!ret)
+		return snprintf(sysfsbuf, PAGE_SIZE, "%d\n", info[0]);
+	else
+		return ret;
+}
+
+static ssize_t applesmc_key_at_index_type_show(struct device *dev,
+				struct device_attribute *attr, char *sysfsbuf)
+{
+	char key[5];
+	char info[6];
+	int ret;
+
+	mutex_lock(&applesmc_lock);
+
+	ret = applesmc_get_key_at_index(key_at_index, key);
+
+	if (ret || !key[0]) {
+		mutex_unlock(&applesmc_lock);
+
+		return -EINVAL;
+	}
+
+	ret = applesmc_get_key_type(key, info);
+
+	mutex_unlock(&applesmc_lock);
+
+	if (!ret)
+		return snprintf(sysfsbuf, PAGE_SIZE, "%s\n", info+1);
+	else
+		return ret;
+}
+
+static ssize_t applesmc_key_at_index_name_show(struct device *dev,
+				struct device_attribute *attr, char *sysfsbuf)
+{
+	char key[5];
+	int ret;
+
+	mutex_lock(&applesmc_lock);
+
+	ret = applesmc_get_key_at_index(key_at_index, key);
+
+	mutex_unlock(&applesmc_lock);
+
+	if (!ret && key[0])
+		return snprintf(sysfsbuf, PAGE_SIZE, "%s\n", key);
+	else
+		return -EINVAL;
+}
+
+static ssize_t applesmc_key_at_index_show(struct device *dev,
+				struct device_attribute *attr, char *sysfsbuf)
+{
+	return snprintf(sysfsbuf, PAGE_SIZE, "%d\n", key_at_index);
+}
+
+static ssize_t applesmc_key_at_index_store(struct device *dev,
+	struct device_attribute *attr, const char *sysfsbuf, size_t count)
+{
+	mutex_lock(&applesmc_lock);
+
+	key_at_index = simple_strtoul(sysfsbuf, NULL, 10);
+
+	mutex_unlock(&applesmc_lock);
+
+	return count;
+}
+
 static struct led_classdev applesmc_backlight = {
 	.name			= "smc:kbd_backlight",
 	.default_trigger	= "nand-disk",
@@ -677,6 +905,31 @@ static const struct attribute_group accelerometer_attributes_group =
 
 static DEVICE_ATTR(light, 0444, applesmc_light_show, NULL);
 
+static DEVICE_ATTR(key_count, 0444, applesmc_key_count_show, NULL);
+static DEVICE_ATTR(key_at_index, 0644,
+		applesmc_key_at_index_show, applesmc_key_at_index_store);
+static DEVICE_ATTR(key_at_index_name, 0444,
+					applesmc_key_at_index_name_show, NULL);
+static DEVICE_ATTR(key_at_index_type, 0444,
+					applesmc_key_at_index_type_show, NULL);
+static DEVICE_ATTR(key_at_index_data_length, 0444,
+				applesmc_key_at_index_data_length_show, NULL);
+static DEVICE_ATTR(key_at_index_data, 0444,
+				applesmc_key_at_index_read_show, NULL);
+
+static struct attribute *key_enumeration_attributes[] = {
+	&dev_attr_key_count.attr,
+	&dev_attr_key_at_index.attr,
+	&dev_attr_key_at_index_name.attr,
+	&dev_attr_key_at_index_type.attr,
+	&dev_attr_key_at_index_data_length.attr,
+	&dev_attr_key_at_index_data.attr,
+	NULL
+};
+
+static const struct attribute_group key_enumeration_group =
+	{ .attrs = key_enumeration_attributes };
+
 /*
  * Macro defining SENSOR_DEVICE_ATTR for a fan sysfs entries.
  *  - show actual speed
@@ -920,6 +1173,11 @@ static int __init applesmc_init(void)
 		goto out_driver;
 	}
 
+	/* Create key enumeration sysfs files */
+	ret = sysfs_create_group(&pdev->dev.kobj, &key_enumeration_group);
+	if (ret)
+		goto out_device;
+
 	/* create fan files */
 	count = applesmc_get_fan_count();
 	if (count < 0) {
@@ -936,7 +1194,7 @@ static int __init applesmc_init(void)
 			ret = sysfs_create_group(&pdev->dev.kobj,
 						 &fan_attribute_groups[1]);
 			if (ret)
-				goto out_device;
+				goto out_key_enumeration;
 		case 1:
 			ret = sysfs_create_group(&pdev->dev.kobj,
 						 &fan_attribute_groups[0]);
@@ -1006,6 +1264,8 @@ out_temperature:
 	sysfs_remove_group(&pdev->dev.kobj, &fan_attribute_groups[0]);
 out_fan_1:
 	sysfs_remove_group(&pdev->dev.kobj, &fan_attribute_groups[1]);
+out_key_enumeration:
+	sysfs_remove_group(&pdev->dev.kobj, &key_enumeration_group);
 out_device:
 	platform_device_unregister(pdev);
 out_driver:
@@ -1027,6 +1287,7 @@ static void __exit applesmc_exit(void)
 	sysfs_remove_group(&pdev->dev.kobj, &temperature_attributes_group);
 	sysfs_remove_group(&pdev->dev.kobj, &fan_attribute_groups[0]);
 	sysfs_remove_group(&pdev->dev.kobj, &fan_attribute_groups[1]);
+	sysfs_remove_group(&pdev->dev.kobj, &key_enumeration_group);
 	platform_device_unregister(pdev);
 	platform_driver_unregister(&applesmc_driver);
 	release_region(APPLESMC_DATA_PORT, APPLESMC_NR_PORTS);


