Return-Path: <linux-kernel-owner+w=401wt.eu-S1753089AbZK3O4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089AbZK3O4f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 09:56:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbZK3O4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 09:56:34 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:32244 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302AbZK3O4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 09:56:34 -0500
X-Spam-Flag: NO
X-Spam-Score: -14.389
Message-ID: <4B13DD1A.3030103@tremplin-utc.net>
Date: Mon, 30 Nov 2009 15:56:26 +0100
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20091009 Mandriva/2.0.0.23-3mdv2010.0 (2010.0) Thunderbird/2.0.0.23 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Samu Onkalo <samu.p.onkalo@nokia.com>
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [PATCH v3 1/5] lis3: Selftest support
References: <1258622842-23129-1-git-send-email-samu.p.onkalo@nokia.com> <1258622842-23129-2-git-send-email-samu.p.onkalo@nokia.com>
In-Reply-To: <1258622842-23129-2-git-send-email-samu.p.onkalo@nokia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 19-11-09 10:27, Samu Onkalo schreef:
> Implement selftest feature as specified by chip manufacturer.
> Control: read selftest sysfs entry
> Response: "OK x y z" or "FAIL x y z"
> where x, y, and z are difference between selftest mode and normal mode.
> Test is passed when values are within acceptance limit values.
> 
> Acceptance limits are provided via platform data. See chip spesifications
> for acceptance limits. If limits are not properly set, OK / FAIL decision is
> meaningless. However, userspace application can still make decision based on
> the numeric x, y, z values.
> 
> Selftest is meant for HW diagnostic purposes. It is not meant to be called
> during normal use of the chip. It may cause false interrupt events.
> Selftest mode delays polling of the normal results but it doesn't cause
> wrong values. Chip must be in static state during selftest.
> Any acceration during the test causes most probably failure.
This patch looks good to me, but please add the info of this changelog
into the documentation (in patch 4). If users have to start digging into
the git changelog to find out what does a feature, we are nasty ;-)

Signed-off-by: Éric Piel <eric.piel@tremplin-utc.net>

> 
> Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
> ---
>  drivers/hwmon/lis3lv02d.c |   72 ++++++++++++++++++++++++++++++++++++++++++++-
>  drivers/hwmon/lis3lv02d.h |   14 +++++++-
>  include/linux/lis3lv02d.h |    3 ++
>  3 files changed, 86 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/hwmon/lis3lv02d.c b/drivers/hwmon/lis3lv02d.c
> index 39b9ac8..69314f9 100644
> --- a/drivers/hwmon/lis3lv02d.c
> +++ b/drivers/hwmon/lis3lv02d.c
> @@ -106,9 +106,11 @@ static void lis3lv02d_get_xyz(struct lis3lv02d *lis3, int *x, int *y, int *z)
>  {
>  	int position[3];
>  
> +	mutex_lock(&lis3->mutex);
>  	position[0] = lis3->read_data(lis3, OUTX);
>  	position[1] = lis3->read_data(lis3, OUTY);
>  	position[2] = lis3->read_data(lis3, OUTZ);
> +	mutex_unlock(&lis3->mutex);
>  
>  	*x = lis3lv02d_get_axis(lis3->ac.x, position);
>  	*y = lis3lv02d_get_axis(lis3->ac.y, position);
> @@ -133,6 +135,60 @@ static int lis3lv02d_get_odr(void)
>  	return val;
>  }
>  
> +static int lis3lv02d_selftest(struct lis3lv02d *lis3, s16 results[3])
> +{
> +	u8 reg;
> +	s16 x, y, z;
> +	u8 selftest;
> +	int ret;
> +
> +	mutex_lock(&lis3->mutex);
> +	if (lis3_dev.whoami == WAI_12B)
> +		selftest = CTRL1_ST;
> +	else
> +		selftest = CTRL1_STP;
> +
> +	lis3->read(lis3, CTRL_REG1, &reg);
> +	lis3->write(lis3, CTRL_REG1, (reg | selftest));
> +	msleep(lis3->pwron_delay / lis3lv02d_get_odr());
> +
> +	/* Read directly to avoid axis remap */
> +	x = lis3->read_data(lis3, OUTX);
> +	y = lis3->read_data(lis3, OUTY);
> +	z = lis3->read_data(lis3, OUTZ);
> +
> +	/* back to normal settings */
> +	lis3->write(lis3, CTRL_REG1, reg);
> +	msleep(lis3->pwron_delay / lis3lv02d_get_odr());
> +
> +	results[0] = x - lis3->read_data(lis3, OUTX);
> +	results[1] = y - lis3->read_data(lis3, OUTY);
> +	results[2] = z - lis3->read_data(lis3, OUTZ);
> +
> +	ret = 0;
> +	if (lis3->pdata) {
> +		int i;
> +		for (i = 0; i < 3; i++) {
> +			/* Check minimum acceptance limits */
> +			if (results[i] < lis3->pdata->st_min_limits[i]) {
> +				ret = -EIO;
> +				goto fail;
> +			}
> +
> +			/* Check maximum acceptance limits */
> +			if (results[i] > lis3->pdata->st_max_limits[i]) {
> +				ret = -EIO;
> +				goto fail;
> +			}
> +		}
> +	}
> +
> +	/* test passed */
> +fail:
> +	mutex_unlock(&lis3->mutex);
> +	return ret;
> +}
> +
>  void lis3lv02d_poweroff(struct lis3lv02d *lis3)
>  {
>  	/* disable X,Y,Z axis and power down */
> @@ -365,6 +421,17 @@ void lis3lv02d_joystick_disable(void)
>  EXPORT_SYMBOL_GPL(lis3lv02d_joystick_disable);
>  
>  /* Sysfs stuff */
> +static ssize_t lis3lv02d_selftest_show(struct device *dev,
> +				struct device_attribute *attr, char *buf)
> +{
> +	int result;
> +	s16 values[3];
> +
> +	result = lis3lv02d_selftest(&lis3_dev, values);
> +	return sprintf(buf, "%s %d %d %d\n", result == 0 ? "OK" : "FAIL",
> +		values[0], values[1], values[2]);
> +}
> +
>  static ssize_t lis3lv02d_position_show(struct device *dev,
>  				struct device_attribute *attr, char *buf)
>  {
> @@ -394,12 +461,14 @@ static ssize_t lis3lv02d_rate_show(struct device *dev,
>  	return sprintf(buf, "%d\n", lis3lv02d_get_odr());
>  }
>  
> +static DEVICE_ATTR(selftest, S_IRUSR, lis3lv02d_selftest_show, NULL);
>  static DEVICE_ATTR(position, S_IRUGO, lis3lv02d_position_show, NULL);
>  static DEVICE_ATTR(calibrate, S_IRUGO|S_IWUSR, lis3lv02d_calibrate_show,
>  	lis3lv02d_calibrate_store);
>  static DEVICE_ATTR(rate, S_IRUGO, lis3lv02d_rate_show, NULL);
>  
>  static struct attribute *lis3lv02d_attributes[] = {
> +	&dev_attr_selftest.attr,
>  	&dev_attr_position.attr,
>  	&dev_attr_calibrate.attr,
>  	&dev_attr_rate.attr,
> @@ -455,6 +524,8 @@ int lis3lv02d_init_device(struct lis3lv02d *dev)
>  		return -EINVAL;
>  	}
>  
> +	mutex_init(&dev->mutex);
> +
>  	lis3lv02d_add_fs(dev);
>  	lis3lv02d_poweron(dev);
>  
> @@ -507,4 +578,3 @@ EXPORT_SYMBOL_GPL(lis3lv02d_init_device);
>  MODULE_DESCRIPTION("ST LIS3LV02Dx three-axis digital accelerometer driver");
>  MODULE_AUTHOR("Yan Burman, Eric Piel, Pavel Machek");
>  MODULE_LICENSE("GPL");
> -
> diff --git a/drivers/hwmon/lis3lv02d.h b/drivers/hwmon/lis3lv02d.h
> index c57f21f..166794c 100644
> --- a/drivers/hwmon/lis3lv02d.h
> +++ b/drivers/hwmon/lis3lv02d.h
> @@ -98,7 +98,7 @@ enum lis3_who_am_i {
>  	WAI_6B		= 0x52, /* 6 bits: LIS331DLF - not supported */
>  };
>  
> -enum lis3lv02d_ctrl1 {
> +enum lis3lv02d_ctrl1_12b {
>  	CTRL1_Xen	= 0x01,
>  	CTRL1_Yen	= 0x02,
>  	CTRL1_Zen	= 0x04,
> @@ -107,8 +107,17 @@ enum lis3lv02d_ctrl1 {
>  	CTRL1_DF1	= 0x20,
>  	CTRL1_PD0	= 0x40,
>  	CTRL1_PD1	= 0x80,
> -	CTRL1_DR	= 0x80, /* Data rate on 8 bits */
>  };
> +
> +/* Delta to ctrl1_12b version */
> +enum lis3lv02d_ctrl1_8b {
> +	CTRL1_STM	= 0x08,
> +	CTRL1_STP	= 0x10,
> +	CTRL1_FS	= 0x20,
> +	CTRL1_PD	= 0x40,
> +	CTRL1_DR	= 0x80,
> +};
> +
>  enum lis3lv02d_ctrl2 {
>  	CTRL2_DAS	= 0x01,
>  	CTRL2_SIM	= 0x02,
> @@ -218,6 +227,7 @@ struct lis3lv02d {
>  	unsigned long		misc_opened; /* bit0: whether the device is open */
>  
>  	struct lis3lv02d_platform_data *pdata;	/* for passing board config */
> +	struct mutex		mutex;     /* Serialize poll and selftest */
>  };
>  
>  int lis3lv02d_init_device(struct lis3lv02d *lis3);
> diff --git a/include/linux/lis3lv02d.h b/include/linux/lis3lv02d.h
> index 8970135..f1ca0dc 100644
> --- a/include/linux/lis3lv02d.h
> +++ b/include/linux/lis3lv02d.h
> @@ -55,6 +55,9 @@ struct lis3lv02d_platform_data {
>  	s8 axis_z;
>  	int (*setup_resources)(void);
>  	int (*release_resources)(void);
> +	/* Limits for selftest are specified in chip data sheet */
> +	s16 st_min_limits[3]; /* min pass limit x, y, z */
> +	s16 st_max_limits[3]; /* max pass limit x, y, z */
>  };
>  
>  #endif /* __LIS3LV02D_H_ */

