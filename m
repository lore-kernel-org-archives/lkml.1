Return-Path: <linux-kernel-owner+w=401wt.eu-S1759219AbYDRRmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759219AbYDRRmj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 13:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758897AbYDRRmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 13:42:10 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:33619 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757997AbYDRRmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 13:42:05 -0400
Subject: Re: [PATCH]Fix usemap for DISCONTIG/FLATMEM with not-aligned zone
	initilaization.
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Shi Weihua <shiwh@cn.fujitsu.com>, akpm@linux-foundation.org,
       balbir@linux.vnet.ibm.com, xemul@openvz.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, hugh@veritas.com
In-Reply-To: <20080418161522.GB9147@csn.ul.ie>
References: <48080706.50305@cn.fujitsu.com>
	 <48080930.5090905@cn.fujitsu.com> <48080B86.7040200@cn.fujitsu.com>
	 <20080418211214.299f91cd.kamezawa.hiroyu@jp.fujitsu.com>
	 <20080418161522.GB9147@csn.ul.ie>
Content-Type: text/plain
Date: Fri, 18 Apr 2008 10:41:56 -0700
Message-Id: <1208540516.25363.44.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-04-18 at 17:15 +0100, Mel Gorman wrote:
> -void __meminit memmap_init_zone(unsigned long size, int nid, unsigned long zone,
> +void __meminit memmap_init_zone(unsigned long size, int nid, struct zone *zone,
>                 unsigned long start_pfn, enum memmap_context context)
>  {
>         struct page *page;
>         unsigned long end_pfn = start_pfn + size;
>         unsigned long pfn;
> +       int zoneidx = zone_idx(zone);
> +
> +       /*
> +        * Sanity check the values passed in. It is possible an architecture
> +        * calling this function directly will use values outside of the memory
> +        * they registered
> +        */
> +       if (start_pfn < zone->zone_start_pfn) {
> +               WARN_ON_ONCE(1);
> +               start_pfn = zone->zone_start_pfn;
> +       }
> +
> +       if (size > zone->spanned_pages) {
> +               WARN_ON_ONCE(1);
> +               size = zone->spanned_pages;
> +       }

I was thinking about whether size needs to be modified in there like
this:

	if (start_pfn < zone->zone_start_pfn) {
		WARN_ON_ONCE(1);
+		size -= zone->zone_start_pfn - start_pfn;
		start_pfn = zone->zone_start_pfn;
	}

and I realized that your modification of size actually happens after its
only use in the function (to calculate end_pfn).  Seems like we either
be error-checking end_pfn or delaying its calculation until after 'size'
is fixed.

-- Dave

