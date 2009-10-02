Return-Path: <linux-kernel-owner+w=401wt.eu-S1757538AbZJBKFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538AbZJBKFR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 06:05:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757503AbZJBKFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 06:05:16 -0400
Received: from smtp-out.google.com ([216.239.33.17]:53846 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756831AbZJBKFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 06:05:14 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=bBrA8mqM1mTF3pvEmaAVYMLl9hysOJmCHRMUyhC2qANVflSCINoU4UnS2Q0hWTSFW
	UaLl+t7TZrbue3He0eYOQ==
Date: Fri, 2 Oct 2009 03:05:07 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Neil Brown <neilb@suse.de>
cc: Suresh Jayaraman <sjayaraman@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org,
       Miklos Szeredi <mszeredi@suse.cz>, Wouter Verhelst <w@uter.be>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, trond.myklebust@fys.uio.no
Subject: Re: [PATCH 30/31] Fix use of uninitialized variable in
 cache_grow()
In-Reply-To: <19141.34685.863491.329836@notabene.brown>
Message-ID: <alpine.DEB.1.00.0910020258190.25369@chino.kir.corp.google.com>
References: <1254406257-16735-1-git-send-email-sjayaraman@suse.de> <alpine.DEB.1.00.0910011341280.27559@chino.kir.corp.google.com> <19141.34685.863491.329836@notabene.brown>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Oct 2009, Neil Brown wrote:

> > > Index: mmotm/mm/slab.c
> > > ===================================================================
> > > --- mmotm.orig/mm/slab.c
> > > +++ mmotm/mm/slab.c
> > > @@ -2760,7 +2760,7 @@ static int cache_grow(struct kmem_cache
> > >  	size_t offset;
> > >  	gfp_t local_flags;
> > >  	struct kmem_list3 *l3;
> > > -	int reserve;
> > > +	int reserve = -1;
> > >  
> > >  	/*
> > >  	 * Be lazy and only check for valid flags here,  keeping it out of the
> > > @@ -2816,7 +2816,8 @@ static int cache_grow(struct kmem_cache
> > >  	if (local_flags & __GFP_WAIT)
> > >  		local_irq_disable();
> > >  	check_irq_off();
> > > -	slab_set_reserve(cachep, reserve);
> > > +	if (reserve != -1)
> > > +		slab_set_reserve(cachep, reserve);
> > >  	spin_lock(&l3->list_lock);
> > >  
> > >  	/* Make slab active. */
> > 
> > Given the patch description, shouldn't this be a test for objp != NULL 
> > instead, then?
> 
> In between those to patch hunks, cache_grow contains the code:
> 	if (!objp)
> 		objp = kmem_getpages(cachep, local_flags, nodeid, &reserve);
> 	if (!objp)
> 		goto failed;
> 
> We can no longer test if objp was NULL on entry to the function.
> We could take a copy of objp on entry to the function, and test it
> here.  But initialising 'reserve' to an invalid value is easier.
> 

Seems like you could do all this in kmem_getpages(), then, by calling 
slab_set_reserve(cachep, page->reserve) before returning the new page?

 [ I'd also drop the branch in slab_set_reserve(), it's faster to just 
   assign it unconditionally. ]
