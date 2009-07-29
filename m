Return-Path: <linux-kernel-owner+w=401wt.eu-S1751750AbZG2HPQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750AbZG2HPQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 03:15:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751076AbZG2HPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 03:15:15 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51166 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbZG2HPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 03:15:14 -0400
Subject: Re: [RFC] Make AGP work with IOMMU
From: David Woodhouse <dwmw2@infradead.org>
To: Dave Airlie <airlied@gmail.com>
Cc: Zhenyu Wang <zhenyu.z.wang@intel.com>, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, Joerg Roedel <joerg.roedel@amd.com>
In-Reply-To: <21d7e9970907282328l4a44b9a2of4500c5c84a3586b@mail.gmail.com>
References: <1248707041.6100.35.camel@macbook.infradead.org>
	 <21d7e9970907282328l4a44b9a2of4500c5c84a3586b@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 29 Jul 2009 08:15:12 +0100
Message-Id: <1248851712.19733.214.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-29 at 16:28 +1000, Dave Airlie wrote:
> Yup pretty much we always got lucky, its not like AGP and IOMMU systems
> are a huge item, its really only Intel IGPs which use the AGP
> subsystem these days.

Ah, really? One thing which was bothering me was what happens when I use
non-onboard graphics in one of these beasts -- are individual gfx
drivers going to need to be fixed too?

> >                cur_gatt = GET_GATT(addr);
> >                writel(agp_generic_mask_memory(agp_bridge,
> > -                       mem->pages[i], mem->type), cur_gatt+GET_GATT_OFF(addr));
> > +                                              phys_to_gart(page_to_phys(mem->pages[i])),
> 
> don't suppose we want page_to_gart or is the double function nicer?

I pondered that briefly. But then observed that phys_to_gart() and
gart_to_phys() _always_ describe an identity mapping, so perhaps they
could just be ditched completely?

> > @@ -150,8 +150,17 @@ static int agp_backend_initialize(struct agp_bridge_data *bridge)
> >                }
> >
> >                bridge->scratch_page_real = phys_to_gart(page_to_phys(page));
> > -               bridge->scratch_page =
> > -                   bridge->driver->mask_memory(bridge, page, 0);
> > +               bridge->scratch_page = bridge->driver->mask_memory(bridge,
> > +                                          phys_to_gart(page_to_phys(page)), 0);
> > +
> > +               if (bridge->driver->agp_map_page &&
> > +                   bridge->driver->agp_map_page(phys_to_virt(page_to_phys(page)),
> 
> and maybe page_to_virt.

That's called page_address(), and it (as well as the above construct) is
broken with highmem pages. It's actually OK here, since this page is
allocated with GFP_DMA32 -- but for cleanliness' sake I should probably
switch agp_map_page() to take a 'struct page *' rather than a virtual
address.

> > +       if ((mem->page_count * sizeof(*mem->sg_list)) < 2*PAGE_SIZE)
> > +               mem->sg_list = kcalloc(mem->page_count, sizeof(*mem->sg_list),
> > +                                      GFP_KERNEL);
> > +
> > +       if (mem->sg_list == NULL) {
> > +               mem->sg_list = vmalloc(mem->page_count * sizeof(*mem->sg_list));
> > +               mem->sg_vmalloc_flag = 1;
> 
> Can we drop vmalloc_flag and use is_vmalloc_addr on the free function?

I suppose so -- we could eliminate the other vmalloc_flag field in
'struct agp_memory' that way too? Doesn't shrink the structure any --
we'd just end up with padding where the flags were.

> (aside: yet another place that wants a kmalloc/vmalloc allocator. I suspect
> vmalloc here to be slow but I suppose there isn't much we can do.)

http://lwn.net/Articles/342915/ ?

In fact, can't scatterlists do something like that already?

> > +       mem->num_sg = pci_map_sg(intel_private.pcidev, mem->sg_list,
> > +                                mem->page_count, PCI_DMA_BIDIRECTIONAL);
> > +       if (!mem->num_sg) {
> > +               if (mem->sg_vmalloc_flag)
> > +                       vfree(mem->sg_list);
> > +               else
> > +                       kfree(mem->sg_list);
> > +               mem->sg_list = NULL;
> > +               mem->sg_vmalloc_flag = 0;
> 
> some common cleanup function?
 ...
> since we reproduce it here.

Yeah, probably a good idea.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

