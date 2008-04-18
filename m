Return-Path: <linux-kernel-owner+w=401wt.eu-S1757197AbYDRDNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197AbYDRDNS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 23:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753957AbYDRDNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 23:13:05 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:38423 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936AbYDRDND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 23:13:03 -0400
Date: Fri, 18 Apr 2008 12:04:56 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Shi Weihua <shiwh@cn.fujitsu.com>
Cc: akpm@linux-foundation.org, balbir@linux.vnet.ibm.com, xemul@openvz.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, hugh@veritas.com
Subject: Re: [PATCH] memcgroup: check and initialize page->cgroup in
 memmap_init_zone
Message-Id: <20080418120456.68a663d7.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <48080B86.7040200@cn.fujitsu.com>
References: <48080706.50305@cn.fujitsu.com>
	<48080930.5090905@cn.fujitsu.com>
	<48080B86.7040200@cn.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Apr 2008 10:46:30 +0800
Shi Weihua <shiwh@cn.fujitsu.com> wrote:

> In this patch, the Author Hugh Dickins said 
> "...memmap_init_zone doesn't need it either, ...
> Linux assumes pointers in zeroed structures are NULL pointers."
> But it seems it's not always the case, so we should check and initialize
> page->cgroup anyways.
> 
Hmm...strange. (I never see this with 2.6.25 + Primequest) 
What memory model are you using ? CONFIG_SPRASEMEM_VMEMMAP ?


>  	for (pfn = start_pfn; pfn < end_pfn; pfn++) {
>  		/*
> @@ -2535,6 +2536,9 @@ void __meminit memmap_init_zone(unsigned long size, int nid, unsigned long zone,
>  		set_page_links(page, zone, nid, pfn);
>  		init_page_count(page);
>  		reset_page_mapcount(page);
> +		pc = page_get_page_cgroup(page);
> +		if (pc) 
> +			page_reset_bad_cgroup(page);
>  		SetPageReserved(page);
>  
BTW, page_reset_page_cgroup, defined as this
==
#define page_reset_bad_cgroup(page)     ((page)->page_cgroup = 0)
==
Should be
==
#define page_reset_bad_cgroup(page)     ((page)->page_cgroup = 0UL)
==
...I'll write a patch.

Thanks,
-Kame


