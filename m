Return-Path: <linux-kernel-owner+w=401wt.eu-S1757405AbXHZEZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405AbXHZEZ0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 00:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750857AbXHZEZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 00:25:18 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:3065 "EHLO
	pd3mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbXHZEZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 00:25:16 -0400
Date: Sat, 25 Aug 2007 22:24:57 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] Fix boot-time hang on G31/G33 PC
In-reply-to: <20070826015556.GC14130@parisc-linux.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       Jesse Barnes <jesse.barnes@intel.com>, Greg KH <greg@kroah.com>
Message-id: <46D10099.40401@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <20070826015556.GC14130@parisc-linux.org>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> This patch, loosely based on a patch from Robert Hancock, which was in
> turn based on a patch from Jesse Barnes, fixes a boot-time hang on my
> shiny new PC.  The 'conflict' mentioned in the patch in my case happens
> to be between mmconfig and the graphics card, but it could easily be
> between any pair of devices if they are left enabled by the BIOS and
> mappen in the wrong place.
> 
> Signed-off-by: Matthew Wilcox <matthew@wil.cx>
> 

We've already got a patch for this in Greg's PCI tree, hopefully it 
should go in for 2.6.24.

Are you getting MMCONFIG enabled on your system with 2.6.23? If not this 
problem shouldn't matter. In the cases I've seen that have caused 
problems in the past (Intel boards mainly), where the MMCONFIG area 
overlaps with where the graphics card BAR ends up during BAR sizing, the 
BIOS happened to not reserve the MMCONFIG table in the E820 memory map, 
so current mainline will turn off MMCONFIG. However, it's quite possible 
that some systems will pass the old E820 validation check and turn on 
MMCONFIG where the overlap happens..

There's a patch in Andi's tree (also hopefully for 2.6.24) to loosen the 
MMCONFIG validation to check against ACPI reservations instead of the 
E820 map (which isn't required to have a reservation for MMCONFIG). This 
makes the disable-decode change more critical.

> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index 34b8dae..51ef450 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -180,11 +180,26 @@ static inline int is_64bit_memory(u32 mask)
>  	return 0;
>  }
>  
> +/*
> + * Sizing PCI BARs requires us to disable decoding, otherwise we may run
> + * into conflicts with other devices while trying to size the BAR.  Normally
> + * this isn't a problem, but it happens on some machines normally, and can
> + * happen on others during PCI device hotplug.  Don't disable BARs for host
> + * bridges, though.  Some of them do silly things like disable accesses to
> + * RAM from the CPU
> + */
>  static void pci_read_bases(struct pci_dev *dev, unsigned int howmany, int rom)
>  {
>  	unsigned int pos, reg, next;
>  	u32 l, sz;
>  	struct resource *res;
> +	u16 orig_cmd;
> +
> +	if ((dev->class >> 8) != PCI_CLASS_BRIDGE_HOST) {
> +		pci_read_config_word(dev, PCI_COMMAND, &orig_cmd);
> +		pci_write_config_word(dev, PCI_COMMAND,
> +			orig_cmd & ~(PCI_COMMAND_MEMORY | PCI_COMMAND_IO));
> +	}
>  
>  	for(pos=0; pos<howmany; pos = next) {
>  		u64 l64;
> @@ -283,6 +298,9 @@ static void pci_read_bases(struct pci_dev *dev, unsigned int howmany, int rom)
>  			}
>  		}
>  	}
> +
> +	if ((dev->class >> 8) != PCI_CLASS_BRIDGE_HOST)
> +		pci_write_config_word(dev, PCI_COMMAND, orig_cmd);
>  }
>  
>  void __devinit pci_read_bridge_bases(struct pci_bus *child)
> 
