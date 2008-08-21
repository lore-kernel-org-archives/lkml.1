Return-Path: <linux-kernel-owner+w=401wt.eu-S1758032AbYHUOVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032AbYHUOVG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 10:21:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753678AbYHUOUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 10:20:54 -0400
Received: from sh.osrg.net ([192.16.179.4]:43768 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753669AbYHUOUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 10:20:53 -0400
Date: Thu, 21 Aug 2008 23:16:49 +0900
To: joerg.roedel@amd.com
Cc: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       muli@il.ibm.com
Subject: Re: [PATCH 1/8] x86: add alloc_coherent dma_ops callback to GART
 driver
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1219156366-32498-2-git-send-email-joerg.roedel@amd.com>
References: <1219156366-32498-1-git-send-email-joerg.roedel@amd.com>
	<1219156366-32498-2-git-send-email-joerg.roedel@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080821225038E.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Aug 2008 16:32:39 +0200
Joerg Roedel <joerg.roedel@amd.com> wrote:

> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  arch/x86/kernel/pci-gart_64.c |   21 +++++++++++++++++++++
>  1 files changed, 21 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
> index 4d8efb0..44a75a6 100644
> --- a/arch/x86/kernel/pci-gart_64.c
> +++ b/arch/x86/kernel/pci-gart_64.c
> @@ -506,6 +506,26 @@ error:
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

I'm not sure a rule is documented or not, but I think that IOMMUs
return zeroed memory wrt dma_alloc_coherent. The current pci-dma.c
does, so I think that it would be better to keep the current behavior.
