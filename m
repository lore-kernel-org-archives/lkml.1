Return-Path: <linux-kernel-owner+w=401wt.eu-S1756661AbYAIVbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661AbYAIVbS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 16:31:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754216AbYAIVbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 16:31:07 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:58195 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754772AbYAIVbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 16:31:06 -0500
Subject: Re: [RFC/PARTIAL PATCH 0/3] dma: passing "attributes" to dma_map_*
	routines
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: akepner@sgi.com, Tony Luck <tony.luck@intel.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       David Miller <davem@davemloft.net>, Muli Ben-Yehuda <muli@il.ibm.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <adaprwa7lzd.fsf@cisco.com>
References: <20080108023222.GP23661@sgi.com>
	 <1199809628.3534.34.camel@localhost.localdomain>
	 <ada63y4kycs.fsf@cisco.com>
	 <1199814853.3534.39.camel@localhost.localdomain>
	 <adawsqkjipz.fsf@cisco.com>
	 <1199816504.3534.59.camel@localhost.localdomain>
	 <adaprwa7lzd.fsf@cisco.com>
Content-Type: text/plain
Date: Wed, 09 Jan 2008 15:30:58 -0600
Message-Id: <1199914258.3493.53.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-01-09 at 13:00 -0800, Roland Dreier wrote:
> > What it wants to do is set strict ordering for the bus ... well, that is
>  > an attribute in the PCIe standard (it just happens to be the default one
>  > for a standard bus, whereas relaxed is the default for altix).  However,
>  > set bus attribute strict would be a simple no-op for a standard bus (and
>  > set attribute relaxed a no-op for altix).
> 
> I don't think that this can work.  As Arthur and I have said several
> times, the Altix issue is within the system NUMA interconnect --
> nothing to do with the PCI bus.

Attributes are supposed to be in force all the way from the bus domain
to the CPU domain.  That means that all of the strange busses you
traverse are theoretically part of the same attribute: The PCI spec
doesn't let you re-order just because you traverse the hypertransport to
get into the CPU domain if you're spec compliant, the hypertransport has
to enforce the same ordering as PCI.

>   And as I understand things, to get
> good performance, we have to allow reordering within the NUMA
> interconnect except that certain transactions need to flush all
> earlier writes.  So this attribute needs to be set per-mapping, not
> per-bus.

I don't believe I said a bus attribute wouldn't be per mapping.  Most
PCI attributes are set per transaction.  The correct paradigm for us
looks to be per device per mapping ... which is correct .. it's from the
CPU to the device regardless of busses traversed.

> If you have a cleaner way to specify this attribute that Arthur's
> idea, then it would be very useful to share that.  If we were starting
> from scratch, then probably adding another "flags" parameter to the
> DMA mapping functions would be the way to go, but given the number of
> calls to dma_map_xxx all around, changing the signature now doesn't
> look very appealing.

My main objection is the direction overloading ... given the number of
potential attributes we run out of bits fast.

However, given that very few device drivers want actually to modify the
attributes away from the default, I think all you need is an opaque
attribute structure

struct bus_attribute;

methods for initialising and setting it

struct bus_attribute attr = BUS_ATTRIBUTE(blah|blah);

bus_set_attribute(&attr, blah)

and a *new* API for taking it.

dma_map/unmap_sg/single_attr()

That way, we can support virtually any weird and wonderful attribute and
because it's done by an opaque structure, we can never run out of bits.
This will work both for the altix bus and the PCIe bus (and any other
future bus type).

Also, there can be a generic implementation of the _attr() calls, so
only architectures actually implementing them need be updated.

> The reason this hasn't been an issue until now is that almost all
> drivers work correctly if the Altix code just sets the "flush" bit for
> memory allocated via the consistent/coherent allocators.  However, if
> we want the device to write to userspace memory, this doesn't work
> (and mapping coherent memory allocated in the kernel into userspace is
> a mess on other platforms, because it unnecessarily consumes lowmem
> and/or kernel address space).

Yes, I understand the reasons, I just want the API to suit non-altix.

> Also, all of this is quite separate from the PCIe "loose ordering"
> stuff.  In fact, it's quite conceivable that SGI could hook up a PCIe
> 3.0 host bridge to the Altix NUMA interconnect, so that you could have
> a PCI bus that supported loose ordering and also a system interconnect
> that allowed a different type of reordering too.

Actually, no ... there'd just be an even weirder attribute, I suspect.
The attributes will be set per *transaction* not per bus.  A transaction
is an operation (DMA, PIO, config space, etc) from the actual bus to the
CPU.  It doesn't matter how many physical bus segments this traverses
and whether they're different bus types; all that matters for the
attributes are the characteristics that are CPU visible.

James


