Return-Path: <linux-kernel-owner+w=401wt.eu-S1753193Ab0AZMSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193Ab0AZMSr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 07:18:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752947Ab0AZMSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 07:18:46 -0500
Received: from smtp103.sbc.mail.gq1.yahoo.com ([67.195.15.62]:21570 "HELO
	smtp103.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752968Ab0AZMSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 07:18:45 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Is3JnlDnZFmAn5dxYRHb5cEZyXmCBLTmM8ux22O8MU2jXTRHW8nGw+bL4ebSE6iN1ejDm2emjvJkYLLPiUP0xCoJQ7eAYPrNQTdXMq2d3uC2noUHDGjbj/sYVb+nsg60yLXRkQt/CNolKmLipoIZJSkytoftLpcSuv77wUsXYgc=  ;
X-Yahoo-SMTP: 2V1ThQ.swBDh24fWwg9PZFuY7TTwFsTuVtXZ.8DKSgQ-
X-YMail-OSG: cJ0NvuQVM1nQu9e4wE3v3m6kihSu37DyarE.rnh4xv0ZR.9Iz.WnS1QdGvNdPKTW43rT5.6gXT7kKHdDgiQrwC0uIhDs3w2kJSkQOINNnI9ZEFGD2PE_Ytv1J_7_TW8FHG3AwuWD1WcQFf08s2D24tGe0bT0nypsxrTlk4Tp0oeuhq5pKgmMbtf24D_ZvoBC9ycpWfdi.lPlyKdcNpZFsfV8qsDD6I59nGOpktNvD.cKFi.BRnwg6hRxrVLMV2gut_VkofXOTZ3t56WI29YX3gyQmEQyoMvHfzt5SyZuFe8I.bt.pYwpH4swBsGCUjwZNj6gcg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Felipe Balbi <felipe.balbi@nokia.com>
Subject: Re: [RFC/PATCH 1/5] usb: otg: add notifier support
Date: Tue, 26 Jan 2010 03:16:20 -0800
User-Agent: KMail/1.9.10
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Grazvydas Ignotas <notasas@gmail.com>,
       Madhusudhan Chikkature <madhu.cr@ti.com>, linux-omap@vger.kernel.org,
       "Greg Kroah-Hartman" <gregkh@suse.de>
References: <6ed0b2680912101251jeec28e6i216dfc51caab13aa@mail.gmail.com> <1260531086-23857-2-git-send-email-felipe.balbi@nokia.com>
In-Reply-To: <1260531086-23857-2-git-send-email-felipe.balbi@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001260316.20529.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 December 2009, Felipe Balbi wrote:
> The notifier will be used to communicate usb events
> to other drivers like the charger chip.

Good idea ... but not OTG-specific.  It doesn't seem to me
that charging hookups belong in that header at all.

In fact, usb_gadget_vbus_draw() might better be implemented
as such a notifier call, removing that configuration mess
from the usb gadget drivers ("how can I know what charger
to use??").  That would be the most common situation:  a
peripheral-only device.

And in fact, OTG can be treated as a trivial superset of
peripheral-only USB.  (In terms of charger support, only!!)

I'd vote to convert all the USB-to-charger interfaces so
they use notifiers.  After fixing the events ... see
comments below.  :)


> This can be used as source of information to kick
> usb charger detection as described by the USB
> Battery Charging Specification 1.1 and/or to
> pass bMaxPower field of selected usb_configuration
> to charger chip in order to use that information
> as input current on the charging profile
> setup.
> 
> Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>
> ---
>  include/linux/usb/otg.h |   25 +++++++++++++++++++++++++
>  1 files changed, 25 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/usb/otg.h b/include/linux/usb/otg.h
> index 52bb917..6c0b676 100644
> --- a/include/linux/usb/otg.h
> +++ b/include/linux/usb/otg.h
> @@ -9,6 +9,8 @@
>  #ifndef __LINUX_USB_OTG_H
>  #define __LINUX_USB_OTG_H
>  
> +#include <linux/notifier.h>
> +
>  /* OTG defines lots of enumeration states before device reset */
>  enum usb_otg_state {
>  	OTG_STATE_UNDEFINED = 0,
> @@ -33,6 +35,14 @@ enum usb_otg_state {
>  	OTG_STATE_A_VBUS_ERR,
>  };
>  
> +enum usb_xceiv_events {

Let's keep charger events separate from anything else,
like "enter host mode" or "enter peripheral mode" (or
even "disconnect").  The audiences for any other types
of event would be entirely different.

Right now there's a mess in terms of charger hookup,
so getting that straight is IMO a priority over any
other type of event.  Using events will decouple a
bunch of drivers, and simplify driver configuration.


> +	USB_EVENT_NONE,         /* no events or cable disconnected */
> +	USB_EVENT_VBUS,         /* vbus valid event */
> +	USB_EVENT_ID,           /* id was grounded */
> +	USB_EVENT_CHARGER,      /* usb dedicated charger */
> +	USB_EVENT_ENUMERATED,   /* gadget driver enumerated */

Those seem like the wrong events.  The right events for a charger
would be more along the lines of:

 - For peripheral:  "you may use N milliAmperes now".
 - General:  "Don't Charge" (a.k.a. "use 0 mA").

I don't see how "N" would be passed with those events ...

Haven't looked at the details of the charger spec, but
those two events are the *basics* from the USB 2.0 spec,
so "official" charger hardware wouldn't be less capable.

Thing like different levels of VBUS validity, ID grounding,
and so forth ... wouldn't be very relevant.  An OTG driver
will do various things, internally, when ID grounds; but
anything else is a function of what role eventually gets
negotiated.  And for the charger, they all add up to "Don't
Charge" (since ID grounded means A-role, sourcing power).

A host *might* want to be able to say things like "supply
up to N milliAmperes now", e.g. to let a regulator choose
the most efficient mode.


> +};
> +
>  #define USB_OTG_PULLUP_ID		(1 << 0)
>  #define USB_OTG_PULLDOWN_DP		(1 << 1)
>  #define USB_OTG_PULLDOWN_DM		(1 << 2)
> @@ -70,6 +80,9 @@ struct otg_transceiver {
>  	struct otg_io_access_ops	*io_ops;
>  	void __iomem			*io_priv;
>  
> +	/* for notification of usb_xceiv_events */
> +	struct blocking_notifier_head	notifier;

Why "blocking"?  That seems kind of unnatural; for example,
the main users -- like usb_gadget_vbus_draw() -- would be
called in IRQ context (blocking not allowed).

> +
>  	/* to pass extra port status to the root hub */
>  	u16			port_status;
>  	u16			port_change;
> @@ -203,6 +216,18 @@ otg_start_srp(struct otg_transceiver *otg)
>  	return otg->start_srp(otg);
>  }
>  
> +/* notifiers */
> +static inline int
> +otg_register_notifier(struct otg_transceiver *otg, struct notifier_block *nb)
> +{
> +	return blocking_notifier_chain_register(&otg->notifier, nb);
> +}
> +
> +static inline void
> +otg_unregister_notifier(struct otg_transceiver *otg, struct notifier_block *nb)
> +{
> +	blocking_notifier_chain_unregister(&otg->notifier, nb);
> +}
>  
>  /* for OTG controller drivers (and maybe other stuff) */
>  extern int usb_bus_start_enum(struct usb_bus *bus, unsigned port_num);
> 

