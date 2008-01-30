Return-Path: <linux-kernel-owner+w=401wt.eu-S1760789AbYA3M1G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760789AbYA3M1G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 07:27:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752794AbYA3M0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 07:26:55 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:62632 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750794AbYA3M0y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 07:26:54 -0500
Date: Wed, 30 Jan 2008 13:26:51 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: David Brownell <david-b@pacbell.net>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
       Shannon Nelson <shannon.nelson@intel.com>, kernel@avr32linux.org,
       "Francis Moreau" <francis.moro@gmail.com>,
       "Paul Mundt" <lethal@linux-sh.org>,
       "Vladimir A. Barinov" <vbarinov@ru.mvista.com>,
       Pierre Ossman <drzeus-list@drzeus.cx>
Subject: Re: [RFC v2 2/5] dmaengine: Add slave DMA interface
Message-ID: <20080130132651.7320d301@dhcp-252-066.norway.atmel.com>
In-Reply-To: <200801300252.50344.david-b@pacbell.net>
References: <1201630213-31900-1-git-send-email-hskinnemoen@atmel.com>
	<200801292330.05874.david-b@pacbell.net>
	<20080130102706.15c88346@dhcp-252-066.norway.atmel.com>
	<200801300252.50344.david-b@pacbell.net>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jan 2008 02:52:49 -0800
David Brownell <david-b@pacbell.net> wrote:

> On Wednesday 30 January 2008, Haavard Skinnemoen wrote:
> > Descriptor-based vs. register-based transfers sounds like something the
> > DMA engine driver is free to decide on its own.
> 
> Not entirely.  The current interface has "dma_async_tx_descriptor"
> wired pretty thoroughly into the call structure -- hard to avoid.
> (And where's the "dma_async_rx_descriptor", since that's only TX??
> Asymmetry like that is usually not a healthy sign.)  The engine is
> not free to avoid those descriptors ...

Oh sure, it can't avoid those. But it is free to program the controller
directly using registers instead of feeding it hardware-defined
descriptors (which are different from the dma_async_tx_descriptor
struct.) That's how I would implement support for the PDCA controller
present on the uC3 chips, which doesn't use descriptors at all.

> And consider that many DMA transfers can often be started (after
> cache synch operations) by writing less than half a dozen registers:
> source address, destination address, params, length, enable.  Being
> wildly generous, let's call that a couple dozen instructions, including
> saving "what to do when it's done".  The current framework requires
> several calls just to fill descriptors ... burning lots more than that
> many instructions even before getting around to the Real Work!  (So I
> was getting at low DMA overheads there, more than any particular way
> to talk to the controller.)

So what you're really talking about here is framework overhead, not
hardware properties. I think this is out of scope for the DMA slave
extensions I'm proposing here; in fact, I think it's more important to
reduce overhead for memcpy transfers, which are very fast to begin
with, than slave transfers, which may be quite slow depending on the
peripheral we're talking to.

I think descriptor caching might be one possibility for reducing the
overhead of submitting new transfers, but let's talk about that later.

> > > Example:  USB tends to use one packet per "frame" and have the DMA
> > > request signal mean "give me the next frame".  It's sometimes been
> > > very important to use use the tuning options to avoid some on-chip
> > > race conditions for transfers that cross lots of internal busses and
> > > clock domains, and to have special handling for aborting transfers
> > > and handling "short RX" packets.
> > 
> > Is it enough to set these options on a per-channel basis, or do they
> > have to be per-transfer?
> 
> Some depend on the buffer alignment and size, so "per-transfer" is the
> norm.  Of course, if there aren't many channels, the various clients
> may need to recycle them a lot ... which means lots of setup anyway.

So basically, you're asking for maximum flexibility with minimum
overhead. I agree that should be the ultimate goal, but wouldn't it be
better to start with something more basic?

> That particular hardware has enough of the "logical" channels that each
> driver gets its own; one level of arbitration involves assigning those
> to underlying "physical" channels.

Yeah, there doesn't necessarily have to be a 1:1 mapping between
channels exported by the driver and actual physical channels. If we
allow several logical channels to be multiplexed onto one or more
physical channels, we can assign quite a few more options to the
channel instead of the transfer, reducing the overhead for submitting a
new transfer.

> > > I wonder whether a unified programming interface is the right way
> > > to approach peripheral DMA support, given such variability.  The DMAC
> > > from Synopsys that you're working with has some of those options, but
> > > not all of them... and other DMA controllers have their own oddities.
> > 
> > Yes, but I still think it's worthwhile to have a common interface to
> > common functionality. Drivers for hardware that does proper flow
> > control won't need to mess with priority and arbitration settings
> > anyway, although they could do it in order to tweak performance.
> 
> I wouldn't assume that systems have that much overcapacity on
> their critical I/O paths.  I've certainly seen systems tune those
> busses down in speed ... you might describe the "why" as "tweaking
> battery performance", which wasn't at all an optional stage of the
> system development process.

But devices that do flow control should work just fine with scaled-down
bus speeds. And I don't think such platform-specific tuning belongs in
the driver anyway. Platform code can use all kinds of specialized
interfaces to tweak the bus priorities and arbitration settings (which
may involve tweaking more devices than just the DMA controller...)

> > So a 
> > plain "write this memory block to the TX register of this slave"
> > interface will be useful in many cases.
> 
> That's a fair place to start.  Although in my limited experience,
> drivers won't stay there.  I have one particular headache in mind,
> where the licensed IP has been glued to at least four different
> DMA controllers.  None of them act similarly -- sanely? -- enough
> to share much DMA interface code.  Initiation has little quirks;
> termination has bigger ones; transfer aborts... sigh

We should try to hide as many such quirks as possible in the DMA engine
driver, but I agree that it may not always be possible.

> Heck, you've seen similar stuff yourself with the MCI driver.
> AVR32 and AT91 have different DMA models.  You chose to have
> them use different drivers...

Not really. They had different drivers from the start. The atmel-mci
driver existed long before I was allowed to even mention the name
"AVR32" to anyone outside Atmel (or even most people inside Atmel.) And
at that point, the at91_mci driver was in pretty poor shape (don't
remember if it even existed at all), so I decided to write my own.

The PDC is somewhat special since its register interface is layered on
top of the peripheral's register interface. So I don't think we'll see
a DMA engine driver for the PDC.

> > > For memcpy() acceleration, sure -- there shouldn't be much scope for
> > > differences.  Source, destination, bytecount ... go!  (Not that it's
> > > anywhere *near* that quick in the current interface.)
> > 
> > Well, I can imagine copying scatterlists may be useful too. Also, some
> > controllers support "stride" (or "scatter-gather", as Synopsys calls
> > it), which can be useful for framebuffer bitblt acceleration, for
> > example.
> 
> The OMAP1 DMA controller supports that.  There were also some
> framebuffer-specific DMA options.  ;)

See? The DMA engine framework doesn't even support all forms of memcpy
transfers yet. Why not get some basic DMA slave functionality in place
first and take it from there?

> > > For peripheral DMA, maybe it should be a "core plus subclasses"
> > > approach so that platform drivers can make use hardware-specific
> > > knowledge (SOC-specific peripheral drivers using SOC-specific DMA),
> > > sharing core code for dma-memcpy() and DMA channel housekeeping.
> > 
> > I mostly agree, but I think providing basic DMA slave transfers only
> > through extensions will cause maintenance nightmares for the drivers
> > using it. 
> 
> See above ... if you've got a driver that's got to cope with
> different DMA engines, those may be inescapable.

Yes, but I think we should at least _try_ to avoid them as much as
possible. I'm not aiming for "perfect", I'm aiming for "better than
what we have now".

> > But I suppose we could have something along the lines of 
> > "core plus standard subclasses plus SOC-specific subclasses"...
> 
> That seems like one layer too many!

Why? It doesn't have to be expensive, and we already have "core plus
standard subclasses"; you're arguing for adding "plus SOC-specific
subclasses". I would like to make the async_tx-specific stuff a
"standard subclass" too at some point.

> > We already have something along those lines through the capabilities
> > mask, taking care of the "standard subclasses" part. How about we add
> > some kind of type ID to struct dma_device so that a driver can use
> > container_of() to get at the extended bits if it recognizes the type?
> 
> That would seem to be needed if the interface isn't going to become
> a least-common-denominator approach -- or a kitchen-sink.

Right. I'll add a "unsigned int engine_type" field so that engine
drivers can go ahead and extend the standard dma_device structure.
Maybe we should add a "void *platform_data" field to the dma_slave
struct as well so that platforms can pass arbitrary platform-specific
information to the DMA controller driver?

Haavard
