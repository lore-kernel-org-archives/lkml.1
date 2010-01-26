Return-Path: <linux-kernel-owner+w=401wt.eu-S1754197Ab0AZPH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab0AZPH1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 10:07:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753984Ab0AZPH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 10:07:26 -0500
Received: from smtp105.sbc.mail.gq1.yahoo.com ([67.195.14.108]:44638 "HELO
	smtp105.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753709Ab0AZPHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 10:07:25 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=US+FW/ug138lLl40lKugvDhUwduNsyCOwVeMGmr1SIFrRPMeWkLTmbAHYcuIWOxuETZJvT1owrB5RknhyoSfYYWmyvfc0L7TQGAka29CSQgvbj/OOjSU4/mFY4MlSdsraC4QM4iMV6cQ0LUggd01kjcuK5Uq5QcNX1xUseJj7Uw=  ;
X-Yahoo-SMTP: 2V1ThQ.swBDh24fWwg9PZFuY7TTwFsTuVtXZ.8DKSgQ-
X-YMail-OSG: qYlFitMVM1k9qLPwAE_qG9UF0WS6VPTIJ9Rqgt3MytkYpqJNPehywp63BCBYpHERhZoJUyGRscomVJFvWXLlR00kgea2JD4mK3umUSj97OaXMetQF_crrvonOcdI4JnLZXKUowXUuNFL2PBWimxwAODw7xweBAcx1kZW3cEkW1KyfSMf91kXoGSTTzMvynSch7aMc3tORMPCws.oPQKpYZdrR9tniQPr80G7jVL2eCKboa8DcMC4UcgpN3Dakhgf03U4bY6rDpvXDrJHqphsUNUj4jW0BgA7SEn5
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: felipe.balbi@nokia.com
Subject: Re: [RFC/PATCH 1/5] usb: otg: add notifier support
Date: Tue, 26 Jan 2010 07:07:22 -0800
User-Agent: KMail/1.9.10
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Grazvydas Ignotas <notasas@gmail.com>,
       Madhusudhan Chikkature <madhu.cr@ti.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "Greg Kroah-Hartman" <gregkh@suse.de>
References: <6ed0b2680912101251jeec28e6i216dfc51caab13aa@mail.gmail.com> <201001260316.20529.david-b@pacbell.net> <20100126141016.GD10690@nokia.com>
In-Reply-To: <20100126141016.GD10690@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <201001260707.23339.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 January 2010, Felipe Balbi wrote:
> >> +enum usb_xceiv_events {
> >
> >Let's keep charger events separate from anything else,
> >like "enter host mode" or "enter peripheral mode" (or
> >even "disconnect").  The audiences for any other types
> >of event would be entirely different.
> 
> the idea was to notify USB events to interested drivers, not only "usb 
> charger events".

There are thousands of events that could be issued.
I'd rather start with one specific problem, which
can really benefit from being solved.

If necessary, other events can be added later.


> >Right now there's a mess in terms of charger hookup,
> >so getting that straight is IMO a priority over any
> >other type of event.  Using events will decouple a
> >bunch of drivers, and simplify driver configuration.
> 
> well, if you consider that this transceiver isn't really otg specific, 
> then this is already wrong.

It's the only transceiver interface we have; and it
works for OTG transceivers in peripheral-only mode,
as well as host-only and dual-role modes.  So it's
not especially wrong.


However, "you can consume N milliAmperes now" doesn't
need to be coupled to a transceiver at all.  In fact,
it works just fine with any pure peripheral interface.
The gadget stack uses such calls ... and doesn't need
to be coupled to any transceiver.  (But obviously it
can hook up to an OTG transceiver.)


 
> >> +    USB_EVENT_NONE,         /* no events or cable disconnected */
> >> +    USB_EVENT_VBUS,         /* vbus valid event */
> >> +    USB_EVENT_ID,           /* id was grounded */
> >> +    USB_EVENT_CHARGER,      /* usb dedicated charger */
> >> +    USB_EVENT_ENUMERATED,   /* gadget driver enumerated */
> >
> >Those seem like the wrong events.  The right events for a charger
> >would be more along the lines of:
> >
> > - For peripheral:  "you may use N milliAmperes now".
> > - General:  "Don't Charge" (a.k.a. "use 0 mA").
> 
> I have to disagree, which information would you used to kick the usb 
> dedicated charger detection other than VBUS irq from transceiver ?

That's why I said what I did about the separate charger spec (and 
you quoted it below):  it's not going to be less than those two
ops, which your events don't really capture.

That's "bonus" functionality though ... among other reasons, it's
not all that common yet.  The basic "charge battery over USB"
scenario needs to work without that stuff.

 
> So we need at least that, and also need to notify when the charger 
> detection is finished, so we can enable data pullups on the link. 
> Remember we might be connected to a charging downstream port.

So you're presuming some separate component will do charger
detection by listening for events?  If it's mucking with the
pullups, that seems very much like what an OTG transciever
needs to be managing.  And thus, perhaps, transceiver code.

If there's such a separate component, I'd like to see some
detail about how it'd work.  But ... at first glance, it'd
have thought it'd be simplest inside a transceiver driver.


> >I don't see how "N" would be passed with those events ...
> 
> there's a void * we can use to pass bMaxPower field of the selected 
> configuration.

Needs to be part of the event spec...

 
> >Haven't looked at the details of the charger spec, but
> >those two events are the *basics* from the USB 2.0 spec,
> >so "official" charger hardware wouldn't be less capable.
> 
> I believe the dedicated charger is also "basic".

We could take a vote to see how many folk have even seen
one, much less own one.  They're not very common, and not
part of the USB 2.0 spec.  That's why I say "not basic".

 
> >Thing like different levels of VBUS validity, ID grounding,
> >and so forth ... wouldn't be very relevant.  An OTG driver
> >will do various things, internally, when ID grounds; but
> >anything else is a function of what role eventually gets
> >negotiated.  And for the charger, they all add up to "Don't
> >Charge" (since ID grounded means A-role, sourcing power).
> 
> ID grounding event is necessary if you have an external charge pump. 
> At least the boards I've been working use an external chip as the USB 
> Charger and Charge pump, iow, the transceiver doesn't source VBUS on ID 
> ground, but the charger chip is put into "boost" mode for that role.

As you say:  transceiver stuff.  What I'm used to seeing is
what the OTG spec says:  ID grounding is an event, which
triggers state machine transitions.  One such transition
involves sourcing VBUS power and making sure it ramps up
properly.  Activating that, and monitoring it, depend on
hardware details which are tightly coupled to transceiver
logic and implementation.


> >>  #define USB_OTG_PULLUP_ID           (1 << 0)
> >>  #define USB_OTG_PULLDOWN_DP         (1 << 1)
> >>  #define USB_OTG_PULLDOWN_DM         (1 << 2)
> >> @@ -70,6 +80,9 @@ struct otg_transceiver {
> >>      struct otg_io_access_ops        *io_ops;
> >>      void __iomem                    *io_priv;
> >>
> >> +    /* for notification of usb_xceiv_events */
> >> +    struct blocking_notifier_head   notifier;
> >
> >Why "blocking"?  That seems kind of unnatural; for example,
> >the main users -- like usb_gadget_vbus_draw() -- would be
> >called in IRQ context (blocking not allowed).
> 
> what about irqs running in thread, wouldn't we "BUG sleeping in irq 
> context" ?

Iff the IRQ has a thread context, it can block.

But a SET_CONFIGURATION request is mostly going to
be delivered to a hard IRQ context, and that is what
will pass the host's vbus_draw configuration to the
hardware.  (Same for most of the other events you
sketched.)

