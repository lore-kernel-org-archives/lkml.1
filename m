Return-Path: <linux-kernel-owner+w=401wt.eu-S934487AbZKXX4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934487AbZKXX4Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 18:56:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934450AbZKXX4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 18:56:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:38782 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934444AbZKXX4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 18:56:15 -0500
Message-ID: <4B0C7257.3070609@kernel.org>
Date: Tue, 24 Nov 2009 15:55:03 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] x86: fix iommu=soft boot option
References: <20091125084611O.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20091125084611O.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> "x86: Handle HW IOMMU initialization failure gracefully" patchset
> handled this option properly however somehow I broke it during cleanup
> after that. Sorry.
> 
> =
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH -tip] x86: fix iommu=soft boot option
> 
> iommu=soft boot option forces the kernel to use swiotlb.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  arch/x86/kernel/pci-swiotlb.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/pci-swiotlb.c b/arch/x86/kernel/pci-swiotlb.c
> index e36e71d..e3c0a66 100644
> --- a/arch/x86/kernel/pci-swiotlb.c
> +++ b/arch/x86/kernel/pci-swiotlb.c
> @@ -50,6 +50,8 @@ static struct dma_map_ops swiotlb_dma_ops = {
>   */
>  int __init pci_swiotlb_init(void)
>  {
> +	int use_swiotlb = swiotlb | swiotlb_force;
> +
>  	/* don't initialize swiotlb if iommu=off (no_iommu=1) */
>  #ifdef CONFIG_X86_64
>  	if (!no_iommu && max_pfn > MAX_DMA32_PFN)
> @@ -63,5 +65,5 @@ int __init pci_swiotlb_init(void)
>  		dma_ops = &swiotlb_dma_ops;
>  	}
>  
> -	return swiotlb_force;
> +	return use_swiotlb;
>  }

before your cleanup patchset:
for AMD 64bit, MEM > 4g, no AGP, iommu=soft
1. if BIOS have correct gart setting, Kernel will use gart
2. if BIOS does not have correct gart setting, Kernel will use swiotlb

for AMD 64bit, MEM > 4g, no AGP, no "iommu=soft"
1. if BIOS have correct gart setting, Kernel will use gart
2. if BIOS does not have correct gart setting, Kernel will allocate some RAM, and set range in AMD NB, and use gart iommu

YH
