Return-Path: <linux-kernel-owner+w=401wt.eu-S1765434AbYEHXpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765434AbYEHXpq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 19:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754099AbYEHXpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 19:45:35 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:36686 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753140AbYEHXpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 19:45:34 -0400
Subject: Re: [RFC][PATCH] x86 calgary: add fallback dma_ops]]
From: Alexis Bruemmer <alexisb@us.ibm.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, muli@il.ibm.com
In-Reply-To: <20080509081322J.tomof@acm.org>
References: <1210282820.6114.209.camel@alexis>
	 <20080509081322J.tomof@acm.org>
Content-Type: text/plain
Date: Thu, 08 May 2008 16:41:51 -0700
Message-Id: <1210290111.6114.214.camel@alexis>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-05-09 at 08:13 +0900, FUJITA Tomonori wrote:
> On Thu, 08 May 2008 14:40:20 -0700
> Alexis Bruemmer <alexisb@us.ibm.com> wrote:
> 
> > Currently the calgary code can give drivers addresses above 4GB which is
> > very bad for hardware that is only 32bit DMA addressable.  This patch
> > "teaches" calgary to fallback to the appropriate dma_ops when it
> > encounters a device/bus which is not behind the Calgary/CalIOC2.  I
> > believe there is a better way to do this and am open for ideas, but for
> > now this certainly fixes the badness.
> 
> I'm not sure that I correctly understand what you want. You mean that
> the Calgary IOMMU code ignores device's dma_mask and gives addresses
> above 4GB or the Calgary IOMMU code wrongly handles devices that are
> not behind the Calgary?
The real issue is the latter-- the Calgary IOMMU code does not properly
handle devices that are not behind the Calgary/CalIO2.
> 
> If you refers to the former problem, other IOMMU implementations do
> something like this.
> 
> 
> diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
> index e28ec49..2a977bc 100644
> --- a/arch/x86/kernel/pci-calgary_64.c
> +++ b/arch/x86/kernel/pci-calgary_64.c
> @@ -268,21 +268,37 @@ static unsigned long iommu_range_alloc(struct device *dev,
>  {
>  	unsigned long flags;
>  	unsigned long offset;
> +	unsigned long limit;
>  	unsigned long boundary_size;
> +	unsigned long start;
> +	unsigned long mask;
> 
>  	boundary_size = ALIGN(dma_get_seg_boundary(dev) + 1,
>  			      PAGE_SIZE) >> PAGE_SHIFT;
> 
>  	BUG_ON(npages == 0);
> 
> +	if (dev->dma_mask)
> +		mask = *dev->dma_mask >> PAGE_SHIFT;
> +	else
> +		mask = 0xfffffffful >> PAGE_SHIFT;
> +
> +	limit = tbl->it_size;
> +	start = tbl->it_hint;
> +
> +	if (limit > mask) {
> +		limit = mask + 1;
> +		start = tbl->it_hint & mask;
> +	}
> +
>  	spin_lock_irqsave(&tbl->it_lock, flags);
> 
> -	offset = iommu_area_alloc(tbl->it_map, tbl->it_size, tbl->it_hint,
> +	offset = iommu_area_alloc(tbl->it_map, limit, start,
>  				  npages, 0, boundary_size, 0);
>  	if (offset == ~0UL) {
>  		tbl->chip_ops->tce_cache_blast(tbl);
> 
> -		offset = iommu_area_alloc(tbl->it_map, tbl->it_size, 0,
> +		offset = iommu_area_alloc(tbl->it_map, limit, 0,
>  					  npages, 0, boundary_size, 0);
>  		if (offset == ~0UL) {
>  			printk(KERN_WARNING "Calgary: IOMMU full.\n");

