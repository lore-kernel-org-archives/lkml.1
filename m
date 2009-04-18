Return-Path: <linux-kernel-owner+w=401wt.eu-S1755217AbZDRVzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217AbZDRVzp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 17:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753280AbZDRVzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 17:55:35 -0400
Received: from mx0.towertech.it ([213.215.222.73]:46879 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752470AbZDRVze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 17:55:34 -0400
Date: Sat, 18 Apr 2009 23:55:29 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: rtc-linux@googlegroups.com
Cc: geert@linux-m68k.org, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [rtc-linux] [PATCH/RFC 15/16] rtc: Add an RTC driver for the
 Ricoh RP5C01
Message-ID: <20090418235529.47e481e9@i1501.lan.towertech.it>
In-Reply-To: <1240080744-14995-16-git-send-email-geert@linux-m68k.org>
References: <1240080744-14995-1-git-send-email-geert@linux-m68k.org>
	<1240080744-14995-2-git-send-email-geert@linux-m68k.org>
	<1240080744-14995-3-git-send-email-geert@linux-m68k.org>
	<1240080744-14995-4-git-send-email-geert@linux-m68k.org>
	<1240080744-14995-5-git-send-email-geert@linux-m68k.org>
	<1240080744-14995-6-git-send-email-geert@linux-m68k.org>
	<1240080744-14995-7-git-send-email-geert@linux-m68k.org>
	<1240080744-14995-8-git-send-email-geert@linux-m68k.org>
	<1240080744-14995-9-git-send-email-geert@linux-m68k.org>
	<1240080744-14995-10-git-send-email-geert@linux-m68k.org>
	<1240080744-14995-11-git-send-email-geert@linux-m68k.org>
	<1240080744-14995-12-git-send-email-geert@linux-m68k.org>
	<1240080744-14995-13-git-send-email-geert@linux-m68k.org>
	<1240080744-14995-14-git-send-email-geert@linux-m68k.org>
	<1240080744-14995-15-git-send-email-geert@linux-m68k.org>
	<1240080744-14995-16-git-send-email-geert@linux-m68k.org>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Apr 2009 20:52:23 +0200
Geert Uytterhoeven <geert@linux-m68k.org> wrote:

 Hi Geert, thanks for your contributions. Comments below.

 Missing patch description.

> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: rtc-linux@googlegroups.com
> ---
>  drivers/rtc/Kconfig      |   10 ++
>  drivers/rtc/Makefile     |    1 +
>  drivers/rtc/rtc-rp5c01.c |  239 ++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 250 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/rtc/rtc-rp5c01.c
> 
> diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
> index a0f6297..150fe43 100644
> --- a/drivers/rtc/Kconfig
> +++ b/drivers/rtc/Kconfig
> @@ -535,6 +535,16 @@ config RTC_DRV_MSM6242
>  	  This driver can also be built as a module. If so, the module
>  	  will be called rtc-msm6242.
>  
> +config RTC_DRV_RP5C01
> +	tristate "Ricoh RP5C01"
> +	help
> +	  If you say yes here you get support for the Ricoh RP5C01
> +	  timekeeping chip. It is used in some Amiga models (e.g. A3000
> +	  and A4000).
> +
> +	  This driver can also be built as a module. If so, the module
> +	  will be called rtc-rp5c01.
> +
>  comment "on-CPU RTC drivers"
>  
>  config RTC_DRV_OMAP
> diff --git a/drivers/rtc/Makefile b/drivers/rtc/Makefile
> index c70418b..6176a8a 100644
> --- a/drivers/rtc/Makefile
> +++ b/drivers/rtc/Makefile
> @@ -77,4 +77,5 @@ obj-$(CONFIG_RTC_DRV_WM8350)	+= rtc-wm8350.o
>  obj-$(CONFIG_RTC_DRV_X1205)	+= rtc-x1205.o
>  obj-$(CONFIG_RTC_DRV_PCF50633)	+= rtc-pcf50633.o
>  obj-$(CONFIG_RTC_DRV_MSM6242)	+= rtc-msm6242.o
> +obj-$(CONFIG_RTC_DRV_RP5C01)	+= rtc-rp5c01.o
>  obj-$(CONFIG_RTC_DRV_PS3)	+= rtc-ps3.o

 alphabetic order please


> diff --git a/drivers/rtc/rtc-rp5c01.c b/drivers/rtc/rtc-rp5c01.c
> new file mode 100644
> index 0000000..d997f33
> --- /dev/null
> +++ b/drivers/rtc/rtc-rp5c01.c
> @@ -0,0 +1,239 @@
> +/*
> + *  Ricoh RP5C01 RTC Driver
> + *
> + *  Copyright 2009 Geert Uytterhoeven
> + *
> + *  Based on the A3000 TOD code in arch/m68k/amiga/config.c
> + *  Copyright (C) 1993 Hamish Macdonald
> + */
> +
> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/rtc.h>
> +
> +
> +enum {
> +	RP5C01_1_SECOND		= 0x0,	/* MODE 00 */
> +	RP5C01_10_SECOND	= 0x1,	/* MODE 00 */
> +	RP5C01_1_MINUTE		= 0x2,	/* MODE 00 and MODE 01 */
> +	RP5C01_10_MINUTE	= 0x3,	/* MODE 00 and MODE 01 */
> +	RP5C01_1_HOUR		= 0x4,	/* MODE 00 and MODE 01 */
> +	RP5C01_10_HOUR		= 0x5,	/* MODE 00 and MODE 01 */
> +	RP5C01_DAY_OF_WEEK	= 0x6,	/* MODE 00 and MODE 01 */
> +	RP5C01_1_DAY		= 0x7,	/* MODE 00 and MODE 01 */
> +	RP5C01_10_DAY		= 0x8,	/* MODE 00 and MODE 01 */
> +	RP5C01_1_MONTH		= 0x9,	/* MODE 00 */
> +	RP5C01_10_MONTH		= 0xa,	/* MODE 00 */
> +	RP5C01_1_YEAR		= 0xb,	/* MODE 00 */
> +	RP5C01_10_YEAR		= 0xc,	/* MODE 00 */
> +
> +	RP5C01_12_24_SELECT	= 0xa,	/* MODE 01 */
> +	RP5C01_LEAP_YEAR	= 0xb,	/* MODE 01 */
> +
> +	RP5C01_MODE		= 0xd,	/* all modes */
> +	RP5C01_TEST		= 0xe,	/* all modes */
> +	RP5C01_RESET		= 0xf,	/* all modes */
> +};
> +
> +#define RP5C01_12_24_SELECT_12	(0 << 0)
> +#define RP5C01_12_24_SELECT_24	(1 << 0)
> +
> +#define RP5C01_10_HOUR_AM	(0 << 1)
> +#define RP5C01_10_HOUR_PM	(1 << 1)
> +
> +#define RP5C01_MODE_TIMER_EN	(1 << 3)	/* timer enable */
> +#define RP5C01_MODE_ALARM_EN	(1 << 2)	/* alarm enable */
> +
> +#define RP5C01_MODE_MODE_MASK	(3 << 0)
> +#define RP5C01_MODE_MODE00	(0 << 0)	/* time */
> +#define RP5C01_MODE_MODE01	(1 << 0)	/* alarm, 12h/24h, leap year */
> +#define RP5C01_MODE_RAM_BLOCK10	(2 << 0)	/* RAM 4 bits x 13 */
> +#define RP5C01_MODE_RAM_BLOCK11	(3 << 0)	/* RAM 4 bits x 13 */
> +
> +#define RP5C01_RESET_1HZ_PULSE	(1 << 3)
> +#define RP5C01_RESET_16HZ_PULSE	(1 << 2)
> +#define RP5C01_RESET_SECOND	(1 << 1)	/* reset divider stages for */
> +						/* seconds or smaller units */
> +#define RP5C01_RESET_ALARM	(1 << 0)	/* reset all alarm registers */
> +
> +
> +struct rp5c01_priv {
> +	u32 __iomem *regs;
> +	struct rtc_device *rtc;
> +};
> +
> +static inline unsigned int rp5c01_read(struct rp5c01_priv *priv,
> +				       unsigned int reg)
> +{
> +	return __raw_readl(&priv->regs[reg]) & 0xf;
> +}
> +
> +static inline void rp5c01_write(struct rp5c01_priv *priv, unsigned int val,
> +				unsigned int reg)
> +{
> +	return __raw_writel(val, &priv->regs[reg]);
> +}
> +
> +static void rp5c01_lock(struct rp5c01_priv *priv)
> +{
> +	rp5c01_write(priv, RP5C01_MODE_MODE00, RP5C01_MODE);
> +}
> +
> +static void rp5c01_unlock(struct rp5c01_priv *priv)
> +{
> +	rp5c01_write(priv, RP5C01_MODE_TIMER_EN | RP5C01_MODE_MODE01,
> +		     RP5C01_MODE);
> +}
> +
> +static int rp5c01_read_time(struct device *dev, struct rtc_time *tm)
> +{
> +	struct rp5c01_priv *priv = dev_get_drvdata(dev);
> +
> +	rp5c01_lock(priv);
> +
> +	tm->tm_sec  = rp5c01_read(priv, RP5C01_10_SECOND) * 10 +
> +		      rp5c01_read(priv, RP5C01_1_SECOND);
> +	tm->tm_min  = rp5c01_read(priv, RP5C01_10_MINUTE) * 10 +
> +		      rp5c01_read(priv, RP5C01_1_MINUTE);
> +	tm->tm_hour = rp5c01_read(priv, RP5C01_10_HOUR) * 10 +
> +		      rp5c01_read(priv, RP5C01_1_HOUR);
> +	tm->tm_mday = rp5c01_read(priv, RP5C01_10_DAY) * 10 +
> +		      rp5c01_read(priv, RP5C01_1_DAY);
> +	tm->tm_wday = rp5c01_read(priv, RP5C01_DAY_OF_WEEK);
> +	tm->tm_mon  = rp5c01_read(priv, RP5C01_10_MONTH) * 10 +
> +		      rp5c01_read(priv, RP5C01_1_MONTH) - 1;
> +	tm->tm_year = rp5c01_read(priv, RP5C01_10_YEAR) * 10 +
> +		      rp5c01_read(priv, RP5C01_1_YEAR);
> +	if (tm->tm_year <= 69)
> +		tm->tm_year += 100;
> +
> +	rp5c01_unlock(priv);
> +
> +	return rtc_valid_tm(tm);
> +}
> +
> +static int rp5c01_set_time(struct device *dev, struct rtc_time *tm)
> +{
> +	struct rp5c01_priv *priv = dev_get_drvdata(dev);
> +
> +	rp5c01_lock(priv);
> +
> +	rp5c01_write(priv, tm->tm_sec / 10, RP5C01_10_SECOND);
> +	rp5c01_write(priv, tm->tm_sec % 10, RP5C01_1_SECOND);
> +	rp5c01_write(priv, tm->tm_min / 10, RP5C01_10_MINUTE);
> +	rp5c01_write(priv, tm->tm_min % 10, RP5C01_1_MINUTE);
> +	rp5c01_write(priv, tm->tm_hour / 10, RP5C01_10_HOUR);
> +	rp5c01_write(priv, tm->tm_hour % 10, RP5C01_1_HOUR);
> +	rp5c01_write(priv, tm->tm_mday / 10, RP5C01_10_DAY);
> +	rp5c01_write(priv, tm->tm_mday % 10, RP5C01_1_DAY);
> +	if (tm->tm_wday != -1)
> +		rp5c01_write(priv, tm->tm_wday, RP5C01_DAY_OF_WEEK);
> +	rp5c01_write(priv, (tm->tm_mon + 1) / 10, RP5C01_10_MONTH);
> +	rp5c01_write(priv, (tm->tm_mon + 1) % 10, RP5C01_1_MONTH);
> +	if (tm->tm_year >= 100)
> +		tm->tm_year -= 100;
> +	rp5c01_write(priv, tm->tm_year / 10, RP5C01_10_YEAR);
> +	rp5c01_write(priv, tm->tm_year % 10, RP5C01_1_YEAR);
> +
> +	rp5c01_unlock(priv);
> +	return 0;
> +}
> +
> +static int rp5c01_set_mmss(struct device *dev, unsigned long secs)
> +{
> +	struct rp5c01_priv *priv = dev_get_drvdata(dev);
> +	unsigned int real_seconds = secs % 60, real_minutes = (secs / 60) % 60;
> +
> +	rp5c01_lock(priv);
> +
> +	rp5c01_write(priv, real_seconds / 10, RP5C01_10_SECOND);
> +	rp5c01_write(priv, real_seconds % 10, RP5C01_1_SECOND);
> +	rp5c01_write(priv, real_minutes / 10, RP5C01_10_MINUTE);
> +	rp5c01_write(priv, real_minutes % 10, RP5C01_1_MINUTE);
> +
> +	rp5c01_unlock(priv);
> +	return 0;
> +}
> +
> +static const struct rtc_class_ops rp5c01_rtc_ops = {
> +	.read_time	= rp5c01_read_time,
> +	.set_time	= rp5c01_set_time,
> +	.set_mmss	= rp5c01_set_mmss,
> +};

 please implement either set_time or set_mmss, not both.
 I don't know the chip but I suspect set_time is the one you need.


> +static int __init rp5c01_rtc_probe(struct platform_device *dev)
> +{
> +	struct resource *res;
> +	struct rp5c01_priv *priv;
> +	struct rtc_device *rtc;
> +	int error;
> +
> +	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
> +	if (!res)
> +		return -ENODEV;
> +
> +	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;
> +
> +	priv->regs = ioremap(res->start, resource_size(res));
> +	if (!priv->regs) {
> +		error = -ENOMEM;
> +		goto out_free_priv;
> +	}
> +
> +	rtc = rtc_device_register("rtc-rp5c01", &dev->dev, &rp5c01_rtc_ops,
> +				  THIS_MODULE);
> +	if (IS_ERR(rtc)) {
> +		error = PTR_ERR(rtc);
> +		goto out_unmap;
> +	}
> +
> +	priv->rtc = rtc;
> +	platform_set_drvdata(dev, priv);
> +	return 0;
> +
> +out_unmap:
> +	iounmap(priv->regs);
> +out_free_priv:
> +	kfree(priv);
> +	return error;
> +}
> +
> +static int __exit rp5c01_rtc_remove(struct platform_device *dev)
> +{
> +	struct rp5c01_priv *priv = platform_get_drvdata(dev);
> +
> +	rtc_device_unregister(priv->rtc);
> +	iounmap(priv->regs);
> +	kfree(priv);
> +	return 0;
> +}
> +
> +static struct platform_driver rp5c01_rtc_driver = {
> +	.driver	= {
> +		.name	= "rtc-rp5c01",
> +		.owner	= THIS_MODULE,
> +	},
> +	.remove	= __exit_p(rp5c01_rtc_remove),
> +};
> +
> +static int __init rp5c01_rtc_init(void)
> +{
> +	return platform_driver_probe(&rp5c01_rtc_driver, rp5c01_rtc_probe);
> +}
> +
> +static void __exit rp5c01_rtc_fini(void)
> +{
> +	platform_driver_unregister(&rp5c01_rtc_driver);
> +}
> +
> +module_init(rp5c01_rtc_init);
> +module_exit(rp5c01_rtc_fini);
> +
> +MODULE_AUTHOR("Geert Uytterhoeven");

 it would be fine to have your email here.

> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("Ricoh RP5C01 RTC driver");
> +MODULE_ALIAS("platform:rtc-rp5c01");
> -- 
> 1.6.2.3
> 
> 
> --~--~---------~--~----~------------~-------~--~----~
> You received this message because you are subscribed to "rtc-linux".
> Membership options at http://groups.google.com/group/rtc-linux .
> Please read http://groups.google.com/group/rtc-linux/web/checklist
> before submitting a driver.
> -~----------~----~----~----~------~----~------~--~---
> 


-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

