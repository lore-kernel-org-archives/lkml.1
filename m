Return-Path: <linux-kernel-owner+w=401wt.eu-S1758828AbZBLKg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758828AbZBLKg7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 05:36:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758653AbZBLKgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 05:36:36 -0500
Received: from gate.crashing.org ([63.228.1.57]:58673 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758631AbZBLKgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 05:36:35 -0500
Subject: Re: [PATCH 1/5]: drm: ati_pcigart: Do not access I/O MEM space
 using pointer derefs.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Miller <davem@davemloft.net>
Cc: airlied@linux.ie, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090212.021527.12463602.davem@davemloft.net>
References: <20090212.021527.12463602.davem@davemloft.net>
Content-Type: text/plain
Date: Thu, 12 Feb 2009 21:35:59 +1100
Message-Id: <1234434959.29851.55.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-12 at 02:15 -0800, David Miller wrote:
> The PCI GART table initialization code treats the GART table mapping
> unconditionally as a kernel virtual address.
> 
> But it could be in the framebuffer, for example, and thus we're
> dealing with a PCI MEM space ioremap() cookie.  Treating that as a
> virtual address is illegal and will crash some system types (such as
> sparc64 where the ioremap() return value is actually a physical I/O
> address).
> 
> So access the area correctly, using gart_info->gart_table_location as
> our guide.

Oh BTW something else to be careful with, though I suppose it's working
some what by accident right now... when the GART is in the frame buffer
it gets applied the current fb swapper setting... ouch !

So it might be a good idea, if we're going to use DRM_READ/WRITE32 which
afaik are readl/writel (ie, swapping) to make sure we at least
temporarily disable that swapper while whacking the GART.

I know David (Airlied) kms stuff sorts that out by having a fixed
surface covering that area but definitely worth keeping in mind.

Cheers,
Ben.

> Signed-off-by: David S. Miller <davem@davemloft.net>
> ---
>  drivers/gpu/drm/ati_pcigart.c |   26 ++++++++++++++++++++------
>  1 files changed, 20 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/gpu/drm/ati_pcigart.c b/drivers/gpu/drm/ati_pcigart.c
> index c533d0c..2cd827a 100644
> --- a/drivers/gpu/drm/ati_pcigart.c
> +++ b/drivers/gpu/drm/ati_pcigart.c
> @@ -95,10 +95,11 @@ EXPORT_SYMBOL(drm_ati_pcigart_cleanup);
>  
>  int drm_ati_pcigart_init(struct drm_device *dev, struct drm_ati_pcigart_info *gart_info)
>  {
> +	struct drm_local_map *map = &gart_info->mapping;
>  	struct drm_sg_mem *entry = dev->sg;
>  	void *address = NULL;
>  	unsigned long pages;
> -	u32 *pci_gart, page_base;
> +	u32 *pci_gart, page_base, gart_idx;
>  	dma_addr_t bus_address = 0;
>  	int i, j, ret = 0;
>  	int max_pages;
> @@ -133,8 +134,14 @@ int drm_ati_pcigart_init(struct drm_device *dev, struct drm_ati_pcigart_info *ga
>  	pages = (entry->pages <= max_pages)
>  	    ? entry->pages : max_pages;
>  
> -	memset(pci_gart, 0, max_pages * sizeof(u32));
> +	if (gart_info->gart_table_location == DRM_ATI_GART_MAIN) {
> +		memset(pci_gart, 0, max_pages * sizeof(u32));
> +	} else {
> +		for (gart_idx = 0; gart_idx < max_pages; gart_idx++)
> +			DRM_WRITE32(map, gart_idx * sizeof(u32), 0);
> +	}
>  
> +	gart_idx = 0;
>  	for (i = 0; i < pages; i++) {
>  		/* we need to support large memory configurations */
>  		entry->busaddr[i] = pci_map_page(dev->pdev, entry->pagelist[i],
> @@ -149,19 +156,26 @@ int drm_ati_pcigart_init(struct drm_device *dev, struct drm_ati_pcigart_info *ga
>  		page_base = (u32) entry->busaddr[i];
>  
>  		for (j = 0; j < (PAGE_SIZE / ATI_PCIGART_PAGE_SIZE); j++) {
> +			u32 val;
> +
>  			switch(gart_info->gart_reg_if) {
>  			case DRM_ATI_GART_IGP:
> -				*pci_gart = cpu_to_le32((page_base) | 0xc);
> +				val = page_base | 0xc;
>  				break;
>  			case DRM_ATI_GART_PCIE:
> -				*pci_gart = cpu_to_le32((page_base >> 8) | 0xc);
> +				val = (page_base >> 8) | 0xc;
>  				break;
>  			default:
>  			case DRM_ATI_GART_PCI:
> -				*pci_gart = cpu_to_le32(page_base);
> +				val = page_base;
>  				break;
>  			}
> -			pci_gart++;
> +			if (gart_info->gart_table_location ==
> +			    DRM_ATI_GART_MAIN)
> +				pci_gart[gart_idx] = cpu_to_le32(val);
> +			else
> +				DRM_WRITE32(map, gart_idx * sizeof(u32), val);
> +			gart_idx++;
>  			page_base += ATI_PCIGART_PAGE_SIZE;
>  		}
>  	}

