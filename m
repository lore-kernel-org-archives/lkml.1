Return-Path: <linux-kernel-owner+w=401wt.eu-S934016AbYAaNwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934016AbYAaNwy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 08:52:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765563AbYAaNwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 08:52:38 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:60441 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932905AbYAaNwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 08:52:18 -0500
Date: Thu, 31 Jan 2008 14:52:14 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: David Brownell <david-b@pacbell.net>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
       Shannon Nelson <shannon.nelson@intel.com>, kernel@avr32linux.org,
       "Francis Moreau" <francis.moro@gmail.com>,
       "Paul Mundt" <lethal@linux-sh.org>,
       "Vladimir A. Barinov" <vbarinov@ru.mvista.com>,
       Pierre Ossman <drzeus-list@drzeus.cx>
Subject: Re: [RFC v2 2/5] dmaengine: Add slave DMA interface
Message-ID: <20080131145214.5bfaf2c5@dhcp-252-066.norway.atmel.com>
In-Reply-To: <200801310027.25516.david-b@pacbell.net>
References: <1201630213-31900-1-git-send-email-hskinnemoen@atmel.com>
	<200801300252.50344.david-b@pacbell.net>
	<20080130132651.7320d301@dhcp-252-066.norway.atmel.com>
	<200801310027.25516.david-b@pacbell.net>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2008 00:27:24 -0800
David Brownell <david-b@pacbell.net> wrote:
> On Wednesday 30 January 2008, Haavard Skinnemoen wrote:
> > So basically, you're asking for maximum flexibility with minimum
> > overhead.
> 
> That's always a goal, but that's not what I said.  I was pointing out
> one scenario I ran into ... where starting with the simple solution
> ran into product issues which were unfixable without using some of the
> more advanced (and nonportable!!) hardware mechanisms.

Right. I'm just having a bit of trouble understanding what you're
really asking for. I think it's something along the lines of:
  * A light-weight interface for doing DMA transfers
  * Still, this interface must be able to handle all kinds of controller-
    specific bells and whistles
  * Those bells and whistles should be configurable per-transfer, not
    only per-channel.

So how about we provide:
  * A hook for changing the default channel settings (many of which may
    really be per-transfer; this depends on the specific controller)
  * A hook for changing the settings of a descriptor after it has been
    prepared with the default settings.

Both of these hooks may take a controller-specific struct, or possibly
a standard struct that can be extended by the controller. This would
ensure that transfers using default settings are still reasonably fast,
while clients with controller-specific knowledge can still tweak things.

We could also let the controller extend the dma_device struct to add
such hooks on its own.

How does that sound?

> > I agree that should be the ultimate goal, but wouldn't it be 
> > better to start with something more basic?
> 
> Where you start is often NOT where you end up!  You should make sure
> that a wants-to-be-generic slave interface can accomodate a variety of
> non-basic mechanisms, without getting bloated.  :)

Right.

> > > That particular hardware has enough of the "logical" channels that each
> > > driver gets its own; one level of arbitration involves assigning those
> > > to underlying "physical" channels.
> > 
> > Yeah, there doesn't necessarily have to be a 1:1 mapping between
> > channels exported by the driver and actual physical channels.
> 
> You probably missed the point that both "logical" and "physical"
> channels in that case have hardware support.  Drivers didn't really
> need to worry about not being able to allocate a (logical) channel.

Ok, maybe I did. But I'm not sure if it actually matters to my
argument. A device supporting "logical" channels in hardware could
still have a driver that pretends it has even more "logical" channels.

> Yes, I also had the half-thought that maybe that notion could show
> up in the "dmaengine" framework...  ;)

Yes, I think this may allow us to move quite a few settings from
"per-transfer" to "per-channel" territory, which would simplify things
and reduce the transfer setup overhead.

> > > I wouldn't assume that systems have that much overcapacity on
> > > their critical I/O paths.  I've certainly seen systems tune those
> > > busses down in speed ... you might describe the "why" as "tweaking
> > > battery performance", which wasn't at all an optional stage of the
> > > system development process.
> > 
> > But devices that do flow control should work just fine with scaled-down
> > bus speeds.
> 
> Modulo the little glitches the hardware people always throw at us.
> Like little synchronization races when the various signals don't
> cross the same clock domains, and errata that creep in ... and the
> fact that "just fine" can still have performance requirements, ones
> that get harder to satisfy when the overcapacity gets shaved.

Right, but such quirks tend to be very chip-specific, or even specific
to a certain chip revision. So I really think this information
ultimately needs to come from the platform code, but we should perhaps
think about how to pass this information through the client driver and
into the DMA engine driver.

> > > > We already have something along those lines through the capabilities
> > > > mask, taking care of the "standard subclasses" part. How about we add
> > > > some kind of type ID to struct dma_device so that a driver can use
> > > > container_of() to get at the extended bits if it recognizes the type?
> > > 
> > > That would seem to be needed if the interface isn't going to become
> > > a least-common-denominator approach -- or a kitchen-sink.
> > 
> > Right. I'll add a "unsigned int engine_type" field so that engine
> > drivers can go ahead and extend the standard dma_device structure.
> 
> Better to have some sort of "struct engine_type" and include a pointer
> to it.  That way there's no global enum in a header to maintain and
> evolve over time.

What do we put in it though? The only thing we really need is some sort
of type id so that clients can know what type to throw at container_of.

If you mean "struct engine_type" should be controller-specific, we
still need a type ID to determine what kind of type it really is.

> > Maybe we should add a "void *platform_data" field to the dma_slave
> > struct as well so that platforms can pass arbitrary platform-specific
> > information to the DMA controller driver?
> 
> Why not just use container_of() wrappers?

Not all drivers may need any platform data. The engine driver must be
able to distinguish between the dma_slave structs that have additional
data attached to them and those that don't.

But if container_of() turns out to make things cleaner, and these
issues can be solved some other way, sure.

Haavard
