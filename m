Return-Path: <linux-kernel-owner+w=401wt.eu-S1762066AbYF2PMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762066AbYF2PMx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 11:12:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760896AbYF2PML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 11:12:11 -0400
Received: from sh.osrg.net ([192.16.179.4]:57061 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760754AbYF2PLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 11:11:55 -0400
Date: Mon, 30 Jun 2008 00:07:10 +0900
To: joerg.roedel@amd.com
Cc: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       Sebastian.Biemueller@amd.com, robert.richter@amd.com, joro@8bytes.org
Subject: Re: [PATCH 21/34] AMD IOMMU: add address allocation and
 deallocation functions
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1214508490-29683-22-git-send-email-joerg.roedel@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
	<1214508490-29683-22-git-send-email-joerg.roedel@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080629234830P.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2008 21:27:57 +0200
Joerg Roedel <joerg.roedel@amd.com> wrote:

> This patch adds the address allocator to the AMD IOMMU code.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  arch/x86/kernel/amd_iommu.c |   48 +++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 48 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
> index 1d70f5e..69d8d02 100644
> --- a/arch/x86/kernel/amd_iommu.c
> +++ b/arch/x86/kernel/amd_iommu.c
> @@ -266,3 +266,51 @@ static int init_unity_mappings_for_device(struct dma_ops_domain *dma_dom,
>  	return 0;
>  }
>  
> +static unsigned long dma_mask_to_pages(unsigned long mask)
> +{
> +	return (mask >> PAGE_SHIFT) +
> +		(PAGE_ALIGN(mask & ~PAGE_MASK) >> PAGE_SHIFT);
> +}
> +
> +static unsigned long dma_ops_alloc_addresses(struct device *dev,
> +					     struct dma_ops_domain *dom,
> +					     unsigned int pages)
> +{
> +	unsigned long limit = dma_mask_to_pages(*dev->dma_mask);
> +	unsigned long address;
> +	unsigned long size = dom->aperture_size >> PAGE_SHIFT;
> +	unsigned long boundary_size;
> +
> +	boundary_size = ALIGN(dma_get_seg_boundary(dev) + 1,
> +			PAGE_SIZE) >> PAGE_SHIFT;
> +	limit = limit < size ? limit : size;
> +
> +	if (dom->next_bit >= limit)
> +		dom->next_bit = 0;
> +
> +	address = iommu_area_alloc(dom->bitmap, limit, dom->next_bit, pages,
> +			0 , boundary_size, 0);
> +	if (address == -1)
> +		address = iommu_area_alloc(dom->bitmap, limit, 0, pages,
> +				0, boundary_size, 0);
> +
> +	if (likely(address != -1)) {
> +		set_bit_string(dom->bitmap, address, pages);

Is set_bit_string() necessary here? iommu_area_alloc calls it internally.
