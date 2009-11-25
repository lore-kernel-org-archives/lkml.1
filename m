Return-Path: <linux-kernel-owner+w=401wt.eu-S934634AbZKYMvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934634AbZKYMvT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 07:51:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934559AbZKYMvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 07:51:19 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:33895 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934553AbZKYMvS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 07:51:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=aY21vB1NSH4XnmYcztltMrCyr0bmBgajsQAJJ/1vGU2L70dhtqfxUj8AL2n7PryBkn
         HTQLbchSc/iOCmqDgjE7TXDpaWqnyr3+9VAcmo4kAxtmKUzrpFeAGB8U7ocyAx5eXaPn
         fHbppqEWdH34Af4+4SUTHluoYuWDIyvZhOMas=
MIME-Version: 1.0
In-Reply-To: <4B0D1FFB.5060403@gmail.com>
References: <4B0D1FFB.5060403@gmail.com>
Date: Wed, 25 Nov 2009 20:51:24 +0800
Message-ID: <713d0d430911250451x51e0196bwdcbe5e8f087c3f8c@mail.gmail.com>
Subject: Re: [PATCH V3] ARM: NUC900: add RTC driver support for nuc910 and 
	nuc920
From: Hu Ruihuan <specter118@gmail.com>
To: Wan ZongShun <mcuos.com@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>,
       linux-rtc <rtc-linux@googlegroups.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Dear Alessandro,
>
> This is a fixed patch which was tested via rtc test program located in Documentation/rtc.txt.
>
> Thanks for your help.
>
> Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>
> ---
>  drivers/rtc/Kconfig      |    6 +
>  drivers/rtc/Makefile     |    1 +
>  drivers/rtc/rtc-nuc900.c |  334 ++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 341 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/rtc/rtc-nuc900.c
>
> diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
> index 3c20dae..266ce62 100644
> --- a/drivers/rtc/Kconfig
> +++ b/drivers/rtc/Kconfig
> @@ -573,6 +573,12 @@ config RTC_DRV_AB3100
>          Select this to enable the ST-Ericsson AB3100 Mixed Signal IC RTC
>          support. This chip contains a battery- and capacitor-backed RTC.
>
> +config RTC_DRV_NUC900
> +       tristate "NUC910/NUC920 RTC driver"
> +       depends on RTC_CLASS && ARCH_W90X900
> +       help
> +         If you say yes here you get support for the RTC subsystem of the
> +         NUC910/NUC920 used in embedded systems.
>
>  comment "on-CPU RTC drivers"
>
> diff --git a/drivers/rtc/Makefile b/drivers/rtc/Makefile
> index aa3fbd5..d511774 100644
> --- a/drivers/rtc/Makefile
> +++ b/drivers/rtc/Makefile
> @@ -53,6 +53,7 @@ obj-$(CONFIG_RTC_MXC)         += rtc-mxc.o
>  obj-$(CONFIG_RTC_DRV_MAX6900)  += rtc-max6900.o
>  obj-$(CONFIG_RTC_DRV_MAX6902)  += rtc-max6902.o
>  obj-$(CONFIG_RTC_DRV_MV)       += rtc-mv.o
> +obj-$(CONFIG_RTC_DRV_NUC900)   += rtc-nuc900.o
>  obj-$(CONFIG_RTC_DRV_OMAP)     += rtc-omap.o
>  obj-$(CONFIG_RTC_DRV_PCAP)     += rtc-pcap.o
>  obj-$(CONFIG_RTC_DRV_PCF8563)  += rtc-pcf8563.o
> diff --git a/drivers/rtc/rtc-nuc900.c b/drivers/rtc/rtc-nuc900.c
> new file mode 100644
> index 0000000..09383e2
> --- /dev/null
> +++ b/drivers/rtc/rtc-nuc900.c
> @@ -0,0 +1,334 @@
> +/*
> + * Copyright (c) 2008-2009 Nuvoton technology corporation.
> + *
> + * Wan ZongShun <mcuos.com@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation;version 2 of the License.
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/platform_device.h>
> +#include <linux/rtc.h>
> +#include <linux/delay.h>
> +#include <linux/io.h>
> +#include <linux/bcd.h>
> +
> +/* RTC Control Registers */
> +#define REG_RTC_INIR           0x00
> +#define REG_RTC_AER            0x04
> +#define REG_RTC_FCR            0x08
> +#define REG_RTC_TLR            0x0C
> +#define REG_RTC_CLR            0x10
> +#define REG_RTC_TSSR           0x14
> +#define REG_RTC_DWR            0x18
> +#define REG_RTC_TAR            0x1C
> +#define REG_RTC_CAR            0x20
> +#define REG_RTC_LIR            0x24
> +#define REG_RTC_RIER           0x28
> +#define REG_RTC_RIIR           0x2C
> +#define REG_RTC_TTR            0x30
> +
> +#define RTCSET                 0x01
> +#define AERRWENB               0x10000
> +#define INIRRESET              0xa5eb1357
> +#define AERPOWERON             0xA965
> +#define AERPOWEROFF            0x0000
> +#define LEAPYEAR               0x0001
> +#define TICKENB                        0x80
> +#define TICKINTENB             0x0002
> +#define ALARMINTENB            0x0001
> +#define MODE24                 0x0001
> +
> +struct nuc900_rtc {
> +       int                     irq_num;
> +       void __iomem            *rtc_reg;
> +       struct rtc_device       *rtcdev;
> +       spinlock_t              lock;
> +};
> +
> +struct nuc900_bcd_time {
> +       int bcd_sec;
> +       int bcd_min;
> +       int bcd_hour;
> +       int bcd_mday;
> +       int bcd_mon;
> +       int bcd_year;
> +};
> +
> +static irqreturn_t nuc900_rtc_interrupt(int irq, void *_rtc)
> +{
> +       struct nuc900_rtc *rtc = _rtc;
> +       unsigned long events = 0, rtc_irq;
> +
> +       rtc_irq = __raw_readl(rtc->rtc_reg + REG_RTC_RIIR);
> +
> +       if (rtc_irq & ALARMINTENB) {
> +               rtc_irq &= ~ALARMINTENB;
> +               __raw_writel(rtc_irq, rtc->rtc_reg + REG_RTC_RIIR);
> +               events |= RTC_AF | RTC_IRQF;
> +       }
> +
> +       if (rtc_irq & TICKINTENB) {
> +               rtc_irq &= ~TICKINTENB;
> +               __raw_writel(rtc_irq, rtc->rtc_reg + REG_RTC_RIIR);
> +               events |= RTC_UF | RTC_IRQF;
> +       }
> +
> +       rtc_update_irq(rtc->rtcdev, 1, events);
> +
> +       return IRQ_HANDLED;
> +}
> +
> +static void check_rtc_power(struct nuc900_rtc *nuc900_rtc)
> +{
> +       unsigned int i;
> +       __raw_writel(INIRRESET, nuc900_rtc->rtc_reg + REG_RTC_INIR);
> +
> +       mdelay(10);
> +
> +       __raw_writel(AERPOWERON, nuc900_rtc->rtc_reg + REG_RTC_AER);
> +
> +       for (i = 0; i < 1000000; i++) {
> +               if (__raw_readl(nuc900_rtc->rtc_reg + REG_RTC_AER) & AERRWENB)
> +                       break;
> +       }
> +}
> +
> +static void nuc900_rtc_bcd2bin(unsigned int timereg,
> +                               unsigned int calreg, struct rtc_time *tm)
> +{
> +       tm->tm_mday     = bcd2bin(calreg >> 0);
> +       tm->tm_mon      = bcd2bin(calreg >> 8);
> +       tm->tm_year     = bcd2bin(calreg >> 16) + 100;
> +
> +       tm->tm_sec      = bcd2bin(timereg >> 0);
> +       tm->tm_min      = bcd2bin(timereg >> 8);
> +       tm->tm_hour     = bcd2bin(timereg >> 16);
> +
> +       rtc_valid_tm(tm);
> +}
> +
> +static void nuc900_rtc_bin2bcd(struct rtc_time *settm,
> +                                               struct nuc900_bcd_time *gettm)
> +{
> +       gettm->bcd_mday = bin2bcd(settm->tm_mday) << 0;
> +       gettm->bcd_mon  = bin2bcd(settm->tm_mon) << 8;
> +       gettm->bcd_year = bin2bcd(settm->tm_year - 100) << 16;
> +
> +       gettm->bcd_sec  = bin2bcd(settm->tm_sec) << 0;
> +       gettm->bcd_min  = bin2bcd(settm->tm_min) << 8;
> +       gettm->bcd_hour = bin2bcd(settm->tm_hour) << 16;
> +}
> +
> +static int nuc900_update_irq_enable(struct device *dev, unsigned int enabled)
> +{
> +       struct nuc900_rtc *rtc = dev_get_drvdata(dev);
> +
> +       if (enabled)
> +               __raw_writel(__raw_readl(rtc->rtc_reg + REG_RTC_RIER)|
> +                               (TICKINTENB), rtc->rtc_reg + REG_RTC_RIER);
> +       else
> +               __raw_writel(__raw_readl(rtc->rtc_reg + REG_RTC_RIER)&
> +                               (~TICKINTENB), rtc->rtc_reg + REG_RTC_RIER);
> +
> +       return 0;
> +}
I think you should lock irq before the serial read and write to the
REG_RTC_RIER register.


> +
> +static int nuc900_alarm_irq_enable(struct device *dev, unsigned int enabled)
> +{
> +       struct nuc900_rtc *rtc = dev_get_drvdata(dev);
> +
> +       if (enabled)
> +               __raw_writel(__raw_readl(rtc->rtc_reg + REG_RTC_RIER)|
> +                               (ALARMINTENB), rtc->rtc_reg + REG_RTC_RIER);
> +       else
> +               __raw_writel(__raw_readl(rtc->rtc_reg + REG_RTC_RIER)&
> +                               (~ALARMINTENB), rtc->rtc_reg + REG_RTC_RIER);
> +
> +       return 0;
> +}
> +
ditto
