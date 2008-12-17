Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1758733AbYLQCtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758733AbYLQCtZ (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 21:49:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753099AbYLQCtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 21:49:15 -0500
Received: from sh.osrg.net ([192.16.179.4]:56559 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858AbYLQCtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 21:49:14 -0500
Date: Wed, 17 Dec 2008 11:48:41 +0900
To: jeremy@goop.org
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        x86@kernel.org, ian.campbell@citrix.com, jbeulich@novell.com,
        fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH 04 of 14] swiotlb: consistently use
 address_needs_mapping	everywhere
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <aba0c734944520d4b892.1229458648@abulafia.goop.org>
References: <patchbomb.1229458644@abulafia.goop.org>
	<aba0c734944520d4b892.1229458648@abulafia.goop.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081217113804F.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Dec 2008 12:17:28 -0800
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> ---
>  lib/swiotlb.c |   10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)

This patch is wrong.

dma_mask and coherent_dma_mask represent different restrictions.

You can't use coherent_dma_mask for alloc_coherent.


> diff --git a/lib/swiotlb.c b/lib/swiotlb.c
> --- a/lib/swiotlb.c
> +++ b/lib/swiotlb.c
> @@ -465,13 +465,9 @@
>  	dma_addr_t dev_addr;
>  	void *ret;
>  	int order = get_order(size);
> -	u64 dma_mask = DMA_32BIT_MASK;
> -
> -	if (hwdev && hwdev->coherent_dma_mask)
> -		dma_mask = hwdev->coherent_dma_mask;
>  
>  	ret = (void *)__get_free_pages(flags, order);
> -	if (ret && !is_buffer_dma_capable(dma_mask, virt_to_bus(ret), size)) {
> +	if (ret && !address_needs_mapping(hwdev, virt_to_bus(ret), size)) {
>  		/*
>  		 * The allocated memory isn't reachable by the device.
>  		 * Fall back on swiotlb_map_single().
> @@ -495,9 +491,9 @@
>  	dev_addr = virt_to_bus(ret);
>  
>  	/* Confirm address can be DMA'd by device */
> -	if (!is_buffer_dma_capable(dma_mask, dev_addr, size)) {
> +	if (!address_needs_mapping(hwdev, dev_addr, size)) {
>  		printk("hwdev DMA mask = 0x%016Lx, dev_addr = 0x%016Lx\n",
> -		       (unsigned long long)dma_mask,
> +		       (unsigned long long)dma_get_mask(hwdev),
>  		       (unsigned long long)dev_addr);
>  
>  		/* DMA_TO_DEVICE to avoid memcpy in unmap_single */
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
