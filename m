Return-Path: <linux-kernel-owner+w=401wt.eu-S1755634AbYHMAre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634AbYHMAre (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 20:47:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755152AbYHMAqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 20:46:40 -0400
Received: from sh.osrg.net ([192.16.179.4]:50950 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755140AbYHMAqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 20:46:39 -0400
Date: Wed, 13 Aug 2008 09:45:54 +0900
To: joerg.roedel@amd.com
Cc: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       muli@il.ibm.com
Subject: Re: [PATCH 1/7] x86: add alloc_coherent dma_ops callback to GART
 driver
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1218554657-16070-2-git-send-email-joerg.roedel@amd.com>
References: <1218554657-16070-1-git-send-email-joerg.roedel@amd.com>
	<1218554657-16070-2-git-send-email-joerg.roedel@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080813094535T.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Aug 2008 17:24:11 +0200
Joerg Roedel <joerg.roedel@amd.com> wrote:

> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  arch/x86/kernel/pci-gart_64.c |   21 +++++++++++++++++++++
>  1 files changed, 21 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
> index cdab678..55cc388 100644
> --- a/arch/x86/kernel/pci-gart_64.c
> +++ b/arch/x86/kernel/pci-gart_64.c
> @@ -499,6 +499,26 @@ error:
>  	return 0;
>  }
>  
> +/* allocate and map a coherent mapping */
> +static void *
> +gart_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_addr,
> +		    gfp_t flag)
> +{
> +	void *vaddr;
> +
> +	vaddr = (void *)__get_free_pages(flag, get_order(size));
> +	if (!vaddr)
> +		return NULL;
> +
> +	*dma_addr = gart_map_single(dev, __pa(vaddr), size, DMA_BIDIRECTIONAL);
> +	if (*dma_addr != bad_dma_address)
> +		return vaddr;
> +
> +	free_pages((unsigned long)vaddr, get_order(size));
> +
> +	return NULL;
> +}
> +
>  static int no_agp;

It would be better to return a size-aligned memory as DMA-mapping.txt
says (though I don't think that it doesn't matter much):

http://lkml.org/lkml/2008/8/8/555


I also think that x86 IOMMUs need to handle DMA_*BIT_MASK properly,
don't we?
