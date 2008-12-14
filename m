Return-Path: <linux-kernel-owner+w=401wt.eu-S1754331AbYLNWFB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331AbYLNWFB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 17:05:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751889AbYLNWEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 17:04:53 -0500
Received: from mail.openmoko.org ([88.198.124.205]:57375 "EHLO
	mail.openmoko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbYLNWEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 17:04:53 -0500
Date: Mon, 15 Dec 2008 03:34:30 +0530
From: Balaji Rao <balajirrao@openmoko.org>
To: Alessandro Zummo <alessandro.zummo@towertech.it>
Cc: linux-kernel@vger.kernel.org, Andy Green <andy@openmoko.com>,
       rtc-linux@googlegroups.com
Subject: Re: [PATCH 4/7] rtc: PCF50633 rtc driver
Message-ID: <20081214220428.GA2741@cff.thadambail>
References: <20081214110152.3307.50843.stgit@cff.thadambail> <20081214110304.3307.53502.stgit@cff.thadambail> <20081214202956.1f97b906@i1501.lan.towertech.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081214202956.1f97b906@i1501.lan.towertech.it>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 14, 2008 at 08:29:56PM +0100, Alessandro Zummo wrote:
> On Sun, 14 Dec 2008 16:33:05 +0530
> Balaji Rao <balajirrao@openmoko.org> wrote:
> 
>  Hello,
> 
>   first review below. Please always add the rtc-linux mailing
>  list in cc so that patchwork[1] can track your submission.
> 
> [1]
>  http://patchwork.ozlabs.org/project/rtc-linux/list/?state=*
> 

OK, noted,

> > +#include <linux/bcd.h>
> > +
> > +#include <linux/mfd/pcf50633/core.h>
> 
> > +#include <linux/mfd/pcf50633/rtc.h>
> 
>  this file should be included with the patch.
> 

Hmm. This patch is included in [PATCH 1/7] of the series - which
implements the core driver. This core driver needs this file to compile
and not including there is going to break the bisectability of the
series. Isn't this what I'm supposed to do ? Please correct me if I'm
wrong.

> > +static void rtc2pcf_time(struct pcf50633_time *pcf, struct rtc_time *rtc)
> > +{
> > +	pcf->time[PCF50633_TI_SEC] = bin2bcd(rtc->tm_sec);
> > +	pcf->time[PCF50633_TI_MIN] = bin2bcd(rtc->tm_min);
> > +	pcf->time[PCF50633_TI_HOUR] = bin2bcd(rtc->tm_hour);
> > +	pcf->time[PCF50633_TI_WKDAY] = bin2bcd(rtc->tm_wday);
> > +	pcf->time[PCF50633_TI_DAY] = bin2bcd(rtc->tm_mday);
> > +	pcf->time[PCF50633_TI_MONTH] = bin2bcd(rtc->tm_mon);
> > +	pcf->time[PCF50633_TI_YEAR] = bin2bcd(rtc->tm_year - 100);
>  
>  you should add a check in the caller for tm_year < 100
> 

OK.

> > +	case RTC_PIE_OFF:
> > +		pcf->rtc.second_enabled = 0;
> > +		pcf50633_irq_mask(pcf, PCF50633_IRQ_SECOND);
> > +		return 0;
> > +	case RTC_PIE_ON:
> > +		pcf->rtc.second_enabled = 1;
> > +		pcf50633_irq_unmask(pcf, PCF50633_IRQ_SECOND);
> > +		return 0;
> > +	}
> 
>  we have recently improved the API for interrupts handling.
>  the patch is now in -mm and you can check it here: 
>  http://patchwork.ozlabs.org/patch/10039/
> 
>  that involves AIE and UIE.
> 
>  the API for PIE was always there and it's implemented by ops->irq_set_state
>  and ops->irq_set_freq
> 
>  Is your PIE a real PIE or an UIE?
> 
OK.

Oh.. yes, it's actually an UIE! Sorry about that - will change.

> > +	pcf = dev_get_drvdata(dev);
> > +
> > +	ret = pcf50633_read_block(pcf, PCF50633_REG_RTCSC,
> > +					    PCF50633_TI_EXTENT,
> > +					    &pcf_tm.time[0]);
> > +	if (ret != PCF50633_TI_EXTENT)
> > +		dev_err(dev, "Failed to read time\n");
> 
>  so return -EIO or something to that effect.
> 

OK.

> > +	dev_dbg(dev, "PCF_TIME: %02x.%02x.%02x %02x:%02x:%02x\n",
> > +		pcf_tm.time[PCF50633_TI_DAY],
> > +		pcf_tm.time[PCF50633_TI_MONTH],
> > +		pcf_tm.time[PCF50633_TI_YEAR],
> > +		pcf_tm.time[PCF50633_TI_HOUR],
> > +		pcf_tm.time[PCF50633_TI_MIN],
> > +		pcf_tm.time[PCF50633_TI_SEC]);
> > +
> > +	pcf2rtc_time(tm, &pcf_tm);
> > +
> > +	dev_dbg(dev, "RTC_TIME: %u.%u.%u %u:%u:%u\n",
> > +		tm->tm_mday, tm->tm_mon, tm->tm_year,
> > +		tm->tm_hour, tm->tm_min, tm->tm_sec);
> > +
> > +	return 0;
> 
>  nope. always return rtc_valid_tm(tm);
> 

OK.

> > +
> > +	ret = pcf50633_write_block(pcf, PCF50633_REG_RTCSC,
> > +					     PCF50633_TI_EXTENT,
> > +					     &pcf_tm.time[0]);
> > +	if (ret)
> > +		dev_err(dev, "Failed to set time %d\n", ret);
> > +
> > +	if (!second_masked)
> > +		pcf50633_irq_unmask(pcf, PCF50633_IRQ_SECOND);
> > +	if (!alarm_masked)
> > +		pcf50633_irq_unmask(pcf, PCF50633_IRQ_ALARM);
> > +
> > +	return ret;
> 
>  is this ret an appropriate error code?
> 

Oops! No, it's wrong. Will fix.

> > +	ret = pcf50633_read_block(pcf, PCF50633_REG_RTCSCA,
> > +				PCF50633_TI_EXTENT, &pcf_tm.time[0]);
> > +
> > +	if (ret != PCF50633_TI_EXTENT)
> > +		dev_err(dev, "Failed to read Alarm time %d\n", ret);
> > +
> > +	pcf2rtc_time(&alrm->time, &pcf_tm);
> > +
> > +	return ret;
> 
>  probably wrong, ret must be 0 on success.
> 

Right. Will fix.

> > +	struct rtc_device *rtc;
> > +	struct pcf50633 *pcf;
> > +
> > +	rtc = rtc_device_register("pcf50633-rtc", &pdev->dev,
> > +					&pcf50633_rtc_ops, THIS_MODULE);
> > +	if (IS_ERR(rtc))
> > +		return -ENODEV;
> 
>  nope. if IS_ERR means that the rtc pointer has a valid error
>  code that you should return to the caller.
> 

Fine. Will change.

> > +	pcf = platform_get_drvdata(pdev);
> 
>  uh? where did you set up the pointer?
> 
> 
> > +	/* Set up IRQ handlers */
> > +	pcf->irq_handler[PCF50633_IRQ_ALARM].handler = pcf50633_rtc_irq;
> > +	pcf->irq_handler[PCF50633_IRQ_SECOND].handler = pcf50633_rtc_irq;
> > +
> > +	pcf->rtc.rtc_dev = rtc;
> 
>  ??
> 

It's done in the core driver - [PATCH 1/7] of this series.

> > +	.probe = pcf50633_rtc_probe,
> > +	.remove = __devexit_p(pcf50633_rtc_remove),
> 
>   you marked __devexit_p but forgot to mark the function
>  itself.
> 

Oh! will fix.

> > +{
> > +	return platform_driver_register(&pcf50633_rtc_driver);
> 
>  can't you use platform_driver_probe ?
> 

Yes, I probably can. Will change.

Thank you for the review. Will send again after resolving the issues.

	- Balaji 
