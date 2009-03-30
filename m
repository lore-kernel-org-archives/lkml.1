Return-Path: <linux-kernel-owner+w=401wt.eu-S1754559AbZC3VYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559AbZC3VYU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 17:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753288AbZC3VYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 17:24:10 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:36999 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814AbZC3VYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 17:24:09 -0400
Date: Mon, 30 Mar 2009 17:19:45 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: David Rientjes <rientjes@google.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Martin Bligh <mbligh@google.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] slub: add per-cache slab thrash ratio
In-Reply-To: <alpine.DEB.2.00.0903301309010.21074@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.10.0903301718080.25929@qirst.com>
References: <alpine.DEB.2.00.0903292241300.15813@chino.kir.corp.google.com> <alpine.DEB.2.00.0903292242510.15813@chino.kir.corp.google.com> <alpine.DEB.1.10.0903301026580.13333@qirst.com> <alpine.DEB.2.00.0903301309010.21074@chino.kir.corp.google.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Mar 2009, David Rientjes wrote:

> > > +	if (oo_objects(s->oo))
> > > +		thrash_ratio = s->min_free_watermark * 100 / oo_objects(s->oo);
> > >  	s->oo = oo_make(order, size);
> >
> > s->oo is set *after* you check it. Check oo_objects after the value has
> > been set please.
> >
>
> It's actually right the way I implemented it, oo_objects(s->oo) will be 0
> when this is called for kmem_cache_open() meaning there is no preexisting
> slab_thrash_ratio.  But this check is required when calculate_sizes() is
> called from order_store() to adjust the slab_thrash_ratio for the new
> objects per slab.  The above check is saving the old thrash ratio so
> the new s->min_free_watermark value can be set following the
> oo_make().  This was mentioned in the changelog for this patch:
>
> 	The value is stored in terms of the number of objects that the
> 	ratio represents, not the ratio itself.  This avoids costly
> 	arithmetic in the slowpath for a calculation that could otherwise
> 	be done only when `slab_thrash_ratio' or `order' is changed.

Then its the wrong place to set it. Initializations are done in
kmem_cache_open() after calculate_sizes are called.
