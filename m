Return-Path: <linux-kernel-owner+w=401wt.eu-S1752865AbZKJIAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865AbZKJIAr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 03:00:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752714AbZKJIAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 03:00:46 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54812 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbZKJIAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 03:00:44 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4AF91D9B.5000407@jp.fujitsu.com>
Date: Tue, 10 Nov 2009 17:00:27 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Alex Chiang <achiang@hp.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: Re: [PATCH 1/2] pci: release that leaf bridge' resource that is not
 big -v8
References: <4ADEB601.8020200@kernel.org> <4AE52B68.3070501@jp.fujitsu.com>	<4AE53883.3070709@kernel.org> <4AE5545E.1020900@jp.fujitsu.com>	<4AE55D12.30403@kernel.org> <4AE57976.4060107@jp.fujitsu.com>	<4AE5E37F.8070707@kernel.org> <4AE5EFDB.2060908@kernel.org>	<4AE80170.6030402@jp.fujitsu.com> <4AE88305.8020207@kernel.org>	<m1ljivibrt.fsf@fess.ebiederm.org> <4AE897B4.9030206@kernel.org>	<m1eionia3y.fsf@fess.ebiederm.org> <4AE8A080.1040208@kernel.org>	<m1pr87cilf.fsf@fess.ebiederm.org> <4AE8BA1D.5030908@kernel.org>	<4AE8C4BF.8040306@kernel.org> <m1my3aboon.fsf@fess.ebiederm.org>	<4AE95A57.6050504@kernel.org> <m1zl7a9ped.fsf@fess.ebiederm.org>	<4AE9CA10.10302@kernel.org> <m1pr86x9qj.fsf@fess.ebiederm.org> <4AEAA579.9040707@kernel.org>
In-Reply-To: <4AEAA579.9040707@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yinghai,

Sorry for the delayed response.
I'll try your patches on my machine soon (maybe in
the few days).

Thanks,
Kenji Kaneshige


Yinghai Lu wrote:
> 
> only for index < 3
> 
> v2: Jesse doesn't like it is in find_free_bus_resource...
>     try to move out of pci_bus_size_bridges loop.
> v3: add pci_setup_bridge calling after pci_bridge_release_not_used_res.
>     only clear release those res for x86.
> v4: Bjorn want to release use dev instead of bus.
> v5: Kenji pointed out it will have problem with several level bridge.
>     so let only handle leaf bridge.
> v6: address Kenji's request (new pci_bus_release...). and change applying order
>     move back release to pci_assign_unassigned_resource
> v7: change functions name pci_bus_release_unused_bridge_res according to Jesse
> v8: address Eric's concern, only overwrite leaf bridge resource that is not big enough
>     need to do it in two steps, and first step recore the failed res, and don't
>     touch bridge res that programmed by firmware. second step will try to release
>     bridge resource that is too small at first.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  drivers/pci/setup-bus.c |  258 ++++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 239 insertions(+), 19 deletions(-)
> 
> Index: linux-2.6/drivers/pci/setup-bus.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/setup-bus.c
> +++ linux-2.6/drivers/pci/setup-bus.c
> @@ -27,11 +27,54 @@
>  #include <linux/slab.h>
>  #include "pci.h"
>  
> -static void pbus_assign_resources_sorted(const struct pci_bus *bus)
> +
> +static void add_to_failed_list(struct resource_list *head, struct pci_dev *dev,
> +				 struct resource *res)
> +{
> +	struct resource_list *list = head;
> +	struct resource_list *ln = list->next;
> +	struct resource_list *tmp;
> +
> +	tmp = kmalloc(sizeof(*tmp), GFP_KERNEL);
> +	if (!tmp) {
> +		pr_warning("add_to_failed_list: kmalloc() failed!\n");
> +		return;
> +	}
> +
> +	tmp->next = ln;
> +	tmp->res = res;
> +	tmp->dev = dev;
> +	list->next = tmp;
> +}
> +
> +static void free_failed_list(struct resource_list *head)
> +{
> +	struct resource_list *list, *tmp;
> +	struct resource *res;
> +	/*
> +	 * Try to release leaf bridge's resources that there is no child
> +	 * under it
> +	 */
> +	for (list = head->next; list;) {
> +		res = list->res;
> +		res->start = 0;
> +		res->end = 0;
> +		res->flags = 0;
> +		tmp = list;
> +		list = list->next;
> +		kfree(tmp);
> +	}
> +
> +	head->next = NULL;
> +}
> +
> +static void pbus_assign_resources_sorted(const struct pci_bus *bus,
> +					 struct resource_list *fail_head)
>  {
>  	struct pci_dev *dev;
>  	struct resource *res;
>  	struct resource_list head, *list, *tmp;
> +	resource_size_t size;
>  	int idx;
>  
>  	head.next = NULL;
> @@ -57,10 +100,22 @@ static void pbus_assign_resources_sorted
>  	for (list = head.next; list;) {
>  		res = list->res;
>  		idx = res - &list->dev->resource[0];
> +		/* save the size at first */
> +		size = resource_size(res);
>  		if (pci_assign_resource(list->dev, idx)) {
> -			res->start = 0;
> -			res->end = 0;
> -			res->flags = 0;
> +			if (fail_head && !list->dev->subordinate) {
> +				/*
> +				 * device need to keep flags and size
> +				 * for second try
> +				 */
> +				res->start = 0;
> +				res->end   = size - 1;
> +				add_to_failed_list(fail_head, list->dev, res);
> +			} else {
> +				res->start = 0;
> +				res->end = 0;
> +				res->flags = 0;
> +			}
>  		}
>  		tmp = list;
>  		list = list->next;
> @@ -137,18 +192,12 @@ EXPORT_SYMBOL(pci_setup_cardbus);
>     config space writes, so it's quite possible that an I/O window of
>     the bridge will have some undesirable address (e.g. 0) after the
>     first write. Ditto 64-bit prefetchable MMIO.  */
> -static void pci_setup_bridge(struct pci_bus *bus)
> +
> +static void pci_setup_bridge_io(struct pci_bus *bus)
>  {
>  	struct pci_dev *bridge = bus->self;
>  	struct pci_bus_region region;
> -	u32 l, bu, lu, io_upper16;
> -	int pref_mem64;
> -
> -	if (pci_is_enabled(bridge))
> -		return;
> -
> -	dev_info(&bridge->dev, "PCI bridge, secondary bus %04x:%02x\n",
> -		 pci_domain_nr(bus), bus->number);
> +	u32 l, io_upper16;
>  
>  	/* Set up the top and bottom of the PCI I/O segment for this bus. */
>  	pcibios_resource_to_bus(bridge, &region, bus->resource[0]);
> @@ -175,7 +224,12 @@ static void pci_setup_bridge(struct pci_
>  	pci_write_config_dword(bridge, PCI_IO_BASE, l);
>  	/* Update upper 16 bits of I/O base/limit. */
>  	pci_write_config_dword(bridge, PCI_IO_BASE_UPPER16, io_upper16);
> -
> +}
> +static void pci_setup_bridge_mmio(struct pci_bus *bus)
> +{
> +	struct pci_dev *bridge = bus->self;
> +	struct pci_bus_region region;
> +	u32 l;
>  	/* Set up the top and bottom of the PCI Memory segment
>  	   for this bus. */
>  	pcibios_resource_to_bus(bridge, &region, bus->resource[1]);
> @@ -191,6 +245,13 @@ static void pci_setup_bridge(struct pci_
>  		dev_info(&bridge->dev, "  MEM window: disabled\n");
>  	}
>  	pci_write_config_dword(bridge, PCI_MEMORY_BASE, l);
> +}
> +static void pci_setup_bridge_mmio_pref(struct pci_bus *bus)
> +{
> +	struct pci_dev *bridge = bus->self;
> +	struct pci_bus_region region;
> +	u32 l, bu, lu;
> +	int pref_mem64;
>  
>  	/* Clear out the upper 32 bits of PREF limit.
>  	   If PCI_PREF_BASE_UPPER32 was non-zero, this temporarily
> @@ -226,10 +287,37 @@ static void pci_setup_bridge(struct pci_
>  		pci_write_config_dword(bridge, PCI_PREF_BASE_UPPER32, bu);
>  		pci_write_config_dword(bridge, PCI_PREF_LIMIT_UPPER32, lu);
>  	}
> +}
> +static void __pci_setup_bridge(struct pci_bus *bus, unsigned long type)
> +{
> +	struct pci_dev *bridge = bus->self;
> +
> +	if (pci_is_enabled(bridge))
> +		return;
> +
> +	dev_info(&bridge->dev, "PCI bridge, secondary bus %04x:%02x\n",
> +		 pci_domain_nr(bus), bus->number);
> +
> +	if (type & IORESOURCE_IO)
> +		pci_setup_bridge_io(bus);
> +
> +	if (type & IORESOURCE_MEM)
> +		pci_setup_bridge_mmio(bus);
> +
> +	if (type & IORESOURCE_PREFETCH)
> +		pci_setup_bridge_mmio_pref(bus);
>  
>  	pci_write_config_word(bridge, PCI_BRIDGE_CONTROL, bus->bridge_ctl);
>  }
>  
> +static void pci_setup_bridge(struct pci_bus *bus)
> +{
> +	unsigned long type = IORESOURCE_IO | IORESOURCE_MEM |
> +				  IORESOURCE_PREFETCH;
> +
> +	__pci_setup_bridge(bus, type);
> +}
> +
>  /* Check whether the bridge supports optional I/O and
>     prefetchable memory ranges. If not, the respective
>     base/limit registers must be read-only and read as 0. */
> @@ -541,19 +629,20 @@ void __ref pci_bus_size_bridges(struct p
>  }
>  EXPORT_SYMBOL(pci_bus_size_bridges);
>  
> -void __ref pci_bus_assign_resources(const struct pci_bus *bus)
> +static void __ref __pci_bus_assign_resources(const struct pci_bus *bus,
> +					 struct resource_list *fail_head)
>  {
>  	struct pci_bus *b;
>  	struct pci_dev *dev;
>  
> -	pbus_assign_resources_sorted(bus);
> +	pbus_assign_resources_sorted(bus, fail_head);
>  
>  	list_for_each_entry(dev, &bus->devices, bus_list) {
>  		b = dev->subordinate;
>  		if (!b)
>  			continue;
>  
> -		pci_bus_assign_resources(b);
> +		__pci_bus_assign_resources(b, fail_head);
>  
>  		switch (dev->class >> 8) {
>  		case PCI_CLASS_BRIDGE_PCI:
> @@ -571,15 +660,105 @@ void __ref pci_bus_assign_resources(cons
>  		}
>  	}
>  }
> +
> +void __ref pci_bus_assign_resources(const struct pci_bus *bus)
> +{
> +	__pci_bus_assign_resources(bus, NULL);
> +}
>  EXPORT_SYMBOL(pci_bus_assign_resources);
>  
> +static void release_children_resource(struct resource *r)
> +{
> +	struct resource *p;
> +	resource_size_t size;
> +
> +	p = r->child;
> +	while (p) {
> +		release_children_resource(p);
> +		release_resource(p);
> +		printk(KERN_DEBUG "PCI: release child resource %pRt\n", p);
> +		/* need to restore size, and keep flags */
> +		size = resource_size(p);
> +		p->start = 0;
> +		p->end = size - 1;
> +		p = r->child;
> +	}
> +}
> +
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
> +		release_children_resource(r);
> +		if (!release_resource(r)) {
> +			dev_printk(KERN_DEBUG, &dev->dev,
> +				 "resource %d %pRt released\n", idx, r);
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
> +		__pci_setup_bridge(bus, type);
> +	}
> +}
> +
> +/*
> + * try to release pci bridge resources that is from leaf bridge,
> + * so we can allocate big new one later
> + */
> +static void __ref pci_bus_release_unused_bridge_res(struct pci_bus *bus,
> +						    unsigned long type)
> +{
> +	struct pci_bus *b;
> +
> +	/* If the bus is cardbus, do nothing */
> +	if (bus->self && (bus->self->class >> 8) == PCI_CLASS_BRIDGE_CARDBUS)
> +		return;
> +
> +	/* We only release the resources under the leaf bridge */
> +	if (list_empty(&bus->children)) {
> +		if (!pci_is_root_bus(bus))
> +			pci_bridge_release_unused_res(bus, type);
> +		return;
> +	}
> +
> +	/* Scan child buses if the bus is not leaf */
> +	list_for_each_entry(b, &bus->children, node)
> +		pci_bus_release_unused_bridge_res(b, type);
> +}
> +
>  static void pci_bus_dump_res(struct pci_bus *bus)
>  {
>          int i;
>  
>          for (i = 0; i < PCI_BUS_NUM_RESOURCES; i++) {
>                  struct resource *res = bus->resource[i];
> -                if (!res || !res->end)
> +
> +		if (!res || !res->end || !res->flags)
>                          continue;
>  
>  		dev_printk(KERN_DEBUG, &bus->dev, "resource %d %pRt\n", i, res);
> @@ -607,6 +786,12 @@ void __init
>  pci_assign_unassigned_resources(void)
>  {
>  	struct pci_bus *bus;
> +	bool second_tried = false;
> +	struct resource_list head, *list, *tmp;
> +	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
> +				  IORESOURCE_PREFETCH;
> +again:
> +	head.next = NULL;
>  
>  	/* Depth first, calculate sizes and alignments of all
>  	   subordinate buses. */
> @@ -615,7 +800,42 @@ pci_assign_unassigned_resources(void)
>  	}
>  	/* Depth last, allocate resources and update the hardware. */
>  	list_for_each_entry(bus, &pci_root_buses, node) {
> -		pci_bus_assign_resources(bus);
> +		__pci_bus_assign_resources(bus, &head);
> +	}
> +
> +	/* any device complain? */
> +	if (!head.next)
> +		goto enable_and_dump;
> +
> +	if (second_tried) {
> +		/* still fail, don't want to try more */
> +		free_failed_list(&head);
> +		goto enable_and_dump;
> +	}
> +
> +	second_tried = true;
> +	printk(KERN_DEBUG "PCI: second try to assign unassigned res\n");
> +
> +	/*
> +	 * Try to release leaf bridge's resources that doesn't fit resource of
> +	 * child device under that bridge
> +	 */
> +	for (list = head.next; list;) {
> +		bus = list->dev->bus;
> +		/* don't need to play with root bus */
> +		if (!pci_is_root_bus(bus))
> +			pci_bus_release_unused_bridge_res(bus,
> +					 list->res->flags & type_mask);
> +		tmp = list;
> +		list = list->next;
> +		kfree(tmp);
> +	}
> +
> +	goto again;
> +
> +enable_and_dump:
> +	/* Depth last, update the hardware. */
> +	list_for_each_entry(bus, &pci_root_buses, node) {
>  		pci_enable_bridges(bus);
>  	}
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


