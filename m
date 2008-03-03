Return-Path: <linux-kernel-owner+w=401wt.eu-S1760585AbYCCJmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760585AbYCCJmz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 04:42:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754697AbYCCJma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 04:42:30 -0500
Received: from n8a.bullet.mail.mud.yahoo.com ([209.191.87.104]:20875 "HELO
	n8a.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754520AbYCCJm3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 04:42:29 -0500
X-Yahoo-Newman-Id: 240610.34133.bm@omp419.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=xgoZvhyjJouwV5nzYfJvaSFvtXBvro7zrwPNYfc41fN9XF5/GCT4kAL13v4b+BXk4IuTTIILeuL9BuHFdIZoQYN6tB0OH0bsI5fPPQHgjaan/sI3X3KT97dsWUjlOy/9Q//bAii8p2F/2fpsyJQIw2CEq7hsugcQwLu75vxcNd4=  ;
X-YMail-OSG: i9mp2dcVM1kNKFs1SbHNUb5Pw5Si8R0EkogRptZEy3MoZ96ZoDovGMbKGlNxWY9wqbcZ349FzA--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [PATCH] alloc_percpu() fails to allocate percpu data
Date: Mon, 3 Mar 2008 20:41:46 +1100
User-Agent: KMail/1.9.5
Cc: Christoph Lameter <clameter@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "David S. Miller" <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
References: <47BDBC23.10605@cosmosbay.com> <200803031414.43076.nickpiggin@yahoo.com.au> <47CBAD4E.7080901@cosmosbay.com>
In-Reply-To: <47CBAD4E.7080901@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803032041.47778.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 March 2008 18:48, Eric Dumazet wrote:
> Nick Piggin a écrit :
> > On Thursday 28 February 2008 06:44, Christoph Lameter wrote:
> >> On Sat, 23 Feb 2008, Nick Piggin wrote:
> >>> What I don't understand is why the slab allocators have something like
> >>> this in it:
> >>>
> >>>         if ((flags & SLAB_HWCACHE_ALIGN) &&
> >>>                         size > cache_line_size() / 2)
> >>>                 return max_t(unsigned long, align, cache_line_size());
> >>>
> >>> If you ask for HWCACHE_ALIGN, then you should get it. I don't
> >>> understand, why do they think they knows better than the caller?
> >>
> >> Tradition.... Its irks me as well.
> >>
> >>> Things like this are just going to lead to very difficult to track
> >>> performance problems. Possibly correctness problems in rare cases.
> >>>
> >>> There could be another flag for "maybe align".
> >>
> >> SLAB_HWCACHE_ALIGN *is* effectively a maybe align flag given the above
> >> code.
> >>
> >> If we all agree then we could change this to have must have semantics?
> >> It has the potential of enlarging objects for small caches.
> >>
> >> SLAB_HWCACHE_ALIGN has an effect that varies according to the alignment
> >> requirements of the architecture that the kernel is build on. We may be
> >> in for some surprises if we change this.
> >
> > I think so. If we ask for HWCACHE_ALIGN, it must be for a good reason.
> > If some structures get too bloated for no good reason, then the problem
> > is not with the slab allocator but with the caller asking for
> > HWCACHE_ALIGN.
>
> HWCACHE_ALIGN is commonly used, even for large structures, because the
> processor cache line on x86 is not known at compile time (can go from 32
> bytes to 128 bytes).

Sure.


> The problem that above code is trying to address is about small objects.
>
> Because at the time code using HWCACHE_ALIGN was written, cache line size
> was 32 bytes. Now we have CPU with 128 bytes cache lines, we would waste
> space if SLAB_HWCACHE_ALIGN was honored for small objects.

I understand that, but I don't think it is a good reason.
SLAB_HWCACHE_ALIGN should only be specified if it is really needed.
If it is not really needed, it should not be specified. And if it
is, then the allocator should not disregard it.

But let's see. There is a valid case where we want to align to a
power of 2 >= objsize and <= hw cache size. That is if we carefully
pack objects so that we know where cacheline boundaries are and only
take the minimum number of cache misses to access them, but are not
concerned about false sharing. That appears to be what HWCACHE_ALIGN
is for, but SLUB does not really get that right either, because it
drops that alignment restriction completely if the object is <= the
cache line size. It should use the same calculation that SLAB uses.
I would have preferred it to be called something else...

For the case where we want to avoid false sharing, we need a new
SLAB_SMP_ALIGN, which always pads out to cacheline size, but only
for num_possible_cpus() > 1.

That still leaves the problem of how to align kmalloc(). SLAB gives
it HWCACHE_ALIGN by default. Why not do the same for SLUB (which
could be changed if CONFIG_SMALL is set)? That would give a more
consistent allocation pattern, at least (eg. you wouldn't get your
structures suddenly straddling cachelines if you reduce it from 100
bytes to 96 bytes...).

And for kmalloc that requires SMP_ALIGN, I guess it is impossible.
Maybe the percpu allocator could just have its own kmem_cache of
size cache_line_size() and use that for all allocations <= that size.
Then just let the scalemp guys worry about using that wasted padding
for same-CPU allocations ;)

And I guess if there is some other situation where alignment is
required, it could be specified explicitly.

> Some occurences of SLAB_HWCACHE_ALIGN are certainly not usefull, we should
> zap them. Last one I removed was the one for "struct flow_cache_entry" 
> (commit dd5a1843d566911dbb077c4022c4936697495af6 : [IPSEC] flow: reorder
> "struct flow_cache_entry" and remove SLAB_HWCACHE_ALIGN)

Sure.

But in general it isn't always easy to tell what should be aligned
and what should not. If you have a set of smallish objects where you
are likely to do basically random lookups to them and they are not
likely to be in cache, then SLAB_HWCACHE_ALIGN can be a good idea so
that you hit as few cachelines as possible when doing the lookup.

