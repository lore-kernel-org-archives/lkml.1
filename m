Return-Path: <linux-kernel-owner+w=401wt.eu-S1750759AbXCUXXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750759AbXCUXXe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 19:23:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164AbXCUXXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 19:23:34 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:41997 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750759AbXCUXXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 19:23:33 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=Ia1p/Zrv6TgAlc9fQ9crKsMj2sqeOBeifQSnfoElfyPcqNiYoIjM4rZ18lnFbT9D4vkTB04QvcTQbsfo0/jxQjvzpJYKVM1uJrdTfuoHEwdLZaoQJWiiGvhwDqatj83vniNXjD632EytUPFpI7R7H4Mee5MEISVuzgx5nXljN+w=  ;
X-YMail-OSG: WMpK9QEVM1knBXTejgx3Un.agZDcyEh75HlBpSzAfSR2vr2SqKySNDnafpEdwYobep8VZuEpq8eeDCo6WOBD.Mh3qrfn2Lou76Rz9qqOB1faJFLg2KjgG1yDPLQwdpK_8Ia1S901DiFCHq4-
Message-ID: <4601BE6F.3000003@yahoo.com.au>
Date: Thu, 22 Mar 2007 10:23:27 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Andy Whitcroft <apw@shadowen.org>
CC: Mel Gorman <mel@csn.ul.ie>, Bob Picco <bob.picco@hp.com>,
       Dave Hansen <hansendc@us.ibm.com>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] add pfn_valid_within helper for sub-MAX_ORDER hole
 detection
References: <exportbomb.1174504472@pinky> <2b7fba2bc49877d95f3ad13735324444@pinky>
In-Reply-To: <2b7fba2bc49877d95f3ad13735324444@pinky>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Whitcroft wrote:
> Generally we work under the assumption that memory the mem_map
> array is contigious and valid out to MAX_ORDER_NR_PAGES block
> of pages, ie. that if we have validated any page within this
> MAX_ORDER_NR_PAGES block we need not check any other.  This is not
> true when CONFIG_HOLES_IN_ZONE is set and we must check each and
> every reference we make from a pfn.
> 
> Add a pfn_valid_within() helper which should be used when scanning
> pages within a MAX_ORDER_NR_PAGES block when we have already
> checked the validility of the block normally with pfn_valid().
> This can then be optimised away when we do not have holes within
> a MAX_ORDER_NR_PAGES block of pages.

Nice cleanup. Horrible name ;) Calls read like "is the pfn valid
within pfn".

I can't think of anything really good, but I think, say,
pfn_valid_within_block or pfn_valid_within_valid_block would be a
bit better. You still get a slight net savings in keystrokes!

Thanks,
Nick

> 
> Signed-off-by: Andy Whitcroft <apw@shadowen.org>
> Acked-by: Mel Gorman <mel@csn.ul.ie>
> ---
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 7206c77..8c87d79 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -837,6 +837,18 @@ void sparse_init(void);
>  void memory_present(int nid, unsigned long start, unsigned long end);
>  unsigned long __init node_memmap_size_bytes(int, unsigned long, unsigned long);
>  
> +/*
> + * If it is possible to have holes within a MAX_ORDER_NR_PAGES, then we
> + * need to check pfn validility within that MAX_ORDER_NR_PAGES block.
> + * pfn_valid_within() should be used in this case; we optimise this away
> + * when we have no holes within a MAX_ORDER_NR_PAGES block.
> + */
> +#ifdef CONFIG_HOLES_IN_ZONE
> +#define pfn_valid_within(pfn) pfn_valid(pfn)
> +#else
> +#define pfn_valid_within(pfn) (1)
> +#endif
> +
>  #endif /* !__ASSEMBLY__ */
>  #endif /* __KERNEL__ */
>  #endif /* _LINUX_MMZONE_H */
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 3d7a9e2..695b5a6 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -206,10 +206,8 @@ static int page_outside_zone_boundaries(struct zone *zone, struct page *page)
>  
>  static int page_is_consistent(struct zone *zone, struct page *page)
>  {
> -#ifdef CONFIG_HOLES_IN_ZONE
> -	if (!pfn_valid(page_to_pfn(page)))
> +	if (!pfn_valid_within(page_to_pfn(page)))
>  		return 0;
> -#endif
>  	if (zone != page_zone(page))
>  		return 0;
>  
> @@ -411,10 +409,8 @@ __find_combined_index(unsigned long page_idx, unsigned int order)
>  static inline int page_is_buddy(struct page *page, struct page *buddy,
>  								int order)
>  {
> -#ifdef CONFIG_HOLES_IN_ZONE
> -	if (!pfn_valid(page_to_pfn(buddy)))
> +	if (!pfn_valid_within(page_to_pfn(buddy)))
>  		return 0;
> -#endif
>  
>  	if (page_zone_id(page) != page_zone_id(buddy))
>  		return 0;
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
