Return-Path: <linux-kernel-owner+w=401wt.eu-S1753226AbZIBI3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbZIBI3Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 04:29:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbZIBI3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 04:29:15 -0400
Received: from mail.ijs.si ([193.2.4.66]:50366 "EHLO mail.ijs.si"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752641AbZIBI3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 04:29:13 -0400
X-Greylist: delayed 534 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Sep 2009 04:29:11 EDT
Message-Id: <5.1.0.14.2.20090902101733.0389a890@pop3.arnes.si>
X-Mailer: QUALCOMM Windows Eudora Version 5.1
Date: Wed, 02 Sep 2009 10:20:36 +0200
To: Andre Prendel <andre.prendel@gmx.de>
From: Tomaz Mertelj <tomaz.mertelj@guest.arnes.si>
Subject: Re: [lm-sensors] [PATCH] hwmon: Driver for Texas Instruments
  amc6821 chip
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090901175636.GA4387@ubuntu>
References: <20090831_202450_066558.tomaz.mertelj@guest.arnes.si>
 <20090831_202450_066558.tomaz.mertelj@guest.arnes.si>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 19:56 1. 9. 2009 +0200, you wrote:

>First thing, please send the patch inline attached that one can
>comment the source code.


Sorry, it was filtered out due to a wrong attchment format.

Tomaz


diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 2d50166..d231a28 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -777,6 +777,16 @@ config SENSORS_ADS7828
           This driver can also be built as a module.  If so, the module
           will be called ads7828.

+config SENSORS_AMC6821
+       tristate "Texas Instruments AMC6821"
+       depends on I2C
+       help
+         If you say yes here you get support for the Texas Instruments
+         AMC6821 hardware monitoring chips.
+
+         This driver can also be build as a module.  If so, the module
+         will be called amc6821.
+
  config SENSORS_THMC50
         tristate "Texas Instruments THMC50 / Analog Devices ADM1022"
         depends on I2C && EXPERIMENTAL
diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
index b793dce..431de76 100644
--- a/drivers/hwmon/Makefile
+++ b/drivers/hwmon/Makefile
@@ -81,6 +81,7 @@ obj-$(CONFIG_SENSORS_SIS5595) += sis5595.o
  obj-$(CONFIG_SENSORS_SMSC47B397)+= smsc47b397.o
  obj-$(CONFIG_SENSORS_SMSC47M1) += smsc47m1.o
  obj-$(CONFIG_SENSORS_SMSC47M192)+= smsc47m192.o
+obj-$(CONFIG_SENSORS_AMC6821)  += amc6821.o
  obj-$(CONFIG_SENSORS_THMC50)   += thmc50.o
  obj-$(CONFIG_SENSORS_TMP401)   += tmp401.o
  obj-$(CONFIG_SENSORS_VIA686A)  += via686a.o
diff --git a/drivers/hwmon/amc6821.c b/drivers/hwmon/amc6821.c
new file mode 100644
index 0000000..75dee4c
--- /dev/null
+++ b/drivers/hwmon/amc6821.c
@@ -0,0 +1,851 @@
+/*
+       amc6821.c - Part of lm_sensors, Linux kernel modules for hardware
+                        monitoring
+       Copyright (C) 2009 T. Mertelj <tomaz.mertelj@guest.arnes.si>
+
+       This program is free software; you can redistribute it and/or modify
+       it under the terms of the GNU General Public License as published by
+       the Free Software Foundation; either version 2 of the License, or
+       (at your option) any later version.
+
+       This program is distributed in the hope that it will be useful,
+       but WITHOUT ANY WARRANTY; without even the implied warranty of
+       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+       GNU General Public License for more details.
+
+       You should have received a copy of the GNU General Public License
+       along with this program; if not, write to the Free Software
+       Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+*/
+
+
+#include <linux/kernel.h>      /* Needed for KERN_INFO */
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
+static const unsigned short normal_i2c[ ] = {0x18, 0x19, 0x1a, 0x2c,0x2d,0x2e,
+       0x4c,0x4d,0x4e,I2C_CLIENT_END};
+
+
+
+/*
+ * Insmod parameters
+ */
+
+static int pwminv = 0; /*Inverted PWM output. */
+module_param(pwminv, int, S_IRUGO);
+
+static int init = 1; /*Power-on initialization.*/
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
+static int amc6821_probe(struct i2c_client *client,const struct 
i2c_device_id *id);
+static int amc6821_detect(struct i2c_client *client, int kind,struct 
i2c_board_info *info);
+static int amc6821_init_client(struct i2c_client *client);
+static int amc6821_remove(struct i2c_client *client);
+static struct amc6821_data *amc6821_update_device(struct device *dev);
+
+/*
+ * Driver data (common to all clients)
+ */
+
+static const struct i2c_device_id amc6821_id[] = {
+       { "amc6821", amc6821 },
+       { }
+};
+
+MODULE_DEVICE_TABLE(i2c, amc6821_id);
+
+
+static struct i2c_driver amc6821_driver = {
+       .class                  = I2C_CLASS_HWMON,
+       .driver = {
+               .name   = "amc6821",
+       },
+       .probe = amc6821_probe,
+       .remove = amc6821_remove,
+       .id_table = amc6821_id,
+       .detect = amc6821_detect,
+       .address_data = &addr_data,
+};
+
+
+/*
+ * Client data (each client gets its own)
+  */
+
+struct amc6821_data
+{
+       struct device *hwmon_dev;
+       struct mutex update_lock;
+       char valid; /* zero until following fields are valid */
+       unsigned long last_updated; /* in jiffies */
+
+       /* register values */
+       int temp1_input;
+       int temp1_min;
+       int temp1_max;
+       int temp1_crit;
+
+       u8 temp1_alarm;
+       int temp2_input;
+       int temp2_min;
+       int temp2_max;
+       int temp2_crit;
+       u8 temp2_alarm;
+
+       u16 fan1_input;
+       u16 fan1_min;
+       u16 fan1_max;
+       u8 fan1_div;
+
+       u8 pwm1;
+       u8 temp1_auto_point_temp[3];
+       u8 temp2_auto_point_temp[3];
+       u8 pwm1_auto_point_pwm[3];
+       u8 pwm1_enable;
+       u8 pwm1_auto_channels_temp;
+
+       u8 stat1;
+       u8 stat2;
+};
+
+
+#define get_temp_para(name) \
+static ssize_t get_##name(struct device *dev, struct device_attribute 
*devattr,char *buf){ \
+       struct amc6821_data *data = amc6821_update_device(dev);\
+       return sprintf(buf, "%d\n", data->name * 1000);\
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
+#define set_temp_para(name,reg)\
+static ssize_t set_##name(struct device *dev, struct device_attribute 
*attr, const char *buf, size_t count) \
+{ \
+       struct i2c_client *client = to_i2c_client(dev); \
+       struct amc6821_data *data = i2c_get_clientdata(client); \
+       int val = simple_strtol(buf, NULL, 10); \
+       \
+       mutex_lock(&data->update_lock); \
+       data->name = SENSORS_LIMIT(val / 1000, -128, 127); \
+        if (i2c_smbus_write_byte_data(client, reg, data->name)) {\
+               dev_err(&client->dev, "Register write error, aborting.\n");\
+               count= -EIO;\
+       }\
+       mutex_unlock(&data->update_lock); \
+       return count; \
+}
+
+set_temp_para(temp1_min,AMC6821_REG_LTEMP_LIMIT_MIN);
+set_temp_para(temp1_max,AMC6821_REG_LTEMP_LIMIT_MAX);
+set_temp_para(temp2_min,AMC6821_REG_RTEMP_LIMIT_MIN);
+set_temp_para(temp2_max,AMC6821_REG_RTEMP_LIMIT_MAX);
+set_temp_para(temp1_crit,AMC6821_REG_LTEMP_CRIT);
+set_temp_para(temp2_crit,AMC6821_REG_RTEMP_CRIT);
+
+#define get_temp_alarm(name, reg, mask)\
+static ssize_t get_##name(struct device *dev, struct device_attribute 
*devattr,char *buf){\
+       struct amc6821_data *data = amc6821_update_device(dev);\
+       if( data->reg &  mask)\
+               return sprintf(buf, "1");\
+       else    \
+               return sprintf(buf, "0");\
+}\
+
+get_temp_alarm(temp1_min_alarm, stat1, AMC6821_STAT1_LTL)
+get_temp_alarm(temp1_max_alarm, stat1, AMC6821_STAT1_LTH)
+get_temp_alarm(temp2_min_alarm, stat1, AMC6821_STAT1_RTL)
+get_temp_alarm(temp2_max_alarm, stat1, AMC6821_STAT1_RTH)
+get_temp_alarm(temp1_crit_alarm, stat2, AMC6821_STAT2_LTC)
+get_temp_alarm(temp2_crit_alarm, stat2, AMC6821_STAT2_RTC)
+
+
+static ssize_t get_temp2_fault(struct device *dev, struct device_attribute 
*devattr,char *buf){
+       struct amc6821_data *data = amc6821_update_device(dev);
+       if( data->stat1 & AMC6821_STAT1_RTF)
+               return sprintf(buf, "1");
+       else
+               return sprintf(buf, "0");
+}
+
+static ssize_t get_pwm1(struct device *dev, struct device_attribute 
*devattr,char *buf){
+       struct amc6821_data *data = amc6821_update_device(dev);
+       return sprintf(buf, "%d\n", data->pwm1);
+}
+
+static ssize_t set_pwm1(struct device *dev, struct device_attribute 
*devattr,const char *buf, size_t count){
+       struct i2c_client *client = to_i2c_client(dev);
+       struct amc6821_data *data = i2c_get_clientdata(client);
+       int val = simple_strtol(buf, NULL, 10);
+
+       mutex_lock(&data->update_lock); \
+       data->pwm1 = SENSORS_LIMIT(val , 0, 255); \
+        i2c_smbus_write_byte_data(client, AMC6821_REG_DCY, data->pwm1); \
+       mutex_unlock(&data->update_lock); \
+       return count;
+}
+
+static ssize_t get_pwm1_enable(struct device *dev, struct device_attribute 
*devattr,char *buf){
+       struct amc6821_data *data = amc6821_update_device(dev);
+       return sprintf(buf, "%d\n", data->pwm1_enable);
+}
+
+static ssize_t set_pwm1_enable(struct device *dev, struct device_attribute 
*attr, const char *buf, size_t count){
+       struct i2c_client *client = to_i2c_client(dev);
+       struct amc6821_data *data = i2c_get_clientdata(client);
+       int val = simple_strtol(buf, NULL, 10);
+
+       int config = i2c_smbus_read_byte_data(client, AMC6821_REG_CONF1);
+          if (config < 0) {
+                       dev_err(&client->dev, "Error reading configuration 
register, aborting.\n");
+                       return -EIO;
+       }
+
+       switch (val){
+       case 1:
+               config &= ~AMC6821_CONF1_FDRC0;
+               config &= ~AMC6821_CONF1_FDRC1;
+               break;
+       case 2:
+               config &= ~AMC6821_CONF1_FDRC0;
+               config |= AMC6821_CONF1_FDRC1;
+               break;
+       case 3:
+               config |= AMC6821_CONF1_FDRC0;
+               config |= AMC6821_CONF1_FDRC1;
+               break;
+       default:
+               return -EINVAL;
+       }
+       mutex_lock(&data->update_lock);
+       if (i2c_smbus_write_byte_data(client, AMC6821_REG_CONF1, config)) {
+                       dev_err(&client->dev, "Configuration register write 
error, aborting.\n");
+                       count= -EIO;
+       }
+       mutex_unlock(&data->update_lock);
+       return count;
+}
+
+
+static ssize_t get_pwm1_auto_channels_temp(struct device *dev, struct 
device_attribute *devattr,char *buf){
+       struct amc6821_data *data = amc6821_update_device(dev);
+       return sprintf(buf, "%d\n", data->pwm1_auto_channels_temp);
+}
+
+
+#define get_auto_point(name)\
+static ssize_t get_##name(struct device *dev, struct device_attribute 
*devattr,char *buf){\
+       int nr = to_sensor_dev_attr(devattr)->index;\
+       struct amc6821_data *data = amc6821_update_device(dev);\
+       return sprintf(buf, "%d\n", data->name[nr] *1000);\
+}
+
+get_auto_point(temp1_auto_point_temp);
+get_auto_point(temp2_auto_point_temp);
+
+static ssize_t get_pwm1_auto_point_pwm(struct device *dev, struct 
device_attribute *devattr,char *buf){
+       int nr = to_sensor_dev_attr(devattr)->index;
+       struct amc6821_data *data = amc6821_update_device(dev);
+       return sprintf(buf, "%d\n", data->pwm1_auto_point_pwm[nr] );
+}
+
+
+#define set_temp_auto_point_temp(name,reg)\
+static ssize_t set_##name(struct device *dev, struct device_attribute 
*attr, const char *buf, size_t count) \
+{ \
+       struct i2c_client *client = to_i2c_client(dev); \
+       struct amc6821_data *data = amc6821_update_device(dev);\
+       int nr = to_sensor_dev_attr(attr)->index;\
+       int val = simple_strtol(buf, NULL, 10); \
+       u8 tmp;\
+       \
+       mutex_lock(&data->update_lock); \
+       switch(nr){\
+               case 0:\
+                       data->name[0] = SENSORS_LIMIT(val / 1000, 
0,data->temp1_auto_point_temp[1]-1);\
+                       data->name[0] = SENSORS_LIMIT(data->name[0], 
0,data->temp2_auto_point_temp[1]-1);\
+                       data->name[0] = SENSORS_LIMIT(data->name[0], 0, 63); \
+                       data->valid = 0;\
+                       if (i2c_smbus_write_byte_data(client, 
AMC6821_REG_PSV_TEMP, data->name[ 0] )) {\
+                                       dev_err(&client->dev, "Register 
write error, aborting.\n");\
+                                       count = -EIO;\
+                       }\
+                       goto EXIT;\
+                        break;\
+               case 1:\
+                       data->name[1] = SENSORS_LIMIT(val / 1000, 
data->name[0]+1, data->name[ 2]-1); \
+                       data->name[1] &= 0x7C;\
+                       break;\
+               case 2:\
+                       data->name[2] = SENSORS_LIMIT(val / 1000, 
data->name[1]+1, 127); \
+                       break;\
+       }\
+       val = 
(16*(data->pwm1_auto_point_pwm[2]-data->pwm1_auto_point_pwm[1]))/(data->name[2]-data->name[1]);\
+       for(tmp = 4; tmp >= 0; tmp--){\
+               if( val <= (0x200 >> tmp)) break;\
+       }\
+       tmp |= ((u8) data->name[ 1] & 0x7C) << 1;\
+       if (i2c_smbus_write_byte_data(client, reg, tmp)) {\
+               dev_err(&client->dev, "Register write error, aborting.\n");\
+               count = -EIO;\
+       }\
+       data->valid = 0;\
+EXIT:\
+       mutex_unlock(&data->update_lock); \
+       return count; \
+}
+
+set_temp_auto_point_temp(temp1_auto_point_temp, AMC6821_REG_LTEMP_FAN_CTRL);
+set_temp_auto_point_temp(temp2_auto_point_temp, AMC6821_REG_RTEMP_FAN_CTRL);
+
+static ssize_t set_pwm1_auto_point_pwm(struct device *dev, struct 
device_attribute *attr, const char *buf, size_t count)
+{
+       struct i2c_client *client = to_i2c_client(dev);
+       struct amc6821_data *data = i2c_get_clientdata(client);
+       int val = simple_strtol(buf, NULL, 10);
+       u8 tmp;
+
+       mutex_lock(&data->update_lock);
+       data->pwm1_auto_point_pwm[ 1] = SENSORS_LIMIT(val, 0, 255);
+       if (i2c_smbus_write_byte_data(client, AMC6821_REG_DCY_LOW_TEMP, 
data->pwm1_auto_point_pwm[ 1])) {\
+               dev_err(&client->dev, "Register write error, aborting.\n");
+               count = -EIO;
+       }
+
+       val =(16 * 
(data->pwm1_auto_point_pwm[2]-data->pwm1_auto_point_pwm[1]))/(data->temp1_auto_point_temp[2]-data->temp1_auto_point_temp[1]);
+       for(tmp = 4; tmp >= 0; tmp--){
+               if( val <= (0x200 >> tmp)) break;
+       }
+       tmp |= ((u8) data->temp1_auto_point_temp[ 1] & 0x7C) << 1;
+       if (i2c_smbus_write_byte_data(client,  AMC6821_REG_LTEMP_FAN_CTRL, 
tmp)) {
+               dev_err(&client->dev, "Register write error, aborting.\n");
+               count = -EIO;
+       }
+       data->valid = 0;
+
+       val = (16 * 
(data->pwm1_auto_point_pwm[2]-data->pwm1_auto_point_pwm[1]))/(data->temp2_auto_point_temp[2]-data->temp2_auto_point_temp[1]);
+       for(tmp = 4; tmp >= 0; tmp--){
+               if( val <= (0x200 >> tmp)) break;
+       }
+       tmp |= ((u8) data->temp2_auto_point_temp[ 1] & 0x7C) << 1;
+       if (i2c_smbus_write_byte_data(client,  AMC6821_REG_RTEMP_FAN_CTRL, 
tmp)) {
+               dev_err(&client->dev, "Register write error, aborting.\n");
+               count = -EIO;
+       }
+       data->valid = 0;
+       mutex_unlock(&data->update_lock);
+       return count;
+}
+
+
+#define get_fan_para(name) static ssize_t get_##name(struct device *dev, 
struct device_attribute *devattr,char *buf){ \
+       struct amc6821_data *data = amc6821_update_device(dev); \
+       if ( 0 == data->name) return sprintf(buf,"0");\
+       return sprintf(buf, "%d\n", (int)(6000000 / data->name)); \
+}
+
+get_fan_para(fan1_input);
+get_fan_para(fan1_min);
+get_fan_para(fan1_max);
+
+static ssize_t get_fan1_fault(struct device *dev, struct device_attribute 
*devattr,char *buf){
+       struct amc6821_data *data = amc6821_update_device(dev);
+       if( data->stat1 & AMC6821_STAT1_FANS)
+               return sprintf(buf, "1");
+       else
+               return sprintf(buf, "0");
+}
+
+
+#define set_fan_para(name, reg) \
+static ssize_t set_##name(struct device *dev, struct device_attribute 
*attr, const char *buf, size_t count){ \
+       struct i2c_client *client = to_i2c_client(dev); \
+       struct amc6821_data *data = i2c_get_clientdata(client); \
+       int val = simple_strtol(buf, NULL, 10); \
+       val = 1>val ? 0xFFFF : 6000000/val; \
+\
+       mutex_lock(&data->update_lock); \
+       data->name = (u16) SENSORS_LIMIT(val, 1, 0xFFFF); \
+       if (i2c_smbus_write_byte_data(client, reg, data->name & 0xFF)) { \
+               dev_err(&client->dev, "Register write error, aborting.\n");\
+               count= -EIO;\
+       }\
+       if (i2c_smbus_write_byte_data(client, reg+1, data->name >> 8 )) { \
+               dev_err(&client->dev, "Register write error, aborting.\n");\
+               count= -EIO;\
+       }\
+       mutex_unlock(&data->update_lock); \
+       return count; \
+}
+
+
+set_fan_para(fan1_min, AMC6821_REG_TACH_LLIMITL);
+set_fan_para(fan1_max, AMC6821_REG_TACH_HLIMITL);
+
+
+static ssize_t get_fan1_div(struct device *dev, struct device_attribute 
*devattr,char *buf){
+       struct amc6821_data *data = amc6821_update_device(dev);
+
+       return sprintf(buf, "%d\n", data->fan1_div);
+}
+
+static ssize_t set_fan1_div(struct device *dev, struct device_attribute 
*attr, const char *buf, size_t count){
+       struct i2c_client *client = to_i2c_client(dev);
+       struct amc6821_data *data = i2c_get_clientdata(client);
+       int val = simple_strtol(buf, NULL, 10);
+       int config = i2c_smbus_read_byte_data(client, AMC6821_REG_CONF4);
+
+       if (config < 0) {
+               dev_err(&client->dev, "Error reading configuration 
register, aborting.\n");
+               return -EIO;
+       }
+       mutex_lock(&data->update_lock);
+       switch (val){
+               case 2:
+                       config &= ~AMC6821_CONF4_PSPR;
+                       data->fan1_div=2;
+                       break;
+               case 4:
+                       config |= AMC6821_CONF4_PSPR;
+                       data->fan1_div=4;
+                       break;
+               default:
+                       mutex_unlock(&data->update_lock);
+                       return -EINVAL;
+       }
+       if (i2c_smbus_write_byte_data(client, AMC6821_REG_CONF4, config)) {
+               dev_err(&client->dev, "Configuration register write error, 
aborting.\n");
+               count= -EIO;
+       }
+       mutex_unlock(&data->update_lock);
+       return count;
+}
+
+
+
+static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO, get_temp1_input, NULL, 0);
+static SENSOR_DEVICE_ATTR(temp1_min, S_IRUGO | S_IWUSR, get_temp1_min, 
set_temp1_min, 0);
+static SENSOR_DEVICE_ATTR(temp1_max, S_IRUGO | S_IWUSR, get_temp1_max, 
set_temp1_max, 0);
+static SENSOR_DEVICE_ATTR(temp1_crit, S_IRUGO | S_IWUSR, get_temp1_crit, 
set_temp1_crit, 0);
+static SENSOR_DEVICE_ATTR(temp1_min_alarm, S_IRUGO, get_temp1_min_alarm, 
NULL, 0);
+static SENSOR_DEVICE_ATTR(temp1_max_alarm, S_IRUGO, get_temp1_max_alarm, 
NULL, 0);
+static SENSOR_DEVICE_ATTR(temp1_crit_alarm, S_IRUGO, get_temp1_crit_alarm, 
NULL, 0);
+static SENSOR_DEVICE_ATTR(temp2_input, S_IRUGO | S_IWUSR, get_temp2_input, 
NULL, 0);
+static SENSOR_DEVICE_ATTR(temp2_min, S_IRUGO | S_IWUSR, get_temp2_min, 
set_temp2_min, 0);
+static SENSOR_DEVICE_ATTR(temp2_max, S_IRUGO | S_IWUSR, get_temp2_max, 
set_temp2_max, 0);
+static SENSOR_DEVICE_ATTR(temp2_crit, S_IRUGO | S_IWUSR, get_temp2_crit, 
set_temp2_crit, 0);
+static SENSOR_DEVICE_ATTR(temp2_fault, S_IRUGO, get_temp2_fault, NULL, 0);
+static SENSOR_DEVICE_ATTR(temp2_min_alarm, S_IRUGO, get_temp2_min_alarm, 
NULL, 0);
+static SENSOR_DEVICE_ATTR(temp2_max_alarm, S_IRUGO, get_temp2_max_alarm, 
NULL, 0);
+static SENSOR_DEVICE_ATTR(temp2_crit_alarm, S_IRUGO, get_temp2_crit_alarm, 
NULL, 0);
+static SENSOR_DEVICE_ATTR(fan1_input, S_IRUGO, get_fan1_input, NULL, 0);
+static SENSOR_DEVICE_ATTR(fan1_min, S_IRUGO | S_IWUSR, get_fan1_min, 
set_fan1_min, 0);
+static SENSOR_DEVICE_ATTR(fan1_max, S_IRUGO | S_IWUSR, get_fan1_max, 
set_fan1_max, 0);
+static SENSOR_DEVICE_ATTR(fan1_fault, S_IRUGO, get_fan1_fault, NULL, 0);
+static SENSOR_DEVICE_ATTR(fan1_div, S_IRUGO | S_IWUSR, get_fan1_div, 
set_fan1_div, 0);
+
+static SENSOR_DEVICE_ATTR(pwm1, S_IWUSR | S_IRUGO, get_pwm1, set_pwm1,0);
+static SENSOR_DEVICE_ATTR(pwm1_enable, S_IWUSR | S_IRUGO, get_pwm1_enable, 
set_pwm1_enable,0);
+static SENSOR_DEVICE_ATTR(pwm1_auto_point1_pwm, S_IRUGO, 
get_pwm1_auto_point_pwm, NULL,0);
+static SENSOR_DEVICE_ATTR(pwm1_auto_point2_pwm, S_IWUSR | S_IRUGO, 
get_pwm1_auto_point_pwm, set_pwm1_auto_point_pwm,1);
+static SENSOR_DEVICE_ATTR(pwm1_auto_point3_pwm, S_IRUGO, 
get_pwm1_auto_point_pwm, NULL,2);
+static SENSOR_DEVICE_ATTR(pwm1_auto_channels_temp, S_IRUGO, 
get_pwm1_auto_channels_temp, NULL,0);
+static SENSOR_DEVICE_ATTR(temp1_auto_point1_temp, S_IRUGO, 
get_temp1_auto_point_temp, NULL,0);
+static SENSOR_DEVICE_ATTR(temp1_auto_point2_temp, S_IWUSR | S_IRUGO, 
get_temp1_auto_point_temp, set_temp1_auto_point_temp,1);
+static SENSOR_DEVICE_ATTR(temp1_auto_point3_temp, S_IWUSR | S_IRUGO, 
get_temp1_auto_point_temp, set_temp1_auto_point_temp,2);
+
+static SENSOR_DEVICE_ATTR(temp2_auto_point1_temp, S_IWUSR | S_IRUGO, 
get_temp2_auto_point_temp, set_temp2_auto_point_temp,0);
+static SENSOR_DEVICE_ATTR(temp2_auto_point2_temp, S_IWUSR | S_IRUGO, 
get_temp2_auto_point_temp, set_temp2_auto_point_temp,1);
+static SENSOR_DEVICE_ATTR(temp2_auto_point3_temp, S_IWUSR | S_IRUGO, 
get_temp2_auto_point_temp, set_temp2_auto_point_temp,2);
+
+
+
+static struct attribute *amc6821_attrs[] = {
+       &sensor_dev_attr_temp1_input.dev_attr.attr,
+       &sensor_dev_attr_temp1_min.dev_attr.attr,
+       &sensor_dev_attr_temp1_max.dev_attr.attr,
+       &sensor_dev_attr_temp1_crit.dev_attr.attr,
+       &sensor_dev_attr_temp1_min_alarm.dev_attr.attr,
+       &sensor_dev_attr_temp1_max_alarm.dev_attr.attr,
+       &sensor_dev_attr_temp1_crit_alarm.dev_attr.attr,
+       &sensor_dev_attr_temp2_input.dev_attr.attr,
+       &sensor_dev_attr_temp2_min.dev_attr.attr,
+       &sensor_dev_attr_temp2_max.dev_attr.attr,
+       &sensor_dev_attr_temp2_crit.dev_attr.attr,
+       &sensor_dev_attr_temp2_min_alarm.dev_attr.attr,
+       &sensor_dev_attr_temp2_max_alarm.dev_attr.attr,
+       &sensor_dev_attr_temp2_crit_alarm.dev_attr.attr,
+       &sensor_dev_attr_temp2_fault.dev_attr.attr,
+       &sensor_dev_attr_fan1_input.dev_attr.attr,
+       &sensor_dev_attr_fan1_min.dev_attr.attr,
+       &sensor_dev_attr_fan1_max.dev_attr.attr,
+       &sensor_dev_attr_fan1_fault.dev_attr.attr,
+       &sensor_dev_attr_fan1_div.dev_attr.attr,
+       &sensor_dev_attr_pwm1.dev_attr.attr,
+       &sensor_dev_attr_pwm1_enable.dev_attr.attr,
+       &sensor_dev_attr_pwm1_auto_channels_temp.dev_attr.attr,
+       &sensor_dev_attr_pwm1_auto_point1_pwm.dev_attr.attr,
+       &sensor_dev_attr_pwm1_auto_point2_pwm.dev_attr.attr,
+       &sensor_dev_attr_pwm1_auto_point3_pwm.dev_attr.attr,
+       &sensor_dev_attr_temp1_auto_point1_temp.dev_attr.attr,
+       &sensor_dev_attr_temp1_auto_point2_temp.dev_attr.attr,
+       &sensor_dev_attr_temp1_auto_point3_temp.dev_attr.attr,
+       &sensor_dev_attr_temp2_auto_point1_temp.dev_attr.attr,
+       &sensor_dev_attr_temp2_auto_point2_temp.dev_attr.attr,
+       &sensor_dev_attr_temp2_auto_point3_temp.dev_attr.attr,
+       NULL
+};
+
+static struct attribute_group amc6821_attr_grp = {
+       .attrs = amc6821_attrs,
+};
+
+
+
+/* Return 0 if detection is successful, -ENODEV otherwise */
+static int amc6821_detect(struct i2c_client *client, int kind,
+       struct i2c_board_info *info)
+{
+       struct i2c_adapter *adapter = client->adapter;
+       int address = client->addr;
+
+       dev_dbg(&adapter->dev, "amc6821_detect called, kind = %d\n", kind);
+
+       if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA)) {
+               dev_dbg(&adapter->dev, "max6650: I2C bus doesn't support 
byte read mode, skipping.\n");
+               return -ENODEV;
+       }
+       if ((kind < 0) &&
+               ((i2c_smbus_read_byte_data(client, AMC6821_REG_DEV_ID) & 
0xDE) ||
+               (i2c_smbus_read_byte_data(client, AMC6821_REG_COMP_ID) & 
0xB6))){
+                       dev_dbg(&adapter->dev,"amc6821: detection failed at 
0x%02x.\n", address);
+               return -ENODEV;
+       }
+
+       dev_info(&adapter->dev, "amc6821: chip found at 0x%02x.\n", address);
+       strlcpy(info->type, "amc6821", I2C_NAME_SIZE);
+
+       return 0;
+}
+
+static int amc6821_probe(struct i2c_client *client,
+       const struct i2c_device_id *id)
+{
+       struct amc6821_data *data;
+       int err;
+
+       if (!(data = kzalloc(sizeof(struct amc6821_data), GFP_KERNEL))) {
+               dev_err(&client->dev, "out of memory.\n");
+               return -ENOMEM;
+       }
+
+
+       i2c_set_clientdata(client, data);
+       mutex_init(&data->update_lock);
+
+       /*
+        * Initialize the amc6821 chip
+        */
+       err = amc6821_init_client(client);
+       if (err)
+               goto err_free;
+
+       err = sysfs_create_group(&client->dev.kobj, &amc6821_attr_grp);
+       if (err)
+               goto err_free;
+
+       data->hwmon_dev = hwmon_device_register(&client->dev);
+       if (!IS_ERR(data->hwmon_dev))
+               return 0;
+
+       err = PTR_ERR(data->hwmon_dev);
+       dev_err(&client->dev, "error registering hwmon device.\n");
+       sysfs_remove_group(&client->dev.kobj, &amc6821_attr_grp);
+err_free:
+       kfree(data);
+       return err;
+}
+
+static int amc6821_remove(struct i2c_client *client)
+{
+       struct amc6821_data *data = i2c_get_clientdata(client);
+
+       hwmon_device_unregister(data->hwmon_dev);
+       sysfs_remove_group(&client->dev.kobj, &amc6821_attr_grp);
+
+       kfree(data);
+
+       return 0;
+}
+
+
+static int amc6821_init_client(struct i2c_client *client)
+{
+       int config;
+       int err = -EIO;
+
+       if( init ){
+               config = i2c_smbus_read_byte_data(client, AMC6821_REG_CONF4);
+
+               if (config < 0) {
+                               dev_err(&client->dev, "Error reading 
configuration register, aborting.\n");
+                               return err;
+               }
+
+               config |= AMC6821_CONF4_MODE;
+
+               if (i2c_smbus_write_byte_data(client, AMC6821_REG_CONF4, 
config)) {
+                       dev_err(&client->dev, "Configuration register write 
error, aborting.\n");
+                       return err;
+               }
+
+               config = i2c_smbus_read_byte_data(client, AMC6821_REG_CONF3);
+
+               if (config < 0) {
+                       dev_err(&client->dev, "Error reading configuration 
register, aborting.\n");
+                       return err;
+               }
+
+               config &= ~AMC6821_CONF3_THERM_FAN_EN;
+
+               if (i2c_smbus_write_byte_data(client, AMC6821_REG_CONF3, 
config)) {
+                       dev_err(&client->dev, "Configuration register write 
error, aborting.\n");
+                       return err;
+               }
+
+               config = i2c_smbus_read_byte_data(client, AMC6821_REG_CONF2);
+
+               if (config < 0) {
+                       dev_err(&client->dev, "Error reading configuration 
register, aborting.\n");
+                       return err;
+               }
+
+               config &= ~AMC6821_CONF2_RTFIE;
+               config &= ~AMC6821_CONF2_LTOIE;
+               config &= ~AMC6821_CONF2_RTOIE;
+               if (i2c_smbus_write_byte_data(client, AMC6821_REG_CONF2, 
config)) {
+                       dev_err(&client->dev, "Configuration register write 
error, aborting.\n");
+                       return err;
+               }
+
+               config = i2c_smbus_read_byte_data(client, AMC6821_REG_CONF1);
+
+               if (config < 0) {
+                       dev_err(&client->dev, "Error reading configuration 
register, aborting.\n");
+                       return err;
+               }
+
+               config &= ~AMC6821_CONF1_THERMOVIE;
+               config &= ~AMC6821_CONF1_FANIE;
+               config |= AMC6821_CONF1_START;
+               if (pwminv) {
+                       config |= AMC6821_CONF1_PWMINV;
+               } else {
+                       config &= ~AMC6821_CONF1_PWMINV;
+               }
+
+               if (i2c_smbus_write_byte_data(client, AMC6821_REG_CONF1, 
config)) {
+                       dev_err(&client->dev, "Configuration register write 
error, aborting.\n");
+                       return err;
+               }
+       }
+       return 0;
+}
+
+
+static struct amc6821_data *amc6821_update_device(struct device *dev)
+{
+       struct i2c_client *client = to_i2c_client(dev);
+       struct amc6821_data *data = i2c_get_clientdata(client);
+       int timeout = HZ;
+       u8 reg;
+
+       mutex_lock(&data->update_lock);
+
+       if (time_after(jiffies, data->last_updated + timeout) || 
!data->valid) {
+               data->temp1_input = i2c_smbus_read_byte_data(client, 
AMC6821_REG_LTEMP_HI);
+               data->temp1_min = i2c_smbus_read_byte_data(client, 
AMC6821_REG_LTEMP_LIMIT_MIN);
+               data->temp1_max = i2c_smbus_read_byte_data(client, 
AMC6821_REG_LTEMP_LIMIT_MAX);
+               data->temp1_crit = i2c_smbus_read_byte_data(client, 
AMC6821_REG_LTEMP_CRIT);
+
+               data->temp2_input = i2c_smbus_read_byte_data(client, 
AMC6821_REG_RTEMP_HI);
+               data->temp2_min = i2c_smbus_read_byte_data(client, 
AMC6821_REG_RTEMP_LIMIT_MIN);
+               data->temp2_max = i2c_smbus_read_byte_data(client, 
AMC6821_REG_RTEMP_LIMIT_MAX);
+               data->temp2_crit = i2c_smbus_read_byte_data(client, 
AMC6821_REG_RTEMP_CRIT);
+
+               data->stat1 = 
i2c_smbus_read_byte_data(client,AMC6821_REG_STAT1);
+               data->stat2 = 
i2c_smbus_read_byte_data(client,AMC6821_REG_STAT2);
+
+               data->pwm1 = i2c_smbus_read_byte_data(client,AMC6821_REG_DCY);
+               data->fan1_input = 
i2c_smbus_read_byte_data(client,AMC6821_REG_TDATA_LOW);
+               data->fan1_input += 
i2c_smbus_read_byte_data(client,AMC6821_REG_TDATA_HI) << 8;
+               data->fan1_min = 
i2c_smbus_read_byte_data(client,AMC6821_REG_TACH_LLIMITL);
+               data->fan1_min += 
i2c_smbus_read_byte_data(client,AMC6821_REG_TACH_LLIMITL+1) << 8;
+               data->fan1_max = 
i2c_smbus_read_byte_data(client,AMC6821_REG_TACH_HLIMITL);
+               data->fan1_max += 
i2c_smbus_read_byte_data(client,AMC6821_REG_TACH_HLIMITL+1) << 8;
+               data->fan1_div = i2c_smbus_read_byte_data(client, 
AMC6821_REG_CONF4);
+               data->fan1_div = data->fan1_div & AMC6821_CONF4_PSPR ? 4 :2;
+
+               data->pwm1_auto_point_pwm[0] = 0;
+               data->pwm1_auto_point_pwm[2] = 255;
+               data->pwm1_auto_point_pwm[1] = 
i2c_smbus_read_byte_data(client, AMC6821_REG_DCY_LOW_TEMP);
+
+               data->temp2_auto_point_temp[0] = 
data->temp1_auto_point_temp[0]=i2c_smbus_read_byte_data(client, 
AMC6821_REG_PSV_TEMP);
+               reg = i2c_smbus_read_byte_data(client, 
AMC6821_REG_LTEMP_FAN_CTRL);
+               data->temp1_auto_point_temp[1] = (reg & 0xF8) >> 1;
+               reg &= 0x07;
+               reg=0x20 >> reg;
+               if(reg>0)
+                       data->temp1_auto_point_temp[2] = 
data->temp1_auto_point_temp[1] + 
(data->pwm1_auto_point_pwm[2]-data->pwm1_auto_point_pwm[1])/reg;
+               else
+                       data->temp1_auto_point_temp[2] = 255;
+
+               reg = i2c_smbus_read_byte_data(client, 
AMC6821_REG_RTEMP_FAN_CTRL);
+               data->temp2_auto_point_temp[1] = (reg & 0xF8) >> 1;
+               reg &= 0x07;
+               reg=0x20 >> reg;
+               if(reg>0)
+                       data->temp2_auto_point_temp[2] = 
data->temp2_auto_point_temp[1] + 
(data->pwm1_auto_point_pwm[2]-data->pwm1_auto_point_pwm[1])/reg;
+               else
+                       data->temp1_auto_point_temp[2] = 255;
+
+               reg = i2c_smbus_read_byte_data(client, AMC6821_REG_CONF1);
+               reg=(reg >> 5) & 0x3;
+               switch(reg) {
+                       case 0:
+                               data->pwm1_auto_channels_temp=0;
+                               data->pwm1_enable=1;
+                               break;
+                       case 2:
+                               data->pwm1_auto_channels_temp=2;
+                               data->pwm1_enable=2;
+                               break;
+                       case 3:
+                               data->pwm1_auto_channels_temp=3;
+                               data->pwm1_enable=3;
+                               break;
+                       case 1:
+                               data->pwm1_auto_channels_temp=0;
+                               data->pwm1_enable=0;
+                               break;
+               }
+
+               data->last_updated = jiffies;
+               data->valid = 1;
+       }
+       mutex_unlock(&data->update_lock);
+       return data;
+}
+
+
+static int __init amc6821_init(void)
+{
+       return i2c_add_driver(&amc6821_driver);
+}
+
+static void __exit amc6821_exit(void)
+{
+       i2c_del_driver(&amc6821_driver);
+}
+
+module_init(amc6821_init);
+module_exit(amc6821_exit);
+
+
+MODULE_LICENSE("GPL");
+
+MODULE_AUTHOR("T. Mertelj <tomaz.mertelj@guest.arnes.si>");
+MODULE_DESCRIPTION("TI amc6821 hwmon driver");
+MODULE_SUPPORTED_DEVICE("amc6821");




***********************************************************************************
Tomaz Mertelj
E-mail: tomaz.mertelj@guest.arnes.si    Home page: 
http://optlab.ijs.si/tmertelj


Staniceva 14
1000 Ljubljana
Slovenia
***********************************************************************************



