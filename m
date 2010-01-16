Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758939Ab0APEwX (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 23:52:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973Ab0APEwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 23:52:22 -0500
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:32373 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169Ab0APEwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 23:52:22 -0500
Date: Fri, 15 Jan 2010 21:52:20 -0700
From: Alex Chiang <achiang@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 08/11] pci: pciehp second try to get big range for pcie
	devices
Message-ID: <20100116045220.GG22215@ldl.fc.hp.com>
References: <1263609721-3921-1-git-send-email-yinghai@kernel.org> <1263609721-3921-9-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263609721-3921-9-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Code looks ok, just need to fix up some of the explanations.

> handle the case the slot bridge that doesn't get pre-allocated big enough res
> from FW.

Please change "res" to "resource" for changelog posterity.

> @@ -1009,12 +1009,60 @@ void pci_assign_unassigned_bridge_resources(struct pci_dev *bridge)
>  {
>  	struct pci_bus *bus;
>  	struct pci_bus *parent = bridge->subordinate;
> +	bool second_tried = false;

second_try ?

> +	struct resource_list_x head, *list;
>  	int retval;
> +	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
> +				  IORESOURCE_PREFETCH;
> +
> +	head.next = NULL;
>  
> +again:
>  	pci_bus_size_bridges(parent);
> -	__pci_bridge_assign_resources(bridge, NULL);
> +	__pci_bridge_assign_resources(bridge, &head);
>  	retval = pci_reenable_device(bridge);
>  	pci_set_master(bridge);
>  	pci_enable_bridges(parent);
> +
> +	/* any device complain? */
> +	if (!head.next)
> +		return;
> +
> +	if (second_tried) {
> +		/* still fail, don't need to try more */
> +		free_failed_list(&head);
> +		return;
> +	}
> +
> +	second_tried = true;
> +	printk(KERN_DEBUG "PCI: second try to assign unassigned res\n");

res -> resource

> +	/*
> +	 * Try to release leaf bridge's resources that doesn't fit resource of
> +	 * child device under that bridge
> +	 */
> +	for (list = head.next; list;) {
> +		unsigned long flags = list->flags;
> +
> +		bus = list->dev->bus;
> +		pci_bus_release_bridge_resources(bus, flags & type_mask,
> +						 whole_subtree);
> +		list = list->next;
> +	}
> +	/* retore size and flags */

retore -> restore

/ac

