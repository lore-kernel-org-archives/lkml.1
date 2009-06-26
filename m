Return-Path: <linux-kernel-owner+w=401wt.eu-S1756077AbZFZUXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077AbZFZUXe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 16:23:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753702AbZFZUXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 16:23:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59782 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751770AbZFZUXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 16:23:25 -0400
Date: Fri, 26 Jun 2009 13:23:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Ribeiro <drwyrm@gmail.com>
Cc: a.zummo@towertech.it, rtc-linux@googlegroups.com,
       linux-kernel@vger.kernel.org, openezx-devel@lists.openezx.org,
       sameo@linux.intel.com
Subject: Re: [PATCH] PCAP RTC driver (for 2.6.32).
Message-Id: <20090626132310.60665a98.akpm@linux-foundation.org>
In-Reply-To: <1245962749.10360.42.camel@brutus>
References: <1245962749.10360.42.camel@brutus>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jun 2009 17:45:49 -0300
Daniel Ribeiro <drwyrm@gmail.com> wrote:

> RTC driver for PCAP2 PMIC.
> 
> This patch was sent some time ago and acked by Alessandro, but we had to
> change some stuff on the core driver and consequently on this driver
> too, so I'm submitting it again for review (sorry).
> 
> Signed-off-by: guiming zhuo <gmzhuo@gmail.com>
> Signed-off-by: Daniel Ribeiro <drwyrm@gmail.com>

The above paragraph contains nothing which is relevant to the final
commit changelog, so I removed it.  I thus ended up without any
changelog at all.

Oh well - perhaps there wasn't much to say anyway.


> diff -puN drivers/rtc/Kconfig~pcap-rtc-driver-for-2632 drivers/rtc/Kconfig
> --- a/drivers/rtc/Kconfig~pcap-rtc-driver-for-2632
> +++ a/drivers/rtc/Kconfig
> @@ -778,4 +778,11 @@ config RTC_DRV_PS3
>  	  This driver can also be built as a module. If so, the module
>  	  will be called rtc-ps3.
>  
> +config RTC_DRV_PCAP
> +	tristate "PCAP RTC"
> +	depends on EZX_PCAP
> +	help
> +	  If you say Y here you will get support for the RTC found on
> +	  the PCAP2 ASIC used on some Motorola phones.
> +
>  endif # RTC_CLASS
> diff -puN drivers/rtc/Makefile~pcap-rtc-driver-for-2632 drivers/rtc/Makefile
> --- a/drivers/rtc/Makefile~pcap-rtc-driver-for-2632
> +++ a/drivers/rtc/Makefile
> @@ -53,6 +53,7 @@ obj-$(CONFIG_RTC_DRV_MAX6902)	+= rtc-max
>  obj-$(CONFIG_RTC_DRV_MSM6242)	+= rtc-msm6242.o
>  obj-$(CONFIG_RTC_DRV_MV)	+= rtc-mv.o
>  obj-$(CONFIG_RTC_DRV_OMAP)	+= rtc-omap.o
> +obj-$(CONFIG_RTC_DRV_PCAP)	+= rtc-pcap.o
>  obj-$(CONFIG_RTC_DRV_PCF8563)	+= rtc-pcf8563.o
>  obj-$(CONFIG_RTC_DRV_PCF8583)	+= rtc-pcf8583.o
>  obj-$(CONFIG_RTC_DRV_PL030)	+= rtc-pl030.o
> diff -puN /dev/null drivers/rtc/rtc-pcap.c
> --- /dev/null
> +++ a/drivers/rtc/rtc-pcap.c
> @@ -0,0 +1,222 @@
> +/*
> + *  pcap rtc code for Motorola EZX phones
> + *
> + *  Copyright (c) 2008 guiming zhuo <gmzhuo@gmail.com>
> + *  Copyright (c) 2009 Daniel Ribeiro <drwyrm@gmail.com>
> + *
> + *  Based on Motorola's rtc.c Copyright (c) 2003-2005 Motorola
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License version 2 as
> + *  published by the Free Software Foundation.
> + *
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/mfd/ezx-pcap.h>
> +#include <linux/rtc.h>
> +#include <linux/platform_device.h>
> +
> +struct pcap_rtc {
> +	struct pcap_chip *pcap;
> +	struct rtc_device *rtc;
> +};
> +
> +static irqreturn_t pcap_rtc_irq(int irq, void *_pcap_rtc)
> +{
> +	struct pcap_rtc *pcap_rtc = _pcap_rtc;
> +	unsigned long rtc_events = 0;
> +
> +	if (irq == pcap_to_irq(pcap_rtc->pcap, PCAP_IRQ_1HZ))
> +		rtc_events |= RTC_IRQF | RTC_UF;
> +	else if (irq == pcap_to_irq(pcap_rtc->pcap, PCAP_IRQ_TODA))
> +		rtc_events |= RTC_IRQF | RTC_AF;
> +
> +	rtc_update_irq(pcap_rtc->rtc, 1, rtc_events);
> +	return IRQ_HANDLED;
> +}

This could be coded more simply:

	unsigned long rtc_events;

	if (irq == pcap_to_irq(pcap_rtc->pcap, PCAP_IRQ_1HZ))
		rtc_events = RTC_IRQF | RTC_UF;
	else if (irq == pcap_to_irq(pcap_rtc->pcap, PCAP_IRQ_TODA))
		rtc_events = RTC_IRQF | RTC_AF;


> +static int pcap_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct pcap_rtc *pcap_rtc = platform_get_drvdata(pdev);
> +	struct rtc_time *tm = &alrm->time;
> +	unsigned long secs;
> +	u32 tmp;
> +
> +	ezx_pcap_read(pcap_rtc->pcap, PCAP_REG_RTC_TODA, &tmp);
> +	secs = tmp & PCAP_RTC_TOD_MASK;
> +
> +	ezx_pcap_read(pcap_rtc->pcap, PCAP_REG_RTC_DAYA, &tmp);
> +	secs += (tmp & PCAP_RTC_DAY_MASK) * SEC_PER_DAY;
> +
> +	rtc_time_to_tm(secs, tm);
> +
> +	return 0;
> +}

SEC_PER_DAY is defined in include/linux/mfd/ezx-pcap.h.  It should not
be, because it is not specific to that driver and can be used elsewhere
in the kernel.

I'd suggest that we

- define SECS_PER_DAY in include/linux/time.h

- remove the private definitions of SECS_PER_DAY from
  arch/m68k/mac/misc, arch/parisc/include/asm/rtc.h,
  arch/ia64/hp/sim/boot/fw-emu.c, fs/udf/udftime.c, fs/fat/misc.c and
  wherever else it appears, make those files use the common definition

- migrate rtc-pcap.c from SEC_PER_DAY over to the common SECS_PER_DAY.

- Then do it all again for SECS_PER_MIN and SECS_PER_HOUR.


What a mess.


None of the above is applicable in the context of this patch.


> +static int pcap_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct pcap_rtc *pcap_rtc = platform_get_drvdata(pdev);
> +	struct rtc_time *tm = &alrm->time;
> +	unsigned long secs;
> +	u32 tmp;

"tmp" is a poor identifier.  We had an opportunity here to use an
identifier which would communicate useful information to the reader. 
But we blew it and used the information-free "tmp" instead.

Something like

	u32 time_of_day;	/* In seconds since midnight */

would be nice.  If that is indeed what the variable contains.  How
would I know?  It's called 'tmp" and is undescribed!

> +	rtc_tm_to_time(tm, &secs);
> +
> +	tmp = secs % SEC_PER_DAY;
> +	ezx_pcap_write(pcap_rtc->pcap, PCAP_REG_RTC_TODA, tmp);
> +
> +	tmp = secs / SEC_PER_DAY;
> +	ezx_pcap_write(pcap_rtc->pcap, PCAP_REG_RTC_DAYA, tmp);
> +
> +	return 0;
> +}
> +
> +static int pcap_rtc_read_time(struct device *dev, struct rtc_time *tm)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct pcap_rtc *pcap_rtc = platform_get_drvdata(pdev);
> +	unsigned long secs;
> +	u32 tmp;
> +
> +	ezx_pcap_read(pcap_rtc->pcap, PCAP_REG_RTC_TOD, &tmp);
> +	secs = tmp & PCAP_RTC_TOD_MASK;
> +
> +	ezx_pcap_read(pcap_rtc->pcap, PCAP_REG_RTC_DAY, &tmp);
> +	secs += (tmp & PCAP_RTC_DAY_MASK) * SEC_PER_DAY;
> +
> +	rtc_time_to_tm(secs, tm);
> +
> +	return rtc_valid_tm(tm);
> +}
> +
> +static int pcap_rtc_set_mmss(struct device *dev, unsigned long secs)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct pcap_rtc *pcap_rtc = platform_get_drvdata(pdev);
> +	u32 tmp;
> +
> +	tmp = secs % SEC_PER_DAY;
> +	ezx_pcap_write(pcap_rtc->pcap, PCAP_REG_RTC_TOD, tmp);
> +
> +	tmp = secs / SEC_PER_DAY;
> +	ezx_pcap_write(pcap_rtc->pcap, PCAP_REG_RTC_DAY, tmp);
> +
> +	return 0;
> +}

etceteras

> +static inline int pcap_rtc_irq_enable(struct device *dev, int pirq,
> +							unsigned int en)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct pcap_rtc *pcap_rtc = platform_get_drvdata(pdev);
> +
> +	if (en)
> +		enable_irq(pcap_to_irq(pcap_rtc->pcap, pirq));
> +	else
> +		disable_irq(pcap_to_irq(pcap_rtc->pcap, pirq));
> +
> +	return 0;
> +}

Inlining this function probably made the code larger and slower.

> +static int pcap_rtc_alarm_irq_enable(struct device *dev, unsigned int en)
> +{
> +	return pcap_rtc_irq_enable(dev, PCAP_IRQ_TODA, en);
> +}
> +
> +static int pcap_rtc_update_irq_enable(struct device *dev, unsigned int en)
> +{
> +	return pcap_rtc_irq_enable(dev, PCAP_IRQ_1HZ, en);
> +}
> +
> +static const struct rtc_class_ops pcap_rtc_ops = {
> +	.read_time = pcap_rtc_read_time,
> +	.read_alarm = pcap_rtc_read_alarm,
> +	.set_alarm = pcap_rtc_set_alarm,
> +	.set_mmss = pcap_rtc_set_mmss,
> +	.alarm_irq_enable = pcap_rtc_alarm_irq_enable,
> +	.update_irq_enable = pcap_rtc_update_irq_enable,
> +};
> +
> +static int __devinit pcap_rtc_probe(struct platform_device *pdev)
> +{
> +	struct pcap_rtc *pcap_rtc;
> +	int timer_irq, alarm_irq;
> +	int err = -ENOMEM;
> +
> +	pcap_rtc = kmalloc(sizeof(struct pcap_rtc), GFP_KERNEL);
> +	if (!pcap_rtc)
> +		return err;
> +
> +	pcap_rtc->pcap = platform_get_drvdata(pdev);
> +
> +	pcap_rtc->rtc = rtc_device_register("pcap", &pdev->dev,
> +				  &pcap_rtc_ops, THIS_MODULE);
> +	if (IS_ERR(pcap_rtc->rtc)) {
> +		err = PTR_ERR(pcap_rtc->rtc);
> +		goto fail_rtc;
> +	}
> +
> +	platform_set_drvdata(pdev, pcap_rtc);
> +
> +	timer_irq = pcap_to_irq(pcap_rtc->pcap, PCAP_IRQ_1HZ);
> +	alarm_irq = pcap_to_irq(pcap_rtc->pcap, PCAP_IRQ_TODA);
> +
> +	err = request_irq(timer_irq, pcap_rtc_irq, 0, "RTC Timer", pcap_rtc);
> +	if (err)
> +		goto fail_timer;
> +
> +	err = request_irq(alarm_irq, pcap_rtc_irq, 0, "RTC Alarm", pcap_rtc);
> +	if (err)
> +		goto fail_alarm;
> +
> +	return 0;
> +fail_alarm:
> +	free_irq(timer_irq, pcap_rtc);
> +fail_timer:
> +	rtc_device_unregister(pcap_rtc->rtc);
> +fail_rtc:
> +	kfree(pcap_rtc);
> +	return err;
> +}
> +
> +static int __devexit pcap_rtc_remove(struct platform_device *pdev)
> +{
> +	struct pcap_rtc *pcap_rtc = platform_get_drvdata(pdev);
> +
> +	free_irq(pcap_to_irq(pcap_rtc->pcap, PCAP_IRQ_1HZ), pcap_rtc);
> +	free_irq(pcap_to_irq(pcap_rtc->pcap, PCAP_IRQ_TODA), pcap_rtc);
> +	rtc_device_unregister(pcap_rtc->rtc);
> +	kfree(pcap_rtc);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver pcap_rtc_driver = {
> +	.remove = __devexit_p(pcap_rtc_remove),
> +	.driver = {
> +		.name  = "pcap-rtc",
> +		.owner = THIS_MODULE,
> +	},
> +};
> +
> +static int __init rtc_pcap_init(void)
> +{
> +	return platform_driver_probe(&pcap_rtc_driver, pcap_rtc_probe);
> +}
> +
> +static void __exit rtc_pcap_exit(void)
> +{
> +	platform_driver_unregister(&pcap_rtc_driver);
> +}
> +
> +module_init(rtc_pcap_init);
> +module_exit(rtc_pcap_exit);
> +
> +MODULE_DESCRIPTION("Motorola pcap rtc driver");
> +MODULE_AUTHOR("guiming zhuo <gmzhuo@gmail.com>");
> +MODULE_LICENSE("GPL");>

It's a nice little driver. 
