Return-Path: <linux-kernel-owner+w=401wt.eu-S1764029AbXHFW3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764029AbXHFW3g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 18:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756366AbXHFW33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 18:29:29 -0400
Received: from gate.crashing.org ([63.228.1.57]:60779 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753727AbXHFW32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 18:29:28 -0400
Subject: Re: [PATCH 2.6.22.y] ieee1394: revert "sbp2: enforce
	32bit	DMA	mapping"
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Olaf Hering <olh@suse.de>, Robert Hancock <hancockr@shaw.ca>,
       linuxppc-dev@ozlabs.org, stable@kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <46B79F25.50205@s5r6.in-berlin.de>
References: <fa.Qn3Snqoik3hhnxcA6HqjGV0Yzck@ifi.uio.no>
	 <46B4B3DC.7020609@shaw.ca> <46B4B7C6.1040107@s5r6.in-berlin.de>
	 <1186272926.938.8.camel@localhost.localdomain>
	 <46B5824B.1000103@s5r6.in-berlin.de>
	 <1186351473.938.21.camel@localhost.localdomain>
	 <20070806135124.GA2900@suse.de>
	 <1186436848.938.75.camel@localhost.localdomain>
	 <46B79F25.50205@s5r6.in-berlin.de>
Content-Type: text/plain
Date: Tue, 07 Aug 2007 08:29:05 +1000
Message-Id: <1186439345.938.91.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-07 at 00:22 +0200, Stefan Richter wrote:
> Benjamin Herrenschmidt wrote:
> > Oh and, don't do the set_dma_mask() in sbp2, it has nothing to do there.
> > It should be in the ohci1394 driver.
> 
> That's not quite right.  OHCI-1394 implementations can go beyond 4GB bus
> address space.  (Although I don't know if there are such implementations
> available.  At least there are two implementations which can set the
> so-called Physical Range bigger than 4GB.)

Hrm..

> Sbp2 however requires that everything which it DMA-maps resides in the
> Physical Range of the controller.  This way the CPU is not involved in
> most of the data transfers.  The OHCI-1394 controller acts as bus bridge
> between IEEE 1394 bus and local bus, with a 1:1 mapping of IEEE 1394 bus
> addresses to and from local bus addresses --- but not in the whole 48
> bits white IEEE 1394 bus address range, only in the
> implementation-dependent Physical Range.  The minimum Physical Range
> that all OHCI-1394 implementations guarantee is 4GB.  I could actually
> have set a bigger mask in sbp2 when the controller supports a
> programmable bigger range.
> 
> So that's the story why that dma_set_mask went into sbp2:  Sbp2 wants
> mappings in a _subset_ of the OHCI-1394 controllers DMA range.
> 
> Anyway.  For now I will simply go with what 2.6.23-rc has and what
> 2.6.21 had:  No dma_set_mask anywhere in the 1394 subsystem.  We can
> revisit this whenever an actual need arises.

Ok, I see your point, however, the problem is that at this stage, in
linux, you really can only set the dma mask on the pci device of the
ohci. That means that sbp2 will effectively change the ohci's DMA mask
for all OHCI operations...

Architectures like powerpc (and possibly others) need to track what
iommu/bridge/etc... a device is on for proper mapping and provide
different DMA operations for different busses. Thus, only devices that
have properly been "setup" by the architecture for DMA can use the DMA
operations.

So while ideally, sbp2 should set the dma mask on itself (or rather on
the sbp2 device) and then use that device for dma mapping operations,
this will not work.

Now, we could try to devise a generic API for use by things such as
ieee1394 to "make DMA'able" sub devices of a pci device with local dma
masks. At least for powerpc, it wouldn't be too hard, but other archs
might have issues if they do things like test for the bus_type.

Cheers,
Ben.


