Return-Path: <linux-kernel-owner+w=401wt.eu-S1756409AbXLSOk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409AbXLSOk1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 09:40:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753264AbXLSOkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 09:40:18 -0500
Received: from smtp-103-wednesday.nerim.net ([62.4.16.103]:49813 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753365AbXLSOkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 09:40:16 -0500
Date: Wed, 19 Dec 2007 15:40:12 +0100
From: Jean Delvare <khali@linux-fr.org>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: lm-sensors <lm-sensors@lm-sensors.org>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] adt7470: Support per-sensor alarm files
Message-ID: <20071219154012.18302de5@hyperion.delvare>
In-Reply-To: <20071219040123.GN6870@tree.beaverton.ibm.com>
References: <20071219040123.GN6870@tree.beaverton.ibm.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Darrick,

On Tue, 18 Dec 2007 20:01:23 -0800, Darrick J. Wong wrote:
> Remove the old alarms sysfs hack and replace it with per-sensor alarm files.
> Also don't read the second alarm register if it's not needed.

Thanks for doing this, I appreciate it. There are so many drivers left
to convert...

In general we keep the all-in-one alarms file for compatibility, but
given that this driver is fairly new and libsensors never had specific
support for it anyway, it's probably OK to drop it this time.

> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> ---
> 
>  drivers/hwmon/adt7470.c |   97 ++++++++++++++++++++++++++++++++++++++++++-----
>  1 files changed, 86 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/hwmon/adt7470.c b/drivers/hwmon/adt7470.c
> index a215560..59ba7e5 100644
> --- a/drivers/hwmon/adt7470.c
> +++ b/drivers/hwmon/adt7470.c
> @@ -48,7 +48,22 @@ I2C_CLIENT_INSMOD_1(adt7470);
>  #define ADT7470_REG_CFG				0x40
>  #define		ADT7470_FSPD_MASK		0x04
>  #define ADT7470_REG_ALARM1			0x41
> +#define		ADT7470_R1T_ALARM		0x01
> +#define		ADT7470_R2T_ALARM		0x02
> +#define		ADT7470_R3T_ALARM		0x04
> +#define		ADT7470_R4T_ALARM		0x08
> +#define		ADT7470_R5T_ALARM		0x10
> +#define		ADT7470_R6T_ALARM		0x20
> +#define		ADT7470_R7T_ALARM		0x40
> +#define		ADT7470_OOL_ALARM		0x80
>  #define ADT7470_REG_ALARM2			0x42
> +#define		ADT7470_R8T_ALARM		0x01
> +#define		ADT7470_R9T_ALARM		0x02
> +#define		ADT7470_R10T_ALARM		0x04
> +#define		ADT7470_FAN1_ALARM		0x10
> +#define		ADT7470_FAN2_ALARM		0x20
> +#define		ADT7470_FAN3_ALARM		0x40
> +#define		ADT7470_FAN4_ALARM		0x80
>  #define ADT7470_REG_TEMP_LIMITS_BASE_ADDR	0x44
>  #define ADT7470_REG_TEMP_LIMITS_MAX_ADDR	0x57
>  #define ADT7470_REG_FAN_MIN_BASE_ADDR		0x58
> @@ -97,6 +112,8 @@ I2C_CLIENT_INSMOD_1(adt7470);
>  #define ADT7470_REG_PWM_AUTO_TEMP(x)	(ADT7470_REG_PWM_AUTO_TEMP_BASE_ADDR + \
>  					((x) / 2))
>  
> +#define ALARM2(x)		((x) << 8)
> +
>  #define ADT7470_VENDOR		0x41
>  #define ADT7470_DEVICE		0x70
>  /* datasheet only mentions a revision 2 */
> @@ -136,7 +153,8 @@ struct adt7470_data {
>  	u16			fan[ADT7470_FAN_COUNT];
>  	u16			fan_min[ADT7470_FAN_COUNT];
>  	u16			fan_max[ADT7470_FAN_COUNT];
> -	u16			alarms, alarms_mask;
> +	u8			alarm1, alarm2;
> +	u16			alarms_mask;

I don't think that you win anything by splitting the alarm field. In
fact it makes your code more complex than it needs to be. When
converting the other drivers, I've always kept a single field for the
alarms.

>  	u8			force_pwm_max;
>  	u8			pwm[ADT7470_PWM_COUNT];
>  	u8			pwm_max[ADT7470_PWM_COUNT];
> @@ -260,7 +278,12 @@ static struct adt7470_data *adt7470_update_device(struct device *dev)
>  	else
>  		data->force_pwm_max = 0;
>  
> -	data->alarms = adt7470_read_word_data(client, ADT7470_REG_ALARM1);
> +	data->alarm1 = i2c_smbus_read_byte_data(client, ADT7470_REG_ALARM1);
> +	if (data->alarm2 & ADT7470_OOL_ALARM)

You certainly mean data->alarm1.

> +		data->alarm2 = i2c_smbus_read_byte_data(client,
> +							ADT7470_REG_ALARM2);
> +	else
> +		data->alarm2 = 0;
>  	data->alarms_mask = adt7470_read_word_data(client,
>  						   ADT7470_REG_ALARM1_MASK);
>  
> @@ -368,17 +391,13 @@ static ssize_t show_temp(struct device *dev, struct device_attribute *devattr,
>  	return sprintf(buf, "%d\n", 1000 * data->temp[attr->index]);
>  }
>  
> -static ssize_t show_alarms(struct device *dev,
> +static ssize_t show_alarm_mask(struct device *dev,
>  			   struct device_attribute *devattr,
>  			   char *buf)
>  {
> -	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
>  	struct adt7470_data *data = adt7470_update_device(dev);
>  
> -	if (attr->index)
> -		return sprintf(buf, "%x\n", data->alarms);
> -	else
> -		return sprintf(buf, "%x\n", data->alarms_mask);
> +	return sprintf(buf, "%x\n", data->alarms_mask);
>  }
>  
>  static ssize_t show_fan_max(struct device *dev,
> @@ -713,8 +732,21 @@ static ssize_t set_pwm_auto_temp(struct device *dev,
>  	return count;
>  }
>  
> -static SENSOR_DEVICE_ATTR(alarms, S_IRUGO, show_alarms, NULL, 0);
> -static SENSOR_DEVICE_ATTR(alarm_mask, S_IRUGO, show_alarms, NULL, 1);
> +static ssize_t show_alarm(struct device *dev,
> +			  struct device_attribute *devattr,
> +			  char *buf)
> +{
> +	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
> +	struct adt7470_data *data = adt7470_update_device(dev);
> +
> +	if (data->alarm1 & (attr->index & 0xFF) ||
> +	    data->alarm2 & (attr->index >> 8))

That's a complex way to write it... It would be more simple with a
16-bit data->alarm field. Please see the lm83 driver for an example.

> +		return sprintf(buf, "1\n");
> +	else
> +		return sprintf(buf, "0\n");
> +}
> +
> +static SENSOR_DEVICE_ATTR(alarm_mask, S_IRUGO, show_alarm_mask, NULL, 0);

Note that this could become a simple DEVICE_ATTR now.

>  
>  static SENSOR_DEVICE_ATTR(temp1_max, S_IWUSR | S_IRUGO, show_temp_max,
>  		    set_temp_max, 0);
> @@ -769,6 +801,27 @@ static SENSOR_DEVICE_ATTR(temp8_input, S_IRUGO, show_temp, NULL, 7);
>  static SENSOR_DEVICE_ATTR(temp9_input, S_IRUGO, show_temp, NULL, 8);
>  static SENSOR_DEVICE_ATTR(temp10_input, S_IRUGO, show_temp, NULL, 9);
>  
> +static SENSOR_DEVICE_ATTR(temp1_alarm, S_IRUGO, show_alarm, NULL,
> +			  ADT7470_R1T_ALARM);
> +static SENSOR_DEVICE_ATTR(temp2_alarm, S_IRUGO, show_alarm, NULL,
> +			  ADT7470_R2T_ALARM);
> +static SENSOR_DEVICE_ATTR(temp3_alarm, S_IRUGO, show_alarm, NULL,
> +			  ADT7470_R3T_ALARM);
> +static SENSOR_DEVICE_ATTR(temp4_alarm, S_IRUGO, show_alarm, NULL,
> +			  ADT7470_R4T_ALARM);
> +static SENSOR_DEVICE_ATTR(temp5_alarm, S_IRUGO, show_alarm, NULL,
> +			  ADT7470_R5T_ALARM);
> +static SENSOR_DEVICE_ATTR(temp6_alarm, S_IRUGO, show_alarm, NULL,
> +			  ADT7470_R6T_ALARM);
> +static SENSOR_DEVICE_ATTR(temp7_alarm, S_IRUGO, show_alarm, NULL,
> +			  ADT7470_R7T_ALARM);
> +static SENSOR_DEVICE_ATTR(temp8_alarm, S_IRUGO, show_alarm, NULL,
> +			  ADT7470_R8T_ALARM);
> +static SENSOR_DEVICE_ATTR(temp9_alarm, S_IRUGO, show_alarm, NULL,
> +			  ADT7470_R9T_ALARM);
> +static SENSOR_DEVICE_ATTR(temp10_alarm, S_IRUGO, show_alarm, NULL,
> +			  ADT7470_R10T_ALARM);

Missing ALARM2() for temp8, temp9 and temp10.

> +
>  static SENSOR_DEVICE_ATTR(fan1_max, S_IWUSR | S_IRUGO, show_fan_max,
>  		    set_fan_max, 0);
>  static SENSOR_DEVICE_ATTR(fan2_max, S_IWUSR | S_IRUGO, show_fan_max,
> @@ -792,6 +845,15 @@ static SENSOR_DEVICE_ATTR(fan2_input, S_IRUGO, show_fan, NULL, 1);
>  static SENSOR_DEVICE_ATTR(fan3_input, S_IRUGO, show_fan, NULL, 2);
>  static SENSOR_DEVICE_ATTR(fan4_input, S_IRUGO, show_fan, NULL, 3);
>  
> +static SENSOR_DEVICE_ATTR(fan1_alarm, S_IRUGO, show_alarm, NULL,
> +			  ALARM2(ADT7470_FAN1_ALARM));
> +static SENSOR_DEVICE_ATTR(fan2_alarm, S_IRUGO, show_alarm, NULL,
> +			  ALARM2(ADT7470_FAN2_ALARM));
> +static SENSOR_DEVICE_ATTR(fan3_alarm, S_IRUGO, show_alarm, NULL,
> +			  ALARM2(ADT7470_FAN3_ALARM));
> +static SENSOR_DEVICE_ATTR(fan4_alarm, S_IRUGO, show_alarm, NULL,
> +			  ALARM2(ADT7470_FAN4_ALARM));
> +
>  static SENSOR_DEVICE_ATTR(force_pwm_max, S_IWUSR | S_IRUGO,
>  		    show_force_pwm_max, set_force_pwm_max, 0);
>  
> @@ -856,7 +918,6 @@ static SENSOR_DEVICE_ATTR(pwm4_auto_channels_temp, S_IWUSR | S_IRUGO,
>  
>  static struct attribute *adt7470_attr[] =
>  {
> -	&sensor_dev_attr_alarms.dev_attr.attr,
>  	&sensor_dev_attr_alarm_mask.dev_attr.attr,
>  	&sensor_dev_attr_temp1_max.dev_attr.attr,
>  	&sensor_dev_attr_temp2_max.dev_attr.attr,
> @@ -888,6 +949,16 @@ static struct attribute *adt7470_attr[] =
>  	&sensor_dev_attr_temp8_input.dev_attr.attr,
>  	&sensor_dev_attr_temp9_input.dev_attr.attr,
>  	&sensor_dev_attr_temp10_input.dev_attr.attr,
> +	&sensor_dev_attr_temp1_alarm.dev_attr.attr,
> +	&sensor_dev_attr_temp2_alarm.dev_attr.attr,
> +	&sensor_dev_attr_temp3_alarm.dev_attr.attr,
> +	&sensor_dev_attr_temp4_alarm.dev_attr.attr,
> +	&sensor_dev_attr_temp5_alarm.dev_attr.attr,
> +	&sensor_dev_attr_temp6_alarm.dev_attr.attr,
> +	&sensor_dev_attr_temp7_alarm.dev_attr.attr,
> +	&sensor_dev_attr_temp8_alarm.dev_attr.attr,
> +	&sensor_dev_attr_temp9_alarm.dev_attr.attr,
> +	&sensor_dev_attr_temp10_alarm.dev_attr.attr,
>  	&sensor_dev_attr_fan1_max.dev_attr.attr,
>  	&sensor_dev_attr_fan2_max.dev_attr.attr,
>  	&sensor_dev_attr_fan3_max.dev_attr.attr,
> @@ -900,6 +971,10 @@ static struct attribute *adt7470_attr[] =
>  	&sensor_dev_attr_fan2_input.dev_attr.attr,
>  	&sensor_dev_attr_fan3_input.dev_attr.attr,
>  	&sensor_dev_attr_fan4_input.dev_attr.attr,
> +	&sensor_dev_attr_fan1_alarm.dev_attr.attr,
> +	&sensor_dev_attr_fan2_alarm.dev_attr.attr,
> +	&sensor_dev_attr_fan3_alarm.dev_attr.attr,
> +	&sensor_dev_attr_fan4_alarm.dev_attr.attr,
>  	&sensor_dev_attr_force_pwm_max.dev_attr.attr,
>  	&sensor_dev_attr_pwm1.dev_attr.attr,
>  	&sensor_dev_attr_pwm2.dev_attr.attr,


-- 
Jean Delvare
