Return-Path: <linux-kernel-owner+w=401wt.eu-S1752144AbZKJIIN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144AbZKJIIN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 03:08:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752073AbZKJIIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 03:08:12 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55139 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbZKJIIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 03:08:11 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4AF91F54.10507@jp.fujitsu.com>
Date: Tue, 10 Nov 2009 17:07:48 +0900
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
Subject: Re: [PATCH 2/2] pci: pciehp update the slot bridge res to get big
 range for pcie devices - v10
References: <4ADEB601.8020200@kernel.org>	<4AE52B68.3070501@jp.fujitsu.com>	<4AE53883.3070709@kernel.org>	<4AE5545E.1020900@jp.fujitsu.com>	<4AE55D12.30403@kernel.org>	<4AE57976.4060107@jp.fujitsu.com>	<4AE5E37F.8070707@kernel.org>	<4AE5EFDB.2060908@kernel.org>	<4AE80170.6030402@jp.fujitsu.com>	<4AE88305.8020207@kernel.org>	<m1ljivibrt.fsf@fess.ebiederm.org>	<4AE899A0.3020006@kernel.org>	<4AE95247.8080401@jp.fujitsu.com>	<4AE952B9.1010603@kernel.org>	<4AE9588E.90708@jp.fujitsu.com>	<4AE9657F.7010302@kernel.org>	<4AE965D9.9040702@kernel.org> <20091104093044.17ab628a@jbarnes-piketon> <4AF1CD79.4010602@kernel.org> <4AF22CF1.1020508@kernel.org> <4AF22D26.4070500@kernel.org> <4AF508F0.9060105@kernel.org>
In-Reply-To: <4AF508F0.9060105@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can I ask which is the latest version?

I think -v10 is the latest. But I could not find -v10 for patch 1/2.

Thanks,
Kenji Kaneshige


Yinghai Lu wrote:
> move out bus_size_bridges and assign resources out of pciehp_add_bridge()
> and at last do them all together one time including slot bridge, to avoid to
> call assign resources several times, when there are several bridges under the
> slot bridge.
> 
> need to introduce pci_bridge_assign_resources there.
> 
> handle the case the slot bridge that doesn't get pre-allocated big enough res
> from FW.
> for example pcie devices need 256M, but the bridge only get preallocated 2M...
> 
> pci_setup_bridge() will take extra check_enabled for the slot bridge, otherwise
> update res is not updated to bridge BAR. that is bridge is enabled already for
> port service.
> 
> v2: address Alex's concern about pci remove/rescan feature about
>     pci_setup_bridge changes.
> v3: Kenji pointed out that pci_config_slot need to be called before
>     pci_bus_add_devices()
> v4: move out pci_is_enabled checkout of pci_setup_bridge()
> v5: change the applying sequence.
> v6: change the functions name according to Jesse
> v8: address Eric's concern, only overwrite leaf bridge resource that is not
>      big enough
> v9: refresh to be applied after bjorn's patch, and remove trick about save
>     size and restore resource second try.
> v10: alex found need to have export for pci_assign_unassigned_bridge_resources
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  drivers/pci/hotplug/pciehp_pci.c |   23 +++++-
>  drivers/pci/setup-bus.c          |  130 +++++++++++++++++++++++++++++++++++++--
>  include/linux/pci.h              |    1 
>  3 files changed, 144 insertions(+), 10 deletions(-)
> 
> Index: linux-2.6/drivers/pci/hotplug/pciehp_pci.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/hotplug/pciehp_pci.c
> +++ linux-2.6/drivers/pci/hotplug/pciehp_pci.c
> @@ -53,17 +53,15 @@ static int __ref pciehp_add_bridge(struc
>  		busnr = pci_scan_bridge(parent, dev, busnr, pass);
>  	if (!dev->subordinate)
>  		return -1;
> -	pci_bus_size_bridges(dev->subordinate);
> -	pci_bus_assign_resources(parent);
> -	pci_enable_bridges(parent);
> -	pci_bus_add_devices(parent);
> +
>  	return 0;
>  }
>  
>  int pciehp_configure_device(struct slot *p_slot)
>  {
>  	struct pci_dev *dev;
> -	struct pci_bus *parent = p_slot->ctrl->pcie->port->subordinate;
> +	struct pci_dev *bridge = p_slot->ctrl->pcie->port;
> +	struct pci_bus *parent = bridge->subordinate;
>  	int num, fn;
>  	struct controller *ctrl = p_slot->ctrl;
>  
> @@ -96,12 +94,25 @@ int pciehp_configure_device(struct slot
>  				(dev->hdr_type == PCI_HEADER_TYPE_CARDBUS)) {
>  			pciehp_add_bridge(dev);
>  		}
> +		pci_dev_put(dev);
> +	}
> +
> +	pci_assign_unassigned_bridge_resources(bridge);
> +
> +	for (fn = 0; fn < 8; fn++) {
> +		dev = pci_get_slot(parent, PCI_DEVFN(0, fn));
> +		if (!dev)
> +			continue;
> +		if ((dev->class >> 16) == PCI_BASE_CLASS_DISPLAY) {
> +			pci_dev_put(dev);
> +			continue;
> +		}
>  		pci_configure_slot(dev);
>  		pci_dev_put(dev);
>  	}
>  
> -	pci_bus_assign_resources(parent);
>  	pci_bus_add_devices(parent);
> +
>  	return 0;
>  }
>  
> Index: linux-2.6/drivers/pci/setup-bus.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/setup-bus.c
> +++ linux-2.6/drivers/pci/setup-bus.c
> @@ -68,6 +68,52 @@ static void free_failed_list(struct reso
>  	head->next = NULL;
>  }
>  
> +static void pdev_assign_resources_sorted(struct pci_dev *dev,
> +				 struct resource_list *fail_head)
> +{
> +	struct resource *res;
> +	struct resource_list head, *list, *tmp;
> +	int idx;
> +	u16 class = dev->class >> 8;
> +
> +	head.next = NULL;
> +
> +	/* Don't touch classless devices or host bridges or ioapics.  */
> +	if (class == PCI_CLASS_NOT_DEFINED || class == PCI_CLASS_BRIDGE_HOST)
> +		return;
> +
> +	/* Don't touch ioapic devices already enabled by firmware */
> +	if (class == PCI_CLASS_SYSTEM_PIC) {
> +		u16 command;
> +		pci_read_config_word(dev, PCI_COMMAND, &command);
> +		if (command & (PCI_COMMAND_IO | PCI_COMMAND_MEMORY))
> +			return;
> +	}
> +
> +	pdev_sort_resources(dev, &head);
> +
> +	for (list = head.next; list;) {
> +		res = list->res;
> +		idx = res - &list->dev->resource[0];
> +		if (pci_assign_resource(list->dev, idx)) {
> +			if (fail_head && !list->dev->subordinate &&
> +			    !pci_is_root_bus(list->dev->bus)) {
> +				/*
> +				 * device need to keep flags and size
> +				 * for second try
> +				 */
> +				add_to_failed_list(fail_head, list->dev, res);
> +			} else {
> +				res->start = 0;
> +				res->end = 0;
> +				res->flags = 0;
> +			}
> +		}
> +		tmp = list;
> +		list = list->next;
> +		kfree(tmp);
> +	}
> +}
>  static void pbus_assign_resources_sorted(const struct pci_bus *bus,
>  					 struct resource_list *fail_head)
>  {
> @@ -282,9 +328,6 @@ static void __pci_setup_bridge(struct pc
>  {
>  	struct pci_dev *bridge = bus->self;
>  
> -	if (pci_is_enabled(bridge))
> -		return;
> -
>  	dev_info(&bridge->dev, "PCI bridge to [bus %02x-%02x]\n",
>  		 bus->secondary, bus->subordinate);
>  
> @@ -645,7 +688,8 @@ static void __ref __pci_bus_assign_resou
>  
>  		switch (dev->class >> 8) {
>  		case PCI_CLASS_BRIDGE_PCI:
> -			pci_setup_bridge(b);
> +			if (!pci_is_enabled(dev))
> +				pci_setup_bridge(b);
>  			break;
>  
>  		case PCI_CLASS_BRIDGE_CARDBUS:
> @@ -666,6 +710,34 @@ void __ref pci_bus_assign_resources(cons
>  }
>  EXPORT_SYMBOL(pci_bus_assign_resources);
>  
> +static void __ref __pci_bridge_assign_resources(const struct pci_dev *bridge,
> +					 struct resource_list *fail_head)
> +{
> +	struct pci_bus *b;
> +
> +	pdev_assign_resources_sorted((struct pci_dev *)bridge, fail_head);
> +
> +	b = bridge->subordinate;
> +	if (!b)
> +		return;
> +
> +	__pci_bus_assign_resources(b, fail_head);
> +
> +	switch (bridge->class >> 8) {
> +	case PCI_CLASS_BRIDGE_PCI:
> +		pci_setup_bridge(b);
> +		break;
> +
> +	case PCI_CLASS_BRIDGE_CARDBUS:
> +		pci_setup_cardbus(b);
> +		break;
> +
> +	default:
> +		dev_info(&bridge->dev, "not setting up bridge for bus "
> +			 "%04x:%02x\n", pci_domain_nr(b), b->number);
> +		break;
> +	}
> +}
>  static void release_children_resource(struct resource *r)
>  {
>  	struct resource *p;
> @@ -841,3 +913,53 @@ enable_and_dump:
>  		pci_bus_dump_resources(bus);
>  	}
>  }
> +
> +void pci_assign_unassigned_bridge_resources(struct pci_dev *bridge)
> +{
> +	struct pci_bus *bus;
> +	struct pci_bus *parent = bridge->subordinate;
> +	bool second_tried = false;
> +	struct resource_list head, *list, *tmp;
> +	int retval;
> +	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
> +				  IORESOURCE_PREFETCH;
> +
> +again:
> +	head.next = NULL;
> +
> +	pci_bus_size_bridges(parent);
> +	pci_clear_master(bridge);
> +	__pci_bridge_assign_resources(bridge, &head);
> +	retval = pci_reenable_device(bridge);
> +	pci_set_master(bridge);
> +	pci_enable_bridges(parent);
> +
> +	/* any device complain? */
> +	if (!head.next)
> +		return;
> +
> +	if (second_tried) {
> +		/* still fail, don't want to try more */
> +		free_failed_list(&head);
> +		return;
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
> +		pci_bus_release_unused_bridge_res(bus,
> +				 list->res->flags & type_mask);
> +		tmp = list;
> +		list = list->next;
> +		kfree(tmp);
> +	}
> +
> +	goto again;
> +}
> +EXPORT_SYMBOL_GPL(pci_assign_unassigned_bridge_resources);
> Index: linux-2.6/include/linux/pci.h
> ===================================================================
> --- linux-2.6.orig/include/linux/pci.h
> +++ linux-2.6/include/linux/pci.h
> @@ -768,6 +768,7 @@ void pci_bus_assign_resources(const stru
>  void pci_bus_size_bridges(struct pci_bus *bus);
>  int pci_claim_resource(struct pci_dev *, int);
>  void pci_assign_unassigned_resources(void);
> +void pci_assign_unassigned_bridge_resources(struct pci_dev *bridge);
>  void pdev_enable_device(struct pci_dev *);
>  void pdev_sort_resources(struct pci_dev *, struct resource_list *);
>  int pci_enable_resources(struct pci_dev *, int mask);
> 
> 


