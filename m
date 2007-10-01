Return-Path: <linux-kernel-owner+w=401wt.eu-S1754553AbXJAQSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553AbXJAQSW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 12:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751985AbXJAQSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 12:18:14 -0400
Received: from mga02.intel.com ([134.134.136.20]:5916 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453AbXJAQSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 12:18:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,217,1188802800"; 
   d="scan'208";a="237006743"
Date: Mon, 1 Oct 2007 09:12:56 -0700
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
To: FUJITA Tomonori <tomof@acm.org>
Cc: akpm@linux-foundation.org,
       "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH -mm] intel-iommu sg chaining support
Message-ID: <20071001161256.GA28998@askeshav-devel.jf.intel.com>
Reply-To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
References: <20070929125638W.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070929125638W.tomof@acm.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 29, 2007 at 05:16:38AM -0700, FUJITA Tomonori wrote:
> 
>    x86_64 defines ARCH_HAS_SG_CHAIN. So if IOMMU implementations don't
>    support sg chaining, we will get data corruption.
>    Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Acked-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>

>    ---
>     drivers/pci/intel-iommu.c |   32 ++++++++++++++++----------------
>     1 files changed, 16 insertions(+), 16 deletions(-)
>    diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
>    index dab329f..4668995 100644
>    --- a/drivers/pci/intel-iommu.c
>    +++ b/drivers/pci/intel-iommu.c
>    @@ -1963,7 +1963,7 @@ static void intel_free_coherent(struct device *hwdev,
>    size_t size,
>     }
>     #define  SG_ENT_VIRT_ADDRESS(sg)         (page_address((sg)->page)  +
>    (sg)->offset)
>    -static void intel_unmap_sg(struct device *hwdev, struct scatterlist *sg,
>    +static  void  intel_unmap_sg(struct device *hwdev, struct scatterlist
>    *sglist,
>            int nelems, int dir)
>     {
>            int i;
>    @@ -1973,16 +1973,17 @@ static void intel_unmap_sg(struct device *hwdev,
>    struct scatterlist *sg,
>            struct iova *iova;
>            size_t size = 0;
>            void *addr;
>    +       struct scatterlist *sg;
>            if (pdev->sysdata == DUMMY_DEVICE_DOMAIN_INFO)
>                    return;
>            domain = find_domain(pdev);
>    -       iova = find_iova(&domain->iovad, IOVA_PFN(sg[0].dma_address));
>    +       iova = find_iova(&domain->iovad, IOVA_PFN(sglist[0].dma_address));
>            if (!iova)
>                    return;
>    -       for (i = 0; i < nelems; i++, sg++) {
>    +       for_each_sg(sglist, sg, nelems, i) {
>                    addr = SG_ENT_VIRT_ADDRESS(sg);
>                    size += aligned_size((u64)addr, sg->length);
>            }
>    @@ -2003,20 +2004,20 @@ static void intel_unmap_sg(struct device *hwdev,
>    struct scatterlist *sg,
>     }
>     static int intel_nontranslate_map_sg(struct device *hddev,
>    -       struct scatterlist *sg, int nelems, int dir)
>    +       struct scatterlist *sglist, int nelems, int dir)
>     {
>            int i;
>    +       struct scatterlist *sg;
>    -       for (i = 0; i < nelems; i++) {
>    -               struct scatterlist *s = &sg[i];
>    -               BUG_ON(!s->page);
>    -               s->dma_address = virt_to_bus(SG_ENT_VIRT_ADDRESS(s));
>    -               s->dma_length = s->length;
>    +       for_each_sg(sglist, sg, nelems, i) {
>    +               BUG_ON(!sg->page);
>    +               sg->dma_address = virt_to_bus(SG_ENT_VIRT_ADDRESS(sg));
>    +               sg->dma_length = sg->length;
>            }
>            return nelems;
>     }
>    -static int intel_map_sg(struct device *hwdev, struct scatterlist *sg,
>    +static int intel_map_sg(struct device *hwdev, struct scatterlist *sglist,
>            int nelems, int dir)
>     {
>            void *addr;
>    @@ -2028,18 +2029,18 @@ static int intel_map_sg(struct device *hwdev, struct
>    scatterlist *sg,
>            size_t offset = 0;
>            struct iova *iova = NULL;
>            int ret;
>    -       struct scatterlist *orig_sg = sg;
>    +       struct scatterlist *sg;
>            unsigned long start_addr;
>            BUG_ON(dir == DMA_NONE);
>            if (pdev->sysdata == DUMMY_DEVICE_DOMAIN_INFO)
>    -               return intel_nontranslate_map_sg(hwdev, sg, nelems, dir);
>    +               return intel_nontranslate_map_sg(hwdev, sglist, nelems,
>    dir);
>            domain = get_valid_domain_for_dev(pdev);
>            if (!domain)
>                    return 0;
>    -       for (i = 0; i < nelems; i++, sg++) {
>    +       for_each_sg(sglist, sg, nelems, i) {
>                    addr = SG_ENT_VIRT_ADDRESS(sg);
>                    addr = (void *)virt_to_phys(addr);
>                    size += aligned_size((u64)addr, sg->length);
>    @@ -2047,7 +2048,7 @@ static int intel_map_sg(struct device *hwdev, struct
>    scatterlist *sg,
>            iova = __intel_alloc_iova(hwdev, domain, size);
>            if (!iova) {
>    -               orig_sg->dma_length = 0;
>    +               sglist->dma_length = 0;
>                    return 0;
>            }
>    @@ -2063,8 +2064,7 @@ static int intel_map_sg(struct device *hwdev, struct
>    scatterlist *sg,
>            start_addr = iova->pfn_lo << PAGE_SHIFT_4K;
>            offset = 0;
>    -       sg = orig_sg;
>    -       for (i = 0; i < nelems; i++, sg++) {
>    +       for_each_sg(sglist, sg, nelems, i) {
>                    addr = SG_ENT_VIRT_ADDRESS(sg);
>                    addr = (void *)virt_to_phys(addr);
>                    size = aligned_size((u64)addr, sg->length);
>    --
>    1.5.2.4
