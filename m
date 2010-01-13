Return-Path: <linux-kernel-owner+w=401wt.eu-S1753462Ab0AMAvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab0AMAvG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 19:51:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753055Ab0AMAvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 19:51:05 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55604 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab0AMAvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 19:51:01 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4B4D18D9.1030609@jp.fujitsu.com>
Date: Wed, 13 Jan 2010 09:50:33 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 09/14] pci: introduce pci_assign_unassigned_bridge_resources
References: <1261522954-12591-1-git-send-email-yinghai@kernel.org> <1261522954-12591-10-git-send-email-yinghai@kernel.org>
In-Reply-To: <1261522954-12591-10-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> for pciehp to use it later
> 
> pci_setup_bridge() will not check enabled for the slot bridge, otherwise
> update res is not updated to bridge BAR. that is bridge is enabled already for
> port service.
> 
> -v2: update it with resource_list_x
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  drivers/pci/setup-bus.c |   93 +++++++++++++++++++++++++++++++++++++++++++++--
>  include/linux/pci.h     |    1 +
>  2 files changed, 90 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
> index 6b8491d..056b98d 100644
> --- a/drivers/pci/setup-bus.c
> +++ b/drivers/pci/setup-bus.c
> @@ -71,6 +71,50 @@ static void free_failed_list(struct resource_list_x *head)
>  	head->next = NULL;
>  }
>  
> +static void pdev_assign_resources_sorted(struct pci_dev *dev,
> +				 struct resource_list_x *fail_head)
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
> +			if (fail_head && !pci_is_root_bus(list->dev->bus)) {
> +				/*
> +				 * device need to keep flags and size
> +				 * for second try
> +				 */
> +				add_to_failed_list(fail_head, list->dev, res);
> +			}
> +			res->start = 0;
> +			res->end = 0;
> +			res->flags = 0;
> +		}
> +		tmp = list;
> +		list = list->next;
> +		kfree(tmp);
> +	}
> +}
>  static void pbus_assign_resources_sorted(const struct pci_bus *bus,
>  					 struct resource_list_x *fail_head)
>  {
> @@ -278,9 +322,6 @@ static void __pci_setup_bridge(struct pci_bus *bus, unsigned long type)
>  {
>  	struct pci_dev *bridge = bus->self;
>  
> -	if (pci_is_enabled(bridge))
> -		return;
> -
>  	dev_info(&bridge->dev, "PCI bridge to [bus %02x-%02x]\n",
>  		 bus->secondary, bus->subordinate);
>  
> @@ -651,7 +692,8 @@ static void __ref __pci_bus_assign_resources(const struct pci_bus *bus,
>  
>  		switch (dev->class >> 8) {
>  		case PCI_CLASS_BRIDGE_PCI:
> -			pci_setup_bridge(b);
> +			if (!pci_is_enabled(dev))
> +				pci_setup_bridge(b);
>  			break;
>  
>  		case PCI_CLASS_BRIDGE_CARDBUS:
> @@ -672,6 +714,34 @@ void __ref pci_bus_assign_resources(const struct pci_bus *bus)
>  }
>  EXPORT_SYMBOL(pci_bus_assign_resources);
>  
> +static void __ref __pci_bridge_assign_resources(const struct pci_dev *bridge,
> +					 struct resource_list_x *fail_head)
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
>  static void pci_bridge_release_unused_res(struct pci_bus *bus,
>  					  unsigned long type)
>  {
> @@ -932,3 +1002,18 @@ enable_and_dump:
>  		pci_bus_dump_resources(bus);
>  	}
>  }
> +
> +void pci_assign_unassigned_bridge_resources(struct pci_dev *bridge)
> +{
> +	struct pci_bus *bus;
> +	struct pci_bus *parent = bridge->subordinate;
> +	int retval;
> +
> +	pci_bus_size_bridges(parent);
> +	pci_clear_master(bridge);

I have a concern about clearing bus master enable bit here, though
I'm not sure about it. I'm wondering if clearing bus master enable
bit might have some bad effect for the port services to work. For
example, does MSI interrupt work without enabling bus mastering?

Thanks,
Kenji Kaneshige


> +	__pci_bridge_assign_resources(bridge, NULL);
> +	retval = pci_reenable_device(bridge);
> +	pci_set_master(bridge);
> +	pci_enable_bridges(parent);
> +}
> +EXPORT_SYMBOL_GPL(pci_assign_unassigned_bridge_resources);
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 5da0690..31fec6f 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -771,6 +771,7 @@ void pci_bus_assign_resources(const struct pci_bus *bus);
>  void pci_bus_size_bridges(struct pci_bus *bus);
>  int pci_claim_resource(struct pci_dev *, int);
>  void pci_assign_unassigned_resources(void);
> +void pci_assign_unassigned_bridge_resources(struct pci_dev *bridge);
>  void pdev_enable_device(struct pci_dev *);
>  void pdev_sort_resources(struct pci_dev *, struct resource_list *);
>  int pci_enable_resources(struct pci_dev *, int mask);


