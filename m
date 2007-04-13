Return-Path: <linux-kernel-owner+w=401wt.eu-S1753149AbXDMJ42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149AbXDMJ42 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 05:56:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753174AbXDMJ42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 05:56:28 -0400
Received: from mx3.mail.ru ([194.67.23.149]:14421 "EHLO mx3.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753149AbXDMJ41 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 05:56:27 -0400
Date: Fri, 13 Apr 2007 13:52:37 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: David Brownell <david-b@pacbell.net>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/7] [RFC] Common power driver for Linux gadgets
Message-ID: <20070413095237.GA14851@zarina>
Reply-To: cbou@mail.ru
References: <200704122306.46518.david-b@pacbell.net> <20070413073650.GA3763@zarina> <200704130142.37081.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <200704130142.37081.david-b@pacbell.net>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2007 at 01:42:36AM -0700, David Brownell wrote:
> On Friday 13 April 2007 12:36 am, Anton Vorontsov wrote:
> > Hello David,
> > > 
> > >  - The API needs to say *how much power* can be drawn...
> > > 
> > >  - Sensing VBUS power is not the same thing as being allowed to consume
> > >    it.  Again, USB OTG devices are different:  OTG hosts **SUPPLY** the
> > >    current, ...
> > 
> > I see. Current devices I have just consumes power from USB host. I.e.
> > they able to boot using only USB and discharged battery. :-/ Even
> > more, HP iPaq hx4700 able to charge battery from USB (using that driver).
> > We just setting USB charging GPIO, and it starts consume power from
> > the host.
> 
> Sounds like it could be more power than the host expects it to consume;
> or in some cases, not as much as it could ... ISTR only the Ethernet
> gadget defaults to 100mA (in non-OTG configs), the others are set for
> only 2 mA (expecting self-powered configs).
> 
> 
> > But I got the point, and yes I can't explain why it works correctly.
> 
> It probably doesn't work correctly.  But it's not broken enough to
> fail badly.

Can that comment be an explanation?

--- drivers/usb/gadget/pxa2xx_udc.c:
static const struct usb_gadget_ops pxa2xx_udc_ops = {
        .get_frame      = pxa2xx_udc_get_frame,
        .wakeup         = pxa2xx_udc_wakeup,
        .vbus_session   = pxa2xx_udc_vbus_session,
        .pullup         = pxa2xx_udc_pullup,

        // .vbus_draw ... boards may consume current from VBUS, up to
        // 100-500mA based on config.  the 500uA suspend ceiling means
        // that exclusively vbus-powered PXA designs violate USB specs.
};


Comparing to omap_udc.

--- drivers/usb/gadget/omap_udc.c
static int omap_vbus_draw(struct usb_gadget *gadget, unsigned mA)
{
        struct omap_udc *udc;

        udc = container_of(gadget, struct omap_udc, gadget);
        if (udc->transceiver)
                return otg_set_power(udc->transceiver, mA);
        return -EOPNOTSUPP;
}
[...]
static struct usb_gadget_ops omap_gadget_ops = {
        .get_frame              = omap_get_frame,
        .wakeup                 = omap_wakeup,
        .set_selfpowered        = omap_set_selfpowered,
        .vbus_session           = omap_vbus_session,
        .vbus_draw              = omap_vbus_draw,
        .pullup                 = omap_pullup,
};



Regarding API. If you all you want is to know how much power you need to
ask from VBUS, we can extend external power interface... thus suppliers
could ask their power consumption requirements in mA/uA, and these
requests will be forwarded to power supply driver, and power driver will
forward that request to USB transceiver (via platform hook).

-- 
Anton Vorontsov
email: cbou@mail.ru
backup email: ya-cbou@yandex.ru
irc://irc.freenode.org/bd2
