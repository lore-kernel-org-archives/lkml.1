Return-Path: <linux-kernel-owner+w=401wt.eu-S932125AbZFLCsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125AbZFLCsj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 22:48:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755445AbZFLCsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 22:48:31 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52100 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752723AbZFLCsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 22:48:30 -0400
Message-ID: <4A31C258.2050404@cn.fujitsu.com>
Date: Fri, 12 Jun 2009 10:50:00 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Pekka J Enberg <penberg@cs.helsinki.fi>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, hannes@cmpxchg.org,
       torvalds@linux-foundation.org, yinghai@kernel.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: boot panic with memcg enabled (Was [PATCH 3/4] memcg: don't use bootmem
 allocator in setup code)
References: <Pine.LNX.4.64.0906110820170.2258@melkki.cs.Helsinki.FI>
In-Reply-To: <Pine.LNX.4.64.0906110820170.2258@melkki.cs.Helsinki.FI>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(This patch should have CCed memcg maitainers)

My box failed to boot due to initialization failure of page_cgroup, and
it's caused by this patch:

+	page = alloc_pages_node(nid, GFP_NOWAIT | __GFP_ZERO, order);

I added a printk, and found that order == 11 == MAX_ORDER.

Pekka J Enberg wrote:
> From: Yinghai Lu <yinghai@kernel.org>
> 
> The bootmem allocator is no longer available for page_cgroup_init() because we
> set up the kernel slab allocator much earlier now.
> 
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> ---
>  mm/page_cgroup.c |   12 ++++++++----
>  1 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
> index 791905c..3dd4a90 100644
> --- a/mm/page_cgroup.c
> +++ b/mm/page_cgroup.c
> @@ -47,6 +47,8 @@ static int __init alloc_node_page_cgroup(int nid)
>  	struct page_cgroup *base, *pc;
>  	unsigned long table_size;
>  	unsigned long start_pfn, nr_pages, index;
> +	struct page *page;
> +	unsigned int order;
>  
>  	start_pfn = NODE_DATA(nid)->node_start_pfn;
>  	nr_pages = NODE_DATA(nid)->node_spanned_pages;
> @@ -55,11 +57,13 @@ static int __init alloc_node_page_cgroup(int nid)
>  		return 0;
>  
>  	table_size = sizeof(struct page_cgroup) * nr_pages;
> -
> -	base = __alloc_bootmem_node_nopanic(NODE_DATA(nid),
> -			table_size, PAGE_SIZE, __pa(MAX_DMA_ADDRESS));
> -	if (!base)
> +	order = get_order(table_size);
> +	page = alloc_pages_node(nid, GFP_NOWAIT | __GFP_ZERO, order);
> +	if (!page)
> +		page = alloc_pages_node(-1, GFP_NOWAIT | __GFP_ZERO, order);
> +	if (!page)
>  		return -ENOMEM;
> +	base = page_address(page);
>  	for (index = 0; index < nr_pages; index++) {
>  		pc = base + index;
>  		__init_page_cgroup(pc, start_pfn + index);

