Return-Path: <linux-kernel-owner+w=401wt.eu-S1751427AbZHaLC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427AbZHaLC4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 07:02:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751178AbZHaLCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 07:02:55 -0400
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:44812 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbZHaLCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 07:02:55 -0400
Date: Mon, 31 Aug 2009 16:32:52 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [RFC][PATCH 3/5] memcg: unmap, truncate, invalidate uncharege
	in batch
Message-ID: <20090831110252.GH4770@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090828132015.10a42e40.kamezawa.hiroyu@jp.fujitsu.com> <20090828132542.37d712ba.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090828132542.37d712ba.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-08-28 13:25:42]:

> 
> We can do batched uncharge when
> 	- invalidate/truncte file
> 	- unmap range of pages.
> 
> This means we don't do "batched" uncharge in memory reclaim path.
> I think it's reasonable.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  mm/memory.c   |    2 ++
>  mm/truncate.c |    6 ++++++
>  2 files changed, 8 insertions(+)
> 
> Index: mmotm-2.6.31-Aug27/mm/memory.c
> ===================================================================
> --- mmotm-2.6.31-Aug27.orig/mm/memory.c
> +++ mmotm-2.6.31-Aug27/mm/memory.c
> @@ -909,6 +909,7 @@ static unsigned long unmap_page_range(st
>  		details = NULL;
> 
>  	BUG_ON(addr >= end);
> +	mem_cgroup_uncharge_batch_start();
>  	tlb_start_vma(tlb, vma);
>  	pgd = pgd_offset(vma->vm_mm, addr);
>  	do {
> @@ -921,6 +922,7 @@ static unsigned long unmap_page_range(st
>  						zap_work, details);
>  	} while (pgd++, addr = next, (addr != end && *zap_work > 0));
>  	tlb_end_vma(tlb, vma);
> +	mem_cgroup_uncharge_batch_end();
> 
>  	return addr;
>  }
> Index: mmotm-2.6.31-Aug27/mm/truncate.c
> ===================================================================
> --- mmotm-2.6.31-Aug27.orig/mm/truncate.c
> +++ mmotm-2.6.31-Aug27/mm/truncate.c
> @@ -272,6 +272,7 @@ void truncate_inode_pages_range(struct a
>  			pagevec_release(&pvec);
>  			break;
>  		}
> +		mem_cgroup_uncharge_batch_start();
>  		for (i = 0; i < pagevec_count(&pvec); i++) {
>  			struct page *page = pvec.pages[i];
> 
> @@ -286,6 +287,7 @@ void truncate_inode_pages_range(struct a
>  			unlock_page(page);
>  		}
>  		pagevec_release(&pvec);
> +		mem_cgroup_uncharge_batch_end();
>  	}
>  }
>  EXPORT_SYMBOL(truncate_inode_pages_range);
> @@ -327,6 +329,7 @@ unsigned long invalidate_mapping_pages(s
>  	pagevec_init(&pvec, 0);
>  	while (next <= end &&
>  			pagevec_lookup(&pvec, mapping, next, PAGEVEC_SIZE)) {
> +		mem_cgroup_uncharge_batch_start();
>  		for (i = 0; i < pagevec_count(&pvec); i++) {
>  			struct page *page = pvec.pages[i];
>  			pgoff_t index;
> @@ -354,6 +357,7 @@ unsigned long invalidate_mapping_pages(s
>  				break;
>  		}
>  		pagevec_release(&pvec);
> +		mem_cgroup_uncharge_batch_end();
>  		cond_resched();
>  	}
>  	return ret;
> @@ -428,6 +432,7 @@ int invalidate_inode_pages2_range(struct
>  	while (next <= end && !wrapped &&
>  		pagevec_lookup(&pvec, mapping, next,
>  			min(end - next, (pgoff_t)PAGEVEC_SIZE - 1) + 1)) {
> +		mem_cgroup_uncharge_batch_start();
>  		for (i = 0; i < pagevec_count(&pvec); i++) {
>  			struct page *page = pvec.pages[i];
>  			pgoff_t page_index;
> @@ -477,6 +482,7 @@ int invalidate_inode_pages2_range(struct
>  			unlock_page(page);
>  		}
>  		pagevec_release(&pvec);
> +		mem_cgroup_uncharge_batch_end();
>  		cond_resched();
>  	}
>  	return ret;
>

This looks good to me
 

-- 
	Balbir
