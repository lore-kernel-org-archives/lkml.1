Return-Path: <linux-kernel-owner+w=401wt.eu-S1753168AbZG2G2F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168AbZG2G2F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 02:28:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752769AbZG2G2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 02:28:05 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:40631 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707AbZG2G2D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 02:28:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CSrUjyv1QGOCV/8KxhltUWVtAtGv+iE9XyfvXf0Dcfqs+gxWygKHRF0bkiPHFHlI7b
         tg4prn0ovWt4BL9a3+qcYKRT3vUmCsCm4Em0gkYlWhO0vJTg43v1h7KUCZW4X6R4/N6e
         LXZGvgMH2FREvn5CNXEAOWQvnmJatFK+8JEkM=
MIME-Version: 1.0
In-Reply-To: <1248707041.6100.35.camel@macbook.infradead.org>
References: <1248707041.6100.35.camel@macbook.infradead.org>
Date: Wed, 29 Jul 2009 16:28:02 +1000
Message-ID: <21d7e9970907282328l4a44b9a2of4500c5c84a3586b@mail.gmail.com>
Subject: Re: [RFC] Make AGP work with IOMMU
From: Dave Airlie <airlied@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Zhenyu Wang <zhenyu.z.wang@intel.com>, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, Joerg Roedel <joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Based on some patches from Zhenyu that I found at
> http://people.freedesktop.org/~zhen/agp-mm-*, this set of patches stops
> the Intel graphics drivers from being utterly broken when the IOMMU is
> enabled...
>
>        http://git.infradead.org/users/dwmw2/iommu-agp.git
>
> I'm still seeing write faults to seemingly random addresses at startup
> when I first enable the IOMMU (and before the gfx driver actually
> starts). Those happen even when I don't use any graphics drivers at all,
> though.
>
> And I'm slightly confused about the way we use the scratch page without
> mask_memory().

Looks good, some comments below:

> commit d8450c7be46afd0b51d2dc171c9d2eb60366ce05
> Author: Zhenyu Wang <zhenyu.z.wang@intel.com>
> Date:   Mon Jul 27 12:59:57 2009 +0100
>
>    intel_agp: Use PCI DMA API correctly on chipsets new enough to have IOMMU
>
>    When graphics dma remapping engine is active, we must fill
>    gart table with dma address from dmar engine, as now graphics
>    device access to graphics memory must go through dma remapping
>    table to get real physical address.
>
>    Add this support to all drivers which use intel_i915_insert_entries()
>
>    Signed-off-by: Zhenyu Wang <zhenyu.z.wang@intel.com>
>    Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
>
> commit ca8cdb1f983c508f586b90870703e85aab87659a
> Author: Zhenyu Wang <zhenyu.z.wang@intel.com>
> Date:   Thu Jul 23 17:25:49 2009 +0100
>
>    agp: Add generic support for graphics dma remapping
>
>    New driver hooks for support graphics memory dma remapping
>    are introduced in this patch. It makes generic code can
>    tell if current device needs dma remapping, then call driver
>    provided interfaces for mapping and unmapping. Change has
>    also been made to handle scratch_page in remapping case.
>
>    Signed-off-by: Zhenyu Wang <zhenyu.z.wang@intel.com>
>    Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
>
> commit 42a509b9cd513ddd536c38cc302c7457a3c811d7
> Author: David Woodhouse <David.Woodhouse@intel.com>
> Date:   Mon Jul 27 10:27:29 2009 +0100
>
>    agp: Switch mask_memory() method to take address argument again, not page
>
>    In commit 07613ba2 ("agp: switch AGP to use page array instead of
>    unsigned long array") we switched the mask_memory() method to take a
>    'struct page *' instead of an address. This is painful, because in some
>    cases it has to be an IOMMU-mapped virtual bus address (in fact,
>    shouldn't it _always_ be a dma_addr_t returned from pci_map_xxx(), and
>    we just happen to get lucky most of the time?)

Yup pretty much we always got lucky, its not like AGP and IOMMU systems
are a huge item, its really only Intel IGPs which use the AGP
subsystem these days.

>


>  struct agp_bridge_data *agp_generic_find_bridge(struct pci_dev *pdev);
> diff --git a/drivers/char/agp/amd-k7-agp.c b/drivers/char/agp/amd-k7-agp.c
> index ba9bde7..542a878 100644
> --- a/drivers/char/agp/amd-k7-agp.c
> +++ b/drivers/char/agp/amd-k7-agp.c
> @@ -325,7 +325,9 @@ static int amd_insert_memory(struct agp_memory *mem, off_t pg_start, int type)
>                addr = (j * PAGE_SIZE) + agp_bridge->gart_bus_addr;
>                cur_gatt = GET_GATT(addr);
>                writel(agp_generic_mask_memory(agp_bridge,
> -                       mem->pages[i], mem->type), cur_gatt+GET_GATT_OFF(addr));
> +                                              phys_to_gart(page_to_phys(mem->pages[i])),

don't suppose we want page_to_gart or is the double function nicer?

> diff --git a/drivers/char/agp/backend.c b/drivers/char/agp/backend.c
> index cfa5a64..19ac366 100644
> --- a/drivers/char/agp/backend.c
> +++ b/drivers/char/agp/backend.c
> @@ -150,8 +150,17 @@ static int agp_backend_initialize(struct agp_bridge_data *bridge)
>                }
>
>                bridge->scratch_page_real = phys_to_gart(page_to_phys(page));
> -               bridge->scratch_page =
> -                   bridge->driver->mask_memory(bridge, page, 0);
> +               bridge->scratch_page = bridge->driver->mask_memory(bridge,
> +                                          phys_to_gart(page_to_phys(page)), 0);
> +
> +               if (bridge->driver->agp_map_page &&
> +                   bridge->driver->agp_map_page(phys_to_virt(page_to_phys(page)),

and maybe page_to_virt.

>
> +#ifdef USE_PCI_DMA_API
> +static int intel_agp_map_page(void *addr, dma_addr_t *ret)
> +{
> +       *ret = pci_map_single(intel_private.pcidev, addr,
> +                             PAGE_SIZE, PCI_DMA_BIDIRECTIONAL);
> +       if (pci_dma_mapping_error(intel_private.pcidev, *ret))
> +               return -EINVAL;
> +       return 0;
> +}
> +
> +static void intel_agp_unmap_page(void *addr, dma_addr_t dma)
> +{
> +       pci_unmap_single(intel_private.pcidev, dma,
> +                        PAGE_SIZE, PCI_DMA_BIDIRECTIONAL);
> +}
> +
> +static int intel_agp_map_memory(struct agp_memory *mem)
> +{
> +       struct scatterlist *sg;
> +       int i;
> +
> +       DBG("try mapping %lu pages\n", (unsigned long)mem->page_count);
> +
> +       if ((mem->page_count * sizeof(*mem->sg_list)) < 2*PAGE_SIZE)
> +               mem->sg_list = kcalloc(mem->page_count, sizeof(*mem->sg_list),
> +                                      GFP_KERNEL);
> +
> +       if (mem->sg_list == NULL) {
> +               mem->sg_list = vmalloc(mem->page_count * sizeof(*mem->sg_list));
> +               mem->sg_vmalloc_flag = 1;

Can we drop vmalloc_flag and use is_vmalloc_addr on the free function?

(aside: yet another place that wants a kmalloc/vmalloc allocator. I suspect
vmalloc here to be slow but I suppose there isn't much we can do.)

> +       }
> +
> +       if (!mem->sg_list) {
> +               mem->sg_vmalloc_flag = 0;
> +               return -ENOMEM;
> +       }
> +       sg_init_table(mem->sg_list, mem->page_count);
> +
> +       sg = mem->sg_list;
> +       for (i = 0 ; i < mem->page_count; i++, sg = sg_next(sg))
> +               sg_set_page(sg, mem->pages[i], PAGE_SIZE, 0);
> +
> +       mem->num_sg = pci_map_sg(intel_private.pcidev, mem->sg_list,
> +                                mem->page_count, PCI_DMA_BIDIRECTIONAL);
> +       if (!mem->num_sg) {
> +               if (mem->sg_vmalloc_flag)
> +                       vfree(mem->sg_list);
> +               else
> +                       kfree(mem->sg_list);
> +               mem->sg_list = NULL;
> +               mem->sg_vmalloc_flag = 0;

some common cleanup function?

> +               return -ENOMEM;
> +       }
> +       return 0;
> +}
> +
> +static void intel_agp_unmap_memory(struct agp_memory *mem)
> +{
> +       DBG("try unmapping %lu pages\n", (unsigned long)mem->page_count);
> +
> +       pci_unmap_sg(intel_private.pcidev, mem->sg_list,
> +                    mem->page_count, PCI_DMA_BIDIRECTIONAL);
> +       if (mem->sg_vmalloc_flag)
> +               vfree(mem->sg_list);
> +       else
> +               kfree(mem->sg_list);
> +       mem->sg_vmalloc_flag = 0;
> +       mem->sg_list = NULL;

since we reproduce it here.

Dave.
