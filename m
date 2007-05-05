Return-Path: <linux-kernel-owner+w=401wt.eu-S1423017AbXEEFOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423017AbXEEFOr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 01:14:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423102AbXEEFOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 01:14:47 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58358 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1423017AbXEEFOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 01:14:47 -0400
Date: Fri, 4 May 2007 22:14:46 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Eric Dumazet <dada1@cosmosbay.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, dgc@sgi.com,
       Mel Gorman <mel@csn.ul.ie>
Subject: Re: [RFC 0/3] Slab Defrag / Slab Targeted Reclaim and general Slab
 API changes
In-Reply-To: <463C10F8.4040803@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0705042209050.14211@schroedinger.engr.sgi.com>
References: <20070504221555.642061626@sgi.com> <463C10F8.4040803@cosmosbay.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 May 2007, Eric Dumazet wrote:

> > C. Introduces a slab_ops structure that allows a slab user to provide
> >    operations on slabs.
> 
> Could you please make it const ?

Sure. Done.

> > All of this is really not necessary since the compiler knows how to align
> > structures and we should use this information instead of having the user
> > specify an alignment. I would like to get rid of SLAB_HWCACHE_ALIGN
> > and kmem_cache_create. Instead one would use the following macros (that
> > then result in a call to __kmem_cache_create).
> 
> Hum, the problem is the compiler sometimes doesnt know the target processor
> alignment.
> 
> Adding ____cacheline_aligned to 'struct ...' definitions might be overkill if
> you compile a generic kernel and happens to boot a Pentium III with it.

Then add ___cacheline_aligned_in_smp or specify the alignment in the 
various other ways that exist. Practice is that most slabs specify 
SLAB_HWCACHE_ALIGN. So most slabs are cache aligned today.

> G. Being able to track the number of pages in a kmem_cache
> 
> 
> If you look at fs/buffer.c, you'll notice the bh_accounting, recalc_bh_state()
> that might be overkill for large SMP configurations, when the real concern is
> to be able to limit the bh's not to exceed 10% of LOWMEM.
> 
> Adding a callback in slab_ops to track total number of pages in use by a given
> kmem_cache would be good.

Such functionality exists internal to SLUB and in the reporting tool. 
I can export that function if you need it.

> Same thing for fs/file_table.c : nr_file logic
> (percpu_counter_dec()/percpu_counter_inc() for each file open/close) could be
> simplified if we could just count the pages in use by filp_cachep kmem_cache.
> The get_nr_files() thing is not worth the pain.

Sure. What exactly do you want? The absolute number of pages of memory 
that the slab is using?

	kmem_cache_pages_in_use(struct kmem_cache *) ?

The call will not be too lightweight since we will have to loop over all 
nodes and add the counters in each per node struct for allocates slabs.

