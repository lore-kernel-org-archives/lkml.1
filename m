Return-Path: <linux-kernel-owner+w=401wt.eu-S1752528AbYCLGJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528AbYCLGJA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 02:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751524AbYCLGIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 02:08:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33531 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751333AbYCLGIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 02:08:48 -0400
Date: Tue, 11 Mar 2008 23:08:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Linux Kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] devres: implement pcim_iomap_regions_request_all()
Message-Id: <20080311230825.fd631e29.akpm@linux-foundation.org>
In-Reply-To: <47D6643A.6060001@gmail.com>
References: <47D6643A.6060001@gmail.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Mar 2008 19:51:38 +0900 Tejun Heo <htejun@gmail.com> wrote:

> Some drivers need to reserve all PCI BARs to prevent other drivers
> misusing unoccupied BARs.  pcim_iomap_regions_request_all() requests
> all BARs and iomap specified BARs.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Cc: Jeff Garzik <jeff@garzik.org>
> ---
> After acked, it's probably best to push this through libata-dev as
> that's the only user for now.
> 
> Thanks.
> 
>  lib/devres.c |   25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
> 
> Index: work/lib/devres.c
> ===================================================================
> --- work.orig/lib/devres.c
> +++ work/lib/devres.c
> @@ -298,6 +298,31 @@ int pcim_iomap_regions(struct pci_dev *p
>  EXPORT_SYMBOL(pcim_iomap_regions);
>  
>  /**
> + * pcim_iomap_regions_request_all - Request all BARs and iomap specified ones
> + * @pdev: PCI device to map IO resources for
> + * @mask: Mask of BARs to iomap
> + * @name: Name used when requesting regions
> + *
> + * Request all PCI BARs and iomap regions specified by @mask.
> + */
> +int pcim_iomap_regions_request_all(struct pci_dev *pdev, u16 mask,
> +				   const char *name)
> +{
> +	int request_mask = ((1 << 6) - 1) & ~mask;
> +	int rc;
> +
> +	rc = pci_request_selected_regions(pdev, request_mask, name);
> +	if (rc)
> +		return rc;
> +
> +	rc = pcim_iomap_regions(pdev, mask, name);
> +	if (rc)
> +		pci_release_selected_regions(pdev, request_mask);
> +	return rc;
> +}
> +EXPORT_SYMBOL(pcim_iomap_regions_request_all);
> +
> +/**

err, I think you lost a bit.

drivers/ata/ahci.c: In function 'ahci_init_one':
drivers/ata/ahci.c:2247: error: implicit declaration of function 'pcim_iomap_regions_request_all'

--- a/include/linux/io.h~devres-implement-pcim_iomap_regions_request_all-fix
+++ a/include/linux/io.h
@@ -65,5 +65,7 @@ void __iomem * devm_ioremap_nocache(stru
 void devm_iounmap(struct device *dev, void __iomem *addr);
 int check_signature(const volatile void __iomem *io_addr,
 			const unsigned char *signature, int length);
+int pcim_iomap_regions_request_all(struct pci_dev *pdev, u16 mask,
+			const char *name)
 
 #endif /* _LINUX_IO_H */
_

