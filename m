Return-Path: <linux-kernel-owner+w=401wt.eu-S1755309Ab0AUVWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309Ab0AUVWw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 16:22:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754907Ab0AUVWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 16:22:50 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:46774 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780Ab0AUVWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 16:22:49 -0500
Date: Thu, 21 Jan 2010 14:22:47 -0700
From: Alex Chiang <achiang@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH 8/9] pci: pciehp second try to get big range for pcie
	devices
Message-ID: <20100121212247.GH17684@ldl.fc.hp.com>
References: <1264054456-12694-1-git-send-email-yinghai@kernel.org> <1264054456-12694-9-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264054456-12694-9-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  void pci_assign_unassigned_bridge_resources(struct pci_dev *bridge)
>  {
>  	struct pci_bus *parent = bridge->subordinate;
> +	int tried_times = 0;
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
> +	tried_times++;
> +
> +	/* any device complain? */

useless comment.

> +	if (!head.next)
> +		return;
> +
> +	if (tried_times  >= 2) {

stray space

> +		/* still fail, don't need to try more */

useless comment

> +		free_failed_list(&head);
> +		return;
> +	}
> +
> +	printk(KERN_DEBUG "PCI: No. %d try to assign unassigned res\n",
> +			 tried_times + 1);
> +
> +	/*
> +	 * Try to release leaf bridge's resources that doesn't fit resource of
> +	 * child device under that bridge
> +	 */
> +	for (list = head.next; list;) {
> +		struct pci_bus *bus = list->dev->bus;
> +		unsigned long flags = list->flags;
> +
> +		pci_bus_release_bridge_resources(bus, flags & type_mask,
> +						 whole_subtree);
> +		list = list->next;
> +	}
> +	/* retore size and flags */

"restore"

/ac

