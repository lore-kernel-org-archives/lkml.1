Return-Path: <linux-kernel-owner+w=401wt.eu-S1755396AbZEVLOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396AbZEVLOj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 07:14:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753025AbZEVLOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 07:14:32 -0400
Received: from sh.osrg.net ([192.16.179.4]:53034 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497AbZEVLOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 07:14:31 -0400
Date: Fri, 22 May 2009 20:13:16 +0900
To: ian.campbell@citrix.com
Cc: fujita.tomonori@lab.ntt.co.jp, jeremy@goop.org, beckyb@kernel.crashing.org,
       okir@suse.de, mingo@elte.hu, gregkh@suse.de,
       xendevel@lists.xensource.com, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] swiotlb: make swiotlb phys<->bus translations
 architecture-specific
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1242922528-5982-7-git-send-email-ian.campbell@citrix.com>
References: <1242906335.22654.188.camel@zakaz.uk.xensource.com>
	<1242922528-5982-7-git-send-email-ian.campbell@citrix.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090522200437P.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 22 May 2009 20:13:16 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 May 2009 17:15:27 +0100
Ian Campbell <ian.campbell@citrix.com> wrote:

> This moves swiotlb_bus_to_phys() and swiotlb_phys_to_bus() from
> lib/swiotlb.c to arch/*/include/asm/dma-mapping.h. On x86 gart_to_phys
> and phys_to_gart translations need an exported function for use from
> drivers so introduce common x86_ variants to implement the interface
> required by both.
> 
> The __weak swiotlb_bus_to_virt is not currently overriden by any
> architecture therefore it can be made static again. I imagine the
> ability to override phys<->bus translations will be sufficient for any
> potential users anyhow, otherwise we can revisit this aspect.
> 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> Cc: Becky Bruce <beckyb@kernel.crashing.org>
> Cc: Olaf Kirch <okir@suse.de>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Greg KH <gregkh@suse.de>
> Cc: xen-devel <xendevel@lists.xensource.com>
> Cc: x86 maintainers <x86@kernel.org>
> Cc: lkml <linux-kernel@vger.kernel.org>
> ---
>  arch/ia64/include/asm/dma-mapping.h |   13 +++++++++++++
>  arch/x86/include/asm/agp.h          |    4 ++--
>  arch/x86/include/asm/dma-mapping.h  |   15 +++++++++++++++
>  arch/x86/kernel/pci-swiotlb.c       |   18 ++++++++++++++++++
>  arch/x86/xen/pci-swiotlb.c          |   15 ---------------
>  include/linux/swiotlb.h             |    5 -----
>  lib/swiotlb.c                       |   14 +-------------
>  7 files changed, 49 insertions(+), 35 deletions(-)
> 
> diff --git a/arch/ia64/include/asm/dma-mapping.h b/arch/ia64/include/asm/dma-mapping.h
> index 9f9994d..667d04e 100644
> --- a/arch/ia64/include/asm/dma-mapping.h
> +++ b/arch/ia64/include/asm/dma-mapping.h
> @@ -190,4 +190,17 @@ static inline int swiotlb_force_mapping(phys_addr_t paddr, size_t size)
>  extern void *swiotlb_alloc_boot(size_t size, unsigned long nslabs);
>  extern void *swiotlb_alloc(unsigned order, unsigned long nslabs);
>  
> +static inline dma_addr_t swiotlb_phys_to_bus(struct device *hwdev,
> +					     phys_addr_t paddr)
> +{
> +	return paddr;
> +}
> +
> +static inline phys_addr_t swiotlb_bus_to_phys(struct device *hwdev,
> +					      dma_addr_t baddr)
> +{
> +	return baddr;
> +}
> +
> +

As I wrote in another mail, adding swiotlb specific code in
dma-mapping.h is wrong.
