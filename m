Return-Path: <linux-kernel-owner+w=401wt.eu-S1757599AbXH1R7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757599AbXH1R7i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 13:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752220AbXH1R72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 13:59:28 -0400
Received: from colo.lackof.org ([198.49.126.79]:48586 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752968AbXH1R71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 13:59:27 -0400
Date: Tue, 28 Aug 2007 11:59:08 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       Robert Hancock <hancockr@shaw.ca>,
       Jesse Barnes <jesse.barnes@intel.com>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] Fix boot-time hang on G31/G33 PC
Message-ID: <20070828175908.GD19224@colo.lackof.org>
References: <20070826015556.GC14130@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070826015556.GC14130@parisc-linux.org>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 25, 2007 at 07:55:56PM -0600, Matthew Wilcox wrote:
> 
> This patch, loosely based on a patch from Robert Hancock, which was in
> turn based on a patch from Jesse Barnes, fixes a boot-time hang on my
> shiny new PC.  The 'conflict' mentioned in the patch in my case happens
> to be between mmconfig and the graphics card, but it could easily be
> between any pair of devices if they are left enabled by the BIOS and
> mappen in the wrong place.

This issue has come up before:
    http://www.uwsg.indiana.edu/hypermail/linux/kernel/0212.2/0232.html

and Ivan Kokshaysky suggested a very similar patch:
    http://www.uwsg.indiana.edu/hypermail/linux/kernel/0212.2/0324.html

cheers,
grant

> 
> Signed-off-by: Matthew Wilcox <matthew@wil.cx>
> 
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
> -- 
> "Bill, look, we understand that you're interested in selling us this
> operating system, but compare it to ours.  We can't possibly take such
> a retrograde step."
