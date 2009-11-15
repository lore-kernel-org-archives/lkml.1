Return-Path: <linux-kernel-owner+w=401wt.eu-S1752886AbZKOPJE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886AbZKOPJE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 10:09:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752734AbZKOPJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 10:09:04 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:15771 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698AbZKOPJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 10:09:03 -0500
X-Spam-Flag: NO
X-Spam-Score: -12.589
Message-ID: <4B001985.3020204@tremplin-utc.net>
Date: Sun, 15 Nov 2009 16:08:53 +0100
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20091009 Mandriva/2.0.0.23-3mdv2010.0 (2010.0) Thunderbird/2.0.0.23 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Samu Onkalo <samu.p.onkalo@nokia.com>
Cc: daniel@caiaq.de, pavel@ucw.cz, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [PATCH v2 06/10] LIS3LV02D: Selftest support
References: <1257856872-11612-1-git-send-email-samu.p.onkalo@nokia.com> <1257856872-11612-2-git-send-email-samu.p.onkalo@nokia.com> <1257856872-11612-3-git-send-email-samu.p.onkalo@nokia.com> <1257856872-11612-4-git-send-email-samu.p.onkalo@nokia.com> <1257856872-11612-5-git-send-email-samu.p.onkalo@nokia.com> <1257856872-11612-6-git-send-email-samu.p.onkalo@nokia.com> <1257856872-11612-7-git-send-email-samu.p.onkalo@nokia.com>
In-Reply-To: <1257856872-11612-7-git-send-email-samu.p.onkalo@nokia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 10-11-09 13:41, Samu Onkalo schreef:
> Selftest as specified by chip manufacturer.
> Controlled via sysfs. Response is OK / FAIL with measurement data for
> each axes. test acceptance limits are set using platform data.
A few remarks:
 * It's not clear what's the effect of doing it while using the sensor
at the same time. I've just tried, and it seems the sensor recovers,
although it returns wrong values during the selftest. So it would be
better to make it accessible by only root: change S_IRUGO to S_IRUSR.
 * The documentation is not clear enough why I would need to run it, how
often, what are the values displayed, and what are those platform data
limit supposed to be. Please, make this more clear. (Actually the
documentation is an other patch, but it makes more sense to talk about
this here, although it's ok to leave it in another patch)

Eric

> 
> Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
> ---
>  drivers/hwmon/lis3lv02d.c |   59 ++++++++++++++++++++++++++++++++++++++++++++-
>  drivers/hwmon/lis3lv02d.h |   13 ++++++++-
>  include/linux/lis3lv02d.h |    2 +
>  3 files changed, 71 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/hwmon/lis3lv02d.c b/drivers/hwmon/lis3lv02d.c
> index 39b9ac8..0335b36 100644
> --- a/drivers/hwmon/lis3lv02d.c
> +++ b/drivers/hwmon/lis3lv02d.c
> @@ -133,6 +133,51 @@ static int lis3lv02d_get_odr(void)
>  	return val;
>  }
>  
> +static int lis3lv02d_selftest(struct lis3lv02d *lis3, s16 results[3])
> +{
> +	u8 reg;
> +	s16 x, y, z;
> +	u8 selftest;
> +
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
> +	if (lis3->pdata) {
> +		int i;
> +		for (i = 0; i < 3; i++) {
> +			/* Check minimum acceptance limits */
> +			if (results[i] < lis3->pdata->selftest_min_limits[i])
> +				return -1;
> +
> +			/* Check maximum acceptance limits */
> +			if (results[i] > lis3->pdata->selftest_max_limits[i])
> +				return -1;
> +		}
> +	}
> +
> +	/* test passed */
> +	return 0;
> +}
> +
>  void lis3lv02d_poweroff(struct lis3lv02d *lis3)
>  {
>  	/* disable X,Y,Z axis and power down */
> @@ -365,6 +410,17 @@ void lis3lv02d_joystick_disable(void)
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
> @@ -394,12 +450,14 @@ static ssize_t lis3lv02d_rate_show(struct device *dev,
>  	return sprintf(buf, "%d\n", lis3lv02d_get_odr());
>  }
>  
> +static DEVICE_ATTR(selftest, S_IRUGO, lis3lv02d_selftest_show, NULL);
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
> @@ -507,4 +565,3 @@ EXPORT_SYMBOL_GPL(lis3lv02d_init_device);
>  MODULE_DESCRIPTION("ST LIS3LV02Dx three-axis digital accelerometer driver");
>  MODULE_AUTHOR("Yan Burman, Eric Piel, Pavel Machek");
>  MODULE_LICENSE("GPL");
> -
> diff --git a/drivers/hwmon/lis3lv02d.h b/drivers/hwmon/lis3lv02d.h
> index c57f21f..655875e 100644
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
> diff --git a/include/linux/lis3lv02d.h b/include/linux/lis3lv02d.h
> index 3cc2f2c..966648b 100644
> --- a/include/linux/lis3lv02d.h
> +++ b/include/linux/lis3lv02d.h
> @@ -43,6 +43,8 @@ struct lis3lv02d_platform_data {
>  #define LIS3_WAKEUP_Z_HI	(1 << 5)
>  	unsigned char wakeup_flags;
>  	unsigned char wakeup_thresh;
> +	s16 selftest_min_limits[3]; /* x, y, z */
> +	s16 selftest_max_limits[3]; /* x, y, z */
>  };
>  
>  #endif /* __LIS3LV02D_H_ */

