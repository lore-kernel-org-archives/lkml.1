Return-Path: <linux-kernel-owner+w=401wt.eu-S1758564AbZEKUcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758564AbZEKUcl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 16:32:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753953AbZEKUcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 16:32:32 -0400
Received: from gw.goop.org ([64.81.55.164]:58555 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752808AbZEKUcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 16:32:31 -0400
Message-ID: <4A088B48.1080900@goop.org>
Date: Mon, 11 May 2009 13:32:08 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Alex Nixon <alex.nixon@citrix.com>,
       Ian Campbell <Ian.Campbell@eu.citrix.com>
Subject: Re: [PATCH 07/11] Xen/x86/PCI: Add support for the Xen PCI subsytem
References: <1241732737-7669-1-git-send-email-jeremy@goop.org> <1241732737-7669-8-git-send-email-jeremy@goop.org> <20090511094025.GA30035@8bytes.org>
In-Reply-To: <20090511094025.GA30035@8bytes.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
>> +static inline int address_needs_mapping(struct device *hwdev,
>> +                                             dma_addr_t addr)
>> +{
>> +     dma_addr_t mask = 0xffffffff;
>>     
>
> You can use DMA_32BIT_MASK here.
>   

OK.  Well, DMA_BIT_MASK(32), since I think DMA_XXBIT_MASK are considered 
deprecated.

>> +     int ret;
>> +
>> +     /* If the device has a mask, use it, otherwise default to 32 bits */
>> +     if (hwdev && hwdev->dma_mask)
>> +             mask = *hwdev->dma_mask;
>>     
>
> I think the check for a valid hwdev->dma_mask is not necessary. Other
> IOMMU drivers also don't check for this.
>   

OK.

>> +
>> +static int range_straddles_page_boundary(phys_addr_t p, size_t size)
>> +{
>> +     unsigned long pfn = PFN_DOWN(p);
>> +     unsigned int offset = p & ~PAGE_MASK;
>> +
>> +     if (offset + size <= PAGE_SIZE)
>> +             return 0;
>>     
>
> You can use iommu_num_pages here from lib/iommu_helpers.c
>   

Ah, useful.  Hm, but iommu_num_pages() takes the addr as an unsigned 
long, which will fail on a 32-bit machine with a 64-bit phys addr.

>> +static int xen_map_sg(struct device *hwdev, struct scatterlist *sg,
>> +                     int nents, int direction)
>> +{
>> +     struct scatterlist *s;
>> +     struct page *page;
>> +     int i, rc;
>> +
>> +     BUG_ON(direction == DMA_NONE);
>> +     WARN_ON(nents == 0 || sg[0].length == 0);
>> +
>> +     for_each_sg(sg, s, nents, i) {
>> +             BUG_ON(!sg_page(s));
>> +             page = sg_page(s);
>> +             s->dma_address = xen_dma_map_page(page) + s->offset;
>> +             s->dma_length = s->length;
>> +             IOMMU_BUG_ON(range_straddles_page_boundary(
>> +                             page_to_phys(page), s->length));
>>     
>
> I have a question on this. How do you make sure that the memory to map
> does not cross page boundarys? I have a stats counter for x-page
> requests in amd iommu code and around 10% of the requests are actually
> x-page for me.
>   

I define a BIOVEC_PHYS_MERGEABLE() which prevents BIOs from being merged 
across non-contiguous pages.  Hm, wonder where that change has gone?  It 
should probably be part of this series...

>> +     }
>> +
>> +     rc = nents;
>> +
>> +     flush_write_buffers();
>> +     return rc;
>> +}
>> +
>> +static void xen_unmap_sg(struct device *hwdev, struct scatterlist *sg,
>> +                      int nents, int direction)
>> +{
>> +     struct scatterlist *s;
>> +     struct page *page;
>> +     int i;
>> +
>> +     for_each_sg(sg, s, nents, i) {
>> +             page = pfn_to_page(mfn_to_pfn(PFN_DOWN(s->dma_address)));
>> +             xen_dma_unmap_page(page);
>> +     }
>> +}
>> +
>> +static void *xen_alloc_coherent(struct device *dev, size_t size,
>> +                             dma_addr_t *dma_handle, gfp_t gfp)
>> +{
>> +     void *ret;
>> +     struct dma_coherent_mem *mem = dev ? dev->dma_mem : NULL;
>> +     unsigned int order = get_order(size);
>> +     unsigned long vstart;
>> +     u64 mask;
>> +
>> +     /* ignore region specifiers */
>> +     gfp &= ~(__GFP_DMA | __GFP_HIGHMEM);
>> +
>> +     if (mem) {
>> +             int page = bitmap_find_free_region(mem->bitmap, mem->size,
>> +                                                  order);
>>     
>
> Can you use iommu_area_alloc here?
>   

There's a later patch in this series ("xen/swiotlb: use 
dma_alloc_from_coherent to get device coherent memory") which converts 
it to use dma_alloc_from_coherent().   I think that's the right thing to 
use here, rather than iommu_area_alloc().

>> +static void xen_free_coherent(struct device *dev, size_t size,
>> +                      void *vaddr, dma_addr_t dma_addr)
>> +{
>> +     struct dma_coherent_mem *mem = dev ? dev->dma_mem : NULL;
>> +     int order = get_order(size);
>> +
>> +     if (mem && vaddr >= mem->virt_base &&
>> +         vaddr < (mem->virt_base + (mem->size << PAGE_SHIFT))) {
>> +             int page = (vaddr - mem->virt_base) >> PAGE_SHIFT;
>> +             bitmap_release_region(mem->bitmap, page, order);
>>     
>
> iommu_area_free
>   

I use dma_release_from_coherent() in the later patch.

Thanks,
    J
