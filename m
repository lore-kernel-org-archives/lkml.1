Return-Path: <linux-kernel-owner+w=401wt.eu-S1756810AbXLXHXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810AbXLXHXh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 02:23:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754370AbXLXHXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 02:23:21 -0500
Received: from colo.lackof.org ([198.49.126.79]:54255 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753866AbXLXHXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 02:23:19 -0500
Date: Mon, 24 Dec 2007 00:23:01 -0700
From: Grant Grundler <grundler@parisc-linux.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, Alan Cox <alan@redhat.com>,
       Greg Kroah-Hartman <greg@kroah.com>, jgarzik@pobox.com,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, wingel@nano-system.com,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, james.smart@emulex.com,
       linux-driver@qlogic.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH 4/4] [POWERPC] pci: Disable IO/Mem on a device when
	resources can't be allocated
Message-ID: <20071224072301.GD3758@colo.lackof.org>
References: <1197932473.576079.142524077033.qpush@grosgo> <20071217230127.46B3BDDE38@ozlabs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071217230127.46B3BDDE38@ozlabs.org>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2007 at 10:01:15AM +1100, Benjamin Herrenschmidt wrote:
> This patch changes the PowerPC PCI code to disable IO and/or Memory
> decoding on a PCI device when a resource of that type failed to be
> allocated. This is done to avoid having unallocated dangling BARs enabled
> that might try to decode on top of other devices.
> 
> If a proper resource is assigned later on, then pci_enable_device{,_io,_mem}
> will take care of re-enabling decoding.
> 
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
....
> @@ -1062,8 +1065,12 @@ static void __init pcibios_allocate_reso
>  				disabled = !(command & PCI_COMMAND_IO);
>  			else
>  				disabled = !(command & PCI_COMMAND_MEMORY);
> -			if (pass == disabled)
> -				alloc_resource(dev, idx);
> +			if (pass == disabled && alloc_resource(dev, idx)) {
> +				command &= ~(r->flags & (IORESOURCE_IO |
> +							 IORESOURCE_MEM));

While this may be ok for PPC, in general, wouldn't we want to only disable
which ever type of resource that couldn't be allocated?
ie make two calls: alloc_resource_io() and alloc_resource_mem() and disable
the respective flag if the alloc call fails?
Thus a device which was enable and programmed by BIOS could remain functional
despite one resource not being allocated.
(e.g. MMIO was allocated successfully while IO Port space was not)

Again, this is just a hypothetical question since I have no example (yet)
off hand where this is true. ISTR, the original discussion around
pci_enable_device_bars() suggested some machines already have this issue.

cheers,
grant

> +				pci_write_config_word(dev,
> +						      PCI_COMMAND, command);
> +			}
>  		}
>  		if (pass)
>  			continue;
