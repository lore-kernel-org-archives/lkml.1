Return-Path: <linux-kernel-owner+w=401wt.eu-S1756223AbZLUAJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223AbZLUAJ6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 19:09:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755275AbZLUAJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 19:09:56 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:48257 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755006AbZLUAJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 19:09:55 -0500
Subject: Re: [PATCH 2/12] pci: add pci_bridge_release_unused_res and
	pci_bus_release_unused_bridge_res -v2
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Alex Chiang <achiang@hp.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
In-Reply-To: <4B2C1DA9.4030907@kernel.org>
References: <4B2BE9DD.3040504@kernel.org> <4B2BEC1B.9090104@kernel.org>
	 <alpine.LFD.2.00.0912181316190.3712@localhost.localdomain>
	 <4B2C1DA9.4030907@kernel.org>
Content-Type: text/plain
Date: Sun, 20 Dec 2009 17:04:03 -0700
Message-Id: <1261353843.26429.61.camel@dc7800.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-18 at 16:26 -0800, Yinghai Lu wrote:
> Subject: [PATCH 2/12] pci: add pci_bridge_release_unused_res and pci_bus_release_unused_bridge_res -v3
> 
> so later we could use it to release small resource before pci assign unassign res
> 
> -v2: change name to release_child_resources according to Jesse
> -v3: according to Linus, move release_child_resources to resource.c
>      also need to put the lock around them all to avoid recursive deep.
>      (my test case only have one level that need to be released)
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  drivers/pci/setup-bus.c |   95 +++++++++++++++++++++++++++++++++++++++++++++++-
>  include/linux/ioport.h  |    1 
>  kernel/resource.c       |   30 +++++++++++++++
>  3 files changed, 125 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/drivers/pci/setup-bus.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/setup-bus.c
> +++ linux-2.6/drivers/pci/setup-bus.c
> @@ -209,7 +209,6 @@ static void pci_setup_bridge_mmio_pref(s
>  		l = (region.start >> 16) & 0xfff0;
>  		l |= region.end & 0xfff00000;
>  		if (res->flags & IORESOURCE_MEM_64) {
> -			pref_mem64 = 1;
>  			bu = upper_32_bits(region.start);
>  			lu = upper_32_bits(region.end);
>  		}
> @@ -608,6 +607,100 @@ void __ref pci_bus_assign_resources(cons
>  }
>  EXPORT_SYMBOL(pci_bus_assign_resources);
>  
> +static void pci_bridge_release_unused_res(struct pci_bus *bus,
> +					  unsigned long type)
> +{
> +	int idx;
> +	bool changed = false;
> +	struct pci_dev *dev;
> +	struct resource *r;
> +	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
> +				  IORESOURCE_PREFETCH;
> +
> +	/* for pci bridges res only */
> +	dev = bus->self;
> +	for (idx = PCI_BRIDGE_RESOURCES; idx < PCI_BRIDGE_RESOURCES + 3;

I *think* this magic "3" refers to the three possible windows supported
by PCI bridges (I/O, memory, prefetchable memory).  I asked you before
about using something more descriptive here; do you have any ideas?  I
think even PCI_BRIDGE_RESOURCE_NUM (4) would be better, because I think
that's the number of bridge windows we support (CardBus bridges have
four windows, regular PCI bridges only have three).  For regular PCI
bridges, that fourth window should be NULL, so it could easily be
skipped here.

> +	    idx++) {
> +		r = &dev->resource[idx];
> +		if ((r->flags & type_mask) != type)
> +			continue;
> +		if (!r->parent)
> +			continue;
> +		/*
> +		 * if there are children under that, we should release them
> +		 *  all
> +		 */
> +		release_child_resources(r);

Sorry for my ignorance here, but is it possible there's a driver using
any of these child devices?

> +		if (!release_resource(r)) {
> +			dev_printk(KERN_DEBUG, &dev->dev,
> +				 "resource %d %pR released\n", idx, r);
> +			/* keep the old size */
> +			r->end = resource_size(r) - 1;
> +			r->start = 0;
> +			r->flags = 0;
> +			changed = true;
> +		}
> +	}
> +
> +	if (changed) {
> +		if (type & IORESOURCE_PREFETCH) {
> +			/* avoiding touch the one without PREF */
> +			type = IORESOURCE_PREFETCH;
> +		}

Again, it's probably perfectly obvious why we need to leave the
non-prefetchable window untouched, but I don't know the reason.  Can you
add a comment about why that's important?

> +		__pci_setup_bridge(bus, type);
> +	}
> +}
> +
> +/*
> + * try to release pci bridge resources that is from leaf bridge,
> + * so we can allocate big new one later
> + * check:
> + *    0: only release the bridge and only the bridge is leaf
> + *    1: release all down side bridge for third shoot
> + */
> +static void __ref pci_bus_release_unused_bridge_res(struct pci_bus *bus,
> +						    unsigned long type,
> +						    int check_leaf)
> +{
> +	struct pci_dev *dev;
> +	bool is_leaf_bridge = true;
> +
> +	list_for_each_entry(dev, &bus->devices, bus_list) {
> +		struct pci_bus *b = dev->subordinate;
> +		if (!b)
> +			continue;
> +
> +		switch (dev->class >> 8) {
> +		case PCI_CLASS_BRIDGE_CARDBUS:
> +			is_leaf_bridge = false;
> +			break;
> +
> +		case PCI_CLASS_BRIDGE_PCI:
> +		default:
> +			is_leaf_bridge = false;
> +			if (!check_leaf)
> +				pci_bus_release_unused_bridge_res(b, type,
> +							 check_leaf);
> +			break;
> +		}
> +	}
> +
> +	/* The root bus? */
> +	if (!bus->self)
> +		return;
> +
> +	switch (bus->self->class >> 8) {
> +	case PCI_CLASS_BRIDGE_CARDBUS:
> +		break;
> +
> +	case PCI_CLASS_BRIDGE_PCI:

Sorry for my ignorance again.  Why do we have to treat CardBus bridges
so much differently?  I realize their windows are programmed a bit
differently, but I don't know what the conceptual difference is as far
as a bridge window being too small to accomodate all downstream devices.

> +	default:
> +		if ((check_leaf && is_leaf_bridge) || !check_leaf)
> +			pci_bridge_release_unused_res(bus, type);
> +		break;
> +	}
> +}
> +
>  static void pci_bus_dump_res(struct pci_bus *bus)
>  {
>          int i;

Bjorn


