Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758953Ab0APD5z (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 22:57:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758883Ab0APD5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 22:57:54 -0500
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:6547 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758122Ab0APD5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 22:57:53 -0500
Date: Fri, 15 Jan 2010 20:57:50 -0700
From: Alex Chiang <achiang@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 01/11] pci: add pci_bridge_release_unused_res and
	pci_bus_release_unused_bridge_res
Message-ID: <20100116035750.GB22215@ldl.fc.hp.com>
References: <1263609721-3921-1-git-send-email-yinghai@kernel.org> <1263609721-3921-2-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263609721-3921-2-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yinghai,

First, thank you very much for writing the summary in patch 0/11.
I feel like I finally understand what you are trying to do with
this series.

> +/*
> + * try to release pci bridge resources that is from leaf bridge,
> + * so we can allocate big new one later
> + */
> +static void __ref pci_bus_release_bridge_resources(struct pci_bus *bus,
> +						   unsigned long type,
> +						   enum release_type rel_type)
> +{
> +	struct pci_dev *dev;
> +	bool is_leaf_bridge = true;
> +
> +	list_for_each_entry(dev, &bus->devices, bus_list) {
> +		struct pci_bus *b = dev->subordinate;
> +		if (!b)
> +			continue;
> +

How about settting

		is_leaf_bridge = false;

here, and then you don't need the repeated assignments below?

> +		switch (dev->class >> 8) {
> +		case PCI_CLASS_BRIDGE_CARDBUS:
> +			is_leaf_bridge = false;
> +			break;
> +
> +		case PCI_CLASS_BRIDGE_PCI:
> +		default:
> +			is_leaf_bridge = false;
> +			if (rel_type == whole_subtree)
> +				pci_bus_release_bridge_resources(b, type,
> +							 whole_subtree);
> +			break;
> +		}
> +	}
> +
> +	/* The root bus? */
> +	if (!bus->self)
> +		return;

Won't work correctly on a non-materialized root bridge.

Use pci_is_root_bus() instead.

Thanks,
/ac
