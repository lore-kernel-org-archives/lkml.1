Return-Path: <linux-kernel-owner+w=401wt.eu-S1753626AbXDMLeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626AbXDMLeS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 07:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753600AbXDMLeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 07:34:18 -0400
Received: from mx34.mail.ru ([194.67.23.200]:29170 "EHLO mx27.mail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753626AbXDMLeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 07:34:17 -0400
Date: Fri, 13 Apr 2007 15:30:56 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: David Brownell <david-b@pacbell.net>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/7] [RFC] Common power driver for Linux gadgets
Message-ID: <20070413113056.GA16342@zarina>
Reply-To: cbou@mail.ru
References: <200704122306.46518.david-b@pacbell.net> <200704130142.37081.david-b@pacbell.net> <20070413095237.GA14851@zarina> <200704130325.13813.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <200704130325.13813.david-b@pacbell.net>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2007 at 03:25:13AM -0700, David Brownell wrote:
> On Friday 13 April 2007 2:52 am, Anton Vorontsov wrote:
> > > > But I got the point, and yes I can't explain why it works correctly.
> > > 
> > > It probably doesn't work correctly.  But it's not broken enough to
> > > fail badly.
> > 
> > Can that comment be an explanation?
> > 
> > --- drivers/usb/gadget/pxa2xx_udc.c:
> > static const struct usb_gadget_ops pxa2xx_udc_ops = {
> >         .get_frame      = pxa2xx_udc_get_frame,
> >         .wakeup         = pxa2xx_udc_wakeup,
> >         .vbus_session   = pxa2xx_udc_vbus_session,
> >         .pullup         = pxa2xx_udc_pullup,
> > 
> >         // .vbus_draw ... boards may consume current from VBUS, up to
> >         // 100-500mA based on config.  the 500uA suspend ceiling means
> >         // that exclusively vbus-powered PXA designs violate USB specs.
> 
> That's basically a "plug in implementation here".  Nobody's yet done
> that on a platform that _uses_ the VBUS power.
> 
> 
> > };
> > 
> > 
> > Comparing to omap_udc.
> > 
> > --- drivers/usb/gadget/omap_udc.c
> > static int omap_vbus_draw(struct usb_gadget *gadget, unsigned mA)
> > {
> >         struct omap_udc *udc;
> > 
> >         udc = container_of(gadget, struct omap_udc, gadget);
> >         if (udc->transceiver)
> >                 return otg_set_power(udc->transceiver, mA);
> 
> Where the transceiver would then delegate to something else,
> like the tps65010 driver.
> 
> 
> >         return -EOPNOTSUPP;
> > }
> > [...]
> > static struct usb_gadget_ops omap_gadget_ops = {
> >         .get_frame              = omap_get_frame,
> >         .wakeup                 = omap_wakeup,
> >         .set_selfpowered        = omap_set_selfpowered,
> >         .vbus_session           = omap_vbus_session,
> >         .vbus_draw              = omap_vbus_draw,
> 
> .... which has most certainly been on platforms which are hooked
> up to draw power from VBUS.
> 
> 
> >         .pullup                 = omap_pullup,
> > };
> > 
> > 
> > 
> > Regarding API. If you all you want is to know how much power you need to
> > ask from VBUS, we can extend external power interface... thus suppliers
> > could ask their power consumption requirements in mA/uA, and these
> > requests will be forwarded to power supply driver, and power driver will
> > forward that request to USB transceiver (via platform hook).
> 
> I don't folow what you're saying.  The control flow *MUST* be that
> the USB stack provides the only indication of how much power may
> be drawn through the VBUS supply.  Nothing else in the system has
> the knowledge of what's legal, and when.
> 
> If you want to talk about a "supplier", the way to put it might
> then be that the USB stack is saying "here's N mA power for you";
> it's supplying the power, not the other way around.
> 
> There's no "ask" involved, since the host controls "N".  So the
> host supplies, the USB gadget stack interprets that, and some
> power component must obeys.  That includes rules like reducing
> VBUS draw to ~500 uA when the host suspends the USB link.

This framework (pda_power) support ability to charge from USB. But
it is only dispatcher, which implements logic. Issues like what
exact mA to draw, and how all that communicate to USB stack, left
to specific devices and/or additional drivers, users of framework.

In this regard, "USB" is just a label. Can be replaced with
"alternative power source".

> - Dave

-- 
Anton Vorontsov
email: cbou@mail.ru
backup email: ya-cbou@yandex.ru
irc://irc.freenode.org/bd2
