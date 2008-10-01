Return-Path: <linux-kernel-owner+w=401wt.eu-S1753697AbYJAQj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697AbYJAQj3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 12:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753023AbYJAQjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 12:39:20 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:22034 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811AbYJAQjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 12:39:20 -0400
Date: Wed, 1 Oct 2008 09:38:04 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH 4/6] memcg: new force_empty and move_account
Message-Id: <20081001093804.b392e418.randy.dunlap@oracle.com>
In-Reply-To: <20081001165912.236af3e7.kamezawa.hiroyu@jp.fujitsu.com>
References: <20081001165233.404c8b9c.kamezawa.hiroyu@jp.fujitsu.com>
	<20081001165912.236af3e7.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Oct 2008 16:59:12 +0900 KAMEZAWA Hiroyuki wrote:

>  Documentation/controllers/memory.txt |   10 -
>  mm/memcontrol.c                      |  267 +++++++++++++++++++++++++++--------
>  2 files changed, 216 insertions(+), 61 deletions(-)
> 
> Index: mmotm-2.6.27-rc7+/mm/memcontrol.c
> ===================================================================
> --- mmotm-2.6.27-rc7+.orig/mm/memcontrol.c
> +++ mmotm-2.6.27-rc7+/mm/memcontrol.c
> @@ -538,6 +533,24 @@ nomem:
>  	return -ENOMEM;
>  }
>  
> +/**
> + * mem_cgroup_try_charge - get charge of PAGE_SIZE.
> + * @mm: an mm_struct which is charged against. (when *memcg is NULL)
> + * @gfp_mask: gfp_mask for reclaim.
> + * @memcg: a pointer to memory cgroup which is charged against.
> + *
> + * charge aginst memory cgroup pointed by *memcg. if *memcg == NULL, estimated
> + * memory cgroup from @mm is got and stored in *memcg.
> + *
> + * Retruns 0 if success. -ENOMEM at failure.
> + */
> +
> +int mem_cgroup_try_charge(struct mm_struct *mm,
> +			  gfp_t mask, struct mem_cgroup **memcg)
> +{
> +	return __mem_cgroup_try_charge(mm, mask, memcg, false);
> +}
> +
>  /*
>   * commit a charge got by mem_cgroup_try_charge() and makes page_cgroup to be
>   * USED state. If already USED, uncharge and return.
> @@ -567,11 +580,109 @@ static void __mem_cgroup_commit_charge(s
>  	mz = page_cgroup_zoneinfo(pc);
>  
>  	spin_lock_irqsave(&mz->lru_lock, flags);
> -	__mem_cgroup_add_list(mz, pc);
> +	__mem_cgroup_add_list(mz, pc, true);
>  	spin_unlock_irqrestore(&mz->lru_lock, flags);
>  	unlock_page_cgroup(pc);
>  }
>  
> +/**
> + * mem_cgroup_move_account - move account of the page
> + * @pc   ... page_cgroup of the page.
> + * @from ... mem_cgroup which the page is moved from.
> + * @to   ... mem_cgroup which the page is moved to. @from != @to.

Bad kernel-doc format.  Use (e.g.)
 * @pc: page_cgroup of the page

as was done in the function above.

> + *
> + * The caller must confirm following.
> + * 1. disable irq.
> + * 2. lru_lock of old mem_cgroup(@from) should be held.
> + *
> + * returns 0 at success,
> + * returns -EBUSY when lock is busy or "pc" is unstable.
> + *
> + * This function do "uncharge" from old cgroup but doesn't do "charge" to

                    does

> + * new cgroup. It should be done by a caller.
> + */
> +
> +static int mem_cgroup_move_account(struct page_cgroup *pc,
> +	struct mem_cgroup *from, struct mem_cgroup *to)
> +{
...
> +}
> +
> Index: mmotm-2.6.27-rc7+/Documentation/controllers/memory.txt
> ===================================================================
> --- mmotm-2.6.27-rc7+.orig/Documentation/controllers/memory.txt
> +++ mmotm-2.6.27-rc7+/Documentation/controllers/memory.txt
> @@ -211,7 +211,9 @@ The memory.force_empty gives an interfac
>  
>  # echo 1 > memory.force_empty
>  
> -will drop all charges in cgroup. Currently, this is maintained for test.
> +Will move account to parent. if parenet is full, will try to free pages.

                                If parent

> +If both of a parent and a child are busy, return -EBUSY;

maybe:
   If both parent and child are busy, return -EBUSY.

> +This file, memory.force_empty, is just for debug purpose.
>  
>  4. Testing
>  
> @@ -242,8 +244,10 @@ reclaimed.
>  
>  A cgroup can be removed by rmdir, but as discussed in sections 4.1 and 4.2, a
>  cgroup might have some charge associated with it, even though all
> -tasks have migrated away from it. Such charges are automatically dropped at
> -rmdir() if there are no tasks.
> +tasks have migrated away from it.
> +Such charges are moved to its parent as mush as possible and freed if parent

                                           much

> +seems to be full. (see force_empty)

seems??  Is it questionable/unsure?

> +If both of them are busy, rmdir() returns -EBUSY.
>  
>  5. TODO


---
~Randy
