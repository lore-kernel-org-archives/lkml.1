Return-Path: <linux-kernel-owner+w=401wt.eu-S1754367Ab0AWJtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367Ab0AWJtT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 04:49:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753986Ab0AWJtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 04:49:19 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52289 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471Ab0AWJtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 04:49:18 -0500
Date: Sat, 23 Jan 2010 10:49:16 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] platform_driver_register: warn if probe is in
	.init.text
Message-ID: <20100123094916.GA24949@pengutronix.de>
References: <20100122173846.GA11057@suse.de> <1264189758-7197-1-git-send-email-u.kleine-koenig@pengutronix.de> <20100122234936.GA14538@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100122234936.GA14538@core.coreip.homeip.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Helle Dmitry,

On Fri, Jan 22, 2010 at 03:49:37PM -0800, Dmitry Torokhov wrote:
> On Fri, Jan 22, 2010 at 08:49:18PM +0100, Uwe Kleine-König wrote:
> > +int platform_driver_register(struct platform_driver *drv)
> > +{
> > +	int ret = __platform_driver_register(drv);
> > +
> > +#if defined(CONFIG_HOTPLUG)
> > +	/*
> > +	 * drivers that are registered by platform_driver_register
> > +	 * should not have their probe function in .init.text.  The
> > +	 * reason is that a probe can happen after .init.text is
> > +	 * discarded which then results in an oops.  The alternatives
> > +	 * are using .devinit.text for the probe function or "register"
> > +	 * with platform_driver_probe.
> > +	 */
> 
> 
> What about CONFIG_MODULE case (without hotplug)? The driver may be
> compiled in (and thus probe will be discarded) but device might be
> created by a loadable module which is loaded later.
I don't see the problem here.  If the driver is registered using
platform_driver_register and the probe function lives in .init.text it
doesn't matter where the device comes from.  If there is one you can
unbind and bind at a later time when .init is already discarded.  No?

More general, using platform_driver_register the pointer to the probe
function have to stay valid as it is saved for later use, so it must not
be an .init pointer.

> > +	if (drv->probe && kernel_init_text_address((unsigned long)drv->probe))
> > +		pr_warning("oops-warning: probe function of platform driver %s"
> > +			       " lives in .init.text\n", drv->driver.name);
> > +#else
> > +	/*
> > +	 * without HOTPLUG probe functions can be discarded after the driver is
> > +	 * loaded.
> > +	 * There is a little chance for false positives, namely if the driver is
> > +	 * registered after the .init sections are discarded.
> > +	 */
> > +	if (drv->probe && !kernel_init_text_address((unsigned long)drv->probe))
> > +		pr_info("probably the probe function of platform driver %s can"
> > +				" be moved to .init.text\n", drv->driver.name);
> 
> It really depends on the user's (or rather builder's) local
> configuration so how can we make this suggestion?
Can you point out a situation that makes the suggestion wrong?  AFAIK
there only the possibility that the driver is loaded after .init is
discarded (as written in the comment).

Thanks
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
