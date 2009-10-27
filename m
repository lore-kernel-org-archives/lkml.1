Return-Path: <linux-kernel-owner+w=401wt.eu-S1755903AbZJ0QJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903AbZJ0QJF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 12:09:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755885AbZJ0QJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 12:09:04 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:10586 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755882AbZJ0QJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 12:09:03 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] pci: only release that resource index is less than 3
Date: Tue, 27 Oct 2009 10:09:04 -0600
User-Agent: KMail/1.9.10
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
References: <4AE2C827.8040905@kernel.org> <1256601476.25492.47.camel@dc7800.home> <4AE63CCC.3050203@kernel.org>
In-Reply-To: <4AE63CCC.3050203@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910271009.05805.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 October 2009 06:20:28 pm Yinghai Lu wrote:
> Bjorn Helgaas wrote:
> > On Mon, 2009-10-26 at 14:23 -0700, Yinghai Lu wrote:
> > 
> >> ===================================================================
> >> --- linux-2.6.orig/drivers/pci/setup-bus.c
> >> +++ linux-2.6/drivers/pci/setup-bus.c
> >> @@ -322,33 +322,54 @@ static void pci_bridge_check_ranges(stru
> >>  	}
> >>  }
> >>  
> >> -/* Helper function for sizing routines: find first available
> >> -   bus resource of a given type. Note: we intentionally skip
> >> -   the bus resources which have already been assigned (that is,
> >> -   have non-NULL parent resource). */
> >> -static struct resource *find_free_bus_resource(struct pci_bus *bus, unsigned long type)
> >> +void pci_bridge_release_not_used_res(struct pci_bus *bus)
> >>  {
> >>  	int i;
> >>  	struct resource *r;
> >>  	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
> >>  				  IORESOURCE_PREFETCH;
> >>  
> >> -	for (i = 0; i < PCI_BUS_NUM_RESOURCES; i++) {
> >> +	/* for pci bridges res only */
> >> +	for (i = 0; i < 3; i++) {
> > 
> > I think the "i = 0; i < 3" part is to check the bridge apertures, i.e.,
> > the I/O base/limit, the memory base/limit, and the prefetchable memory
> > base/limit.  Right?  We need some way to indicate that more clearly than
> > using a hard-coded "3".
> 
> yes. the 0x1c, 0x20, and 0x28

Do you have a proposal for something other than "3"?  The magic number
"3" does appear other places, e.g., pci_read_bridge_bases() but I don't
think we should add new uses of it.  Make up a descriptive #define if
nothing else.

> >>  		r = bus->resource[i];
> >> -		if (r == &ioport_resource || r == &iomem_resource)
> >> -			continue;
> >> -		if (r && (r->flags & type_mask) == type) {
> >> +		if (r && (r->flags & type_mask)) {
> >>  			if (!r->parent)
> >> -				return r;
> >> +				continue;
> >>  			/*
> >>  			 * if there is no child under that, we should release
> >>  			 * and use it. don't need to reset it, pbus_size_* will
> >>  			 * set it again
> >>  			 */
> >>  			if (!r->child && !release_resource(r))
> > 
> > We got this resource pointer out of a struct pci_bus, and we release it
> > here.  We must have previously done a request_resource(),
> > allocate_resource(), or similar.  Where does that happen?  Are the
> > requests and releases nested correctly?
> > 
> > I would think that somewhere, we would be doing a request_resource() and
> > assigning the resource to pci_bus->resource[x].  But there are very few
> > assignments to the pci_bus resources:
> >   setup_resource (only for "pci=use_crs")
> >   pci_read_bridge_bases (just a copy from upstream bus resources)
> >   pci_alloc_child_bus (copy from upstream bridge resources)
> >   pci_create_bus (set to &ioport_resource or &iomem_resource)
> > 
> > My guess is that this release_resource() releases something we copied
> > from the bridge in pci_alloc_child_bus().  But that doesn't seem right,
> > because we aren't changing the bridge programming here.
> 
> in arch/x86/pci/i386.c::
> pcibios_resource_survey() ==> pcibios_allocate_bus_resources()

The asymmetry here bothers me.  The pci_claim_resource() in
pcibios_allocate_bus_resources() is done on a *device*, while the
release_resource() you added is done on a *bus*.  And the claim is
done in arch-specific code, while the release is done in generic
code.  And there's an interval where the bridge device resources
don't match the hardware apertures, and it's hard to figure out
when they are in sync again.

This might all work fine, but it's harder to understand than it
should be.

Bjorn
