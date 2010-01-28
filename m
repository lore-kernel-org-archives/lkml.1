Return-Path: <linux-kernel-owner+w=401wt.eu-S1755899Ab0A1BX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899Ab0A1BX6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 20:23:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755841Ab0A1BX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 20:23:56 -0500
Received: from kroah.org ([198.145.64.141]:46854 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755842Ab0A1BXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 20:23:54 -0500
Date: Wed, 27 Jan 2010 17:14:03 -0800
From: Greg KH <greg@kroah.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] platform_driver_register: warn if probe is in
 .init.text
Message-ID: <20100128011403.GB24068@kroah.com>
References: <20100122173846.GA11057@suse.de>
 <1264189758-7197-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <87y6jnw6qa.fsf@devron.myhome.or.jp>
 <20100126084741.GC20792@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100126084741.GC20792@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 09:47:41AM +0100, Uwe Kleine-König wrote:
> Hello,
> 
> On Mon, Jan 25, 2010 at 06:09:01AM +0900, OGAWA Hirofumi wrote:
> > Uwe Kleine-König <u.kleine-koenig@pengutronix.de> writes:
> > 
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
> > > +#endif
> > > +	return ret;
> > > +}
> > 
> > Um..., can't we extend modpost or such one for this? I think the static
> > analysis is better (assume the changing ->probe dynamically is really
> > rare).
> I like the idea and will look later into modpost if this can be done
> there.

That would be nice to do instead, as we already do checks like this
today, and might make more sense.

And could you do it for all probe functions, and not just the platform
devices?  Don't all busses have this same problem?

thanks,

greg k-h
