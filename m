Return-Path: <linux-kernel-owner+w=401wt.eu-S1753619AbZGWHKL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619AbZGWHKL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 03:10:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbZGWHKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 03:10:11 -0400
Received: from sh.osrg.net ([192.16.179.4]:53422 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752626AbZGWHKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 03:10:09 -0400
Date: Thu, 23 Jul 2009 16:09:49 +0900
To: beckyb@kernel.crashing.org
Cc: fujita.tomonori@lab.ntt.co.jp, linuxppc-dev@lists.ozlabs.org,
       benh@kernel.crashing.org, galak@kernel.crashing.org,
       linux-kernel@vger.kernel.org
Subject: Re: removing addr_needs_map in struct dma_mapping_ops
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <79B7CF70-0A66-43DA-91ED-3C8638FED141@kernel.crashing.org>
References: <B6C36B32-6861-4FD9-B8A3-E8C328687E0F@kernel.crashing.org>
	<20090714094919V.fujita.tomonori@lab.ntt.co.jp>
	<79B7CF70-0A66-43DA-91ED-3C8638FED141@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090723160855S.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 23 Jul 2009 16:09:50 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jul 2009 18:59:03 -0500
Becky Bruce <beckyb@kernel.crashing.org> wrote:

> 
> On Jul 13, 2009, at 7:49 PM, FUJITA Tomonori wrote:
> 
> > On Mon, 13 Jul 2009 16:50:43 -0500
> > Becky Bruce <beckyb@kernel.crashing.org> wrote:
> >
> >>> talked about defining something like struct dma_data. Then we could
> >>>
> >>> struct dev_archdata {
> >>>     ...
> >>>
> >>>     struct dma_data *ddata;
> >>> };
> >>>
> >>> or
> >>>
> >>> struct dev_archdata {
> >>>     ...
> >>>
> >>>     struct dma_data ddata;
> >>> };
> >>>
> >>>
> >>> struct dma_data needs dma_direct_offset, iommu_table, dma_base, and
> >>> dma_window_size, anything else?
> >>
> >> IIRC, what we had talked about was simpler - we talked about changing
> >> the current dev_archdata from this:
> >>
> >> struct dev_archdata {
> >>        struct device_node      *of_node;
> >>        struct dma_mapping_ops  *dma_ops;
> >>        void                    *dma_data;
> >> };
> >>
> >> to this:
> >>
> >> struct dev_archdata {
> >> 	struct device_node *of_node;
> >> 	struct dma_mapping_ops *dma_ops;
> >> 	unsigned long long dma_data;
> >> #ifdef CONFIG_SWIOTLB
> >> 	dma_addr_t max_direct_dma_addr;
> >> #endif
> >> };
> >>
> >> Where max_direct_dma_addr is the address beyond which a specific
> >> device must use swiotlb, and dma_data is the offset like it is now
> >> (but wider on 32-bit systems than void *). I believe Ben had  
> >> mentioned
> >> wanting to make the max_direct_dma_addr part conditional so we don't
> >> bloat archdata on platforms that don't ever bounce.
> >
> > Only maximum address is enough? The minimum (dma_window_base_cur in
> > swiotlb_pci_addr_needs_map) is not necessary?
> >
> >
> >> The change to the type of dma_data is actually in preparation for an
> >> optimization I have planned for 64-bit PCI devices (and which  
> >> probably
> >> requires more discussion), so that doesn't need to happen now -  just
> >> leave it as a void *, and I can post a followup patch.
> >>
> >> Let me know if I can help or do any testing - I've been meaning to
> >> look into switching to dma_map_ops for a while now but it hasn't
> >> managed to pop off my todo stack.
> >
> > Ok, how about this? I'm not familiar with POWERPC so I might
> > misunderstand something.
> 
> This is close, but it misses the setup for non-pci devices. We have a  
> bus notifier that we use to set up archdata for those devices -   
> ppc_swiotlb_bus_notify() in arch/powerpc/kernel/dma-swiotlb.c.  It  
> won't cause breakage to not have this set up, because those will fall  
> through to the dma_capable(), but I think we should initialize it  
> anyway (who knows what it will end up used for later....).

You mean that you like to initialize max_direct_dma_addr to zero
explicitly in ppc_swiotlb_bus_notify()?


> > diff --git a/arch/powerpc/include/asm/device.h b/arch/powerpc/ 
> > include/asm/device.h
> > index 7d2277c..0086f8d 100644
> > --- a/arch/powerpc/include/asm/device.h
> > +++ b/arch/powerpc/include/asm/device.h
> > @@ -16,6 +16,9 @@ struct dev_archdata {
> > 	/* DMA operations on that device */
> > 	struct dma_mapping_ops	*dma_ops;
> > 	void			*dma_data;
> > +#ifdef CONFIG_SWIOTLB
> > +	dma_addr_t		max_direct_dma_addr;
> > +#endif
> > };
> >
> > static inline void dev_archdata_set_node(struct dev_archdata *ad,
> > diff --git a/arch/powerpc/include/asm/swiotlb.h b/arch/powerpc/ 
> > include/asm/swiotlb.h
> > index 30891d6..b23a4f1 100644
> > --- a/arch/powerpc/include/asm/swiotlb.h
> > +++ b/arch/powerpc/include/asm/swiotlb.h
> > @@ -24,4 +24,6 @@ static inline void dma_mark_clean(void *addr,  
> > size_t size) {}
> > extern unsigned int ppc_swiotlb_enable;
> > int __init swiotlb_setup_bus_notifier(void);
> >
> > +extern void pci_dma_dev_setup_swiotlb(struct pci_dev *pdev);
> > +
> > #endif /* __ASM_SWIOTLB_H */
> > diff --git a/arch/powerpc/kernel/dma-swiotlb.c b/arch/powerpc/kernel/ 
> > dma-swiotlb.c
> > index 68ccf11..e21359e 100644
> > --- a/arch/powerpc/kernel/dma-swiotlb.c
> > +++ b/arch/powerpc/kernel/dma-swiotlb.c
> > @@ -56,39 +56,16 @@ swiotlb_arch_address_needs_mapping(struct device  
> > *hwdev, dma_addr_t addr,
> > 				   size_t size)
> > {
> > 	struct dma_mapping_ops *dma_ops = get_dma_ops(hwdev);
> > +	struct dev_archdata *sd = &hwdev->archdata;
> >
> > 	BUG_ON(!dma_ops);
> > -	return dma_ops->addr_needs_map(hwdev, addr, size);
> > -}
> 
> You can get rid of the dma_ops stuff here.... it's no longer needed.

Yeah, I'll do later in this patchset that converts POWERPC to use
dma_map_ops structure; this is the first patch of the patchset.


> > - * Determine if an address is reachable by a pci device, or if we  
> > must bounce.
> > - */
> > -static int
> > -swiotlb_pci_addr_needs_map(struct device *hwdev, dma_addr_t addr,  
> > size_t size)
> > -{
> > -	u64 mask = dma_get_mask(hwdev);
> > -	dma_addr_t max;
> > -	struct pci_controller *hose;
> > -	struct pci_dev *pdev = to_pci_dev(hwdev);
> > -
> > -	hose = pci_bus_to_host(pdev->bus);
> > -	max = hose->dma_window_base_cur + hose->dma_window_size;
> > -
> > -	/* check that we're within mapped pci window space */
> > -	if ((addr + size > max) | (addr < hose->dma_window_base_cur))
> > +	if (sd->max_direct_dma_addr && addr + size > sd- 
> > >max_direct_dma_addr)
> > 		return 1;
> >
> > -	return !is_buffer_dma_capable(mask, addr, size);
> > -}
> > -
> > -static int
> > -swiotlb_addr_needs_map(struct device *hwdev, dma_addr_t addr,  
> > size_t size)
> > -{
> > 	return !is_buffer_dma_capable(dma_get_mask(hwdev), addr, size);
> > }
> >
> > -
> > /*
> >  * At the moment, all platforms that use this code only require
> >  * swiotlb to be used if we're operating on HIGHMEM.  Since
> > @@ -104,7 +81,6 @@ struct dma_mapping_ops swiotlb_dma_ops = {
> > 	.dma_supported = swiotlb_dma_supported,
> > 	.map_page = swiotlb_map_page,
> > 	.unmap_page = swiotlb_unmap_page,
> > -	.addr_needs_map = swiotlb_addr_needs_map,
> > 	.sync_single_range_for_cpu = swiotlb_sync_single_range_for_cpu,
> > 	.sync_single_range_for_device = swiotlb_sync_single_range_for_device,
> > 	.sync_sg_for_cpu = swiotlb_sync_sg_for_cpu,
> > @@ -119,13 +95,23 @@ struct dma_mapping_ops swiotlb_pci_dma_ops = {
> > 	.dma_supported = swiotlb_dma_supported,
> > 	.map_page = swiotlb_map_page,
> > 	.unmap_page = swiotlb_unmap_page,
> > -	.addr_needs_map = swiotlb_pci_addr_needs_map,
> > 	.sync_single_range_for_cpu = swiotlb_sync_single_range_for_cpu,
> > 	.sync_single_range_for_device = swiotlb_sync_single_range_for_device,
> > 	.sync_sg_for_cpu = swiotlb_sync_sg_for_cpu,
> > 	.sync_sg_for_device = swiotlb_sync_sg_for_device
> > };
> >
> > +void pci_dma_dev_setup_swiotlb(struct pci_dev *pdev)
> > +{
> > +	struct pci_controller *hose;
> > +	struct dev_archdata *sd;
> > +
> > +	hose = pci_bus_to_host(pdev->bus);
> > +	sd = &pdev->dev.archdata;
> > +	sd->max_direct_dma_addr =
> > +		hose->dma_window_base_cur + hose->dma_window_size;
> > +}
> > +
> > static int ppc_swiotlb_bus_notify(struct notifier_block *nb,
> > 				  unsigned long action, void *data)
> > {
> > diff --git a/arch/powerpc/platforms/85xx/mpc8536_ds.c b/arch/powerpc/ 
> > platforms/85xx/mpc8536_ds.c
> > index 055ff41..401751b 100644
> > --- a/arch/powerpc/platforms/85xx/mpc8536_ds.c
> > +++ b/arch/powerpc/platforms/85xx/mpc8536_ds.c
> > @@ -136,6 +136,7 @@ define_machine(mpc8536_ds) {
> > 	.init_IRQ		= mpc8536_ds_pic_init,
> > #ifdef CONFIG_PCI
> > 	.pcibios_fixup_bus	= fsl_pcibios_fixup_bus,
> > +	.pci_dma_dev_setup	= pci_dma_dev_setup_swiotlb,
> > #endif
> > 	.get_irq		= mpic_get_irq,
> > 	.restart		= fsl_rstcr_restart,
> > diff --git a/arch/powerpc/platforms/85xx/mpc85xx_ds.c b/arch/powerpc/ 
> > platforms/85xx/mpc85xx_ds.c
> > index 849c0ac..1ba8e38 100644
> > --- a/arch/powerpc/platforms/85xx/mpc85xx_ds.c
> > +++ b/arch/powerpc/platforms/85xx/mpc85xx_ds.c
> > @@ -277,6 +277,7 @@ define_machine(mpc8544_ds) {
> > 	.init_IRQ		= mpc85xx_ds_pic_init,
> > #ifdef CONFIG_PCI
> > 	.pcibios_fixup_bus	= fsl_pcibios_fixup_bus,
> > +	.pci_dma_dev_setup	= pci_dma_dev_setup_swiotlb,
> > #endif
> > 	.get_irq		= mpic_get_irq,
> > 	.restart		= fsl_rstcr_restart,
> > @@ -291,6 +292,7 @@ define_machine(mpc8572_ds) {
> > 	.init_IRQ		= mpc85xx_ds_pic_init,
> > #ifdef CONFIG_PCI
> > 	.pcibios_fixup_bus	= fsl_pcibios_fixup_bus,
> > +	.pci_dma_dev_setup	= pci_dma_dev_setup_swiotlb,
> > #endif
> > 	.get_irq		= mpic_get_irq,
> > 	.restart		= fsl_rstcr_restart,
> > @@ -305,6 +307,7 @@ define_machine(p2020_ds) {
> > 	.init_IRQ		= mpc85xx_ds_pic_init,
> > #ifdef CONFIG_PCI
> > 	.pcibios_fixup_bus	= fsl_pcibios_fixup_bus,
> > +	.pci_dma_dev_setup	= pci_dma_dev_setup_swiotlb,
> > #endif
> > 	.get_irq		= mpic_get_irq,
> > 	.restart		= fsl_rstcr_restart,
> > diff --git a/arch/powerpc/platforms/85xx/mpc85xx_mds.c b/arch/ 
> > powerpc/platforms/85xx/mpc85xx_mds.c
> > index 60ed9c0..165a2de 100644
> > --- a/arch/powerpc/platforms/85xx/mpc85xx_mds.c
> > +++ b/arch/powerpc/platforms/85xx/mpc85xx_mds.c
> > @@ -356,6 +356,7 @@ define_machine(mpc8568_mds) {
> > 	.progress	= udbg_progress,
> > #ifdef CONFIG_PCI
> > 	.pcibios_fixup_bus	= fsl_pcibios_fixup_bus,
> > +	.pci_dma_dev_setup	= pci_dma_dev_setup_swiotlb,
> > #endif
> > };
> >
> > @@ -377,5 +378,6 @@ define_machine(mpc8569_mds) {
> > 	.progress	= udbg_progress,
> > #ifdef CONFIG_PCI
> > 	.pcibios_fixup_bus	= fsl_pcibios_fixup_bus,
> > +	.pci_dma_dev_setup	= pci_dma_dev_setup_swiotlb,
> > #endif
> > };
> > diff --git a/arch/powerpc/platforms/86xx/mpc86xx_hpcn.c b/arch/ 
> > powerpc/platforms/86xx/mpc86xx_hpcn.c
> > index 6632702..d1878f3 100644
> > --- a/arch/powerpc/platforms/86xx/mpc86xx_hpcn.c
> > +++ b/arch/powerpc/platforms/86xx/mpc86xx_hpcn.c
> > @@ -187,5 +187,6 @@ define_machine(mpc86xx_hpcn) {
> > 	.progress		= udbg_progress,
> > #ifdef CONFIG_PCI
> > 	.pcibios_fixup_bus	= fsl_pcibios_fixup_bus,
> > +	.pci_dma_dev_setup	= pci_dma_dev_setup_swiotlb,
> > #endif
> > };
> 
> Instead of initializing this here (which has problems if ! 
> CONFIG_SWIOTLB),

Oops, I overlooked it.


> place this in the xxxxx_xxxx_setup_arch function in  
> the same files, which already have an #ifdef CONFIG_SWIOTLB in which  
> this can be embedded.

But the xxxxx_xxxx_setup_arch function doesn't access to each device
so we need to add something like for_each_pci_dev()? You prefer that?


> I'm about to be off-list for a few days but will be happy to help when  
> I'm back next week.

Thanks!
