Return-Path: <linux-kernel-owner+w=401wt.eu-S1752627AbYJADtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627AbYJADtY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 23:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751718AbYJADtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 23:49:16 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:37964 "EHLO
	e28esmtp02.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751477AbYJADtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 23:49:15 -0400
Message-ID: <48E2F336.4030203@linux.vnet.ibm.com>
Date: Wed, 01 Oct 2008 09:19:10 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "xemul@openvz.org" <xemul@openvz.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH/stylefix 3/4] memcg: avoid account not-on-LRU pages
References: <20080929191927.caabec89.kamezawa.hiroyu@jp.fujitsu.com> <20080929192339.327ca142.kamezawa.hiroyu@jp.fujitsu.com> <20080930101705.aec0e59b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080930101705.aec0e59b.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> This is conding-style fixed version. Thank you, Nishimura-san.
> -Kmae
> ==
> There are not-on-LRU pages which can be mapped and they are not worth to
> be accounted. (becasue we can't shrink them and need dirty codes to handle
> specical case) We'd like to make use of usual objrmap/radix-tree's protcol
> and don't want to account out-of-vm's control pages.
> 
> When special_mapping_fault() is called, page->mapping is tend to be NULL 
> and it's charged as Anonymous page.
> insert_page() also handles some special pages from drivers.
> 
> This patch is for avoiding to account special pages.
> 
> Changlog: v5 -> v6
>   - modified Documentation.
>   - fixed to charge only when a page is newly allocated.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 

[snip]
> @@ -2463,6 +2457,7 @@ static int __do_fault(struct mm_struct *
>  	struct page *page;
>  	pte_t entry;
>  	int anon = 0;
> +	int charged = 0;
>  	struct page *dirty_page = NULL;
>  	struct vm_fault vmf;
>  	int ret;
> @@ -2503,6 +2498,12 @@ static int __do_fault(struct mm_struct *
>  				ret = VM_FAULT_OOM;
>  				goto out;
>  			}
> +			if (mem_cgroup_charge(page, mm, GFP_KERNEL)) {
> +				ret = VM_FAULT_OOM;
> +				page_cache_release(page);
> +				goto out;
> +			}
> +			charged = 1;

If I understand this correctly, we now account only when the VMA is not shared?
Seems reasonable, since we don't allocate a page otherwise.


[snip]


> Index: mmotm-2.6.27-rc7+/mm/rmap.c
> ===================================================================
> --- mmotm-2.6.27-rc7+.orig/mm/rmap.c
> +++ mmotm-2.6.27-rc7+/mm/rmap.c
> @@ -725,8 +725,8 @@ void page_remove_rmap(struct page *page,
>  			page_clear_dirty(page);
>  			set_page_dirty(page);
>  		}
> -
> -		mem_cgroup_uncharge_page(page);
> +		if (PageAnon(page))
> +			mem_cgroup_uncharge_page(page);

Is the change because we expect the page to get directly uncharged when it is
removed from cache? i.e, page->mapping is set to NULL before uncharge?

Looks good to me, I am yet to test it though.

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>


-- 
	Balbir
