Return-Path: <linux-kernel-owner+w=401wt.eu-S1754196Ab0ASV5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab0ASV5T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 16:57:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753822Ab0ASV5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 16:57:18 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:4629 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653Ab0ASV5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 16:57:17 -0500
Date: Tue, 19 Jan 2010 14:57:14 -0700
From: Alex Chiang <achiang@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH 09/11] pci: pci_bridge_release_res
Message-ID: <20100119215714.GI11010@ldl.fc.hp.com>
References: <1263640037-24134-1-git-send-email-yinghai@kernel.org> <1263640037-24134-10-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263640037-24134-10-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> --- a/drivers/pci/setup-bus.c
> +++ b/drivers/pci/setup-bus.c
> @@ -731,32 +732,57 @@ static void pci_bridge_release_resources(struct pci_bus *bus,
>  	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
>  				  IORESOURCE_PREFETCH;
>  
> +	/* The root bus? */
> +	if (!bus->self)
> +		return;
> +

pci_is_root_bus()

> +/*
> + * pci_bridge_release_res will not release the resource that have children
> + *  and apply all resources type under that devices
> + */
> +void pci_bridge_release_res(struct pci_bus *bus)
> +{
> +	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
> +				  IORESOURCE_PREFETCH;
> +
> +	__pci_bridge_release_res(bus, false, type_mask);
> +}
> +EXPORT_SYMBOL_GPL(pci_bridge_release_res);
> +
> +/*
> + * this one will release children resource, but only to specifed resource type
> + * and also will keep old resource size
> + */
> +static void pci_bridge_release_resources(struct pci_bus *bus,
> +					  unsigned long type)
> +{
> +	__pci_bridge_release_res(bus, true, type);
> +}
> +

I still don't really like the naming here. We're exporting a
function with an abbreviation in the name while the static
function has a name that is more descriptive.

/ac
