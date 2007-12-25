Return-Path: <linux-kernel-owner+w=401wt.eu-S1751651AbXLYVWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751651AbXLYVWS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 16:22:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751117AbXLYVWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 16:22:09 -0500
Received: from gate.crashing.org ([63.228.1.57]:40709 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079AbXLYVWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 16:22:06 -0500
Subject: Re: [RFC/PATCH 4/4] [POWERPC] pci: Disable IO/Mem on a device when
	resources can't be allocated
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Grant Grundler <grundler@parisc-linux.org>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, Alan Cox <alan@redhat.com>,
       Greg Kroah-Hartman <greg@kroah.com>, jgarzik@pobox.com,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, wingel@nano-system.com,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, james.smart@emulex.com,
       linux-driver@qlogic.com, linux-kernel@vger.kernel.org
In-Reply-To: <20071224072301.GD3758@colo.lackof.org>
References: <1197932473.576079.142524077033.qpush@grosgo>
	 <20071217230127.46B3BDDE38@ozlabs.org>
	 <20071224072301.GD3758@colo.lackof.org>
Content-Type: text/plain
Date: Wed, 26 Dec 2007 08:20:53 +1100
Message-Id: <1198617653.7209.4.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-12-24 at 00:23 -0700, Grant Grundler wrote:
> On Tue, Dec 18, 2007 at 10:01:15AM +1100, Benjamin Herrenschmidt wrote:
> > This patch changes the PowerPC PCI code to disable IO and/or Memory
> > decoding on a PCI device when a resource of that type failed to be
> > allocated. This is done to avoid having unallocated dangling BARs enabled
> > that might try to decode on top of other devices.
> > 
> > If a proper resource is assigned later on, then pci_enable_device{,_io,_mem}
> > will take care of re-enabling decoding.
> > 
> > Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ....
> > @@ -1062,8 +1065,12 @@ static void __init pcibios_allocate_reso
> >  				disabled = !(command & PCI_COMMAND_IO);
> >  			else
> >  				disabled = !(command & PCI_COMMAND_MEMORY);
> > -			if (pass == disabled)
> > -				alloc_resource(dev, idx);
> > +			if (pass == disabled && alloc_resource(dev, idx)) {
> > +				command &= ~(r->flags & (IORESOURCE_IO |
> > +							 IORESOURCE_MEM));
> 
> While this may be ok for PPC, in general, wouldn't we want to only disable
> which ever type of resource that couldn't be allocated?

This is exactly what's supposed to be happening, but the code is buggy
and nobody noticed :-) (I'm mixing up IORESOURCE_* flags and
PCI_COMMAND_* flags). Thanks for reviewing !

> ie make two calls: alloc_resource_io() and alloc_resource_mem() and disable
> the respective flag if the alloc call fails?

No need for 2 calls, just disable whatever type the resource is, but
using the right bits instead of what my code incorrectly does.

> Thus a device which was enable and programmed by BIOS could remain functional
> despite one resource not being allocated.

Yes, that's what intended by the above code, if I didn't have mixed up
the flags.

Ben.


