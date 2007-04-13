Return-Path: <linux-kernel-owner+w=401wt.eu-S1753247AbXDMKZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247AbXDMKZS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 06:25:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753272AbXDMKZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 06:25:18 -0400
Received: from smtp102.sbc.mail.mud.yahoo.com ([68.142.198.201]:46357 "HELO
	smtp102.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753247AbXDMKZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 06:25:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=wKZ2W6PZ7thRs2b8aLNn1l6yZJ5cDsG4mAC8ncadiKvTq1+xBr4IkrJ4EnfzL3W+soMjbrnH+h0POp/qncpQ5//EQFr0lYIsGIPCmy98ppxYViHc3Xxm4H9gP6Zfqx2jmkmxA5dnhQSXduf4wddWKE9OHXeh7CKFNE4ODwzYk0Y=  ;
X-YMail-OSG: i.pbrMIVM1ntiIldmZbIpYnwk8tLS.RiEHyvWHJut_a4BDnM0WIHe8m2C3_hDQnKaDgwrBftcw--
From: David Brownell <david-b@pacbell.net>
To: cbou@mail.ru
Subject: Re: [PATCH 2/7] [RFC] Common power driver for Linux gadgets
Date: Fri, 13 Apr 2007 03:25:13 -0700
User-Agent: KMail/1.7.1
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
References: <200704122306.46518.david-b@pacbell.net> <200704130142.37081.david-b@pacbell.net> <20070413095237.GA14851@zarina>
In-Reply-To: <20070413095237.GA14851@zarina>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704130325.13813.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 April 2007 2:52 am, Anton Vorontsov wrote:
> > > But I got the point, and yes I can't explain why it works correctly.
> > 
> > It probably doesn't work correctly.  But it's not broken enough to
> > fail badly.
> 
> Can that comment be an explanation?
> 
> --- drivers/usb/gadget/pxa2xx_udc.c:
> static const struct usb_gadget_ops pxa2xx_udc_ops = {
>         .get_frame      = pxa2xx_udc_get_frame,
>         .wakeup         = pxa2xx_udc_wakeup,
>         .vbus_session   = pxa2xx_udc_vbus_session,
>         .pullup         = pxa2xx_udc_pullup,
> 
>         // .vbus_draw ... boards may consume current from VBUS, up to
>         // 100-500mA based on config.  the 500uA suspend ceiling means
>         // that exclusively vbus-powered PXA designs violate USB specs.

That's basically a "plug in implementation here".  Nobody's yet done
that on a platform that _uses_ the VBUS power.


> };
> 
> 
> Comparing to omap_udc.
> 
> --- drivers/usb/gadget/omap_udc.c
> static int omap_vbus_draw(struct usb_gadget *gadget, unsigned mA)
> {
>         struct omap_udc *udc;
> 
>         udc = container_of(gadget, struct omap_udc, gadget);
>         if (udc->transceiver)
>                 return otg_set_power(udc->transceiver, mA);

Where the transceiver would then delegate to something else,
like the tps65010 driver.


>         return -EOPNOTSUPP;
> }
> [...]
> static struct usb_gadget_ops omap_gadget_ops = {
>         .get_frame              = omap_get_frame,
>         .wakeup                 = omap_wakeup,
>         .set_selfpowered        = omap_set_selfpowered,
>         .vbus_session           = omap_vbus_session,
>         .vbus_draw              = omap_vbus_draw,

... which has most certainly been on platforms which are hooked
up to draw power from VBUS.


>         .pullup                 = omap_pullup,
> };
> 
> 
> 
> Regarding API. If you all you want is to know how much power you need to
> ask from VBUS, we can extend external power interface... thus suppliers
> could ask their power consumption requirements in mA/uA, and these
> requests will be forwarded to power supply driver, and power driver will
> forward that request to USB transceiver (via platform hook).

I don't folow what you're saying.  The control flow *MUST* be that
the USB stack provides the only indication of how much power may
be drawn through the VBUS supply.  Nothing else in the system has
the knowledge of what's legal, and when.

If you want to talk about a "supplier", the way to put it might
then be that the USB stack is saying "here's N mA power for you";
it's supplying the power, not the other way around.

There's no "ask" involved, since the host controls "N".  So the
host supplies, the USB gadget stack interprets that, and some
power component must obeys.  That includes rules like reducing
VBUS draw to ~500 uA when the host suspends the USB link.

- Dave

