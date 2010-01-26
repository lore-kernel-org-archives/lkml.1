Return-Path: <linux-kernel-owner+w=401wt.eu-S1752592Ab0AZIrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592Ab0AZIrr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 03:47:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752027Ab0AZIrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 03:47:45 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43904 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864Ab0AZIro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 03:47:44 -0500
Date: Tue, 26 Jan 2010 09:47:41 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] platform_driver_register: warn if probe is in
	.init.text
Message-ID: <20100126084741.GC20792@pengutronix.de>
References: <20100122173846.GA11057@suse.de> <1264189758-7197-1-git-send-email-u.kleine-koenig@pengutronix.de> <87y6jnw6qa.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87y6jnw6qa.fsf@devron.myhome.or.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Jan 25, 2010 at 06:09:01AM +0900, OGAWA Hirofumi wrote:
> Uwe Kleine-König <u.kleine-koenig@pengutronix.de> writes:
> 
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
> > +#endif
> > +	return ret;
> > +}
> 
> Um..., can't we extend modpost or such one for this? I think the static
> analysis is better (assume the changing ->probe dynamically is really
> rare).
I like the idea and will look later into modpost if this can be done
there.

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
