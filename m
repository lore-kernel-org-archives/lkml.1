Return-Path: <linux-kernel-owner+w=401wt.eu-S1754126Ab0AZOVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126Ab0AZOVN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 09:21:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754027Ab0AZOVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 09:21:12 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48138 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754036Ab0AZOVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 09:21:10 -0500
Date: Tue, 26 Jan 2010 14:21:02 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Brownell <david-b@pacbell.net>
Cc: Felipe Balbi <felipe.balbi@nokia.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Grazvydas Ignotas <notasas@gmail.com>,
       Madhusudhan Chikkature <madhu.cr@ti.com>, linux-omap@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [RFC/PATCH 1/5] usb: otg: add notifier support
Message-ID: <20100126142102.GU15759@rakim.wolfsonmicro.main>
References: <6ed0b2680912101251jeec28e6i216dfc51caab13aa@mail.gmail.com>
 <201001260316.20529.david-b@pacbell.net>
 <20100126131146.GC32291@sirena.org.uk>
 <201001260535.21689.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001260535.21689.david-b@pacbell.net>
X-Cookie: I'm ANN LANDERS!!  I can SHOPLIFT!!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 05:35:21AM -0800, David Brownell wrote:
> On Tuesday 26 January 2010, Mark Brown wrote:

> > Yes please - it's not just chargers either, this can also be used by
> > PMICs which do power path management that includes USB.

> Color me confused ... what do you mean by "power path"?

In the sort of design I'm talking about there is generally a system
power rail which is generated from the various power sources available
to the system, which might include a combination of batteries, USB and
wall adaptors.  The power path management logic is the hardware which
controls which of these are actually being used as supplies, and may
also include battery charger management.

> Do you mean something like "the board as a whole can take N mA of
> current from USB", rather than specifically addressing a charger?

Pretty much, from this point of view.

> It's not uncommon to do things like use VBUS current to power the
> USB circuitry, too.  That can leave less for other purposes.  All
> of that being rather board-specific.

In this sort of design either VBUS goes through the power path
management logic before anything else gets to use it or the hardware
will know about the headroom it needs to leave.  The power path
management will usually do things like try to suppliment VBUS with any
battery that's available to generate the main system supply rail.

This all needs to function without software since it tends to get used
to decide things like if the system is able to begin power up at all, .

> > > Those seem like the wrong events.  The right events for a charger
> > > would be more along the lines of:

> > >  - For peripheral:  "you may use N milliAmperes now".
> > >  - General:  "Don't Charge" (a.k.a. "use 0 mA").

> > > I don't see how "N" would be passed with those events ...

> > These are good for the peripheral side.  You do get to pass a void *
> > along with the notifier value, that could be used to pass data like the
> > current limit.

> I don't think I saw that being done ... either in code, comments,
> or documentation.  Passing N is fundamental.

I think we're talking at cross purposes - I was reading "these events"
as being the new events quoted above, not the events in the existing
code.  I certainly agree that N is fundamental.

> Thing is, supplying current is a bit more involved.  If the
> board can't supply 300 mA, the USB configuration selection
> mechanism has to know that, so it never selects peripheral
> configurations which require that much current.

Indeed, the specific limits are more used for protection against things
like the connected devices drawing more current than they claimed than
anything else.

> Ergo my desire to start with a straightforward problem whose
> solution has real value (how much VBUS current may be consumed?),
> and leave some of those other messes for later!

Understandable.  It would be good to have an idea what sort of general
direction to go in there, though I do agree that the gadget case is much
more important here.
