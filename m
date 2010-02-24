Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758167Ab0BXVVM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 16:21:12 -0500
Received: from smtp-out.google.com ([216.239.33.17]:48001 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758155Ab0BXVVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 16:21:10 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=vxBCWIdJ6TSpPv9NerBq6NT2ncVDb3m+MOoD+KMMX1Cw8TGT4qMf+e2caKcZqXlBz
	QzKx+7JwIshH6HX6spqeg==
Date: Wed, 24 Feb 2010 13:21:00 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
cc: linux-kernel@vger.kernel.org, akinobu.mita@gmail.com
Subject: Re: [PATCH] failslab: add ability to filter slab caches
In-Reply-To: <87bpfe8ooj.fsf_-_@openvz.org>
Message-ID: <alpine.DEB.2.00.1002241312250.6379@chino.kir.corp.google.com>
References: <1266931960-9779-1-git-send-email-dmonakhov@openvz.org> <alpine.DEB.2.00.1002231432530.8693@chino.kir.corp.google.com> <87bpfe8ooj.fsf_-_@openvz.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Feb 2010, Dmitry Monakhov wrote:

> >> Example:
> >> echo 1 > /sys/kernel/slab/skbuff_head_cache/failslab
> >> echo 1 > /sys/kernel/debug/failslab/cache-filter
> >> 
> >
> > Where's the changelog?
> I've hoped than subject is enough. But if you want more verbose
> changelog, take following version.
> 

Please do not attach patches to emails when sending to LKML, they are 
preferred to be inline.  See Documentation/SubmittingPatches.

> This patch allow to inject faults only for specific slabs.
> In order to preserve default behavior cache filter is off by
> default (all caches are faulty).
> 
> One may define specific set of slabs like this:
> # mark skbuff_head_cache as faulty
> echo 1 > /sys/kernel/slab/skbuff_head_cache/failslab
> # Turn on cache filter (off by default)
> echo 1 > /sys/kernel/debug/failslab/cache-filter
> # Turn on fault injection
> echo 1 > /sys/kernel/debug/failslab/times
> echo 1 > /sys/kernel/debug/failslab/probability
> 

Please describe your new slub_debug=a option here as well as in an update 
to Documentation/vm/slub.txt.

> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  include/linux/fault-inject.h |    4 ++--
>  include/linux/slab.h         |    4 +++-
>  mm/failslab.c                |   18 +++++++++++++++---
>  mm/slab.c                    |    2 +-
>  mm/slub.c                    |   31 +++++++++++++++++++++++++++++--
>  5 files changed, 50 insertions(+), 9 deletions(-)
> 
> diff --git a/include/linux/fault-inject.h b/include/linux/fault-inject.h
> index 06ca9b2..d935647 100644
> --- a/include/linux/fault-inject.h
> +++ b/include/linux/fault-inject.h
> @@ -82,9 +82,9 @@ static inline void cleanup_fault_attr_dentries(struct fault_attr *attr)
>  #endif /* CONFIG_FAULT_INJECTION */
>  
>  #ifdef CONFIG_FAILSLAB
> -extern bool should_failslab(size_t size, gfp_t gfpflags);
> +extern bool should_failslab(size_t size, gfp_t gfpflags, unsigned long c_flags);
>  #else
> -static inline bool should_failslab(size_t size, gfp_t gfpflags)
> +static inline bool should_failslab(size_t size, gfp_t gfpflags, unsigned long f)
>  {
>  	return false;
>  }

As I said in the first review, these need to be more descriptive: 'flags' 
would be better.

> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index 2da8372..9e03a81 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -70,7 +70,9 @@
>  #else
>  # define SLAB_NOTRACK		0x00000000UL
>  #endif
> -
> +#ifdef CONFIG_FAILSLAB
> +# define SLAB_FAILSLAB	0x02000000UL	/* Fault injection filter mark */
> +#endif 

Trailing whitespace on your #endif.

>  /* The following flags affect the page allocator grouping pages by mobility */
>  #define SLAB_RECLAIM_ACCOUNT	0x00020000UL		/* Objects are reclaimable */
>  #define SLAB_TEMPORARY		SLAB_RECLAIM_ACCOUNT	/* Objects are short-lived */
> diff --git a/mm/failslab.c b/mm/failslab.c
> index 9339de5..bb41f98 100644
> --- a/mm/failslab.c
> +++ b/mm/failslab.c
> @@ -1,18 +1,22 @@
>  #include <linux/fault-inject.h>
>  #include <linux/gfp.h>
> +#include <linux/slab.h>
>  
>  static struct {
>  	struct fault_attr attr;
>  	u32 ignore_gfp_wait;
> +	int cache_filter;
>  #ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
>  	struct dentry *ignore_gfp_wait_file;
> +	struct dentry *cache_filter_file;
>  #endif
>  } failslab = {
>  	.attr = FAULT_ATTR_INITIALIZER,
>  	.ignore_gfp_wait = 1,
> +	.cache_filter = 0,
>  };
>  
> -bool should_failslab(size_t size, gfp_t gfpflags)
> +bool should_failslab(size_t size, gfp_t gfpflags, unsigned long cache_flags)
>  {
>  	if (gfpflags & __GFP_NOFAIL)
>  		return false;
> @@ -20,6 +24,9 @@ bool should_failslab(size_t size, gfp_t gfpflags)
>          if (failslab.ignore_gfp_wait && (gfpflags & __GFP_WAIT))
>  		return false;
>  
> +	if (failslab.cache_filter && !(cache_flags & SLAB_FAILSLAB))
> +		return false;
> +
>  	return should_fail(&failslab.attr, size);
>  }
>  
> @@ -30,7 +37,6 @@ static int __init setup_failslab(char *str)
>  __setup("failslab=", setup_failslab);
>  
>  #ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
> -
>  static int __init failslab_debugfs_init(void)
>  {
>  	mode_t mode = S_IFREG | S_IRUSR | S_IWUSR;
> @@ -46,8 +52,14 @@ static int __init failslab_debugfs_init(void)
>  		debugfs_create_bool("ignore-gfp-wait", mode, dir,
>  				      &failslab.ignore_gfp_wait);
>  
> -	if (!failslab.ignore_gfp_wait_file) {
> +	failslab.cache_filter_file =
> +		debugfs_create_bool("cache-filter", mode, dir,
> +				      &failslab.cache_filter);
> +
> +	if (!failslab.ignore_gfp_wait_file ||
> +	    !failslab.cache_filter_file) {
>  		err = -ENOMEM;
> +		debugfs_remove(failslab.cache_filter_file);
>  		debugfs_remove(failslab.ignore_gfp_wait_file);
>  		cleanup_fault_attr_dentries(&failslab.attr);
>  	}
> diff --git a/mm/slab.c b/mm/slab.c
> index 7451bda..33496b7 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -3101,7 +3101,7 @@ static bool slab_should_failslab(struct kmem_cache *cachep, gfp_t flags)
>  	if (cachep == &cache_cache)
>  		return false;
>  
> -	return should_failslab(obj_size(cachep), flags);
> +	return should_failslab(obj_size(cachep), flags, cachep->flags);
>  }
>  

cachep->flags for CONFIG_SLAB is of type unsigned int and 
should_failslab() takes an unsigned long.

>  static inline void *____cache_alloc(struct kmem_cache *cachep, gfp_t flags)
> diff --git a/mm/slub.c b/mm/slub.c
> index 8d71aaf..64114fa 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -151,7 +151,8 @@
>   * Set of flags that will prevent slab merging
>   */
>  #define SLUB_NEVER_MERGE (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER | \
> -		SLAB_TRACE | SLAB_DESTROY_BY_RCU | SLAB_NOLEAKTRACE)
> +		SLAB_TRACE | SLAB_DESTROY_BY_RCU | SLAB_NOLEAKTRACE | \
> +		SLAB_FAILSLAB)
>  
>  #define SLUB_MERGE_SAME (SLAB_DEBUG_FREE | SLAB_RECLAIM_ACCOUNT | \
>  		SLAB_CACHE_DMA | SLAB_NOTRACK)

As I mentioned in my first review of your patch, this breaks for 
CONFIG_FAILSLAB=n.  Please make sure your patch compiles for the 
defconfig.
