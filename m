Return-Path: <linux-kernel-owner+w=401wt.eu-S1753460AbYL3W3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460AbYL3W3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 17:29:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753105AbYL3W3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 17:29:07 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44445 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751063AbYL3W3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 17:29:06 -0500
Date: Tue, 30 Dec 2008 14:28:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: miaox@cn.fujitsu.com
Cc: menage@google.com, cl@linux-foundation.org, penberg@cs.helsinki.fi,
       mpm@selenic.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] cpuset,mm: fix allocating page cache/slab object on the
 unallowed node when memory spread is set
Message-Id: <20081230142805.3c6f78e3.akpm@linux-foundation.org>
In-Reply-To: <49547B93.5090905@cn.fujitsu.com>
References: <49547B93.5090905@cn.fujitsu.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Dec 2008 14:37:07 +0800
Miao Xie <miaox@cn.fujitsu.com> wrote:

> The task still allocated the page caches on old node after modifying its
> cpuset's mems when 'memory_spread_page' was set, it is caused by the old
> mem_allowed_list of the task. Slab has the same problem.

ok...

> diff --git a/mm/filemap.c b/mm/filemap.c
> index f3e5f89..d978983 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -517,6 +517,9 @@ int add_to_page_cache_lru(struct page *page, struct address_space *mapping,
>  #ifdef CONFIG_NUMA
>  struct page *__page_cache_alloc(gfp_t gfp)
>  {
> +	if ((gfp & __GFP_WAIT) && !in_interrupt())
> +		cpuset_update_task_memory_state();
> +
>  	if (cpuset_do_page_mem_spread()) {
>  		int n = cpuset_mem_spread_node();
>  		return alloc_pages_node(n, gfp, 0);
> diff --git a/mm/slab.c b/mm/slab.c
> index 0918751..3b6e3d7 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -3460,6 +3460,9 @@ __cache_alloc(struct kmem_cache *cachep, gfp_t flags, void *caller)
>  	if (should_failslab(cachep, flags))
>  		return NULL;
>  
> +	if ((flags & __GFP_WAIT) && !in_interrupt())
> +		cpuset_update_task_memory_state();
> +
>  	cache_alloc_debugcheck_before(cachep, flags);
>  	local_irq_save(save_flags);
>  	objp = __do_cache_alloc(cachep, flags);

Problems.

a) There's no need to test in_interrupt().  Any caller who passed us
   __GFP_WAIT from interrupt context is horridly buggy and needs to be
   fixed.

b) Even if the caller _did_ set __GFP_WAIT, there's no guarantee
   that we're deadlock safe here.  Does anyone ever do a __GFP_WAIT
   allocation while holding callback_mutex?  If so, it'll deadlock.

c) These are two of the kernel's hottest code paths.  We really
   really really really don't want to be polling for some dopey
   userspace admin change on each call to __cache_alloc()!

d) How does slub handle this problem?
