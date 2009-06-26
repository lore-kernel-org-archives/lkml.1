Return-Path: <linux-kernel-owner+w=401wt.eu-S1757510AbZFZJEF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510AbZFZJEF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 05:04:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754926AbZFZJDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 05:03:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38950 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754963AbZFZJDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 05:03:55 -0400
Date: Fri, 26 Jun 2009 11:03:55 +0200
From: Nick Piggin <npiggin@suse.de>
To: Matt Mackall <mpm@selenic.com>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, cl@linux-foundation.org, penberg@cs.helsinki.fi,
       jdb@comx.dk
Subject: Re: [PATCH RFC] fix RCU-callback-after-kmem_cache_destroy problem in sl[aou]b
Message-ID: <20090626090355.GA11450@wotan.suse.de>
References: <20090625193137.GA16861@linux.vnet.ibm.com> <1245965239.21085.393.camel@calx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245965239.21085.393.camel@calx>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 25, 2009 at 04:27:19PM -0500, Matt Mackall wrote:
> On Thu, 2009-06-25 at 12:31 -0700, Paul E. McKenney wrote:
> > Hello!
> > 
> > Jesper noted that kmem_cache_destroy() invokes synchronize_rcu() rather
> > than rcu_barrier() in the SLAB_DESTROY_BY_RCU case, which could result
> > in RCU callbacks accessing a kmem_cache after it had been destroyed.
> > 
> > The following untested (might not even compile) patch proposes a fix.
> 
> Acked-by: Matt Mackall <mpm@selenic.com>
> 
> Nick, you'll want to make sure you get this in SLQB.

Thanks Matt. Paul, I think this should be appropriate for
stable@kernel.org too?

> 
> > Reported-by: Jesper Dangaard Brouer <jdb@comx.dk>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> > 
> >  slab.c |    2 +-
> >  slob.c |    2 ++
> >  slub.c |    2 ++
> >  3 files changed, 5 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mm/slab.c b/mm/slab.c
> > index e74a16e..5241b65 100644
> > --- a/mm/slab.c
> > +++ b/mm/slab.c
> > @@ -2547,7 +2547,7 @@ void kmem_cache_destroy(struct kmem_cache *cachep)
> >  	}
> >  
> >  	if (unlikely(cachep->flags & SLAB_DESTROY_BY_RCU))
> > -		synchronize_rcu();
> > +		rcu_barrier();
> >  
> >  	__kmem_cache_destroy(cachep);
> >  	mutex_unlock(&cache_chain_mutex);
> > diff --git a/mm/slob.c b/mm/slob.c
> > index c78742d..9641da3 100644
> > --- a/mm/slob.c
> > +++ b/mm/slob.c
> > @@ -595,6 +595,8 @@ EXPORT_SYMBOL(kmem_cache_create);
> >  void kmem_cache_destroy(struct kmem_cache *c)
> >  {
> >  	kmemleak_free(c);
> > +	if (c->flags & SLAB_DESTROY_BY_RCU)
> > +		rcu_barrier();
> >  	slob_free(c, sizeof(struct kmem_cache));
> >  }
> >  EXPORT_SYMBOL(kmem_cache_destroy);
> > diff --git a/mm/slub.c b/mm/slub.c
> > index 819f056..a9201d8 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -2595,6 +2595,8 @@ static inline int kmem_cache_close(struct kmem_cache *s)
> >   */
> >  void kmem_cache_destroy(struct kmem_cache *s)
> >  {
> > +	if (s->flags & SLAB_DESTROY_BY_RCU)
> > +		rcu_barrier();
> >  	down_write(&slub_lock);
> >  	s->refcount--;
> >  	if (!s->refcount) {
> 
> -- 
> http://selenic.com : development and support for Mercurial and Linux
> 
