Return-Path: <linux-kernel-owner+w=401wt.eu-S1761536AbZE2P6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761536AbZE2P6U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 11:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760199AbZE2P6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 11:58:13 -0400
Received: from claw.goop.org ([74.207.240.146]:40460 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756888AbZE2P6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 11:58:12 -0400
Message-ID: <4A20060C.2050701@goop.org>
Date: Fri, 29 May 2009 08:58:04 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ian Campbell <ian.campbell@citrix.com>
CC: linux-kernel@vger.kernel.org, Becky Bruce <beckyb@kernel.crashing.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Kumar Gala <galak@kernel.crashing.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Ingo Molnar <mingo@elte.hu>, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 8/9] swiotlb: support HIGHMEM in swiotlb_bus_to_virt
References: <1243586643-5554-1-git-send-email-ian.campbell@citrix.com> <1243586643-5554-9-git-send-email-ian.campbell@citrix.com>
In-Reply-To: <1243586643-5554-9-git-send-email-ian.campbell@citrix.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Campbell wrote:
> Rather than supplying a __weak hook which architectures which support
> highmem can overide simply provide a version of swiotlb_bus_to_virt
> which works with high memory. Make it conditional since it is a more
> expensive variant than the non-highmem version.
>
> Acutal function contents taken from the PowerPC swiotlb patchset by
> Becky Bruce.
>
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> Cc: Becky Bruce <beckyb@kernel.crashing.org>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Kumar Gala <galak@kernel.crashing.org>
> Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> Cc: linuxppc-dev@ozlabs.org
> ---
>  lib/swiotlb.c |   14 +++++++++++++-
>  1 files changed, 13 insertions(+), 1 deletions(-)
>
> diff --git a/lib/swiotlb.c b/lib/swiotlb.c
> index e332342..c50a5ed 100644
> --- a/lib/swiotlb.c
> +++ b/lib/swiotlb.c
> @@ -130,10 +130,22 @@ static dma_addr_t swiotlb_virt_to_bus(struct device *hwdev,
>  	return phys_to_dma(hwdev, virt_to_phys(address));
>  }
>  
> -void * __weak swiotlb_bus_to_virt(struct device *hwdev, dma_addr_t address)
> +#ifdef CONFIG_HIGHMEM
> +static void * swiotlb_bus_to_virt(struct device *hwdev, dma_addr_t address)
>   

I think it would be better to put the #ifdef within the function body so 
that there's no chance of prototype-drift.
> +{
> +	unsigned long pfn = PFN_DOWN(dma_to_phys(hwdev, addr));
> +	void *pageaddr = page_address(pfn_to_page(pfn));
> +
> +	if (pageaddr != NULL)
> +		return pageaddr + (addr % PAGE_SIZE);
>   
Is there an arch-independent test to see if a pfn is considered highmem 
or not (which returns a constant on non-highmem configurations)?  If so, 
then I think this could be common without having to go via a struct page.

    J
