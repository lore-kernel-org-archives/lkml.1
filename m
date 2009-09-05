Return-Path: <linux-kernel-owner+w=401wt.eu-S932745AbZIEMIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932745AbZIEMIh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 08:08:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757343AbZIEMIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 08:08:36 -0400
Received: from avs2.arnes.si ([193.2.1.75]:41114 "EHLO avs2.arnes.si"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757335AbZIEMIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 08:08:34 -0400
To: Andrew Morton <akpm@linux-foundation.org>
From: tomaz.mertelj@guest.arnes.si
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwmon: Driver for Texas Instruments amc6821 chip
Date: Sat, 5 Sep 2009 14:08:34 +0200
Message-ID: <20090905_120834_010267.tomaz.mertelj@guest.arnes.si>
X-originating-IP: 84.20.248.126
MIME-Version: 1.0
Content-type: multipart/mixed;
	boundary="Arnes-Webmail-11976"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

--Arnes-Webmail-11976
Content-type: text/plain; charset="US-ASCII"
Content-description: Mail message body
Content-transfer-encoding: Quoted-printable
Content-disposition: inline


>- The attachment uses \r\n line termination and caused me quite a bit
>  of trouble before I worked out what was going on.

I am sorry. All my e-mail access is from MS-windows and I can not figure=20
how to get rid of \r\n. For convenience I attach also the raw patch with \n=
=20
only in encoded format.=20

>- The changelog is missing your Signed-off-by:.  Please read up on
>  this in Documentation/SubmittingPatches.

Fixed.

>- The driver needs lots and lots of trivial coding-style fixes.=20
>  Please take a look at some similar drivers and also use the
>  scripts/checkpatch.pl tool.

Fixed.


I also added documentation file and fixed bugs related to setting the trip=
=20
points.

Best Regards,

Tomaz

--
Signed-off-by: tomaz.mertelj@guest.arnes.si

diff --git a/Documentation/hwmon/amc6821 b/Documentation/hwmon/
amc6821
new file mode 100644
index 0000000..b7cba86
--- /dev/null
+++ b/Documentation/hwmon/amc6821
@@ -0,0 +1,101 @@
+Kernel driver amc6821
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+Supported chips:
+	Prefix: 'amc6821'
+	Addresses scanned: 0x18, 0x19, 0x1a, 0x2c, 0x2d, 0x2e, 0x4c,=20
0x4d, 0x4e
+	Datasheet: http://focus.ti.com/docs/prod/folders/print/amc6821.html
+
+Authors:
+	Tomaz Mertelj <tomaz.mertelj@guest.arnes.si>
+
+
+Description
+-----------
+
+This driver implements support for the Texas Instruments amc6821 chip.
+The chip has one on-chip and one remote temperature sensor and one=20
pwm fan
+regulator.
+The pwm can be controlled either from software or automatically.
+
+The driver provides the following sensor accesses in sysfs:
+
+temp1_input		ro	on-chip temperature
+temp1_min		rw	"
+temp1_max		rw	"
+temp1_crit	 	rw	"
+temp1_min_alarm		ro	"
+temp1_max_alarm		ro	"
+temp1_crit_alarm	ro	"
+
+temp2_input		ro	remote temperature
+temp2_min		rw	"
+temp2_max		rw	"
+temp2_crit	 	rw	"
+temp2_min_alarm		ro	"
+temp2_max_alarm		ro	"
+temp2_crit_alarm	ro	"
+temp2_fault		ro	"
+
+fan1_input	 	ro	tachometer speed
+fan1_min		rw	"
+fan1_max		rw	"
+fan1_fault	 	ro	"
+fan1_div		rw	Fan divisor can be either 2 or 4.
+
+pwm1			rw	pwm1
+pwm1_enable		rw	regulator mode, 1=3Dopen loop, 2=3Dfan=20
controlled
+				by remote temperature, 3=3Dfan controlled=20
by
+				combination of on-chip temperature and
+				remote-sensor temperature,
+pwm1_auto_channels_temp ro	1 if pwm_enable=3D=3D2, 3 if pwm_
enable=3D=3D3
+pwm1_auto_point1_pwm	ro	Hardwired to 0, shared for both
+				temperature channels.
+pwm1_auto_point2_pwm	rw	This value, shared for both=20
temperature
+				channels.
+pwm1_auto_point3_pwm	rw	Hardwired to 255, shared for=20
both
+				temperature channels.
+
+temp1_auto_point1_temp	ro	Hardwired to temp2_auto_
point1_temp
+				which is rw. Below this temperature fan=20
stops.
+temp1_auto_point2_temp	rw	The low-temperature limit of the=20
proportional
+				range. Below this temperature
+				pwm1 =3D pwm1_auto_point2_pwm. It can=20
go from
+				0 degree C and 124 degree C in steps of
+				4 degree C. Read it out after writing to=20
get
+				actual value.
+temp1_auto_point3_temp	rw	Above this temperature fan=20
runs at maximum
+				speed. It can go from temp1_auto_
point2_temp.
+				It can only have certain discrete values
+				which depend on temp1_auto_point2_
temp and
+				pwm1_auto_point2_pwm. Read it out=20
after
+				writing to get the actual value.
+
+temp2_auto_point1_temp	rw	Must be between 0 degree C=20
and 63 degree C and
+				it defines passive cooling temperature.
+				Below this temperature the fan stops in
+				the closed loop mode.
+temp2_auto_point2_temp	rw	The low-temperature limit of the=20
proportional
+				range. Below this temperature
+				pwm1 =3D pwm1_auto_point2_pwm. It can=20
go from
+				0 degree C and 124 degree C in steps
+				of 4 degree C.
+
+temp2_auto_point3_temp	rw	Above this temperature fan=20
runs at maximum
+				speed. It can only have certain discrete
+				values which depend on temp2_auto_
point2_temp
+				and pwm1_auto_point2_pwm. Read it=20
out after
+				writing to get actual value.
+
+
+Module parameters
+-----------------
+
+If your board has a BIOS that initializes the amc6821 correctly, you should
+load the module with: init=3D0.
+
+If your board BIOS doesn't initialize the chip, or you want
+different settings, you can set the following parameters:
+init=3D1,
+pwminv: 0 default pwm output, 1 inverts pwm output.
+
diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 2d50166..dbe180f 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -777,6 +777,16 @@ config SENSORS_ADS7828
 	  This driver can also be built as a module.  If so, the module
 	  will be called ads7828.
=20
+config SENSORS_AMC6821
+	tristate "Texas Instruments AMC6821"
+	depends on I2C  && EXPERIMENTAL
+	help
+	  If you say yes here you get support for the Texas Instruments
+	  AMC6821 hardware monitoring chips.
+
+	  This driver can also be build as a module.  If so, the module
+	  will be called amc6821.
+
 config SENSORS_THMC50
 	tristate "Texas Instruments THMC50 / Analog Devices ADM1022"
 	depends on I2C && EXPERIMENTAL
diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
index b793dce..431de76 100644
--- a/drivers/hwmon/Makefile
+++ b/drivers/hwmon/Makefile
@@ -81,6 +81,7 @@ obj-$(CONFIG_SENSORS_SIS5595)	+=3D sis5595.o
 obj-$(CONFIG_SENSORS_SMSC47B397)+=3D smsc47b397.o
 obj-$(CONFIG_SENSORS_SMSC47M1)	+=3D smsc47m1.o
 obj-$(CONFIG_SENSORS_SMSC47M192)+=3D smsc47m192.o
+obj-$(CONFIG_SENSORS_AMC6821)	+=3D amc6821.o
 obj-$(CONFIG_SENSORS_THMC50)	+=3D thmc50.o
 obj-$(CONFIG_SENSORS_TMP401)	+=3D tmp401.o
 obj-$(CONFIG_SENSORS_VIA686A)	+=3D via686a.o
diff --git a/drivers/hwmon/amc6821.c b/drivers/hwmon/amc6821.c
new file mode 100644
index 0000000..6905c5e
--- /dev/null
+++ b/drivers/hwmon/amc6821.c
@@ -0,0 +1,1037 @@
+/*
+	amc6821.c - Part of lm_sensors, Linux kernel modules for=20
hardware
+	monitoring
+	Copyright (C) 2009 T. Mertelj <tomaz.mertelj@guest.arnes.si>
+
+	This program is free software; you can redistribute it and/or modify
+	it under the terms of the GNU General Public License as published=20
by
+	the Free Software Foundation; either version 2 of the License, or
+	(at your option) any later version.
+
+	This program is distributed in the hope that it will be useful,
+	but WITHOUT ANY WARRANTY; without even the implied warranty=20
of
+	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.=20=20
See the
+	GNU General Public License for more details.
+
+	You should have received a copy of the GNU General Public=20
License
+	along with this program; if not, write to the Free Software
+	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+*/
+
+
+#include <linux/kernel.h>	/* Needed for KERN_INFO */
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/jiffies.h>
+#include <linux/i2c.h>
+#include <linux/hwmon.h>
+#include <linux/hwmon-sysfs.h>
+#include <linux/err.h>
+#include <linux/mutex.h>
+
+
+/*
+ * Addresses to scan.
+ */
+
+static const unsigned short normal_i2c[] =3D {0x18, 0x19, 0x1a, 0x2c, 0x2d=
,=20
0x2e,
+	0x4c, 0x4d, 0x4e, I2C_CLIENT_END};
+
+
+
+/*
+ * Insmod parameters
+ */
+
+static int pwminv =3D 0;	/*Inverted PWM output. */
+module_param(pwminv, int, S_IRUGO);
+
+static int init =3D 1; /*Power-on initialization.*/
+module_param(init, int, S_IRUGO);
+
+
+I2C_CLIENT_INSMOD_1(amc6821);
+
+#define AMC6821_REG_DEV_ID 0x3D
+#define AMC6821_REG_COMP_ID 0x3E
+#define AMC6821_REG_CONF1 0x00
+#define AMC6821_REG_CONF2 0x01
+#define AMC6821_REG_CONF3 0x3F
+#define AMC6821_REG_CONF4 0x04
+#define AMC6821_REG_STAT1 0x02
+#define AMC6821_REG_STAT2 0x03
+#define AMC6821_REG_TDATA_LOW 0x08
+#define AMC6821_REG_TDATA_HI 0x09
+#define AMC6821_REG_LTEMP_HI 0x0A
+#define AMC6821_REG_RTEMP_HI 0x0B
+#define AMC6821_REG_LTEMP_LIMIT_MIN 0x15
+#define AMC6821_REG_LTEMP_LIMIT_MAX 0x14
+#define AMC6821_REG_RTEMP_LIMIT_MIN 0x19
+#define AMC6821_REG_RTEMP_LIMIT_MAX 0x18
+#define AMC6821_REG_LTEMP_CRIT 0x1B
+#define AMC6821_REG_RTEMP_CRIT 0x1D
+#define AMC6821_REG_PSV_TEMP 0x1C
+#define AMC6821_REG_DCY 0x22
+#define AMC6821_REG_LTEMP_FAN_CTRL 0x24
+#define AMC6821_REG_RTEMP_FAN_CTRL 0x25
+#define AMC6821_REG_DCY_LOW_TEMP 0x21
+
+#define AMC6821_REG_TACH_LLIMITL 0x10
+#define AMC6821_REG_TACH_LLIMITH 0x11
+#define AMC6821_REG_TACH_HLIMITL 0x12
+#define AMC6821_REG_TACH_HLIMITH 0x13
+
+#define AMC6821_CONF1_START 0x01
+#define AMC6821_CONF1_FAN_INT_EN 0x02
+#define AMC6821_CONF1_FANIE 0x04
+#define AMC6821_CONF1_PWMINV 0x08
+#define AMC6821_CONF1_FAN_FAULT_EN 0x10
+#define AMC6821_CONF1_FDRC0 0x20
+#define AMC6821_CONF1_FDRC1 0x40
+#define AMC6821_CONF1_THERMOVIE 0x80
+
+#define AMC6821_CONF2_PWM_EN 0x01
+#define AMC6821_CONF2_TACH_MODE 0x02
+#define AMC6821_CONF2_TACH_EN 0x04
+#define AMC6821_CONF2_RTFIE 0x08
+#define AMC6821_CONF2_LTOIE 0x10
+#define AMC6821_CONF2_RTOIE 0x20
+#define AMC6821_CONF2_PSVIE 0x40
+#define AMC6821_CONF2_RST 0x80
+
+#define AMC6821_CONF3_THERM_FAN_EN 0x80
+#define AMC6821_CONF3_REV_MASK 0x0F
+
+#define AMC6821_CONF4_OVREN 0x10
+#define AMC6821_CONF4_TACH_FAST 0x20
+#define AMC6821_CONF4_PSPR 0x40
+#define AMC6821_CONF4_MODE 0x80
+
+#define AMC6821_STAT1_RPM_ALARM 0x01
+#define AMC6821_STAT1_FANS 0x02
+#define AMC6821_STAT1_RTH 0x04
+#define AMC6821_STAT1_RTL 0x08
+#define AMC6821_STAT1_R_THERM 0x10
+#define AMC6821_STAT1_RTF 0x20
+#define AMC6821_STAT1_LTH 0x40
+#define AMC6821_STAT1_LTL 0x80
+
+#define AMC6821_STAT2_RTC 0x08
+#define AMC6821_STAT2_LTC 0x10
+#define AMC6821_STAT2_LPSV 0x20
+#define AMC6821_STAT2_L_THERM 0x40
+#define AMC6821_STAT2_THERM_IN 0x80
+
+
+static int amc6821_probe(
+		struct i2c_client *client,
+		const struct i2c_device_id *id);
+static int amc6821_detect(
+		struct i2c_client *client,
+		int kind,
+		struct i2c_board_info *info);
+static int amc6821_init_client(struct i2c_client *client);
+static int amc6821_remove(struct i2c_client *client);
+static struct amc6821_data *amc6821_update_device(struct device *dev);
+
+/*
+ * Driver data (common to all clients)
+ */
+
+static const struct i2c_device_id amc6821_id[] =3D {
+	{ "amc6821", amc6821 },
+	{ }
+};
+
+MODULE_DEVICE_TABLE(i2c, amc6821_id);
+
+static struct i2c_driver amc6821_driver =3D {
+	.class =3D I2C_CLASS_HWMON,
+	.driver =3D {
+		.name	=3D "amc6821",
+	},
+	.probe =3D amc6821_probe,
+	.remove =3D amc6821_remove,
+	.id_table =3D amc6821_id,
+	.detect =3D amc6821_detect,
+	.address_data =3D &addr_data,
+};
+
+
+/*
+ * Client data (each client gets its own)
+  */
+
+struct amc6821_data {
+	struct device *hwmon_dev;
+	struct mutex update_lock;
+	char valid; /* zero until following fields are valid */
+	unsigned long last_updated; /* in jiffies */
+
+	/* register values */
+	int temp1_input;
+	int temp1_min;
+	int temp1_max;
+	int temp1_crit;
+
+	int temp2_input;
+	int temp2_min;
+	int temp2_max;
+	int temp2_crit;
+
+	u16 fan1_input;
+	u16 fan1_min;
+	u16 fan1_max;
+	u8 fan1_div;
+
+	u8 pwm1;
+	u8 temp1_auto_point_temp[3];
+	u8 temp2_auto_point_temp[3];
+	u8 pwm1_auto_point_pwm[3];
+	u8 pwm1_enable;
+	u8 pwm1_auto_channels_temp;
+
+	u8 stat1;
+	u8 stat2;
+};
+
+
+#define get_temp_para(name) \
+static ssize_t get_##name(\
+		struct device *dev,\
+		struct device_attribute *devattr,\
+		char *buf)\
+{\
+	struct amc6821_data *data =3D amc6821_update_device(dev);\
+	return sprintf(buf, "%d\n", data->name * 1000);\
+}
+
+get_temp_para(temp1_input);
+get_temp_para(temp1_min);
+get_temp_para(temp1_max);
+get_temp_para(temp2_input);
+get_temp_para(temp2_min);
+get_temp_para(temp2_max);
+get_temp_para(temp1_crit);
+get_temp_para(temp2_crit);
+
+#define set_temp_para(name, reg)\
+static ssize_t set_##name(\
+		struct device *dev,\
+		struct device_attribute *attr,\
+		const char *buf,\
+		size_t count)\
+{ \
+	struct i2c_client *client =3D to_i2c_client(dev); \
+	struct amc6821_data *data =3D i2c_get_clientdata(client); \
+	int val =3D simple_strtol(buf, NULL, 10); \
+	\
+	mutex_lock(&data->update_lock); \
+	data->name =3D SENSORS_LIMIT(val / 1000, -128, 127); \
+	if (i2c_smbus_write_byte_data(client, reg, data->name)) {\
+		dev_err(&client->dev, "Register write error, aborting.\n");\
+		count =3D -EIO;\
+	} \
+	mutex_unlock(&data->update_lock); \
+	return count; \
+}
+
+set_temp_para(temp1_min, AMC6821_REG_LTEMP_LIMIT_MIN);
+set_temp_para(temp1_max, AMC6821_REG_LTEMP_LIMIT_MAX);
+set_temp_para(temp2_min, AMC6821_REG_RTEMP_LIMIT_MIN);
+set_temp_para(temp2_max, AMC6821_REG_RTEMP_LIMIT_MAX);
+set_temp_para(temp1_crit, AMC6821_REG_LTEMP_CRIT);
+set_temp_para(temp2_crit, AMC6821_REG_RTEMP_CRIT);
+
+#define get_temp_alarm(name, reg, mask)\
+static ssize_t get_##name(\
+	struct device *dev, \
+	struct device_attribute *devattr,\
+	char *buf)\
+{\
+	struct amc6821_data *data =3D amc6821_update_device(dev);\
+	if (data->reg &  mask)\
+		return sprintf(buf, "1");\
+	else	\
+		return sprintf(buf, "0");\
+} \
+
+get_temp_alarm(temp1_min_alarm, stat1,	AMC6821_STAT1_LTL)
+get_temp_alarm(temp1_max_alarm, stat1, AMC6821_STAT1_LTH)
+get_temp_alarm(temp2_min_alarm, stat1, AMC6821_STAT1_RTL)
+get_temp_alarm(temp2_max_alarm, stat1, AMC6821_STAT1_RTH)
+get_temp_alarm(temp1_crit_alarm, stat2, AMC6821_STAT2_LTC)
+get_temp_alarm(temp2_crit_alarm, stat2, AMC6821_STAT2_RTC)
+
+
+static ssize_t get_temp2_fault(
+		struct device *dev,
+		struct device_attribute *devattr,
+		char *buf)
+{
+	struct amc6821_data *data =3D amc6821_update_device(dev);
+	if (data->stat1 & AMC6821_STAT1_RTF)
+		return sprintf(buf, "1");
+	else
+		return sprintf(buf, "0");
+}
+
+static ssize_t get_pwm1(
+		struct device *dev,
+		struct device_attribute *devattr,
+		char *buf)
+{
+	struct amc6821_data *data =3D amc6821_update_device(dev);
+	return sprintf(buf, "%d\n", data->pwm1);
+}
+
+static ssize_t set_pwm1(
+		struct device *dev,
+		struct device_attribute *devattr,
+		const char *buf,
+		size_t count)
+{
+	struct i2c_client *client =3D to_i2c_client(dev);
+	struct amc6821_data *data =3D i2c_get_clientdata(client);
+	int val =3D simple_strtol(buf, NULL, 10);
+
+	mutex_lock(&data->update_lock);
+	data->pwm1 =3D SENSORS_LIMIT(val , 0, 255);
+	i2c_smbus_write_byte_data(client, AMC6821_REG_DCY, data-
>pwm1);
+	mutex_unlock(&data->update_lock);
+	return count;
+}
+
+static ssize_t get_pwm1_enable(
+		struct device *dev,
+		struct device_attribute *devattr,
+		char *buf)
+{
+	struct amc6821_data *data =3D amc6821_update_device(dev);
+	return sprintf(buf, "%d\n", data->pwm1_enable);
+}
+
+static ssize_t set_pwm1_enable(
+		struct device *dev,
+		struct device_attribute *attr,
+		const char *buf,
+		size_t count)
+{
+	struct i2c_client *client =3D to_i2c_client(dev);
+	struct amc6821_data *data =3D i2c_get_clientdata(client);
+	int val =3D simple_strtol(buf, NULL, 10);
+
+	int config =3D i2c_smbus_read_byte_data(client, AMC6821_REG_
CONF1);
+	if (config < 0) {
+			dev_err(&client->dev,
+			"Error reading configuration register, aborting.\n")
;
+			return -EIO;
+	}
+
+	switch (val) {
+	case 1:
+		config &=3D ~AMC6821_CONF1_FDRC0;
+		config &=3D ~AMC6821_CONF1_FDRC1;
+		break;
+	case 2:
+		config &=3D ~AMC6821_CONF1_FDRC0;
+		config |=3D AMC6821_CONF1_FDRC1;
+		break;
+	case 3:
+		config |=3D AMC6821_CONF1_FDRC0;
+		config |=3D AMC6821_CONF1_FDRC1;
+		break;
+	default:
+		return -EINVAL;
+	}
+	mutex_lock(&data->update_lock);
+	if (i2c_smbus_write_byte_data(client, AMC6821_REG_CONF1,=20
config)) {
+			dev_err(&client->dev,
+			"Configuration register write error, aborting.\n");
+			count =3D -EIO;
+	}
+	mutex_unlock(&data->update_lock);
+	return count;
+}
+
+
+static ssize_t get_pwm1_auto_channels_temp(
+		struct device *dev,
+		struct device_attribute *devattr,
+		char *buf)
+{
+	struct amc6821_data *data =3D amc6821_update_device(dev);
+	return sprintf(buf, "%d\n", data->pwm1_auto_channels_temp);
+}
+
+
+#define get_auto_point(name)\
+static ssize_t get_##name(\
+		struct device *dev,\
+		struct device_attribute *devattr,\
+		char *buf)\
+{\
+	int nr =3D to_sensor_dev_attr(devattr)->index;\
+	struct amc6821_data *data =3D amc6821_update_device(dev);\
+	return sprintf(buf, "%d\n", data->name[nr] * 1000);\
+}
+
+get_auto_point(temp1_auto_point_temp);
+get_auto_point(temp2_auto_point_temp);
+
+static ssize_t get_pwm1_auto_point_pwm(
+		struct device *dev,
+		struct device_attribute *devattr,
+		char *buf)
+{
+	int nr =3D to_sensor_dev_attr(devattr)->index;
+	struct amc6821_data *data =3D amc6821_update_device(dev);
+	return sprintf(buf, "%d\n", data->pwm1_auto_point_pwm[nr]);
+}
+
+
+#define set_temp_auto_point_temp(name, reg)\
+static ssize_t set_##name(\
+		struct device *dev,\
+		struct device_attribute *attr,\
+		const char *buf,\
+		size_t count)\
+{ \
+	struct i2c_client *client =3D to_i2c_client(dev); \
+	struct amc6821_data *data =3D amc6821_update_device(dev);\
+	int nr =3D to_sensor_dev_attr(attr)->index;\
+	int val =3D simple_strtol(buf, NULL, 10); \
+	u8 tmp;\
+	int dt;\
+	int dpwm;\
+	\
+	mutex_lock(&data->update_lock); \
+	switch (nr) {\
+	case 0:\
+		data->name[0] =3D SENSORS_LIMIT(val / 1000, 0,\
+				data->temp1_auto_point_temp[1]);\
+		data->name[0] =3D SENSORS_LIMIT(data->name[0], 0,\
+				data->temp2_auto_point_temp[1]);\
+		data->name[0] =3D SENSORS_LIMIT(data->name[0], 0, 63); \
+		data->valid =3D 0;\
+		if (i2c_smbus_write_byte_data(\
+					client,\
+					AMC6821_REG_PSV_TEMP,\
+					data->name[0])) {\
+				dev_err(&client->dev,\
+					"Register write error, aborting.
\n");\
+				count =3D -EIO;\
+		} \
+		goto EXIT;\
+		break;\
+	case 1:\
+		data->name[1] =3D SENSORS_LIMIT(\
+					val / 1000,\
+					(data->name[0] & 0x7C) + 4,\
+					124);\
+		data->name[1] &=3D 0x7C;\
+		data->name[2] =3D SENSORS_LIMIT(\
+					data->name[2], data->name[1] +=20
1,\
+					255);\
+		break;\
+	case 2:\
+		data->name[2] =3D SENSORS_LIMIT(\
+					val / 1000,\
+					data->name[1]+1,\
+					255); \
+		break;\
+	} \
+	dt =3D data->name[2]-data->name[1];\
+	dpwm =3D data->pwm1_auto_point_pwm[2] - data->pwm1_auto_
point_pwm[1];\
+	for (tmp =3D 4; tmp > 0; tmp--) {\
+		if (dt * (0x20 >> tmp) >=3D dpwm)\
+			break;\
+	} \
+	tmp |=3D (data->name[1] & 0x7C) << 1;\
+	if (i2c_smbus_write_byte_data(client, reg, tmp)) {\
+		dev_err(&client->dev, "Register write error, aborting.\n");\
+		count =3D -EIO;\
+	} \
+	data->valid =3D 0;\
+EXIT:\
+	mutex_unlock(&data->update_lock); \
+	return count; \
+}
+
+set_temp_auto_point_temp(temp1_auto_point_temp, AMC6821_REG_
LTEMP_FAN_CTRL);
+set_temp_auto_point_temp(temp2_auto_point_temp, AMC6821_REG_
RTEMP_FAN_CTRL);
+
+static ssize_t set_pwm1_auto_point_pwm(
+		struct device *dev,
+		struct device_attribute *attr,
+		const char *buf,
+		size_t count)
+{
+	struct i2c_client *client =3D to_i2c_client(dev);
+	struct amc6821_data *data =3D i2c_get_clientdata(client);
+	int val =3D simple_strtol(buf, NULL, 10);
+	u8 tmp;
+	int dt;
+	int dpwm;
+
+	mutex_lock(&data->update_lock);
+	data->pwm1_auto_point_pwm[1] =3D SENSORS_LIMIT(val, 0, 254);
+	if (i2c_smbus_write_byte_data(client, AMC6821_REG_DCY_LOW_
TEMP,
+			data->pwm1_auto_point_pwm[1])) {
+		dev_err(&client->dev, "Register write error, aborting.\n");
+		count =3D -EIO;
+	}
+
+	dpwm =3D data->pwm1_auto_point_pwm[2] - data->pwm1_auto_
point_pwm[1];
+	dt =3D data->temp1_auto_point_temp[2]-data->temp1_auto_point_
temp[1];
+	for (tmp =3D 4; tmp > 0; tmp--) {
+		if (dt * (0x20 >> tmp) >=3D dpwm)
+			break;
+	}
+	tmp |=3D (data->temp1_auto_point_temp[1] & 0x7C) << 1;
+	if (i2c_smbus_write_byte_data(client,
+			AMC6821_REG_LTEMP_FAN_CTRL, tmp)) {
+		dev_err(&client->dev, "Register write error, aborting.\n");
+		count =3D -EIO;
+	}
+
+	dt =3D data->temp2_auto_point_temp[2]-data->temp2_auto_point_
temp[1];
+	for (tmp =3D 4; tmp > 0; tmp--) {
+		if (dt * (0x20 >> tmp) >=3D dpwm)
+			break;
+	}
+	tmp |=3D (data->temp2_auto_point_temp[1] & 0x7C) << 1;
+	if (i2c_smbus_write_byte_data(client,
+			AMC6821_REG_RTEMP_FAN_CTRL, tmp)) {
+		dev_err(&client->dev, "Register write error, aborting.\n");
+		count =3D -EIO;
+	}
+	data->valid =3D 0;
+	mutex_unlock(&data->update_lock);
+	return count;
+}
+
+
+#define get_fan_para(name) static ssize_t get_##name(\
+		struct device *dev,\
+		struct device_attribute *devattr,\
+		char *buf)\
+{ \
+	struct amc6821_data *data =3D amc6821_update_device(dev); \
+	if (0 =3D=3D data->name)\
+		return sprintf(buf, "0");\
+	return sprintf(buf, "%d\n", (int)(6000000 / data->name)); \
+}
+
+get_fan_para(fan1_input);
+get_fan_para(fan1_min);
+get_fan_para(fan1_max);
+
+static ssize_t get_fan1_fault(
+		struct device *dev,
+		struct device_attribute *devattr,
+		char *buf)
+{
+	struct amc6821_data *data =3D amc6821_update_device(dev);
+	if (data->stat1 & AMC6821_STAT1_FANS)
+		return sprintf(buf, "1");
+	else
+		return sprintf(buf, "0");
+}
+
+
+#define set_fan_para(name, reg) \
+static ssize_t set_##name(\
+		struct device *dev,\
+		struct device_attribute *attr,\
+		const char *buf, size_t count)\
+{ \
+	struct i2c_client *client =3D to_i2c_client(dev); \
+	struct amc6821_data *data =3D i2c_get_clientdata(client); \
+	int val =3D simple_strtol(buf, NULL, 10); \
+	val =3D 1 > val ? 0xFFFF : 6000000/val; \
+\
+	mutex_lock(&data->update_lock); \
+	data->name =3D (u16) SENSORS_LIMIT(val, 1, 0xFFFF); \
+	if (i2c_smbus_write_byte_data(client, reg, data->name & 0xFF)) { \
+		dev_err(&client->dev, "Register write error, aborting.\n");\
+		count =3D -EIO;\
+	} \
+	if (i2c_smbus_write_byte_data(client, reg+1, data->name >> 8)) { \
+		dev_err(&client->dev, "Register write error, aborting.\n");\
+		count =3D -EIO;\
+	} \
+	mutex_unlock(&data->update_lock); \
+	return count; \
+}
+
+
+set_fan_para(fan1_min, AMC6821_REG_TACH_LLIMITL);
+set_fan_para(fan1_max, AMC6821_REG_TACH_HLIMITL);
+
+
+static ssize_t get_fan1_div(
+		struct device *dev,
+		struct device_attribute *devattr,
+		char *buf)
+{
+	struct amc6821_data *data =3D amc6821_update_device(dev);
+	return sprintf(buf, "%d\n", data->fan1_div);
+}
+
+static ssize_t set_fan1_div(
+		struct device *dev,
+		struct device_attribute *attr,
+		const char *buf, size_t count)
+{
+	struct i2c_client *client =3D to_i2c_client(dev);
+	struct amc6821_data *data =3D i2c_get_clientdata(client);
+	int val =3D simple_strtol(buf, NULL, 10);
+	int config =3D i2c_smbus_read_byte_data(client, AMC6821_REG_
CONF4);
+
+	if (config < 0) {
+		dev_err(&client->dev,
+			"Error reading configuration register, aborting.\n")
;
+		return -EIO;
+	}
+	mutex_lock(&data->update_lock);
+	switch (val) {
+	case 2:
+		config &=3D ~AMC6821_CONF4_PSPR;
+		data->fan1_div =3D 2;
+		break;
+	case 4:
+		config |=3D AMC6821_CONF4_PSPR;
+		data->fan1_div =3D 4;
+		break;
+	default:
+		mutex_unlock(&data->update_lock);
+		return -EINVAL;
+	}
+	if (i2c_smbus_write_byte_data(client, AMC6821_REG_CONF4,=20
config)) {
+		dev_err(&client->dev,
+			"Configuration register write error, aborting.\n");
+		count =3D -EIO;
+	}
+	mutex_unlock(&data->update_lock);
+	return count;
+}
+
+
+
+static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO, get_temp1_input,=20
NULL, 0);
+static SENSOR_DEVICE_ATTR(temp1_min, S_IRUGO | S_IWUSR, get_
temp1_min,
+	set_temp1_min, 0);
+static SENSOR_DEVICE_ATTR(temp1_max, S_IRUGO | S_IWUSR, get_
temp1_max,
+	set_temp1_max, 0);
+static SENSOR_DEVICE_ATTR(temp1_crit, S_IRUGO | S_IWUSR, get_
temp1_crit,
+	set_temp1_crit, 0);
+static SENSOR_DEVICE_ATTR(temp1_min_alarm, S_IRUGO,
+	get_temp1_min_alarm, NULL, 0);
+static SENSOR_DEVICE_ATTR(temp1_max_alarm, S_IRUGO,
+	get_temp1_max_alarm, NULL, 0);
+static SENSOR_DEVICE_ATTR(temp1_crit_alarm, S_IRUGO,
+	get_temp1_crit_alarm, NULL, 0);
+static SENSOR_DEVICE_ATTR(temp2_input, S_IRUGO | S_IWUSR,
+	get_temp2_input, NULL, 0);
+static SENSOR_DEVICE_ATTR(temp2_min, S_IRUGO | S_IWUSR, get_
temp2_min,
+	set_temp2_min, 0);
+static SENSOR_DEVICE_ATTR(temp2_max, S_IRUGO | S_IWUSR, get_
temp2_max,
+	set_temp2_max, 0);
+static SENSOR_DEVICE_ATTR(temp2_crit, S_IRUGO | S_IWUSR, get_
temp2_crit,
+	set_temp2_crit, 0);
+static SENSOR_DEVICE_ATTR(temp2_fault, S_IRUGO,
+	get_temp2_fault, NULL, 0);
+static SENSOR_DEVICE_ATTR(temp2_min_alarm, S_IRUGO,
+	get_temp2_min_alarm, NULL, 0);
+static SENSOR_DEVICE_ATTR(temp2_max_alarm, S_IRUGO,
+	get_temp2_max_alarm, NULL, 0);
+static SENSOR_DEVICE_ATTR(temp2_crit_alarm, S_IRUGO,
+	get_temp2_crit_alarm, NULL, 0);
+static SENSOR_DEVICE_ATTR(fan1_input, S_IRUGO, get_fan1_input,=20
NULL, 0);
+static SENSOR_DEVICE_ATTR(fan1_min, S_IRUGO | S_IWUSR,
+	get_fan1_min, set_fan1_min, 0);
+static SENSOR_DEVICE_ATTR(fan1_max, S_IRUGO | S_IWUSR,
+	get_fan1_max, set_fan1_max, 0);
+static SENSOR_DEVICE_ATTR(fan1_fault, S_IRUGO, get_fan1_fault,=20
NULL, 0);
+static SENSOR_DEVICE_ATTR(fan1_div, S_IRUGO | S_IWUSR,
+	get_fan1_div, set_fan1_div, 0);
+
+static SENSOR_DEVICE_ATTR(pwm1, S_IWUSR | S_IRUGO, get_pwm1,=20
set_pwm1, 0);
+static SENSOR_DEVICE_ATTR(pwm1_enable, S_IWUSR | S_IRUGO,
+	get_pwm1_enable, set_pwm1_enable, 0);
+static SENSOR_DEVICE_ATTR(pwm1_auto_point1_pwm, S_IRUGO,
+	get_pwm1_auto_point_pwm, NULL, 0);
+static SENSOR_DEVICE_ATTR(pwm1_auto_point2_pwm, S_IWUSR | S_
IRUGO,
+	get_pwm1_auto_point_pwm, set_pwm1_auto_point_pwm, 1);
+static SENSOR_DEVICE_ATTR(pwm1_auto_point3_pwm, S_IRUGO,
+	get_pwm1_auto_point_pwm, NULL, 2);
+static SENSOR_DEVICE_ATTR(pwm1_auto_channels_temp, S_IRUGO,
+	get_pwm1_auto_channels_temp, NULL, 0);
+static SENSOR_DEVICE_ATTR(temp1_auto_point1_temp, S_IRUGO,
+	get_temp1_auto_point_temp, NULL, 0);
+static SENSOR_DEVICE_ATTR(temp1_auto_point2_temp, S_IWUSR | S_
IRUGO,
+	get_temp1_auto_point_temp, set_temp1_auto_point_temp, 1);
+static SENSOR_DEVICE_ATTR(temp1_auto_point3_temp, S_IWUSR | S_
IRUGO,
+	get_temp1_auto_point_temp, set_temp1_auto_point_temp, 2);
+
+static SENSOR_DEVICE_ATTR(temp2_auto_point1_temp, S_IWUSR | S_
IRUGO,
+	get_temp2_auto_point_temp, set_temp2_auto_point_temp, 0);
+static SENSOR_DEVICE_ATTR(temp2_auto_point2_temp, S_IWUSR | S_
IRUGO,
+	get_temp2_auto_point_temp, set_temp2_auto_point_temp, 1);
+static SENSOR_DEVICE_ATTR(temp2_auto_point3_temp, S_IWUSR | S_
IRUGO,
+	get_temp2_auto_point_temp, set_temp2_auto_point_temp, 2);
+
+
+
+static struct attribute *amc6821_attrs[] =3D {
+	&sensor_dev_attr_temp1_input.dev_attr.attr,
+	&sensor_dev_attr_temp1_min.dev_attr.attr,
+	&sensor_dev_attr_temp1_max.dev_attr.attr,
+	&sensor_dev_attr_temp1_crit.dev_attr.attr,
+	&sensor_dev_attr_temp1_min_alarm.dev_attr.attr,
+	&sensor_dev_attr_temp1_max_alarm.dev_attr.attr,
+	&sensor_dev_attr_temp1_crit_alarm.dev_attr.attr,
+	&sensor_dev_attr_temp2_input.dev_attr.attr,
+	&sensor_dev_attr_temp2_min.dev_attr.attr,
+	&sensor_dev_attr_temp2_max.dev_attr.attr,
+	&sensor_dev_attr_temp2_crit.dev_attr.attr,
+	&sensor_dev_attr_temp2_min_alarm.dev_attr.attr,
+	&sensor_dev_attr_temp2_max_alarm.dev_attr.attr,
+	&sensor_dev_attr_temp2_crit_alarm.dev_attr.attr,
+	&sensor_dev_attr_temp2_fault.dev_attr.attr,
+	&sensor_dev_attr_fan1_input.dev_attr.attr,
+	&sensor_dev_attr_fan1_min.dev_attr.attr,
+	&sensor_dev_attr_fan1_max.dev_attr.attr,
+	&sensor_dev_attr_fan1_fault.dev_attr.attr,
+	&sensor_dev_attr_fan1_div.dev_attr.attr,
+	&sensor_dev_attr_pwm1.dev_attr.attr,
+	&sensor_dev_attr_pwm1_enable.dev_attr.attr,
+	&sensor_dev_attr_pwm1_auto_channels_temp.dev_attr.attr,
+	&sensor_dev_attr_pwm1_auto_point1_pwm.dev_attr.attr,
+	&sensor_dev_attr_pwm1_auto_point2_pwm.dev_attr.attr,
+	&sensor_dev_attr_pwm1_auto_point3_pwm.dev_attr.attr,
+	&sensor_dev_attr_temp1_auto_point1_temp.dev_attr.attr,
+	&sensor_dev_attr_temp1_auto_point2_temp.dev_attr.attr,
+	&sensor_dev_attr_temp1_auto_point3_temp.dev_attr.attr,
+	&sensor_dev_attr_temp2_auto_point1_temp.dev_attr.attr,
+	&sensor_dev_attr_temp2_auto_point2_temp.dev_attr.attr,
+	&sensor_dev_attr_temp2_auto_point3_temp.dev_attr.attr,
+	NULL
+};
+
+static struct attribute_group amc6821_attr_grp =3D {
+	.attrs =3D amc6821_attrs,
+};
+
+
+
+/* Return 0 if detection is successful, -ENODEV otherwise */
+static int amc6821_detect(
+		struct i2c_client *client,
+		int kind,
+		struct i2c_board_info *info)
+{
+	struct i2c_adapter *adapter =3D client->adapter;
+	int address =3D client->addr;
+
+	dev_dbg(&adapter->dev, "amc6821_detect called, kind =3D %d\n",=20
kind);
+
+	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_
DATA)) {
+		dev_dbg(&adapter->dev,
+		"max6650: I2C bus doesn't support byte read mode,=20
skipping.\n");
+		return -ENODEV;
+	}
+	if ((kind < 0) &&
+		((i2c_smbus_read_byte_data(client, AMC6821_REG_DEV_
ID) &
+			0xDE) ||
+		(i2c_smbus_read_byte_data(client, AMC6821_REG_
COMP_ID) &
+			0xB6))) {
+			dev_dbg(&adapter->dev,
+				"amc6821: detection failed at 0x%02x.
\n",
+				address);
+		return -ENODEV;
+	}
+
+	dev_info(&adapter->dev, "amc6821: chip found at 0x%02x.\n",=20
address);
+	strlcpy(info->type, "amc6821", I2C_NAME_SIZE);
+
+	return 0;
+}
+
+static int amc6821_probe(
+	struct i2c_client *client,
+	const struct i2c_device_id *id)
+{
+	struct amc6821_data *data;
+	int err;
+
+	data =3D kzalloc(sizeof(struct amc6821_data), GFP_KERNEL);
+	if (!data) {
+		dev_err(&client->dev, "out of memory.\n");
+		return -ENOMEM;
+	}
+
+
+	i2c_set_clientdata(client, data);
+	mutex_init(&data->update_lock);
+
+	/*
+	 * Initialize the amc6821 chip
+	 */
+	err =3D amc6821_init_client(client);
+	if (err)
+		goto err_free;
+
+	err =3D sysfs_create_group(&client->dev.kobj, &amc6821_attr_grp);
+	if (err)
+		goto err_free;
+
+	data->hwmon_dev =3D hwmon_device_register(&client->dev);
+	if (!IS_ERR(data->hwmon_dev))
+		return 0;
+
+	err =3D PTR_ERR(data->hwmon_dev);
+	dev_err(&client->dev, "error registering hwmon device.\n");
+	sysfs_remove_group(&client->dev.kobj, &amc6821_attr_grp);
+err_free:
+	kfree(data);
+	return err;
+}
+
+static int amc6821_remove(struct i2c_client *client)
+{
+	struct amc6821_data *data =3D i2c_get_clientdata(client);
+
+	hwmon_device_unregister(data->hwmon_dev);
+	sysfs_remove_group(&client->dev.kobj, &amc6821_attr_grp);
+
+	kfree(data);
+
+	return 0;
+}
+
+
+static int amc6821_init_client(struct i2c_client *client)
+{
+	int config;
+	int err =3D -EIO;
+
+	if (init) {
+		config =3D i2c_smbus_read_byte_data(client, AMC6821_
REG_CONF4);
+
+		if (config < 0) {
+				dev_err(&client->dev,
+			"Error reading configuration register, aborting.\n")
;
+				return err;
+		}
+
+		config |=3D AMC6821_CONF4_MODE;
+
+		if (i2c_smbus_write_byte_data(client, AMC6821_REG_
CONF4,
+				config)) {
+			dev_err(&client->dev,
+			"Configuration register write error, aborting.\n");
+			return err;
+		}
+
+		config =3D i2c_smbus_read_byte_data(client, AMC6821_
REG_CONF3);
+
+		if (config < 0) {
+			dev_err(&client->dev,
+			"Error reading configuration register, aborting.\n")
;
+			return err;
+		}
+
+		config &=3D ~AMC6821_CONF3_THERM_FAN_EN;
+
+		if (i2c_smbus_write_byte_data(client, AMC6821_REG_
CONF3,
+				config)) {
+			dev_err(&client->dev,
+			"Configuration register write error, aborting.\n");
+			return err;
+		}
+
+		config =3D i2c_smbus_read_byte_data(client, AMC6821_
REG_CONF2);
+
+		if (config < 0) {
+			dev_err(&client->dev,
+			"Error reading configuration register, aborting.\n")
;
+			return err;
+		}
+
+		config &=3D ~AMC6821_CONF2_RTFIE;
+		config &=3D ~AMC6821_CONF2_LTOIE;
+		config &=3D ~AMC6821_CONF2_RTOIE;
+		if (i2c_smbus_write_byte_data(client,
+				AMC6821_REG_CONF2, config)) {
+			dev_err(&client->dev,
+			"Configuration register write error, aborting.\n");
+			return err;
+		}
+
+		config =3D i2c_smbus_read_byte_data(client, AMC6821_
REG_CONF1);
+
+		if (config < 0) {
+			dev_err(&client->dev,
+			"Error reading configuration register, aborting.\n")
;
+			return err;
+		}
+
+		config &=3D ~AMC6821_CONF1_THERMOVIE;
+		config &=3D ~AMC6821_CONF1_FANIE;
+		config |=3D AMC6821_CONF1_START;
+		if (pwminv)
+			config |=3D AMC6821_CONF1_PWMINV;
+		else
+			config &=3D ~AMC6821_CONF1_PWMINV;
+
+		if (i2c_smbus_write_byte_data(
+				client, AMC6821_REG_CONF1, config)) {
+			dev_err(&client->dev,
+			"Configuration register write error, aborting.\n");
+			return err;
+		}
+	}
+	return 0;
+}
+
+
+static struct amc6821_data *amc6821_update_device(struct device *dev)
+{
+	struct i2c_client *client =3D to_i2c_client(dev);
+	struct amc6821_data *data =3D i2c_get_clientdata(client);
+	int timeout =3D HZ;
+	u8 reg;
+
+	mutex_lock(&data->update_lock);
+
+	if (time_after(jiffies, data->last_updated + timeout) ||
+			!data->valid) {
+		data->temp1_input =3D i2c_smbus_read_byte_data(client,
+			AMC6821_REG_LTEMP_HI);
+		data->temp1_min =3D i2c_smbus_read_byte_data(client,
+			AMC6821_REG_LTEMP_LIMIT_MIN);
+		data->temp1_max =3D i2c_smbus_read_byte_data(client,
+			AMC6821_REG_LTEMP_LIMIT_MAX);
+		data->temp1_crit =3D i2c_smbus_read_byte_data(client,
+			AMC6821_REG_LTEMP_CRIT);
+
+		data->temp2_input =3D i2c_smbus_read_byte_data(client,
+			AMC6821_REG_RTEMP_HI);
+		data->temp2_min =3D i2c_smbus_read_byte_data(client,
+			AMC6821_REG_RTEMP_LIMIT_MIN);
+		data->temp2_max =3D i2c_smbus_read_byte_data(client,
+			AMC6821_REG_RTEMP_LIMIT_MAX);
+		data->temp2_crit =3D i2c_smbus_read_byte_data(client,
+			AMC6821_REG_RTEMP_CRIT);
+
+		data->stat1 =3D i2c_smbus_read_byte_data(client,
+			AMC6821_REG_STAT1);
+		data->stat2 =3D i2c_smbus_read_byte_data(client,
+			AMC6821_REG_STAT2);
+
+		data->pwm1 =3D i2c_smbus_read_byte_data(client,
+			AMC6821_REG_DCY);
+		data->fan1_input =3D i2c_smbus_read_byte_data(client,
+			AMC6821_REG_TDATA_LOW);
+		data->fan1_input +=3D i2c_smbus_read_byte_data(client,
+			AMC6821_REG_TDATA_HI) << 8;
+		data->fan1_min =3D i2c_smbus_read_byte_data(client,
+			AMC6821_REG_TACH_LLIMITL);
+		data->fan1_min +=3D i2c_smbus_read_byte_data(client,
+			AMC6821_REG_TACH_LLIMITL+1) << 8;
+		data->fan1_max =3D i2c_smbus_read_byte_data(client,
+			AMC6821_REG_TACH_HLIMITL);
+		data->fan1_max +=3D i2c_smbus_read_byte_data(client,
+			AMC6821_REG_TACH_HLIMITL+1) << 8;
+		data->fan1_div =3D i2c_smbus_read_byte_data(client,
+			AMC6821_REG_CONF4);
+		data->fan1_div =3D data->fan1_div & AMC6821_CONF4_
PSPR ? 4 : 2;
+
+		data->pwm1_auto_point_pwm[0] =3D 0;
+		data->pwm1_auto_point_pwm[2] =3D 255;
+		data->pwm1_auto_point_pwm[1] =3D i2c_smbus_read_byte_
data(client,
+			AMC6821_REG_DCY_LOW_TEMP);
+
+		data->temp1_auto_point_temp[0] =3D
+			i2c_smbus_read_byte_data(client,
+					AMC6821_REG_PSV_TEMP);
+		data->temp2_auto_point_temp[0] =3D
+				data->temp1_auto_point_temp[0];
+		reg =3D i2c_smbus_read_byte_data(client,
+			AMC6821_REG_LTEMP_FAN_CTRL);
+		data->temp1_auto_point_temp[1] =3D (reg & 0xF8) >> 1;
+		reg &=3D 0x07;
+		reg =3D 0x20 >> reg;
+		if (reg > 0)
+			data->temp1_auto_point_temp[2] =3D
+				data->temp1_auto_point_temp[1] +
+				(data->pwm1_auto_point_pwm[2] -
+				data->pwm1_auto_point_pwm[1]) / reg;
+		else
+			data->temp1_auto_point_temp[2] =3D 255;
+
+		reg =3D i2c_smbus_read_byte_data(client,
+			AMC6821_REG_RTEMP_FAN_CTRL);
+		data->temp2_auto_point_temp[1] =3D (reg & 0xF8) >> 1;
+		reg &=3D 0x07;
+		reg =3D 0x20 >> reg;
+		if (reg > 0)
+			data->temp2_auto_point_temp[2] =3D
+				data->temp2_auto_point_temp[1] +
+				(data->pwm1_auto_point_pwm[2] -
+				data->pwm1_auto_point_pwm[1]) / reg;
+		else
+			data->temp2_auto_point_temp[2] =3D 255;
+
+		reg =3D i2c_smbus_read_byte_data(client, AMC6821_REG_
CONF1);
+		reg =3D (reg >> 5) & 0x3;
+		switch (reg) {
+		case 0: /*open loop: software sets pwm1*/
+			data->pwm1_auto_channels_temp =3D 0;
+			data->pwm1_enable =3D 1;
+			break;
+		case 2: /*closed loop: remote T (temp2)*/
+			data->pwm1_auto_channels_temp =3D 2;
+			data->pwm1_enable =3D 2;
+			break;
+		case 3: /*closed loop: local and remote T (temp2)*/
+			data->pwm1_auto_channels_temp =3D 3;
+			data->pwm1_enable =3D 3;
+			break;
+		case 1: /*semi-open loop: software sets rpm, chip=20
controls pwm1,
+			  *currently not implemented
+			  */
+			data->pwm1_auto_channels_temp =3D 0;
+			data->pwm1_enable =3D 0;
+			break;
+		}
+
+		data->last_updated =3D jiffies;
+		data->valid =3D 1;
+	}
+	mutex_unlock(&data->update_lock);
+	return data;
+}
+
+
+static int __init amc6821_init(void)
+{
+	return i2c_add_driver(&amc6821_driver);
+}
+
+static void __exit amc6821_exit(void)
+{
+	i2c_del_driver(&amc6821_driver);
+}
+
+module_init(amc6821_init);
+module_exit(amc6821_exit);
+
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("T. Mertelj <tomaz.mertelj@guest.arnes.si>");
+MODULE_DESCRIPTION("Texas Instruments amc6821 hwmon driver");
+MODULE_SUPPORTED_DEVICE("amc6821");

--Arnes-Webmail-11976
Content-type: application/octet-stream; name="amc6821.diff"
Content-transfer-encoding: Base64
Content-disposition: attachment; filename="amc6821.diff"

ZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vaHdtb24vYW1jNjgyMSBiL0RvY3VtZW50YXRpb24v
aHdtb24vYW1jNjgyMQpuZXcgZmlsZSBtb2RlIDEwMDY0NAppbmRleCAwMDAwMDAwLi5iN2NiYTg2
Ci0tLSAvZGV2L251bGwKKysrIGIvRG9jdW1lbnRhdGlvbi9od21vbi9hbWM2ODIxCkBAIC0wLDAg
KzEsMTAxIEBACitLZXJuZWwgZHJpdmVyIGFtYzY4MjEKKz09PT09PT09PT09PT09PT09PT09PQor
CitTdXBwb3J0ZWQgY2hpcHM6CisJUHJlZml4OiAnYW1jNjgyMScKKwlBZGRyZXNzZXMgc2Nhbm5l
ZDogMHgxOCwgMHgxOSwgMHgxYSwgMHgyYywgMHgyZCwgMHgyZSwgMHg0YywgMHg0ZCwgMHg0ZQor
CURhdGFzaGVldDogaHR0cDovL2ZvY3VzLnRpLmNvbS9kb2NzL3Byb2QvZm9sZGVycy9wcmludC9h
bWM2ODIxLmh0bWwKKworQXV0aG9yczoKKwlUb21heiBNZXJ0ZWxqIDx0b21hei5tZXJ0ZWxqQGd1
ZXN0LmFybmVzLnNpPgorCisKK0Rlc2NyaXB0aW9uCistLS0tLS0tLS0tLQorCitUaGlzIGRyaXZl
ciBpbXBsZW1lbnRzIHN1cHBvcnQgZm9yIHRoZSBUZXhhcyBJbnN0cnVtZW50cyBhbWM2ODIxIGNo
aXAuCitUaGUgY2hpcCBoYXMgb25lIG9uLWNoaXAgYW5kIG9uZSByZW1vdGUgdGVtcGVyYXR1cmUg
c2Vuc29yIGFuZCBvbmUgcHdtIGZhbgorcmVndWxhdG9yLgorVGhlIHB3bSBjYW4gYmUgY29udHJv
bGxlZCBlaXRoZXIgZnJvbSBzb2Z0d2FyZSBvciBhdXRvbWF0aWNhbGx5LgorCitUaGUgZHJpdmVy
IHByb3ZpZGVzIHRoZSBmb2xsb3dpbmcgc2Vuc29yIGFjY2Vzc2VzIGluIHN5c2ZzOgorCit0ZW1w
MV9pbnB1dAkJcm8Jb24tY2hpcCB0ZW1wZXJhdHVyZQordGVtcDFfbWluCQlydwkiCit0ZW1wMV9t
YXgJCXJ3CSIKK3RlbXAxX2NyaXQJIAlydwkiCit0ZW1wMV9taW5fYWxhcm0JCXJvCSIKK3RlbXAx
X21heF9hbGFybQkJcm8JIgordGVtcDFfY3JpdF9hbGFybQlybwkiCisKK3RlbXAyX2lucHV0CQly
bwlyZW1vdGUgdGVtcGVyYXR1cmUKK3RlbXAyX21pbgkJcncJIgordGVtcDJfbWF4CQlydwkiCit0
ZW1wMl9jcml0CSAJcncJIgordGVtcDJfbWluX2FsYXJtCQlybwkiCit0ZW1wMl9tYXhfYWxhcm0J
CXJvCSIKK3RlbXAyX2NyaXRfYWxhcm0Jcm8JIgordGVtcDJfZmF1bHQJCXJvCSIKKworZmFuMV9p
bnB1dAkgCXJvCXRhY2hvbWV0ZXIgc3BlZWQKK2ZhbjFfbWluCQlydwkiCitmYW4xX21heAkJcncJ
IgorZmFuMV9mYXVsdAkgCXJvCSIKK2ZhbjFfZGl2CQlydwlGYW4gZGl2aXNvciBjYW4gYmUgZWl0
aGVyIDIgb3IgNC4KKworcHdtMQkJCXJ3CXB3bTEKK3B3bTFfZW5hYmxlCQlydwlyZWd1bGF0b3Ig
bW9kZSwgMT1vcGVuIGxvb3AsIDI9ZmFuIGNvbnRyb2xsZWQKKwkJCQlieSByZW1vdGUgdGVtcGVy
YXR1cmUsIDM9ZmFuIGNvbnRyb2xsZWQgYnkKKwkJCQljb21iaW5hdGlvbiBvZiBvbi1jaGlwIHRl
bXBlcmF0dXJlIGFuZAorCQkJCXJlbW90ZS1zZW5zb3IgdGVtcGVyYXR1cmUsCitwd20xX2F1dG9f
Y2hhbm5lbHNfdGVtcCBybwkxIGlmIHB3bV9lbmFibGU9PTIsIDMgaWYgcHdtX2VuYWJsZT09Mwor
cHdtMV9hdXRvX3BvaW50MV9wd20Jcm8JSGFyZHdpcmVkIHRvIDAsIHNoYXJlZCBmb3IgYm90aAor
CQkJCXRlbXBlcmF0dXJlIGNoYW5uZWxzLgorcHdtMV9hdXRvX3BvaW50Ml9wd20JcncJVGhpcyB2
YWx1ZSwgc2hhcmVkIGZvciBib3RoIHRlbXBlcmF0dXJlCisJCQkJY2hhbm5lbHMuCitwd20xX2F1
dG9fcG9pbnQzX3B3bQlydwlIYXJkd2lyZWQgdG8gMjU1LCBzaGFyZWQgZm9yIGJvdGgKKwkJCQl0
ZW1wZXJhdHVyZSBjaGFubmVscy4KKwordGVtcDFfYXV0b19wb2ludDFfdGVtcAlybwlIYXJkd2ly
ZWQgdG8gdGVtcDJfYXV0b19wb2ludDFfdGVtcAorCQkJCXdoaWNoIGlzIHJ3LiBCZWxvdyB0aGlz
IHRlbXBlcmF0dXJlIGZhbiBzdG9wcy4KK3RlbXAxX2F1dG9fcG9pbnQyX3RlbXAJcncJVGhlIGxv
dy10ZW1wZXJhdHVyZSBsaW1pdCBvZiB0aGUgcHJvcG9ydGlvbmFsCisJCQkJcmFuZ2UuIEJlbG93
IHRoaXMgdGVtcGVyYXR1cmUKKwkJCQlwd20xID0gcHdtMV9hdXRvX3BvaW50Ml9wd20uIEl0IGNh
biBnbyBmcm9tCisJCQkJMCBkZWdyZWUgQyBhbmQgMTI0IGRlZ3JlZSBDIGluIHN0ZXBzIG9mCisJ
CQkJNCBkZWdyZWUgQy4gUmVhZCBpdCBvdXQgYWZ0ZXIgd3JpdGluZyB0byBnZXQKKwkJCQlhY3R1
YWwgdmFsdWUuCit0ZW1wMV9hdXRvX3BvaW50M190ZW1wCXJ3CUFib3ZlIHRoaXMgdGVtcGVyYXR1
cmUgZmFuIHJ1bnMgYXQgbWF4aW11bQorCQkJCXNwZWVkLiBJdCBjYW4gZ28gZnJvbSB0ZW1wMV9h
dXRvX3BvaW50Ml90ZW1wLgorCQkJCUl0IGNhbiBvbmx5IGhhdmUgY2VydGFpbiBkaXNjcmV0ZSB2
YWx1ZXMKKwkJCQl3aGljaCBkZXBlbmQgb24gdGVtcDFfYXV0b19wb2ludDJfdGVtcCBhbmQKKwkJ
CQlwd20xX2F1dG9fcG9pbnQyX3B3bS4gUmVhZCBpdCBvdXQgYWZ0ZXIKKwkJCQl3cml0aW5nIHRv
IGdldCB0aGUgYWN0dWFsIHZhbHVlLgorCit0ZW1wMl9hdXRvX3BvaW50MV90ZW1wCXJ3CU11c3Qg
YmUgYmV0d2VlbiAwIGRlZ3JlZSBDIGFuZCA2MyBkZWdyZWUgQyBhbmQKKwkJCQlpdCBkZWZpbmVz
IHBhc3NpdmUgY29vbGluZyB0ZW1wZXJhdHVyZS4KKwkJCQlCZWxvdyB0aGlzIHRlbXBlcmF0dXJl
IHRoZSBmYW4gc3RvcHMgaW4KKwkJCQl0aGUgY2xvc2VkIGxvb3AgbW9kZS4KK3RlbXAyX2F1dG9f
cG9pbnQyX3RlbXAJcncJVGhlIGxvdy10ZW1wZXJhdHVyZSBsaW1pdCBvZiB0aGUgcHJvcG9ydGlv
bmFsCisJCQkJcmFuZ2UuIEJlbG93IHRoaXMgdGVtcGVyYXR1cmUKKwkJCQlwd20xID0gcHdtMV9h
dXRvX3BvaW50Ml9wd20uIEl0IGNhbiBnbyBmcm9tCisJCQkJMCBkZWdyZWUgQyBhbmQgMTI0IGRl
Z3JlZSBDIGluIHN0ZXBzCisJCQkJb2YgNCBkZWdyZWUgQy4KKwordGVtcDJfYXV0b19wb2ludDNf
dGVtcAlydwlBYm92ZSB0aGlzIHRlbXBlcmF0dXJlIGZhbiBydW5zIGF0IG1heGltdW0KKwkJCQlz
cGVlZC4gSXQgY2FuIG9ubHkgaGF2ZSBjZXJ0YWluIGRpc2NyZXRlCisJCQkJdmFsdWVzIHdoaWNo
IGRlcGVuZCBvbiB0ZW1wMl9hdXRvX3BvaW50Ml90ZW1wCisJCQkJYW5kIHB3bTFfYXV0b19wb2lu
dDJfcHdtLiBSZWFkIGl0IG91dCBhZnRlcgorCQkJCXdyaXRpbmcgdG8gZ2V0IGFjdHVhbCB2YWx1
ZS4KKworCitNb2R1bGUgcGFyYW1ldGVycworLS0tLS0tLS0tLS0tLS0tLS0KKworSWYgeW91ciBi
b2FyZCBoYXMgYSBCSU9TIHRoYXQgaW5pdGlhbGl6ZXMgdGhlIGFtYzY4MjEgY29ycmVjdGx5LCB5
b3Ugc2hvdWxkCitsb2FkIHRoZSBtb2R1bGUgd2l0aDogaW5pdD0wLgorCitJZiB5b3VyIGJvYXJk
IEJJT1MgZG9lc24ndCBpbml0aWFsaXplIHRoZSBjaGlwLCBvciB5b3Ugd2FudAorZGlmZmVyZW50
IHNldHRpbmdzLCB5b3UgY2FuIHNldCB0aGUgZm9sbG93aW5nIHBhcmFtZXRlcnM6Citpbml0PTEs
Citwd21pbnY6IDAgZGVmYXVsdCBwd20gb3V0cHV0LCAxIGludmVydHMgcHdtIG91dHB1dC4KKwpk
aWZmIC0tZ2l0IGEvZHJpdmVycy9od21vbi9LY29uZmlnIGIvZHJpdmVycy9od21vbi9LY29uZmln
CmluZGV4IDJkNTAxNjYuLmRiZTE4MGYgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvaHdtb24vS2NvbmZp
ZworKysgYi9kcml2ZXJzL2h3bW9uL0tjb25maWcKQEAgLTc3Nyw2ICs3NzcsMTYgQEAgY29uZmln
IFNFTlNPUlNfQURTNzgyOAogCSAgVGhpcyBkcml2ZXIgY2FuIGFsc28gYmUgYnVpbHQgYXMgYSBt
b2R1bGUuICBJZiBzbywgdGhlIG1vZHVsZQogCSAgd2lsbCBiZSBjYWxsZWQgYWRzNzgyOC4KIAor
Y29uZmlnIFNFTlNPUlNfQU1DNjgyMQorCXRyaXN0YXRlICJUZXhhcyBJbnN0cnVtZW50cyBBTUM2
ODIxIgorCWRlcGVuZHMgb24gSTJDICAmJiBFWFBFUklNRU5UQUwKKwloZWxwCisJICBJZiB5b3Ug
c2F5IHllcyBoZXJlIHlvdSBnZXQgc3VwcG9ydCBmb3IgdGhlIFRleGFzIEluc3RydW1lbnRzCisJ
ICBBTUM2ODIxIGhhcmR3YXJlIG1vbml0b3JpbmcgY2hpcHMuCisKKwkgIFRoaXMgZHJpdmVyIGNh
biBhbHNvIGJlIGJ1aWxkIGFzIGEgbW9kdWxlLiAgSWYgc28sIHRoZSBtb2R1bGUKKwkgIHdpbGwg
YmUgY2FsbGVkIGFtYzY4MjEuCisKIGNvbmZpZyBTRU5TT1JTX1RITUM1MAogCXRyaXN0YXRlICJU
ZXhhcyBJbnN0cnVtZW50cyBUSE1DNTAgLyBBbmFsb2cgRGV2aWNlcyBBRE0xMDIyIgogCWRlcGVu
ZHMgb24gSTJDICYmIEVYUEVSSU1FTlRBTApkaWZmIC0tZ2l0IGEvZHJpdmVycy9od21vbi9NYWtl
ZmlsZSBiL2RyaXZlcnMvaHdtb24vTWFrZWZpbGUKaW5kZXggYjc5M2RjZS4uNDMxZGU3NiAxMDA2
NDQKLS0tIGEvZHJpdmVycy9od21vbi9NYWtlZmlsZQorKysgYi9kcml2ZXJzL2h3bW9uL01ha2Vm
aWxlCkBAIC04MSw2ICs4MSw3IEBAIG9iai0kKENPTkZJR19TRU5TT1JTX1NJUzU1OTUpCSs9IHNp
czU1OTUubwogb2JqLSQoQ09ORklHX1NFTlNPUlNfU01TQzQ3QjM5NykrPSBzbXNjNDdiMzk3Lm8K
IG9iai0kKENPTkZJR19TRU5TT1JTX1NNU0M0N00xKQkrPSBzbXNjNDdtMS5vCiBvYmotJChDT05G
SUdfU0VOU09SU19TTVNDNDdNMTkyKSs9IHNtc2M0N20xOTIubworb2JqLSQoQ09ORklHX1NFTlNP
UlNfQU1DNjgyMSkJKz0gYW1jNjgyMS5vCiBvYmotJChDT05GSUdfU0VOU09SU19USE1DNTApCSs9
IHRobWM1MC5vCiBvYmotJChDT05GSUdfU0VOU09SU19UTVA0MDEpCSs9IHRtcDQwMS5vCiBvYmot
JChDT05GSUdfU0VOU09SU19WSUE2ODZBKQkrPSB2aWE2ODZhLm8KZGlmZiAtLWdpdCBhL2RyaXZl
cnMvaHdtb24vYW1jNjgyMS5jIGIvZHJpdmVycy9od21vbi9hbWM2ODIxLmMKbmV3IGZpbGUgbW9k
ZSAxMDA2NDQKaW5kZXggMDAwMDAwMC4uNjkwNWM1ZQotLS0gL2Rldi9udWxsCisrKyBiL2RyaXZl
cnMvaHdtb24vYW1jNjgyMS5jCkBAIC0wLDAgKzEsMTAzNyBAQAorLyoKKwlhbWM2ODIxLmMgLSBQ
YXJ0IG9mIGxtX3NlbnNvcnMsIExpbnV4IGtlcm5lbCBtb2R1bGVzIGZvciBoYXJkd2FyZQorCW1v
bml0b3JpbmcKKwlDb3B5cmlnaHQgKEMpIDIwMDkgVC4gTWVydGVsaiA8dG9tYXoubWVydGVsakBn
dWVzdC5hcm5lcy5zaT4KKworCVRoaXMgcHJvZ3JhbSBpcyBmcmVlIHNvZnR3YXJlOyB5b3UgY2Fu
IHJlZGlzdHJpYnV0ZSBpdCBhbmQvb3IgbW9kaWZ5CisJaXQgdW5kZXIgdGhlIHRlcm1zIG9mIHRo
ZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZSBhcyBwdWJsaXNoZWQgYnkKKwl0aGUgRnJlZSBT
b2Z0d2FyZSBGb3VuZGF0aW9uOyBlaXRoZXIgdmVyc2lvbiAyIG9mIHRoZSBMaWNlbnNlLCBvcgor
CShhdCB5b3VyIG9wdGlvbikgYW55IGxhdGVyIHZlcnNpb24uCisKKwlUaGlzIHByb2dyYW0gaXMg
ZGlzdHJpYnV0ZWQgaW4gdGhlIGhvcGUgdGhhdCBpdCB3aWxsIGJlIHVzZWZ1bCwKKwlidXQgV0lU
SE9VVCBBTlkgV0FSUkFOVFk7IHdpdGhvdXQgZXZlbiB0aGUgaW1wbGllZCB3YXJyYW50eSBvZgor
CU1FUkNIQU5UQUJJTElUWSBvciBGSVRORVNTIEZPUiBBIFBBUlRJQ1VMQVIgUFVSUE9TRS4gIFNl
ZSB0aGUKKwlHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZSBmb3IgbW9yZSBkZXRhaWxzLgorCisJ
WW91IHNob3VsZCBoYXZlIHJlY2VpdmVkIGEgY29weSBvZiB0aGUgR05VIEdlbmVyYWwgUHVibGlj
IExpY2Vuc2UKKwlhbG9uZyB3aXRoIHRoaXMgcHJvZ3JhbTsgaWYgbm90LCB3cml0ZSB0byB0aGUg
RnJlZSBTb2Z0d2FyZQorCUZvdW5kYXRpb24sIEluYy4sIDY3NSBNYXNzIEF2ZSwgQ2FtYnJpZGdl
LCBNQSAwMjEzOSwgVVNBLgorKi8KKworCisjaW5jbHVkZSA8bGludXgva2VybmVsLmg+CS8qIE5l
ZWRlZCBmb3IgS0VSTl9JTkZPICovCisjaW5jbHVkZSA8bGludXgvbW9kdWxlLmg+CisjaW5jbHVk
ZSA8bGludXgvaW5pdC5oPgorI2luY2x1ZGUgPGxpbnV4L3NsYWIuaD4KKyNpbmNsdWRlIDxsaW51
eC9qaWZmaWVzLmg+CisjaW5jbHVkZSA8bGludXgvaTJjLmg+CisjaW5jbHVkZSA8bGludXgvaHdt
b24uaD4KKyNpbmNsdWRlIDxsaW51eC9od21vbi1zeXNmcy5oPgorI2luY2x1ZGUgPGxpbnV4L2Vy
ci5oPgorI2luY2x1ZGUgPGxpbnV4L211dGV4Lmg+CisKKworLyoKKyAqIEFkZHJlc3NlcyB0byBz
Y2FuLgorICovCisKK3N0YXRpYyBjb25zdCB1bnNpZ25lZCBzaG9ydCBub3JtYWxfaTJjW10gPSB7
MHgxOCwgMHgxOSwgMHgxYSwgMHgyYywgMHgyZCwgMHgyZSwKKwkweDRjLCAweDRkLCAweDRlLCBJ
MkNfQ0xJRU5UX0VORH07CisKKworCisvKgorICogSW5zbW9kIHBhcmFtZXRlcnMKKyAqLworCitz
dGF0aWMgaW50IHB3bWludiA9IDA7CS8qSW52ZXJ0ZWQgUFdNIG91dHB1dC4gKi8KK21vZHVsZV9w
YXJhbShwd21pbnYsIGludCwgU19JUlVHTyk7CisKK3N0YXRpYyBpbnQgaW5pdCA9IDE7IC8qUG93
ZXItb24gaW5pdGlhbGl6YXRpb24uKi8KK21vZHVsZV9wYXJhbShpbml0LCBpbnQsIFNfSVJVR08p
OworCisKK0kyQ19DTElFTlRfSU5TTU9EXzEoYW1jNjgyMSk7CisKKyNkZWZpbmUgQU1DNjgyMV9S
RUdfREVWX0lEIDB4M0QKKyNkZWZpbmUgQU1DNjgyMV9SRUdfQ09NUF9JRCAweDNFCisjZGVmaW5l
IEFNQzY4MjFfUkVHX0NPTkYxIDB4MDAKKyNkZWZpbmUgQU1DNjgyMV9SRUdfQ09ORjIgMHgwMQor
I2RlZmluZSBBTUM2ODIxX1JFR19DT05GMyAweDNGCisjZGVmaW5lIEFNQzY4MjFfUkVHX0NPTkY0
IDB4MDQKKyNkZWZpbmUgQU1DNjgyMV9SRUdfU1RBVDEgMHgwMgorI2RlZmluZSBBTUM2ODIxX1JF
R19TVEFUMiAweDAzCisjZGVmaW5lIEFNQzY4MjFfUkVHX1REQVRBX0xPVyAweDA4CisjZGVmaW5l
IEFNQzY4MjFfUkVHX1REQVRBX0hJIDB4MDkKKyNkZWZpbmUgQU1DNjgyMV9SRUdfTFRFTVBfSEkg
MHgwQQorI2RlZmluZSBBTUM2ODIxX1JFR19SVEVNUF9ISSAweDBCCisjZGVmaW5lIEFNQzY4MjFf
UkVHX0xURU1QX0xJTUlUX01JTiAweDE1CisjZGVmaW5lIEFNQzY4MjFfUkVHX0xURU1QX0xJTUlU
X01BWCAweDE0CisjZGVmaW5lIEFNQzY4MjFfUkVHX1JURU1QX0xJTUlUX01JTiAweDE5CisjZGVm
aW5lIEFNQzY4MjFfUkVHX1JURU1QX0xJTUlUX01BWCAweDE4CisjZGVmaW5lIEFNQzY4MjFfUkVH
X0xURU1QX0NSSVQgMHgxQgorI2RlZmluZSBBTUM2ODIxX1JFR19SVEVNUF9DUklUIDB4MUQKKyNk
ZWZpbmUgQU1DNjgyMV9SRUdfUFNWX1RFTVAgMHgxQworI2RlZmluZSBBTUM2ODIxX1JFR19EQ1kg
MHgyMgorI2RlZmluZSBBTUM2ODIxX1JFR19MVEVNUF9GQU5fQ1RSTCAweDI0CisjZGVmaW5lIEFN
QzY4MjFfUkVHX1JURU1QX0ZBTl9DVFJMIDB4MjUKKyNkZWZpbmUgQU1DNjgyMV9SRUdfRENZX0xP
V19URU1QIDB4MjEKKworI2RlZmluZSBBTUM2ODIxX1JFR19UQUNIX0xMSU1JVEwgMHgxMAorI2Rl
ZmluZSBBTUM2ODIxX1JFR19UQUNIX0xMSU1JVEggMHgxMQorI2RlZmluZSBBTUM2ODIxX1JFR19U
QUNIX0hMSU1JVEwgMHgxMgorI2RlZmluZSBBTUM2ODIxX1JFR19UQUNIX0hMSU1JVEggMHgxMwor
CisjZGVmaW5lIEFNQzY4MjFfQ09ORjFfU1RBUlQgMHgwMQorI2RlZmluZSBBTUM2ODIxX0NPTkYx
X0ZBTl9JTlRfRU4gMHgwMgorI2RlZmluZSBBTUM2ODIxX0NPTkYxX0ZBTklFIDB4MDQKKyNkZWZp
bmUgQU1DNjgyMV9DT05GMV9QV01JTlYgMHgwOAorI2RlZmluZSBBTUM2ODIxX0NPTkYxX0ZBTl9G
QVVMVF9FTiAweDEwCisjZGVmaW5lIEFNQzY4MjFfQ09ORjFfRkRSQzAgMHgyMAorI2RlZmluZSBB
TUM2ODIxX0NPTkYxX0ZEUkMxIDB4NDAKKyNkZWZpbmUgQU1DNjgyMV9DT05GMV9USEVSTU9WSUUg
MHg4MAorCisjZGVmaW5lIEFNQzY4MjFfQ09ORjJfUFdNX0VOIDB4MDEKKyNkZWZpbmUgQU1DNjgy
MV9DT05GMl9UQUNIX01PREUgMHgwMgorI2RlZmluZSBBTUM2ODIxX0NPTkYyX1RBQ0hfRU4gMHgw
NAorI2RlZmluZSBBTUM2ODIxX0NPTkYyX1JURklFIDB4MDgKKyNkZWZpbmUgQU1DNjgyMV9DT05G
Ml9MVE9JRSAweDEwCisjZGVmaW5lIEFNQzY4MjFfQ09ORjJfUlRPSUUgMHgyMAorI2RlZmluZSBB
TUM2ODIxX0NPTkYyX1BTVklFIDB4NDAKKyNkZWZpbmUgQU1DNjgyMV9DT05GMl9SU1QgMHg4MAor
CisjZGVmaW5lIEFNQzY4MjFfQ09ORjNfVEhFUk1fRkFOX0VOIDB4ODAKKyNkZWZpbmUgQU1DNjgy
MV9DT05GM19SRVZfTUFTSyAweDBGCisKKyNkZWZpbmUgQU1DNjgyMV9DT05GNF9PVlJFTiAweDEw
CisjZGVmaW5lIEFNQzY4MjFfQ09ORjRfVEFDSF9GQVNUIDB4MjAKKyNkZWZpbmUgQU1DNjgyMV9D
T05GNF9QU1BSIDB4NDAKKyNkZWZpbmUgQU1DNjgyMV9DT05GNF9NT0RFIDB4ODAKKworI2RlZmlu
ZSBBTUM2ODIxX1NUQVQxX1JQTV9BTEFSTSAweDAxCisjZGVmaW5lIEFNQzY4MjFfU1RBVDFfRkFO
UyAweDAyCisjZGVmaW5lIEFNQzY4MjFfU1RBVDFfUlRIIDB4MDQKKyNkZWZpbmUgQU1DNjgyMV9T
VEFUMV9SVEwgMHgwOAorI2RlZmluZSBBTUM2ODIxX1NUQVQxX1JfVEhFUk0gMHgxMAorI2RlZmlu
ZSBBTUM2ODIxX1NUQVQxX1JURiAweDIwCisjZGVmaW5lIEFNQzY4MjFfU1RBVDFfTFRIIDB4NDAK
KyNkZWZpbmUgQU1DNjgyMV9TVEFUMV9MVEwgMHg4MAorCisjZGVmaW5lIEFNQzY4MjFfU1RBVDJf
UlRDIDB4MDgKKyNkZWZpbmUgQU1DNjgyMV9TVEFUMl9MVEMgMHgxMAorI2RlZmluZSBBTUM2ODIx
X1NUQVQyX0xQU1YgMHgyMAorI2RlZmluZSBBTUM2ODIxX1NUQVQyX0xfVEhFUk0gMHg0MAorI2Rl
ZmluZSBBTUM2ODIxX1NUQVQyX1RIRVJNX0lOIDB4ODAKKworCitzdGF0aWMgaW50IGFtYzY4MjFf
cHJvYmUoCisJCXN0cnVjdCBpMmNfY2xpZW50ICpjbGllbnQsCisJCWNvbnN0IHN0cnVjdCBpMmNf
ZGV2aWNlX2lkICppZCk7CitzdGF0aWMgaW50IGFtYzY4MjFfZGV0ZWN0KAorCQlzdHJ1Y3QgaTJj
X2NsaWVudCAqY2xpZW50LAorCQlpbnQga2luZCwKKwkJc3RydWN0IGkyY19ib2FyZF9pbmZvICpp
bmZvKTsKK3N0YXRpYyBpbnQgYW1jNjgyMV9pbml0X2NsaWVudChzdHJ1Y3QgaTJjX2NsaWVudCAq
Y2xpZW50KTsKK3N0YXRpYyBpbnQgYW1jNjgyMV9yZW1vdmUoc3RydWN0IGkyY19jbGllbnQgKmNs
aWVudCk7CitzdGF0aWMgc3RydWN0IGFtYzY4MjFfZGF0YSAqYW1jNjgyMV91cGRhdGVfZGV2aWNl
KHN0cnVjdCBkZXZpY2UgKmRldik7CisKKy8qCisgKiBEcml2ZXIgZGF0YSAoY29tbW9uIHRvIGFs
bCBjbGllbnRzKQorICovCisKK3N0YXRpYyBjb25zdCBzdHJ1Y3QgaTJjX2RldmljZV9pZCBhbWM2
ODIxX2lkW10gPSB7CisJeyAiYW1jNjgyMSIsIGFtYzY4MjEgfSwKKwl7IH0KK307CisKK01PRFVM
RV9ERVZJQ0VfVEFCTEUoaTJjLCBhbWM2ODIxX2lkKTsKKworc3RhdGljIHN0cnVjdCBpMmNfZHJp
dmVyIGFtYzY4MjFfZHJpdmVyID0geworCS5jbGFzcyA9IEkyQ19DTEFTU19IV01PTiwKKwkuZHJp
dmVyID0geworCQkubmFtZQk9ICJhbWM2ODIxIiwKKwl9LAorCS5wcm9iZSA9IGFtYzY4MjFfcHJv
YmUsCisJLnJlbW92ZSA9IGFtYzY4MjFfcmVtb3ZlLAorCS5pZF90YWJsZSA9IGFtYzY4MjFfaWQs
CisJLmRldGVjdCA9IGFtYzY4MjFfZGV0ZWN0LAorCS5hZGRyZXNzX2RhdGEgPSAmYWRkcl9kYXRh
LAorfTsKKworCisvKgorICogQ2xpZW50IGRhdGEgKGVhY2ggY2xpZW50IGdldHMgaXRzIG93bikK
KyAgKi8KKworc3RydWN0IGFtYzY4MjFfZGF0YSB7CisJc3RydWN0IGRldmljZSAqaHdtb25fZGV2
OworCXN0cnVjdCBtdXRleCB1cGRhdGVfbG9jazsKKwljaGFyIHZhbGlkOyAvKiB6ZXJvIHVudGls
IGZvbGxvd2luZyBmaWVsZHMgYXJlIHZhbGlkICovCisJdW5zaWduZWQgbG9uZyBsYXN0X3VwZGF0
ZWQ7IC8qIGluIGppZmZpZXMgKi8KKworCS8qIHJlZ2lzdGVyIHZhbHVlcyAqLworCWludCB0ZW1w
MV9pbnB1dDsKKwlpbnQgdGVtcDFfbWluOworCWludCB0ZW1wMV9tYXg7CisJaW50IHRlbXAxX2Ny
aXQ7CisKKwlpbnQgdGVtcDJfaW5wdXQ7CisJaW50IHRlbXAyX21pbjsKKwlpbnQgdGVtcDJfbWF4
OworCWludCB0ZW1wMl9jcml0OworCisJdTE2IGZhbjFfaW5wdXQ7CisJdTE2IGZhbjFfbWluOwor
CXUxNiBmYW4xX21heDsKKwl1OCBmYW4xX2RpdjsKKworCXU4IHB3bTE7CisJdTggdGVtcDFfYXV0
b19wb2ludF90ZW1wWzNdOworCXU4IHRlbXAyX2F1dG9fcG9pbnRfdGVtcFszXTsKKwl1OCBwd20x
X2F1dG9fcG9pbnRfcHdtWzNdOworCXU4IHB3bTFfZW5hYmxlOworCXU4IHB3bTFfYXV0b19jaGFu
bmVsc190ZW1wOworCisJdTggc3RhdDE7CisJdTggc3RhdDI7Cit9OworCisKKyNkZWZpbmUgZ2V0
X3RlbXBfcGFyYShuYW1lKSBcCitzdGF0aWMgc3NpemVfdCBnZXRfIyNuYW1lKFwKKwkJc3RydWN0
IGRldmljZSAqZGV2LFwKKwkJc3RydWN0IGRldmljZV9hdHRyaWJ1dGUgKmRldmF0dHIsXAorCQlj
aGFyICpidWYpXAore1wKKwlzdHJ1Y3QgYW1jNjgyMV9kYXRhICpkYXRhID0gYW1jNjgyMV91cGRh
dGVfZGV2aWNlKGRldik7XAorCXJldHVybiBzcHJpbnRmKGJ1ZiwgIiVkXG4iLCBkYXRhLT5uYW1l
ICogMTAwMCk7XAorfQorCitnZXRfdGVtcF9wYXJhKHRlbXAxX2lucHV0KTsKK2dldF90ZW1wX3Bh
cmEodGVtcDFfbWluKTsKK2dldF90ZW1wX3BhcmEodGVtcDFfbWF4KTsKK2dldF90ZW1wX3BhcmEo
dGVtcDJfaW5wdXQpOworZ2V0X3RlbXBfcGFyYSh0ZW1wMl9taW4pOworZ2V0X3RlbXBfcGFyYSh0
ZW1wMl9tYXgpOworZ2V0X3RlbXBfcGFyYSh0ZW1wMV9jcml0KTsKK2dldF90ZW1wX3BhcmEodGVt
cDJfY3JpdCk7CisKKyNkZWZpbmUgc2V0X3RlbXBfcGFyYShuYW1lLCByZWcpXAorc3RhdGljIHNz
aXplX3Qgc2V0XyMjbmFtZShcCisJCXN0cnVjdCBkZXZpY2UgKmRldixcCisJCXN0cnVjdCBkZXZp
Y2VfYXR0cmlidXRlICphdHRyLFwKKwkJY29uc3QgY2hhciAqYnVmLFwKKwkJc2l6ZV90IGNvdW50
KVwKK3sgXAorCXN0cnVjdCBpMmNfY2xpZW50ICpjbGllbnQgPSB0b19pMmNfY2xpZW50KGRldik7
IFwKKwlzdHJ1Y3QgYW1jNjgyMV9kYXRhICpkYXRhID0gaTJjX2dldF9jbGllbnRkYXRhKGNsaWVu
dCk7IFwKKwlpbnQgdmFsID0gc2ltcGxlX3N0cnRvbChidWYsIE5VTEwsIDEwKTsgXAorCVwKKwlt
dXRleF9sb2NrKCZkYXRhLT51cGRhdGVfbG9jayk7IFwKKwlkYXRhLT5uYW1lID0gU0VOU09SU19M
SU1JVCh2YWwgLyAxMDAwLCAtMTI4LCAxMjcpOyBcCisJaWYgKGkyY19zbWJ1c193cml0ZV9ieXRl
X2RhdGEoY2xpZW50LCByZWcsIGRhdGEtPm5hbWUpKSB7XAorCQlkZXZfZXJyKCZjbGllbnQtPmRl
diwgIlJlZ2lzdGVyIHdyaXRlIGVycm9yLCBhYm9ydGluZy5cbiIpO1wKKwkJY291bnQgPSAtRUlP
O1wKKwl9IFwKKwltdXRleF91bmxvY2soJmRhdGEtPnVwZGF0ZV9sb2NrKTsgXAorCXJldHVybiBj
b3VudDsgXAorfQorCitzZXRfdGVtcF9wYXJhKHRlbXAxX21pbiwgQU1DNjgyMV9SRUdfTFRFTVBf
TElNSVRfTUlOKTsKK3NldF90ZW1wX3BhcmEodGVtcDFfbWF4LCBBTUM2ODIxX1JFR19MVEVNUF9M
SU1JVF9NQVgpOworc2V0X3RlbXBfcGFyYSh0ZW1wMl9taW4sIEFNQzY4MjFfUkVHX1JURU1QX0xJ
TUlUX01JTik7CitzZXRfdGVtcF9wYXJhKHRlbXAyX21heCwgQU1DNjgyMV9SRUdfUlRFTVBfTElN
SVRfTUFYKTsKK3NldF90ZW1wX3BhcmEodGVtcDFfY3JpdCwgQU1DNjgyMV9SRUdfTFRFTVBfQ1JJ
VCk7CitzZXRfdGVtcF9wYXJhKHRlbXAyX2NyaXQsIEFNQzY4MjFfUkVHX1JURU1QX0NSSVQpOwor
CisjZGVmaW5lIGdldF90ZW1wX2FsYXJtKG5hbWUsIHJlZywgbWFzaylcCitzdGF0aWMgc3NpemVf
dCBnZXRfIyNuYW1lKFwKKwlzdHJ1Y3QgZGV2aWNlICpkZXYsIFwKKwlzdHJ1Y3QgZGV2aWNlX2F0
dHJpYnV0ZSAqZGV2YXR0cixcCisJY2hhciAqYnVmKVwKK3tcCisJc3RydWN0IGFtYzY4MjFfZGF0
YSAqZGF0YSA9IGFtYzY4MjFfdXBkYXRlX2RldmljZShkZXYpO1wKKwlpZiAoZGF0YS0+cmVnICYg
IG1hc2spXAorCQlyZXR1cm4gc3ByaW50ZihidWYsICIxIik7XAorCWVsc2UJXAorCQlyZXR1cm4g
c3ByaW50ZihidWYsICIwIik7XAorfSBcCisKK2dldF90ZW1wX2FsYXJtKHRlbXAxX21pbl9hbGFy
bSwgc3RhdDEsCUFNQzY4MjFfU1RBVDFfTFRMKQorZ2V0X3RlbXBfYWxhcm0odGVtcDFfbWF4X2Fs
YXJtLCBzdGF0MSwgQU1DNjgyMV9TVEFUMV9MVEgpCitnZXRfdGVtcF9hbGFybSh0ZW1wMl9taW5f
YWxhcm0sIHN0YXQxLCBBTUM2ODIxX1NUQVQxX1JUTCkKK2dldF90ZW1wX2FsYXJtKHRlbXAyX21h
eF9hbGFybSwgc3RhdDEsIEFNQzY4MjFfU1RBVDFfUlRIKQorZ2V0X3RlbXBfYWxhcm0odGVtcDFf
Y3JpdF9hbGFybSwgc3RhdDIsIEFNQzY4MjFfU1RBVDJfTFRDKQorZ2V0X3RlbXBfYWxhcm0odGVt
cDJfY3JpdF9hbGFybSwgc3RhdDIsIEFNQzY4MjFfU1RBVDJfUlRDKQorCisKK3N0YXRpYyBzc2l6
ZV90IGdldF90ZW1wMl9mYXVsdCgKKwkJc3RydWN0IGRldmljZSAqZGV2LAorCQlzdHJ1Y3QgZGV2
aWNlX2F0dHJpYnV0ZSAqZGV2YXR0ciwKKwkJY2hhciAqYnVmKQoreworCXN0cnVjdCBhbWM2ODIx
X2RhdGEgKmRhdGEgPSBhbWM2ODIxX3VwZGF0ZV9kZXZpY2UoZGV2KTsKKwlpZiAoZGF0YS0+c3Rh
dDEgJiBBTUM2ODIxX1NUQVQxX1JURikKKwkJcmV0dXJuIHNwcmludGYoYnVmLCAiMSIpOworCWVs
c2UKKwkJcmV0dXJuIHNwcmludGYoYnVmLCAiMCIpOworfQorCitzdGF0aWMgc3NpemVfdCBnZXRf
cHdtMSgKKwkJc3RydWN0IGRldmljZSAqZGV2LAorCQlzdHJ1Y3QgZGV2aWNlX2F0dHJpYnV0ZSAq
ZGV2YXR0ciwKKwkJY2hhciAqYnVmKQoreworCXN0cnVjdCBhbWM2ODIxX2RhdGEgKmRhdGEgPSBh
bWM2ODIxX3VwZGF0ZV9kZXZpY2UoZGV2KTsKKwlyZXR1cm4gc3ByaW50ZihidWYsICIlZFxuIiwg
ZGF0YS0+cHdtMSk7Cit9CisKK3N0YXRpYyBzc2l6ZV90IHNldF9wd20xKAorCQlzdHJ1Y3QgZGV2
aWNlICpkZXYsCisJCXN0cnVjdCBkZXZpY2VfYXR0cmlidXRlICpkZXZhdHRyLAorCQljb25zdCBj
aGFyICpidWYsCisJCXNpemVfdCBjb3VudCkKK3sKKwlzdHJ1Y3QgaTJjX2NsaWVudCAqY2xpZW50
ID0gdG9faTJjX2NsaWVudChkZXYpOworCXN0cnVjdCBhbWM2ODIxX2RhdGEgKmRhdGEgPSBpMmNf
Z2V0X2NsaWVudGRhdGEoY2xpZW50KTsKKwlpbnQgdmFsID0gc2ltcGxlX3N0cnRvbChidWYsIE5V
TEwsIDEwKTsKKworCW11dGV4X2xvY2soJmRhdGEtPnVwZGF0ZV9sb2NrKTsKKwlkYXRhLT5wd20x
ID0gU0VOU09SU19MSU1JVCh2YWwgLCAwLCAyNTUpOworCWkyY19zbWJ1c193cml0ZV9ieXRlX2Rh
dGEoY2xpZW50LCBBTUM2ODIxX1JFR19EQ1ksIGRhdGEtPnB3bTEpOworCW11dGV4X3VubG9jaygm
ZGF0YS0+dXBkYXRlX2xvY2spOworCXJldHVybiBjb3VudDsKK30KKworc3RhdGljIHNzaXplX3Qg
Z2V0X3B3bTFfZW5hYmxlKAorCQlzdHJ1Y3QgZGV2aWNlICpkZXYsCisJCXN0cnVjdCBkZXZpY2Vf
YXR0cmlidXRlICpkZXZhdHRyLAorCQljaGFyICpidWYpCit7CisJc3RydWN0IGFtYzY4MjFfZGF0
YSAqZGF0YSA9IGFtYzY4MjFfdXBkYXRlX2RldmljZShkZXYpOworCXJldHVybiBzcHJpbnRmKGJ1
ZiwgIiVkXG4iLCBkYXRhLT5wd20xX2VuYWJsZSk7Cit9CisKK3N0YXRpYyBzc2l6ZV90IHNldF9w
d20xX2VuYWJsZSgKKwkJc3RydWN0IGRldmljZSAqZGV2LAorCQlzdHJ1Y3QgZGV2aWNlX2F0dHJp
YnV0ZSAqYXR0ciwKKwkJY29uc3QgY2hhciAqYnVmLAorCQlzaXplX3QgY291bnQpCit7CisJc3Ry
dWN0IGkyY19jbGllbnQgKmNsaWVudCA9IHRvX2kyY19jbGllbnQoZGV2KTsKKwlzdHJ1Y3QgYW1j
NjgyMV9kYXRhICpkYXRhID0gaTJjX2dldF9jbGllbnRkYXRhKGNsaWVudCk7CisJaW50IHZhbCA9
IHNpbXBsZV9zdHJ0b2woYnVmLCBOVUxMLCAxMCk7CisKKwlpbnQgY29uZmlnID0gaTJjX3NtYnVz
X3JlYWRfYnl0ZV9kYXRhKGNsaWVudCwgQU1DNjgyMV9SRUdfQ09ORjEpOworCWlmIChjb25maWcg
PCAwKSB7CisJCQlkZXZfZXJyKCZjbGllbnQtPmRldiwKKwkJCSJFcnJvciByZWFkaW5nIGNvbmZp
Z3VyYXRpb24gcmVnaXN0ZXIsIGFib3J0aW5nLlxuIik7CisJCQlyZXR1cm4gLUVJTzsKKwl9CisK
Kwlzd2l0Y2ggKHZhbCkgeworCWNhc2UgMToKKwkJY29uZmlnICY9IH5BTUM2ODIxX0NPTkYxX0ZE
UkMwOworCQljb25maWcgJj0gfkFNQzY4MjFfQ09ORjFfRkRSQzE7CisJCWJyZWFrOworCWNhc2Ug
MjoKKwkJY29uZmlnICY9IH5BTUM2ODIxX0NPTkYxX0ZEUkMwOworCQljb25maWcgfD0gQU1DNjgy
MV9DT05GMV9GRFJDMTsKKwkJYnJlYWs7CisJY2FzZSAzOgorCQljb25maWcgfD0gQU1DNjgyMV9D
T05GMV9GRFJDMDsKKwkJY29uZmlnIHw9IEFNQzY4MjFfQ09ORjFfRkRSQzE7CisJCWJyZWFrOwor
CWRlZmF1bHQ6CisJCXJldHVybiAtRUlOVkFMOworCX0KKwltdXRleF9sb2NrKCZkYXRhLT51cGRh
dGVfbG9jayk7CisJaWYgKGkyY19zbWJ1c193cml0ZV9ieXRlX2RhdGEoY2xpZW50LCBBTUM2ODIx
X1JFR19DT05GMSwgY29uZmlnKSkgeworCQkJZGV2X2VycigmY2xpZW50LT5kZXYsCisJCQkiQ29u
ZmlndXJhdGlvbiByZWdpc3RlciB3cml0ZSBlcnJvciwgYWJvcnRpbmcuXG4iKTsKKwkJCWNvdW50
ID0gLUVJTzsKKwl9CisJbXV0ZXhfdW5sb2NrKCZkYXRhLT51cGRhdGVfbG9jayk7CisJcmV0dXJu
IGNvdW50OworfQorCisKK3N0YXRpYyBzc2l6ZV90IGdldF9wd20xX2F1dG9fY2hhbm5lbHNfdGVt
cCgKKwkJc3RydWN0IGRldmljZSAqZGV2LAorCQlzdHJ1Y3QgZGV2aWNlX2F0dHJpYnV0ZSAqZGV2
YXR0ciwKKwkJY2hhciAqYnVmKQoreworCXN0cnVjdCBhbWM2ODIxX2RhdGEgKmRhdGEgPSBhbWM2
ODIxX3VwZGF0ZV9kZXZpY2UoZGV2KTsKKwlyZXR1cm4gc3ByaW50ZihidWYsICIlZFxuIiwgZGF0
YS0+cHdtMV9hdXRvX2NoYW5uZWxzX3RlbXApOworfQorCisKKyNkZWZpbmUgZ2V0X2F1dG9fcG9p
bnQobmFtZSlcCitzdGF0aWMgc3NpemVfdCBnZXRfIyNuYW1lKFwKKwkJc3RydWN0IGRldmljZSAq
ZGV2LFwKKwkJc3RydWN0IGRldmljZV9hdHRyaWJ1dGUgKmRldmF0dHIsXAorCQljaGFyICpidWYp
XAore1wKKwlpbnQgbnIgPSB0b19zZW5zb3JfZGV2X2F0dHIoZGV2YXR0ciktPmluZGV4O1wKKwlz
dHJ1Y3QgYW1jNjgyMV9kYXRhICpkYXRhID0gYW1jNjgyMV91cGRhdGVfZGV2aWNlKGRldik7XAor
CXJldHVybiBzcHJpbnRmKGJ1ZiwgIiVkXG4iLCBkYXRhLT5uYW1lW25yXSAqIDEwMDApO1wKK30K
KworZ2V0X2F1dG9fcG9pbnQodGVtcDFfYXV0b19wb2ludF90ZW1wKTsKK2dldF9hdXRvX3BvaW50
KHRlbXAyX2F1dG9fcG9pbnRfdGVtcCk7CisKK3N0YXRpYyBzc2l6ZV90IGdldF9wd20xX2F1dG9f
cG9pbnRfcHdtKAorCQlzdHJ1Y3QgZGV2aWNlICpkZXYsCisJCXN0cnVjdCBkZXZpY2VfYXR0cmli
dXRlICpkZXZhdHRyLAorCQljaGFyICpidWYpCit7CisJaW50IG5yID0gdG9fc2Vuc29yX2Rldl9h
dHRyKGRldmF0dHIpLT5pbmRleDsKKwlzdHJ1Y3QgYW1jNjgyMV9kYXRhICpkYXRhID0gYW1jNjgy
MV91cGRhdGVfZGV2aWNlKGRldik7CisJcmV0dXJuIHNwcmludGYoYnVmLCAiJWRcbiIsIGRhdGEt
PnB3bTFfYXV0b19wb2ludF9wd21bbnJdKTsKK30KKworCisjZGVmaW5lIHNldF90ZW1wX2F1dG9f
cG9pbnRfdGVtcChuYW1lLCByZWcpXAorc3RhdGljIHNzaXplX3Qgc2V0XyMjbmFtZShcCisJCXN0
cnVjdCBkZXZpY2UgKmRldixcCisJCXN0cnVjdCBkZXZpY2VfYXR0cmlidXRlICphdHRyLFwKKwkJ
Y29uc3QgY2hhciAqYnVmLFwKKwkJc2l6ZV90IGNvdW50KVwKK3sgXAorCXN0cnVjdCBpMmNfY2xp
ZW50ICpjbGllbnQgPSB0b19pMmNfY2xpZW50KGRldik7IFwKKwlzdHJ1Y3QgYW1jNjgyMV9kYXRh
ICpkYXRhID0gYW1jNjgyMV91cGRhdGVfZGV2aWNlKGRldik7XAorCWludCBuciA9IHRvX3NlbnNv
cl9kZXZfYXR0cihhdHRyKS0+aW5kZXg7XAorCWludCB2YWwgPSBzaW1wbGVfc3RydG9sKGJ1Ziwg
TlVMTCwgMTApOyBcCisJdTggdG1wO1wKKwlpbnQgZHQ7XAorCWludCBkcHdtO1wKKwlcCisJbXV0
ZXhfbG9jaygmZGF0YS0+dXBkYXRlX2xvY2spOyBcCisJc3dpdGNoIChucikge1wKKwljYXNlIDA6
XAorCQlkYXRhLT5uYW1lWzBdID0gU0VOU09SU19MSU1JVCh2YWwgLyAxMDAwLCAwLFwKKwkJCQlk
YXRhLT50ZW1wMV9hdXRvX3BvaW50X3RlbXBbMV0pO1wKKwkJZGF0YS0+bmFtZVswXSA9IFNFTlNP
UlNfTElNSVQoZGF0YS0+bmFtZVswXSwgMCxcCisJCQkJZGF0YS0+dGVtcDJfYXV0b19wb2ludF90
ZW1wWzFdKTtcCisJCWRhdGEtPm5hbWVbMF0gPSBTRU5TT1JTX0xJTUlUKGRhdGEtPm5hbWVbMF0s
IDAsIDYzKTsgXAorCQlkYXRhLT52YWxpZCA9IDA7XAorCQlpZiAoaTJjX3NtYnVzX3dyaXRlX2J5
dGVfZGF0YShcCisJCQkJCWNsaWVudCxcCisJCQkJCUFNQzY4MjFfUkVHX1BTVl9URU1QLFwKKwkJ
CQkJZGF0YS0+bmFtZVswXSkpIHtcCisJCQkJZGV2X2VycigmY2xpZW50LT5kZXYsXAorCQkJCQki
UmVnaXN0ZXIgd3JpdGUgZXJyb3IsIGFib3J0aW5nLlxuIik7XAorCQkJCWNvdW50ID0gLUVJTztc
CisJCX0gXAorCQlnb3RvIEVYSVQ7XAorCQlicmVhaztcCisJY2FzZSAxOlwKKwkJZGF0YS0+bmFt
ZVsxXSA9IFNFTlNPUlNfTElNSVQoXAorCQkJCQl2YWwgLyAxMDAwLFwKKwkJCQkJKGRhdGEtPm5h
bWVbMF0gJiAweDdDKSArIDQsXAorCQkJCQkxMjQpO1wKKwkJZGF0YS0+bmFtZVsxXSAmPSAweDdD
O1wKKwkJZGF0YS0+bmFtZVsyXSA9IFNFTlNPUlNfTElNSVQoXAorCQkJCQlkYXRhLT5uYW1lWzJd
LCBkYXRhLT5uYW1lWzFdICsgMSxcCisJCQkJCTI1NSk7XAorCQlicmVhaztcCisJY2FzZSAyOlwK
KwkJZGF0YS0+bmFtZVsyXSA9IFNFTlNPUlNfTElNSVQoXAorCQkJCQl2YWwgLyAxMDAwLFwKKwkJ
CQkJZGF0YS0+bmFtZVsxXSsxLFwKKwkJCQkJMjU1KTsgXAorCQlicmVhaztcCisJfSBcCisJZHQg
PSBkYXRhLT5uYW1lWzJdLWRhdGEtPm5hbWVbMV07XAorCWRwd20gPSBkYXRhLT5wd20xX2F1dG9f
cG9pbnRfcHdtWzJdIC0gZGF0YS0+cHdtMV9hdXRvX3BvaW50X3B3bVsxXTtcCisJZm9yICh0bXAg
PSA0OyB0bXAgPiAwOyB0bXAtLSkge1wKKwkJaWYgKGR0ICogKDB4MjAgPj4gdG1wKSA+PSBkcHdt
KVwKKwkJCWJyZWFrO1wKKwl9IFwKKwl0bXAgfD0gKGRhdGEtPm5hbWVbMV0gJiAweDdDKSA8PCAx
O1wKKwlpZiAoaTJjX3NtYnVzX3dyaXRlX2J5dGVfZGF0YShjbGllbnQsIHJlZywgdG1wKSkge1wK
KwkJZGV2X2VycigmY2xpZW50LT5kZXYsICJSZWdpc3RlciB3cml0ZSBlcnJvciwgYWJvcnRpbmcu
XG4iKTtcCisJCWNvdW50ID0gLUVJTztcCisJfSBcCisJZGF0YS0+dmFsaWQgPSAwO1wKK0VYSVQ6
XAorCW11dGV4X3VubG9jaygmZGF0YS0+dXBkYXRlX2xvY2spOyBcCisJcmV0dXJuIGNvdW50OyBc
Cit9CisKK3NldF90ZW1wX2F1dG9fcG9pbnRfdGVtcCh0ZW1wMV9hdXRvX3BvaW50X3RlbXAsIEFN
QzY4MjFfUkVHX0xURU1QX0ZBTl9DVFJMKTsKK3NldF90ZW1wX2F1dG9fcG9pbnRfdGVtcCh0ZW1w
Ml9hdXRvX3BvaW50X3RlbXAsIEFNQzY4MjFfUkVHX1JURU1QX0ZBTl9DVFJMKTsKKworc3RhdGlj
IHNzaXplX3Qgc2V0X3B3bTFfYXV0b19wb2ludF9wd20oCisJCXN0cnVjdCBkZXZpY2UgKmRldiwK
KwkJc3RydWN0IGRldmljZV9hdHRyaWJ1dGUgKmF0dHIsCisJCWNvbnN0IGNoYXIgKmJ1ZiwKKwkJ
c2l6ZV90IGNvdW50KQoreworCXN0cnVjdCBpMmNfY2xpZW50ICpjbGllbnQgPSB0b19pMmNfY2xp
ZW50KGRldik7CisJc3RydWN0IGFtYzY4MjFfZGF0YSAqZGF0YSA9IGkyY19nZXRfY2xpZW50ZGF0
YShjbGllbnQpOworCWludCB2YWwgPSBzaW1wbGVfc3RydG9sKGJ1ZiwgTlVMTCwgMTApOworCXU4
IHRtcDsKKwlpbnQgZHQ7CisJaW50IGRwd207CisKKwltdXRleF9sb2NrKCZkYXRhLT51cGRhdGVf
bG9jayk7CisJZGF0YS0+cHdtMV9hdXRvX3BvaW50X3B3bVsxXSA9IFNFTlNPUlNfTElNSVQodmFs
LCAwLCAyNTQpOworCWlmIChpMmNfc21idXNfd3JpdGVfYnl0ZV9kYXRhKGNsaWVudCwgQU1DNjgy
MV9SRUdfRENZX0xPV19URU1QLAorCQkJZGF0YS0+cHdtMV9hdXRvX3BvaW50X3B3bVsxXSkpIHsK
KwkJZGV2X2VycigmY2xpZW50LT5kZXYsICJSZWdpc3RlciB3cml0ZSBlcnJvciwgYWJvcnRpbmcu
XG4iKTsKKwkJY291bnQgPSAtRUlPOworCX0KKworCWRwd20gPSBkYXRhLT5wd20xX2F1dG9fcG9p
bnRfcHdtWzJdIC0gZGF0YS0+cHdtMV9hdXRvX3BvaW50X3B3bVsxXTsKKwlkdCA9IGRhdGEtPnRl
bXAxX2F1dG9fcG9pbnRfdGVtcFsyXS1kYXRhLT50ZW1wMV9hdXRvX3BvaW50X3RlbXBbMV07CisJ
Zm9yICh0bXAgPSA0OyB0bXAgPiAwOyB0bXAtLSkgeworCQlpZiAoZHQgKiAoMHgyMCA+PiB0bXAp
ID49IGRwd20pCisJCQlicmVhazsKKwl9CisJdG1wIHw9IChkYXRhLT50ZW1wMV9hdXRvX3BvaW50
X3RlbXBbMV0gJiAweDdDKSA8PCAxOworCWlmIChpMmNfc21idXNfd3JpdGVfYnl0ZV9kYXRhKGNs
aWVudCwKKwkJCUFNQzY4MjFfUkVHX0xURU1QX0ZBTl9DVFJMLCB0bXApKSB7CisJCWRldl9lcnIo
JmNsaWVudC0+ZGV2LCAiUmVnaXN0ZXIgd3JpdGUgZXJyb3IsIGFib3J0aW5nLlxuIik7CisJCWNv
dW50ID0gLUVJTzsKKwl9CisKKwlkdCA9IGRhdGEtPnRlbXAyX2F1dG9fcG9pbnRfdGVtcFsyXS1k
YXRhLT50ZW1wMl9hdXRvX3BvaW50X3RlbXBbMV07CisJZm9yICh0bXAgPSA0OyB0bXAgPiAwOyB0
bXAtLSkgeworCQlpZiAoZHQgKiAoMHgyMCA+PiB0bXApID49IGRwd20pCisJCQlicmVhazsKKwl9
CisJdG1wIHw9IChkYXRhLT50ZW1wMl9hdXRvX3BvaW50X3RlbXBbMV0gJiAweDdDKSA8PCAxOwor
CWlmIChpMmNfc21idXNfd3JpdGVfYnl0ZV9kYXRhKGNsaWVudCwKKwkJCUFNQzY4MjFfUkVHX1JU
RU1QX0ZBTl9DVFJMLCB0bXApKSB7CisJCWRldl9lcnIoJmNsaWVudC0+ZGV2LCAiUmVnaXN0ZXIg
d3JpdGUgZXJyb3IsIGFib3J0aW5nLlxuIik7CisJCWNvdW50ID0gLUVJTzsKKwl9CisJZGF0YS0+
dmFsaWQgPSAwOworCW11dGV4X3VubG9jaygmZGF0YS0+dXBkYXRlX2xvY2spOworCXJldHVybiBj
b3VudDsKK30KKworCisjZGVmaW5lIGdldF9mYW5fcGFyYShuYW1lKSBzdGF0aWMgc3NpemVfdCBn
ZXRfIyNuYW1lKFwKKwkJc3RydWN0IGRldmljZSAqZGV2LFwKKwkJc3RydWN0IGRldmljZV9hdHRy
aWJ1dGUgKmRldmF0dHIsXAorCQljaGFyICpidWYpXAoreyBcCisJc3RydWN0IGFtYzY4MjFfZGF0
YSAqZGF0YSA9IGFtYzY4MjFfdXBkYXRlX2RldmljZShkZXYpOyBcCisJaWYgKDAgPT0gZGF0YS0+
bmFtZSlcCisJCXJldHVybiBzcHJpbnRmKGJ1ZiwgIjAiKTtcCisJcmV0dXJuIHNwcmludGYoYnVm
LCAiJWRcbiIsIChpbnQpKDYwMDAwMDAgLyBkYXRhLT5uYW1lKSk7IFwKK30KKworZ2V0X2Zhbl9w
YXJhKGZhbjFfaW5wdXQpOworZ2V0X2Zhbl9wYXJhKGZhbjFfbWluKTsKK2dldF9mYW5fcGFyYShm
YW4xX21heCk7CisKK3N0YXRpYyBzc2l6ZV90IGdldF9mYW4xX2ZhdWx0KAorCQlzdHJ1Y3QgZGV2
aWNlICpkZXYsCisJCXN0cnVjdCBkZXZpY2VfYXR0cmlidXRlICpkZXZhdHRyLAorCQljaGFyICpi
dWYpCit7CisJc3RydWN0IGFtYzY4MjFfZGF0YSAqZGF0YSA9IGFtYzY4MjFfdXBkYXRlX2Rldmlj
ZShkZXYpOworCWlmIChkYXRhLT5zdGF0MSAmIEFNQzY4MjFfU1RBVDFfRkFOUykKKwkJcmV0dXJu
IHNwcmludGYoYnVmLCAiMSIpOworCWVsc2UKKwkJcmV0dXJuIHNwcmludGYoYnVmLCAiMCIpOwor
fQorCisKKyNkZWZpbmUgc2V0X2Zhbl9wYXJhKG5hbWUsIHJlZykgXAorc3RhdGljIHNzaXplX3Qg
c2V0XyMjbmFtZShcCisJCXN0cnVjdCBkZXZpY2UgKmRldixcCisJCXN0cnVjdCBkZXZpY2VfYXR0
cmlidXRlICphdHRyLFwKKwkJY29uc3QgY2hhciAqYnVmLCBzaXplX3QgY291bnQpXAoreyBcCisJ
c3RydWN0IGkyY19jbGllbnQgKmNsaWVudCA9IHRvX2kyY19jbGllbnQoZGV2KTsgXAorCXN0cnVj
dCBhbWM2ODIxX2RhdGEgKmRhdGEgPSBpMmNfZ2V0X2NsaWVudGRhdGEoY2xpZW50KTsgXAorCWlu
dCB2YWwgPSBzaW1wbGVfc3RydG9sKGJ1ZiwgTlVMTCwgMTApOyBcCisJdmFsID0gMSA+IHZhbCA/
IDB4RkZGRiA6IDYwMDAwMDAvdmFsOyBcCitcCisJbXV0ZXhfbG9jaygmZGF0YS0+dXBkYXRlX2xv
Y2spOyBcCisJZGF0YS0+bmFtZSA9ICh1MTYpIFNFTlNPUlNfTElNSVQodmFsLCAxLCAweEZGRkYp
OyBcCisJaWYgKGkyY19zbWJ1c193cml0ZV9ieXRlX2RhdGEoY2xpZW50LCByZWcsIGRhdGEtPm5h
bWUgJiAweEZGKSkgeyBcCisJCWRldl9lcnIoJmNsaWVudC0+ZGV2LCAiUmVnaXN0ZXIgd3JpdGUg
ZXJyb3IsIGFib3J0aW5nLlxuIik7XAorCQljb3VudCA9IC1FSU87XAorCX0gXAorCWlmIChpMmNf
c21idXNfd3JpdGVfYnl0ZV9kYXRhKGNsaWVudCwgcmVnKzEsIGRhdGEtPm5hbWUgPj4gOCkpIHsg
XAorCQlkZXZfZXJyKCZjbGllbnQtPmRldiwgIlJlZ2lzdGVyIHdyaXRlIGVycm9yLCBhYm9ydGlu
Zy5cbiIpO1wKKwkJY291bnQgPSAtRUlPO1wKKwl9IFwKKwltdXRleF91bmxvY2soJmRhdGEtPnVw
ZGF0ZV9sb2NrKTsgXAorCXJldHVybiBjb3VudDsgXAorfQorCisKK3NldF9mYW5fcGFyYShmYW4x
X21pbiwgQU1DNjgyMV9SRUdfVEFDSF9MTElNSVRMKTsKK3NldF9mYW5fcGFyYShmYW4xX21heCwg
QU1DNjgyMV9SRUdfVEFDSF9ITElNSVRMKTsKKworCitzdGF0aWMgc3NpemVfdCBnZXRfZmFuMV9k
aXYoCisJCXN0cnVjdCBkZXZpY2UgKmRldiwKKwkJc3RydWN0IGRldmljZV9hdHRyaWJ1dGUgKmRl
dmF0dHIsCisJCWNoYXIgKmJ1ZikKK3sKKwlzdHJ1Y3QgYW1jNjgyMV9kYXRhICpkYXRhID0gYW1j
NjgyMV91cGRhdGVfZGV2aWNlKGRldik7CisJcmV0dXJuIHNwcmludGYoYnVmLCAiJWRcbiIsIGRh
dGEtPmZhbjFfZGl2KTsKK30KKworc3RhdGljIHNzaXplX3Qgc2V0X2ZhbjFfZGl2KAorCQlzdHJ1
Y3QgZGV2aWNlICpkZXYsCisJCXN0cnVjdCBkZXZpY2VfYXR0cmlidXRlICphdHRyLAorCQljb25z
dCBjaGFyICpidWYsIHNpemVfdCBjb3VudCkKK3sKKwlzdHJ1Y3QgaTJjX2NsaWVudCAqY2xpZW50
ID0gdG9faTJjX2NsaWVudChkZXYpOworCXN0cnVjdCBhbWM2ODIxX2RhdGEgKmRhdGEgPSBpMmNf
Z2V0X2NsaWVudGRhdGEoY2xpZW50KTsKKwlpbnQgdmFsID0gc2ltcGxlX3N0cnRvbChidWYsIE5V
TEwsIDEwKTsKKwlpbnQgY29uZmlnID0gaTJjX3NtYnVzX3JlYWRfYnl0ZV9kYXRhKGNsaWVudCwg
QU1DNjgyMV9SRUdfQ09ORjQpOworCisJaWYgKGNvbmZpZyA8IDApIHsKKwkJZGV2X2VycigmY2xp
ZW50LT5kZXYsCisJCQkiRXJyb3IgcmVhZGluZyBjb25maWd1cmF0aW9uIHJlZ2lzdGVyLCBhYm9y
dGluZy5cbiIpOworCQlyZXR1cm4gLUVJTzsKKwl9CisJbXV0ZXhfbG9jaygmZGF0YS0+dXBkYXRl
X2xvY2spOworCXN3aXRjaCAodmFsKSB7CisJY2FzZSAyOgorCQljb25maWcgJj0gfkFNQzY4MjFf
Q09ORjRfUFNQUjsKKwkJZGF0YS0+ZmFuMV9kaXYgPSAyOworCQlicmVhazsKKwljYXNlIDQ6CisJ
CWNvbmZpZyB8PSBBTUM2ODIxX0NPTkY0X1BTUFI7CisJCWRhdGEtPmZhbjFfZGl2ID0gNDsKKwkJ
YnJlYWs7CisJZGVmYXVsdDoKKwkJbXV0ZXhfdW5sb2NrKCZkYXRhLT51cGRhdGVfbG9jayk7CisJ
CXJldHVybiAtRUlOVkFMOworCX0KKwlpZiAoaTJjX3NtYnVzX3dyaXRlX2J5dGVfZGF0YShjbGll
bnQsIEFNQzY4MjFfUkVHX0NPTkY0LCBjb25maWcpKSB7CisJCWRldl9lcnIoJmNsaWVudC0+ZGV2
LAorCQkJIkNvbmZpZ3VyYXRpb24gcmVnaXN0ZXIgd3JpdGUgZXJyb3IsIGFib3J0aW5nLlxuIik7
CisJCWNvdW50ID0gLUVJTzsKKwl9CisJbXV0ZXhfdW5sb2NrKCZkYXRhLT51cGRhdGVfbG9jayk7
CisJcmV0dXJuIGNvdW50OworfQorCisKKworc3RhdGljIFNFTlNPUl9ERVZJQ0VfQVRUUih0ZW1w
MV9pbnB1dCwgU19JUlVHTywgZ2V0X3RlbXAxX2lucHV0LCBOVUxMLCAwKTsKK3N0YXRpYyBTRU5T
T1JfREVWSUNFX0FUVFIodGVtcDFfbWluLCBTX0lSVUdPIHwgU19JV1VTUiwgZ2V0X3RlbXAxX21p
biwKKwlzZXRfdGVtcDFfbWluLCAwKTsKK3N0YXRpYyBTRU5TT1JfREVWSUNFX0FUVFIodGVtcDFf
bWF4LCBTX0lSVUdPIHwgU19JV1VTUiwgZ2V0X3RlbXAxX21heCwKKwlzZXRfdGVtcDFfbWF4LCAw
KTsKK3N0YXRpYyBTRU5TT1JfREVWSUNFX0FUVFIodGVtcDFfY3JpdCwgU19JUlVHTyB8IFNfSVdV
U1IsIGdldF90ZW1wMV9jcml0LAorCXNldF90ZW1wMV9jcml0LCAwKTsKK3N0YXRpYyBTRU5TT1Jf
REVWSUNFX0FUVFIodGVtcDFfbWluX2FsYXJtLCBTX0lSVUdPLAorCWdldF90ZW1wMV9taW5fYWxh
cm0sIE5VTEwsIDApOworc3RhdGljIFNFTlNPUl9ERVZJQ0VfQVRUUih0ZW1wMV9tYXhfYWxhcm0s
IFNfSVJVR08sCisJZ2V0X3RlbXAxX21heF9hbGFybSwgTlVMTCwgMCk7CitzdGF0aWMgU0VOU09S
X0RFVklDRV9BVFRSKHRlbXAxX2NyaXRfYWxhcm0sIFNfSVJVR08sCisJZ2V0X3RlbXAxX2NyaXRf
YWxhcm0sIE5VTEwsIDApOworc3RhdGljIFNFTlNPUl9ERVZJQ0VfQVRUUih0ZW1wMl9pbnB1dCwg
U19JUlVHTyB8IFNfSVdVU1IsCisJZ2V0X3RlbXAyX2lucHV0LCBOVUxMLCAwKTsKK3N0YXRpYyBT
RU5TT1JfREVWSUNFX0FUVFIodGVtcDJfbWluLCBTX0lSVUdPIHwgU19JV1VTUiwgZ2V0X3RlbXAy
X21pbiwKKwlzZXRfdGVtcDJfbWluLCAwKTsKK3N0YXRpYyBTRU5TT1JfREVWSUNFX0FUVFIodGVt
cDJfbWF4LCBTX0lSVUdPIHwgU19JV1VTUiwgZ2V0X3RlbXAyX21heCwKKwlzZXRfdGVtcDJfbWF4
LCAwKTsKK3N0YXRpYyBTRU5TT1JfREVWSUNFX0FUVFIodGVtcDJfY3JpdCwgU19JUlVHTyB8IFNf
SVdVU1IsIGdldF90ZW1wMl9jcml0LAorCXNldF90ZW1wMl9jcml0LCAwKTsKK3N0YXRpYyBTRU5T
T1JfREVWSUNFX0FUVFIodGVtcDJfZmF1bHQsIFNfSVJVR08sCisJZ2V0X3RlbXAyX2ZhdWx0LCBO
VUxMLCAwKTsKK3N0YXRpYyBTRU5TT1JfREVWSUNFX0FUVFIodGVtcDJfbWluX2FsYXJtLCBTX0lS
VUdPLAorCWdldF90ZW1wMl9taW5fYWxhcm0sIE5VTEwsIDApOworc3RhdGljIFNFTlNPUl9ERVZJ
Q0VfQVRUUih0ZW1wMl9tYXhfYWxhcm0sIFNfSVJVR08sCisJZ2V0X3RlbXAyX21heF9hbGFybSwg
TlVMTCwgMCk7CitzdGF0aWMgU0VOU09SX0RFVklDRV9BVFRSKHRlbXAyX2NyaXRfYWxhcm0sIFNf
SVJVR08sCisJZ2V0X3RlbXAyX2NyaXRfYWxhcm0sIE5VTEwsIDApOworc3RhdGljIFNFTlNPUl9E
RVZJQ0VfQVRUUihmYW4xX2lucHV0LCBTX0lSVUdPLCBnZXRfZmFuMV9pbnB1dCwgTlVMTCwgMCk7
CitzdGF0aWMgU0VOU09SX0RFVklDRV9BVFRSKGZhbjFfbWluLCBTX0lSVUdPIHwgU19JV1VTUiwK
KwlnZXRfZmFuMV9taW4sIHNldF9mYW4xX21pbiwgMCk7CitzdGF0aWMgU0VOU09SX0RFVklDRV9B
VFRSKGZhbjFfbWF4LCBTX0lSVUdPIHwgU19JV1VTUiwKKwlnZXRfZmFuMV9tYXgsIHNldF9mYW4x
X21heCwgMCk7CitzdGF0aWMgU0VOU09SX0RFVklDRV9BVFRSKGZhbjFfZmF1bHQsIFNfSVJVR08s
IGdldF9mYW4xX2ZhdWx0LCBOVUxMLCAwKTsKK3N0YXRpYyBTRU5TT1JfREVWSUNFX0FUVFIoZmFu
MV9kaXYsIFNfSVJVR08gfCBTX0lXVVNSLAorCWdldF9mYW4xX2Rpdiwgc2V0X2ZhbjFfZGl2LCAw
KTsKKworc3RhdGljIFNFTlNPUl9ERVZJQ0VfQVRUUihwd20xLCBTX0lXVVNSIHwgU19JUlVHTywg
Z2V0X3B3bTEsIHNldF9wd20xLCAwKTsKK3N0YXRpYyBTRU5TT1JfREVWSUNFX0FUVFIocHdtMV9l
bmFibGUsIFNfSVdVU1IgfCBTX0lSVUdPLAorCWdldF9wd20xX2VuYWJsZSwgc2V0X3B3bTFfZW5h
YmxlLCAwKTsKK3N0YXRpYyBTRU5TT1JfREVWSUNFX0FUVFIocHdtMV9hdXRvX3BvaW50MV9wd20s
IFNfSVJVR08sCisJZ2V0X3B3bTFfYXV0b19wb2ludF9wd20sIE5VTEwsIDApOworc3RhdGljIFNF
TlNPUl9ERVZJQ0VfQVRUUihwd20xX2F1dG9fcG9pbnQyX3B3bSwgU19JV1VTUiB8IFNfSVJVR08s
CisJZ2V0X3B3bTFfYXV0b19wb2ludF9wd20sIHNldF9wd20xX2F1dG9fcG9pbnRfcHdtLCAxKTsK
K3N0YXRpYyBTRU5TT1JfREVWSUNFX0FUVFIocHdtMV9hdXRvX3BvaW50M19wd20sIFNfSVJVR08s
CisJZ2V0X3B3bTFfYXV0b19wb2ludF9wd20sIE5VTEwsIDIpOworc3RhdGljIFNFTlNPUl9ERVZJ
Q0VfQVRUUihwd20xX2F1dG9fY2hhbm5lbHNfdGVtcCwgU19JUlVHTywKKwlnZXRfcHdtMV9hdXRv
X2NoYW5uZWxzX3RlbXAsIE5VTEwsIDApOworc3RhdGljIFNFTlNPUl9ERVZJQ0VfQVRUUih0ZW1w
MV9hdXRvX3BvaW50MV90ZW1wLCBTX0lSVUdPLAorCWdldF90ZW1wMV9hdXRvX3BvaW50X3RlbXAs
IE5VTEwsIDApOworc3RhdGljIFNFTlNPUl9ERVZJQ0VfQVRUUih0ZW1wMV9hdXRvX3BvaW50Ml90
ZW1wLCBTX0lXVVNSIHwgU19JUlVHTywKKwlnZXRfdGVtcDFfYXV0b19wb2ludF90ZW1wLCBzZXRf
dGVtcDFfYXV0b19wb2ludF90ZW1wLCAxKTsKK3N0YXRpYyBTRU5TT1JfREVWSUNFX0FUVFIodGVt
cDFfYXV0b19wb2ludDNfdGVtcCwgU19JV1VTUiB8IFNfSVJVR08sCisJZ2V0X3RlbXAxX2F1dG9f
cG9pbnRfdGVtcCwgc2V0X3RlbXAxX2F1dG9fcG9pbnRfdGVtcCwgMik7CisKK3N0YXRpYyBTRU5T
T1JfREVWSUNFX0FUVFIodGVtcDJfYXV0b19wb2ludDFfdGVtcCwgU19JV1VTUiB8IFNfSVJVR08s
CisJZ2V0X3RlbXAyX2F1dG9fcG9pbnRfdGVtcCwgc2V0X3RlbXAyX2F1dG9fcG9pbnRfdGVtcCwg
MCk7CitzdGF0aWMgU0VOU09SX0RFVklDRV9BVFRSKHRlbXAyX2F1dG9fcG9pbnQyX3RlbXAsIFNf
SVdVU1IgfCBTX0lSVUdPLAorCWdldF90ZW1wMl9hdXRvX3BvaW50X3RlbXAsIHNldF90ZW1wMl9h
dXRvX3BvaW50X3RlbXAsIDEpOworc3RhdGljIFNFTlNPUl9ERVZJQ0VfQVRUUih0ZW1wMl9hdXRv
X3BvaW50M190ZW1wLCBTX0lXVVNSIHwgU19JUlVHTywKKwlnZXRfdGVtcDJfYXV0b19wb2ludF90
ZW1wLCBzZXRfdGVtcDJfYXV0b19wb2ludF90ZW1wLCAyKTsKKworCisKK3N0YXRpYyBzdHJ1Y3Qg
YXR0cmlidXRlICphbWM2ODIxX2F0dHJzW10gPSB7CisJJnNlbnNvcl9kZXZfYXR0cl90ZW1wMV9p
bnB1dC5kZXZfYXR0ci5hdHRyLAorCSZzZW5zb3JfZGV2X2F0dHJfdGVtcDFfbWluLmRldl9hdHRy
LmF0dHIsCisJJnNlbnNvcl9kZXZfYXR0cl90ZW1wMV9tYXguZGV2X2F0dHIuYXR0ciwKKwkmc2Vu
c29yX2Rldl9hdHRyX3RlbXAxX2NyaXQuZGV2X2F0dHIuYXR0ciwKKwkmc2Vuc29yX2Rldl9hdHRy
X3RlbXAxX21pbl9hbGFybS5kZXZfYXR0ci5hdHRyLAorCSZzZW5zb3JfZGV2X2F0dHJfdGVtcDFf
bWF4X2FsYXJtLmRldl9hdHRyLmF0dHIsCisJJnNlbnNvcl9kZXZfYXR0cl90ZW1wMV9jcml0X2Fs
YXJtLmRldl9hdHRyLmF0dHIsCisJJnNlbnNvcl9kZXZfYXR0cl90ZW1wMl9pbnB1dC5kZXZfYXR0
ci5hdHRyLAorCSZzZW5zb3JfZGV2X2F0dHJfdGVtcDJfbWluLmRldl9hdHRyLmF0dHIsCisJJnNl
bnNvcl9kZXZfYXR0cl90ZW1wMl9tYXguZGV2X2F0dHIuYXR0ciwKKwkmc2Vuc29yX2Rldl9hdHRy
X3RlbXAyX2NyaXQuZGV2X2F0dHIuYXR0ciwKKwkmc2Vuc29yX2Rldl9hdHRyX3RlbXAyX21pbl9h
bGFybS5kZXZfYXR0ci5hdHRyLAorCSZzZW5zb3JfZGV2X2F0dHJfdGVtcDJfbWF4X2FsYXJtLmRl
dl9hdHRyLmF0dHIsCisJJnNlbnNvcl9kZXZfYXR0cl90ZW1wMl9jcml0X2FsYXJtLmRldl9hdHRy
LmF0dHIsCisJJnNlbnNvcl9kZXZfYXR0cl90ZW1wMl9mYXVsdC5kZXZfYXR0ci5hdHRyLAorCSZz
ZW5zb3JfZGV2X2F0dHJfZmFuMV9pbnB1dC5kZXZfYXR0ci5hdHRyLAorCSZzZW5zb3JfZGV2X2F0
dHJfZmFuMV9taW4uZGV2X2F0dHIuYXR0ciwKKwkmc2Vuc29yX2Rldl9hdHRyX2ZhbjFfbWF4LmRl
dl9hdHRyLmF0dHIsCisJJnNlbnNvcl9kZXZfYXR0cl9mYW4xX2ZhdWx0LmRldl9hdHRyLmF0dHIs
CisJJnNlbnNvcl9kZXZfYXR0cl9mYW4xX2Rpdi5kZXZfYXR0ci5hdHRyLAorCSZzZW5zb3JfZGV2
X2F0dHJfcHdtMS5kZXZfYXR0ci5hdHRyLAorCSZzZW5zb3JfZGV2X2F0dHJfcHdtMV9lbmFibGUu
ZGV2X2F0dHIuYXR0ciwKKwkmc2Vuc29yX2Rldl9hdHRyX3B3bTFfYXV0b19jaGFubmVsc190ZW1w
LmRldl9hdHRyLmF0dHIsCisJJnNlbnNvcl9kZXZfYXR0cl9wd20xX2F1dG9fcG9pbnQxX3B3bS5k
ZXZfYXR0ci5hdHRyLAorCSZzZW5zb3JfZGV2X2F0dHJfcHdtMV9hdXRvX3BvaW50Ml9wd20uZGV2
X2F0dHIuYXR0ciwKKwkmc2Vuc29yX2Rldl9hdHRyX3B3bTFfYXV0b19wb2ludDNfcHdtLmRldl9h
dHRyLmF0dHIsCisJJnNlbnNvcl9kZXZfYXR0cl90ZW1wMV9hdXRvX3BvaW50MV90ZW1wLmRldl9h
dHRyLmF0dHIsCisJJnNlbnNvcl9kZXZfYXR0cl90ZW1wMV9hdXRvX3BvaW50Ml90ZW1wLmRldl9h
dHRyLmF0dHIsCisJJnNlbnNvcl9kZXZfYXR0cl90ZW1wMV9hdXRvX3BvaW50M190ZW1wLmRldl9h
dHRyLmF0dHIsCisJJnNlbnNvcl9kZXZfYXR0cl90ZW1wMl9hdXRvX3BvaW50MV90ZW1wLmRldl9h
dHRyLmF0dHIsCisJJnNlbnNvcl9kZXZfYXR0cl90ZW1wMl9hdXRvX3BvaW50Ml90ZW1wLmRldl9h
dHRyLmF0dHIsCisJJnNlbnNvcl9kZXZfYXR0cl90ZW1wMl9hdXRvX3BvaW50M190ZW1wLmRldl9h
dHRyLmF0dHIsCisJTlVMTAorfTsKKworc3RhdGljIHN0cnVjdCBhdHRyaWJ1dGVfZ3JvdXAgYW1j
NjgyMV9hdHRyX2dycCA9IHsKKwkuYXR0cnMgPSBhbWM2ODIxX2F0dHJzLAorfTsKKworCisKKy8q
IFJldHVybiAwIGlmIGRldGVjdGlvbiBpcyBzdWNjZXNzZnVsLCAtRU5PREVWIG90aGVyd2lzZSAq
Lworc3RhdGljIGludCBhbWM2ODIxX2RldGVjdCgKKwkJc3RydWN0IGkyY19jbGllbnQgKmNsaWVu
dCwKKwkJaW50IGtpbmQsCisJCXN0cnVjdCBpMmNfYm9hcmRfaW5mbyAqaW5mbykKK3sKKwlzdHJ1
Y3QgaTJjX2FkYXB0ZXIgKmFkYXB0ZXIgPSBjbGllbnQtPmFkYXB0ZXI7CisJaW50IGFkZHJlc3Mg
PSBjbGllbnQtPmFkZHI7CisKKwlkZXZfZGJnKCZhZGFwdGVyLT5kZXYsICJhbWM2ODIxX2RldGVj
dCBjYWxsZWQsIGtpbmQgPSAlZFxuIiwga2luZCk7CisKKwlpZiAoIWkyY19jaGVja19mdW5jdGlv
bmFsaXR5KGFkYXB0ZXIsIEkyQ19GVU5DX1NNQlVTX0JZVEVfREFUQSkpIHsKKwkJZGV2X2RiZygm
YWRhcHRlci0+ZGV2LAorCQkibWF4NjY1MDogSTJDIGJ1cyBkb2Vzbid0IHN1cHBvcnQgYnl0ZSBy
ZWFkIG1vZGUsIHNraXBwaW5nLlxuIik7CisJCXJldHVybiAtRU5PREVWOworCX0KKwlpZiAoKGtp
bmQgPCAwKSAmJgorCQkoKGkyY19zbWJ1c19yZWFkX2J5dGVfZGF0YShjbGllbnQsIEFNQzY4MjFf
UkVHX0RFVl9JRCkgJgorCQkJMHhERSkgfHwKKwkJKGkyY19zbWJ1c19yZWFkX2J5dGVfZGF0YShj
bGllbnQsIEFNQzY4MjFfUkVHX0NPTVBfSUQpICYKKwkJCTB4QjYpKSkgeworCQkJZGV2X2RiZygm
YWRhcHRlci0+ZGV2LAorCQkJCSJhbWM2ODIxOiBkZXRlY3Rpb24gZmFpbGVkIGF0IDB4JTAyeC5c
biIsCisJCQkJYWRkcmVzcyk7CisJCXJldHVybiAtRU5PREVWOworCX0KKworCWRldl9pbmZvKCZh
ZGFwdGVyLT5kZXYsICJhbWM2ODIxOiBjaGlwIGZvdW5kIGF0IDB4JTAyeC5cbiIsIGFkZHJlc3Mp
OworCXN0cmxjcHkoaW5mby0+dHlwZSwgImFtYzY4MjEiLCBJMkNfTkFNRV9TSVpFKTsKKworCXJl
dHVybiAwOworfQorCitzdGF0aWMgaW50IGFtYzY4MjFfcHJvYmUoCisJc3RydWN0IGkyY19jbGll
bnQgKmNsaWVudCwKKwljb25zdCBzdHJ1Y3QgaTJjX2RldmljZV9pZCAqaWQpCit7CisJc3RydWN0
IGFtYzY4MjFfZGF0YSAqZGF0YTsKKwlpbnQgZXJyOworCisJZGF0YSA9IGt6YWxsb2Moc2l6ZW9m
KHN0cnVjdCBhbWM2ODIxX2RhdGEpLCBHRlBfS0VSTkVMKTsKKwlpZiAoIWRhdGEpIHsKKwkJZGV2
X2VycigmY2xpZW50LT5kZXYsICJvdXQgb2YgbWVtb3J5LlxuIik7CisJCXJldHVybiAtRU5PTUVN
OworCX0KKworCisJaTJjX3NldF9jbGllbnRkYXRhKGNsaWVudCwgZGF0YSk7CisJbXV0ZXhfaW5p
dCgmZGF0YS0+dXBkYXRlX2xvY2spOworCisJLyoKKwkgKiBJbml0aWFsaXplIHRoZSBhbWM2ODIx
IGNoaXAKKwkgKi8KKwllcnIgPSBhbWM2ODIxX2luaXRfY2xpZW50KGNsaWVudCk7CisJaWYgKGVy
cikKKwkJZ290byBlcnJfZnJlZTsKKworCWVyciA9IHN5c2ZzX2NyZWF0ZV9ncm91cCgmY2xpZW50
LT5kZXYua29iaiwgJmFtYzY4MjFfYXR0cl9ncnApOworCWlmIChlcnIpCisJCWdvdG8gZXJyX2Zy
ZWU7CisKKwlkYXRhLT5od21vbl9kZXYgPSBod21vbl9kZXZpY2VfcmVnaXN0ZXIoJmNsaWVudC0+
ZGV2KTsKKwlpZiAoIUlTX0VSUihkYXRhLT5od21vbl9kZXYpKQorCQlyZXR1cm4gMDsKKworCWVy
ciA9IFBUUl9FUlIoZGF0YS0+aHdtb25fZGV2KTsKKwlkZXZfZXJyKCZjbGllbnQtPmRldiwgImVy
cm9yIHJlZ2lzdGVyaW5nIGh3bW9uIGRldmljZS5cbiIpOworCXN5c2ZzX3JlbW92ZV9ncm91cCgm
Y2xpZW50LT5kZXYua29iaiwgJmFtYzY4MjFfYXR0cl9ncnApOworZXJyX2ZyZWU6CisJa2ZyZWUo
ZGF0YSk7CisJcmV0dXJuIGVycjsKK30KKworc3RhdGljIGludCBhbWM2ODIxX3JlbW92ZShzdHJ1
Y3QgaTJjX2NsaWVudCAqY2xpZW50KQoreworCXN0cnVjdCBhbWM2ODIxX2RhdGEgKmRhdGEgPSBp
MmNfZ2V0X2NsaWVudGRhdGEoY2xpZW50KTsKKworCWh3bW9uX2RldmljZV91bnJlZ2lzdGVyKGRh
dGEtPmh3bW9uX2Rldik7CisJc3lzZnNfcmVtb3ZlX2dyb3VwKCZjbGllbnQtPmRldi5rb2JqLCAm
YW1jNjgyMV9hdHRyX2dycCk7CisKKwlrZnJlZShkYXRhKTsKKworCXJldHVybiAwOworfQorCisK
K3N0YXRpYyBpbnQgYW1jNjgyMV9pbml0X2NsaWVudChzdHJ1Y3QgaTJjX2NsaWVudCAqY2xpZW50
KQoreworCWludCBjb25maWc7CisJaW50IGVyciA9IC1FSU87CisKKwlpZiAoaW5pdCkgeworCQlj
b25maWcgPSBpMmNfc21idXNfcmVhZF9ieXRlX2RhdGEoY2xpZW50LCBBTUM2ODIxX1JFR19DT05G
NCk7CisKKwkJaWYgKGNvbmZpZyA8IDApIHsKKwkJCQlkZXZfZXJyKCZjbGllbnQtPmRldiwKKwkJ
CSJFcnJvciByZWFkaW5nIGNvbmZpZ3VyYXRpb24gcmVnaXN0ZXIsIGFib3J0aW5nLlxuIik7CisJ
CQkJcmV0dXJuIGVycjsKKwkJfQorCisJCWNvbmZpZyB8PSBBTUM2ODIxX0NPTkY0X01PREU7CisK
KwkJaWYgKGkyY19zbWJ1c193cml0ZV9ieXRlX2RhdGEoY2xpZW50LCBBTUM2ODIxX1JFR19DT05G
NCwKKwkJCQljb25maWcpKSB7CisJCQlkZXZfZXJyKCZjbGllbnQtPmRldiwKKwkJCSJDb25maWd1
cmF0aW9uIHJlZ2lzdGVyIHdyaXRlIGVycm9yLCBhYm9ydGluZy5cbiIpOworCQkJcmV0dXJuIGVy
cjsKKwkJfQorCisJCWNvbmZpZyA9IGkyY19zbWJ1c19yZWFkX2J5dGVfZGF0YShjbGllbnQsIEFN
QzY4MjFfUkVHX0NPTkYzKTsKKworCQlpZiAoY29uZmlnIDwgMCkgeworCQkJZGV2X2VycigmY2xp
ZW50LT5kZXYsCisJCQkiRXJyb3IgcmVhZGluZyBjb25maWd1cmF0aW9uIHJlZ2lzdGVyLCBhYm9y
dGluZy5cbiIpOworCQkJcmV0dXJuIGVycjsKKwkJfQorCisJCWNvbmZpZyAmPSB+QU1DNjgyMV9D
T05GM19USEVSTV9GQU5fRU47CisKKwkJaWYgKGkyY19zbWJ1c193cml0ZV9ieXRlX2RhdGEoY2xp
ZW50LCBBTUM2ODIxX1JFR19DT05GMywKKwkJCQljb25maWcpKSB7CisJCQlkZXZfZXJyKCZjbGll
bnQtPmRldiwKKwkJCSJDb25maWd1cmF0aW9uIHJlZ2lzdGVyIHdyaXRlIGVycm9yLCBhYm9ydGlu
Zy5cbiIpOworCQkJcmV0dXJuIGVycjsKKwkJfQorCisJCWNvbmZpZyA9IGkyY19zbWJ1c19yZWFk
X2J5dGVfZGF0YShjbGllbnQsIEFNQzY4MjFfUkVHX0NPTkYyKTsKKworCQlpZiAoY29uZmlnIDwg
MCkgeworCQkJZGV2X2VycigmY2xpZW50LT5kZXYsCisJCQkiRXJyb3IgcmVhZGluZyBjb25maWd1
cmF0aW9uIHJlZ2lzdGVyLCBhYm9ydGluZy5cbiIpOworCQkJcmV0dXJuIGVycjsKKwkJfQorCisJ
CWNvbmZpZyAmPSB+QU1DNjgyMV9DT05GMl9SVEZJRTsKKwkJY29uZmlnICY9IH5BTUM2ODIxX0NP
TkYyX0xUT0lFOworCQljb25maWcgJj0gfkFNQzY4MjFfQ09ORjJfUlRPSUU7CisJCWlmIChpMmNf
c21idXNfd3JpdGVfYnl0ZV9kYXRhKGNsaWVudCwKKwkJCQlBTUM2ODIxX1JFR19DT05GMiwgY29u
ZmlnKSkgeworCQkJZGV2X2VycigmY2xpZW50LT5kZXYsCisJCQkiQ29uZmlndXJhdGlvbiByZWdp
c3RlciB3cml0ZSBlcnJvciwgYWJvcnRpbmcuXG4iKTsKKwkJCXJldHVybiBlcnI7CisJCX0KKwor
CQljb25maWcgPSBpMmNfc21idXNfcmVhZF9ieXRlX2RhdGEoY2xpZW50LCBBTUM2ODIxX1JFR19D
T05GMSk7CisKKwkJaWYgKGNvbmZpZyA8IDApIHsKKwkJCWRldl9lcnIoJmNsaWVudC0+ZGV2LAor
CQkJIkVycm9yIHJlYWRpbmcgY29uZmlndXJhdGlvbiByZWdpc3RlciwgYWJvcnRpbmcuXG4iKTsK
KwkJCXJldHVybiBlcnI7CisJCX0KKworCQljb25maWcgJj0gfkFNQzY4MjFfQ09ORjFfVEhFUk1P
VklFOworCQljb25maWcgJj0gfkFNQzY4MjFfQ09ORjFfRkFOSUU7CisJCWNvbmZpZyB8PSBBTUM2
ODIxX0NPTkYxX1NUQVJUOworCQlpZiAocHdtaW52KQorCQkJY29uZmlnIHw9IEFNQzY4MjFfQ09O
RjFfUFdNSU5WOworCQllbHNlCisJCQljb25maWcgJj0gfkFNQzY4MjFfQ09ORjFfUFdNSU5WOwor
CisJCWlmIChpMmNfc21idXNfd3JpdGVfYnl0ZV9kYXRhKAorCQkJCWNsaWVudCwgQU1DNjgyMV9S
RUdfQ09ORjEsIGNvbmZpZykpIHsKKwkJCWRldl9lcnIoJmNsaWVudC0+ZGV2LAorCQkJIkNvbmZp
Z3VyYXRpb24gcmVnaXN0ZXIgd3JpdGUgZXJyb3IsIGFib3J0aW5nLlxuIik7CisJCQlyZXR1cm4g
ZXJyOworCQl9CisJfQorCXJldHVybiAwOworfQorCisKK3N0YXRpYyBzdHJ1Y3QgYW1jNjgyMV9k
YXRhICphbWM2ODIxX3VwZGF0ZV9kZXZpY2Uoc3RydWN0IGRldmljZSAqZGV2KQoreworCXN0cnVj
dCBpMmNfY2xpZW50ICpjbGllbnQgPSB0b19pMmNfY2xpZW50KGRldik7CisJc3RydWN0IGFtYzY4
MjFfZGF0YSAqZGF0YSA9IGkyY19nZXRfY2xpZW50ZGF0YShjbGllbnQpOworCWludCB0aW1lb3V0
ID0gSFo7CisJdTggcmVnOworCisJbXV0ZXhfbG9jaygmZGF0YS0+dXBkYXRlX2xvY2spOworCisJ
aWYgKHRpbWVfYWZ0ZXIoamlmZmllcywgZGF0YS0+bGFzdF91cGRhdGVkICsgdGltZW91dCkgfHwK
KwkJCSFkYXRhLT52YWxpZCkgeworCQlkYXRhLT50ZW1wMV9pbnB1dCA9IGkyY19zbWJ1c19yZWFk
X2J5dGVfZGF0YShjbGllbnQsCisJCQlBTUM2ODIxX1JFR19MVEVNUF9ISSk7CisJCWRhdGEtPnRl
bXAxX21pbiA9IGkyY19zbWJ1c19yZWFkX2J5dGVfZGF0YShjbGllbnQsCisJCQlBTUM2ODIxX1JF
R19MVEVNUF9MSU1JVF9NSU4pOworCQlkYXRhLT50ZW1wMV9tYXggPSBpMmNfc21idXNfcmVhZF9i
eXRlX2RhdGEoY2xpZW50LAorCQkJQU1DNjgyMV9SRUdfTFRFTVBfTElNSVRfTUFYKTsKKwkJZGF0
YS0+dGVtcDFfY3JpdCA9IGkyY19zbWJ1c19yZWFkX2J5dGVfZGF0YShjbGllbnQsCisJCQlBTUM2
ODIxX1JFR19MVEVNUF9DUklUKTsKKworCQlkYXRhLT50ZW1wMl9pbnB1dCA9IGkyY19zbWJ1c19y
ZWFkX2J5dGVfZGF0YShjbGllbnQsCisJCQlBTUM2ODIxX1JFR19SVEVNUF9ISSk7CisJCWRhdGEt
PnRlbXAyX21pbiA9IGkyY19zbWJ1c19yZWFkX2J5dGVfZGF0YShjbGllbnQsCisJCQlBTUM2ODIx
X1JFR19SVEVNUF9MSU1JVF9NSU4pOworCQlkYXRhLT50ZW1wMl9tYXggPSBpMmNfc21idXNfcmVh
ZF9ieXRlX2RhdGEoY2xpZW50LAorCQkJQU1DNjgyMV9SRUdfUlRFTVBfTElNSVRfTUFYKTsKKwkJ
ZGF0YS0+dGVtcDJfY3JpdCA9IGkyY19zbWJ1c19yZWFkX2J5dGVfZGF0YShjbGllbnQsCisJCQlB
TUM2ODIxX1JFR19SVEVNUF9DUklUKTsKKworCQlkYXRhLT5zdGF0MSA9IGkyY19zbWJ1c19yZWFk
X2J5dGVfZGF0YShjbGllbnQsCisJCQlBTUM2ODIxX1JFR19TVEFUMSk7CisJCWRhdGEtPnN0YXQy
ID0gaTJjX3NtYnVzX3JlYWRfYnl0ZV9kYXRhKGNsaWVudCwKKwkJCUFNQzY4MjFfUkVHX1NUQVQy
KTsKKworCQlkYXRhLT5wd20xID0gaTJjX3NtYnVzX3JlYWRfYnl0ZV9kYXRhKGNsaWVudCwKKwkJ
CUFNQzY4MjFfUkVHX0RDWSk7CisJCWRhdGEtPmZhbjFfaW5wdXQgPSBpMmNfc21idXNfcmVhZF9i
eXRlX2RhdGEoY2xpZW50LAorCQkJQU1DNjgyMV9SRUdfVERBVEFfTE9XKTsKKwkJZGF0YS0+ZmFu
MV9pbnB1dCArPSBpMmNfc21idXNfcmVhZF9ieXRlX2RhdGEoY2xpZW50LAorCQkJQU1DNjgyMV9S
RUdfVERBVEFfSEkpIDw8IDg7CisJCWRhdGEtPmZhbjFfbWluID0gaTJjX3NtYnVzX3JlYWRfYnl0
ZV9kYXRhKGNsaWVudCwKKwkJCUFNQzY4MjFfUkVHX1RBQ0hfTExJTUlUTCk7CisJCWRhdGEtPmZh
bjFfbWluICs9IGkyY19zbWJ1c19yZWFkX2J5dGVfZGF0YShjbGllbnQsCisJCQlBTUM2ODIxX1JF
R19UQUNIX0xMSU1JVEwrMSkgPDwgODsKKwkJZGF0YS0+ZmFuMV9tYXggPSBpMmNfc21idXNfcmVh
ZF9ieXRlX2RhdGEoY2xpZW50LAorCQkJQU1DNjgyMV9SRUdfVEFDSF9ITElNSVRMKTsKKwkJZGF0
YS0+ZmFuMV9tYXggKz0gaTJjX3NtYnVzX3JlYWRfYnl0ZV9kYXRhKGNsaWVudCwKKwkJCUFNQzY4
MjFfUkVHX1RBQ0hfSExJTUlUTCsxKSA8PCA4OworCQlkYXRhLT5mYW4xX2RpdiA9IGkyY19zbWJ1
c19yZWFkX2J5dGVfZGF0YShjbGllbnQsCisJCQlBTUM2ODIxX1JFR19DT05GNCk7CisJCWRhdGEt
PmZhbjFfZGl2ID0gZGF0YS0+ZmFuMV9kaXYgJiBBTUM2ODIxX0NPTkY0X1BTUFIgPyA0IDogMjsK
KworCQlkYXRhLT5wd20xX2F1dG9fcG9pbnRfcHdtWzBdID0gMDsKKwkJZGF0YS0+cHdtMV9hdXRv
X3BvaW50X3B3bVsyXSA9IDI1NTsKKwkJZGF0YS0+cHdtMV9hdXRvX3BvaW50X3B3bVsxXSA9IGky
Y19zbWJ1c19yZWFkX2J5dGVfZGF0YShjbGllbnQsCisJCQlBTUM2ODIxX1JFR19EQ1lfTE9XX1RF
TVApOworCisJCWRhdGEtPnRlbXAxX2F1dG9fcG9pbnRfdGVtcFswXSA9CisJCQlpMmNfc21idXNf
cmVhZF9ieXRlX2RhdGEoY2xpZW50LAorCQkJCQlBTUM2ODIxX1JFR19QU1ZfVEVNUCk7CisJCWRh
dGEtPnRlbXAyX2F1dG9fcG9pbnRfdGVtcFswXSA9CisJCQkJZGF0YS0+dGVtcDFfYXV0b19wb2lu
dF90ZW1wWzBdOworCQlyZWcgPSBpMmNfc21idXNfcmVhZF9ieXRlX2RhdGEoY2xpZW50LAorCQkJ
QU1DNjgyMV9SRUdfTFRFTVBfRkFOX0NUUkwpOworCQlkYXRhLT50ZW1wMV9hdXRvX3BvaW50X3Rl
bXBbMV0gPSAocmVnICYgMHhGOCkgPj4gMTsKKwkJcmVnICY9IDB4MDc7CisJCXJlZyA9IDB4MjAg
Pj4gcmVnOworCQlpZiAocmVnID4gMCkKKwkJCWRhdGEtPnRlbXAxX2F1dG9fcG9pbnRfdGVtcFsy
XSA9CisJCQkJZGF0YS0+dGVtcDFfYXV0b19wb2ludF90ZW1wWzFdICsKKwkJCQkoZGF0YS0+cHdt
MV9hdXRvX3BvaW50X3B3bVsyXSAtCisJCQkJZGF0YS0+cHdtMV9hdXRvX3BvaW50X3B3bVsxXSkg
LyByZWc7CisJCWVsc2UKKwkJCWRhdGEtPnRlbXAxX2F1dG9fcG9pbnRfdGVtcFsyXSA9IDI1NTsK
KworCQlyZWcgPSBpMmNfc21idXNfcmVhZF9ieXRlX2RhdGEoY2xpZW50LAorCQkJQU1DNjgyMV9S
RUdfUlRFTVBfRkFOX0NUUkwpOworCQlkYXRhLT50ZW1wMl9hdXRvX3BvaW50X3RlbXBbMV0gPSAo
cmVnICYgMHhGOCkgPj4gMTsKKwkJcmVnICY9IDB4MDc7CisJCXJlZyA9IDB4MjAgPj4gcmVnOwor
CQlpZiAocmVnID4gMCkKKwkJCWRhdGEtPnRlbXAyX2F1dG9fcG9pbnRfdGVtcFsyXSA9CisJCQkJ
ZGF0YS0+dGVtcDJfYXV0b19wb2ludF90ZW1wWzFdICsKKwkJCQkoZGF0YS0+cHdtMV9hdXRvX3Bv
aW50X3B3bVsyXSAtCisJCQkJZGF0YS0+cHdtMV9hdXRvX3BvaW50X3B3bVsxXSkgLyByZWc7CisJ
CWVsc2UKKwkJCWRhdGEtPnRlbXAyX2F1dG9fcG9pbnRfdGVtcFsyXSA9IDI1NTsKKworCQlyZWcg
PSBpMmNfc21idXNfcmVhZF9ieXRlX2RhdGEoY2xpZW50LCBBTUM2ODIxX1JFR19DT05GMSk7CisJ
CXJlZyA9IChyZWcgPj4gNSkgJiAweDM7CisJCXN3aXRjaCAocmVnKSB7CisJCWNhc2UgMDogLypv
cGVuIGxvb3A6IHNvZnR3YXJlIHNldHMgcHdtMSovCisJCQlkYXRhLT5wd20xX2F1dG9fY2hhbm5l
bHNfdGVtcCA9IDA7CisJCQlkYXRhLT5wd20xX2VuYWJsZSA9IDE7CisJCQlicmVhazsKKwkJY2Fz
ZSAyOiAvKmNsb3NlZCBsb29wOiByZW1vdGUgVCAodGVtcDIpKi8KKwkJCWRhdGEtPnB3bTFfYXV0
b19jaGFubmVsc190ZW1wID0gMjsKKwkJCWRhdGEtPnB3bTFfZW5hYmxlID0gMjsKKwkJCWJyZWFr
OworCQljYXNlIDM6IC8qY2xvc2VkIGxvb3A6IGxvY2FsIGFuZCByZW1vdGUgVCAodGVtcDIpKi8K
KwkJCWRhdGEtPnB3bTFfYXV0b19jaGFubmVsc190ZW1wID0gMzsKKwkJCWRhdGEtPnB3bTFfZW5h
YmxlID0gMzsKKwkJCWJyZWFrOworCQljYXNlIDE6IC8qc2VtaS1vcGVuIGxvb3A6IHNvZnR3YXJl
IHNldHMgcnBtLCBjaGlwIGNvbnRyb2xzIHB3bTEsCisJCQkgICpjdXJyZW50bHkgbm90IGltcGxl
bWVudGVkCisJCQkgICovCisJCQlkYXRhLT5wd20xX2F1dG9fY2hhbm5lbHNfdGVtcCA9IDA7CisJ
CQlkYXRhLT5wd20xX2VuYWJsZSA9IDA7CisJCQlicmVhazsKKwkJfQorCisJCWRhdGEtPmxhc3Rf
dXBkYXRlZCA9IGppZmZpZXM7CisJCWRhdGEtPnZhbGlkID0gMTsKKwl9CisJbXV0ZXhfdW5sb2Nr
KCZkYXRhLT51cGRhdGVfbG9jayk7CisJcmV0dXJuIGRhdGE7Cit9CisKKworc3RhdGljIGludCBf
X2luaXQgYW1jNjgyMV9pbml0KHZvaWQpCit7CisJcmV0dXJuIGkyY19hZGRfZHJpdmVyKCZhbWM2
ODIxX2RyaXZlcik7Cit9CisKK3N0YXRpYyB2b2lkIF9fZXhpdCBhbWM2ODIxX2V4aXQodm9pZCkK
K3sKKwlpMmNfZGVsX2RyaXZlcigmYW1jNjgyMV9kcml2ZXIpOworfQorCittb2R1bGVfaW5pdChh
bWM2ODIxX2luaXQpOworbW9kdWxlX2V4aXQoYW1jNjgyMV9leGl0KTsKKworCitNT0RVTEVfTElD
RU5TRSgiR1BMIik7CitNT0RVTEVfQVVUSE9SKCJULiBNZXJ0ZWxqIDx0b21hei5tZXJ0ZWxqQGd1
ZXN0LmFybmVzLnNpPiIpOworTU9EVUxFX0RFU0NSSVBUSU9OKCJUZXhhcyBJbnN0cnVtZW50cyBh
bWM2ODIxIGh3bW9uIGRyaXZlciIpOworTU9EVUxFX1NVUFBPUlRFRF9ERVZJQ0UoImFtYzY4MjEi
KTsK
--Arnes-Webmail-11976--

