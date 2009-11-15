Return-Path: <linux-kernel-owner+w=401wt.eu-S1753250AbZKOPyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbZKOPyS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 10:54:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753234AbZKOPyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 10:54:18 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:24671 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127AbZKOPyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 10:54:17 -0500
X-Spam-Flag: NO
X-Spam-Score: -12.589
Message-ID: <4B00242D.1050704@tremplin-utc.net>
Date: Sun, 15 Nov 2009 16:54:21 +0100
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20091009 Mandriva/2.0.0.23-3mdv2010.0 (2010.0) Thunderbird/2.0.0.23 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Samu Onkalo <samu.p.onkalo@nokia.com>
Cc: daniel@caiaq.de, pavel@ucw.cz, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [PATCH v2 07/10] LIS3LV02D: Remove calibaration functionality
References: <1257856872-11612-1-git-send-email-samu.p.onkalo@nokia.com> <1257856872-11612-2-git-send-email-samu.p.onkalo@nokia.com> <1257856872-11612-3-git-send-email-samu.p.onkalo@nokia.com> <1257856872-11612-4-git-send-email-samu.p.onkalo@nokia.com> <1257856872-11612-5-git-send-email-samu.p.onkalo@nokia.com> <1257856872-11612-6-git-send-email-samu.p.onkalo@nokia.com> <1257856872-11612-7-git-send-email-samu.p.onkalo@nokia.com> <1257856872-11612-8-git-send-email-samu.p.onkalo@nokia.com>
In-Reply-To: <1257856872-11612-8-git-send-email-samu.p.onkalo@nokia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 10-11-09 13:41, Samu Onkalo schreef:
> Chip is calibrated by the manufacturer. There is no need to calibarate
> it at driver level. If the chip is used as a joystick, calibaration can
> be done using joystick device calibration mechanism.
> 
> Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
Acked-by: Éric Piel <eric.piel@tremplin-utc.net>
> ---
>  drivers/hwmon/lis3lv02d.c |   32 +++-----------------------------
>  drivers/hwmon/lis3lv02d.h |    3 ---
>  2 files changed, 3 insertions(+), 32 deletions(-)
> 
> diff --git a/drivers/hwmon/lis3lv02d.c b/drivers/hwmon/lis3lv02d.c
> index 0335b36..5b39257 100644
> --- a/drivers/hwmon/lis3lv02d.c
> +++ b/drivers/hwmon/lis3lv02d.c
> @@ -344,19 +344,12 @@ static void lis3lv02d_joystick_poll(struct input_polled_dev *pidev)
>  	int x, y, z;
>  
>  	lis3lv02d_get_xyz(&lis3_dev, &x, &y, &z);
> -	input_report_abs(pidev->input, ABS_X, x - lis3_dev.xcalib);
> -	input_report_abs(pidev->input, ABS_Y, y - lis3_dev.ycalib);
> -	input_report_abs(pidev->input, ABS_Z, z - lis3_dev.zcalib);
> +	input_report_abs(pidev->input, ABS_X, x);
> +	input_report_abs(pidev->input, ABS_Y, y);
> +	input_report_abs(pidev->input, ABS_Z, z);
>  	input_sync(pidev->input);
>  }
>  
> -
> -static inline void lis3lv02d_calibrate_joystick(void)
> -{
> -	lis3lv02d_get_xyz(&lis3_dev,
> -		&lis3_dev.xcalib, &lis3_dev.ycalib, &lis3_dev.zcalib);
> -}
> -
>  int lis3lv02d_joystick_enable(void)
>  {
>  	struct input_dev *input_dev;
> @@ -373,8 +366,6 @@ int lis3lv02d_joystick_enable(void)
>  	lis3_dev.idev->poll_interval = MDPS_POLL_INTERVAL;
>  	input_dev = lis3_dev.idev->input;
>  
> -	lis3lv02d_calibrate_joystick();
> -
>  	input_dev->name       = "ST LIS3LV02DL Accelerometer";
>  	input_dev->phys       = DRIVER_NAME "/input0";
>  	input_dev->id.bustype = BUS_HOST;
> @@ -430,20 +421,6 @@ static ssize_t lis3lv02d_position_show(struct device *dev,
>  	return sprintf(buf, "(%d,%d,%d)\n", x, y, z);
>  }
>  
> -static ssize_t lis3lv02d_calibrate_show(struct device *dev,
> -				struct device_attribute *attr, char *buf)
> -{
> -	return sprintf(buf, "(%d,%d,%d)\n", lis3_dev.xcalib, lis3_dev.ycalib, lis3_dev.zcalib);
> -}
> -
> -static ssize_t lis3lv02d_calibrate_store(struct device *dev,
> -				struct device_attribute *attr,
> -				const char *buf, size_t count)
> -{
> -	lis3lv02d_calibrate_joystick();
> -	return count;
> -}
> -
>  static ssize_t lis3lv02d_rate_show(struct device *dev,
>  			struct device_attribute *attr, char *buf)
>  {
> @@ -452,14 +429,11 @@ static ssize_t lis3lv02d_rate_show(struct device *dev,
>  
>  static DEVICE_ATTR(selftest, S_IRUGO, lis3lv02d_selftest_show, NULL);
>  static DEVICE_ATTR(position, S_IRUGO, lis3lv02d_position_show, NULL);
> -static DEVICE_ATTR(calibrate, S_IRUGO|S_IWUSR, lis3lv02d_calibrate_show,
> -	lis3lv02d_calibrate_store);
>  static DEVICE_ATTR(rate, S_IRUGO, lis3lv02d_rate_show, NULL);
>  
>  static struct attribute *lis3lv02d_attributes[] = {
>  	&dev_attr_selftest.attr,
>  	&dev_attr_position.attr,
> -	&dev_attr_calibrate.attr,
>  	&dev_attr_rate.attr,
>  	NULL
>  };
> diff --git a/drivers/hwmon/lis3lv02d.h b/drivers/hwmon/lis3lv02d.h
> index 655875e..a692116 100644
> --- a/drivers/hwmon/lis3lv02d.h
> +++ b/drivers/hwmon/lis3lv02d.h
> @@ -216,9 +216,6 @@ struct lis3lv02d {
>  	struct input_polled_dev	*idev;     /* input device */
>  	struct platform_device	*pdev;     /* platform device */
>  	atomic_t		count;     /* interrupt count after last read */
> -	int			xcalib;    /* calibrated null value for x */
> -	int			ycalib;    /* calibrated null value for y */
> -	int			zcalib;    /* calibrated null value for z */
>  	struct axis_conversion	ac;        /* hw -> logical axis */
>  
>  	u32			irq;       /* IRQ number */

