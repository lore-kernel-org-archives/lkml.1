Return-Path: <linux-kernel-owner+w=401wt.eu-S1754905AbYJ3L1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905AbYJ3L1h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 07:27:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753495AbYJ3L10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 07:27:26 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35750 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753191AbYJ3L1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 07:27:25 -0400
Date: Thu, 30 Oct 2008 09:28:54 -0200
From: Glauber Costa <glommer@redhat.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, aliguori@codemonkey.ws,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Krzysztof Helt <krzysztof.h1@poczta.fm>
Subject: Re: [PATCH] regression: vmalloc easily fail.
Message-ID: <20081030112854.GA18634@poweredge.glommer>
References: <1225234513-3996-1-git-send-email-glommer@redhat.com> <20081028232944.GA3759@wotan.suse.de> <20081029094856.GD4269@poweredge.glommer> <20081029101145.GB5953@wotan.suse.de> <49083B14.6070402@redhat.com> <20081029104333.GD5953@wotan.suse.de> <20081029220737.GF11532@poweredge.glommer> <20081030044941.GA9470@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081030044941.GA9470@wotan.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2008 at 05:49:41AM +0100, Nick Piggin wrote:
> On Wed, Oct 29, 2008 at 08:07:37PM -0200, Glauber Costa wrote:
> > On Wed, Oct 29, 2008 at 11:43:33AM +0100, Nick Piggin wrote:
> > > On Wed, Oct 29, 2008 at 12:29:40PM +0200, Avi Kivity wrote:
> > > > Nick Piggin wrote:
> > > > >Hmm, spanning <30MB of memory... how much vmalloc space do you have?
> > > > >
> > > > >  
> > > > 
> > > > From the original report:
> > > > 
> > > > >VmallocTotal:     122880 kB
> > > > >VmallocUsed:       15184 kB
> > > > >VmallocChunk:      83764 kB
> > > > 
> > > > So it seems there's quite a bit of free space.
> > > > 
> > > > Chunk is the largest free contiguous region, right?  If so, it seems the 
> > > 
> > > Yes.
> > > 
> > > 
> > > > problem is unrelated to guard pages, instead the search isn't finding a 
> > > > 1-page area (with two guard pages) for some reason, even though lots of 
> > > > free space is available.
> > > 
> > > Hmm. The free area search could be buggy...
> > Do you want me to grab any specific info of it? Or should I just hack myself
> > randomly into it? I'll probably have some time for that tomorrow.
> 
> I took a bit of a look. Does this help you at all?
> 
> I still think we should get rid of the guard pages in non-debug kernels
> completely, but hopefully this will fix your problems?
unfortunately, it doesn't.
problem still happen in a kernel with this patch.

> --
> 
> - Fix off by one bug in the KVA allocator that can leave gaps 
> - An initial vmalloc failure should start off a synchronous flush of lazy
>   areas, in case someone is in progress flushing them already.
> - Purge lock can be a mutex so we can sleep while that's going on.
>  
> Signed-off-by: Nick Piggin <npiggin@suse.de>
> ---
> Index: linux-2.6/mm/vmalloc.c
> ===================================================================
> --- linux-2.6.orig/mm/vmalloc.c
> +++ linux-2.6/mm/vmalloc.c
> @@ -14,6 +14,7 @@
>  #include <linux/highmem.h>
>  #include <linux/slab.h>
>  #include <linux/spinlock.h>
> +#include <linux/mutex.h>
>  #include <linux/interrupt.h>
>  #include <linux/proc_fs.h>
>  #include <linux/seq_file.h>
> @@ -362,7 +363,7 @@ retry:
>  				goto found;
>  		}
>  
> -		while (addr + size >= first->va_start && addr + size <= vend) {
> +		while (addr + size > first->va_start && addr + size <= vend) {
>  			addr = ALIGN(first->va_end + PAGE_SIZE, align);
>  
>  			n = rb_next(&first->rb_node);
> @@ -472,7 +473,7 @@ static atomic_t vmap_lazy_nr = ATOMIC_IN
>  static void __purge_vmap_area_lazy(unsigned long *start, unsigned long *end,
>  					int sync, int force_flush)
>  {
> -	static DEFINE_SPINLOCK(purge_lock);
> +	static DEFINE_MUTEX(purge_lock);
>  	LIST_HEAD(valist);
>  	struct vmap_area *va;
>  	int nr = 0;
> @@ -483,10 +484,10 @@ static void __purge_vmap_area_lazy(unsig
>  	 * the case that isn't actually used at the moment anyway.
>  	 */
>  	if (!sync && !force_flush) {
> -		if (!spin_trylock(&purge_lock))
> +		if (!mutex_trylock(&purge_lock))
>  			return;
>  	} else
> -		spin_lock(&purge_lock);
> +		mutex_lock(&purge_lock);
>  
>  	rcu_read_lock();
>  	list_for_each_entry_rcu(va, &vmap_area_list, list) {
> @@ -518,7 +519,18 @@ static void __purge_vmap_area_lazy(unsig
>  			__free_vmap_area(va);
>  		spin_unlock(&vmap_area_lock);
>  	}
> -	spin_unlock(&purge_lock);
> +	mutex_unlock(&purge_lock);
> +}
> +
> +/*
> + * Kick off a purge of the outstanding lazy areas. Don't bother if somebody
> + * is already purging.
> + */
> +static void try_purge_vmap_area_lazy(void)
> +{
> +	unsigned long start = ULONG_MAX, end = 0;
> +
> +	__purge_vmap_area_lazy(&start, &end, 0, 0);
>  }
>  
>  /*
> @@ -528,7 +540,7 @@ static void purge_vmap_area_lazy(void)
>  {
>  	unsigned long start = ULONG_MAX, end = 0;
>  
> -	__purge_vmap_area_lazy(&start, &end, 0, 0);
> +	__purge_vmap_area_lazy(&start, &end, 1, 0);
>  }
>  
>  /*
> @@ -539,7 +551,7 @@ static void free_unmap_vmap_area(struct 
>  	va->flags |= VM_LAZY_FREE;
>  	atomic_add((va->va_end - va->va_start) >> PAGE_SHIFT, &vmap_lazy_nr);
>  	if (unlikely(atomic_read(&vmap_lazy_nr) > lazy_max_pages()))
> -		purge_vmap_area_lazy();
> +		try_purge_vmap_area_lazy();
>  }
>  
>  static struct vmap_area *find_vmap_area(unsigned long addr)
