Return-Path: <linux-kernel-owner+w=401wt.eu-S1752860AbZBWGEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860AbZBWGEq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 01:04:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbZBWGEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 01:04:37 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:59117 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbZBWGEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 01:04:36 -0500
Date: Mon, 23 Feb 2009 14:58:28 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       nishimura@mxp.nes.nec.co.jp
Subject: Re: [RFC][PATCH] Reduce size of swap_cgroup by CSS ID v2
Message-Id: <20090223145828.d14ff015.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20090209145557.d0754a9f.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090205185959.7971dee4.kamezawa.hiroyu@jp.fujitsu.com>
	<20090209145557.d0754a9f.kamezawa.hiroyu@jp.fujitsu.com>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm sorry for my late reply.

It looks good basically, but I have 1 comment.

>  static struct mem_cgroup *try_get_mem_cgroup_from_swapcache(struct page *page)
>  {
> -	struct mem_cgroup *mem;
> +	unsigned short id;
> +	struct mem_cgroup *mem = NULL;
>  	swp_entry_t ent;
>  
>  	if (!PageSwapCache(page))
>  		return NULL;
>  
>  	ent.val = page_private(page);
> -	mem = lookup_swap_cgroup(ent);
> -	if (!mem)
> -		return NULL;
> +	id = lookup_swap_cgroup(ent);
> +	rcu_read_lock();
> +	mem = mem_cgroup_lookup(id);
>  	if (!css_tryget(&mem->css))
We should check whether "mem" is NULL or not before css_tryget, because
"mem" can be NULL(or "id" can be 0) if the page is on swapcache,
that is, remove_from_swap_cache has not been called yet.

Actually, I got NULL pointer dereference bug here.

> -		return NULL;
> +		mem = NULL;
> +	rcu_read_unlock();
>  	return mem;
>  }
>  


Thanks,
Daisuke Nishimura.
