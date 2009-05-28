Return-Path: <linux-kernel-owner+w=401wt.eu-S1760583AbZE1ApQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760583AbZE1ApQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 20:45:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753863AbZE1ApF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 20:45:05 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:33280 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567AbZE1ApE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 20:45:04 -0400
Date: Thu, 28 May 2009 09:41:57 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [RFC][PATCH 2/5] add SWAP_HAS_CACHE flag to swap_map
Message-Id: <20090528094157.5c39ac57.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20090526121547.ce866fe4.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090526121259.b91b3e9d.kamezawa.hiroyu@jp.fujitsu.com>
	<20090526121547.ce866fe4.kamezawa.hiroyu@jp.fujitsu.com>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -1969,17 +2017,33 @@ int swap_duplicate(swp_entry_t entry)
>  	offset = swp_offset(entry);
>  
>  	spin_lock(&swap_lock);
> -	if (offset < p->max && p->swap_map[offset]) {
> -		if (p->swap_map[offset] < SWAP_MAP_MAX - 1) {
> -			p->swap_map[offset]++;
> +
> +	if (unlikely(offset >= p->max))
> +		goto unlock_out;
> +
> +	count = swap_count(p->swap_map[offset]);
> +	has_cache = swap_has_cache(p->swap_map[offset]);
> +	if (cache) {
> +		/* set SWAP_HAS_CACHE if there is no cache and entry is used */
> +		if (!has_cache && count) {
Should we check !has_cache here ?

Concurrent read_swap_cache_async() might have set SWAP_HAS_CACHE, but not have added
a page to swap cache yet when find_get_page() was called.
add_to_swap_cache() would handle the race of concurrent read_swap_cache_async(),
but considering more, swapcache_free() at the end of the loop might dangerous in this case...
So I think it should be like:

	read_swap_cache_async()
		:
		valid = swapcache_prepare(entry);
		if (!valid)
			break;
		if (valid == -EAGAIN);
			continue;

to let the context that succeeded in swapcache_prepare() do add_to_swap_cache().


Thanks,
Daisuke Nishimura.

> +			p->swap_map[offset] = make_swap_count(count, 1);
> +			result = 1;
> +		}
> +	} else if (count || has_cache) {
> +		if (count < SWAP_MAP_MAX - 1) {
> +			p->swap_map[offset] = make_swap_count(count + 1,
> +							      has_cache);
>  			result = 1;
> -		} else if (p->swap_map[offset] <= SWAP_MAP_MAX) {
> +		} else if (count <= SWAP_MAP_MAX) {
>  			if (swap_overflow++ < 5)
> -				printk(KERN_WARNING "swap_dup: swap entry overflow\n");
> -			p->swap_map[offset] = SWAP_MAP_MAX;
> +				printk(KERN_WARNING
> +				       "swap_dup: swap entry overflow\n");
> +			p->swap_map[offset] = make_swap_count(SWAP_MAP_MAX,
> +							      has_cache);
>  			result = 1;
>  		}
>  	}
> +unlock_out:
>  	spin_unlock(&swap_lock);
>  out:
>  	return result;
