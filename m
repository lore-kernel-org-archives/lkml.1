Return-Path: <linux-kernel-owner+w=401wt.eu-S1753183AbZKOPUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbZKOPUu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 10:20:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753114AbZKOPUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 10:20:50 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:24141 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096AbZKOPUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 10:20:49 -0500
X-Spam-Flag: NO
X-Spam-Score: -12.589
Message-ID: <4B001C4C.8080309@tremplin-utc.net>
Date: Sun, 15 Nov 2009 16:20:44 +0100
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20091009 Mandriva/2.0.0.23-3mdv2010.0 (2010.0) Thunderbird/2.0.0.23 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Samu Onkalo <samu.p.onkalo@nokia.com>
Cc: daniel@caiaq.de, pavel@ucw.cz, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [PATCH v2 08/10] lis3: Sysfs entry for setting chip measurement
 rate
References: <1257856872-11612-1-git-send-email-samu.p.onkalo@nokia.com> <1257856872-11612-2-git-send-email-samu.p.onkalo@nokia.com> <1257856872-11612-3-git-send-email-samu.p.onkalo@nokia.com> <1257856872-11612-4-git-send-email-samu.p.onkalo@nokia.com> <1257856872-11612-5-git-send-email-samu.p.onkalo@nokia.com> <1257856872-11612-6-git-send-email-samu.p.onkalo@nokia.com> <1257856872-11612-7-git-send-email-samu.p.onkalo@nokia.com> <1257856872-11612-8-git-send-email-samu.p.onkalo@nokia.com> <1257856872-11612-9-git-send-email-samu.p.onkalo@nokia.com>
In-Reply-To: <1257856872-11612-9-git-send-email-samu.p.onkalo@nokia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 10-11-09 13:41, Samu Onkalo schreef:
> It is possible to read position information at the chip measurement
> rate via sysfs. This patch adds possibility to configure chip
> measurement rate.
Looks fine in general... but there is a bug, cf below.

In addition, the construct of the code make me cry for object
orientation. I'll get over it, but we should keep in mind that cleaning
this up would be welcome (maybe through the usage of an additional
function pointer in the lis3lv02 struct).

Eric

> 
> Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
> ---
>  drivers/hwmon/lis3lv02d.c |   49 ++++++++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 48 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/hwmon/lis3lv02d.c b/drivers/hwmon/lis3lv02d.c
> index 5b39257..be2eb97 100644
> --- a/drivers/hwmon/lis3lv02d.c
> +++ b/drivers/hwmon/lis3lv02d.c
> @@ -133,6 +133,37 @@ static int lis3lv02d_get_odr(void)
>  	return val;
>  }
>  
> +static int lis3lv02d_set_odr(int rate)
> +{
> +	u8 ctrl;
> +	int i, len, shift;
> +	int *rates;
> +	int ret = -EINVAL;
> +
> +	lis3_dev.read(&lis3_dev, CTRL_REG1, &ctrl);
> +
> +	if (lis3_dev.whoami == WAI_12B) {
> +		len = sizeof(lis3_12_rates);
ARRAY_SIZE() would be much more correct!

> +		rates = lis3_12_rates;
> +		shift = 4;
> +		ctrl &= ~(CTRL1_DF0 | CTRL1_DF1);
> +	} else {
> +		len = sizeof(lis3_8_rates);
idem

> +		rates = lis3_8_rates;
> +		shift = 7;
> +		ctrl &= ~CTRL1_DR;
> +	}
> +
> +	for (i = 0; i < len; i++)
> +		if (rates[i] == rate) {
> +			lis3_dev.write(&lis3_dev,
> +				CTRL_REG1, ctrl | (i << shift));
> +			ret = 0;
You could do simply a "return 0"

> +			break;
> +		}
> +	return ret;
And here a "return -EINVAL"


> +}
> +
>  static int lis3lv02d_selftest(struct lis3lv02d *lis3, s16 results[3])
>  {
>  	u8 reg;
> @@ -427,9 +458,25 @@ static ssize_t lis3lv02d_rate_show(struct device *dev,
>  	return sprintf(buf, "%d\n", lis3lv02d_get_odr());
>  }
>  
> +static ssize_t lis3lv02d_rate_set(struct device *dev,
> +				struct device_attribute *attr, const char *buf,
> +				size_t count)
> +{
> +	unsigned long rate;
> +
> +	if (strict_strtoul(buf, 0, &rate))
> +		return -EINVAL;
> +
> +	if (lis3lv02d_set_odr(rate))
> +		return -EINVAL;
> +
> +	return count;
> +}
> +
>  static DEVICE_ATTR(selftest, S_IRUGO, lis3lv02d_selftest_show, NULL);
>  static DEVICE_ATTR(position, S_IRUGO, lis3lv02d_position_show, NULL);
> -static DEVICE_ATTR(rate, S_IRUGO, lis3lv02d_rate_show, NULL);
> +static DEVICE_ATTR(rate, S_IRUGO | S_IWUSR, lis3lv02d_rate_show,
> +					    lis3lv02d_rate_set);
>  
>  static struct attribute *lis3lv02d_attributes[] = {
>  	&dev_attr_selftest.attr,

