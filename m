Return-Path: <linux-kernel-owner+w=401wt.eu-S1757218AbZBWQXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218AbZBWQXq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 11:23:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757057AbZBWQXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 11:23:35 -0500
Received: from smtp-out.google.com ([216.239.45.13]:6747 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757042AbZBWQXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 11:23:34 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=hNB+zJrl6kbSFnsq4YRhRmHL2kl3hXqqX8Vi0q96AaQdfNgENk8zpZbFOth5YrO5i
	Xvw126HHzz4be2xhFDG5A==
Date: Mon, 23 Feb 2009 08:23:26 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux-foundation.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] slub: move min_partial to struct kmem_cache
In-Reply-To: <alpine.DEB.1.10.0902231108200.22276@qirst.com>
Message-ID: <alpine.DEB.2.00.0902230821510.23216@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0902221710430.26165@chino.kir.corp.google.com> <alpine.DEB.1.10.0902231108200.22276@qirst.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Feb 2009, Christoph Lameter wrote:

> On Sun, 22 Feb 2009, David Rientjes wrote:
> 
> > +static void calculate_min_partial(struct kmem_cache *s, unsigned long min)
> > +{
> > +	if (min < MIN_PARTIAL)
> > +		min = MIN_PARTIAL;
> > +	else if (min > MAX_PARTIAL)
> > +		min = MAX_PARTIAL;
> > +	s->min_partial = min;
> > +}
> > +
> >  /*
> >   * calculate_sizes() determines the order and the distribution of data within
> >   * a slab object.
> > @@ -2319,6 +2317,11 @@ static int kmem_cache_open(struct kmem_cache *s, gfp_t gfpflags,
> >  	if (!calculate_sizes(s, -1))
> >  		goto error;
> >
> > +	/*
> > +	 * The larger the object size is, the more pages we want on the partial
> > +	 * list to avoid pounding the page allocator excessively.
> > +	 */
> > +	calculate_min_partial(s, ilog2(s->size));
> >  	s->refcount = 1;
> >  #ifdef CONFIG_NUMA
> >  	s->remote_node_defrag_ratio = 1000;
> >
> 
> Move the ilog2 use into calculate_min_partial()? Otherweise
> calculate_min_partial is merely enforcing limits and not doing any
> calculations.
> 

The second patch in this series as a /sys/kernel/slab/cache/min_partial 
tunable that uses calculate_min_partial() to enforce a sane range, so 
while it may not actually be doing any calculations, the ilog2() is 
appropriately placed in kmem_cache_open().  We don't want to be taking the 
log of the user's min_partial value.
