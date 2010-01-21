Return-Path: <linux-kernel-owner+w=401wt.eu-S1754932Ab0AUSTN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932Ab0AUSTN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 13:19:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752436Ab0AUSTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 13:19:08 -0500
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:15364 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754903Ab0AUSTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 13:19:03 -0500
Date: Thu, 21 Jan 2010 11:18:59 -0700
From: Alex Chiang <achiang@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH 1/9] pci: add pci_bridge_release_unused_res and
	pci_bus_release_unused_bridge_res
Message-ID: <20100121181859.GC17684@ldl.fc.hp.com>
References: <1264054456-12694-1-git-send-email-yinghai@kernel.org> <1264054456-12694-2-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264054456-12694-2-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  
Sorry, this is getting into bike-shed territory.

I'm a lot happier with the code now, so may as well fix up a few
style issues before it goes in.

> +static void pci_bridge_release_resources(struct pci_bus *bus,
> +					  unsigned long type)
> +{

[...]

> +	if (changed) {
> +		if (type & IORESOURCE_PREFETCH) {
> +			/* avoiding touch the one without PREF */
> +			type = IORESOURCE_PREFETCH;
> +		}

Strictly speaking, you don't need those curly braces. If you want
readability, how about moving the comment up?

		/* Only setup prefetch resources */
		if (type & IORESOURCE_PREFETCH)
			type = IORESOURCE_PREFETCH;


> +		__pci_setup_bridge(bus, type);
> +	}
> +}
> +
> +static void __ref pci_bus_release_bridge_resources(struct pci_bus *bus,
> +						   unsigned long type,
> +						   enum release_type rel_type)
> +{

[...]

> +
> +	/* The root bus? */

Useless comment.

> +	if (pci_is_root_bus(bus))
> +		return;
> +
> +	if ((bus->self->class >> 8) != PCI_CLASS_BRIDGE_PCI)
> +		return;
> +
> +	if (((rel_type == leaf_only) && is_leaf_bridge) ||
> +		    (rel_type == whole_subtree))
> +		pci_bridge_release_resources(bus, type);
> +}

Can clean this up a bit too with short-circuit logic.

	if ((rel_type == whole_subtree) || is_leaf_bridge)
		pci_bridge_release_resources(bus, type);

If you clean those up, you can add my:

Reviewed-by: Alex Chiang <achiang@hp.com>

> +
>  static void pci_bus_dump_res(struct pci_bus *bus)
>  {
>          int i;
> -- 
> 1.6.4.2
> 
