Return-Path: <linux-kernel-owner+w=401wt.eu-S965047AbXCSF0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965047AbXCSF0q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 01:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965172AbXCSF0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 01:26:46 -0400
Received: from 30.mail-out.ovh.net ([213.186.62.213]:41682 "HELO
	30.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S965047AbXCSF0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 01:26:44 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Mar 2007 01:26:43 EDT
Message-ID: <45FE1D44.8000805@boichat.ch>
Date: Mon, 19 Mar 2007 13:19:00 +0800
From: Nicolas Boichat <nicolas@boichat.ch>
User-Agent: Thunderbird 1.5.0.10 (X11/20070309)
MIME-Version: 1.0
To: Nicolas Boichat <nicolas@boichat.ch>,
       Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org, rlove@rlove.org,
       linux-kernel@hansmi.ch
Subject: [PATCH] Apple SMC driver (hardware monitoring and control)
References: <45F7C083.7090504@boichat.ch>
In-Reply-To: <45F7C083.7090504@boichat.ch>
X-Enigmail-Version: 0.94.3.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Ovh-Remote: 137.132.204.228 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|H 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Nicolas Boichat wrote:
> Hello,
>
> I developed, a while ago, a driver the Apple System Management
> Controller, which provides an accelerometer (Apple Sudden Motion
> Sensor), light sensors, temperature sensors, keyboard backlight control
> and fan control on Intel-based Apple's computers (MacBook Pro, MacBook,
> MacMini).
>
> This patch has been tested successfully since kernel 2.6.18 (i.e. 3-4
> months ago) by various users on different systems on the mactel-linux lists.
>
> However, I'm not really satisfied with the way sysfs files are created:
> I use a lot of preprocessor macros to avoid repetition of code.
> The files created with these macros in /sys/devices/platform/applesmc are
> the following (on a Macbook Pro):
> fan0_actual_speed
> fan0_manual
> fan0_maximum_speed
> fan0_minimum_speed
> fan0_safe_speed
> fan0_target_speed
> fan1_actual_speed
> fan1_manual
> fan1_maximum_speed
> fan1_minimum_speed
> fan1_safe_speed
> fan1_target_speed
> temperature_0
> temperature_1
> temperature_2
> temperature_3
> temperature_4
> temperature_5
> temperature_6
>
> (i.e. temperature_* is created by one macro, fan*_actual_speed by
> another, ...)
> Is it acceptable programming practice? Is there a way to create these
> files in a more elegant manner?
>
> Also, I never call any sysfs_remove_* function, as the files are
> deleted when the module is unloaded. Is it safe to do so? Doesn't it
> cause any memory leak?
>
> This is my main concerns, however, I would be happy to have comments
> on the other parts of the code. (Please cc me I'm not subscribed to
> lkml)
>   

Here is an updated version. I added an entry in MAINTAINERS, and changed
some variables names which were confusing in some functions (the above
concerns still remains though).

Also, there is a bug I didn't mention before (I thought it disappeared
with the lastest kernel version). Sometimes there are errors when
reading/writing values, indicated by these dmesg warnings:
applesmc: wait status failed: c != 8

I don't know why it happens from time to time (I don't have any
documentation for the chip), but retrying will work almost for sure. Do
you think the kernel driver should retry by itself? Or is it to the
application to retry (the current way)?

If the current way is ok, maybe it would be good to merge this patch in
mm (it applies cleanly against the latest git).

Again, comments are welcome.

Best regards,

Nicolas

This driver provides support for the Apple System Management Controller, which
provides an accelerometer (Apple Sudden Motion Sensor), light sensors,
temperature sensors, keyboard backlight control and fan control. Only
Intel-based Apple's computers are supported (MacBook Pro, MacBook, MacMini).

Signed-off-by: Nicolas Boichat <nicolas@boichat.ch>


---

 MAINTAINERS              |    6 
 drivers/hwmon/Kconfig    |   24 +
 drivers/hwmon/Makefile   |    1 
 drivers/hwmon/applesmc.c |  965 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 996 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 81bcc22..cbfdc3e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -367,6 +367,12 @@ L:	linux-laptop@vger.kernel.org
 W:	http://www.canb.auug.org.au/~sfr/
 S:	Supported
 
+APPLE SMC DRIVER
+P:	Nicolas Boichat
+M:	nicolas@boichat.ch
+L:	mactel-linux-devel@lists.sourceforge.net
+S:	Maintained
+
 APPLETALK NETWORK LAYER
 P:	Arnaldo Carvalho de Melo
 M:	acme@conectiva.com.br
diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 6d105a1..25b72a4 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -594,6 +594,30 @@ config SENSORS_HDAPS
 	  Say Y here if you have an applicable laptop and want to experience
 	  the awesome power of hdaps.
 
+config SENSORS_APPLESMC
+	tristate "Apple SMC (Motion sensor, light sensor, keyboard backlight)"
+	depends on HWMON && INPUT && X86
+	select NEW_LEDS
+	select LEDS_CLASS
+	default n
+	help
+	  This driver provides support for the Apple System Management
+	  Controller, which provides an accelerometer (Apple Sudden Motion
+	  Sensor), light sensors, temperature sensors, keyboard backlight
+	  control and fan control.
+
+	  Only Intel-based Apple's computers are supported (MacBook Pro,
+	  MacBook, MacMini).
+
+	  Data from the different sensors, keyboard backlight control and fan
+	  control are accessible via sysfs.
+
+	  This driver also provides an absolute input class device, allowing
+	  the laptop to act as a pinball machine-esque joystick.
+
+	  Say Y here if you have an applicable laptop and want to experience
+	  the awesome power of applesmc.
+
 config HWMON_DEBUG_CHIP
 	bool "Hardware Monitoring Chip debugging messages"
 	depends on HWMON
diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
index 4165c27..544f8d8 100644
--- a/drivers/hwmon/Makefile
+++ b/drivers/hwmon/Makefile
@@ -20,6 +20,7 @@ obj-$(CONFIG_SENSORS_ADM1026)	+= adm1026.o
 obj-$(CONFIG_SENSORS_ADM1029)	+= adm1029.o
 obj-$(CONFIG_SENSORS_ADM1031)	+= adm1031.o
 obj-$(CONFIG_SENSORS_ADM9240)	+= adm9240.o
+obj-$(CONFIG_SENSORS_APPLESMC)	+= applesmc.o
 obj-$(CONFIG_SENSORS_AMS)	+= ams/
 obj-$(CONFIG_SENSORS_ATXP1)	+= atxp1.o
 obj-$(CONFIG_SENSORS_DS1621)	+= ds1621.o
diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
new file mode 100644
index 0000000..f596101
--- /dev/null
+++ b/drivers/hwmon/applesmc.c
@@ -0,0 +1,965 @@
+/*
+ * drivers/hwmon/applesmc.c - driver for Apple's SMC (accelerometer, temperature
+ * sensors, fan control, keyboard backlight control) used in Intel-based Apple
+ * computers.
+ *
+ * Copyright (C) 2007 Nicolas Boichat <nicolas@boichat.ch>
+ *
+ * Based on hdaps.c driver:
+ * Copyright (C) 2005 Robert Love <rml@novell.com>
+ * Copyright (C) 2005 Jesper Juhl <jesper.juhl@gmail.com>
+ *
+ * Fan control based on smcFanControl:
+ * Copyright (C) 2006 Hendrik Holtmann <holtmann@mac.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License v2 as published by the
+ * Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA
+ */
+
+#include <linux/delay.h>
+#include <linux/platform_device.h>
+#include <linux/input.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/timer.h>
+#include <linux/dmi.h>
+#include <asm/io.h>
+#include <linux/leds.h>
+
+/* data port used by apple SMC */
+#define APPLESMC_DATA_PORT	0x300
+/* command/status port used by apple SMC */
+#define APPLESMC_CMD_PORT	0x304
+
+#define APPLESMC_NR_PORTS	5 /* 0x300-0x304 */
+
+#define APPLESMC_STATUS_MASK	0x0f
+#define APPLESMC_READ_CMD	0x10
+#define APPLESMC_WRITE_CMD	0x11
+
+#define LIGHT_SENSOR_LEFT_KEY	"ALV0" //r-o length 6
+#define LIGHT_SENSOR_RIGHT_KEY	"ALV1" //r-o length 6
+#define BACKLIGHT_KEY 		"LKSB" //w-o
+
+#define CLAMSHELL_KEY 		"MSLD" //r-o length 1 (unused)
+
+#define MOTION_SENSOR_X_KEY	"MO_X" //r-o length 2
+#define MOTION_SENSOR_Y_KEY	"MO_Y" //r-o length 2
+#define MOTION_SENSOR_Z_KEY	"MO_Z" //r-o length 2
+#define MOTION_SENSOR_KEY	"MOCN" //r/w length 2
+
+#define FANS_COUNT		"FNum" //r-o length 1
+#define FANS_MANUAL		"FS! " //r-w length 2
+#define FAN_ACTUAL_SPEED	"F0Ac" //r-o length 2
+#define FAN_MIN_SPEED		"F0Mn" //r-o length 2
+#define FAN_MAX_SPEED		"F0Mx" //r-o length 2
+#define FAN_SAFE_SPEED		"F0Sf" //r-o length 2
+#define FAN_TARGET_SPEED	"F0Tg" //r-w length 2
+
+/* Temperature sensors keys. First set for Macbook(Pro), second for Macmini */
+static const char* temperature_sensors_sets[][8] = {
+	{ "TB0T", "TC0D", "TC0P", "Th0H", "Ts0P", "Th1H", "Ts1P", NULL },
+	{ "TC0D", "TC0P", NULL }
+};
+
+#define INIT_TIMEOUT_MSECS	5000	/* wait up to 5s for device init ... */
+#define INIT_WAIT_MSECS		50	/* ... in 50ms increments */
+
+#define APPLESMC_POLL_PERIOD	(HZ/20)	/* poll for input every 1/20s */
+#define APPLESMC_INPUT_FUZZ	4	/* input event threshold */
+#define APPLESMC_INPUT_FLAT	4
+
+#define SENSOR_X 0
+#define SENSOR_Y 1
+#define SENSOR_Z 2
+
+/* Structure to be passed to DMI_MATCH function */
+struct dmi_match_data {
+/* Indicates whether this computer has an accelerometer. */
+	int accelerometer;
+/* Indicates whether this computer has light sensors and keyboard backlight. */
+	int light;
+/* Indicates which temperature sensors set to use. */
+	int temperature_set;
+};
+
+static int debug = 0;
+static struct platform_device *pdev;
+static s16 rest_x;
+static s16 rest_y;
+static struct timer_list applesmc_timer;
+static struct input_dev *applesmc_idev;
+
+/* Indicates whether this computer has an accelerometer. */
+static unsigned int applesmc_accelerometer = 0;
+
+/* Indicates whether this computer has light sensors and keyboard backlight. */
+static unsigned int applesmc_light = 0;
+
+/* Indicates which temperature sensors set to use. */
+static unsigned int applesmc_temperature_set = 0;
+
+static DECLARE_MUTEX(applesmc_sem);
+
+/*
+ * __wait_status - Wait up to 100ms for the status port to get a certain value
+ * (masked with 0x0f), returning zero if the value is obtained.  Callers must
+ * hold applesmc_sem.
+ */
+static int __wait_status(u8 val)
+{
+	unsigned int i;
+
+	val = val & APPLESMC_STATUS_MASK;
+
+	for (i = 0; i < 10000; i++) {
+		if ((inb(APPLESMC_CMD_PORT) & APPLESMC_STATUS_MASK) == val)
+			return 0;
+		udelay(10);
+	}
+
+	printk(KERN_WARNING "applesmc: wait status failed: %x != %x\n",
+						val, inb(APPLESMC_CMD_PORT));
+
+	return -EIO;
+}
+
+/*
+ * applesmc_read_key - reads len bytes from a given key, and put them in buffer.
+ * Returns zero on success or a negative error on failure. Callers must
+ * hold applesmc_sem.
+ */
+static int applesmc_read_key(const char* key, u8* buffer, u8 len)
+{
+	int ret = -EIO;
+	int i;
+
+	outb(APPLESMC_READ_CMD, APPLESMC_CMD_PORT);
+	if (__wait_status(0x0c))
+		goto out;
+	
+	for (i = 0; i < 4; i++) {
+		outb(key[i], APPLESMC_DATA_PORT);
+		if (__wait_status(0x04))
+			goto out;
+	}
+	if (debug) printk(KERN_DEBUG "<%s", key);
+
+	outb(len, APPLESMC_DATA_PORT);
+	if (debug) printk(KERN_DEBUG ">%x", len);
+
+	for (i = 0; i < len; i++) {
+		if (__wait_status(0x05))
+			goto out;
+		buffer[i] = inb(APPLESMC_DATA_PORT);
+		if (debug) printk(KERN_DEBUG "<%x", buffer[i]);
+	}
+	if (debug) printk(KERN_DEBUG "\n");
+	ret = 0;
+
+out:
+	return ret;
+}
+
+/*
+ * applesmc_write_key - writes len bytes from buffer to a given key.
+ * Returns zero on success or a negative error on failure. Callers must
+ * hold applesmc_sem.
+ */
+static int applesmc_write_key(const char* key, u8* buffer, u8 len)
+{
+	int ret = -EIO;
+	int i;
+
+	outb(APPLESMC_WRITE_CMD, APPLESMC_CMD_PORT);
+	if (__wait_status(0x0c))
+		goto out;
+	
+	for (i = 0; i < 4; i++) {
+		outb(key[i], APPLESMC_DATA_PORT);
+		if (__wait_status(0x04))
+			goto out;
+	}
+
+	outb(len, APPLESMC_DATA_PORT);
+
+	for (i = 0; i < len; i++) {
+		if (__wait_status(0x04))
+			goto out;
+		outb(buffer[i], APPLESMC_DATA_PORT);
+	}
+
+	ret = 0;
+out:
+	return ret;
+}
+
+/*
+ * applesmc_read_motion_sensor - Read motion sensor (X, Y or Z). Callers must
+ * hold applesmc_sem.
+ */
+static int applesmc_read_motion_sensor(int index, s16* value)
+{
+	u8 buffer[2];
+	int ret;
+
+	switch (index) {
+	case SENSOR_X:
+		ret = applesmc_read_key(MOTION_SENSOR_X_KEY, buffer, 2);
+		break;
+	case SENSOR_Y:
+		ret = applesmc_read_key(MOTION_SENSOR_Y_KEY, buffer, 2);
+		break;
+	case SENSOR_Z:
+		ret = applesmc_read_key(MOTION_SENSOR_Z_KEY, buffer, 2);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	*value = ((s16)buffer[0] << 8) | buffer[1];
+
+	return ret;
+}
+
+/*
+ * applesmc_device_init - initialize the accelerometer.  Returns zero on success
+ * and negative error code on failure.  Can sleep.
+ */
+static int applesmc_device_init(void)
+{
+	int total, ret = -ENXIO;
+	u8 buffer[2];
+
+	if (!applesmc_accelerometer) return 0;
+
+	down(&applesmc_sem);
+
+	for (total = INIT_TIMEOUT_MSECS; total > 0; total -= INIT_WAIT_MSECS) {
+		if (debug) printk(KERN_DEBUG "applesmc try %d\n", total);
+		if (!applesmc_read_key(MOTION_SENSOR_KEY, buffer, 2) &&
+				(buffer[0] != 0x00 || buffer[1] != 0x00)) {
+			if (total == INIT_TIMEOUT_MSECS) {
+				printk(KERN_DEBUG "applesmc: device has" 
+						" already been initialized"
+						" (0x%02x, 0x%02x).\n",
+						buffer[0], buffer[1]);
+			}
+			else {
+				printk(KERN_DEBUG "applesmc: device" 
+						" successfully initialized"
+						" (0x%02x, 0x%02x).\n",
+						buffer[0], buffer[1]);
+			}
+			ret = 0;
+			goto out;
+		}
+		buffer[0] = 0xe0;
+		buffer[1] = 0x00;
+		applesmc_write_key(MOTION_SENSOR_KEY, buffer, 2);
+		msleep(INIT_WAIT_MSECS);
+	}
+
+	printk(KERN_WARNING "applesmc: failed to init the device\n");
+
+out:
+	up(&applesmc_sem);
+	return ret;
+}
+
+/*
+ * applesmc_get_fan_count - get the number of fans. Callers must NOT hold
+ * applesmc_sem.
+ */
+static int applesmc_get_fan_count(void)
+{
+	int ret;
+	u8 buffer[1];
+
+	down(&applesmc_sem);
+
+	ret = applesmc_read_key(FANS_COUNT, buffer, 1);
+
+	up(&applesmc_sem);
+	if (ret)
+		return ret;
+	else
+		return buffer[0];
+}
+
+/* Device model stuff */
+static int applesmc_probe(struct platform_device *dev)
+{
+	int ret;
+
+	ret = applesmc_device_init();
+	if (ret)
+		return ret;
+
+	printk(KERN_INFO "applesmc: device successfully initialized.\n");
+	return 0;
+}
+
+static int applesmc_resume(struct platform_device *dev)
+{
+	return applesmc_device_init();
+}
+
+static struct platform_driver applesmc_driver = {
+	.probe = applesmc_probe,
+	.resume = applesmc_resume,
+	.driver	= {
+		.name = "applesmc",
+		.owner = THIS_MODULE,
+	},
+};
+
+/*
+ * applesmc_calibrate - Set our "resting" values.  Callers must
+ * hold applesmc_sem.
+ */
+static void applesmc_calibrate(void)
+{
+	applesmc_read_motion_sensor(SENSOR_X, &rest_x);
+	applesmc_read_motion_sensor(SENSOR_Y, &rest_y);
+}
+
+static void applesmc_mousedev_poll(unsigned long unused)
+{
+	s16 x, y;
+
+	/* Cannot sleep.  Try nonblockingly.  If we fail, try again later. */
+	if (down_trylock(&applesmc_sem)) {
+		mod_timer(&applesmc_timer, jiffies + APPLESMC_POLL_PERIOD);
+		return;
+	}
+
+	if (applesmc_read_motion_sensor(SENSOR_X, &x))
+		goto out;
+	if (applesmc_read_motion_sensor(SENSOR_Y, &y))
+		goto out;
+
+
+	input_report_abs(applesmc_idev, ABS_X, x - rest_x);
+	input_report_abs(applesmc_idev, ABS_Y, y - rest_y);
+	input_sync(applesmc_idev);
+
+out:
+	mod_timer(&applesmc_timer, jiffies + APPLESMC_POLL_PERIOD);
+
+	up(&applesmc_sem);
+}
+
+/* Sysfs Files */
+
+static ssize_t applesmc_position_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	int ret;
+	s16 x, y, z;
+
+	down(&applesmc_sem);
+
+	ret = applesmc_read_motion_sensor(SENSOR_X, &x);
+	if (ret)
+		goto out;
+	ret = applesmc_read_motion_sensor(SENSOR_Y, &y);
+	if (ret)
+		goto out;
+	ret = applesmc_read_motion_sensor(SENSOR_Z, &z);
+	if (ret)
+		goto out;
+
+out:
+	up(&applesmc_sem);
+	if (ret)
+		return ret;
+	else
+		return sprintf(buf, "(%d,%d,%d)\n", x, y, z);
+}
+
+static ssize_t applesmc_light_show(struct device *dev,
+				struct device_attribute *attr, char *sysfsbuf)
+{
+	int ret;
+	u8 left = 0, right = 0;
+	u8 buffer[6];
+
+	down(&applesmc_sem);
+
+	ret = applesmc_read_key(LIGHT_SENSOR_LEFT_KEY, buffer, 6);
+	left = buffer[2];
+	if (ret)
+		goto out;
+	ret = applesmc_read_key(LIGHT_SENSOR_RIGHT_KEY, buffer, 6);
+	right = buffer[2];
+
+out:
+	up(&applesmc_sem);
+	if (ret)
+		return ret;
+	else
+		return sprintf(sysfsbuf, "(%d,%d)\n", left, right);
+}
+
+/* Displays degree Celsius * 100 */
+static ssize_t applesmc_show_temperature(struct device *dev, char *sysfsbuf,
+								const char *key)
+{
+	int ret;
+	u8 buffer[2];
+	unsigned int temp;
+	
+	down(&applesmc_sem);
+
+	ret = applesmc_read_key(key, buffer, 2);
+	temp = buffer[0]*100;
+	temp += (buffer[1] >> 6) * 25;
+
+	up(&applesmc_sem);
+
+	if (ret)
+		return ret;
+	else
+		return sprintf(sysfsbuf, "%u\n", temp);
+}
+
+static ssize_t applesmc_show_fan_speed(struct device *dev, char *sysfsbuf,
+						const char* key, int offset)
+{
+	int ret;
+	unsigned int speed = 0;
+	char newkey[5];
+	u8 buffer[2];
+
+	newkey[0] = key[0];
+	newkey[1] = '0' + offset;
+	newkey[2] = key[2];
+	newkey[3] = key[3];
+	newkey[4] = 0;
+
+	down(&applesmc_sem);
+
+	ret = applesmc_read_key(newkey, buffer, 2);
+	speed = ((buffer[0] << 8 | buffer[1]) >> 2);
+
+	up(&applesmc_sem);
+	if (ret)
+		return ret;
+	else
+		return sprintf(sysfsbuf, "%u\n", speed);
+}
+
+static ssize_t applesmc_store_fan_speed(struct device *dev,
+					const char *sysfsbuf, size_t count,
+					const char* key, int offset)
+{
+	int ret;
+	u32 speed;
+	char newkey[5];
+	u8 buffer[2];
+
+	speed = simple_strtoul(sysfsbuf, NULL, 10);
+
+	if (speed > 0x4000) /* Bigger than a 14-bit value */
+		return -EINVAL;
+
+	newkey[0] = key[0];
+	newkey[1] = '0' + offset;
+	newkey[2] = key[2];
+	newkey[3] = key[3];
+	newkey[4] = 0;
+
+	down(&applesmc_sem);
+
+	buffer[0] = (speed >> 6) & 0xff;
+	buffer[1] = (speed << 2) & 0xff;
+	ret = applesmc_write_key(newkey, buffer, 2);
+
+	up(&applesmc_sem);
+	if (ret)
+		return ret;
+	else
+		return count;
+}
+
+static ssize_t applesmc_show_fan_manual(struct device *dev, char *sysfsbuf,
+								int offset)
+{
+	int ret;
+	u16 manual = 0;
+	u8 buffer[2];
+
+	down(&applesmc_sem);
+
+	ret = applesmc_read_key(FANS_MANUAL, buffer, 2);
+	manual = ((buffer[0] << 8 | buffer[1]) >> offset) & 0x01;
+
+	up(&applesmc_sem);
+	if (ret)
+		return ret;
+	else
+		return sprintf(sysfsbuf, "%d\n", manual);
+}
+
+static ssize_t applesmc_store_fan_manual(struct device *dev,
+				const char *sysfsbuf, size_t count, int offset)
+{
+	int ret;
+	u8 buffer[2];
+	u32 input;
+	u16 val;
+
+	input = simple_strtoul(sysfsbuf, NULL, 10);
+
+	down(&applesmc_sem);
+
+	ret = applesmc_read_key(FANS_MANUAL, buffer, 2);
+	val = (buffer[0] << 8 | buffer[1]);
+	if (ret)
+		goto out;
+
+	if (input)
+		val = val | (0x01 << offset);
+	else 
+		val = val & ~(0x01 << offset);
+
+	buffer[0] = (val >> 8) & 0xFF;
+	buffer[1] = val & 0xFF;
+
+	ret = applesmc_write_key(FANS_MANUAL, buffer, 2);
+
+out:
+	up(&applesmc_sem);
+	if (ret)
+		return ret;
+	else
+		return count;
+}
+
+static ssize_t applesmc_calibrate_show(struct device *dev,
+				struct device_attribute *attr, char *sysfsbuf)
+{
+	return sprintf(sysfsbuf, "(%d,%d)\n", rest_x, rest_y);
+}
+
+static ssize_t applesmc_calibrate_store(struct device *dev,
+	struct device_attribute *attr, const char *sysfsbuf, size_t count)
+{
+	down(&applesmc_sem);
+	applesmc_calibrate();
+	up(&applesmc_sem);
+
+	return count;
+}
+
+static void applesmc_backlight_set(struct led_classdev *led_cdev,
+						enum led_brightness value)
+{
+	u8 buffer[2];
+	
+	down(&applesmc_sem);
+	buffer[0] = value;
+	buffer[1] = 0x00;
+	applesmc_write_key(BACKLIGHT_KEY, buffer, 2);
+	up(&applesmc_sem);
+}
+
+static struct led_classdev applesmc_backlight = {
+	.name			= "smc:kbd_backlight",
+	.default_trigger	= "nand-disk",
+	.brightness_set		= applesmc_backlight_set,
+};
+
+static DEVICE_ATTR(position, 0444, applesmc_position_show, NULL);
+static DEVICE_ATTR(calibrate, 0644,
+			applesmc_calibrate_show, applesmc_calibrate_store);
+
+static DEVICE_ATTR(light, 0444, applesmc_light_show, NULL);
+
+/*
+ * Macro defining helper functions and DEVICE_ATTR for a fan sysfs entries.
+ *  - show actual speed
+ *  - show/store minimum speed
+ *  - show maximum speed
+ *  - show safe speed
+ *  - show/store target speed
+ *  - show/store manual mode
+ */
+#define sysfs_fan_speeds_offset(offset) \
+static ssize_t show_fan_actual_speed_##offset (struct device *dev, \
+				struct device_attribute *attr, char *buf) \
+{ \
+	return applesmc_show_fan_speed(dev, buf, FAN_ACTUAL_SPEED, offset); \
+} \
+static DEVICE_ATTR(fan##offset##_actual_speed, S_IRUGO, \
+					show_fan_actual_speed_##offset, NULL); \
+\
+static ssize_t show_fan_minimum_speed_##offset (struct device *dev, \
+				struct device_attribute *attr, char *buf) \
+{ \
+	return applesmc_show_fan_speed(dev, buf, FAN_MIN_SPEED, offset); \
+} \
+static ssize_t store_fan_minimum_speed_##offset (struct device *dev, \
+		struct device_attribute *attr, const char *buf, size_t count) \
+{ \
+	return applesmc_store_fan_speed(dev, buf, count, FAN_MIN_SPEED, offset); \
+} \
+static DEVICE_ATTR(fan##offset##_minimum_speed, S_IRUGO | S_IWUSR, \
+	show_fan_minimum_speed_##offset, store_fan_minimum_speed_##offset); \
+\
+static ssize_t show_fan_maximum_speed_##offset (struct device *dev, \
+				struct device_attribute *attr, char *buf) \
+{ \
+	return applesmc_show_fan_speed(dev, buf, FAN_MAX_SPEED, offset); \
+} \
+static DEVICE_ATTR(fan##offset##_maximum_speed, S_IRUGO, \
+				show_fan_maximum_speed_##offset, NULL); \
+\
+static ssize_t show_fan_safe_speed_##offset (struct device *dev, \
+				struct device_attribute *attr, char *buf) \
+{ \
+	return applesmc_show_fan_speed(dev, buf, FAN_SAFE_SPEED, offset); \
+} \
+static DEVICE_ATTR(fan##offset##_safe_speed, S_IRUGO, \
+					show_fan_safe_speed_##offset, NULL); \
+\
+static ssize_t show_fan_target_speed_##offset (struct device *dev, \
+				struct device_attribute *attr, char *buf) \
+{ \
+	return applesmc_show_fan_speed(dev, buf, FAN_TARGET_SPEED, offset); \
+} \
+static ssize_t store_fan_target_speed_##offset (struct device *dev, \
+		struct device_attribute *attr, const char *buf, size_t count) \
+{ \
+	return applesmc_store_fan_speed(dev, buf, count, FAN_TARGET_SPEED, offset); \
+} \
+static DEVICE_ATTR(fan##offset##_target_speed, S_IRUGO | S_IWUSR, \
+	show_fan_target_speed_##offset, store_fan_target_speed_##offset); \
+static ssize_t show_fan_manual_##offset (struct device *dev, \
+				struct device_attribute *attr, char *buf) \
+{ \
+	return applesmc_show_fan_manual(dev, buf, offset); \
+} \
+static ssize_t store_fan_manual_##offset (struct device *dev, \
+		struct device_attribute *attr, const char *buf, size_t count) \
+{ \
+	return applesmc_store_fan_manual(dev, buf, count, offset); \
+} \
+static DEVICE_ATTR(fan##offset##_manual, S_IRUGO | S_IWUSR, \
+		   show_fan_manual_##offset, store_fan_manual_##offset);
+
+/*
+ * Create the needed functions for each fan using the macro defined above 
+ * (2 fans are supported)
+ */
+sysfs_fan_speeds_offset(0);
+sysfs_fan_speeds_offset(1);
+
+/* Macro creating the sysfs entries for a fan */
+#define device_create_file_fan(ret, client, offset) \
+do { \
+ret = sysfs_create_file(client, &dev_attr_fan##offset##_actual_speed.attr); \
+if (ret) break; \
+ret = sysfs_create_file(client, &dev_attr_fan##offset##_minimum_speed.attr); \
+if (ret) break; \
+ret = sysfs_create_file(client, &dev_attr_fan##offset##_maximum_speed.attr); \
+if (ret) break; \
+ret = sysfs_create_file(client, &dev_attr_fan##offset##_safe_speed.attr); \
+if (ret) break; \
+ret = sysfs_create_file(client, &dev_attr_fan##offset##_target_speed.attr); \
+if (ret) break; \
+ret = sysfs_create_file(client, &dev_attr_fan##offset##_manual.attr); \
+} while (0)
+
+/*
+ * Macro defining the helper function and DEVICE_ATTR for a temperature sensor
+ * sysfs entry.
+ */
+#define sysfs_temperature_offset(offset) \
+static ssize_t show_temperature_##offset (struct device *dev, \
+				struct device_attribute *attr, char *buf) \
+{ \
+	return applesmc_show_temperature(dev, buf, \
+		temperature_sensors_sets[applesmc_temperature_set][offset]);  \
+} \
+static DEVICE_ATTR(temperature_##offset, S_IRUGO, \
+					show_temperature_##offset, NULL);
+
+/*
+ * Create the needed functions for each temperature sensors using the macro
+ * defined above (7 temperature sensors are supported)
+ */
+sysfs_temperature_offset(0);
+sysfs_temperature_offset(1);
+sysfs_temperature_offset(2);
+sysfs_temperature_offset(3);
+sysfs_temperature_offset(4);
+sysfs_temperature_offset(5);
+sysfs_temperature_offset(6);
+
+/* Macro creating the sysfs entry for a temperature sensor */
+#define device_create_files_temperature(ret, client, offset) \
+{ \
+	ret = sysfs_create_file(client, &dev_attr_temperature_##offset.attr); \
+} while (0)
+
+/* Module stuff */
+
+/* 
+ * applesmc_dmi_match - found a match.  return one, short-circuiting the hunt.
+ */
+static int applesmc_dmi_match(struct dmi_system_id *id)
+{
+	int i = 0;
+	struct dmi_match_data* dmi_data =
+					(struct dmi_match_data*)id->driver_data;
+	printk(KERN_INFO "applesmc: %s detected:\n", id->ident);
+	applesmc_accelerometer = dmi_data->accelerometer;
+	printk(KERN_INFO "applesmc:  - Model %s accelerometer\n",
+				applesmc_accelerometer ? "with" : "without");
+	applesmc_light = dmi_data->light;
+	printk(KERN_INFO "applesmc:  - Model %s light sensors and backlight\n",
+					applesmc_light ? "with" : "without");
+
+	applesmc_temperature_set =  dmi_data->temperature_set;
+	while (temperature_sensors_sets[applesmc_temperature_set][i] != NULL)
+		i++;
+	printk(KERN_INFO "applesmc:  - Model with %d temperature sensors\n", i);
+	return 1;
+}
+
+/* Create accelerometer ressources */
+static int applesmc_create_accelerometer(void) {
+	int ret;
+
+	ret = sysfs_create_file(&pdev->dev.kobj, &dev_attr_position.attr);
+	if (ret)
+		goto out;
+
+	ret = sysfs_create_file(&pdev->dev.kobj, &dev_attr_calibrate.attr);
+	if (ret)
+		goto out;
+
+	applesmc_idev = input_allocate_device();
+	if (!applesmc_idev) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	/* initial calibrate for the input device */
+	applesmc_calibrate();
+
+	/* initialize the input class */
+	applesmc_idev->name = "applesmc";
+	applesmc_idev->cdev.dev = &pdev->dev;
+	applesmc_idev->evbit[0] = BIT(EV_ABS);
+	input_set_abs_params(applesmc_idev, ABS_X,
+			-256, 256, APPLESMC_INPUT_FUZZ, APPLESMC_INPUT_FLAT);
+	input_set_abs_params(applesmc_idev, ABS_Y,
+			-256, 256, APPLESMC_INPUT_FUZZ, APPLESMC_INPUT_FLAT);
+
+	input_register_device(applesmc_idev);
+
+	/* start up our timer for the input device */
+	init_timer(&applesmc_timer);
+	applesmc_timer.function = applesmc_mousedev_poll;
+	applesmc_timer.expires = jiffies + APPLESMC_POLL_PERIOD;
+	add_timer(&applesmc_timer);
+
+	return 0;
+
+out:
+	printk(KERN_WARNING "applesmc: driver init failed (ret=%d)!\n", ret);
+	return ret;
+}
+
+/* Release all ressources used by the accelerometer */
+static void applesmc_release_accelerometer(void) {
+	del_timer_sync(&applesmc_timer);
+	input_unregister_device(applesmc_idev);
+}
+
+static int __init applesmc_init(void)
+{
+	int ret;
+	int count;
+
+	struct dmi_match_data applesmc_dmi_data[] = {
+	/* MacBook Pro: accelerometer, backlight and temperature set 0 */
+	  { .accelerometer = 1, .light = 1, .temperature_set = 0 },
+	/* MacBook: accelerometer and temperature set 0 */
+	  { .accelerometer = 1, .light = 0, .temperature_set = 0 },
+	/* MacBook: temperature set 1 */
+	  { .accelerometer = 0, .light = 0, .temperature_set = 1 }
+	};
+
+	/* Note that DMI_MATCH(...,"MacBook") will match "MacBookPro1,1".
+	 * So we need to put "Apple MacBook Pro" before "Apple MacBook". */
+	struct dmi_system_id applesmc_whitelist[] = {
+		{ applesmc_dmi_match, "Apple MacBook Pro", {
+		  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
+		  DMI_MATCH(DMI_PRODUCT_NAME,"MacBookPro") },
+			(void*)&applesmc_dmi_data[0]},
+		{ applesmc_dmi_match, "Apple MacBook", {
+		  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
+		  DMI_MATCH(DMI_PRODUCT_NAME,"MacBook") },
+			(void*)&applesmc_dmi_data[1]},
+		{ applesmc_dmi_match, "Apple Macmini", {
+		  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
+		  DMI_MATCH(DMI_PRODUCT_NAME,"Macmini") },
+			(void*)&applesmc_dmi_data[2]},
+		{ .ident = NULL }
+	};
+
+	if (!dmi_check_system(applesmc_whitelist)) {
+		printk(KERN_WARNING "applesmc: supported laptop not found!\n");
+		ret = -ENODEV;
+		goto out;
+	}
+
+	if (!request_region(APPLESMC_DATA_PORT, APPLESMC_NR_PORTS,
+								"applesmc")) {
+		ret = -ENXIO;
+		goto out;
+	}
+
+	ret = platform_driver_register(&applesmc_driver);
+	if (ret)
+		goto out_region;
+
+	pdev = platform_device_register_simple("applesmc", -1, NULL, 0);
+	if (IS_ERR(pdev)) {
+		ret = PTR_ERR(pdev);
+		goto out_driver;
+	}
+
+	/* create fan files */
+	count = applesmc_get_fan_count();
+	if (count < 0) {
+		printk(KERN_ERR "applesmc: Cannot get the number of fans.\n");
+	}
+	else {
+		printk(KERN_INFO "applesmc: %d fans found.\n", count);
+
+		switch (count) {
+		default:
+			printk(KERN_WARNING "applesmc: More than 2 fans found,"
+					" but at most 2 fans are supported"
+						" by the driver.\n");
+		case 2:
+			device_create_file_fan(ret, &pdev->dev.kobj, 1);
+			if (ret)
+				goto out_device;
+		case 1:
+			device_create_file_fan(ret, &pdev->dev.kobj, 0);
+			if (ret)
+				goto out_device;
+		case 0:
+			;
+		}
+	}
+
+	count = 0;
+	while (temperature_sensors_sets[applesmc_temperature_set][count]
+									!= NULL)
+		count++;
+
+	switch (count) {
+	default:
+	case 7:
+		device_create_files_temperature(ret, &pdev->dev.kobj, 6);
+		if (ret)
+			goto out_device;
+	case 6:
+		device_create_files_temperature(ret, &pdev->dev.kobj, 5);
+		if (ret)
+			goto out_device;
+	case 5:
+		device_create_files_temperature(ret, &pdev->dev.kobj, 4);
+		if (ret)
+			goto out_device;
+	case 4:
+		device_create_files_temperature(ret, &pdev->dev.kobj, 3);
+		if (ret)
+			goto out_device;
+	case 3:
+		device_create_files_temperature(ret, &pdev->dev.kobj, 2);
+		if (ret)
+			goto out_device;
+	case 2:
+		device_create_files_temperature(ret, &pdev->dev.kobj, 1);
+		if (ret)
+			goto out_device;
+	case 1:
+		device_create_files_temperature(ret, &pdev->dev.kobj, 0);
+		if (ret)
+			goto out_device;
+	case 0:
+		;
+	}
+
+	if (applesmc_accelerometer) {
+		ret = applesmc_create_accelerometer();
+		if (ret)
+			goto out_device;
+	}
+
+	if (applesmc_light) {
+		/* Add light sensor file */
+		ret = sysfs_create_file(&pdev->dev.kobj, &dev_attr_light.attr);
+		if (ret)
+			goto out_accelerometer;
+
+		/* register as a led device */
+		ret = led_classdev_register(&pdev->dev, &applesmc_backlight);
+		if (ret < 0)
+			goto out_accelerometer;
+	}
+
+	printk(KERN_INFO "applesmc: driver successfully loaded.\n");
+	return 0;
+
+out_accelerometer:
+	if (applesmc_accelerometer)
+		applesmc_release_accelerometer();
+out_device:
+	platform_device_unregister(pdev);
+out_driver:
+	platform_driver_unregister(&applesmc_driver);
+out_region:
+	release_region(APPLESMC_DATA_PORT, APPLESMC_NR_PORTS);
+out:
+	printk(KERN_WARNING "applesmc: driver init failed (ret=%d)!\n", ret);
+	return ret;
+}
+
+static void __exit applesmc_exit(void)
+{
+	if (applesmc_light)
+		led_classdev_unregister(&applesmc_backlight);
+	if (applesmc_accelerometer)
+		applesmc_release_accelerometer();
+	platform_device_unregister(pdev);
+	platform_driver_unregister(&applesmc_driver);
+	release_region(APPLESMC_DATA_PORT, APPLESMC_NR_PORTS);
+
+	printk(KERN_INFO "applesmc: driver unloaded.\n");
+}
+
+module_init(applesmc_init);
+module_exit(applesmc_exit);
+
+MODULE_AUTHOR("Nicolas Boichat");
+MODULE_DESCRIPTION("Apple SMC");
+MODULE_LICENSE("GPL v2");


