Return-Path: <linux-kernel-owner+w=401wt.eu-S1754035AbYJAIf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035AbYJAIf3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 04:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752085AbYJAIfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 04:35:20 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:55040 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbYJAIfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 04:35:19 -0400
Date: Wed, 1 Oct 2008 17:33:13 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: nishimura@mxp.nes.nec.co.jp, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/6] memcg: charge-commit-cancel protocl
Message-Id: <20081001173313.69fb8c74.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20081001165734.e484cfe4.kamezawa.hiroyu@jp.fujitsu.com>
References: <20081001165233.404c8b9c.kamezawa.hiroyu@jp.fujitsu.com>
	<20081001165734.e484cfe4.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -531,18 +529,33 @@ static int mem_cgroup_charge_common(stru
>  
>  		if (!nr_retries--) {
>  			mem_cgroup_out_of_memory(mem, gfp_mask);
> -			goto out;
> +			goto nomem;
>  		}
>  	}
> +	return 0;
> +nomem:
> +	css_put(&mem->css);
> +	return -ENOMEM;
> +}
>  
> +/*
> + * commit a charge got by mem_cgroup_try_charge() and makes page_cgroup to be
> + * USED state. If already USED, uncharge and return.
> + */
> +
> +static void __mem_cgroup_commit_charge(struct mem_cgroup *mem,
> +				     struct page_cgroup *pc,
> +				     enum charge_type ctype)
> +{
> +	struct mem_cgroup_per_zone *mz;
> +	unsigned long flags;
>  
>  	lock_page_cgroup(pc);
>  	if (unlikely(PageCgroupUsed(pc))) {
>  		unlock_page_cgroup(pc);
>  		res_counter_uncharge(&mem->res, PAGE_SIZE);
>  		css_put(&mem->css);
> -
> -		goto done;
> +		return;
>  	}
>  	pc->mem_cgroup = mem;
>  	/*

Hmm, this patch cannot be applied because of this part.

After [2/6], mem_cgroup_charge_common looks like:

---
                if (!nr_retries--) {
                        mem_cgroup_out_of_memory(mem, gfp_mask);
                        goto out;
                }
        }


        lock_page_cgroup(pc);

        if (unlikely(PageCgroupUsed(pc))) {
                unlock_page_cgroup(pc);
                res_counter_uncharge(&mem->res, PAGE_SIZE);
                css_put(&mem->css);

                goto done;
        }
        pc->mem_cgroup = mem;
        /*
---

There is an empty line after lock_page_cgroup.

After removing this line, I can appliy this patch(and [4-6/6]).


Thanks,
Daisuke Nishimura.

