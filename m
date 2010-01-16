Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759012Ab0APE6d (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 23:58:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751634Ab0APE6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 23:58:31 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:6359 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab0APE6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 23:58:30 -0500
Date: Fri, 15 Jan 2010 21:57:58 -0700
From: Alex Chiang <achiang@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 09/11] pci: pci_bridge_release_res
Message-ID: <20100116045758.GH22215@ldl.fc.hp.com>
References: <1263609721-3921-1-git-send-email-yinghai@kernel.org> <1263609721-3921-10-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263609721-3921-10-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +void pci_bridge_release_res(struct pci_bus *bus)
> +{
> +	int idx;
> +	bool changed = false;
> +	struct pci_dev *dev;
> +	struct resource *r;
> +
> +	/* The root bus? */
> +	if (!bus->self)
> +		return;
> +
> +	/* for pci bridges res only */
> +	dev = bus->self;
> +	if ((dev->class >> 8) != PCI_CLASS_BRIDGE_PCI)
> +		return;
> +
> +	for (idx = PCI_BRIDGE_RESOURCES; idx < PCI_BRIDGE_RESOURCES + 3;
> +	     idx++) {
> +		r = &dev->resource[idx];
> +		if (!r->parent)
> +			continue;
> +
> +		/* if there are children under that, we should not release it */
> +		if (r->child)
> +			continue;
> +
> +		if (!release_resource(r)) {
> +			dev_printk(KERN_DEBUG, &dev->dev,
> +				 "resource %d %pR released\n", idx, r);
> +			/* old size is not kept */
> +			r->start = 0;
> +			r->end   = 0;
> +			r->flags = 0;
> +			changed = true;
> +		}
> +	}
> +
> +	if (changed)
> +		pci_setup_bridge(bus);
> +}
> +EXPORT_SYMBOL_GPL(pci_bridge_release_res);
> +
>  static void pci_bridge_release_resources(struct pci_bus *bus,
>  					  unsigned long type)

My brain is melting.

Why do we have pci_bridge_release_res and pci_bridge_release_resources?

The code is similar, but not the same. The names are similar but
not the same.

Any chance you could factor similarities, and then write a
comment that explains the differences to a developer?

thanks,
/ac

