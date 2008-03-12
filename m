Return-Path: <linux-kernel-owner+w=401wt.eu-S1753330AbYCLNC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330AbYCLNC0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 09:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751616AbYCLNCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 09:02:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43697 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751521AbYCLNCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 09:02:18 -0400
Date: Wed, 12 Mar 2008 13:02:16 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Brownell <david-b@pacbell.net>
Cc: Liam Girdwood <lg@opensource.wolfsonmicro.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [UPDATED v3][PATCH 1/7] regulator: consumer interface
Message-ID: <20080312130216.GA26583@rakim.wolfsonmicro.main>
Mail-Followup-To: David Brownell <david-b@pacbell.net>,
	Liam Girdwood <lg@opensource.wolfsonmicro.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-arm-kernel@lists.arm.linux.org.uk,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <1204827056.15360.147.camel@a10323.wolfsonmicro.main> <200803111525.10717.david-b@pacbell.net> <20080312000044.GA30908@sirena.org.uk> <200803120031.59742.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803120031.59742.david-b@pacbell.net>
X-Cookie: Marriage is the sole cause of divorce.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2008 at 11:31:59PM -0800, David Brownell wrote:
> On Tuesday 11 March 2008, Mark Brown wrote:

> > It's also common for devices to have multiple power inputs which can be
> > run separately if required but which are normally tied together unless
> > there is a special reason to do so.

> I've not happened across that idiom.  Is that common on
> particular larger systems?

It's standard on the analogue side of audio codecs, for example.

> > This is pretty much the model that is currently implemented.

> Then the tree should be a bit more of a first class citizen,
> IMO, like it is in the clock framework.  Both clock and power
> distribution have similar hardware infrastructure; the software
> interfaces can be more similar than it is.

What do you see as being missing in the externally presented interface?
As far as I can see the main difference between the two APIs on this
front is that the regulator API explicitly separates the interface used
to set up the tree from the interface used by consumers.

> > A given 
> > power management IC can have several regulators (that is, things which
> > have regulator IDs registered and can supply power). 

> Those are the outputs.  Are the inputs visible?  Like batteries
> or loosely regulated DC voltages ... drivers/power/* stuff.

Not as part of this API at present unless the input is another
regulator, though obviously drivers could set up associations in the
device tree.

> > Each regulator can 
> > have multiple clients bound to it (that is, things that have called
> > regulator_get() and can consume power). 

> In the clock framework, clk_get_parent() exposes one part of this
> relationship.  But there's also the association of logical clock
> names to devices ... 

Right, though that does tend to break down when clocks go off chip - the
association of devices with symbolic names is generally only done for
things that are hard wired as part of the same chip since the devices
are registered along with the clock.   Other clocks generally just get
the name that the chip documents for them.  Indeed, looking around the
tree almost all current use of clock API appears to be for on-SoC devices.

Unless I'm missing something the obvious way to provide off-chip
symbolic names in the clock API is for board code to register a virtual
clock with the desired name and device and parent it off the actual
clock source.  That said I can't immediately find any actual uses of that
and at least some of the implementations I've seen wouldn't support it.
A similar approach should work here, though I'm not sure it's terribly
nice.

What might be nicer would be an API that platform code could use to map
regulators to device/name tuples.  The core could then search these when
a client calls regulator_get() (either by maintaining a separate table
or by setting up virtual regulators).

> > While the leaf enable/disable operations do happen at the client level
> > the core reference counts the enabled clients to control enabling of the
> > actual supply.

> Right.  But what I was getting at was that there can be
> domains hooked up like:

>     Power --> Regulator -+-> Switch-1 -+-> Switch-2 --> [Dev-A]
>                          |             |
>                          |             +-> [Dev-B], [Dev-C]
>                          |
>                          +-> [Dev-D], [Dev-E]

> Those switches can be as simple as a MOSFET under GPIO control.

> And I'd expect power domains under Linux to be able to represent
> all of those ... including software controls wherevever they're
> practical, which in this case might include everything except the
> battery input.

I don't see a particular problem fitting this into the structure of
the current API - to me the switches inflexible regulators with no
configurable voltage control of their own.  The core would need to be
enhanced a bit to cope with passing through the configurability of the
parent regulator when a child has no get/set operations of its own but
that doesn't need to be visible to anything except the non-configurable
regulators.
