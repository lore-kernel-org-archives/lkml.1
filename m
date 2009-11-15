Return-Path: <linux-kernel-owner+w=401wt.eu-S1753228AbZKOPyF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228AbZKOPyF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 10:54:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753063AbZKOPyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 10:54:04 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:2179 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759AbZKOPyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 10:54:02 -0500
X-Spam-Flag: NO
X-Spam-Score: -12.589
Message-ID: <4B00241E.5080003@tremplin-utc.net>
Date: Sun, 15 Nov 2009 16:54:06 +0100
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20091009 Mandriva/2.0.0.23-3mdv2010.0 (2010.0) Thunderbird/2.0.0.23 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Samu Onkalo <samu.p.onkalo@nokia.com>
Cc: daniel@caiaq.de, pavel@ucw.cz, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [PATCH v2 05/10] LIS3LV02D: Proper power on sequence
References: <1257856872-11612-1-git-send-email-samu.p.onkalo@nokia.com> <1257856872-11612-2-git-send-email-samu.p.onkalo@nokia.com> <1257856872-11612-3-git-send-email-samu.p.onkalo@nokia.com> <1257856872-11612-4-git-send-email-samu.p.onkalo@nokia.com> <1257856872-11612-5-git-send-email-samu.p.onkalo@nokia.com> <1257856872-11612-6-git-send-email-samu.p.onkalo@nokia.com>
In-Reply-To: <1257856872-11612-6-git-send-email-samu.p.onkalo@nokia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 10-11-09 13:41, Samu Onkalo schreef:
> Lis3 accelerometer sensors have quite long power on delay (up to 125
> ms). This patch adds necessary delay to power on sequence for currently
> supported lis3 chips.
> 
> Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
Acked-by: Éric Piel <eric.piel@tremplin-utc.net>
> ---
>  drivers/hwmon/lis3lv02d.c |   41 +++++++++++++++++++++++++++--------------
>  drivers/hwmon/lis3lv02d.h |    1 +
>  2 files changed, 28 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/hwmon/lis3lv02d.c b/drivers/hwmon/lis3lv02d.c
> index b12ee35..39b9ac8 100644
> --- a/drivers/hwmon/lis3lv02d.c
> +++ b/drivers/hwmon/lis3lv02d.c
> @@ -50,6 +50,9 @@
>   * joystick.
>   */
>  
> +#define LIS3_PWRON_DELAY_WAI_12B	(5000)
> +#define LIS3_PWRON_DELAY_WAI_8B		(3000)
> +
>  struct lis3lv02d lis3_dev = {
>  	.misc_wait   = __WAIT_QUEUE_HEAD_INITIALIZER(lis3_dev.misc_wait),
>  };
> @@ -112,6 +115,24 @@ static void lis3lv02d_get_xyz(struct lis3lv02d *lis3, int *x, int *y, int *z)
>  	*z = lis3lv02d_get_axis(lis3->ac.z, position);
>  }
>  
> +/* conversion btw sampling rate and the register values */
> +static int lis3_12_rates[4] = {40, 160, 640, 2560};
> +static int lis3_8_rates[2] = {100, 400};
> +
> +static int lis3lv02d_get_odr(void)
> +{
> +	u8 ctrl;
> +	int val;
> +
> +	lis3_dev.read(&lis3_dev, CTRL_REG1, &ctrl);
> +
> +	if (lis3_dev.whoami == WAI_12B)
> +		val = lis3_12_rates[(ctrl & (CTRL1_DF0 | CTRL1_DF1)) >> 4];
> +	else
> +		val = lis3_8_rates[(ctrl & CTRL1_DR) >> 7];
> +	return val;
> +}
> +
>  void lis3lv02d_poweroff(struct lis3lv02d *lis3)
>  {
>  	/* disable X,Y,Z axis and power down */
> @@ -125,6 +146,9 @@ void lis3lv02d_poweron(struct lis3lv02d *lis3)
>  
>  	lis3->init(lis3);
>  
> +	/* LIS3 power on delay is quite long */
> +	msleep(lis3->pwron_delay / lis3lv02d_get_odr());
> +
>  	/*
>  	 * Common configuration
>  	 * BDU: (12 bits sensors only) LSB and MSB values are not updated until
> @@ -364,23 +388,10 @@ static ssize_t lis3lv02d_calibrate_store(struct device *dev,
>  	return count;
>  }
>  
> -/* conversion btw sampling rate and the register values */
> -static int lis3_12_rates[4] = {40, 160, 640, 2560};
> -static int lis3_8_rates[2] = {100, 400};
>  static ssize_t lis3lv02d_rate_show(struct device *dev,
>  			struct device_attribute *attr, char *buf)
>  {
> -	u8 ctrl;
> -	int val;
> -
> -	lis3_dev.read(&lis3_dev, CTRL_REG1, &ctrl);
> -
> -	if (lis3_dev.whoami == WAI_12B)
> -		val = lis3_12_rates[(ctrl & (CTRL1_DF0 | CTRL1_DF1)) >> 4];
> -	else
> -		val = lis3_8_rates[(ctrl & CTRL1_DR) >> 7];
> -
> -	return sprintf(buf, "%d\n", val);
> +	return sprintf(buf, "%d\n", lis3lv02d_get_odr());
>  }
>  
>  static DEVICE_ATTR(position, S_IRUGO, lis3lv02d_position_show, NULL);
> @@ -430,11 +441,13 @@ int lis3lv02d_init_device(struct lis3lv02d *dev)
>  		printk(KERN_INFO DRIVER_NAME ": 12 bits sensor found\n");
>  		dev->read_data = lis3lv02d_read_12;
>  		dev->mdps_max_val = 2048;
> +		dev->pwron_delay = LIS3_PWRON_DELAY_WAI_12B;
>  		break;
>  	case WAI_8B:
>  		printk(KERN_INFO DRIVER_NAME ": 8 bits sensor found\n");
>  		dev->read_data = lis3lv02d_read_8;
>  		dev->mdps_max_val = 128;
> +		dev->pwron_delay = LIS3_PWRON_DELAY_WAI_8B;
>  		break;
>  	default:
>  		printk(KERN_ERR DRIVER_NAME
> diff --git a/drivers/hwmon/lis3lv02d.h b/drivers/hwmon/lis3lv02d.h
> index c6ae507..c57f21f 100644
> --- a/drivers/hwmon/lis3lv02d.h
> +++ b/drivers/hwmon/lis3lv02d.h
> @@ -202,6 +202,7 @@ struct lis3lv02d {
>  	u8			whoami;    /* indicates measurement precision */
>  	s16 (*read_data) (struct lis3lv02d *lis3, int reg);
>  	int			mdps_max_val;
> +	int			pwron_delay;
>  
>  	struct input_polled_dev	*idev;     /* input device */
>  	struct platform_device	*pdev;     /* platform device */

