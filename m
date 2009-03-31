Return-Path: <linux-kernel-owner+w=401wt.eu-S1756833AbZCaRWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833AbZCaRWl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 13:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756865AbZCaRWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 13:22:31 -0400
Received: from smtp-out.google.com ([216.239.45.13]:21367 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755244AbZCaRWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 13:22:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=bs6Ar/zgx7VUa2CE8oHoXOyDxTW7KMEkK1GNxHcn9Z0RRdkjwJ3nqCowcQlh0b5nJ
	NuGMUhjdF3Y47VSfueo4w==
Date: Tue, 31 Mar 2009 10:21:42 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Martin Bligh <mbligh@google.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] slub: add per-cache slab thrash ratio
In-Reply-To: <alpine.DEB.1.10.0903310925130.24040@qirst.com>
Message-ID: <alpine.DEB.2.00.0903311014140.10407@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0903292241300.15813@chino.kir.corp.google.com> <alpine.DEB.2.00.0903292242510.15813@chino.kir.corp.google.com> <alpine.DEB.1.10.0903301026580.13333@qirst.com> <alpine.DEB.2.00.0903301309010.21074@chino.kir.corp.google.com>
 <alpine.DEB.1.10.0903301718080.25929@qirst.com> <alpine.DEB.2.00.0903301545200.30928@chino.kir.corp.google.com> <alpine.DEB.2.00.0903302140250.27065@chino.kir.corp.google.com> <alpine.DEB.1.10.0903310925130.24040@qirst.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Mar 2009, Christoph Lameter wrote:

> > @@ -3833,7 +3830,9 @@ static ssize_t order_store(struct kmem_cache *s,
> >  	if (order > slub_max_order || order < slub_min_order)
> >  		return -EINVAL;
> >
> > +	thrash_ratio = s->min_free_watermark * 100 / oo_objects(s->oo);
> >  	calculate_sizes(s, order);
> > +	s->min_free_watermark = oo_objects(s->oo) * thrash_ratio / 100;
> >  	return length;
> >  }
> >
> 
> Hmmm.. Still calculating the trash ratio based on existing objects per
> slab and then resetting the objects per slab to a different number.
> Shouldnt the trash_ratio simply be zapped to an initial value if the
> number of objects per slab changes?
> 

Each cache with >= 20 objects per slab will get a default 
slab_thrash_ratio of 20 in v2 of the series.  If the order of a cache is 
subsequently tuned, the default slab_thrash_ratio would be cleared without 
knowledge to the user.

I'd agree that it should be cleared if the tunable had object units 
instead of a ratio, but the ratio simply applies to any given order.
