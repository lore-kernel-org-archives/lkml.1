Return-Path: <linux-kernel-owner+w=401wt.eu-S1753561AbZK3Vmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561AbZK3Vmm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 16:42:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753426AbZK3Vml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 16:42:41 -0500
Received: from complete.lackof.org ([198.49.126.79]:54509 "EHLO
	complete.lackof.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365AbZK3Vmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 16:42:40 -0500
Date: Mon, 30 Nov 2009 14:42:43 -0700
From: Grant Grundler <grundler@parisc-linux.org>
To: Alex Williamson <alex.williamson@hp.com>
Cc: jbarnes@virtuousgeek.org, yinghai@kernel.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: Always set prefetchable base/limit upper32
	registers
Message-ID: <20091130214243.GA24539@lackof.org>
References: <20091130212228.7555.43533.stgit@debian.lart>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091130212228.7555.43533.stgit@debian.lart>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 30, 2009 at 02:22:53PM -0700, Alex Williamson wrote:
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
> write the upper32 registers.
> 
> Signed-off-by: Alex Williamson <alex.williamson@hp.com>
> ---
> 
>  drivers/pci/setup-bus.c |    8 +++-----
>  1 files changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
> index cb1a027..127d759 100644
> --- a/drivers/pci/setup-bus.c
> +++ b/drivers/pci/setup-bus.c
> @@ -221,11 +221,9 @@ static void pci_setup_bridge(struct pci_bus *bus)
>  	}
>  	pci_write_config_dword(bridge, PCI_PREF_MEMORY_BASE, l);
>  
> -	if (pref_mem64) {
> -		/* Set the upper 32 bits of PREF base & limit. */
> -		pci_write_config_dword(bridge, PCI_PREF_BASE_UPPER32, bu);
> -		pci_write_config_dword(bridge, PCI_PREF_LIMIT_UPPER32, lu);
> -	}

Why not remove all references to pref_mem64?
This was the only use AFAICT.

thanks,
grant

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
