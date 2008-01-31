Return-Path: <linux-kernel-owner+w=401wt.eu-S1761546AbYAaI1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761546AbYAaI1j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 03:27:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbYAaI13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 03:27:29 -0500
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:35220 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752527AbYAaI12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 03:27:28 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=i1/pdezJigAWXVSZPTMpwF/RybijNIa5lwzW7dvrBYatCXAD+d2VX2Y4YIsUesthppPrM0Kje5pyD76KhULGuajra68LPTo1sQnosHWmO6QuCysjfZ8qkOgCbu9m6vQ28iiZuO9yQXQFh6T29N4Oqf0IJ4Z0TvCDYmVyuSfyxjM=  ;
X-YMail-OSG: SYdwRF0VM1lVVtcQXNMV17ifVfEHfUSX4ZqjuodV.40MCHJ5
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: [RFC v2 2/5] dmaengine: Add slave DMA interface
Date: Thu, 31 Jan 2008 00:27:24 -0800
User-Agent: KMail/1.9.6
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
       Shannon Nelson <shannon.nelson@intel.com>, kernel@avr32linux.org,
       "Francis Moreau" <francis.moro@gmail.com>,
       "Paul Mundt" <lethal@linux-sh.org>,
       "Vladimir A. Barinov" <vbarinov@ru.mvista.com>,
       Pierre Ossman <drzeus-list@drzeus.cx>
References: <1201630213-31900-1-git-send-email-hskinnemoen@atmel.com> <200801300252.50344.david-b@pacbell.net> <20080130132651.7320d301@dhcp-252-066.norway.atmel.com>
In-Reply-To: <20080130132651.7320d301@dhcp-252-066.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801310027.25516.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 January 2008, Haavard Skinnemoen wrote:
> > > > Example:  USB tends to use one packet per "frame" and have the DMA
> > > > request signal mean "give me the next frame".  It's sometimes been
> > > > very important to use use the tuning options to avoid some on-chip
> > > > race conditions for transfers that cross lots of internal busses and
> > > > clock domains, and to have special handling for aborting transfers
> > > > and handling "short RX" packets.
> > > 
> > > Is it enough to set these options on a per-channel basis, or do they
> > > have to be per-transfer?
> > 
> > Some depend on the buffer alignment and size, so "per-transfer" is the
> > norm.  Of course, if there aren't many channels, the various clients
> > may need to recycle them a lot ... which means lots of setup anyway.
> 
> So basically, you're asking for maximum flexibility with minimum
> overhead.

That's always a goal, but that's not what I said.  I was pointing out
one scenario I ran into ... where starting with the simple solution
ran into product issues which were unfixable without using some of the
more advanced (and nonportable!!) hardware mechanisms.


> I agree that should be the ultimate goal, but wouldn't it be 
> better to start with something more basic?

Where you start is often NOT where you end up!  You should make sure
that a wants-to-be-generic slave interface can accomodate a variety of
non-basic mechanisms, without getting bloated.  :)


> > That particular hardware has enough of the "logical" channels that each
> > driver gets its own; one level of arbitration involves assigning those
> > to underlying "physical" channels.
> 
> Yeah, there doesn't necessarily have to be a 1:1 mapping between
> channels exported by the driver and actual physical channels.

You probably missed the point that both "logical" and "physical"
channels in that case have hardware support.  Drivers didn't really
need to worry about not being able to allocate a (logical) channel.

Yes, I also had the half-thought that maybe that notion could show
up in the "dmaengine" framework...  ;)


> > I wouldn't assume that systems have that much overcapacity on
> > their critical I/O paths.  I've certainly seen systems tune those
> > busses down in speed ... you might describe the "why" as "tweaking
> > battery performance", which wasn't at all an optional stage of the
> > system development process.
> 
> But devices that do flow control should work just fine with scaled-down
> bus speeds.

Modulo the little glitches the hardware people always throw at us.
Like little synchronization races when the various signals don't
cross the same clock domains, and errata that creep in ... and the
fact that "just fine" can still have performance requirements, ones
that get harder to satisfy when the overcapacity gets shaved.


> And I don't think such platform-specific tuning belongs in 
> the driver anyway. Platform code can use all kinds of specialized
> interfaces

In platform-specific drivers, it's common to *NEED* to use lots
of different platform-specific mechanisms.  The DMA engine and
the controller may well have been co-designed to address various
system-wide requirements, for example.  It depends on how tightly
integrated things are.


> > > We already have something along those lines through the capabilities
> > > mask, taking care of the "standard subclasses" part. How about we add
> > > some kind of type ID to struct dma_device so that a driver can use
> > > container_of() to get at the extended bits if it recognizes the type?
> > 
> > That would seem to be needed if the interface isn't going to become
> > a least-common-denominator approach -- or a kitchen-sink.
> 
> Right. I'll add a "unsigned int engine_type" field so that engine
> drivers can go ahead and extend the standard dma_device structure.

Better to have some sort of "struct engine_type" and include a pointer
to it.  That way there's no global enum in a header to maintain and
evolve over time.


> Maybe we should add a "void *platform_data" field to the dma_slave
> struct as well so that platforms can pass arbitrary platform-specific
> information to the DMA controller driver?

Why not just use container_of() wrappers?

- Dave
