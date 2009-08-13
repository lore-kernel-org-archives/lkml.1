Return-Path: <linux-kernel-owner+w=401wt.eu-S1753318AbZHMHDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318AbZHMHDX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 03:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753278AbZHMHDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 03:03:21 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:43550 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244AbZHMHDT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 03:03:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AaMIAsm6B9KqJAzpcC7cV66hW+L0QHEcvU1sjOffAQ/LMdiyolIKnAMWFoLeaulJCC
         /pBdKr+dP7Nz0652DdM/U6GXkQmZVfwXBRDqJrWDUS+hg81w9ppj/BZJ6bnP1h9oo9EC
         RBXTCKkQTh/QvWWpRT30gIWVGznbekPsfpxf0=
MIME-Version: 1.0
In-Reply-To: <20090813155118P.fujita.tomonori@lab.ntt.co.jp>
References: <20090812181722.GA32653@linux-os.sc.intel.com>
	 <20090813132845R.fujita.tomonori@lab.ntt.co.jp>
	 <3877989d0908122248s4212ef95w7606a4dca5c7a855@mail.gmail.com>
	 <20090813155118P.fujita.tomonori@lab.ntt.co.jp>
Date: Thu, 13 Aug 2009 15:03:20 +0800
Message-ID: <3877989d0908130003i295cc7f2q343ad2446d0d51ff@mail.gmail.com>
Subject: Re: [RFC patch] init default dma_ops to prepare intel_iommu_init 
	failure
From: Luming Yu <luming.yu@gmail.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: fenghua.yu@intel.com, dwmw2@infradead.org, tony.luck@intel.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for another workaround, we should be working on deleting wrong
assumption of"iommu_deteced == iommu working", Not just workaround. My
patch could break something.. but it is just a start towards right
goal..

On Thu, Aug 13, 2009 at 2:52 PM, FUJITA
Tomonori<fujita.tomonori@lab.ntt.co.jp> wrote:
> On Thu, 13 Aug 2009 13:48:45 +0800
> Luming Yu <luming.yu@gmail.com> wrote:
>
>> >>
>> >> This check can not be removed. Otherwise, swiotlb_dma_ops will always override
>> >> previous dma_ops value.
>> >
>> > Yeah.
>>
>> I think pci_swiotlb_init needs to be cleaned up for both x86_{32,64} and ia64.
>> it should be used to init default dma_ops, and the call site of it should be
>> as early as platform_dma_init in mem_init. SInce swiotlb_dma_ops is pitched as
>> default dma_ops for x86, ia64, we really don't need to let pci_swiotlb_init
>> know iommu_deteced, dmar_disabled or iommu_passthrough...and anything
>> like that..
>> Please note the major wrong assumption of the current implementation is
>> "iommu_deteced == iommu working" that I was trying to fix.
>
> How about this?
>
> You can work around that assumption, I guess.
>
>
> diff --git a/arch/ia64/kernel/pci-dma.c b/arch/ia64/kernel/pci-dma.c
> index f6b1ff0..48caafa 100644
> --- a/arch/ia64/kernel/pci-dma.c
> +++ b/arch/ia64/kernel/pci-dma.c
> @@ -20,6 +20,8 @@
>
>  #include <asm/page.h>
>
> +extern int swiotlb_late_init_with_default_size (size_t size);
> +
>  dma_addr_t bad_dma_address __read_mostly;
>  EXPORT_SYMBOL(bad_dma_address);
>
> @@ -44,11 +46,25 @@ struct device fallback_dev = {
>  };
>
>  extern struct dma_map_ops intel_dma_ops;
> +extern struct dma_map_ops swiotlb_dma_ops;
>
>  static int __init pci_iommu_init(void)
>  {
> -       if (iommu_detected)
> -               intel_iommu_init();
> +       int ret;
> +
> +       if (iommu_detected) {
> +               ret = intel_iommu_init();
> +               if (ret) {
> +#ifdef CONFIG_IA64_GENERIC
> +                       dma_ops = &swiotlb_dma_ops;
> +                       if (swiotlb_late_init_with_default_size(64 * (1<<20)))
> +                               panic("failed to initialize swiotlb");
> +                       machvec_init("dig");
> +#else
> +                       panic("Unable to find Intel IOMMU");
> +#endif
> +               }
> +       }
>
>        return 0;
>  }
>
