Return-Path: <linux-kernel-owner+w=401wt.eu-S1753401AbZHJU5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401AbZHJU5U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 16:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753020AbZHJU5U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 16:57:20 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41127 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904AbZHJU5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 16:57:19 -0400
Date: Mon, 10 Aug 2009 21:57:13 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alessandro Zummo <alessandro.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com, Samuel Ortiz <sameo@linux.intel.com>,
       linux-kernel@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>
Message-ID: <20090810205712.GA4528@sirena.org.uk>
References: <1249922635-31864-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1249922635-31864-4-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20090810205535.4fb160af@i1501.lan.towertech.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090810205535.4fb160af@i1501.lan.towertech.it>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [rtc-linux] [PATCH 4/5] RTC: Add support for RTCs on Wolfson
 WM831x devices
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 10, 2009 at 08:55:35PM +0200, Alessandro Zummo wrote:
> Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

>  given you have your own include directory undef mfd/
>  you might want to move those #defines there

Unlike the others these registers can't really be used outside of this
driver - for the other drivers there's potential for at least platform
specific code if not multiple drivers to use some or all of the register
definitions.

> > +struct wm831x_rtc {
> > +	struct wm831x *wm831x;
> > +	struct rtc_device *rtc;
> > +	int alarm_enabled;
> > +	int per_irq;

>  are those tows int or unsigned int? 

I've just dropped per_irq, it's not needed anyway.

>  or maybe alarm_enabled could be :1 ?

Done, but it doesn't really buy us much given that there's nothing
else to pack it with.

> > +/*
> > + * Set current time and date in RTC
> > + */
> > +static int wm831x_rtc_settime(struct device *dev, struct rtc_time *tm)

>  isn't rtc_set_mmss more appropriate?

Hrm, I think so so I've made the change.  It's not a particularly
discoverable API - the fact that there's no readback equivalent hides
the fact that it's supposed to be an equivalent for settime.  Some
documentation would really help here.

> > +	ret = wm831x_set_bits(wm831x_rtc->wm831x, WM831X_RTC_CONTROL,
> > +			      WM831X_RTC_ALM_ENA, enable);
> > +	if (ret != 0)
> > +		dev_err(&pdev->dev, "Failed to update RTC alarm: %d\n", ret);
> > +
> > +	return 0;

>  always 0 ? (also below..)

Failing suspend and resume due to failure to disable the RTC alarm
would be excessive - indeed, I'd expect the overwhelming majority of
systems to function perfectly well with no suspend/resume support in the
driver at all.  RTC alarms are infrequent relative to other
suspend/resume events in typical systems but suspend is normally used
fairly heavily to preserve battery (typical applications include things
like MP3 players or phones).  Typically the error handling would at best
cause more serious consequences than the original error and there's
little chance the user will be able to even report the error.

> > +static int __init wm831x_rtc_init(void)
> > +{
> > +	return platform_driver_register(&wm831x_rtc_driver);

>  can you use platform_driver_probe() ?

No, this is a MFD accessed over slow buses and we can't guarantee that
the device will be registered.

Fixed everything else, will repost tomorrow.
