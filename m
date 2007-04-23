Return-Path: <linux-kernel-owner+w=401wt.eu-S1754072AbXDWJTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072AbXDWJTa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 05:19:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754077AbXDWJTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 05:19:30 -0400
Received: from smtp-101-monday.nerim.net ([62.4.16.101]:3490 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754072AbXDWJT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 05:19:29 -0400
Date: Mon, 23 Apr 2007 11:19:50 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Vitaly Bordug <vitb@kernel.crashing.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
       "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>
Subject: Re: [PATCH][RFC] i2c: adds support for i2c bus on 8xx
Message-ID: <20070423111950.129856eb@hyperion.delvare>
In-Reply-To: <20070422152937.7332fc31@localhost.localdomain>
References: <20070420082714.4f10f186@localhost.localdomain>
	<20070421095707.6b42a312@hyperion.delvare>
	<20070422152937.7332fc31@localhost.localdomain>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vitaly,

On Sun, 22 Apr 2007 15:29:37 +0400, Vitaly Bordug wrote:
> On Sat, 21 Apr 2007 09:57:07 +0200 Jean Delvare wrote:
> > I wonder what's the point of having a separate i2c algorithm driver.
> > We don't expect any other driver than i2c-rpx to ever use it, do we?
> > In that case, all the code should be added to i2c-rpx directly, this
> > will makes things more simple and more efficient.
>
> That is how it was back in 2.4 - if you see combine is a good move,
> I'm OK with it. But what shouldn't be rpc then - basically rpx(lite) is
> 8xx-based target, so let's call it all mpc8xx then.

Sure, I'm fine with a name change. If it makes more sense to name that
driver i2c-mpc8xx, that's OK with me.

> > > +		tmo = jiffies + 1 * HZ;
> > > +		while (!(in_8(&i2c->i2c_i2cer) & 0x11 || time_after(jiffies, tmo))) ;/* Busy wait, with a timeout */
> > 
> > This could result in a one-second busy loop, not very friendly for
> > other drivers. It should sleep while waiting. Line too long, please
> > fold.
>
> Can you please elaborate a little here (or just point to the
> similar code)? I assume we should not block here, handling timeout
> in a waitqueue...

Blocking is not a problem. The problem is that you are keeping the CPU
for yourself while waiting, for up to one full second. That's not
acceptable. You should at least call schedule() or cond_resced() (I
don't know the difference, I admit) and/or cpu_relax() as is done in
i2c-mpc, i2c-ibm_iic and scx200_acb, or even sleep, as is done in
i2c-omap. Search for "time_after" in these 4 drivers for examples. I
believe that sleeping is more friendly.

> > You do not appear to handle repeated start. I can tell because the
> > code handles all messages the exact same way, be they the first,
> > second or last message of a group. This means that you don't really
> > implement the I2C protocol, but an approximation of it. It might be
> > sufficient for some I2C chips, but others will break. Look in the
> > specifications of your device for how this could be fixed.
>
> I doubt 8xx has a full-fledged i2c protocol stuff onboard, and basic
> code that were residing in 2.4 repo suite my needs quite well (afaict
> many others just don't care :)).
> I just think it is silly to drop the code already implemented and working
> even if it requires some efforts to bring it up to shape.

Well as far as I can see, only the repeated start is missing, so it's
not that far from a complete implementation. If the hardware can do it,
you simply have to add it to the driver. If the hardware really doesn't
do it (which would surprise me, but you never know), of course you
cannot implement it in the driver and we'll have to live with (well,
without) it. But that's definitely an issue to keep in mind if I2C chip
drivers start failing when used together with this bus driver.

> > > +static struct i2c_adapter rpx_ops = {
> > 
> > Could be const?
> > 
> prolly yes.
> > > +	.owner		= THIS_MODULE,
> > > +	.name		= "m8xx",
> > 
> > Find a better name (e.g. "i2c-rpx").
> > 
> What about mpc8xx?

i2c-mpc8xx then, OK.

> > > +/* Structure for a device driver */
> > > +static struct device_driver i2c_rpx_driver = {
> > > +	.name = "fsl-i2c-cpm",
> > > +	.bus = &platform_bus_type,
> > > +	.probe = i2c_rpx_probe,
> > > +	.remove = i2c_rpx_remove,
> > > +};
> > 
> > Why don't you declare it as a struct platform_driver, register it with
> > platform_driver_register() and unregister it with
> > platform_driver_unregister()?
>
> Well. This stuff belongs to CPM1, of the mpc8xx family, but the
> target boards are different, and they may/should provide board
> specific inits and filling of platform data. With
> platform_driver_register we may end up with ifdef stuff here
> (which is evil).

I don't follow you here, sorry. Platform devices are declared by
board-specific code which can include all the needed initialization.
And device-specific data can be carried to the platform driver for
further use. The platform device/driver infrastructure is meant to
handle that kind of situation, so there really is no excuse that I can
see not to use it. i2c-omap and i2c-mpc use it. As a matter of fact you
_are_ declaring a platform driver (.bus = &platform_bus_type), just not
using the standard way.

-- 
Jean Delvare
