Return-Path: <linux-kernel-owner+w=401wt.eu-S1754430Ab0AYRPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430Ab0AYRPB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 12:15:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754421Ab0AYRO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 12:14:59 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:34739 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754290Ab0AYRO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 12:14:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=TnAX7BhpSgZJSFPJwl22lv8478PP2RHvmRsn+/XMAyn4Gfa/m2FBExCd5y2btLHMvE
         Xw8H/7GJQIcWdYjhORO5khdc4Hv73I9gkb7whTx2UwiwNQMwlaa9D/MJ+/0jzqt6Sz9a
         xsYaIe56VmDYi05elLLASJ8nFmkxHNtJLEA2Q=
Date: Mon, 25 Jan 2010 09:14:39 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] platform_driver_register: warn if probe is in .init.text
Message-ID: <20100125171439.GA27387@core.coreip.homeip.net>
References: <20100122173846.GA11057@suse.de>
 <1264189758-7197-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <20100122234936.GA14538@core.coreip.homeip.net>
 <20100123094916.GA24949@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100123094916.GA24949@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 23, 2010 at 10:49:16AM +0100, Uwe Kleine-König wrote:
> Helle Dmitry,
> 
> On Fri, Jan 22, 2010 at 03:49:37PM -0800, Dmitry Torokhov wrote:
> > On Fri, Jan 22, 2010 at 08:49:18PM +0100, Uwe Kleine-König wrote:
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
> > 
> > What about CONFIG_MODULE case (without hotplug)? The driver may be
> > compiled in (and thus probe will be discarded) but device might be
> > created by a loadable module which is loaded later.
> I don't see the problem here.

You are right, without hotplug we don't try to bind to devices that
come in later so we are safe to discard probe.

>  If the driver is registered using
> platform_driver_register and the probe function lives in .init.text it
> doesn't matter where the device comes from.  If there is one you can
> unbind and bind at a later time when .init is already discarded.  No?
> 

Yes.

> More general, using platform_driver_register the pointer to the probe
> function have to stay valid as it is saved for later use, so it must not
> be an .init pointer.


> 
> > > +	if (drv->probe && kernel_init_text_address((unsigned long)drv->probe))
> > > +		pr_warning("oops-warning: probe function of platform driver %s"
> > > +			       " lives in .init.text\n", drv->driver.name);
> > > +#else
> > > +	/*
> > > +	 * without HOTPLUG probe functions can be discarded after the driver is
> > > +	 * loaded.
> > > +	 * There is a little chance for false positives, namely if the driver is
> > > +	 * registered after the .init sections are discarded.
> > > +	 */
> > > +	if (drv->probe && !kernel_init_text_address((unsigned long)drv->probe))
> > > +		pr_info("probably the probe function of platform driver %s can"
> > > +				" be moved to .init.text\n", drv->driver.name);
> > 
> > It really depends on the user's (or rather builder's) local
> > configuration so how can we make this suggestion?
> Can you point out a situation that makes the suggestion wrong?  AFAIK
> there only the possibility that the driver is loaded after .init is
> discarded (as written in the comment).
> 

The presence of CONFIG_HOTPLUG depends on particular .config, so, for
example, you may not have it set while I have. So you will boot, get the
suggestion, submit a patch, then I will boot and will get a warning that
the probe function is in wrong section.

So in general I wonder if it is possible to request that all probe
functions are marked as __devinit or not marked at all, regardless of
CONFIG_HOTPLUG and CONFIG_MODULE settings.

-- 
Dmitry
