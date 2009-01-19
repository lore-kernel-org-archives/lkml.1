Return-Path: <linux-kernel-owner+w=401wt.eu-S1759656AbZASJyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759656AbZASJyy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 04:54:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759546AbZASJyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 04:54:37 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:40024 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759538AbZASJyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 04:54:36 -0500
Subject: Re: [PATCH] SLUB: Use WARN_ON instead of BUG_ON where appropriate
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0901141117070.26507@quilx.com>
References: <Pine.LNX.4.64.0901141719560.12990@melkki.cs.Helsinki.FI>
	 <Pine.LNX.4.64.0901141117070.26507@quilx.com>
Date: Mon, 19 Jan 2009 11:54:33 +0200
Message-Id: <1232358873.27569.3.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On Wed, 2009-01-14 at 11:45 -0600, Christoph Lameter wrote:
> On Wed, 14 Jan 2009, Pekka J Enberg wrote:
> 
> > From: Pekka Enberg <penberg@cs.helsinki.fi>
> >
> > It's better to WARN_ON and let the kernel limp along to increase the likelihood
> > of an user detecting the error and reporting it to us.
> 
> That only works if a error condition can be signaled and be handled
> appropriately.

Yes and I think the cases I converted we can.

> > diff --git a/mm/slub.c b/mm/slub.c
> > index 6392ae5..e4404a1 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -1119,7 +1119,8 @@ static struct page *new_slab(struct kmem_cache *s, gfp_t flags, int node)
> >  	void *last;
> >  	void *p;
> >
> > -	BUG_ON(flags & GFP_SLAB_BUG_MASK);
> > +	if (WARN_ON(flags & GFP_SLAB_BUG_MASK))
> > +		return NULL;
> >
> >  	page = allocate_slab(s,
> >  		flags & (GFP_RECLAIM_MASK | GFP_CONSTRAINT_MASK), node);
> 
> Ok. this relies on kmalloc returning NULL to the app.

Which should be fine because allocate_slab() can return NULL for oom
conditions.

> > @@ -4285,7 +4287,8 @@ static char *create_unique_id(struct kmem_cache *s)
> >  	char *name = kmalloc(ID_STR_LENGTH, GFP_KERNEL);
> >  	char *p = name;
> >
> > -	BUG_ON(!name);
> > +	if (WARN_ON(!name))
> > +		return NULL;
> >
> >  	*p++ = ':';
> >  	/*
> > @@ -4304,7 +4307,8 @@ static char *create_unique_id(struct kmem_cache *s)
> >  	if (p != name + 1)
> >  		*p++ = '-';
> >  	p += sprintf(p, "%07d", s->size);
> > -	BUG_ON(p > name + ID_STR_LENGTH - 1);
> > +	if (WARN_ON(p > name + ID_STR_LENGTH - 1))
> > +		return NULL;
> >  	return name;
> >  }
> >
> 
> NULL name? Guess the kfree will just be a nop but what does
> kobject_init_and_add do with a NULL name?

We never get that far because we check if create_unique_id() returns
NULL and bail out early.

> 
> 
> > @@ -4333,6 +4337,8 @@ static int sysfs_slab_add(struct kmem_cache *s)
> >  		 * for the symlinks.
> >  		 */
> >  		name = create_unique_id(s);
> > +		if (!name)
> > +			return -EINVAL;
> >  	}
> >
> >  	s->kobj.kset = slab_kset;
> >
> 
> -EINVAL may cause a panic anyways if called from create_kmalloc_cache.

Yes. I think I'll drop these bits and just change the BUG_ON() in
new_slab() to WARN_ON().

