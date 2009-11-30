Return-Path: <linux-kernel-owner+w=401wt.eu-S1753522AbZK3Vhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbZK3Vhf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 16:37:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753428AbZK3Vhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 16:37:34 -0500
Received: from hera.kernel.org ([140.211.167.34]:38163 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753217AbZK3Vhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 16:37:33 -0500
Message-ID: <4B143AE5.7040702@kernel.org>
Date: Mon, 30 Nov 2009 13:36:37 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@hp.com>
CC: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: Always set prefetchable base/limit upper32 registers
References: <20091130212228.7555.43533.stgit@debian.lart>
In-Reply-To: <20091130212228.7555.43533.stgit@debian.lart>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Williamson wrote:
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
> +	/* Set the upper 32 bits of PREF base & limit. */
> +	pci_write_config_dword(bridge, PCI_PREF_BASE_UPPER32, bu);
> +	pci_write_config_dword(bridge, PCI_PREF_LIMIT_UPPER32, lu);
>  
>  	pci_write_config_word(bridge, PCI_BRIDGE_CONTROL, bus->bridge_ctl);
>  }

when pref_mem64=0 it means that pref register is only 32 bit, we should not touch upper 32bits.

YH
