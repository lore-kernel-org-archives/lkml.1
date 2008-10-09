Return-Path: <linux-kernel-owner+w=401wt.eu-S1756820AbYJIFuB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820AbYJIFuB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 01:50:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751494AbYJIFtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 01:49:52 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:54811 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795AbYJIFtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 01:49:52 -0400
Date: Thu, 9 Oct 2008 14:39:49 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: nishimura@mxp.nes.nec.co.jp, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH 5/6] memcg: lazy lru freeing
Message-Id: <20081009143949.b3cf91b7.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20081001170005.1997d7c8.kamezawa.hiroyu@jp.fujitsu.com>
References: <20081001165233.404c8b9c.kamezawa.hiroyu@jp.fujitsu.com>
	<20081001170005.1997d7c8.kamezawa.hiroyu@jp.fujitsu.com>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Oct 2008 17:00:05 +0900, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> Free page_cgroup from its LRU in batched manner.
> 
> When uncharge() is called, page is pushed onto per-cpu vector and
> removed from LRU, later.. This routine resembles to global LRU's pagevec.
> This patch is half of the whole patch and a set with following lazy LRU add
> patch.
> 
> After this, a pc, which is PageCgroupLRU(pc)==true, is on LRU.
> This LRU bit is guarded by lru_lock().
> 
>  PageCgroupUsed(pc) && PageCgroupLRU(pc) means "pc" is used and on LRU.
>  This check makes sense only when both 2 locks, lock_page_cgroup()/lru_lock(),
>  are aquired.
> 
>  PageCgroupUsed(pc) && !PageCgroupLRU(pc) means "pc" is used but not on LRU.
>  !PageCgroupUsed(pc) && PageCgroupLRU(pc) means "pc" is unused but still on
>  LRU. lru walk routine should avoid touching this.
> 
> Changelog (v5) => (v6):
>  - Fixing race and added PCG_LRU bit
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 

(snip)

> +static void
> +__release_page_cgroup(struct memcg_percpu_vec *mpv)
> +{
> +	unsigned long flags;
> +	struct mem_cgroup_per_zone *mz, *prev_mz;
> +	struct page_cgroup *pc;
> +	int i, nr;
> +
> +	local_irq_save(flags);
> +	nr = mpv->nr;
> +	mpv->nr = 0;
> +	prev_mz = NULL;
> +	for (i = nr - 1; i >= 0; i--) {
> +		pc = mpv->vec[i];
> +		mz = page_cgroup_zoneinfo(pc);
> +		if (prev_mz != mz) {
> +			if (prev_mz)
> +				spin_unlock(&prev_mz->lru_lock);
> +			prev_mz = mz;
> +			spin_lock(&mz->lru_lock);
> +		}
> +		/*
> +		 * this "pc" may be charge()->uncharge() while we are waiting
> +		 * for this. But charge() path check LRU bit and remove this
> +		 * from LRU if necessary.
> +		 */
> +		if (!PageCgroupUsed(pc) && PageCgroupLRU(pc)) {
> +			ClearPageCgroupLRU(pc);
> +			__mem_cgroup_remove_list(mz, pc);
> +			css_put(&pc->mem_cgroup->css);
> +		}
> +	}
> +	if (prev_mz)
> +		spin_unlock(&prev_mz->lru_lock);
> +	local_irq_restore(flags);
> +
> +}
> +
I'm wondering if page_cgroup_zoneinfo is safe without lock_page_cgroup
because it dereferences pc->mem_cgroup.
I'm worring if the pc has been moved to another lru by re-charge(and re-uncharge),
and __mem_cgroup_remove_list toches a wrong(old) group.

Hmm, there are many things to be done for re-charge and re-uncharge,
so "if (!PageCgroupUsed(pc) && PageCgroupLRU(pc))" would be enough.
(it can avoid race between re-charge.)

Another user of page_cgroup_zoneinfo without lock_page_cgroup is
__mem_cgroup_move_lists called by mem_cgroup_isolate_pages,
but mem_cgroup_isolate_pages handles pc which is actually on the mz->lru
so it would be ok.
(I think adding VM_BUG_ON(mz != page_cgroup_zoneifno(pc)) would make sense,
or add new arg *mz to __mem_cgroup_move_lists?)


Thanks,
Daisuke Nishimura.
