Return-Path: <linux-kernel-owner+w=401wt.eu-S1755124AbZF2Hzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124AbZF2Hzn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 03:55:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753059AbZF2Hzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 03:55:36 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38638 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbZF2Hzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 03:55:35 -0400
Date: Mon, 29 Jun 2009 09:55:35 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] platform_driver_register:  warn if probe is in
	.init.text
Message-ID: <20090629075535.GA20155@pengutronix.de>
References: <20090616182310.GC13048@pengutronix.de> <1245418939-20758-1-git-send-email-u.kleine-koenig@pengutronix.de> <20090619141128.GA11506@suse.de> <20090619144354.GA20985@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090619144354.GA20985@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Fri, Jun 19, 2009 at 04:43:54PM +0200, Uwe Kleine-König wrote:
> On Fri, Jun 19, 2009 at 07:11:28AM -0700, Greg KH wrote:
> > On Fri, Jun 19, 2009 at 03:42:19PM +0200, Uwe Kleine-König wrote:
> > > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > > ---
> > >  drivers/base/platform.c |   42 ++++++++++++++++++++++++++++++++++++------
> > >  include/linux/kernel.h  |    2 ++
> > >  include/linux/module.h  |   12 ++++++++++++
> > >  kernel/extable.c        |   12 ++++++++++++
> > >  kernel/module.c         |   36 ++++++++++++++++++++++++++++++++++++
> > >  5 files changed, 98 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> > > index 81cb01b..851ba84 100644
> > > --- a/drivers/base/platform.c
> > > +++ b/drivers/base/platform.c
> > > @@ -470,11 +470,7 @@ static void platform_drv_shutdown(struct device *_dev)
> > >  	drv->shutdown(dev);
> > >  }
> > >  
> > > -/**
> > > - * platform_driver_register
> > > - * @drv: platform driver structure
> > > - */
> > > -int platform_driver_register(struct platform_driver *drv)
> > > +static int __platform_driver_register(struct platform_driver *drv)
> > >  {
> > >  	drv->driver.bus = &platform_bus_type;
> > >  	if (drv->probe)
> > > @@ -489,6 +485,40 @@ int platform_driver_register(struct platform_driver *drv)
> > >  
> > >  	return driver_register(&drv->driver);
> > >  }
> > > +
> > > +/**
> > > + * platform_driver_register
> > > + * @drv: platform driver structure
> > > + */
> > > +int platform_driver_register(struct platform_driver *drv)
> > > +{
> > > +	int ret = __platform_driver_register(drv);
> > > +
> > > +#if defined(CONFIG_HOTPLUG)
> > > +	/*
> > > +	 * drivers that are registered by platform_driver_register
> > > +	 * should not have their probe function in .init.text.  The
> > > +	 * reason is that a probe can happen after .init.text is
> > > +	 * discarded which then results in an oops.  The alternatives
> > > +	 * are using .devinit.text for the probe function or "register"
> > > +	 * with platform_driver_probe.
> > > +	 */
> > 
> > That's not true, remember, drivers built into the system, like platform
> > ones, can have their probe function in .init.text, as it will be called
> > before we discard .init.text, and will never be called again as the
> > device will never be "hot added" at any future time.
> > 
> > So this could trigger a lot of false positives :(
> IMHO this is not a false positive.  You can still do
> 
> 	for f in unbind bind do echo $deviceid > /sys/bus/platform/drivers/$drivername/$f; done
> 
> This type of driver should use platform_driver_probe.
Are you conviced and took the patch or did you give up to convince me?

I still think the patch is correct and I'd like to have it applied.

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
