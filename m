Return-Path: <linux-kernel-owner+w=401wt.eu-S1757751AbZCYDH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757751AbZCYDH4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 23:07:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757354AbZCYDHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 23:07:01 -0400
Received: from sh.osrg.net ([192.16.179.4]:56071 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757379AbZCYDHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 23:07:00 -0400
Date: Wed, 25 Mar 2009 11:58:27 +0900
To: beckyb@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, fujita.tomonori@lab.ntt.co.jp,
       ian.campbell@citrix.com, jeremy@goop.org
Subject: Re: [PATCH 5/5] swiotlb: Allow arch override of
 address_needs_mapping
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1237930126-6741-6-git-send-email-beckyb@kernel.crashing.org>
References: <1237930126-6741-4-git-send-email-beckyb@kernel.crashing.org>
	<1237930126-6741-5-git-send-email-beckyb@kernel.crashing.org>
	<1237930126-6741-6-git-send-email-beckyb@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090325115514Q.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 25 Mar 2009 11:58:27 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Mar 2009 16:28:46 -0500
Becky Bruce <beckyb@kernel.crashing.org> wrote:

> Some architectures require additional checking to determine
> if a device can dma to an address and need to provide their
> own address_needs_mapping..
> 
> Signed-off-by: Becky Bruce <beckyb@kernel.crashing.org>
> ---
>  lib/swiotlb.c |   10 ++++++++--
>  1 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/swiotlb.c b/lib/swiotlb.c
> index b33180e..f365735 100644
> --- a/lib/swiotlb.c
> +++ b/lib/swiotlb.c
> @@ -145,6 +145,12 @@ void __weak *swiotlb_bus_to_virt(struct device *hwdev, dma_addr_t address)
>  	return phys_to_virt(swiotlb_bus_to_phys(hwdev, address));
>  }
>  
> +int __weak swiotlb_arch_address_needs_mapping(struct device *hwdev,
> +					       dma_addr_t addr, size_t size)
> +{
> +	return !is_buffer_dma_capable(dma_get_mask(hwdev), addr, size);
> +}
> +
>  int __weak swiotlb_arch_range_needs_mapping(phys_addr_t paddr, size_t size)
>  {
>  	return 0;
> @@ -309,10 +315,10 @@ cleanup1:
>  	return -ENOMEM;
>  }
>  
> -static int
> +static inline int
>  address_needs_mapping(struct device *hwdev, dma_addr_t addr, size_t size)
>  {
> -	return !is_buffer_dma_capable(dma_get_mask(hwdev), addr, size);
> +	return swiotlb_arch_address_needs_mapping(hwdev, addr, size);
>  }
>  
>  static inline int range_needs_mapping(phys_addr_t paddr, size_t size)

Looks fine to me. Though I guess that we could clean up
swiotlb_arch_range_needs_mapping and
swiotlb_arch_address_needs_mapping a bit (at least, the names are
confusing).
