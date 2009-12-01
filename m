Return-Path: <linux-kernel-owner+w=401wt.eu-S1754116AbZLAADa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbZLAADa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 19:03:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754066AbZLAAD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 19:03:29 -0500
Received: from complete.lackof.org ([198.49.126.79]:38144 "EHLO
	complete.lackof.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933AbZLAAD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 19:03:28 -0500
Date: Mon, 30 Nov 2009 17:03:32 -0700
From: Grant Grundler <grundler@parisc-linux.org>
To: Alex Williamson <alex.williamson@hp.com>
Cc: jbarnes@virtuousgeek.org, yinghai@kernel.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] PCI: Always set prefetchable base/limit upper32
	registers
Message-ID: <20091201000332.GD24539@lackof.org>
References: <20091130214954.10845.23072.stgit@debian.lart>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091130214954.10845.23072.stgit@debian.lart>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 30, 2009 at 02:51:44PM -0700, Alex Williamson wrote:
> Prior to 1f82de10 we always initialized the upper 32bits of the
> prefetchable memory window, regardless of the address range used.
> Now we only touch it for a >32bit address, which means the upper32
> registers remain whatever the BIOS initialized them too.
> 
> It's valid for the BIOS to set the upper32 base/limit to
> 0xffffffff/0x00000000, which makes us program prefetchable ranges
> like 0xffffffffabc00000 - 0x00000000abc00000
> 
> Revert the chunk of 1f82de10 that made this conditional so we always
> write the upper32 registers and remove now unused pref_mem64 variable.
> 
> Signed-off-by: Alex Williamson <alex.williamson@hp.com>

Reviewed-by: Grant Grundler <grundler@parisc-linux.org>

thanks,
grant

> ---
> 
> v2:
>   Remove pref_mem64 as it's now unused.
> 
>  drivers/pci/setup-bus.c |   11 +++--------
>  1 files changed, 3 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
> index cb1a027..dd58c6a 100644
> --- a/drivers/pci/setup-bus.c
> +++ b/drivers/pci/setup-bus.c
> @@ -142,7 +142,6 @@ static void pci_setup_bridge(struct pci_bus *bus)
>  	struct pci_dev *bridge = bus->self;
>  	struct pci_bus_region region;
>  	u32 l, bu, lu, io_upper16;
> -	int pref_mem64;
>  
>  	if (pci_is_enabled(bridge))
>  		return;
> @@ -198,7 +197,6 @@ static void pci_setup_bridge(struct pci_bus *bus)
>  	pci_write_config_dword(bridge, PCI_PREF_LIMIT_UPPER32, 0);
>  
>  	/* Set up PREF base/limit. */
> -	pref_mem64 = 0;
>  	bu = lu = 0;
>  	pcibios_resource_to_bus(bridge, &region, bus->resource[2]);
>  	if (bus->resource[2]->flags & IORESOURCE_PREFETCH) {
> @@ -206,7 +204,6 @@ static void pci_setup_bridge(struct pci_bus *bus)
>  		l = (region.start >> 16) & 0xfff0;
>  		l |= region.end & 0xfff00000;
>  		if (bus->resource[2]->flags & IORESOURCE_MEM_64) {
> -			pref_mem64 = 1;
>  			bu = upper_32_bits(region.start);
>  			lu = upper_32_bits(region.end);
>  			width = 16;
> @@ -221,11 +218,9 @@ static void pci_setup_bridge(struct pci_bus *bus)
>  	}
>  	pci_write_config_dword(bridge, PCI_PREF_MEMORY_BASE, l);
>  
> -	if (pref_mem64) {
> -		/* Set the upper 32 bits of PREF base & limit. */
> -		pci_write_config_dword(bridge, PCI_PREF_BASE_UPPER32, bu);
> -		pci_write_config_dword(bridge, PCI_PREF_LIMIT_UPPER32, lu);
> -	}
> +	/* Set the upper 32 bits of PREF base & limit. */
> +	pci_write_config_dword(bridge, PCI_PREF_BASE_UPPER32, bu);
> +	pci_write_config_dword(bridge, PCI_PREF_LIMIT_UPPER32, lu);
>  
>  	pci_write_config_word(bridge, PCI_BRIDGE_CONTROL, bus->bridge_ctl);
>  }
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
