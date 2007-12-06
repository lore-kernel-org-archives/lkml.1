Return-Path: <linux-kernel-owner+w=401wt.eu-S1753253AbXLFAM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253AbXLFAM7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 19:12:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751531AbXLFAMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 19:12:50 -0500
Received: from gate.crashing.org ([63.228.1.57]:45404 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478AbXLFAMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 19:12:49 -0500
Subject: Please revert: PCI: fix IDE legacy mode resources
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@suse.de>, Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>,
       Ralf Baechle <ralf@linux-mips.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <200710122305.l9CN5tFI008240@hera.kernel.org>
References: <200710122305.l9CN5tFI008240@hera.kernel.org>
Content-Type: text/plain
Date: Thu, 06 Dec 2007 11:10:18 +1100
Message-Id: <1196899818.7033.11.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit below that was merged in october looks bogus to me.

At this stage in the PCI probe, the pci_dev->resource's contain RAW bar
values, that is bus values..

A PCI legacy IDE controller that hard decodes 0x1f0 etc...  does such as
bus values as well. That is, the resources should contain 0x1f0...0x1f7
etc... -not- some kind of transformed values, because that's exactly
what a BAR would contain if it had been read from the device by
pci_read_bases() and we haven't performed any fixup yet.

If the platform offsets resources, like powerpc does, it should do so
later on in a fixup pass (on ppc, we use either a header quirk or
fixup_bus depending on the phase of the moon) and that should work
fine. 

I don't understand how his fix can work on MIPS nor why the previous
code didn't, but I don't know how MIPS does its remapping tricks,
however it will definitely -not- work on powerpc (and will break a
couple of machines out there).

So there may be a problem with MIPS but that "fix" is wrong and will
break PowerPC at least. Can it be reverted ? I'll work with Yoichi and
Ralf to understand what mips does and see how it can be fixed.

Cheers,
Ben. 

On Fri, 2007-10-12 at 23:05 +0000, Linux Kernel Mailing List wrote:
> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=fd6e732186ab522c812ab19c2c5e5befb8ec8115
> Commit:     fd6e732186ab522c812ab19c2c5e5befb8ec8115
> Parent:     cbf5d9e6b9bcf03291cbb51db144b3e2773a8a2d
> Author:     Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
> AuthorDate: Tue Oct 2 14:19:23 2007 -0700
> Committer:  Greg Kroah-Hartman <gregkh@suse.de>
> CommitDate: Fri Oct 12 15:03:17 2007 -0700
> 
>     PCI: fix IDE legacy mode resources
>     
>     I got the following error on MIPS Cobalt.
>     
>     PCI: Unable to reserve I/O region #1:8@f00001f0 for device 0000:00:09.1
>     pata_via 0000:00:09.1: failed to request/iomap BARs for port 0 (errno=-16)
>     PCI: Unable to reserve I/O region #3:8@f0000170 for device 0000:00:09.1
>     pata_via 0000:00:09.1: failed to request/iomap BARs for port 1 (errno=-16)
>     pata_via 0000:00:09.1: no available native port
>     
>     The legacy mode IDE resources set the following order.
>     
>     pci_setup_device()
>         Legacy mode ATA controllers have fixed addresses.
>         IDE resources: 0x1F0-0x1F7, 0x3F6, 0x170-0x177, 0x376
>         |
>         V
>     pcibios_fixup_bus()
>         MIPS Cobalt PCI bus regions have the -0x10000000 offset from PCI resources.
>         pcibios_fixup_bus() fix PCI bus regions.
>         0x1F0 - 0x10000000 = 0xF00001F0
>         |
>         V
>     ata_pci_init_one()
>         PCI: Unable to reserve I/O region #1:8@f00001f0 for device 0000:00:09.1
>     
>     In some architectures, PCI bus regions have the offset from PCI resources.
>     For this reason, pci_setup_device() should set PCI bus regions to
>     dev->resource[].
>     
>     [akpm@linux-foundation.org: use struct initialiser]
>     Signed-off-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
>     Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
>     Cc: Greg KH <greg@kroah.com>
>     Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>     Cc: Ralf Baechle <ralf@linux-mips.org>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> ---
>  drivers/pci/probe.c |   48 ++++++++++++++++++++++++++++++++++++------------
>  1 files changed, 36 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index 171ca71..40e571d 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -744,22 +744,46 @@ static int pci_setup_device(struct pci_dev * dev)
>  		 */
>  		if (class == PCI_CLASS_STORAGE_IDE) {
>  			u8 progif;
> +			struct pci_bus_region region;
> +
>  			pci_read_config_byte(dev, PCI_CLASS_PROG, &progif);
>  			if ((progif & 1) == 0) {
> -				dev->resource[0].start = 0x1F0;
> -				dev->resource[0].end = 0x1F7;
> -				dev->resource[0].flags = LEGACY_IO_RESOURCE;
> -				dev->resource[1].start = 0x3F6;
> -				dev->resource[1].end = 0x3F6;
> -				dev->resource[1].flags = LEGACY_IO_RESOURCE;
> +				struct resource resource = {
> +					.start = 0x1F0,
> +					.end = 0x1F7,
> +					.flags = LEGACY_IO_RESOURCE,
> +				};
> +
> +				pcibios_resource_to_bus(dev, &region, &resource);
> +				dev->resource[0].start = region.start;
> +				dev->resource[0].end = region.end;
> +				dev->resource[0].flags = resource.flags;
> +				resource.start = 0x3F6;
> +				resource.end = 0x3F6;
> +				resource.flags = LEGACY_IO_RESOURCE;
> +				pcibios_resource_to_bus(dev, &region, &resource);
> +				dev->resource[1].start = region.start;
> +				dev->resource[1].end = region.end;
> +				dev->resource[1].flags = resource.flags;
>  			}
>  			if ((progif & 4) == 0) {
> -				dev->resource[2].start = 0x170;
> -				dev->resource[2].end = 0x177;
> -				dev->resource[2].flags = LEGACY_IO_RESOURCE;
> -				dev->resource[3].start = 0x376;
> -				dev->resource[3].end = 0x376;
> -				dev->resource[3].flags = LEGACY_IO_RESOURCE;
> +				struct resource resource = {
> +					.start = 0x170,
> +					.end = 0x177,
> +					.flags = LEGACY_IO_RESOURCE,
> +				};
> +
> +				pcibios_resource_to_bus(dev, &region, &resource);
> +				dev->resource[2].start = region.start;
> +				dev->resource[2].end = region.end;
> +				dev->resource[2].flags = resource.flags;
> +				resource.start = 0x376;
> +				resource.end = 0x376;
> +				resource.flags = LEGACY_IO_RESOURCE;
> +				pcibios_resource_to_bus(dev, &region, &resource);
> +				dev->resource[3].start = region.start;
> +				dev->resource[3].end = region.end;
> +				dev->resource[3].flags = resource.flags;
>  			}
>  		}
>  		break;
> -
> To unsubscribe from this list: send the line "unsubscribe git-commits-head" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

