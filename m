Return-Path: <linux-kernel-owner+w=401wt.eu-S1764415AbXHXWUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764415AbXHXWUc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 18:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757555AbXHXWUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 18:20:22 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54143 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760818AbXHXWUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 18:20:21 -0400
Date: Fri, 24 Aug 2007 15:20:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>,
       Jan Beulich <jbeulich@novell.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Greg KH <greg@kroah.com>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, Martin Michlmayr <tbm@cyrius.com>
Subject: Re: [PATCH][resend] fix IDE legacy mode resources
Message-Id: <20070824152005.45167160.akpm@linux-foundation.org>
In-Reply-To: <20070824115559.06250ec0.yoichi_yuasa@tripeaks.co.jp>
References: <20070824115559.06250ec0.yoichi_yuasa@tripeaks.co.jp>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Aug 2007 11:55:59 +0900
Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp> wrote:

> Hi,
> 
> I got the following error on MIPS Cobalt.
> 
> PCI: Unable to reserve I/O region #1:8@f00001f0 for device 0000:00:09.1
> pata_via 0000:00:09.1: failed to request/iomap BARs for port 0 (errno=-16)
> PCI: Unable to reserve I/O region #3:8@f0000170 for device 0000:00:09.1
> pata_via 0000:00:09.1: failed to request/iomap BARs for port 1 (errno=-16)
> pata_via 0000:00:09.1: no available native port
> 
> The legacy mode IDE resources set the following order. 
> 
> pci_setup_device()
>     Legacy mode ATA controllers have fixed addresses.
>     IDE resources: 0x1F0-0x1F7, 0x3F6, 0x170-0x177, 0x376
>     |
>     V
> pcibios_fixup_bus()
>     MIPS Cobalt PCI bus regions have the -0x10000000 offset from PCI resources.
>     pcibios_fixup_bus() fix PCI bus regions.
>     0x1F0 - 0x10000000 = 0xF00001F0
>     |
>     V
> ata_pci_init_one()
>     PCI: Unable to reserve I/O region #1:8@f00001f0 for device 0000:00:09.1
> 
> In some architectures, PCI bus regions have the offset from PCI resources.
> For this reason, pci_setup_device() should set PCI bus regions to dev->resource[]. 
> 
> Yoichi
> 
> ---
> 
> Fix legacy mode IDE resources 
> 
> Signed-off-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
> 
> diff -pruN -X generic/Documentation/dontdiff generic-orig/drivers/pci/probe.c generic/drivers/pci/probe.c
> --- generic-orig/drivers/pci/probe.c	2007-07-26 17:07:44.151670750 +0900
> +++ generic/drivers/pci/probe.c	2007-07-26 17:25:42.227046250 +0900
> @@ -744,22 +744,40 @@ static int pci_setup_device(struct pci_d
>  		 */
>  		if (class == PCI_CLASS_STORAGE_IDE) {
>  			u8 progif;
> +			struct pci_bus_region region;
> +			struct resource resource;
>  			pci_read_config_byte(dev, PCI_CLASS_PROG, &progif);
>  			if ((progif & 1) == 0) {
> -				dev->resource[0].start = 0x1F0;
> -				dev->resource[0].end = 0x1F7;
> -				dev->resource[0].flags = LEGACY_IO_RESOURCE;
> -				dev->resource[1].start = 0x3F6;
> -				dev->resource[1].end = 0x3F6;
> -				dev->resource[1].flags = LEGACY_IO_RESOURCE;
> +				resource.start = 0x1F0;
> +				resource.end = 0x1F7;
> +				resource.flags = LEGACY_IO_RESOURCE;
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
> +				resource.start = 0x170;
> +				resource.end = 0x177;
> +				resource.flags = LEGACY_IO_RESOURCE;
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

ho hum.

Below is the patch from Jan (which I'll now need to drop) which we are, in
a rather haphazard manner, trying to get into some sort of working shape.

Please discuss.

From: Jan Beulich <jbeulich@novell.com>

Fix http://bugzilla.kernel.org/show_bug.cgi?id=8187

The change to force legacy mode IDE channels' resources to fixed non-zero
values confuses (at least some versions of) X, because the values reported by
the kernel and those readable from PCI config space aren't consistent anymore.
 Therefore, this patch arranges for the respective BARs to also get updated if
possible.

[akpm@linux-foundation.org: <alan>Just remove that chunk</aman>]
Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Kristofer T. Karas" <ktk@enterprise.bidmc.harvard.edu>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Natalie Protasevich <protasnb@gmail.com>
Cc: Greg KH <greg@kroah.com>
Cc: Gabriel C <nix.or.die@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/probe.c |   40 +++++++++++++++++++++++++++-------------
 1 files changed, 27 insertions(+), 13 deletions(-)

diff -puN drivers/pci/probe.c~pci-align-bar-settings-for-legacy-mode-ide drivers/pci/probe.c
--- a/drivers/pci/probe.c~pci-align-bar-settings-for-legacy-mode-ide
+++ a/drivers/pci/probe.c
@@ -741,7 +741,29 @@ static void pci_read_irq(struct pci_dev 
 	dev->irq = irq;
 }
 
-#define LEGACY_IO_RESOURCE	(IORESOURCE_IO | IORESOURCE_PCI_FIXED)
+static void change_legacy_io_resource(struct pci_dev * dev, unsigned index,
+				resource_size_t start, resource_size_t end)
+{
+	resource_size_t base = start & PCI_BASE_ADDRESS_IO_MASK;
+	resource_size_t len = (end | ~PCI_BASE_ADDRESS_IO_MASK) - base + 1;
+
+	if (pci_resource_len(dev, index) != len) {
+		printk(KERN_WARNING "%s: cannot adjust BAR%u (size %Lx)\n",
+			pci_name(dev), index,
+			(unsigned long long)pci_resource_len(dev, index));
+	} else {
+		printk(KERN_INFO "%s: trying to change BAR%u from %Lx to %Lx\n",
+			pci_name(dev), index,
+			(unsigned long long)pci_resource_start(dev, index),
+			(unsigned long long)base);
+		pci_write_config_dword(dev, PCI_BASE_ADDRESS_0 + index * 4,
+					base);
+	}
+	pci_resource_start(dev, index) = start;
+	pci_resource_end(dev, index) = end;
+	pci_resource_flags(dev, index) = IORESOURCE_IO|IORESOURCE_PCI_FIXED|
+					PCI_BASE_ADDRESS_SPACE_IO;
+}
 
 /**
  * pci_setup_device - fill in class and map information of a device
@@ -795,20 +817,12 @@ static int pci_setup_device(struct pci_d
 			u8 progif;
 			pci_read_config_byte(dev, PCI_CLASS_PROG, &progif);
 			if ((progif & 1) == 0) {
-				dev->resource[0].start = 0x1F0;
-				dev->resource[0].end = 0x1F7;
-				dev->resource[0].flags = LEGACY_IO_RESOURCE;
-				dev->resource[1].start = 0x3F6;
-				dev->resource[1].end = 0x3F6;
-				dev->resource[1].flags = LEGACY_IO_RESOURCE;
+				change_legacy_io_resource(dev, 0, 0x1F0, 0x1F7);
+				change_legacy_io_resource(dev, 1, 0x3F6, 0x3F6);
 			}
 			if ((progif & 4) == 0) {
-				dev->resource[2].start = 0x170;
-				dev->resource[2].end = 0x177;
-				dev->resource[2].flags = LEGACY_IO_RESOURCE;
-				dev->resource[3].start = 0x376;
-				dev->resource[3].end = 0x376;
-				dev->resource[3].flags = LEGACY_IO_RESOURCE;
+				change_legacy_io_resource(dev, 2, 0x170, 0x177);
+				change_legacy_io_resource(dev, 3, 0x376, 0x376);
 			}
 		}
 		break;
_

