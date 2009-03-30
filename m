Return-Path: <linux-kernel-owner+w=401wt.eu-S1760803AbZC3UNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760803AbZC3UNx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 16:13:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758788AbZC3UNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 16:13:43 -0400
Received: from smtp-out.google.com ([216.239.33.17]:20668 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758468AbZC3UNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 16:13:43 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=rFc+UlW24JWZgos+rGVGQidtXAi/In38AdhBXUmEa+9Z7GWtPOqYL2GLBoS4p6GfI
	NBjpuhTRsUmhM9XL81y4Q==
Date: Mon, 30 Mar 2009 13:12:55 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Martin Bligh <mbligh@google.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] slub: add per-cache slab thrash ratio
In-Reply-To: <alpine.DEB.1.10.0903301026580.13333@qirst.com>
Message-ID: <alpine.DEB.2.00.0903301309010.21074@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0903292241300.15813@chino.kir.corp.google.com> <alpine.DEB.2.00.0903292242510.15813@chino.kir.corp.google.com> <alpine.DEB.1.10.0903301026580.13333@qirst.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Mar 2009, Christoph Lameter wrote:

> > @@ -2291,10 +2292,13 @@ static int calculate_sizes(struct kmem_cache *s, int forced_order)
> >  	/*
> >  	 * Determine the number of objects per slab
> >  	 */
> > +	if (oo_objects(s->oo))
> > +		thrash_ratio = s->min_free_watermark * 100 / oo_objects(s->oo);
> >  	s->oo = oo_make(order, size);
> 
> s->oo is set *after* you check it. Check oo_objects after the value has
> been set please.
> 

It's actually right the way I implemented it, oo_objects(s->oo) will be 0 
when this is called for kmem_cache_open() meaning there is no preexisting 
slab_thrash_ratio.  But this check is required when calculate_sizes() is 
called from order_store() to adjust the slab_thrash_ratio for the new 
objects per slab.  The above check is saving the old thrash ratio so 
the new s->min_free_watermark value can be set following the 
oo_make().  This was mentioned in the changelog for this patch:

	The value is stored in terms of the number of objects that the 
	ratio represents, not the ratio itself.  This avoids costly 
	arithmetic in the slowpath for a calculation that could otherwise 
	be done only when `slab_thrash_ratio' or `order' is changed.
