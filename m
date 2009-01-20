Return-Path: <linux-kernel-owner+w=401wt.eu-S1760192AbZATJaN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760192AbZATJaN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 04:30:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755166AbZATJ3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 04:29:52 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34264 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726AbZATJ3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 04:29:49 -0500
Date: Tue, 20 Jan 2009 10:29:44 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20090120092944.GA2369@pengutronix.de>
References: <S1757830AbZALWQu/20090112221650Z+1710@vger.kernel.org> <1231799107-20136-8-git-send-email-u.kleine-koenig@pengutronix.de> <ca2dc2820901200013y3723785cjb4ca4a0e223f7993@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ca2dc2820901200013y3723785cjb4ca4a0e223f7993@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ukl@pengutronix.de
Subject: Re: [PATCH] move cfag12864bfb's probe function to .devinit.text
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Miguel,

On Tue, Jan 20, 2009 at 09:13:25AM +0100, Miguel Ojeda wrote:
> On Mon, Jan 12, 2009 at 11:24 PM, Uwe Kleine-König
> <u.kleine-koenig@pengutronix.de> wrote:
> > An alternative to this patch is using platform_driver_probe instead of
> > platform_driver_register plus removing the pointer to the probe function
> > from the struct platform_driver.
> 
> Is that solution better? What are the pros/cons?
When using platform_driver_probe only devices that are already available
are probed.  There is no way you can bind a device that was registered
after the call to platform_driver_probe or that was once unbound via
sysfs.  In return your .probe function can live in .init.text and so you
can save some RAM.  (Note, that for modular drivers the situation is a
bit different because you can reload your modules (assuming it supports
unloading) and then you get a new platform_driver_probe call.  This
doesn't matter though, because either the devices are available before
you can load your module or your module creates the devices itself.)

I think for many drivers using platform_driver_probe is the more
sensible way, but it needs a deeper look and/or more testing.  With the
unfixed code a device that is created after platform_driver_register but
before the init sections are discarded is correctly bound.  After
changing to platform_driver_probe this is not the case anymore.  That's
why I choosed to stay with platform_driver_register for my patches.

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
Peiner Strasse 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686              | Fax:   +49-5121-206917-5555 |
