Return-Path: <linux-kernel-owner+w=401wt.eu-S1752625AbXDMHkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625AbXDMHkL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 03:40:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752652AbXDMHkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 03:40:10 -0400
Received: from mx33.mail.ru ([194.67.23.194]:5943 "EHLO mx33.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752625AbXDMHkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 03:40:09 -0400
Date: Fri, 13 Apr 2007 11:36:50 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: David Brownell <david-b@pacbell.net>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/7] [RFC] Common power driver for Linux gadgets
Message-ID: <20070413073650.GA3763@zarina>
Reply-To: cbou@mail.ru
References: <200704122306.46518.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <200704122306.46518.david-b@pacbell.net>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello David,

On Thu, Apr 12, 2007 at 11:06:46PM -0700, David Brownell wrote:
> > This driver used to stop code/logic duplication through different
> > machines we porting at handhelds.org. pda_power register machs' power
> > supplies, and will take care about notifying batteries about power
> > changes through external power interface.
> 
> It gets USB power management wrong though.  Have a look at two I2C drivers
> in drivers/i2c/chips:  tps65010.c (which would talk to this API) and then
> isp1301_omap.c (which would talk to the tps65010 driver).  The tps65010
> chip accepts the same two power sources you're addressing here, as part
> of its battery charging responsibilities. [1]
> 
> Key points:
> 
>  - The API needs to say *how much power* can be drawn.  Common values
>    are 8 mA (OTG peripherals before configuration), 100 mA (non-OTG ones
>    before configuration), 500 mA (high power configurations) ... but the
>    exact value depends on what's listed in the configuration descriptor
>    for the chosen configuration, any value 0..500 mA (increments of two)
>    could be appropriate.
> 
>  - Sensing VBUS power is not the same thing as being allowed to consume
>    it.  Again, USB OTG devices are different:  OTG hosts **SUPPLY** the
>    current, so you really don't want to be telling the OTG transceiver to
>    fire up its charge pump (say, 3.0V VBAT converted to 5V VBUS) while at
>    the same time telling the battery manager to use that battery-derived
>    VBUS current to recharge its battery!  Not only would that waste power,
>    but it also deprives the peripheral of the power it needs to draw.
> 
> In general, no component other than the USB peripheral (or host) controller
> driver has any business trying to control how VBUS power is used.  It's
> likely to get it wrong ... as shown by this patch.  ;)
> 
> And that's exactly why the USB gadget API has had calls to manage the USB
> power consumption since mid-2004.  And I wonder why H5000 code evidently
> doesn't implement those calls.
> 
> - Dave
> 
> [1] You may find http://www.linux-usb.org/gadget/h2-otg.html useful too.
>     It gives a high level map of the complicated OTG case, including
>     those drivers, and points out how simpler peripheral-only systems
>     could behave with the same drivers.  However it does turn out to
>     be useful if USB peripheral drivers have a "transciever" notion
>     that can receive "VBUS present" interrupts, letting the peripheral
>     controller driver power down almost *everything* to save power,
>     and that otg_transceiver interface does that job.

I see. Current devices I have just consumes power from USB host. I.e.
they able to boot using only USB and discharged battery. :-/ Even
more, HP iPaq hx4700 able to charge battery from USB (using that driver).
We just setting USB charging GPIO, and it starts consume power from
the host.

But I got the point, and yes I can't explain why it works correctly.

(1) Anyway, you're hinting that you'd want to see some
"usb_vbus_start_consume_power(how much)" callback, which will be
handled by gadget driver? Or it should just start using some gadget api?
Or even pda_battery must become an "usb power supplicant" gadget itself
to consume power by law?

-

I'm stuck in null-modem century, so don't wonder my USB-dumbness.
Will read http://www.linux-usb.org/gadget/h2-otg.html, of course.

Though I'd appreciate answers for (1), thus I can think in right
direction from the start.

Much thanks for your comments.

-- 
Anton Vorontsov
email: cbou@mail.ru
backup email: ya-cbou@yandex.ru
irc://irc.freenode.org/bd2
