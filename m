Return-Path: <linux-kernel-owner+w=401wt.eu-S1754955Ab0AZTME@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955Ab0AZTME (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 14:12:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754808Ab0AZTMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 14:12:03 -0500
Received: from smtp.nokia.com ([192.100.105.134]:54308 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754663Ab0AZTMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 14:12:00 -0500
Date: Tue, 26 Jan 2010 21:09:34 +0200
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext David Brownell <david-b@pacbell.net>
Cc: "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Grazvydas Ignotas <notasas@gmail.com>,
       Madhusudhan Chikkature <madhu.cr@ti.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [RFC/PATCH 1/5] usb: otg: add notifier support
Message-ID: <20100126190934.GC20049@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <6ed0b2680912101251jeec28e6i216dfc51caab13aa@mail.gmail.com>
 <201001260316.20529.david-b@pacbell.net>
 <20100126141016.GD10690@nokia.com>
 <201001260707.23339.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201001260707.23339.david-b@pacbell.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 26 Jan 2010 19:11:12.0346 (UTC) FILETIME=[531553A0:01CA9EBB]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 04:07:22PM +0100, ext David Brownell wrote:
>On Tuesday 26 January 2010, Felipe Balbi wrote:
>> >> +enum usb_xceiv_events {
>> >
>> >Let's keep charger events separate from anything else,
>> >like "enter host mode" or "enter peripheral mode" (or
>> >even "disconnect").  The audiences for any other types
>> >of event would be entirely different.
>>
>> the idea was to notify USB events to interested drivers, not only "usb
>> charger events".
>
>There are thousands of events that could be issued.
>I'd rather start with one specific problem, which
>can really benefit from being solved.
>
>If necessary, other events can be added later.
>
>
>> >Right now there's a mess in terms of charger hookup,
>> >so getting that straight is IMO a priority over any
>> >other type of event.  Using events will decouple a
>> >bunch of drivers, and simplify driver configuration.
>>
>> well, if you consider that this transceiver isn't really otg specific,
>> then this is already wrong.
>
>It's the only transceiver interface we have; and it
>works for OTG transceivers in peripheral-only mode,
>as well as host-only and dual-role modes.  So it's
>not especially wrong.
>
>
>However, "you can consume N milliAmperes now" doesn't
>need to be coupled to a transceiver at all.  In fact,
>it works just fine with any pure peripheral interface.
>The gadget stack uses such calls ... and doesn't need
>to be coupled to any transceiver.  (But obviously it
>can hook up to an OTG transceiver.)
>
>
>
>> >> +    USB_EVENT_NONE,         /* no events or cable disconnected */
>> >> +    USB_EVENT_VBUS,         /* vbus valid event */
>> >> +    USB_EVENT_ID,           /* id was grounded */
>> >> +    USB_EVENT_CHARGER,      /* usb dedicated charger */
>> >> +    USB_EVENT_ENUMERATED,   /* gadget driver enumerated */
>> >
>> >Those seem like the wrong events.  The right events for a charger
>> >would be more along the lines of:
>> >
>> > - For peripheral:  "you may use N milliAmperes now".
>> > - General:  "Don't Charge" (a.k.a. "use 0 mA").
>>
>> I have to disagree, which information would you used to kick the usb
>> dedicated charger detection other than VBUS irq from transceiver ?
>
>That's why I said what I did about the separate charger spec (and
>you quoted it below):  it's not going to be less than those two
>ops, which your events don't really capture.
>
>That's "bonus" functionality though ... among other reasons, it's
>not all that common yet.  The basic "charge battery over USB"
>scenario needs to work without that stuff.
>
>
>> So we need at least that, and also need to notify when the charger
>> detection is finished, so we can enable data pullups on the link.
>> Remember we might be connected to a charging downstream port.
>
>So you're presuming some separate component will do charger
>detection by listening for events?  If it's mucking with the
>pullups, that seems very much like what an OTG transciever
>needs to be managing.  And thus, perhaps, transceiver code.

well, if you have access to twl5031 docs you'd understand what I'm 
talking about, the charger detection involves at least 3 blocks on 
twl5031 plus musb to enable/disable pullups. The sequence is pretty much 
as below:

1. vbus irq
2. usb_gadget_disconnect()
3. disable usb ldos
4. switch usb3v1 supply from vbat to vbus (to let charger detection work 
on low bat)
5. enable usb3v1 *only*
6. call the notifier chain
7. BCC module kicks charger detection
8. disable usb3v1
9. switch usb3v1 supply back to vbat
10. enable usb ldos
11. usb_gadget_connect() (necessary since we might be connected to 
charging port)

vbus irq comes from transceiver (drivers/usb/otg/twl4030-usb.c), 
notifier (currently) is also issued from there. 
usb_gadget_connect/disconnect() is implemented in 
drivers/usb/musb/musb_gadget.c, BCC module is a power_supply driver (not 
in mainline yet, I guess).

And after all that, we still have bq2415x as the charger chip itself. On 
that we configure input current and all the filters imposed by pse law. 
There's also the battery monitoring part which will involve the MADC 
part of twl4030/5030/5031/tpsxxxxx and some temperature sensor (maybe).

So the whole thing is quite complicated and should probably be moved to 
some "core" code.

>If there's such a separate component, I'd like to see some
>detail about how it'd work.  But ... at first glance, it'd
>have thought it'd be simplest inside a transceiver driver.

well, we could export some symbols to the transceiver to access the BCC 
address space in twl, but why if we can let bcc do that by itself if we 
just tell it "hey dude, vbus is alive".

>We could take a vote to see how many folk have even seen
>one, much less own one.  They're not very common, and not
>part of the USB 2.0 spec.  That's why I say "not basic".

ok, got it. But we already have plenty of devices on the market which 
support them. Look at n900, for example, the only way to charge its 
battery if via usb port ;-)

>> what about irqs running in thread, wouldn't we "BUG sleeping in irq
>> context" ?
>
>Iff the IRQ has a thread context, it can block.

ok, so what do you suggest in this case ?

we know that on omaps vbus will come from an i2c-connected transceiver 
so its irq handler will be running in a thread and VBUS is the first 
valuable information we have on usb point of view.

-- 
balbi
