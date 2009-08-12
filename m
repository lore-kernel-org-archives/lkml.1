Return-Path: <linux-kernel-owner+w=401wt.eu-S932403AbZHLJll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932403AbZHLJll (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 05:41:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932389AbZHLJli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 05:41:38 -0400
Received: from mx0.towertech.it ([213.215.222.73]:55357 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932376AbZHLJlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 05:41:36 -0400
Date: Wed, 12 Aug 2009 11:41:34 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       Sascha Hauer <s.hauer@pengutronix.de>,
       Paul Gortmaker <p_gortmaker@yahoo.com>, rtc-linux@googlegroups.com
Subject: Re: [PATCH 4/5] [RTC] Add Freescale MC13783 RTC driver
Message-ID: <20090812114134.421303c4@i1501.lan.towertech.it>
In-Reply-To: <1249981166-4210-4-git-send-email-s.hauer@pengutronix.de>
References: <1249981166-4210-1-git-send-email-s.hauer@pengutronix.de>
	<1249981166-4210-2-git-send-email-s.hauer@pengutronix.de>
	<1249981166-4210-3-git-send-email-s.hauer@pengutronix.de>
	<1249981166-4210-4-git-send-email-s.hauer@pengutronix.de>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Aug 2009 10:59:25 +0200
Sascha Hauer <s.hauer@pengutronix.de> wrote:

> This driver provides support for the RTC part integrated into
> the Freescale MC13783 PMIC.
> 
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
> Cc: Alessandro Zummo <a.zummo@towertech.it>
> Cc: rtc-linux@googlegroups.com


 thanks for your submission, comments below

> ---
>  drivers/rtc/Kconfig       |    6 ++
>  drivers/rtc/Makefile      |    1 +
>  drivers/rtc/rtc-mc13783.c |  141 +++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 148 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/rtc/rtc-mc13783.c
> 
> diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
> index 81adbdb..e4a242f 100644
> --- a/drivers/rtc/Kconfig
> +++ b/drivers/rtc/Kconfig
> @@ -759,4 +759,10 @@ config RTC_DRV_PS3
>  	  This driver can also be built as a module. If so, the module
>  	  will be called rtc-ps3.
>  
> +config RTC_DRV_MC13783
> +	depends on MFD_MC13783
> +	tristate "Freescale MC13783 RTC"
> +	help
> +	  This enables support for the Freescale MC13783 PMIC RTC
> +
>  endif # RTC_CLASS
> diff --git a/drivers/rtc/Makefile b/drivers/rtc/Makefile
> index 3c0f2b2..00bf66d 100644
> --- a/drivers/rtc/Makefile
> +++ b/drivers/rtc/Makefile
> @@ -78,3 +78,4 @@ obj-$(CONFIG_RTC_DRV_WM8350)	+= rtc-wm8350.o
>  obj-$(CONFIG_RTC_DRV_X1205)	+= rtc-x1205.o
>  obj-$(CONFIG_RTC_DRV_PCF50633)	+= rtc-pcf50633.o
>  obj-$(CONFIG_RTC_DRV_PS3)	+= rtc-ps3.o
> +obj-$(CONFIG_RTC_DRV_MC13783)	+= rtc-mc13783.o

 keep in in alphabetic order.

> diff --git a/drivers/rtc/rtc-mc13783.c b/drivers/rtc/rtc-mc13783.c
> new file mode 100644
> index 0000000..d1f1192
> --- /dev/null
> +++ b/drivers/rtc/rtc-mc13783.c
> @@ -0,0 +1,141 @@
> +/*
> + * Real Time Clock driver for Freescale MC13783 PMIC
> + *
> + * (C) 2009 Sascha Hauer, Pengutronix
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +#include <linux/mfd/mc13783-private.h>
> +#include <linux/platform_device.h>
> +#include <linux/interrupt.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/ioctl.h>
> +#include <linux/time.h>
> +#include <linux/rtc.h>

 too many includes?

> +
> +struct mc13783_rtc {
> +	struct rtc_device *rtc;
> +	struct mc13783 *mc13783;
> +};
> +
> +static int mc13783_rtc_set_time(struct device *dev, struct rtc_time *tm)

 please implement set_mmss instad of set_time

> +	struct mc13783_rtc *priv = dev_get_drvdata(dev);
> +	unsigned int seconds, days;
> +	unsigned long s1970;
> +
> +	rtc_tm_to_time(tm, &s1970);
> +
> +	seconds = s1970 % 86400;
> +	days = s1970 / 86400;
> +
> +	mc13783_reg_write(priv->mc13783, MC13783_REG_RTC_TIME, seconds);
> +	mc13783_reg_write(priv->mc13783, MC13783_REG_RTC_DAY, days);
> +
> +	return 0;
> +}
> +
> +static int mc13783_rtc_read_time(struct device *dev, struct rtc_time *tm)
> +{
> +	struct mc13783_rtc *priv = dev_get_drvdata(dev);
> +	unsigned int seconds, days1, days2;
> +	unsigned long s1970;
> +
> +	rtc_tm_to_time(tm, &s1970);
> +
> +	do {
> +		mc13783_reg_read(priv->mc13783, MC13783_REG_RTC_TIME, &seconds);
> +		mc13783_reg_read(priv->mc13783, MC13783_REG_RTC_DAY, &days1);
> +		mc13783_reg_read(priv->mc13783, MC13783_REG_RTC_DAY, &days2);
> +	} while (days1 != days2);
> +
> +	s1970 = days1 * 86400 + seconds;
> +
> +	rtc_time_to_tm(s1970, tm);
> +
> +	return 0;

 use rtc_valid_tm

> +}
> +
> +static const struct rtc_class_ops mc13783_rtc_ops = {
> +	.read_time	= mc13783_rtc_read_time,
> +	.set_time	= mc13783_rtc_set_time,
> +};
> +
> +static int mc13783_rtc_probe(struct platform_device *pdev)
> +{
> +	int err;
> +	struct mc13783_rtc *priv;
> +
> +	priv = kzalloc(sizeof *priv, GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;
> +
> +	priv->mc13783 = pdev->dev.platform_data;
> +	platform_set_drvdata(pdev, priv);
> +
> +	priv->rtc = rtc_device_register(pdev->name,
> +			&pdev->dev, &mc13783_rtc_ops, THIS_MODULE);
> +
> +	if (IS_ERR(priv->rtc)) {
> +		err = PTR_ERR(priv->rtc);
> +		goto exit_kfree;
> +	}
> +
> +	return 0;
> +
> +exit_kfree:
> +	kfree(priv);
> +	return err;
> +}
> +
> +static int __exit mc13783_rtc_remove(struct platform_device *pdev)
> +{
> +	struct mc13783_rtc *priv = platform_get_drvdata(pdev);
> +
> +	rtc_device_unregister(priv->rtc);
> +	platform_set_drvdata(pdev, NULL);
> +
> +	kfree(priv);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver mc13783_rtc_driver = {
> +	.probe		 = mc13783_rtc_probe,
> +	.remove		= __exit_p(mc13783_rtc_remove),
> +	.driver = {
> +		.name	= "mc13783-rtc",
> +		.owner	= THIS_MODULE,
> +	},
> +};
> +
> +static int __init mc13783_rtc_init(void)
> +{
> +	return platform_driver_register(&mc13783_rtc_driver);

 can you use platform_driver_probe?

> +}
> +module_init(mc13783_rtc_init);
> +
> +static void __exit mc13783_rtc_exit(void)
> +{
> +	platform_driver_unregister(&mc13783_rtc_driver);
> +}
> +module_exit(mc13783_rtc_exit);
> +
> +
> +MODULE_AUTHOR("Sascha Hauer");

 email here please.

> +MODULE_DESCRIPTION("RTC driver for Freescale MC13783 PMIC");
> +MODULE_LICENSE("GPL");
> -- 
> 1.6.3.3
> 


-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

