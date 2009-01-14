Return-Path: <linux-kernel-owner+w=401wt.eu-S1757362AbZANOZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757362AbZANOZK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 09:25:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbZANOY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 09:24:57 -0500
Received: from mx2.redhat.com ([66.187.237.31]:56150 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766AbZANOY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 09:24:56 -0500
Subject: Re: [PATCH] lib/idr.c: Zero memory properly in idr_remove_all
From: Kristian =?ISO-8859-1?Q?H=F8gsberg?= <krh@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Manfred Spraul <manfred@colorfullife.com>, stefanr@s5r6.in-berlin.de,
       dcm@acm.org, Nadia.Derbey@bull.net,
       linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       paulmck@us.ibm.com
In-Reply-To: <20090113144802.39dc4c23.akpm@linux-foundation.org>
References: <1231571060.3538.18.camel@localhost.localdomain>
	 <49686465.70501@s5r6.in-berlin.de>
	 <20090110011557.9d94e111.akpm@linux-foundation.org>
	 <496872E0.9030007@s5r6.in-berlin.de>
	 <1231773620.6365.21.camel@gaara.bos.redhat.com>
	 <496B9FC7.3090108@colorfullife.com>
	 <1231792712.6365.31.camel@gaara.bos.redhat.com>
	 <496BAD1C.5060201@colorfullife.com>
	 <20090113144802.39dc4c23.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 14 Jan 2009 09:23:10 -0500
Message-Id: <1231942990.8542.7.camel@gaara.bos.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-13 at 14:48 -0800, Andrew Morton wrote:
> On Mon, 12 Jan 2009 21:50:36 +0100
> Manfred Spraul <manfred@colorfullife.com> wrote:
> 
> > Kristian H__gsberg wrote:
> > > On Mon, 2009-01-12 at 20:53 +0100, Manfred Spraul wrote:
> > >   
> > >> Kristian H__gsberg wrote:
> > >>     
> > >>>   The problem
> > >>> isn't about returning un-zeroed-out objects to the kmem cache, the
> > >>> problem is returning them to the idr free list.
> > >>>   
> > >>>       
> > >> I think this is wrong:
> > >> The slab allocator assumes that the objects that are given to 
> > >> kmem_cache_free() are properly constructed.
> > >> I.e.: No additional constructor is called prior to returning the object 
> > >> from the next kmem_cache_alloc() call.
> > >>     
> > >
> > > That's fine, the ctor associated with the kmem cache is called, and in
> > > the case of idr, it does a memset().
> > >   
> > No.
> > As I said, the construtor is not called.
> > An object that is given to kmem_cache_free() must be properly constructed.
> > kmem_cache_free() just adds the obj pointer to a list, the next 
> > kmem_cache_alloc returns the pointer.
> > 
> > This is also documented in mm/slab.c:
> >  * The memory is organized in caches, one cache for each object type.
> >  * (e.g. inode_cache, dentry_cache, buffer_head, vm_area_struct)
> >  * Each cache consists out of many slabs (they are small (usually one
> >  * page long) and always contiguous), and each slab contains multiple
> >  * initialized objects.
> >  *
> >  * This means, that your constructor is used only for newly allocated
> >  * slabs and you must pass objects with the same initializations to
> >  * kmem_cache_free.
> >  *
> > 
> > If the idr code passes uninitialized objects to kmem_cache_free(), then 
> > the next kmem_cache_alloc will return a bad object.
> > 
> 
> None of this got us much closer to fixing the bug ;)
> 
> What do we think of just removing the constructor and using
> kmem_cache_zalloc()?

We still need to zero out the idr_layer before returning it to the idr's
internal free list.  I had a memset(p, 0, sizeof *p) just before the
free_layer() call in idr_remove_all() in the original version.  I don't
know why that was taken out (some rcu thing?) but if you're looking for
a minimal change to just fix the bug, just put that back in.  Or maybe
it now needs to be in idr_layer_rcu_free(), I never really figured out
how rcu works.

> --- a/lib/idr.c~a
> +++ a/lib/idr.c
> @@ -121,7 +121,7 @@ int idr_pre_get(struct idr *idp, gfp_t g
>  {
>  	while (idp->id_free_cnt < IDR_FREE_MAX) {
>  		struct idr_layer *new;
> -		new = kmem_cache_alloc(idr_layer_cache, gfp_mask);
> +		new = kmem_cache_zalloc(idr_layer_cache, gfp_mask);
>  		if (new == NULL)
>  			return (0);
>  		move_to_free_list(idp, new);
> @@ -623,16 +623,10 @@ void *idr_replace(struct idr *idp, void 
>  }
>  EXPORT_SYMBOL(idr_replace);
>  
> -static void idr_cache_ctor(void *idr_layer)
> -{
> -	memset(idr_layer, 0, sizeof(struct idr_layer));
> -}
> -
>  void __init idr_init_cache(void)
>  {
>  	idr_layer_cache = kmem_cache_create("idr_layer_cache",
> -				sizeof(struct idr_layer), 0, SLAB_PANIC,
> -				idr_cache_ctor);
> +				sizeof(struct idr_layer), 0, SLAB_PANIC, NULL);
>  }
>  
>  /**
> _
> 

