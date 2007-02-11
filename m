Return-Path: <linux-kernel-owner+w=401wt.eu-S1752639AbXBKCpI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639AbXBKCpI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 21:45:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752632AbXBKCpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 21:45:07 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:34427 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbXBKCpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 21:45:04 -0500
Date: Sat, 10 Feb 2007 18:41:20 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Jeff Garzik <jgarzik@pobox.com>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org
Subject: Re: [PATCH] iomap: make PCI iomap stuff excluded when PCI isn't
 configured
Message-Id: <20070210184120.728ef789.randy.dunlap@oracle.com>
In-Reply-To: <45CE0434.30105@gmail.com>
References: <20070210114314.GB12642@osiris.boeblingen.de.ibm.com>
	<45CE0434.30105@gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Feb 2007 12:43:16 -0500 Tejun Heo wrote:

> devres iomap made lib/iomap.c always built and added several
> arch-indep PCI routines to include/linux/io.h and lib/iomap.c without
> wrapping them inside CONFIG_PCI.  This breaks configurations where PCI
> is not configured.  Wrap pci_iomap() in CONFIG_PCI and move managed
> PCI iomap functions into include/linux/pci.h and drivers/pci/pci.c.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---
> Heiko, how about this?  Does it fix s390?

At least it fixes allnoconfig on x86_64, which was also broken
by this.  <see sig :>


> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 8b44cff..d6ec47a 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -1314,6 +1314,158 @@ int pci_select_bars(struct pci_dev *dev, unsigned long flags)
>  	return bars;
>  }
>  
> +/*
> + * PCI iomap devres
> + */
> +#define PCIM_IOMAP_MAX	PCI_ROM_RESOURCE
> +
> +struct pcim_iomap_devres {
> +	void __iomem *table[PCIM_IOMAP_MAX];
> +};
> +
> +static void pcim_iomap_release(struct device *gendev, void *res)
> +{
> +	struct pci_dev *dev = container_of(gendev, struct pci_dev, dev);
> +	struct pcim_iomap_devres *this = res;
> +	int i;
> +
> +	for (i = 0; i < PCIM_IOMAP_MAX; i++)
> +		if (this->table[i])
> +			pci_iounmap(dev, this->table[i]);
> +}
> +
> +/**
> + * pcim_iomap_table - access iomap allocation table
> + * @pdev: PCI device to access iomap table for
> + *
> + * Access iomap allocation table for @dev.  If iomap table doesn't
> + * exist and @pdev is managed, it will be allocated.  All iomaps
> + * recorded in the iomap table are automatically unmapped on driver
> + * detach.
> + *
> + * This function might sleep when the table is first allocated but can
> + * be safely called without context and guaranteed to succed once
> + * allocated.
> + */
> +void __iomem * const * pcim_iomap_table(struct pci_dev *pdev)
> +{
> +	struct pcim_iomap_devres *dr, *new_dr;
> +
> +	dr = devres_find(&pdev->dev, pcim_iomap_release, NULL, NULL);
> +	if (dr)
> +		return dr->table;
> +
> +	new_dr = devres_alloc(pcim_iomap_release, sizeof(*new_dr), GFP_KERNEL);
> +	if (!new_dr)
> +		return NULL;
> +	dr = devres_get(&pdev->dev, new_dr, NULL, NULL);
> +	return dr->table;
> +}
> +EXPORT_SYMBOL(pcim_iomap_table);
> +
> +/**
> + * pcim_iomap - Managed pcim_iomap()
> + * @pdev: PCI device to iomap for
> + * @bar: BAR to iomap
> + * @maxlen: Maximum length of iomap
> + *
> + * Managed pci_iomap().  Map is automatically unmapped on driver
> + * detach.
> + */
> +void __iomem * pcim_iomap(struct pci_dev *pdev, int bar, unsigned long maxlen)
> +{
> +	void __iomem **tbl;
> +
> +	BUG_ON(bar >= PCIM_IOMAP_MAX);
> +
> +	tbl = (void __iomem **)pcim_iomap_table(pdev);
> +	if (!tbl || tbl[bar])	/* duplicate mappings not allowed */
> +		return NULL;
> +
> +	tbl[bar] = pci_iomap(pdev, bar, maxlen);
> +	return tbl[bar];
> +}
> +EXPORT_SYMBOL(pcim_iomap);
> +
> +/**
> + * pcim_iounmap - Managed pci_iounmap()
> + * @pdev: PCI device to iounmap for
> + * @addr: Address to unmap
> + *
> + * Managed pci_iounmap().  @addr must have been mapped using pcim_iomap().
> + */
> +void pcim_iounmap(struct pci_dev *pdev, void __iomem *addr)
> +{
> +	void __iomem **tbl;
> +	int i;
> +
> +	pci_iounmap(pdev, addr);
> +
> +	tbl = (void __iomem **)pcim_iomap_table(pdev);
> +	BUG_ON(!tbl);
> +
> +	for (i = 0; i < PCIM_IOMAP_MAX; i++)
> +		if (tbl[i] == addr) {
> +			tbl[i] = NULL;
> +			return;
> +		}
> +	WARN_ON(1);
> +}
> +EXPORT_SYMBOL(pcim_iounmap);
> +
> +/**
> + * pcim_iomap_regions - Request and iomap PCI BARs
> + * @pdev: PCI device to map IO resources for
> + * @mask: Mask of BARs to request and iomap
> + * @name: Name used when requesting regions
> + *
> + * Request and iomap regions specified by @mask.
> + */
> +int pcim_iomap_regions(struct pci_dev *pdev, u16 mask, const char *name)
> +{
> +	void __iomem * const *iomap;
> +	int i, rc;
> +
> +	iomap = pcim_iomap_table(pdev);
> +	if (!iomap)
> +		return -ENOMEM;
> +
> +	for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
> +		unsigned long len;
> +
> +		if (!(mask & (1 << i)))
> +			continue;
> +
> +		rc = -EINVAL;
> +		len = pci_resource_len(pdev, i);
> +		if (!len)
> +			goto err_inval;
> +
> +		rc = pci_request_region(pdev, i, name);
> +		if (rc)
> +			goto err_region;
> +
> +		rc = -ENOMEM;
> +		if (!pcim_iomap(pdev, i, 0))
> +			goto err_iomap;
> +	}
> +
> +	return 0;
> +
> + err_iomap:
> +	pcim_iounmap(pdev, iomap[i]);
> + err_region:
> +	pci_release_region(pdev, i);
> + err_inval:
> +	while (--i >= 0) {
> +		pcim_iounmap(pdev, iomap[i]);
> +		pci_release_region(pdev, i);
> +	}
> +
> +	return rc;
> +}
> +EXPORT_SYMBOL(pcim_iomap_regions);
> +
>  static int __devinit pci_init(void)
>  {
>  	struct pci_dev *dev = NULL;
> diff --git a/include/linux/io.h b/include/linux/io.h
> index 9e419eb..c244a0c 100644
> --- a/include/linux/io.h
> +++ b/include/linux/io.h
> @@ -43,12 +43,6 @@ void __iomem * devm_ioremap_nocache(struct device *dev, unsigned long offset,
>  				    unsigned long size);
>  void devm_iounmap(struct device *dev, void __iomem *addr);
>  
> -void __iomem * pcim_iomap(struct pci_dev *pdev, int bar, unsigned long maxlen);
> -void pcim_iounmap(struct pci_dev *pdev, void __iomem *addr);
> -void __iomem * const * pcim_iomap_table(struct pci_dev *pdev);
> -
> -int pcim_iomap_regions(struct pci_dev *pdev, u16 mask, const char *name);
> -
>  /**
>   *	check_signature		-	find BIOS signatures
>   *	@io_addr: mmio address to check
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 9e3042e..c8f4b84 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -611,6 +611,12 @@ void pci_walk_bus(struct pci_bus *top, void (*cb)(struct pci_dev *, void *),
>  int pci_cfg_space_size(struct pci_dev *dev);
>  unsigned char pci_bus_max_busnr(struct pci_bus* bus);
>  
> +/* PCI managed iomap interface */
> +void __iomem * pcim_iomap(struct pci_dev *pdev, int bar, unsigned long maxlen);
> +void pcim_iounmap(struct pci_dev *pdev, void __iomem *addr);
> +void __iomem * const * pcim_iomap_table(struct pci_dev *pdev);
> +int pcim_iomap_regions(struct pci_dev *pdev, u16 mask, const char *name);
> +
>  /* kmem_cache style wrapper around pci_alloc_consistent() */
>  
>  #include <linux/dmapool.h>
> diff --git a/lib/iomap.c b/lib/iomap.c
> index 4990c73..bdf31ba 100644
> --- a/lib/iomap.c
> +++ b/lib/iomap.c
> @@ -228,6 +228,8 @@ void ioport_unmap(void __iomem *addr)
>  EXPORT_SYMBOL(ioport_map);
>  EXPORT_SYMBOL(ioport_unmap);
>  
> +#ifdef CONFIG_PCI
> +
>  /* Create a virtual mapping cookie for a PCI BAR (memory or IO) */
>  void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
>  {
> @@ -257,6 +259,7 @@ void pci_iounmap(struct pci_dev *dev, void __iomem * addr)
>  EXPORT_SYMBOL(pci_iomap);
>  EXPORT_SYMBOL(pci_iounmap);
>  
> +#endif /* CONFIG_PCI */
>  #endif /* CONFIG_GENERIC_IOMAP */
>  
>  /*
> @@ -399,155 +402,3 @@ void devm_iounmap(struct device *dev, void __iomem *addr)
>  			       (void *)addr));
>  }
>  EXPORT_SYMBOL(devm_iounmap);
> -
> -/*
> - * PCI iomap devres
> - */
> -#define PCIM_IOMAP_MAX	PCI_ROM_RESOURCE
> -
> -struct pcim_iomap_devres {
> -	void __iomem *table[PCIM_IOMAP_MAX];
> -};
> -
> -static void pcim_iomap_release(struct device *gendev, void *res)
> -{
> -	struct pci_dev *dev = container_of(gendev, struct pci_dev, dev);
> -	struct pcim_iomap_devres *this = res;
> -	int i;
> -
> -	for (i = 0; i < PCIM_IOMAP_MAX; i++)
> -		if (this->table[i])
> -			pci_iounmap(dev, this->table[i]);
> -}
> -
> -/**
> - * pcim_iomap_table - access iomap allocation table
> - * @pdev: PCI device to access iomap table for
> - *
> - * Access iomap allocation table for @dev.  If iomap table doesn't
> - * exist and @pdev is managed, it will be allocated.  All iomaps
> - * recorded in the iomap table are automatically unmapped on driver
> - * detach.
> - *
> - * This function might sleep when the table is first allocated but can
> - * be safely called without context and guaranteed to succed once
> - * allocated.
> - */
> -void __iomem * const * pcim_iomap_table(struct pci_dev *pdev)
> -{
> -	struct pcim_iomap_devres *dr, *new_dr;
> -
> -	dr = devres_find(&pdev->dev, pcim_iomap_release, NULL, NULL);
> -	if (dr)
> -		return dr->table;
> -
> -	new_dr = devres_alloc(pcim_iomap_release, sizeof(*new_dr), GFP_KERNEL);
> -	if (!new_dr)
> -		return NULL;
> -	dr = devres_get(&pdev->dev, new_dr, NULL, NULL);
> -	return dr->table;
> -}
> -EXPORT_SYMBOL(pcim_iomap_table);
> -
> -/**
> - * pcim_iomap - Managed pcim_iomap()
> - * @pdev: PCI device to iomap for
> - * @bar: BAR to iomap
> - * @maxlen: Maximum length of iomap
> - *
> - * Managed pci_iomap().  Map is automatically unmapped on driver
> - * detach.
> - */
> -void __iomem * pcim_iomap(struct pci_dev *pdev, int bar, unsigned long maxlen)
> -{
> -	void __iomem **tbl;
> -
> -	BUG_ON(bar >= PCIM_IOMAP_MAX);
> -
> -	tbl = (void __iomem **)pcim_iomap_table(pdev);
> -	if (!tbl || tbl[bar])	/* duplicate mappings not allowed */
> -		return NULL;
> -
> -	tbl[bar] = pci_iomap(pdev, bar, maxlen);
> -	return tbl[bar];
> -}
> -EXPORT_SYMBOL(pcim_iomap);
> -
> -/**
> - * pcim_iounmap - Managed pci_iounmap()
> - * @pdev: PCI device to iounmap for
> - * @addr: Address to unmap
> - *
> - * Managed pci_iounmap().  @addr must have been mapped using pcim_iomap().
> - */
> -void pcim_iounmap(struct pci_dev *pdev, void __iomem *addr)
> -{
> -	void __iomem **tbl;
> -	int i;
> -
> -	pci_iounmap(pdev, addr);
> -
> -	tbl = (void __iomem **)pcim_iomap_table(pdev);
> -	BUG_ON(!tbl);
> -
> -	for (i = 0; i < PCIM_IOMAP_MAX; i++)
> -		if (tbl[i] == addr) {
> -			tbl[i] = NULL;
> -			return;
> -		}
> -	WARN_ON(1);
> -}
> -EXPORT_SYMBOL(pcim_iounmap);
> -
> -/**
> - * pcim_iomap_regions - Request and iomap PCI BARs
> - * @pdev: PCI device to map IO resources for
> - * @mask: Mask of BARs to request and iomap
> - * @name: Name used when requesting regions
> - *
> - * Request and iomap regions specified by @mask.
> - */
> -int pcim_iomap_regions(struct pci_dev *pdev, u16 mask, const char *name)
> -{
> -	void __iomem * const *iomap;
> -	int i, rc;
> -
> -	iomap = pcim_iomap_table(pdev);
> -	if (!iomap)
> -		return -ENOMEM;
> -
> -	for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
> -		unsigned long len;
> -
> -		if (!(mask & (1 << i)))
> -			continue;
> -
> -		rc = -EINVAL;
> -		len = pci_resource_len(pdev, i);
> -		if (!len)
> -			goto err_inval;
> -
> -		rc = pci_request_region(pdev, i, name);
> -		if (rc)
> -			goto err_region;
> -
> -		rc = -ENOMEM;
> -		if (!pcim_iomap(pdev, i, 0))
> -			goto err_iomap;
> -	}
> -
> -	return 0;
> -
> - err_iomap:
> -	pcim_iounmap(pdev, iomap[i]);
> - err_region:
> -	pci_release_region(pdev, i);
> - err_inval:
> -	while (--i >= 0) {
> -		pcim_iounmap(pdev, iomap[i]);
> -		pci_release_region(pdev, i);
> -	}
> -
> -	return rc;
> -}
> -EXPORT_SYMBOL(pcim_iomap_regions);
> -

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
