Return-Path: <linux-kernel-owner+w=401wt.eu-S1757039AbYLMJtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757039AbYLMJtV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 04:49:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754760AbYLMJtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 04:49:13 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:49750 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754458AbYLMJtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 04:49:12 -0500
Date: Sat, 13 Dec 2008 09:49:49 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [BUGFIX][PATCH mmotm] memcg fix swap accounting leak (v2)
In-Reply-To: <20081213160310.e9501cd9.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0812130935220.3611@blonde.anvils>
References: <20081212172930.282caa38.kamezawa.hiroyu@jp.fujitsu.com>
 <20081212184341.b62903a7.nishimura@mxp.nes.nec.co.jp>
 <46730.10.75.179.61.1229080565.squirrel@webmail-b.css.fujitsu.com>
 <20081213160310.e9501cd9.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Dec 2008, KAMEZAWA Hiroyuki wrote:
> --- mmotm-2.6.28-Dec12.orig/mm/memory.c
> +++ mmotm-2.6.28-Dec12/mm/memory.c
>  
> -	mem_cgroup_commit_charge_swapin(page, ptr);
>  	inc_mm_counter(mm, anon_rss);
>  	pte = mk_pte(page, vma->vm_page_prot);
>  	if (write_access && reuse_swap_page(page)) {
>  		pte = maybe_mkwrite(pte_mkdirty(pte), vma);
>  		write_access = 0;
>  	}
> -
>  	flush_icache_page(vma, page);
>  	set_pte_at(mm, address, page_table, pte);
>  	page_add_anon_rmap(page, vma, address);
> +	/* It's better to call commit-charge after rmap is established */
> +	mem_cgroup_commit_charge_swapin(page, ptr);
>  
>  	swap_free(entry);
>  	if (vm_swap_full() || (vma->vm_flags & VM_LOCKED) || PageMlocked(page))

That ordering is back to how it was before I adjusted it
for reuse_swap_page()'s delete_from_swap_cache(), isn't it?

So I don't understand how you've fixed the bug I hit (not an
accounting imbalance but an oops or BUG, I forget) with this
ordering, without making some other change elsewhere.

mem_cgroup_commit_charge_swapin calls swap_cgroup_record with
bogus swp_entry_t 0, which appears to belong to swp_offset 0 of
swp_type 0, but the ctrl->map for type 0 may have been freed
ages ago (we do always start from 0, but maybe we swapped on
type 1 and swapped off type 0 meanwhile).  I'm guessing that
by looking at the code, not by retesting it, so I may have the
details wrong; but I didn't reorder your code just for fun.

Perhaps your restored ordering works if you check PageSwapCache
in mem_cgroup_commit_charge_swapin or check 0 in swap_cgroup_record,
but I don't see that in yesterday's mmotm, nor in this patch.

(And I should admit, I've not even attempted to follow your
accounting justification: I'll leave that to you memcg guys.)

An alternative could be not to clear page->private when deleting
from swap cache, that's only done for tidiness and to force notice
of races like this; but I'd want a much stronger reason to change that.

Or am I making this up?  As I say, I've not tested it this time around.

Hugh
