Return-Path: <linux-kernel-owner+w=401wt.eu-S1755899Ab0ASV0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899Ab0ASV0O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 16:26:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755813Ab0ASV0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 16:26:13 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:1564 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755798Ab0ASV0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 16:26:12 -0500
Date: Tue, 19 Jan 2010 14:26:08 -0700
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
Message-ID: <20100119212608.GF11010@ldl.fc.hp.com>
References: <1263640037-24134-1-git-send-email-yinghai@kernel.org> <1263640037-24134-2-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263640037-24134-2-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

I still don't understand this loop. Can't you write it like this:

	list_for_each_entry(dev, &bus->devices, bus_list) {
		struct pci_bus *b = dev->subordinate;
		if (!b)
			continue;

		is_leaf_bridge = false;

		if ((dev->class >> 8) == PCI_CLASS_BRIDGE_CARDBUS)
			continue;

		if (rel_type == whole_subtree)
			pci_bus_release_bridge_resources(b, type,
						whole_subtree);
	}

I'm looking at that 'default' label in your switch() statement
which causes us to always set is_leaf_bridge = false after 'b' is
valid.

/ac
