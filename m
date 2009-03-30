Return-Path: <linux-kernel-owner+w=401wt.eu-S1761064AbZC3UaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761064AbZC3UaR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 16:30:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756958AbZC3UaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 16:30:00 -0400
Received: from smtp-out.google.com ([216.239.45.13]:35355 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755642AbZC3U37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 16:29:59 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=lFMaeveQWjlwIeoczpEdZszebIc1Z4SuUkS6PdaV6obGHymipo+flwtzWXK2UdPEb
	9DpyHNOQkrxmPBLBVoANg==
Date: Mon, 30 Mar 2009 13:29:16 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Martin Bligh <mbligh@google.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3] slub: sort parital list when thrashing
In-Reply-To: <alpine.DEB.1.10.0903301040160.13333@qirst.com>
Message-ID: <alpine.DEB.2.00.0903301324300.21074@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0903292241300.15813@chino.kir.corp.google.com> <alpine.DEB.2.00.0903292242510.15813@chino.kir.corp.google.com> <alpine.DEB.2.00.0903292243050.15813@chino.kir.corp.google.com> <alpine.DEB.2.00.0903292243200.15813@chino.kir.corp.google.com>
 <alpine.DEB.1.10.0903301040160.13333@qirst.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Mar 2009, Christoph Lameter wrote:

> > @@ -1720,6 +1727,15 @@ checks_ok:
> >  	if (unlikely(!prior)) {
> >  		add_partial(get_node(s, page_to_nid(page)), page, 1);
> >  		stat(c, FREE_ADD_PARTIAL);
> > +	} else if (c->slowpath_allocs >= SLAB_THRASHING_THRESHOLD) {
> > +		/*
> > +		 * If the cache is actively slab thrashing, it's necessary to
> > +		 * move partial slabs to the head of the list so there isn't
> > +		 * excessive partial list scanning while holding list_lock.
> > +		 */
> > +		if (!skip_partial(s, page))
> > +			move_partial_to_head(get_node(s, page_to_nid(page)),
> > +					     page);
> >  	}
> >
> >  out_unlock:
> >
> 
> This again adds code to a pretty hot path.
> 
> What is the impact of the additional hot path code?
> 

I'll be collecting more data now that there's a general desire for a 
default slab_thrash_ratio value, so we'll implicitly see the performance 
degradation for non-thrashing slab caches.  Mel had suggested a couple of 
benchmarks to try and my hypothesis is that they won't regress with a 
default ratio of 20 for all caches with >= 20 objects per slab (at least a 
4 object threshold for determining thrash).
