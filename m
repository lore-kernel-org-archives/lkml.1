Return-Path: <linux-kernel-owner+w=401wt.eu-S1755247AbZLHOQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247AbZLHOQw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 09:16:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755523AbZLHOQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 09:16:48 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:43983 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755418AbZLHOQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 09:16:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=qdRzp2Hsk1DTHLYQnkSDAvw4pWekQRmo75FY9IrhZKLg8nZl5ktbOnnHOp5VmHlu1/
         DRnvYuZQDPKNMopBMhf8rilOO+XS84i12tnp96+uv1E+/gl4NH1hBqoNEL7kudCnZY33
         Cqmka9U3ZKzd1jVd++c2yWJX0IMbS3SArra4g=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: akpm@linux-foundation.org, Wu Zhangjin <wuzhangjin@gmail.com>,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "Rafael J . Wysocki" <rjw@sisk.pl>, zhangfx@lemote.com,
       linux-laptop@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       Pavel Machek <pavel@ucw.cz>
Subject: [PATCH v9 5/8] Loongson: YeeLoong: add hardware monitoring driver
Date: Tue,  8 Dec 2009 22:15:53 +0800
Message-Id: <5e9acb4cd757075f617daa45cbd6f5fad94678ac.1260281599.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <5c426a5091bee3e4483fc0b93f26359e2840428b.1260281599.git.wuzhangjin@gmail.com>
References: <cover.1260254344.git.wuzhangjin@gmail.com>
 <39d232e3f8359e9c11bad7536f0162444401ec94.1260281599.git.wuzhangjin@gmail.com>
 <7676d8397e593dbec0d40e24429b7ccbcecfa588.1260281599.git.wuzhangjin@gmail.com>
 <4d821efaecc3dee0b9124119507a694e81572437.1260281599.git.wuzhangjin@gmail.com>
 <5c426a5091bee3e4483fc0b93f26359e2840428b.1260281599.git.wuzhangjin@gmail.com>
In-Reply-To: <cover.1260281599.git.wuzhangjin@gmail.com>
References: <cover.1260281599.git.wuzhangjin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzhangjin@gmail.com>

This patch adds hardware monitoring driver, it provides standard
interface(/sys/class/hwmon/) for lm-sensors/sensors-applet to monitor
the temperatures of CPU and battery, the PWM of fan, the current,
voltage of battery.

Please refer to Documentation/hwmon/userspace-tools to get more
information about the hwmon.

Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
---
 drivers/platform/mips/Kconfig           |    1 +
 drivers/platform/mips/yeeloong_laptop.c |  211 ++++++++++++++++++++++++++++++-
 2 files changed, 208 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/mips/Kconfig b/drivers/platform/mips/Kconfig
index 965933b..352594c 100644
--- a/drivers/platform/mips/Kconfig
+++ b/drivers/platform/mips/Kconfig
@@ -20,6 +20,7 @@ config LEMOTE_YEELOONG2F
 	select BACKLIGHT_CLASS_DEVICE
 	select SYS_SUPPORTS_APM_EMULATION
 	select APM_EMULATION
+	select HWMON
 	help
 	  YeeLoong netbook is a mini laptop made by Lemote, which is basically
 	  compatible to FuLoong2F mini PC, but it has an extra Embedded
diff --git a/drivers/platform/mips/yeeloong_laptop.c b/drivers/platform/mips/yeeloong_laptop.c
index b265674..becda4f 100644
--- a/drivers/platform/mips/yeeloong_laptop.c
+++ b/drivers/platform/mips/yeeloong_laptop.c
@@ -14,6 +14,8 @@
 #include <linux/backlight.h>	/* for backlight subdriver */
 #include <linux/fb.h>
 #include <linux/apm-emulation.h>/* for battery subdriver */
+#include <linux/hwmon.h>	/* for hwmon subdriver */
+#include <linux/hwmon-sysfs.h>
 
 #include <ec_kb3310b.h>
 
@@ -29,10 +31,7 @@ static int yeeloong_set_brightness(struct backlight_device *bd)
 		 bd->props.power == FB_BLANK_UNBLANK) ?
 	    bd->props.brightness : 0;
 
-	if (level > MAX_BRIGHTNESS)
-		level = MAX_BRIGHTNESS;
-	else if (level < 0)
-		level = 0;
+	level = SENSORS_LIMIT(level, 0, MAX_BRIGHTNESS);
 
 	/* Avoid to modify the brightness when EC is tuning it */
 	if (old_level != level) {
@@ -186,6 +185,202 @@ static void yeeloong_battery_exit(void)
 		apm_get_power_status = NULL;
 }
 
+/* hwmon subdriver */
+
+/* pwm(auto/manual) enable or not */
+static int get_fan_pwm_enable(void)
+{
+	return ec_read(REG_FAN_AUTO_MAN_SWITCH);
+}
+
+static void set_fan_pwm_enable(int manual)
+{
+	ec_write(REG_FAN_AUTO_MAN_SWITCH, !!manual);
+}
+
+static int get_fan_pwm(void)
+{
+	return ec_read(REG_FAN_SPEED_LEVEL);
+}
+
+static void set_fan_pwm(int value)
+{
+	value = SENSORS_LIMIT(value, 0, 3);
+
+	/* We must ensure the fan is on */
+	if (value > 0)
+		ec_write(REG_FAN_CONTROL, BIT_FAN_CONTROL_ON);
+
+	ec_write(REG_FAN_SPEED_LEVEL, value);
+}
+
+static int get_fan_rpm(void)
+{
+	int value;
+
+	value = FAN_SPEED_DIVIDER /
+	    (((ec_read(REG_FAN_SPEED_HIGH) & 0x0f) << 8) |
+	     ec_read(REG_FAN_SPEED_LOW));
+
+	return value;
+}
+
+static int get_cpu_temp(void)
+{
+	s8 value;
+
+	value = ec_read(REG_TEMPERATURE_VALUE);
+
+	return value * 1000;
+}
+
+static int get_battery_temp(void)
+{
+	int value;
+
+	value = (ec_read(REG_BAT_TEMPERATURE_HIGH) << 8) |
+		(ec_read(REG_BAT_TEMPERATURE_LOW));
+
+	return value * 1000;
+}
+
+static int get_battery_temp_alarm(void)
+{
+	int status;
+
+	status = (ec_read(REG_BAT_CHARGE_STATUS) &
+			BIT_BAT_CHARGE_STATUS_OVERTEMP);
+
+	return !!status;
+}
+
+static int get_battery_current(void)
+{
+	s16 value;
+
+	value = (ec_read(REG_BAT_CURRENT_HIGH) << 8) |
+		(ec_read(REG_BAT_CURRENT_LOW));
+
+	return -value;
+}
+
+static int get_battery_voltage(void)
+{
+	int value;
+
+	value = (ec_read(REG_BAT_VOLTAGE_HIGH) << 8) |
+		(ec_read(REG_BAT_VOLTAGE_LOW));
+
+	return value;
+}
+
+static ssize_t store_sys_hwmon(void (*set) (int), const char *buf, size_t count)
+{
+	int ret;
+	unsigned long value;
+
+	if (!count)
+		return 0;
+
+	ret = strict_strtoul(buf, 10, &value);
+	if (ret)
+		return ret;
+
+	set(value);
+
+	return count;
+}
+
+static ssize_t show_sys_hwmon(int (*get) (void), char *buf)
+{
+	return sprintf(buf, "%d\n", get());
+}
+
+#define CREATE_SENSOR_ATTR(_name, _mode, _set, _get)		\
+	static ssize_t show_##_name(struct device *dev,			\
+				    struct device_attribute *attr,	\
+				    char *buf)				\
+	{								\
+		return show_sys_hwmon(_set, buf);			\
+	}								\
+	static ssize_t store_##_name(struct device *dev,		\
+				     struct device_attribute *attr,	\
+				     const char *buf, size_t count)	\
+	{								\
+		return store_sys_hwmon(_get, buf, count);		\
+	}								\
+	static SENSOR_DEVICE_ATTR(_name, _mode, show_##_name, store_##_name, 0);
+
+CREATE_SENSOR_ATTR(fan1_input, S_IRUGO, get_fan_rpm, NULL);
+CREATE_SENSOR_ATTR(pwm1, S_IRUGO | S_IWUSR, get_fan_pwm, set_fan_pwm);
+CREATE_SENSOR_ATTR(pwm1_enable, S_IRUGO | S_IWUSR, get_fan_pwm_enable,
+		set_fan_pwm_enable);
+CREATE_SENSOR_ATTR(temp1_input, S_IRUGO, get_cpu_temp, NULL);
+CREATE_SENSOR_ATTR(temp2_input, S_IRUGO, get_battery_temp, NULL);
+CREATE_SENSOR_ATTR(temp2_max_alarm, S_IRUGO, get_battery_temp_alarm, NULL);
+CREATE_SENSOR_ATTR(curr1_input, S_IRUGO, get_battery_current, NULL);
+CREATE_SENSOR_ATTR(in1_input, S_IRUGO, get_battery_voltage, NULL);
+
+static ssize_t
+show_name(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "yeeloong\n");
+}
+
+static SENSOR_DEVICE_ATTR(name, S_IRUGO, show_name, NULL, 0);
+
+static struct attribute *hwmon_attributes[] = {
+	&sensor_dev_attr_pwm1.dev_attr.attr,
+	&sensor_dev_attr_pwm1_enable.dev_attr.attr,
+	&sensor_dev_attr_fan1_input.dev_attr.attr,
+	&sensor_dev_attr_temp1_input.dev_attr.attr,
+	&sensor_dev_attr_temp2_input.dev_attr.attr,
+	&sensor_dev_attr_temp2_max_alarm.dev_attr.attr,
+	&sensor_dev_attr_curr1_input.dev_attr.attr,
+	&sensor_dev_attr_in1_input.dev_attr.attr,
+	&sensor_dev_attr_name.dev_attr.attr,
+	NULL
+};
+
+static struct attribute_group hwmon_attribute_group = {
+	.attrs = hwmon_attributes
+};
+
+static struct device *yeeloong_hwmon_dev;
+
+static int yeeloong_hwmon_init(void)
+{
+	int ret;
+
+	yeeloong_hwmon_dev = hwmon_device_register(NULL);
+	if (IS_ERR(yeeloong_hwmon_dev)) {
+		pr_err("Fail to register yeeloong hwmon device\n");
+		yeeloong_hwmon_dev = NULL;
+		return PTR_ERR(yeeloong_hwmon_dev);
+	}
+	ret = sysfs_create_group(&yeeloong_hwmon_dev->kobj,
+				 &hwmon_attribute_group);
+	if (ret) {
+		hwmon_device_unregister(yeeloong_hwmon_dev);
+		yeeloong_hwmon_dev = NULL;
+		return ret;
+	}
+	/* ensure fan is set to auto mode */
+	set_fan_pwm_enable(BIT_FAN_AUTO);
+
+	return 0;
+}
+
+static void yeeloong_hwmon_exit(void)
+{
+	if (yeeloong_hwmon_dev) {
+		sysfs_remove_group(&yeeloong_hwmon_dev->kobj,
+				   &hwmon_attribute_group);
+		hwmon_device_unregister(yeeloong_hwmon_dev);
+		yeeloong_hwmon_dev = NULL;
+	}
+}
+
 static struct platform_device_id platform_device_ids[] = {
 	{
 		.name = "yeeloong_laptop",
@@ -225,11 +420,19 @@ static int __init yeeloong_init(void)
 
 	yeeloong_battery_init();
 
+	ret = yeeloong_hwmon_init();
+	if (ret) {
+		pr_err("Fail to register yeeloong hwmon driver.\n");
+		yeeloong_hwmon_exit();
+		return ret;
+	}
+
 	return 0;
 }
 
 static void __exit yeeloong_exit(void)
 {
+	yeeloong_hwmon_exit();
 	yeeloong_battery_exit();
 	yeeloong_backlight_exit();
 	platform_driver_unregister(&platform_driver);
-- 
1.6.2.1

