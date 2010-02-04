Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316Ab0BDIZj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 03:25:39 -0500
Received: from smtp.nokia.com ([192.100.122.230]:17279 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755793Ab0BDIZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 03:25:03 -0500
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: eric.piel@tremplin-utc.net
Cc: pavel@ucw.cz, daniel@caiaq.de, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org, Samu Onkalo <samu.p.onkalo@nokia.com>
Subject: [PATCH 4/6] lis3: Power control for the chip
Date: Thu,  4 Feb 2010 10:24:06 +0200
Message-Id: <1265271848-26559-5-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1265271848-26559-1-git-send-email-samu.p.onkalo@nokia.com>
References: <1265271848-26559-1-git-send-email-samu.p.onkalo@nokia.com>
X-OriginalArrivalTime: 04 Feb 2010 08:24:25.0508 (UTC) FILETIME=[761F8640:01CAA573]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chip operational state is controlled by number of the users.
When no-one is really using the chip, it is powered down.
Typical saving for 8bit device is 300 uA based on chip datasheet.
Not much, but in small devices everything counts.

New entry is added to sysfs: active
It tells when position entry in sysfs is in operational state.
Initial setting is chip active to keep functionality similar as
before. When "active" is set to 0, position entry return error code.

Regardless of the active sysfs entry state, chip is also powered on / off
according to /dev/freefall or /dev/input/eventx / /dev/input/jsx
use. If some of the device handles is open, chip is on operational state.

Chip is in powerdown:
- sysfs active == 0 and
- /dev/freefall is not open and
- /dev/input/... is not open

Chip is in active mode:
- active == 1 or
- /dev/freefall is open or
- /dev/input/.... is open

Initial state:
active == 1

When chip is powered on, it takes 30-125 ms depending on the chip type and
current sampling rate.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
---
 drivers/hwmon/lis3lv02d.c     |   75 +++++++++++++++++++++++++++++++++++++++--
 drivers/hwmon/lis3lv02d.h     |    2 +
 drivers/hwmon/lis3lv02d_i2c.c |    8 +++-
 drivers/hwmon/lis3lv02d_spi.c |   12 ++++---
 4 files changed, 87 insertions(+), 10 deletions(-)

diff --git a/drivers/hwmon/lis3lv02d.c b/drivers/hwmon/lis3lv02d.c
index 50f3123..5948a3a 100644
--- a/drivers/hwmon/lis3lv02d.c
+++ b/drivers/hwmon/lis3lv02d.c
@@ -248,6 +248,31 @@ void lis3lv02d_poweron(struct lis3lv02d *lis3)
 }
 EXPORT_SYMBOL_GPL(lis3lv02d_poweron);
 
+static void lis3lv02d_add_users(struct lis3lv02d *lis3)
+{
+	mutex_lock(&lis3->mutex);
+	if (!lis3->users++)
+		lis3lv02d_poweron(lis3);
+	mutex_unlock(&lis3->mutex);
+}
+
+static void lis3lv02d_remove_users(struct lis3lv02d *lis3)
+{
+	mutex_lock(&lis3->mutex);
+	if (!--lis3->users)
+		lis3lv02d_poweroff(lis3);
+	mutex_unlock(&lis3->mutex);
+}
+
+static void lis3lv02d_joystick_open(struct input_polled_dev *pidev)
+{
+	lis3lv02d_add_users(&lis3_dev);
+}
+
+static void lis3lv02d_joystick_close(struct input_polled_dev *pidev)
+{
+	lis3lv02d_remove_users(&lis3_dev);
+}
 
 static irqreturn_t lis302dl_interrupt(int irq, void *dummy)
 {
@@ -270,6 +295,7 @@ static int lis3lv02d_misc_open(struct inode *inode, struct file *file)
 	if (test_and_set_bit(0, &lis3_dev.misc_opened))
 		return -EBUSY; /* already open */
 
+	lis3lv02d_add_users(&lis3_dev);
 	atomic_set(&lis3_dev.count, 0);
 
 	/*
@@ -299,6 +325,7 @@ static int lis3lv02d_misc_release(struct inode *inode, struct file *file)
 	fasync_helper(-1, file, 0, &lis3_dev.async_queue);
 	free_irq(lis3_dev.irq, &lis3_dev);
 	clear_bit(0, &lis3_dev.misc_opened); /* release the device */
+	lis3lv02d_remove_users(&lis3_dev);
 	return 0;
 }
 
@@ -404,8 +431,10 @@ int lis3lv02d_joystick_enable(void)
 	if (!lis3_dev.idev)
 		return -ENOMEM;
 
-	lis3_dev.idev->poll = lis3lv02d_joystick_poll;
-	lis3_dev.idev->poll_interval = MDPS_POLL_INTERVAL;
+	lis3_dev.idev->poll  = lis3lv02d_joystick_poll;
+	lis3_dev.idev->open  = lis3lv02d_joystick_open;
+	lis3_dev.idev->close = lis3lv02d_joystick_close;
+	lis3_dev.idev->poll_interval	 = MDPS_POLL_INTERVAL;
 	input_dev = lis3_dev.idev->input;
 
 	input_dev->name       = "ST LIS3LV02DL Accelerometer";
@@ -462,6 +491,9 @@ static ssize_t lis3lv02d_position_show(struct device *dev,
 {
 	int x, y, z;
 
+	if (lis3_dev.active == 0)
+		return -ENODATA;
+
 	lis3lv02d_get_xyz(&lis3_dev, &x, &y, &z);
 	return sprintf(buf, "(%d,%d,%d)\n", x, y, z);
 }
@@ -487,15 +519,51 @@ static ssize_t lis3lv02d_rate_set(struct device *dev,
 	return count;
 }
 
+static ssize_t lis3lv02d_active_show(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%d\n", lis3_dev.active);
+}
+
+static ssize_t lis3lv02d_active_set(struct device *dev,
+				struct device_attribute *attr, const char *buf,
+				size_t count)
+{
+	unsigned long active;
+
+	if (strict_strtoul(buf, 0, &active))
+		return -EINVAL;
+
+	if (active > 1)
+		return -EINVAL;
+
+	mutex_lock(&lis3_dev.mutex);
+	if (active == lis3_dev.active) {
+		mutex_unlock(&lis3_dev.mutex);
+		return count;
+	}
+	lis3_dev.active = active;
+	mutex_unlock(&lis3_dev.mutex);
+
+	if (active)
+		lis3lv02d_add_users(&lis3_dev);
+	else
+		lis3lv02d_remove_users(&lis3_dev);
+	return count;
+}
+
 static DEVICE_ATTR(selftest, S_IRUSR, lis3lv02d_selftest_show, NULL);
 static DEVICE_ATTR(position, S_IRUGO, lis3lv02d_position_show, NULL);
 static DEVICE_ATTR(rate, S_IRUGO | S_IWUSR, lis3lv02d_rate_show,
 					    lis3lv02d_rate_set);
+static DEVICE_ATTR(active, S_IRUGO | S_IWUSR, lis3lv02d_active_show,
+					      lis3lv02d_active_set);
 
 static struct attribute *lis3lv02d_attributes[] = {
 	&dev_attr_selftest.attr,
 	&dev_attr_position.attr,
 	&dev_attr_rate.attr,
+	&dev_attr_active.attr,
 	NULL
 };
 
@@ -592,7 +660,8 @@ int lis3lv02d_init_device(struct lis3lv02d *dev)
 	mutex_init(&dev->mutex);
 
 	lis3lv02d_add_fs(dev);
-	lis3lv02d_poweron(dev);
+	lis3lv02d_add_users(dev);
+	lis3_dev.active = 1; /* By default, chip is in operational state */
 
 	if (lis3lv02d_joystick_enable())
 		printk(KERN_ERR DRIVER_NAME ": joystick initialization failed\n");
diff --git a/drivers/hwmon/lis3lv02d.h b/drivers/hwmon/lis3lv02d.h
index 692e244..72d8660 100644
--- a/drivers/hwmon/lis3lv02d.h
+++ b/drivers/hwmon/lis3lv02d.h
@@ -221,9 +221,11 @@ struct lis3lv02d {
 	int                     *odrs;     /* Supported output data rates */
 	u8                      odr_mask;  /* ODR bit mask */
 	u8			whoami;    /* indicates measurement precision */
+	u8			active;
 	s16 (*read_data) (struct lis3lv02d *lis3, int reg);
 	int			mdps_max_val;
 	int			pwron_delay;
+	int			users;
 	int                     scale; /*
 					* relationship between 1 LBS and mG
 					* (1/1000th of earth gravity)
diff --git a/drivers/hwmon/lis3lv02d_i2c.c b/drivers/hwmon/lis3lv02d_i2c.c
index dc1f540..5ffcaba 100644
--- a/drivers/hwmon/lis3lv02d_i2c.c
+++ b/drivers/hwmon/lis3lv02d_i2c.c
@@ -121,8 +121,10 @@ static int lis3lv02d_i2c_suspend(struct i2c_client *client, pm_message_t mesg)
 {
 	struct lis3lv02d *lis3 = i2c_get_clientdata(client);
 
-	if (!lis3->pdata->wakeup_flags)
+	mutex_lock(&lis3->mutex);
+	if (!lis3->pdata->wakeup_flags && lis3->users)
 		lis3lv02d_poweroff(lis3);
+	mutex_unlock(&lis3->mutex);
 	return 0;
 }
 
@@ -130,8 +132,10 @@ static int lis3lv02d_i2c_resume(struct i2c_client *client)
 {
 	struct lis3lv02d *lis3 = i2c_get_clientdata(client);
 
-	if (!lis3->pdata->wakeup_flags)
+	mutex_lock(&lis3->mutex);
+	if (!lis3->pdata->wakeup_flags && lis3->users)
 		lis3lv02d_poweron(lis3);
+	mutex_unlock(&lis3->mutex);
 	return 0;
 }
 
diff --git a/drivers/hwmon/lis3lv02d_spi.c b/drivers/hwmon/lis3lv02d_spi.c
index 82b1680..c48c523 100644
--- a/drivers/hwmon/lis3lv02d_spi.c
+++ b/drivers/hwmon/lis3lv02d_spi.c
@@ -92,9 +92,10 @@ static int lis3lv02d_spi_suspend(struct spi_device *spi, pm_message_t mesg)
 {
 	struct lis3lv02d *lis3 = spi_get_drvdata(spi);
 
-	if (!lis3->pdata->wakeup_flags)
-		lis3lv02d_poweroff(&lis3_dev);
-
+	mutex_lock(&lis3->mutex);
+	if (!lis3->pdata->wakeup_flags && lis3->users)
+		lis3lv02d_poweroff(lis3);
+	mutex_unlock(&lis3->mutex);
 	return 0;
 }
 
@@ -102,9 +103,10 @@ static int lis3lv02d_spi_resume(struct spi_device *spi)
 {
 	struct lis3lv02d *lis3 = spi_get_drvdata(spi);
 
-	if (!lis3->pdata->wakeup_flags)
+	mutex_lock(&lis3->mutex);
+	if (!lis3->pdata->wakeup_flags && lis3->users)
 		lis3lv02d_poweron(lis3);
-
+	mutex_unlock(&lis3->mutex);
 	return 0;
 }
 
-- 
1.6.0.4

