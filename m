Return-Path: <linux-kernel-owner+w=401wt.eu-S1754049Ab0AZORK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049Ab0AZORK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 09:17:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754027Ab0AZORI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 09:17:08 -0500
Received: from smtp.nokia.com ([192.100.122.233]:19713 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984Ab0AZORG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 09:17:06 -0500
Date: Tue, 26 Jan 2010 16:14:43 +0200
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext David Brownell <david-b@pacbell.net>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Grazvydas Ignotas <notasas@gmail.com>,
       Madhusudhan Chikkature <madhu.cr@ti.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [RFC/PATCH 1/5] usb: otg: add notifier support
Message-ID: <20100126141443.GE10690@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <6ed0b2680912101251jeec28e6i216dfc51caab13aa@mail.gmail.com>
 <201001260316.20529.david-b@pacbell.net>
 <20100126131146.GC32291@sirena.org.uk>
 <201001260535.21689.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <201001260535.21689.david-b@pacbell.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 26 Jan 2010 14:16:24.0346 (UTC) FILETIME=[2436B7A0:01CA9E92]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 02:35:21PM +0100, ext David Brownell wrote:
>On Tuesday 26 January 2010, Mark Brown wrote:
>> On Tue, Jan 26, 2010 at 03:16:20AM -0800, David Brownell wrote:
>>
>> > I'd vote to convert all the USB-to-charger interfaces so
>> > they use notifiers.  After fixing the events ... see
>> > comments below.  :)
>>
>> Yes please - it's not just chargers either, this can also be used by
>> PMICs which do power path management that includes USB.
>
>Color me confused ... what do you mean by "power path"?
>
>Do you mean something like "the board as a whole can take N mA of
>current from USB", rather than specifically addressing a charger?
>
>It's not uncommon to do things like use VBUS current to power the
>USB circuitry, too.  That can leave less for other purposes.  All
>of that being rather board-specific.
>
>
>> > Those seem like the wrong events.  The right events for a charger
>> > would be more along the lines of:
>>
>> >  - For peripheral:  "you may use N milliAmperes now".
>> >  - General:  "Don't Charge" (a.k.a. "use 0 mA").
>>
>> > I don't see how "N" would be passed with those events ...
>>
>> These are good for the peripheral side.  You do get to pass a void *
>> along with the notifier value, that could be used to pass data like the
>> current limit.
>
>I don't think I saw that being done ... either in code, comments,
>or documentation.  Passing N is fundamental.

yeah, my bad. I should have said that, but it's more related to the 
implementation of the notifier_block.

>> > A host *might* want to be able to say things like "supply
>> > up to N milliAmperes now", e.g. to let a regulator choose
>> > the most efficient mode.
>>
>> Yes, they definitely want this - not just for efficiency but also to
>> allow current limiting to protect the system from excessive current
>> drain.
>
>There are load bursting issues too.  All part of the USB spec;
>a load that's OK for 1 millisecond might not be OK for 1 second.

if you get a SetConfiguration(config), then you can use that load for as 
long as needed, the limitation is when not enumerated, afaict.

>ISTR the "supply N mA" refers to an average.  And there are some
>limits to the capacitance that can practically be stuck on VBUS
>output lines (which includes the cable).  Solvable problems, but
>not always pretty if software has to think it through.
>
>Thing is, supplying current is a bit more involved.  If the
>board can't supply 300 mA, the USB configuration selection
>mechanism has to know that, so it never selects peripheral
>configurations which require that much current.

but that's done already by the usb core, no ? It rules out configuration 
based on the hub->power_budget (can't remember if the field is that 
exact name).

-- 
balbi
