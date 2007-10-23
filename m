Return-Path: <linux-kernel-owner+w=401wt.eu-S1753884AbXJWHeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884AbXJWHeQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 03:34:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751687AbXJWHeD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 03:34:03 -0400
Received: from brick.kernel.dk ([87.55.233.238]:24529 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751654AbXJWHeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 03:34:01 -0400
Date: Tue, 23 Oct 2007 09:32:36 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: torvalds@linux-foundation.org, anil.s.keshavamurthy@intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] intel-iommu: fix sg_page()
Message-ID: <20071023073236.GM25962@kernel.dk>
References: <20071023135926A.fujita.tomonori@lab.ntt.co.jp> <20071023050426.GJ16425@kernel.dk> <20071023141929B.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071023141929B.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23 2007, FUJITA Tomonori wrote:
> On Tue, 23 Oct 2007 07:04:27 +0200
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Tue, Oct 23 2007, FUJITA Tomonori wrote:
> > > drivers/pci/intel-iommu.c: In function 'intel_unmap_sg':
> > > drivers/pci/intel-iommu.c:1987: error: 'struct scatterlist' has no member named 'page'
> > > drivers/pci/intel-iommu.c: In function 'intel_nontranslate_map_sg':
> > > drivers/pci/intel-iommu.c:2013: error: 'struct scatterlist' has no member named 'page'
> > > drivers/pci/intel-iommu.c:2014: error: 'struct scatterlist' has no member named 'page'
> > > drivers/pci/intel-iommu.c: In function 'intel_map_sg':
> > > drivers/pci/intel-iommu.c:2044: error: 'struct scatterlist' has no member named 'page'
> > > drivers/pci/intel-iommu.c:2068: error: 'struct scatterlist' has no member named 'page'
> > > 
> > > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > > ---
> > >  drivers/pci/intel-iommu.c |   11 +++++------
> > >  1 files changed, 5 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
> > > index b3d7031..0f6e528 100644
> > > --- a/drivers/pci/intel-iommu.c
> > > +++ b/drivers/pci/intel-iommu.c
> > > @@ -1962,7 +1962,6 @@ static void intel_free_coherent(struct device *hwdev, size_t size,
> > >  	free_pages((unsigned long)vaddr, order);
> > >  }
> > >  
> > > -#define SG_ENT_VIRT_ADDRESS(sg)	(page_address((sg)->page) + (sg)->offset)
> > 
> > Thanks, though I preferred to just do the one-liner for the conversions.
> > Funny that I missed this file - ah seems it was merged yesterday as
> > well, it didn't exist in the current tree I was working against.
> 
> Yeah, the patchset has been -mm and was merged after the sg updates.
> 
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> 
> diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
> index b3d7031..a837d64 100644
> --- a/drivers/pci/intel-iommu.c
> +++ b/drivers/pci/intel-iommu.c
> @@ -1962,7 +1962,7 @@ static void intel_free_coherent(struct device *hwdev, size_t size,
>  	free_pages((unsigned long)vaddr, order);
>  }
>  
> -#define SG_ENT_VIRT_ADDRESS(sg)	(page_address((sg)->page) + (sg)->offset)
> +#define SG_ENT_VIRT_ADDRESS(sg)	sg_virt(sg)
>  static void intel_unmap_sg(struct device *hwdev, struct scatterlist *sglist,
>  	int nelems, int dir)
>  {
> @@ -2010,7 +2010,7 @@ static int intel_nontranslate_map_sg(struct device *hddev,
>  	struct scatterlist *sg;
>  
>  	for_each_sg(sglist, sg, nelems, i) {
> -		BUG_ON(!sg->page);
> +		BUG_ON(!sg_page(sg));
>  		sg->dma_address = virt_to_bus(SG_ENT_VIRT_ADDRESS(sg));
>  		sg->dma_length = sg->length;
>  	}

Great, applied this one.

-- 
Jens Axboe

