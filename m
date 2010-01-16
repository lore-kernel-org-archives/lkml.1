Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758859Ab0APEri (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 23:47:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280Ab0APErh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 23:47:37 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:42694 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973Ab0APErf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 23:47:35 -0500
Date: Fri, 15 Jan 2010 21:47:33 -0700
From: Alex Chiang <achiang@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 06/11] pci: introduce
	pci_assign_unassigned_bridge_resources
Message-ID: <20100116044733.GF22215@ldl.fc.hp.com>
References: <1263609721-3921-1-git-send-email-yinghai@kernel.org> <1263609721-3921-7-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263609721-3921-7-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

This is extremely similar to pbus_assign_resources_sorted(). Any
chance you could factor out the commonalities and reduce the
amount of duplicated code?

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

I think this should probably be a dev_dbg.

thanks,
/ac
