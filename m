Return-Path: <linux-kernel-owner+w=401wt.eu-S1755417AbYAHSWJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbYAHSWJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 13:22:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753013AbYAHSVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 13:21:54 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:57222 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755182AbYAHSVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 13:21:51 -0500
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
In-Reply-To: <adawsqkjipz.fsf@cisco.com>
References: <20080108023222.GP23661@sgi.com>
	 <1199809628.3534.34.camel@localhost.localdomain>
	 <ada63y4kycs.fsf@cisco.com>
	 <1199814853.3534.39.camel@localhost.localdomain>
	 <adawsqkjipz.fsf@cisco.com>
Content-Type: text/plain
Date: Tue, 08 Jan 2008 12:21:44 -0600
Message-Id: <1199816504.3534.59.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-01-08 at 10:05 -0800, Roland Dreier wrote:
> > > I think the case before us that Arthur is dealing with is a
>  > > counterexample for this: there's nothing bus-specific about it all.
>  > > The issue is related to reordering of DMAs within the Altix system
>  > > fabric, after they've left the PCI world.  This issue would be present
>  > > no matter what kind of host bridge you hook up to the system fabric,
>  > > be it PCI-X, PCIe, ISA, MCA or whatever.
> 
>  > But it is: for performance reasons, the Altix boxes have a rather non
>  > standard PCI bridge implementation that gives relaxed ordering on the
>  > PCI bus.
> 
> I don't think this is accurate. As I understand things, the reordering
> happens within the Altix system interconnect

Which would be a platform bus, rather like the runway bus in parisc
systems ...

>  -- nothing to do with the
> PCI bridge hanging off this fabric.  It is "platform" behavior and I
> think is properly handled within the dma_ API, which exists to
> abstract platforms.


>  > This behaviour was later standardised to some degree in PCIe,
>  > so you could argue they actually have an altix specific PCI bus (PCIa
>  > anyone?).  Regardless, other manufacturers are probably going to demand
>  > something equivalent to this based on the PCIe standard, so we should be
>  > ready for it, hence the desire for the bus specific attributes.
> 
> But:
>  a) The Altix has PCI-X, not PCIe, so having something PCIe-specific
>     is not a solution for this case; and
>  b) the PCIe behavior is opt-in, in the sense that you have to
>     specifically ask for looser ordering, while the Altix is loosely
>     ordered unless you ask for this "flush" property.  So I don't
>     think the same attribute will work for both cases.

But the point is that the Altix does something non-standard but which
was later standardised (in a different way) largely so others could also
benefit from the relaxed ordering speedup.

I agree the altix needs something, what I don't agree is that we should
be overloading the dma data direction to do it ... especially given the
confetti like shower of other bus attributes waiting in the wings.

What it wants to do is set strict ordering for the bus ... well, that is
an attribute in the PCIe standard (it just happens to be the default one
for a standard bus, whereas relaxed is the default for altix).  However,
set bus attribute strict would be a simple no-op for a standard bus (and
set attribute relaxed a no-op for altix).

James


