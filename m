Return-Path: <linux-kernel-owner+w=401wt.eu-S1758049AbZFANIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049AbZFANIq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 09:08:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757038AbZFANI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 09:08:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33789 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755767AbZFANI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 09:08:26 -0400
Date: Mon, 1 Jun 2009 15:08:25 +0200
From: Nick Piggin <npiggin@suse.de>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: mingo@elte.hu, cl@linux-foundation.com, torvals@linux-foundation.org,
       mpm@selenic.com, yinghai@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] init: call vfs_caches_init_early() later in the boot sequence
Message-ID: <20090601130825.GA1422@wotan.suse.de>
References: <1243517365.11533.65.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243517365.11533.65.camel@penberg-laptop>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 04:29:25PM +0300, Pekka Enberg wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> There's no need to call vfs_caches_init_early() before kmem_cache_init(). All
> we have to do is make sure we don't attempt to use the bootmem allocator after
> we've called mem_init().

Hmm, but you'd want to be able to allocate > MAX_ORDER areas in the linear
KVA, which the page allocator cannot do. So this is just going to silently
truncate hash table size. Nack on this one.


> Cc: Christoph Lameter <cl@linux-foundation.com>
> Cc: Linus Torvalds <torvals@linux-foundation.org>
> Cc: Matt Mackall <mpm@selenic.com>
> Cc: Nick Piggin <npiggin@suse.de>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> ---
>  fs/dcache.c |    2 +-
>  fs/inode.c  |    2 +-
>  init/main.c |    2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/dcache.c b/fs/dcache.c
> index ee60ce4..6c48ba1 100644
> --- a/fs/dcache.c
> +++ b/fs/dcache.c
> @@ -2255,7 +2255,7 @@ static void __init dcache_init_early(void)
>  					sizeof(struct hlist_head),
>  					dhash_entries,
>  					13,
> -					HASH_EARLY,
> +					0,
>  					&d_hash_shift,
>  					&d_hash_mask,
>  					0);
> diff --git a/fs/inode.c b/fs/inode.c
> index 0571983..92379c8 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -1487,7 +1487,7 @@ void __init inode_init_early(void)
>  					sizeof(struct hlist_head),
>  					ihash_entries,
>  					14,
> -					HASH_EARLY,
> +					0,
>  					&i_hash_shift,
>  					&i_hash_mask,
>  					0);
> diff --git a/init/main.c b/init/main.c
> index 5a19578..f6bd51f 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -588,7 +588,6 @@ asmlinkage void __init start_kernel(void)
>  	 * kmem_cache_init()
>  	 */
>  	pidhash_init();
> -	vfs_caches_init_early();
>  	/*
>  	 * Set up kernel memory allocators
>  	 */
> @@ -658,6 +657,7 @@ asmlinkage void __init start_kernel(void)
>  		initrd_start = 0;
>  	}
>  #endif
> +	vfs_caches_init_early();
>  	cpuset_init_early();
>  	page_cgroup_init();
>  	enable_debug_pagealloc();
> -- 
> 1.6.0.4
> 
> 
