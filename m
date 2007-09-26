Return-Path: <linux-kernel-owner+w=401wt.eu-S1762740AbXIZVXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762740AbXIZVXn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 17:23:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756595AbXIZVXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 17:23:35 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48372 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbXIZVXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 17:23:35 -0400
Date: Wed, 26 Sep 2007 14:18:16 -0700
From: Greg KH <greg@kroah.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       Robert Hancock <hancockr@shaw.ca>,
       Jesse Barnes <jesse.barnes@intel.com>
Subject: Re: PCI: Fix boot-time hang on G31/G33 PC
Message-ID: <20070926211816.GA9916@kroah.com>
References: <20070826015556.GC14130@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070826015556.GC14130@parisc-linux.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Due to the issues surrounding this patch, I'm dropping it from my repo.

thanks,

greg k-h


On Sat, Aug 25, 2007 at 07:55:56PM -0600, Matthew Wilcox wrote:
> 
> 
> This patch, loosely based on a patch from Robert Hancock, which was in
> turn based on a patch from Jesse Barnes, fixes a boot-time hang on my
> shiny new PC.  The 'conflict' mentioned in the patch in my case happens
> to be between mmconfig and the graphics card, but it could easily be
> between any pair of devices if they are left enabled by the BIOS and
> mappen in the wrong place.
> 
> Signed-off-by: Matthew Wilcox <matthew@wil.cx>
> Acked-by: Robert Hancock <hancockr@shaw.ca>
> Acked-by: Jesse Barnes <jesse.barnes@intel.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  drivers/pci/probe.c |   18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -180,11 +180,26 @@ static inline int is_64bit_memory(u32 ma
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
> @@ -283,6 +298,9 @@ static void pci_read_bases(struct pci_de
>  			}
>  		}
>  	}
> +
> +	if ((dev->class >> 8) != PCI_CLASS_BRIDGE_HOST)
> +		pci_write_config_word(dev, PCI_COMMAND, orig_cmd);
>  }
>  
>  void pci_read_bridge_bases(struct pci_bus *child)
