Return-Path: <linux-kernel-owner+w=401wt.eu-S1756708AbYJITlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708AbYJITlX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 15:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760492AbYJITlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 15:41:05 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:58521 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726AbYJITlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 15:41:04 -0400
Date: Thu, 9 Oct 2008 12:40:25 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       mingo@elte.hu
Subject: Re: [PATCH] resource: ensure MMIO exclusivity for device drivers
Message-Id: <20081009124025.00f5178d.randy.dunlap@oracle.com>
In-Reply-To: <20081006144629.25091ac0@infradead.org>
References: <20081006144629.25091ac0@infradead.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Oct 2008 14:46:29 -0700 Arjan van de Ven wrote:

>  Documentation/kernel-parameters.txt |    4 ++
>  arch/x86/mm/init_32.c               |    2 +
>  arch/x86/mm/init_64.c               |    2 +
>  drivers/pci/pci-sysfs.c             |    3 ++
>  drivers/pci/pci.c                   |   50 +++++++++++++++++++++++++++-
>  include/linux/ioport.h              |    9 +++--
>  include/linux/pci.h                 |    1 +
>  kernel/resource.c                   |   61 +++++++++++++++++++++++++++++++++--
>  8 files changed, 124 insertions(+), 8 deletions(-)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 4b9ee9b..e0b0a6b 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -882,6 +882,10 @@ and is between 256 and 4096 characters. It is defined in the file
>  
>  	inttest=	[IA64]
>  
> +	iomem=		Disable strict checking of access to MMIO memory
> +		strict	regions from userspace.
> +		relaxed
> +
>  	iommu=		[x86]
>  		off
>  		force
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index a9301a2..d61e756 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -1367,6 +1372,47 @@ err_out:
>  }
>  
>  /**
> + *	pci_request_region - Reserved PCI I/O and memory resource

	                     Reserve

> + *	@pdev: PCI device whose resources are to be reserved
> + *	@bar: BAR to be reserved
> + *	@res_name: Name to be associated with resource.
> + *
> + *	Mark the PCI region associated with PCI device @pdev BR @bar as

	                                                     BAR (or why not?)

> + *	being reserved by owner @res_name.  Do not access any
> + *	address inside the PCI regions unless this call returns
> + *	successfully.
> + *
> + *	Returns 0 on success, or %EBUSY on error.  A warning
> + *	message is also printed on failure.
> + */
> +int pci_request_region(struct pci_dev *pdev, int bar, const char *res_name)
> +{
> +	return __pci_request_region(pdev, bar, res_name, 0);
> +}
> +
> +/**
> + *	pci_request_region_relaxed - Reserved PCI I/O and memory resource

	                             Reserve

> + *	@pdev: PCI device whose resources are to be reserved
> + *	@bar: BAR to be reserved
> + *	@res_name: Name to be associated with resource.
> + *
> + *	Mark the PCI region associated with PCI device @pdev BR @bar as

	                                                     BAR

> + *	being reserved by owner @res_name.  Do not access any
> + *	address inside the PCI regions unless this call returns
> + *	successfully.
> + *
> + *	Returns 0 on success, or %EBUSY on error.  A warning
> + *	message is also printed on failure.
> + *
> + *	The key difference that _relaxed makes is that userspace is
> + *	explicitly allowed to map the resource via /dev/mem or
> + * 	sysfs.
> + */
> +int pci_request_region_relaxed(struct pci_dev *pdev, int bar, const char *res_name)
> +{
> +	return __pci_request_region(pdev, bar, res_name, 1);
> +}
> +/**
>   * pci_release_selected_regions - Release selected PCI I/O and memory resources
>   * @pdev: PCI device whose resources were previously reserved
>   * @bars: Bitmask of BARs to be released

> diff --git a/kernel/resource.c b/kernel/resource.c
> index 7797dae..d08fa31 100644
> --- a/kernel/resource.c
> +++ b/kernel/resource.c
> @@ -864,3 +866,56 @@ int iomem_map_sanity_check(resource_size_t addr, unsigned long size)
>  
>  	return err;
>  }
> +
> +#ifdef CONFIG_STRICT_DEVMEM
> +static int strict_iomem_checks = 1;
> +#else
> +static int strict_iomem_checks = 0;
> +#endif
> +
> +/*
> + * check if an address is reserved in the iomem resource tree
> + * returns 1 if reserved, 0 if not reserved.
> + */
> +int iomem_is_reserved(u64 addr)
> +{
> +	struct resource *p = &iomem_resource;
> +	int err = 0;
> +	loff_t l;
> +	int size= PAGE_SIZE;
> +
> +	if (!strict_iomem_checks)
> +		return 0;
> +
> +	read_lock(&resource_lock);
> +	for (p = p->child; p ; p = r_next(NULL, p, &l)) {
> +		/*
> +		 * We can probably skip the resources without
> +		 * IORESOURCE_IO attribute?
> +		 */
> +		if (p->start >= addr + size)
> +			continue;
> +		if (p->end < addr)
> +			continue;
> +		if (p->flags & IORESOURCE_BUSY &&
> +		    !(p->flags & IORESOURCE_RELAXED)) {
> +			err = 1;
> +			break;
> +		}
> +	}
> +	read_unlock(&resource_lock);
> +
> +	return err;
> +}
> +EXPORT_SYMBOL(iomem_is_reserved);
> +
> +static int __init strict_iomem(char *str)
> +{
> +	if (strstr(str, "relaxed"))
> +		strict_iomem_checks = 0;
> +	if (strstr(str, "strict"))
> +		strict_iomem_checks = 0;

	Why not                     = 1;

> +	return 1;
> +}
> +
> +__setup("iomem=", strict_iomem);


---
~Randy
