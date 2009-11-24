Return-Path: <linux-kernel-owner+w=401wt.eu-S1757548AbZKXBJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548AbZKXBJR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 20:09:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757401AbZKXBJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 20:09:16 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:51513 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690AbZKXBJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 20:09:14 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4B0B321E.4010103@jp.fujitsu.com>
Date: Tue, 24 Nov 2009 10:08:46 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: Re: [PATCH 1/2] pci: release that leaf bridge' resource that is not
 big -v11
References: <4ADEB601.8020200@kernel.org>	<4AE52B68.3070501@jp.fujitsu.com>	<4AE53883.3070709@kernel.org>	<4AE5545E.1020900@jp.fujitsu.com>	<4AE55D12.30403@kernel.org>	<4AE57976.4060107@jp.fujitsu.com>	<4AE5E37F.8070707@kernel.org>	<4AE5EFDB.2060908@kernel.org>	<4AE80170.6030402@jp.fujitsu.com>	<4AE88305.8020207@kernel.org>	<m1ljivibrt.fsf@fess.ebiederm.org>	<4AE899A0.3020006@kernel.org>	<4AE95247.8080401@jp.fujitsu.com>	<4AE952B9.1010603@kernel.org>	<4AE9588E.90708@jp.fujitsu.com>	<4AE9657F.7010302@kernel.org>	<4AE965D9.9040702@kernel.org> <20091104093044.17ab628a@jbarnes-piketon> <4AF1CD79.4010602@kernel.org> <4AF22CF1.1020508@kernel.org> <4AF22D26.4070500@kernel.org> <4AF508F0.9060105@kernel.org> <4AF91F54.10507@jp.fujitsu.com> <4AF936DB.1030309@kernel.org> <4AFCF7D8.1090207@jp.fujitsu.com> <4AFCFC0D.4030002@kernel.org> <4AFD19DA.7010602@jp.fujitsu.com> <4AFE6F39.5080505@kernel.org>
In-Reply-To: <4AFE6F39.5080505@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I tried v11 patches. This version seems to fix the problem I
reported against previous version.

I have no objection against the idea of resource allocation
changes for PCI express hotplug slots.

But I still have concern about changing resource allocation for
other than PCI express hotplug slots. For example, some hotplug
controller other than PCI express can have multiple slots under
the same bus. If some hotplug slots are occupied and the others
are empty at the boot time, I think your code try to shrink the
bus resources for hotplug slots allocated by BIOS. It would break
the hot-add on the empty slots due to the resource allocation
failure.

Thanks,
Kenji Kaneshige



Yinghai Lu wrote:
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
> v8: address Eric's concern, only overwrite leaf bridge resource that is not big
>     enough need to do it in two steps, and first step recore the failed res,
>     and don't touch bridge res that programmed by firmware. second step will
>     try to release bridge resource that is too small at first.
> v9: refresh to be applied after bjorn's patch, and remove trick about save
>     size and restore resource second try.
> v11:add pci=try=5, about more try to change more bridge
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  drivers/pci/pci.c       |    5 
>  drivers/pci/pci.h       |    2 
>  drivers/pci/setup-bus.c |  304 +++++++++++++++++++++++++++++++++++++++++++++---
>  3 files changed, 292 insertions(+), 19 deletions(-)
> 
> Index: linux-2.6/drivers/pci/setup-bus.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/setup-bus.c
> +++ linux-2.6/drivers/pci/setup-bus.c
> @@ -27,7 +27,49 @@
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
> @@ -58,9 +100,17 @@ static void pbus_assign_resources_sorted
>  		res = list->res;
>  		idx = res - &list->dev->resource[0];
>  		if (pci_assign_resource(list->dev, idx)) {
> -			res->start = 0;
> -			res->end = 0;
> -			res->flags = 0;
> +			if (fail_head && !pci_is_root_bus(list->dev->bus)) {
> +				/*
> +				 * device need to keep flags and size
> +				 * for next try
> +				 */
> +				add_to_failed_list(fail_head, list->dev, res);
> +			} else {
> +				res->start = 0;
> +				res->end = 0;
> +				res->flags = 0;
> +			}
>  		}
>  		tmp = list;
>  		list = list->next;
> @@ -134,19 +184,12 @@ EXPORT_SYMBOL(pci_setup_cardbus);
>     config space writes, so it's quite possible that an I/O window of
>     the bridge will have some undesirable address (e.g. 0) after the
>     first write. Ditto 64-bit prefetchable MMIO.  */
> -static void pci_setup_bridge(struct pci_bus *bus)
> +static void pci_setup_bridge_io(struct pci_bus *bus)
>  {
>  	struct pci_dev *bridge = bus->self;
>  	struct resource *res;
>  	struct pci_bus_region region;
> -	u32 l, bu, lu, io_upper16;
> -	int pref_mem64;
> -
> -	if (pci_is_enabled(bridge))
> -		return;
> -
> -	dev_info(&bridge->dev, "PCI bridge to [bus %02x-%02x]\n",
> -		 bus->secondary, bus->subordinate);
> +	u32 l, io_upper16;
>  
>  	/* Set up the top and bottom of the PCI I/O segment for this bus. */
>  	res = bus->resource[0];
> @@ -172,7 +215,13 @@ static void pci_setup_bridge(struct pci_
>  	pci_write_config_dword(bridge, PCI_IO_BASE, l);
>  	/* Update upper 16 bits of I/O base/limit. */
>  	pci_write_config_dword(bridge, PCI_IO_BASE_UPPER16, io_upper16);
> -
> +}
> +static void pci_setup_bridge_mmio(struct pci_bus *bus)
> +{
> +	struct pci_dev *bridge = bus->self;
> +	struct resource *res;
> +	struct pci_bus_region region;
> +	u32 l;
>  	/* Set up the top and bottom of the PCI Memory segment
>  	   for this bus. */
>  	res = bus->resource[1];
> @@ -187,6 +236,14 @@ static void pci_setup_bridge(struct pci_
>  		dev_info(&bridge->dev, "  bridge window [mem disabled]\n");
>  	}
>  	pci_write_config_dword(bridge, PCI_MEMORY_BASE, l);
> +}
> +static void pci_setup_bridge_mmio_pref(struct pci_bus *bus)
> +{
> +	struct pci_dev *bridge = bus->self;
> +	struct resource *res;
> +	struct pci_bus_region region;
> +	u32 l, bu, lu;
> +	int pref_mem64;
>  
>  	/* Clear out the upper 32 bits of PREF limit.
>  	   If PCI_PREF_BASE_UPPER32 was non-zero, this temporarily
> @@ -219,10 +276,37 @@ static void pci_setup_bridge(struct pci_
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
> +	dev_info(&bridge->dev, "PCI bridge to [bus %02x-%02x]\n",
> +		 bus->secondary, bus->subordinate);
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
> @@ -543,19 +627,20 @@ void __ref pci_bus_size_bridges(struct p
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
> @@ -573,15 +658,130 @@ void __ref pci_bus_assign_resources(cons
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
>  
>          for (i = 0; i < PCI_BUS_NUM_RESOURCES; i++) {
>                  struct resource *res = bus->resource[i];
> -                if (!res || !res->end)
> +
> +		if (!res || !res->end || !res->flags)
>                          continue;
>  
>  		dev_printk(KERN_DEBUG, &bus->dev, "resource %d %pR\n", i, res);
> @@ -605,10 +805,25 @@ static void pci_bus_dump_resources(struc
>  	}
>  }
>  
> +/*
> + * first try will not touch pci bridge res
> + * second try will clear small leaf bridge res
> + * third try will clear related bridge: some aggressive
> + */
> +/* assume we only have 4 level bridges, so only try 5 times */
> +int pci_try_num = 5;
>  void __init
>  pci_assign_unassigned_resources(void)
>  {
>  	struct pci_bus *bus;
> +	int tried_times = 0;
> +	int check_leaf = 1;
> +	struct resource_list head, *list, *tmp;
> +	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
> +				  IORESOURCE_PREFETCH;
> +	unsigned long failed_type;
> +again:
> +	head.next = NULL;
>  
>  	/* Depth first, calculate sizes and alignments of all
>  	   subordinate buses. */
> @@ -617,7 +832,58 @@ pci_assign_unassigned_resources(void)
>  	}
>  	/* Depth last, allocate resources and update the hardware. */
>  	list_for_each_entry(bus, &pci_root_buses, node) {
> -		pci_bus_assign_resources(bus);
> +		__pci_bus_assign_resources(bus, &head);
> +	}
> +	tried_times++;
> +
> +	/* any device complain? */
> +	if (!head.next)
> +		goto enable_and_dump;
> +	failed_type = 0;
> +	for (list = head.next; list;) {
> +		unsigned long flags = list->res->flags;
> +
> +		failed_type |= flags;
> +		list = list->next;
> +	}
> +	/*
> +	 * io port are tight, don't try extra
> +	 * or if reach the limit, don't want to try more
> +	 */
> +	failed_type &= type_mask;
> +	if ((failed_type == IORESOURCE_IO) || (tried_times >= pci_try_num)) {
> +		free_failed_list(&head);
> +		goto enable_and_dump;
> +	}
> +
> +	printk(KERN_DEBUG "PCI: No. %d try to assign unassigned res\n",
> +			 tried_times + 1);
> +
> +	/*
> +	 * Try to release leaf bridge's resources that doesn't fit resource of
> +	 * child device under that bridge
> +	 */
> +	/* third times and later will not check if it is leaf */
> +	if ((tried_times + 1) > 2)
> +		check_leaf = 0;
> +	for (list = head.next; list;) {
> +		unsigned long flags = list->res->flags;
> +
> +		bus = list->dev->bus;
> +		if (list->dev->subordinate)
> +			list->res->flags = 0;
> +		pci_bus_release_unused_bridge_res(bus, flags & type_mask,
> +						  check_leaf);
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
> Index: linux-2.6/drivers/pci/pci.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/pci.c
> +++ linux-2.6/drivers/pci/pci.c
> @@ -2779,6 +2779,11 @@ static int __init pci_setup(char *str)
>  				pci_no_aer();
>  			} else if (!strcmp(str, "nodomains")) {
>  				pci_no_domains();
> +			} else if (!strncmp(str, "try=", 4)) {
> +				int try_num = memparse(str + 4, &str);
> +
> +				if (try_num > 0 && try_num < 10)
> +					pci_try_num = try_num;
>  			} else if (!strncmp(str, "cbiosize=", 9)) {
>  				pci_cardbus_io_size = memparse(str + 9, &str);
>  			} else if (!strncmp(str, "cbmemsize=", 10)) {
> Index: linux-2.6/drivers/pci/pci.h
> ===================================================================
> --- linux-2.6.orig/drivers/pci/pci.h
> +++ linux-2.6/drivers/pci/pci.h
> @@ -203,6 +203,8 @@ static inline int pci_ari_enabled(struct
>  	return bus->self && bus->self->ari_enabled;
>  }
>  
> +extern int pci_try_num;
> +
>  #ifdef CONFIG_PCI_QUIRKS
>  extern int pci_is_reassigndev(struct pci_dev *dev);
>  resource_size_t pci_specified_resource_alignment(struct pci_dev *dev);
> 
> 


