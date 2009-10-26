Return-Path: <linux-kernel-owner+w=401wt.eu-S1755432AbZJ0ABl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432AbZJ0ABl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 20:01:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755215AbZJ0ABk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 20:01:40 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:5147 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755021AbZJ0ABj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 20:01:39 -0400
Subject: Re: [PATCH] pci: only release that resource index is less than 3
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4AE6135B.2070003@kernel.org>
References: <4AE2C827.8040905@kernel.org>
	 <200910261032.58231.bjorn.helgaas@hp.com>
	 <20091026101942.578f41b2@jbarnes-g45>  <4AE6135B.2070003@kernel.org>
Content-Type: text/plain
Date: Mon, 26 Oct 2009 17:57:56 -0600
Message-Id: <1256601476.25492.47.camel@dc7800.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-26 at 14:23 -0700, Yinghai Lu wrote:

> ===================================================================
> --- linux-2.6.orig/drivers/pci/setup-bus.c
> +++ linux-2.6/drivers/pci/setup-bus.c
> @@ -322,33 +322,54 @@ static void pci_bridge_check_ranges(stru
>  	}
>  }
>  
> -/* Helper function for sizing routines: find first available
> -   bus resource of a given type. Note: we intentionally skip
> -   the bus resources which have already been assigned (that is,
> -   have non-NULL parent resource). */
> -static struct resource *find_free_bus_resource(struct pci_bus *bus, unsigned long type)
> +void pci_bridge_release_not_used_res(struct pci_bus *bus)
>  {
>  	int i;
>  	struct resource *r;
>  	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
>  				  IORESOURCE_PREFETCH;
>  
> -	for (i = 0; i < PCI_BUS_NUM_RESOURCES; i++) {
> +	/* for pci bridges res only */
> +	for (i = 0; i < 3; i++) {

I think the "i = 0; i < 3" part is to check the bridge apertures, i.e.,
the I/O base/limit, the memory base/limit, and the prefetchable memory
base/limit.  Right?  We need some way to indicate that more clearly than
using a hard-coded "3".

>  		r = bus->resource[i];
> -		if (r == &ioport_resource || r == &iomem_resource)
> -			continue;
> -		if (r && (r->flags & type_mask) == type) {
> +		if (r && (r->flags & type_mask)) {
>  			if (!r->parent)
> -				return r;
> +				continue;
>  			/*
>  			 * if there is no child under that, we should release
>  			 * and use it. don't need to reset it, pbus_size_* will
>  			 * set it again
>  			 */
>  			if (!r->child && !release_resource(r))

We got this resource pointer out of a struct pci_bus, and we release it
here.  We must have previously done a request_resource(),
allocate_resource(), or similar.  Where does that happen?  Are the
requests and releases nested correctly?

I would think that somewhere, we would be doing a request_resource() and
assigning the resource to pci_bus->resource[x].  But there are very few
assignments to the pci_bus resources:
  setup_resource (only for "pci=use_crs")
  pci_read_bridge_bases (just a copy from upstream bus resources)
  pci_alloc_child_bus (copy from upstream bridge resources)
  pci_create_bus (set to &ioport_resource or &iomem_resource)

My guess is that this release_resource() releases something we copied
from the bridge in pci_alloc_child_bus().  But that doesn't seem right,
because we aren't changing the bridge programming here.

Maybe I'm being confused by the fact that we find the resource pointer
from the pci_bus table, but that's only a pointer to the actual struct
resource that lives in the pci_dev of the upstream bridge.

Bjorn

> -				return r;
> +				dev_printk(KERN_DEBUG, &bus->dev,
> +					   "resource %d %s %pR released\n", i,
> +					   (r->flags & IORESOURCE_IO) ? "io: " :
> +					    ((r->flags & IORESOURCE_PREFETCH)?
> +						 "pref mem":"mem:"),
> +					   r);
>  		}
>  	}
> +}
> +EXPORT_SYMBOL(pci_bridge_release_not_used_res);
> +
> +/* Helper function for sizing routines: find first available
> +   bus resource of a given type. Note: we intentionally skip
> +   the bus resources which have already been assigned (that is,
> +   have non-NULL parent resource). */
> +static struct resource *find_free_bus_resource(struct pci_bus *bus, unsigned long type)
> +{
> +	int i;
> +	struct resource *r;
> +	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
> +				  IORESOURCE_PREFETCH;
> +
> +	for (i = 0; i < PCI_BUS_NUM_RESOURCES; i++) {
> +		r = bus->resource[i];
> +		if (r == &ioport_resource || r == &iomem_resource)
> +			continue;
> +		if (r && (r->flags & type_mask) == type && !r->parent)
> +			return r;
> +	}
>  	return NULL;
>  }
>  
> @@ -588,6 +609,41 @@ void __ref pci_bus_size_bridges(struct p
>  }
>  EXPORT_SYMBOL(pci_bus_size_bridges);
>  
> +static void pci_bus_release_bridges_not_used_res(struct pci_bus *bus)
> +{
> +	struct pci_dev *dev;
> +
> +	list_for_each_entry(dev, &bus->devices, bus_list) {
> +		struct pci_bus *b = dev->subordinate;
> +		if (!b)
> +			continue;
> +
> +		switch (dev->class >> 8) {
> +		case PCI_CLASS_BRIDGE_CARDBUS:
> +			break;
> +
> +		case PCI_CLASS_BRIDGE_PCI:
> +		default:
> +			pci_bus_release_bridges_not_used_res(b);
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
> +	default:
> +		pci_bridge_release_not_used_res(bus);
> +		break;
> +	}
> +}
> +
>  void __ref pci_bridge_assign_resources(const struct pci_dev *bridge)
>  {
>  	struct pci_bus *b;
> @@ -687,6 +743,11 @@ pci_assign_unassigned_resources(void)
>  {
>  	struct pci_bus *bus;
>  
> +	/* Try to release bridge resources, that there is not child under it */
> +	list_for_each_entry(bus, &pci_root_buses, node) {
> +		pci_bus_release_bridges_not_used_res(bus);
> +	}
> +
>  	/* Depth first, calculate sizes and alignments of all
>  	   subordinate buses. */
>  	list_for_each_entry(bus, &pci_root_buses, node) {
> Index: linux-2.6/drivers/pci/hotplug/pciehp_pci.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/hotplug/pciehp_pci.c
> +++ linux-2.6/drivers/pci/hotplug/pciehp_pci.c
> @@ -171,6 +171,7 @@ int pciehp_unconfigure_device(struct slo
>  		}
>  		pci_dev_put(temp);
>  	}
> +	pci_bridge_release_not_used_res(parent);
>  
>  	return rc;
>  }
> Index: linux-2.6/include/linux/pci.h
> ===================================================================
> --- linux-2.6.orig/include/linux/pci.h
> +++ linux-2.6/include/linux/pci.h
> @@ -759,6 +759,7 @@ int pci_vpd_truncate(struct pci_dev *dev
>  void pci_bridge_assign_resources(const struct pci_dev *bridge);
>  void pci_bus_assign_resources(const struct pci_bus *bus);
>  void pci_bus_size_bridges(struct pci_bus *bus);
> +void pci_bridge_release_not_used_res(struct pci_bus *bus);
>  int pci_claim_resource(struct pci_dev *, int);
>  void pci_assign_unassigned_resources(void);
>  void pdev_enable_device(struct pci_dev *);

