Return-Path: <linux-kernel-owner+w=401wt.eu-S934250AbZIDUmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934250AbZIDUmy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 16:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933979AbZIDUmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 16:42:53 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:41892 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933903AbZIDUmw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 16:42:52 -0400
Date: Fri, 4 Sep 2009 13:42:51 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Patrick McHardy <kaber@trash.net>, Robin Holt <holt@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesper Dangaard Brouer <hawk@comx.dk>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Netfilter Developers <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH] slub: fix slab_pad_check()
Message-ID: <20090904204251.GA15413@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4A9F7283.1090306@gmail.com> <alpine.DEB.1.10.0909031244230.27903@V090114053VZO-1> <4A9FCDC6.3060003@gmail.com> <alpine.DEB.1.10.0909031335430.29881@V090114053VZO-1> <4A9FDA72.8060001@gmail.com> <alpine.DEB.1.10.0909031414310.29881@V090114053VZO-1> <20090903174435.GF6761@linux.vnet.ibm.com> <alpine.DEB.1.10.0909031736340.24199@V090114053VZO-1> <4AA03E6A.7070800@gmail.com> <4AA0407E.8030505@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4AA0407E.8030505@gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 04, 2009 at 12:17:34AM +0200, Eric Dumazet wrote:
> Eric Dumazet a écrit :
> > 
> > 
> > 
> > Problem is not _objects_ Christoph, but _slabs_, and your patch is not working.
> > 
> > Its true that when User calls kmem_cache_destroy(), all _objects_ were previously freed.
> > This is mandatory, with or withou SLAB_DESTROY_BY_RCU thing
> > 
> > Problem is that slub has some internal state, including some to-be-freed _slabs_,
> > that User have no control at all on it.
> > 
> > User cannot "know" slabs are freed, inuse, or whatever state in cache or call_rcu queues.
> > 
> > Face it, SLAB_DESTROY_BY_RCU is internal affair (to slub/slab/... allocators)
> > 
> > We absolutely need a rcu_barrier() somewhere, believe it or not. You can argue that it should
> > be done *before*, but it gives no speedup, only potential bugs.
> > 
> > Only case User should do its rcu_barrier() itself is if it knows some call_rcu() are pending
> > and are delaying _objects_ freeing (typical !SLAB_DESTROY_RCU usage in RCU algos).
> > 
> > I dont even understand why you care so much about kmem_cache_destroy(SLAB_DESTROY_BY_RCU),
> > given that almost nobody use it. We took almost one month to find out what the bug was in first
> > place...
> 
> 
> So maybe the safest thing would be to include the rcu_barrier() to
> insure all objects where freed

I argue that the above is the user's responsibility.  That said, I don't
see why the user would pass a SLAB_DESTROY_BY_RCU object to call_rcu().
So I would want to see an example of this before inflicting a pair
of rcu_barrier() calls on kmem_cache_destroy().

> And another one for SLAB_DESTROY_BY_RCU to make sure slabs where freed

This last is I believe kmem_cache's responsibility.

							Thanx, Paul

> void kmem_cache_destroy(struct kmem_cache *s)
> {
> 	/*
> 	 * Make sure no objects are waiting in call_rcu queues to be freed
> 	 */
> 	rcu_barrier();
> 
> 	down_write(&slub_lock);
> 	s->refcount--;
> 	if (!s->refcount) {
>                 list_del(&s->list);
>                 up_write(&slub_lock);
>                 if (kmem_cache_close(s)) {
>                         printk(KERN_ERR "SLUB %s: %s called for cache that "
>                                 "still has objects.\n", s->name, __func__);
>                         dump_stack();
>                 }
> 		/*
> 		 * Make sure no slabs are waiting in call_rcu queues to be freed
> 		 */
>                 if (s->flags & SLAB_DESTROY_BY_RCU)
>                         rcu_barrier();
>                 sysfs_slab_remove(s);
>         } else
>                 up_write(&slub_lock);
> }
