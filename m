Return-Path: <linux-kernel-owner+w=401wt.eu-S1753939Ab0AZOMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939Ab0AZOMW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 09:12:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752414Ab0AZOMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 09:12:21 -0500
Received: from smtp.nokia.com ([192.100.122.233]:19239 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353Ab0AZOMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 09:12:20 -0500
Date: Tue, 26 Jan 2010 16:10:16 +0200
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
Message-ID: <20100126141016.GD10690@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <6ed0b2680912101251jeec28e6i216dfc51caab13aa@mail.gmail.com>
 <1260531086-23857-2-git-send-email-felipe.balbi@nokia.com>
 <201001260316.20529.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <201001260316.20529.david-b@pacbell.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 26 Jan 2010 14:11:57.0242 (UTC) FILETIME=[8501E1A0:01CA9E91]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jan 26, 2010 at 12:16:20PM +0100, ext David Brownell wrote:
>On Friday 11 December 2009, Felipe Balbi wrote:
>> The notifier will be used to communicate usb events
>> to other drivers like the charger chip.
>
>Good idea ... but not OTG-specific.  It doesn't seem to me

thanks

>that charging hookups belong in that header at all.

I noticed that when started actually using it :-)

>In fact, usb_gadget_vbus_draw() might better be implemented
>as such a notifier call, removing that configuration mess
>from the usb gadget drivers ("how can I know what charger
>to use??").  That would be the most common situation:  a
>peripheral-only device.
>
>And in fact, OTG can be treated as a trivial superset of
>peripheral-only USB.  (In terms of charger support, only!!)
>
>I'd vote to convert all the USB-to-charger interfaces so
>they use notifiers.  After fixing the events ... see
>comments below.  :)

makes sense

>> @@ -9,6 +9,8 @@
>>  #ifndef __LINUX_USB_OTG_H
>>  #define __LINUX_USB_OTG_H
>>
>> +#include <linux/notifier.h>
>> +
>>  /* OTG defines lots of enumeration states before device reset */
>>  enum usb_otg_state {
>>  	OTG_STATE_UNDEFINED = 0,
>> @@ -33,6 +35,14 @@ enum usb_otg_state {
>>  	OTG_STATE_A_VBUS_ERR,
>>  };
>>
>> +enum usb_xceiv_events {
>
>Let's keep charger events separate from anything else,
>like "enter host mode" or "enter peripheral mode" (or
>even "disconnect").  The audiences for any other types
>of event would be entirely different.

the idea was to notify USB events to interested drivers, not only "usb 
charger events".

>Right now there's a mess in terms of charger hookup,
>so getting that straight is IMO a priority over any
>other type of event.  Using events will decouple a
>bunch of drivers, and simplify driver configuration.

well, if you consider that this transceiver isn't really otg specific, 
then this is already wrong.

>> +	USB_EVENT_NONE,         /* no events or cable disconnected */
>> +	USB_EVENT_VBUS,         /* vbus valid event */
>> +	USB_EVENT_ID,           /* id was grounded */
>> +	USB_EVENT_CHARGER,      /* usb dedicated charger */
>> +	USB_EVENT_ENUMERATED,   /* gadget driver enumerated */
>
>Those seem like the wrong events.  The right events for a charger
>would be more along the lines of:
>
> - For peripheral:  "you may use N milliAmperes now".
> - General:  "Don't Charge" (a.k.a. "use 0 mA").

I have to disagree, which information would you used to kick the usb 
dedicated charger detection other than VBUS irq from transceiver ?

So we need at least that, and also need to notify when the charger 
detection is finished, so we can enable data pullups on the link. 
Remember we might be connected to a charging downstream port.

>I don't see how "N" would be passed with those events ...

there's a void * we can use to pass bMaxPower field of the selected 
configuration.

>Haven't looked at the details of the charger spec, but
>those two events are the *basics* from the USB 2.0 spec,
>so "official" charger hardware wouldn't be less capable.

I believe the dedicated charger is also "basic".

>Thing like different levels of VBUS validity, ID grounding,
>and so forth ... wouldn't be very relevant.  An OTG driver
>will do various things, internally, when ID grounds; but
>anything else is a function of what role eventually gets
>negotiated.  And for the charger, they all add up to "Don't
>Charge" (since ID grounded means A-role, sourcing power).

ID grounding event is necessary if you have an external charge pump. 
At least the boards I've been working use an external chip as the USB 
Charger and Charge pump, iow, the transceiver doesn't source VBUS on ID 
ground, but the charger chip is put into "boost" mode for that role.

>>  #define USB_OTG_PULLUP_ID		(1 << 0)
>>  #define USB_OTG_PULLDOWN_DP		(1 << 1)
>>  #define USB_OTG_PULLDOWN_DM		(1 << 2)
>> @@ -70,6 +80,9 @@ struct otg_transceiver {
>>  	struct otg_io_access_ops	*io_ops;
>>  	void __iomem			*io_priv;
>>
>> +	/* for notification of usb_xceiv_events */
>> +	struct blocking_notifier_head	notifier;
>
>Why "blocking"?  That seems kind of unnatural; for example,
>the main users -- like usb_gadget_vbus_draw() -- would be
>called in IRQ context (blocking not allowed).

what about irqs running in thread, wouldn't we "BUG sleeping in irq 
context" ?

-- 
balbi
