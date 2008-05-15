Return-Path: <linux-kernel-owner+w=401wt.eu-S1764895AbYEOUqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764895AbYEOUqQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 16:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751543AbYEOUqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 16:46:00 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:63892 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440AbYEOUp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 16:45:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fQ7T0tLfPiZKs/HODudvaa2wMvOaYeZl+feF+BZorgb1PKNGrhaBW49VYc52nIXIxWJ3RCFcRN7KYm9r080NyYz4xQLLu3e0vPfuWxTkP8m4Mfo5xeFC/HYUVKbbcszZxZrrzGnRuI2khM/T9WPkUhqSLQZzBVAdC60wIbIBjC8=
Message-ID: <86802c440805151345g6f272ab1xb1644ac9d655e6e2@mail.gmail.com>
Date: Thu, 15 May 2008 13:45:58 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 2/2] x86: per-device dma_mapping_ops support
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, muli@il.ibm.com,
       alexisb@us.ibm.com
In-Reply-To: <1210658692-960-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1210658692-960-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	 <1210658692-960-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	 <1210658692-960-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2008 at 11:04 PM, FUJITA Tomonori
<fujita.tomonori@lab.ntt.co.jp> wrote:
> This adds per-device dma_mapping_ops support for CONFIG_X86_64.
>
> A pointer to dma_mapping_ops to struct dev_archdata is added. If the
> pointer is non NULL, DMA operations in asm/dma-mapping.h use it. If
> it's NULL, the system-wide dma_ops pointer is used as before.
>
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  arch/x86/kernel/pci-calgary_64.c |    2 +-
>  arch/x86/kernel/pci-dma.c        |    2 +-
>  arch/x86/kernel/pci-gart_64.c    |    2 +-
>  arch/x86/kernel/pci-nommu.c      |   14 +-----
>  arch/x86/kernel/pci-swiotlb_64.c |    2 +-
>  include/asm-x86/device.h         |    3 +
>  include/asm-x86/dma-mapping.h    |   95 ++++++++++++++++++++++++++------------
>  7 files changed, 74 insertions(+), 46 deletions(-)
>
> diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
> index e28ec49..dca9a82 100644
> --- a/arch/x86/kernel/pci-calgary_64.c
> +++ b/arch/x86/kernel/pci-calgary_64.c
> @@ -541,7 +541,7 @@ error:
>        return ret;
>  }
>
> -static const struct dma_mapping_ops calgary_dma_ops = {
> +static struct dma_mapping_ops calgary_dma_ops = {
>        .alloc_coherent = calgary_alloc_coherent,
>        .map_single = calgary_map_single,
>        .unmap_single = calgary_unmap_single,
> diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
> index 0c37f16..33ded93 100644
> --- a/arch/x86/kernel/pci-dma.c
> +++ b/arch/x86/kernel/pci-dma.c
> @@ -11,7 +11,7 @@
>  int forbid_dac __read_mostly;
>  EXPORT_SYMBOL(forbid_dac);
>
> -const struct dma_mapping_ops *dma_ops;
> +struct dma_mapping_ops *dma_ops;
>  EXPORT_SYMBOL(dma_ops);
>
>  static int iommu_sac_force __read_mostly;
> diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
> index e1a6954..8469f76 100644
> --- a/arch/x86/kernel/pci-gart_64.c
> +++ b/arch/x86/kernel/pci-gart_64.c
> @@ -621,7 +621,7 @@ static __init int init_k8_gatt(struct agp_kern_info *info)
>
>  extern int agp_amd64_init(void);
>
> -static const struct dma_mapping_ops gart_dma_ops = {
> +static struct dma_mapping_ops gart_dma_ops = {
>        .map_single                     = gart_map_single,
>        .map_simple                     = gart_map_simple,
>        .unmap_single                   = gart_unmap_single,
> diff --git a/arch/x86/kernel/pci-nommu.c b/arch/x86/kernel/pci-nommu.c
> index 05d70b8..67cc5ee 100644
> --- a/arch/x86/kernel/pci-nommu.c
> +++ b/arch/x86/kernel/pci-nommu.c
> @@ -72,21 +72,9 @@ static int nommu_map_sg(struct device *hwdev, struct scatterlist *sg,
>        return nents;
>  }
>
> -/* Make sure we keep the same behaviour */
> -static int nommu_mapping_error(struct device *hwdev, dma_addr_t dma_addr)
> -{
> -#ifdef CONFIG_X86_32
> -       return 0;
> -#else
> -       return (dma_addr == bad_dma_address);
> -#endif
> -}
> -
> -
> -const struct dma_mapping_ops nommu_dma_ops = {
> +struct dma_mapping_ops nommu_dma_ops = {
>        .map_single = nommu_map_single,
>        .map_sg = nommu_map_sg,
> -       .mapping_error = nommu_mapping_error,
>        .is_phys = 1,
>  };
>
> diff --git a/arch/x86/kernel/pci-swiotlb_64.c b/arch/x86/kernel/pci-swiotlb_64.c
> index 490da7f..a464016 100644
> --- a/arch/x86/kernel/pci-swiotlb_64.c
> +++ b/arch/x86/kernel/pci-swiotlb_64.c
> @@ -18,7 +18,7 @@ swiotlb_map_single_phys(struct device *hwdev, phys_addr_t paddr, size_t size,
>        return swiotlb_map_single(hwdev, phys_to_virt(paddr), size, direction);
>  }
>
> -const struct dma_mapping_ops swiotlb_dma_ops = {
> +struct dma_mapping_ops swiotlb_dma_ops = {
>        .mapping_error = swiotlb_dma_mapping_error,
>        .alloc_coherent = swiotlb_alloc_coherent,
>        .free_coherent = swiotlb_free_coherent,
> diff --git a/include/asm-x86/device.h b/include/asm-x86/device.h
> index 87a7153..3c034f4 100644
> --- a/include/asm-x86/device.h
> +++ b/include/asm-x86/device.h
> @@ -5,6 +5,9 @@ struct dev_archdata {
>  #ifdef CONFIG_ACPI
>        void    *acpi_handle;
>  #endif
> +#ifdef CONFIG_X86_64
> +struct dma_mapping_ops *dma_ops;
> +#endif
>  #ifdef CONFIG_DMAR
>        void *iommu; /* hook for IOMMU specific extension */
>  #endif

do you have other patch to assign value to dma_ops for every device?
it is always NULL at this time.

YH
